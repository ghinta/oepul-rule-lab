# Verification · 08.10.2026

- 52 wörtliche Belege an den angegebenen lokalen Original-PDF-Seiten geprüft;
  SHA-256 der jeweiligen Quelldatei in evidence.json erfasst. Bei layoutbedingt
  getrennten Wörtern wurde der tatsächliche Extraktionstext erhalten.
- BAW-Originalbeispiel und WRRL-gewichtetes Beispiel exakt mit Decimal
  nachgerechnet. Die WRRL-Rundung bleibt offen.
- Alle 289 bestehenden Aufnahmefragen der 25 Dossiers weiterhin mit
  `open_before_app_admission` und `answer: null`; keine Frage-Datei geändert.
- Bestehender Inventarvalidator `tools/review_all_measure_variables.py`
  bestanden: die gepinnten 26 Maßnahmen / 52 Runs / ursprünglichen
  offenen Fragegruppen bleiben erhalten.
- Aktuelle Onlinefassungen nur gezielt geprüft. Keine lokalen Bytes,
  Prüfsummen oder vollständige Erfassung dieser Fassungen behauptet.
- Dokumentationsänderung: keine neue App-/Policy-Funktion, keine neuen
  Golden-Tests oder Modell-Runs. Originalquellen, Canonical Farm Profile,
  historische Run-Artefakte und Thesis bleiben unverändert.

`git diff --check` wurde vor Veröffentlichung geprüft.
Die reguläre PR-CI prüft zusätzlich die unveränderten vorhandenen
Repository-/Validator-/OPA-Checks am neuen Commit; ihr Ergebnis steht im
PR und im Recherche-Subtask.
