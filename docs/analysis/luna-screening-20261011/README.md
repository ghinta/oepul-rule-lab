# Luna: diagnostische Sichtung der vorhandenen Regelkandidaten

Synthetische Entwicklungsfälle auf unveränderten historischen Luna-Artefakten. Die beobachteten Ausgaben sind keine unabhängig beurteilten Sollwerte, keine Genauigkeitsmessung und kein Nachweis der Quellkorrektheit. Es erfolgt keine Übernahme oder Förderfreigabe in der App.

App-Issue #140 blockiert nur fachliche Sollurteile, die eine noch offene Auslegung benötigen. Technische Ausführung und dokumentierte Ausgabelücken können unabhängig davon untersucht werden.

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

Die native Ausgabe bleibt unverändert. `eligible` und ähnliche Felder haben je Kandidat unterschiedliche Bedeutungen; die Details stehen unten. `undefined` ist ein dokumentierter Befund. Eine definierte Ausgabe kann auch den JSON-Wert `null` enthalten; dieser unterscheidet sich von keinem Wert.

[Befunde und nächste Entscheidung](findings.md) · [Aufklappbare Vorschau](index.html) · [Manifest](manifest.json) · [Alle Ergebnisse](results.json) · [Matrix als CSV](matrix.csv) · [Fixierung und Wiederholung](method.md)

Basiscommit: `7a296d28cb5b92e2758c5a3889c929ea1db60fe5`. OPA: `1.18.2`. Policy und Daten werden je Run getrennt geladen; es erfolgt keine neue Modellgenerierung.

## Ausführungsübersicht

| Maßnahme | Run | Kompilierung | Basis | Variation | Fehlende Tatsache |
|---|---|---|---|---|---|
| [o6_1a](results/o6_1a.json) | `v2-o6_1a-luna-high-20260930` | compiled | defined | defined | defined |
| [o6_1b](results/o6_1b.json) | `v2-o6_1b-luna-high-20260930` | compiled | defined | defined | defined |
| [o6_1c](results/o6_1c.json) | `v2-o6_1c-luna-high-20260930` | compiled | defined | defined | defined |
| [o6_2](results/o6_2.json) | `v2-o6_2-luna-high-20260930` | compiled | defined | defined | defined |
| [o6_3](results/o6_3.json) | `v2-o6_3-luna-high-20261001` | compiled | defined | defined | defined |
| [o6_4](results/o6_4.json) | `v2-o6_4-luna-high-20261001` | compiled | defined | defined | defined |
| [o6_5](results/o6_5.json) | `v2-o6_5-luna-high-20261002` | compiled | defined | defined | defined |
| [o6_6](results/o6_6.json) | `v2-o6_6-luna-high-20261002` | compiled | defined | defined | defined |
| [o6_7](results/o6_7.json) | `v2-o6_7-luna-high-20261002` | compiled | defined | defined | defined |
| [o6_8](results/o6_8.json) | `v2-o6_8-luna-high-20261002` | compiled | defined | undefined | defined |
| [o6_9](results/o6_9.json) | `v2-o6_9-luna-high-20261002` | compiled | defined | defined | defined |
| [o6_10](results/o6_10.json) | `v2-o6_10-luna-high-20261003` | compiled | defined | defined | defined |
| [o6_11](results/o6_11.json) | `v2-o6_11-luna-20260920` | compiled | defined | defined | defined |
| [o6_12](results/o6_12.json) | `v2-o6_12-luna-high-20261003` | compiled | defined | defined | defined |
| [o6_13](results/o6_13.json) | `v2-o6_13-luna-high-20261004` | compiled | defined | defined | defined |
| [o6_14](results/o6_14.json) | `v2-o6_14-luna-high-20261004` | compiled | defined | defined | defined |
| [o6_15](results/o6_15.json) | `v2-o6_15-luna-high-20261004` | compiled | defined | defined | defined |
| [o6_16](results/o6_16.json) | `v2-o6_16-luna-high-20261005` | compiled | defined | defined | defined |
| [o6_17](results/o6_17.json) | `v2-o6_17-luna-high-20261005` | compiled | defined | defined | undefined |
| [o6_18](results/o6_18.json) | `v2-o6_18-luna-high-20261005` | compiled | defined | defined | defined |
| [o6_19](results/o6_19.json) | `v2-o6_19-luna-high-20261005` | compiled | defined | defined | defined |
| [o6_20](results/o6_20.json) | `v2-o6_20-luna-high-20261005` | compiled | defined | defined | defined |
| [o6_21](results/o6_21.json) | `v2-o6_21-luna-high-20261005` | compiled | defined | defined | defined |
| [o6_22](results/o6_22.json) | `v2-o6_22-luna-high-20261005` | compiled | defined | defined | defined |
| [o6_23](results/o6_23.json) | `v2-o6_23-luna-high-20261005` | compiled | defined | defined | defined |
| [o6_24](results/o6_24.json) | `v2-o6_24-luna-high-20261005` | compiled | defined | defined | defined |

`defined`: Query liefert einen nativen Wert. `undefined`: kein Wert. `runtime_error` und `compile_error`: technische Fehler mit originaler OPA-Diagnose im Ergebnis-JSON. `fixture_gap`: kein ausführbarer Fall; die konkrete Lücke steht beim Kandidaten. Diese Statuswerte sind keine fachlichen Bewertungen.

## Reproduzieren

Vom Repository-Wurzelverzeichnis mit der passenden absoluten OPA-Binary:

```bash
PYTHONPATH=src OPA_BIN=/absolute/path/opa python -m rulelab.screening verify --report-dir docs/analysis/luna-screening-20261011
```

Die Überprüfung vergleicht den eingefrorenen Bestand und die Ausgaben. Eingabe-, Artefakt- und Quellenhashes stehen im Manifest beziehungsweise Ergebnis-JSON. Die methodischen Grenzen sind in [method.md](method.md) beschrieben.

## Kandidaten und beobachtete Fälle

### o6_1a

Run: `v2-o6_1a-luna-high-20260930`. [Fixture](fixtures/o6_1a.json) · [Native Ergebnisse](results/o6_1a.json)

**Eingaben:** Native Struktur farm.year, land und documentation; Acker-DIV 0,7 ha bei 10 ha Acker, ein 10-ha-Feldstück mit 0,15 ha anrechenbarer Fläche, kein Grünland und deaktivierte regionale Saat-/Pheromonoption. Die Variante synthetic_no_grassland_option ist ein offen synthetischer Nicht-DIVNFZ-Marker und kein fachlicher AMA-Code. Alle Werte sind ausdrücklich synthetische Entwicklungsannahmen; die Eingaben repräsentieren keinen echten Betrieb.

**Ausgabebedeutung:** decision enthält eligible, deny und das konstante Vertragsende. eligible aggregiert nur die im deny-Set angeschlossenen Prüfungen. Fehlende Pflichtfakten werden teilweise als deny ausgegeben; ein eigener Zustand missing_data, vollständige UBB-Auflagen und aggregierte Prämie fehlen.

**Herkunft:** DEVELOPMENT ONLY: Kombination der Modelltests test_arable_minimum_passes/fails und test_arable_fieldpiece_passes in runs/v2-o6_1a-luna-high-20260930/workspace/tests/o6_1a_test.rego; übrige Werte aus direkt gelesenen Policy-Bedingungen synthetisch gesetzt. Keine Expertenlabels, kein Golden- oder Heldout-Test; keine erwarteten fachlichen Ergebnisse werden vergeben.

**Query:** `data.o6_1a.decision`

**Inventar:** 37 Regelkatalog-Einträge; 8 Quellen; 41 statisch erkannte Eingabepfade; 81 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"calculation": 5, "choice": 1, "classification": 1, "condition": 7, "consequence": 1, "contract": 1, "deadline": 1, "duration": 1, "eligibility": 7, "procedure": 1, "prohibition": 2, "scope": 1, "temporary_exception": 3, "threshold": 5}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.documentation.arable_div_ha",
      "input.documentation.arable_fertilizer_used",
      "input.documentation.arable_fieldpieces",
      "input.documentation.arable_first_grazing_date",
      "input.documentation.arable_grazing",
      "input.documentation.arable_psm_used",
      "input.documentation.arable_removal_method",
      "input.documentation.arable_threshing",
      "input.documentation.arable_uses_in_two_years",
      "input.documentation.arable_uses_this_year",
      "input.documentation.drought_2026.relief_code",
      "input.documentation.drought_2026.third_use",
      "input.documentation.grassland_div_ha",
      "input.documentation.grassland_fallow_days",
      "input.documentation.grassland_fertilization_during_fallow",
      "input.documentation.grassland_fieldpieces",
      "input.documentation.grassland_second_use",
      "input.documentation.grassland_vehicle_entry_during_fallow",
      "input.documentation.livestock_status",
      "input.documentation.pheromone",
      "input.documentation.pheromone_days_after_sowing",
      "input.documentation.pheromone_emptyings",
      "input.documentation.pheromone_field_days",
      "input.documentation.pheromone_records_complete",
      "input.documentation.pheromone_traps_per_ha",
      "input.documentation.regional_grassland_number",
      "input.documentation.regional_origin_proven",
      "input.documentation.regional_seed",
      "input.documentation.regional_seed_max_species_weight_share",
      "input.documentation.regional_seed_plant_families",
      "input.documentation.regional_seed_rate_kg_per_ha",
      "input.documentation.regional_seed_species_count",
      "input.documentation.wild_bird_cereal",
      "input.documentation.wild_bird_protected_period_compliant",
      "input.documentation.wild_bird_row_spacing_cm",
      "input.documentation.wild_bird_undersown",
      "input.farm.year",
      "input.land.arable_area_ha",
      "input.land.grassland_area_ha",
      "input.land.parcels",
      "input.land.total_area_ha"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| ubb_2026 | full_document | 10 | {"not_rule": 1, "rules": 9} |
| general_2026 | full_document | 7 | {"not_rule": 2, "rules": 5} |
| srl_2024 | targeted_sections | 3 | {"not_rule": 1, "rules": 2} |
| srl_attachments_2024 | targeted_sections | 3 | {"rules": 3} |
| notice_2026_05_22 | full_document | 1 | {"rules": 1} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026_08_12 | full_document | 2 | {"not_rule": 1, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Konstruierte synthetische Basis zur Beobachtung des nativen Kandidaten; kein bestätigter Förderfall. |
| variation | defined | ja | Nur documentation.arable_div_ha von 0,70 auf 0,69 ändern: native 7-%-Grenze unterlaufen. |
| missing_fact | defined | ja | Nur documentation.arable_div_ha entfernen: Verhalten bei fehlender entscheidungsrelevanter Flächensumme beobachten. |

**Offene Abhängigkeiten:**

- Die Aggregation deckt nicht alle Regelkatalog-/Helper-Prüfungen ab; negative Beobachtung bedeutet keine vollständige fachliche Prüfung.
- Keine fachliche Bestätigung der Feldstück-/DIV-Aggregate und Quellenpriorität. Für ein Sollurteil zu betroffenen Klauseln ist die zugehörige Klärung in App #140 erforderlich; Ausführung ist ohne diese möglich.
- Missing-Fact-Probe untersucht die Vermischung fehlender Werte mit fachlicher Nichterfüllung.

**Belege:**

- [runs/v2-o6_1a-luna-high-20260930/workspace/policy/o6_1a.rego](../../../runs/v2-o6_1a-luna-high-20260930/workspace/policy/o6_1a.rego): Native Eingabepfade und ausdrücklich gewählter Ausgabepunkt; Änderung und fehlende Tatsache richten sich nach dem ausführbaren Kandidaten, nicht nach einer fachlichen Sollentscheidung.
- [runs/v2-o6_1a-luna-high-20260930/workspace/tests/o6_1a_test.rego](../../../runs/v2-o6_1a-luna-high-20260930/workspace/tests/o6_1a_test.rego): Kombination der Modelltests test_arable_minimum_passes/fails und test_arable_fieldpiece_passes in runs/v2-o6_1a-luna-high-20260930/workspace/tests/o6_1a_test.rego; übrige Werte aus direkt gelesenen Policy-Bedingungen synthetisch gesetzt.
- [runs/v2-o6_1a-luna-high-20260930/workspace/notes/assumptions.md](../../../runs/v2-o6_1a-luna-high-20260930/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen; keine unabhängige Expertenbestätigung.
- [runs/v2-o6_1a-luna-high-20260930/workspace/rules/rules.json](../../../runs/v2-o6_1a-luna-high-20260930/workspace/rules/rules.json): Katalog o6_1a.arable_minimum belegt die 7-%-Schwelle und nennt zusätzliche Flächenabgrenzungen; der native Code verwendet documentation.arable_div_ha und setzt diese Abgrenzung als bereits berechneten Input voraus.

### o6_1b

Run: `v2-o6_1b-luna-high-20260930`. [Fixture](fixtures/o6_1b.json) · [Native Ergebnisse](results/o6_1b.json)

**Eingaben:** Root-level year und first_participation_year, contract, certifications, aggregierte land-Fakten und livestock. Anteile sind Bruchteile 0–1. Feldstückkonformität wird als synthetisch vorausgesetzter boolescher Fakt eingegeben, nicht aus Einzelparzellen bewiesen. Alle Werte sind ausdrücklich synthetische Entwicklungsannahmen; die Eingaben repräsentieren keinen echten Betrieb.

**Ausgabebedeutung:** Der Kandidat besitzt kein natives decision/result-Objekt: eligible ist ein boolescher Wert ohne Gründe oder fehlende-Fakten-Liste. Er aggregiert neun Basisprüfungen; Bewirtschaftung, Monitoring, Fristen, Varianten und Prämien existieren als separate Helper und werden hier nicht zu einer vollständigen BIO-Entscheidung zusammengeführt.

**Herkunft:** DEVELOPMENT ONLY: Nahezu direkte synthetische Wiederverwendung von valid_base_input und test_arable_diversification_rejects_excessive_grain in runs/v2-o6_1b-luna-high-20260930/workspace/tests/o6_1b_test.rego; Kontrollstellenname explizit als synthetischer Marker ersetzt. Keine Expertenlabels, kein Golden- oder Heldout-Test; keine erwarteten fachlichen Ergebnisse werden vergeben.

**Query:** `data.o6_1b.eligible`

**Inventar:** 43 Regelkatalog-Einträge; 8 Quellen; 71 statisch erkannte Eingabepfade; 95 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"area_threshold": 4, "automatic_surcharge": 3, "biodiversity_management": 2, "choice": 1, "classification": 1, "combination": 1, "contract_duration": 1, "crop_diversification": 1, "deadline": 4, "duration": 1, "eligibility": 8, "exception": 4, "input_ban": 1, "optional_surcharge": 7, "premium": 2, "reporting": 1, "training": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.biodiversity.arable.exempt_from_new_sowing",
      "input.biodiversity.arable.fertilizer_used",
      "input.biodiversity.arable.insect_pollinated_partners",
      "input.biodiversity.arable.invasive_species_evidence",
      "input.biodiversity.arable.invasive_species_share",
      "input.biodiversity.arable.minimum_duration_years",
      "input.biodiversity.arable.non_insect_pollinated_share",
      "input.biodiversity.arable.plant_families",
      "input.biodiversity.arable.sown_date",
      "input.biodiversity.arable.unrestricted_share",
      "input.biodiversity.arable.use_date",
      "input.biodiversity.early_use_before_august",
      "input.biodiversity.grassland.annual_mowing_with_removal",
      "input.biodiversity.grassland.dormant_days",
      "input.biodiversity.grassland.fertilizer_only_manure_or_compost",
      "input.biodiversity.grassland.first_use_date",
      "input.biodiversity.grassland.last_use_date",
      "input.biodiversity.grassland.max_uses_per_year",
      "input.biodiversity.grassland.mowing_with_removal",
      "input.biodiversity.grassland.second_use_in_year",
      "input.biodiversity.grassland.variant",
      "input.biodiversity.regional_seed.ecotype_seed",
      "input.biodiversity.regional_seed.family_count",
      "input.biodiversity.regional_seed.kind",
      "input.biodiversity.regional_seed.max_single_species_share",
      "input.biodiversity.regional_seed.regional_origin_documented",
      "input.biodiversity.regional_seed.seed_rate_kg_ha",
      "input.biodiversity.regional_seed.sown_date",
      "input.biodiversity.regional_seed.species_count",
      "input.biodiversity.third_arable_use",
      "input.certifications.organic.control_body",
      "input.certifications.organic.is_certified",
      "input.contract.end_date",
      "input.contract.start_year",
      "input.crop.variety",
      "input.first_participation_year",
      "input.land.arable_area_ha",
      "input.land.arable_biodiversity_area_ha",
      "input.land.arable_fields_with_more_than_5ha_are_valid",
      "input.land.circular_arable_crop_is_eligible",
      "input.land.circular_arable_share",
      "input.land.circular_grassland_share",
      "input.land.grain_and_maize_share",
      "input.land.grassland_biodiversity_area_for_arable_ha",
      "input.land.grassland_biodiversity_area_ha",
      "input.land.grassland_fields_with_more_than_5ha_are_valid",
      "input.land.max_crop_share",
      "input.land.mowed_grassland_area_ha",
      "input.land.protected_cultivation_area_ha",
      "input.land.total_area_ha",
      "input.livestock.average_rgve_per_forage_ha",
      "input.livestock.biological_equines",
      "input.livestock.category",
      "input.livestock.conventional_equines_only",
      "input.livestock.has_livestock",
      "input.livestock.is_forage_eating_livestock_farm",
      "input.livestock.uncertified_chickens",
      "input.livestock.uncertified_fattening_pigs",
      "input.monitoring.data_submitted_annually",
      "input.monitoring.has_gl06_gl15_or_gl25",
      "input.monitoring.introductory_event_completed",
      "input.monitoring.nature_measure",
      "input.monitoring.participation_confirmation",
      "input.monitoring.program",
      "input.monitoring.ta01_on_at_least_one_parcel",
      "input.pheromone_traps.days_on_field",
      "input.pheromone_traps.emptyings_during_minimum_period",
      "input.pheromone_traps.is_sugar_beet_or_previous_sugar_beet_parcel",
      "input.pheromone_traps.records_complete",
      "input.pheromone_traps.traps_per_ha",
      "input.year"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_1b | full_document | 17 | {"not_rule": 2, "rules": 15} |
| o6_general | full_document | 7 | {"not_rule": 2, "rules": 5} |
| srl_oepul_2023 | targeted_sections | 5 | {"rules": 5} |
| srl_oepul_2023_anhaenge | targeted_sections | 4 | {"rules": 4} |
| notice_2026_05_22 | full_document | 1 | {"rules": 1} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 1 | {"rules": 1} |
| notice_2026_08_12 | full_document | 1 | {"rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Konstruierte synthetische Basis zur Beobachtung des nativen Kandidaten; kein bestätigter Förderfall. |
| variation | defined | ja | Nur land.grain_and_maize_share von 0,70 auf 0,76 ändern: native Grenze 0,75 überschreiten. |
| missing_fact | defined | ja | Nur certifications.organic.is_certified entfernen: Beobachtung, wie ein fehlender Zertifizierungsfakt in den booleschen Ausgabevertrag fällt. |

**Offene Abhängigkeiten:**

- Boolesche Ausgabe erklärt weder betroffene Klausel noch fehlende Daten; für App-Anzeige ist ein gesonderter dokumentierter Diagnosevertrag nötig.
- Land-Feldstückkonformität ist nur behaupteter Input. Unabhängige Referenzprüfung und ausgewählte Fachfragen aus App #140 bleiben für eine semantische Bewertung offen.
- eligible deckt die separaten Bewirtschaftungs- und Variantenprüfungen nicht ab; true darf nicht als vollständige Förderfreigabe bezeichnet werden.

**Belege:**

- [runs/v2-o6_1b-luna-high-20260930/workspace/policy/o6_1b.rego](../../../runs/v2-o6_1b-luna-high-20260930/workspace/policy/o6_1b.rego): Native Eingabepfade und ausdrücklich gewählter Ausgabepunkt; Änderung und fehlende Tatsache richten sich nach dem ausführbaren Kandidaten, nicht nach einer fachlichen Sollentscheidung.
- [runs/v2-o6_1b-luna-high-20260930/workspace/tests/o6_1b_test.rego](../../../runs/v2-o6_1b-luna-high-20260930/workspace/tests/o6_1b_test.rego): Nahezu direkte synthetische Wiederverwendung von valid_base_input und test_arable_diversification_rejects_excessive_grain in runs/v2-o6_1b-luna-high-20260930/workspace/tests/o6_1b_test.rego; Kontrollstellenname explizit als synthetischer Marker ersetzt.
- [runs/v2-o6_1b-luna-high-20260930/workspace/notes/assumptions.md](../../../runs/v2-o6_1b-luna-high-20260930/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen; keine unabhängige Expertenbestätigung.
- [runs/v2-o6_1b-luna-high-20260930/workspace/rules/rules.json](../../../runs/v2-o6_1b-luna-high-20260930/workspace/rules/rules.json): Katalog o6_1b_crop_diversification beschreibt die 0,75-/0,55-Anteilsgrenzen einschließlich Ausnahmen; die Variation prüft nur den Getreide-/Mais-Anteil des nativen Codes.

### o6_1c

Run: `v2-o6_1c-luna-high-20260930`. [Fixture](fixtures/o6_1c.json) · [Native Ergebnisse](results/o6_1c.json)

**Eingaben:** Native farm.year/farm.region.nUTS mit gemischter Großschreibung, measure und land.parcels. Die Basis enthält eine synthetische NPA-Fläche; Agroforst wird in diesen drei Entwicklungsproben nicht ausgeübt. Alle Werte sind ausdrücklich synthetische Entwicklungsannahmen; die Eingaben repräsentieren keinen echten Betrieb.

**Ausgabebedeutung:** decisions ist ein Set einzelner code/status-Befunde, kein zusammengefasstes Förderurteil. eligible ist ein separater Zugangsbefund aus Maßnahmen-ID, Jahr und nichtleerem Regionswert; er ignoriert Verletzungen in decisions. Prämienbänder sind separat und werden hier nicht abgefragt. Fehlende Ackerfläche kann NPA_AREA_LIMIT als fail statt missing erscheinen lassen.

**Herkunft:** DEVELOPMENT ONLY: NPA-Flächenstruktur aus test_npa_limit_passes/fails in runs/v2-o6_1c-luna-high-20260930/workspace/tests/o6_1c_test.rego; Pflege, Betriebsmittel, Kombination und Vertragsdaten anhand der Policy synthetisch vervollständigt. Keine Expertenlabels, kein Golden- oder Heldout-Test; keine erwarteten fachlichen Ergebnisse werden vergeben.

**Query:** `data.policy.o6_1c.decisions`

**Inventar:** 46 Regelkatalog-Einträge; 8 Quellen; 8 statisch erkannte Eingabepfade; 58 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"applicant_eligibility": 1, "application_deadline": 1, "care_frequency": 1, "clearance": 1, "combination": 2, "continuity": 1, "contract_period": 1, "deadline": 2, "declaration": 1, "definition": 1, "eligibility_exclusion": 1, "establishment": 2, "exception": 2, "exclusion": 1, "farm_minimum": 1, "geometry": 1, "input_prohibition": 2, "location": 2, "maintenance": 1, "modulation": 1, "negative_list": 1, "no_double_counting": 1, "option": 1, "post_break": 1, "premium_band": 2, "premium_cap": 1, "premium_floor": 1, "renewal": 1, "replacement": 1, "sanction": 1, "scope": 1, "scope_exclusion": 4, "timing_share": 1, "tree_maintenance": 1, "use_prohibition": 2}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.region.nUTS",
      "input.farm.year",
      "input.land.arable_area_ha",
      "input.land.parcels",
      "input.measure.contract_end",
      "input.measure.contract_start",
      "input.measure.id",
      "input.measure.npa_area_with_care_before_august_ha"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_1c | full_document | 9 | {"not_rule": 2, "rules": 7} |
| o6_general | full_document | 18 | {"not_rule": 7, "rules": 11} |
| srl_oepul_2023 | targeted_sections | 7 | {"rules": 7} |
| srl_oepul_2023_anhaenge | targeted_sections | 2 | {"not_rule": 1, "rules": 1} |
| ama_notice_2026_biodiv | full_document | 2 | {"not_rule": 1, "rules": 1} |
| ama_notice_2026_rebzikade | full_document | 1 | {"rules": 1} |
| ama_notice_2026_drought_0805 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| ama_notice_2026_drought_0812 | full_document | 3 | {"not_rule": 2, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Konstruierte synthetische Basis zur Beobachtung des nativen Kandidaten; kein bestätigter Förderfall. |
| variation | defined | ja | Nur die NPA-Parzellenfläche von 0,30 auf 0,50 ha ändern: native 4-%-Grenze bei 10 ha Acker überschreiten. |
| missing_fact | defined | ja | Nur land.arable_area_ha entfernen: Verhalten bei fehlendem Nenner der Flächenbegrenzung beobachten. |

**Offene Abhängigkeiten:**

- Keine unabhängige Bestätigung des NPA-Flächenbezugs (4-%-Nenner) und der Kombinationstabelle; die betreffenden Klärungen in App #140 werden erst für das Sollurteil benötigt.
- Native decisions aggregiert nicht alle Helper (z.B. Saat-/Vertragsfrist und Augustanteil); die drei NPA-Proben sind keine vollständige Agroforst-/NPA-Abdeckung.
- Kein expliziter Zustand für fehlende Daten; fehlende Werte sind vom fachlichen fail abzugrenzen.

**Belege:**

- [runs/v2-o6_1c-luna-high-20260930/workspace/policy/o6_1c.rego](../../../runs/v2-o6_1c-luna-high-20260930/workspace/policy/o6_1c.rego): Native Eingabepfade und ausdrücklich gewählter Ausgabepunkt; Änderung und fehlende Tatsache richten sich nach dem ausführbaren Kandidaten, nicht nach einer fachlichen Sollentscheidung.
- [runs/v2-o6_1c-luna-high-20260930/workspace/tests/o6_1c_test.rego](../../../runs/v2-o6_1c-luna-high-20260930/workspace/tests/o6_1c_test.rego): NPA-Flächenstruktur aus test_npa_limit_passes/fails in runs/v2-o6_1c-luna-high-20260930/workspace/tests/o6_1c_test.rego; Pflege, Betriebsmittel, Kombination und Vertragsdaten anhand der Policy synthetisch vervollständigt.
- [runs/v2-o6_1c-luna-high-20260930/workspace/notes/assumptions.md](../../../runs/v2-o6_1c-luna-high-20260930/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen; keine unabhängige Expertenbestätigung.
- [runs/v2-o6_1c-luna-high-20260930/workspace/rules/rules.json](../../../runs/v2-o6_1c-luna-high-20260930/workspace/rules/rules.json): Katalog o6_1c_001 beschreibt den 4-%-NPA-Scope; native decisions ist weiterhin nur eine Teilmenge der Katalogklauseln.

### o6_2

Run: `v2-o6_2-luna-high-20260930`. [Fixture](fixtures/o6_2.json) · [Native Ergebnisse](results/o6_2.json)

**Eingaben:** Native root-level application_year/program/region und farm.compliance/training; Futterfläche, Tierkategorie und Stickstoffmenge sind synthetische externe Aggregate. livestock_n_kg_per_ha wird wie in den Modellannahmen bereits nach Stall-/Lagerverlusten vorausgesetzt; keine N-Berechnung wird erfunden. Alle Werte sind ausdrücklich synthetische Entwicklungsannahmen; die Eingaben repräsentieren keinen echten Betrieb.

**Ausgabebedeutung:** decision enthält einzelne boolesche Prüfungen, Prämientier und Modulationsfaktor; kein aggregiertes eligible, kein Gesamtbetrag, keine Quellen-/Missing-Fact-Diagnose. Einzelprüfungen und Prämientier dürfen nicht zur vollständigen Förderung umgedeutet werden.

**Herkunft:** DEVELOPMENT ONLY: Wiederverwendung der base-Struktur sowie des Graslandparzellenmusters test_rgve_animal_holding in runs/v2-o6_2-luna-high-20260930/workspace/tests/o6_2_test.rego; synthetische Lagerdokumentation und Zahlungsbetrag ergänzen die direkt gelesenen Ausgabebedingungen. Keine Expertenlabels, kein Golden- oder Heldout-Test; keine erwarteten fachlichen Ergebnisse werden vergeben.

**Query:** `data.oepul.o6_2.decision`

**Inventar:** 39 Regelkatalog-Einträge; 8 Quellen; 21 statisch erkannte Eingabepfade; 23 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application_deadline": 1, "area_access": 1, "area_reduction": 1, "classification": 2, "combination": 3, "contract_duration": 1, "cross_measure_exception_2026": 2, "drought_exception_2026": 1, "eligibility": 1, "exception": 2, "general_condition": 2, "input_classification": 1, "input_table": 1, "measure_change": 1, "modulation": 1, "permission": 1, "premium": 4, "premium_cap": 1, "prohibition": 5, "quality": 1, "reporting": 1, "sanction": 1, "threshold": 1, "training": 3}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.application_year",
      "input.farm.compliance.external_n_fertilizer_kg",
      "input.farm.compliance.livestock_n_kg_per_ha",
      "input.farm.compliance.purchase_storage_records_complete",
      "input.farm.forage_area_ha",
      "input.farm.training.completed_by",
      "input.farm.training.course_date",
      "input.farm.training.double_counted",
      "input.farm.training.hours",
      "input.farm.training.provider_approved",
      "input.land.parcels",
      "input.land.total_area_ha",
      "input.livestock.species_groups",
      "input.program.o6_1a.participates",
      "input.program.o6_1b.partial_farm",
      "input.program.o6_1b.participates",
      "input.program.o6_2.application_date",
      "input.program.o6_2.application_year",
      "input.program.o6_2.participates",
      "input.region.district",
      "input.region.federal_state"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_2_sheet | full_document | 8 | {"rules": 8} |
| o6_general_sheet | full_document | 21 | {"not_rule": 6, "rules": 15} |
| srl_20241011 | targeted_sections | 5 | {"rules": 5} |
| srl_annexes_20241011 | targeted_sections | 2 | {"rules": 2} |
| notice_2026_05_22 | full_document | 2 | {"rules": 2} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026_08_12 | full_document | 3 | {"not_rule": 1, "rules": 2} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Konstruierte synthetische Basis zur Beobachtung des nativen Kandidaten; kein bestätigter Förderfall. |
| variation | defined | ja | Nur farm.compliance.livestock_n_kg_per_ha von 170 auf 171 ändern: native N-Grenze überschreiten. |
| missing_fact | defined | ja | Nur farm.compliance.external_n_fertilizer_kg entfernen: Verhalten bei fehlendem Fremd-N-Aggregat beobachten. |

**Offene Abhängigkeiten:**

- Die fachliche Ermittlung der Stickstoffgröße und stabile Zuordnung von Tierkategorien/Anzahlbasis sind offen; für spätere Sollwerte sind nur die einschlägigen Fragen in App #140 nötig.
- Einzelne Oberflächenprüfungen betrachten nur parcels[0]; mehrparzellige Aggregation ist mit diesen Proben nicht abgedeckt.
- all_psm_ok ist default true und bildet die Ergebnisse einer Comprehension ab; eine separate PSM-Fehlprobe ist vor Behauptungen einer vollständigen PSM-Kontrolle erforderlich.
- Fehlende Fakten werden als false/Default statt eigenem insufficient_data-Status ausgegeben.

**Belege:**

- [runs/v2-o6_2-luna-high-20260930/workspace/policy/o6_2.rego](../../../runs/v2-o6_2-luna-high-20260930/workspace/policy/o6_2.rego): Native Eingabepfade und ausdrücklich gewählter Ausgabepunkt; Änderung und fehlende Tatsache richten sich nach dem ausführbaren Kandidaten, nicht nach einer fachlichen Sollentscheidung.
- [runs/v2-o6_2-luna-high-20260930/workspace/tests/o6_2_test.rego](../../../runs/v2-o6_2-luna-high-20260930/workspace/tests/o6_2_test.rego): Wiederverwendung der base-Struktur sowie des Graslandparzellenmusters test_rgve_animal_holding in runs/v2-o6_2-luna-high-20260930/workspace/tests/o6_2_test.rego; synthetische Lagerdokumentation und Zahlungsbetrag ergänzen die direkt gelesenen Ausgabebedingungen.
- [runs/v2-o6_2-luna-high-20260930/workspace/notes/assumptions.md](../../../runs/v2-o6_2-luna-high-20260930/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen; keine unabhängige Expertenbestätigung.
- [runs/v2-o6_2-luna-high-20260930/workspace/rules/rules.json](../../../runs/v2-o6_2-luna-high-20260930/workspace/rules/rules.json): Katalog O62-R11 nennt 170 kg N pro ha nach Stall-/Lagerverlusten; die Fixture übernimmt diese Größe synthetisch und führt keine eigenständige N-Ermittlung durch.

### o6_3

Run: `v2-o6_3-luna-high-20261001`. [Fixture](fixtures/o6_3.json) · [Native Ergebnisse](results/o6_3.json)

**Eingaben:** Native farm.heuwirtschaft-Struktur und eigenständige land/livestock-Listen; synthetisches Jahr 2025 entsprechend dem historischen Modelltest. Green-Feeding und Heuabgabe sind vorausgesetzte boolesche Entwicklungsfakten, keine aus Zeitreihen bewiesenen Aussagen. Alle Werte sind ausdrücklich synthetische Entwicklungsannahmen; die Eingaben repräsentieren keinen echten Betrieb.

**Ausgabebedeutung:** result enthält eligible, first_year_access, RGVE-/Futter-/Prämienaggregate, Dürreindikator und violations. Allgemeine Förderfreigabe und Betriebsmodulation fehlen. first_year_access benutzt teilweise aktuelle Tiere/Futterfläche statt die supplied first_year.rgve_total/fodder_area_ha. Beim Entfernen eines Faktwerts kann eligible false ohne passende violation entstehen; die Prämienarithmetik kann weiterlaufen.

**Herkunft:** DEVELOPMENT ONLY: Synthetische Wiederverwendung von test_valid_heuwirtschaft_with_option in runs/v2-o6_3-luna-high-20261001/workspace/tests/o6_3_heuwirtschaft_test.rego, mit zusätzlicher eindeutig synthetischer parcel_id; Änderung/Entfernung des Lagerungsfakts direkt aus compliance_ok/violation-Bedingungen. Keine Expertenlabels, kein Golden- oder Heldout-Test; keine erwarteten fachlichen Ergebnisse werden vergeben.

**Query:** `data.oepul.o6_3.result`

**Inventar:** 29 Regelkatalog-Einträge; 8 Quellen; 16 statisch erkannte Eingabepfade; 23 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_condition": 2, "area_access": 1, "calculation": 2, "closed_list": 1, "conditional_prohibition": 1, "consequence": 2, "contract_duration": 1, "deadline": 2, "delivery_condition": 1, "eligibility_scope": 1, "exclusion": 1, "general_access": 1, "general_obligation": 1, "interpretive_update": 1, "location": 1, "lookup_table": 1, "option": 1, "premium_calculation": 1, "prohibition": 3, "seasonal_obligation": 1, "temporary_exception": 1, "threshold": 2}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.heuwirtschaft.contract_start_year",
      "input.farm.heuwirtschaft.drought_exception_area",
      "input.farm.heuwirtschaft.feed_fermentation",
      "input.farm.heuwirtschaft.first_year.mown_meadow_meadow_pasture_ha",
      "input.farm.heuwirtschaft.green_feeding_majority_april_to_september",
      "input.farm.heuwirtschaft.measure",
      "input.farm.heuwirtschaft.mower_conditioner_present",
      "input.farm.heuwirtschaft.mower_conditioner_used",
      "input.farm.heuwirtschaft.no_harvestable_stand",
      "input.farm.heuwirtschaft.no_mower_conditioner_option",
      "input.farm.heuwirtschaft.participation.combined_measure",
      "input.farm.heuwirtschaft.silage_preparation_and_feeding",
      "input.farm.heuwirtschaft.silage_storage",
      "input.farm.heuwirtschaft.third_party_cuttings_only_dry_hay",
      "input.farm.heuwirtschaft.year",
      "input.land.parcels"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_3 | full_document | 12 | {"rules": 12} |
| o6_general | full_document | 16 | {"not_rule": 7, "rules": 9} |
| srl_oepul_2023 | targeted_sections | 6 | {"rules": 6} |
| srl_oepul_anhaenge | targeted_sections | 3 | {"not_rule": 1, "rules": 2} |
| notice_drought_biodiversity_2026 | full_document | 1 | {"not_rule": 1} |
| notice_insecticide_exit_2026 | full_document | 1 | {"not_rule": 1} |
| notice_drought_az_2026 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_drought_processing_2026 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Konstruierte synthetische Basis zur Beobachtung des nativen Kandidaten; kein bestätigter Förderfall. |
| variation | defined | ja | Nur farm.heuwirtschaft.silage_storage von false auf true ändern: konkrete native Lagerungsbedingung verletzen. |
| missing_fact | defined | ja | Nur farm.heuwirtschaft.silage_storage entfernen: Unterschied zwischen ausdrücklicher Lagerung und unbekanntem Lagerungsfakt beobachten. |

**Offene Abhängigkeiten:**

- Die acht offenen o6_3-Gates aus App #140 betreffen fachliche Gesamtfreigabe und insbesondere Gruppenidentität, Anzahlbasis, Historie und Evidenz; diese Vorschau schließt sie nicht.
- Historische Zugangsvoraussetzungen und zeitliche Green-Feeding-Tatsache benötigen einen unabhängig bestätigten Datenvertrag.
- Prämienwerte des historischen Kandidaten sind unbestätigte Indikationen; kein vollständiger Zahlbetrag und keine semantische Freigabe.
- Bei fehlendem silage_storage existiert im nativen Vertrag kein expliziter Missing-Fact-Befund; das muss für eine verständliche App-Vorschau sichtbar bleiben.

**Belege:**

- [runs/v2-o6_3-luna-high-20261001/workspace/policy/o6_3_heuwirtschaft.rego](../../../runs/v2-o6_3-luna-high-20261001/workspace/policy/o6_3_heuwirtschaft.rego): Native Eingabepfade und ausdrücklich gewählter Ausgabepunkt; Änderung und fehlende Tatsache richten sich nach dem ausführbaren Kandidaten, nicht nach einer fachlichen Sollentscheidung.
- [runs/v2-o6_3-luna-high-20261001/workspace/tests/o6_3_heuwirtschaft_test.rego](../../../runs/v2-o6_3-luna-high-20261001/workspace/tests/o6_3_heuwirtschaft_test.rego): Synthetische Wiederverwendung von test_valid_heuwirtschaft_with_option in runs/v2-o6_3-luna-high-20261001/workspace/tests/o6_3_heuwirtschaft_test.rego, mit zusätzlicher eindeutig synthetischer parcel_id; Änderung/Entfernung des Lagerungsfakts direkt aus compliance_ok/violation-Bedingungen.
- [runs/v2-o6_3-luna-high-20261001/workspace/notes/assumptions.md](../../../runs/v2-o6_3-luna-high-20261001/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen; keine unabhängige Expertenbestätigung.
- [runs/v2-o6_3-luna-high-20261001/workspace/rules/rules.json](../../../runs/v2-o6_3-luna-high-20261001/workspace/rules/rules.json): Katalog O63.NO_SILAGE_STORAGE referenziert farm.heuwirtschaft.silage_storage und O63-M12; der native Code unterscheidet ausdrücklich true und das Fehlen des Faktwerts unterschiedlich.

### o6_4

Run: `v2-o6_4-luna-high-20261001`. [Fixture](fixtures/o6_4.json) · [Native Ergebnisse](results/o6_4.json)

**Eingaben:** Native farm.o6_4 und flache land.parcels-Blattpfade; ein synthetischer Bergmahdschlag mit 1,1 von 2 ha über 1200 m und einer vollständigen Mahd. Eingabecode BM1 stammt aus dem Modellvertrag, ohne eine unabhängige Zuordnung des Mahdverfahrens zu behaupten. Alle Werte sind ausdrücklich synthetische Entwicklungsannahmen; die Eingaben repräsentieren keinen echten Betrieb.

**Ausgabebedeutung:** compliance enthält status, violations und missing_data. Es aggregiert Bewirtschaftungsverstöße und nur zwei definierte Missing-Data-Pfade. eligible_parcel_ids, eligibility_findings, premium_amount, allgemeine Konditionalität und Vertrags-/Zugangshelper sind separat; compliant ist daher keine Gesamtförderfreigabe.

**Herkunft:** DEVELOPMENT ONLY: Kombination der Modellmuster test_eligible_parcel_requires_majority_above_1200m und test_array_profile_fields_are_read_from_flat_parcel_leaves in runs/v2-o6_4-luna-high-20261001/workspace/tests/o6_4_test.rego; positive Mahdwerte und leere Betriebsmittellisten bewusst synthetisch gesetzt. Keine Expertenlabels, kein Golden- oder Heldout-Test; keine erwarteten fachlichen Ergebnisse werden vergeben.

**Query:** `data.o6_4.compliance`

**Inventar:** 24 Regelkatalog-Einträge; 8 Quellen; 18 statisch erkannte Eingabepfade; 20 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application_code": 1, "application_deadline": 1, "area_access": 1, "area_eligibility": 1, "area_reduction": 1, "combination": 1, "contract_duration": 1, "controls": 1, "eligibility": 1, "eligibility_location": 1, "eligibility_threshold": 1, "farm_minimum_size": 1, "fertilizer_restriction": 1, "general_condition": 1, "grazing_restriction": 1, "management_limit": 1, "management_obligation": 1, "measure_change": 1, "modulation": 1, "no_mowing_code": 1, "participation_option": 1, "plant_protection_restriction": 1, "premium_amount": 1, "sanction": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.first_oepul_year",
      "input.farm.o6_4.access_year",
      "input.farm.o6_4.added_area_ha",
      "input.farm.o6_4.base_2025_area_ha",
      "input.farm.o6_4.code",
      "input.farm.o6_4.compliance.conditionality_compliant",
      "input.farm.o6_4.contract_start_year",
      "input.farm.o6_4.measure_application_date",
      "input.farm.o6_4.measure_change_date",
      "input.farm.o6_4.previous_measure_area_ha",
      "input.farm.o6_4.reduction_ha",
      "input.farm.o6_4.target_measure",
      "input.farm.o6_4.year",
      "input.land.eligible_agricultural_area_ha",
      "input.land.home_farm_elevation_m",
      "input.land.parcels",
      "input.land.protected_area_ha",
      "input.land.total_area_ha"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_4_measure_2025_10 | full_document | 10 | {"not_rule": 1, "rules": 9} |
| o6_general_2026_04 | full_document | 20 | {"not_rule": 6, "rules": 14} |
| srl_oepul_2023 | targeted_sections | 6 | {"rules": 5, "unresolved": 1} |
| srl_oepul_2023_annexes | targeted_sections | 4 | {"not_rule": 3, "rules": 1} |
| notice_2026_05_22 | full_document | 2 | {"not_rule": 2} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 2 | {"not_rule": 2} |
| notice_2026_08_12 | full_document | 5 | {"not_rule": 5} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Konstruierte synthetische Basis zur Beobachtung des nativen Kandidaten; kein bestätigter Förderfall. |
| variation | defined | ja | Nur land.parcels[0].operations.mowing_years[0].full_area auf false setzen: native Mahdverletzung beobachten. |
| missing_fact | defined | ja | Nur land.parcels[0].elevation_above_1200_area_ha entfernen: expliziten nativen Missing-Data-Pfad auslösen. |

**Offene Abhängigkeiten:**

- Mähcode, lokale Siedlungsgrenze, Bewirtschaftungserschwernis und Alm-Ausnahme benötigen belegte Eingaben; die Vorschau setzt sie ausdrücklich synthetisch voraus.
- Das native compliance-Objekt schließt Flächeneignungs- und allgemeine Förderhelper nicht ein; vor einer App-Gesamtanzeige ist ein dokumentierter Aggregationsvertrag nötig.
- Für die ausgewählten fachlichen Sollfälle bleiben einschlägige Fachfragen aus App #140 offen; diese Entwicklungsproben liefern keine Referenzentscheidung.
- Der Katalog fordert rollierende Zweijahres-Mahdzeiträume; der native Code prüft einzelne gelieferte Mahdereignisse, aber beweist die Zweijahresabdeckung nicht. Die synthetische Basis darf nicht als vollständige Bestätigung dieser Katalogpflicht gelten.

**Belege:**

- [runs/v2-o6_4-luna-high-20261001/workspace/policy/o6_4.rego](../../../runs/v2-o6_4-luna-high-20261001/workspace/policy/o6_4.rego): Native Eingabepfade und ausdrücklich gewählter Ausgabepunkt; Änderung und fehlende Tatsache richten sich nach dem ausführbaren Kandidaten, nicht nach einer fachlichen Sollentscheidung.
- [runs/v2-o6_4-luna-high-20261001/workspace/tests/o6_4_test.rego](../../../runs/v2-o6_4-luna-high-20261001/workspace/tests/o6_4_test.rego): Kombination der Modellmuster test_eligible_parcel_requires_majority_above_1200m und test_array_profile_fields_are_read_from_flat_parcel_leaves in runs/v2-o6_4-luna-high-20261001/workspace/tests/o6_4_test.rego; positive Mahdwerte und leere Betriebsmittellisten bewusst synthetisch gesetzt.
- [runs/v2-o6_4-luna-high-20261001/workspace/notes/assumptions.md](../../../runs/v2-o6_4-luna-high-20261001/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen; keine unabhängige Expertenbestätigung.
- [runs/v2-o6_4-luna-high-20261001/workspace/rules/rules.json](../../../runs/v2-o6_4-luna-high-20261001/workspace/rules/rules.json): Katalog O64-MOW-001 nennt rollierende Zweijahreszeiträume mit Vollmahd und Abtransport; die Variation betrifft nur das im nativen Code tatsächlich konsumierte full_area-Feld.

### o6_5

Run: `v2-o6_5-luna-high-20261002`. [Fixture](fixtures/o6_5.json) · [Native Ergebnisse](results/o6_5.json)

**Eingaben:** farm.year ist das betrachtete Kalenderjahr; livestock.animals enthält einzelne Tiere mit nativen englischen Art-/Typwerten, Rassenbezeichnung, Zucht-/Abkalben-Nachweisen und ISO-Haltedaten. Keine Übertragung eines echten Tierbestands.

**Ausgabebedeutung:** Die explizite Projektion zeigt nur das native eligible und eligible_animals. eligible bedeutet: mindestens ein Tier erfüllt animal_eligible und holding_valid. Es gibt keine native Gesamtentscheidung oder Verletzungsliste; Antrags-, Vertrags- und Bewegungshilfsregeln fließen nicht in eligible ein. Keine vollständige Förderfreigabe oder Auszahlung.

**Herkunft:** Die Basis entspricht test_eligible_with_one_valid_cow; die Haltedatum-Variation und das entfernte Zuchtprogramm-Feld sind eigene Einzeländerungen an dessen synthetischem Eingabemuster. Alle Fälle sind synthetische Entwicklungsfälle, keine unabhängig beurteilten Referenz- oder zurückgehaltenen Testfälle.

**Query:** `{"eligible": data.policy.o6_5.eligible, "eligible_animals": data.policy.o6_5.eligible_animals}`

**Inventar:** 55 Regelkatalog-Einträge; 8 Quellen; 3 statisch erkannte Eingabepfade; 2 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"2026_holding_exception": 1, "2026_movement_reporting": 1, "2026_notice_scope": 1, "2026_replacement_reporting_exception": 1, "animal_scope": 1, "application": 1, "application_deadline": 1, "automatic_extension": 1, "breed_list": 1, "breeding_organization_confirmation": 1, "breeding_organization_deadline": 1, "breeding_program": 1, "breeding_station_transfer": 1, "buck_age": 1, "bull_age": 1, "cattle_application": 1, "cattle_departure": 1, "cattle_late_transfer": 1, "cattle_replacement": 1, "conditionality": 1, "contract_period": 1, "control": 1, "cow_requirement": 1, "data_responsibility": 1, "departure_reporting": 1, "doe_requirement": 1, "equine_identification": 1, "ewe_requirement": 1, "farm_minimum_size": 1, "female_breeding": 1, "gep_requirements": 1, "gep_surcharge": 1, "holding_period": 1, "latest_entry": 1, "location": 1, "male_breeding": 1, "male_breeding_transfer": 1, "mare_requirement": 1, "measure_transfer": 1, "minimum_participation": 1, "payment": 1, "premium_schedule": 1, "ram_boar_age": 1, "replacement_period": 1, "replacement_premium": 1, "replacement_reporting": 1, "sanction": 1, "short_stay_exception": 1, "sow_requirement": 1, "stallion_age": 1, "stallion_offspring": 1, "temporary_pasture": 1, "transfer_reporting": 1, "vis_reporting": 1, "withdrawal": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.application_date",
      "input.farm.year",
      "input.livestock.animals"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_5_sheet_2025_10 | full_document | 10 | {"not_rule": 1, "rules": 9} |
| o6_general_2026_04 | full_document | 13 | {"not_rule": 4, "rules": 9} |
| srl_2023_main | targeted_sections | 3 | {"rules": 3} |
| srl_2023_annex_d | targeted_sections | 1 | {"rules": 1} |
| notice_2026_05_22_biodiversity | full_document | 1 | {"rules": 1} |
| notice_2026_06_12_insecticide | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05_drought | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_12_drought | full_document | 1 | {"rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Einen synthetischen Einzeltiersachverhalt mit dem historischen Kandidaten ausführen. |
| variation | defined | ja | Das Ende der Haltung um einen Tag vor die in holding_deadline verwendete Jahresendgrenze setzen. |
| missing_fact | defined | ja | Den konsumierten Nachweis approved_breeding_program entfernen und den nativen Umgang mit unbekannten Fakten beobachten. |

**Offene Abhängigkeiten:**

- Einzeltiere sind im Canonical Farm Profile nicht abgebildet; die vorgeschlagenen Discover-Felder sind kein realer Bestand.
- Antrags-/Vertragsbedingungen und Tierbewegungsnachweise benötigen eine bewusst definierte Gesamtentscheidung; die native eligible-Abfrage verbindet diese Helfer nicht.
- Die fachliche Abgrenzung der verkürzten Haltedauer und Nachbesetzung 2026 bleibt laut historischen Annahmen offen.

**Belege:**

- [runs/v2-o6_5-luna-high-20261002/workspace/policy/o6_5.rego](../../../runs/v2-o6_5-luna-high-20261002/workspace/policy/o6_5.rego): Nativer Eingabeverbrauch und abgefragte Ausgabe; Änderungen werden gegen diese historische Policy untersucht.
- [runs/v2-o6_5-luna-high-20261002/workspace/tests/o6_5_test.rego](../../../runs/v2-o6_5-luna-high-20261002/workspace/tests/o6_5_test.rego): Die Basis entspricht test_eligible_with_one_valid_cow; die Haltedatum-Variation und das entfernte Zuchtprogramm-Feld sind eigene Einzeländerungen an dessen synthetischem Eingabemuster.
- [runs/v2-o6_5-luna-high-20261002/workspace/notes/assumptions.md](../../../runs/v2-o6_5-luna-high-20261002/workspace/notes/assumptions.md): Historische Eingabe-, Quellen- und Integrationsannahmen; keine unabhängige fachliche Bestätigung.

### o6_6

Run: `v2-o6_6-luna-high-20261002`. [Fixture](fixtures/o6_6.json) · [Native Ergebnisse](results/o6_6.json)

**Eingaben:** Eigenständiges natives Wurzelobjekt o6_6: Kalender-/Antragsjahr, Varianten-ID, ISO-Saat-/Umbruch-/Antragsdaten, Flächen in ha, Partner-/Familienanzahlen und Wahrheitswerte. harvested_share ist ein Anteil 0–1; keine Prozentzahl.

**Ausgabebedeutung:** decision liefert eligible, violations, profile_missing und ein Prämienband pro ha. eligible ist ausschließlich count(violations)==0; profile_missing ist informativ und wird nicht automatisch zur Ablehnung. Das Prämienband ist keine zugesagte Auszahlung und kein Nachweis vollständiger allgemeiner Förderbedingungen.

**Herkunft:** Die Basis entspricht test_variant_2_valid. Mineral-N-Einsatz und Entfernung desselben Feldes sind eigene Einzeländerungen; die MINERAL_N-Regel und profile_fields belegen deren Verbrauch. Alle Fälle sind synthetische Entwicklungsfälle, keine unabhängig beurteilten Referenz- oder zurückgehaltenen Testfälle.

**Query:** `data.oepul.o6_6.decision`

**Inventar:** 67 Regelkatalog-Einträge; 8 Quellen; 50 statisch erkannte Eingabepfade; 8 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application": 4, "area_change": 1, "closed_list": 1, "combination": 3, "contract_continuation": 1, "contract_period": 1, "control": 1, "cross_compliance": 1, "deadline": 1, "definition": 1, "definition_exclusion": 2, "eligibility": 4, "eligibility_consequence": 1, "eligibility_exclusion": 1, "evidence": 2, "exception": 5, "follow_crop": 2, "land_transfer": 1, "location": 1, "management": 2, "measure_change": 1, "measure_takeover": 1, "minimum_management": 1, "obligation_duration": 1, "payment": 1, "premium": 1, "premium_cap": 1, "premium_exclusion": 1, "premium_modulation": 1, "prohibition": 4, "removal": 1, "removal_exclusion": 1, "sanction": 1, "scope": 1, "temporary_application": 1, "temporary_exception": 2, "use": 1, "variant": 8, "variant_option": 1, "withdrawal": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.o6_6",
      "input.o6_6.active_sowing",
      "input.o6_6.after_frost",
      "input.o6_6.application_corrected",
      "input.o6_6.application_year",
      "input.o6_6.arable_area_ha",
      "input.o6_6.area_ha",
      "input.o6_6.autumn_main_crop_planted",
      "input.o6_6.break_date",
      "input.o6_6.conditionality_compliant",
      "input.o6_6.crop",
      "input.o6_6.crop_harvest_period",
      "input.o6_6.days_between_sowing_and_break",
      "input.o6_6.district",
      "input.o6_6.drought_no_harvestable_stock",
      "input.o6_6.federal_state",
      "input.o6_6.full_coverage",
      "input.o6_6.gloez8_npf",
      "input.o6_6.grain_maize_share",
      "input.o6_6.harmful_soil_tillage",
      "input.o6_6.harvested_share",
      "input.o6_6.has_greened_parcel",
      "input.o6_6.herbicide_after_four_leaf_stage",
      "input.o6_6.insect_pollinated_partner_count",
      "input.o6_6.knife_roller_used",
      "input.o6_6.land_use",
      "input.o6_6.maintenance_action",
      "input.o6_6.measure_application_date",
      "input.o6_6.mechanical_removal",
      "input.o6_6.mineral_n_applied",
      "input.o6_6.mixing_partner_count",
      "input.o6_6.mixture_crops",
      "input.o6_6.non_insect_pollinated_share",
      "input.o6_6.participates_immergruen",
      "input.o6_6.plant_family_count",
      "input.o6_6.proper_installation",
      "input.o6_6.psm_after_follow_crop_sowing",
      "input.o6_6.psm_applied",
      "input.o6_6.regrowth_expected",
      "input.o6_6.removal_done",
      "input.o6_6.sow_date",
      "input.o6_6.sowing_will_not_occur",
      "input.o6_6.threshed",
      "input.o6_6.travel_ban_until",
      "input.o6_6.travel_date",
      "input.o6_6.travel_is_neighbor_crossing",
      "input.o6_6.variant",
      "input.o6_6.variant_application_date",
      "input.o6_6.volunteer_grain_share",
      "input.o6_6.volunteer_or_self_greening"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_6 | full_document | 14 | {"not_rule": 1, "rules": 13} |
| o6_general | full_document | 9 | {"not_rule": 2, "rules": 7} |
| srl_oepul_2023 | targeted_sections | 6 | {"rules": 6} |
| srl_oepul_2023_anhaenge | targeted_sections | 1 | {"rules": 1} |
| notice_2026-05-22 | full_document | 1 | {"not_rule": 1} |
| notice_2026-06-12 | full_document | 1 | {"not_rule": 1} |
| notice_2026-08-05 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026-08-12 | full_document | 2 | {"not_rule": 1, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Das native Entscheidungsobjekt für einen synthetischen Variante-2-Sachverhalt erfassen. |
| variation | defined | ja | Nur mineral_n_applied auf true setzen, um eine konkret konsumierte Düngeinformation zu variieren. |
| missing_fact | defined | ja | mineral_n_applied entfernen und profile_missing gemeinsam mit eligible und violations beobachten. |

**Offene Abhängigkeiten:**

- Die App benötigt eine explizite Zuordnung zum eigenständigen o6_6-Eingabevertrag; vorhandene Farmfelder liefern diese Angaben nicht vollständig.
- Fehlende Pflichtfelder und native eligible können nebeneinander stehen; vor einer App-Aussage muss die Bedeutung dieser Kombination festgelegt werden.
- Zeitlich begrenzte 2026-Ausnahmen und Variante-6-Sortenzulässigkeit bedürfen eigener Quellen-/Geltungsabgrenzung, sobald solche Fälle ausgewählt werden.

**Belege:**

- [runs/v2-o6_6-luna-high-20261002/workspace/policy/o6_6.rego](../../../runs/v2-o6_6-luna-high-20261002/workspace/policy/o6_6.rego): Nativer Eingabeverbrauch und abgefragte Ausgabe; Änderungen werden gegen diese historische Policy untersucht.
- [runs/v2-o6_6-luna-high-20261002/workspace/tests/o6_6_test.rego](../../../runs/v2-o6_6-luna-high-20261002/workspace/tests/o6_6_test.rego): Die Basis entspricht test_variant_2_valid. Mineral-N-Einsatz und Entfernung desselben Feldes sind eigene Einzeländerungen; die MINERAL_N-Regel und profile_fields belegen deren Verbrauch.
- [runs/v2-o6_6-luna-high-20261002/workspace/notes/assumptions.md](../../../runs/v2-o6_6-luna-high-20261002/workspace/notes/assumptions.md): Historische Eingabe-, Quellen- und Integrationsannahmen; keine unabhängige fachliche Bestätigung.

### o6_7

Run: `v2-o6_7-luna-high-20261002`. [Fixture](fixtures/o6_7.json) · [Native Ergebnisse](results/o6_7.json)

**Eingaben:** farm.year, land.arable_area_ha in ha und synthetische Parzellen mit operations; Teilnahme-/Quotenfakten in measure.o6_7. Quoten sind Prozentwerte 0–100, mineral_n_kg_per_ha ist kg N/ha, Zeitangaben sind Tag des Jahres beziehungsweise Dauern in Tagen. Keine automatische Kalender-/Schaltjahrkonvertierung.

**Ausgabebedeutung:** compliance enthält eligible, violations, Prämienband und drei Ausnahme-Wahrheitswerte. eligible verlangt Teilnahme, Mindestackerfläche und keine erkannten violations; es gibt keine allgemeine Vollständigkeitsprüfung aller Fakten. Prämienband und ausbleibende Verletzungen belegen keine vollständige Förderfreigabe.

**Herkunft:** Die Basis entspricht base_input/test_compliant_profile; die Flächenänderung entspricht low_area_input/test_minimum_area_violation. Das Entfernen der Begrünungsquote ist eine eigene Einzeländerung an der vom Policy-Vergleich konsumierten Tatsache. Alle Fälle sind synthetische Entwicklungsfälle, keine unabhängig beurteilten Referenz- oder zurückgehaltenen Testfälle.

**Query:** `data.oepul.o6_7.compliance`

**Inventar:** 68 Regelkatalog-Einträge; 8 Quellen; 8 statisch erkannte Eingabepfade; 21 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_condition": 1, "application": 3, "area_addition_exception": 1, "calculation_scope": 1, "combination": 2, "combination_consequence": 1, "consequence": 1, "contract_consequence": 1, "contract_period": 1, "control": 1, "coverage_threshold": 1, "crop_sequence": 1, "date_counting": 1, "deadline": 6, "definition": 2, "definition_exclusion": 2, "documentation": 1, "duration": 1, "eligibility_exclusion": 1, "eligible_area": 1, "exception": 1, "general_condition": 5, "general_consequence": 1, "general_exclusion": 2, "input_permission": 1, "input_restriction": 3, "maintenance_condition": 2, "maintenance_permission": 1, "mechanical_removal": 2, "mechanical_removal_exclusion": 1, "mixture_condition": 2, "pre_contract_condition": 1, "premium": 1, "procedure": 1, "scope": 1, "soil_operation": 2, "special_area_rule": 1, "special_date_rule": 2, "temporary_exception": 4, "use_condition": 3, "withdrawal": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.oepul",
      "input.farm.oepul.drought_2026",
      "input.farm.region.district",
      "input.farm.region.federal_state",
      "input.farm.year",
      "input.land.arable_area_ha",
      "input.land.parcels",
      "input.measure"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| measure_sheet_o6_7 | full_document | 11 | {"not_rule": 1, "rules": 10} |
| general_terms | full_document | 11 | {"not_rule": 4, "rules": 7} |
| srl_oepul_main | targeted_sections | 7 | {"rules": 7} |
| srl_oepul_annexes | targeted_sections | 3 | {"not_rule": 1, "rules": 2} |
| drought_notice_2026_08_05 | full_document | 3 | {"not_rule": 1, "rules": 2} |
| drought_notice_2026_08_12 | full_document | 3 | {"not_rule": 1, "rules": 2} |
| biodiversity_notice_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| insecticide_notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Die native compliance-Ausgabe für einen synthetischen Begrünungssachverhalt aufnehmen. |
| variation | defined | ja | Nur die Ackerfläche von 10 auf 1,4 ha ändern und die Mindestflächenprüfung beobachten. |
| missing_fact | defined | nein | cover_share_percent entfernen und prüfen, ob der Kandidat fehlende Quote und festgestellte Erfüllung unterscheidet. |

**Offene Abhängigkeiten:**

- Eine produktive Tag-des-Jahres-Konvertierung muss Kalender- und Schaltjahre zentral berücksichtigen.
- Der Kandidat hat keine profile_missing-Ausgabe für sämtliche konsumierten Begrünungs-/Betriebsfakten.
- Glaubhaftmachung und räumlich/zeitlich begrenzte Ausnahmen 2026 brauchen eigenständig geprüfte Nachweise, wenn sie im Versuchsausschnitt verwendet werden.

**Belege:**

- [runs/v2-o6_7-luna-high-20261002/workspace/policy/o6_7.rego](../../../runs/v2-o6_7-luna-high-20261002/workspace/policy/o6_7.rego): Nativer Eingabeverbrauch und abgefragte Ausgabe; Änderungen werden gegen diese historische Policy untersucht.
- [runs/v2-o6_7-luna-high-20261002/workspace/tests/o6_7_test.rego](../../../runs/v2-o6_7-luna-high-20261002/workspace/tests/o6_7_test.rego): Die Basis entspricht base_input/test_compliant_profile; die Flächenänderung entspricht low_area_input/test_minimum_area_violation. Das Entfernen der Begrünungsquote ist eine eigene Einzeländerung an der vom Policy-Vergleich konsumierten Tatsache.
- [runs/v2-o6_7-luna-high-20261002/workspace/notes/assumptions.md](../../../runs/v2-o6_7-luna-high-20261002/workspace/notes/assumptions.md): Historische Eingabe-, Quellen- und Integrationsannahmen; keine unabhängige fachliche Bestätigung.

### o6_8

Run: `v2-o6_8-luna-high-20261002`. [Fixture](fixtures/o6_8.json) · [Native Ergebnisse](results/o6_8.json)

**Eingaben:** farm.year und Gebiet; land.parcels mit synthetischer parcel_id, area_ha in ha, nativem Kulturlabel, Code BAW und Erosionsfakten. erosion_entry_path_share ist Anteil 0–1, entry_path_area_ha ist ha, die KG-Nummer ein String aus dem historischen Lookup. Keine reale GIS-Lage wird behauptet.

**Ausgabebedeutung:** Das native decision verbindet mehrere Teilbefunde. compliant und minimum_area_satisfied haben keinen Default; bei einer unerfüllten Teilbedingung kann das ganze decision undefiniert sein. baw_eligible ist ein separater Teilbefund und wird nicht vollständig in compliant verbunden. Ein definierter Befund ist keine vollständige Förderfreigabe; eine undefinierte Ausgabe darf nicht als fachliche Ablehnung normalisiert werden.

**Herkunft:** Die Basis kombiniert die Eingaben aus test_baw_is_eligible_and_capped in einem synthetischen Profil. Variation und Entfernung der KG-Nummer sind eigene Einzeländerungen an den dort überprüften Erosionsfakten. Alle Fälle sind synthetische Entwicklungsfälle, keine unabhängig beurteilten Referenz- oder zurückgehaltenen Testfälle.

**Query:** `data.oepul.o6_8.decision`

**Inventar:** 39 Regelkatalog-Einträge; 8 Quellen; 8 statisch erkannte Eingabepfade; 12 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"2026_force_majeure_exception": 2, "application_codes": 1, "application_deadline": 1, "area_reduction_tolerance": 1, "baw_area_cap": 1, "baw_duration": 1, "baw_eligibility": 1, "baw_establishment": 1, "baw_maintenance": 1, "closed_culture_list": 3, "combination_requirement": 2, "contract_duration": 1, "eligibility_scope": 1, "eligible_crops": 1, "general_access": 1, "general_management": 1, "legal_cross_reference": 1, "location": 1, "measure_change": 1, "measure_combination_table": 1, "method_definition": 3, "minimum_area": 1, "parcel_combination": 2, "potato_hilling": 1, "preceding_cover_crop": 1, "premium_rate": 1, "sanction_consequence": 1, "undersowing": 1, "undersowing_harvest": 1, "undersowing_maintenance": 1, "vienna_exclusion": 1, "withdrawal_consequence": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm",
      "input.farm.oepul.measure_applications",
      "input.farm.region",
      "input.farm.region.district",
      "input.farm.region.federal_state",
      "input.farm.year",
      "input.land",
      "input.land.parcels"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_8 | full_document | 12 | {"not_rule": 1, "rules": 11} |
| o6_general | full_document | 15 | {"not_rule": 8, "rules": 7} |
| srl_oepul_2023 | targeted_sections | 4 | {"rules": 4} |
| srl_oepul_2023_anhaenge | targeted_sections | 3 | {"rules": 3} |
| notice_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026_08_12 | full_document | 3 | {"not_rule": 1, "rules": 2} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Die native Entscheidung mit dem synthetischen BAW- und Vierfachflächenbeispiel erfassen. |
| variation | undefined | ja | Nur die Eintragspfadfläche von 0,10 auf 0,09 ha setzen, sodass der native Vierfachvergleich eine andere Tatsachenbasis erhält. |
| missing_fact | defined | ja | Die konsumierte KG-Nummer entfernen; getrennt von Flächenbegrenzung und compliant die native Ausgabe beobachten. |

**Offene Abhängigkeiten:**

- Historische Annahmen dokumentieren eine Abweichung zwischen Viertelschwelle des Maßnahmenblatts und teilweise in der Sonderrichtlinie; vor Sollurteilen für diese Schwelle fachlich klären.
- Kulturlabel mit nur-MS-/Jahressuffixen und GIS-/KG-Lookup brauchen einen expliziten, versionierten Eingabevertrag.
- Die native Entscheidung kann bei violations vollständig undefiniert werden; dazu ist eine App-/Ausgabevertragsentscheidung erforderlich.
- BAW-Teilzulässigkeit wird nicht als vollständige Gesamtzulässigkeit geprüft; fehlende KG-Zuordnung muss als Lücke erhalten bleiben.

**Belege:**

- [runs/v2-o6_8-luna-high-20261002/workspace/policy/o6_8.rego](../../../runs/v2-o6_8-luna-high-20261002/workspace/policy/o6_8.rego): Nativer Eingabeverbrauch und abgefragte Ausgabe; Änderungen werden gegen diese historische Policy untersucht.
- [runs/v2-o6_8-luna-high-20261002/workspace/tests/o6_8_test.rego](../../../runs/v2-o6_8-luna-high-20261002/workspace/tests/o6_8_test.rego): Die Basis kombiniert die Eingaben aus test_baw_is_eligible_and_capped in einem synthetischen Profil. Variation und Entfernung der KG-Nummer sind eigene Einzeländerungen an den dort überprüften Erosionsfakten.
- [runs/v2-o6_8-luna-high-20261002/workspace/notes/assumptions.md](../../../runs/v2-o6_8-luna-high-20261002/workspace/notes/assumptions.md): Historische Eingabe-, Quellen- und Integrationsannahmen; keine unabhängige fachliche Bestätigung.

### o6_9

Run: `v2-o6_9-luna-high-20261002`. [Fixture](fixtures/o6_9.json) · [Native Ergebnisse](results/o6_9.json)

**Eingaben:** Natives input mit measure, participation, application, separation, pig_feeding und calculation. Mengen sind m³, Flächen ha, cattle_gve/GVE sind native Berechnungsgrößen. records_include ist eine JSON-Liste der nativen Eintragsnamen; Rego-Set-Konstanten der Modelltests werden für die Mitgliedschaftsprüfungen als Listen dargestellt.

**Ausgabebedeutung:** result enthält eligible, violations, warnings und eine native Bruttoprämie. eligible verbindet nicht alle Aufzeichnungs-/Fristverletzungen; Prämienkomponenten werden ohne gemeinsame Freigabe berechnet. eligible oder premium allein sind deshalb keine vollständige Förderfreigabe oder zugesicherte Auszahlung.

**Herkunft:** Die Basis entspricht test_valid_application_and_separation; dessen records_include-Sets sind als JSON-Listen mit denselben Werten dargestellt. Die Methodenumstellung ist vom test_application_cap_and_disallowed_device und application_method_allowed abgeleitet, das Entfernen der Aufzeichnungsliste eine eigene Einzeländerung. Alle Fälle sind synthetische Entwicklungsfälle, keine unabhängig beurteilten Referenz- oder zurückgehaltenen Testfälle.

**Query:** `data.oepul.o6_9.result`

**Inventar:** 42 Regelkatalog-Einträge; 8 Quellen; 31 statisch erkannte Eingabepfade; 12 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_condition": 1, "application_data": 1, "area_definition": 1, "calculation_basis": 1, "closed_list": 1, "combination": 1, "combination_exclusion": 1, "contract_consequence": 1, "contract_period": 1, "conversion_factor": 1, "deadline": 3, "definition": 1, "effective_date": 1, "eligibility_condition": 2, "eligibility_exclusion": 3, "evidence": 3, "exit": 1, "exit_consequence": 1, "feeding_option": 1, "feeding_requirement": 1, "general_condition": 1, "independence": 1, "minimum_participation": 1, "premium_cap": 2, "premium_modulation": 1, "premium_rate": 3, "recordkeeping": 2, "recordkeeping_option": 1, "sanction": 1, "scope": 1, "transfer": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.application.biogas_has_excluded_input",
      "input.application.injected_rainwater",
      "input.application.is_water_mixed_solid_manure",
      "input.application.land_use",
      "input.application.manure_type",
      "input.application.method",
      "input.application.records_complete",
      "input.application.records_include",
      "input.application.requested_by_december_31",
      "input.application.requested_m3",
      "input.calculation.arable_area_ha",
      "input.calculation.cattle_gve",
      "input.calculation.eligible_fertilizable_area_ha",
      "input.farm.arable_area_ha",
      "input.farm.year",
      "input.measure",
      "input.participation.application_m3",
      "input.participation.base_measure_valid",
      "input.participation.categories",
      "input.participation.groundwater_protection_pig_bonus",
      "input.participation.measure_requested_by_december_31",
      "input.participation.separated_m3",
      "input.pig_feeding.all_pigs_compliant",
      "input.pig_feeding.gve_pigs_annual_average",
      "input.pig_feeding.proof_available",
      "input.separation.mechanical_phase_separation",
      "input.separation.origin",
      "input.separation.records_complete",
      "input.separation.records_include",
      "input.separation.requested_m3",
      "input.separation.separated_m3"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_9_measure_sheet | full_document | 9 | {"not_rule": 1, "rules": 8} |
| general_conditions_2026 | full_document | 10 | {"not_rule": 2, "rules": 8} |
| srl_20241011 | targeted_sections | 6 | {"rules": 6} |
| srl_anhaenge_20241011 | targeted_sections | 2 | {"rules": 2} |
| drought_biodiversity_2026 | full_document | 1 | {"not_rule": 1} |
| insecticide_exit_2026 | full_document | 1 | {"not_rule": 1} |
| drought_az_2026 | full_document | 1 | {"not_rule": 1} |
| drought_processing_2026 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Native Ausbringungs- und Separationsausgabe auf einer vollständig synthetischen Mengenbasis aufnehmen. |
| variation | defined | ja | Nur application.method von trailing_shoe auf broadcast ändern und Teilurteil sowie verbleibende Prämienkomponenten prüfen. |
| missing_fact | defined | ja | Nur application.records_include entfernen und violations gemeinsam mit eligible und premium beobachten. |

**Offene Abhängigkeiten:**

- Anträge, Ereignisse, Aufzeichnungsnachweise und düngungswürdige Flächen sind im nativen Farmprofil nicht vollständig enthalten.
- Die native Bruttoprämie enthält keine allgemeine Betriebsgrößenmodulation und ist nicht durch einen gemeinsamen Auszahlungsentscheid gegated.
- Für den optionalen Schweinefütterungsteil bleibt laut Annahmen die Rohproteingrenze gedeckter Jungsauen ab 50 kg offen; dieser Teil ist in diesen Fällen nicht aktiviert.
- Die Trennung zwischen Kernanforderungen, Dokumentationsverletzungen und eligible muss vor einer App-Freigabe explizit festgelegt werden.

**Belege:**

- [runs/v2-o6_9-luna-high-20261002/workspace/policy/o6_9.rego](../../../runs/v2-o6_9-luna-high-20261002/workspace/policy/o6_9.rego): Nativer Eingabeverbrauch und abgefragte Ausgabe; Änderungen werden gegen diese historische Policy untersucht.
- [runs/v2-o6_9-luna-high-20261002/workspace/tests/o6_9_test.rego](../../../runs/v2-o6_9-luna-high-20261002/workspace/tests/o6_9_test.rego): Die Basis entspricht test_valid_application_and_separation; dessen records_include-Sets sind als JSON-Listen mit denselben Werten dargestellt. Die Methodenumstellung ist vom test_application_cap_and_disallowed_device und application_method_allowed abgeleitet, das Entfernen der Aufzeichnungsliste eine eigene Einzeländerung.
- [runs/v2-o6_9-luna-high-20261002/workspace/notes/assumptions.md](../../../runs/v2-o6_9-luna-high-20261002/workspace/notes/assumptions.md): Historische Eingabe-, Quellen- und Integrationsannahmen; keine unabhängige fachliche Bestätigung.

### o6_10

Run: `v2-o6_10-luna-high-20261003`. [Fixture](fixtures/o6_10.json) · [Native Ergebnisse](results/o6_10.json)

**Eingaben:** farm.year; synthetische land.parcels mit Fläche ha, slope_percent in Prozent, crop_category=vineyard und parzellenspezifischem o6_10. open_stem_width_cm ist cm, Partneranzahl ist Ganzzahl; das Wurzelobjekt o6_10 enthält beantragte Teilnahme und Aufzeichnungs-/Zuschlagsfakten.

**Ausgabebedeutung:** Die explizite Projektion verwendet nur native Entscheidungs-/Prämienausgaben, da kein result/decision existiert. eligible ist requested und keine erkannten violations. Fehlende Felder werden teilweise mit false/0 ersetzt; leere records lösen keine Vollständigkeitsverletzung aus. Prämienberechnung verwendet historische Sätze und ist keine unabhängig bestätigte Förder-/Auszahlungsaussage.

**Herkunft:** Die Basis entspricht sample/test_valid_vineyard. Die 81-cm-Variation und das entfernte Hangneigungsfeld sind eigene Einzeländerungen, belegt durch open_stem_area_exceeded und wine_rate in der nativen Policy. Alle Fälle sind synthetische Entwicklungsfälle, keine unabhängig beurteilten Referenz- oder zurückgehaltenen Testfälle.

**Query:** `{"eligible": data.oepul.o6_10.eligible, "violations": data.oepul.o6_10.violations, "eligible_area_ha": data.oepul.o6_10.eligible_area_ha, "premium_eur_per_ha": data.oepul.o6_10.premium_eur_per_ha, "surcharge_eur_per_ha": data.oepul.o6_10.surcharge_eur_per_ha, "total_premium_eur": data.oepul.o6_10.total_premium_eur}`

**Inventar:** 37 Regelkatalog-Einträge; 8 Quellen; 18 statisch erkannte Eingabepfade; 3 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application_code": 1, "application_deadline": 1, "contract_duration": 1, "cultivation_obligation": 8, "deadline": 1, "double_funding_exclusion": 1, "eligibility": 2, "eligible_area": 1, "entry_deadline": 1, "exception": 1, "farm_access": 1, "location": 1, "minimum_management": 1, "optional_surcharge": 1, "plant_protection_restriction": 1, "premium_calculation": 6, "quality_requirement": 1, "recordkeeping": 2, "sanction": 1, "temporary_exception": 1, "use_restriction": 1, "withdrawal": 1, "withdrawal_effect": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm",
      "input.farm.year",
      "input.land",
      "input.land.parcels",
      "input.land.parcels[].crop.crop_category",
      "input.land.parcels[].slope_percent",
      "input.o6_10",
      "input.o6_10.application_replaces_pesticide",
      "input.o6_10.drought_2026",
      "input.o6_10.insecticide_avoidance",
      "input.o6_10.operation_program_organisms_or_pheromones",
      "input.o6_10.organic_farming",
      "input.o6_10.organism_or_pheromone_surcharge_requested",
      "input.o6_10.proper_cover_establishment",
      "input.o6_10.records",
      "input.o6_10.records.farm",
      "input.o6_10.requested",
      "input.o6_10.surcharge_applied_on_at_least_one_plot"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_10 | full_document | 17 | {"not_rule": 2, "rules": 15} |
| o6_general | full_document | 21 | {"not_rule": 11, "rules": 10} |
| srl_oepul_2023 | targeted_sections | 7 | {"rules": 7} |
| srl_oepul_2023_anhaenge | targeted_sections | 2 | {"rules": 2} |
| notice_2026-05-22 | full_document | 1 | {"not_rule": 1} |
| notice_2026-06-12 | full_document | 1 | {"not_rule": 1} |
| notice_2026-08-05 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026-08-12 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Die öffentlichen nativen Teilurteile und Prämienausgaben für das synthetische Weinflächenbeispiel aufnehmen. |
| variation | defined | ja | Nur open_stem_width_cm von 80 auf 81 cm setzen und die konsumierte Breitenprüfung beobachten. |
| missing_fact | defined | ja | slope_percent entfernen und den nativen Default bei der für Prämiensätze verwendeten Hangneigung sichtbar machen. |

**Offene Abhängigkeiten:**

- Für eine produktive Integration fehlen die belegte AMA-Kulturcodierung und eine versionierte GIS-Hangneigung als Eingabevertrag.
- Die Abgrenzung der optionalen Zuschlagsflächen ist laut historischen Annahmen zu verifizieren; die vorliegenden Fälle beantragen diesen Zuschlag nicht.
- Fehlende Hangneigung und leere Aufzeichnungsobjekte werden nicht als explizit unbekannt ausgewiesen; dies muss im App-Ausgabevertrag sichtbar bleiben.
- Allgemeine Förderbedingungen und sämtliche Kombinations-/Zeitbedingungen sind nicht automatisch durch eligible abgedeckt.

**Belege:**

- [runs/v2-o6_10-luna-high-20261003/workspace/policy/o6_10.rego](../../../runs/v2-o6_10-luna-high-20261003/workspace/policy/o6_10.rego): Nativer Eingabeverbrauch und abgefragte Ausgabe; Änderungen werden gegen diese historische Policy untersucht.
- [runs/v2-o6_10-luna-high-20261003/workspace/tests/o6_10_test.rego](../../../runs/v2-o6_10-luna-high-20261003/workspace/tests/o6_10_test.rego): Die Basis entspricht sample/test_valid_vineyard. Die 81-cm-Variation und das entfernte Hangneigungsfeld sind eigene Einzeländerungen, belegt durch open_stem_area_exceeded und wine_rate in der nativen Policy.
- [runs/v2-o6_10-luna-high-20261003/workspace/notes/assumptions.md](../../../runs/v2-o6_10-luna-high-20261003/workspace/notes/assumptions.md): Historische Eingabe-, Quellen- und Integrationsannahmen; keine unabhängige fachliche Bestätigung.

### o6_11

Run: `v2-o6_11-luna-20260920`. [Fixture](fixtures/o6_11.json) · [Native Ergebnisse](results/o6_11.json)

**Eingaben:** farm.year ist der historische Betrachtungsjahrwert 2024; Antrags-/Vertragsbeginn separat unter farm.oepul. land.oepul_eligible_area_ha und parcel.area_ha sind ha. PSM-Anwendungen liegen als Liste unter operations.pesticide_applications, mit nativen Wirkungstyp-/Herbizidmerkmalen; keine Registerabfrage wird behauptet.

**Ausgabebedeutung:** decision.eligible entspricht ausschließlich minimum_participation_area_satisfied, also Zielkulturfläche &gt;=0,5 ha. Herbizid-, Kauf-/Lager- und Kombinationsbefunde werden separat ausgegeben und können zugleich mit eligible=true vorkommen. premium_amount_eur ist Flächenmultiplikation ohne vollständige Freigabe. Fehlende Anwendungslisten werden wie leere Listen behandelt.

**Herkunft:** Die Basis kombiniert base_profile/test_minimum_area_and_premium mit land.oepul_eligible_area_ha=1,5 aus test_general_minimum_farm_size_by_eligible_area. Die Anwendung entspricht test_herbicide_application_is_violation; die Entfernung der Liste ist eine eigene Einzeländerung. Alle Fälle sind synthetische Entwicklungsfälle, keine unabhängig beurteilten Referenz- oder zurückgehaltenen Testfälle.

**Query:** `data.oepul.o6_11.decision`

**Inventar:** 26 Regelkatalog-Einträge; 8 Quellen; 12 statisch erkannte Eingabepfade; 9 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_requirement": 1, "annual_area_rule": 1, "application_deadline": 1, "area_access_rule": 1, "area_scope": 1, "calculation": 1, "calculation_adjustment": 1, "classification_rule": 1, "combination": 1, "content_obligation": 2, "contract_obligation": 1, "contract_period": 1, "eligibility": 1, "eligibility_exclusion": 2, "entry_deadline": 1, "general_access_requirement": 1, "general_content_obligation": 1, "general_eligibility": 1, "measure_switch": 1, "prohibition": 1, "reporting_exemption": 1, "reporting_obligation": 1, "reporting_rule": 1, "scope": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm",
      "input.farm.oepul",
      "input.farm.oepul.herbicide_purchases_storage",
      "input.farm.oepul.k20_continuation_only",
      "input.farm.oepul.measure_applications",
      "input.farm.oepul.o6_11_application_year",
      "input.farm.oepul.o6_11_contract_start_year",
      "input.farm.year",
      "input.land",
      "input.land.oepul_eligible_area_ha",
      "input.land.parcels",
      "input.land.protected_cultivation_area_ha"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_11 | full_document | 10 | {"not_rule": 1, "rules": 9} |
| o6_general | full_document | 15 | {"not_rule": 3, "rules": 12} |
| srl-oepul-2023 | targeted_sections | 7 | {"rules": 7} |
| srl-oepul-2023-annexes | targeted_sections | 2 | {"rules": 2} |
| notice-2026-05-22 | full_document | 1 | {"not_rule": 1} |
| notice-2026-06-12 | full_document | 1 | {"not_rule": 1} |
| notice-2026-08-05 | full_document | 1 | {"not_rule": 1} |
| notice-2026-08-12 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Die native Entscheidung mit synthetischer Weinfläche und expliziter Mindestbetriebsfläche aufnehmen. |
| variation | defined | ja | Nur eine native Herbizidanwendung hinzufügen und eligible gemeinsam mit herbicide_ban_satisfied, violations und premium_amount_eur beobachten. |
| missing_fact | defined | nein | Die gesamte PSM-Anwendungsliste entfernen, um fehlende Information gegenüber einer explizit leeren Liste zu untersuchen. |

**Offene Abhängigkeiten:**

- Für belastbare PSM-Sollurteile fehlen ein versionierter Register-/Wirkungstypvertrag und verlässliche Anwendungs-/Kauf-/Lagerdaten.
- eligible ist ein Mindestflächen-Teilurteil; vollständige Förderfreigabe muss separate Bedingungen und Verletzungen berücksichtigen.
- Das historische Beispiel verwendet 2024; heutige Aufnahme-, Vertrags- und Quellenjahre dürfen nicht stillschweigend gleichgesetzt werden.
- Die historischen Annahmen und ausführbare Policy beschreiben Walnuss-Zielflächen unterschiedlich; eine fachlich beurteilte Kulturabgrenzung ist für solche Fälle erforderlich.

**Belege:**

- [runs/v2-o6_11-luna-20260920/workspace/policy/o6_11.rego](../../../runs/v2-o6_11-luna-20260920/workspace/policy/o6_11.rego): Nativer Eingabeverbrauch und abgefragte Ausgabe; Änderungen werden gegen diese historische Policy untersucht.
- [runs/v2-o6_11-luna-20260920/workspace/tests/o6_11_test.rego](../../../runs/v2-o6_11-luna-20260920/workspace/tests/o6_11_test.rego): Die Basis kombiniert base_profile/test_minimum_area_and_premium mit land.oepul_eligible_area_ha=1,5 aus test_general_minimum_farm_size_by_eligible_area. Die Anwendung entspricht test_herbicide_application_is_violation; die Entfernung der Liste ist eine eigene Einzeländerung.
- [runs/v2-o6_11-luna-20260920/workspace/notes/assumptions.md](../../../runs/v2-o6_11-luna-20260920/workspace/notes/assumptions.md): Historische Eingabe-, Quellen- und Integrationsannahmen; keine unabhängige fachliche Bestätigung.

### o6_12

Run: `v2-o6_12-luna-high-20261003`. [Fixture](fixtures/o6_12.json) · [Native Ergebnisse](results/o6_12.json)

**Eingaben:** Native Eingaben unter farm.measures.o6_12 und land.parcels[].operations; Förderjahr als Ganzzahl, Fläche in ha, boolesche Einsatz-/Ausnahme-/Nachweisfelder. Basis ist das synthetische Modellbeispiel mit Förderjahr 2024; keine Übertragung auf 2026.

**Ausgabebedeutung:** Kein aggregiertes decision/result-Objekt: Die Query projiziert belegte Mindestteilnahme-/Kombinationschecks, Verletzungsmengen, Zielfläche und Prämiensatz. Eine Verletzungsmenge [] bedeutet nur keine ausgelöste Verletzungsregel; ein fehlender Einsatznachweis kann darin unauffällig bleiben. Der Prämiensatz wird unabhängig von Verletzungen berechnet. premium_eligible ist eine separate positive Regel ohne false-Default und wird nicht durch diese Projektion als Gesamturteil ersetzt; eine vollständige Förderfreigabe fehlt.

**Herkunft:** Synthetische Entwicklungsfälle aus dem modellgenerierten Testbeispiel; gezielte Änderungen durch Codex zur diagnostischen Sichtung. Keine unabhängigen Sollurteile, keine Expertenvalidierung, keine Golden- oder Held-out-Fälle.

**Query:** `{"minimum_participation_met": data.oepul.o6_12.minimum_participation_met, "insecticide_violation": data.oepul.o6_12.insecticide_violation, "purchase_storage_violation": data.oepul.o6_12.purchase_storage_violation, "combination_allowed": data.oepul.o6_12.combination_allowed, "premium_rate_eur_per_ha": data.oepul.o6_12.premium_rate_eur_per_ha, "target_area_ha": data.oepul.o6_12.target_area_ha}`

**Inventar:** 24 Regelkatalog-Einträge; 8 Quellen; 21 statisch erkannte Eingabepfade; 9 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application_deadline": 1, "area_change": 1, "calculation": 1, "combination": 1, "contract_period": 1, "deadline": 1, "definition": 1, "eligibility_condition": 1, "eligibility_threshold": 1, "exception": 2, "exclusion": 2, "general_eligibility": 2, "measure_switch": 1, "reporting": 1, "sanction": 1, "scope": 1, "substantive_obligation": 2, "temporary_exception": 2, "transitional_rule": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.measures.o6_12.area_wide_psm_application",
      "input.farm.measures.o6_12.authority_order_documented",
      "input.farm.measures.o6_12.authority_ordered_area",
      "input.farm.measures.o6_12.authority_ordered_chemical_synthetic_insecticide",
      "input.farm.measures.o6_12.authority_ordered_control",
      "input.farm.measures.o6_12.authority_ordered_substance_allowed",
      "input.farm.measures.o6_12.biological_farming_participation",
      "input.farm.measures.o6_12.biological_farming_scope",
      "input.farm.measures.o6_12.chemical_synthetic_insecticide_used",
      "input.farm.measures.o6_12.contract_start_year",
      "input.farm.measures.o6_12.early_exit_approved",
      "input.farm.measures.o6_12.early_exit_reason",
      "input.farm.measures.o6_12.first_participation_year",
      "input.farm.measures.o6_12.participating",
      "input.farm.measures.o6_12.premium_target_type",
      "input.farm.measures.o6_12.quality_planting_material_ok",
      "input.farm.measures.o6_12.sonstige_target_land_use",
      "input.farm.measures.o6_12.switch_request_date",
      "input.farm.region.federal_state",
      "input.farm.year",
      "input.land.parcels"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_12_measure_sheet_2026_04 | full_document | 9 | {"not_rule": 1, "rules": 8} |
| o6_general_conditions_2026_04 | full_document | 24 | {"not_rule": 11, "rules": 13} |
| srl_oepul_2023_measure_12 | targeted_sections | 5 | {"rules": 5} |
| srl_oepul_2023_annex_l | targeted_sections | 2 | {"rules": 2} |
| notice_2026_05_22_biodiversity_drought | full_document | 1 | {"not_rule": 1} |
| notice_2026_06_12_early_exit_rebzikade | full_document | 1 | {"rules": 1} |
| notice_2026_08_05_drought | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_12_drought | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | ja | insecticide_use von false auf true ändern; belegte eingesetzte Kultur und alle übrigen Fakten beibehalten. |
| missing_fact | defined | nein | insecticide_use entfernen; beobachten, ob ein fehlender Einsatznachweis als unbekannt sichtbar wird oder die Verletzung ausbleibt. |

**Offene Abhängigkeiten:**

- Historischer Luna-Quellenstand bleibt unverändert; Übereinstimmung mit dem aktuellen Quellenpaket und verbindliche Gesamtauslegung sind vor einer produktiven Übernahme separat zu prüfen.
- Native Eingaben sind kein gemeinsamer App-Vertrag; Herkunft, Vollständigkeit und Bedeutung der entscheidungsrelevanten Nachweisfelder benötigen eine gesonderte Zuordnung.
- Es fehlt ein aggregiertes Drei-Zustände-Gesamturteil; Insektizid-/Ausnahmeflags ohne Nachweis und die getrennte Kombinationsprüfung dürfen nicht als Förderfreigabe interpretiert werden.
- Beobachtet bei isolierter OPA-Ausführung: Entfernen von insecticide_use liefert dieselbe projizierte Ausgabe wie der Basisfall; ein Missing-Data-Code fehlt. Die belegte Änderung auf true erzeugt dagegen insecticide_violation=[W1].

**Belege:**

- [runs/v2-o6_12-luna-high-20261003/workspace/policy/o6_12.rego](../../../runs/v2-o6_12-luna-high-20261003/workspace/policy/o6_12.rego): Belegt die Query, tatsächlich konsumierte Eingabefelder, Checks und Berechnungen; die Variations- und Entfernungsfälle ändern jeweils genau einen konsumierten Blattwert.
- [runs/v2-o6_12-luna-high-20261003/workspace/tests/o6_12_test.rego](../../../runs/v2-o6_12-luna-high-20261003/workspace/tests/o6_12_test.rego): Modellgenerierte synthetische Entwicklungsbeispiele und Grenzwerte; keine unabhängige Ground Truth.
- [runs/v2-o6_12-luna-high-20261003/workspace/notes/assumptions.md](../../../runs/v2-o6_12-luna-high-20261003/workspace/notes/assumptions.md): Dokumentiert historische Quellen-/Eingabeannahmen und offene Integrations-/Auslegungsfragen.

### o6_13

Run: `v2-o6_13-luna-high-20261004`. [Fixture](fixtures/o6_13.json) · [Native Ergebnisse](results/o6_13.json)

**Eingaben:** Native Antragseingaben unter farm.measure_application; schlagbezogene protected_cultivation, measure_application und organism_application. Fläche in ha, harvested_percent in Prozent, Datum als ISO-String; quantity ist der native positive Mengenwert ohne im Run festgelegte Einheit. AGES-Eintrag und Aufwandkonformität bleiben synthetisch gesetzte Nachweisflags.

**Ausgabebedeutung:** decision enthält eligible, Vertrags-/Frist-/Mindestflächenchecks sowie Prämienindikationen. eligible gilt ausschließlich für die modellierten Bedingungen; fehlende Angaben können über Defaults zu false werden, ein eigener Missing-Data-Status fehlt.

**Herkunft:** Synthetische Entwicklungsfälle aus dem modellgenerierten Testbeispiel; gezielte Änderungen durch Codex zur diagnostischen Sichtung. Keine unabhängigen Sollurteile, keine Expertenvalidierung, keine Golden- oder Held-out-Fälle.

**Query:** `data.oepul.o6_13.decision`

**Inventar:** 32 Regelkatalog-Einträge; 8 Quellen; 50 statisch erkannte Eingabepfade; 6 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application_code": 1, "application_continuation": 1, "application_deadline": 1, "area_exclusion": 1, "combination": 1, "contract_duration": 1, "controls": 1, "eligible_area": 2, "entry_deadline": 1, "exclusion": 1, "force_majeure_2026": 1, "general_eligibility": 1, "general_management": 1, "general_minimum_size": 1, "land_use_classification": 3, "location": 1, "minimum_participation": 1, "modulation": 1, "operational_requirement": 2, "payment": 1, "premium": 2, "premium_cap": 1, "recordkeeping": 1, "sanction": 1, "scope": 1, "withdrawal": 1, "withdrawal_effect": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm",
      "input.farm.measure_application",
      "input.farm.measure_application.contract_year",
      "input.farm.measure_application.drought_no_harvestable_stock",
      "input.farm.measure_application.first_participation",
      "input.farm.measure_application.requested",
      "input.farm.measure_application.submitted_by",
      "input.farm.operation_program",
      "input.farm.operation_program.member",
      "input.farm.operation_program.organism_use_compensated",
      "input.farm.region",
      "input.farm.region.country",
      "input.farm.region.district",
      "input.farm.region.federal_state",
      "input.farm.year",
      "input.land",
      "input.land.alpine_pasture_area_ha",
      "input.land.arable_area_ha",
      "input.land.grassland_area_ha",
      "input.land.parcels",
      "input.land.parcels[].area_ha",
      "input.land.parcels[].land_use",
      "input.land.parcels[].measure_application.code",
      "input.land.parcels[].measure_application.crop_is_late_summer_or_autumn",
      "input.land.parcels[].measure_application.harvested_percent",
      "input.land.parcels[].measure_application.other_premium",
      "input.land.parcels[].measure_application.proper_annual_care",
      "input.land.parcels[].measure_application.proper_cultivation",
      "input.land.parcels[].measure_application.requested",
      "input.land.parcels[].organism_application",
      "input.land.parcels[].organism_application.ages_register_entry",
      "input.land.parcels[].organism_application.application_rate_compliant",
      "input.land.parcels[].organism_application.date",
      "input.land.parcels[].organism_application.goal",
      "input.land.parcels[].organism_application.is_pollinator_only",
      "input.land.parcels[].organism_application.organism_type",
      "input.land.parcels[].organism_application.purchase_evidence",
      "input.land.parcels[].organism_application.quantity",
      "input.land.parcels[].organism_application.reason",
      "input.land.parcels[].organism_application.replaces_plant_protection_use",
      "input.land.parcels[].protected_cultivation",
      "input.land.parcels[].protected_cultivation.active_production",
      "input.land.parcels[].protected_cultivation.aisle_necessary",
      "input.land.parcels[].protected_cultivation.area_role",
      "input.land.parcels[].protected_cultivation.classification_medium_april_1",
      "input.land.parcels[].protected_cultivation.cultivation_medium",
      "input.land.parcels[].protected_cultivation.is_protected_cultivation",
      "input.land.parcels[].protected_cultivation.structure_type",
      "input.land.special_crops_area_ha",
      "input.land.total_area_ha"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_13_sheet | full_document | 11 | {"not_rule": 1, "rules": 10} |
| o6_general_sheet | full_document | 21 | {"not_rule": 6, "rules": 15} |
| srl_oepul_2023 | targeted_sections | 10 | {"rules": 10} |
| srl_oepul_annexes | targeted_sections | 3 | {"not_rule": 1, "rules": 2} |
| notice_drought_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| notice_rebzikade_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_drought_2026_08_05 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_drought_2026_08_12 | full_document | 2 | {"not_rule": 1, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | ja | is_pollinator_only von false auf true ändern; beobachten, wie eine ausschließliche Bestäubung den Befund verändert. |
| missing_fact | defined | ja | purchase_evidence aus organism_application entfernen; untersuchen, ob die fehlende Kaufbelegeingabe getrennt von einer belegten Nichterfüllung erkennbar ist. |

**Offene Abhängigkeiten:**

- Historischer Luna-Quellenstand bleibt unverändert; Übereinstimmung mit dem aktuellen Quellenpaket und verbindliche Gesamtauslegung sind vor einer produktiven Übernahme separat zu prüfen.
- Native Eingaben sind kein gemeinsamer App-Vertrag; Herkunft, Vollständigkeit und Bedeutung der entscheidungsrelevanten Nachweisfelder benötigen eine gesonderte Zuordnung.
- Registereintrag/Aufwandkonformität werden als Eingabeflags konsumiert; die Zulässigkeit und Einheit der tatsächlich eingesetzten Menge ist hier nicht unabhängig bestätigt.
- Mehrfachanwendungen pro Schlag sowie die alternative Mindestflächenbasis sind laut Run-Annahmen offen.
- Beobachtet: Der fehlende Kaufbeleg und die belegte reine Bestäuberanwendung liefern jeweils eligible=false/premium_eur=0; das decision-Objekt enthält keinen Grundcode, der unbekannt von belegter Nichterfüllung unterscheidet.

**Belege:**

- [runs/v2-o6_13-luna-high-20261004/workspace/policy/o6_13.rego](../../../runs/v2-o6_13-luna-high-20261004/workspace/policy/o6_13.rego): Belegt die Query, tatsächlich konsumierte Eingabefelder, Checks und Berechnungen; die Variations- und Entfernungsfälle ändern jeweils genau einen konsumierten Blattwert.
- [runs/v2-o6_13-luna-high-20261004/workspace/tests/o6_13_test.rego](../../../runs/v2-o6_13-luna-high-20261004/workspace/tests/o6_13_test.rego): Modellgenerierte synthetische Entwicklungsbeispiele und Grenzwerte; keine unabhängige Ground Truth.
- [runs/v2-o6_13-luna-high-20261004/workspace/notes/assumptions.md](../../../runs/v2-o6_13-luna-high-20261004/workspace/notes/assumptions.md): Dokumentiert historische Quellen-/Eingabeannahmen und offene Integrations-/Auslegungsfragen.

### o6_14

Run: `v2-o6_14-luna-high-20261004`. [Fixture](fixtures/o6_14.json) · [Native Ergebnisse](results/o6_14.json)

**Eingaben:** Native almbezogene alpine_pastures und tierbezogene alpine_movements; area_ha in ha, gve als bereits aggregierter RGVE-Wert des Modellbeispiels, alpung_days und Meldefristen in Tagen. Förderjahr 2026; Erstteilnahmeflag ist hier ein Boolean. Keine Umrechnung von Tierzahlen oder Ableitung aus realen Meldedaten.

**Ausgabebedeutung:** rego_symbols ist das vorhandene Ausgabeobjekt mit eligible, Dichte je Alm, Basisprämien und Melde-/Tagesregeln. eligible prüft die implementierten Alm-Kernbedingungen; andere Fristfunktionen existieren separat und werden von eligible nicht aufgerufen. Prämienwerte können auch bei eligible=false berechnet werden und sind keine Förderzusage.

**Herkunft:** Synthetische Entwicklungsfälle aus dem modellgenerierten Testbeispiel; gezielte Änderungen durch Codex zur diagnostischen Sichtung. Keine unabhängigen Sollurteile, keine Expertenvalidierung, keine Golden- oder Held-out-Fälle.

**Query:** `data.oepul.o6_14.rego_symbols`

**Inventar:** 59 Regelkatalog-Einträge; 8 Quellen; 69 statisch erkannte Eingabepfade; 72 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_averaging": 1, "access_classification": 1, "animal_application": 1, "animal_housing": 1, "annex_e_rates": 1, "applicant": 1, "application": 1, "area_reduction": 1, "area_transfer": 1, "conditionality": 1, "contract_period": 1, "cross_alm_allocation": 1, "data_completeness": 1, "day_counting": 1, "definition": 1, "drought_force_majeure": 1, "duration_obligation": 1, "eligibility": 1, "eligible_animals": 1, "farm_minimum": 1, "feed": 1, "feed_prohibition": 1, "fertilizer": 1, "field_application": 1, "footnote": 1, "foreign_alm_relief": 1, "interruption": 1, "last_entry": 1, "location": 1, "minimum_duration": 1, "minimum_participation": 1, "minimum_participation_exception": 1, "modulation": 1, "nata_code": 1, "naturschutz_land_management": 2, "naturschutz_premium": 1, "naturschutz_stocking_limit": 1, "naturschutz_training": 1, "naturschutz_training_replacement": 1, "option_availability": 1, "option_combination": 1, "option_period": 1, "option_prerequisite": 1, "payment_application": 1, "per_alm_calculation": 1, "plan_content": 1, "plan_density_exception": 1, "plan_premium": 1, "plan_review": 1, "plan_training": 1, "plant_protection": 1, "premium_area_cap": 1, "premium_rate": 1, "reporting_deadline": 2, "reporting_exception": 1, "stocking_basis": 1, "stocking_limit": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.documentation",
      "input.documentation.oepul_application_date",
      "input.documentation.oepul_field_list_date",
      "input.documentation.oepul_only_cattle",
      "input.documentation.oepul_participates_tierwohl_behirtung",
      "input.documentation.oepul_reports",
      "input.documentation.oepul_reports.cattle_arrival_days",
      "input.documentation.oepul_reports.cattle_departure_days",
      "input.documentation.oepul_reports.other_arrival_days",
      "input.documentation.oepul_reports.other_departure_days",
      "input.documentation.oepul_stocking_list_date",
      "input.farm",
      "input.farm.year",
      "input.land",
      "input.land.alpine_pastures",
      "input.land.alpine_pastures[].access_stage",
      "input.land.alpine_pastures[].alm_id",
      "input.land.alpine_pastures[].alm_inputs",
      "input.land.alpine_pastures[].alm_inputs.fertilizer_bio_allowed",
      "input.land.alpine_pastures[].alm_inputs.fertilizer_used",
      "input.land.alpine_pastures[].alm_inputs.non_alpine_slurry_or_liquid_manure",
      "input.land.alpine_pastures[].alm_inputs.pesticide_bio_only",
      "input.land.alpine_pastures[].alm_inputs.pesticide_used",
      "input.land.alpine_pastures[].alm_inputs.separated_home_farm_slurry_solids",
      "input.land.alpine_pastures[].alm_inputs.sewage_sludge",
      "input.land.alpine_pastures[].almweideplan",
      "input.land.alpine_pastures[].almweideplan.communicated_to_workers",
      "input.land.alpine_pastures[].almweideplan.contains_required_assessment",
      "input.land.alpine_pastures[].almweideplan.course.hours",
      "input.land.alpine_pastures[].almweideplan.course.recognized_provider",
      "input.land.alpine_pastures[].almweideplan.course.relevant_content",
      "input.land.alpine_pastures[].almweideplan.plan_created_by_deadline",
      "input.land.alpine_pastures[].almweideplan.plan_for_all_alms",
      "input.land.alpine_pastures[].almweideplan.strong_intensity",
      "input.land.alpine_pastures[].almweideplan.strong_intensity_reason",
      "input.land.alpine_pastures[].area_ha",
      "input.land.alpine_pastures[].feed_practices",
      "input.land.alpine_pastures[].feed_practices.natural_fodder_sufficient",
      "input.land.alpine_pastures[].feed_practices.non_alpine_silage_or_green_fodder",
      "input.land.alpine_pastures[].feed_practices.own_alpine_silage",
      "input.land.alpine_pastures[].feed_practices.own_alpine_silage_fed_on_same_alm",
      "input.land.alpine_pastures[].is_in_austria",
      "input.land.alpine_pastures[].naturschutz",
      "input.land.alpine_pastures[].naturschutz.course",
      "input.land.alpine_pastures[].naturschutz.course.completed_by",
      "input.land.alpine_pastures[].naturschutz.course.hours",
      "input.land.alpine_pastures[].naturschutz.course.recognized_provider",
      "input.land.alpine_pastures[].naturschutz.course.relevant_content",
      "input.land.alpine_pastures[].naturschutz.no_new_drainage",
      "input.land.alpine_pastures[].naturschutz.no_terrain_correction",
      "input.land.alpine_pastures[].naturschutz.project_codes",
      "input.land.alpine_pastures[].naturschutz.project_confirmation_for_all_parcels",
      "input.land.alpine_pastures[].naturschutz.sensitive_area_fertilizer_free",
      "input.land.alpine_pastures[].naturschutz.troughs_not_in_wetlands",
      "input.livestock",
      "input.livestock.alpine_movements",
      "input.livestock.alpine_movements[].alm_id",
      "input.livestock.alpine_movements[].alpung_days",
      "input.livestock.alpine_movements[].animal_id",
      "input.livestock.alpine_movements[].gve",
      "input.livestock.alpine_movements[].is_held_in_austria",
      "input.livestock.alpine_movements[].species",
      "input.preferences_constraints",
      "input.preferences_constraints.oepul_contract_start_year",
      "input.preferences_constraints.oepul_first_participation_year",
      "input.preferences_constraints.oepul_options",
      "input.preferences_constraints.oepul_options.almweideplan",
      "input.preferences_constraints.oepul_options.naturschutz_auf_der_alm",
      "input.preferences_constraints.oepul_participation_requested"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_14_almbewirtschaftung_2026_04 | full_document | 16 | {"not_rule": 2, "rules": 14} |
| o6_allgemeine_teilnahmebedingungen_2026_04 | full_document | 10 | {"not_rule": 2, "rules": 8} |
| srl_oepul_2023 | targeted_sections | 5 | {"rules": 5} |
| srl_oepul_2023_anhaenge | targeted_sections | 5 | {"rules": 5} |
| dry_2026_biodiversitaetsflaechen | full_document | 3 | {"not_rule": 2, "rules": 1} |
| rebzikade_2026 | full_document | 1 | {"not_rule": 1} |
| dry_2026_0805 | full_document | 1 | {"not_rule": 1} |
| dry_2026_0812 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | ja | alpung_days von 60 auf 59 ändern; RGVE und Fläche beibehalten, um den Mindesttagepfad zu untersuchen. |
| missing_fact | defined | nein | is_in_austria bei der Alm entfernen; prüfen, ob fehlender Standortnachweis die Zulassung verhindert oder wegen negierter Verletzungsprüfung unauffällig bleibt. |

**Offene Abhängigkeiten:**

- Historischer Luna-Quellenstand bleibt unverändert; Übereinstimmung mit dem aktuellen Quellenpaket und verbindliche Gesamtauslegung sind vor einer produktiven Übernahme separat zu prüfen.
- Native Eingaben sind kein gemeinsamer App-Vertrag; Herkunft, Vollständigkeit und Bedeutung der entscheidungsrelevanten Nachweisfelder benötigen eine gesonderte Zuordnung.
- Fehlende Standort-/Praxismerkmale benötigen eine explizite Missing-Data-Semantik; das negierte Vorliegen einer Verletzung ist kein positiver Nachweis.
- Antrags-/Listenfristen existieren als separate Funktionen und fließen nicht in eligible ein; GVE/RGVE-Aggregation und Bewegungsidentität benötigen belegte Zuordnung.
- Beobachtet: Trotz access_stage=stage_2/Förderjahr 2026 bleibt premium_base in allen drei Fällen {}. Die Policy liest data.o6_14.rates, die JSON-Datei enthält rates beim nativen Verzeichnisladen jedoch an der Datenwurzel; die Referenzauflösung muss vor einer Prämienintegration geklärt werden. {} ist keine belegte Nullprämie.
- Beobachtet: Entfernen von alm.is_in_austria ändert eligible=true nicht; ein Missing-Data-Status für den Standortnachweis fehlt.

**Belege:**

- [runs/v2-o6_14-luna-high-20261004/workspace/policy/almbewirtschaftung.rego](../../../runs/v2-o6_14-luna-high-20261004/workspace/policy/almbewirtschaftung.rego): Belegt die Query, tatsächlich konsumierte Eingabefelder, Checks und Berechnungen; die Variations- und Entfernungsfälle ändern jeweils genau einen konsumierten Blattwert.
- [runs/v2-o6_14-luna-high-20261004/workspace/tests/almbewirtschaftung_test.rego](../../../runs/v2-o6_14-luna-high-20261004/workspace/tests/almbewirtschaftung_test.rego): Modellgenerierte synthetische Entwicklungsbeispiele und Grenzwerte; keine unabhängige Ground Truth.
- [runs/v2-o6_14-luna-high-20261004/workspace/notes/assumptions.md](../../../runs/v2-o6_14-luna-high-20261004/workspace/notes/assumptions.md): Dokumentiert historische Quellen-/Eingabeannahmen und offene Integrations-/Auslegungsfragen.
- [runs/v2-o6_14-luna-high-20261004/workspace/data/o6_14.json](../../../runs/v2-o6_14-luna-high-20261004/workspace/data/o6_14.json): Enthält rates an der JSON-Wurzel; bei nativer OPA-Verzeichnisladung stimmt dies nicht mit data.o6_14.rates in der Policy überein. Keine Umformung des historischen Datenbestands vorgenommen.

### o6_15

Run: `v2-o6_15-luna-high-20261004`. [Fixture](fixtures/o6_15.json) · [Native Ergebnisse](results/o6_15.json)

**Eingaben:** Native farm-Teilnahme-/Antragsdaten, land.parcels[].care/grazing_management und livestock.species_groups. gve ist der bereits aggregierte RGVE-Gruppenwert; stocking_days und herding_days sind Tage, ISO-Strings bilden Fristen ab. Drei RGVE Schafe, kein Milchzuschlag, kein beantragter Herdenschutzhund; kein realer Betrieb.

**Ausgabebedeutung:** Die Policy nutzt package opul.o6_15 und hat kein Gesamturteil. Die Query zeigt einzelne Vertrags-/Teilnahme-/Betreuungs-/Fristchecks sowie premium_eur. premium_eur wird unabhängig von diesen Checks berechnet; eine Summe ist deshalb nur eine native Berechnungsindikation und keine Gesamtfreigabe.

**Herkunft:** Eigener synthetischer Entwicklungsbasisfall aus den tatsächlich konsumierten Policy-Feldern; Grenzen 3 RGVE/60 Tage aus modellgenerierten Einzeltests übernommen. Keine unabhängigen Sollurteile, keine Expertenvalidierung, keine Golden- oder Held-out-Fälle.

**Query:** `{"annual_contract_valid": data.opul.o6_15.annual_contract_valid, "participation_valid": data.opul.o6_15.participation_valid, "sixty_day_requirement_valid": data.opul.o6_15.sixty_day_requirement_valid, "care_requirement_valid": data.opul.o6_15.care_requirement_valid, "grazing_management_valid": data.opul.o6_15.grazing_management_valid, "accommodation_valid": data.opul.o6_15.accommodation_valid, "reporting_valid": data.opul.o6_15.reporting_valid, "premium_eur": data.opul.o6_15.premium_eur}`

**Inventar:** 44 Regelkatalog-Einträge; 8 Quellen; 19 statisch erkannte Eingabepfade; 60 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"accommodation": 1, "active_area_management": 1, "alm_definition": 1, "animal_care": 1, "annual_application": 1, "applicant_eligibility": 1, "application_deadline": 1, "care_components": 1, "category_completeness": 1, "combination_requirement": 1, "conditionality": 1, "contract_consequence": 1, "contract_period": 1, "day_counting": 1, "dog_application_limit": 1, "dog_premium": 1, "duration": 1, "eligible_animals": 1, "exit": 1, "farm_minimum_size": 1, "full_year_obligation": 1, "geographic_eligibility": 1, "grazing_management": 1, "herd_protection_dog_definition": 1, "herd_protection_dog_documentation": 1, "herd_protection_dog_duration": 1, "herder_cap": 1, "higher_force_2026": 1, "last_entry": 1, "milk_category": 1, "milk_cow_age": 1, "milk_flag_correction": 1, "milk_small_ruminant_age": 1, "minimum_participation": 1, "modulation": 1, "op_code_effect": 1, "payment_application": 1, "premium_rate": 1, "reporting_deadline_cattle": 1, "reporting_deadline_equine_camelid": 1, "reporting_deadline_small_ruminants": 1, "rgve_calculation": 1, "sanction_consequence": 1, "support_scope": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.o6_15_application_date",
      "input.farm.o6_15_drought.drought_prevented_obligation",
      "input.farm.o6_15_drought.higher_force_application_submitted",
      "input.farm.o6_15_exit.exit_effective_date",
      "input.farm.o6_15_exit.requested",
      "input.farm.o6_15_payment_application_date",
      "input.farm.participates_almbewirtschaftung",
      "input.farm.year",
      "input.land.parcels",
      "input.livestock.herd_protection_dog.certificate_recognized",
      "input.livestock.herd_protection_dog.day_and_night_with_herd",
      "input.livestock.herd_protection_dog.days_on_single_alm",
      "input.livestock.herd_protection_dog.dogs_on_alm",
      "input.livestock.herd_protection_dog.herded_animals_total_days",
      "input.livestock.herd_protection_dog.liability_insurance",
      "input.livestock.herd_protection_dog.permanent_herd_member",
      "input.livestock.herd_protection_dog.requested",
      "input.livestock.herd_protection_dog.works_without_direct_commands",
      "input.livestock.species_groups"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_15_measure_sheet | full_document | 9 | {"not_rule": 1, "rules": 8} |
| general_participation_conditions | full_document | 9 | {"not_rule": 3, "rules": 6} |
| srl_oepul_2023 | targeted_sections | 6 | {"not_rule": 1, "rules": 5} |
| srl_annexes_oepul_2023 | targeted_sections | 2 | {"not_rule": 1, "rules": 1} |
| ama_drought_notice_2026_05_22 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| ama_insecticide_notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| ama_drought_notice_2026_08_05 | full_document | 1 | {"not_rule": 1} |
| ama_drought_notice_2026_08_12 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | ja | herding_days der Schafgruppe von 60 auf 59 ändern; die 60-Tage-Grenze getrennt von Teilnahme und Prämienberechnung beobachten. |
| missing_fact | defined | ja | herding_days entfernen; untersuchen, ob der Teilcheck zwischen fehlendem Zeitraum und dokumentierter Unterschreitung unterscheidet. |

**Offene Abhängigkeiten:**

- Historischer Luna-Quellenstand bleibt unverändert; Übereinstimmung mit dem aktuellen Quellenpaket und verbindliche Gesamtauslegung sind vor einer produktiven Übernahme separat zu prüfen.
- Native Eingaben sind kein gemeinsamer App-Vertrag; Herkunft, Vollständigkeit und Bedeutung der entscheidungsrelevanten Nachweisfelder benötigen eine gesonderte Zuordnung.
- Mehr-Alm-/Mehr-Hirten-Zuordnung, zeitanteilige Tierbewegungen und Modulationsbasis sind laut Run-Annahmen nicht vollständig bestimmbar.
- Es fehlt die Zusammenführung der Teilchecks zu einem quellengebundenen Gesamturteil samt Missing-Data-Zustand; die Prämienfunktion ist davon unabhängig.
- Beobachtet: baseline, herding_days=59 und fehlende herding_days liefern alle premium_eur=243; sixty_day_requirement_valid ist nur im Basisfall true. Die Berechnung darf deshalb nicht direkt als bestätigter Anspruch angezeigt werden.

**Belege:**

- [runs/v2-o6_15-luna-high-20261004/workspace/policy/behirtung.rego](../../../runs/v2-o6_15-luna-high-20261004/workspace/policy/behirtung.rego): Belegt die Query, tatsächlich konsumierte Eingabefelder, Checks und Berechnungen; die Variations- und Entfernungsfälle ändern jeweils genau einen konsumierten Blattwert.
- [runs/v2-o6_15-luna-high-20261004/workspace/tests/behirtung_test.rego](../../../runs/v2-o6_15-luna-high-20261004/workspace/tests/behirtung_test.rego): Modellgenerierte synthetische Entwicklungsbeispiele und Grenzwerte; keine unabhängige Ground Truth.
- [runs/v2-o6_15-luna-high-20261004/workspace/notes/assumptions.md](../../../runs/v2-o6_15-luna-high-20261004/workspace/notes/assumptions.md): Dokumentiert historische Quellen-/Eingabeannahmen und offene Integrations-/Auslegungsfragen.

### o6_16

Run: `v2-o6_16-luna-high-20261005`. [Fixture](fixtures/o6_16.json) · [Native Ergebnisse](results/o6_16.json)

**Eingaben:** Native measure-/records-/options-Eingaben sowie land.parcels; Acker-/Gebietsflächen in ha, N-Überschuss und Folgekulturreduktion in kg N/ha, Weiterbildung in Stunden, Probennahme als ISO-Datum. Der Gebietsflag und kg_number sind synthetische, aus dem Modelltest übernommene Nachweise, keine GIS-Verifikation.

**Ausgabebedeutung:** decision enthält eligible, Verletzungscodes, Bodenprobenbedarf, Reduktionsfaktor und Prämienkomponenten. eligible folgt requested plus leerer Verletzungsmenge; fehlende numerische Felder können einen Vergleich undefiniert lassen, ohne einen Missing-Data-Code zu erzeugen. Das Ergebnis ist eine Teilprüfung des historischen Quellen-/Eingabestands.

**Herkunft:** Synthetische Entwicklungsfälle aus dem modellgenerierten Testbeispiel; gezielte Änderungen durch Codex zur diagnostischen Sichtung. Keine unabhängigen Sollurteile, keine Expertenvalidierung, keine Golden- oder Held-out-Fälle.

**Query:** `data.oepul.o6_16.decision`

**Inventar:** 71 Regelkatalog-Einträge; 8 Quellen; 39 statisch erkannte Eingabepfade; 57 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"annual_option_period": 1, "application": 2, "autumn_establishment": 1, "calculation": 7, "coding": 1, "combination": 1, "combination_requirement": 1, "compatibility": 4, "contract_period": 1, "cultan": 2, "deadline": 2, "drought_exception": 2, "exception": 2, "general": 5, "minimum_area": 2, "nitrogen_balance": 2, "notice": 2, "option_minimum": 1, "pig_access": 1, "pig_feed": 3, "plant_protection": 2, "premium": 3, "recording": 2, "sanction": 1, "scope": 1, "soil_testing": 3, "training": 5, "upper_austria": 4, "vienna_option": 3, "washout": 4}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.bentazon_reauthorized",
      "input.farm.region.federal_state",
      "input.farm.region.is_eastern_lower_austria_or_tullnerfeld",
      "input.farm.year",
      "input.land.groundwater_arable_area_ha",
      "input.land.parcels",
      "input.land.total_arable_area_ha",
      "input.livestock.pig_gve_average",
      "input.measure.first_participation_year",
      "input.measure.oo_chemical_psm_application",
      "input.measure.oo_variant_3_cover",
      "input.measure.participates_cover_evergreen",
      "input.measure.participates_cover_intercrop",
      "input.measure.participates_organic",
      "input.measure.requested",
      "input.options.cultan.external_equipment",
      "input.options.cultan.has_ammonium_depot_injection",
      "input.options.cultan.requested",
      "input.options.psm_avoidance_surcharge.requested",
      "input.options.strong_n_reduced_pig_feeding.also_claimed_in_liquid_manure_measure",
      "input.options.strong_n_reduced_pig_feeding.feed_categories",
      "input.options.strong_n_reduced_pig_feeding.requested",
      "input.options.vienna_humus.recognized_carbon_project_confirmation",
      "input.options.vienna_humus.requested",
      "input.options.vienna_humus.turning_tillage_other_than_after_maize",
      "input.options.washout_risk.parcel_ids",
      "input.options.washout_risk.requested",
      "input.records.cultan_external_service_evidence",
      "input.records.cultan_field_records_complete",
      "input.records.education_completed_date",
      "input.records.education_hours",
      "input.records.education_provider_recognized",
      "input.records.farm_balance_completed_by_next_01_31",
      "input.records.farm_planning_completed_by_02_28",
      "input.records.oo_ipm_inspection_or_warning_documented",
      "input.records.pig_feed_recipe_evidence",
      "input.records.soil_samples",
      "input.records.vienna_extra_education_hours",
      "input.records.water_protection_concept_complete"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| measure_sheet | full_document | 14 | {"not_rule": 2, "rules": 12} |
| general_conditions | full_document | 9 | {"not_rule": 1, "rules": 8} |
| legal_measure_and_annexes | targeted_sections | 4 | {"rules": 4} |
| legal_annexes | targeted_sections | 4 | {"rules": 4} |
| notice_may_2026 | full_document | 1 | {"rules": 1} |
| notice_june_2026 | full_document | 1 | {"rules": 1} |
| notice_august_05_2026 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_august_12_2026 | full_document | 2 | {"not_rule": 1, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | ja | education_hours von 10 auf 9 ändern; beobachten, ob die belegte Weiterbildungsgrenze einen eigenen Verletzungscode erzeugt. |
| missing_fact | defined | nein | education_hours entfernen; prüfen, ob ein fehlender Stundennachweis anders als neun belegte Stunden behandelt wird. |

**Offene Abhängigkeiten:**

- Historischer Luna-Quellenstand bleibt unverändert; Übereinstimmung mit dem aktuellen Quellenpaket und verbindliche Gesamtauslegung sind vor einer produktiven Übernahme separat zu prüfen.
- Native Eingaben sind kein gemeinsamer App-Vertrag; Herkunft, Vollständigkeit und Bedeutung der entscheidungsrelevanten Nachweisfelder benötigen eine gesonderte Zuordnung.
- N-Berechnung und Dünge-Detailtabellen außerhalb des damaligen Quellenpakets sind laut Run-Annahmen offen; die Prüfung übernimmt N-Werte als Eingabe.
- Gebiets-/Katastralgemeindennachweis und historische Anhang-G-Liste sind vor einer aktuellen GIS-/Förderentscheidung abzugleichen.
- Beobachtet: education_hours=9 erzeugt ten_hours_training_required und eligible=false; Entfernen von education_hours liefert dagegen wieder eligible=true ohne Verletzung. Ein eigener Status für die fehlende entscheidungsrelevante Angabe fehlt.

**Belege:**

- [runs/v2-o6_16-luna-high-20261005/workspace/policy/o6_16.rego](../../../runs/v2-o6_16-luna-high-20261005/workspace/policy/o6_16.rego): Belegt die Query, tatsächlich konsumierte Eingabefelder, Checks und Berechnungen; die Variations- und Entfernungsfälle ändern jeweils genau einen konsumierten Blattwert.
- [runs/v2-o6_16-luna-high-20261005/workspace/tests/o6_16_test.rego](../../../runs/v2-o6_16-luna-high-20261005/workspace/tests/o6_16_test.rego): Modellgenerierte synthetische Entwicklungsbeispiele und Grenzwerte; keine unabhängige Ground Truth.
- [runs/v2-o6_16-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_16-luna-high-20261005/workspace/notes/assumptions.md): Dokumentiert historische Quellen-/Eingabeannahmen und offene Integrations-/Auslegungsfragen.

### o6_17

Run: `v2-o6_17-luna-high-20261005`. [Fixture](fixtures/o6_17.json) · [Native Ergebnisse](results/o6_17.json)

**Eingaben:** Native Eingaben unter oepul.o6_17 plus land.parcels; Flächen in ha, Graslandanteil und Hangneigung in Prozent, rgve_total als RGVE, forage_area_ha als Futterfläche, Bodenproben als Anzahl. Basis Förderjahr 2025 mit 3 RGVE/10 ha an der Tierhaltergrenze; Schlag synthetisch ergänzt, native Boden-/Hang- und Kombinationsflags explizit gesetzt.

**Ausgabebedeutung:** decision kombiniert Zugangsurteil, Basis-/Bonusparzellen, Nachweisverletzungen und Prämienindikationen. eligible ruft den Bodenproben-Verletzungscheck nicht auf; daher kann eligible=true mit soil_samples_missing koexistieren. Fehlt eine für ein Objektfeld erforderliche Berechnungsangabe, kann das gesamte decision-Objekt undefiniert bleiben.

**Herkunft:** Synthetischer Entwicklungsbasisfall aus test_first_year_eligibility_and_premium, ergänzt um einen einzelnen synthetischen Grünlandschlag mit konsumierten Feldern aus test_parcel_base_and_bonus_boundaries. Gezielte Änderungen durch Codex; keine unabhängigen Sollurteile, keine Golden- oder Held-out-Fälle.

**Query:** `data.oepul.o6_17.decision`

**Inventar:** 48 Regelkatalog-Einträge; 8 Quellen; 17 statisch erkannte Eingabepfade; 50 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_condition": 4, "allowed_method": 1, "application": 2, "calculation": 6, "closed_list": 2, "combination_condition": 2, "contract_period": 1, "control": 1, "definition": 3, "documentation": 2, "exception": 5, "general_condition": 5, "method": 2, "obligation": 6, "premium_calculation": 3, "premium_condition": 2, "sanction": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.year",
      "input.land.grassland_area_ha",
      "input.land.parcels",
      "input.oepul.o6_17.average_grassland_score",
      "input.oepul.o6_17.combination",
      "input.oepul.o6_17.contract_start_year",
      "input.oepul.o6_17.forage_area_ha",
      "input.oepul.o6_17.grassland_break_documented",
      "input.oepul.o6_17.grassland_share_excluding_alpine_percent",
      "input.oepul.o6_17.is_first_participation_year",
      "input.oepul.o6_17.mown_grassland_area_ha",
      "input.oepul.o6_17.participating",
      "input.oepul.o6_17.rgve_total",
      "input.oepul.o6_17.slope_percent",
      "input.oepul.o6_17.soil_basis_grassland_under_18_ha",
      "input.oepul.o6_17.soil_samples_submitted",
      "input.oepul.o6_17.total_farm_area_ha"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_17_info | full_document | 13 | {"not_rule": 1, "rules": 12} |
| o6_general | full_document | 14 | {"not_rule": 5, "rules": 9} |
| srl_oepul_2023 | targeted_sections | 6 | {"not_rule": 1, "rules": 5} |
| srl_annexes | targeted_sections | 5 | {"rules": 5} |
| notice_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_12 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | ja | soil_samples_submitted von 3 auf 2 ändern; das Verhältnis zwischen Zugangsurteil und verletzter Nachweispflicht sichtbar machen. |
| missing_fact | undefined | ja | average_grassland_score entfernen; prüfen, ob das fehlende Prämienberechnungsmerkmal nur einen Teilwert oder das gesamte Entscheidungsobjekt undefiniert macht. |

**Offene Abhängigkeiten:**

- Historischer Luna-Quellenstand bleibt unverändert; Übereinstimmung mit dem aktuellen Quellenpaket und verbindliche Gesamtauslegung sind vor einer produktiven Übernahme separat zu prüfen.
- Native Eingaben sind kein gemeinsamer App-Vertrag; Herkunft, Vollständigkeit und Bedeutung der entscheidungsrelevanten Nachweisfelder benötigen eine gesonderte Zuordnung.
- Zugangsurteil und Bodenprobenverletzung sind getrennte Policy-Pfade; kein vollständiger Gesamtfreigabeentscheid.
- Maßnahmenbezogene Hangneigung/Grünlandzahl und schlagbezogene Werte müssen eindeutig zugeordnet werden; Nachweis-/Bildungspflichten sind teilweise nur im Katalog.
- Beobachtet: soil_samples_submitted=2 liefert eligible=true zusammen mit violations=[soil_samples_missing]. Entfernen von average_grassland_score macht das gesamte decision-Objekt undefiniert; das ist kein negativer Förderentscheid.

**Belege:**

- [runs/v2-o6_17-luna-high-20261005/workspace/policy/o6_17.rego](../../../runs/v2-o6_17-luna-high-20261005/workspace/policy/o6_17.rego): Belegt die Query, tatsächlich konsumierte Eingabefelder, Checks und Berechnungen; die Variations- und Entfernungsfälle ändern jeweils genau einen konsumierten Blattwert.
- [runs/v2-o6_17-luna-high-20261005/workspace/tests/o6_17_test.rego](../../../runs/v2-o6_17-luna-high-20261005/workspace/tests/o6_17_test.rego): Modellgenerierte synthetische Entwicklungsbeispiele und Grenzwerte; keine unabhängige Ground Truth.
- [runs/v2-o6_17-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_17-luna-high-20261005/workspace/notes/assumptions.md): Dokumentiert historische Quellen-/Eingabeannahmen und offene Integrations-/Auslegungsfragen.

### o6_18

Run: `v2-o6_18-luna-high-20261005`. [Fixture](fixtures/o6_18.json) · [Native Ergebnisse](results/o6_18.json)

**Eingaben:** Native application sowie land.parcels[].naturschutz_codes/project_confirmation; Förderjahr 2026, land.total_area_ha in ha. Ein synthetischer Grünlandschlag mit Code GA09. Projektnachweis ist ein gesetzt/fehlend-Flag; konkrete projektabhängige Platzhalter, Bewirtschaftungswerte und Auflagen werden nicht erfunden.

**Ausgabebedeutung:** decision gibt Verletzungen, bekannte Codes und die berechnete Prämienindikation je ha aus. Code-/Prämienauswertung bezieht sich vorrangig auf den ersten Schlag, während manche Verletzungen alle Schläge betrachten. eligible=true bestätigt ausschließlich implementierte Checks; zahlreiche nicht gelieferte Fakten erhalten günstige Defaults.

**Herkunft:** Synthetische Entwicklungsfälle aus dem modellgenerierten Testbeispiel; gezielte Änderungen durch Codex zur diagnostischen Sichtung. Keine unabhängigen Sollurteile, keine Expertenvalidierung, keine Golden- oder Held-out-Fälle.

**Query:** `data.oepul.o6_18.decision`

**Inventar:** 39 Regelkatalog-Einträge; 8 Quellen; 53 statisch erkannte Eingabepfade; 55 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_requirement": 1, "annex_combination": 1, "application_coding": 1, "application_deadline": 1, "area_access": 1, "area_limit": 1, "closed_list": 1, "combination_exclusion": 1, "combination_requirement": 3, "conditionality": 1, "contract_duration": 1, "contract_management": 1, "eligibility": 1, "fertilizer_prohibition": 1, "management_requirement": 1, "measure_switch": 1, "minimum_area": 1, "minimum_management": 1, "minimum_participation": 1, "not_applicable": 1, "optional_surcharge": 1, "participation_condition": 1, "premium_cap": 1, "premium_modulation": 1, "prohibition": 1, "prohibition_with_exception": 1, "project_change": 1, "recordkeeping": 1, "regional_plan": 1, "sanction": 1, "surcharge_limit": 1, "temporary_exception": 5, "territorial_eligibility": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.application",
      "input.application.access_year",
      "input.application.added_area_ha",
      "input.application.additional_grazing_fertilization",
      "input.application.automatic_drought_exception",
      "input.application.base_2025_area_ha",
      "input.application.biodiversity_use_count",
      "input.application.comparable_second_cut",
      "input.application.deadline",
      "input.application.div_code",
      "input.application.div_credit",
      "input.application.drought_no_harvestable_stock",
      "input.application.early_arable_biodiversity_use",
      "input.application.early_grassland_biodiversity_use",
      "input.application.grassland_resowing",
      "input.application.grassland_resowing_written_approval",
      "input.application.grassland_uses_per_year",
      "input.application.grazing_required",
      "input.application.great_bustard_monitoring",
      "input.application.has_managed_parcel",
      "input.application.management_changed",
      "input.application.measure",
      "input.application.nat_code",
      "input.application.nat_fallow_area_ha",
      "input.application.nature_reference_area",
      "input.application.naturschutz_date_exception",
      "input.application.obligations_full_period",
      "input.application.op_code",
      "input.application.phenology_monitoring",
      "input.application.prohibited_interventions",
      "input.application.project_confirmation",
      "input.application.project_confirmation_amended",
      "input.application.regional_goals_and_confirmation",
      "input.application.regional_participation_confirmation",
      "input.application.regional_plan",
      "input.application.sludge_or_sludge_compost_applied",
      "input.application.submission_date",
      "input.application.switch_date",
      "input.application.ubb_or_bio",
      "input.application.use_date",
      "input.application.use_or_care_within_two_years",
      "input.application.violation_assessed",
      "input.documentation",
      "input.documentation.grazing_diary_complete",
      "input.farm",
      "input.farm.region.country",
      "input.farm.region.district",
      "input.farm.region.federal_state",
      "input.farm.year",
      "input.land",
      "input.land.arable_area_ha",
      "input.land.parcels",
      "input.land.total_area_ha"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_18_sheet | full_document | 3 | {"rules": 3} |
| o6_general_conditions | full_document | 5 | {"rules": 5} |
| srl_2024_main | targeted_sections | 5 | {"rules": 5} |
| srl_2024_annexes | targeted_sections | 6 | {"rules": 6} |
| notice_2026_may_biodiversity | full_document | 3 | {"rules": 3} |
| notice_2026_june_insecticide | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026_august_5 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026_august_12 | full_document | 3 | {"not_rule": 1, "rules": 2} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | ja | Den einzelnen Code GA09 durch den im Modelltest belegten Code GL06 ersetzen; beobachten, ob ein zusätzlicher Monitoringnachweis als Verletzung erscheint. |
| missing_fact | defined | ja | project_confirmation aus dem Schlag entfernen; den fehlenden Projektbestätigungsnachweis mit dem Basisfall vergleichen. |

**Offene Abhängigkeiten:**

- Historischer Luna-Quellenstand bleibt unverändert; Übereinstimmung mit dem aktuellen Quellenpaket und verbindliche Gesamtauslegung sind vor einer produktiven Übernahme separat zu prüfen.
- Native Eingaben sind kein gemeinsamer App-Vertrag; Herkunft, Vollständigkeit und Bedeutung der entscheidungsrelevanten Nachweisfelder benötigen eine gesonderte Zuordnung.
- Mehrschlagauswertung und projektspezifische Auflagenwerte/Platzhalter sind laut Run-Annahmen offene Integrationsfragen.
- Günstige Defaults für fehlende Angaben benötigen unabhängige fachliche Prüfung und einen expliziten Missing-Data-Vertrag vor einer Förderempfehlung.
- Beobachtet: Fehlende project_confirmation erzeugt eligible=false und project_confirmation_required, lässt aber premium_eur_ha=410.4 bestehen. Die Rate ist damit auch bei fehlendem Projektbeleg nur eine Berechnungsindikation.

**Belege:**

- [runs/v2-o6_18-luna-high-20261005/workspace/policy/naturschutz.rego](../../../runs/v2-o6_18-luna-high-20261005/workspace/policy/naturschutz.rego): Belegt die Query, tatsächlich konsumierte Eingabefelder, Checks und Berechnungen; die Variations- und Entfernungsfälle ändern jeweils genau einen konsumierten Blattwert.
- [runs/v2-o6_18-luna-high-20261005/workspace/tests/naturschutz_test.rego](../../../runs/v2-o6_18-luna-high-20261005/workspace/tests/naturschutz_test.rego): Modellgenerierte synthetische Entwicklungsbeispiele und Grenzwerte; keine unabhängige Ground Truth.
- [runs/v2-o6_18-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_18-luna-high-20261005/workspace/notes/assumptions.md): Dokumentiert historische Quellen-/Eingabeannahmen und offene Integrations-/Auslegungsfragen.

### o6_19

Run: `v2-o6_19-luna-high-20261005`. [Fixture](fixtures/o6_19.json) · [Native Ergebnisse](results/o6_19.json)

**Eingaben:** Native Eingabe input.measure mit beantragter Maßnahme, Antrags-/Einstiegsjahr, Bindungsdauer, Flächen in ha, Projektbestätigung und Schulungsnachweisen. mandatory_indicators_met ist bereits ein zusammengefasstes Projektergebnis; kein aus Rohbeobachtungen abgeleiteter Indikator. Die synthetischen Modelltestwerte verwenden das Antragsjahr 2025 und sind keine Aktualitätsbehauptung für 2026.

**Ausgabebedeutung:** Begrenzte Projektion der nativen eligible-, violation- und premium_rate_eur_per_ha-Pfade ohne neue fachliche Aggregation. eligible umfasst nur die im historischen Einstiegspunkt verknüpften Zugangs-, Vertrags-, Projekt- und Schulungsbedingungen. violation enthält separate Meldungen; Prämienrate bleibt auch bei eligible=false berechenbar. Kombinationen/Zuschläge sind nicht verknüpft; true ist keine vollständige Förderfreigabe. Fehlende mandatory_indicators_met-Werte werden nicht ausdrücklich als Datenlücke ausgewiesen. Wird ein projizierter Pfad undefined, bleibt dies ein undefiniertes Queryergebnis und wird nicht als false oder 0 ersetzt.

**Herkunft:** Synthetische DEVELOPMENT-Eingaben: Basis aus dem historischen Luna-Modelltest base_measure; gezielte Einzelvariation und Auslassungsfall von der Sichtung abgeleitet. Keine unabhängig erstellten oder fachlich adjudizierten Gold-/Heldoutfälle.

**Query:** `{"eligible": data.oepul.o6_19.eligible, "violations": data.oepul.o6_19.violation, "premium_rate_eur_per_ha": data.oepul.o6_19.premium_rate_eur_per_ha}`

**Inventar:** 32 Regelkatalog-Einträge; 8 Quellen; 42 statisch erkannte Eingabepfade; 58 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application_code": 1, "application_deadline": 1, "area_accession": 1, "area_reduction": 1, "biodiversity_minimum": 1, "combination_div": 1, "combination_naturschutz": 1, "contract_duration": 1, "control_consequence": 1, "drought_2026_exception": 1, "eligibility": 1, "fallow_cap": 1, "farm_modulation": 1, "indicator_catalog": 1, "indicator_compliance": 1, "last_entry": 1, "maintenance": 1, "measure_conversion": 1, "measure_takeover": 1, "minimum_participation": 1, "non_premium_area": 1, "premium_combination": 1, "premium_table": 1, "project_confirmation": 1, "recordkeeping": 1, "regional_plan": 1, "regional_surcharge": 1, "surcharge_ebba": 1, "surcharge_ebhg": 1, "training_deadline": 1, "training_delegate": 1, "training_evidence": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.measure.accession_area_ha",
      "input.measure.application_year",
      "input.measure.arable_area_ha",
      "input.measure.area_2025_ha",
      "input.measure.combination_scope",
      "input.measure.commitment_end_date",
      "input.measure.commitment_years",
      "input.measure.contract_end_year",
      "input.measure.drought_2026.affected_biodiversity_area_in_ebw",
      "input.measure.drought_2026.proposed_use_follows_project_confirmation",
      "input.measure.eligible_area_ha",
      "input.measure.first_commitment_year",
      "input.measure.id",
      "input.measure.other_measure",
      "input.measure.premium.conservation_status",
      "input.measure.premium.difficulty_index",
      "input.measure.premium.habitat",
      "input.measure.premium.land_use",
      "input.measure.project_confirmation.indicator_observation_database_current",
      "input.measure.project_confirmation.parcels",
      "input.measure.project_confirmation.present",
      "input.measure.project_confirmation.reference_area_present",
      "input.measure.project_confirmation.regular_care_every_second_year",
      "input.measure.regional_nature_conservation_plan.also_naturschutz",
      "input.measure.regional_nature_conservation_plan.annual_confirmation_present",
      "input.measure.regional_nature_conservation_plan.awards_this_year",
      "input.measure.regional_nature_conservation_plan.requested",
      "input.measure.requested",
      "input.measure.start_year",
      "input.measure.surcharges.ebba01.awards_on_area",
      "input.measure.surcharges.ebba01.reason_documented",
      "input.measure.surcharges.ebba01.reason_qualifies",
      "input.measure.surcharges.ebba01.requested",
      "input.measure.surcharges.ebba02.reason_documented",
      "input.measure.surcharges.ebba02.requested",
      "input.measure.surcharges.ebba02.very_good_conservation_status",
      "input.measure.surcharges.ebhg.protection_layer_share",
      "input.measure.surcharges.ebhg.requested",
      "input.measure.total_farm_area_ha",
      "input.measure.training.not_double_counted",
      "input.measure.training.participant_is_farm_person",
      "input.measure.training.regional_network_meeting_by_2026_12_31"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_19_measure | full_document | 10 | {"not_rule": 1, "rules": 9} |
| o6_general | full_document | 7 | {"not_rule": 3, "rules": 4} |
| srl_oepul_2023 | targeted_sections | 6 | {"rules": 6} |
| srl_oepul_2023_annexes | targeted_sections | 8 | {"rules": 8} |
| drought_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| insecticide_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| drought_2026_08_05 | full_document | 1 | {"not_rule": 1} |
| drought_2026_08_12 | full_document | 2 | {"not_rule": 1, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Native synthetische Modelltestbasis getrennt vom App-Adapter ausführen; Ergebnis als Kandidatenbefund protokollieren. |
| variation | defined | ja | Einzige Änderung: förderfähige Fläche im ersten Bindungsjahr von 1,2 auf 0,99 ha; Reaktion des nativen Mindestflächenpfads beobachten. |
| missing_fact | defined | nein | Einzige Auslassung: mandatory_indicators_met im vorhandenen Projekt-Schlag; prüfen, ob unbekanntes Indikatorergebnis als Lücke oder als weiterhin erfüllt erscheint. |

**Offene Abhängigkeiten:**

- Projektbestätigung mit tatsächlich angewendeten Indikatoren und Projektparametern fehlt als unabhängig bestätigte Referenz; Modelltestflags ersetzen sie nicht.
- Die Annahme max(25 % Ackerfläche, 2 ha) und Kombinations-/Zuschlagspfade benötigen gesonderte fachliche Prüfung, bevor sie ein Sollurteil tragen.
- Historischer Quellenstand und Kandidatenvertrag dürfen nicht durch neue Quellen oder App-Felder stillschweigend ersetzt werden.
- eligible lässt unvollständige Indikatorflags möglicherweise passieren und liefert keinen vollständigen Diagnose-/Prämienvertrag.

**Belege:**

- [runs/v2-o6_19-luna-high-20261005/workspace/policy/ebw.rego](../../../runs/v2-o6_19-luna-high-20261005/workspace/policy/ebw.rego): Nativer Package-/Querypfad und tatsächlich konsumierte Eingabefelder; keine neue fachliche Regel hinzugefügt.
- [runs/v2-o6_19-luna-high-20261005/workspace/tests/ebw_test.rego](../../../runs/v2-o6_19-luna-high-20261005/workspace/tests/ebw_test.rego): Herkunft der synthetischen Entwicklungsbasis und Modelltest-Beispiele zu Mindest-/Grenzwertreaktionen; keine unabhängige Sollreferenz.
- [runs/v2-o6_19-luna-high-20261005/workspace/data/ebw_catalog.json](../../../runs/v2-o6_19-luna-high-20261005/workspace/data/ebw_catalog.json): Historischer Datenkatalog für die vorhandenen Kategorien, Tabellen, Prämien und/oder Kombinationen.
- [runs/v2-o6_19-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_19-luna-high-20261005/workspace/notes/assumptions.md): Vom historischen Kandidaten dokumentierte Eingabe-, Quellen- und Auslegungsgrenzen.

### o6_20

Run: `v2-o6_20-luna-high-20261005`. [Fixture](fixtures/o6_20.json) · [Native Ergebnisse](results/o6_20.json)

**Eingaben:** Native Eingabe farm.livestock.o6_20 als Liste teilnehmender Tierkategorien; animal_count in Köpfen, average_rgve als vorausberechneter Durchschnitt in RGVE, weide_days in Tagen sowie boolesche Zeitraum-, Versorgungs-, Melde- und Nachweisfelder. Antrag über o6_20_application, Dürrekontext über context. Keine Ableitung aus tierbezogener Ereigniszeitleiste.

**Ausgabebedeutung:** decision liefert eligible, violations, Kategorien mit Tagesgrenzen, application_valid und Prämienband-Indikationen; keine ausgezahlte Betriebsgesamtprämie. eligible wird aus Kategorien/violations gebildet und verknüpft application_valid im Code nicht. Fehlende Angaben können als false/0 und damit als Verletzung erscheinen; keine einheitliche Missing-Data-Semantik.

**Herkunft:** Synthetische DEVELOPMENT-Eingaben: Basis aus dem historischen Luna-Modelltest valid_input; gezielte Einzelvariation und Auslassungsfall von der Sichtung abgeleitet. Keine unabhängig erstellten oder fachlich adjudizierten Gold-/Heldoutfälle.

**Query:** `data.oepul.o6_20.decision`

**Inventar:** 41 Regelkatalog-Einträge; 8 Quellen; 33 statisch erkannte Eingabepfade; 3 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_threshold": 2, "animal_welfare": 3, "application_data": 2, "calculation": 3, "closed_list": 2, "contract_effect": 1, "contract_period": 1, "control_context": 1, "correction": 1, "crediting": 1, "deadline": 5, "documentation": 2, "eligibility": 2, "exception": 2, "premium": 1, "premium_adjustment": 3, "reporting": 3, "sanction": 1, "scope": 1, "threshold": 1, "time_window": 1, "transfer": 1, "withdrawal": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.context",
      "input.context.control_note_acknowledged",
      "input.context.drought_2026",
      "input.farm",
      "input.farm.livestock.o6_20",
      "input.farm.livestock.o6_20[].all_category_animals_participate",
      "input.farm.livestock.o6_20[].animal_count",
      "input.farm.livestock.o6_20[].animals_held_in_austria",
      "input.farm.livestock.o6_20[].average_rgve",
      "input.farm.livestock.o6_20[].category",
      "input.farm.livestock.o6_20[].correction_or_report",
      "input.farm.livestock.o6_20[].count_correction_done",
      "input.farm.livestock.o6_20[].entry_after_april",
      "input.farm.livestock.o6_20[].entry_report_within_7_days",
      "input.farm.livestock.o6_20[].exit_after_april",
      "input.farm.livestock.o6_20[].exit_report_within_7_days",
      "input.farm.livestock.o6_20[].grazing_substantial_part_of_day",
      "input.farm.livestock.o6_20[].groundfeed_predominantly_grazing",
      "input.farm.livestock.o6_20[].optional_150_days",
      "input.farm.livestock.o6_20[].participating",
      "input.farm.livestock.o6_20[].pasture_treated_as_exit",
      "input.farm.livestock.o6_20[].replacement_by_growing_animals",
      "input.farm.livestock.o6_20[].shelter_access",
      "input.farm.livestock.o6_20[].temporary_pasture_stay",
      "input.farm.livestock.o6_20[].vis_reporting_complete",
      "input.farm.livestock.o6_20[].water_access",
      "input.farm.livestock.o6_20[].weide_days",
      "input.farm.livestock.o6_20[].weide_diary_complete",
      "input.farm.livestock.o6_20[].weide_period_valid",
      "input.farm.year",
      "input.o6_20_application",
      "input.o6_20_application.application_date_before_31_december",
      "input.o6_20_application.measure_requested"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| measure_o620 | full_document | 15 | {"not_rule": 1, "rules": 14} |
| general_conditions | full_document | 21 | {"not_rule": 9, "rules": 12} |
| legal_srl | targeted_sections | 12 | {"not_rule": 3, "rules": 9} |
| measure_annex_a | targeted_sections | 2 | {"not_rule": 1, "rules": 1} |
| notice_drought_2026 | full_document | 3 | {"not_rule": 2, "rules": 1} |
| notice_insecticide_2026 | full_document | 1 | {"not_rule": 1} |
| notice_drought_az_2026 | full_document | 3 | {"not_rule": 3} |
| notice_drought_abwicklung_2026 | full_document | 4 | {"not_rule": 4} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Native synthetische Modelltestbasis getrennt vom App-Adapter ausführen; Ergebnis als Kandidatenbefund protokollieren. |
| variation | defined | ja | Einzige Änderung: Weidetage der Rinderkategorie von 120 auf 119 Tage; Reaktion an der im Kandidaten konsumierten Schwelle beobachten. |
| missing_fact | defined | ja | Einzige Auslassung: water_access der Rinderkategorie; prüfen, ob fehlende Evidenz von einer tatsächlich fehlenden Tränke unterschieden wird. |

**Offene Abhängigkeiten:**

- Durchschnittliche RGVE und Weidetage brauchen eine festgelegte Herleitung aus Zu-/Abgängen und Zeitraum; diese Vorschau übernimmt Modelltestwerte.
- Kategorien-/Melde-/Dürrefakten und gekoppelte Almförderung sind ohne Nachweise keine fachlich bestätigten Eingaben.
- Das Prämienband ist keine aktuelle vollständige Jahres-/Betriebsberechnung.
- application_valid wird im nativen eligible-Pfad nicht verknüpft; die Gesamtbedeutung des Outputs muss vor App-Übernahme geklärt werden.

**Belege:**

- [runs/v2-o6_20-luna-high-20261005/workspace/policy/o6_20.rego](../../../runs/v2-o6_20-luna-high-20261005/workspace/policy/o6_20.rego): Nativer Package-/Querypfad und tatsächlich konsumierte Eingabefelder; keine neue fachliche Regel hinzugefügt.
- [runs/v2-o6_20-luna-high-20261005/workspace/tests/o6_20_test.rego](../../../runs/v2-o6_20-luna-high-20261005/workspace/tests/o6_20_test.rego): Herkunft der synthetischen Entwicklungsbasis und Modelltest-Beispiele zu Mindest-/Grenzwertreaktionen; keine unabhängige Sollreferenz.
- [runs/v2-o6_20-luna-high-20261005/workspace/data/o6_20_categories.json](../../../runs/v2-o6_20-luna-high-20261005/workspace/data/o6_20_categories.json): Historischer Datenkatalog für die vorhandenen Kategorien, Tabellen, Prämien und/oder Kombinationen.
- [runs/v2-o6_20-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_20-luna-high-20261005/workspace/notes/assumptions.md): Vom historischen Kandidaten dokumentierte Eingabe-, Quellen- und Auslegungsgrenzen.

### o6_21

Run: `v2-o6_21-luna-high-20261005`. [Fixture](fixtures/o6_21.json) · [Native Ergebnisse](results/o6_21.json)

**Eingaben:** Native Eingabe farm.o6_21 mit Jahr 2026, teilnehmenden Kategorien, durchschnittlichen/förderbaren RGVE und Stall-/Nachweisfeldern. animals[].weight_kg in kg; total_area_m2_per_animal und lying_area_m2_per_animal in m²/Tier, Prozentangaben als Zahlen. Allgemeine Betriebsdaten werden nicht aus dem App-Profil übersetzt.

**Ausgabebedeutung:** decision liefert eligible, konkrete violations, application/contract_year und premium_eur. Die Prämienformel bleibt auch bei Verletzungen ausführbar; Betrag ist deshalb eine rechnerische Indikation, keine Freigabe. Antrag-/Vertragsstatus sind separate Felder und nicht vollständig Bestandteil von eligible; allgemeine Förderbedingungen bleiben außerhalb des Teilurteils.

**Herkunft:** Synthetische DEVELOPMENT-Eingaben: Basis aus dem historischen Luna-Modelltest valid_input; gezielte Einzelvariation und Auslassungsfall von der Sichtung abgeleitet. Keine unabhängig erstellten oder fachlich adjudizierten Gold-/Heldoutfälle.

**Query:** `data.policy.o6_21.decision`

**Inventar:** 40 Regelkatalog-Einträge; 8 Quellen; 52 statisch erkannte Eingabepfade; 63 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"application_deadline": 1, "area_definition": 1, "calculation": 3, "combination": 1, "conditional_requirement": 2, "consequence": 1, "contract_consequence": 1, "contract_duration": 1, "control_consequence": 1, "conversion_table": 1, "deadline": 1, "documentation": 2, "duration": 1, "eligibility_threshold": 1, "eligible_categories": 1, "exception": 2, "exclusion": 1, "general_access": 1, "general_eligibility": 1, "housing_requirement": 1, "location_requirement": 1, "mixed_group_area": 1, "notification": 1, "optional_surcharge": 1, "optional_surcharge_exception": 1, "premium_calculation": 1, "premium_modulation": 1, "quality_requirement": 1, "scope": 1, "special_area_calculation": 1, "structural_requirement": 2, "threshold": 1, "transfer": 1, "withdrawal": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.o6_21",
      "input.farm.o6_21.all_eligible_animals_participating",
      "input.farm.o6_21.animals",
      "input.farm.o6_21.application_submitted_by_december_31",
      "input.farm.o6_21.average_fundable_rgve",
      "input.farm.o6_21.calf_social_contact",
      "input.farm.o6_21.calves_under_21_days_individually_housed",
      "input.farm.o6_21.compost",
      "input.farm.o6_21.compost.additional_organic_material_nondisregarded",
      "input.farm.o6_21.compost.all_solid_manure_in_piles",
      "input.farm.o6_21.compost.compost_barn",
      "input.farm.o6_21.compost.composting_process",
      "input.farm.o6_21.compost.minimum_interval_days",
      "input.farm.o6_21.compost.mode",
      "input.farm.o6_21.compost.napv_compliant",
      "input.farm.o6_21.compost.records_complete",
      "input.farm.o6_21.compost.turning_equipment_available_or_proven",
      "input.farm.o6_21.compost.turns",
      "input.farm.o6_21.compost_surcharge_requested",
      "input.farm.o6_21.cow_count",
      "input.farm.o6_21.cow_group_area_calculated",
      "input.farm.o6_21.fundable_rgve_total",
      "input.farm.o6_21.health_service_participation",
      "input.farm.o6_21.housing_periods_documented",
      "input.farm.o6_21.individual_housing_days",
      "input.farm.o6_21.individual_housing_records_complete",
      "input.farm.o6_21.milk_delivery_to_dairy",
      "input.farm.o6_21.minimum_participation_met",
      "input.farm.o6_21.noncompliant_animals_count",
      "input.farm.o6_21.noncompliant_animals_reported_immediately",
      "input.farm.o6_21.open_stall",
      "input.farm.o6_21.overlap_with_alp_or_weide",
      "input.farm.o6_21.participating_categories",
      "input.farm.o6_21.qplus_rind_or_comparable",
      "input.farm.o6_21.shared_group",
      "input.farm.o6_21.shared_group_area_calculated_for_all",
      "input.farm.o6_21.stall",
      "input.farm.o6_21.stall.group_housing",
      "input.farm.o6_21.stall.hard_surface",
      "input.farm.o6_21.stall.individual_housing_littered",
      "input.farm.o6_21.stall.litter_depth_cm",
      "input.farm.o6_21.stall.littered_lying_area_percent",
      "input.farm.o6_21.stall.littered_system",
      "input.farm.o6_21.stall.lying_area_m2_per_animal",
      "input.farm.o6_21.stall.lying_area_soft_and_dry",
      "input.farm.o6_21.stall.open_stall_requirements_met",
      "input.farm.o6_21.stall.perforation_percent",
      "input.farm.o6_21.stall.structural_requirements_met",
      "input.farm.o6_21.stall.total_area_m2_per_animal",
      "input.farm.o6_21.stall.usable_area_definition_met",
      "input.farm.o6_21.stall_sketch_and_occupancy_plan_available",
      "input.farm.o6_21.year"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_21 | full_document | 13 | {"rules": 13} |
| o6_general | full_document | 13 | {"not_rule": 5, "rules": 8} |
| srl_oepul_2023 | targeted_sections | 7 | {"rules": 7} |
| srl_oepul_2023_anhaenge | targeted_sections | 3 | {"not_rule": 1, "rules": 2} |
| notice_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_12 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Native synthetische Modelltestbasis getrennt vom App-Adapter ausführen; Ergebnis als Kandidatenbefund protokollieren. |
| variation | defined | ja | Einzige Änderung: nutzbare Gesamtfläche von 4,20 auf 4,19 m²/Tier bei 501 kg; Reaktion der modellierten Platzbedarfstabelle beobachten. |
| missing_fact | defined | ja | Einzige Auslassung: structural_requirements_met; prüfen, ob fehlender baulicher Nachweis ausdrücklich als unbekannt oder als Verletzung erscheint. |

**Offene Abhängigkeiten:**

- Exakt 500 kg ist in notes/assumptions.md auslegungsbedürftig; die Vorschau nutzt 501 kg und beansprucht kein Grenzfall-Sollurteil.
- Qplus/vergleichbare Programme, besondere Offenstallbedingungen und Kompostierungsvarianten benötigen unabhängig bestätigte Tatsachen-/Rechtsgrundlagen.
- Allgemeine Zugangsvoraussetzungen und Jahres-/Kombinationsbezug sind nicht vollständig aus dem App-Profil abgeleitet.
- Fehlende Angaben und rechnerische Prämie sind im nativen Vertrag nicht sauber von fachlicher Freigabe getrennt.

**Belege:**

- [runs/v2-o6_21-luna-high-20261005/workspace/policy/o6_21.rego](../../../runs/v2-o6_21-luna-high-20261005/workspace/policy/o6_21.rego): Nativer Package-/Querypfad und tatsächlich konsumierte Eingabefelder; keine neue fachliche Regel hinzugefügt.
- [runs/v2-o6_21-luna-high-20261005/workspace/tests/o6_21_test.rego](../../../runs/v2-o6_21-luna-high-20261005/workspace/tests/o6_21_test.rego): Herkunft der synthetischen Entwicklungsbasis und Modelltest-Beispiele zu Mindest-/Grenzwertreaktionen; keine unabhängige Sollreferenz.
- [runs/v2-o6_21-luna-high-20261005/workspace/data/o6_21_tables.json](../../../runs/v2-o6_21-luna-high-20261005/workspace/data/o6_21_tables.json): Historischer Datenkatalog für die vorhandenen Kategorien, Tabellen, Prämien und/oder Kombinationen.
- [runs/v2-o6_21-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_21-luna-high-20261005/workspace/notes/assumptions.md): Vom historischen Kandidaten dokumentierte Eingabe-, Quellen- und Auslegungsgrenzen.

### o6_22

Run: `v2-o6_22-luna-high-20261005`. [Fixture](fixtures/o6_22.json) · [Native Ergebnisse](results/o6_22.json)

**Eingaben:** Native Eingabe livestock.o6_22.measure und participation_gve in GVE. Dieser Einstiegspunkt konsumiert nur diese zwei Felder; Stall, Freiland, Tierkategorie, Zuschläge und Prämien werden über separate Hilfsregeln geprüft und sind in dieser Minimalvorschau nicht aggregiert.

**Ausgabebedeutung:** Boolean eligible ist ausschließlich die Scope-/Mindestbestandsprüfung (Maßnahmenkennung o6_22 und mindestens 2 GVE). Es ist ausdrücklich kein Gesamtergebnis zur Schweinehaltung. Native Hilfsregeln zu Platzbedarf, Freiland, Zuschlägen und Prämie sind nicht in eligible integriert; ein fehlender GVE-Wert liefert false ohne eigenen Fehlendatenbefund.

**Herkunft:** Synthetische DEVELOPMENT-Eingaben: Basis aus dem historischen Luna-Modelltest test_minimum_participation_is_two_gve; Variation aus test_below_minimum_is_not_eligible, Auslassungsfall von der Sichtung abgeleitet. Keine unabhängig erstellten oder fachlich adjudizierten Gold-/Heldoutfälle.

**Query:** `data.oepul.o6_22.eligible`

**Inventar:** 55 Regelkatalog-Einträge; 8 Quellen; 39 statisch erkannte Eingabepfade; 1 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"alternative": 1, "calculation": 5, "classification": 1, "closed_list": 1, "combination": 1, "consequence": 3, "contract": 1, "cross_reference": 1, "deadline": 2, "definition": 3, "documentation": 5, "eligibility": 10, "exception": 2, "exclusion": 2, "exit": 1, "rate_table": 1, "reporting": 4, "scope": 1, "supplement": 3, "threshold": 4, "threshold_table": 2, "transfer": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.land.total_area_ha",
      "input.livestock.o6_22.applied_heads",
      "input.livestock.o6_22.category",
      "input.livestock.o6_22.deregistered_heads",
      "input.livestock.o6_22.eligible_gve",
      "input.livestock.o6_22.free_range.actual_gve_per_ha",
      "input.livestock.o6_22.free_range.all_animals_can_lie_simultaneously",
      "input.livestock.o6_22.free_range.authority_max_gve_per_ha",
      "input.livestock.o6_22.free_range.continuous_use_years",
      "input.livestock.o6_22.free_range.farrowing_huts_available",
      "input.livestock.o6_22.free_range.feed_and_water_separated",
      "input.livestock.o6_22.free_range.feed_on_hard_surface_or_moved_regularly",
      "input.livestock.o6_22.free_range.feed_roofed",
      "input.livestock.o6_22.free_range.roofed_three_sided_bedded_shelter",
      "input.livestock.o6_22.free_range.wild_boar_exclusion",
      "input.livestock.o6_22.individual_housing_days",
      "input.livestock.o6_22.measure",
      "input.livestock.o6_22.participation_gve",
      "input.livestock.o6_22.reporting.category_conditions_not_met",
      "input.livestock.o6_22.sow_type",
      "input.livestock.o6_22.supplement_facts.all_farm_pigs_compliant",
      "input.livestock.o6_22.supplement_facts.all_farm_solid_manure_composted",
      "input.livestock.o6_22.supplement_facts.all_participating_animals_uncut",
      "input.livestock.o6_22.supplement_facts.applies_to_whole_category",
      "input.livestock.o6_22.supplement_facts.compost_documentation_complete",
      "input.livestock.o6_22.supplement_facts.compost_log_complete",
      "input.livestock.o6_22.supplement_facts.compost_requested",
      "input.livestock.o6_22.supplement_facts.compost_stall",
      "input.livestock.o6_22.supplement_facts.compost_turn_count",
      "input.livestock.o6_22.supplement_facts.compost_turn_interval_days",
      "input.livestock.o6_22.supplement_facts.composter_on_farm",
      "input.livestock.o6_22.supplement_facts.composting_process_applied",
      "input.livestock.o6_22.supplement_facts.inter_farm_use_documented",
      "input.livestock.o6_22.supplement_facts.no_noncompliant_protein_feed_storage_or_feeding",
      "input.livestock.o6_22.supplement_facts.organic_mix_present",
      "input.livestock.o6_22.supplement_facts.protein_feed_evidence_available",
      "input.livestock.o6_22.supplement_facts.protein_requested",
      "input.livestock.o6_22.supplement_facts.uncut_requested",
      "input.livestock.o6_22.year"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_22 | full_document | 12 | {"not_rule": 1, "rules": 11} |
| o6_general | full_document | 11 | {"not_rule": 4, "rules": 7} |
| srl | targeted_sections | 2 | {"rules": 2} |
| srl_annexes | targeted_sections | 1 | {"rules": 1} |
| notice_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_12 | full_document | 1 | {"not_rule": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Native synthetische Modelltestbasis getrennt vom App-Adapter ausführen; Ergebnis als Kandidatenbefund protokollieren. |
| variation | defined | ja | Einzige Änderung: participation_gve von 2 auf 1,99 GVE; Reaktion der einzigen aggregierten Bestandsschwelle beobachten. |
| missing_fact | defined | ja | Einzige Auslassung: participation_gve; prüfen, ob das boolesche Einstiegsergebnis fehlende Daten von negativem Bestand unterscheidet. |

**Offene Abhängigkeiten:**

- Es fehlt ein aggregiertes Diagnose-/Entscheidungsobjekt, das Bestands-, Haltungs-, Platz-, Melde- und Zuschlagsprüfungen verknüpft.
- Für eine breitere Vorschau braucht jede separate Hilfsregel einen expliziten Eingabe- und Queryvertrag; dieser Minimalfall beweist nur Bestandsprüfung.
- Freilandalternative über die gesamte verfügbare Fläche und die Zuordnung älterer ungedeckter Sauen sind laut notes/assumptions.md offen.
- Betriebsgrößenmodulation und aktuelle Quellen-/Jahreszuordnung dürfen nicht aus dem einzelnen booleschen Ergebnis abgeleitet werden.

**Belege:**

- [runs/v2-o6_22-luna-high-20261005/workspace/policy/o6_22.rego](../../../runs/v2-o6_22-luna-high-20261005/workspace/policy/o6_22.rego): Nativer Package-/Querypfad und tatsächlich konsumierte Eingabefelder; keine neue fachliche Regel hinzugefügt.
- [runs/v2-o6_22-luna-high-20261005/workspace/tests/o6_22_test.rego](../../../runs/v2-o6_22-luna-high-20261005/workspace/tests/o6_22_test.rego): Herkunft der synthetischen Entwicklungsbasis und Modelltest-Beispiele zu Mindest-/Grenzwertreaktionen; keine unabhängige Sollreferenz.
- [runs/v2-o6_22-luna-high-20261005/workspace/data/o6_22_tables.json](../../../runs/v2-o6_22-luna-high-20261005/workspace/data/o6_22_tables.json): Historischer Datenkatalog für die vorhandenen Kategorien, Tabellen, Prämien und/oder Kombinationen.
- [runs/v2-o6_22-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_22-luna-high-20261005/workspace/notes/assumptions.md): Vom historischen Kandidaten dokumentierte Eingabe-, Quellen- und Auslegungsgrenzen.

### o6_23

Run: `v2-o6_23-luna-high-20261005`. [Fixture](fixtures/o6_23.json) · [Native Ergebnisse](results/o6_23.json)

**Eingaben:** Native Eingabe farm.year, land.total_area_ha und land.parcels[] mit Fläche in ha, Nutzungs-/Gebietsflags, Projektbestätigung, N2-/Antragscode, optionalen Auflagen sowie Düngegaben in kg N/ha; measure.o6_23 mit Vertrag, Antragstermin und Kombinationen. Kalenderdaten werden als ISO-Datumsstrings erwartet. Keine automatische Gebiets- oder Projektzuordnung.

**Ausgabebedeutung:** evaluate liefert compliant/status, Vertrags-/Antragsfelder, Prämienrechnung und schlagbezogene Teilbefunde. Kernkonformität deckt nicht alle allgemeinen ÖPUL-Bedingungen ab; Prämien können bei nicht konformen Fällen berechnet werden. Abwesende Düngewerte werden über fertilizer_applied als nicht nachgewiesene Ausbringung behandelt und erzeugen keinen eigenständigen Missing-Data-Status.

**Herkunft:** Synthetische DEVELOPMENT-Eingaben: Basis aus dem historischen Luna-Modelltest valid_input; gezielte Einzelvariation und Auslassungsfall von der Sichtung abgeleitet. Keine unabhängig erstellten oder fachlich adjudizierten Gold-/Heldoutfälle.

**Query:** `data.oepul.o6_23.evaluate`

**Inventar:** 28 Regelkatalog-Einträge; 8 Quellen; 24 statisch erkannte Eingabepfade; 30 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_condition": 1, "application_coding": 1, "application_deadline": 1, "closed_code_list": 1, "consequence": 2, "contract_duration": 1, "contract_extension": 1, "cross_cutting_condition": 1, "cross_measure_condition": 1, "duration_condition": 1, "eligibility_scope": 1, "entry_deadline": 1, "farm_minimum_size": 1, "general_minimum_management": 1, "management_obligation": 2, "measure_combination": 1, "minimum_participation": 1, "obligation_combination": 1, "premium_cap": 1, "premium_modulation": 1, "premium_rate_table": 1, "territorial_eligibility": 1, "withdrawal": 1, "withdrawal_effect": 1, "year_specific_exception": 2}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.farm.year",
      "input.land.parcels",
      "input.land.parcels[].annual_full_area_mown_or_grazed",
      "input.land.parcels[].area_ha",
      "input.land.parcels[].land_use",
      "input.land.parcels[].project_confirmation_obligations",
      "input.land.parcels[].project_confirmation_obligations[].chapter",
      "input.land.parcels[].valid",
      "input.land.total_area_ha",
      "input.measure.o6_23",
      "input.measure.o6_23.application_date",
      "input.measure.o6_23.biodiversity_area_code",
      "input.measure.o6_23.combined_premium_eur_ha",
      "input.measure.o6_23.contract_year_completed",
      "input.measure.o6_23.contract_years",
      "input.measure.o6_23.cut_date_changed",
      "input.measure.o6_23.early_use_days",
      "input.measure.o6_23.early_use_premium_code",
      "input.measure.o6_23.other_measures",
      "input.measure.o6_23.requested",
      "input.measure.o6_23.second_mowing_on_comparable_fields",
      "input.measure.o6_23.state_regulation_adjusted",
      "input.measure.o6_23.withdrawal_date",
      "input.measure.o6_23.withdrawal_not_declared"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_23_information_sheet | full_document | 5 | {"not_rule": 1, "rules": 4} |
| o6_general_information_sheet | full_document | 21 | {"not_rule": 9, "rules": 12} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 7 | {"rules": 7} |
| oepul_sonderrichtlinie_anhaenge_2023 | targeted_sections | 6 | {"not_rule": 2, "rules": 4} |
| notice_2026_05_22_biodiversity | full_document | 3 | {"not_rule": 2, "rules": 1} |
| notice_2026_06_12_insecticide | full_document | 2 | {"not_rule": 2} |
| notice_2026_08_05_drought | full_document | 3 | {"not_rule": 3} |
| notice_2026_08_12_drought_processing | full_document | 5 | {"not_rule": 4, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Native synthetische Modelltestbasis getrennt vom App-Adapter ausführen; Ergebnis als Kandidatenbefund protokollieren. |
| variation | defined | ja | Einzige Änderung: mineralische N-Gabe von 0 auf 1 kg N/ha bei N2GI05; Düngungs- und Gesamtteilbefund beobachten. |
| missing_fact | defined | nein | Einzige Auslassung: mineral_n_kg_per_ha bei weiterhin 0 organischem N; prüfen, ob eine unbekannte mineralische Gabe als fehlende Evidenz sichtbar wird. |

**Offene Abhängigkeiten:**

- Konkrete Landesregelung/Projektbestätigung mit Schnittterminen und nicht prämienrelevanten Auflagen fehlt als unabhängige Referenz.
- Die 2026-Schnittausnahme braucht die tatsächlich angepasste Landesverordnung; die Modellannahme ersetzt diesen Nachweis nicht.
- Schnittdatenpfad enthält eine akzeptierende Regel auch für dates[0] &lt; cutoff ohne Ausnahme; separat zu prüfen, keine fachliche Bestätigung.
- Düngefakten, Gebiets-/N2-Codes und allgemeine Mindest-/Konditionalitätsbedingungen brauchen belastbare Eingabe- und Referenzverträge.

**Belege:**

- [runs/v2-o6_23-luna-high-20261005/workspace/policy/o6_23.rego](../../../runs/v2-o6_23-luna-high-20261005/workspace/policy/o6_23.rego): Nativer Package-/Querypfad und tatsächlich konsumierte Eingabefelder; keine neue fachliche Regel hinzugefügt.
- [runs/v2-o6_23-luna-high-20261005/workspace/tests/o6_23_test.rego](../../../runs/v2-o6_23-luna-high-20261005/workspace/tests/o6_23_test.rego): Herkunft der synthetischen Entwicklungsbasis und Modelltest-Beispiele zu Mindest-/Grenzwertreaktionen; keine unabhängige Sollreferenz.
- [runs/v2-o6_23-luna-high-20261005/workspace/data/o6_23.json](../../../runs/v2-o6_23-luna-high-20261005/workspace/data/o6_23.json): Historischer Datenkatalog für die vorhandenen Kategorien, Tabellen, Prämien und/oder Kombinationen.
- [runs/v2-o6_23-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_23-luna-high-20261005/workspace/notes/assumptions.md): Vom historischen Kandidaten dokumentierte Eingabe-, Quellen- und Auslegungsgrenzen.

### o6_24

Run: `v2-o6_24-luna-high-20261005`. [Fixture](fixtures/o6_24.json) · [Native Ergebnisse](results/o6_24.json)

**Eingaben:** Native Eingabe farm.year/region, land.parcels[] mit ha und WRRL-Gebiets-/Bewilligungsflags, annual_effective_n_kg_per_ha und wrrl_annual_limit_kg_per_ha in kg N/ha, aus externer Quelle vorausgesetzte Fristkonformität sowie documentation.wrrl_farm_book_complete. Grenzwert und Gebietszuordnung sind synthetisch vorgegeben, nicht aus aktuellen Originalen abgeleitet.

**Ausgabebedeutung:** decision liefert Fläche, Mindestteilnahme, N-Grenzwert-/Frist-/Buchführungsflags, all_measure_conditions_met und Euro/ha sowie Dürrekontext. all_measure_conditions_met ist der verknüpfte WRRL-Teilausschnitt, keine vollständige ÖPUL-Förderfreigabe. Fehlende Mengen werden in der Verletzungs-Comprehension übersprungen; true ist dann kein Nachweis vollständiger Eingaben.

**Herkunft:** Synthetische DEVELOPMENT-Eingaben: Basis aus dem historischen Luna-Modelltest valid_input; gezielte Einzelvariation und Auslassungsfall von der Sichtung abgeleitet. Keine unabhängig erstellten oder fachlich adjudizierten Gold-/Heldoutfälle.

**Query:** `data.oepul.o6_24.decision`

**Inventar:** 33 Regelkatalog-Einträge; 8 Quellen; 6 statisch erkannte Eingabepfade; 10 Profilvorschläge. Unabhängige Referenzfälle: `not_adjudicated`.

**Regeltypen:** `{"access_requirement": 1, "applicant_eligibility": 1, "application": 1, "application_deadline": 1, "application_window": 1, "area_determination": 1, "combination": 1, "contract_consequence": 1, "contract_duration": 1, "control": 1, "default_classification": 1, "eligibility_exclusion": 1, "entry_deadline": 1, "farm_minimum_size": 1, "fertilizer_limit": 1, "fertilizer_requirement": 1, "location": 1, "minimum_management": 1, "modulation": 1, "non_eligible_area": 1, "payment": 1, "premium": 1, "recordkeeping": 1, "renewal": 1, "sanction": 1, "sanction_update": 1, "scope": 1, "split_recordkeeping": 1, "temporary_exception": 1, "weighted_limit": 1, "withdrawal": 1, "withdrawal_consequence": 1, "withdrawal_timing": 1}`

<details>
<summary>Statische Eingabepfade und vom Modell berichtete Quellen-Coverage</summary>

Inventar und Quellen-Coverage stammen aus historischen Modellartefakten. Modellkataloge und selbst berichtete Quellen-Coverage sind kein Nachweis unabhängig bestätigter Vollständigkeit. Statisch erkannte Eingabepfade sind unvollständig, erfassen dynamische Referenzen nicht vollständig und sind kein Nachweis tatsächlich zur Laufzeit konsumierter Fakten.

Statische Eingabepfade (keine Laufzeitspur):

    [
      "input.documentation.drought_no_harvestable_stand",
      "input.documentation.wrrl_farm_book_complete",
      "input.farm.region.district",
      "input.farm.region.federal_state",
      "input.farm.year",
      "input.land.parcels"
    ]

| Quellen-ID | Berichteter Prüfbereich | Einträge | Einordnung |
|---|---|---|---|
| o6_24 | full_document | 4 | {"rules": 4} |
| o6_general | full_document | 12 | {"not_rule": 3, "rules": 9} |
| srl_oepul_2023 | targeted_sections | 7 | {"rules": 7} |
| srl_oepul_2023_annexes | targeted_sections | 2 | {"rules": 2} |
| notice_2026_05_22 | full_document | 1 | {"not_rule": 1} |
| notice_2026_06_12 | full_document | 1 | {"not_rule": 1} |
| notice_2026_08_05 | full_document | 2 | {"not_rule": 1, "rules": 1} |
| notice_2026_08_12 | full_document | 2 | {"not_rule": 1, "rules": 1} |

</details>

Regeltypen, Quellen, Datenanforderungen und offene fachliche Abhängigkeiten helfen bei der Auswahl des Versuchsausschnitts und der nötigen Referenzarbeit; ein Aufwand in Stunden wird nicht geschätzt. not_adjudicated bedeutet, dass unabhängige Referenzfälle und fachlich bestätigte Sollentscheidungen benötigt werden. Bereits sichtbare Entwicklungsfixtures sind keine zurückgehaltenen Testfälle und dürfen nicht nachträglich dazu umetikettiert werden.

| Fall | Beobachteter Status | Ausgabe gegenüber Basis geändert | Zweck |
|---|---|---|---|
| baseline | defined | Basis | Native synthetische Modelltestbasis getrennt vom App-Adapter ausführen; Ergebnis als Kandidatenbefund protokollieren. |
| variation | defined | ja | Einzige Änderung: annual_effective_n_kg_per_ha von 120 auf 131 kg N/ha bei vorgegebenem Grenzwert 130; N-Grenzwertbefund beobachten. |
| missing_fact | defined | nein | Einzige Auslassung: annual_effective_n_kg_per_ha; prüfen, ob eine unbekannte N-Menge bei vorhandenem Grenzwert als Datenlücke sichtbar wird. |

**Offene Abhängigkeiten:**

- WRRL-Gebietskulisse, Düngeklasse, rechtlich richtige N-Grenzwerte und Ausbringungszeiträume sind externe vorausgesetzte Tatsachen; hier nur synthetisch.
- Aktuelle WRRL-/NAPV-Originale aus neuer Quellenaufnahme sind nicht automatisch in diesen historischen Kandidaten übernommen.
- Fehlende N-Menge oder Fristfakten können in Verletzungslisten verschwinden; die Missing-Data-Semantik ist vor fachlicher Nutzung zu klären.
- Allgemeine ÖPUL-Antrags-/Förderbedingungen und Kombinationen sind nicht mit all_measure_conditions_met verknüpft.

**Belege:**

- [runs/v2-o6_24-luna-high-20261005/workspace/policy/o6_24.rego](../../../runs/v2-o6_24-luna-high-20261005/workspace/policy/o6_24.rego): Nativer Package-/Querypfad und tatsächlich konsumierte Eingabefelder; keine neue fachliche Regel hinzugefügt.
- [runs/v2-o6_24-luna-high-20261005/workspace/tests/o6_24_test.rego](../../../runs/v2-o6_24-luna-high-20261005/workspace/tests/o6_24_test.rego): Herkunft der synthetischen Entwicklungsbasis und Modelltest-Beispiele zu Mindest-/Grenzwertreaktionen; keine unabhängige Sollreferenz.
- [runs/v2-o6_24-luna-high-20261005/workspace/data/o6_24_reference_tables.json](../../../runs/v2-o6_24-luna-high-20261005/workspace/data/o6_24_reference_tables.json): Historischer Datenkatalog für die vorhandenen Kategorien, Tabellen, Prämien und/oder Kombinationen.
- [runs/v2-o6_24-luna-high-20261005/workspace/notes/assumptions.md](../../../runs/v2-o6_24-luna-high-20261005/workspace/notes/assumptions.md): Vom historischen Kandidaten dokumentierte Eingabe-, Quellen- und Auslegungsgrenzen.
