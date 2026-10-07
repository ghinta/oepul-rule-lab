package adapted.o6_3

import rego.v1

tables := data.heuwirtschaft_tables
value(path) := object.get(input, path, null)
hay := object.get(input, ["farm", "heuwirtschaft"], {})
year := value(["farm", "year"])
start := value(["farm", "heuwirtschaft", "contract_start_year"])
as_of := value(["context", "as_of"])

parcels := ps if {
	ps := value(["land", "parcels"])
	is_array(ps)
}

else := []

groups := gs if {
	gs := value(["livestock", "species_groups"])
	is_array(gs)
}

else := []

recognitions := rs if {
	rs := value(["exceptions", "recognitions"])
	is_array(rs)
}

else := []

# Current-year context comes from the trusted host, not an editable farm fact.
required_paths := [
	["context", "current_year"], ["context", "snapshot_year"], ["context", "as_of"],
	["farm", "year"], ["farm", "heuwirtschaft", "contract_start_year"],
	["farm", "heuwirtschaft", "participation", "combined_measure"],
	["farm", "heuwirtschaft", "no_mower_conditioner_option"],
	["land", "parcels"], ["livestock", "species_groups"],
]

missing_data contains concat(".", path) if {
	some path in required_paths
	value(path) == null
}

collection_missing contains "land.parcels_complete" if value(["land", "parcels_complete"]) != true
collection_missing contains "livestock.species_groups_complete" if value(["livestock", "species_groups_complete"]) != true

basis_failures contains "CURRENT_YEAR_MISMATCH" if {
	is_number(year)
	is_number(value(["context", "current_year"]))
	year != value(["context", "current_year"])
}

basis_failures contains "SNAPSHOT_YEAR_MISMATCH" if {
	is_number(year)
	is_number(value(["context", "snapshot_year"]))
	year != value(["context", "snapshot_year"])
}

basis_failures contains "AS_OF_YEAR_MISMATCH" if {
	is_number(year)
	is_string(as_of)
	not startswith(as_of, sprintf("%d-", [year]))
}

basis_failures contains "CONTRACT_START" if {
	is_number(start)
	not start in {2023, 2024, 2025}
}

basis_failures contains "OUTSIDE_CONTRACT" if {
	is_number(year)
	is_number(start)
	year < start
}

basis_failures contains "OUTSIDE_CONTRACT" if {
	is_number(year)
	year > 2028
}

basis_failures contains "COMBINATION" if {
	v := value(["farm", "heuwirtschaft", "participation", "combined_measure"])
	v != null
	not v in tables.eligible_combinations
}

# MB pp. 2, 5-6; SRL 1.5.5: all RGVE categories, with average cattle counts.
non_rgve_species := {"pigs", "poultry", "rabbits"}

rgve_row(g) := row if {
	some row in tables.rgve_rates
	row.category_id == object.get(g, "rgve_category", null)
	row.species == g.species
}

group_count(g) := g.average_count if is_number(object.get(g, "average_count", null))

group_count(g) := g.animal_count if {
	object.get(g, "average_count", null) == null
	not rgve_row(g).average_required
	is_number(object.get(g, "animal_count", null))
}

collection_missing contains sprintf("livestock.species_groups[%s].rgve_category", [g.group_id]) if {
	some g in groups
	not g.species in non_rgve_species
	not rgve_row(g)
}

collection_missing contains sprintf("livestock.species_groups[%s].average_count", [g.group_id]) if {
	some g in groups
	rgve_row(g).average_required
	object.get(g, "average_count", null) == null
}

collection_missing contains sprintf("livestock.species_groups[%s].animal_count", [g.group_id]) if {
	some g in groups
	not rgve_row(g).average_required
	object.get(g, "average_count", null) == null
	object.get(g, "animal_count", null) == null
}

collection_missing contains sprintf("livestock.species_groups[%s].kept_in_austria", [g.group_id]) if {
	some g in groups
	not g.species in non_rgve_species
	object.get(g, "kept_in_austria", null) == null
}

total_rgve := sum([amount | some g in groups; not g.species in non_rgve_species; object.get(g, "kept_in_austria", null) == true; amount := group_count(g) * rgve_row(g).rgve])

# MB p. 2: all applied forage land counts, including nature-protection land.
is_forage(p) if p.land_use == "grassland"

is_forage(p) if {
	p.land_use == "arable"
	object.get(p, ["crop", "forage_crop_type"], null) in tables.arable_fodder_for_livestock_calculation
	object.get(p, ["crop", "is_second_crop"], null) == false
}

applied(p) if {
	p.located_in_austria == true
	p.is_applied == true
}

forage_area_ha := sum([p.area_ha | some p in parcels; applied(p); is_forage(p)])
min_area_ha := sum([p.area_ha | some p in parcels; applied(p); p.land_use == "grassland"; object.get(p, "grassland_type", null) in tables.eligible_grassland_types])

collection_missing contains sprintf("land.parcels[%s].located_in_austria", [p.parcel_id]) if {
	some p in parcels
	object.get(p, "located_in_austria", null) == null
}

collection_missing contains sprintf("land.parcels[%s].is_applied", [p.parcel_id]) if {
	some p in parcels
	object.get(p, "is_applied", null) == null
}

collection_missing contains sprintf("land.parcels[%s].grassland_type", [p.parcel_id]) if {
	some p in parcels
	applied(p)
	p.land_use == "grassland"
	not object.get(p, "grassland_type", null) in array.concat(tables.eligible_grassland_types, tables.excluded_grassland_types)
}

collection_missing contains sprintf("land.parcels[%s].crop.forage_crop_type", [p.parcel_id]) if {
	some p in parcels
	applied(p)
	p.land_use == "arable"
	object.get(p, ["crop", "forage_crop_type"], null) == null
}

collection_missing contains sprintf("land.parcels[%s].crop.is_second_crop", [p.parcel_id]) if {
	some p in parcels
	applied(p)
	p.land_use == "arable"
	object.get(p, ["crop", "is_second_crop"], null) == null
}

collections_known if {
	value(["land", "parcels_complete"]) == true
	value(["livestock", "species_groups_complete"]) == true
	is_array(value(["land", "parcels"]))
	is_array(value(["livestock", "species_groups"]))
	not some_collection_fact_missing
}

some_collection_fact_missing if count(collection_missing) > 0

missing_data contains path if some path in collection_missing

tierholding if {
	collections_known
	forage_area_ha > 0
	total_rgve / forage_area_ha >= 0.3
}

tierholding_bool if tierholding

else := false

# Current first year uses current evidence; following years use dated history.
first_year if {
	is_number(year)
	is_number(start)
	year == start
}

later_year if {
	is_number(year)
	is_number(start)
	year > start
}

basis_failures contains "FIRST_YEAR_MINIMUM" if {
	first_year
	collections_known
	min_area_ha < 2
}

basis_failures contains "FIRST_YEAR_RGVE" if {
	first_year
	collections_known
	not tierholding
}

history := object.get(hay, "first_year", {})
history_fields := {"year", "mown_meadow_meadow_pasture_ha", "rgve_total", "fodder_area_ha"}

missing_data contains sprintf("farm.heuwirtschaft.first_year.%s", [key]) if {
	later_year
	some key in history_fields
	object.get(history, key, null) == null
}

history_known if {
	later_year
	every key in history_fields { is_number(object.get(history, key, null)) }
}

missing_data contains "farm.heuwirtschaft.first_year.year_alignment" if {
	history_known
	history.year != start
}

basis_failures contains "HISTORICAL_MINIMUM" if {
	history_known
	history.year == start
	history.mown_meadow_meadow_pasture_ha < 2
}

basis_failures contains "HISTORICAL_RGVE" if {
	history_known
	history.year == start
	history.fodder_area_ha <= 0
}

basis_failures contains "HISTORICAL_RGVE" if {
	history_known
	history.year == start
	history.fodder_area_ha > 0
	history.rgve_total / history.fodder_area_ha < 0.3
}

# MB pp. 2-4. No invented day-count interpretation of 'überwiegend'.
fact_rules := {
	"SILAGE": {"field": "silage_preparation_and_feeding", "expected": false},
	"FERMENTATION": {"field": "feed_fermentation", "expected": false},
	"STORAGE": {"field": "silage_storage", "expected": false},
	"GREEN_FEEDING": {"field": "green_feeding_majority_april_to_september", "expected": true},
	"HAY_TRANSFER": {"field": "third_party_cuttings_only_dry_hay", "expected": true},
}

fact_due(id) if id != "GREEN_FEEDING"

fact_due("GREEN_FEEDING") if {
	is_number(year)
	is_string(as_of)
	as_of >= sprintf("%d-09-30", [year])
	total_rgve > 0
}

missing_data contains sprintf("farm.heuwirtschaft.%s", [rule.field]) if {
	some id, rule in fact_rules
	fact_due(id)
	object.get(hay, rule.field, null) == null
}

raw_violations contains {"id": id, "parcel_id": null} if {
	some id, rule in fact_rules
	fact_due(id)
	actual := object.get(hay, rule.field, null)
	actual != null
	actual != rule.expected
}

notes contains "Grünfütterung: Jahrespflicht bis 30.09.; vor Fälligkeit keine Nichterfüllung aus fehlenden Tagen ableiten." if {
	is_number(year)
	is_string(as_of)
	as_of < sprintf("%d-09-30", [year])
}

option_requested if value(["farm", "heuwirtschaft", "no_mower_conditioner_option"]) == true

missing_data contains sprintf("farm.heuwirtschaft.%s", [field]) if {
	option_requested
	some field in {"mower_conditioner_used", "mower_conditioner_present"}
	object.get(hay, field, null) == null
}

raw_violations contains {"id": "MOWER_CONDITIONER", "parcel_id": null} if {
	option_requested
	some field in {"mower_conditioner_used", "mower_conditioner_present"}
	object.get(hay, field, null) == true
}

# SRL 1.6.3.3. No automatic transfer of the 85%-arable drought exemption.
management_met(p) if object.get(p, ["operations", "full_mowing_and_removal"], null) == true
management_met(p) if object.get(p, ["operations", "full_grazing"], null) == true

management_due if {
	is_number(year)
	is_string(as_of)
	as_of >= sprintf("%d-12-31", [year])
}

raw_violations contains {"id": "MINIMUM_MANAGEMENT", "parcel_id": p.parcel_id} if {
	management_due
	some p in parcels
	applied(p)
	is_forage(p)
	object.get(p, "grassland_type", null) != "bergmähder"
	not management_met(p)
	object.get(p, ["operations", "full_mowing_and_removal"], null) == false
	object.get(p, ["operations", "full_grazing"], null) == false
}

missing_data contains sprintf("land.parcels[%s].operations.full_mowing_and_removal", [p.parcel_id]) if {
	management_due
	some p in parcels
	applied(p)
	is_forage(p)
	object.get(p, "grassland_type", null) != "bergmähder"
	not management_met(p)
	object.get(p, ["operations", "full_mowing_and_removal"], null) == null
}

missing_data contains sprintf("land.parcels[%s].operations.full_grazing", [p.parcel_id]) if {
	management_due
	some p in parcels
	applied(p)
	is_forage(p)
	object.get(p, "grassland_type", null) != "bergmähder"
	not management_met(p)
	object.get(p, ["operations", "full_grazing"], null) == null
}

notes contains "Mindestbewirtschaftung: offene Jahrespflicht vor 31.12.; keine automatische Dürrebefreiung für Ackerfutter." if {
	not management_due
	some p in parcels
	applied(p)
	is_forage(p)
	not management_met(p)
}

# Recognition is bounded evidence for review, never a blanket waiver.
recognition_matches(v, r) if {
	r.recognised == true
	r.authority == "AMA"
	r.year == year
	r.obligation_id == v.id
	r.valid_from <= as_of
	as_of <= r.valid_to
	v.parcel_id == null
	object.get(r, "parcel_ids", null) == null
}

recognition_matches(v, r) if {
	r.recognised == true
	r.authority == "AMA"
	r.year == year
	r.obligation_id == v.id
	r.valid_from <= as_of
	as_of <= r.valid_to
	v.parcel_id != null
	v.parcel_id in r.parcel_ids
}

has_recognition(v) if {
	some r in recognitions
	recognition_matches(v, r)
}

exceptions_known if {
	value(["exceptions", "recognitions_complete"]) == true
	is_array(value(["exceptions", "recognitions"]))
}

violations contains v if {
	some v in raw_violations
	exceptions_known
	not has_recognition(v)
}

missing_data contains "exceptions.recognitions/completeness" if {
	count(raw_violations) > 0
	not exceptions_known
}

missing_data contains sprintf("exceptions.review[%s/%v]", [v.id, v.parcel_id]) if {
	some v in raw_violations
	has_recognition(v)
}

notes contains "Anerkennung höherer Gewalt ist pflicht-/flächen-/zeitgebunden; ihre Rechtsfolge braucht fachliche Freigabe." if {
	some v in raw_violations
	has_recognition(v)
}

# MB pp. 1, 4-5: own area classification, no editable 'premium eligible' flag.
premium_type(p) if {
	p.land_use == "grassland"
	object.get(p, "grassland_type", null) in tables.eligible_grassland_types
}

premium_type(p) if {
	p.land_use == "arable"
	object.get(p, ["crop", "forage_crop_type"], null) in tables.eligible_arable_fodder_crops
	object.get(p, ["crop", "is_second_crop"], null) == false
}

missing_data contains sprintf("land.parcels[%s].operations.cutting_dates", [p.parcel_id]) if {
	some p in parcels
	applied(p)
	premium_type(p)
	not is_array(object.get(p, ["operations", "cutting_dates"], null))
}

premium_area_ha := sum([p.area_ha | some p in parcels; applied(p); premium_type(p); dates := object.get(p, ["operations", "cutting_dates"], null); is_array(dates); count(dates) > 0])

rate := row.rate if {
	some row in tables.premium_rates_eur_per_ha
	is_number(year)
	year >= 2023
	year <= 2028
	year >= row.from_year
	rate_year_valid(row)
	row.tierholding == tierholding_bool
	row.no_mower_conditioner == option_requested_bool
}

rate_year_valid(row) if row.to_year == null

rate_year_valid(row) if {
	row.to_year != null
	year <= row.to_year
}

option_requested_bool if option_requested

else := false

# No bonus for a non-livestock farm, even when the option was requested.
indicative_rate := 0 if {
	collections_known
	is_number(year)
	year >= start
	year <= 2028
	not tierholding
}

else := rate if {
	collections_known
	rate
}

else := null

invalid_current_basis if {
	some id in basis_failures
	id in {"CURRENT_YEAR_MISMATCH", "SNAPSHOT_YEAR_MISMATCH", "AS_OF_YEAR_MISMATCH"}
}

invalid_current_basis if {
	some path in [["context", "current_year"], ["context", "snapshot_year"], ["context", "as_of"], ["farm", "year"]]
	value(path) == null
}

missing_data contains "context.current_snapshot_alignment" if invalid_current_basis

status := "missing_data" if invalid_current_basis

else := "ineligible" if count(basis_failures) > 0

else := "ineligible" if count(violations) > 0

else := "missing_data" if count(missing_data) > 0

else := "eligible"

indicative_premium := round((premium_area_ha * indicative_rate) * 100) / 100 if {
	status == "eligible"
	is_number(indicative_rate)
}

else := null

reported_rgve := total_rgve if collections_known

else := null

reported_forage_area := forage_area_ha if collections_known

else := null

premium_area_known if {
	collections_known
	not some_cutting_fact_missing
}

some_cutting_fact_missing if {
	some path in missing_data
	endswith(path, ".operations.cutting_dates")
}

reported_premium_area := premium_area_ha if premium_area_known

else := null

decision := {
	"measure": "o6_3", "adaptation": "issue-97-v1", "status": status,
	"scope": "measure-specific clause slice; indicative gross rate only",
	"excluded_scope": ["general applicant/area eligibility", "single-parcel combination matrix", "area-growth caps", "modulation/caps/sanctions", "two-year mountain-meadow management", "recognition legal effect", "App P1/P2 wiring"],
	"basis_failures": basis_failures, "missing_data": missing_data,
	"violations": violations, "raw_violations": raw_violations, "notes": notes,
	"current_rgve": reported_rgve, "forage_area_ha": reported_forage_area,
	"premium_area_ha": reported_premium_area, "indicative_rate_eur_per_ha": indicative_rate,
	"indicative_premium_eur": indicative_premium,
}
