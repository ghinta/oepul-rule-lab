# o6_7: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_7-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_7-luna-high-20261002/workspace/rules/profile_changes.json:6–9`

```text
    {"action":"add","path":"farm.oepul","value_after":{"participating":false,"measure_6_participating":false,"application_submitted":false,"application_date":"date|null","withdrawn":false,"first_participation":false,"switch_requested":false,"drought_2026":{"proper_establishment":false,"field_emergence_full_cover":true,"volunteer_cereal_share_percent":0,"credible_forward_management":false,"planting_conditions_unavailable":false,"drought_no_harvestable_stand":false}},"rationale":"Das Canonical Farm Profile enthält keine Teilnahme-, Antrag-, Konkurrenzmaßnahmen- oder 2026-Ausnahmefelder für die einjährige Maßnahme.","rule_ids":["O6_7_CONTRACT_YEAR","O6_7_APPLICATION_DEADLINE","O6_7_MEASURE_6_CONFLICT","O6_7_WITHDRAWAL","O6_7_MEASURE_SWITCH","O6_7_DROUGHT_COVER_2026","O6_7_DROUGHT_DEADLINE_2026","O6_7_DROUGHT_HARVEST_2026"],"source_reference_ids":["INFO_P1","INFO_P9","GEN_P18","D2026_AUG5","D2026_AUG12"]},
    {"action":"add","path":"measure","value_after":{"o6_7":{"participating":false,"cover_share_percent":"number","harvest_share_percent":"number","proper_establishment":false,"field_emergence_full_cover":true,"volunteer_cereal_share_percent":0,"credible_forward_management":false,"planting_conditions_unavailable":false,"drought_no_harvestable_stand":false,"measure_6_participating":false,"application_submitted":false}},"rationale":"Die Regelbedingungen und die ausführbare Policy verwenden maßnahmenspezifische Teilnahme-, Quoten- und 2026-Ausnahmefelder unter measure.o6_7.","rule_ids":["O6_7_COVER_SHARE","O6_7_GENERAL_MIN_CARE","O6_7_MEASURE_6_CONFLICT","O6_7_DROUGHT_COVER_2026","O6_7_DROUGHT_DEADLINE_2026","O6_7_DROUGHT_HARVEST_2026"],"source_reference_ids":["M57_COVER","MAIN_GENERAL_MIN_CRIT","GEN_P18","D2026_AUG5","D2026_AUG12"]},
    {"action":"add","path":"farm.region.country","value_after":"string","rationale":"Die allgemeine Lagevoraussetzung verlangt die Unterscheidung österreichischer und ausländischer Flächen.","rule_ids":["O6_7_GENERAL_LOCATION"],"source_reference_ids":["GEN_P9"]},
    {"action":"add","path":"land.parcels[].crop.sequence","value_after":{"previous_crop":"string|null","next_crop":"string|null","is_main_crop":true,"is_intercrop":false,"is_volunteer":false,"is_threshing_loss":false},"rationale":"Die Kulturfolge und die Abgrenzung von Hauptfrucht, Zwischenfrucht, Ausfall und Druschausfall sind für die Einstufung erforderlich.","rule_ids":["O6_7_INTERCROP_DEFINITION","O6_7_INVALID_INTERCROP","O6_7_MAIN_CROPS_APPLICATION","O6_7_NO_THRESHING"],"source_reference_ids":["M57_DEFS","INFO_P2","INFO_P8","INFO_P9"]},
```

Ursprung: `runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "farm.applicant",
      "value_before": null,
      "value_after": {
        "legal_form": "enum(natural_person|registered_partnership|legal_person|association|territorial_authority)",
```

### o6_7-TIMELINE

Welche datierten Begrünungsabschnitte einschließlich Vorjahr sind erforderlich? Wie zählen Lücken, ungültige Zwischenfrüchte und Zug-um-Zug-Wechsel?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_7-opus-5.5-high-20260925/workspace/notes/assumptions.md:7–11`

```text
- Das Canonical Farm Profile enthält nur einen Zeitpunkt `operations.cover_crop.sowing_date`.
  Für die tagesgenaue 85 %-Prüfung wird je Ackerschlag eine chronologische Liste von
  Begrünungsabschnitten (`land.parcels[].greening.segments[]`) vorausgesetzt (Vorschlag in
  `rules/profile_changes.json`). Abschnitte des Vorjahres (z. B. Winterweizen ab Herbst) müssen
  mitgeliefert werden, sonst gelten die Tage ab 1. Jänner bis zur ersten Kultur als unbegrünt.
```

### o6_7-LATE_SEED

Welche Mindestpartnerzahl und Winterhärte gelten nach 20.09. und im ersten Vertragsjahr? Wie wird ein noch offenes Jahresende behandelt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_7-opus-5.5-high-20260925/workspace/notes/assumptions.md:31–42`

```text
5. **Offene Lücke am Jahresende** (Ernte ohne erfasste Folgekultur): Tage innerhalb der
   höchstzulässigen Frist (50 Tage nach Hauptfrucht, 30 Tage nach Zwischenfrucht) gelten
   vorläufig als begrünt, danach als unbegrünt.
6. **Winterhärte nach dem 20. September:** vor 2025 `frost_killed_share == 0`; ab dem
   Antragsjahr (= Jahr der Anlage) 2025 `frost_killed_share < 0.5`. Nach dem 20. September
   gilt keine Mindestzahl an Mischungspartnern (Reinsaat zulässig). Die SRL formuliert die
   3-Partner-Regel ohne Datumsbezug; das Merkblatt knüpft sie an die Anlage bis 20.09. –
   umgesetzt wurde die Merkblatt-Lesart.
7. **Ersteinstieg:** Für Zwischenfrüchte, die vor dem 1. Jänner des ersten Vertragsjahres
   angelegt wurden, werden die Termine 20.09./15.10. nicht geprüft; die Mischung muss
   entweder die 3-Partner/2-Familien-Regel oder die Winterhärte-Regel erfüllen. Die
   15.02.-Umbruchsperre und 42 Tage werden weiterhin geprüft.
```

### o6_7-NITRATE_ROLLING

Welches kultur-/regionsbezogene NAPV-Enddatum ist verbindlich? Was bedeutet unmittelbar beim Walzen und welche Frost-Ausnahme gilt?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_7-opus-5.5-high-20260925/workspace/notes/assumptions.md:43–52`

```text
8. **Ende des Mineral-N-Verbots:** Das Ende des Verbotszeitraums nach
   Nitrat-Aktionsprogramm-Verordnung ist in den Quellen nicht datiert; es wird als
   Eingabe `nitrate_ban_end_date` erwartet. Fehlt es, wird das Umbruchsdatum verwendet
   (Untergrenze) bzw. bei offenem Abschnitt jede Düngung ab Anlage als Verstoß gewertet.
9. **Walzen:** Rückverfestigungswalzen gilt bis 1 Tag nach Anlage als „unmittelbar“
   (Parameter `reconsolidation_rolling_max_days_after_sowing`). Späteres Walzen ist bei
   überwinternden Zwischenfrüchten erst nach dem 31.10. und nur bei Erhalt der
   flächendeckenden Begrünung zulässig (Merkblatt 2025-10 S. 6/7 und SRL 2.7 lit. e
   zusammen gelesen; der Merkblatt-Satz „Für den restlichen Begrünungszeitraum ist Walzen
   nicht erlaubt“ steht im Spannungsverhältnis zu „Walzen – z. B. bei Frost – ist möglich“).
```

### o6_7-PAYMENT_EXIT

Welche NAT-/EBW-/Grünbracheflächen erhalten Prämie und zählen zur 85-%-Basis? Welches Folgejahr ist für ES-Acker nach Abmeldung gemeint?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_7-opus-5.5-high-20260925/workspace/notes/assumptions.md:55–71`

```text
11. **ES-Acker-Sperre nach Abmeldung:** umgesetzt als Verstoß, wenn die Abmeldung im
    Bewertungsjahr erfolgt und der Betrieb im selben Jahr die ES-Acker-Option
    Mulch/Direkt/Strip-Till beantragt und nicht an Maßnahme 6 teilnimmt. Das Merkblatt
    spricht vom „Folgejahr“ ohne klaren Bezugspunkt (Jahr der Begrünung vs. Jahr der
    Abmeldung).
12. **Flächenhinzunahmen nach dem 15. Oktober:** Ausgeschlossen werden unbegrünt übernommene
    Schläge mit Übernahmedatum nach dem 15.10. des Bewertungsjahres; ob die Hinzunahme
    ursächlich für die Überschreitung ist, wird nicht zusätzlich geprüft.
13. **Prämienfähigkeit auf Einzelflächen (Anhang L):** Schläge, die zusätzlich in nicht
    kombinierbaren Maßnahmen liegen (z. B. 18 Naturschutz, 19 EBW, 1C, 17, 23) oder K20
    tragen, erhalten keine Immergrün-Prämie, zählen aber zur 85 %-Ausgangsfläche.
    Grünbrachen (nicht aktiv bewirtschaftet) erhalten keine Prämie, außer als
    Biodiversitätsfläche (`DIV`) von UBB/BIO. Diese Auslegung ist durch die Quellen nicht
    explizit für System Immergrün bestätigt.
14. **Prämiensatz:** Der tatsächliche Satz im Band 70–90 €/ha wird von der AMA jährlich
    festgelegt; ohne Eingabe wird der garantierte Mindestbetrag 70 €/ha verwendet. Die
    Modulation wird auf die gesamte Betriebsfläche (`land.total_area_ha`) angewendet.
```
