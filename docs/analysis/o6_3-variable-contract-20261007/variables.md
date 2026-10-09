# Variablenmatrix o6_3

Stand: 07.10.2026. Alle 46 Eingabepfade des gebundenen Pydantic-Vertrags.
Keine neue App-Registry und kein verändertes Canonical Farm Profile.

| Pfad | Typ / Einheit | Herkunft / Zeit | App-Stand | Regel-IDs |
| --- | --- | --- | --- | --- |
| `context.current_year` | integer / year | server_current_year; server year; no client override | Hostvertrag | CURRENT_BASIS |
| `context.snapshot_year` | integer / year | current_snapshot_year; must equal server year | Hostvertrag | CURRENT_BASIS |
| `context.as_of` | string / date | server_as_of; Europe/Vienna local date | Hostvertrag | CURRENT_BASIS, SILAGE, FERMENTATION, STORAGE, GREEN_FEEDING, HAY_TRANSFER, MINIMUM_MANAGEMENT, RECOGNITION |
| `farm.year` | integer / year | current_snapshot_year; must equal server/snapshot year | Hostvertrag | CURRENT_BASIS, CONTRACT, FIRST_YEAR_AREA, FIRST_YEAR_RGVE, PREMIUM_RATE, SILAGE, FERMENTATION, STORAGE, GREEN_FEEDING, HAY_TRANSFER, MINIMUM_MANAGEMENT, RECOGNITION |
| `farm.heuwirtschaft.contract_start_year` | integer / year | dated_contract_record; 2023/2024/2025; missing valid-contract evidence blocks | neu / Vertrag erweitern | CONTRACT, FIRST_YEAR_AREA, FIRST_YEAR_RGVE, PREMIUM_RATE |
| `farm.heuwirtschaft.first_year.year` | integer / year | historical_document; must equal contract_start_year; never default to current year | neu / Vertrag erweitern | FIRST_YEAR_AREA, FIRST_YEAR_RGVE |
| `farm.heuwirtschaft.first_year.mown_meadow_meadow_pasture_ha` | number / ha | historical_document; later years only; >=2 in first year | neu / Vertrag erweitern | FIRST_YEAR_AREA |
| `farm.heuwirtschaft.first_year.rgve_total` | number / RGVE | historical_document_or_bound_calculation; later years only; current stock is not substitute | neu / Vertrag erweitern | FIRST_YEAR_RGVE |
| `farm.heuwirtschaft.first_year.fodder_area_ha` | number / ha | historical_document_or_bound_calculation; later years only; positive and historical RGVE/ha >=0.30 | neu / Vertrag erweitern | FIRST_YEAR_RGVE |
| `farm.heuwirtschaft.participation.combined_measure` | string / measure_id | active_application_document; closed o6_1a/o6_1b/o6_1b_teilbetrieb; verify whole-period validity | neu / Vertrag erweitern | COMBINATION |
| `farm.heuwirtschaft.silage_preparation_and_feeding` | boolean / boolean | operator_declaration_or_expert_observation; false only when both prohibited activities excluded; all species/buildings | neu / Vertrag erweitern | SILAGE |
| `farm.heuwirtschaft.feed_fermentation` | boolean / boolean | operator_declaration_or_expert_observation; false needs exclusion of fermentation; allowed dry byproducts are not silage | neu / Vertrag erweitern | FERMENTATION |
| `farm.heuwirtschaft.silage_storage` | boolean / boolean | operator_declaration_or_expert_observation; farm-wide annual obligation; false not inferred from missing import | neu / Vertrag erweitern | STORAGE |
| `farm.heuwirtschaft.green_feeding_majority_april_to_september` | boolean / boolean | expert_method_with_operator_records; no invented 92-day rule; seasonal cohort presence required, not today stock only | neu / Vertrag erweitern | GREEN_FEEDING |
| `farm.heuwirtschaft.third_party_cuttings_only_dry_hay` | boolean / boolean | operator_transfer_records_or_expert_observation; no transfers can support true only after explicit complete no-transfer declaration | neu / Vertrag erweitern | HAY_TRANSFER |
| `farm.heuwirtschaft.no_mower_conditioner_option` | boolean / boolean | active_option_application_document; explicit true/false; yearly option validity | neu / Vertrag erweitern | CONTRACT, PREMIUM_RATE, MOWER_CONDITIONER |
| `farm.heuwirtschaft.mower_conditioner_used` | boolean / boolean | operator_declaration_or_expert_observation; required when option=true; includes mowing for green feed | neu / Vertrag erweitern | MOWER_CONDITIONER |
| `farm.heuwirtschaft.mower_conditioner_present` | boolean / boolean | operator_inventory_or_expert_observation; required when option=true; interpretation of decommissioned devices needs expert review | neu / Vertrag erweitern | MOWER_CONDITIONER |
| `land.parcels_complete` | boolean / boolean | operator_or_expert_inventory_confirmation; true plus [] is known empty; import presence alone is insufficient | neu / Vertrag erweitern | FIRST_YEAR_AREA, FORAGE_AREA |
| `land.parcels[].parcel_id` | string / id | snapshot_stable_parcel_reference; structural; immutable for evidence scope | Identitätsvertrag erweitern | FIRST_YEAR_AREA, FORAGE_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].area_ha` | number / ha | snapshot_or_bound_current_fact; finite >=0; current candidate accepts zero, do not use as missing sentinel | registriert, o6_3 konsumiert nicht | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA |
| `land.parcels[].land_use` | string / enum | validated_snapshot_classification; schema enum; labels/codes need explicit source-backed map | registriert, o6_3 konsumiert nicht | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].located_in_austria` | boolean / boolean | geospatial_or_application_record; false excludes from calculations; unknown remains unknown | neu / Vertrag erweitern | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].is_applied` | boolean / boolean | current_application_document; generic application is not proof of o6_3 parcel eligibility; missing general conditions block premium | neu / Vertrag erweitern | FIRST_YEAR_AREA, FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].grassland_type` | string / enum | validated_application_classification; mähwiese/mähweide/streuwiese/bergmähder/dauerweide/hutweide; unknown blocks | neu / Vertrag erweitern | FIRST_YEAR_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].crop.forage_crop_type` | string / enum | validated_application_crop_classification; unknown import codes must never become non_fodder | neu / Vertrag erweitern | FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].crop.is_second_crop` | boolean / boolean | current_application_crop_document; true excludes forage denominator and premium for arable forage | neu / Vertrag erweitern | FORAGE_AREA, PREMIUM_AREA, MINIMUM_MANAGEMENT |
| `land.parcels[].operations.cutting_dates` | array / date[] | operator_mowing_records_or_expert_observation; null unknown; confirmed [] means no observed cuts; one date not full-area removal proof | registriert, o6_3 konsumiert | PREMIUM_AREA |
| `land.parcels[].operations.full_mowing_and_removal` | boolean / boolean | operator_management_records_or_expert_observation; annual evidence; false before year-end not final future noncompliance | neu / Vertrag erweitern | MINIMUM_MANAGEMENT |
| `land.parcels[].operations.full_grazing` | boolean / boolean | operator_grazing_records_or_expert_observation; alternative to full mowing/removal; mountain meadows need separate two-year check | neu / Vertrag erweitern | MINIMUM_MANAGEMENT |
| `livestock.species_groups_complete` | boolean / boolean | operator_or_expert_livestock_inventory_confirmation; aggregated species import cannot certify category completeness | neu / Vertrag erweitern | CURRENT_RGVE |
| `livestock.species_groups[].group_id` | string / id | source_backed_category_cohort_identity; App currently identifies by species; extension required, preserve legacy IDs | Identitätsvertrag erweitern | CURRENT_RGVE |
| `livestock.species_groups[].species` | string / enum | source_backed_category_cohort_identity; multiple categories of same species require separate stable cohorts | Identitätsvertrag erweitern | CURRENT_RGVE |
| `livestock.species_groups[].rgve_category` | string / enum | animal_category_age_breed_size_evidence; unknown/mismatched species blocks; no generic GVE alias | neu / Vertrag erweitern | CURRENT_RGVE |
| `livestock.species_groups[].animal_count` | number / animals | declared_1_april_animal_list; must match year/date/basis; App integer vs Lab number difference requires documented handling | registriert, o6_3 konsumiert nicht | CURRENT_RGVE |
| `livestock.species_groups[].average_count` | number / animals | cattle_database_or_submitted_average_list; cattle required; other species only authoritative submitted average list; never arbitrary numeric preference | neu / Vertrag erweitern | CURRENT_RGVE |
| `livestock.species_groups[].kept_in_austria` | boolean / boolean | animal_location_records; false excludes; unknown blocks RGVE | neu / Vertrag erweitern | CURRENT_RGVE |
| `exceptions.recognitions_complete` | boolean / boolean | authority_document_inventory_confirmation; required when violation exists; known empty is not unknown | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].reference` | string / id | AMA_document; identifies evidence; cannot be a generic drought claim | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].authority` | string / enum | AMA_document; constant AMA; source label alone is not legal approval | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].recognised` | boolean / boolean | AMA_document; true only with supporting document; no blanket waiver | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].year` | integer / year | AMA_document; must align with affected obligation year | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].obligation_id` | string / enum | AMA_document_scope; one of seven implemented obligation IDs | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].parcel_ids` | array / id[] | AMA_document_scope; MINIMUM_MANAGEMENT requires nonempty IDs; farm scope represented by null in candidate | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].valid_from` | string / date | AMA_document_scope; compare to incident/obligation period, not blindly current as_of; legal interpretation pending | neu / Vertrag erweitern | RECOGNITION |
| `exceptions.recognitions[].valid_to` | string / date | AMA_document_scope; end >=start, same declared year in current schema; cross-year documents require explicit extension | neu / Vertrag erweitern | RECOGNITION |

Definition, zulässige Schemawerte, unbekannte Werte, Quellen-IDs und geplantes OPA-Ziel stehen pro Pfad vollständig in `variables.json`.
Für CURRENT_BASIS sind Quellen-IDs leer: das ist der technische App-Vertrag aus #135 und kein erfundenes Fördergesetz.

## Strukturelle Lücken

- Vier wiederverwendbare registrierte Felder: Schlagfläche, Nutzungsart, Tierzahl und Mahddaten. Nur Mahddaten werden heute von o6_3 konsumiert.
- Tierzahl: App integer gegenüber Lab number. Stichtagsstückzahlen müssen ganze Zahlen sein; Durchschnittsbestand darf nicht gerundet werden.
- Die App-Gruppenidentität ist bisher die Art (`species`), nicht eine RGVE-Kohorte. Mehrere Alters-/Größenklassen benötigen stabile Kategorien-IDs und erhaltene Alt-Provenienz.
- Vollständigkeit des effektiven Bestands ist eine eigene Bestätigung; vorhandene Importzeilen ersetzen sie nicht.
- Erstjahresnachweise werden heute erfasst, beziehen sich fachlich aber auf das datierte historische Erstjahr. #135 speichert sie im aktuellen Faktenvertrag; ihr Nachweisjahr wird nicht auf das aktuelle Jahr umgeschrieben.
- Ergänzende count_reference-/Saison-/Vorfalls-/allgemeine Förderbelege sind Vorschläge in `proposed_evidence_extensions`. Sie sind aktuell keine vom strikten Lab-Eingabeschema akzeptierten Felder.
- Keine GVE→RGVE-Umbenennung, kein Schnittdatum→vollflächige Abfuhr, keine Importexistenz→Vollständigkeit, keine Schätzung→AMA-Anerkennung.
