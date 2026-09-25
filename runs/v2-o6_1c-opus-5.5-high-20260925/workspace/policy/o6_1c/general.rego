# Allgemeine ÖPUL-Bestimmungen mit Wirkung auf die Maßnahme 1C: Sanktionen, Konditionalität,
# höhere Gewalt und flächenverändernde Umstände, Kontrollen, Definitionen, 2026-Hinweise
# (Allgemeine Teilnahmebedingungen Kap. 4, 5.1, 8; SRL Punkte 1.5, 1.7.4, 1.7.5, 1.11, 1.12, 1.20).
package oepul.o6_1c

# --- Sanktionen (Allgemeine Teilnahmebedingungen 8.2) -------------------------------

sanction_share(level) := s.from_2027_reduction_share if {
	some s in data.o6_1c.sanction_levels
	s.level == level
	year >= 2027
	s.from_2027_reduction_share
} else := s.reduction_share if {
	some s in data.o6_1c.sanction_levels
	s.level == level
}

# O61C-GEN-SANC-002: zweimalige 100 %-Kürzung im Vertragszeitraum -> Ausschluss und Rückforderung.
default excluded_from_measure := false

excluded_from_measure if object.get(oepul, "full_reductions_in_contract_period", 0) >= 2

# O61C-GEN-SANC-003: Reihenfolge bei Mehrfachkürzungen.
reduction_order := [r.reduction | some r in data.o6_1c.multiple_reduction_order]

# O61C-GEN-SANC-004: Bei einjährigen Maßnahmen kommt bei Nichterfüllung von Förder-/Zugangsvoraussetzungen kein Vertrag zustande.
default no_contract_due_to_access_conditions := false

no_contract_due_to_access_conditions if {
	is_one_year_measure
	count(measure_1c_participations) > 0
	not applicant_eligible
}

no_contract_due_to_access_conditions if {
	is_one_year_measure
	count(measure_1c_participations) > 0
	not min_farm_size_met
}

# --- Konditionalität (Allgemeine Teilnahmebedingungen 5.1) --------------------------

default conditionality_reduction_possible := false

conditionality_reduction_possible if object.get(oepul, "conditionality_compliant", true) == false

# --- Kontrollen (SRL 1.11.1.2) ----------------------------------------------------

# O61C-GEN-CTRL-001: Verweigerung/Verhinderung der Vor-Ort-Kontrolle -> Ablehnung, keine Prämie, Vertragsbeendigung.
default application_rejected_control_refused := false

application_rejected_control_refused if {
	object.get(oepul, "onsite_control_refused", false) == true
	object.get(oepul, "onsite_control_refusal_force_majeure", false) != true
}

# --- Flächen- und bewirtschaftungsverändernde Umstände (SRL 1.7.4) -------------------

# O61C-GEN-FM-002: Dauerhafte Umstände: Prämie im Eintrittsjahr nur bei höherer Gewalt oder Eintritt nach dem 15.04.
premium_possible_in_year_of_permanent_circumstance(_, force_majeure) if force_majeure == true

premium_possible_in_year_of_permanent_circumstance(occurrence_date, force_majeure) if {
	force_majeure != true
	occurrence_date > date_in_year("04-15")
}

# O61C-GEN-FM-003: Vorübergehende Umstände: Prämie im Jahr der Nichteinhaltung nur bei höherer Gewalt
# oder wenn alle Bedingungen auf den geänderten Flächen eingehalten werden.
premium_possible_in_year_of_temporary_circumstance(force_majeure, _) if force_majeure == true

premium_possible_in_year_of_temporary_circumstance(force_majeure, conditions_met_on_changed_areas) if {
	force_majeure != true
	conditions_met_on_changed_areas == true
}

# --- Definitionen (Allgemeine Teilnahmebedingungen 4, SRL 1.5.3.2) --------------------

definitions := data.o6_1c.oepul_definitions

crop_in_group(crop, "cereal") if crop in definitions.cereals

crop_in_group(crop, "arable_forage") if crop in definitions.arable_forage_crops

crop_in_group(crop, "field_vegetable") if crop in definitions.field_vegetables

crop_in_group(crop, "fruit") if {
	some f in definitions.fruit_crops
	f.crop == crop
	year >= f.from_year
}

crop_group_ids := ["cereal", "arable_forage", "field_vegetable", "fruit"]

crop_groups(crop) := {g | some g in crop_group_ids; crop_in_group(crop, g)}

is_not_cereal(crop) if crop in definitions.not_cereals

cereal_mixture_is_cereal(cereal_share) if cereal_share >= definitions.cereal_mixture_min_share

# --- 2026-Hinweise --------------------------------------------------------------------

notices := data.o6_1c.notices_2026

# O61C-N2026-003: Dürre 2026 – Entfall der Ernteverpflichtung ohne Einzelmeldung in gelisteten Bezirken
# (betrifft Ackerkulturen mit Ernteverpflichtung, nicht NPA/AFS, die von den Mindestbewirtschaftungskriterien ausgenommen sind).
drought_2026_harvest_relief_district(state, district) if {
	year == 2026
	some e in notices.drought_harvest_relief_districts
	e.federal_state == state
	"*" in e.districts
	is_string(district)
}

drought_2026_harvest_relief_district(state, district) if {
	year == 2026
	some e in notices.drought_harvest_relief_districts
	e.federal_state == state
	district in e.districts
}

default farm_in_drought_2026_relief_area := false

farm_in_drought_2026_relief_area if {
	drought_2026_harvest_relief_district(input.farm.region.federal_state, input.farm.region.district)
}

# O61C-N2026-001: Die trockenheitsbedingten Erleichterungen für Acker-Biodiversitätsflächen 2026
# (vorzeitige und dritte Nutzung unter OPUBB/OPBIO) gelten nur für UBB/BIO-Biodiversitätsflächen, nicht für NPA.
default biodiversity_relief_2026_applies_to_npa := false

biodiversity_relief_2026_applies_to_npa if params.measure_code in notices.biodiversity_relief_measures

# O61C-N2026-002: Höhere Gewalt ist einzelbetrieblich über eAMA (Register „Eingaben") geltend zu machen.
force_majeure_channel := notices.force_majeure_channel
