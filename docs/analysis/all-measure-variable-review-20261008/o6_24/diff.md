# o6_24: Variablen vorher / nachher

Vorher/nachher bezeichnet das Ausgangsprofil und den Modellvorschlag des historischen Runs.
App vorher bezeichnet nur das deklarierte Blueprint-Schema und die CSV-Registries am festgehaltenen Commit.
Die Python-Collection-Registry und Adapter benötigen eine gesonderte Konsumprüfung; „nein“ ist kein Laufzeitnachweis.
App nachher: nicht entschieden. Beispielwerte sind keine Defaults. Keine semantischen Aliase sind freigegeben.

## luna: `v2-o6_24-luna-high-20261005`

10 Vorschläge; Blattpfade: {'added': 10, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `documentation.drought_no_harvestable_stand` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.wrrl_farm_book_complete` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.wrrl_measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `documentation.wrrl_withdrawal_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.is_wrrl_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].constraints.wrrl_fertilizer_class` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].constraints.wrrl_higher_n_authorization` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.annual_effective_n_kg_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.application_period_compliant` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.wrrl_annual_limit_kg_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_24-luna-high-20261005/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_24-luna-high-20261005/workspace/rules/citations.json).

## opus: `v2-o6_24-opus-5.5-high-20260928`

22 Vorschläge; Blattpfade: {'added': 46, 'removed': 0, 'changed': 0}.

| Pfad | Aktion | Vorher im Run | Nachher im Run | App-Blueprint vorher | Exakt CSV-registriert |
| --- | --- | --- | --- | --- | --- |
| `compliance.conditionality_breach` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `documentation.o6_24_betriebsbuch_stored_on_farm` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_active_farmer` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.is_public_body` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `farm.applicant.legal_form` | added | nicht vorhanden | `"enum(natural_person&#124;registered_partnership&#124;legal_person&#124;association_of_persons)"` | nicht deklariert | nein |
| `farm.applicant.public_body_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `farm.oepul.first_participation_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `land.parcels[].crop.usually_harvested_late_summer_or_autumn` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].district` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].federal_state` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].in_national_park` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].is_gloez_landscape_element` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].located_in_austria` | added | nicht vorhanden | `"boolean"` | nicht deklariert | ja |
| `land.parcels[].mainly_agricultural_use` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].oepul_codes[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilization_records_kept` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.fertilizer.annual_effective_n_kg_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.force_majeure_recognized` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.full_area_grazing` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].operations.harvest_share_percent` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].operations.no_harvestable_stand_due_to_drought` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.duengeklassen[].area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.duengeklassen[].klasse` | added | nicht vorhanden | `"string&#124;null"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.duengeklassen[].n_limit_kg_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.in_area` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.increased_n_permit` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.n_application_periods_compliant` | added | nicht vorhanden | `"boolean&#124;null"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.other_area_payments_eur_per_ha` | added | nicht vorhanden | `"number&#124;null"` | nicht deklariert | nein |
| `land.parcels[].wrrl_o6_24.public_funding_overlap` | added | nicht vorhanden | `"enum(none&#124;statutory&#124;public_agreement&#124;official_compensation_area)"` | nicht deklariert | nein |
| `land.protected_cultivation_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `participation.measures[]` | added | nicht vorhanden | `"string"` | nicht deklariert | nein |
| `participation.o6_24.circumstance.date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `participation.o6_24.circumstance.force_majeure` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.o6_24.circumstance.reported` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.o6_24.contract_start_year` | added | nicht vorhanden | `"int&#124;null"` | nicht deklariert | nein |
| `participation.o6_24.control_refused` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.o6_24.deregistration_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `participation.o6_24.measure_application_date` | added | nicht vorhanden | `"date&#124;null"` | nicht deklariert | nein |
| `participation.o6_24.multiple_application_not_submitted` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.o6_24.sanction_step` | added | nicht vorhanden | `"enum(warning&#124;reduction_2&#124;reduction_5&#124;reduction_10&#124;reduction_25&#124;reduction_50&#124;reduction_100&#124;exclusion&#124;null)"` | nicht deklariert | nein |
| `participation.o6_24.takeover.additional_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `participation.o6_24.takeover.ama_approved` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |
| `participation.o6_24.takeover.date` | added | nicht vorhanden | `"date"` | nicht deklariert | nein |
| `participation.o6_24.takeover.taken_over_area_ha` | added | nicht vorhanden | `"number"` | nicht deklariert | nein |
| `participation.o6_24.takeover.taker_already_participating` | added | nicht vorhanden | `"boolean"` | nicht deklariert | nein |

Originalvorschläge und Quellen: [profile_changes.json](../../../../runs/v2-o6_24-opus-5.5-high-20260928/workspace/rules/profile_changes.json), [citations.json](../../../../runs/v2-o6_24-opus-5.5-high-20260928/workspace/rules/citations.json).

## Grenzen

Deklarierte Regelpfade, Profilvorschläge und tatsächlicher Rego-Konsum sind getrennt erfasst.
Der Scanner erfasst object.get/Helper/Aliase nicht vollständig. Konsumprüfung bleibt offen.
Die Anzahl der Vorschläge oder Blattpfade ist kein Qualitätsurteil über Luna bzw. Opus.
