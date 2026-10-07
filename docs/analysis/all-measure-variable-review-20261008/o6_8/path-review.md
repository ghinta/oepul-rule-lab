# o6_8: Pfade Luna / Opus

Verglichen werden vollständige Blattpfade, keine ähnlich klingenden Namen.
Gleiche Schreibweise oder gleiche Typnotation beweist weder dieselbe Definition noch denselben Rego-Konsum.
Modell-exklusive Pfade stehen vollständig im [Variablendiff](diff.md); sie werden nicht automatisch als Aliase zusammengeführt.

Luna-exklusive Blattpfade: 44; Opus-exklusive: 93; gemeinsame Schreibweisen: 1.

| Gemeinsamer Pfad | Luna-Notation danach | Opus-Notation danach | fachliche Zuordnung |
| --- | --- | --- | --- |
| `farm.oepul.first_participation_year` | `"int"` | `"int&#124;null"` | offen |

## Geänderte bestehende Definitionen

- opus: `land.parcels[].operations.tillage_type`: `"enum(plough&#124;reduced&#124;mulch&#124;no_till&#124;unknown)"` → `"enum(plough&#124;reduced&#124;mulch&#124;no_till&#124;strip_till&#124;unknown)"`. Bestehende Bedeutung nicht überschreiben.

## Technischer Konsum bleibt offen

- luna: 8 gespeicherte Scannerpfade; 2 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.
- opus: 1 gespeicherte Scannerpfade; 7 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.

Diese Zahlen messen keine Vollständigkeit. Multiline-Zugriffe, lokale Aliase, Helper und Adapter brauchen eigene Prüfung.
Vor Integration: bestätigte Fachdefinition → zugelassener App-Pfad → expliziter Adapter → tatsächlicher Rego-Zugriff → Grenzfalltest.

Offene Fachentscheidungen: [questions.md](questions.md). Alle ursprünglichen Modellannahmen: [model-notes.md](model-notes.md).
