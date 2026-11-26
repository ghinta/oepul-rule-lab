package oepul.o6_2

import rego.v1

# Für jeden Biogasanlagen-Rücklauf sind kumulierte, vergleichbare Mengen zu verwenden.
fertilizer_status(f) := "verboten" if f.kind in {"Klärschlamm", "Anderer organischer Rückstand"}

else := "verboten" if f.kind in t.residue_examples

else := "erlaubt" if {
	f.kind == "Häusliches Abwasser"
	f.external == false
}

else := "erlaubt" if f.kind in t.manures

else := "erlaubt" if {
	f.kind == "Kompost"
	f.eu_organic_allowed
}

else := "erlaubt" if {
	f.kind == "Biogasgülle"
	f.own_slurry_delivered > 0
	is_number(f.own_slurry_delivered)
	is_number(f.cumulative_return)
	f.cumulative_return >= 0
	f.cumulative_return <= f.own_slurry_delivered
}

else := "verboten" if {
	f.kind == "Biogasgülle"
	is_number(f.own_slurry_delivered)
	is_number(f.cumulative_return)
	f.cumulative_return > f.own_slurry_delivered
}

else := "erlaubt" if {
	f.kind == "Einzel-/Mehrnährstoffdünger"
	f.contains_n == false
}

else := "verboten" if {
	f.external
	f.contains_n
	f.kind == "Kompost"
	f.eu_organic_allowed == false
}

else := "verboten" if {
	f.external
	f.contains_n
	f.kind in {"Einzel-/Mehrnährstoffdünger", "Häusliches Abwasser", "Sonstiger Dünger"}
}

else := "erlaubt" if {
	f.external == false
	f.kind in {"Einzel-/Mehrnährstoffdünger", "Sonstiger Dünger", "Kompost"}
}

fertilizer_findings contains {"parcel": p.parcel_id, "index": i, "status": s} if {
	some p in input.land.parcels
	p.mfa.country == "AT"
	p.mfa.agricultural_area
	some i, f in p.operations.fertilizer.applications
	s := fertilizer_status(f)
}

nitrogen_per_ha := net / n.agricultural_ha_at if {
	n := input.livestock.nitrogen
	n.year == year
	n.agricultural_ha_at > 0
	n.livestock_n_at_kg >= 0
	n.housing_storage_loss_kg >= 0
	n.alpine_and_common_grazing_n_kg >= 0
	net := (n.livestock_n_at_kg - n.housing_storage_loss_kg) - n.alpine_and_common_grazing_n_kg
	net >= 0
}

nitrogen_ok := nitrogen_per_ha <= 170

sensitive(p) if p.land_use == "grassland"

sensitive(p) if {
	p.land_use == "arable"
	forage_crop(p.crop.crop_name)
}

area_application(e) if e.method in {"flächig", "Horstbehandlung", "Saatgutbeizung"}

psm_status(p, e) := "verboten" if {
	sensitive(p)
	e.method == "Saatgutbeizung"
}

else := "erlaubt" if {
	sensitive(p)
	e.method == "Einzelpflanze"
}

else := "erlaubt" if {
	sensitive(p)
	area_application(e)
	e.all_actives_organic_allowed
}

else := "verboten" if {
	sensitive(p)
	area_application(e)
	e.all_actives_organic_allowed == false
}

else := "erlaubt" if {
	p.land_use == "arable"
	known_nonforage(p)
	e.baes_use_authorised
}

else := "verboten" if {
	p.land_use == "arable"
	known_nonforage(p)
	e.baes_use_authorised == false
}

psm_findings contains {"parcel": p.parcel_id, "index": i, "status": s} if {
	some p in input.land.parcels
	p.mfa.country == "AT"
	some i, e in p.operations.psm_applications
	s := psm_status(p, e)
}

required_psm_codes(p) := set() if year >= 2026

else := {t.psm_codes.synthetic} if {
	year >= 2023
	sensitive(p)
	some e in p.operations.psm_applications
	area_application(e)
	e.product_class == "synthetic"
}

else := codes if {
	year >= 2023
	sensitive(p)
	is_array(p.operations.psm_applications)
	every e in p.operations.psm_applications {
		known_code_class(e)
	}
	codes := {t.psm_codes.organic | some e in p.operations.psm_applications; area_application(e); e.product_class == "organic"}
}

known_code_class(e) if e.method == "Einzelpflanze"

known_code_class(e) if {
	area_application(e)
	e.product_class in {"organic", "synthetic"}
}

stock_status(s) := "verboten" if {
	s.action in {"Kauf", "Lagerung"}
	s.disallowed_for_measure
	s.is_psm == false
}

else := "verboten" if {
	s.action in {"Kauf", "Lagerung"}
	s.disallowed_for_measure
	s.is_psm
	s.permitted_other_crop == false
}

else := "verboten" if {
	s.action in {"Kauf", "Lagerung"}
	s.is_psm
	s.permitted_other_crop
	false in [object.get(s, "quantity_plausible", null), object.get(s, "documented", null)]
}

else := "erlaubt" if {
	s.action in {"Kauf", "Lagerung"}
	s.is_psm
	s.permitted_other_crop
	s.quantity_plausible
	s.documented
}

else := "erlaubt" if {
	s.action in {"Kauf", "Lagerung"}
	s.disallowed_for_measure == false
	not stock_for_other_crop(s)
}

stock_for_other_crop(s) if {
	s.is_psm
	s.permitted_other_crop
}

stock_findings contains {"index": i, "status": s} if {
	some i, record in input.farm.input_transactions
	s := stock_status(record)
}

eligible_attendee(c) if c.role == "Betriebsführung"

eligible_attendee(c) if {
	c.role == "Mitwirkende Person"
	c.operational_need
	c.significant_and_involved
}

retained(c) if c.left_on == null

retained(c) if {
	valid_date(c.left_on)
	c.left_on > "2025-12-31"
}

creditable(c) if {
	eligible_attendee(c)
	retained(c)
	valid_date(c.date)
	c.date >= "2022-01-01"
	c.date <= "2025-12-31"
	c.topic in {"Stickstoffdüngung", "Angepasste Nutzungshäufigkeit im Grünland"}
	c.recognised_provider
	c.other_obligation_credit == false
	c.other_farm_credit == false
	is_number(c.hours)
	c.hours > 0
}

# Eindeutige Veranstaltung je Person, auch bei wiederholtem Import.
event_hours(person, event) := hours if {
	amounts := {c.hours | some c in input.documentation.courses; c.person_id == person; c.event_id == event; creditable(c)}
	count(amounts) == 1
	some hours in amounts
}

trained_people contains person if {
	some attendance in input.documentation.courses
	person := attendance.person_id
	events := {c.event_id | some c in input.documentation.courses; c.person_id == person; creditable(c)}
	total := sum([h | some event in events; h := event_hours(person, event)])
	total >= 3
}

certificate_due if {
	input.documentation.certificate_requested
	input.documentation.provider_sent_certificate == false
	input.documentation.farm_sent_certificate == false
}
