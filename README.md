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

Die Container veröffentlichen folgende Ports (Standard-Setup):

- Homepage: `http://localhost:8080`
- Web-App: `http://localhost:8081`
- Wiki: `http://localhost:8082`
- API/Backend: `http://localhost:8083`

Auf dem Server läuft der Reverse-Proxy separat und kann diese Ports den Domains `personal-tracker.life`, `app.personal-tracker.life` und `api.personal-tracker.life` zuordnen. Eine Beispielkonfiguration liegt unter `deploy/nginx/conf.d/personal-tracker.conf`.

Für lokale Tests kannst du optional Hosts-Einträge wie `127.0.0.1 app.personal-tracker.life` und `127.0.0.1 api.personal-tracker.life` setzen oder direkt die oben genannten Ports aufrufen.

## Weitere Unterlagen

- `gemini.md` – Projektnotizen / Kontext.
- `todo.md` – Offene Aufgaben und Roadmap.
- `LICENSE` – Lizenzinformationen.
