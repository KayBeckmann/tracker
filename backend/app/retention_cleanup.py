from __future__ import annotations

import logging
from datetime import datetime, timezone

from sqlalchemy import delete
from sqlalchemy.orm import Session

from .main import (
    SessionLocal,
    User,
    Note,
    Task,
    TimeEntry,
    JournalEntry,
    JournalTracker,
    HabitDefinition,
    HabitLog,
    LedgerTransaction,
    LedgerRecurringTransaction,
    LedgerBudget,
    LedgerAccount,
    LedgerCategory,
    CryptoPriceEntry,
)

LOGGER = logging.getLogger(__name__)

# Order matters: purge child tables before parent references.
TABLES_TO_DELETE = [
    LedgerTransaction,
    LedgerRecurringTransaction,
    LedgerBudget,
    LedgerAccount,
    LedgerCategory,
    HabitLog,
    HabitDefinition,
    JournalEntry,
    JournalTracker,
    TimeEntry,
    Task,
    Note,
    CryptoPriceEntry,
]


def _purge_user_data(db: Session, user: User) -> int:
    """Remove synchronised data for a single user and reset retention markers."""

    total_rows = 0
    for model in TABLES_TO_DELETE:
        result = db.execute(delete(model).where(model.user_id == user.id))
        total_rows += result.rowcount or 0

    user.membership_level = "none"
    user.sync_enabled = False
    user.membership_expires_at = None
    user.sync_retention_until = None
    db.add(user)
    return total_rows


def purge_expired_retained_data(now: datetime | None = None) -> dict[str, int]:
    """Delete synced data for users whose retention window has elapsed."""

    now = now or datetime.now(timezone.utc)
    processed_users = 0
    removed_rows = 0

    with SessionLocal() as db:
        expired_users = (
            db.query(User)
            .filter(User.sync_retention_until.isnot(None))
            .filter(User.sync_retention_until <= now)
            .all()
        )

        if not expired_users:
            LOGGER.info("No users scheduled for retention cleanup.")
            return {"users": 0, "rows": 0}

        LOGGER.info("Found %s user(s) pending retention cleanup.", len(expired_users))

        for user in expired_users:
            deleted = _purge_user_data(db, user)
            removed_rows += deleted
            processed_users += 1
            LOGGER.info(
                "Purged %s rows for user_id=%s (target retention date %s).",
                deleted,
                user.id,
                user.sync_retention_until,
            )

        db.commit()

    return {"users": processed_users, "rows": removed_rows}


def main() -> None:
    """CLI entrypoint."""

    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    stats = purge_expired_retained_data()
    LOGGER.info(
        "Retention cleanup complete: %s user(s) processed, %s row(s) removed.",
        stats["users"],
        stats["rows"],
    )


if __name__ == "__main__":
    main()
