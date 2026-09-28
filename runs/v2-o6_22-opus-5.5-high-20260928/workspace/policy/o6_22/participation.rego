# Tierwohl – Schweinehaltung (o6_22): applications, contract validity, entry
# deadlines, withdrawals, participating GVE and minimum participation.
package oepul.o6_22

# Rule: O622-APP-01 / O622-GEN-APP-01 (Maßnahmenantrag by 31 December before contract start)
application_deadline(first_commitment_year) := year_end(first_commitment_year - 1)

application_timely(a) if a.applied_on <= application_deadline(a.first_commitment_year)

# Rule: O622-APP-02 / O622-GEN-ONEYEAR-01 (last entry into categories: commitment year 2027)
category_application_valid(a) if {
	a.measure_category in object.keys(measure_categories)
	a.first_commitment_year >= params.first_programme_year
	a.first_commitment_year <= params.last_entry_commitment_year_categories
	application_timely(a)
}

# Rule: O622-APP-03 / O622-GEN-SUPP-APP-01 (supplements via Maßnahmenantrag; last entry commitment year 2028)
supplement_application_valid(s) if {
	s.first_commitment_year >= params.first_programme_year
	s.first_commitment_year <= params.last_entry_commitment_year_supplements
	application_timely(s)
	supplement_start_allowed(s)
	supplement_scope_allowed(s)
}

# Rule: O622-SUP-COMP-01 (Festmistkompostierung only from application year 2025)
supplement_start_allowed(s) if s.supplement in {"unkupiert", "gvo_frei_eiweiss"}

supplement_start_allowed(s) if {
	s.supplement == "festmistkompostierung"
	s.first_commitment_year >= params.festmist_supplement_first_year
}

# Rule: O622-SUP-UNK-03 (undocked supplement only for Ferkel and Jung-/Mastschweine)
supplement_scope_allowed(s) if s.supplement in {"gvo_frei_eiweiss", "festmistkompostierung"}

supplement_scope_allowed(s) if {
	s.supplement == "unkupiert"
	measure_categories[s.measure_category].undocked_supplement_available == true
}

withdrawals := object.get(app, "withdrawals", [])

withdrawal_covers_category(w, _) if w.scope == "measure"

withdrawal_covers_category(w, c) if {
	w.scope == "category"
	w.measure_category == c
}

withdrawal_covers_supplement(w, _) if w.scope == "measure"

withdrawal_covers_supplement(w, s) if {
	w.scope == "supplement"
	w.supplement == s.supplement
	object.get(w, "measure_category", null) == null
}

withdrawal_covers_supplement(w, s) if {
	w.scope == "supplement"
	w.supplement == s.supplement
	w.measure_category == object.get(s, "measure_category", null)
}

# Rule: O622-EXIT-01 / O622-EXIT-02 / O622-GEN-EXIT-01 / O622-GEN-REENTRY-01
# A withdrawal notified during a calendar year makes the measure (category,
# supplement) invalid for that whole year and ends the contract thereafter.
category_application_terminated(a) if {
	some w in withdrawals
	withdrawal_covers_category(w, a.measure_category)
	year_of(w.notified_on) >= a.first_commitment_year
	year_of(w.notified_on) <= year
}

supplement_application_terminated(s) if {
	some w in withdrawals
	withdrawal_covers_supplement(w, s)
	year_of(w.notified_on) >= s.first_commitment_year
	year_of(w.notified_on) <= year
}

# Rule: O622-CONTRACT-02 (automatic extension of categories unless withdrawn)
active_categories contains a.measure_category if {
	some a in object.get(app, "category_applications", [])
	category_application_valid(a)
	a.first_commitment_year <= year
	not category_application_terminated(a)
}

# Rule: O622-CONTRACT-02 (automatic extension of supplements unless withdrawn)
active_supplement_keys contains {"supplement": s.supplement, "measure_category": object.get(s, "measure_category", null)} if {
	some s in object.get(app, "supplement_applications", [])
	supplement_application_valid(s)
	s.first_commitment_year <= year
	not supplement_application_terminated(s)
}

# Rule: O622-SUP-UNK-01 / O622-SUP-GVO-01 / O622-SUP-COMP-01 (supplement applies per participating category)
supplement_active_for(sup, c) if {
	some k in active_supplement_keys
	k.supplement == sup
	k.measure_category == c
	c in active_categories
}

supplement_active_for(sup, c) if {
	some k in active_supplement_keys
	k.supplement == sup
	sup != "unkupiert"
	k.measure_category == null
	c in active_categories
}

# Invalid applications are reported so that they are not silently ignored.
violations contains {
	"rule_id": "O622-APP-01",
	"severity": "application_invalid",
	"message": sprintf("Category application %v is late, outside the entry window or unknown", [a.measure_category]),
} if {
	some a in object.get(app, "category_applications", [])
	not category_application_valid(a)
}

violations contains {
	"rule_id": "O622-APP-03",
	"severity": "application_invalid",
	"message": sprintf("Supplement application %v is late, outside the entry window or not offered for this category", [s.supplement]),
} if {
	some s in object.get(app, "supplement_applications", [])
	not supplement_application_valid(s)
}

participating_groups := {i: g |
	some i, g in category_groups
	category_of(g) in active_categories
}

category_head_count(c) := sum([group_count(g) | some g in category_groups; category_of(g) == c])

# Rule: O622-REPORT-01 (deregistered annual-average head count per category)
deregistered_count(c) := sum([d.average_count |
	some d in object.get(app, "deregistrations", [])
	d.measure_category == c
])

# Rule: O622-PREM-GVE-01 / O622-REPORT-03 / O622-SUP-UNK-04 (applied head count minus deregistered head count)
premium_head_count(c) := max([0, category_head_count(c) - deregistered_count(c)])

# Rule: O622-PREM-GVE-01 / O622-GVE-01
category_gve[c] := r2(premium_head_count(c) * measure_categories[c].gve_per_head) if {
	some c in active_categories
}

participating_gve := r2(sum([v | some v in category_gve]))

# Rule: O622-ELIG-01 (at least 2.00 GVE over all applied categories)
min_participation_met if participating_gve >= params.min_participation_gve

measure_applied if count(active_categories) > 0

# Rule: O622-CONTRACT-03 / O622-GEN-ACCESS-01 (access condition not met: no valid contract for the year)
violations contains {
	"rule_id": "O622-ELIG-01",
	"severity": "access_condition",
	"message": sprintf("Participating GVE %v below minimum of %v GVE; the contract for the measure lapses", [participating_gve, params.min_participation_gve]),
} if {
	measure_applied
	not min_participation_met
}

# Rule: O622-APP-07 (category without any premium-eligible animal lapses automatically)
category_contract_lapsed contains c if {
	some c in active_categories
	premium_head_count(c) <= 0
}

violations contains {
	"rule_id": "O622-APP-07",
	"severity": "contract_lapse",
	"message": sprintf("No premium-eligible animal in category %v; the category contract lapses and a new timely application is required", [c]),
} if {
	some c in category_contract_lapsed
}
