# Zugangsvoraussetzungen, teilnahmefähige Tiere, Mindestteilnahme, TGD und Qplus Rind (Kapitel 3, 6.1, 6.2).
package oepul.o6_21

import rego.v1

# ---------------------------------------------------------------------------
# Kategorien und Milchanlieferung (O6_21-ACC-003 / O6_21-ACC-004)
# ---------------------------------------------------------------------------

milk_delivery_to_dairy if input.farm.dairy.milk_delivery_to_dairy == true

milk_delivery_to_dairy if input.farm.dairy.seasonal_alm_milk_delivery == true

category_excluded contains c if {
	some c in applied_categories
	categories_by_id[c].excluded_for_milk_delivering_farms == true
	milk_delivery_to_dairy
}

category_excluded contains c if {
	some c in unknown_applied_categories
}

# ---------------------------------------------------------------------------
# Ausschluss einzelner Tiere
# ---------------------------------------------------------------------------

# O6_21-GEN-003: geförderte Tiere müssen in Österreich gehalten werden.
animal_exclusion_reasons contains [a.ear_tag, "O6_21-GEN-003"] if {
	some a in cattle
	a.kept_in_austria == false
}

# O6_21-NOTIF-003: abgemeldete Tiere sind im Förderjahr generell nicht prämienfähig.
animal_exclusion_reasons contains [a.ear_tag, "O6_21-NOTIF-003"] if {
	some a in cattle
	deregistered(a)
}

# O6_21-GEN-006 / O6_21-CONT-004: Tiere mit (abmeldepflichtigen) Verstößen erfüllen die Verpflichtung nicht ganzjährig.
animal_exclusion_reasons contains [ear, "O6_21-GEN-006"] if {
	some ear in deregistration_required
}

animal_excluded contains ear if {
	some [ear, _] in animal_exclusion_reasons
}

# O6_21-HOUS-002 / O6_21-ACC-002: Teilnahme eines Rindes an einer beantragten Kategorie.
participating(a, c) if {
	c in applied_categories
	not c in category_excluded
	w := obligation_window(a, categories_by_id[c])
	w[1] > w[0]
	not a.ear_tag in animal_excluded
}

# O6_21-PREM-003 / O6_21-RGVE-002: prämienfähige RGVE im Jahresdurchschnitt je Kategorie.
category_rgve[c] := r if {
	some c in applied_categories
	not c in category_excluded
	cat := categories_by_id[c]
	r := sum([animal_category_rgve(a, cat) | some a in cattle; participating(a, c)])
}

total_participating_rgve := sum([r | some r in category_rgve])

# Förderbare Rinder (vor Abzug abgemeldeter Tiere) für die TGD-Schwelle.
eligible_cattle_rgve := sum([animal_category_rgve(a, categories_by_id[c]) |
	some c in applied_categories
	not c in category_excluded
	some a in cattle
	obligation_window(a, categories_by_id[c])
])

# O6_21-ACC-001 / O6_21-CONT-003: mindestens 2,00 RGVE im Jahresdurchschnitt über alle beantragten Kategorien.
default minimum_participation_met := false

minimum_participation_met if total_participating_rgve >= params.minimum_participation_rgve

# O6_21-APP-005: Kategorie ohne mindestens ein prämienfähiges Tier - Vertrag der Kategorie erlischt.
category_contract_lapsed contains c if {
	some c in applied_categories
	not c in category_excluded
	count([a | some a in cattle; participating(a, c)]) == 0
}

# ---------------------------------------------------------------------------
# Programmteilnahmen (O6_21-TGD-* / O6_21-QPL-*)
# ---------------------------------------------------------------------------

# Beginn des erforderlichen Teilnahmezeitraums: 1. Jänner bzw. im Förderjahr 2023 der 15. April.
required_program_start_ns := date_ns(params.reduced_start_date_2023) if measure_year == params.program_start_year

else := year_start_ns

program_covers_year(p) if {
	p.participates == true
	date_ns(p.from_date) <= required_program_start_ns
	date_ns(p.to_date) >= time.add_date(year_end_excl_ns, 0, 0, -1)
}

# O6_21-TGD-001: über 10,00 RGVE förderbare Rinder - Teilnahme am Tiergesundheitsdienst.
default animal_health_service_required := false

animal_health_service_required if eligible_cattle_rgve > params.animal_health_service_threshold_rgve

program_violations contains {"rule_id": "O6_21-TGD-001", "reason": "keine ganzjährige Teilnahme an einem anerkannten Tiergesundheitsdienst bei über 10 RGVE förderbaren Rindern"} if {
	animal_health_service_required
	not program_covers_year(object.get(input, ["farm", "programs", "animal_health_service"], {}))
}

female_category_applied if {
	some c in applied_categories
	not c in category_excluded
	categories_by_id[c].requires_qplus_rind == true
}

# O6_21-QPL-001 / O6_21-QPL-003: bei weiblichen Rindern ganzjährige Teilnahme am Qualitätsprogramm Qplus Rind.
qplus_ok if {
	q := input.farm.programs.qplus_rind
	q.programme == "qplus_rind"
	program_covers_year(q)
}

program_violations contains {"rule_id": "O6_21-QPL-001", "reason": "keine ganzjährige Teilnahme am Qualitätsprogramm Qplus Rind bei Beantragung weiblicher Rinder"} if {
	female_category_applied
	not qplus_ok
}

# O6_21-TGD-003 / O6_21-QPL-004: Nachweis nach Aufforderung, sofern keine Übermittlung durch Dritte.
program_violations contains {"rule_id": "O6_21-TGD-003", "reason": "Nachweis der TGD-Teilnahme trotz Aufforderung nicht übermittelt"} if {
	p := input.farm.programs.animal_health_service
	p.proof_requested_by_ama == true
	not p.transmitted_by_service == true
	not p.proof_submitted == true
}

program_violations contains {"rule_id": "O6_21-QPL-004", "reason": "Nachweis der Qplus-Rind-Teilnahme trotz Aufforderung nicht übermittelt"} if {
	p := input.farm.programs.qplus_rind
	p.proof_requested_by_ama == true
	not p.transmitted_by_service == true
	not p.proof_submitted == true
}
