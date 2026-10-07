# o6_1a: Pfade Luna / Opus

Verglichen werden vollständige Blattpfade, keine ähnlich klingenden Namen.
Gleiche Schreibweise oder gleiche Typnotation beweist weder dieselbe Definition noch denselben Rego-Konsum.
Modell-exklusive Pfade stehen vollständig im [Variablendiff](diff.md); sie werden nicht automatisch als Aliase zusammengeführt.

Luna-exklusive Blattpfade: 91; Opus-exklusive: 191; gemeinsame Schreibweisen: 0.

| Gemeinsamer Pfad | Luna-Notation danach | Opus-Notation danach | fachliche Zuordnung |
| --- | --- | --- | --- |

## Geänderte bestehende Definitionen

- opus: `land.parcels[].constraints.biodiversity_area.type`: `"enum(annual&#124;multi_year&#124;null)"` → `"enum(DIV&#124;DIVRS&#124;DIVSZ&#124;DIVNFZ&#124;DIVAGF&#124;null)"`. Bestehende Bedeutung nicht überschreiben.

## Technischer Konsum bleibt offen

- luna: 41 gespeicherte Scannerpfade; 0 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.
- opus: 0 gespeicherte Scannerpfade; 9 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.

Diese Zahlen messen keine Vollständigkeit. Multiline-Zugriffe, lokale Aliase, Helper und Adapter brauchen eigene Prüfung.
Vor Integration: bestätigte Fachdefinition → zugelassener App-Pfad → expliziter Adapter → tatsächlicher Rego-Zugriff → Grenzfalltest.

Offene Fachentscheidungen: [questions.md](questions.md). Alle ursprünglichen Modellannahmen: [model-notes.md](model-notes.md).
