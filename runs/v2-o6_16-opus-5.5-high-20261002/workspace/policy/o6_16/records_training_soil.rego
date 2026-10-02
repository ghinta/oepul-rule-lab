# o6_16 – Aufzeichnungen (4.1/4.2), Weiterbildung (4.4) und Bodenuntersuchung (4.5)
package oepul.o6_16

# ---------------------------------------------------------------------------
# 4.1 Betriebsbezogene Aufzeichnungen
# ---------------------------------------------------------------------------

farm_records := object.get(o16, "farm_records", {})

fertilization_plan_deadline := md_date(year, params.farm_records.plan_deadline_month_day)

farm_balance_deadline := md_date(year + 1, params.farm_records.balance_deadline_month_day_next_year)

violations contains {
	"rule_id": "o6_16.records.farm_plan_deadline",
	"parcel_id": null,
	"message": "Voraussichtliche Düngeplanung nicht bis 28.02. des Förderjahres angelegt.",
} if {
	participates_o6_16
	not farm_plan_in_time
}

farm_plan_in_time if {
	d := farm_records.fertilization_plan_date
	is_date(d)
	date_le(d, fertilization_plan_deadline)
}

violations contains {
	"rule_id": "o6_16.records.farm_balance_deadline",
	"parcel_id": null,
	"message": "Betriebliche Düngebilanzierung nicht bis 31.01. des Folgejahres abgeschlossen.",
} if {
	d := farm_records.farm_balance_completed_date
	is_date(d)
	not date_le(d, farm_balance_deadline)
}

violations contains {
	"rule_id": "o6_16.records.napv_compliance",
	"parcel_id": null,
	"message": "Düngevorgaben bzw. Aufzeichnungen gemäß § 8 Abs. 1 NAPV auf allen Flächen nicht eingehalten.",
} if {
	participates_o6_16
	object.get(farm_records, "napv_compliant", true) == false
}

# ---------------------------------------------------------------------------
# 4.2 Schlagbezogene Aufzeichnungen
# ---------------------------------------------------------------------------

field_records := object.get(o16, "field_records", {})

# Kulturflächen je Kultur in der Gebietskulisse
crop_area_in_area[name] := total if {
	some p in arable_in_area
	name := crop_key(p)
	total := sum([q.area_ha | some q in arable_in_area; crop_key(q) == name])
}

crop_key(p) := lower(crop_name(p)) if {
	is_string(crop_name(p))
	crop_name(p) != ""
} else := crop_category(p)

# Kulturen mit max. 0,30 ha je Kultur sind von schlagbezogenen Aufzeichnungen ausgenommen
field_records_required_for(name) if crop_area_in_area[name] > params.field_records.small_crop_max_ha

field_records_required if {
	some name, _ in crop_area_in_area
	field_records_required_for(name)
}

violations contains {
	"rule_id": "o6_16.records.field_records_electronic",
	"parcel_id": null,
	"message": "Schlagbezogene Aufzeichnungen sind elektronisch zu führen.",
} if {
	field_records_required
	object.get(field_records, "electronic", false) == false
}

violations contains {
	"rule_id": "o6_16.records.field_records_14_days",
	"parcel_id": null,
	"message": "Schlagbezogene Aufzeichnungen nicht innerhalb von 14 Tagen nach Ausbringung, Anbau, Bewässerung oder Ernte fertiggestellt.",
} if {
	field_records_required
	delay := object.get(field_records, "max_completion_delay_days", 0)
	delay > params.field_records.max_completion_days
}

violations contains {
	"rule_id": "o6_16.records.field_records_content",
	"parcel_id": null,
	"message": "Schlagbezogene Aufzeichnungen unvollständig (u. a. Erntemenge samt Wiegebelegen, Bewässerung, jährlicher Stickstoffsaldo).",
} if {
	field_records_required
	object.get(field_records, "content_complete", false) == false
}

# ---------------------------------------------------------------------------
# 4.4 Weiterbildung und Gewässerschutzkonzept
# ---------------------------------------------------------------------------

training_courses := object.get(o16, "training_courses", [])

course_creditable(c, topics) if {
	date_le(params.training.earliest_course_date, c.date)
	date_le(c.date, params.training.deadline)
	object.get(c, "provider_recognized", false) == true
	object.get(c, "credited_to_other_commitment", false) == false
	object.get(c, "credited_to_other_farm", false) == false
	not attendee_left_before_deadline(c)
	some t in c.topics
	t in topics
}

attendee_left_before_deadline(c) if {
	d := object.get(c, "attendee_left_farm_date", null)
	is_date(d)
	date_lt(d, params.training.deadline)
}

base_training_topics := {t | some t in params.training.topics}

vienna_training_topics := {t | some t in params.training.vienna_extra_topics}

training_hours := sum([c.hours |
	some c in training_courses
	not object.get(c, "vienna_extra", false) == true
	course_creditable(c, base_training_topics)
])

vienna_extra_training_hours := sum([c.hours |
	some c in training_courses
	object.get(c, "vienna_extra", false) == true
	course_creditable(c, vienna_training_topics)
])

default training_fulfilled := false

training_fulfilled if training_hours >= params.training.min_hours

deadline_passed(deadline) if year > date_year(deadline)

obligations contains {
	"rule_id": "o6_16.training.min_hours",
	"deadline": params.training.deadline,
	"status": obligation_status(training_fulfilled, params.training.deadline),
	"detail": sprintf("%v von 10 anrechenbaren Weiterbildungsstunden", [training_hours]),
} if {
	participates_o6_16
}

obligation_status(true, _) := "fulfilled"

obligation_status(false, deadline) := "missed" if deadline_passed(deadline)

obligation_status(false, deadline) := "open" if not deadline_passed(deadline)

violations contains {
	"rule_id": "o6_16.training.min_hours",
	"parcel_id": null,
	"message": "Weiterbildung von mindestens 10 Stunden nicht bis 31.12.2026 absolviert.",
} if {
	participates_o6_16
	not training_fulfilled
	deadline_passed(params.training.deadline)
}

default water_protection_concept_done := false

water_protection_concept_done if {
	d := o16.water_protection_concept_date
	is_date(d)
	date_le(d, params.training.concept_deadline)
}

violations contains {
	"rule_id": "o6_16.training.water_protection_concept",
	"parcel_id": null,
	"message": "Betriebsbezogenes Gewässerschutzkonzept nicht bis 31.12.2026 erstellt.",
} if {
	participates_o6_16
	not water_protection_concept_done
	deadline_passed(params.training.concept_deadline)
}

obligations contains {
	"rule_id": "o6_16.training.water_protection_concept",
	"deadline": params.training.concept_deadline,
	"status": obligation_status(water_protection_concept_done, params.training.concept_deadline),
	"detail": "einmaliges betriebsbezogenes Gewässerschutzkonzept",
} if {
	participates_o6_16
}

# ---------------------------------------------------------------------------
# 4.5 Bodenuntersuchung
# ---------------------------------------------------------------------------

# pro angefangene 5 ha Ackerfläche in der Gebietskulisse (MFA 2026) mindestens eine Probe
soil_samples_required(area_ha) := 0 if area_ha <= 0

soil_samples_required(area_ha) := ceil(area_ha / params.soil_samples.ha_per_sample) if area_ha > 0

soil_sample_base_area_ha := o16.soil_sample_base_area_ha if {
	is_number(object.get(o16, "soil_sample_base_area_ha", null))
} else := arable_in_area_ha

soil_samples := object.get(o16, "soil_samples", [])

required_parameter_set := {x | some x in params.soil_samples.required_parameters}

soil_sample_creditable(s) if {
	date_le(params.soil_samples.earliest_sampling_date, s.sampling_date)
	is_date(s.lab_submission_date)
	date_le(s.lab_submission_date, params.soil_samples.deadline)
	object.get(s, "lab_accredited", false) == true
	required_parameter_set - {x | some x in s.parameters} == set()
	object.get(s, "n_method", "") in {m | some m in params.soil_samples.n_methods}
	object.get(s, "analysis_method", "") in {m | some m in params.soil_samples.analysis_methods}
	object.get(s, "received_with_parcel_from_other_farm", false) == false
}

creditable_soil_samples := [s | some s in soil_samples; soil_sample_creditable(s)]

default soil_samples_fulfilled := false

soil_samples_fulfilled if count(creditable_soil_samples) >= soil_samples_required(soil_sample_base_area_ha)

obligations contains {
	"rule_id": "o6_16.soil.samples_per_5ha",
	"deadline": params.soil_samples.deadline,
	"status": obligation_status(soil_samples_fulfilled, params.soil_samples.deadline),
	"detail": sprintf("%v von %v erforderlichen Bodenproben", [count(creditable_soil_samples), soil_samples_required(soil_sample_base_area_ha)]),
} if {
	participates_o6_16
}

violations contains {
	"rule_id": "o6_16.soil.samples_per_5ha",
	"parcel_id": null,
	"message": sprintf("Nur %v anrechenbare Bodenproben, erforderlich %v (je angefangene 5 ha Ackerfläche in der Gebietskulisse).", [count(creditable_soil_samples), soil_samples_required(soil_sample_base_area_ha)]),
} if {
	participates_o6_16
	not soil_samples_fulfilled
	deadline_passed(params.soil_samples.deadline)
}

violations contains {
	"rule_id": "o6_16.soil.results_in_invekos_gis",
	"parcel_id": null,
	"message": sprintf("Ergebnis der Bodenprobe %v nicht im INVEKOS-GIS erfasst.", [object.get(s, "sample_id", "?")]),
} if {
	some s in creditable_soil_samples
	object.get(s, "entered_in_invekos_gis", false) == false
	deadline_passed(params.soil_samples.deadline)
}

# Zuordnung einer Bodenprobe zum Mehrfachantrag des Ziehungsjahres; neu im Herbst
# hinzugekommene Flächen können dem Folgejahr zugeordnet werden.
soil_sample_mfa_year(sampling_date, false) := date_year(sampling_date)

soil_sample_mfa_year(sampling_date, true) := date_year(sampling_date) + 1
