# Förderfähigkeit von Flächen, Prämienberechnung, Kombinierbarkeit, Modulation und Auszahlung
# (Informationsblatt 1C Kap. 1, 7; Allgemeine Teilnahmebedingungen Kap. 5.5, 5.5.1, 5.5.2, 5.6, 5.8,
# 9.1–9.3; SRL Punkte 1.4.2, 1.6.2, 1.9, 1.10.7, 2.1C Höhe der Förderung; Anhang L).
package oepul.o6_1c

area_eligibility := data.o6_1c.area_eligibility

rates := {r.category: r | some r in data.o6_1c.premium_rates}

# --- Kombinierbarkeit laut Anhang L -------------------------------------------------

combinable_on_single_area(a, b) if {
	some c in data.o6_1c.anhang_l_combination.cells
	c.row == a
	c.column == b
	c.combinable == true
}

# O61C-COMB-002: Zeile/Spalte 1C der Kombinationstabelle ist leer.
combinable_measures_1c := {c.column |
	some c in data.o6_1c.anhang_l_combination.cells
	c.row == params.measure_code
	c.combinable == true
}

# --- Flächenbezogene Förderfähigkeit ------------------------------------------------

national_park_premium_rule(name) := r.area_premiums if {
	some r in area_eligibility.national_parks
	r.name == name
} else := "all"

# Gründe, aus denen für eine Fläche (Schlag oder Agroforststreifen) keine 1C-Prämie gewährt wird.
area_exclusion(a, "O61C-GEN-ELIG-004") if {
	some code in parcel_codes(a)
	code in area_eligibility.no_premium_codes
}

area_exclusion(a, "O61C-GEN-ELIG-003") if {
	np := object.get(parcel_status(a), "national_park", null)
	np != null
	national_park_premium_rule(np) == "none_except_23_24"
}

area_exclusion(a, "O61C-GEN-ELIG-006") if object.get(parcel_status(a), "in_austria", true) == false

area_exclusion(a, "O61C-GEN-ELIG-002") if object.get(parcel_status(a), "is_gloez_landscape_element", false) == true

area_exclusion(a, "O61C-GEN-ELIG-005") if object.get(parcel_status(a), "scientific_trial_area", false) == true

area_exclusion(a, "O61C-GEN-ELIG-007") if object.get(parcel_status(a), "overlapping_public_funding", false) == true

area_exclusion(a, "O61C-GEN-ELIG-007") if object.get(parcel_status(a), "authority_mandated_compensation_area", false) == true

area_exclusion(a, "O61C-GEN-DUR-001") if object.get(parcel_status(a), "commitment_not_fulfillable_full_year", false) == true

area_exclusion(a, "O61C-GEN-ELIG-008") if object.get(parcel_status(a), "noncompliance_third_party_fault", false) == true

area_exclusion_ids := [
	"O61C-GEN-ELIG-002", "O61C-GEN-ELIG-003", "O61C-GEN-ELIG-004", "O61C-GEN-ELIG-005",
	"O61C-GEN-ELIG-006", "O61C-GEN-ELIG-007", "O61C-GEN-ELIG-008", "O61C-GEN-DUR-001",
]

area_exclusions(a) := {id | some id in area_exclusion_ids; area_exclusion(a, id)}

# Fälle, in denen eine OP-Codierung verpflichtend ist, die aber fehlt.
op_code_required(a) if object.get(parcel_status(a), "overlapping_public_funding", false) == true

op_code_required(a) if object.get(parcel_status(a), "authority_mandated_compensation_area", false) == true

op_code_required(a) if object.get(parcel_status(a), "commitment_not_fulfillable_full_year", false) == true

op_code_required(a) if object.get(parcel_status(a), "noncompliance_third_party_fault", false) == true

has_op_code(a) if {
	some code in parcel_codes(a)
	startswith(code, "OP")
}

eligibility_violations contains v if {
	some a in array.concat(parcels, agroforestry_strips)
	op_code_required(a)
	not has_op_code(a)
	id := object.get(a, "parcel_id", object.get(a, "strip_id", "unknown"))
	v := {"rule_id": "O61C-GEN-ELIG-004", "scope": id, "message": "Verpflichtende OP-Codierung fehlt"}
}

# O61C-PREM-005: NPA-Flächenteile, die als GLÖZ 4-Pufferstreifen ausgewiesen sind, sind nicht förderbar.
npa_gloez4_area_ha(p) := min_of(object.get(p, ["constraints", "gloez4_buffer_area_ha"], 0), object.get(p, "area_ha", 0))

npa_parcel_eligible(p) if {
	object.get(p, "land_use", null) == "arable"
	params.npa_code in parcel_codes(p)
	object.get(p, "schlagnutzungsart", null) == params.npa_schlagnutzungsart
	count(area_exclusions(p)) == 0
}

npa_eligible_parcel_area_ha(p) := object.get(p, "area_ha", 0) - npa_gloez4_area_ha(p) if npa_parcel_eligible(p)

npa_eligible_area_ha := sum([npa_eligible_parcel_area_ha(p) | some p in npa_parcels; npa_parcel_eligible(p)])

# O61C-PREM-001: NPA-Prämie bis maximal 4 % der Ackerfläche.
npa_area_cap_ha := params.npa_max_share_of_arable_area * arable_area_ha

default npa_premium_area_ha := 0

npa_premium_area_ha := min_of(npa_eligible_area_ha, npa_area_cap_ha) if contract_valid_for_category("npa")

afs_strip_eligible(s) if {
	afs_meets_definition(s)
	object.get(s, "schlagnutzungsart", null) == params.afs_schlagnutzungsart
	count(area_exclusions(s)) == 0
}

default afs_premium_area_ha := 0

afs_premium_area_ha := sum([object.get(s, "area_ha", 0) | some s in agroforestry_strips; afs_strip_eligible(s)]) if {
	contract_valid_for_category("afs")
}

# Beträge werden auf Cent gerundet.
round_eur(x) := round(x * 100) / 100

# O61C-PREM-001 / O61C-PREM-002: Prämienbänder (garantierter Mindestbetrag, Höchstbetrag).
npa_premium_band := {
	"area_ha": npa_premium_area_ha,
	"min_eur": round_eur(npa_premium_area_ha * rates.npa.rate_min_eur_per_ha),
	"max_eur": round_eur(npa_premium_area_ha * rates.npa.rate_max_eur_per_ha),
}

afs_premium_band := {
	"area_ha": afs_premium_area_ha,
	"min_eur": round_eur(afs_premium_area_ha * rates.afs.rate_min_eur_per_ha),
	"max_eur": round_eur(afs_premium_area_ha * rates.afs.rate_max_eur_per_ha),
}

# --- Modulation (Allgemeine Teilnahmebedingungen 9.3, SRL 1.9.2.2) -------------------

tier_upper(t, total) := total if t.to_ha == null

tier_upper(t, _) := t.to_ha if t.to_ha != null

tier_portion(t, total) := max_of(0, min_of(total, tier_upper(t, total)) - t.from_ha)

modulated_amount_ha(total) := sum([x | some t in data.o6_1c.modulation_tiers; x := tier_portion(t, total) * t.payout_share])

modulation_factor(total) := 1 if total <= 0

modulation_factor(total) := modulated_amount_ha(total) / total if total > 0

farm_modulation_factor := modulation_factor(total_area_ha)

premium_estimate := {
	"npa": npa_premium_band,
	"afs": afs_premium_band,
	"modulation_factor": farm_modulation_factor,
	"total_min_eur": round_eur((npa_premium_band.min_eur + afs_premium_band.min_eur) * farm_modulation_factor),
	"total_max_eur": round_eur((npa_premium_band.max_eur + afs_premium_band.max_eur) * farm_modulation_factor),
}

# O61C-GEN-PAY-003: Von der Gewährung kann abgesehen werden, wenn der Auszahlungsbetrag 50 Euro nicht überschreitet.
default payment_may_be_waived := false

payment_may_be_waived if premium_estimate.total_min_eur <= params.min_payout_eur

# --- Obergrenze für Flächenzahlungen (Allgemeine Teilnahmebedingungen 9.2) ----------

applicable_general_cap := c if {
	some c in data.o6_1c.area_payment_caps
	c.scope == "general"
	c.year_from <= year
	c.year_to == null
}

applicable_general_cap := c if {
	some c in data.o6_1c.area_payment_caps
	c.scope == "general"
	c.year_from <= year
	c.year_to != null
	year <= c.year_to
}

# O61C-GEN-CAP-001: Ab 2025 werden 1C-Zahlungen nicht in die Obergrenze von 1.300 €/ha eingerechnet.
default included_in_area_payment_cap := false

included_in_area_payment_cap if not params.measure_code in applicable_general_cap.excluded_measures

# --- Auszahlung (Allgemeine Teilnahmebedingungen 9.1, SRL 1.10.7) -------------------

payment_deadline := date_of(year + 1, params.payment_deadline_month_day_following_year)

max_advance_payment_eur := premium_estimate.total_max_eur * params.max_advance_payment_share

# --- Mindestbewirtschaftung (SRL 1.6.2.1, 1.6.3.4) ------------------------------------

# O61C-GEN-ELIG-001: NPA und AFS in 1C sind von den Mindestbewirtschaftungskriterien ausgenommen.
default exempt_from_min_management := false

exempt_from_min_management if {
	some e in area_eligibility.min_management_exempt_areas
	params.measure_code in e.measures
}

# O61C-GEN-ELIG-009: Selbstbegrünung bei NPA ersetzt die ordnungsgemäße Anlage einer Gründecke.
default self_greening_allowed_for_npa := false

self_greening_allowed_for_npa if {
	some c in area_eligibility.min_management_criteria
	c.land_category == "taken_out_of_production"
	some r in c.requirements
	contains(r, "Selbstbegrünung")
}
