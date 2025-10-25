A server app built using [Shelf](https://pub.dev/packages/shelf),
configured to enable running with [Docker](https://www.docker.com/).

This sample code handles HTTP GET requests to `/` and `/echo/<message>`

# Running the sample

## Running with the Dart SDK

You can run the example with the [Dart SDK](https://dart.dev/get-dart)
like this:

```
$ dart run bin/server.dart
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

## Running with Docker

If you have [Docker Desktop](https://www.docker.com/get-started) installed, you
can build and run with the `docker` command:

```
$ docker build . -t myserver
$ docker run -it -p 8080:8080 myserver
Server listening on port 8080
```

And then from a second terminal:
```
$ curl http://0.0.0.0:8080
Hello, World!
$ curl http://0.0.0.0:8080/echo/I_love_Dart
I_love_Dart
```

You should see the logging printed in the first terminal:
```
2021-05-06T15:47:04.620417  0:00:00.000158 GET     [200] /
2021-05-06T15:47:08.392928  0:00:00.001216 GET     [200] /echo/I_love_Dart
```

## Daten-Synchronisation

Alle an den Endpunkten `/api/sync/items` übertragenen Inhalte werden bereits vollständig verschlüsselt (`ciphertext`) abgespeichert. Der Server speichert lediglich Metadaten (ID, Collection, Versionszähler, Zeitstempel, Lösch-Flag) und erzwingt über die Benutzer-ID, dass jede Anfrage nur auf die eigenen Datensätze zugreifen kann.

Zur Organisation empfiehlt es sich, pro Feature eine eigene Collection zu verwenden. Typische Zuordnungen:

- `settings`: Benutzer- und App-Einstellungen (Theme, Sprache, Freigaben)
- `tasks`, `notes`, `timers`: Aufgaben, Notizen und Zeiteinträge
- `habits`: Gewohnheiten inkl. Wiederholungen/Verlauf
- `ledger_accounts`, `ledger_transactions`, `ledger_categories`, `ledger_budgets`: Haushaltsbuch-Daten
- `journal_entries`, `journal_pin`: Journal-Inhalte und der verschlüsselte Journal-PIN, sodass die Sperre auf allen Geräten aktiv bleibt

Weitere Collections können bei Bedarf ergänzt werden – solange der Client gültige Ciphertexte liefert, werden sie versioniert gespeichert und über die Sync-Endpunkte verteilt.
