# o6_16 – Höhe der Prämie (6) inkl. Kombinations- und Ausschlussregeln
package oepul.o6_16

premium_rate(component, yr) := r.eur_per_ha if {
	some r in params.premium_rates
	r.component == component
	r.year_from <= yr
	yr <= r.year_to
}

round2(x) := round(x * 100) / 100

# Basisprämie: 50 % bei Teilnahme an Biologische Wirtschaftsweise (o6_1b) oder EEB (o6_2)
basis_component := "basis_reduced" if {
	some m in ["o6_1b", "o6_2"]
	participates(m)
}

basis_component := "basis" if {
	not participates("o6_1b")
	not participates("o6_2")
}

# Flächenzugangsbeschränkung (Allgemeine Bedingungen 7.2 / SRL 1.7.2.4)
basis_premium_area := limited_increase_area(basis_parcels_ha, o16.premium_area_2025_ha, year) if {
	is_number(object.get(o16, "premium_area_2025_ha", null))
} else := basis_parcels_ha

# Zuschlag Pflanzenschutzmittelverzicht: nicht mit BIO, nicht in Schutz- und Schongebieten
psm_premium_parcels(component) := [p |
	some p in basis_parcels
	name_in(crop_name(p), params.psm_premium_crops[component])
	object.get(p, ["oepul", "in_protection_or_conservation_zone"], false) == false
]

psm_premium_area(_) := 0 if participates("o6_1b")

psm_premium_area(component) := sum([p.area_ha | some p in psm_premium_parcels(component)]) if not participates("o6_1b")

ooe_top_up_area := 0 if object.get(o16, "upper_austria_top_up_funds_available", true) == false

ooe_top_up_area := sum([p.area_ha | some p in basis_parcels; in_upper_austria_area(p)]) if object.get(o16, "upper_austria_top_up_funds_available", true) != false

vienna_premium_area := sum([p.area_ha | some p in basis_parcels; in_vienna_area(p)]) if humus_vienna

vienna_premium_area := 0 if not humus_vienna

# bis 2024 nur Ackerflächen in der Gebietskulisse, ab 2025 alle Ackerflächen (ohne AG-Schläge)
pig_feeding_area := basis_parcels_ha if {
	pig_feeding_eligible
	year <= 2024
}

pig_feeding_area := sum([p.area_ha | some p in parcels; is_arable(p); not is_ag(p); not is_op(p)]) if {
	pig_feeding_eligible
	year >= 2025
}

pig_feeding_area := 0 if not pig_feeding_eligible

cultan_area := sum([p.area_ha | some p in cul_parcels; cultan_parcel_ok(p)])

premium_areas := {
	basis_component: basis_premium_area,
	"training_first_10ha": min([basis_premium_area, 10]),
	"psm_maize_sorghum": psm_premium_area("psm_maize_sorghum"),
	"psm_rape_seed_maize": psm_premium_area("psm_rape_seed_maize"),
	"upper_austria_top_up": ooe_top_up_area,
	"leaching_risk_area": ag_premium_area,
	"humus_erosion_vienna": vienna_premium_area,
	"n_reduced_pig_feeding": pig_feeding_area,
	"cultan": cultan_area,
}

premium_components[component] := {
	"area_ha": round2(area),
	"rate_eur_per_ha": rate,
	"amount_eur": round2(area * rate),
} if {
	some component, area in premium_areas
	rate := premium_rate(component, year)
}

premium_total_before_modulation := round2(sum([c.amount_eur | some c in premium_components]))

premium_total := round2(premium_total_before_modulation * modulation_factor(object.get(input, ["land", "total_area_ha"], 0)))

# Anhang L: Kombinierbarkeit auf der Einzelfläche (Zeile o6_16)
combination_cell(measure) := c.cell if {
	some c in data.o6_16.kombination_anhang_l.row_o6_16
	c.measure_id == measure
}

combinable_on_parcel(measure) if combination_cell(measure) in {"x", "a"}

combination_with_premium_deduction(measure) if combination_cell(measure) == "a"
