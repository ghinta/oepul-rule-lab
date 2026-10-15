# Verifikation der Diagnosevorbereitung

Die Prüfungen bestätigen reproduzierbare Entwicklungsbeobachtungen, keine
unabhängigen fachlichen Sollwerte oder Methodfreigabe.

| Prüfung | Beobachtetes Ergebnis |
|---|---|
| Unveränderlicher Veröffentlichungsstand | PR #79 `e009eed4a83ff076b26eba33ac433ac2b0642621`; 1.430 relevante Run-/Quellen-/Profildateien gegen veröffentlichte Gitblob-SHAs geprüft |
| Auswahl | 36 finalisierte Opus-Veröffentlichungen, genau 26 aktuelle Kandidaten und zehn ersetzte; Metadaten aller 36 gebunden |
| Fixture-/Übersetzungsverträge | 26 gültige Fixtures; alle 78 ursprünglichen Luna-Rollen mit Zuordnungen oder Lücken erfasst |
| Native isolierte Kompilierung | 26/26 `opa check --strict`, nur Policy und native Datennamespaces geladen |
| Tatsächliche Teilproben | 59 Ausführungen: 54 definierte Werte, fünf echte Laufzeitfehler; fünf explizite vollständige Fixture-Lücken |
| Opus bytegenaues Replay | `python -m rulelab.opus_screening verify --candidate-root /absolute/path/candidate-e009eed`: PASS für JSON/CSV/Markdown/HTML und alle Hashbindungen |
| Unveränderte Luna-Diagnose | Bestehendes Manifest/Fixtures/Reports unverändert; Replay liefert weiterhin 76 defined und zwei undefined aus 78 Fällen |
| Repository-Regressionen | 136 Tests PASS, einschließlich 18 neuer Integritäts-/Ausführungschecks; diese 18 nach finaler Codeänderung erneut PASS |
| Technischer Validator | Elf Regressionstests PASS |
| Quellen-/App-Vertragsdossier o6_3 | Integritätsprüfung PASS; bestehende acht fachliche Promotion-Blocker bleiben offen |
| Vier vorgeschlagene #56-Originale | Alle vier direkten PDF-Hashbindungen auch in den ausgewählten Opus-Quellensätzen identisch |
| Unabhängige methodische Prüfung | Alle 26 Übersetzungen geprüft; unbelegte o6_9-Einzelrecords entfernt, o6_12-Query auf belegte Verbots-/Flächenprobe begrenzt; abschließend PASS für Diagnosevorbereitung |
| Unabhängige Codeprüfung | Keine verbleibenden materiellen Befunde; beide Richtungen überlappender Report-/Kandidatenverzeichnisse werden abgelehnt |
| Historische Unverändertheit | Kein Diff unter Runs, Quellen, Profilen, Adaptationen oder eingefrorener Luna-Diagnose; Veröffentlichungskandidaten vor/nach hashgleich |
| Format | `git diff --check`: PASS |

Bei der Vorveröffentlichungsprüfung wurde der erste lokale Reportentwurf nach
der o6_9-Korrektur verworfen und unter `/tmp` als Reviewcheckpoint erhalten.
Das finale Manifest wurde erst auf den korrigierten Fixtures neu gebunden.
Keiner der verworfenen Entwurfsstände wurde committed oder veröffentlicht.
Die Bindungsprüfung lehnte die veränderte Eingabe unter dem alten Entwurf
erwartungsgemäß ab. Historische Modellartefakte waren davon nicht betroffen.

Finale SHA-256-Bindungen:

- Manifest: `575194a57dd09e52b52adc05de229abc7584414b32b5fadef36a9b83d4368f55`
- Native Matrix: `4d6c4e03254d414221897b80532e3634033d3b723faffd028c263358733e851c`
- Vergleichsmatrix: `61b7f7caf5b6fb539af4e1a03dc90660f7463ecb60f46f199de0062dda56a9dd`
- Ergebnisse: `2c300b3e1f614caab18538ab313c58b95d0bcbfee9d7449d9e3263d5b0717ba0`

CI ergänzt einen separaten Checkout des fest gebundenen Kandidatencommits,
prüft dessen tatsächlichen Git-HEAD und wiederholt denselben Reportvergleich.
Der konkrete remote CI-Lauf wird auf dem PR dokumentiert, nicht vorab behauptet.
Die vollständige Interventionsgeschichte, unabhängige Volltext-Coverage und
fachliche Referenzentscheidungen sind keine geprüften Eigenschaften dieser Diagnose.
