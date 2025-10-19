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

### Infrastruktur (Docker Compose)

Alle Komponenten – Homepage, Wiki, Flutter-Web-App, Backend und Datenbank – lassen sich gemeinsam starten:

```bash
docker compose up --build -d
```

Der Reverse-Proxy routet anhand der Hostnamen:

- Homepage: `https://personal-tracker.life` (lokal via `http://localhost`)
- Wiki: `https://personal-tracker.life/wiki/`
- Web-App: `https://app.personal-tracker.life`
- API: `https://api.personal-tracker.life`

Für lokale Tests kannst du Einträge wie `127.0.0.1 app.personal-tracker.life` und `127.0.0.1 api.personal-tracker.life` in `/etc/hosts` ergänzen oder alternativ direkt den Reverse-Proxy unter `http://localhost` aufrufen.

## Weitere Unterlagen

- `gemini.md` – Projektnotizen / Kontext.
- `todo.md` – Offene Aufgaben und Roadmap.
- `LICENSE` – Lizenzinformationen.
