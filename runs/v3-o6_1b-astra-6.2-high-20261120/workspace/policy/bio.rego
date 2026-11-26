package oepul.o6_1b

import rego.v1

# Die Teilergebnisse beziehen sich jeweils auf eine benannte Anspruchsvoraussetzung.
# Fehlende Beobachtungen ergeben keine positive Entscheidung.
tab := data.bio_tables
year := input.farm.year
bio_land := input.land.oepul
contract := input.farm.oepul
arable := input.land.arable_area_ha
mown := bio_land.mown_grassland_without_mountain_meadows_ha

rate(position, y) := row.eur if {
	y >= 2023
	y <= 2028
	starts := [r.ab | some r in tab.praemiensaetze; r.position == position; r.ab <= y]
	some row in tab.praemiensaetze
	row.position == position
	row.ab == max(starts)
}

contract_years := row.jahre if {
	some row in tab.vertragsjahre
	row.beginn == contract.first_bio_year
}

ordinary_entry_timely if {
	contract_years > 0
	is_string(contract.application_date)
	contract.application_date <= sprintf("%d-12-31", [contract.first_bio_year - 1])
}

minimum_size_met if contract.first_oepul_year < year

minimum_size_met if {
	contract.first_oepul_year == year
	bio_land.protected_cultivation_at_ha >= 0.5
}

minimum_size_met if {
	contract.first_oepul_year == year
	bio_land.minimum_size_basis_at_ha >= 1.5
}

control_contract_met if {
	contract.registered_food_authority
	contract.recognised_control_body
	is_string(contract.control_start)
	contract.control_start <= sprintf("%d-01-01", [contract.first_bio_year])
	contract.control_continuous_through >= sprintf("%d-12-31", [year])
	year >= contract.first_bio_year
	year <= 2028
}

partial_separation_met if {
	contract.organic_sector in {"arable_grassland", "wine_fruit_hops"}
	contract.separate_facilities_and_land
	contract.separate_crop_sectors
	contract.separate_input_storage
}

household_exception_met if {
	input.livestock.oepul.household_pigs <= 2
	input.livestock.oepul.household_hens <= 10
	input.livestock.oepul.other_nonorganic_household_animals == 0
	input.livestock.oepul.separate_household_feed
}

mixed_equids if {
	input.livestock.oepul.organic_equids > 0
	input.livestock.oepul.conventional_equids > 0
}

rgve_factor(category) := r.faktor if {
	some r in tab.viehschluessel
	r.kategorie == category
	r.einheit == "RGVE"
}

stock_contribution(g) := 0 if g.qualifies_for_bio_rgve == false

else := n if {
	g.qualifies_for_bio_rgve
	is_number(g.annual_assessable_count)
	g.annual_assessable_count >= 0
	n := g.annual_assessable_count * rgve_factor(g.category)
}

stock_density := sum(amounts) / forage if {
	groups := input.livestock.species_groups
	amounts := [stock_contribution(g) | some g in groups]
	count(amounts) == count(groups)
	forage := input.land.grassland_area_ha + bio_land.arable_forage_ha
	forage > 0
}

stock_class := "ohne" if stock_density < 0.30

else := "mittel" if stock_density < 1.40

else := "hoch" if stock_density >= 1.40

grass_base_rate := rate(sprintf("gruen_basis_%s", [stock_class]), year)

grassland_conversion_excess := max([0, (bio_land.chargeable_grassland_conversion_ha - bio_land.eligible_grassland_creation_ha) - 1])

psm_declaration_code(kind, y) := r.code if {
	y >= 2023
	y <= 2025
	some r in tab.psm_codes
	r.mittel == kind
}

required_div(area) := area * 0.07 if area > 2

else := 0 if area >= 0

arable_div_required_ha := required_div(arable)
grass_div_required_ha := required_div(mown)

grass_credit_ha := 0 if arable > 10

else := 0 if bio_land.additional_qualifying_grass_div_ha == 0

else := min([bio_land.additional_qualifying_grass_div_ha, max([0, bio_land.grass_div_ha - grass_div_required_ha])]) if arable < 10

# Bei genau 10 ha widersprechen sich SRL und Informationsblatt. Unstrittige
# Fälle mit ausreichender Ackerfläche bleiben entscheidbar.
arable_div_met if bio_land.arable_div_ha >= arable_div_required_ha
arable_div_met if bio_land.arable_div_ha + grass_credit_ha >= arable_div_required_ha
grass_div_met if bio_land.grass_div_ha >= grass_div_required_ha

required_field_div(total, field) := 0.15 if {
	total >= 10
	field > 5
}

else := 0 if {
	total >= 0
	field >= 0
}

field_shortfall[f.id] := max([0, (((required_field_div(arable, f.basis_ha) * 10000) - (f.div_ha * 10000)) - (f.gloez_lse_ha * 10000)) - (af * 10000)]) / 10000 if {
	some f in bio_land.fields
	f.use == "arable"
	af := agroforestry_credit(f, year)
}

field_shortfall[f.id] := max([0, ((required_field_div(mown, f.basis_ha) * 10000) - (f.div_ha * 10000)) - (f.gloez_lse_ha * 10000)]) / 10000 if {
	some f in bio_land.fields
	f.use == "grassland"
}

agroforestry_credit(f, y) := f.assigned_1c_strip_ha if y >= 2025

else := 0 if y < 2025

div_bonus_area(basis, pure) := max([0, min([pure, basis * 0.20]) - (basis * 0.07)])
arable_extra_div_ha := div_bonus_area(arable, bio_land.pure_arable_div_ha)
grass_extra_div_ha := div_bonus_area(mown, bio_land.pure_grass_div_ha)

density_bonus(basis, areas) if {
	basis > 0
	count([a | some a in areas; a > 0.05]) >= ceil(basis / 3)
}

arable_density_bonus_ha := min([arable * 0.20, bio_land.pure_arable_div_ha]) if density_bonus(arable, bio_land.arable_div_plot_sizes_ha)
grass_density_bonus_ha := min([mown * 0.20, bio_land.pure_grass_div_ha]) if density_bonus(mown, bio_land.grass_div_plot_sizes_ha)

crop_exempt(name, _) if name in tab.ackerfutter

crop_exempt(name, y) if {
	y >= 2025
	name in {"Grünbrache", "Spargel"}
}

excess_cereal_maize_ha := max([0, bio_land.cereal_and_maize_ha - (arable * 0.75)]) if arable > 5

single_crop_excess[c.botanical_species] := c.area_ha - (arable * 0.55) if {
	arable > 5
	some c in bio_land.main_crops
	is_string(c.use)
	not crop_exempt(c.use, year)
	c.area_ha > arable * 0.55
}

forage_crop(c) if c in tab.ackerfutter
cereal(c) if c in tab.getreide
vegetable_or_strawberry(c) if c in tab.feldgemuese
vegetable_or_strawberry(c) if c == "Erdbeeren"

vegetable_or_strawberry(c) if {
	some group in tab.feldgemuese
	c in split(group, "/")
}

special_use_excluded(c) if c in tab.spezialausnahmen

fruit(c, y) if {
	some r in tab.obst
	c in object.get(r, "bezeichnungen", [r.name])
	r.ab <= y
}

crop_position(c) := r.position if {
	some r in tab.kulturgruppen
	r.kultur == c
}

else := "bhg" if c in tab.bhg

circular_crop(c) if {
	some r in tab.kulturgruppen
	r.kultur == c
	r.kreislauf
}

arable_circular_rate := rate(position, year) if {
	year >= 2025
	stock_density < 1.40
	position := {"ohne": "kreislauf_acker_ohne", "mittel": "kreislauf_acker_mit"}[stock_class]
	bio_land.circular_arable_ha * 100 > arable * 15
	arable > 0
}

grass_circular_rate := rate("kreislauf_gruen", year) if {
	stock_class == "mittel"
	mown > 0
	bio_land.div_or_species_rich_grass_ha > mown * 0.08
}

max_crop_rate(p) := max([rate(pos, year) | some pos in p.eligible_crop_positions])
eligible_crop_area := sum([p.area_ha | some p in input.land.parcels; p.land_use == "arable"; max_crop_rate(p) > 0])
high_rate_area(v) := sum([p.area_ha | some p in input.land.parcels; p.land_use == "arable"; max_crop_rate(p) > v])

# Je Schlag zählt nur die höher dotierte Erst-/Zweitkultur. Bei gleicher
# Prämienstufe wird erst die gesamte Stufenfläche zusammengefasst.
crop_bonus_eur := sum(amounts) if {
	is_array(input.land.parcels)
	every p in input.land.parcels { crop_record_complete(p) }
	eligible_crop_area + max([0, bio_land.arable_div_ha - (arable * 0.07)]) > arable * 0.15
	rates := {max_crop_rate(p) | some p in input.land.parcels; p.land_use == "arable"}
	amounts := [amount |
		some v in rates
		ha := sum([p.area_ha | some p in input.land.parcels; p.land_use == "arable"; max_crop_rate(p) == v])
		amount := v * min([ha, max([0, (arable * 0.40) - high_rate_area(v)])])
	]
}

bee_premium_eur := 0 if input.livestock.oepul.sector_programme_feed_or_wax

else := first + rest if {
	input.livestock.oepul.sector_programme_feed_or_wax == false
	n := input.livestock.oepul.claimed_eligible_colonies
	n >= 0
	first := min([100, n]) * rate("volk_1", year)
	rest := max([0, min([900, n]) - 100]) * rate("volk_2", year)
}

eligible_colony(h) if {
	h.controlled_organic
	h.combs_at_cherry_blossom >= 6
	h.brood_combs
	h.laying_queen
	h.economic_colony
}

tier_area(t, ha) := max([0, ha - t.von]) if t.bis == null

else := max([0, min([ha, t.bis]) - t.von])

modulation(ha) := sum([part | some t in tab.modulation; part := tier_area(t, ha) * t.faktor]) / ha if ha > 0
modulation_factor := modulation(bio_land.home_modulation_area_ha)
loss_tolerance_ha := max([0.50, min([5, 0.05 * bio_land.prior_committed_ha])])
repay_area_ha := bio_land.chargeable_loss_ha if bio_land.chargeable_loss_ha > loss_tolerance_ha

else := 0 if bio_land.chargeable_loss_ha <= loss_tolerance_ha

new_area_payable_ha := bio_land.new_uncommitted_ha if year in {2024, 2025}

else := min([bio_land.new_uncommitted_ha, max([0, max([5, bio_land.bio_2025_ha * 0.50]) - bio_land.additions_already_counted_ha])]) if {
	year >= 2026
	year <= 2028
}

parcel_cap(group, y) := r if {
	some r in tab.obergrenzen
	r.bereich == group
	y >= r.ab
	y <= r.bis
}

combination(left, right) := r.zelle if {
	some r in tab.kombinationen
	r.von == left
	r.mit == right
}

project_combination(left, right) := r.zelle if {
	some r in tab.projektkombinationen
	r.von == left
	r.mit == right
}

allowed_switch(from, to, y) if {
	some r in tab.wechsel
	r.von == from
	r.nach == to
	y <= r.bis_jahr
	y >= 2023
}

crop_record_complete(p) if p.land_use != "arable"

crop_record_complete(p) if {
	p.land_use == "arable"
	is_number(p.area_ha)
	is_array(p.eligible_crop_positions)
	every pos in p.eligible_crop_positions { pos in {"feldfutter", "leguminosen", "kreuzbluetler", "sonnenblume", "bhg"} }
}
