# o6_12: Eingabevertrag und tatsächliche App-Projektion

Run `v2-o6_12-opus-5.5-high-20261009`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieser Teil ist fertig als öffentliche Entwicklungsanalyse, ohne Förderfreigabe oder Genauigkeitsaussage. Inputs-JSON SHA-256: `32c0a832be99387c0d90798286ffe607b454839611e168e8fd16e25fd52c7c8d`.

83 frische Proben ergeben 119 typisierte Einzelprüfungen: 68 erfüllt, 51 nicht erfüllt. 57 native Ergebnisse sind definiert, fünf undefiniert, 21 enden mit Laufzeitfehler. Darin sind 13 separate Prädikat-/Helferabfragen enthalten. Eine zusätzliche unveränderte App-Projektion wird separat nativ abgespielt und ist undefiniert.

## Quellen und vollständiger Lesebereich

Das neue Merkblatt wurde auf allen vier Seiten einschließlich Tabellen, Fortsetzungen und Ausnahmen vollständig gelesen: `720df07d4aa2fcc42fc8f087ff9e32abdced5be950408c0292f7b3bcf48415b8`. Alle sechs produktiven Module mit insgesamt 1.063 Zeilen sowie alle 17 nummerierten Annahmen, offenen Fragen und Rohnotizen wurden vollständig gelesen.

Die neun tatsächlich gebundenen Originalquellen wurden per SHA-256 geprüft. Acht geteilte Quellen verwenden die dokumentierten vollständigen Vorlektüren bei identischem Hash. Die GSP-AV ist hier tatsächlich als 94-seitiges Original gebunden (`d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10`); ihre aktuellen Verbraucherklauseln wurden auf PDF-Seiten 10, 11, 14, 18, 20, 21, 23, 24, 25, 30, 31 erneut vollständig gelesen. Das ist keine Behauptung einer neuen vollständigen 94-Seiten-Lektüre in diesem Teil. NAPV ist hier nicht geliefert und wird nicht zugerechnet.

Die weiteren aktuellen ATB-/SRL-/Anhangseiten stehen genau im JSON-Lesebeleg; teils wurden die persönlichen aktuellen Lektüren aus 10/11 bei gleichem Originalhash verwendet, zusätzlich insbesondere ATB 15/16 und SRL 9/13/14/16/37/67 vollständig gelesen. Alle vier gebundenen Hinweise wurden für Maßnahme 12 erneut zugeordnet. Sämtliche 97 dem Profil zugewiesenen Quellenbelege wurden auf der tatsächlichen Seite nach ausschließlich Whitespace-Normalisierung wiedergefunden.

**Offen bleibt der Quellenversionskonflikt:** Das Merkblatt erklärt den Wegfall der PSM-Codierung ab 2026; die tatsächlich gelieferte GSP-AV § 34 Abs. 2 Z 12 lit. f auf PDF 25 verlangt für 70-10 weiterhin die PSM-Angabe. Die native 2025-Grenze und die technische 2026 Probe lösen diesen Konflikt nicht.

## Vollständiger Profilkatalog

24 tatsächliche `add`-Vorschläge mit 96 Blättern: 93 gelesen, drei ungelesen. 217 kontextuelle Lesestellen einschließlich vorhandener Canonicalpfade sind dokumentiert. Die zwei dynamischen Mindestbewirtschaftungs-Schleifen werden jeweils auf dieselben drei tatsächlichen Schlüssel geschlossen: sechs Vorkommen, drei unterschiedliche Blattpfade. Acht weitere gelesene Pfade gehören zum unveränderten Canonical; es gibt keinen unvorgeschlagenen nativen Zusatzpfad.

| Nr. | Tatsächlicher Vorschlagspfad | Blätter | gelesen / ungelesen |
|---:|---|---:|---:|
| 1 | `farm.applicant` | 4 | 4 / 0 |
| 2 | `land.protected_cultivation_area_ha` | 1 | 1 / 0 |
| 3 | `oepul.first_participation_year` | 1 | 1 / 0 |
| 4 | `oepul.participating_measures` | 1 | 1 / 0 |
| 5 | `oepul.bio_teilbetrieb` | 2 | 2 / 0 |
| 6 | `oepul.undeclared_parcels_area_ha` | 1 | 1 / 0 |
| 7 | `oepul.o6_12` | 60 | 57 / 3 |
| 8 | `land.parcels[].land_use_code` | 1 | 1 / 0 |
| 9 | `land.parcels[].crop.usage_type` | 1 | 1 / 0 |
| 10 | `land.parcels[].crop.grafted_planting_material` | 1 | 1 / 0 |
| 11 | `land.parcels[].in_vineyard_register` | 1 | 1 / 0 |
| 12 | `land.parcels[].country` | 1 | 1 / 0 |
| 13 | `land.parcels[].oepul_codes` | 1 | 1 / 0 |
| 14 | `land.parcels[].declared_measures` | 1 | 1 / 0 |
| 15 | `land.parcels[].measure_op_exclusions` | 1 | 1 / 0 |
| 16 | `land.parcels[].national_park` | 1 | 1 / 0 |
| 17 | `land.parcels[].is_gloez_landscape_element` | 1 | 1 / 0 |
| 18 | `land.parcels[].mainly_agricultural_use` | 1 | 1 / 0 |
| 19 | `land.parcels[].non_agricultural_use_days` | 1 | 1 / 0 |
| 20 | `land.parcels[].other_public_funding_same_service` | 1 | 1 / 0 |
| 21 | `land.parcels[].commitment_fulfilled_whole_year` | 1 | 1 / 0 |
| 22 | `land.parcels[].minimum_management` | 3 | 3 / 0 |
| 23 | `land.parcels[].other_area_payments_eur_per_ha` | 1 | 1 / 0 |
| 24 | `land.parcels[].psm_applications` | 8 | 8 / 0 |

Jedes Blatt erhält im JSON seinen tatsächlichen Deskriptor, Einheit, Bedeutung, zeitlichen/bedingten Kontext, Default, Nullabgrenzung, Quellenbelege, alle Lesestellen und das tatsächliche App-Ergebnis. Die folgenden vollständigen 96 Zeilen zeigen Typ und Verbraucherscope; vollständige Defaults und Begründungen stehen unmittelbar im JSON-Blattkatalog.

| Blatt | Deskriptor | Scope | Lesestellen |
|---|---|---|---|
| `farm.applicant.legal_form` | `enum(natural_person\|registered_partnership\|legal_person\|association\|public_body)` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:11, eligibility.rego:15, eligibility.rego:32, eligibility.rego:37 |
| `farm.applicant.public_body_share_percent` | `number\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:20 |
| `farm.applicant.is_active_farmer` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:24 |
| `farm.applicant.farms_in_own_name_and_account` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:28 |
| `land.protected_cultivation_area_ha` | `number\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:82 |
| `oepul.first_participation_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:76 |
| `oepul.participating_measures[]` | `enum(1A\|1B\|1C\|2\|3\|4\|5\|6\|7\|8\|9\|10\|11\|12\|13\|14\|15\|16\|17\|18\|19\|20\|21\|22\|23\|24)` | bedingter MAIN-Nachweis/Betrag | common.rego:13 |
| `oepul.bio_teilbetrieb.is_participating` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:95 |
| `oepul.bio_teilbetrieb.organic_cultural_area` | `enum(arable_grassland\|permanent_crops\|null)` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:96 |
| `oepul.undeclared_parcels_area_ha` | `number\|null` | nur separater Helfer | sanctions.rego:46 |
| `oepul.o6_12.participating` | `boolean` | bedingter MAIN-Nachweis/Betrag | common.rego:15 |
| `oepul.o6_12.application_submitted_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:46 |
| `oepul.o6_12.contract_start_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | common.rego:47, common.rego:55, contract.rego:112, eligibility.rego:49, eligibility.rego:59 |
| `oepul.o6_12.first_year_area_ha` | `number\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:67, eligibility.rego:69 |
| `oepul.o6_12.annual_application_submitted` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:113 |
| `oepul.o6_12.payment_application_missing_over_one_year` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | contract.rego:92, contract.rego:119 |
| `oepul.o6_12.previous_year_area_ha` | `number\|null` | nur separater Helfer | contract.rego:128, contract.rego:131 |
| `oepul.o6_12.area_reduction_cause` | `enum(none\|loss_of_control\|land_use_change\|code_removed\|null)` | nur separater Helfer | contract.rego:137 |
| `oepul.o6_12.declared_area_ha` | `number\|null` | bedingter MAIN-Nachweis/Betrag | premium.rego:65 |
| `oepul.o6_12.determined_area_ha` | `number\|null` | bedingter MAIN-Nachweis/Betrag | premium.rego:67 |
| `oepul.o6_12.control_announced_date` | `date\|null` | nur separater Helfer | contract.rego:72, contract.rego:77 |
| `oepul.o6_12.control_refused` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:99, premium.rego:54 |
| `oepul.o6_12.contract_adjustment_refused` | `boolean` | nur separater Helfer | contract.rego:255 |
| `oepul.o6_12.previous_full_reductions` | `int` | bedingter MAIN-Nachweis/Betrag | sanctions.rego:29 |
| `oepul.o6_12.exit.requested` | `boolean` | bedingter MAIN-Nachweis/Betrag | common.rego:65 |
| `oepul.o6_12.exit.request_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:19, contract.rego:47, contract.rego:50, contract.rego:66, contract.rego:77, contract.rego:83, obligations.rego:17 |
| `oepul.o6_12.exit.reason` | `enum(regular\|rebzikade_2026\|null)` | bedingter MAIN-Nachweis/Betrag | contract.rego:14 |
| `oepul.o6_12.exit.submitted_via_force_majeure_form` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:29 |
| `oepul.o6_12.exit.rebzikade_reason_stated` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:34 |
| `oepul.o6_12.exit.approved` | `boolean\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:39 |
| `oepul.o6_12.switch_to_bio.requested` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | contract.rego:59 |
| `oepul.o6_12.switch_to_bio.application_date` | `date\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | contract.rego:60 |
| `oepul.o6_12.takeover.is_takeover` | `boolean` | nur separater Helfer | contract.rego:159, contract.rego:164, contract.rego:169, contract.rego:174, contract.rego:179 |
| `oepul.o6_12.takeover.submission_date` | `date\|null` | nur separater Helfer | contract.rego:160 |
| `oepul.o6_12.takeover.taken_over_area_ha` | `number\|null` | nur separater Helfer | contract.rego:165 |
| `oepul.o6_12.takeover.additional_area_ha` | `number\|null` | nur separater Helfer | contract.rego:165 |
| `oepul.o6_12.takeover.approved_by_ama` | `boolean\|null` | nur separater Helfer | contract.rego:175 |
| `oepul.o6_12.takeover.taker_previously_participating` | `boolean` | nur separater Helfer | contract.rego:170 |
| `oepul.o6_12.farm_transfer.occurred` | `boolean` | nur separater Helfer | contract.rego:188, contract.rego:193 |
| `oepul.o6_12.farm_transfer.effective_date` | `date\|null` | nur separater Helfer | contract.rego:194 |
| `oepul.o6_12.farm_transfer.notification_date` | `date\|null` | nur separater Helfer | contract.rego:194 |
| `oepul.o6_12.farm_transfer.successor_continues_commitment` | `boolean` | nur separater Helfer | contract.rego:189 |
| `oepul.o6_12.force_majeure.case_id` | `enum(eu_2021_2116_art3\|permanent_cession_public\|temporary_public_land_use\|animal_death_natural_event\|early_herd_descent\|official_disease_order\|null)` | nur separater Helfer | contract.rego:203, contract.rego:217 |
| `oepul.o6_12.force_majeure.able_to_notify_date` | `date\|null` | nur separater Helfer | contract.rego:207 |
| `oepul.o6_12.force_majeure.claim_date` | `date\|null` | nur separater Helfer | contract.rego:207 |
| `oepul.o6_12.force_majeure.documented` | `boolean` | nur separater Helfer | contract.rego:213 |
| `oepul.o6_12.circumstance.type` | `enum(permanent\|temporary\|null)` | nur separater Helfer | contract.rego:224, contract.rego:230, contract.rego:236, contract.rego:242, contract.rego:248 |
| `oepul.o6_12.circumstance.beyond_control` | `boolean` | nur separater Helfer | contract.rego:225 |
| `oepul.o6_12.circumstance.notified` | `boolean` | nur separater Helfer | contract.rego:226 |
| `oepul.o6_12.circumstance.event_date` | `date\|null` | nur separater Helfer | contract.rego:232 |
| `oepul.o6_12.circumstance.conditions_met_on_changed_areas` | `boolean\|null` | nur separater Helfer | contract.rego:244 |
| `oepul.o6_12.authority_orders[].order_id` | `string` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:6, obligations.rego:28 |
| `oepul.o6_12.authority_orders[].federal_state` | `string\|null` | ungelesen | — |
| `oepul.o6_12.authority_orders[].pest` | `string\|null` | ungelesen | — |
| `oepul.o6_12.authority_orders[].chemical_synthetic_explicitly_ordered` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:35 |
| `oepul.o6_12.authority_orders[].bio_substances_available` | `boolean\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:42 |
| `oepul.o6_12.authority_orders[].documented_on_farm` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:73 |
| `oepul.o6_12.authority_orders[].uploaded_to_eama` | `boolean\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:93 |
| `oepul.o6_12.insecticide_stock[].product_name` | `string` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:102, obligations.rego:111 |
| `oepul.o6_12.insecticide_stock[].is_insecticide` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:105, obligations.rego:114 |
| `oepul.o6_12.insecticide_stock[].eu_2018_848_permitted` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:106, obligations.rego:115 |
| `oepul.o6_12.insecticide_stock[].intended_for_other_crops` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:107, obligations.rego:116 |
| `oepul.o6_12.insecticide_stock[].quantity_plausible` | `boolean\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:121 |
| `oepul.o6_12.insecticide_stock[].records_kept` | `boolean\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:122 |
| `oepul.o6_12.insecticide_stock[].authority_order_id` | `string\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:108 |
| `oepul.o6_12.violations[].obligation_id` | `string` | ungelesen | — |
| `oepul.o6_12.violations[].level` | `int` | bedingter MAIN-Nachweis/Betrag | sanctions.rego:21 |
| `oepul.o6_12.violations[].detected_by` | `enum(administrative\|on_site)` | nur separater Helfer | sanctions.rego:36 |
| `oepul.o6_12.violations[].occurrence_same_obligation` | `int` | bedingter MAIN-Nachweis/Betrag | sanctions.rego:21 |
| `oepul.o6_12.violations[].serious` | `boolean` | nur separater Helfer | sanctions.rego:41 |
| `land.parcels[].land_use_code` | `enum(A\|G\|S\|WI\|WT\|GA\|L\|D\|FO\|NF)` | bedingter MAIN-Nachweis/Betrag | contract.rego:271, eligibility.rego:168, eligibility.rego:169 |
| `land.parcels[].crop.usage_type` | `enum(regular\|schnittweingarten\|rebschule\|baumschule\|sonstige_weinflaeche\|sonstige_spezialkulturflaeche\|energieholz_niederwald_kurzumtrieb\|palmkaetzchenproduktion)` | bedingter MAIN-Nachweis/Betrag | common.rego:23 |
| `land.parcels[].crop.grafted_planting_material` | `boolean\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:187, eligibility.rego:268 |
| `land.parcels[].in_vineyard_register` | `boolean\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:175 |
| `land.parcels[].country` | `string` | bedingter MAIN-Nachweis/Betrag | common.rego:40, eligibility.rego:217 |
| `land.parcels[].oepul_codes[]` | `string` | bedingter MAIN-Nachweis/Betrag | common.rego:25 |
| `land.parcels[].declared_measures[]` | `string` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:207, eligibility.rego:291, eligibility.rego:299 |
| `land.parcels[].measure_op_exclusions[]` | `string` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:202, eligibility.rego:278 |
| `land.parcels[].national_park` | `string\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:212 |
| `land.parcels[].is_gloez_landscape_element` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:222 |
| `land.parcels[].mainly_agricultural_use` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:227 |
| `land.parcels[].non_agricultural_use_days` | `int\|null` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:232 |
| `land.parcels[].other_public_funding_same_service` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:248 |
| `land.parcels[].commitment_fulfilled_whole_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:253 |
| `land.parcels[].minimum_management.properly_planted` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:243, obligations.rego:172 |
| `land.parcels[].minimum_management.annual_care` | `boolean` | bedingter MAIN-Nachweis/Betrag | eligibility.rego:243, obligations.rego:172 |
| `land.parcels[].minimum_management.harvested` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:281, eligibility.rego:243, eligibility.rego:276, obligations.rego:172 |
| `land.parcels[].other_area_payments_eur_per_ha` | `number\|null` | nur separater Helfer | premium.rego:144 |
| `land.parcels[].psm_applications[].date` | `date` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:17, obligations.rego:50 |
| `land.parcels[].psm_applications[].product_name` | `string\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:50 |
| `land.parcels[].psm_applications[].action_type` | `enum(insecticide\|herbicide\|fungicide\|other)` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:55, obligations.rego:90, obligations.rego:133, obligations.rego:139 |
| `land.parcels[].psm_applications[].chemical_synthetic` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:12 |
| `land.parcels[].psm_applications[].eu_2018_848_permitted` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:10 |
| `land.parcels[].psm_applications[].flat_application` | `boolean` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:129 |
| `land.parcels[].psm_applications[].authority_order_id` | `string\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:25, obligations.rego:32, obligations.rego:39, obligations.rego:67, obligations.rego:71, obligations.rego:72, obligations.rego:76, obligations.rego:80, obligations.rego:81, obligations.rego:85, obligations.rego:92 |
| `land.parcels[].psm_applications[].substance_approved_by_order` | `boolean\|null` | MAIN-Meldung/Rückforderung, kein eigener aktueller Betragsschalter | obligations.rego:26, obligations.rego:33, obligations.rego:40 |

27 gelesene Blätter erreichen ausschließlich separate Helfer. Weitere 23 wirken in MAIN-Meldungen bzw. rückwirkenden Rückforderungszweigen ohne eigenen aktuellen Betragsschalter. Diese rückwirkende finanzielle Wirkung wird nicht verworfen. Ungelesen bleiben `oepul.o6_12.authority_orders[].federal_state`, `.pest` und `oepul.o6_12.violations[].obligation_id`.

| Weiterer Canonicalpfad | tatsächlicher Scope | App exakt erhalten |
|---|---|---|
| `farm.region.district` | Exact district string for 2026 drought lookup in arable-only helper; not a MAIN 12 vineyard harvest waiver. | nein |
| `farm.region.federal_state` | Exact federal-state string for same lookup; no MAIN financial gate. | nein |
| `farm.year` | Integer current year, separate from original start/application/history. | ja |
| `land.parcels[].area_ha` | Current physical parcel hectares; minimum, 50 m 2 boundary, eligible sum and parcel premium. Null outside number contract. | ja |
| `land.parcels[].crop.crop_category` | Exact Canonical crop-category enum; default other cannot substitute verified crop identity. | nein |
| `land.parcels[].crop.crop_name` | Free Canonical string oder null, exact listed fruit identity in orchard branch; null excludes here, not an enum and not 11 fallback. | nein |
| `land.parcels[].parcel_id` | Exact parcel identity and output object key; duplicate conflicting rows may conflict. | ja |
| `land.total_area_ha` | Actual whole-holding hectares, not automatically eligible 12 area; first-program minimum/modulation and separate underdeclaration helper. | ja |

## Ausgangsfälle und Grenzen der Sollwerte

Die drei positiven 2025-Quellenfälle enthalten jeweils bekannte 2 ha Wein, Apfel bzw. Hopfen, korrekte Originalantrags-/Vertragsdaten, aktuelle Beantragung und alle jeweils relevanten Lage-, Qualitäts- und Bewirtschaftungsfakten. Sie enthalten keinen PSM-Einsatz/-Kauf/-Bestand, keine Anordnung und kein optionales Ausstiegs-/Umstiegs-/Übertragungs-/Gewaltereignis. Die erwarteten 540 EUR werden in allen drei Fällen erreicht; der 2023-Fall erreicht 500 EUR, 2026 ebenfalls 540 EUR. Im Folgejahr mit nachgewiesen erfüllter ursprünglicher 2 ha-Mindestfläche werden 0,4 ha korrekt mit 108 EUR gefördert. OP, explizit fehlender Jahreszahlungsantrag nach dem ersten Jahr und bekannte Kontrollverweigerung sperren tatsächlich. Die gesonderte 25%-Stufenkontrolle berechnet 405 EUR ausschließlich unter der ausdrücklich hypothetischen, schon behördlich festgesetzten Eingabestufe.

Elf Quellenkomponenten, 26 gewünschte Positivnachweisgrenzen, 37 technische Eingabekontrollen und neun ausdrücklich außerhalb des Schemas liegende Stresse sind getrennt gekennzeichnet. Die Positivnachweisregel ist ein gewünschter Autorisierungsvertrag; unbekannte Pflichtnachweise werden damit nicht zu tatsächlichen verspäteten Anträgen, illegalen Mitteln oder beliebigen 100%-Sanktionen erklärt.

Alle PSM-/Bio-/Anordnungs-Kreuzflags und Produktetiketten sind rein synthetische technische Kontrollen. Es wird weder ein tatsächlich registriertes/biologisch zugelassenes Produkt noch eine echte behördliche Anordnung behauptet. Die Bio-Ausnahme verlangt `eu_2018_848_permitted=true`; der Vorschlag ist `boolean`, nicht nullable. Ein fehlender positiver Beleg gibt keine Verwendung frei. Eine native Meldung `insecticide_use` bei fehlendem Beleg ist noch kein Nachweis tatsächlich verbotener Verwendung. Codes wie PSMBIO ersetzen keinen Produktbeleg.

## Laufzeit, fehlende Nachweise und Identität

| Gruppe | Anzahl | tatsächliche Pfade / Abgrenzung |
|---|---:|---|
| Gültiges Nullable in MAIN | 5 | Originalantragsdatum, deklarierte und ermittelte Fläche, tatsächlich ausgewähltes Ausstiegs- und Umstiegsdatum |
| Gültiges Nullable nur im separaten Helfer | 10 | Übernahme 2, Betriebsübertragung 2, höhere Gewalt 2, dauerhaftes Ereignis 1, Vorjahresfläche 1, Kontrollankündigung 1, andere Zahlungen 1 |
| Strukturell erlaubte widersprüchliche Identität in MAIN | 2 | gleiche Anordnungs-ID mit abweichenden Datensätzen; gleiche Schlag-ID mit abweichender Fläche |
| Außerhalb des Schemas, MAIN-Laufzeitfehler | 4 | null in drei nicht nullfähigen int-Sanktionsfeldern; null im Canonical-Flächenfeld vom Typ number |
| MAIN undefiniert | 5 | fehlende Rechtsform, fehlender Originalantrag, fehlendes Startjahr, gültiges Startjahr=null, bekannte Nichtteilnahme |

Die letzten fünf sind keine Laufzeitfehler und kein definiertes negatives Ergebnis: Das MAIN-Objekt referenziert positive Prädikate ohne false-Defaults. In der Nullable-Umstiegsprobe ist der erforderliche reguläre Ausstiegs-/Umstiegszweig tatsächlich ausgewählt; eine leere optionale Nicht-Ereignisbranche wird nicht gleichgesetzt. Vorjahresfläche, Kontrollankündigung und andere Zahlungen sind separat jeweils mit unverändertem MAIN 540 gepaart. Ihr Helferabbruch wird nicht als MAIN-Abbruch gezählt.

Die gültigen Nullwerte in Kataster-/Veredelungs- und mehreren Nachweisfeldern können einen bestehenden positiven Guard passieren; das ist eine Nachweisgrenze, kein bestätigter positiver Fachbeleg. Fehlende Erstjahresfläche bleibt später unknown und kann zahlen, null wird hier zu `not_met`/0 ohne bekannten tatsächlichen Flächenwert. Fehlender schlagbezogener 12-Antrag und Canonical-Obstname=null sperren hingegen. 0 ha wird im vorliegenden Lauf definiert ausgeschlossen; ein früherer Lauf-Abbruch wird nicht übertragen.

Native Rebzikade- und Übernahmefreigaben prüfen `approved` nur auf false. Gezielte missing-/null-Proben liefern deshalb true statt einer Freigabe nur bei positivem Nachweis. Die Übernahmeprüfung ist ein separater Helfer, keine alternative MAIN-Vertragsgrundlage. Anordnungs-ID, Gebiet, Schädling, tatsächlicher Wirkstoff und Dokument bleiben vorgelagerte Fakten; die drei ungelesenen Blätter werden nicht als wirksame Prüfung gezählt.

Alle 21 Laufzeitfehler und alle fünf undefinierten Fälle sind im JSON mit vollständigem Pfad, Achse des tatsächlichen Deskriptors, MAIN-/Helferscope, Query und nativer Fehlermeldung einzeln aufgeschlüsselt. Die Suite ist gezielt, keine vollständige kartesische Vollständigkeits- oder behördliche Tatsachenbescheinigung.

## Tatsächlich ausgeführte App-Projektion

Die unveränderte reine Funktion `adapt_payload_for_measures` wurde auf Appcommit `529eadb34c4fdd249fbf739a372d63185b7374a2` mit einem strukturellen Eingabeverbund aller 24 Vorschläge ausgeführt. Dieser Verbund ist keine behauptete reale Farm mit allen optionalen Ereignissen. Ein installierter `CursorWrapper.execute`-Guard hätte jeden SQL-Aufruf abgebrochen; tatsächlich gab es 0 Aufrufe. Eingang und Ausgang, alle Pfadwerte und JSON-Typen sowie die drei App-Dateihashes stehen im JSON.

Ergebnis: 0/24 Wurzeln, 0/96 Blätter, 4/8 zusätzliche Canonicalpfade exakt erhalten. Farmjahr, Schlag-ID, Schlagfläche und Gesamtfläche bleiben erhalten; Region sowie Kulturkategorie/-name fehlen. Ähnliche Aliase werden nicht als Retention gutgeschrieben. Genau dieser App-Ausgang wurde einmal unverändert mit den Originalpolicy-/Dataverzeichnissen ausgewertet: `data.oepul.o6_12.decision` ist undefiniert, da positive Beteiligungs-/Vertragsprädikate fehlen. Dies ist eine separate Integrationsbeobachtung zusätzlich zu 83 frischen Eingabeproben.

## Reproduzierbarkeit und Prüfgrenzen

OPA 1.18.2 ist fest auf SHA `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8` gebunden. `opa check --strict` besteht. Beide tatsächlichen Policy-/Datenverzeichnisse werden als Verzeichnisse mit unverändertem Namespace geladen. Es gelten strikte Builtinfehler, ein OPA-Limit von 10 s, ein Prozesslimit von 20 s, eine leere Netzfreigabe und blockierte Netzwerk-/Zeit-/Zufalls-/Runtimebuiltins. Die MAIN-Abfrage ist aus dem tatsächlichen Code abgeleitet: `data.oepul.o6_12.decision`; statische Daten bleiben unter `data.o6_12`.

Alle 6052 vorhandenen Objekt-/Array-/Primitivwerte der 83 Proben wurden gegen unverändertes Canonical plus tatsächliche 24 Vorschläge geprüft: genau neun benannte Schema-Stresse, keine unerwartete Abweichung und kein unbekannter Pfad. 695 vorhandene Enumwerte auf 13 Pfaden ergeben ausschließlich die zwei benannten null-Enumstresse. Das prüft vorhandene Werte, keine fehlenden Pflichtfelder, Identität, Vollständigkeit, landwirtschaftliche Wahrheit oder tatsächliche Register-/Behördenbescheide.

Die Sollkomponenten und technischen Erwartungen wurden vor der nativen Ausführung persistiert; Beobachtungen sind keine Sollwertquelle. Historische Selbsttests, manuelle Anpassungstests, private Referenzen und GM-/Domainexpert:innenurteile wurden nicht als Oracle verwendet. Policies, Quellen, Canonical, App, gemeinsame Sammler-/Queue-/QC-Dateien und andere Maßnahmenteile wurden in diesem Teil nicht verändert.

## Metadatenkorrektur nach der unabhängigen Blattprüfung

Ein einzelnes Blatt wurde enger eingeordnet: `oepul.o6_12.payment_application_missing_over_one_year` wird in `contract.rego:92` für den MAIN-Rückforderungsgrund und in `contract.rego:119` für einen separaten Fortbestandshelfer gelesen. Es ist kein eigener aktueller Betrags-/Zugangsschalter. Daher steigt die Zahl der MAIN-Meldungs-/Rückforderungsblätter von 22 auf 23; die 27 Helferblätter bleiben gleich. Alle 83 Eingaben, Queries, Erwartungen und Beobachtungen sind unverändert; eine neue native Ausführung war nicht nötig.

Vorheriger JSON-Freeze: `13950e0e9a209b2e6a628bbcc247f4b9fb49f4be44459cf45f517fb5c52e6990`; vorheriger MD-Freeze: `ec55af3970cf0295c06238b1fefb4168ed351f26f8e21eb515f0413284b1ea3e`. Die unveränderten Proben und Beobachtungen sind gemeinsam auf SHA-256 `e41f31b59ebaf34b8665eaa5222d74746bc6dd1cc0fe6ac758ab64064277cca9` gebunden.
