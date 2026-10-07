# o6_5: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_5-luna-high-20261002`

2 Vorschläge; Blattpfade: {'added': 50, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.animals[].animal_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.animals[].animal_type` | added | nicht vorhanden | `"enum(cow&#124;bull&#124;mare&#124;stallion&#124;ewe&#124;ram&#124;doe&#124;buck&#124;sow&#124;boar)"` | nicht deklariert | nein |
| `livestock.animals[].application_and_confirmation.application_year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.animals[].application_and_confirmation.applied_individually` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].application_and_confirmation.confirmation_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].application_and_confirmation.organization_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].application_and_confirmation.program_implemented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].application_and_confirmation.reference_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.animals[].application_and_confirmation.ueln` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].approved_breeding_program` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breed` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.admitted_to_breeding_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.age_months_at_stichtag` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.age_years_at_may31` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.breeding_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.calved_by_stichtag` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.every_second_litter_purebred` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.foaled_by_may31` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.kidded_by_stichtag` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.lambed_by_stichtag` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.live_born_offspring_last_two_years[].year` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.milk_control` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.next_foaling_within_3_5_years` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].breeding_facts.purebred_farroted_by_stichtag` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].held_from` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.animals[].held_to` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.animals[].holding_country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].animal_sex` | added | nicht vorhanden | `"enum(female&#124;male&#124;null)"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].control_remains_with_applicant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].days_until_replacement` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].duration_days` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].duration_months` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].event_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].event_type` | added | nicht vorhanden | `"enum(departure&#124;replacement&#124;temporary_transfer)"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].original_breed` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].original_milk_control` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].original_sex` | added | nicht vorhanden | `"enum(female&#124;male&#124;null)"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].purpose` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].replacement_breed` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].replacement_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].replacement_milk_control` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].replacement_sex` | added | nicht vorhanden | `"enum(female&#124;male&#124;null)"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].reported_within_days` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.animals[].movement_events[].temporary_stay` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].purebred` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].purebred_mating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].regular_breeding_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.animals[].species` | added | nicht vorhanden | `"enum(cattle&#124;horse&#124;sheep&#124;goat&#124;pig)"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_5-luna-high-20261002/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_5-luna-high-20261002/workspace/rules/citations.json).

## opus: `v2-o6_5-opus-5.5-high-20260925`

7 Vorschläge; Blattpfade: {'added': 62, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.inspection_refusal_force_majeure` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `documentation.inspection_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.vis_reports_complete` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons)"` | nicht deklariert | nein |
| `farm.applicant.performs_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].animal_category` | added | nicht vorhanden | `"enum(kuh&#124;zuchtstier&#124;stute&#124;zuchthengst&#124;mutterschaf&#124;zuchtwidder&#124;mutterziege&#124;zuchtbock&#124;zuchtsau&#124;zuchteber)"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].animal_id` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].applied_in_mfa` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].approved_breeding_program` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].birth_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].breed` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].breeding_approval_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].breeding_org_confirmation.date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].breeding_org_confirmation.status` | added | nicht vorhanden | `"enum(confirmed&#124;rejected&#124;pending)"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].breeding_use_in_year` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].departure.date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].departure.exported_slaughtered_or_died_before_next_jan1` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].departure.reason` | added | nicht vorhanden | `"enum(sale&#124;transfer&#124;death&#124;slaughter&#124;export&#124;other)&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].departure.reported_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].equine_database_and_vis_reported` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].first_offspring_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].first_purebred_farrowing_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].herdbook_registered` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].identification` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].is_purebred` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].kept_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].last_foaling_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].litters_purebred` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].litters_total` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].live_offspring_registered_last_2_years` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].milk_recording` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].on_farm_from` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].purebred_mating_only` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].regular_breeding_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].replacement_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].replacement_reported_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].replaces_animal_id` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].temporary_absences[].control_retained_or_care_only` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].temporary_absences[].documented` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].temporary_absences[].end_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].temporary_absences[].reported_before_transfer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].temporary_absences[].start_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].temporary_absences[].type` | added | nicht vorhanden | `"enum(breeding_station&#124;male_breeding_use_other_farm&#124;alpine_or_common_pasture&#124;performance_test&#124;breeding_event&#124;sport_event&#124;other)"` | nicht deklariert | nein |
| `livestock.endangered_breed_animals[].ueln_in_application` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_participation.first_oepul_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.content_violation_stage` | added | nicht vorhanden | `"enum(none&#124;warning&#124;2&#124;5&#124;10&#124;25&#124;50&#124;100&#124;exclusion)"` | nicht deklariert | nein |
| `oepul_participation.o6_5.deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `oepul_participation.o6_5.inspection_notice_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.late_reentry_correction` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.o6_5.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.participation_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.previous_year_contract_lapsed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.o6_5.reapplication_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.takeover.animals_and_land_from_same_predecessor` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.takeover.is_takeover` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `oepul_participation.o6_5.takeover.reason` | added | nicht vorhanden | `"enum(betriebsaufloesung&#124;betriebsteilung&#124;betriebszusammenlegung&#124;other)&#124;null"` | nicht deklariert | nein |
| `oepul_participation.o6_5.written_request_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_5-opus-5.5-high-20260925/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_5-opus-5.5-high-20260925/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
