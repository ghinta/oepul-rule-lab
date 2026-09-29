package oepul.o6_18

import data.o6_18 as o6data

default eligible := false

# Input is the proposed extension described in rules/profile_changes.json.
eligible if {
	input.o6_18.participates
	input.o6_18.project_confirmation.present
	count(input.o6_18.parcels) > 0
	every p in input.o6_18.parcels { p.nat_code }
}

violations contains v if {
	input.o6_18.participates
	not input.o6_18.project_confirmation.present
	v := {"rule_id": "o6_18.project_confirmation", "message": "Projektbestätigung der zuständigen Landesstelle fehlt."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	p.nat_code
	not p.project_operations_confirmed
	v := {"rule_id": "o6_18.project_obligations", "parcel_id": p.parcel_id, "message": "Auflagen der Projektbestätigung sind nicht als erfüllt bestätigt."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	p.nat_code
	p.land_use == "grassland"
	p.uses_per_year > 3
	v := {"rule_id": "o6_18.max_grassland_uses", "parcel_id": p.parcel_id, "message": "Mehr als drei Grünlandnutzungen."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	p.nat_code
	p.care_or_use_within_two_years == false
	v := {"rule_id": "o6_18.min_care", "parcel_id": p.parcel_id, "message": "Nutzung/Pflege mindestens alle zwei Jahre fehlt."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	p.nat_code
	p.prohibited_general_activity
	v := {"rule_id": "o6_18.general_prohibitions", "parcel_id": p.parcel_id, "message": "Verbotene allgemeine Naturschutzhandlung."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	p.nat_code
	p.requires_grazing_log
	not p.grazing_log.current
	v := {"rule_id": "o6_18.grazing_log", "parcel_id": p.parcel_id, "message": "Tagaktuelles Weidetagebuch fehlt."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	code := p.project_codes[_]
	not code in o6data.annex_i_codes
	v := {"rule_id": "o6_18.annex_code", "parcel_id": p.parcel_id, "code": code, "message": "Code ist nicht in Anhang I enthalten."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	code := p.project_codes[_]
	code in o6data.special_code_sets.phenology_monitoring
	not input.o6_18.monitoring.phenology
	v := {"rule_id": "o6_18.phenology_monitoring", "parcel_id": p.parcel_id, "code": code, "message": "Monitoring Schnittzeit nach Phänologie fehlt."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	code := p.project_codes[_]
	code in o6data.special_code_sets.great_bustard_monitoring
	not input.o6_18.monitoring.great_bustard
	v := {"rule_id": "o6_18.great_bustard_monitoring", "parcel_id": p.parcel_id, "code": code, "message": "Monitoring Beobachtung der Großtrappe fehlt."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	code := p.project_codes[_]
	code in o6data.special_code_sets.fallow_care_requires_sa01
	not "SA01" in p.project_codes
	v := {"rule_id": "o6_18.fallow_combination", "parcel_id": p.parcel_id, "code": code, "message": "Pflegecode der Ackerstilllegung verlangt SA01."}
}

violations contains v if {
	p := input.o6_18.parcels[_]
	"AA06" in p.project_codes
	code := p.project_codes[_]
	code in o6data.special_code_sets.mutually_exclusive_with_aa06
	v := {"rule_id": "o6_18.aa06_combination", "parcel_id": p.parcel_id, "code": code, "message": "AA06 ist mit diesem Code nicht kombinierbar."}
}

regional_plan_premium_eur := 270 if {
	input.o6_18.regional_plan.requested
	input.o6_18.regional_plan.annual_confirmation
}

fallow_eligible_ha := min([input.o6_18.fallow_requested_ha, max([2, 0.25 * input.land.arable_area_ha])])

area_modulation_factor := factor if {
	area := input.land.total_area_ha
	factor := (((min([area, 200]) + (0.9 * min([max([area - 200, 0]), 100]))) + (0.85 * min([max([area - 300, 0]), 700]))) + (0.75 * max([area - 1000, 0]))) / area
}
