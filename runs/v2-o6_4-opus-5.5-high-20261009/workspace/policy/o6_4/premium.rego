# o6_4 – Prämienberechnung (Sätze, Kombination, Kürzungsreihenfolge, Modulation, Obergrenze, Zugangskürzung)
package oepul.o6_4

import rego.v1

# O64-PRM-001: Prämiensatz je Mähverfahren und Jahr
premium_rate(code, yr) := r.eur_per_ha if {
	some r in cfg.premium_rates
	r.code == code
	yr >= r.year_from
	rate_year_to_ok(r.year_to, yr)
}

rate_year_to_ok(to, _) if to == null

rate_year_to_ok(to, yr) if {
	is_number(to)
	yr <= to
}

# Wirksamer Mähcode: aus der dokumentierten Bewirtschaftung, sonst beantragter Code
effective_code[pid] := c if {
	some pid, _ in o6_4_parcels
	c := expected_mowing_code[pid]
}

effective_code[pid] := c if {
	some pid, p in o6_4_parcels
	not expected_mowing_code[pid]
	c := declared_mowing_code(p)
	c != null
}

# O64-PRM-003: auf der Einzelfläche nur mit LSE-Abgeltung (1A/1B) kombinierbar
combinable_area_premium(m) if {
	some row in cfg.annex_l_combination_row_4
	row.measure_number == m
	row.combinable == true
	row.landscape_elements_only == false
}

combination_conflicts[pid] contains m if {
	some pid, p in o6_4_parcels
	some m in object.get(parcel_oepul(p), "premium_measures", [])
	m != "4"
	not combinable_area_premium(m)
}

# Abgeltung punktförmiger Landschaftselemente aus 1A/1B (kombinierbar)
le_measure := "1B" if "1B" in farm_measures

le_measure := "1A" if {
	"1A" in farm_measures
	not "1B" in farm_measures
}

le_premium[pid] := total if {
	some pid, p in o6_4_parcels
	m := le_measure
	total := sum([amount |
		some le in object.get(parcel_oepul(p), "point_landscape_elements", [])
		some r in cfg.landscape_element_rates_combinable
		r.measure_number == m
		r.element == le.element
		amount := le.count * r.eur_per_element
	])
}

le_amount(pid) := object.get(le_premium, pid, 0)

# Ausschlussgründe für die o6_4-Prämie eines Schlages
premium_blockers[pid] contains reason if {
	some pid, _ in o6_4_parcels
	not parcel_is_bergmahd[pid]
	reason := "Bergmahd-Definition nicht erfüllt oder Angaben fehlen (O64-ELIG-001..004)"
}

premium_blockers[pid] contains reason if {
	some pid, _ in o6_4_parcels
	some f in object.get(parcel_premium_exclusions, pid, set())
	reason := f.message
}

premium_blockers[pid] contains reason if {
	some pid, _ in o6_4_parcels
	count(object.get(combination_conflicts, pid, set())) > 0
	reason := "unzulässige Maßnahmenkombination auf der Einzelfläche (O64-PRM-003)"
}

premium_blockers[pid] contains "keine Mahd im Antragsjahr – keine Prämie (O64-PRM-002)" if {
	some pid, _ in o6_4_parcels
	object.get(effective_code, pid, "BM0") == "BM0"
}

premium_blockers[pid] contains "Fläche in Naturschutz/Ergebnisorientierte Bewirtschaftung umgewandelt (O64-APP-003)" if {
	some pid, _ in o6_4_parcels
	pid in converted_parcels
}

farm_premium_blockers contains "förderwerbende Person bzw. Betrieb erfüllt Teilnahmevoraussetzungen nicht" if not applicant_eligible

farm_premium_blockers contains "kein gültiger Vertrag für das Antragsjahr" if not contract_active

farm_premium_blockers contains "Abmeldung im laufenden Förderjahr – Maßnahme im Förderjahr nicht gültig (O64-GEN-013)" if exit_in_current_year

farm_premium_blockers contains "Ausschluss aus der Maßnahme nach zweimaliger 100 %-Kürzung (O64-GEN-026)" if excluded_from_measure

farm_premium_blockers contains "Vor-Ort-Kontrolle verweigert (O64-GEN-032)" if control_refused

farm_premium_blockers contains "kein Zahlungsantrag im Antragsjahr (O64-GEN-034)" if payment_claim_missing

premium_parcels[pid] := p if {
	some pid, p in o6_4_parcels
	count(farm_premium_blockers) == 0
	count(object.get(premium_blockers, pid, set())) == 0
}

# Schritt 1: Bruttoprämie je Schlag
gross_premium[pid] := round2(rate * p.area_ha) if {
	some pid, p in premium_parcels
	rate := premium_rate(effective_code[pid], year)
}

gross_premium_total := sum([v | some v in gross_premium])

# Schritt 2: inhaltliche Kürzungen (Punkt 1.12.1.3 SRL, § 48 GSP-AV)
after_content[pid] := v * (1 - (content_reduction_percent / 100)) if {
	some pid, v in gross_premium
}

# Schritt 3: Modulation nach Betriebsgröße (O64-GEN-029)
total_farm_area := object.get(input, ["land", "total_area_ha"], 0)

modulated_area(total) := sum([portion |
	some b in cfg.modulation_bands
	upper := band_upper(b.to_ha, total)
	portion := (max([0, upper - b.from_ha]) * b.payout_percent) / 100
])

band_upper(to, total) := total if to == null

band_upper(to, total) := min([to, total]) if to != null

modulation_factor := modulated_area(total_farm_area) / total_farm_area if total_farm_area > 0

modulation_factor := 1 if total_farm_area <= 0

after_modulation[pid] := v * modulation_factor if {
	some pid, v in after_content
}

# Schritt 4: Obergrenze für Flächenzahlungen je Schlag inkl. LSE (O64-GEN-028)
area_payment_cap_rate := r.eur_per_ha if {
	some r in cfg.area_payment_caps
	r.key == "general"
	year >= r.year_from
	rate_year_to_ok(r.year_to, year)
}

cap_excess[pid] := max([0, (v + le_amount(pid)) - (area_payment_cap_rate * premium_parcels[pid].area_ha)]) if {
	some pid, v in after_modulation
}

after_cap[pid] := max([0, v - cap_excess[pid]]) if {
	some pid, v in after_modulation
}

# Schritt 5: Zugangskürzung bei Flächenausweitung über die Grenze (O64-GEN-023)
premium_area_total := sum([p.area_ha | some p in premium_parcels])

access_factor := area_increase_limit_ha / premium_area_total if {
	premium_area_total > area_increase_limit_ha
} else := 1

net_premium[pid] := round2(v * access_factor) if {
	some pid, v in after_cap
}

net_premium_total := round2(sum([v | some v in net_premium]))

# O64-GEN-027: kein Auszahlungsbetrag ≤ 50 € erforderlich (Ermessen der AMA)
payment_may_be_waived if net_premium_total <= cfg.deadlines.minimum_payment_eur
