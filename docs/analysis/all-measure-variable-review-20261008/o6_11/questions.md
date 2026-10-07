# o6_11: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_11-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_11-luna-20260920/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.oepul",
      "value_after": {
        "o6_11_application_year": 2025,
        "o6_11_contract_start_year": 2025,
```

Ursprung: `runs/v2-o6_11-opus-5.5-high-20261001/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association)",
```

### o6_11-NONPREMIUM_FRUIT

Fallen Walnüsse/Edelkastanien und sonstige Weinflächen trotz fehlender Prämie unter das Verbot und/oder die Mindestteilnahme? Luna und Opus grenzen dies unterschiedlich ab.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_11-opus-5.5-high-20261001/workspace/notes/assumptions.md:9–12`

```text
1. **Nutzungsart-Ableitung.** Fehlt `crop.usage_type`, wird aus `crop_category` abgeleitet: `vineyard → wine`, `orchard → fruit`, `hop → hop`. Ist `crop_name` bei Obst `null`, wird der Schlag als Obstfläche behandelt; ist eine Art angegeben, muss sie in der Obstliste stehen.
2. **Schnittweingärten** erhalten den Weinprämiensatz („zählen zur Weinfläche“). Ausdrücklich ist nur die Anrechnung zur Weinfläche und der Herbizidverzicht geregelt.
3. **Sonstige Weinflächen** unterliegen konservativ dem Herbizidverzicht (gesamte Weinfläche des Betriebes), zählen aber nicht zur Mindestteilnahmefläche (nicht förderfähig). **Rebschulen** unterliegen nicht dem Verzicht (keine Weinfläche). **Walnüsse/Edelkastanien** bleiben Obstflächen mit Verzichtspflicht, erhalten aber keine Prämie. Offen: Ob nicht prämienfähige Flächen tatsächlich unter den Verzicht fallen.
4. **Unveredelte Obstanlagen** (Code OP) bleiben ebenfalls Obstflächen mit Verzichtspflicht.
```

### o6_11-AGES

Welcher versionierte AGES-Wirkungstyp gilt für Anwendungen, Kauf und Lagerung? Wie werden Zielkultur, plausible Menge und Dokumentation geprüft?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_11-opus-5.5-high-20261001/workspace/notes/assumptions.md:13–16`

```text
5. **Wirkungstyp.** Herbizid = `effect_type == "herbicide"` gemäß AGES-Register. Die Registerabfrage selbst ist nicht abgebildet; die Einstufung muss im Input vorliegen. Auch biologisch zugelassene Mittel mit Wirkungstyp Herbizid gelten als Verstoß.
6. **Ameisensäure** wird unabhängig von der Kultur als Verstoß gewertet („generell in der Feldproduktion nicht zulässig“), auch bei Kauf/Lagerung.
7. **Kauf/Lagerung.** Ausnahme nur, wenn die Zielkultur (`intended_crop_category`) auf einem Schlag ohne Herbizidverzicht angebaut wird **und** Aufzeichnungen vorliegen **und** die Menge als plausibel markiert ist. Die Plausibilitätsbeurteilung selbst (Menge vs. Fläche) wird nicht berechnet.
8. **PSM-Codierung (bis 2025).** Geprüft werden nur flächige Anwendungen (`is_area_wide`) im Antragsjahr auf Schlägen der Maßnahme. Ein gesetztes PSMCS erfüllt auch die PSMBIO-Pflicht. Die zeitliche Pflicht zur Streichung/Nachtragung (O611-PSM-CODE-ADVANCE) ist nur katalogisiert.
```

### o6_11-PARTICIPATION_MISSING

Wie wird die tatsächliche Schlagbeantragung nachgewiesen? Der Opus-Default beantragt alle Schläge ohne Maßnahmenliste; welche nationalparkbezogenen Auflagen sind relevant?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_11-opus-5.5-high-20261001/workspace/notes/assumptions.md:24–25`

```text
16. **Schläge ohne `oepul.measures`** gelten als für Maßnahme 11 beantragt (Default), damit Profile ohne MFA-Schlagdaten auswertbar bleiben.
17. **Nationalparks.** Namen werden gegen eine Liste (`Neusiedler See`, `Neusiedlersee`, `Neusiedler See - Seewinkel`, `Donau-Auen`) abgeglichen; in anderen Nationalparks wird die Prämie gewährt (AT 5.5.1). Die SRL-Formulierung „keine relevanten Bewirtschaftungsauflagen“ wird nicht separat bewertet.
```
