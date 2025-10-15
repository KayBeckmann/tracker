# Zeiterfassung Modul

## Bedienung
- Sessions manuell oder per Timer erfassen.
- Aufgabenverknüpfung erlaubt Zuordnung von Zeiten zu Projekten.
- Tag-Funktionen, um Sessions gruppiert auszuwerten.
- Geplante UI: Start/Stop-Timer, Liste abgeschlossener Sessions, Filter nach Aufgabe/Tag.

## Datenmodell
- Drift-Tabelle `time_entries` (geplant) mit Feldern: `task_id`, `started_at`, `ended_at`, `duration`, `tags`.
- Verknüpfung zu Aufgaben (FK) und Tags.

## Synchronisation
- Offlinetauglich; Sessions bleiben lokal ohne Account.
- Bei Mitgliedschaft: verschlüsselte Synchronisation aller Zeiteinträge.
- Konfliktauflösung: Merge per Session-ID, nachträgliche Änderungen werden versioniert.

## Roadmap
- Integration in Aufgabenmodul.
- Visualisierung (Diagramme, Tages-/Wochenübersichten).
- Automatische Pausen-Erkennung & Fokus-Modus.
