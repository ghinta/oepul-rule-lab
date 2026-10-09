# o6_23: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_23-luna-high-20261005`

30 Vorschläge; Blattpfade: {'added': 31, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.conditionality_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.first_oepul_participation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].annual_full_area_mown_or_grazed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].application_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].application_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].country` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].is_natura2000_or_high_nature_value` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].n2_code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].op_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].project_confirmation` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].project_confirmation_cut_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].project_confirmation_obligations[].chapter` | added | nicht vorhanden | `"enum(S&#124;A&#124;B&#124;G&#124;W&#124;O&#124;L&#124;H)"` | nicht deklariert | nein |
| `land.parcels[].project_confirmation_obligations[].code` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].transfer_recipient_continues_until_year_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].valid` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `measure.o6_23.application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `measure.o6_23.biodiversity_area_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `measure.o6_23.combined_premium_eur_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `measure.o6_23.contract_year_completed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.o6_23.contract_years` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.o6_23.cut_date_changed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.o6_23.early_use_days` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `measure.o6_23.early_use_premium_code` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `measure.o6_23.noncompliance` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.o6_23.other_measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `measure.o6_23.requested` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.o6_23.second_mowing_on_comparable_fields` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.o6_23.state_regulation_adjusted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `measure.o6_23.withdrawal_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `measure.o6_23.withdrawal_not_declared` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_23-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_23-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_23-opus-5.5-high-20260928`

9 Vorschläge; Blattpfade: {'added': 46, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `farm.applicant.farms_in_own_name_and_account` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association&#124;public_body)"` | nicht deklariert | nein |
| `farm.applicant.performs_agricultural_activity` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.conditionality_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_23.content_violation_stage` | added | nicht vorhanden | `"enum(none&#124;warning&#124;2&#124;5&#124;10&#124;25&#124;50&#124;100)"` | nicht deklariert | nein |
| `farm.oepul.o6_23.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_23.control_notice_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_23.deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_23.full_reductions_in_contract_period` | added | nicht vorhanden | `"int"` | nicht deklariert | nein |
| `farm.oepul.o6_23.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `farm.oepul.o6_23.takeover.additional_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.o6_23.takeover.application_date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `farm.oepul.o6_23.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `farm.oepul.on_site_check_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.divsz_code_marked` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.earliest_cut_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.earliest_cut_date_state_ordinance_2026` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.fertilization_applied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.grassland_type` | added | nicht vorhanden | `"enum(maehwiese&#124;maehweide&#124;dauerweide&#124;hutweide&#124;other)"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.in_national_park` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.in_natura2000_or_high_nature_value_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.n2_code_marked` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.national_park_name` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.project_confirmation_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.project_confirmation_complied` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.natura2000.project_confirmation_present` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility.actively_farmed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility.is_experimental_area_vf` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility.is_gloez_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility.is_other_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility.is_short_rotation_or_nursery` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility.located_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].eligibility.mainly_agricultural_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.naturschutz_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.op_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].oepul.successor_continues_until_year_end` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].oepul.transferred_during_year` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.full_area_grazed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.grazing_uses` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.mowing_material_removed` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_23-opus-5.5-high-20260928/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_23-opus-5.5-high-20260928/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
