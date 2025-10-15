# Dashboard Modul

## Bedienung
- Startseite der App nach dem Login (oder lokal).
- Zeigt eine Willkommensnachricht, Statusmeldungen und Kennzahlen aus anderen Modulen.
- Schnellzugriff auf Backend-Kommunikation, gespeicherte Antworten und statische Karten.
- Lösch-Icon entfernt gespeicherte Antworten lokal.

## Datenmodell
- Greift auf lokale Drift-Datenbank (`greeting_entries`) zu.
- Nutzt Hive für Settings (z.B. Sprache, Theme, Module).
- Keine eigenen Synchronisationsdaten.

## Synchronisation
- Einträge aus dem Begrüßungsservice werden nur lokal gespeichert.
- Bei aktiver Mitgliedschaft könnten zukünftige Kennzahlen synchronisiert werden (noch offen laut Roadmap).

## Geplante Erweiterungen
- Integration echter Modul-Daten (Tasks, Habits etc.).
- Anpassbares Dashboard-Layout gemäß Roadmap (Phase 2).
