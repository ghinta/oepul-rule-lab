# Verifikation

Lokal am 08.10.2026 mit Python 3.11 und OPA 1.18.2:

- 102 Repository-Tests bestanden, einschließlich fünf neuer BIO-Prüfungen.
- 11 technische Validator-Tests bestanden.
- Dossierprüfung: alle 287 Blattpfade, elf verpflichtende offene Expertenfragen,
  235 wörtliche Belege direkt in Original-PDF/HTML; historische Dateien hashgleich.
- Acht OPA-Beobachtungen mit synthetischen Eingaben reproduziert. Sie halten
  bekannte historische Fehlprüfungen fest, nicht gewünschtes Förderverhalten.
- App-Hashes und zeilengebundene Auszüge mit `git show` am festgehaltenen
  App-Commit verglichen; keine echten Betriebs-/Snapshotdaten verwendet.
- 26-Maßnahmen-Vorinventar und vorhandener o6_3-Vertrag unverändert valide;
  o6_3 OPA-Format/Strict-Compile/Test bestanden, 3/3 zusätzliche OPA-Tests.
- `git diff --check` bestanden.

Die GitHub-CI muss den veröffentlichten PR-Stand separat bestätigen. Grüne
Checks beweisen hier technische Integrität und Reproduzierbarkeit, keine
fachliche Zulassung, vollständige Regelabdeckung oder abgeschlossene Prüfung
der anderen Maßnahmen. App-End-to-End-Tests sind nicht Teil dieser Dokumentations-
und Analyseänderung; die App und ihre registrierten Variablen bleiben unverändert.
