# Einstellungen Modul

## Bedienung
- Zugriff auf Sprache, Theme, Modul-Sichtbarkeit, Reihenfolge und Synchronisation.
- Änderungen werden sofort in Hive gespeichert.
- Module lassen sich per Toggle verstecken und via Drag & Drop in der Navigation umsortieren.
- Synchronisationsstatus und Mitgliedschaften werden angezeigt, sobald ein Backend-Login existiert.

## Datenmodell
- Hive-Keys:
  - `preferred_locale`
  - `preferred_theme_mode`
  - `preferred_seed_color`
  - `enabled_modules`
  - `module_order`
- Membership-Infos werden via Backend (`/api/membership`) geladen und im State gehalten.

## Synchronisation
- Einstellungen bleiben lokal gespeichert.
- Modul-Sichtbarkeit/-Reihenfolge beeinflussen nur das Gerät.
- Mitgliedschaftsstatus kommt vom Backend und steuert die Sync-Freischaltung.

## Roadmap
- Erweiterte Theme-Verwaltung (eigene Paletten).
- Globale Export/Import-Funktionen für Settings.
- Integration externer IdPs (Google, Apple ID) für Login.
