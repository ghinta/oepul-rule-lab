# AMA-Hinweise 2026 (Trockenheit/Dürre), soweit für EBW-Flächen entscheidungsrelevant.
package oepul.o6_19

import rego.v1

drought := tables.drought_2026

# R-O619-N2026-ACKER-BDF-PB: Acker-Biodiversitätsflächen, die zusätzlich in EBW eingebracht sind, dürfen 2026
# weiterhin nur nach der Projektbestätigung bewirtschaftet werden (vorzeitige bzw. dritte Nutzung nicht zulässig).
drought_bdf_exception_available[pid] := false if {
	year == drought.year
	some pid, p in ebw_parcels
	has_div_code(p)
}

notice_2026_findings contains {"parcel_id": pid, "rule_id": "R-O619-N2026-ACKER-BDF-PB", "message": "Vorzeitige oder dritte Nutzung 2026 auf EBW-Biodiversitätsfläche widerspricht der Projektbestätigung."} if {
	year == drought.year
	some pid, p in ebw_parcels
	u := object.get(p, ["oepul", "ebw", "use_2026"], {})
	deviating_2026_use(u)
}

deviating_2026_use(u) if u.early_use_before_permitted_date == true

deviating_2026_use(u) if u.third_use == true

deviating_2026_use(u) if u.shortened_rest_period == true

# R-O619-N2026-NAT-RELEASE-SCOPE: Freigabe der Nutzungstermine ab 12.08.2026 gilt nur für "Naturschutz" und Natura 2000.
nat_release_applies_to_ebw := false

# R-O619-N2026-HARVEST-DROUGHT: automatische Anerkennung höherer Gewalt für die Ernteverpflichtung in der Gebietskulisse.
farm_state := object.get(input, ["farm", "region", "federal_state"], "")

farm_district := object.get(input, ["farm", "region", "district"], "")

in_drought_area if farm_state in drought.all_districts_states

in_drought_area if {
	some d in drought.districts
	d.federal_state == farm_state
	farm_district in d.districts
}

harvest_obligation_waived[pid] if {
	year == drought.year
	in_drought_area
	some pid, p in ebw_parcels
	p.land_use == "arable"
	h := object.get(p, ["oepul", "harvest_2026"], {})
	h.no_harvestable_stand_due_to_drought == true
	h.late_summer_or_autumn_crop == true
}

# R-O619-N2026-FORCE-MAJEURE-APPLICATION: außerhalb der Gebietskulisse einzelbetriebliches Ansuchen über eAMA erforderlich.
force_majeure_application_required[pid] if {
	year == drought.year
	some pid, p in ebw_parcels
	h := object.get(p, ["oepul", "harvest_2026"], {})
	h.obligation_not_met_due_to_drought == true
	not harvest_obligation_waived[pid]
}
