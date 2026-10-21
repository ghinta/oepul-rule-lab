# METADATA
# title: UBB (o6_1a) – Allgemeine ÖPUL-Teilnahmebedingungen mit Bezug zur Maßnahme
package oepul.o6_1a.general_conditions

import data.oepul.o6_1a.common
import data.oepul.o6_1a.notices_2026

history := object.get(common.ubb, "area_history", {})

# ---------------------------------------------------------------------------
# ATB-ABG-001..003: Flächenabgänge – Toleranz 5 %, max. 5 ha, jedenfalls 0,50 ha
# ---------------------------------------------------------------------------
tolerance := common.tables.o6_1a_area_reduction_tolerance

relevant_reduction_ha := common.max_of(0, ((object.get(history, "previous_year_ha", 0) - object.get(history, "current_year_ha", 0)) - object.get(history, "loss_of_control_ha", 0)) - object.get(history, "permitted_conversion_ha", 0))

allowed_reduction_ha := common.max_of(common.min_of(object.get(history, "previous_year_ha", 0) * tolerance.max_share, tolerance.max_ha), tolerance.always_allowed_ha)

default repayment_area_ha := 0

repayment_area_ha := relevant_reduction_ha if relevant_reduction_ha > allowed_reduction_ha

violations contains {"rule_id": "ATB-ABG-001", "subject": "farm", "message": sprintf("Flächenverringerung %v ha überschreitet Toleranz %v ha – Rückzahlung für die gesamte Differenzfläche", [relevant_reduction_ha, allowed_reduction_ha])} if {
	history != {}
	relevant_reduction_ha > allowed_reduction_ha
}

# ---------------------------------------------------------------------------
# ATB-ZUG-001..002: Flächenzugang – 2024/2025 zur Gänze, danach max. 50 % auf Basis 2025, jedenfalls 5 ha
# ---------------------------------------------------------------------------
increase := common.tables.o6_1a_area_increase_limit

max_premium_eligible_area_ha := object.get(history, "current_year_ha", 0) if common.year in {y | some y in increase.fully_eligible_years}

max_premium_eligible_area_ha := (base + common.max_of(base * increase.max_increase_share, increase.always_allowed_ha)) + object.get(history, "increase_previously_committed_ha", 0) if {
	common.year > increase.base_year
	base := object.get(history, "base_2025_ha", 0)
}

violations contains {"rule_id": "ATB-ZUG-001", "subject": "farm", "message": sprintf("Flächenzugang über Grenze: nur %v ha prämienfähig", [max_premium_eligible_area_ha])} if {
	common.year > increase.base_year
	history != {}
	object.get(history, "current_year_ha", 0) > max_premium_eligible_area_ha
}

# ---------------------------------------------------------------------------
# ATB-SANK-001..002: Stufen bei Verstößen gegen inhaltliche Bewirtschaftungsauflagen
# ---------------------------------------------------------------------------
sanction_reduction_percent(level) := r.reduction_percent if {
	some r in common.tables.o6_1a_sanction_levels
	r.level == level
	level > 0
}

sanction_reduction_percent(0) := 0 if common.year <= 2026

sanction_reduction_percent(0) := 1 if common.year >= 2027

exclusion_due_to_repeated_full_reduction if object.get(common.ubb, "full_reductions_in_contract_period", 0) >= 2

# ---------------------------------------------------------------------------
# ATB-MBK-001..005: Mindestbewirtschaftungskriterien (DIV, Mehrnutzenhecken u. a. ausgenommen)
# ---------------------------------------------------------------------------
exempt_from_minimum_management(p) if common.is_arable_div(p)

exempt_from_minimum_management(p) if common.is_grassland_div(p)

exempt_from_minimum_management(p) if common.area_kind(p) in {"mehrnutzenhecke", "agroforststreifen", "gloez_landscape_element"}

exempt_from_minimum_management(p) if {
	some c in {"BAW", "AG", "K20"}
	common.has_code(p, c)
}

exempt_from_minimum_management(p) if {
	some c in {"NAT", "EBW"}
	common.has_code(p, c)
	common.schlagnutzungsart(p) == "Grünbrache"
}

harvest_share(p) := object.get(p, ["harvest", "harvested_share_percent"], 100)

violations contains {"rule_id": "ATB-MBK-001", "subject": common.parcel_id(p), "message": "Ernte und Verbringen des Erntegutes auf weniger als 85 % des Schlages"} if {
	some p in common.arable_parcels
	not common.is_arable_forage(p)
	not exempt_from_minimum_management(p)
	common.schlagnutzungsart(p) != "Grünbrache"
	harvest_share(p) < 85
	not common.no_premium(p)
	not notices_2026.harvest_exemption_2026(p)
	not object.get(p, ["harvest", "force_majeure_recognized"], false)
}

grassland_used(p) if {
	some e in object.get(p, ["operations", "use_events"], [])
	common.date_year(e.date) == common.year
	e.type == "mow"
	object.get(e, "material_removed", false)
}

grassland_used(p) if {
	some e in object.get(p, ["operations", "use_events"], [])
	common.date_year(e.date) == common.year
	e.type == "graze"
}

grassland_used(p) if {
	common.is_bergmaehder(p)
	object.get(p, ["operations", "bergmaehder_mown_previous_year"], false)
}

violations contains {"rule_id": "ATB-MBK-002", "subject": common.parcel_id(p), "message": "Grünland-/Ackerfutterfläche weder vollflächig gemäht (mit Verbringung) noch beweidet"} if {
	some p in common.parcels
	forage_like(p)
	not exempt_from_minimum_management(p)
	not grassland_used(p)
	object.get(p, ["operations", "use_events"], null) != null
}

forage_like(p) if common.is_grassland(p)

forage_like(p) if common.is_arable_forage(p)

# ---------------------------------------------------------------------------
# ATB-VD-001: Unterjährige Flächenweitergabe ohne Weiterführung -> Code OP bzw. OPUBB
# ---------------------------------------------------------------------------
violations contains {"rule_id": "ATB-VD-001", "subject": common.parcel_id(p), "message": "Unterjährig weitergegebene Fläche ohne Weiterführung bis Jahresende ist mit OP bzw. OPUBB zu codieren"} if {
	some p in common.parcels
	object.get(p, ["transfer", "transferred_during_year"], false)
	not object.get(p, ["transfer", "successor_continues_until_year_end"], false)
	not common.has_code(p, "OP")
	not common.has_code(p, "OPUBB")
}

# ATB-OP-002: Nichterfüllung wegen reinem Fremdverschulden -> maßnahmenbezogener OP-Code; sonst Code löschen oder Selbstanzeige.
violations contains {"rule_id": "ATB-OP-002", "subject": common.parcel_id(p), "message": "Nichterfüllung ohne Löschung des Codes, OP-Codierung oder Selbstanzeige"} if {
	some p in common.parcels
	object.get(p, ["compliance", "obligation_not_met"], false)
	not common.has_code(p, "OPUBB")
	not common.has_code(p, "OP")
	not object.get(p, ["compliance", "self_reported"], false)
}

# ---------------------------------------------------------------------------
# ATB-AUSZ-001..002: Auszahlung bis 30.06. des Folgejahres, Teilzahlung max. 75 %
# ---------------------------------------------------------------------------
payment_deadline := sprintf("%d-06-30", [common.year + 1])

max_advance_share := 0.75
