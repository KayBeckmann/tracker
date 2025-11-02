# Tracker Backend

FastAPI-Backend für den Personal Tracker mit Benutzerverwaltung, Mitgliedschafts-Abonnements,
Google-Authentifizierung, Zahlungsverwaltung (inkl. Google Pay & PayPal Business) und Admin-Schnittstellen.

## Lokale Entwicklung

### Ohne Docker

```bash
pip install -r requirements.txt
export DATABASE_URL="postgresql+psycopg://tracker:tracker@localhost:5432/tracker"
export AUTH_SECRET_KEY="change-this-secret"
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

Das Backend verwendet standardmäßig SQLite (`sqlite:///./tracker.db`). Sobald `DATABASE_URL`
gesetzt ist, wird die angegebene SQL-Datenbank genutzt; für Postgres eignet sich der obige
Connection-String.

### Mit Docker Compose

```bash
docker compose up --build
```

Compose startet automatisch eine Postgres-Instanz sowie das Backend mit dem
vorkonfigurierten Connection-String `postgresql+psycopg://tracker:tracker@db:5432/tracker`.

Nach dem Start lässt sich das Backend z.B. mit `curl http://127.0.0.1:8080/api/health` prüfen.

## Wichtige Umgebungsvariablen

| Name | Beschreibung |
| --- | --- |
| `AUTH_SECRET_KEY` | Geheimnis zur Signierung der Access-Tokens (Pflicht in Produktion). |
| `DATABASE_URL` | Optionale Datenbankverbindung (SQLite per Default). |
| `GOOGLE_CLIENT_IDS` | Kommagetrennte Liste erlaubter Google OAuth Client IDs zur Verifikation von ID-Tokens. |
| `PAYPAL_BUSINESS_ACCOUNT` | Kennung/E-Mail des PayPal Business Accounts, wird in Zahlungs-Metadaten ausgegeben. |
| `MEMBERSHIP_PRICE_MONTHLY` / `MEMBERSHIP_PRICE_YEARLY` | Überschreibt Standardpreise (1.0 € / 10.0 €). |
| `ADMIN_DEFAULT_EMAIL` / `ADMIN_DEFAULT_PASSWORD` | Erstellt bei Start (falls gesetzt) automatisch einen Admin-Zugang. |
| `ADMIN_DEFAULT_DISPLAY_NAME` | Anzeigename des automatisch angelegten Admins. |

> Hinweis: `ADMIN_DEFAULT_PASSWORD` wird beim Seed-Prozess gehasht. Entfernen Sie die
> Variable nach der ersten Initialisierung oder ändern Sie das Kennwort via SQL.

## Neue API-Endpunkte

- `POST /api/auth/google` – Anmeldung/Registrierung via Google-ID-Token (erstellt Nutzer & Verknüpfung).
- `POST /api/admin/auth/login` – Admin-Login, liefert ein JWT mit `role=admin`.
- `GET /api/admin/payments` – Listet Zahlungen mit Filteroptionen (Status, Nutzer, Plan, Methode).
- `GET /api/admin/payments/{payment_uuid}` – Details zu einer Zahlung.
- `PATCH /api/admin/payments/{payment_uuid}` – Korrigiert Zahlungsstatus, Referenz, Metadaten oder Betrag.

Die bestehenden `/api/membership`-Routen ergänzen jetzt eine `last_payment_uuid`, sodass
Zahlungen eindeutig auswertbar sind. Bitcoin-Zahlungen sind bis auf Weiteres deaktiviert.

## Datenbank-Schema

Das Backend verwendet SQLAlchemy, um das Datenbankschema automatisch aus den Modellen in `app/main.py` zu erstellen.

**Wichtiger Hinweis:** Wenn Sie Änderungen am Datenbankschema vornehmen (z. B. neue Spalten zu einem Modell hinzufügen), müssen Sie die Datenbank manuell neu erstellen, damit die Änderungen wirksam werden. Da die Daten in einem Docker-Volume gespeichert werden, bleiben sie auch nach einem Neustart der Container erhalten.

Um die Datenbank neu zu erstellen, führen Sie die folgenden Befehle aus:

```bash
docker compose down
docker volume rm tracker_tracker-postgres-data
docker compose up --build
```

**Achtung:** Dieser Vorgang löscht alle Daten in der Datenbank. Für eine Produktionsumgebung wird die Verwendung eines Migrationstools wie Alembic empfohlen.
