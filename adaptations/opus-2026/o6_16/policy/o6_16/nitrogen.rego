# Stickstoffbilanzierung, Übertrag auf die Folgekultur, Herbstbegrünung (Kapitel 4.3 Informationsblatt; SRL 2.16;
# NAPV Anlage 3 Abschnitte II–V; AMA-Hinweis vom 25.08.2026).
package oepul.o6_16

import data.o6_16 as d

nb(p) := object.get(p, "n_balance", {})

# --- Parameter je Antragsjahr der Folgekultur (bis 2024: > 10 kg/ha; ab 2025: > 20 kg/ha, max. 100 kg/ha) ---
n_params(y) := p if {
	some p in d.n_carryover_parameters
	y >= p.year_from
	y <= p.year_to
}

capped_surplus(s, params) := s if params.surplus_cap_kg_ha == null

capped_surplus(s, params) := min_of(s, params.surplus_cap_kg_ha) if params.surplus_cap_kg_ha != null

round2(x) := round(x * 100) / 100

# Anzurechnender Stickstoffübertrag (kg N/ha) aus dem Saldo der Vorkultur
n_carryover_kg_ha(surplus, app_year, _) := 0 if surplus <= n_params(app_year).surplus_threshold_kg_ha

n_carryover_kg_ha(surplus, app_year, factor) := c if {
	params := n_params(app_year)
	surplus > params.surplus_threshold_kg_ha
	c := round2(capped_surplus(surplus, params) * factor)
}

# Mindest-Reduktionsfaktor: 80 % (nördl./mittl. Burgenland, östl. NÖ inkl. Tullnerfeld, Wien), sonst 60 %
zone_factor(zone) := z.min_reduction_factor if {
	some z in d.n_reduction_zones
	z.zone == zone
}

parcel_reduction_factor(p) := 0.8 if parcel_area_state(p) == "Wien"

parcel_reduction_factor(p) := f if {
	parcel_area_state(p) != "Wien"
	f := zone_factor(object.get(p, "n_reduction_zone", "other"))
}

parcel_reduction_factor(p) := 0.6 if {
	parcel_area_state(p) != "Wien"
	not object.get(p, "n_reduction_zone", "other") in {z.zone | some z in d.n_reduction_zones}
}

# Ungenutzte Zwischenfrucht ohne Anlage gemäß Maßnahme 6/7: kein Reduktionsfaktor (voller Übertrag)
effective_factor(p) := 1.0 if {
	object.get(nb(p), "unused_catch_crop", false) == true
	object.get(nb(p), "catch_crop_per_measure_6_or_7", false) != true
}

effective_factor(p) := parcel_reduction_factor(p) if {
	not unused_catch_crop_without_measure(p)
}

unused_catch_crop_without_measure(p) if {
	object.get(nb(p), "unused_catch_crop", false) == true
	object.get(nb(p), "catch_crop_per_measure_6_or_7", false) != true
}

following_crop_year(p) := object.get(nb(p), "following_crop_application_year", year)

required_carryover(p) := n_carryover_kg_ha(s, following_crop_year(p), effective_factor(p)) if {
	s := object.get(nb(p), "previous_crop_n_saldo_kg_ha", null)
	s != null
}

obligation_violations contains v if {
	some p in area_parcels
	req := required_carryover(p)
	applied := object.get(nb(p), "following_crop_n_reduction_kg_ha", 0)
	applied < req
	v := {
		"rule_id": "O616-NB-001",
		"parcel_id": p.parcel_id,
		"message": sprintf("Düngung der Folgekultur um %v kg N/ha reduziert, erforderlich mind. %v kg N/ha", [applied, req]),
	}
}

# Reduktionsfaktor zwischen zwei Hauptkulturen nur einmal anwendbar
obligation_violations contains v if {
	some p in area_parcels
	object.get(nb(p), "reduction_factor_applications_between_main_crops", 0) > 1
	v := {
		"rule_id": "O616-NB-006",
		"parcel_id": p.parcel_id,
		"message": "Reduktionsfaktor zwischen zwei Hauptkulturen mehrfach angewendet",
	}
}

# Düngung ungenutzter Zwischenfrüchte: max. Düngebedarf der Folgekultur abzüglich Übertrag der Vorkultur
unused_catch_crop_max_n(p) := max_of(0, demand - carry) if {
	object.get(nb(p), "unused_catch_crop", false) == true
	demand := object.get(nb(p), "following_main_crop_n_demand_kg_ha", null)
	demand != null
	carry := object.get(nb(p), "carryover_after_factor_kg_ha", required_carryover_or_zero(p))
}

required_carryover_or_zero(p) := c if c := required_carryover(p)

required_carryover_or_zero(p) := 0 if not required_carryover(p)

obligation_violations contains v if {
	some p in area_parcels
	limit := unused_catch_crop_max_n(p)
	applied := object.get(nb(p), "unused_catch_crop_n_applied_kg_ha", 0)
	applied > limit
	v := {
		"rule_id": "O616-NB-007",
		"parcel_id": p.parcel_id,
		"message": sprintf("Ungenutzte Zwischenfrucht mit %v kg N/ha gedüngt, zulässig max. %v kg N/ha", [applied, limit]),
	}
}

# Auf ungenutzte Zwischenfrüchte ausgebrachter Stickstoff ist zur Gänze der Folgekultur anzurechnen
n_credit_to_following_main_crop(p) := required_carryover_or_zero(p) + object.get(nb(p), "unused_catch_crop_n_applied_kg_ha", 0)

# Gemüse mit Nmin-Analyse: Abzug mindestens in Höhe des Stickstoffsaldos der Vorkultur
vegetable_min_deduction(p) := max_of(nmin, saldo) if {
	nmin := object.get(nb(p), "vegetable_nmin_analysis_kg_ha", null)
	nmin != null
	saldo := object.get(nb(p), "previous_crop_n_saldo_kg_ha", 0)
	parcel_crop_name(p) in field_vegetable_set
	object.get(nb(p), "previous_crop_name", "") in field_vegetable_set
}

obligation_violations contains v if {
	some p in area_parcels
	req := vegetable_min_deduction(p)
	applied := object.get(nb(p), "vegetable_nmin_deduction_kg_ha", 0)
	applied < req
	v := {
		"rule_id": "O616-NB-009",
		"parcel_id": p.parcel_id,
		"message": sprintf("Nmin-Abzug %v kg N/ha geringer als Stickstoffsaldo der Vorkultur (%v kg N/ha)", [applied, req]),
	}
}

field_vegetable_set := {v | some v in d.field_vegetables}

pumpkin_crops := {"Kürbis", "Ölkürbis", "Speisekürbis"}

# --- Herbstbegrünung: Anlage einer Folgekultur bis 15.11. oder einer Zwischenfrucht gemäß Maßnahme 6/7 ---
autumn_cover_trigger(p) if object.get(nb(p), "previous_crop_n_saldo_kg_ha", 0) > 30

autumn_cover_trigger(p) if {
	p.area_ha > 0.3
	prev := object.get(nb(p), "previous_crop_name", "")
	prev in (field_vegetable_set | pumpkin_crops)
}

autumn_cover_trigger(p) if object.get(nb(p), "fallow_ploughed_before_nov15", false) == true

autumn_cover_trigger(p) if arable_forage_ploughed(p)

arable_forage_ploughed(p) if object.get(nb(p), "arable_forage_ploughed_before_nov15", false) == true

autumn_cover_exempt(p) if {
	object.get(nb(p), "previous_crop_harvested_after_sep30", false) == true
	not arable_forage_ploughed(p)
}

autumn_cover_established(p) if object.get(nb(p), "follow_crop_sown_by_nov15", false) == true

autumn_cover_established(p) if object.get(nb(p), "catch_crop_per_measure_6_or_7", false) == true

obligation_violations contains v if {
	some p in area_parcels
	autumn_cover_trigger(p)
	not autumn_cover_exempt(p)
	not autumn_cover_established(p)
	v := {
		"rule_id": "O616-NB-005",
		"parcel_id": p.parcel_id,
		"message": "Keine Folgekultur bis 15.11. bzw. keine Zwischenfrucht gemäß Maßnahme 6/7 angelegt",
	}
}

# --- Stickstoffsaldo innerhalb von 14 Tagen nach der Ernte berechnen; jährlicher Saldo bei mehrjährigen Kulturen ---
obligation_violations contains v if {
	some p in area_parcels
	delay := object.get(nb(p), "saldo_calculation_delay_days", 0)
	delay > 14
	v := {
		"rule_id": "O616-NB-010",
		"parcel_id": p.parcel_id,
		"message": "Stickstoffsaldo nicht innerhalb von 14 Tagen nach der Ernte berechnet",
	}
}

obligation_violations contains v if {
	some p in area_parcels
	object.get(nb(p), "perennial_crop", false) == true
	object.get(nb(p), "annual_saldo_calculated", true) == false
	v := {
		"rule_id": "O616-NB-008",
		"parcel_id": p.parcel_id,
		"message": "Bei mehrjährigen Kulturen ist jährlich ein Saldo zu bilden",
	}
}

# --- Schlagbezogener Stickstoffsaldo (NAPV Anlage 3 Abschnitt V Tabelle 3) ---
uptake_factor_record(crop, diff) := r if {
	some r in d.napv_anlage3_a5_uptake_factors
	r.crop == crop
	r.differentiation == diff
}

grid_key(x) := sprintf("%.1f", [x])

wheat_barley_uptake(column, protein, moisture) := val if {
	some r in d.napv_anlage3_a5_wheat_barley_uptake
	r.crude_protein_percent_dm == protein
	val := r[column][grid_key(moisture)]
	val != null
}

# Körnerleguminosen und Ackerfutter: Stickstoffbedarf statt ertragsabhängigem Entzugsfaktor
legume_n_demand(b) := object.get(b, "crop_n_demand_kg_ha", default_legume_demand(b))

default_legume_demand(b) := 60 if object.get(b, "legume_footnote1", false) == true

default_legume_demand(b) := 0 if object.get(b, "legume_footnote1", false) != true

crop_uptake_kg_ha(b) := legume_n_demand(b) if {
	r := uptake_factor_record(b.uptake_crop, object.get(b, "uptake_differentiation", null))
	r.is_grain_or_forage_legume
}

crop_uptake_kg_ha(b) := u if {
	r := uptake_factor_record(b.uptake_crop, object.get(b, "uptake_differentiation", null))
	not r.is_grain_or_forage_legume
	r.n_uptake_kg_per_t != null
	u := r.n_uptake_kg_per_t * b.harvest_t_ha
}

crop_uptake_kg_ha(b) := u if {
	b.uptake_crop == "Weizen"
	u := wheat_barley_uptake("wheat", b.crude_protein_percent_dm, b.grain_moisture_percent) * b.harvest_t_ha
}

crop_uptake_kg_ha(b) := u if {
	b.uptake_crop == "Braugerste"
	u := wheat_barley_uptake("brewing_barley", b.crude_protein_percent_dm, b.grain_moisture_percent) * b.harvest_t_ha
}

# N-Saldo = Vorfruchtwirkung + aktive Düngung (+ N aus Bewässerung) − Entzug durch Ernte
computed_n_saldo(p) := round2(supply - crop_uptake_kg_ha(b)) if {
	b := nb(p)
	supply := (object.get(b, "previous_crop_effect_kg_ha", 0) + object.get(b, "crop_n_applied_kg_ha", 0)) + object.get(b, "irrigation_n_kg_ha", 0)
}

# Stickstoffmenge durch Bewässerungswasser (NAPV Anlage 3 Abschnitt IV), abzuziehen ab 10 kg N/ha
irrigation_n_kg_ha(nitrate_mg_l, irrigation_mm) := round2(((nitrate_mg_l / 4.43) * irrigation_mm) / 100)

irrigation_n_relevant(nitrate_mg_l, irrigation_mm) if irrigation_n_kg_ha(nitrate_mg_l, irrigation_mm) >= 10
