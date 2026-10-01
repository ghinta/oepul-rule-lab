# Prämienberechnung Heuwirtschaft (Merkblatt Kap. 7, SRL 2.3.5, SRL 1.9, Anhang L).
package o6_3

# O6_3-PREM-01: Prämiensatz je Jahr, Tierhaltereigenschaft und Option.
rate_for(y, livestock, option) := row.eur_per_ha if {
	some row in data.o6_3.premium_rates.rows
	row.year_from <= y
	y <= row.year_to
	row.livestock_farm == livestock
	row.option_no_mower_conditioner == option
}

current_rate := rate_for(year, is_livestock_farm_bool, option_active_bool)

is_livestock_farm_bool if {
	is_livestock_farm
} else := false

option_active_bool if {
	option_active
} else := false

# O6_3-PREM-02: prämienfähige Flächen.
premium_area_class(p) := "grassland" if {
	p.land_use == "grassland"
	grassland_type(p) in premium_grassland_types
	is_mown(p)
}

premium_area_class(p) := "arable" if {
	p.land_use == "arable"
	forage_crop_type(p) in premium_forage_crop_ids
	not is_second_crop(p)
	is_mown(p)
}

# Ausschlüsse auf Einzelflächen (GEN-OP-01, GEN-AREA-01, GEN-AREA-02, GEN-COMB-02).
exclusion_rule_ids := {"GEN-OP-01", "GEN-AREA-01", "GEN-AREA-02", "GEN-COMB-02"}

parcel_exclusions(p) := {r | some r in exclusion_rule_ids; parcel_excluded_by(p, r)}

parcel_excluded_by(p, "GEN-OP-01") if "OP" in object.get(p, "oepul_codes", [])

parcel_excluded_by(p, "GEN-OP-01") if "o6_3" in object.get(p, "op_measures", [])

parcel_excluded_by(p, "GEN-AREA-01") if object.get(p, "non_eligible_area_type", null) in non_eligible_area_type_ids

non_eligible_area_type_ids := {t.id | some t in data.o6_3.area_eligibility.non_eligible_area_types}

parcel_excluded_by(p, "GEN-AREA-02") if {
	np := object.get(p, ["national_park", "name"], null)
	np in {n | some n in params.national_parks_without_area_premiums}
}

parcel_excluded_by(p, "GEN-AREA-02") if {
	object.get(p, ["national_park", "name"], null) != null
	object.get(p, ["national_park", "has_relevant_management_restrictions"], false) == true
}

parcel_excluded_by(p, "GEN-COMB-02") if {
	some m in parcel_measures(p)
	m != "o6_3"
	not single_parcel_combinable("o6_3", m)
}

# GEN-COMB-02: Anhang L – Kombinierbarkeit auf der Einzelfläche.
single_parcel_combinable(a, b) if {
	some cell in data.o6_3.combination_table.cells
	cell.row_measure == a
	cell.col_measure == b
}

single_parcel_combinable(a, b) if {
	a == "o6_3"
	b in {"o6_1a", "o6_1b", "o6_1b_teilbetrieb"}
}

premium_parcels := [{"parcel_id": p.parcel_id, "class": premium_area_class(p), "area_ha": p.area_ha} |
	some p in parcels
	premium_area_class(p)
	count(parcel_exclusions(p)) == 0
]

premium_grassland_area_ha := sum([pp.area_ha | some pp in premium_parcels; pp.class == "grassland"])

premium_arable_area_ha := sum([pp.area_ha | some pp in premium_parcels; pp.class == "arable"])

# GEN-AREA-INC-01: Flächenzugang auf Grünland ab 2026 max. +50 % bzw. +5 ha gegenüber 2025.
area_change := object.get(o6_3_input, "area_change", {})

base_2025_grassland_ha := object.get(area_change, "base_2025_grassland_measure_area_ha", null)

allowed_grassland_increase_ha := max([
	base_2025_grassland_ha * params.area_increase_restriction.max_increase_share,
	params.area_increase_restriction.always_allowed_increase_ha,
]) if {
	is_number(base_2025_grassland_ha)
}

eligible_grassland_area_ha := min([premium_grassland_area_ha, base_2025_grassland_ha + allowed_grassland_increase_ha]) if {
	"o6_3_grassland" in data.o6_3.measure_lists.area_increase_restricted_measures
	year > params.area_increase_restriction.base_year
	is_number(base_2025_grassland_ha)
} else := premium_grassland_area_ha

eligible_area_ha := eligible_grassland_area_ha + premium_arable_area_ha

# O6_3-PREM-01 / O6_3-PREM-03: Bruttoprämie (vor Kürzungen und Modulation).
premium_gross_eur := round((eligible_area_ha * current_rate) * 100) / 100 if {
	premium_payable_year
} else := 0

premium_payable_year if {
	contract_established
	not premium_blocked
}

premium_payable_year if {
	not is_first_contract_year
	within_contract_period
	access_requirements_met
	not premium_blocked
}

# GEN-EXIT-02, SRL-ZA-01, SRL-VOK-01: Gründe, aus denen im Antragsjahr keine Prämie gewährt wird.
premium_blocked if exited_without_recognition

premium_blocked if no_payment_missing_application

premium_blocked if control_refused

premium_blocked if excluded_from_measure

# GEN-MOD-01: Betriebsgrößenmodulation.
modulation_factor(total_ha) := 1 if total_ha <= 0

modulation_factor(total_ha) := f if {
	total_ha > 0
	parts := [part |
		some b in data.o6_3.modulation.brackets
		upper := bracket_upper(b, total_ha)
		upper > b.from_ha
		part := (upper - b.from_ha) * b.payout_share
	]
	f := sum(parts) / total_ha
}

bracket_upper(b, total_ha) := min([b.to_ha, total_ha]) if b.to_ha != null

bracket_upper(b, total_ha) := total_ha if b.to_ha == null

farm_total_area_ha := object.get(input, ["land", "total_area_ha"], 0)

premium_after_modulation_eur := round((premium_gross_eur * modulation_factor(farm_total_area_ha)) * 100) / 100

# SRL-PAY-02: Auszahlungsbetrag bis 50 Euro kann entfallen.
payout_may_be_waived if premium_after_modulation_eur <= params.payment.minimum_payout_eur

# GEN-CAP-01: Obergrenze der flächenbezogenen Zahlungen je ha.
cap_type(p) := "o6_18_o6_19" if {
	some m in parcel_measures(p)
	m in {"o6_18", "o6_19"}
} else := "general"

cap_for(y, t) := row.eur_per_ha if {
	some row in data.o6_3.premium_caps.rows
	row.cap_type == t
	row.year_from <= y
	y <= row.year_to
}

cap_exceeded_parcels contains p.parcel_id if {
	some pp in premium_parcels
	some p in parcels
	p.parcel_id == pp.parcel_id
	other := object.get(p, "other_capped_oepul_payments_eur_per_ha", 0)
	other + current_rate > cap_for(year, cap_type(p))
}

# NAT-GM01: Zuschlag im Naturschutz bei Teilnahme an der Heuwirtschaft (Anhang I).
naturschutz_gm01_surcharge_eur_per_ha := row.surcharge_if_o6_3_eur_per_ha if {
	"o6_3" in participating_measures
	some row in data.o6_3.naturschutz_interaction.rows
	row.code == "GM01"
}
