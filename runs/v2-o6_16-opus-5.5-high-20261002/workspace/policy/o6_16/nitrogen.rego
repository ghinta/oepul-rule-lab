# o6_16 – Stickstoffbilanzierung und Übertrag auf die Folgekultur (4.3)
package oepul.o6_16

# Schwellenwert/Obergrenze je Antragsjahr der Folgekultur
carryover_row(yr) := row if {
	some row in params.n_carryover.threshold_rows
	row.year_from <= yr
	yr <= row.year_to
}

# Ist der Stickstoffüberschuss (vor Abzug des Reduktionsfaktors) anzurechnen?
carryover_required(saldo, yr) if saldo > carryover_row(yr).threshold_kg_ha_exclusive

# anzurechnender Überschuss: ab 2025 max. 100 kg N/ha vor Reduktionsfaktor (auch bei Schadereignissen)
capped_surplus(saldo, yr) := min([saldo, carryover_row(yr).cap_kg_ha]) if is_number(carryover_row(yr).cap_kg_ha)

capped_surplus(saldo, yr) := saldo if carryover_row(yr).cap_kg_ha == null

reduction_factor(zone) := row.factor if {
	some row in params.n_carryover.reduction_factor_zones
	row.zone == zone
}

# Zone eines Schlages: Wien ergibt sich aus Anhang G, sonst Profilangabe
parcel_zone(p) := "wien" if in_vienna_area(p)

parcel_zone(p) := p.n_reduction_zone if {
	not in_vienna_area(p)
	is_string(object.get(p, "n_reduction_zone", null))
}

# Mindestreduktion der Düngung der Folgekultur (kg N/ha)
required_n_reduction(saldo, yr, _) := 0 if not carryover_required(saldo, yr)

required_n_reduction(saldo, yr, zone) := round((capped_surplus(saldo, yr) * reduction_factor(zone)) * 100) / 100 if carryover_required(saldo, yr)

parcel_saldo(p) := p.previous_crop.n_saldo_kg_ha if is_number(object.get(p, ["previous_crop", "n_saldo_kg_ha"], null))

parcel_required_reduction(p) := required_n_reduction(parcel_saldo(p), year, parcel_zone(p))

n_carryover := {p.parcel_id: parcel_required_reduction(p) | some p in arable_in_area}

missing_data contains {"rule_id": "o6_16.n.carryover_reduction", "path": "land.parcels[].n_reduction_zone", "reason": sprintf("Schlag %v: Reduktionszone (80 %%/60 %%) nicht bestimmbar", [p.parcel_id])} if {
	some p in arable_in_area
	carryover_required(parcel_saldo(p), year)
	not parcel_zone(p)
}

# Düngung der Folgekultur ist um den Übertrag einzuschränken
violations contains {
	"rule_id": "o6_16.n.carryover_reduction",
	"parcel_id": p.parcel_id,
	"message": sprintf("Düngung der Folgekultur %v kg N/ha überschreitet Bedarf %v abzüglich Übertrag %v.", [fert, need, red]),
} if {
	some p in arable_in_area
	red := parcel_required_reduction(p)
	fert := p.n_management.follow_crop_n_fertilization_kg_ha
	need := p.n_management.follow_crop_n_requirement_kg_ha
	is_number(fert)
	is_number(need)
	fert > need - red
}

# Ungenutzte Zwischenfrucht: max. Düngung = Düngebedarf Folgekultur - Übertrag aus Vorkultur
max_unused_cover_crop_n(follow_need, transfer) := max([0, follow_need - transfer])

violations contains {
	"rule_id": "o6_16.n.unused_cover_crop_max",
	"parcel_id": p.parcel_id,
	"message": sprintf("Düngung der ungenutzten Zwischenfrucht %v kg N/ha über zulässigem Maximum %v.", [cc, maxn]),
} if {
	some p in arable_in_area
	cc := p.n_management.unused_cover_crop_n_kg_ha
	is_number(cc)
	maxn := max_unused_cover_crop_n(p.n_management.follow_crop_n_requirement_kg_ha, parcel_required_reduction(p))
	cc > maxn
}

# Reduktionsfaktor zwischen zwei Hauptkulturen nur einmal
violations contains {
	"rule_id": "o6_16.n.reduction_factor_once",
	"parcel_id": p.parcel_id,
	"message": "Reduktionsfaktor zwischen zwei Hauptkulturen mehr als einmal angewendet.",
} if {
	some p in arable_in_area
	object.get(p, ["n_management", "reduction_factor_applications"], 0) > params.n_carryover.max_reduction_factor_applications_between_main_crops
}

# Körnerleguminosen und Ackerfutter: Stickstoffbedarf statt ertragsabhängigem Entzug
legume_or_forage(pc) if object.get(pc, "crop_category", "") == "legume"

legume_or_forage(pc) if is_arable_forage_name(object.get(pc, "crop_name", ""))

violations contains {
	"rule_id": "o6_16.n.legume_offtake_basis",
	"parcel_id": p.parcel_id,
	"message": "Bei Körnerleguminosen/Ackerfutter ist im Saldo der Stickstoffbedarf statt des ertragsabhängigen Entzugs anzusetzen.",
} if {
	some p in arable_in_area
	legume_or_forage(object.get(p, "previous_crop", {}))
	object.get(p, ["n_management", "offtake_basis"], "") == "yield_based"
}

# Gemüse nach Gemüse mit Nmin-Analyse: Abzug mindestens in Höhe des Saldos der Vorkultur
vegetable_n_deduction(nmin, saldo) := max([nmin, saldo])

# ---------------------------------------------------------------------------
# Herbst-Anlageverpflichtung (Folgekultur bis 15.11. oder Zwischenfrucht o6_6/o6_7)
# ---------------------------------------------------------------------------

autumn := params.n_carryover.autumn_obligation

is_vegetable_or_pumpkin(pc) if object.get(pc, "crop_category", "") == "vegetable"

is_vegetable_or_pumpkin(pc) if name_in(object.get(pc, "crop_name", ""), general.definitions.feldgemuese)

is_vegetable_or_pumpkin(pc) if name_in(object.get(pc, "crop_name", ""), autumn.pumpkin_crop_names)

is_forage_or_fallow(pc) if object.get(pc, "crop_category", "") == "fallow"

is_forage_or_fallow(pc) if is_arable_forage_name(object.get(pc, "crop_name", ""))

harvested_late(pc) if {
	d := pc.harvest_date
	is_date(d)
	month_day(d) > autumn.late_harvest_after_month_day
}

# Auslöser, die durch späte Ernte (nach 30.09.) aufgehoben werden
autumn_trigger_harvest(p) if parcel_saldo(p) > autumn.saldo_threshold_kg_ha_exclusive

autumn_trigger_harvest(p) if {
	is_vegetable_or_pumpkin(object.get(p, "previous_crop", {}))
	p.area_ha > autumn.vegetable_pumpkin_min_parcel_ha_exclusive
}

# Umbruch von Ackerfutter oder Ackerbrache vor dem 15.11.
autumn_trigger_breakup(p) if {
	pc := object.get(p, "previous_crop", {})
	is_forage_or_fallow(pc)
	d := pc.breakup_date
	is_date(d)
	date_lt(d, md_date(date_year(d), autumn.deadline_month_day))
}

autumn_obligation_applies(p) if autumn_trigger_breakup(p)

autumn_obligation_applies(p) if {
	autumn_trigger_harvest(p)
	not harvested_late(object.get(p, "previous_crop", {}))
}

autumn_obligation_fulfilled(p) if {
	d := p.n_management.follow_crop_sowing_date
	is_date(d)
	date_le(d, md_date(autumn_reference_year(p), autumn.deadline_month_day))
}

autumn_obligation_fulfilled(p) if {
	object.get(p, ["operations", "cover_crop", "is_used"], false) == true
	some m in params.combination_obligation_measures
	participates(m)
}

autumn_reference_year(p) := date_year(p.previous_crop.breakup_date) if is_date(object.get(p, ["previous_crop", "breakup_date"], null))

autumn_reference_year(p) := date_year(p.previous_crop.harvest_date) if {
	not is_date(object.get(p, ["previous_crop", "breakup_date"], null))
	is_date(object.get(p, ["previous_crop", "harvest_date"], null))
}

autumn_reference_year(p) := year if {
	not is_date(object.get(p, ["previous_crop", "breakup_date"], null))
	not is_date(object.get(p, ["previous_crop", "harvest_date"], null))
}

violations contains {
	"rule_id": "o6_16.n.autumn_sowing_obligation",
	"parcel_id": p.parcel_id,
	"message": "Anlage einer Folgekultur bis 15.11. oder einer Zwischenfrucht gemäß o6_6/o6_7 erforderlich.",
} if {
	some p in arable_in_area
	autumn_obligation_applies(p)
	not autumn_obligation_fulfilled(p)
}
