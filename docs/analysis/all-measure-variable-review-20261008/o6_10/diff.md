# o6_10: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_10-luna-high-20261003`

3 Vorschläge; Blattpfade: {'added': 51, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `land.parcels[].country` | added | nicht vorhanden | `"AT"` | nicht deklariert | nein |
| `land.parcels[].o6_10.alternative_planting_system` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.application_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_10.country` | added | nicht vorhanden | `"AT"` | nicht deklariert | nein |
| `land.parcels[].o6_10.cover_removal_method` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_10.cover_type` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].o6_10.cover_used_for_production` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.covered_area_percent` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].o6_10.extensive_sheep_grazing` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.full_year_and_all_alleys_cover` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.grafted_material` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.grain_or_maize_share_percent` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].o6_10.green_cut_rye_under_seed_law` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.hardy_mixture_partners` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].o6_10.is_terrace` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.oats_or_spring_barley_cover_crop` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.open_stem_width_cm` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].o6_10.pesticide_on_aisle_cover` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.preexisting_cover` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.pure_grain_or_maize` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.renewal_count_per_year` | added | nicht vorhanden | `0` | nicht deklariert | nein |
| `land.parcels[].o6_10.reseeding.after_october_1` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.reseeding.cleared_after_september_15` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.reseeding.required` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.reseeding.uncovered_until_may_15` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.reseeding.within_8_weeks` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.special_crop_management_complete` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.surcharge_applied` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.temporary_poultry_grazing` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.tillage.destroys_cover` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `land.parcels[].o6_10.tillage.followed_by_reseeding` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_10.application_replaces_pesticide` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.compliance` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.contract_year_completed` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.drought_2026` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.drought_cover_failure` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.entry_year` | added | nicht vorhanden | `2026` | nicht deklariert | nein |
| `o6_10.insecticide_avoidance` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.is_terrace` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.operation_program_organisms_or_pheromones` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.organic_farming` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.organism_or_pheromone_surcharge_requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.proper_cover_establishment` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.records.cover_fields_complete` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.records.farm` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.records.surcharge_fields_complete` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.requested` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.surcharge_applied_on_at_least_one_plot` | added | nicht vorhanden | `false` | nicht deklariert | nein |
| `o6_10.withdrawal_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `o6_10.withdrawal_reported_online` | added | nicht vorhanden | `false` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_10-luna-high-20261003/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_10-luna-high-20261003/workspace/rules/citations.json).

## opus: `v2-o6_10-opus-5.5-high-20260925`

20 Vorschläge; Blattpfade: {'added': 62, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.o6_10_greening_record_items[]` | added | nicht vorhanden | `"enum(farm&#124;field_piece_number_and_name&#124;plot_size&#124;clearing_replanting_date&#124;greening_establishment_and_break_dates)"` | nicht deklariert | nein |
| `documentation.o6_10_organisms_pheromones_record_items[]` | added | nicht vorhanden | `"enum(type_and_amount&#124;purchase_receipts&#124;reason_and_target&#124;application_date)"` | nicht deklariert | nein |
| `farm.applicant.farms_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.person_type` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons&#124;territorial_authority)"` | nicht deklariert | nein |
| `farm.applicant.public_authority_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.conditionality_breach` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.exited_measure_12_rebzikade_2026` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_oepul_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_10.control_findings[].stage` | added | nicht vorhanden | `"enum(warning&#124;reduction_2&#124;reduction_5&#124;reduction_10&#124;reduction_25&#124;reduction_50&#124;reduction_100&#124;exclusion)"` | nicht deklariert | nein |
| `farm.oepul.o6_10.control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_10.deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_10.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.o6_10.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_10.multiple_application_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_10.on_site_control_announced_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_10.takeover.additional_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_10.takeover.farm_already_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_10.takeover.is_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.o6_10.takeover.request_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_10.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.participating_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `farm.oepul.producer_organisation.is_member` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.producer_organisation.operational_programme_compensates_organisms_or_pheromones` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].is_gloez_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].location.is_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].location.national_park` | added | nicht vorhanden | `"enum(neusiedlersee&#124;donau_auen&#124;kalkalpen&#124;other&#124;null)"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].op_excluded_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.cereal_is_oat_or_spring_barley_nurse_crop` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.contains_pure_cereal_or_maize` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.cover_type` | added | nicht vorhanden | `"enum(living_greening&#124;organic_mulch&#124;self_greening&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.establishment_method` | added | nicht vorhanden | `"enum(sown_mixture&#124;existing_greening_retained&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.events[].date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.events[].destroys_greening` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.events[].event_type` | added | nicht vorhanden | `"enum(establishment&#124;break&#124;clearing&#124;replanting&#124;subsoil_loosening&#124;other_tillage)"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.full_coverage_all_inter_rows_all_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.grazing` | added | nicht vorhanden | `"enum(none&#124;sheep_extensive&#124;poultry_temporary&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.greened_share_of_total_area_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.growth_used_or_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.is_green_cut_rye_variety` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.max_cereal_maize_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.open_strip_width_cm` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.properly_established` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.psm_applied_on_greening` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.removal_method` | added | nicht vorhanden | `"enum(mechanical&#124;chemical&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].operations.inter_row_greening.winter_hardy_mixture_partners` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.organisms_pheromones.per_register_application_rates` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.organisms_pheromones.replaces_psm_application` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.organisms_pheromones.used` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].permanent_crop.is_grafted_planting_material` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].permanent_crop.minimum_management.annual_care` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].permanent_crop.minimum_management.harvest_and_removal` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].permanent_crop.minimum_management.properly_planted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].permanent_crop.planting_system` | added | nicht vorhanden | `"enum(single_row&#124;double_row&#124;planting_bed&#124;staggered&#124;wide_row_spacing&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].permanent_crop.planting_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].permanent_crop.type` | added | nicht vorhanden | `"enum(vine&#124;vine_terrace&#124;fruit&#124;hop&#124;vine_nursery&#124;tree_nursery&#124;energy_wood&#124;palm_catkin&#124;other_permanent_crop&#124;other_special_crop_area&#124;none)"` | nicht deklariert | nein |
| `land.parcels[].transfer.successor_continues_until_year_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].transfer.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_10-opus-5.5-high-20260925/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_10-opus-5.5-high-20260925/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
