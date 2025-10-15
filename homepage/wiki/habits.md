# Habits Modul

## Bedienung
- Erlaubt tägliche, wöchentliche oder benutzerdefinierte Gewohnheiten.
- Eingabemasken für Anzahl, Zeit oder Status (ja/nein).
- Visualisierung als Kalender/Diagramm mit Trendlinien.
- Erinnerungssystem (Push/Notifications) geplant.

## Datenmodell (geplant)
- Tabellen `habits`, `habit_entries`, `habit_tags`.
- Felder: Zieltyp, Intervall, Soll-Wert, aktuelle Serie, längste Serie.

## Synchronisation
- Offline nutzbar; Daten werden lokal gespeichert.
- Mitglieder: verschlüsselte Synchronisation aller Habit-Daten.
- Konfliktlösung über Tagesstempel (letzter Eintrag gewinnt).

## To-Do laut Roadmap
- UI designen und implementieren.
- Historische Vergleiche & Heatmaps.
- Integration in Dashboard & Benachrichtigungen.
