# o6_9: Pfade Luna / Opus

Verglichen werden vollständige Blattpfade, keine ähnlich klingenden Namen.
Gleiche Schreibweise oder gleiche Typnotation beweist weder dieselbe Definition noch denselben Rego-Konsum.
Modell-exklusive Pfade stehen vollständig im [Variablendiff](diff.md); sie werden nicht automatisch als Aliase zusammengeführt.

Luna-exklusive Blattpfade: 70; Opus-exklusive: 64; gemeinsame Schreibweisen: 0.

| Gemeinsamer Pfad | Luna-Notation danach | Opus-Notation danach | fachliche Zuordnung |
| --- | --- | --- | --- |

## Geänderte bestehende Definitionen

- opus: `livestock.species_groups[].manure.application_technology`: `"enum(broadcast&#124;trailing_hose&#124;trailing_shoe&#124;injection&#124;incorporation&#124;unknown)"` → `"enum(broadcast&#124;trailing_hose&#124;trailing_shoe&#124;injection&#124;incorporation&#124;swivel_distributor&#124;impact_plate_boom&#124;unknown)"`. Bestehende Bedeutung nicht überschreiben.

## Technischer Konsum bleibt offen

- luna: 31 gespeicherte Scannerpfade; 0 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.
- opus: 9 gespeicherte Scannerpfade; 9 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.

Diese Zahlen messen keine Vollständigkeit. Multiline-Zugriffe, lokale Aliase, Helper und Adapter brauchen eigene Prüfung.
Vor Integration: bestätigte Fachdefinition → zugelassener App-Pfad → expliziter Adapter → tatsächlicher Rego-Zugriff → Grenzfalltest.

Offene Fachentscheidungen: [questions.md](questions.md). Alle ursprünglichen Modellannahmen: [model-notes.md](model-notes.md).
