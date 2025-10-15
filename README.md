# tracker

Dieses Repository ist in drei Hauptteile gegliedert:

- `app/` – Flutter-Anwendung inkl. aller mobilen/desktop Builds und Tests.
- `backend/` – Serverpod-Backend mit Docker-basierter Dev-Umgebung.
- `homepage/` – Platzhalter für die Projekt-Homepage bzw. Marketing-Site.

## Entwickeln

### Flutter-App

```bash
cd app
flutter pub get
flutter analyze
flutter run
```

### Backend

```bash
cd backend/tracker_backend/tracker_backend_server
docker compose up --build -d
dart bin/main.dart --apply-migrations
```

Weitere Hinweise (CLI-Wrapperskript, Migrationen, Konfiguration) findest du in
`backend/README.md`.

### Homepage & Web-App

Die statische Produktseite + Wiki sowie die Flutter-Web-App lassen sich via Docker Compose starten:

```bash
docker compose -f docker-compose.homepage.yml up --build
```

Anschließend:

- Homepage: <http://localhost:8080>
- Web-App: <http://localhost:8081>

Weitere Details findest du in `homepage/README.md`.

## Weitere Unterlagen

- `gemini.md` – Projektnotizen / Kontext.
- `todo.md` – Offene Aufgaben und Roadmap.
- `LICENSE` – Lizenzinformationen.
