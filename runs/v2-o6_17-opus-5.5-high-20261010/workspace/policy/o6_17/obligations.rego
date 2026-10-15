package oepul.o6_17.obligations

# Förderverpflichtungen: Verzicht auf Grünlandumbruch, umbruchslose
# Erneuerung, Weiterbildung, Bodenuntersuchungen (Informationsblatt Kapitel
# 5.1, 6.1 bis 6.5; SRL 2.17 Förderverpflichtungen).

import data.oepul.o6_17.common

lists := data.o6_17_tables.obligation_lists

breakups(p) := object.get(p, ["o6_17", "grassland_breakups"], [])

reason_documentation_ok(r, _) if r.requires_documentation == false

reason_documentation_ok(r, e) if {
	r.requires_documentation == true
	object.get(e, "necessity_documented", false) == true
}

reason_measure_ok(r) if count(r.requires_measure_any_of) == 0

reason_measure_ok(r) if common.in_measure({m | some m in r.requires_measure_any_of})

ploughing_exception_applies(e) if {
	some r in lists.ploughing_exception_reasons
	r.id == object.get(e, "reason", "none")
	reason_documentation_ok(r, e)
	reason_measure_ok(r)
}

area_m2(e) := object.get(e, "area_m2", 0)

# Umbruch auf irgendeiner Grünlandfläche des Betriebes ohne Ausnahme.
violations contains v if {
	common.contract_active
	some p in common.grassland_parcels
	some e in breakups(p)
	e.type == "ploughing"
	not ploughing_exception_applies(e)
	v := {"rule_id": "o6_17.obligation.no_grassland_ploughing", "parcel_id": p.parcel_id, "detail": "Grünlandumbruch ohne zulässige Ausnahme"}
}

# Geringfügige Abweichungen gelten nur bis 300 m² je Einzelfläche nicht als Umbruch.
violations contains v if {
	common.contract_active
	some p in common.grassland_parcels
	some e in breakups(p)
	e.type == "minor_deviation"
	area_m2(e) > lists.minor_deviation_max_m2
	v := {"rule_id": "o6_17.obligation.minor_deviation_300m2", "parcel_id": p.parcel_id, "detail": "Geringfügige Abweichung über 300 m² gilt als Umbruch"}
}

# Aufschüttungen über 300 m² nur mit vorab eingeholter landesrechtlicher Bewilligung.
violations contains v if {
	common.contract_active
	some p in common.grassland_parcels
	some e in breakups(p)
	e.type == "fill"
	area_m2(e) > lists.minor_deviation_max_m2
	object.get(e, "state_permit_obtained", false) != true
	v := {"rule_id": "o6_17.obligation.fill_over_300m2_permit", "parcel_id": p.parcel_id, "detail": "Aufschüttung über 300 m² ohne vorab eingeholte landesrechtliche Bewilligung"}
}

# Keine Nutzung im Jahr der Aufschüttung: Beantragung als „Sonstige Grünlandflächen“.
violations contains v if {
	common.contract_active
	some p in common.grassland_parcels
	some e in breakups(p)
	e.type == "fill"
	object.get(e, "no_use_in_year", false) == true
	common.use_type(p) != "sonstige_gruenlandflaeche"
	v := {"rule_id": "o6_17.obligation.fill_without_use_sonstige_gruenland", "parcel_id": p.parcel_id, "detail": "Ungenutzte Fläche nach Aufschüttung ist als Sonstige Grünlandfläche zu beantragen"}
}

# Kein Acker-Grünland-Flächentausch.
violations contains v if {
	common.contract_active
	some p in common.parcels
	object.get(p, ["o6_17", "arable_grassland_swap"], false) == true
	v := {"rule_id": "o6_17.obligation.no_arable_grassland_swap", "parcel_id": p.parcel_id, "detail": "Acker-Grünland-Flächentausch ist nicht möglich"}
}

allowed_devices := {d.id | some d in lists.allowed_renewal_devices}

# Umbruchslose Grünlanderneuerung nur mit Saatstriegel, Schlitzdrillgerät, Walze, Wiesenegge.
violations contains v if {
	common.contract_active
	some p in common.grassland_parcels
	some d in object.get(p, ["o6_17", "renewal_devices_used"], [])
	not common.normalize(d) in allowed_devices
	v := {"rule_id": "o6_17.obligation.allowed_renewal_devices", "parcel_id": p.parcel_id, "detail": sprintf("Gerät %v ist für die umbruchslose Grünlanderneuerung nicht zulässig", [d])}
}

# ---------------------------------------------------------------------------
# Weiterbildung: mindestens 5 Stunden Grünlandbewirtschaftung bis 31.12.2025.

training_courses := object.get(common.o6, "training_courses", [])

person_still_counts(c) if object.get(c, "person_left_farm_date", null) == null

person_still_counts(c) if {
	d := object.get(c, "person_left_farm_date", null)
	is_string(d)
	d > lists.training.deadline
}

qualifying_course(c) if {
	c.topic == "grassland"
	c.person_role in {"applicant", "involved_person"}
	c.provider_recognized == true
	c.course_date >= lists.training.earliest_course_date
	c.course_date <= lists.training.deadline
	object.get(c, "counted_for_other_commitment", false) == false
	object.get(c, "counted_for_other_farm", false) == false
	person_still_counts(c)
}

training_hours_by_person[pid] := hours if {
	some c in training_courses
	pid := c.person_id
	hours := sum([x.hours | some x in training_courses; x.person_id == pid; qualifying_course(x)])
}

training_fulfilled if {
	some pid
	training_hours_by_person[pid] >= lists.training.min_hours
}

violations contains v if {
	common.contract_active
	common.year >= 2025
	not training_fulfilled
	v := {"rule_id": "o6_17.obligation.training_5h_grassland", "parcel_id": null, "detail": "Weiterbildung Grünlandbewirtschaftung (mind. 5 Stunden bis 31.12.2025) nicht nachgewiesen"}
}

# ---------------------------------------------------------------------------
# Bodenuntersuchungen: pro angefangene 5 ha förderfähige Grünlandfläche unter
# 18 % Hangneigung (Mehrfachantrag 2025) mindestens eine Bodenprobe.

basis_area_input := object.get(common.o6, "soil_sample_basis_area_ha", null)

computed_basis_area_ha := sum([p.area_ha |
	some p in common.grassland_parcels
	common.slope_below_18(p)
	not common.gloez_ban(p)
])

soil_sample_basis_area_ha := basis_area_input if {
	is_number(basis_area_input)
} else := computed_basis_area_ha if {
	common.year == lists.soil_sample.basis_application_year
}

required_soil_samples := ceil(common.round3(soil_sample_basis_area_ha) / lists.soil_sample.hectares_per_sample)

soil_samples := object.get(common.o6, "soil_samples", [])

required_parameters := {x | some x in lists.soil_sample_required_parameters}

allowed_methods := {m.id | some m in lists.soil_sample_allowed_methods}

valid_soil_sample(s) if {
	s.sample_date >= lists.soil_sample.earliest_sample_date
	s.lab_submission_date <= lists.soil_sample.lab_submission_deadline
	s.lab_accredited == true
	s.method in allowed_methods
	count(required_parameters - {x | some x in s.parameters}) == 0
	object.get(s, "received_with_transferred_parcel", false) == false
}

valid_soil_sample_count := count([s | some s in soil_samples; valid_soil_sample(s)])

soil_samples_fulfilled if valid_soil_sample_count >= required_soil_samples

violations contains v if {
	common.contract_active
	common.year >= 2025
	is_number(required_soil_samples)
	not soil_samples_fulfilled
	v := {"rule_id": "o6_17.obligation.soil_samples_per_5ha", "parcel_id": null, "detail": sprintf("Bodenproben: %d gültig, %d erforderlich", [valid_soil_sample_count, required_soil_samples])}
}

# Ergebnisse der Bodenproben sind im INVEKOS-GIS einzutragen.
violations contains v if {
	common.contract_active
	some s in soil_samples
	valid_soil_sample(s)
	object.get(s, "recorded_in_invekos_gis", false) != true
	v := {"rule_id": "o6_17.obligation.soil_sample_results_in_gis", "parcel_id": null, "detail": sprintf("Ergebnis der Bodenprobe %v nicht im INVEKOS-GIS erfasst", [object.get(s, "sample_id", "ohne ID")])}
}

missing_inputs contains "farm.oepul.o6_17.soil_sample_basis_area_ha" if {
	common.contract_active
	common.year > lists.soil_sample.basis_application_year
	not is_number(basis_area_input)
}

default training_fulfilled := false

default required_soil_samples := null
