# Tracker Backend

Simple FastAPI backend exposing a greeting and health endpoint for the tracker demo.

## Local development

```bash
pip install -r requirements.txt
uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

## Docker

```bash
docker build -t tracker-backend ./backend
docker run --rm -p 8080:8080 tracker-backend
```

Once running, try `curl http://127.0.0.1:8080/api/greeting?name=Flutter`.
