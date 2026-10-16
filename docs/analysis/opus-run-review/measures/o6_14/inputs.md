# o6_14: Eingabevertrag, Tier-/Almzeitlinien und App-Projektion

Run `v2-o6_14-opus-5.5-high-20260926`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Öffentliche Entwicklungsanalyse ohne Förderfreigabe, Registerbescheinigung oder Genauigkeitsaussage. Inputs-JSON SHA-256: `c9b7c641957b15c572424405c85ba65bc1d04ae7ef032fcaec2509779d55bbdf`.

99 frische Proben umfassen 154 typisierte Einzelprüfungen: 104 erfüllt, 50 nicht erfüllt. 68 native Ergebnisse sind definiert, 31 enden mit Laufzeitfehler. Es gibt kein undefiniertes Ergebnis. Alle 99 persistierten Fälle wurden vollständig erneut abgespielt; Statuswerte, Ausgaben und Fehler sind identisch. Eine zusätzliche exakte App-Ausgabe wird separat nativ ausgewertet und ergibt definiert access_conditions_met=false sowie premium_total_eur=0.

**Die Primitive von `enum(1|2|3)` bleibt offen.** Die offiziellen Formverträge legen für diese unquotierten Tokens keine konkrete JSON-Primitive fest. Native Zahlenkonvention und wörtliche Stringtokens werden getrennt geprüft; 92 passende Repräsentationen werden weder heimlich normalisiert noch als zertifizierte normale Typfehler ausgegeben. Die positiven MAIN-Betragskontrollen sind unter dieser nativen Zahlenkonvention konditional.

## Vollständiger Lesebereich und Quellen

Das neue Merkblatt wurde auf allen 16 Seiten einschließlich Tabellen, Fortsetzungen, Definitionen, Ausnahmen und Aktualisierungen vollständig gelesen: `b7958c79e990c03cc1c0624e1ecd3f1e15c94322d00a2ede794c8e52727ecd43`. Alle acht produktiven Module mit 1.377 Zeilen und alle 17 Annahmen einschließlich offener Rohfragen wurden vollständig gelesen. Tatsächliche MAIN-Abfrage ist `data.oepul.o6_14.decision`; statische Originaldaten bleiben unter `data.o6_14`.

Alle acht tatsächlich gebundenen Originalquellen wurden per SHA-256 geprüft. Sieben geteilte Quellen verwenden dokumentierte vollständige Vorlektüren bei identischem Hash mit erneut geprüften aktuellen Verbraucherklauseln. SRL-PDF 69–72/87 und Anhang A-PDF 3 sowie Anhang E-PDF 10 wurden hier vollständig persönlich gelesen. Die aktuellen gemeinsamen ATB-/SRL-/Anhang 103-Klauseln verwenden zusätzlich die persönlichen vollständigen Seitenlektüren aus 12/13 bei identischem Originalhash und den aktuellen Zitatabgleich. Sämtliche 62 Profilbelege wurden auf der tatsächlichen Seite nach ausschließlich Whitespace-Normalisierung wiedergefunden.

Der Hinweis vom 22. Mai wurde für die tatsächliche Aussage zu fehlender Wasserversorgung auf Almen und zum einzelbetrieblichen Ansuchen erneut gelesen. Ein gestellter Antrag ist kein Anerkennungsbescheid. Die übrigen drei Hinweise liefern keine neue Alm-Ausnahme. GSP-AV und NAPV sind in diesem Paket als Originale nicht geliefert; Erwähnungen in SRL, Merkblatt oder Hinweisen erzeugen keine separat gebundene Rechtsfassung.

## Vollständiger Vorschlagskatalog und Verbraucher

Die vier tatsächlichen `add`-Vorschlagsbäume umfassen 136 Blätter: 131 gelesen, fünf ungelesen. 263 kontextuelle Lesestellen sind dokumentiert. Drei dynamische Vorlagen werden auf 12 tatsächliche Schlüssel geschlossen: vier Düngeverbote, zwei NATA-Geländeeingriffe und sechs AWP-Planinhalte. Die Datenzeile `s.species` aus dem statischen RGVE-Schlüssel wird nicht als Aufenthalts-Eingabe gezählt.

14 gelesene Blätter wirken ausschließlich in separaten Helfern; 51 erreichen MAIN-Meldungen ohne eigenen aktuellen Betragsschalter. 66 gelesene Blätter wirken bedingt auf MAIN-Vertrag, Nachweise, Fläche oder Betrag. Die beiden weiteren tatsächlich gelesenen Pfade gehören zum unveränderten Canonical; es gibt keinen unvorgeschlagenen nativen Zusatzpfad.

| Nr. | Tatsächlicher Vorschlagspfad | Blätter | gelesen / ungelesen |
|---:|---|---:|---:|
| 1 | `alpine_farming` | 130 | 125 / 5 |
| 2 | `farm.applicant` | 3 | 3 / 0 |
| 3 | `farm.oepul` | 2 | 2 / 0 |
| 4 | `land.protected_cultivation_area_ha` | 1 | 1 / 0 |

Jedes Blatt hat im JSON seinen tatsächlichen Deskriptor, Einheit, Bedeutung, bedingten Tier-/Alm-/Jahres-/Ereigniskontext, Missing-/Nullabgrenzung, tatsächliche Defaults, sämtliche Lesestellen, Quellenbelege und App-Retention. Die folgende vollständige 136-Zeilen-Liste fasst Typ und Wirkungsscope zusammen.

| Blatt | tatsächlicher Deskriptor | Scope | Lesestellen |
|---|---|---|---|
| `alpine_farming.is_alm_manager` | `boolean` | bedingter MAIN-Nachweis/Betrag | participation.rego:88 |
| `alpine_farming.measure.applied` | `boolean` | bedingter MAIN-Nachweis/Betrag | general.rego:27, participation.rego:22 |
| `alpine_farming.measure.application_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | participation.rego:23 |
| `alpine_farming.measure.commitment_start_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | participation.rego:5 |
| `alpine_farming.measure.payment_claim_missing` | `boolean` | ausschließlich separater Helfer | general.rego:76 |
| `alpine_farming.measure.payment_claim_missing_over_one_year` | `boolean` | ausschließlich separater Helfer | general.rego:77, general.rego:80 |
| `alpine_farming.nature_conservation_supplement.applied` | `boolean` | bedingter MAIN-Nachweis/Betrag | common.rego:63 |
| `alpine_farming.nature_conservation_supplement.application_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | participation.rego:149 |
| `alpine_farming.nature_conservation_supplement.commitment_start_year` | `int\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | participation.rego:141, participation.rego:148 |
| `alpine_farming.nature_conservation_supplement.course.completed` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:80 |
| `alpine_farming.nature_conservation_supplement.course.hours` | `number\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:81 |
| `alpine_farming.nature_conservation_supplement.course.completion_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:82, supplements.rego:83 |
| `alpine_farming.nature_conservation_supplement.course.provider_recognized` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:84 |
| `alpine_farming.nature_conservation_supplement.course.content_nature_conservation_related` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:85 |
| `alpine_farming.nature_conservation_supplement.course.attendee_role` | `enum(alm_manager\|herder\|significantly_involved_person\|other)` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:86 |
| `alpine_farming.nature_conservation_supplement.course.credited_to_other_farm` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:87 |
| `alpine_farming.nature_conservation_supplement.course.double_counted` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:88 |
| `alpine_farming.nature_conservation_supplement.course.trained_person_left_date_known` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:93 |
| `alpine_farming.nature_conservation_supplement.course.trained_person_left_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:94 |
| `alpine_farming.nature_conservation_supplement.course.replacement_course_completed` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:95 |
| `alpine_farming.grazing_plan_supplement.applied` | `boolean` | bedingter MAIN-Nachweis/Betrag | common.rego:65 |
| `alpine_farming.grazing_plan_supplement.application_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | participation.rego:163 |
| `alpine_farming.grazing_plan_supplement.first_application_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | participation.rego:155, participation.rego:162, supplements.rego:120 |
| `alpine_farming.grazing_plan_supplement.deregistered` | `boolean` | ausschließlich separater Helfer | supplements.rego:190 |
| `alpine_farming.grazing_plan_supplement.takeover_context` | `enum(farm_dissolution\|farm_division\|farm_merger\|other\|null)` | ungelesen | — |
| `alpine_farming.grazing_plan_supplement.course.completed` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:123 |
| `alpine_farming.grazing_plan_supplement.course.hours` | `number\|null` | bedingter MAIN-Nachweis/Betrag | supplements.rego:124 |
| `alpine_farming.grazing_plan_supplement.course.completion_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | supplements.rego:125, supplements.rego:126 |
| `alpine_farming.grazing_plan_supplement.course.provider_recognized` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:127 |
| `alpine_farming.grazing_plan_supplement.course.covers_required_topics` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:128 |
| `alpine_farming.grazing_plan_supplement.course.attendee_role` | `enum(farm_manager\|alm_manager\|significantly_involved_person\|other)` | bedingter MAIN-Nachweis/Betrag | supplements.rego:129 |
| `alpine_farming.grazing_plan_supplement.course.credited_to_other_farm` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:130 |
| `alpine_farming.grazing_plan_supplement.course.double_counted` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:131 |
| `alpine_farming.grazing_plan_supplement.plan.created_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | supplements.rego:151, supplements.rego:157, supplements.rego:158 |
| `alpine_farming.grazing_plan_supplement.plan.covers_all_alms` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:165 |
| `alpine_farming.grazing_plan_supplement.plan.assessment_site_yield` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:165 |
| `alpine_farming.grazing_plan_supplement.plan.assessment_ecological_value` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:165 |
| `alpine_farming.grazing_plan_supplement.plan.development_goals_and_management_needs` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:165 |
| `alpine_farming.grazing_plan_supplement.plan.grazing_and_steering_measures_per_plot` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:165 |
| `alpine_farming.grazing_plan_supplement.plan.created_with_or_communicated_to_involved_persons` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:165 |
| `alpine_farming.grazing_plan_supplement.plan.annual_review_documented` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:172 |
| `alpine_farming.takeover.is_takeover` | `boolean` | bedingter MAIN-Nachweis/Betrag | participation.rego:35 |
| `alpine_farming.takeover.submission_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | participation.rego:36 |
| `alpine_farming.takeover.previously_participating` | `boolean` | bedingter MAIN-Nachweis/Betrag | participation.rego:37 |
| `alpine_farming.takeover.expansion_share` | `number\|null` | bedingter MAIN-Nachweis/Betrag | participation.rego:38 |
| `alpine_farming.takeover.approved_by_ama` | `boolean` | bedingter MAIN-Nachweis/Betrag | participation.rego:39 |
| `alpine_farming.exit.exited` | `boolean` | ausschließlich separater Helfer | general.rego:62 |
| `alpine_farming.exit.exit_date` | `date\|null` | ausschließlich separater Helfer | general.rego:63 |
| `alpine_farming.exit.reason` | `enum(voluntary\|loss_of_control\|revision_clause\|force_majeure\|permanent_circumstance_reported\|null)` | ausschließlich separater Helfer | general.rego:64 |
| `alpine_farming.exit.operator_change` | `boolean` | ausschließlich separater Helfer | general.rego:68 |
| `alpine_farming.circumstance.type` | `enum(permanent\|temporary\|null)` | ausschließlich separater Helfer | general.rego:89, general.rego:96 |
| `alpine_farming.circumstance.reported` | `boolean` | ausschließlich separater Helfer | general.rego:90, general.rego:97 |
| `alpine_farming.circumstance.occurrence_date` | `date\|null` | ausschließlich separater Helfer | general.rego:92 |
| `alpine_farming.circumstance.force_majeure` | `boolean` | ausschließlich separater Helfer | general.rego:98 |
| `alpine_farming.circumstance.drought_prevents_compliance` | `boolean` | ausschließlich separater Helfer | general.rego:105 |
| `alpine_farming.circumstance.force_majeure_application_submitted` | `boolean` | ausschließlich separater Helfer | general.rego:110 |
| `alpine_farming.sanction_history.full_reductions_in_contract_period` | `int` | ausschließlich separater Helfer | general.rego:158 |
| `alpine_farming.control.refused` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | general.rego:160 |
| `alpine_farming.alms[].alm_id` | `string` | bedingter MAIN-Nachweis/Betrag | common.rego:69, obligations.rego:70, obligations.rego:76, obligations.rego:83, obligations.rego:95, obligations.rego:107, obligations.rego:123, obligations.rego:166, participation.rego:177, participation.rego:181, participation.rego:183, participation.rego:193, participation.rego:201, participation.rego:218, participation.rego:226, supplements.rego:23, supplements.rego:30, supplements.rego:38, supplements.rego:46, supplements.rego:54, supplements.rego:61, supplements.rego:69, supplements.rego:182 |
| `alpine_farming.alms[].in_alm_cadastre_or_alm_area` | `boolean` | bedingter MAIN-Nachweis/Betrag | premium.rego:52 |
| `alpine_farming.alms[].managed_from_home_farm` | `boolean` | bedingter MAIN-Nachweis/Betrag | premium.rego:53 |
| `alpine_farming.alms[].boundary_or_management_difference_visible` | `boolean` | bedingter MAIN-Nachweis/Betrag | premium.rego:54 |
| `alpine_farming.alms[].alm_pasture_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | participation.rego:68, premium.rego:74, stocking.rego:20 |
| `alpine_farming.alms[].foreign_adjacent_area_ha` | `number\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | stocking.rego:16 |
| `alpine_farming.alms[].foreign_area_report_submitted` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | stocking.rego:16, stocking.rego:18 |
| `alpine_farming.alms[].national_park` | `enum(none\|kalkalpen\|neusiedlersee\|donau_auen\|other)` | bedingter MAIN-Nachweis/Betrag | premium.rego:45 |
| `alpine_farming.alms[].access_level` | `enum(1\|2\|3)` | bedingter MAIN-Nachweis/Betrag | premium.rego:31 |
| `alpine_farming.alms[].access_units[].unit_id` | `string` | ungelesen | — |
| `alpine_farming.alms[].access_units[].access_level` | `enum(1\|2\|3)` | bedingter MAIN-Nachweis/Betrag | premium.rego:17, premium.rego:27 |
| `alpine_farming.alms[].access_units[].alp_days` | `number` | bedingter MAIN-Nachweis/Betrag | premium.rego:15, premium.rego:17 |
| `alpine_farming.alms[].access_units[].drive_period_days` | `int` | bedingter MAIN-Nachweis/Betrag | premium.rego:26, premium.rego:27 |
| `alpine_farming.alms[].access_times_comparable` | `boolean` | bedingter MAIN-Nachweis/Betrag | premium.rego:14, premium.rego:25 |
| `alpine_farming.alms[].is_own_alm` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:100 |
| `alpine_farming.alms[].adjacent_to_home_farm` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:51 |
| `alpine_farming.alms[].field_list_submission_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | participation.rego:175, participation.rego:176 |
| `alpine_farming.alms[].drive_up_list_submission_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | participation.rego:192, participation.rego:199, participation.rego:200 |
| `alpine_farming.alms[].nata_coding_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | participation.rego:216, participation.rego:217 |
| `alpine_farming.alms[].plots[].plot_id` | `string` | bedingter MAIN-Nachweis/Betrag | general.rego:21, obligations.rego:146, participation.rego:210 |
| `alpine_farming.alms[].plots[].codes[]` | `string` | bedingter MAIN-Nachweis/Betrag | obligations.rego:149, participation.rego:209 |
| `alpine_farming.alms[].plots[].project_confirmation` | `boolean` | bedingter MAIN-Nachweis/Betrag | supplements.rego:11 |
| `alpine_farming.alms[].plots[].area_wide_psm_types[]` | `enum(organic\|chemical_synthetic)` | bedingter MAIN-Nachweis/Betrag | obligations.rego:142 |
| `alpine_farming.alms[].plots[].other_area_measures[]` | `string` | bedingter MAIN-Nachweis/Betrag | general.rego:19 |
| `alpine_farming.alms[].feeding.basic_fodder_supplementation` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:69 |
| `alpine_farming.alms[].feeding.compensatory_feeding` | `boolean` | ungelesen | — |
| `alpine_farming.alms[].feeding.silage_fed` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:81, obligations.rego:110 |
| `alpine_farming.alms[].feeding.silage_alm_own` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:88 |
| `alpine_farming.alms[].feeding.silage_produced` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:112 |
| `alpine_farming.alms[].feeding.silage_stored` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:114 |
| `alpine_farming.alms[].feeding.alm_silage_moved_to_home_farm` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:94 |
| `alpine_farming.alms[].feeding.alm_foreign_green_fodder_fed` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:75 |
| `alpine_farming.alms[].plant_protection.non_organic_psm_used` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:122 |
| `alpine_farming.alms[].fertilisation.non_organic_fertiliser_used` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:165 |
| `alpine_farming.alms[].fertilisation.alm_foreign_slurry_applied` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:165 |
| `alpine_farming.alms[].fertilisation.sewage_sludge_applied` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:165 |
| `alpine_farming.alms[].fertilisation.home_farm_separated_slurry_solids_applied` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:165 |
| `alpine_farming.alms[].fertilisation.home_farm_manure_applied` | `boolean` | ungelesen | — |
| `alpine_farming.alms[].nature_conservation.participates` | `boolean` | bedingter MAIN-Nachweis/Betrag | stocking.rego:37 |
| `alpine_farming.alms[].nature_conservation.project_requirements_met` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:29 |
| `alpine_farming.alms[].nature_conservation.fertilised_habitats[]` | `enum(moor\|wetland\|calcareous_grassland\|siliceous_grassland\|nardus_grassland\|other)` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:36 |
| `alpine_farming.alms[].nature_conservation.terrain_correction` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:45 |
| `alpine_farming.alms[].nature_conservation.new_drainage` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:45 |
| `alpine_farming.alms[].nature_conservation.drainage_upgraded` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:52 |
| `alpine_farming.alms[].nature_conservation.drainage_upgrade_consent` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:53 |
| `alpine_farming.alms[].nature_conservation.watering_point_in_wetland_or_spring` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | supplements.rego:60 |
| `alpine_farming.alms[].nature_conservation.measures[].code` | `enum(NAW1\|NAW2\|NAW3\|NAD1\|NAD2\|NAD3\|NAB1\|NAB2\|NAB3)` | bedingter MAIN-Nachweis/Betrag | premium.rego:111, supplements.rego:68, supplements.rego:69 |
| `alpine_farming.alms[].nature_conservation.measures[].affected_share_pct` | `number\|null` | ungelesen | — |
| `alpine_farming.alms[].grazing_plan.increased_intensity_applied` | `boolean` | bedingter MAIN-Nachweis/Betrag | stocking.rego:31, supplements.rego:180 |
| `alpine_farming.alms[].grazing_plan.increased_intensity_justified_in_plan` | `boolean` | bedingter MAIN-Nachweis/Betrag | stocking.rego:32, supplements.rego:181 |
| `alpine_farming.alms[].grazing_plan.increased_intensity_declared_in_drive_up_list` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | participation.rego:225 |
| `alpine_farming.animals[].animal_id` | `string` | bedingter MAIN-Nachweis/Betrag | common.rego:74 |
| `alpine_farming.animals[].species` | `enum(cattle\|sheep\|goat\|equine\|new_world_camelid\|other)` | bedingter MAIN-Nachweis/Betrag | animals.rego:12, animals.rego:15, animals.rego:20, animals.rego:24, animals.rego:26, animals.rego:41, animals.rego:95, animals.rego:175, general.rego:37, general.rego:48, obligations.rego:173, obligations.rego:183, obligations.rego:204, obligations.rego:210, obligations.rego:217 |
| `alpine_farming.animals[].breed` | `string\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:16, animals.rego:28 |
| `alpine_farming.animals[].equine_size_class` | `enum(small\|large\|null)` | bedingter MAIN-Nachweis/Betrag | animals.rego:24 |
| `alpine_farming.animals[].birth_date` | `date` | bedingter MAIN-Nachweis/Betrag | animals.rego:30, animals.rego:36 |
| `alpine_farming.animals[].rgve_category_id` | `string\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:56, animals.rego:59 |
| `alpine_farming.animals[].count` | `int` | bedingter MAIN-Nachweis/Betrag | animals.rego:69 |
| `alpine_farming.animals[].ear_tag` | `string\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:211 |
| `alpine_farming.animals[].presence_compliant` | `boolean` | bedingter MAIN-Nachweis/Betrag | animals.rego:128 |
| `alpine_farming.animals[].non_compliance_reported` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:43 |
| `alpine_farming.animals[].home_stable_only_for_milking` | `boolean\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:49 |
| `alpine_farming.animals[].in_tierwohl_weide_or_rare_breeds` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:219 |
| `alpine_farming.animals[].sold_without_drive_down` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:218 |
| `alpine_farming.animals[].new_drive_up_report_with_new_home_farm` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:220 |
| `alpine_farming.animals[].stays[].alm_id` | `string` | bedingter MAIN-Nachweis/Betrag | animals.rego:147, animals.rego:158, animals.rego:169, animals.rego:178, obligations.rego:51 |
| `alpine_farming.animals[].stays[].in_austria` | `boolean` | bedingter MAIN-Nachweis/Betrag | animals.rego:87 |
| `alpine_farming.animals[].stays[].drive_up_date` | `date` | bedingter MAIN-Nachweis/Betrag | animals.rego:85, animals.rego:88, animals.rego:92, animals.rego:95, animals.rego:112, animals.rego:171, obligations.rego:177 |
| `alpine_farming.animals[].stays[].drive_down_date` | `date` | bedingter MAIN-Nachweis/Betrag | animals.rego:86, animals.rego:88, animals.rego:92, animals.rego:97, animals.rego:171, obligations.rego:195, obligations.rego:205 |
| `alpine_farming.animals[].stays[].drive_up_report_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:95, animals.rego:97, animals.rego:99, obligations.rego:176, obligations.rego:177 |
| `alpine_farming.animals[].stays[].drive_down_report_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:194, obligations.rego:195, obligations.rego:200 |
| `alpine_farming.animals[].stays[].planned_drive_down_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:205 |
| `farm.applicant.legal_form` | `enum(natural_person\|registered_partnership\|legal_person\|association_of_persons\|public_body)` | bedingter MAIN-Nachweis/Betrag | participation.rego:55, participation.rego:61 |
| `farm.applicant.public_body_share_pct` | `number\|null` | bedingter MAIN-Nachweis/Betrag | participation.rego:63 |
| `farm.applicant.is_active_farmer` | `boolean` | bedingter MAIN-Nachweis/Betrag | participation.rego:103 |
| `farm.oepul.first_oepul_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | participation.rego:81 |
| `farm.oepul.participating_measures[]` | `string` | MAIN-Meldung, kein eigener aktueller Betragsschalter | common.rego:20 |
| `land.protected_cultivation_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | participation.rego:83 |

Ungelesen bleiben `grazing_plan_supplement.takeover_context`, `alms[].access_units[].unit_id`, `feeding.compensatory_feeding`, `fertilisation.home_farm_manure_applied` und `nature_conservation.measures[].affected_share_pct` unter den jeweiligen vollständigen JSON-Pfaden. Zulässige Ausgleichsfütterung und Heimbetriebsmist sind dadurch keine erfundenen fehlenden Verbote. Der NATA-Code wird aus dem angegebenen Flächenanteil nicht rekonstruiert; eine separate Argumentfunktion ist kein Verbraucher des vorgeschlagenen Anteilsfeldes.

| Weiterer Canonicalpfad | tatsächliche Verwendung | App exakt erhalten |
|---|---|---|
| `farm.year` | Integer currentapplicationyear useddeadlines,Julyage,dateclassification,rates andoriginalcontractrelationships. No current-year clip ofallrawstays credited. | ja |
| `land.total_area_ha` | Actual whole-holdingagriculturalhectares usedonlyfirstPROGRAMminimumalternative. Alm14modulation insteadusesperAlmcomputedpremiumareas, notthisaggregate. | ja |

Die 14 Helferblätter betreffen Exit/Rückforderung, besondere Umstände/höhere Gewalt, fehlende Zahlungsclaimhistorie, AWP-Fortbestand im nächsten Jahr und die Historie zweier Vollkürzungen. Der gesamte aktuelle Sanktions-/Rückforderungsanspruch wird nicht aus diesen Helfern in die MAIN-Zahlenrechnung integriert. Die Liste `farm.oepul.participating_measures[]` erreicht aktuell ausschließlich Heuwirtschaft-/Behirtungs-Verstoß-, Kombinations- und Fristmeldungen; der separate Stallhaltungshelfer liest diese Liste gar nicht.

## Quellenkomponenten und konsistente technische Basen

Neun Quellenkomponenten prüfen sechs Prämiensätze für 2023/2025 und Stufen 1/2/3, die 60-Tage-Datumsdifferenz, den Faktor 1,00 für ein bekanntes erwachsenes Nicht-Zwergrind und den NAW2-Satz 8,60. Alle neun werden erfüllt. Die Sollzahlen stammen aus Originaltabellen bzw. der ausdrücklich beschriebenen Tageszählung und wurden vor Ausführung festgelegt. Ein numerisches Funktionsargument für eine benannte Quellenstufe zertifiziert nicht die ungeklärte konkrete Eingabeprimitive.

Die gewöhnliche technische MAIN-Basis enthält eine bekannte 3 ha-Alm in Österreich und drei unterschiedliche erwachsene Nicht-Zwergrinder mit count 1 je individueller Zeile. Art, tatsächliches Geburtsdatum, bekannte Rasse, Anwesenheit, Almdefinition, Antragsdaten sowie Auf-/Abtriebs- und Meldedaten sind positiv angegeben. Auftrieb 1. Juni bis Abtrieb 31. Juli ergibt 60 tatsächliche und angerechnete Tage; der Abtriebstag zählt nicht. Die optionale RGVE-Kategorie ist in der Ableitungsbasis absent; sie wird nicht still aus null konvertiert.

Unter der ausdrücklich konditionalen nativen Zahlenstufen-Konvention ergeben sich 129,60/194,40/259,20 EUR für Stufe 1/2/3 und 120 EUR im 2023-Fall. Der NATA-Fall mit stipulierten positiven Projekt-/Kursbelegen ergibt 159,60 EUR, der AWP-Fall 189,60 EUR. Das sind keine tatsächlich registerbestätigten Tiere, genehmigten Betriebe oder Kurs-/Projektzertifikate. Normale Rinder-/Schaf-/Ziegenbeispiele werden individuell mit count 1 geführt; strukturtypisch erlaubte widersprüchliche Gruppen-/Identitätswerte sind technische Stresse.

Die Mengen sind getrennt: tatsächliche körperliche Tage, nach Meldedatum angerechnete Tage, je Alm vereinigte Belegungstage, RGVE, RGVE×Tage als freie Access-Gewichte und reine Kalenderperioden. Der kohärente gewichtete Access-Fall teilt drei RGVE × 60 Tage = 180 RGVE-Tage in 90+90 auf zwei 30-Tage-Einheiten. Er behauptet keinen vorhandenen Tier-/Einheitenregisterabgleich. Auslandsflächen entlasten ausschließlich den Besatz unter positivem jährlichem Nachweis; sie werden nicht als österreichische Prämienfläche behandelt.

Die Gruppen sind getrennt gekennzeichnet: neun Quellenkomponenten, 61 technische Kontrollen, 17 gewünschte Positivnachweisgrenzen und zwölf ausdrücklich außerhalb des unstrittigen Schemas liegende Stresse. Alle 99 Fälle sind öffentliche gezielte Entwicklungsproben; keine Genauigkeits- oder private Expert:innenreferenz.

## Numerische Enumprimitive bleibt ausdrücklich ungeklärt

Die Prüfung ging über unseren Hilfsparser hinaus: AGENTS fordert dieselbe JSON-Notation wie der Canonical-Blueprint; `ProfileChange.value_after` ist in `src/rulelab/contracts.py:152` ein beliebiger `JsonValue`, das exportierte Schema enthält `"JsonValue": {}`. `apply_profile_changes` prüft Pfade, Überlappung und Before-Werte und kopiert die Deskriptorwerte; es interpretiert deren Enumprimitive nicht. Der technische OPA-Validator prüft Rego, kein konkretes Farm-Eingabeschema. Diese technischen Dateibelege sind keine zusätzlichen juristischen PDF-Quellen.

Der tatsächliche Code vergleicht Stufen mit numerischen Datentabellen und multipliziert `u.access_level * u.alp_days`. Deshalb werden beide Darstellungen getrennt ausgewertet: String `"1"` an der Alm bleibt definiert, ergibt aber 0 EUR; zwei Stringstufen im gewichteten Fall abortieren an der Multiplikation. Zahlen 1/2/3 ergeben die beschriebenen konditionalen Berechnungen. Ohne offizielle Primitivefestlegung wird keine Lesart als normale vollständige Typzertifizierung ausgegeben. Null und unknown gehören dagegen zu keiner der beiden zulässigen Tokenlesarten und bleiben ausdrücklich benannte Stresse.

## Null, Missing, Identität und Zeitlinien

| Befundklasse | Anzahl | tatsächliche Abgrenzung |
|---|---:|---|
| Gültiges Nullable in MAIN, Laufzeitfehler | 17 | ausgewählte Haupt-/NATA-/AWP-/Übernahmedaten sowie Meldedaten und positiv ausgewählte Auslandsfläche |
| Gültiges Nullable nur im separaten Helfer | 2 | Exitdatum und Zeitpunkt eines permanenten Umstands; identische Payloads haben MAIN 129,60 |
| Missing→nativer Null-Default | 1 | fehlendes ursprüngliches Startjahr wird zu null und dann subtrahiert |
| Strukturell erlaubter Identitätskonflikt | 2 | widersprüchliche gleiche Tier-ID bzw. Alm-ID lösen Objektkonflikte aus |
| Ausdrücklich außerhalb des Schemas | 8 | nichtnullable Zahlen/Daten, zwei Objekt-null und ungültiges Kalenderdatum |
| Offene Enumprimitive | 1 | Stringstufen im gewichteten Rechenpfad, kein zertifizierter normaler Typfehlergold |
| Undefiniert | 0 | von Laufzeitabbruch und definiertem negativen Ergebnis getrennt |

Alle 31 Fehler sind im JSON mit vollständigem Eingabepfad, Schema-/Nullklasse, tatsächlich gewähltem Ereigniskontext, MAIN-/Helferscope, Query und nativer Meldung einzeln belegt. Es gibt 29 MAIN-Abbrüche und zwei separate Helferabbrüche. Ein nur meldender Eingabepfad kann durch einen Parserfehler trotzdem die gesamte MAIN-Verfügbarkeit abbrechen; das macht ihn noch nicht zum fachlichen aktuellen Betragsschalter.

Direkte Null-Wahrheit in Rego ist entscheidend: `rgve_category_id=null` wird als vorhandener Override gewählt und verhindert die sonst mögliche Ableitung aus bekannter Art, Alter und Rasse. Drei so positiv klassifizierbare Tiere ergeben 0 statt 3 RGVE und 0 statt 129,60 EUR. Das ist kein Fall einer noch unbekannten Tierart und kein Laufzeitfehler. Absent bzw. explizit korrekte Kategorie ergeben 3 RGVE. Diese Familie überschneidet sich mit dem Domainbefund und wird als eigener Eingabevertragsnachweis gezählt, nicht als unabhängige zusätzliche Schadensschätzung.

Ein fehlender Auftriebsbericht gibt 0 angerechnete Tage; null erreicht dagegen den strikten Datumsparser. Entsprechende Paare unterscheiden beim AWP-Plan fehlendes Datum von wahrheitsfähigem null. Ein null-Auftriebslisten-Datum ist bei bekannter reiner Rinderalm/Stufe 1 ohne Behirtung/2,4 AWP tatsächlich unnötig; der ausgewählte Gegenfall mit einer individuellen Ziege im Folgejahr erreicht den Parser. Unbenötigte Auslandsfläche=null bleibt sicher, wenn kein Auslandsentlastungsnachweis ausgewählt ist.

Unbekannte erforderliche Nachweise geben keine fachliche Wahrheit her. Fehlender öffentlicher Anteil, aktive Landwirtschaft, Anwesenheit und Österreichbezug können günstig bleiben; fehlende Almdefinition, Rechtsform oder Managerangabe sperren dagegen tatsächlich. Ein unbekanntes erstes PROGRAMJahr bei unabhängig positiv erfüllter 3 ha-Mindestfläche ist ein sicherer Alternativnachweisfall und kein erfundener Flächenverstoß. Ohrmarke missing/null wird getrennt am bekannten individuellen Ziegendatensatz geprüft; die gewünschte Nachweismeldung ist keine Behauptung tatsächlich fehlender Tierkennzeichnung oder eine gewählte Vollsanktion.

Offene Referenz-/Zeitkonsistenzgrenzen bleiben ebenfalls sichtbar: unbekannte Aufenthalts-Alm-ID kann die Mindestteilnahme erhöhen; identische überlappende 39-Tage-Zeilen zählen pro Tier 78 Tage; vorjährige Aufenthalte können im aktuellen Jahr angerechnet werden. Ein bekannt zukünftiger Vertragsbeginn kann bereits eine frühere Jahresberechnung passieren. Diese Kontrollen wählen keinen tatsächlichen Register-/Flächensachverhalt aus widersprüchlichen Eingaben.

## Meldungen, Rückforderungen und Betragspotenzial

Der Raw-Vertrag A04 kennzeichnet `premium_total` als Betrag vor inhaltlichen Kürzungen. Diese Zahl ist keine genehmigte Nettoauszahlung. Aus lokalen Besatz-/Fütterungs-/PSM-/Dünge-/Dokumentationsmeldungen wird keine frei gewählte 100%-Sanktion abgeleitet. MAIN zeigt Kontrollverweigerung als Boolean; Claimhistorie, Exit, Ausnahmeumstände und Vollkürzungshistorie wirken überwiegend nur in separaten Helfern. Das ist eine Grenze zwischen Zahlenpotenzial und Zahlungs-/Rückforderungsfreigabe.

NATA-Kurs-/Antrags-/Codierungs-/Bewirtschaftungsbefunde können ausschließlich melden; Projektbestätigung für alle vorhandenen Plots wirkt hingegen tatsächlich auf den NATA-Betrag. AWP-Kurs- und Planpflichten sperren bei Verletzung tatsächlich dessen Zuschlag; die vollständige Entziehung ist als Raw-Annahme A10 gekennzeichnet. Der fehlende NATA-Flächenanteilverbrauch darf nicht als tatsächlich geprüfte Code-/Projektbindung dargestellt werden.

## Tatsächlich ausgeführte App-Projektion und Reproduzierbarkeit

Die unveränderte reine Funktion `adapt_payload_for_measures` wurde auf Appcommit `529eadb34c4fdd249fbf739a372d63185b7374a2` mit einem strukturellen Verbund der vier Vorschlagsbäume ausgeführt. Der Verbund ist kein behaupteter realer Betrieb mit allen Ereignissen. Er erhält die lexikalischen Blueprint-Tokens und enthält keine heimliche Enumkonvertierung. `CursorWrapper.execute` war durch einen sofort abbrechenden SQL-Guard geschützt: 0 Aufrufe. Vollständige Eingabe/Ausgabe, Typen/Werte, Wurzel-/Blattretention und drei App-Dateihashes sind dokumentiert.

Ergebnis: 0/4 Vorschlagswurzeln, 0/136 Blätter, 2/2 weitere Canonicalpfade exakt erhalten. Genau die tatsächliche App-Ausgabe wurde einmal unverändert im Originalrun ausgewertet: definiert, access_conditions_met=false und premium_total_eur=0. Diese separate Integrationsbeobachtung kommt zusätzlich zu den 99 frischen Proben. Keine Retentions-, Fehler- oder undefined-Zahl aus 13 wurde übernommen.

Vor der ersten nativen Ausführung wurden vorhandene Werte/Enums geprüft. Nach der gezielten Ergänzung der Ohrmarkenpaarung und des sicheren PROGRAM-Jahr-null-Falls wurden diese drei neuen Fälle ebenfalls zuerst persistiert und typgeprüft; die ursprünglichen 96 Fälle blieben unverändert. Danach wurden alle 99 Fälle vollständig erneut abgespielt. Statuswerte, Ausgaben und Fehler stimmen mit sämtlichen ersten Beobachtungen überein; Inputs, Queries oder Erwartungen wurden nicht aus Beobachtungen zum Oracle umgeschrieben.

Festes OPA 1.18.2 mit SHA `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`; `opa check --strict` besteht. Originalpolicy-/Dataverzeichnisse werden als Verzeichnisse mit intaktem Namespace geladen, strikte Builtinfehler, 10 s OPA-/20 s Prozesslimit, leere Netzfreigabe und blockierte Netzwerk-/Zeit-/Zufalls-/Runtimebuiltins.

Vorhandene Werte: 13.207 entschiedene Objekt-/Array-/Primitivprüfungen, ausschließlich zwölf benannte Schema-Stresswerte, kein unbekannter Pfad oder unerwarteter unstrittiger Typfehler. 92 passende Zahlen-/Stringvorkommen der beiden numerischen Enumpfade bleiben ausdrücklich unzertifiziert. 553 explizite Enumwerte enthalten dieselben 92 offenen Vorkommen und nur drei benannte Outside-Stresse: Tierart=null, Stufe=null und unknown. Dies prüft vorhandene Formen, keine Pflichtfeldvollständigkeit, Identität, Tatsachen- oder Registerwahrheit.

Beim letzten eigenen Callgraph-Abgleich wurde ausschließlich die Scope-Metadatenklasse von `farm.oepul.participating_measures[]` enger eingeordnet: 51 statt 50 MAIN-Meldungsblätter, 66 statt 67 bedingte MAIN-Blätter. Alle 99 Inputs, Queries, Erwartungen und Beobachtungen bleiben unverändert. Der transparente Metadatenbeleg erhält den vorherigen noch ungefrorenen JSON-Hash sowie die gemeinsame unveränderte Fall-/Beobachtungsbindung.

Historische Selbsttests, manuelle Anpassungstests, private Referenzen und GM-/Domainexpert:innenurteile wurden nicht als Oracle verwendet. Policies, Quellen, Canonical, App, gemeinsame Sammler-/Queue-/QC-Dateien und andere Maßnahmenteile wurden nicht geändert.
