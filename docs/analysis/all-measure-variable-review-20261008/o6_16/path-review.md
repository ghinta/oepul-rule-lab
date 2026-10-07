# o6_16: Pfade Luna / Opus

Verglichen werden vollständige Blattpfade, keine ähnlich klingenden Namen.
Gleiche Schreibweise oder gleiche Typnotation beweist weder dieselbe Definition noch denselben Rego-Konsum.
Modell-exklusive Pfade stehen vollständig im [Variablendiff](diff.md); sie werden nicht automatisch als Aliase zusammengeführt.

Luna-exklusive Blattpfade: 61; Opus-exklusive: 111; gemeinsame Schreibweisen: 0.

| Gemeinsamer Pfad | Luna-Notation danach | Opus-Notation danach | fachliche Zuordnung |
| --- | --- | --- | --- |

## Geänderte bestehende Definitionen

- opus: `livestock.species_groups[].category`: `"string&#124;null"` → `"enum(rinder_unter_halbes_jahr&#124;rinder_halbes_bis_2_jahre&#124;rinder_ab_2_jahre&#124;zwergrinder_unter_halbes_jahr&#124;zwergrinder_halbes_bis_2_jahre&#124;zwergrinder_ab_2_jahre&#124;schafe_ab_1_jahr&#124;schafe_unter_1_jahr&#124;ziegen_ab_1_jahr&#124;ziegen_unter_1_jahr&#124;pferde_klein_fohlen_unter_halbes_jahr&#124;pferde_klein_jungtiere_halbes_bis_3_jahre&#124;pferde_klein_ab_3_jahre&#124;pferde_gross_fohlen_unter_halbes_jahr&#124;pferde_gross_jungtiere_halbes_bis_3_jahre&#124;pferde_gross_ab_3_jahre&#124;rotwild_ab_1_jahr&#124;damwild_zuchtwild_ab_1_jahr&#124;neuweltkamele_ab_1_jahr&#124;neuweltkamele_wild_unter_1_jahr&#124;ferkel_ab_8kg&#124;jung_mastschweine_ab_32kg&#124;zucht_jungsauen_ab_50kg)&#124;null"`. Bestehende Bedeutung nicht überschreiben.

## Technischer Konsum bleibt offen

- luna: 39 gespeicherte Scannerpfade; 0 beobachtete direkte object.get(input, …)-Zeilen; 71 Regelbedingungen ohne input_paths-Deklaration.
- opus: 4 gespeicherte Scannerpfade; 9 beobachtete direkte object.get(input, …)-Zeilen; 0 Regelbedingungen ohne input_paths-Deklaration.

Diese Zahlen messen keine Vollständigkeit. Multiline-Zugriffe, lokale Aliase, Helper und Adapter brauchen eigene Prüfung.
Vor Integration: bestätigte Fachdefinition → zugelassener App-Pfad → expliziter Adapter → tatsächlicher Rego-Zugriff → Grenzfalltest.

Offene Fachentscheidungen: [questions.md](questions.md). Alle ursprünglichen Modellannahmen: [model-notes.md](model-notes.md).
