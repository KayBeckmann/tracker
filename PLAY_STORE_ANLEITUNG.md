# Anleitung zur Veröffentlichung im Google Play Store

Diese Anleitung führt dich Schritt für Schritt durch den Prozess, deine App ("Personal Tracker") für den Google Play Store vorzubereiten und zu veröffentlichen.

## 1. App-Icons generieren (Bereits erledigt)
Die Konfiguration für die App-Icons wurde bereits erstellt (`flutter_launcher_icons.yaml`) und die Icons wurden generiert. Damit hat deine App nun passende Icons für alle Android-Geräte.

## 2. Signaturschlüssel (Keystore) erstellen
Um eine App im Play Store zu veröffentlichen, muss sie digital signiert sein. Dafür benötigst du eine Keystore-Datei. **Wichtig:** Diese Datei darf niemals verloren gehen, sonst kannst du keine Updates mehr veröffentlichen!

Führe folgenden Befehl in deinem Terminal aus (im Hauptverzeichnis des Projekts):

```bash
# Erstellt eine Datei upload-keystore.jks im Ordner app/android
keytool -genkey -v -keystore app/android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Du wirst nach einem Passwort gefragt. Merke dir dieses Passwort gut! Die Fragen nach Name, Ort, etc. kannst du wahrheitsgemäß beantworten oder leer lassen (Enter).

## 3. `key.properties` erstellen
Damit der Build-Prozess den Schlüssel findet, ohne dass das Passwort im Code steht, erstellen wir eine `key.properties` Datei. Diese Datei wird von Git ignoriert (siehe `.gitignore`), damit deine Geheimnisse sicher bleiben.

Erstelle die Datei `app/android/key.properties` mit folgendem Inhalt (ersetze `DEIN_PASSWORT` mit dem Passwort, das du oben gewählt hast):

```properties
storePassword=DEIN_PASSWORT
keyPassword=DEIN_PASSWORT
keyAlias=upload
storeFile=upload-keystore.jks
```

## 4. App Bundle erstellen
Google Play verlangt mittlerweile ein "App Bundle" (.aab) statt einer APK. Das Bundle erlaubt Google, optimierte Versionen für verschiedene Geräte auszuliefern.

Führe folgenden Befehl im `app`-Verzeichnis aus:

```bash
cd app
flutter build appbundle --release
```

Die fertige Datei findest du dann unter:
`app/build/app/outputs/bundle/release/app-release.aab`

## 5. Google Play Console

1.  Gehe zur [Google Play Console](https://play.google.com/console).
2.  Erstelle eine neue App.
3.  Wähle "App erstellen" und fülle die Basisdaten aus (Name, Sprache, App/Spiel, Kostenlos/Bezahlt).

### Store-Eintrag (Texte)

Hier sind Vorschläge für die Texte, die du im Play Store verwenden kannst:

**App-Name (max. 30 Zeichen):**
Personal Tracker - Journal

**Kurzbeschreibung (max. 80 Zeichen):**
Tracke Gewohnheiten, Finanzen, Aufgaben und Tagebuch – privat & sicher.

**Ausführliche Beschreibung (max. 4000 Zeichen):**
Behalte den Überblick über dein Leben mit Personal Tracker. Deine Daten gehören dir – die App speichert alles lokal auf deinem Gerät.

Funktionen im Überblick:

**✨ Gewohnheiten (Habits)**
Baue neue Routinen auf und verfolge deinen Fortschritt. Visualisiere deine Erfolge und bleibe motiviert.

**📝 Tagebuch (Journal)**
Halte deine Gedanken fest. Schreibe tägliche Einträge, reflektiere über deinen Tag und nutze die integrierte Sperrfunktion für maximale Privatsphäre.

**💰 Finanzen (Ledger)**
Behalte deine Ausgaben und Einnahmen im Blick. Einfaches Tracking hilft dir, dein Budget besser zu verstehen.

**✅ Aufgaben (Tasks)**
Organisiere deine To-Dos effizient. Erstelle Listen, setze Prioritäten und hake erledigte Aufgaben ab.

**🔒 Datenschutz & Privatsphäre**
Kein Cloud-Zwang, kein Tracking. Deine Daten werden lokal gespeichert. Du hast die volle Kontrolle.

Lade Personal Tracker jetzt herunter und beginne, dein Leben bewusster zu gestalten!

---

### Upload & Release

1.  Gehe im Menü auf **Testen und veröffentlichen** -> **Produktion**.
2.  Erstelle einen neuen Release.
3.  Lade die Datei `app-release.aab` hoch, die du in Schritt 4 erstellt hast.
4.  Fülle die Hinweise zum Release aus (z.B. "Erste Veröffentlichung").
5.  Gehe die Checkliste im Dashboard durch (Datenschutzerklärung, Inhaltsbewertung, Zielgruppe etc.).
6.  Sobald alles grün ist: Klicke auf "Veröffentlichung prüfen" und dann "Rollout starten".

Viel Erfolg mit deiner App!
