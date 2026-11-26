package oepul.o6_9

import rego.v1

tables := data.o6_9_tables
year := input.farm.year
annual := input.o6_9

program_year if {
	year >= 2023
	year <= 2028
}

nonnegative(x) if {
	is_number(x)
	x >= 0
}

valid_date(d) if {
	regex.match(`^\d{4}-\d{2}-\d{2}$`, d)
	time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"])) != null
}

in_year(d) if {
	valid_date(d)
	startswith(d, sprintf("%04d-", [year]))
}

base_entry_ok if {
	program_year
	year <= 2027
	timely_prior_application(annual.base_application_date)
}

timely_prior_application(d) if {
	valid_date(d)
	d <= sprintf("%04d-12-31", [year - 1])
}

feed_entry_ok if {
	program_year
	year >= 2025
	annual.base_contract_active == true
	timely_prior_application(annual.feed_application_date)
}

april_day := 17 if year in {2023, 2028}

else := 15

mfa_timely if {
	program_year
	valid_date(annual.mfa_date)
	annual.mfa_date <= sprintf("%04d-04-%02d", [year, april_day])
}

withdrawn_in_year if in_year(annual.withdrawal_date)

rate(category) := row.eur if {
	some row in tables.rates
	row.category == category
	year >= row.from_year
	year <= row.through_year
}

# Eine Meldung je Verfahren entspricht dem bis zum Stichtag wirksamen Stand.
claimed_volume(category) := c.volume_m3 if {
	c := annual.claims[category]
	nonnegative(c.volume_m3)
	in_year(c.date)
	c.date <= sprintf("%04d-11-30", [year])
}

no_annual_claim if {
	annual.claims_complete == true
	is_object(annual.claims)
	every method, claim in annual.claims {
		method in {"trailing_hose", "trailing_shoe", "injection", "separation"}
		nonnegative(claim.volume_m3)
		in_year(claim.date)
	}
	not positive_claim
	no_feeding_participation
}

no_feeding_participation if {
	program_year
	year < 2025
}

no_feeding_participation if annual.feeding.participating == false

positive_claim if {
	some c in ["trailing_hose", "trailing_shoe", "injection", "separation"]
	claimed_volume(c) > 0
}

material_ok(e) if {
	e.material in {"slurry", "liquid_manure"}
	e.originally_liquid == true
}

material_ok(e) if {
	e.material == "digestate"
	e.originally_liquid == true
	e.substrate_proof == true
	is_array(e.substrates)
	count(e.substrates) > 0
	every s in e.substrates {
		checks := tables.substrates[s.name]

		# Das Merkblatt und die SRL weichen bei Maisquellwasser voneinander ab.
		s.name != "Maisquellwasser"
		every requirement in checks { requirement in s.confirmed }
	}
}

eligible_volume(e) := v if {
	material_ok(e)
	nonnegative(e.volume_m3)
	nonnegative(e.ineligible_water_m3)
	e.ineligible_water_m3 <= e.volume_m3
	v := e.volume_m3 - e.ineligible_water_m3
}

equipment_ok(e) if e.ownership == "own"

equipment_ok(e) if {
	e.ownership == "external"
	e.service_evidence == true
}

equipment_ok(e) if {
	e.ownership == "shared"
	e.inspectable_at_participant == true
	e.invoice_to_participants_available == true
}

spread_log_ok(e) if {
	in_year(e.date)
	is_string(e.parcel_id)
	e.parcel_id != ""
	is_string(e.material)
	e.method in {"trailing_hose", "trailing_shoe", "injection"}
	nonnegative(e.volume_m3)
	annual.spreading_chronological == true
}

group_log_ok(entries, recorded_ha) if {
	is_array(entries)
	count(entries) > 0
	first := entries[0]
	is_string(first.crop)
	valid_date(first.date)
	first.method in {"trailing_hose", "trailing_shoe", "injection"}
	nonnegative(first.quantity)
	every row in entries {
		row.crop == first.crop
		row.quantity == first.quantity
		row.date == first.date
		row.method == first.method
		nonnegative(row.area_ha)
	}
	recorded_ha == sum([r.area_ha | some r in entries])
}

eligible_spreading(e) if {
	spread_log_ok(e)
	not invalid_group_for(e.parcel_id)
	e.method in {"trailing_hose", "trailing_shoe", "injection"}
	technique_ok(e)
	equipment_ok(e)
	eligible_volume(e) > 0
	some p in input.land.parcels
	p.parcel_id == e.parcel_id
	p.land_use in {"arable", "grassland"}
	p.country == "AT"
}

eligible_separation(e) if {
	in_year(e.date)
	e.own_cattle_slurry == true
	e.mechanically_separated_on_farm == true
	nonnegative(e.volume_m3)
	equipment_ok(e)
}

annual_activity if {
	some e in annual.spreading
	eligible_spreading(e)
}

annual_activity if {
	some e in annual.separations
	eligible_separation(e)
	e.volume_m3 > 0
}

annual_activity if feeding_ok

fertilisable(p) if {
	p.land_use in {"arable", "grassland"}
	p.country == "AT"
	p.n_demand_napv == true
	p.pure_legumes == false
	p.total_fertilizer_ban == false
}

area_known(p) if {
	not p.land_use in {"arable", "grassland"}
	is_string(p.land_use)
}

area_known(p) if {
	is_string(p.country)
	p.country != "AT"
}

area_known(p) if {
	p.country == "AT"
	nonnegative(p.area_ha)
	is_boolean(p.n_demand_napv)
	is_boolean(p.pure_legumes)
	is_boolean(p.total_fertilizer_ban)
}

fertilisable_ha := sum([p.area_ha | some p in input.land.parcels; fertilisable(p)]) if {
	is_array(input.land.parcels)
	every p in input.land.parcels { area_known(p) }
}

spread_cap_m3 := 50 * fertilisable_ha

# Ein Bestandssatz ist eine disjunkte Anhang-A-Kategorie im Inland.
head_count(g) := g.annual_average if {
	g.species == "cattle"
	nonnegative(g.annual_average)
}

head_count(g) := g.annual_average if {
	g.species != "cattle"
	g.average_list_submitted == true
	nonnegative(g.annual_average)
}

head_count(g) := g.animal_count if {
	g.species != "cattle"
	g.average_list_submitted == false
	g.fluctuating == false
	nonnegative(g.animal_count)
}

animal_factor(g) := row.factor if {
	row := tables.gve[g.gve_category]
	row.species_group == "cattle"
	g.species == "cattle"
	is_string(g.breed)
	g.breed != ""
	dwarf := g.breed in tables.dwarf_breeds
	startswith(g.gve_category, "dwarf_") == dwarf
}

animal_factor(g) := row.factor if {
	row := tables.gve[g.gve_category]
	row.species_group == "pigs"
	g.species == "pigs"
}

animal_factor(g) := row.factor if {
	row := tables.gve[g.gve_category]
	row.species_group == "other"
	not g.species in {"pigs", "cattle"}
	not g.gve_category in {"red_deer", "other_deer", "camelid", "wild_young"}
}

animal_factor(g) := row.factor if {
	row := tables.gve[g.gve_category]
	g.gve_category in {"red_deer", "other_deer", "camelid", "wild_young"}
	g.annex_a_wild_holding == true
}

in_stock_group(g, group) if g.species == group

in_stock_group(g, "rgve") if g.species in {"cattle", "sheep_goats", "horses"}

in_stock_group(g, "rgve") if {
	g.gve_category in object.keys(tables.gve)
	tables.gve[g.gve_category].rgve
}

gve_total(group) := sum([units |
	some g in input.livestock.species_groups
	in_stock_group(g, group)
	g.country == "AT"
	units := head_count(g) * animal_factor(g)
]) if {
	is_array(input.livestock.species_groups)
	every g in input.livestock.species_groups {
		is_string(g.species)
		stock_known(g, group)
	}
}

stock_known(g, group) if not in_stock_group(g, group)

stock_known(g, group) if {
	in_stock_group(g, group)
	is_string(g.country)
	g.country != "AT"
}

stock_known(g, group) if {
	in_stock_group(g, group)
	g.country == "AT"
	nonnegative(head_count(g))
	nonnegative(animal_factor(g))
}

separation_cap_m3 := 20 * gve_total("cattle")

pig_density_met if {
	is_number(input.land.arable_area_ha)
	input.land.arable_area_ha > 0
	gve_total("pigs") >= input.land.arable_area_ha
}

livestock_farm if {
	ha := input.land.grassland_area_ha + input.land.arable_forage_ha
	ha > 0
	gve_total("rgve") >= 0.30 * ha
}

feed_source_ok(i) if {
	i.kind == "compound"
	i.protein_source == "manufacturer"
}

feed_source_ok(i) if {
	i.kind == "individual"
	i.tested == true
	i.protein_source == "analysis"
}

feed_source_ok(i) if {
	i.kind == "individual"
	i.tested == false
	i.protein_source == "literature"
}

within_limit(r, limit) if {
	nonnegative(r.protein_g_kg_88)
	r.protein_g_kg_88 <= tables.protein[limit]
}

finisher(r) if {
	r.category == "finishing"
	nonnegative(r.weight_kg)
	r.weight_kg >= 32
}

finisher(r) if {
	r.category == "unserved_gilt"
	nonnegative(r.weight_kg)
	r.weight_kg >= 50
}

phase_key(w) := "phase_32" if {
	w >= 32
	w < 60
}

else := "phase_60" if {
	w >= 60
	w < 90
}

else := "phase_90" if w >= 90

ration_ok(r) if {
	r.category == "piglet"
	nonnegative(r.weight_kg)
	r.weight_kg >= 8
	r.weight_kg < 32
	within_limit(r, "piglet_mean")
}

ration_ok(r) if {
	r.category == "pregnant"
	within_limit(r, "pregnant")
}

ration_ok(r) if {
	r.category == "served_gilt"
	nonnegative(r.weight_kg)
	r.weight_kg >= 50
	within_limit(r, "pregnant")
}

ration_ok(r) if {
	r.category == "lactating"
	within_limit(r, "lactating")
}

ration_ok(r) if {
	r.category == "boar"
	nonnegative(r.weight_kg)
	r.weight_kg >= 50
	within_limit(r, "boar")
}

ration_ok(r) if finisher(r)

finisher_limits_ok(f) if every r in f.rations { not finisher(r) }

finisher_limits_ok(f) if {
	some r in f.rations
	finisher(r)
	nonnegative(f.finishing_mean_g_kg_88)
	f.finishing_mean_g_kg_88 <= tables.protein.finishing_mean
}

finisher_limits_ok(f) if {
	f.phase_technically_possible == true
	f.phase_actually_used == true
	every r in f.rations { phase_or_other(r) }
}

phase_or_other(r) if not finisher(r)

phase_or_other(r) if {
	finisher(r)
	within_limit(r, phase_key(r.weight_kg))
}

rations_ok(f) if {
	is_array(f.rations)
	count(f.rations) > 0
	every r in f.rations { ration_ok(r) }
	finisher_limits_ok(f)
}

feeding_ok if {
	program_year
	year >= 2025
	f := annual.feeding
	f.participating == true
	f.groundwater_option == false
	pig_density_met
	f.all_pigs_covered == true
	f.recipes_88_available == true
	count(f.ingredients) > 0
	every i in f.ingredients { feed_source_ok(i) }
	rations_ok(f)
}

feed_amount_eur := rate("feeding") * annual.eligible_arable_ha if {
	feeding_ok
	nonnegative(annual.eligible_arable_ha)
	annual.eligible_arable_ha <= input.land.arable_area_ha
}

# Nachweise und Mengen sind je Verfahren auswertbar. Die gemeinsame Grenze hat
# bei mehreren Sätzen keine in den Quellen festgelegte Zuteilungsreihenfolge.
documented_m3(category) := sum([eligible_volume(e) | some e in annual.spreading; e.method == category; eligible_spreading(e)]) if {
	category in {"trailing_hose", "trailing_shoe", "injection"}
	is_array(annual.spreading)
}

documented_m3("separation") := sum([e.volume_m3 | some e in annual.separations; eligible_separation(e)]) if is_array(annual.separations)

claim_basis(c) := min([claimed_volume(c), documented_m3(c)])

claim_basis(c) := 0 if {
	annual.claims_complete == true
	is_object(annual.claims)
	not c in object.keys(annual.claims)
}

separation_amount_eur := min([claim_basis("separation"), separation_cap_m3]) * rate("separation")
spread_basis := {c: claim_basis(c) | some c in ["trailing_hose", "trailing_shoe", "injection"]}
spread_payable_m3 := min([spread_cap_m3, sum([v | some _, v in spread_basis])]) if count(spread_basis) == 3

spread_amount_eur := sum([amount | some c, v in spread_basis; amount := v * rate(c)]) if {
	count(spread_basis) == 3
	sum([v | some _, v in spread_basis]) <= spread_cap_m3
}

spread_amount_eur := spread_payable_m3 * rate(c) if {
	sum([v | some _, v in spread_basis]) > spread_cap_m3
	positive := {method | some method, v in spread_basis; v > 0}
	count(positive) == 1
	some c in positive
}

allocation_review_required if {
	count(spread_basis) == 3
	sum([v | some _, v in spread_basis]) > spread_cap_m3
	count({c | some c, v in spread_basis; v > 0}) > 1
}

# Ein eindeutiger Eurobetrag wird nur für eindeutig bewertbare Nachweise ausgegeben.
review_items contains {"topic": "Ausbringung", "event": i, "reason": "Maisquellwasser im Merkblatt, ohne Entsprechung in der bereitgestellten SRL"} if {
	some i, e in annual.spreading
	some s in e.substrates
	s.name == "Maisquellwasser"
}

review_items contains {"topic": "Fütterung", "ration": i, "reason": "Abweichende Untergrenze für ungedeckte Jungsauen"} if {
	some i, r in annual.feeding.rations
	r.category == "unserved_gilt"
	nonnegative(r.weight_kg)
	r.weight_kg >= 32
	r.weight_kg < 50
}

review_items contains {"topic": "Ausbringung", "reason": "Zuteilung des gemeinsamen Mengenlimits auf unterschiedliche Prämiensätze offen"} if allocation_review_required

review_items contains {"topic": "Fütterung", "reason": "Keine positive Ackerfläche als Bezugsgröße"} if {
	annual.feeding.participating == true
	input.land.arable_area_ha == 0
}

unverified_spreading contains i if {
	some i, e in annual.spreading
	not eligible_spreading(e)
}

unverified_separations contains i if {
	some i, e in annual.separations
	not eligible_separation(e)
}

contract_continuation if {
	program_year
	annual.base_contract_active == true
	annual.withdrawal_date == null
	mfa_timely
	positive_claim
}

contract_continuation if {
	program_year
	annual.base_contract_active == true
	annual.withdrawal_date == null
	mfa_timely
	year >= 2025
	annual.feeding.participating == true
}

# Fachliche Teilbeträge vor allgemeinen Kürzungen. Unbestimmte Werte fehlen.
component_eur["spreading"] := spread_amount_eur
component_eur["separation"] := separation_amount_eur
component_eur["feeding"] := feed_amount_eur

assessment := {
	"annual_findings": annual_findings,
	"area_exclusions": area_exclusions,
	"component_eur_before_general_reductions": component_eur,
	"unverified_spreading_indices": unverified_spreading,
	"unverified_separation_indices": unverified_separations,
	"review": review_items,
}

# Liegen technische Einzelmerkmale vor, haben diese Vorrang vor der fachlichen Einstufung.
technique_ok(e) if {
	not "device" in object.keys(e)
	e.technique_meets_definition == true
}

technique_ok(e) if {
	e.method == "trailing_hose"
	e.device.loose_flexible_hoses == true
	e.device.contact_pressure == false
	e.device.near_ground == true
}

technique_ok(e) if {
	e.method == "trailing_shoe"
	e.device.application_share == true
	e.device.contact_pressure == true
	e.device.direct_on_infiltrable_soil == true
}

technique_ok(e) if {
	e.method == "injection"
	e.device.opens_soil == true
	e.device.into_soil_same_pass == true
}

invalid_group_for(id) if {
	some record in annual.group_records
	some row in record.entries
	row.parcel_id == id
	not group_log_ok(record.entries, record.recorded_ha)
}

# Bekannte Ausschlüsse und verstrichene Fristen werden getrennt von den
# fachlich nachgewiesenen Mengen ausgewiesen. Ein fehlendes Merkmal ist offen.
annual_findings contains {"rule_id": "o6_9.withdraw_effect", "finding": "im Förderjahr abgemeldet"} if withdrawn_in_year
annual_findings contains {"rule_id": "o6_9.lapse", "finding": "keine Jahresmenge oder Fütterungsteilnahme beantragt"} if no_annual_claim

annual_findings contains {"rule_id": "o6_9.mfa", "finding": "MFA nach der regulären Frist eingereicht"} if {
	in_year(annual.mfa_date)
	not mfa_timely
}

annual_findings contains {"rule_id": "o6_9.november", "category": category, "finding": "Mengenmeldung nach dem 30. November"} if {
	some category, claim in annual.claims
	in_year(claim.date)
	claim.date > sprintf("%04d-11-30", [year])
}

annual_findings contains {"rule_id": "o6_9.exclusive", "finding": "Fütterung zugleich unter Maßnahmen 9 und 16 beantragt"} if {
	annual.feeding.participating == true
	annual.feeding.groundwater_option == true
}

annual_findings contains {"rule_id": "o6_9.density", "finding": "Schweinebesatz unter 1 GVE je ha Ackerfläche"} if {
	annual.feeding.participating == true
	nonnegative(input.land.arable_area_ha)
	gve_total("pigs") < input.land.arable_area_ha
}

annual_findings contains {"rule_id": "o6_9.feed_entry", "finding": "Fütterung in Maßnahme 9 vor 2025 beantragt"} if {
	program_year
	year < 2025
	annual.feeding.participating == true
}

annual_findings contains {"rule_id": "o6_9.stock", "finding": "Durchschnittstierliste bei schwankendem Bestand fehlt", "group_index": i} if {
	some i, g in input.livestock.species_groups
	g.country == "AT"
	g.species != "cattle"
	g.fluctuating == true
	g.average_list_submitted == false
}

review_items contains {"topic": "Tierbestand", "group_index": i, "reason": "Keine eindeutige Zuordnung des Bestands zum GVE-Schlüssel"} if {
	some i, g in input.livestock.species_groups
	g.country == "AT"
	g.species in {"pigs", "cattle"}
	not animal_factor(g)
}
