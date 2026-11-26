package oepul.o6_2

import rego.v1

t := data.o6_2_tables
year := input.farm.year
app := input.farm.application

contract := row if {
	some row in t.contracts
	row.start_year == app.start_year
}

valid_date(d) if {
	regex.match(`^[0-9]{4}-[0-9]{2}-[0-9]{2}$`, d)
	is_number(time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"])))
}

entry_on_time if {
	valid_date(app.application_date)
	app.application_date < contract.start
}

bio_compatible if app.bio_scope == "none"

bio_compatible if {
	app.bio_scope == "wine_fruit_hops"
	app.separate_units
	app.separate_crop_sectors
	app.separate_stores
}

combination_ok if {
	app.ubb
	bio_compatible
}

switch_allowed if {
	some row in t.switches
	row.from == "2"
	row.to == app.switch_to
	valid_date(app.switch_date)
	contract.start <= app.switch_date
	app.switch_date <= sprintf("%d-12-31", [row.through])
}

applicant_ok if {
	a := input.farm.applicant
	a.legal_form in t.applicant_forms
	a.public_control == false
	is_number(a.public_share_pct)
	a.public_share_pct <= 25
	a.active_farmer
	a.agricultural_activity
	a.own_name_and_account
	a.disposal_right
}

minimum_size_ok if year > app.first_oepul_year

minimum_size_ok if {
	year == app.first_oepul_year
	input.land.protected_cultivation_at_ha >= 0.5
}

minimum_size_ok if {
	year == app.first_oepul_year
	input.land.mfa_minimum_size_area_at_ha >= 1.5
}

access_consequence(first_year) := "kein Vertrag" if first_year == true
access_consequence(first_year) := "keine Jahresprämie" if first_year == false

forage_crop(name) if {
	some crop in t.forage_crops
	lower(name) == lower(crop)
}

crop_label(p, "Getreide") if p.crop.crop_name in t.cereals
crop_label(p, "Kein Getreide") if p.crop.crop_name in t.non_cereals

crop_label(p, "Kein Getreide") if {
	p.crop.crop_name == "Gemenge"
	p.crop.cereal_share_pct < 50
}

crop_label(p, "Feldgemüse") if p.crop.crop_name in t.vegetables
crop_label(p, "Ackerfutter") if forage_crop(p.crop.crop_name)
crop_label(p, "Obst") if year >= t.fruit_since[p.crop.crop_name]

crop_label(p, "Obst") if {
	p.crop.crop_name == "Walnüsse"
	year >= t.fruit_since.Walnuss
}

crop_classes(p) := {label |
	some label in {"Getreide", "Kein Getreide", "Feldgemüse", "Ackerfutter", "Obst"}
	crop_label(p, label)
}

tariff_group(p) := "grassland" if p.land_use == "grassland"

tariff_group(p) := "forage" if {
	p.land_use == "arable"
	forage_crop(p.crop.crop_name)
	p.crop.is_second_crop == false
}

known_nonforage(p) if {
	is_string(p.crop.crop_name)
	not forage_crop(p.crop.crop_name)
}

known_nonforage(p) if {
	p.crop.crop_category in {"cereal", "maize", "oilseed", "root", "vegetable"}
	not forage_crop(p.crop.crop_name)
}

tariff_group(p) := "arable" if {
	p.land_use == "arable"
	known_nonforage(p)
}

tariff_group(p) := "arable" if {
	p.land_use == "arable"
	forage_crop(p.crop.crop_name)
	p.crop.is_second_crop
}

tariff_group(p) := "permanent" if {
	p.land_use == "special_crop"
	p.crop.crop_category in {"vineyard", "hop"}
}

tariff_group(p) := "permanent" if {
	p.land_use == "special_crop"
	p.crop.crop_category == "orchard"
	crop_label(p, "Obst")
}

# MFA-Futterfläche, unabhängig vom Zahlungsantrag für die Maßnahme.
forage_part(p) := 0 if {
	is_string(p.mfa.country)
	p.mfa.country != "AT"
}

else := 0 if p.mfa.declared == false

else := 0 if p.land_use in {"alpine_pasture", "other", "special_crop"}

else := 0 if tariff_group(p) == "arable"

else := p.area_ha if {
	p.mfa.country == "AT"
	p.mfa.declared
	tariff_group(p) in {"forage", "grassland"}
	is_number(p.area_ha)
	p.area_ha >= 0
}

forage_ha := sum(parts) if {
	parcels := input.land.parcels
	is_array(parcels)
	parts := [forage_part(p) | some p in parcels]
	count(parts) == count(parcels)
}

animal_class(g) := "Zwergrind" if {
	g.species == "cattle"
	g.breed in t.dwarf_breeds
}

animal_class(g) := "Rind" if {
	g.species == "cattle"
	is_string(g.breed)
	not g.breed in t.dwarf_breeds
}

animal_class(g) := g.category if {
	g.species == "sheep_goats"
	g.category in {"Schaf", "Ziege"}
}

animal_class(g) := "Kleine Equiden" if {
	g.species == "horses"
	is_number(g.breed_height_m)
	is_number(g.breed_adult_weight_kg)
	g.breed_height_m <= 1.48
	g.breed_adult_weight_kg <= 300
}

animal_class(g) := "Große Equiden" if {
	g.species == "horses"
	g.breed_height_m > 1.48
	is_number(g.breed_height_m)
}

animal_class(g) := "Große Equiden" if {
	g.species == "horses"
	g.breed_adult_weight_kg > 300
	is_number(g.breed_adult_weight_kg)
}

wild_group(g) if {
	g.species == "other"
	g.category in {"Rotwild", "Damwild", "Anderes Zuchtwild", "Neuweltkamel"}
}

animal_class(g) := g.category if {
	wild_group(g)
	g.captive_on_agricultural_land
}

assessment_count(g) := g.annual_mean_count if {
	g.species == "cattle"
	g.count_basis == "cattle_database_daily"
	is_number(g.annual_mean_count)
}

assessment_count(g) := g.annual_mean_count if {
	g.species != "cattle"
	g.count_basis == "average_list"
	is_number(g.annual_mean_count)
}

assessment_count(g) := g.animal_count if {
	g.species != "cattle"
	g.count_basis == "april_1"
	g.fluctuating_stock == false
	is_number(g.animal_count)
}

below_upper(_, upper) if upper == null
below_upper(value, upper) if value < upper

pig_gve_per_head(category) := row.gve_per_head if {
	some row in t.pig_gve
	row.category == category
}

hundredths_rgve(g) := 0 if {
	is_string(g.country)
	g.country != "AT"
}

else := 0 if g.species in {"poultry", "rabbits"}

else := 0 if g.species == "pigs"

else := 0 if {
	g.species == "other"
	g.category == "Sonstige Nicht-RGVE"
}

else := 0 if {
	wild_group(g)
	g.captive_on_agricultural_land == false
}

else := n * round(row.rgve_per_head * 100) if {
	g.country == "AT"
	n := assessment_count(g)
	n >= 0
	some row in t.rgve_factors
	row.group == animal_class(g)
	is_number(g.age_months)
	g.age_months >= row.age_months_from
	below_upper(g.age_months, row.age_months_below)
}

animal_contribution(g) := hundredths_rgve(g) / 100

herd_hundredths := sum(parts) if {
	groups := input.livestock.species_groups
	is_array(groups)
	parts := [hundredths_rgve(g) | some g in groups]
	count(groups) == count(parts)
}

rgve := herd_hundredths / 100
density := herd_hundredths / (forage_ha * 100) if forage_ha > 0

# Amtliche RGVE-Faktoren haben höchstens zwei Dezimalstellen. Direktvergleich
# in Hundertsteln vermeidet eine Grenzentscheidung aus einem gerundeten Quotienten.
stock_band := "none" if {
	forage_ha > 0
	herd_hundredths < forage_ha * 30
}

else := "medium" if {
	forage_ha > 0
	herd_hundredths < forage_ha * 140
}

else := "high" if {
	forage_ha > 0
	herd_hundredths >= forage_ha * 140
}

tariff_band(group) := "all" if group in {"arable", "permanent"}
tariff_band(group) := stock_band if group in {"grassland", "forage"}

npf_crop(name) if {
	some crop in t.npf_crops
	lower(name) == lower(crop)
}

npf_exclusion(p) if {
	year <= 2024
	tariff_group(p) == "forage"
	npf_crop(p.crop.crop_name)
	"NPF" in p.mfa.codes
}

rate(p) := 0 if {
	year >= 2023
	npf_exclusion(p)
}

else := row.eur_per_ha if {
	some row in t.premium_rates
	row.year_from <= year
	year <= row.year_to
	row.group == tariff_group(p)
	row.stock_band == tariff_band(row.group)
	npf_resolved(p)
}

npf_resolved(_) if year >= 2025
npf_resolved(p) if tariff_group(p) != "forage"

npf_resolved(p) if {
	is_string(p.crop.crop_name)
	not npf_crop(p.crop.crop_name)
}

npf_resolved(p) if is_array(p.mfa.codes)

# Jahressätze vor Modulation, Deckelung, Sanktionen und Kombinationsausschlüssen.
base_rates[p.parcel_id] := rate(p) if some p in input.land.parcels

combination_row(measure) := row.cells if {
	some row in t.combination_matrix
	row.measure == measure
}

combination_cell(left, right) := combination_row(left)[right]
combination_note(id) := t.combination_notes[id]

groundwater_base(base) := base * 0.5 if {
	base >= 0
	combination_cell("2", "16") == "a"
}

exclusion(p, "Ausland") if {
	is_string(p.mfa.country)
	p.mfa.country != "AT"
}

exclusion(p, "MFA") if p.mfa.claimed_o6_2 == false
exclusion(p, "MFA") if p.mfa.correctly_identified == false
exclusion(p, "Nutzung") if p.mfa.use in t.excluded_uses
exclusion(p, "Landwirtschaft") if p.mfa.predominantly_agricultural == false
exclusion(p, "GLÖZ-LSE") if p.mfa.gloez_lse
exclusion(p, "Nationalpark") if p.mfa.national_park in {"Neusiedlersee", "Donau-Auen"}
exclusion(p, "Nationalpark") if p.mfa.relevant_park_restrictions
exclusion(p, "Versuchsfläche") if "VF" in p.mfa.codes
exclusion(p, "Versuchsfläche") if p.mfa.approved_trial_precludes_obligation
exclusion(p, "OP") if "OP" in p.mfa.codes
exclusion(p, "OP") if p.mfa.op_for_o6_2

exclusion(p, "Obstqualität") if {
	p.crop.crop_category == "orchard"
	p.crop.high_quality_stock == false
}

exclusion(p, "Kombination") if {
	some m in p.mfa.other_parcel_measures
	m != "2"
	combination_cell("2", m) == ""
}

exclusion(p, "Sonderfläche") if p.mfa.ubb_arable_div
exclusion(p, "Sonderfläche") if p.mfa.protected_pots_or_substrate

exclusion(p, "Sonderfläche") if {
	some c in p.mfa.codes
	c in {"BAW", "AG", "K20"}
}

parcel_exclusions[p.parcel_id] contains reason if {
	some p in input.land.parcels
	some reason in {"Ausland", "MFA", "Nutzung", "Landwirtschaft", "GLÖZ-LSE", "Nationalpark", "Versuchsfläche", "OP", "Obstqualität", "Kombination", "Sonderfläche"}
	exclusion(p, reason)
}
