# Verifikation

Geprüft am 11. Oktober 2026 mit Python 3.12.14 und dem Repository-Pin OPA 1.18.2
(Linux amd64, SHA-256 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`).

| Prüfung | Ergebnis |
|---|---|
| Repository-Unittests | 118 bestanden, einschließlich 29 Screening-Tests; keine übersprungen |
| Validator-Unittests | 11 bestanden |
| Neuer Strict-Compile der isolierten Luna-Bundles | 26/26 technisch erfolgreich |
| Gebundene synthetische Entwicklungsfälle | 78 ausgeführt: 76 definierte Ausgaben, 2 undefinierte Ausgaben, keine technischen Ausführungsfehler |
| Bytegleiche Wiederholung von JSON, CSV, Markdown und HTML | `python -m rulelab.screening verify` erfolgreich |
| Native Datennamespaces | Regressionstest vergleicht o6_18 direkt mit dem historischen Verzeichnisbundle; unabhängiger Gegencheck aller 21 Fälle o6_12–18 stimmt im vollständigen OPA-JSON überein |
| Quellen-/Variablenvertrag o6_3 | 46 Variablen, 17 Regeln, 46 Belege, 20 RGVE-Kategorien geprüft; 8 offene Gates bleiben offen |
| Unveränderte o6_3-Adaptation | OPA fmt/check/test erfolgreich, 3/3 OPA-Tests |
| Vorschau-/Matrixstruktur | Lokale HTML-Links auf vorhandene Dateien geprüft; CSV enthält 26 eindeutige Maßnahmen und 16 Spalten |
| Historische Dateien | Git-Diff für `runs/`, `sources/`, `profiles/`, `adaptations/` leer; gebundene Dateien vor/nach dem Screening identisch |

Die Screening-Tests prüfen veränderte oder fehlende Hashbindungen, unvollständige
Lauf-/Quellen-/Profil-/Runtime-Bindungen, unerlaubte Queries, Pfadausbrüche,
fehlend/null und verschiedene JSON-Typen, technische Fehlerklassifikation,
Modelltest-Ausschluss und native Verzeichnisladung. Sie enthalten keine
fachlichen Golden-Sollwerte für die historischen Luna-Ausgaben.

Der zusätzliche Review-Regressionsfall schützt die festen Berichtsspalten:
unbekannte, fehlende oder vertauschte Basisrollen werden vor der Ausführung
abgelehnt; die Basis mit optionalen Variations-/Fehlendatenproben bleibt erlaubt.
Die ursprünglichen 78 Eingaben und Ergebnisse bleiben bytegleich.

Die beiden undefinierten Ausgaben sind `o6_8/variation` und
`o6_17/missing_fact`. Sie bleiben als Befunde in der Matrix. Technischer
Prüferfolg hebt keine semantische Grenze aus [method.md](method.md) auf.

CI führt die Repository-/Validator-Tests, den o6_3-Vertrag, den gebundenen
Luna-Replay und die bestehenden Adaptationsprüfungen aus. Der genaue CI-Lauf
ist im verknüpften PR dem jeweiligen Commit zugeordnet.
