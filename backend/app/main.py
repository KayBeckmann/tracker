from __future__ import annotations

import os
from datetime import datetime, timedelta
from typing import Annotated, Generator, Literal

from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel, ConfigDict, EmailStr, Field
from sqlalchemy import Boolean, DateTime, Integer, String, create_engine, func, select
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import DeclarativeBase, Mapped, Session, mapped_column, sessionmaker


class Base(DeclarativeBase):
    """Declarative base for SQLAlchemy models."""


class User(Base):
    """Persisted application user."""

    __tablename__ = "users"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    email: Mapped[str] = mapped_column(String(320), unique=True, index=True, nullable=False)
    password_hash: Mapped[str] = mapped_column(String(255), nullable=False)
    display_name: Mapped[str | None] = mapped_column(String(120), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        server_default=func.now(),
        nullable=False,
    )
    membership_level: Mapped[str] = mapped_column(
        String(20),
        nullable=False,
        default="none",
        server_default="none",
    )
    membership_expires_at: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )
    sync_enabled: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        default=False,
        server_default="0",
    )
    last_payment_method: Mapped[str | None] = mapped_column(String(20), nullable=True)
    sync_retention_until: Mapped[datetime | None] = mapped_column(
        DateTime(timezone=True),
        nullable=True,
    )


DATABASE_URL = os.getenv("DATABASE_URL", "sqlite:///./tracker.db")
SECRET_KEY = os.getenv("AUTH_SECRET_KEY", "change-this-secret")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES", "4320"))
ALGORITHM = "HS256"

engine = create_engine(
    DATABASE_URL,
    echo=False,
    future=True,
    connect_args={"check_same_thread": False} if DATABASE_URL.startswith("sqlite") else {},
)
SessionLocal = sessionmaker(bind=engine, autoflush=False, autocommit=False, future=True)

pwd_context = CryptContext(schemes=["pbkdf2_sha256"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")


def create_database() -> None:
    """Create database schema if it does not exist."""

    Base.metadata.create_all(bind=engine, checkfirst=True)


def get_db() -> Generator[Session, None, None]:
    """Provide a database session for request handling."""

    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict, expires_delta: timedelta | None = None) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + (
        expires_delta if expires_delta is not None else timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    to_encode.update({"exp": expire, "iat": datetime.utcnow()})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def _now_utc() -> datetime:
    return datetime.utcnow()


def _ensure_membership_state(user: User) -> None:
    """Update membership flags when a membership may have expired."""

    before_retention = user.sync_retention_until

    if user.membership_level == "none" and user.sync_enabled:
        # Safety: sync should never be enabled without a membership
        user.sync_enabled = False

    if user.membership_level != "none" and user.membership_expires_at is not None:
        if user.membership_expires_at <= _now_utc():
            user.membership_level = "none"
            user.sync_enabled = False
            if user.sync_retention_until is None:
                user.sync_retention_until = _now_utc() + timedelta(days=90)
    elif user.membership_level != "none":
        user.sync_retention_until = None

    if user.sync_retention_until != before_retention:
        # pass to caller to decide on persisting; nothing to do here
        pass


def _membership_delta(plan: str) -> timedelta:
    if plan == "monthly":
        return timedelta(days=30)
    if plan == "yearly":
        return timedelta(days=365)
    raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Unbekannter Tarif.")


def _membership_status_from_user(user: User) -> MembershipStatusResponse:
    return MembershipStatusResponse(
        membership_level=user.membership_level,
        membership_expires_at=user.membership_expires_at,
        sync_enabled=user.sync_enabled,
        last_payment_method=user.last_payment_method,
        sync_retention_until=user.sync_retention_until,
    )


class RegisterRequest(BaseModel):
    email: EmailStr
    password: str = Field(min_length=8, max_length=128)
    display_name: str | None = Field(default=None, max_length=120)


class LoginRequest(BaseModel):
    email: EmailStr
    password: str


class UserOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    email: EmailStr
    display_name: str | None = None
    created_at: datetime
    membership_level: str
    membership_expires_at: datetime | None = None
    sync_enabled: bool
    last_payment_method: str | None = None
    sync_retention_until: datetime | None = None


class AuthResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user: UserOut


class TokenData(BaseModel):
    sub: str | None = None


class MembershipStatusResponse(BaseModel):
    membership_level: str
    membership_expires_at: datetime | None = None
    sync_enabled: bool
    last_payment_method: str | None = None
    sync_retention_until: datetime | None = None
    price_monthly: float = 1.0
    price_yearly: float = 10.0


class SubscribeRequest(BaseModel):
    plan: Literal["monthly", "yearly"]
    payment_method: Literal["paypal", "bitcoin"]


def normalize_email(email: str) -> str:
    return email.strip().lower()


async def get_current_user(
    token: Annotated[str, Depends(oauth2_scheme)],
    db: Annotated[Session, Depends(get_db)],
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Anmeldung erforderlich.",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str | None = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError as exc:
        raise credentials_exception from exc

    user = db.get(User, int(user_id))
    if user is None:
        raise credentials_exception
    before_level = user.membership_level
    before_enabled = user.sync_enabled
    before_retention = user.sync_retention_until
    _ensure_membership_state(user)
    if (
        user.membership_level != before_level
        or user.sync_enabled != before_enabled
        or user.sync_retention_until != before_retention
    ):
        db.commit()
        db.refresh(user)
    return user


app = FastAPI(title="Tracker Backend", version="0.2.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def on_startup() -> None:
    create_database()


@app.get("/api/health")
async def health_check():
    """Simple health endpoint used by the Flutter client."""
    return {"status": "ok", "service": "tracker-backend"}


@app.get("/api/greeting")
async def greeting(name: str = "Flutter"):
    """Return a friendly greeting for the provided name."""
    return {"message": f"Hello, {name}!", "source": "tracker-backend"}


@app.post("/api/auth/register", response_model=AuthResponse, status_code=status.HTTP_201_CREATED)
def register_user(payload: RegisterRequest, db: Annotated[Session, Depends(get_db)]) -> AuthResponse:
    email = normalize_email(payload.email)

    statement = select(User).where(User.email == email)
    existing_user = db.execute(statement).scalar_one_or_none()
    if existing_user is not None:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Diese E-Mail-Adresse ist bereits registriert.",
        )

    user = User(
        email=email,
        password_hash=get_password_hash(payload.password),
        display_name=payload.display_name,
    )

    db.add(user)

    try:
        db.commit()
    except IntegrityError as exc:
        db.rollback()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Diese E-Mail-Adresse ist bereits registriert.",
        ) from exc

    db.refresh(user)

    token = create_access_token({"sub": str(user.id)})
    return AuthResponse(access_token=token, user=UserOut.model_validate(user))


@app.post("/api/auth/login", response_model=AuthResponse)
def login_user(payload: LoginRequest, db: Annotated[Session, Depends(get_db)]) -> AuthResponse:
    email = normalize_email(payload.email)
    statement = select(User).where(User.email == email)
    user = db.execute(statement).scalar_one_or_none()

    if user is None or not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Ungültige Zugangsdaten.",
        )

    before_level = user.membership_level
    before_enabled = user.sync_enabled
    before_retention = user.sync_retention_until
    _ensure_membership_state(user)
    if (
        user.membership_level != before_level
        or user.sync_enabled != before_enabled
        or user.sync_retention_until != before_retention
    ):
        db.commit()
        db.refresh(user)

    token = create_access_token({"sub": str(user.id)})
    return AuthResponse(access_token=token, user=UserOut.model_validate(user))


@app.get("/api/auth/me", response_model=UserOut)
async def read_current_user(
    current_user: Annotated[User, Depends(get_current_user)],
) -> UserOut:
    _ensure_membership_state(current_user)
    return UserOut.model_validate(current_user)


@app.get("/api/membership", response_model=MembershipStatusResponse)
def get_membership_status(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> MembershipStatusResponse:
    before_level = current_user.membership_level
    before_enabled = current_user.sync_enabled
    before_retention = current_user.sync_retention_until
    _ensure_membership_state(current_user)
    if (
        current_user.membership_level != before_level
        or current_user.sync_enabled != before_enabled
        or current_user.sync_retention_until != before_retention
    ):
        db.commit()
    return _membership_status_from_user(current_user)


@app.post("/api/membership/subscribe", response_model=MembershipStatusResponse)
def subscribe_membership(
    request: SubscribeRequest,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> MembershipStatusResponse:
    delta = _membership_delta(request.plan)
    now = _now_utc()
    current_user.membership_level = request.plan
    current_user.membership_expires_at = now + delta
    current_user.sync_enabled = True
    current_user.last_payment_method = request.payment_method
    current_user.sync_retention_until = None
    db.add(current_user)
    db.commit()
    db.refresh(current_user)
    return _membership_status_from_user(current_user)


@app.post("/api/membership/cancel", response_model=MembershipStatusResponse)
def cancel_membership(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> MembershipStatusResponse:
    now = _now_utc()
    current_user.membership_level = "none"
    current_user.sync_enabled = False
    current_user.sync_retention_until = now + timedelta(days=90)
    current_user.membership_expires_at = now
    db.add(current_user)
    db.commit()
    db.refresh(current_user)
    return _membership_status_from_user(current_user)


@app.post("/api/membership/delete_synced_data", response_model=MembershipStatusResponse)
def delete_synced_data(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> MembershipStatusResponse:
    current_user.membership_level = "none"
    current_user.sync_enabled = False
    current_user.membership_expires_at = None
    current_user.sync_retention_until = None
    db.add(current_user)
    db.commit()
    db.refresh(current_user)
    return _membership_status_from_user(current_user)
