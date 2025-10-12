# Tracker Backend

Simple FastAPI backend exposing a greeting and health endpoint for the tracker demo.

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
