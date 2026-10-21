# Jahresspezifische Festlegungen 2026 (AMA-Aktuelles vom 22.05.2026, 05.08.2026 und 12.08.2026).
package oepul.o6_1b

n26 := data.o6_1b.notices_2026

# Vorzeitige Nutzung 2026 nur mit Codierung OPBIO (bzw. OPUBB) - keine Prämie auf der Fläche.
# Flächen mit (auch) anderen Vorgaben (z. B. Naturschutz) sind von der Ausnahme nicht umfasst.
drought_2026_opt_out(p) if {
	year == n26.early_use_2026.year
	count(codes(p) & {c | some c in n26.early_use_2026.opt_out_codes}) > 0
	count(codes(p) & {"NAT", "EBW", "N2"}) == 0
}

# Grünland-Biodiversitätsflächen: Vorverlegung der Nutzung um 14 Tage (DIVSZ)
drought_advance_days(p) := n26.early_use_2026.grassland_advance_days if {
	is_grassland(p)
	drought_2026_opt_out(p)
}

drought_advance_days(p) := 0 if not drought_2026_grassland_opt_out(p)

drought_2026_grassland_opt_out(p) if {
	is_grassland(p)
	drought_2026_opt_out(p)
}

# Acker-Biodiversitätsflächen: dritte Nutzung 2026 zulässig, wenn OPBIO/OPUBB codiert
third_use_2026_allowed(p) if {
	is_arable_div(p)
	drought_2026_opt_out(p)
	n26.early_use_2026.arable_third_use_allowed == true
}

# Vorzeitig (vor 1.8.) genutzte Acker-DIV-Flächen über die 25 % hinaus bzw. beweidete Flächen
# müssen 2026 mit OPBIO codiert sein; ohne Codierung Beanstandung (DA-018/DA-019).
violations contains {"rule_id": "O61B-N26-001", "message": sprintf("Acker-DIV-Fläche %s: mehr als 2 Nutzungen trotz OPBIO-Codierung (dritte Nutzung erst ab Meldung 12.08.2026 zulässig)", [p.parcel_id])} if {
	year == 2026
	some p in parcels
	is_arable_div(p)
	drought_2026_opt_out(p)
	count(counted_uses(p)) > 3
}

# Wechsel der Grünland-Biodiversitätsvariante nach dem 15. April
variant_change_allowed(ch) if {
	some r in n26.grassland_variant_changes_after_04_15
	r.from == ch.from
	r.to == ch.to
	md(ch.date) <= r.until
}

variant_change_allowed(ch) if md(ch.date) <= n26.deadlines.mfa_deadline

violations contains {"rule_id": "O61B-N26-004", "message": sprintf("Unzulässiger Wechsel der Grünland-Biodiversitätsvariante %s -> %s am %s auf Schlag %s", [ch.from, ch.to, ch.date, p.parcel_id])} if {
	some p in parcels
	some ch in object.get(div_info(p), "variant_changes", [])
	not variant_change_allowed(ch)
}

# Ernteverpflichtung 2026: automatische Anerkennung höherer Gewalt in Dürre-Bezirken
parcel_federal_state(p) := object.get(p, "federal_state", object.get(input, ["farm", "region", "federal_state"], ""))

parcel_district(p) := object.get(p, "district", object.get(input, ["farm", "region", "district"], ""))

drought_district(p) if {
	some row in n26.drought_2026_harvest_waiver_districts
	row.federal_state == parcel_federal_state(p)
	district_listed(row, parcel_district(p))
}

district_listed(row, _) if "*" in row.districts

district_listed(row, d) if d in row.districts

drought_harvest_waiver(p) if {
	year == 2026
	drought_district(p)
	object.get(p, ["crop", "late_harvest_crop"], false) == true
	object.get(p, ["operations", "no_harvestable_stand_due_to_drought"], false) == true
}

# Einzelbetriebliche Meldung höherer Gewalt erforderlich außerhalb der Gebietskulisse
force_majeure_report_required contains p.parcel_id if {
	year == 2026
	some p in parcels
	harvest_required(p)
	object.get(p, ["operations", "no_harvestable_stand_due_to_drought"], false) == true
	not drought_harvest_waiver(p)
}
