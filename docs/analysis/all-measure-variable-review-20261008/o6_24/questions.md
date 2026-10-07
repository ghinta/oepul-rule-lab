# o6_24: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_24-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_24-luna-high-20261005/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"land.parcels[].constraints.is_wrrl_area","value_after":"boolean","rationale":"Die WRRL-Gebietskulisse wird schlagbezogen über das INVEKOS-GIS ermittelt und ist im Canonical Farm Profile nicht vorhanden.","rule_ids":["O624-AREA-001","O624-SCOPE-001"],"source_reference_ids":["O624-P1-SCOPE","O624-P2-GIS"]},
    {"action":"add","path":"land.parcels[].constraints.wrrl_higher_n_authorization","value_after":"boolean","rationale":"Eine Bewilligung zu erhöhten Stickstoffdüngergaben schließt die Fläche von der Prämie aus.","rule_ids":["O624-ELIG-002"],"source_reference_ids":["O624-P3-OPWRRL","O624-P4-NOPREM"]},
    {"action":"add","path":"land.parcels[].constraints.wrrl_fertilizer_class","value_after":"string|null","rationale":"Für die zulässige jahreswirksame Stickstoffmenge wird die Düngeklasse benötigt; nicht zugeordnete Flächen sind Klasse C.","rule_ids":["O624-N-CLASS-001","O624-N-CLASS-002"],"source_reference_ids":["O624-P2-NLIMIT","O624-P2-CLASSC"]},
    {"action":"add","path":"land.parcels[].operations.fertilizer.annual_effective_n_kg_per_ha","value_after":"number|null","rationale":"Die tatsächlich ausgebrachte jahreswirksame Stickstoffmenge muss gegen die klassenbezogene Obergrenze geprüft werden.","rule_ids":["O624-N-CLASS-001"],"source_reference_ids":["O624-P2-NLIMIT"]},
```

Ursprung: `runs/v2-o6_24-opus-5.5-high-20260928/workspace/rules/profile_changes.json:8–11`

```text
      "path": "land.parcels[].wrrl_o6_24",
      "value_before": null,
      "value_after": {
        "in_area": "boolean",
```

### o6_24-EXTERNAL_REGULATION

Welche aktuelle steirische Verordnung/GIS-Version einschließlich Anlagen 2B/3 liefert Düngeklassen, N-Obergrenzen und Ausbringungszeiträume? Beispielwerte dürfen keine vollständige Tabelle ersetzen.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_24-opus-5.5-high-20260928/workspace/notes/assumptions.md:7–22`

```text
- **Grundwasserschutzprogramm Graz bis Bad Radkersburg 2018 (LGBl. Nr. 24/2018 idF LGBl. Nr. 70/2020) fehlt im Quellpaket.**
  Die eigentlichen Förderverpflichtungen verweisen auf § 4, § 5, Anlage 2B (Düngeklasseneinstufung) und
  Anlage 3 Punkt 1–3 (N-Obergrenzen je Kultur/Klasse, Ausbringungszeiträume). Folgen:
  - Die Düngeobergrenzen werden je Schlag-Teilfläche als Eingabe erwartet
    (`land.parcels[].wrrl_o6_24.duengeklassen[].n_limit_kg_per_ha`). Vollständig belegt sind nur die
    zwei Beispielwerte des Informationsblattes (Winterweichweizen D = 144 kg, B = 108 kg) in
    `data/o6_24/duengeklassen.json`; sie dienen als Fallback, wenn keine Obergrenze geliefert wird.
  - Fehlt eine Obergrenze, gibt es keine Aussage zur Einhaltung, sondern einen Eintrag in `missing_inputs`.
  - Die Einhaltung der Ausbringungszeiträume (Anlage 3 Punkt 3) wird als boolesche Eingabe
    `n_application_periods_compliant` erwartet; die Sperrfristen selbst sind nicht abbildbar.
  - Inhalt und Form des Betriebsbuchs nach § 5 sind nicht abbildbar; geprüft wird nur, ob für jeden
    Schlag Aufzeichnungen vorliegen und das Betriebsbuch am Betrieb aufbewahrt wird.
- § 6 GSP-AV (höhere Gewalt), §§ 42–47 GSP-AV (Flächenabweichungen), § 16 GSP-AV (Aufbewahrung) und
  § 48 GSP-AV (Sanktionsbemessung) sind ebenfalls nicht im Paket. Abweichungssanktionen sind im Coverage-Ledger
  als `unresolved` markiert. Die Stufe der inhaltlichen Kürzung wird als Eingabe `participation.o6_24.sanction_step`
  erwartet, weil Schwere, Ausmaß, Dauer und Häufigkeit nicht aus den Quellen berechenbar sind.
```

### o6_24-EFFECTIVE_N_ROUNDING

Wie wird jahreswirksamer organischer N berechnet und die gewichtete Grenze gerundet: 133 oder 133,2 kg? Welche Faktorquelle ist verbindlich?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_24-opus-5.5-high-20260928/workspace/notes/assumptions.md:26–31`

```text
1. **Jahreswirksame N-Menge**: Liegt `annual_effective_n_kg_per_ha` vor, wird dieser Wert verwendet; sonst
   die Summe aus `mineral_n_kg_per_ha` und `organic_n_kg_per_ha`. Das ist eine Näherung, weil die
   Anrechnung der Jahreswirksamkeit organischer Dünger in der (fehlenden) Verordnung geregelt ist.
2. **Gewichtetes Mittel**: Es wird ungerundet gerechnet (Beispiel 144 × 0,70 + 108 × 0,30 = 133,2 kg).
   Das Informationsblatt nennt „133 kg“. Ob auf ganze kg abgerundet wird, ist offen; die Regel meldet
   133,2 kg (auf 2 Dezimalstellen gerundet).
```

### o6_24-AREA_SCOPE

Zählen Brachen und Flächen mit erhöhtem N-Bewilligungswert zur 2-ha-Mindestfläche, zu Pflichten und Betriebsbuch? Welche Auflagen gelten je Teilfläche?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_24-opus-5.5-high-20260928/workspace/notes/assumptions.md:32–45`

```text
3. **Mindestteilnahme 2,00 ha**: Gezählt wird jede Ackerfläche (`land_use = arable`) in der Gebietskulisse,
   auch Brachen und Flächen mit Bewilligung zu erhöhten N-Gaben, weil die Quelle von „bewirtschafteter
   Ackerfläche in der Gebietskulisse“ spricht und nicht von prämienfähiger Fläche. Eine strengere Auslegung
   (nur prämienfähige Fläche) ist möglich.
4. **Brachflächen**: Nur die Sonderrichtlinie (2.24.5) schließt Brachflächen aus und verlangt eine Codierung.
   Das Informationsblatt erwähnt Brachen nicht. Die Rego-Regeln folgen der Sonderrichtlinie
   (nicht förderfähig, OPWRRL-Codierung verlangt).
5. **Anwendungsbereich der Förderverpflichtungen**: Die N-Obergrenzen und Ausbringungszeiträume werden auf
   die für 24 beantragten Ackerflächen im Gebiet ohne Bewilligung und ohne Brache angewendet
   (`obligation_parcels`). Betriebsbuch-Aufzeichnungen werden für alle beantragten Ackerschläge im Gebiet verlangt.
6. **Verstöße gegen Förderverpflichtungen** führen nicht automatisch zum Prämienverlust; sie werden als
   `violations` ausgegeben. Die Kürzung ergibt sich erst über `sanction_step`. Ausnahmen sind Mindestbewirtschaftung,
   Codierpflichten, Leistungsüberschneidung und Kombinationskonflikte: Sie machen den Schlag nach
   SRL 1.6.2.1, AT 5.5.2 bzw. Anhang L nicht prämienfähig.
```
