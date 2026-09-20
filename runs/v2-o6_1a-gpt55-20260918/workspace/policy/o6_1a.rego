package oepul.o6_1a

import rego.v1

default allow := false

allow if {
	count(violations) == 0
}

year := input.farm.year

tables := {
	"crop_groups": data.crop_groups,
	"premium_rates": data.premium_rates,
	"rare_cultivars": data.rare_cultivars,
}

violations contains {"rule_id": "O6_1A.ARABLE_DIVERSIFICATION.CEREAL_MAIZE_MAX_75", "message": msg} if {
	input.land.arable_area_ha > 5
	share := (100 * cereal_maize_area) / input.land.arable_area_ha
	share > 75
	msg := sprintf("Getreide und Mais betragen %.2f %% der Ackerfläche und überschreiten 75 %%", [share])
}

violations contains {"rule_id": "O6_1A.ARABLE_DIVERSIFICATION.SINGLE_CROP_MAX_55", "message": msg} if {
	input.land.arable_area_ha > 5
	p := input.land.parcels[_]
	p.land_use == "arable"
	crop := p.crop.crop_name
	not single_crop_exempt(crop)
	area := crop_area(crop)
	share := (100 * area) / input.land.arable_area_ha
	share > 55
	msg := sprintf("%s beträgt %.2f %% der Ackerfläche und überschreitet 55 %%", [crop, share])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_RETENTION.MAX_CONVERSION_1HA", "message": msg} if {
	converted := object.get(input.land, "grassland_converted_ha_contract_period", 0)
	new_grass := object.get(input.land, "grassland_newly_established_ha_contract_period", 0)
	net := converted - new_grass
	net > 1
	msg := sprintf("Netto-Grünlandumwandlung %.2f ha überschreitet die Toleranz von 1,00 ha", [net])
}

violations contains {"rule_id": "O6_1A.TRAINING.BIODIVERSITY_3H_BY_2025", "message": "Biodiversitätsweiterbildung von mindestens 3 Stunden bis 31.12.2025 fehlt"} if {
	year >= 2026
	hours := object.get(input.documentation, "biodiversity_training_hours_since_2022", 0)
	hours < 3
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.MIN_7_PERCENT", "message": msg} if {
	input.land.arable_area_ha > 2
	required := 0.07 * input.land.arable_area_ha
	eligible := arable_biodiversity_credit_area
	eligible < required
	msg := sprintf("Acker-Biodiversitätsflächen %.2f ha unterschreiten 7 %% von %.2f ha", [eligible, input.land.arable_area_ha])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_BIODIVERSITY.MIN_7_PERCENT", "message": msg} if {
	mown := object.get(input.land, "mown_grassland_area_excluding_mountain_meadows_ha", input.land.grassland_area_ha)
	mown > 2
	required := 0.07 * mown
	eligible := grassland_biodiversity_credit_area
	eligible < required
	msg := sprintf("Grünland-Biodiversitätsflächen %.2f ha unterschreiten 7 %% von %.2f ha", [eligible, mown])
}

violations contains {"rule_id": "O6_1A.ARABLE_FIELD_BLOCK.MIN_0_15HA", "message": msg} if {
	input.land.arable_area_ha >= 10
	block := object.get(input.land, "field_blocks", [])[_]
	block.land_use == "arable"
	block.area_ha > 5
	credit := object.get(block, "biodiversity_credit_area_ha", 0)
	credit < 0.15
	msg := sprintf("Acker-Feldstück %s über 5 ha hat nur %.2f ha anrechenbare Biodiversitätsfläche", [block.field_block_id, credit])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_FIELD_BLOCK.MIN_0_15HA", "message": msg} if {
	mown := object.get(input.land, "mown_grassland_area_excluding_mountain_meadows_ha", input.land.grassland_area_ha)
	mown >= 10
	block := object.get(input.land, "field_blocks", [])[_]
	block.land_use == "grassland"
	object.get(block, "mown_area_excluding_mountain_meadows_ha", block.area_ha) > 5
	credit := object.get(block, "biodiversity_credit_area_ha", 0)
	credit < 0.15
	msg := sprintf("Grünland-Feldstück %s über 5 ha hat nur %.2f ha anrechenbare Biodiversitätsfläche", [block.field_block_id, credit])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.SEED_MIX", "message": msg} if {
	p := arable_biodiversity_parcels[_]
	not object.get(p.constraints.biodiversity_area, "legacy_seed_mix_exemption", false)
	mix := object.get(p.constraints.biodiversity_area, "seed_mix", {})
	object.get(mix, "insect_pollinated_partners", 0) < 7
	msg := sprintf("Acker-Biodiversitätsfläche %s hat weniger als 7 insektenblütige Mischungspartner", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.SEED_MIX_FAMILIES", "message": msg} if {
	p := arable_biodiversity_parcels[_]
	not object.get(p.constraints.biodiversity_area, "legacy_seed_mix_exemption", false)
	mix := object.get(p.constraints.biodiversity_area, "seed_mix", {})
	object.get(mix, "plant_families", 0) < 3
	msg := sprintf("Acker-Biodiversitätsfläche %s hat weniger als 3 Pflanzenfamilien", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.NON_INSECT_MAX_10", "message": msg} if {
	p := arable_biodiversity_parcels[_]
	mix := object.get(p.constraints.biodiversity_area, "seed_mix", {})
	object.get(mix, "non_insect_pollinated_percent", 0) > 10
	msg := sprintf("Acker-Biodiversitätsfläche %s überschreitet 10 %% nicht insektenblütige Mischungspartner", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.SOWING_BY_MAY_15", "message": msg} if {
	p := arable_biodiversity_parcels[_]
	date := object.get(p.constraints.biodiversity_area, "sowing_date", "")
	date != ""
	month_day(date) > "05-15"
	msg := sprintf("Acker-Biodiversitätsfläche %s wurde nach dem 15. Mai angesät", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.NO_PSM_OR_FERTILIZER", "message": msg} if {
	p := arable_biodiversity_parcels[_]
	p.operations.psm_used
	not object.get(p.operations, "psm_bio_regulation_only", false)
	msg := sprintf("Acker-Biodiversitätsfläche %s verwendet unzulässige Pflanzenschutzmittel", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.NO_PSM_OR_FERTILIZER", "message": msg} if {
	p := arable_biodiversity_parcels[_]
	total_n(p) > 0
	msg := sprintf("Acker-Biodiversitätsfläche %s wurde gedüngt", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.MAX_TWO_USES", "message": msg} if {
	p := arable_biodiversity_parcels[_]
	uses := object.get(p.operations, "biodiversity_use_count", 0)
	uses > 2
	not dry_2026_third_use_exception(p)
	msg := sprintf("Acker-Biodiversitätsfläche %s überschreitet maximal zwei Nutzungen pro Jahr", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.ARABLE_BIODIVERSITY.BEFORE_AUG_1_LIMIT", "message": msg} if {
	early := object.get(input.land, "arable_biodiversity_area_used_before_august_1_ha", 0)
	limit := 0.25 * arable_biodiversity_total_area
	early > limit
	not dry_2026_op_exception_area_ok
	msg := sprintf("Vor dem 1. August genutzte Acker-DIV-Fläche %.2f ha überschreitet 25 %%", [early])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_BIODIVERSITY.NO_PSM", "message": msg} if {
	p := grassland_biodiversity_parcels[_]
	p.operations.psm_used
	not object.get(p.operations, "psm_bio_regulation_only", false)
	msg := sprintf("Grünland-Biodiversitätsfläche %s verwendet unzulässige Pflanzenschutzmittel", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_DIVSZ.FIRST_USE_DATE", "message": msg} if {
	p := grassland_biodiversity_parcels[_]
	biodiv_code(p, "DIVSZ")
	first := object.get(p.operations, "first_use_date", "")
	first != ""
	not divsz_date_ok(p, first)
	msg := sprintf("DIVSZ-Fläche %s wurde zu früh genutzt", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_DIVNFZ.NINE_WEEKS", "message": msg} if {
	p := grassland_biodiversity_parcels[_]
	biodiv_code(p, "DIVNFZ")
	days := object.get(p.operations, "use_free_period_days_after_first_use", 0)
	days < 63
	not dry_2026_grassland_divnfz_op_exception(p, days)
	msg := sprintf("DIVNFZ-Fläche %s hat weniger als 63 nutzungsfreie Tage", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_DIVAGF.LAST_USE_AUG_15", "message": msg} if {
	p := grassland_biodiversity_parcels[_]
	biodiv_code(p, "DIVAGF")
	last := object.get(p.operations, "last_use_date", "")
	last != ""
	month_day(last) > "08-15"
	msg := sprintf("DIVAGF-Fläche %s wurde nach dem 15. August genutzt", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.DIVRS.REGIONAL_SEED_MIX", "message": msg} if {
	p := biodiversity_parcels[_]
	biodiv_code(p, "DIVRS")
	mix := object.get(p.constraints.biodiversity_area, "seed_mix", {})
	object.get(mix, "species_count", 0) < 30
	msg := sprintf("DIVRS-Fläche %s hat weniger als 30 Arten", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.DIVRS.REGIONAL_SEED_MIX", "message": msg} if {
	p := biodiversity_parcels[_]
	biodiv_code(p, "DIVRS")
	mix := object.get(p.constraints.biodiversity_area, "seed_mix", {})
	object.get(mix, "plant_families", 0) < 7
	msg := sprintf("DIVRS-Fläche %s hat weniger als 7 Pflanzenfamilien", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.DIVRS.SOWING_RATE", "message": msg} if {
	p := biodiversity_parcels[_]
	biodiv_code(p, "DIVRS")
	mix := object.get(p.constraints.biodiversity_area, "seed_mix", {})
	object.get(mix, "sowing_rate_kg_per_ha", 0) < 20
	msg := sprintf("DIVRS-Fläche %s unterschreitet 20 kg/ha Saatstärke", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.DIVRS.MAX_SINGLE_SPECIES_5_PERCENT", "message": msg} if {
	p := biodiversity_parcels[_]
	biodiv_code(p, "DIVRS")
	mix := object.get(p.constraints.biodiversity_area, "seed_mix", {})
	not object.get(mix, "ecotype_seed_exception", false)
	object.get(mix, "max_single_species_weight_percent", 0) > 5
	msg := sprintf("DIVRS-Fläche %s überschreitet 5 Gewichtsprozent je Art", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_DIVRS.SITE", "message": msg} if {
	p := grassland_biodiversity_parcels[_]
	biodiv_code(p, "DIVRS")
	object.get(p.constraints, "average_grassland_score", 0) < 30
	msg := sprintf("Grünland-DIVRS-Fläche %s unterschreitet Grünlandzahl 30", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.GRASSLAND_DIVRS.SITE", "message": msg} if {
	p := grassland_biodiversity_parcels[_]
	biodiv_code(p, "DIVRS")
	p.slope_percent >= 18
	msg := sprintf("Grünland-DIVRS-Fläche %s hat mindestens 18 %% Hangneigung", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.WILD_HERB_BREEDING.REQUIREMENTS", "message": msg} if {
	p := object.get(input.land, "parcels", [])[_]
	has_code(p, "WB")
	not is_cereal(p)
	msg := sprintf("WB-Schlag %s ist keine Getreidefläche", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.WILD_HERB_BREEDING.REQUIREMENTS", "message": msg} if {
	p := object.get(input.land, "parcels", [])[_]
	has_code(p, "WB")
	object.get(p.operations, "row_spacing_cm", 0) < 20
	msg := sprintf("WB-Schlag %s unterschreitet 20 cm Reihenabstand", [p.parcel_id])
}

violations contains {"rule_id": "O6_1A.PHEROMONE_BEET.MIN_15_PER_HA", "message": msg} if {
	p := object.get(input.land, "parcels", [])[_]
	has_code(p, "PZR")
	density := object.get(p.operations, "pheromone_traps_per_ha", 0)
	density < 15
	msg := sprintf("PZR-Schlag %s hat weniger als 15 Pheromonfallen je Hektar", [p.parcel_id])
}

classification := {
	"is_livestock_holding": is_livestock_holding,
	"rgve_total": rgve_total,
	"forage_area_ha": forage_area,
}

is_livestock_holding if {
	forage_area > 0
	rgve_total / forage_area >= 0.30
}

premium_rates := tables.premium_rates.from_2025

eligible_arable_biodiversity_extra_area_ha := max([0, min([pure_arable_biodiversity_area, 0.20 * input.land.arable_area_ha]) - (0.07 * input.land.arable_area_ha)])

eligible_grassland_biodiversity_extra_area_ha := max([0, min([pure_grassland_biodiversity_area, 0.20 * mown_grassland_area]) - (0.07 * mown_grassland_area)])

eligible_rare_cultivars contains p.parcel_id if {
	p := object.get(input.land, "parcels", [])[_]
	has_code(p, "SLK")
	slk_entry(p)
	object.get(p.operations, "sort_pure", false)
}

eligible_bhg_parcels contains p.parcel_id if {
	p := object.get(input.land, "parcels", [])[_]
	has_code(p, "BHG")
	contains_name(tables.crop_groups.bhg, p.crop.crop_name)
}

slk_entry(p) if {
	entry := tables.rare_cultivars[_]
	lower(entry.cultivar) == lower(object.get(p.crop, "cultivar", ""))
	object.get(entry, "valid_from_year", null) == null
}

slk_entry(p) if {
	entry := tables.rare_cultivars[_]
	lower(entry.cultivar) == lower(object.get(p.crop, "cultivar", ""))
	year >= entry.valid_from_year
}

cereal_maize_area := sum([p.area_ha | p := object.get(input.land, "parcels", [])[_]; p.land_use == "arable"; is_cereal_or_maize(p)])

crop_area(crop) := sum([p.area_ha | p := object.get(input.land, "parcels", [])[_]; p.land_use == "arable"; lower(p.crop.crop_name) == lower(crop)])

forage_area := input.land.grassland_area_ha + sum([p.area_ha | p := object.get(input.land, "parcels", [])[_]; p.land_use == "arable"; contains_name(tables.crop_groups.forage_crops, p.crop.crop_name)])

rgve_total := sum([group.gve | group := object.get(input.livestock, "species_groups", [])[_]; group.gve != null])

mown_grassland_area := object.get(input.land, "mown_grassland_area_excluding_mountain_meadows_ha", input.land.grassland_area_ha)

arable_biodiversity_total_area := sum([p.area_ha | p := arable_biodiversity_parcels[_]])

pure_arable_biodiversity_area := sum([p.area_ha | p := arable_biodiversity_parcels[_]; not biodiversity_from_other_measure(p); not has_code(p, "GLÖZ4")])

arable_biodiversity_credit_area := sum([p.area_ha | p := arable_biodiversity_parcels[_]; not has_code(p, "K20")])

grassland_biodiversity_credit_area := sum([p.area_ha | p := grassland_biodiversity_parcels[_]])

pure_grassland_biodiversity_area := sum([p.area_ha | p := grassland_biodiversity_parcels[_]; not biodiversity_from_other_measure(p); not has_code(p, "GLÖZ4")])

arable_biodiversity_parcels contains p if {
	p := object.get(input.land, "parcels", [])[_]
	p.land_use == "arable"
	p.constraints.biodiversity_area.is_biodiversity_area
}

grassland_biodiversity_parcels contains p if {
	p := object.get(input.land, "parcels", [])[_]
	p.land_use == "grassland"
	p.constraints.biodiversity_area.is_biodiversity_area
}

biodiversity_parcels contains p if {
	p := arable_biodiversity_parcels[_]
}

biodiversity_parcels contains p if {
	p := grassland_biodiversity_parcels[_]
}

is_cereal_or_maize(p) if {
	is_cereal(p)
}

is_cereal_or_maize(p) if {
	lower(p.crop.crop_name) == "mais"
}

is_cereal_or_maize(p) if {
	p.crop.crop_category == "maize"
}

is_cereal(p) if {
	contains_name(tables.crop_groups.cereals, p.crop.crop_name)
}

single_crop_exempt(crop) if {
	contains_name(tables.crop_groups.forage_crops, crop)
}

single_crop_exempt(crop) if {
	year >= 2025
	lower(crop) == "grünbrache"
}

single_crop_exempt(crop) if {
	year >= 2025
	lower(crop) == "spargel"
}

biodiv_code(p, code) if {
	has_code(p, code)
}

biodiv_code(p, code) if {
	object.get(p.constraints.biodiversity_area, "variant_code", "") == code
}

has_code(p, code) if {
	codes := object.get(p, "codes", [])
	some c in codes
	c == code
}

biodiversity_from_other_measure(p) if {
	has_code(p, "NAT")
}

biodiversity_from_other_measure(p) if {
	has_code(p, "EBW")
}

biodiversity_from_other_measure(p) if {
	has_code(p, "BAW")
}

biodiversity_from_other_measure(p) if {
	has_code(p, "AG")
}

biodiversity_from_other_measure(p) if {
	has_code(p, "N2")
}

total_n(p) := n if {
	f := object.get(p.operations, "fertilizer", {})
	n := number_or_zero(object.get(f, "mineral_n_kg_per_ha", 0)) + number_or_zero(object.get(f, "organic_n_kg_per_ha", 0))
}

number_or_zero(value) := value if {
	is_number(value)
}

number_or_zero(value) := 0 if {
	not is_number(value)
}

month_day(date) := substring(date, 5, 5)

divsz_date_ok(p, first) if {
	month_day(first) >= "06-15"
	object.get(p.operations, "comparable_second_cut_occurred", false)
}

divsz_date_ok(_, first) if {
	month_day(first) >= "07-15"
}

divsz_date_ok(p, first) if {
	year == 2026
	object.get(p, "op_code_no_ubb_premium", false)
	object.get(p.operations, "comparable_second_cut_occurred", false)
	month_day(first) >= object.get(p.operations, "dry_2026_earliest_use_month_day", "05-25")
}

dry_2026_op_exception_area_ok if {
	year == 2026
	area := object.get(input.land, "arable_biodiversity_area_used_before_august_1_without_ubb_premium_ha", 0)
	early := object.get(input.land, "arable_biodiversity_area_used_before_august_1_ha", 0)
	regular_limit := 0.25 * arable_biodiversity_total_area
	early <= regular_limit + area
}

dry_2026_third_use_exception(p) if {
	year == 2026
	object.get(p.operations, "biodiversity_use_count", 0) == 3
	object.get(p, "op_code_no_ubb_premium", false)
	not has_code(p, "NAT")
	not has_code(p, "EBW")
}

dry_2026_grassland_divnfz_op_exception(p, days) if {
	year == 2026
	object.get(p, "op_code_no_ubb_premium", false)
	days >= 49
}

contains_name(list, name) if {
	some x in list
	lower(x) == lower(name)
}
