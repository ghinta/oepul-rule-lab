# Warum dieser Abschluss

Der veröffentlichte Run war trotz erfolgreicher historischer Prüfberichte
als `generated` gespeichert. Das durch `.gitignore` ausgeschlossene
Original-Generatorlog fehlte in frischen Checkouts; außerdem verwies das
Inventar noch auf einen älteren Stand der Belegdatei.

PR #95 stellt das unveränderte Log bereit: 24.670 Bytes, 11 valide
JSONL-Ereignisse, SHA-256
`c3c943a1a2b7164f6b1f3ae899b2c5db8a36543f9e14c1cfd990b589907a8f1d`.
Die Quellen wurden anhand der in `run.json` gespeicherten Hashes aus dem
Quellenpack wiederhergestellt. Der reguläre Finalizer hat danach den Status,
die Metriken und das Inventar neu geschrieben.

## Verifikation

- `rulelab finalize`: Exit-Code 0, keine fehlenden Pflichtartefakte.
- Grounding und sämtliche Vertragsprüfungen: keine Fehler.
- OPA 1.18.2: Formatierung, strikte Prüfung und alle 5 Tests bestanden.
- Originalprofil unverändert; keine unbekannten Eingabepfade.
- 29 Regeln, 35 Quellenbelege, 42 Coverage-Einträge, 23 Profilvorschläge.
- Explorer-Zeile gegen die finalisierten Metriken geprüft; keine Änderung nötig.
- Regeln, Belege, Daten, Tests und Generation-Metadaten unverändert.

Die Validierung lief lokal unter Linux; `technical-validation.json` hält
diese Umgebung fest. `run.json.opa_runtime` beschreibt weiterhin die
ursprüngliche Modellgenerierung auf macOS. Es gab keinen neuen Modelllauf.
Dieser technische Abschluss ist keine fachliche Freigabe und kein Golden-Test.

Abhängigkeit: zuerst PR #95 mergen, anschließend den Finalisierungs-PR.
