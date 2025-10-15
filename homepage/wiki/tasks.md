# Aufgaben & Termine Modul

## Bedienung
- Planung von Aufgaben, Terminen und Erinnerungen.
- Kalenderansicht hebt Tage mit Terminen hervor.
- Listenansichten mit Sortierung nach Fälligkeit, Priorität und Kategorie.
- Kategorieverwaltung mit automatischer Erstellung beim Anlegen neuer Einträge.
- Zeiterfassung kann direkt aus Aufgaben heraus gestartet werden.

## Datenmodell
- Drift-Tabellen (geplant) für `tasks`, `appointments`, `categories`, `reminders`.
- Beziehungen:
  - `tasks` ↔ `time_entries` (1:n)
  - `tasks` ↔ `notes` (n:m geplant)
  - Kategorien als referenzielle Entities.

## Synchronisation
- Lokal vollständig nutzbar.
- Bei Mitgliedschaft: verschlüsselte Synchronisation aller Aufgaben, Termine und Erinnerungen.
- Konfliktstrategie (Roadmap Phase 3): letzte Änderung gewinnt + Versionshistorie.

## Offene Punkte (To-Do)
- UI/UX Implementierung laut Roadmap.
- Erinnerungssystem & Push Notifications.
- Kalender- und Listen-Ansichten fertigstellen.
- Kategorien-UI + automatische Erstellung.
