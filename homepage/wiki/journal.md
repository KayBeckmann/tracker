# Journal & Mood Tracker Modul

## Bedienung
- Dient als persönliches Tagebuch mit Stimmungsaufzeichnungen.
- Geplante UI: Tagesliste, Wochen- und Monatsübersichten.
- Eingabemaske mit Textfeldern, Tags, Stimmungsskala und optionalen Verknüpfungen zu Notizen/Aufgaben.
- Filter nach Zeitraum, Stimmung und Tags.

## Datenmodell (geplant)
- Tabellen `journal_entries` (Textinhalte), `mood_metrics` (Skalenwerte), `journal_tags`.
- Beziehung zu Notizen/Tasks über Link-Tabellen.

## Synchronisation
- Lokal vollständig nutzbar.
- Mit Mitgliedschaft: verschlüsselte Synchronisation aller Journal- und Stimmungsdaten.
- Datenschutz: sensible Daten werden nur mit Nutzerzustimmung synchronisiert.

## Roadmap-Punkte
- UI-Implementierung inkl. Diagramme.
- Automatische Erinnerungen für tägliches Logging.
- Verbindung zu Habit-Tracking für Reflexion.
