# o6_3 input matrix

Historical review: 7 October 2026. All 46 paths in the bound Pydantic contract.
This matrix does not add an app registry or change the Canonical Farm Profile.
Field identifiers and allowed domain codes retain their exact names.

| Path | Type / unit | Origin / time | App status | Rule IDs |
| --- | --- | --- | --- | --- |
| `context.current_year` | integer / year | server_current_year; server year; no client override | Host contract | CURRENT_BASIS |
| `context.snapshot_year` | integer / year | current_snapshot_year; must equal server year | Host contract | CURRENT_BASIS |
| `context.as_of` | string / date | server_as_of; Europe/Vienna local date | Host contract | CURRENT_BASIS, SILAGE, FERMENTATION, STORAGE, GREEN_FEEDING, HAY_TRANSFER, MINIMUM_MANAGEMENT, RECOGNITION |
| `farm.year` | integer / year | current_snapshot_year; must equal server/snapshot year | Host contract | CURRENT_BASIS, CONTRACT, FIRST_YEAR_AREA, FIRST_YEAR_RGVE, PREMIUM_RATE, SILAGE, FERMENTATION, STORAGE, GREEN_FEEDING, HAY_TRANSFER, MINIMUM_MANAGEMENT, RECOGNITION |
| `farm.heuwirtschaft.contract_start_year` | integer / year | dated_contract_record; 2023/2024/2025; missing valid-contract evidence blocks | New / extend contract | CONTRACT, FIRST_YEAR_AREA, FIRST_YEAR_RGVE, PREMIUM_RATE |
| `farm.heuwirtschaft.first_year.year` | integer / year | historical_document; must equal contract_start_year; never default to current year | New / extend contract | FIRST_YEAR_AREA, FIRST_YEAR_RGVE |
| `farm.heuwirtschaft.first_year.mown_meadow_meadow_pasture_ha` | number / ha | historical_document; later years only; >=2 in first year | New / extend contract | FIRST_YEAR_AREA |
| `farm.heuwirtschaft.first_year.rgve_total` | number / RGVE | historical_document_or_bound_calculation; later years only; current stock is not substitute | New / extend contract | FIRST_YEAR_RGVE |
| `farm.heuwirtschaft.first_year.fodder_area_ha` | number / ha | historical_document_or_bound_calculation; later years only; positive and historical RGVE/ha >=0.30 | New / extend contract | FIRST_YEAR_RGVE |
| `farm.heuwirtschaft.participation.combined_measure` | string / measure_id | active_application_document; closed o6_1a/o6_1b/o6_1b_teilbetrieb; verify whole-period validity | New / extend contract | COMBINATION |
| `farm.heuwirtschaft.silage_preparation_and_feeding` | boolean / boolean | operator_declaration_or_expert_observation; false only when both prohibited activities excluded; all species/buildings | New / extend contract | SILAGE |
| `farm.heuwirtschaft.feed_fermentation` | boolean / boolean | operator_declaration_or_expert_observation; false needs exclusion of fermentation; allowed dry byproducts are not silage | New / extend contract | FERMENTATION |
| `farm.heuwirtschaft.silage_storage` | boolean / boolean | operator_declaration_or_expert_observation; farm-wide annual obligation; false not inferred from missing import | New / extend contract | STORAGE |
| `farm.heuwirtschaft.green_feeding_majority_april_to_september` | boolean / boolean | expert_method_with_operator_records; no invented 92-day rule; seasonal cohort presence required, not today stock only | New / extend contract | GREEN_FEEDING |
| `farm.heuwirtschaft.third_party_cuttings_only_dry_hay` | boolean / boolean | operator_transfer_records_or_expert_observation; no transfers can support true only after explicit complete no-transfer declaration | New / extend contract | HAY_TRANSFER |
| `farm.heuwirtschaft.no_mower_conditioner_option` | boolean / boolean | active_option_application_document; explicit true/false; yearly option validity | New / extend contract | CONTRACT, PREMIUM_RATE, MOWER_CONDITIONER |
| `farm.heuwirtschaft.mower_conditioner_used` | boolean / boolean | operator_declaration_or_expert_observation; required when option=true; includes mowing for green feed | New / extend contract | MOWER_CONDITIONER |
| `farm.heuwirtschaft.mower_conditioner_present` | boolean / boolean | operator_inventory_or_expert_observation; required when option=true; interpretation of decommissioned devices needs expert review | New / extend contract | MOWER_CONDITIONER |
| `land.parcels_complete` | boolean / boolean | operator_or_expert_inventory_confirmation; true plus [] is known empty; import presence alone is insufficient | New / extend contract | FIRST_YEAR_AREA, FORAGE_AREA |
| `land.parcels[].parcel_id` | string / id | snapshot_stable_parcel_reference; structural; immutable for evidence scope | Extend identity contract | FIRST_YEAR_AREA, FORAGE_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].area_ha` | number / ha | snapshot_or_bound_current_fact; finite >=0; current candidate accepts zero, do not use as missing sentinel | Registered, not consumed by o6_3 | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA |
| `land.parcels[].land_use` | string / enum | validated_snapshot_classification; schema enum; labels/codes need explicit source-backed map | Registered, not consumed by o6_3 | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].located_in_austria` | boolean / boolean | geospatial_or_application_record; false excludes from calculations; unknown remains unknown | New / extend contract | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].is_applied` | boolean / boolean | current_application_document; generic application is not proof of o6_3 parcel eligibility; missing general conditions block premium | New / extend contract | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].grassland_type` | string / enum | validated_application_classification; mähwiese/mähweide/streuwiese/bergmähder/dauerweide/hutweide; unknown blocks | New / extend contract | FIRST_YEAR_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].crop.forage_crop_type` | string / enum | validated_application_crop_classification; unknown import codes must never become non_fodder | New / extend contract | FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].crop.is_second_crop` | boolean / boolean | current_application_crop_document; true excludes forage denominator and premium for arable forage | New / extend contract | FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].operations.cutting_dates` | array / date[] | operator_mowing_records_or_expert_observation; null unknown; confirmed [] means no observed cuts; one date not full-area removal proof | Registered, consumed by o6_3 | PREMIUM_AREA |
| `land.parcels[].operations.full_mowing_and_removal` | boolean / boolean | operator_management_records_or_expert_observation; annual evidence; false before year-end not final future noncompliance | New / extend contract | MINIMUM_MANAGEMENT |
| `land.parcels[].operations.full_grazing` | boolean / boolean | operator_grazing_records_or_expert_observation; alternative to full mowing/removal; mountain meadows need separate two-year check | New / extend contract | MINIMUM_MANAGEMENT |
| `livestock.species_groups_complete` | boolean / boolean | operator_or_expert_livestock_inventory_confirmation; aggregated species import cannot certify category completeness | New / extend contract | CURRENT_RGVE |
| `livestock.species_groups[].group_id` | string / id | source_backed_category_cohort_identity; App currently identifies by species; extension required, preserve legacy IDs | Extend identity contract | CURRENT_RGVE |
| `livestock.species_groups[].species` | string / enum | source_backed_category_cohort_identity; multiple categories of same species require separate stable cohorts | Extend identity contract | CURRENT_RGVE |
| `livestock.species_groups[].rgve_category` | string / enum | animal_category_age_breed_size_evidence; unknown/mismatched species blocks; no generic GVE alias | New / extend contract | CURRENT_RGVE |
| `livestock.species_groups[].animal_count` | number / animals | declared_1_april_animal_list; must match year/date/basis; App integer vs Lab number difference requires documented handling | Registered, not consumed by o6_3 | CURRENT_RGVE |
| `livestock.species_groups[].average_count` | number / animals | cattle_database_or_submitted_average_list; cattle required; other species only authoritative submitted average list; never arbitrary numeric preference | New / extend contract | CURRENT_RGVE |
| `livestock.species_groups[].kept_in_austria` | boolean / boolean | animal_location_records; false excludes; unknown blocks RGVE | New / extend contract | CURRENT_RGVE |
| `exceptions.recognitions_complete` | boolean / boolean | authority_document_inventory_confirmation; required when violation exists; known empty is not unknown | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].reference` | string / id | AMA_document; identifies evidence; cannot be a generic drought claim | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].authority` | string / enum | AMA_document; constant AMA; source label alone is not legal approval | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].recognised` | boolean / boolean | AMA_document; true only with supporting document; no blanket waiver | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].year` | integer / year | AMA_document; must align with affected obligation year | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].obligation_id` | string / enum | AMA_document_scope; one of seven implemented obligation IDs | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].parcel_ids` | array / id[] | AMA_document_scope; MINIMUM_MANAGEMENT requires nonempty IDs; farm scope represented by null in candidate | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].valid_from` | string / date | AMA_document_scope; compare to incident/obligation period, not blindly current as_of; legal interpretation pending | New / extend contract | RECOGNITION |
| `exceptions.recognitions[].valid_to` | string / date | AMA_document_scope; end >=start, same declared year in current schema; cross-year documents require explicit extension | New / extend contract | RECOGNITION |


`variables.json` gives each path's definition, allowed values, unknown-value
handling, source IDs and planned OPA target. CURRENT_BASIS has no source IDs:
it is the technical host contract from #135, not an invented funding law.

## Structural gaps

- Four registered fields can be reused: parcel area, land use, animal count and
  cutting dates. Only cutting dates are currently consumed by o6_3.
- App animal counts are integers; lab counts are numbers. Reference-date counts
  need whole animals; average stock must not be rounded.
- Existing group identity is species, not RGVE cohort. Age/size groups need stable
  category IDs while keeping old provenance.
- Completeness requires a separate confirmation, not merely imported rows.
- First-year evidence is declared now but retains its historical evidence year.
- Count-reference, seasonal, incident and general eligibility evidence extensions
  remain proposals outside the current strict input schema.
- GVE does not become RGVE by renaming. A cutting date does not prove removal;
  an import does not prove completeness; an estimate is not AMA recognition.
