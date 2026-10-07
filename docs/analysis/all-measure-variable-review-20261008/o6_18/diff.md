# o6_18: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_18-luna-high-20261005`

55 Vorschläge; Blattpfade: {'added': 55, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `application.access_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `application.added_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `application.additional_grazing_fertilization` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.automatic_drought_exception` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.base_2025_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `application.biodiversity_use_count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `application.codes[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `application.comparable_second_cut` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.deadline` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `application.div_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `application.div_credit` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.drought_no_harvestable_stock` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.early_arable_biodiversity_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.early_grassland_biodiversity_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.grassland_resowing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.grassland_resowing_written_approval` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.grassland_uses_per_year` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `application.grazing_required` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.great_bustard_monitoring` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.has_managed_parcel` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.management_changed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.measure` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `application.nat_code` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.nat_fallow_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `application.nature_reference_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.naturschutz_date_exception` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.obligations_full_period` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.op_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `application.other_measure_on_same_parcel` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `application.phenology_monitoring` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.prohibited_interventions` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.project_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.project_confirmation_amended` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.regional_goals_and_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.regional_participation_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.regional_plan` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.regional_plan_surcharge_count` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `application.sludge_or_sludge_compost_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.start_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `application.submission_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `application.switch_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `application.ubb_or_bio` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.use_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `application.use_or_care_within_two_years` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `application.violation_assessed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.grazing_diary_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.region.country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].div_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].field_piece_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].gloez4_or_gloez8_part` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].harvested_percent` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].is_mown_pasture` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz_codes[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].project_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_18-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_18-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_18-opus-5.5-high-20260927`

30 Vorschläge; Blattpfade: {'added': 112, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.oepul.applicant.public_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.applicant.type` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.oepul.first_oepul_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.access_requirements_failed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.area_2025_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.area_lost_disposal_right_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.area_permitted_conversion_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.area_previous_year_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.excluded` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.event_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.exit_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.exited` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.force_majeure_recognised` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.on_site_control_announced_before_exit` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.permanent_circumstance` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.reported_in_time` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.exit.revision_clause_refusal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.hundred_percent_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.mfa_not_submitted_previous_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.on_site_control_objection` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.operator_change` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.payment_claim_missed_since_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.payment_notice_received` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.previously_committed_added_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.refusal_force_majeure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.refused_on_site_control` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.regional_plan.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.regional_plan.applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.regional_plan.deregistered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.regional_plan.granted_via_ebw` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.regional_plan.participation_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.switch_to_ebw.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.switch_to_ebw.switch_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.takeover.date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.takeover.expansion_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.takeover.includes_regional_plan` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.takeover.reason` | added | nicht vorhanden | `"enum(betriebsaufloesung&#124;betriebsteilung&#124;betriebszusammenlegung&#124;other)&#124;null"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.takeover.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.naturschutz.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.protected_cultivation_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.ubb_bio_monitoring_options[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.ackerzahl` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.deposits` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.drainage_maintenance` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.fill_up` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.mechanical_stone_removal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.new_drainage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.reseeding.performed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.reseeding.reason` | added | nicht vorhanden | `"enum(wildschaden&#124;engerlingsbefall&#124;murenabgang&#124;anderes_ereignis&#124;other)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.reseeding.written_approval` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.silage_bale_storage` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.terrain_correction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.activities.trench_milling` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.applied_for_measure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.driven_on_before_first_cut` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.drought_div_exception_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.drought_no_harvestable_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.fertilization_events[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.fertilization_events[].type` | added | nicht vorhanden | `"enum(festmist&#124;kompostierter_festmist&#124;kompost&#124;guelle&#124;jauche&#124;mistwasser&#124;mineral&#124;kalk&#124;urgesteinsmehl&#124;klaerschlamm&#124;klaerschlammkompost&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.gg_exception_justified` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grassland_type` | added | nicht vorhanden | `"enum(maehwiese&#124;maehweide&#124;weide&#124;hutweide&#124;streuwiese&#124;bergmahd&#124;other)&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_diary.combined_with_other_plots` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_diary.daily_current` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_diary.kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_diary.same_management_and_visible_unit` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_periods[].animals[].annex_a_key` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_periods[].animals[].count` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_periods[].end` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.grazing_periods[].start` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.habitat_layer_registered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.harvest_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.irrigation_used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.is_bergmahd` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.noncompliance.occurred` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.noncompliance.self_reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.noncompliance.third_party_fault` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.auflagen[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.earliest_mowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.fertilization_allowed_years[]` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.first_mowing_before_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.grazing_window_end` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.grazing_window_start` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.management_deviates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.max_gve_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.second_use_earliest_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.third_use_permitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.project_confirmation.written_amendment` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.psm_only_eu_organic_approved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.reference_area_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.schutzgut_layer_share` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.silage_produced` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.use_or_care_years[]` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `land.parcels[].naturschutz.year_completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.feldstueck_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.feldstueck_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.gloez4_buffer_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.gloez8_fallow_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.located_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.national_park` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.national_park_relevant_requirements` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_area_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.schlagnutzung` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].oepul.successor_continues_until_year_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.trial_written_approval` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.ubb_bio_only_landscape_elements` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_18-opus-5.5-high-20260927/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_18-opus-5.5-high-20260927/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
