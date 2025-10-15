# Tracker Homepage

Diese statische Seite dient als Produkt- und Feature-Übersicht der Tracker-App.

## Inhalte

- **Vision**: Warum Tracker entwickelt wird und welchen Mehrwert die App liefert.
- **Module**: Überblick über Dashboard, Aufgaben, Notizen, Journal, Habits, Haushaltsbuch, Zeiterfassung und Einstellungen.
- **Synchronisation**: Darstellung der Offline-first-Strategie sowie der verschlüsselten Cloud-Synchronisierung.
- **Roadmap**: Wichtigste To-do-Blöcke basierend auf `../todo.md`.

## Struktur

```
homepage/
├── index.html      # Produktseite
├── styles.css      # Styling im dunklen Look
└── wiki/
    ├── index.html          # Wiki-Übersicht
    ├── dashboard.html      # Modul-Seiten (gleiches Muster)
    └── …
```

## Lokale Vorschau

Einfach mit einem beliebigen Webserver starten, z. B.:

```bash
python -m http.server --directory homepage 8080
```

Danach im Browser `http://localhost:8080` öffnen. Die Wiki-Unterseiten liegen z. B. unter `http://localhost:8080/wiki/index.html`.
