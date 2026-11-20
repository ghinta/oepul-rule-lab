# o6_13 – teilnahmefähige Flächen, Codierung, Nutzungsart und Förderfähigkeit je Schlag
package oepul.o6_13

# ---------------------------------------------------------------------------
# O6_13-APP-03: Schlag muss in der Feldstücksliste mit Code NUE gekennzeichnet sein
# ---------------------------------------------------------------------------
parcel_codes(p) := object.get(p, "oepul_codes", [])

nue_coded(p) if params.parcel_code in parcel_codes(p)

nue_parcels contains p if {
	some p in parcels
	nue_coded(p)
}

pc(p) := object.get(p, "protected_cultivation", {})

# ---------------------------------------------------------------------------
# O6_13-ELIG-01: befestigte Gewächshäuser mit Folien-, Glas- oder
# Kunststoffeindeckung sowie unbefestigte Folientunnel
# ---------------------------------------------------------------------------
eligible_structure_codes := {row.code | some row in params.eligible_structure_types}

is_protected_structure(p) if {
	s := pc(p)
	s.structure_type == "unfixed_foil_tunnel"
}

is_protected_structure(p) if {
	s := pc(p)
	s.structure_type == "fixed_greenhouse"
	s.covering_material in params.fixed_greenhouse_coverings
}

# ---------------------------------------------------------------------------
# O6_13-APP-05 / O6_13-APP-06: gewachsener Boden -> "A", Töpfe/Substrat -> "GA";
# bei wechselweiser Bewirtschaftung ist der Stand am 1. April maßgeblich
# ---------------------------------------------------------------------------
effective_growing_system(p) := gs if {
	s := pc(p)
	s.growing_system != "alternating"
	gs := s.growing_system
}

effective_growing_system(p) := gs if {
	s := pc(p)
	s.growing_system == "alternating"
	gs := s.growing_system_on_april_1
}

expected_field_use_type(p) := params.field_use_type_by_growing_system[effective_growing_system(p)]

declared_field_use_type(p) := object.get(pc(p), "field_use_type", null)

# ---------------------------------------------------------------------------
# O6_13-ELIG-02..04: Verkaufs-, Schau-, Lagerflächen, ungenutzte Zwischenflächen
# und Gangflächen über das nötige Ausmaß sind nicht förderfähig
# ---------------------------------------------------------------------------
non_eligible_part_ha(p) := sum([object.get(pc(p), row.key, 0) | some row in params.non_eligible_area_components])

eligible_area_ha(p) := max([0, p.area_ha - non_eligible_part_ha(p)])

# ---------------------------------------------------------------------------
# Schlagbezogene Ausschlussgründe (nur für NUE-codierte Schläge relevant)
# ---------------------------------------------------------------------------
parcel_issue(p, rule_id, message) := {
	"parcel_id": p.parcel_id,
	"rule_id": rule_id,
	"message": message,
}

parcel_issues contains parcel_issue(p, "O6_13-ELIG-01", "Schlag liegt nicht in einem befestigten Gewächshaus (Glas/Folie/Kunststoff) oder unbefestigten Folientunnel") if {
	some p in nue_parcels
	not is_protected_structure(p)
}

parcel_issues contains parcel_issue(p, "O6_13-APP-04", "Feldstücksnutzungsart ist weder Ackerland (A) noch Geschützter Anbau (GA)") if {
	some p in nue_parcels
	not declared_field_use_type(p) in params.eligible_field_use_types
}

parcel_issues contains parcel_issue(p, "O6_13-APP-05", sprintf("Nutzungsart %v passt nicht zum Anbausystem (erwartet %v)", [declared_field_use_type(p), expected_field_use_type(p)])) if {
	some p in nue_parcels
	pc(p).growing_system != "alternating"
	declared_field_use_type(p) != expected_field_use_type(p)
}

parcel_issues contains parcel_issue(p, "O6_13-APP-06", sprintf("Wechselweise Bewirtschaftung: Nutzungsart gemäß Stand 1. April muss %v sein", [expected_field_use_type(p)])) if {
	some p in nue_parcels
	pc(p).growing_system == "alternating"
	declared_field_use_type(p) != expected_field_use_type(p)
}

parcel_issues contains parcel_issue(p, "O6_13-APP-06", "Wechselweise Bewirtschaftung ohne Angabe des Anbausystems am 1. April") if {
	some p in nue_parcels
	pc(p).growing_system == "alternating"
	not effective_growing_system(p)
}

# O6_13-GEN-NE-01: nicht förderfähige Flächenarten (inkl. Sonstige Flächen im geschützten Anbau)
non_eligible_area_type_codes := {row.code | some row in general.non_eligible_area_types}

parcel_issues contains parcel_issue(p, "O6_13-GEN-NE-01", sprintf("Nicht förderfähige Fläche: %v", [p.area_type])) if {
	some p in nue_parcels
	object.get(p, "area_type", "standard") in non_eligible_area_type_codes
}

parcel_issues contains parcel_issue(p, "O6_13-GEN-NE-01", "Sonstige Fläche im geschützten Anbau ist nicht förderfähig") if {
	some p in nue_parcels
	is_true(pc(p), "is_other_protected_area")
}

# O6_13-GEN-ACTIVE-01: aktive landwirtschaftliche Produktion
parcel_issues contains parcel_issue(p, "O6_13-GEN-ACTIVE-01", "Fläche wird nicht aktiv für die landwirtschaftliche Produktion bewirtschaftet") if {
	some p in nue_parcels
	is_false(p, "actively_managed")
}

# O6_13-GEN-NE-02: nicht für die Maßnahme angegebene oder falsch identifizierte Fläche
parcel_issues contains parcel_issue(p, "O6_13-GEN-NE-02", "Fläche falsch identifiziert bzw. außerhalb der Flächenreferenz") if {
	some p in nue_parcels
	is_false(p, "correctly_identified")
}

# O6_13-GEN-LOC-01: Lage in Österreich
parcel_issues contains parcel_issue(p, "O6_13-GEN-LOC-01", "Fläche liegt nicht in Österreich") if {
	some p in nue_parcels
	is_false(p, "located_in_austria")
}

# O6_13-GEN-NP-01: Nationalparkflächen
national_park_rule(name) := row if {
	some row in general.national_park_rules
	row.national_park == name
}

national_park_excludes(p) if {
	row := national_park_rule(p.national_park)
	row.area_premiums_only_for_measures != null
	not measure_code in row.area_premiums_only_for_measures
}

national_park_excludes(p) if {
	row := national_park_rule(p.national_park)
	measure_code in row.measures_without_premium
}

national_park_excludes(p) if {
	object.get(p, "national_park", null) != null
	not measure_code in general.national_park_exempt_measures
	is_true(p, "national_park_relevant_restrictions")
}

parcel_issues contains parcel_issue(p, "O6_13-GEN-NP-01", sprintf("Nationalparkfläche (%v): keine Prämie", [p.national_park])) if {
	some p in nue_parcels
	national_park_excludes(p)
}

# O6_13-GEN-OP-01 / O6_13-GEN-VF-01: Codes OP bzw. VF bzw. maßnahmenbezogener OP-Code
parcel_issues contains parcel_issue(p, "O6_13-GEN-OP-01", "Schlag mit Code OP: keine ÖPUL-Prämie im Förderjahr") if {
	some p in nue_parcels
	"OP" in parcel_codes(p)
}

parcel_issues contains parcel_issue(p, "O6_13-GEN-OP-01", "Maßnahmenbezogener OP-Code für o6_13: keine Prämie für diese Maßnahme") if {
	some p in nue_parcels
	measure_code in object.get(p, "op_measure_codes", [])
}

parcel_issues contains parcel_issue(p, "O6_13-GEN-VF-01", "Versuchsfläche (Code VF): im laufenden Antragsjahr keine Prämie") if {
	some p in nue_parcels
	"VF" in parcel_codes(p)
}

# O6_13-GEN-OP-02: verpflichtende OP-Codierung – Fälle, die ohne Codierung als
# Mangel erkannt werden (Leistungsüberschneidung, Ausgleichsflächen, unterjährige Weitergabe)
parcel_funding_overlap(p) := object.get(p, "funding_overlap", {})

parcel_issues contains parcel_issue(p, "O6_13-GEN-DBL-01", "Leistungsüberschneidung mit anderer Förderung der öffentlichen Hand bzw. gesetzlich/behördlich vorgeschriebener Auflage") if {
	some p in nue_parcels
	some key in ["other_public_funding_same_service", "statutory_or_official_requirement"]
	is_true(parcel_funding_overlap(p), key)
}

parcel_issues contains parcel_issue(p, "O6_13-GEN-OP-02", "Behördlich vorgeschriebene Ausgleichsfläche/Infrastrukturnutzung: Code OP erforderlich") if {
	some p in nue_parcels
	is_true(parcel_funding_overlap(p), "official_compensation_area")
}

# O6_13-GEN-DUR-02: unterjährige Weitergabe ohne Weiterführung bis Jahresende
parcel_issues contains parcel_issue(p, "O6_13-GEN-DUR-02", "Unterjährige Flächenweitergabe ohne Weiterführung durch den Übernehmer: keine Prämie für das unvollendete Verpflichtungsjahr") if {
	some p in nue_parcels
	t := object.get(p, "transfer", {})
	is_true(t, "transferred_during_year")
	not is_true(t, "successor_continues_same_or_higher_measure")
}

# O6_13-GEN-OP-02 (Fremdverschulden): betroffene Fläche mit maßnahmenbezogenem OP-Code, keine Prämie
parcel_issues contains parcel_issue(p, "O6_13-GEN-OP-02", "Nichterfüllung durch reines Fremdverschulden: betroffene Fläche ohne Prämie (maßnahmenbezogener OP-Code)") if {
	some p in nue_parcels
	is_true(p, "non_compliance_due_to_third_party_fault")
}

# ---------------------------------------------------------------------------
# O6_13-GEN-MBK-01: Mindestbewirtschaftung auf Flächen im geschützten Anbau
# (ordnungsgemäßer Anbau, jährliche Pflege, Ernte auf >= 85 % des Schlages)
# ---------------------------------------------------------------------------
mbk(p) := object.get(p, "minimum_management", {})

harvest_obligation_waived(p) if is_true(p, "force_majeure_recognised")

harvest_obligation_waived(p) if drought_2026_harvest_exemption(p)

harvest_shortfall(p) if {
	share := object.get(mbk(p), "harvested_share_percent", null)
	share != null
	share < general.minimum_management_arable_and_protected.min_harvested_share_percent
}

parcel_issues contains parcel_issue(p, "O6_13-GEN-MBK-01", "Ernte und Verbringen des Erntegutes auf weniger als 85 % des Schlages (Code OP erforderlich)") if {
	some p in nue_parcels
	harvest_shortfall(p)
	not harvest_obligation_waived(p)
}

parcel_issues contains parcel_issue(p, "O6_13-GEN-MBK-01", sprintf("Mindestbewirtschaftungskriterium nicht erfüllt: %s", [key])) if {
	some p in nue_parcels
	some key in ["properly_cultivated", "annual_care"]
	is_false(mbk(p), key)
}

# ---------------------------------------------------------------------------
# O6_13-SCOPE-01: Prämie für Flächen, auf denen flächendeckend Organismen
# eingesetzt werden
# ---------------------------------------------------------------------------
parcel_issues contains parcel_issue(p, "O6_13-SCOPE-01", "Kein anrechenbarer Nützlingseinsatz auf dem Schlag im Förderjahr") if {
	some p in nue_parcels
	not parcel_has_creditable_use(p)
}

parcel_issues contains parcel_issue(p, "O6_13-SCOPE-01", "Nützlingseinsatz nicht flächendeckend auf dem Schlag") if {
	some p in nue_parcels
	parcel_has_creditable_use(p)
	not parcel_has_full_coverage_use(p)
}

# ---------------------------------------------------------------------------
# O6_13-COMB-01: auf der Einzelfläche mit keiner anderen Prämie kombinierbar
# (Anhang L: Zeile/Spalte 13 leer; Fußnote 2)
# ---------------------------------------------------------------------------
combinable_on_single_parcel(a, b) if {
	some cell in data.o6_13.anhang_l.cells
	cell.row_measure == a
	cell.column_measure == b
}

combinable_on_single_parcel(a, b) if {
	some cell in data.o6_13.anhang_l.cells
	cell.row_measure == b
	cell.column_measure == a
}

measure_number_of(code) := upper(trim_prefix(code, "o6_"))

parcel_issues contains parcel_issue(p, "O6_13-COMB-01", sprintf("Prämie auf der Einzelfläche nicht mit %v kombinierbar", [other])) if {
	some p in nue_parcels
	some other in object.get(p, "other_measures_on_parcel", [])
	not combinable_on_single_parcel(measure_number, measure_number_of(other))
}

parcel_issue_list(p) := [i | some i in parcel_issues; i.parcel_id == p.parcel_id]

parcel_premium_eligible(p) if {
	nue_coded(p)
	count(parcel_issue_list(p)) == 0
}
