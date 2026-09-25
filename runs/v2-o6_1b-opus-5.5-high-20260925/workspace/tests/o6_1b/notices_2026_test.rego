package oepul.o6_1b_test

import data.oepul.o6_1b

# Meldung 22.05.2026: vorzeitige Nutzung nur mit OPBIO; NAT-Flächen sind nicht umfasst
test_drought_opt_out_requires_code_and_excludes_nat if {
	p := object.union(div_arable("D1", 2, ["OPBIO"]), {"operations": {"use_events": [{"date": "2026-07-01", "type": "graze"}]}})
	o6_1b.drought_2026_opt_out(p) with input as base_input
	not "O61B-DA-019" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), p])
	nat := object.union(div_arable("N1", 2, ["OPBIO", "NAT"]), {"constraints": {"biodiversity_area": {"nat_auflagen": ["SA01"]}}})
	not o6_1b.drought_2026_opt_out(nat) with input as base_input
	inp25 := json.patch(with_parcels([arable("A1", 18, "Winterweizen"), p]), [{"op": "replace", "path": "/farm/year", "value": 2025}])
	not o6_1b.drought_2026_opt_out(p) with input as inp25
}

# Meldung 12.08.2026: dritte Nutzung zulässig, eine vierte nicht
test_fourth_use_2026_not_allowed if {
	evs := [
		{"date": "2026-05-02", "type": "mow", "removed": true},
		{"date": "2026-06-10", "type": "mow", "removed": true},
		{"date": "2026-07-20", "type": "mow", "removed": true},
		{"date": "2026-08-20", "type": "mow", "removed": true},
	]
	p := object.union(div_arable("D1", 2, ["OPBIO"]), {"operations": {"use_events": evs}})
	"O61B-N26-001" in ids(o6_1b.violations) with input as with_parcels([arable("A1", 18, "Winterweizen"), div_arable("D2", 1.5, []), p])
}

# Opt-out-Flächen erhalten keine Bio-Prämie
test_opt_out_div_no_premium if {
	p := object.union(div_arable("D1", 2, ["OPBIO"]), {"ackerzahl": 60})
	ps := [arable("A1", 18, "Winterweizen"), div_arable("D2", 1.5, []), p]
	o6_1b.premium_components.arable_div_ackerzahl_50 == 0 with input as with_parcels(ps)
	approx(o6_1b.premium_components.arable_base, 19.5 * 235) with input as with_parcels(ps)
}

test_drought_districts_wien_all if {
	late := object.union(arable("A9", 2, "Sojabohne"), {"crop": {"crop_name": "Sojabohne", "late_harvest_crop": true}, "operations": {"harvested_share_percent": 0, "no_harvestable_stand_due_to_drought": true}})
	inp := json.patch(base_input, [
		{"op": "add", "path": "/land/parcels/-", "value": late},
		{"op": "replace", "path": "/farm/region", "value": {"federal_state": "Wien", "district": "Donaustadt"}},
	])
	o6_1b.drought_harvest_waiver(late) with input as inp

	# Waiver gilt nur im Antragsjahr 2026
	inp25 := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2025}])
	not o6_1b.drought_harvest_waiver(late) with input as inp25
}

test_gloez_landscape_element_not_paid if {
	e := lse("G", "F1", {"is_gloez_element": true})
	inp := with_patch([{"op": "add", "path": "/land/point_landscape_elements", "value": [e]}])
	o6_1b.premium_components.landscape_elements == 0 with input as inp
	not "O61B-LE-001" in ids(o6_1b.violations) with input as inp
}

test_rate_offered_only_from_year if {
	o6_1b.rate_or_zero("grassland_divagf") == 0 with input as json.patch(base_input, [{"op": "replace", "path": "/farm/year", "value": 2024}])
	o6_1b.rate_or_zero("grassland_divagf") == 150 with input as base_input
}
