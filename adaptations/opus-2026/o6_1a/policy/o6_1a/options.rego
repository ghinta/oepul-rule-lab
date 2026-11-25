# METADATA
# title: UBB (o6_1a) – Betriebliche Optionen und Zuschläge (Kapitel 7)
package oepul.o6_1a.options

import data.oepul.o6_1a.common

# ---------------------------------------------------------------------------
# Punktförmige Landschaftselemente und Streuobstbäume (UBB-LSE-001..006, UBB-SO-001..004)
# ---------------------------------------------------------------------------
elements := object.get(common.ubb, "point_landscape_elements", [])

lse_eligible(e) if {
	object.get(e, "crown_diameter_m", 0) >= 2
	object.get(e, "area_m2", 1000) <= 100
	object.get(e, "min_distance_to_other_m", 0) >= 5
	object.get(e, "distance_to_agricultural_area_m", 100) <= 5
	object.get(e, "under_control", false)
	object.get(e, "applied_in_mfa", false)
	object.get(e, "maintained_full_year", false)
	not object.get(e, "on_alm_or_hutweide", false)
	not object.get(e, "is_gloez", false)
}

streuobst_species := {s.species | some s in common.tables.o6_1a_streuobst_species; s.from_year <= common.year}

wild_form_species := {s.species | some s in common.tables.o6_1a_streuobst_species; s.wild_form_eligible}

streuobst_eligible(e) if {
	lse_eligible(e)
	object.get(e, "streuobst", false)
	e.fruit_species in streuobst_species
	object.get(e, "tree_form", "") in {"hochstamm", "halbstamm"}
	object.get(e, "strong_growing_large_crown", false)
	not object.get(e, "permanent_support_frame_multiple_trees", false)
	object.get(e, "coded_so", false)
	wild_form_ok(e)
}

wild_form_ok(e) if not object.get(e, "wild_form", false)

wild_form_ok(e) if {
	object.get(e, "wild_form", false)
	e.fruit_species in wild_form_species
}

fp_area(fp) := sum([common.area(p) | some p in common.parcels; common.field_piece(p) == fp])

fp_cap(fp) := floor(fp_area(fp) * common.limits.lse_max_per_ha_field_piece)

element_fps := {object.get(e, "field_piece_id", "") | some e in elements}

eligible_streuobst_count(fp) := count([e | some e in elements; object.get(e, "field_piece_id", "") == fp; streuobst_eligible(e)])

eligible_other_count(fp) := count([e | some e in elements; object.get(e, "field_piece_id", "") == fp; lse_eligible(e); not streuobst_eligible(e)])

# Annahme: bei Überschreitung der 80 Elemente je ha werden Streuobstbäume vorrangig berücksichtigt.
paid_streuobst(fp) := common.min_of(eligible_streuobst_count(fp), fp_cap(fp))

paid_other(fp) := common.min_of(eligible_other_count(fp), fp_cap(fp) - paid_streuobst(fp))

lse_streuobst_count := sum([paid_streuobst(fp) | some fp in element_fps])

lse_other_count := sum([paid_other(fp) | some fp in element_fps])

lse_premium := (lse_streuobst_count * common.rate_or_zero("lse_streuobst")) + (lse_other_count * common.rate_or_zero("lse_other"))

violations contains {"rule_id": "UBB-LSE-001", "subject": object.get(e, "id", "lse"), "message": "Punktförmiges Landschaftselement erfüllt Definition nicht (Kronendurchmesser, Größe, Abstand, Lage, Verfügungsgewalt, ganzjährige Erhaltung, kein GLÖZ/Alm/Hutweide)"} if {
	some e in elements
	not lse_eligible(e)
}

violations contains {"rule_id": "UBB-LSE-003", "subject": fp, "message": sprintf("Mehr als 80 punktförmige Landschaftselemente je ha am Feldstück %s – nur %d prämienfähig", [fp, fp_cap(fp)])} if {
	some fp in element_fps
	eligible_streuobst_count(fp) + eligible_other_count(fp) > fp_cap(fp)
}

violations contains {"rule_id": "UBB-SO-001", "subject": object.get(e, "id", "lse"), "message": "Streuobstbaum nicht förderfähig (Obstart, Hoch-/Halbstamm, Wuchs, Stützgerüst, Code SO)"} if {
	some e in elements
	object.get(e, "streuobst", false)
	lse_eligible(e)
	not streuobst_eligible(e)
}

# ---------------------------------------------------------------------------
# Mehrnutzenhecken (UBB-MNH-001..008)
# ---------------------------------------------------------------------------
hedges := [p | some p in common.parcels; common.area_kind(p) == "mehrnutzenhecke"]

hedge(p) := object.get(p, "hedge", {})

hedge_eligible(p) if {
	h := hedge(p)
	d := object.get(h, "planted_date", "0000-00-00")
	d >= "2023-01-01"
	d <= sprintf("%d-05-15", [common.year])
	object.get(h, "state_concept", false)
	object.get(h, "gis_confirmed", false)
	object.get(h, "adjacent_own_arable_field_piece", false)
	not object.get(h, "borders_forest_or_flat_lse_longside", false)
	object.get(h, "average_width_m", 0) >= 5
	object.get(h, "average_width_m", 100) <= 20
	object.get(h, "herbaceous_share_percent", 0) >= 20
	object.get(h, "herbaceous_permanently_green", false)
	not object.get(h, "herbaceous_used", false)
	not object.get(h, "fertilizer_or_psm_used", false)
	object.get(h, "woody_care_ok", true)
	common.schlagnutzungsart(p) == "LSE Mehrnutzenhecke"
	not common.no_premium(p)
}

hedge_area_ha := sum([common.area(p) | some p in hedges; hedge_eligible(p)])

hedge_premium := hedge_area_ha * common.rate_or_zero("mehrnutzenhecken")

violations contains {"rule_id": "UBB-MNH-001", "subject": common.parcel_id(p), "message": "Mehrnutzenhecke erfüllt Förderbedingungen nicht"} if {
	some p in hedges
	not hedge_eligible(p)
}

# ---------------------------------------------------------------------------
# Naturschutz-Monitoring (UBB-MON-001..006)
# ---------------------------------------------------------------------------
monitoring := object.get(common.ubb, "monitoring", [])

program(name) := r if {
	some r in common.tables.o6_1a_monitoring_programs
	r.program == name
}

all_conditions := {c | some p in common.parcels; some c in common.conditions(p)}

combination_ok(m) if {
	r := program(m.program)
	r.requires_measure == null
}

combination_ok(m) if {
	r := program(m.program)
	r.requires_measure != null
	common.participates(r.requires_measure)
	count(all_conditions & {c | some c in r.requires_any_condition}) > 0
}

monitoring_eligible(m) if {
	program(m.program)
	object.get(m, "participation_confirmation", false)
	intro_ok(m)
	object.get(m, "data_recorded_timely_complete", false)
	combination_ok(m)
}

intro_ok(m) if object.get(m, "first_year", common.year) < common.year

intro_ok(m) if {
	object.get(m, "first_year", common.year) == common.year
	object.get(m, "intro_event_completed", false)
}

monitoring_premium := sum([common.rate_or_zero(program(m.program).rate_component) | some m in monitoring; monitoring_eligible(m)])

violations contains {"rule_id": "UBB-MON-001", "subject": m.program, "message": "Voraussetzungen für den Monitoring-Zuschlag nicht erfüllt (Teilnahmebestätigung, Einführungsveranstaltung, Datenerfassung, Kombinationsverpflichtung)"} if {
	some m in monitoring
	not monitoring_eligible(m)
}

violations contains {"rule_id": "UBB-ANT-003", "subject": m.program, "message": "Monitoring-Zuschlag nicht bis 31.12. des Vorjahres im Maßnahmenantrag beantragt bzw. Einstieg nach Förderjahr 2028"} if {
	some m in monitoring
	not monitoring_application_ok(m)
}

monitoring_application_ok(m) if {
	d := object.get(m, "application_date", null)
	d != null
	d <= sprintf("%d-12-31", [object.get(m, "first_year", common.year) - 1])
	object.get(m, "first_year", common.year) <= 2028
}
