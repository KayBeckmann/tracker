from __future__ import annotations

import os
from datetime import datetime, timedelta, timezone
from typing import Annotated, Any, Generator, Literal

from fastapi import Depends, FastAPI, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from passlib.context import CryptContext
from pydantic import BaseModel, ConfigDict, EmailStr, Field
from sqlalchemy import Boolean, DateTime, Float, ForeignKey, Integer, String, Text, create_engine, func, select
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


class Note(Base):
    """User-authored note entry."""

    __tablename__ = "notes"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    title: Mapped[str] = mapped_column(String(255), nullable=False, default="", server_default="")
    content: Mapped[str | None] = mapped_column(Text, nullable=True)
    tags: Mapped[str] = mapped_column(String(255), nullable=False, default="", server_default="")
    kind: Mapped[str] = mapped_column(String(32), nullable=False, default="markdown", server_default="markdown")
    remote_id: Mapped[str | None] = mapped_column(String(64), nullable=True, unique=True)
    remote_version: Mapped[int] = mapped_column(Integer, nullable=False, default=0, server_default="0")
    needs_sync: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True, server_default="1")
    synced_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class Task(Base):
    """Task or appointment entry."""

    __tablename__ = "tasks"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    status: Mapped[str] = mapped_column(String(32), nullable=False, default="todo", server_default="todo")
    priority: Mapped[str] = mapped_column(String(32), nullable=False, default="medium", server_default="medium")
    due_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    note_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("notes.id", ondelete="SET NULL"),
        nullable=True,
    )
    tags: Mapped[str] = mapped_column(String(255), nullable=False, default="", server_default="")
    reminder_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class TimeEntry(Base):
    """Tracked time entry."""

    __tablename__ = "time_entries"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    started_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    ended_at: Mapped[datetime | None] = mapped_column(DateTime(timezone=True), nullable=True)
    duration_minutes: Mapped[int] = mapped_column(Integer, nullable=False, default=0, server_default="0")
    note: Mapped[str] = mapped_column(String(512), nullable=False, default="", server_default="")
    kind: Mapped[str] = mapped_column(String(32), nullable=False, default="work", server_default="work")
    task_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("tasks.id", ondelete="SET NULL"),
        nullable=True,
    )
    is_manual: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class JournalEntry(Base):
    """Daily journal entry."""

    __tablename__ = "journal_entries"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    entry_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    content: Mapped[str] = mapped_column(Text, nullable=False, default="", server_default="")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class JournalTracker(Base):
    """Trackers associated with journal entries."""

    __tablename__ = "journal_trackers"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    description: Mapped[str] = mapped_column(String(255), nullable=False, default="", server_default="")
    kind: Mapped[str] = mapped_column(String(32), nullable=False, default="checkbox", server_default="checkbox")
    sort_order: Mapped[int] = mapped_column(Integer, nullable=False, default=0, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class JournalTrackerValue(Base):
    """Recorded values for journal trackers."""

    __tablename__ = "journal_tracker_values"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    tracker_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("journal_trackers.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    entry_date: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    value: Mapped[int] = mapped_column(Integer, nullable=False, default=0, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class HabitDefinition(Base):
    """Habit definition."""

    __tablename__ = "habits"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    description: Mapped[str] = mapped_column(String(255), nullable=False, default="", server_default="")
    interval: Mapped[str] = mapped_column(String(32), nullable=False, default="daily", server_default="daily")
    target_occurrences: Mapped[int] = mapped_column(Integer, nullable=False, default=1, server_default="1")
    measurement_kind: Mapped[str] = mapped_column(String(32), nullable=False, default="boolean", server_default="boolean")
    target_value: Mapped[float | None] = mapped_column(Float, nullable=True)
    archived: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class HabitLog(Base):
    """Recorded habit occurrence."""

    __tablename__ = "habit_logs"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    habit_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("habits.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    occurred_at: Mapped[datetime] = mapped_column(DateTime(timezone=True), nullable=False)
    value: Mapped[float] = mapped_column(Float, nullable=False, default=0.0, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class LedgerAccount(Base):
    """Ledger account definition."""

    __tablename__ = "ledger_accounts"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    account_kind: Mapped[str] = mapped_column(String(32), nullable=False, default="cash", server_default="cash")
    currency_code: Mapped[str] = mapped_column(String(3), nullable=False, default="EUR", server_default="EUR")
    include_in_net_worth: Mapped[bool] = mapped_column(Boolean, nullable=False, default=True, server_default="1")
    initial_balance: Mapped[float] = mapped_column(Float, nullable=False, default=0.0, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class LedgerCategory(Base):
    """Ledger categories and subcategories."""

    __tablename__ = "ledger_categories"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    category_kind: Mapped[str] = mapped_column(String(16), nullable=False, default="expense", server_default="expense")
    parent_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_categories.id", ondelete="SET NULL"),
        nullable=True,
    )
    is_archived: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False, server_default="0")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class LedgerBudget(Base):
    """Budget definition for categories."""

    __tablename__ = "ledger_budgets"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    category_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("ledger_categories.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    period_kind: Mapped[str] = mapped_column(String(16), nullable=False, default="monthly", server_default="monthly")
    year: Mapped[int] = mapped_column(Integer, nullable=False)
    month: Mapped[int | None] = mapped_column(Integer, nullable=True)
    amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0, server_default="0")
    currency_code: Mapped[str] = mapped_column(String(3), nullable=False, default="EUR", server_default="EUR")
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class LedgerTransaction(Base):
    """Ledger transaction entry."""

    __tablename__ = "ledger_transactions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    transaction_kind: Mapped[str] = mapped_column(String(32), nullable=False, default="expense", server_default="expense")
    account_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_accounts.id", ondelete="SET NULL"),
        nullable=True,
    )
    target_account_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_accounts.id", ondelete="SET NULL"),
        nullable=True,
    )
    category_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_categories.id", ondelete="SET NULL"),
        nullable=True,
    )
    subcategory_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_categories.id", ondelete="SET NULL"),
        nullable=True,
    )
    amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0, server_default="0")
    currency_code: Mapped[str] = mapped_column(String(3), nullable=False, default="EUR", server_default="EUR")
    booking_date: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    is_planned: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False, server_default="0")
    description: Mapped[str] = mapped_column(String(255), nullable=False, default="", server_default="")
    crypto_symbol: Mapped[str | None] = mapped_column(String(32), nullable=True)
    crypto_quantity: Mapped[float | None] = mapped_column(Float, nullable=True)
    price_per_unit: Mapped[float | None] = mapped_column(Float, nullable=True)
    fee_amount: Mapped[float | None] = mapped_column(Float, nullable=True)
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class LedgerRecurringTransaction(Base):
    """Template for recurring transactions."""

    __tablename__ = "ledger_recurring_transactions"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    transaction_kind: Mapped[str] = mapped_column(String(32), nullable=False, default="expense", server_default="expense")
    amount: Mapped[float] = mapped_column(Float, nullable=False, default=0.0, server_default="0")
    currency_code: Mapped[str] = mapped_column(String(3), nullable=False, default="EUR", server_default="EUR")
    interval_kind: Mapped[str] = mapped_column(String(32), nullable=False, default="monthly", server_default="monthly")
    interval_count: Mapped[int] = mapped_column(Integer, nullable=False, default=1, server_default="1")
    next_occurrence: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    auto_apply: Mapped[bool] = mapped_column(Boolean, nullable=False, default=False, server_default="0")
    metadata_json: Mapped[str] = mapped_column(Text, nullable=False, default="{}", server_default="{}")
    account_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_accounts.id", ondelete="SET NULL"),
        nullable=True,
    )
    target_account_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_accounts.id", ondelete="SET NULL"),
        nullable=True,
    )
    category_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_categories.id", ondelete="SET NULL"),
        nullable=True,
    )
    subcategory_id: Mapped[int | None] = mapped_column(
        Integer,
        ForeignKey("ledger_categories.id", ondelete="SET NULL"),
        nullable=True,
    )
    created_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
    )
    updated_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
        onupdate=func.now(),
    )


class CryptoPriceEntry(Base):
    """Cached crypto price per symbol."""

    __tablename__ = "crypto_price_entries"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, index=True)
    user_id: Mapped[int] = mapped_column(
        Integer,
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    symbol: Mapped[str] = mapped_column(String(16), nullable=False)
    currency_code: Mapped[str] = mapped_column(String(3), nullable=False, default="EUR", server_default="EUR")
    price: Mapped[float] = mapped_column(Float, nullable=False, default=0.0, server_default="0")
    fetched_at: Mapped[datetime] = mapped_column(
        DateTime(timezone=True),
        nullable=False,
        server_default=func.now(),
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
    expire = _now_utc() + (
        expires_delta if expires_delta is not None else timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    )
    to_encode.update({"exp": expire, "iat": _now_utc()})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)


def _now_utc() -> datetime:
    return datetime.now(timezone.utc)


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
    payment_method: Literal["paypal", "bitcoin", "manual"] = "manual"


class NoteBase(BaseModel):
    title: str
    content: str | None = None
    tags: str = ""
    kind: str = "markdown"
    remote_id: str | None = None
    remote_version: int = 0
    needs_sync: bool = True
    synced_at: datetime | None = None


class NoteCreate(NoteBase):
    pass


class NoteUpdate(BaseModel):
    title: str | None = None
    content: str | None = None
    tags: str | None = None
    kind: str | None = None
    remote_id: str | None = None
    remote_version: int | None = None
    needs_sync: bool | None = None
    synced_at: datetime | None = None


class NoteResponse(NoteBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class TaskBase(BaseModel):
    title: str
    status: str = "todo"
    priority: str = "medium"
    due_date: datetime
    note_id: int | None = None
    tags: str = ""
    reminder_at: datetime | None = None


class TaskCreate(TaskBase):
    pass


class TaskUpdate(BaseModel):
    title: str | None = None
    status: str | None = None
    priority: str | None = None
    due_date: datetime | None = None
    note_id: int | None = None
    tags: str | None = None
    reminder_at: datetime | None = None


class TaskResponse(TaskBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class TimeEntryBase(BaseModel):
    started_at: datetime
    ended_at: datetime | None = None
    duration_minutes: int = 0
    note: str = ""
    kind: str = "work"
    task_id: int | None = None
    is_manual: bool = False


class TimeEntryCreate(TimeEntryBase):
    pass


class TimeEntryUpdate(BaseModel):
    started_at: datetime | None = None
    ended_at: datetime | None = None
    duration_minutes: int | None = None
    note: str | None = None
    kind: str | None = None
    task_id: int | None = None
    is_manual: bool | None = None


class TimeEntryResponse(TimeEntryBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class JournalEntryCreate(BaseModel):
    entry_date: datetime
    content: str = ""


class JournalEntryUpdate(BaseModel):
    content: str | None = None


class JournalEntryResponse(JournalEntryCreate):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class JournalTrackerBase(BaseModel):
    name: str
    description: str = ""
    kind: str = "checkbox"
    sort_order: int = 0


class JournalTrackerCreate(JournalTrackerBase):
    pass


class JournalTrackerUpdate(BaseModel):
    name: str | None = None
    description: str | None = None
    kind: str | None = None
    sort_order: int | None = None


class JournalTrackerResponse(JournalTrackerBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class JournalTrackerValueBase(BaseModel):
    tracker_id: int
    entry_date: datetime
    value: int = 0


class JournalTrackerValueCreate(JournalTrackerValueBase):
    pass


class JournalTrackerValueUpdate(BaseModel):
    entry_date: datetime | None = None
    value: int | None = None


class JournalTrackerValueResponse(JournalTrackerValueBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class HabitBase(BaseModel):
    name: str
    description: str = ""
    interval: str = "daily"
    target_occurrences: int = 1
    measurement_kind: str = "boolean"
    target_value: float | None = None
    archived: bool = False


class HabitCreate(HabitBase):
    pass


class HabitUpdate(BaseModel):
    name: str | None = None
    description: str | None = None
    interval: str | None = None
    target_occurrences: int | None = None
    measurement_kind: str | None = None
    target_value: float | None = None
    archived: bool | None = None


class HabitResponse(HabitBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class HabitLogBase(BaseModel):
    habit_id: int
    occurred_at: datetime
    value: float = 0.0


class HabitLogCreate(HabitLogBase):
    pass


class HabitLogUpdate(BaseModel):
    occurred_at: datetime | None = None
    value: float | None = None


class HabitLogResponse(HabitLogBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class LedgerAccountBase(BaseModel):
    name: str
    account_kind: str = "cash"
    currency_code: str = "EUR"
    include_in_net_worth: bool = True
    initial_balance: float = 0.0


class LedgerAccountCreate(LedgerAccountBase):
    pass


class LedgerAccountUpdate(BaseModel):
    name: str | None = None
    account_kind: str | None = None
    currency_code: str | None = None
    include_in_net_worth: bool | None = None
    initial_balance: float | None = None


class LedgerAccountResponse(LedgerAccountBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class LedgerCategoryBase(BaseModel):
    name: str
    category_kind: str = "expense"
    parent_id: int | None = None
    is_archived: bool = False


class LedgerCategoryCreate(LedgerCategoryBase):
    pass


class LedgerCategoryUpdate(BaseModel):
    name: str | None = None
    category_kind: str | None = None
    parent_id: int | None = None
    is_archived: bool | None = None


class LedgerCategoryResponse(LedgerCategoryBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class LedgerBudgetBase(BaseModel):
    category_id: int
    period_kind: str = "monthly"
    year: int
    month: int | None = None
    amount: float
    currency_code: str = "EUR"


class LedgerBudgetCreate(LedgerBudgetBase):
    pass


class LedgerBudgetUpdate(BaseModel):
    category_id: int | None = None
    period_kind: str | None = None
    year: int | None = None
    month: int | None = None
    amount: float | None = None
    currency_code: str | None = None


class LedgerBudgetResponse(LedgerBudgetBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class LedgerTransactionBase(BaseModel):
    transaction_kind: str = "expense"
    account_id: int | None = None
    target_account_id: int | None = None
    category_id: int | None = None
    subcategory_id: int | None = None
    amount: float
    currency_code: str = "EUR"
    booking_date: datetime
    is_planned: bool = False
    description: str = ""
    crypto_symbol: str | None = None
    crypto_quantity: float | None = None
    price_per_unit: float | None = None
    fee_amount: float | None = None


class LedgerTransactionCreate(LedgerTransactionBase):
    pass


class LedgerTransactionUpdate(BaseModel):
    transaction_kind: str | None = None
    account_id: int | None = None
    target_account_id: int | None = None
    category_id: int | None = None
    subcategory_id: int | None = None
    amount: float | None = None
    currency_code: str | None = None
    booking_date: datetime | None = None
    is_planned: bool | None = None
    description: str | None = None
    crypto_symbol: str | None = None
    crypto_quantity: float | None = None
    price_per_unit: float | None = None
    fee_amount: float | None = None


class LedgerTransactionResponse(LedgerTransactionBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class LedgerRecurringBase(BaseModel):
    name: str
    transaction_kind: str = "expense"
    amount: float
    currency_code: str = "EUR"
    interval_kind: str = "monthly"
    interval_count: int = 1
    next_occurrence: datetime
    auto_apply: bool = False
    metadata_json: str = "{}"
    account_id: int | None = None
    target_account_id: int | None = None
    category_id: int | None = None
    subcategory_id: int | None = None


class LedgerRecurringCreate(LedgerRecurringBase):
    pass


class LedgerRecurringUpdate(BaseModel):
    name: str | None = None
    transaction_kind: str | None = None
    amount: float | None = None
    currency_code: str | None = None
    interval_kind: str | None = None
    interval_count: int | None = None
    next_occurrence: datetime | None = None
    auto_apply: bool | None = None
    metadata_json: str | None = None
    account_id: int | None = None
    target_account_id: int | None = None
    category_id: int | None = None
    subcategory_id: int | None = None


class LedgerRecurringResponse(LedgerRecurringBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
    created_at: datetime
    updated_at: datetime


class CryptoPriceBase(BaseModel):
    symbol: str
    currency_code: str = "EUR"
    price: float
    fetched_at: datetime


class CryptoPriceCreate(CryptoPriceBase):
    pass


class CryptoPriceResponse(CryptoPriceBase):
    model_config = ConfigDict(from_attributes=True)

    id: int
    user_id: int
def normalize_email(email: str) -> str:
    return email.strip().lower()


def _resource_for_user(db: Session, model: type[Base], resource_id: int, user: User):
    statement = select(model).where(model.id == resource_id, model.user_id == user.id)
    resource = db.execute(statement).scalar_one_or_none()
    if resource is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"{model.__name__} nicht gefunden.",
        )
    return resource


def _normalize_currency(code: str) -> str:
    return code.upper()


def _ensure_optional_relation(db: Session, model: type[Base], resource_id: int | None, user: User) -> None:
    if resource_id is None:
        return
    _resource_for_user(db, model, resource_id, user)


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


ALLOWED_ORIGINS = [
    "https://app.personal-tracker.life",
    "https://api.personal-tracker.life",
    "http://localhost",
    "http://localhost:3000",
    "http://localhost:8080",
    "http://127.0.0.1",
    "http://10.0.2.2",
]

app = FastAPI(title="Tracker Backend", version="0.2.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
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


# Notes ---------------------------------------------------------------------#


@app.get("/api/notes", response_model=list[NoteResponse])
def list_notes(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[NoteResponse]:
    statement = select(Note).where(Note.user_id == current_user.id).order_by(Note.updated_at.desc(), Note.id.desc())
    results = db.execute(statement).scalars().all()
    return [NoteResponse.model_validate(row) for row in results]


@app.post("/api/notes", response_model=NoteResponse, status_code=status.HTTP_201_CREATED)
def create_note(
    payload: NoteCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> NoteResponse:
    note = Note(user_id=current_user.id, **payload.model_dump())
    db.add(note)
    db.commit()
    db.refresh(note)
    return NoteResponse.model_validate(note)


@app.get("/api/notes/{note_id}", response_model=NoteResponse)
def read_note(
    note_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> NoteResponse:
    note = _resource_for_user(db, Note, note_id, current_user)
    return NoteResponse.model_validate(note)


@app.put("/api/notes/{note_id}", response_model=NoteResponse)
def update_note(
    note_id: int,
    payload: NoteUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> NoteResponse:
    note = _resource_for_user(db, Note, note_id, current_user)
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(note, key, value)
    db.add(note)
    db.commit()
    db.refresh(note)
    return NoteResponse.model_validate(note)


@app.delete("/api/notes/{note_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_note(
    note_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    note = _resource_for_user(db, Note, note_id, current_user)
    db.delete(note)
    db.commit()


# Tasks ---------------------------------------------------------------------#


@app.get("/api/tasks", response_model=list[TaskResponse])
def list_tasks(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[TaskResponse]:
    statement = select(Task).where(Task.user_id == current_user.id).order_by(Task.due_date.asc(), Task.id.asc())
    results = db.execute(statement).scalars().all()
    return [TaskResponse.model_validate(row) for row in results]


@app.post("/api/tasks", response_model=TaskResponse, status_code=status.HTTP_201_CREATED)
def create_task(
    payload: TaskCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> TaskResponse:
    task = Task(user_id=current_user.id, **payload.model_dump())
    db.add(task)
    db.commit()
    db.refresh(task)
    return TaskResponse.model_validate(task)


@app.get("/api/tasks/{task_id}", response_model=TaskResponse)
def read_task(
    task_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> TaskResponse:
    task = _resource_for_user(db, Task, task_id, current_user)
    return TaskResponse.model_validate(task)


@app.put("/api/tasks/{task_id}", response_model=TaskResponse)
def update_task(
    task_id: int,
    payload: TaskUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> TaskResponse:
    task = _resource_for_user(db, Task, task_id, current_user)
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(task, key, value)
    db.add(task)
    db.commit()
    db.refresh(task)
    return TaskResponse.model_validate(task)


@app.delete("/api/tasks/{task_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_task(
    task_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    task = _resource_for_user(db, Task, task_id, current_user)
    db.delete(task)
    db.commit()


# Time Tracking -------------------------------------------------------------#


@app.get("/api/time_entries", response_model=list[TimeEntryResponse])
def list_time_entries(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[TimeEntryResponse]:
    statement = select(TimeEntry).where(TimeEntry.user_id == current_user.id).order_by(TimeEntry.started_at.desc())
    results = db.execute(statement).scalars().all()
    return [TimeEntryResponse.model_validate(row) for row in results]


@app.post("/api/time_entries", response_model=TimeEntryResponse, status_code=status.HTTP_201_CREATED)
def create_time_entry(
    payload: TimeEntryCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> TimeEntryResponse:
    entry = TimeEntry(user_id=current_user.id, **payload.model_dump())
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return TimeEntryResponse.model_validate(entry)


@app.get("/api/time_entries/{entry_id}", response_model=TimeEntryResponse)
def read_time_entry(
    entry_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> TimeEntryResponse:
    entry = _resource_for_user(db, TimeEntry, entry_id, current_user)
    return TimeEntryResponse.model_validate(entry)


@app.put("/api/time_entries/{entry_id}", response_model=TimeEntryResponse)
def update_time_entry(
    entry_id: int,
    payload: TimeEntryUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> TimeEntryResponse:
    entry = _resource_for_user(db, TimeEntry, entry_id, current_user)
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(entry, key, value)
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return TimeEntryResponse.model_validate(entry)


@app.delete("/api/time_entries/{entry_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_time_entry(
    entry_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    entry = _resource_for_user(db, TimeEntry, entry_id, current_user)
    db.delete(entry)
    db.commit()


# Journal ------------------------------------------------------------------#


@app.get("/api/journal/entries", response_model=list[JournalEntryResponse])
def list_journal_entries(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[JournalEntryResponse]:
    statement = select(JournalEntry).where(JournalEntry.user_id == current_user.id).order_by(JournalEntry.entry_date.desc())
    results = db.execute(statement).scalars().all()
    return [JournalEntryResponse.model_validate(row) for row in results]


@app.post("/api/journal/entries", response_model=JournalEntryResponse, status_code=status.HTTP_201_CREATED)
def create_journal_entry(
    payload: JournalEntryCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> JournalEntryResponse:
    entry = JournalEntry(
        user_id=current_user.id,
        entry_date=payload.entry_date,
        content=payload.content,
    )
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return JournalEntryResponse.model_validate(entry)


@app.get("/api/journal/entries/{entry_id}", response_model=JournalEntryResponse)
def read_journal_entry(
    entry_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> JournalEntryResponse:
    entry = _resource_for_user(db, JournalEntry, entry_id, current_user)
    return JournalEntryResponse.model_validate(entry)


@app.put("/api/journal/entries/{entry_id}", response_model=JournalEntryResponse)
def update_journal_entry(
    entry_id: int,
    payload: JournalEntryUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> JournalEntryResponse:
    entry = _resource_for_user(db, JournalEntry, entry_id, current_user)
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(entry, key, value)
    db.add(entry)
    db.commit()
    db.refresh(entry)
    return JournalEntryResponse.model_validate(entry)


@app.delete("/api/journal/entries/{entry_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_journal_entry(
    entry_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    entry = _resource_for_user(db, JournalEntry, entry_id, current_user)
    db.delete(entry)
    db.commit()


@app.get("/api/journal/trackers", response_model=list[JournalTrackerResponse])
def list_journal_trackers(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[JournalTrackerResponse]:
    statement = select(JournalTracker).where(JournalTracker.user_id == current_user.id).order_by(JournalTracker.sort_order.asc(), JournalTracker.id.asc())
    results = db.execute(statement).scalars().all()
    return [JournalTrackerResponse.model_validate(row) for row in results]


@app.post("/api/journal/trackers", response_model=JournalTrackerResponse, status_code=status.HTTP_201_CREATED)
def create_journal_tracker(
    payload: JournalTrackerCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> JournalTrackerResponse:
    tracker = JournalTracker(user_id=current_user.id, **payload.model_dump())
    db.add(tracker)
    db.commit()
    db.refresh(tracker)
    return JournalTrackerResponse.model_validate(tracker)


@app.put("/api/journal/trackers/{tracker_id}", response_model=JournalTrackerResponse)
def update_journal_tracker(
    tracker_id: int,
    payload: JournalTrackerUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> JournalTrackerResponse:
    tracker = _resource_for_user(db, JournalTracker, tracker_id, current_user)
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(tracker, key, value)
    db.add(tracker)
    db.commit()
    db.refresh(tracker)
    return JournalTrackerResponse.model_validate(tracker)


@app.delete("/api/journal/trackers/{tracker_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_journal_tracker(
    tracker_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    tracker = _resource_for_user(db, JournalTracker, tracker_id, current_user)
    db.delete(tracker)
    db.commit()


@app.get("/api/journal/tracker_values", response_model=list[JournalTrackerValueResponse])
def list_journal_tracker_values(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
    tracker_id: int | None = None,
) -> list[JournalTrackerValueResponse]:
    statement = select(JournalTrackerValue).where(JournalTrackerValue.user_id == current_user.id)
    if tracker_id is not None:
        statement = statement.where(JournalTrackerValue.tracker_id == tracker_id)
    statement = statement.order_by(JournalTrackerValue.entry_date.desc())
    results = db.execute(statement).scalars().all()
    return [JournalTrackerValueResponse.model_validate(row) for row in results]


@app.post("/api/journal/tracker_values", response_model=JournalTrackerValueResponse, status_code=status.HTTP_201_CREATED)
def create_journal_tracker_value(
    payload: JournalTrackerValueCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> JournalTrackerValueResponse:
    _resource_for_user(db, JournalTracker, payload.tracker_id, current_user)
    value = JournalTrackerValue(user_id=current_user.id, **payload.model_dump())
    db.add(value)
    db.commit()
    db.refresh(value)
    return JournalTrackerValueResponse.model_validate(value)


@app.put("/api/journal/tracker_values/{value_id}", response_model=JournalTrackerValueResponse)
def update_journal_tracker_value(
    value_id: int,
    payload: JournalTrackerValueUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> JournalTrackerValueResponse:
    value = _resource_for_user(db, JournalTrackerValue, value_id, current_user)
    for key, val in payload.model_dump(exclude_unset=True).items():
        setattr(value, key, val)
    db.add(value)
    db.commit()
    db.refresh(value)
    return JournalTrackerValueResponse.model_validate(value)


@app.delete("/api/journal/tracker_values/{value_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_journal_tracker_value(
    value_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    value = _resource_for_user(db, JournalTrackerValue, value_id, current_user)
    db.delete(value)
    db.commit()


# Habits -------------------------------------------------------------------#


@app.get("/api/habits", response_model=list[HabitResponse])
def list_habits(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
    include_archived: bool = True,
) -> list[HabitResponse]:
    statement = select(HabitDefinition).where(HabitDefinition.user_id == current_user.id)
    if not include_archived:
        statement = statement.where(HabitDefinition.archived.is_(False))
    statement = statement.order_by(HabitDefinition.name.asc())
    results = db.execute(statement).scalars().all()
    return [HabitResponse.model_validate(row) for row in results]


@app.post("/api/habits", response_model=HabitResponse, status_code=status.HTTP_201_CREATED)
def create_habit(
    payload: HabitCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> HabitResponse:
    habit = HabitDefinition(user_id=current_user.id, **payload.model_dump())
    db.add(habit)
    db.commit()
    db.refresh(habit)
    return HabitResponse.model_validate(habit)


@app.put("/api/habits/{habit_id}", response_model=HabitResponse)
def update_habit(
    habit_id: int,
    payload: HabitUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> HabitResponse:
    habit = _resource_for_user(db, HabitDefinition, habit_id, current_user)
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(habit, key, value)
    db.add(habit)
    db.commit()
    db.refresh(habit)
    return HabitResponse.model_validate(habit)


@app.delete("/api/habits/{habit_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_habit(
    habit_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    habit = _resource_for_user(db, HabitDefinition, habit_id, current_user)
    db.delete(habit)
    db.commit()


@app.get("/api/habit_logs", response_model=list[HabitLogResponse])
def list_habit_logs(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
    habit_id: int | None = None,
) -> list[HabitLogResponse]:
    statement = select(HabitLog).where(HabitLog.user_id == current_user.id)
    if habit_id is not None:
        statement = statement.where(HabitLog.habit_id == habit_id)
    statement = statement.order_by(HabitLog.occurred_at.desc())
    results = db.execute(statement).scalars().all()
    return [HabitLogResponse.model_validate(row) for row in results]


@app.post("/api/habit_logs", response_model=HabitLogResponse, status_code=status.HTTP_201_CREATED)
def create_habit_log(
    payload: HabitLogCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> HabitLogResponse:
    _resource_for_user(db, HabitDefinition, payload.habit_id, current_user)
    log = HabitLog(user_id=current_user.id, **payload.model_dump())
    db.add(log)
    db.commit()
    db.refresh(log)
    return HabitLogResponse.model_validate(log)


@app.put("/api/habit_logs/{log_id}", response_model=HabitLogResponse)
def update_habit_log(
    log_id: int,
    payload: HabitLogUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> HabitLogResponse:
    log = _resource_for_user(db, HabitLog, log_id, current_user)
    for key, value in payload.model_dump(exclude_unset=True).items():
        setattr(log, key, value)
    db.add(log)
    db.commit()
    db.refresh(log)
    return HabitLogResponse.model_validate(log)


@app.delete("/api/habit_logs/{log_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_habit_log(
    log_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    log = _resource_for_user(db, HabitLog, log_id, current_user)
    db.delete(log)
    db.commit()


# Ledger -------------------------------------------------------------------#


@app.get("/api/ledger/accounts", response_model=list[LedgerAccountResponse])
def list_ledger_accounts(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[LedgerAccountResponse]:
    statement = select(LedgerAccount).where(LedgerAccount.user_id == current_user.id).order_by(LedgerAccount.name.asc())
    results = db.execute(statement).scalars().all()
    return [LedgerAccountResponse.model_validate(row) for row in results]


@app.post("/api/ledger/accounts", response_model=LedgerAccountResponse, status_code=status.HTTP_201_CREATED)
def create_ledger_account(
    payload: LedgerAccountCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerAccountResponse:
    account = LedgerAccount(
        user_id=current_user.id,
        **payload.model_dump(exclude={"currency_code"}),
        currency_code=_normalize_currency(payload.currency_code),
    )
    db.add(account)
    db.commit()
    db.refresh(account)
    return LedgerAccountResponse.model_validate(account)


@app.put("/api/ledger/accounts/{account_id}", response_model=LedgerAccountResponse)
def update_ledger_account(
    account_id: int,
    payload: LedgerAccountUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerAccountResponse:
    account = _resource_for_user(db, LedgerAccount, account_id, current_user)
    updates = payload.model_dump(exclude_unset=True)
    if "currency_code" in updates and updates["currency_code"] is not None:
        updates["currency_code"] = _normalize_currency(updates["currency_code"])
    for key, value in updates.items():
        setattr(account, key, value)
    db.add(account)
    db.commit()
    db.refresh(account)
    return LedgerAccountResponse.model_validate(account)


@app.delete("/api/ledger/accounts/{account_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_ledger_account(
    account_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    account = _resource_for_user(db, LedgerAccount, account_id, current_user)
    db.delete(account)
    db.commit()


@app.get("/api/ledger/categories", response_model=list[LedgerCategoryResponse])
def list_ledger_categories(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
    include_archived: bool = True,
) -> list[LedgerCategoryResponse]:
    statement = select(LedgerCategory).where(LedgerCategory.user_id == current_user.id)
    if not include_archived:
        statement = statement.where(LedgerCategory.is_archived.is_(False))
    statement = statement.order_by(LedgerCategory.parent_id.asc().nullsfirst(), LedgerCategory.name.asc())
    results = db.execute(statement).scalars().all()
    return [LedgerCategoryResponse.model_validate(row) for row in results]


@app.post("/api/ledger/categories", response_model=LedgerCategoryResponse, status_code=status.HTTP_201_CREATED)
def create_ledger_category(
    payload: LedgerCategoryCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerCategoryResponse:
    _ensure_optional_relation(db, LedgerCategory, payload.parent_id, current_user)
    category = LedgerCategory(user_id=current_user.id, **payload.model_dump())
    db.add(category)
    db.commit()
    db.refresh(category)
    return LedgerCategoryResponse.model_validate(category)


@app.put("/api/ledger/categories/{category_id}", response_model=LedgerCategoryResponse)
def update_ledger_category(
    category_id: int,
    payload: LedgerCategoryUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerCategoryResponse:
    category = _resource_for_user(db, LedgerCategory, category_id, current_user)
    updates = payload.model_dump(exclude_unset=True)
    if updates.get("parent_id") is not None:
        _ensure_optional_relation(db, LedgerCategory, updates["parent_id"], current_user)
    for key, value in updates.items():
        setattr(category, key, value)
    db.add(category)
    db.commit()
    db.refresh(category)
    return LedgerCategoryResponse.model_validate(category)


@app.delete("/api/ledger/categories/{category_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_ledger_category(
    category_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    category = _resource_for_user(db, LedgerCategory, category_id, current_user)
    db.delete(category)
    db.commit()


@app.get("/api/ledger/budgets", response_model=list[LedgerBudgetResponse])
def list_ledger_budgets(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[LedgerBudgetResponse]:
    statement = select(LedgerBudget).where(LedgerBudget.user_id == current_user.id).order_by(
        LedgerBudget.year.desc(),
        LedgerBudget.month.desc().nullslast(),
    )
    results = db.execute(statement).scalars().all()
    return [LedgerBudgetResponse.model_validate(row) for row in results]


@app.post("/api/ledger/budgets", response_model=LedgerBudgetResponse, status_code=status.HTTP_201_CREATED)
def create_ledger_budget(
    payload: LedgerBudgetCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerBudgetResponse:
    _resource_for_user(db, LedgerCategory, payload.category_id, current_user)
    budget = LedgerBudget(
        user_id=current_user.id,
        **payload.model_dump(exclude={"currency_code"}),
        currency_code=_normalize_currency(payload.currency_code),
    )
    db.add(budget)
    db.commit()
    db.refresh(budget)
    return LedgerBudgetResponse.model_validate(budget)


@app.put("/api/ledger/budgets/{budget_id}", response_model=LedgerBudgetResponse)
def update_ledger_budget(
    budget_id: int,
    payload: LedgerBudgetUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerBudgetResponse:
    budget = _resource_for_user(db, LedgerBudget, budget_id, current_user)
    updates = payload.model_dump(exclude_unset=True)
    if updates.get("category_id") is not None:
        _resource_for_user(db, LedgerCategory, updates["category_id"], current_user)
    if updates.get("currency_code") is not None:
        updates["currency_code"] = _normalize_currency(updates["currency_code"])
    for key, value in updates.items():
        setattr(budget, key, value)
    db.add(budget)
    db.commit()
    db.refresh(budget)
    return LedgerBudgetResponse.model_validate(budget)


@app.delete("/api/ledger/budgets/{budget_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_ledger_budget(
    budget_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    budget = _resource_for_user(db, LedgerBudget, budget_id, current_user)
    db.delete(budget)
    db.commit()


@app.get("/api/ledger/transactions", response_model=list[LedgerTransactionResponse])
def list_ledger_transactions(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[LedgerTransactionResponse]:
    statement = select(LedgerTransaction).where(LedgerTransaction.user_id == current_user.id).order_by(
        LedgerTransaction.booking_date.desc(),
        LedgerTransaction.id.desc(),
    )
    results = db.execute(statement).scalars().all()
    return [LedgerTransactionResponse.model_validate(row) for row in results]


@app.post("/api/ledger/transactions", response_model=LedgerTransactionResponse, status_code=status.HTTP_201_CREATED)
def create_ledger_transaction(
    payload: LedgerTransactionCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerTransactionResponse:
    _ensure_optional_relation(db, LedgerAccount, payload.account_id, current_user)
    _ensure_optional_relation(db, LedgerAccount, payload.target_account_id, current_user)
    _ensure_optional_relation(db, LedgerCategory, payload.category_id, current_user)
    _ensure_optional_relation(db, LedgerCategory, payload.subcategory_id, current_user)
    transaction = LedgerTransaction(
        user_id=current_user.id,
        **payload.model_dump(exclude={"currency_code"}),
        currency_code=_normalize_currency(payload.currency_code),
    )
    db.add(transaction)
    db.commit()
    db.refresh(transaction)
    return LedgerTransactionResponse.model_validate(transaction)


@app.put("/api/ledger/transactions/{transaction_id}", response_model=LedgerTransactionResponse)
def update_ledger_transaction(
    transaction_id: int,
    payload: LedgerTransactionUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerTransactionResponse:
    transaction = _resource_for_user(db, LedgerTransaction, transaction_id, current_user)
    updates = payload.model_dump(exclude_unset=True)
    _ensure_optional_relation(db, LedgerAccount, updates.get("account_id"), current_user)
    _ensure_optional_relation(db, LedgerAccount, updates.get("target_account_id"), current_user)
    _ensure_optional_relation(db, LedgerCategory, updates.get("category_id"), current_user)
    _ensure_optional_relation(db, LedgerCategory, updates.get("subcategory_id"), current_user)
    if updates.get("currency_code") is not None:
        updates["currency_code"] = _normalize_currency(updates["currency_code"])
    for key, value in updates.items():
        setattr(transaction, key, value)
    db.add(transaction)
    db.commit()
    db.refresh(transaction)
    return LedgerTransactionResponse.model_validate(transaction)


@app.delete("/api/ledger/transactions/{transaction_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_ledger_transaction(
    transaction_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    transaction = _resource_for_user(db, LedgerTransaction, transaction_id, current_user)
    db.delete(transaction)
    db.commit()


@app.get("/api/ledger/recurring", response_model=list[LedgerRecurringResponse])
def list_ledger_recurring(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[LedgerRecurringResponse]:
    statement = select(LedgerRecurringTransaction).where(LedgerRecurringTransaction.user_id == current_user.id).order_by(
        LedgerRecurringTransaction.next_occurrence.asc(),
        LedgerRecurringTransaction.id.asc(),
    )
    results = db.execute(statement).scalars().all()
    return [LedgerRecurringResponse.model_validate(row) for row in results]


@app.post("/api/ledger/recurring", response_model=LedgerRecurringResponse, status_code=status.HTTP_201_CREATED)
def create_ledger_recurring(
    payload: LedgerRecurringCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerRecurringResponse:
    _ensure_optional_relation(db, LedgerAccount, payload.account_id, current_user)
    _ensure_optional_relation(db, LedgerAccount, payload.target_account_id, current_user)
    _ensure_optional_relation(db, LedgerCategory, payload.category_id, current_user)
    _ensure_optional_relation(db, LedgerCategory, payload.subcategory_id, current_user)
    recurring = LedgerRecurringTransaction(
        user_id=current_user.id,
        **payload.model_dump(exclude={"currency_code"}),
        currency_code=_normalize_currency(payload.currency_code),
    )
    db.add(recurring)
    db.commit()
    db.refresh(recurring)
    return LedgerRecurringResponse.model_validate(recurring)


@app.put("/api/ledger/recurring/{recurring_id}", response_model=LedgerRecurringResponse)
def update_ledger_recurring(
    recurring_id: int,
    payload: LedgerRecurringUpdate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> LedgerRecurringResponse:
    recurring = _resource_for_user(db, LedgerRecurringTransaction, recurring_id, current_user)
    updates = payload.model_dump(exclude_unset=True)
    _ensure_optional_relation(db, LedgerAccount, updates.get("account_id"), current_user)
    _ensure_optional_relation(db, LedgerAccount, updates.get("target_account_id"), current_user)
    _ensure_optional_relation(db, LedgerCategory, updates.get("category_id"), current_user)
    _ensure_optional_relation(db, LedgerCategory, updates.get("subcategory_id"), current_user)
    if updates.get("currency_code") is not None:
        updates["currency_code"] = _normalize_currency(updates["currency_code"])
    for key, value in updates.items():
        setattr(recurring, key, value)
    db.add(recurring)
    db.commit()
    db.refresh(recurring)
    return LedgerRecurringResponse.model_validate(recurring)


@app.delete("/api/ledger/recurring/{recurring_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_ledger_recurring(
    recurring_id: int,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> None:
    recurring = _resource_for_user(db, LedgerRecurringTransaction, recurring_id, current_user)
    db.delete(recurring)
    db.commit()


@app.get("/api/ledger/crypto_prices", response_model=list[CryptoPriceResponse])
def list_crypto_prices(
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> list[CryptoPriceResponse]:
    statement = select(CryptoPriceEntry).where(CryptoPriceEntry.user_id == current_user.id).order_by(
        CryptoPriceEntry.symbol.asc(),
        CryptoPriceEntry.currency_code.asc(),
    )
    results = db.execute(statement).scalars().all()
    return [CryptoPriceResponse.model_validate(row) for row in results]


@app.post("/api/ledger/crypto_prices", response_model=CryptoPriceResponse, status_code=status.HTTP_201_CREATED)
def upsert_crypto_price(
    payload: CryptoPriceCreate,
    current_user: Annotated[User, Depends(get_current_user)],
    db: Annotated[Session, Depends(get_db)],
) -> CryptoPriceResponse:
    symbol = payload.symbol.upper()
    currency = _normalize_currency(payload.currency_code)
    statement = (
        select(CryptoPriceEntry)
        .where(
            CryptoPriceEntry.user_id == current_user.id,
            CryptoPriceEntry.symbol == symbol,
            CryptoPriceEntry.currency_code == currency,
        )
    )
    existing = db.execute(statement).scalar_one_or_none()
    if existing is None:
        price_entry = CryptoPriceEntry(
            user_id=current_user.id,
            symbol=symbol,
            currency_code=currency,
            price=payload.price,
            fetched_at=payload.fetched_at,
        )
        db.add(price_entry)
        db.commit()
        db.refresh(price_entry)
        return CryptoPriceResponse.model_validate(price_entry)
    existing.price = payload.price
    existing.fetched_at = payload.fetched_at
    db.add(existing)
    db.commit()
    db.refresh(existing)
    return CryptoPriceResponse.model_validate(existing)
