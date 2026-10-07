# o6_5: Pfade Luna / Opus

Verglichen werden vollständige Blattpfade, keine ähnlich klingenden Namen.
Gleiche Schreibweise oder gleiche Typnotation beweist weder dieselbe Definition noch denselben Rego-Konsum.
Modell-exklusive Pfade stehen vollständig im [Variablendiff](diff.md); sie werden nicht automatisch als Aliase zusammengeführt.

Luna-exklusive Blattpfade: 50; Opus-exklusive: 62; gemeinsame Schreibweisen: 0.

| Gemeinsamer Pfad | Luna-Notation danach | Opus-Notation danach | fachliche Zuordnung |
| --- | --- | --- | --- |

## Geänderte bestehende Definitionen

Keine geänderten/entfernten Blattwerte im gespeicherten Profildiff. Implizite Umdeutungen bestehender Felder bleiben trotzdem prüfpflichtig.

## Technischer Konsum bleibt offen

- luna: 3 gespeicherte Scannerpfade; 0 beobachtete direkte object.get(input, …)-Zeilen; 54 Regelbedingungen ohne input_paths-Deklaration.
- opus: 2 gespeicherte Scannerpfade; 8 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.

Diese Zahlen messen keine Vollständigkeit. Multiline-Zugriffe, lokale Aliase, Helper und Adapter brauchen eigene Prüfung.
Vor Integration: bestätigte Fachdefinition → zugelassener App-Pfad → expliziter Adapter → tatsächlicher Rego-Zugriff → Grenzfalltest.

Offene Fachentscheidungen: [questions.md](questions.md). Alle ursprünglichen Modellannahmen: [model-notes.md](model-notes.md).
