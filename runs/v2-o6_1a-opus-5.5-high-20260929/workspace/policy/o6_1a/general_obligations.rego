# METADATA
# title: UBB (o6_1a) – Allgemeine Förderbedingungen (Grünlanderhaltung, Anbaudiversifizierung, Weiterbildung)
package oepul.o6_1a.general_obligations

import data.oepul.o6_1a.common

# ---------------------------------------------------------------------------
# UBB-GLE-001..004: Erhaltung des Grünlandausmaßes
# ---------------------------------------------------------------------------
gc := object.get(common.ubb, "grassland_conservation", {})

# Referenzfläche = Grünlandfläche im 1. Teilnahmejahr + im Jahr davor umgebrochene Fläche.
grassland_reference_ha := object.get(gc, "first_year_grassland_ha", 0) + object.get(gc, "ploughed_previous_year_ha", 0)

# Aktuelle Grünlandfläche; Neuanlagen sind enthalten und füllen die Toleranz wieder auf.
# Überbetriebliche Flächentäusche sind nicht anrechenbar.
grassland_current_creditable_ha := object.get(gc, "current_grassland_ha", common.grassland_area_ha) - object.get(gc, "inter_farm_swap_gain_ha", 0)

grassland_net_conversion_ha := grassland_reference_ha - grassland_current_creditable_ha

grassland_tolerance_ha := 1.0

violations contains {"rule_id": "UBB-GLE-001", "subject": "farm", "message": sprintf("Grünlandumwandlung von %v ha überschreitet die Toleranz von 1,00 ha", [grassland_net_conversion_ha])} if {
	gc != {}
	grassland_net_conversion_ha > grassland_tolerance_ha + common.eps
}

# ---------------------------------------------------------------------------
# UBB-AD-001..007: Anbaudiversifizierung auf Ackerflächen
# ---------------------------------------------------------------------------
cereals := {c | some c in common.tables.o6_1a_cereals}

maize := {c | some c in common.tables.o6_1a_maize}

forage := {c | some c in common.tables.o6_1a_arable_forage}

# Botanische Art (Erstkultur bei Doppelnutzung, Hauptanteil bei Mischkulturen).
culture(p) := object.get(p, ["crop", "botanical_species"], common.crop_label(p))

is_cereal(p) if {
	culture(p) in cereals
	object.get(p, ["crop", "cereal_share_percent"], 100) >= 50
}

is_maize(p) if culture(p) in maize

is_maize(p) if p.crop.crop_category == "maize"

diversification_applies if common.arable_area_ha > 5.0

cereal_maize_area_ha := sum([common.area(p) | some p in common.arable_parcels; cereal_or_maize(p)])

cereal_or_maize(p) if is_cereal(p)

cereal_or_maize(p) if {
	not is_cereal(p)
	is_maize(p)
}

cereal_maize_share := cereal_maize_area_ha / common.arable_area_ha if common.arable_area_ha > 0

violations contains {"rule_id": "UBB-AD-001", "subject": "farm", "message": sprintf("Getreide- und Maisanteil %v %% überschreitet 75 %%", [cereal_maize_share * 100])} if {
	diversification_applies
	cereal_maize_share > 0.75 + common.eps
}

exempt_from_55(p) if culture(p) in forage

exempt_from_55(p) if common.crop_label(p) in forage

exempt_from_55(p) if {
	common.year >= 2025
	culture(p) in {c | some c in common.tables.o6_1a_diversification_exempt_from_2025}
}

culture_area := {c: a |
	some q in common.arable_parcels
	not exempt_from_55(q)
	c := culture(q)
	a := sum([common.area(p) | some p in common.arable_parcels; culture(p) == c])
}

violations contains {"rule_id": "UBB-AD-002", "subject": c, "message": sprintf("Kultur %s hat einen Anteil von %v %% (max. 55 %%)", [c, (a / common.arable_area_ha) * 100])} if {
	diversification_applies
	some c, a in culture_area
	a / common.arable_area_ha > 0.55 + common.eps
}

# ---------------------------------------------------------------------------
# UBB-WB-001..006: Weiterbildung (3 Stunden bis 31.12.2025)
# ---------------------------------------------------------------------------
training := object.get(common.ubb, "training", {})

creditable_course(c) if {
	c.date >= "2022-01-01"
	c.date <= "2025-12-31"
	object.get(c, "provider_recognized", false)
	object.get(c, "biodiversity_relevant", false)
	not object.get(c, "credited_to_other_obligation", false)
	not object.get(c, "credited_to_other_farm", false)
	object.get(c, "attendee", "applicant") in {"applicant", "involved_person"}
	not object.get(c, "attendee_left_before_deadline", false)
}

training_hours := sum([object.get(c, "hours", 0) | some c in object.get(training, "courses", []); creditable_course(c)])

default training_fulfilled := false

training_fulfilled if training_hours >= 3

violations contains {"rule_id": "UBB-WB-001", "subject": "farm", "message": sprintf("Weiterbildung Biodiversität: nur %v anrechenbare Stunden bis 31.12.2025 (mind. 3)", [training_hours])} if {
	common.participates("1A")
	common.year >= 2026
	not training_fulfilled
}
