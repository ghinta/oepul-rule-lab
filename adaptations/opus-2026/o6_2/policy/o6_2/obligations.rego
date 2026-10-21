# Förderverpflichtungen (Kapitel 5 des Informationsblatts, SRL Punkt 2.2.4).
package oepul.o6_2

fertilizer_input_by_id := {f.id: f | some f in lists.fertilizer_inputs}

psm_mode_by_id := {m.id: m | some m in lists.psm_application_modes}

fertilizer_inputs_of(p) := object.get(p, ["operations", "fertilizer", "inputs"], [])

psm_applications_of(p) := object.get(p, ["operations", "psm_applications"], [])

input_is_external(i) if object.get(i, "external_origin", false) == true

fertilizer_status(i) := fertilizer_input_by_id[i.input_id].status_external if {
	input_is_external(i)
} else := fertilizer_input_by_id[i.input_id].status_own_farm

fertilizer_input_prohibited(i) if fertilizer_status(i) == "prohibited"

fertilizer_input_prohibited(i) if {
	fertilizer_status(i) == "allowed_if_return_of_delivered_slurry"
	object.get(i, "is_return_of_delivered_slurry", false) != true
}

# Unbekannte, betriebsfremde, stickstoffhaltige Betriebsmittel gelten als unzulässig.
fertilizer_input_prohibited(i) if {
	not fertilizer_input_by_id[i.input_id]
	input_is_external(i)
	object.get(i, "contains_n", true) == true
}

# 5.1: Verbot betriebsfremder, stickstoffhaltiger Düngemittel auf der gesamten LN
# (auch auf in der Maßnahme nicht prämienfähigen Flächen).
violations contains {
	"rule_id": "O6_2-OBL-N-FERT-001",
	"parcel_id": p.parcel_id,
	"input_id": i.input_id,
	"message": "Unzulässiges stickstoffhaltiges Betriebsmittel ausgebracht",
} if {
	some p in parcels
	some i in fertilizer_inputs_of(p)
	fertilizer_input_prohibited(i)
}

violations contains {
	"rule_id": "O6_2-OBL-N-FERT-002",
	"parcel_id": p.parcel_id,
	"input_id": "mineral_n_fertilizer",
	"message": "Mineralischer Stickstoffdünger ausgebracht",
} if {
	some p in parcels
	object.get(p, ["operations", "fertilizer", "mineral_n_kg_per_ha"], 0) > 0
}

# 5.2: Maximal 170 kg N/ha LN aus der Tierhaltung.
violations contains {
	"rule_id": "O6_2-OBL-N-LIMIT-001",
	"parcel_id": null,
	"input_id": null,
	"message": sprintf("Stickstoffanfall aus der Tierhaltung %.1f kg N/ha > 170 kg N/ha", [n_per_ha]),
} if {
	nitrogen_limit_exceeded
}

psm_counts_as_broadcast(a) := psm_mode_by_id[a.application_mode].counts_as_broadcast

psm_application_prohibited(a) if {
	psm_counts_as_broadcast(a)
	object.get(a, "organic_approved_only", false) != true
}

# 5.3: Kein flächiger PSM-Einsatz auf Ackerfutter- und Grünlandflächen
# (Ausnahme: nur Bio-Wirkstoffe; Einzelpflanzenbehandlung; Beizung = flächig).
violations contains {
	"rule_id": "O6_2-OBL-PSM-001",
	"parcel_id": p.parcel_id,
	"input_id": object.get(a, "product_name", null),
	"message": sprintf("Flächiger Pflanzenschutzmitteleinsatz (%s) auf Grünland/Ackerfutter", [a.application_mode]),
} if {
	some p in parcels
	is_psm_restricted_area(p)
	some a in psm_applications_of(p)
	psm_application_prohibited(a)
}

broadcast_psm_on_restricted(p) if {
	is_psm_restricted_area(p)
	some a in psm_applications_of(p)
	psm_counts_as_broadcast(a)
}

chemical_broadcast_psm_on_restricted(p) if {
	is_psm_restricted_area(p)
	some a in psm_applications_of(p)
	psm_application_prohibited(a)
}

required_psm_code(p) := "PSMCS" if {
	chemical_broadcast_psm_on_restricted(p)
} else := "PSMBIO" if {
	broadcast_psm_on_restricted(p)
}

psm_code_satisfied(p) if required_psm_code(p) in oepul_codes_of(p)

# PSMCS deckt auch zusätzliche Bio-Mittel ab.
psm_code_satisfied(p) if {
	required_psm_code(p) == "PSMBIO"
	"PSMCS" in oepul_codes_of(p)
}

# 5.3: Angabeverpflichtung (PSMBIO/PSMCS) bis einschließlich Antragsjahr 2025.
violations contains {
	"rule_id": "O6_2-OBL-PSM-CODE-001",
	"parcel_id": p.parcel_id,
	"input_id": required_psm_code(p),
	"message": sprintf("Code %s im Mehrfachantrag fehlt", [required_psm_code(p)]),
} if {
	year <= 2025
	some p in parcels
	required_psm_code(p)
	not psm_code_satisfied(p)
}

psm_coding_obligation_applies if year <= 2025

# 5.4: Kauf und Lagerung unzulässiger Betriebsmittel verboten.
operating_supplies := object.get(oepul, "operating_supplies", [])

supply_purchased_or_stored(s) if object.get(s, "purchased", false) == true

supply_purchased_or_stored(s) if object.get(s, "stored", false) == true

psm_supply_exception(s) if {
	object.get(s, "psm_permitted_in_other_crops", false) == true
	object.get(s, "quantity_plausible", false) == true
	object.get(s, "records_available", false) == true
}

supply_inadmissible(s) if {
	s.category == "fertilizer"
	fertilizer_input_prohibited(s)
}

supply_inadmissible(s) if {
	s.category == "psm"
	object.get(s, "organic_approved_only", false) != true
	not psm_supply_exception(s)
}

violations contains {
	"rule_id": "O6_2-OBL-SUPPLY-001",
	"parcel_id": null,
	"input_id": s.input_id,
	"message": "Kauf oder Lagerung eines in der Maßnahme unzulässigen Betriebsmittels",
} if {
	some s in operating_supplies
	supply_purchased_or_stored(s)
	supply_inadmissible(s)
}

# 5.5: Weiterbildung (mind. 3 h Stickstoffdüngung / angepasste Nutzungshäufigkeit).
trainings := object.get(oepul, "trainings", [])

training_creditable(t) if {
	t.topic in general.training.topics
	t.date >= general.training.earliest_creditable_date
	t.date <= general.training.deadline
	object.get(t, "provider_recognized", false) == true
	t.attendee_role in general.training.attendee_roles_allowed
	object.get(t, "credited_to_other_farm", false) != true
	object.get(t, "credited_to_other_commitment", false) != true
	not attendee_left_before_deadline(t)
}

attendee_left_before_deadline(t) if {
	left := object.get(t, "attendee_left_farm_date", null)
	left != null
	left < general.training.deadline
}

creditable_training_hours := sum([t.hours | some t in trainings; training_creditable(t)])

training_requirement_met if creditable_training_hours >= general.training.min_hours

violations contains {
	"rule_id": "O6_2-OBL-TRAIN-001",
	"parcel_id": null,
	"input_id": null,
	"message": sprintf("Anrechenbare Weiterbildung %.1f h < 3 h bis 31.12.2025", [creditable_training_hours]),
} if {
	year >= 2025
	not training_requirement_met
}

# Hinweise, die mangels Detailangaben manuell zu prüfen sind.
review_items contains {
	"rule_id": "O6_2-OBL-PSM-001",
	"parcel_id": p.parcel_id,
	"message": "PSM-Einsatz auf Grünland/Ackerfutter gemeldet, aber ohne Angaben zur Anwendungsart",
} if {
	some p in parcels
	is_psm_restricted_area(p)
	object.get(p, ["operations", "psm_used"], false) == true
	count(psm_applications_of(p)) == 0
}

review_items contains {
	"rule_id": "O6_2-OBL-N-FERT-004",
	"parcel_id": null,
	"message": "Gesetzliche Düngeobergrenzen und Verbotszeiträume sind zusätzlich einzuhalten",
} if {
	count(parcels) > 0
}
