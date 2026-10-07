# o6_13: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_13-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_13-luna-high-20261004/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.measure_application",
      "value_after": {
        "requested": false,
        "contract_year": 2026,
```

Ursprung: `runs/v2-o6_13-opus-5.5-high-20260926/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association_of_persons)",
```

### o6_13-STRUCTURE_PARCEL

Welche Beziehung zwischen Gewächshaus/Folientunnel und Schlag ist verbindlich? Muss jeder NUE-Schlag eigenen flächendeckenden Einsatz nachweisen?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_13-opus-5.5-high-20260926/workspace/notes/assumptions.md:7–16`

```text
1. **Flächendeckender Einsatz je Schlag vs. „zumindest ein Gewächshaus“.**
   Das Merkblatt (Kap. 1) gewährt die Prämie für Flächen, „auf denen flächendeckend
   Organismen eingesetzt werden“; SRL 2.13 und Merkblatt 4.1 verlangen den Einsatz
   „in zumindest einem Gewächshaus oder Folientunnel“. Umsetzung: Die Maßnahmenebene
   (Mindestteilnahme O6_13-ACC-02, Verpflichtung O6_13-OBL-01) prüft ≥ 1 Struktur; die
   Prämie je NUE-Schlag (O6_13-SCOPE-01) verlangt einen anrechenbaren, flächendeckenden
   Einsatz auf genau diesem Schlag. Ob ein NUE-Schlag ohne eigenen Einsatz prämienfähig
   ist, wenn ein anderes Gewächshaus des Betriebs die Bedingung erfüllt, bleibt offen.
2. **Flächendeckung** wird als boolesche Eingabe (`covers_entire_area`) modelliert; die
   Quellen definieren kein Mess-/Toleranzkriterium.
```

### o6_13-APPLICATION_EVIDENCE

Welche AGES-Version, Aufwandsmenge, PSM-Ersatz und datierten Anwendungen belegen den Nützlingseinsatz? Reicht ein repräsentatives Objekt oder braucht es mehrere Ereignisse?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_13-luna-high-20261004/workspace/notes/assumptions.md:3–4`

```text
- Die Quellen nennen keine abschließende Artenliste der zulässigen Organismen. Deshalb prüft Rego einen belegten Eintrag im AGES-Pflanzenschutzmittelregister und die dortige Aufwandsmenge als Eingabe, statt eine nicht belegte Artenliste zu erfinden.
- `organism_application` wird als schlagbezogenes repräsentatives Objekt modelliert. Für jeden beantragten Schlag muss mindestens ein vollständiger Eintrag vorliegen; die Quellen sagen nicht ausdrücklich, ob mehrere Anwendungen getrennt oder gesammelt aufgezeichnet werden müssen. Der Canonical-Profile-Vertrag erlaubt an dieser Stelle keinen Array-Container.
```

Ursprung: `runs/v2-o6_13-opus-5.5-high-20260926/workspace/notes/assumptions.md:17–19`

```text
3. **Anrechenbarkeit** (Registereintrag, Aufwandsmenge, Ersatz eines PSM-Einsatzes) wird
   als Eingabe erwartet; ein Abgleich mit dem AGES-Pflanzenschutzmittelregister ist nicht
   Teil der Quellen und nicht implementiert.
```

### o6_13-DROUGHT_SCOPE

Gilt die Dürre-Ernteausnahme 2026 tatsächlich für geschützten Anbau und wird die Gebietskulisse je Schlag statt Betriebssitz geprüft?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_13-opus-5.5-high-20260926/workspace/notes/assumptions.md:22–33`

```text
5. **Dürre 2026 (Ernteverpflichtung)**: Die Hinweise vom 05.08./12.08.2026 beziehen sich
   auf Ackerflächen und Ackerkulturen mit Ernte im Spätsommer/Herbst. Flächen im
   geschützten Anbau (A) sind Ackerland; ob die Ausnahme auf Gewächshauskulturen
   praktisch anwendbar ist, ist fraglich. Die Regel O6_13-DRT-01 greift nur, wenn die
   Eingaben `no_harvestable_crop_due_to_drought` und
   `crop_usually_harvested_late_summer_or_autumn` gesetzt sind. Die Gebietskulisse wird
   auf Betriebsebene (`farm.region`) geprüft, nicht je Schlag.
6. **Betriebsmindestgröße 1,50 ha**: `land.total_area_ha` wird als Fläche nach § 25 GSP-AV
   interpretiert; GA-, K20-, Landschaftselement-, Hecken- und Agroforstflächen werden über
   `land.minimum_size_additional_area_ha` addiert (Profilvorschlag). Die 0,50-ha-Schwelle
   für geschützten Anbau nutzt `land.protected_cultivation_area_ha`, ersatzweise die Summe
   der Schläge in Gewächshaus/Folientunnel.
```
