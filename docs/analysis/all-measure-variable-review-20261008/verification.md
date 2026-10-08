# Verification

Geprüfter Stand: dieser Branch gegen Lab main 7a296d2 und App main 5296108.

- 26 Maßnahmen, 52 finalisierte Run-IDs; 129 offene Fragegruppen.
- 1.397 gepinnte Eingabedateien mit SHA-256; App-Snapshot gegen `git show` geprüft.
- Run-Profildiffs vollständig neu berechnet; keine direkten Baseline-Änderungen.
- Blattpfade/Elternvorschläge mit existierenden Regel- und Quellen-IDs verbunden.
- 97 Repository-Tests bestanden (89 bestehende + 8 neue Testmethoden mit Negativfällen).
- 11 Validator-Regressionstests bestanden.
- Heuwirtschaft-Dossier: 46 Variablen, 17 Regeln, 46 Belege, 20 RGVE-Kategorien,
  acht weiterhin offene Promotionsblocker; kein Promotionsstatus geändert.
- OPA 1.18.2: Format/strikte Kompilierung/Tests bestanden; direkte OPA-Guards 3/3.
- `git diff --check` bestanden.

Die Prüfungen validieren Inventar, Herkunft, Reproduzierbarkeit und offene Zustände.
Statuskorrektur 08.10.2026: Eine Modellnotizen-Durchsicht und dieses Vorinventar
entsprechen nicht der Prüftiefe des einzelnen o6_1a-Dossiers. Die früher als
erledigt gemeldeten 25 Einzelprüfungen waren damit nicht erfolgt. Ausschließlich
o6_1b wurde danach im [eigenen Slice](../o6_1b-variable-review-20261008/README.md)
vertieft; die weiteren 24 bleiben ausstehend.
Sie bestätigen keine fachliche Modellqualität, vollständigen Rego-/Adapter-Konsum,
aktuelle gesetzliche Anwendbarkeit oder produktive Empfehlungen aller Maßnahmen.
Kein neuer Modelllauf, keine App-Implementierung, keine Golden-/Hidden-Testbewertung.
Die 129 Gruppen priorisieren die Expertenklärung; alle weiteren Modellannahmen
bleiben in den vollständigen Modellnotizen sichtbar und unbestätigt.
CI-Ergebnis für den veröffentlichten Commit wird in der PR dokumentiert.
