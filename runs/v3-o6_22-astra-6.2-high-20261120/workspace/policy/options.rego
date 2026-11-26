package oepul.o6_22

import rego.v1

# Einzelfutter ist nach dem üblichen, Mischfutter nach dem tatsächlichen Gehalt einzuordnen.
protein_feed(f) := false if f.roughage

else := result if {
	f.roughage == false
	f.kind == "compound"
	nonnegative(f.protein_pct_dm)
	result := f.protein_pct_dm > 20
} else := result if {
	f.roughage == false
	f.kind == "single"
	nonnegative(f.typical_protein_pct_dm)
	result := f.typical_protein_pct_dm > 20
}

feed_record_ok(f) if protein_feed(f) == false

feed_record_ok(f) if {
	protein_feed(f)
	f.european_origin
	f.gmo_free
	feed_proof(f)
}

feed_proof(f) if f.homegrown
feed_proof(f) if f.origin_and_gmo_documented

feed_ok if {
	is_array(application.feed_lots)
	application.feed_inventory_complete_year
	every f in application.feed_lots { feed_record_ok(f) }
}

turn_ok(t) if {
	t.device == "turner"
	equipment_available(t)
}

turn_ok(t) if {
	t.device in {"spreader", "equivalent"}
	t.equivalent_result
	t.fully_turned
	equipment_available(t)
}

equipment_available(t) if t.on_farm
equipment_available(t) if t.external_use_documented

pile_ok(p) if {
	p.method == "turning"
	is_array(p.turns)
	some i, first in p.turns
	some j, second in p.turns
	i != j
	turn_ok(first)
	turn_ok(second)
	days_between(first.date, second.date) >= 14
}

pile_ok(p) if {
	p.method == "mixed_or_layered"
	p.significant_added_organics
	p.added_material in {"field_residues", "straw", "green_cuttings", "branches", "shrubs", "combination"}
	p.composting_process_used
}

compost_ok if {
	year >= 2025
	c := application.composting
	c.all_species_manure_piled_on_farm
	c.compost_barn == false
	c.nitrate_programme_met
	c.operations_documented
	is_array(c.piles)
	count(c.piles) > 0
	every p in c.piles { pile_ok(p) }
}
