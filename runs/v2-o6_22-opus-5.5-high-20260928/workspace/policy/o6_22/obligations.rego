# Tierwohl – Schweinehaltung (o6_22): deregistration duty, animal health service,
# stall sketch/occupancy plan, VIS reporting.
package oepul.o6_22

noncompliant_groups := {i | some issue in group_issues; i := issue.group}

# Rule: O622-REPORT-01 / O622-FAT-ALL-01 / O622-FAT-ALL-02 (all animals of the category; not kept according to the conditions must be deregistered)
required_deregistration_count[c] := n if {
	some c in active_categories
	n := sum([group_count(category_groups[i]) |
		some i in noncompliant_groups
		category_of(category_groups[i]) == c
	])
}

violations contains {
	"rule_id": "O622-REPORT-01",
	"severity": "obligation",
	"message": sprintf("Category %v: %v animals (annual average) do not meet the conditions but only %v were deregistered", [c, n, deregistered_count(c)]),
} if {
	some c, n in required_deregistration_count
	n > 0
	deregistered_count(c) < n
}

# Rule: O622-REPORT-01 (deregistration must be made immediately)
violations contains {
	"rule_id": "O622-REPORT-01",
	"severity": "obligation",
	"message": sprintf("Deregistration for category %v was not notified immediately", [d.measure_category]),
} if {
	some d in object.get(app, "deregistrations", [])
	d.notified_immediately == false
}

# Rule: O622-TGD-01 (GVE of premium-eligible pigs held on the farm; wild boars excluded)
farm_eligible_pig_gve := r2(sum([group_gve(g) |
	some g in category_groups
	object.get(g, "is_wild_boar", false) != true
]))

tgd_required if farm_eligible_pig_gve > params.tgd_gve_threshold_exclusive

# Rule: O622-TGD-02 (2023: participation from 15 April 2023 suffices)
tgd_required_from := params.tgd_2023_participation_start if year == 2023

else := year_start(year)

tgd_ok if {
	t := app.animal_health_service
	t.participating == true
	t.from <= tgd_required_from
	t.to >= year_end(year)
}

# Rule: O622-TGD-01
violations contains {
	"rule_id": "O622-TGD-01",
	"severity": "obligation",
	"message": sprintf("%v GVE premium-eligible pigs (> %v GVE): participation in a recognised pig health service (TGD) for the whole year is required", [farm_eligible_pig_gve, params.tgd_gve_threshold_exclusive]),
} if {
	measure_applied
	tgd_required
	not tgd_ok
}

# Rule: O622-DOC-SKETCH-01 / O622-DOC-SKETCH-04 (stall sketch and occupancy plan up to and including 2024)
stall_sketch_required if {
	year <= params.stall_sketch_required_until_year
	count(stall_groups) > 0
}

violations contains {
	"rule_id": "O622-DOC-SKETCH-01",
	"severity": "obligation",
	"message": "Stall sketch and occupancy plan (maximum occupancy) per category and compartment must be available on the farm",
} if {
	stall_sketch_required
	object.get(app, "stall_sketch_and_occupancy_plan_available", false) != true
}

# Rule: O622-VIS-01 (VIS reporting of animal movements under TKZVO 2009)
violations contains {
	"rule_id": "O622-VIS-01",
	"severity": "legal_obligation",
	"message": "Pig movements (arrivals and departures of live animals) must be reported to the VIS",
} if {
	count(listed_pig_groups) > 0
	object.get(app, "vis_reporting_complete", null) == false
}

# Rule: O622-GEN-LOC-01 (animals kept outside Austria must not be listed)
violations contains {
	"rule_id": "O622-GEN-LOC-01",
	"severity": "declaration",
	"message": sprintf("Group %v is kept outside Austria and must not be listed or counted", [i]),
} if {
	some i, g in object.get(input, ["livestock", "species_groups"], [])
	g.species == "pigs"
	g.kept_in_austria == false
}
