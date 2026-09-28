# Tierwohl – Schweinehaltung (o6_22): optional supplements (undocked tails,
# GMO-free European protein feed, solid manure composting).
package oepul.o6_22

# ---- Zuschlag unkupierte Tiere ----

# Rule: O622-SUP-UNK-01 / O622-SUP-UNK-02 (all participating animals of the category undocked all year)
violations contains {
	"rule_id": "O622-SUP-UNK-02",
	"severity": "supplement_obligation",
	"message": sprintf("Undocked-tail supplement for %v: participating group %v has docked tails", [c, i]),
} if {
	some i, g in participating_groups
	c := category_of(g)
	supplement_active_for("unkupiert", c)
	not i in noncompliant_groups
	g.tail_docked == true
}

# ---- Zuschlag GVO-freie Eiweißfuttermittel ----

gvo := object.get(app, "gvo_free_protein_feed", {})

gvo_supplement_active if {
	some c in active_categories
	supplement_active_for("gvo_frei_eiweiss", c)
}

# Rule: O622-SUP-GVO-01 (all animals on the farm, whole calendar year)
violations contains {
	"rule_id": "O622-SUP-GVO-01",
	"severity": "supplement_obligation",
	"message": "GMO-free supplement: all protein feed for all animals on the farm must be GMO-free and of European origin for the whole calendar year",
} if {
	gvo_supplement_active
	gvo.all_protein_feed_gvo_free_european == false
}

# Rule: O622-SUP-GVO-01 (no storage or feeding of non-compliant protein feed, incl. old stocks and other species)
violations contains {
	"rule_id": "O622-SUP-GVO-01",
	"severity": "supplement_obligation",
	"message": "GMO-free supplement: non-compliant protein feed is stored or fed on the farm",
} if {
	gvo_supplement_active
	gvo.non_compliant_protein_feed_stored_or_fed == true
}

# Rule: O622-SUP-GVO-03 (proof of European origin and GMO freedom for purchased protein feed)
violations contains {
	"rule_id": "O622-SUP-GVO-03",
	"severity": "supplement_obligation",
	"message": "GMO-free supplement: proofs (delivery notes, invoices, feed recipes) for purchased protein feed are missing",
} if {
	gvo_supplement_active
	gvo.purchase_proofs_available == false
}

# Rule: O622-SUP-GVO-02 (protein feed definition: > 20 % crude protein in dry matter, roughage excluded)
is_protein_feed(feed) if {
	feed.is_roughage != true
	feed.crude_protein_percent_dm > params.protein_feed_min_crude_protein_percent_dm_exclusive
}

# Rule: O622-SUP-GVO-03 ('European' means the continent of Europe, not only the EU)
feed_origin_ok(feed) if feed.origin_continent == "europe"

# ---- Zuschlag Festmistkompostierung ----

composting := object.get(app, "solid_manure_composting", {})

composting_supplement_active if {
	year >= params.festmist_supplement_first_year
	some c in active_categories
	supplement_active_for("festmistkompostierung", c)
}

equipment := {row.code: row | some row in lists.compost_turning_equipment}

# Rule: O622-SUP-COMP-02 / O622-SUP-COMP-03 (turning equipment)
equipment_ok(w) if {
	row := equipment[w.turning_equipment]
	row.eligible == true
	row.requires_complete_turning_proof == false
	w.equipment_owned_or_use_documented == true
}

equipment_ok(w) if {
	row := equipment[w.turning_equipment]
	row.eligible == true
	row.requires_complete_turning_proof == true
	w.complete_turning == true
	w.equipment_owned_or_use_documented == true
}

# Rule: O622-SUP-COMP-01 (turned at least twice, >= 14 days apart)
turning_ok(w) if {
	count(w.turn_dates) >= params.compost_min_turn_count
	some d1 in w.turn_dates
	some d2 in w.turn_dates
	days_between(d1, d2) >= params.compost_min_turn_interval_days
}

# Rule: O622-SUP-COMP-01 / O622-SUP-COMP-02 / O622-SUP-COMP-03
windrow_ok(w) if {
	w.method == "turned"
	turning_ok(w)
	equipment_ok(w)
}

# Rule: O622-SUP-COMP-04 (mixture or layering with plant material, no turning required)
windrow_ok(w) if {
	w.method == "mixed_or_layered"
	w.plant_material_share_percent > 0
	object.get(w, "straw_rich_manure_only", false) != true
}

# Rule: O622-SUP-COMP-05 (no turner: substantial plant material plus composting process)
windrow_ok(w) if {
	w.method == "unturned_with_additives"
	w.plant_material_share_percent > 0
	w.composting_process_applied == true
	object.get(w, "straw_rich_manure_only", false) != true
}

violations contains {
	"rule_id": "O622-SUP-COMP-01",
	"severity": "supplement_obligation",
	"message": sprintf("Composting supplement: windrow %v does not meet the composting requirements", [object.get(w, "windrow_id", idx)]),
} if {
	composting_supplement_active
	some idx, w in object.get(composting, "windrows", [])
	not windrow_ok(w)
}

# Rule: O622-SUP-COMP-01 (entire solid manure of the farm, all species)
violations contains {
	"rule_id": "O622-SUP-COMP-01",
	"severity": "supplement_obligation",
	"message": "Composting supplement: the entire solid manure of the farm must be composted in windrows on the farm",
} if {
	composting_supplement_active
	composting.all_solid_manure_composted_on_farm == false
}

violations contains {
	"rule_id": "O622-SUP-COMP-01",
	"severity": "supplement_obligation",
	"message": "Composting supplement: no compost windrow recorded",
} if {
	composting_supplement_active
	count(object.get(composting, "windrows", [])) == 0
}

# Rule: O622-SUP-COMP-06 (documentation of set-up, turning, spreading/transfer)
violations contains {
	"rule_id": "O622-SUP-COMP-06",
	"severity": "supplement_obligation",
	"message": "Composting supplement: documentation of windrow set-up, turning and spreading/transfer is incomplete",
} if {
	composting_supplement_active
	composting.documentation_complete == false
}

# Rule: O622-SUP-COMP-07 (Nitrate Action Programme Regulation for windrows)
violations contains {
	"rule_id": "O622-SUP-COMP-07",
	"severity": "legal_obligation",
	"message": "Composting supplement: compost windrows must comply with the Nitrat-Aktionsprogramm-Verordnung",
} if {
	composting_supplement_active
	composting.nitrate_action_programme_compliant == false
}

# Rule: O622-SUP-COMP-08 (no supplement for compost barns)
composting_supplement_excluded if {
	composting_supplement_active
	composting.compost_stall_system == true
}

violations contains {
	"rule_id": "O622-SUP-COMP-08",
	"severity": "supplement_not_grantable",
	"message": "Composting supplement cannot be granted for compost barns (Kompostställe)",
} if {
	composting_supplement_excluded
}

# Advisory: 'nennenswertes Ausmaß (z. B. 50:50)' is only given as an example (see notes/assumptions.md).
advisories contains sprintf("Windrow %v: plant material share %v %% is below the 50:50 example ratio", [object.get(w, "windrow_id", idx), w.plant_material_share_percent]) if {
	composting_supplement_active
	some idx, w in object.get(composting, "windrows", [])
	w.method == "unturned_with_additives"
	w.plant_material_share_percent < 50
}
