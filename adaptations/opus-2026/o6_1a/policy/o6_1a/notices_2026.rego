# METADATA
# title: UBB (o6_1a) – Sonderregelungen 2026 (Trockenheit/Dürre) laut AMA-Hinweisen
package oepul.o6_1a.notices_2026

import data.oepul.o6_1a.common

params := common.tables.o6_1a_drought_2026_parameters

opubb_coded(p) if {
	some c in params.no_premium_codes
	common.has_code(p, c)
}

project_bound(p) if {
	some c in {"NAT", "EBW"}
	common.has_code(p, c)
}

# N26-TR-001/N26-DU-006: vorzeitige (ab 12.08. auch dritte) Nutzung von Acker-Biodiversitätsflächen 2026
# nur mit Code OPUBB/OPBIO (keine Prämie) und nicht bei Flächen mit Projektbestätigung (NAT/EBW).
early_use_exception_2026(p) if {
	common.year == params.year
	common.is_arable_div(p)
	opubb_coded(p)
	not project_bound(p)
}

# N26-TR-003: vorzeitige Nutzung von Grünland-Biodiversitätsflächen um 14 Tage (DIVNFZ: 49 Tage Ruhezeit).
grassland_advance_exception_2026(p) if {
	common.year == params.year
	common.is_grassland_div(p)
	opubb_coded(p)
	not project_bound(p)
	not common.has_code(p, "N2")
}

violations contains {"rule_id": "N26-TR-006", "subject": common.parcel_id(p), "message": "Trockenheitsausnahme gilt nicht für Flächen mit Projektbestätigung (Naturschutz/EBW); Bewirtschaftung nach Projektbestätigung"} if {
	common.year == params.year
	some p in common.parcels
	opubb_coded(p)
	project_bound(p)
	object.get(p, ["biodiversity", "drought_early_use"], false)
}

# N26-DU-001..003: Ernteverpflichtung 2026 in Dürre-Gebieten automatisch als höhere Gewalt anerkannt.
district_listed(state, district) if {
	some r in common.tables.o6_1a_drought_2026_harvest_exemption_districts
	r.federal_state == state
	r.district in {"*", district}
}

harvest_exemption_2026(p) if {
	common.year == params.year
	district_listed(object.get(input, ["farm", "region", "federal_state"], ""), object.get(p, "district", object.get(input, ["farm", "region", "district"], "")))
	object.get(p, ["harvest", "late_summer_autumn_crop"], false)
	object.get(p, ["harvest", "no_harvestable_stand_due_to_drought"], false)
}
