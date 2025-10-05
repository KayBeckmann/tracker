# Backend – Serverpod (Dev)

Der Backend-Stack basiert auf [Serverpod](https://serverpod.dev/) und liegt in
`tracker_backend/`. Die erzeugte Struktur enthält drei Pakete:

- `tracker_backend_server` – Serverpod-Server mit Docker-Setup und Migrationen
- `tracker_backend_client` – Dart-Client (wird später im Flutter-Frontend genutzt)
- `tracker_backend_flutter` – Beispiel-Flutter-App von Serverpod (optional)

## Voraussetzungen

```bash
dart pub global activate serverpod_cli
```

Da der CLI-Cache im Repository abgelegt wird, nutze das Wrapper-Skript:

```bash
backend/scripts/serverpod.sh generate
```

(Das Skript legt einen isolierten Cache in `backend/.serverpod-home/` an, damit
keine Schreibrechte außerhalb des Repos nötig sind.)

## Dev-Stack starten

```bash
cd backend/tracker_backend/tracker_backend_server
docker compose up --build -d
dart bin/main.dart --apply-migrations
```

- Postgres & Redis laufen in Containern mit `tmpfs`-Storage – Daten sind damit
  automatisch flüchtig und verschwinden beim Stoppen von Docker.
- Konfigurationswerte findest du unter `config/` (`development.yaml`, etc.).

Zum Stoppen genügt:

```bash
docker compose down
```

## Nützliche Befehle

- `backend/scripts/serverpod.sh generate` – Code & Migrationen regenerieren
- `backend/scripts/serverpod.sh create-migration <name>` – neue Migration anlegen
- `dart test` innerhalb von `tracker_backend_server` – Serverseitige Tests

Weitere Serverpod-Dokumentation: https://docs.serverpod.dev/
