package oepul.o6_1b

import rego.v1

# Datumsangaben im Profil sind ISO-Kalendertage ohne Uhrzeit.
day(date) := time.parse_rfc3339_ns(concat("", [date, "T00:00:00Z"])) / 86400000000000
key_date(y, month_day) := sprintf("%04d-%s", [y, month_day])

standard_mix_met(m) if {
	m.insect_pollinated_species >= 7
	m.insect_pollinated_families >= 3
	m.non_insect_stand_percent <= 10
}

seed_rows("arable") := tab.arten_acker
seed_rows("grassland") := tab.arten_gruenland

seed_taxon(use, name) := r if {
	some r in seed_rows(use)
	name in {r.wissenschaftlich, r.deutsch}
}

seed_taxon("grassland", "Plantago lanceolata") := r if {
	some r in tab.arten_gruenland
	r.deutsch == "Spitz-Wegerich"
}

regional_partner_ok(use, s) if {
	s.regional_origin_verified
	s.certified_ecotype == false
	s.weight_percent > 0
	s.weight_percent <= 5
	seed_taxon(use, s.species)
}

regional_partner_ok(_, s) if {
	s.regional_origin_verified
	s.certified_ecotype
	s.weight_percent > 0
}

regional_mix_met(use, m) if {
	m.kg_per_ha >= 20
	m.labels_and_invoices
	every s in m.components { regional_partner_ok(use, s) }
	species := {r.wissenschaftlich | some s in m.components; r := seed_taxon(use, s.species)}
	families := {r.familie | some s in m.components; r := seed_taxon(use, s.species)}
	every taxon in species {
		ordinary := [s.weight_percent | some s in m.components; s.certified_ecotype == false; seed_taxon(use, s.species).wissenschaftlich == taxon]
		sum(ordinary) <= 5
	}
	count(species) >= 30
	count(families) >= 7
	sum([s.weight_percent | some s in m.components]) == 100
}

regional_grass_site(p) if {
	is_number(p.slope_percent)
	p.slope_percent < 18
	p.oepul.soil_rating >= 30
}

old_div_code(code) if code in tab.altcodes
problem_plant(name) if name in tab.problemarten

qualifying_project_code(measure, codes) if {
	some row in tab.schnittauflagen
	row.massnahme == measure
	row.code in codes
}

slk_tier(variety, y) := r.stufe if {
	some r in tab.seltene_sorten
	r.sorte == variety
	r.ab <= y
}

slk_amount(variety, ha, y) := min([10, ha]) * rate(position, y) if {
	ha >= 0
	position := concat("", ["slk_", lower(slk_tier(variety, y))])
}

first_allowed_break(sowing_year, winter_or_cover) := key_date(sowing_year + 1, "08-01") if winter_or_cover == true

else := key_date(sowing_year + 1, "09-15") if winter_or_cover == false

cross_project(codes) if {
	some c in codes
	c in {"NAT", "EBW", "N2"}
}

drought_relief(p) if {
	year == 2026
	"OPBIO" in p.oepul.codes
	p.oepul.other_use_restrictions == false
	not cross_project(p.oepul.codes)
}

rest_days(p) := 49 if drought_relief(p)

else := 63

nfz_second_use_met(p) if {
	"DIVNFZ" in p.oepul.codes
	day(p.oepul.second_use) - day(p.oepul.first_use_completed) > rest_days(p)
}

# Vorgezogene DIVSZ-Nutzung unter OPBIO erfordert auch den Vergleichsschnitt.
early_sz_met(p) if {
	"DIVSZ" in p.oepul.codes
	drought_relief(p)
	shift := p.oepul.phenology_days
	shift >= 4
	shift <= 7
	is_string(p.oepul.comparable_second_cut)
	p.oepul.comparable_second_cut <= p.oepul.first_use
	day(p.oepul.first_use) >= (day(key_date(year, "06-15")) - shift) - 14
}

regular_sz_met(p) if {
	"DIVSZ" in p.oepul.codes
	shift := p.oepul.phenology_days
	shift >= 0
	shift <= 10
	first := day(p.oepul.first_use)
	first >= day(key_date(year, "06-15")) - shift
	sz_release(p, first, shift)
}

sz_release(p, _, _) if p.oepul.single_cut_meadow

sz_release(p, _, _) if {
	is_string(p.oepul.comparable_second_cut)
	p.oepul.comparable_second_cut <= p.oepul.first_use
}

sz_release(_, first, shift) if first >= day(key_date(year, "07-15")) - shift

variant_change(old, new, date, y) if {
	old == "DIVSZ"
	new in {"DIVNFZ", "DIVAGF"}
	date > key_date(y, "04-15")
	date <= key_date(y, "06-15")
}

variant_change(old, new, date, y) if {
	old == "DIVNFZ"
	new == "DIVAGF"
	date > key_date(y, "04-15")
	date <= key_date(y, "08-15")
}

arable_drought_third_use(p) if {
	p.land_use == "arable"
	"DIV" in p.oepul.codes
	drought_relief(p)
	p.oepul.counted_uses == 3
}

drought_region(state, district) if {
	some r in tab.duerre_bezirke
	r.land == state
	r.bezirk in {null, district}
}

harvest_waiver(p) if {
	year == 2026
	p.land_use == "arable"
	p.oepul.drought_destroyed_harvest
	p.oepul.heat_sensitive_late_crop
	drought_region(p.oepul.federal_state, p.oepul.district)
}

erosion_risk(p) if {
	p.land_use == "arable"
	p.area_ha > 0.5
	p.oepul.predominant_slope_percent >= 10
	p.crop.crop_name in tab.erosionskulturen
}

erosion_full(p) if {
	p.oepul.measure8
	p.oepul.erosion_procedure in {"Mulchsaat", "Direktsaat", "Strip-Till"}
	p.oepul.measure6_or_7
}

erosion_full(p) if {
	p.oepul.measure8
	p.oepul.erosion_procedure == "Anhäufungen bei Kartoffeln"
	p.crop.crop_name == "Kartoffeln"
}

erosion_full(p) if {
	p.oepul.measure8
	p.oepul.erosion_procedure == "Untersaat"
	undersowing_crop(p.crop.crop_name, year)
}

undersowing_crop(c, _) if c in {"Ackerbohnen", "Kürbisse", "Sojabohnen", "Sonnenblumen"}

undersowing_crop(c, y) if {
	y >= 2025
	c in {"Mais", "Sorghum"}
}

erosion_base_factor(p) := 1 if {
	erosion_risk(p)
	erosion_full(p)
}

else := 0.5 if {
	erosion_risk(p)
	is_boolean(p.oepul.measure8)
	is_boolean(p.oepul.measure6_or_7)
	is_string(p.oepul.erosion_procedure)
	year >= 2025
}

else := 0 if {
	erosion_risk(p)
	is_boolean(p.oepul.measure8)
	is_boolean(p.oepul.measure6_or_7)
	is_string(p.oepul.erosion_procedure)
	year <= 2024
}

trap_operation_met(p) if {
	year >= 2025
	"PZR" in p.oepul.codes
	p.oepul.sugar_beet_current_or_previous_harvest
	t := p.oepul.traps
	count(t.empty_dates) >= 2
	t.number >= 15 * p.area_ha
	t.annual_lures_installed
	t.catch_containers
	start := day(t.installed)
	start - day(t.sowing_or_comparable_date) <= 14
	start >= day(t.sowing_or_comparable_date)
	day(t.removed) - start >= 35
	t.removed < t.harvest
	count({d | some d in t.empty_dates; day(d) >= start; day(d) <= start + 35; d <= t.removed}) >= 2
}

lse_geometry(e) if {
	e.distance_to_farmed_land_m <= 5
	e.crown_diameter_m >= 2
	e.area_m2 <= 100
	e.nearest_lse_m >= 5
	e.under_control_all_year
	e.claimed
	e.gloez == false
	e.on_alp_or_rough_pasture == false
}

orchard_tree(e, y) if {
	lse_geometry(e)
	e.strong_large_crowned_high_or_half_standard
	e.shared_permanent_support == false
	some r in tab.streuobst
	r.name == e.species
	r.ab <= y
	e.wild_form in {false, r.wildform}
}

hedge_met(h, y) if {
	h.planted >= "2023-01-01"
	h.planted <= key_date(y, "05-15")
	h.adjacent_own_arable_field
	h.long_side_wood_or_lse == false
	h.average_width_m >= 5
	h.average_width_m <= 20
	h.permanent_herb_percent >= 20
	h.mainly_shrubs_fruit_trees
	h.woody_plants_maintained
	h.herb_harvest_or_grazing == false
	h.fertiliser_or_disallowed_psm == false
	h.land_concept
	h.gis_confirmed
}

eligible_steep(p) if {
	p.land_use == "grassland"
	p.slope_percent >= 50
	count(p.operations.cutting_dates) >= 1
	p.oepul.use in {"Einmähdige Wiese", "Streuwiese", "Mähwiese/-weide zwei Nutzungen", "Mähwiese/-weide drei und mehr Nutzungen"}
}

soil_bonus_rate(p) := rate("acker_bonitaet", year) if {
	p.land_use == "arable"
	p.oepul.qualifies_for_bio_div_premium
	p.oepul.soil_rating >= 50
}

else := rate("gruen_bonitaet", year) if {
	p.land_use == "grassland"
	p.oepul.qualifies_for_bio_div_premium
	p.oepul.soil_rating >= 30
}

parcel_premium_blocked(p) if {
	some c in p.oepul.codes
	c in {"OP", "OPBIO", "VF"}
}

parcel_premium_blocked(p) if special_use_excluded(p.oepul.use)
parcel_premium_blocked(p) if p.oepul.use in {"Sonstige Spezialkulturflächen", "Sonstige Weinflächen", "Sonstige Ackerflächen", "Sonstige Grünlandflächen", "Sonstige Hutweideflächen", "Sonstige Flächen im geschützten Anbau"}
parcel_premium_blocked(p) if p.oepul.national_park in {"Neusiedlersee", "Donau-Auen"}
parcel_premium_blocked(p) if p.oepul.relevant_national_park_obligations
parcel_premium_blocked(p) if p.oepul.country != "AT"

eligible_monitoring_program(program, _, _) if {
	some r in tab.monitoring
	r.position == program
	count(r.nat_codes) == 0
}

eligible_monitoring_program(program, codes, nat) if {
	nat == true
	some r in tab.monitoring
	r.position == program
	some c in r.nat_codes
	c in codes
}

kennarten_count(names) := count({r.deutsch | some r in tab.kennarten; some n in names; n in r.bezeichnungen})

grass_variant(code) := r if {
	some r in tab.varianten
	r.code == code
}

dwarf_breed(name) if name in tab.zwergrinder
sanction_options(y) := [r | some r in tab.sanktionsstufen; r.ab <= y; y <= r.bis]

# Teilergebnisse pro Schlag sind auch ohne vollständige betriebliche Abrechnung abfragbar.
parcel_findings contains {"parcel_id": p.parcel_id, "result": "BIO-Flächenprämie ausgeschlossen"} if {
	some p in input.land.parcels
	parcel_premium_blocked(p)
}

parcel_findings contains {"parcel_id": p.parcel_id, "result": "Ernteausnahme 2026 ohne Einzelmeldung"} if {
	some p in input.land.parcels
	harvest_waiver(p)
}

parcel_findings contains {"parcel_id": p.parcel_id, "result": "Dritte Nutzung unter OPBIO"} if {
	some p in input.land.parcels
	arable_drought_third_use(p)
}

parcel_findings contains {"parcel_id": p.parcel_id, "result": "DIVNFZ-Ruhefrist erfüllt"} if {
	some p in input.land.parcels
	nfz_second_use_met(p)
}

parcel_findings contains {"parcel_id": p.parcel_id, "result": "DIVSZ-Nutzungstermin zulässig"} if {
	some p in input.land.parcels
	regular_sz_met(p)
}

parcel_findings contains {"parcel_id": p.parcel_id, "result": "DIVSZ-Frühnutzung mit OPBIO"} if {
	some p in input.land.parcels
	early_sz_met(p)
}
