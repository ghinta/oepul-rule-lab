# o6_1c: Pfade Luna / Opus

Verglichen werden vollständige Blattpfade, keine ähnlich klingenden Namen.
Gleiche Schreibweise oder gleiche Typnotation beweist weder dieselbe Definition noch denselben Rego-Konsum.
Modell-exklusive Pfade stehen vollständig im [Variablendiff](diff.md); sie werden nicht automatisch als Aliase zusammengeführt.

Luna-exklusive Blattpfade: 60; Opus-exklusive: 86; gemeinsame Schreibweisen: 2.

| Gemeinsamer Pfad | Luna-Notation danach | Opus-Notation danach | fachliche Zuordnung |
| --- | --- | --- | --- |
| `farm.applicant.is_active_farmer` | `"boolean"` | `"boolean"` | offen |
| `land.parcels[].npa.sowing_date` | `"date&#124;null"` | `"date&#124;null"` | offen |

## Geänderte bestehende Definitionen

Keine geänderten/entfernten Blattwerte im gespeicherten Profildiff. Implizite Umdeutungen bestehender Felder bleiben trotzdem prüfpflichtig.

## Technischer Konsum bleibt offen

- luna: 8 gespeicherte Scannerpfade; 0 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.
- opus: 5 gespeicherte Scannerpfade; 8 beobachtete direkte object.get(input, …)-Zeilen; 11 Regelbedingungen ohne input_paths-Deklaration.

Diese Zahlen messen keine Vollständigkeit. Multiline-Zugriffe, lokale Aliase, Helper und Adapter brauchen eigene Prüfung.
Vor Integration: bestätigte Fachdefinition → zugelassener App-Pfad → expliziter Adapter → tatsächlicher Rego-Zugriff → Grenzfalltest.

Offene Fachentscheidungen: [questions.md](questions.md). Alle ursprünglichen Modellannahmen: [model-notes.md](model-notes.md).
