# Notizen Modul

## Bedienung
- Start im Modul: Liste mit Markdown- und Zeichen-Notizen.
- Suche nach Text + Dropdown für Tag-Filter.
- Schaltfläche "Neue Notiz" öffnet Auswahl zwischen Markdown und Zeichnung.
- Markdown-Editor mit Live-Vorschau, Tags (Textfeld + Vorschlagschips).
- Zeichen-Modus mit Tools (Stift, Linie, Rechteck, Ellipse), Farb- und Strichstärke-Auswahl.
- Notizen lassen sich nachträglich bearbeiten, löschen und über Tags verknüpfen.

## Datenmodell
- Drift-Tabelle `note_entries` mit Feldern:
  - `id`, `title`, `content`, `drawing_json`, `tags`, `kind`, `created_at`, `updated_at`.
- Enum `NoteKind` (markdown/drawing) ermöglicht dynamische Darstellung.
- Tags werden als kommaseparierte Liste gespeichert; künftig als eigene Tabelle geplant.

## Synchronisation
- Standard: alles lokal in Drift + Hive.
- Bei Mitgliedschaft: verschlüsselte Synchronisierung aller Notizen (Text + Zeichnungen).
- Zeichnungen werden als JSON-Struktur mit Vektorpfaden gespeichert.

## Offene Punkte (To-Do)
- Automatische Tags & Vorschlagslogik ausbauen.
- Bidirektionale Verlinkung mit Aufgaben/Terminen.
- Vorlagen, Kalender-Filter, Bildanhänge.
