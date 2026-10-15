# Modul:
#   o6_17 – Förderverpflichtungen (Umbruchsverzicht, Weiterbildung, Bodenuntersuchung, AGL, Mindestbewirtschaftung)
package oepul.o6_17

# ---------------------------------------------------------------------------
# Verzicht auf Grünlandumbruch auf sämtlichen Grünlandflächen des Betriebes
# ---------------------------------------------------------------------------
conversion_events contains [pid, e] if {
	some p in parcels
	is_grassland(p)
	pid := p.parcel_id
	some e in object.get(p, ["operations", "grassland_conversions"], [])
}

# Geringfügige Abweichungen bis 300 m² je Einzelfläche gelten nicht als Umbruch
conversion_permitted(e) if {
	object.get(e, "kind", "") != "fill"
	e.area_m2 <= cfg.lists.minor_deviation_max_m2_per_area
}

# Aufschüttungen mit nachfolgender Einsaat; > 300 m² nur mit vorab eingeholter landesrechtlicher Bewilligung
conversion_permitted(e) if {
	e.kind == "fill"
	e.area_m2 <= cfg.lists.fill_permit_threshold_m2
}

conversion_permitted(e) if {
	e.kind == "fill"
	object.get(e, "reseeded", false) == true
	e.area_m2 > cfg.lists.fill_permit_threshold_m2
	object.get(e, "permit_obtained", false) == true
}

# Ausnahme: Grünlandsanierung nach Schädlingsbefall mit Dokumentation
conversion_permitted(e) if {
	e.reason == "pest_damage"
	object.get(e, "documented", false) == true
}

# Ausnahme: Neueinsaat regionaler Grünland-Saatgutmischung für Biodiversitätsflächen in UBB/BIO
conversion_permitted(e) if {
	e.reason == "biodiversity_reseeding"
	ubb_or_bio_participation
	object.get(e, "documented", false) == true
}

allowed_renewal_equipment := {r.key | some r in cfg.lists.allowed_renewal_equipment}

violations contains v if {
	some [pid, e] in conversion_events
	not conversion_permitted(e)
	v := {"rule_id": "O6_17-MB-6.1-NO-CONVERSION", "parcel_id": pid, "message": "Unzulässiger Grünlandumbruch während des Vertragszeitraums"}
}

violations contains v if {
	object.get(o617, "arable_grassland_swap", false) == true
	v := {"rule_id": "O6_17-MB-6.1-NO-ARABLE-GRASSLAND-SWAP", "parcel_id": null, "message": "Acker-Grünland-Flächentausch ist nicht möglich"}
}

violations contains v if {
	some p in parcels
	is_grassland(p)
	some equipment in object.get(p, ["operations", "renewal_equipment"], [])
	not equipment in allowed_renewal_equipment
	v := {"rule_id": "O6_17-MB-6.2-RENEWAL-EQUIPMENT", "parcel_id": p.parcel_id, "message": sprintf("Gerät %v ist für die umbruchslose Grünlanderneuerung nicht zulässig", [equipment])}
}

# ---------------------------------------------------------------------------
# Weiterbildung: 5 Stunden Grünlandbewirtschaftung bis 31.12.2025
# ---------------------------------------------------------------------------
training_cfg := cfg.lists.training

training_courses := object.get(o617, "training", [])

trained_person_still_counts(c) if object.get(c, "person_left_farm_date", null) == null

trained_person_still_counts(c) if {
	d := object.get(c, "person_left_farm_date", null)
	is_string(d)
	d >= training_cfg.deadline
}

creditable_course(c) if {
	c.course_date >= training_cfg.earliest_creditable_course_date
	c.course_date <= training_cfg.deadline
	object.get(c, "provider_recognized", false) == true
	object.get(c, "grassland_topic", false) == true
	object.get(c, "person_role", "") in {r | some r in training_cfg.eligible_person_roles}
	object.get(c, "credited_to_other_farm", false) == false
	object.get(c, "credited_to_other_obligation", false) == false
	trained_person_still_counts(c)
}

training_hours_creditable := sum([c.hours | some c in training_courses; creditable_course(c)])

training_obligation_met if training_hours_creditable >= training_cfg.required_hours

violations contains v if {
	deadline_passed(training_cfg.deadline)
	not training_obligation_met
	v := {"rule_id": "O6_17-MB-6.4-TRAINING", "parcel_id": null, "message": sprintf("Nur %v anrechenbare Weiterbildungsstunden (mindestens 5 bis 31.12.2025)", [training_hours_creditable])}
}

# ---------------------------------------------------------------------------
# Bodenuntersuchungen: je angefangene 5 ha förderfähiges Grünland < 18 % (MFA 2025) eine Probe
# ---------------------------------------------------------------------------
soil_cfg := cfg.lists.soil_sampling

soil_base_parcel(p) if {
	is_grassland(p)
	is_number(p.slope_percent)
	p.slope_percent < rates.slope_threshold_percent
	not gloez_conversion_ban(p)
}

soil_sample_base_ha := b if {
	b := object.get(o617, "eligible_grassland_lt18_mfa2025_ha", null)
	is_number(b)
}

soil_sample_base_ha := b if {
	not is_number(object.get(o617, "eligible_grassland_lt18_mfa2025_ha", null))
	application_year == soil_cfg.reference_application_year
	b := sum([p.area_ha | some p in parcels; soil_base_parcel(p)])
}

soil_samples_required := ceil(soil_sample_base_ha / soil_cfg.hectares_per_sample) if soil_sample_base_ha > 0

soil_samples_required := 0 if soil_sample_base_ha <= 0

soil_samples := object.get(o617, "soil_samples", [])

valid_soil_sample(s) if {
	s.drawn_date >= soil_cfg.earliest_creditable_sample_date
	s.lab_submission_date <= soil_cfg.deadline
	object.get(s, "lab_accredited", false) == true
	object.get(s, "method", "") in {m | some m in soil_cfg.allowed_methods}
	every param in soil_cfg.required_parameters {
		param in object.get(s, "parameters", [])
	}
	object.get(s, "received_with_transferred_land", false) == false
}

valid_soil_sample_count := count({s.sample_id | some s in soil_samples; valid_soil_sample(s)})

soil_sample_obligation_met if valid_soil_sample_count >= soil_samples_required

violations contains v if {
	deadline_passed(soil_cfg.deadline)
	is_number(soil_samples_required)
	not soil_sample_obligation_met
	v := {"rule_id": "O6_17-MB-6.5-SOIL-SAMPLES", "parcel_id": null, "message": sprintf("%v gültige Bodenproben, erforderlich %v", [valid_soil_sample_count, soil_samples_required])}
}

violations contains v if {
	some s in soil_samples
	valid_soil_sample(s)
	object.get(s, "entered_in_invekos_gis", false) == false
	v := {"rule_id": "O6_17-MB-6.5-SOIL-RESULTS-ENTRY", "parcel_id": null, "message": sprintf("Ergebnis der Bodenprobe %v nicht im INVEKOS-GIS erfasst", [s.sample_id])}
}

# ---------------------------------------------------------------------------
# Zuschlag AGL: beantragte Schläge ohne erfüllte Voraussetzungen
# ---------------------------------------------------------------------------
violations contains v if {
	some p in parcels
	field_use_attr(p, "agl_requires_code_and_survey") == true
	cfg.lists.agl.code in parcel_codes(p)
	not agl_conditions_met(p)
	v := {"rule_id": "O6_17-MB-6.6-AGL-CONDITIONS", "parcel_id": p.parcel_id, "message": "Code AGL ohne erfüllte Kennarten-, Erstnutzungs- oder Dokumentationsauflagen"}
}

violations contains v if {
	some p in parcels
	cfg.lists.agl.code in parcel_codes(p)
	field_use_attr(p, "agl_requires_code_and_survey") == false
	v := {"rule_id": "O6_17-MB-7-AGL-CODE-USE-TYPES", "parcel_id": p.parcel_id, "message": "Code AGL nur auf Mähwiese/-weide zwei bzw. drei und mehr Nutzungen vorgesehen"}
}

# ---------------------------------------------------------------------------
# Mindestbewirtschaftung auf Grünland (jährlich Mahd mit Verbringung oder vollflächige Beweidung)
# ---------------------------------------------------------------------------
grassland_minimum_management_met(p) if count(object.get(p, ["operations", "cutting_dates"], [])) > 0

grassland_minimum_management_met(p) if object.get(p, ["operations", "full_grazing"], false) == true

grassland_minimum_management_met(p) if {
	field_use_attr(p, "is_bergmaehder") == true
	last := object.get(p, ["operations", "last_full_mowing_year"], null)
	is_number(last)
	application_year - last < 2
}

violations contains v if {
	some p in parcels
	base_premium_eligible(p)
	not grassland_minimum_management_met(p)
	v := {"rule_id": "O6_17-SRL-1.6.3.3-MIN-MANAGEMENT", "parcel_id": p.parcel_id, "message": "Mindestbewirtschaftung Grünland (Mahd mit Verbringung oder Beweidung) nicht erfüllt"}
}
