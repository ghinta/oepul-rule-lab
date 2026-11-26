package oepul.o6_17

import data.o17_tables as tab
import rego.v1

alpine_modulation(area, driven_rgve) := modulation(min([area, driven_rgve])) if {
	area > 0
	driven_rgve > 0
}

exemption(p) if {
	some r in tab.management_exemptions
	input.farm.year >= 2023
	input.farm.year <= r.last_year
	p.management.exemption_use in r.uses
	p.management.exemption_measure in r.measures
}

# Erfüllung der allgemeinen Mindestbewirtschaftung. Spezifische Auflagen der
# jeweiligen Ausnahme werden in ihrer eigenen Maßnahme geprüft.
management_met(p) if exemption(p)

management_met(p) if {
	a := p.management
	a.category in {"Acker ohne Ackerfutter", "Geschützter Anbau"}
	a.proper_establishment
	a.annual_care
	a.harvest_removed_percent >= 85
}

management_met(p) if {
	p.management.proper_establishment
	p.management.annual_care
	drought_harvest_exception(p)
}

management_met(p) if {
	a := p.management
	a.category in {"Dauerkultur", "Spezialkultur", "Wein"}
	a.proper_establishment
	a.annual_care
	a.harvested_and_removed
}

management_met(p) if {
	a := p.management
	a.category in {"Grünland", "Ackerfutter"}
	p.mfa_use != "Bergmähder"
	a.whole_mown_and_removed_this_year
}

management_met(p) if {
	a := p.management
	a.category in {"Grünland", "Ackerfutter"}
	p.mfa_use != "Bergmähder"
	a.whole_grazed_this_year
}

management_met(p) if {
	p.mfa_use == "Bergmähder"
	p.management.whole_mown_and_removed_within_two_years
}

management_met(p) if {
	a := p.management
	a.category == "Aus der Produktion genommen"
	a.maintenance_within_two_years
	green_cover_ok(a)
}

green_cover_ok(a) if a.green_cover_established
green_cover_ok(a) if a.permitted_self_greening

parcel_exclusions[p.parcel_id] contains "Ausgeschlossene Schlagnutzung" if {
	some p in input.land.parcels
	p.mfa_use in tab.excluded_uses
}

parcel_exclusions[p.parcel_id] contains "Keine aktive Bewirtschaftung" if {
	some p in input.land.parcels
	p.oepul_assessment.active_production == false
	not exemption(p)
}

parcel_exclusions[p.parcel_id] contains reason if {
	some p in input.land.parcels
	some key, reason in {"applied_for_17": "Maßnahme nicht beantragt", "correctly_identified": "Fläche falsch identifiziert", "predominantly_agricultural": "Nicht hauptsächlich landwirtschaftlich genutzt"}
	p.oepul_assessment[key] == false
}

parcel_exclusions[p.parcel_id] contains reason if {
	some p in input.land.parcels
	some key, reason in {"gloez_landscape_element": "GLÖZ-Landschaftselement", "restricted_national_park": "Relevante Nationalparkauflage", "approved_trial_prevents_compliance": "Genehmigter Versuch mit Auflagenabweichung", "op_for_17": "OP für Maßnahme 17"}
	p.oepul_assessment[key]
}

parcel_exclusions[p.parcel_id] contains "Nationalpark mit flächenbezogenem Ausschluss" if {
	some p in input.land.parcels
	p.oepul_assessment.national_park in {"Neusiedlersee", "Donau-Auen"}
}

parcel_exclusions[p.parcel_id] contains "Code OP oder VF" if {
	some p in input.land.parcels
	some c in p.mfa_codes
	c in {"OP", "VF"}
}

incompatible_pair contains [r.left, r.right] if {
	some r in tab.farm_conflicts
	ms := input.farm.o6_17.active_measures
	r.left in ms
	r.right in ms
	not partial_exception(r, ms)
}

partial_exception(r, ms) if {
	r.partial_bio_exception
	"BIO-Teilbetrieb" in ms
}

course_certificate_due if {
	c := input.documentation.course_confirmation
	c.ama_requested
	c.provider_submitted == false
	c.farm_submitted == false
}

regular_divrs_use(u, _) if u.cleaning_cut == false

regular_divrs_use(u, m) if {
	u.cleaning_cut
	m.first_application_year == false
}

regional_management_met(p) if {
	m := p.operations.divrs_management
	m.mulched == false
	m.removed
	is_array(m.uses)
	is_array(m.fertilisers)
	every f in m.fertilisers { f in {"Festmist", "Festmistkompost"} }
	every u in m.uses {
		date_ok(u.date)
		startswith(u.date, sprintf("%d-", [input.farm.year]))
		is_boolean(u.cleaning_cut)
	}
	is_boolean(m.first_application_year)
	uses := [u | some u in m.uses; regular_divrs_use(u, m)]
	count(uses) <= 2
	every u in uses { substring(u.date, 5, 5) >= "07-15" }
}

# Nur Codierung und betriebliche Voraussetzungen der vorzeitigen/zusätzlichen
# Ackernutzung. Der jeweilige Flächenanteil bleibt bei UBB/BIO unbezahlt.
coded_early_use(p) if {
	input.farm.year == 2026
	p.land_use == "arable"
	p.constraints.biodiversity_area.is_biodiversity_area
	a := p.div_2026
	a.other_restrictive_conditions == false
	coding_needed(a)
	code := {"UBB": "OPUBB", "BIO": "OPBIO", "BIO-Teilbetrieb": "OPBIO"}[a.partner]
	code in p.mfa_codes
}

coding_needed(a) if {
	a.early_use
	a.mowed_beyond_free_quarter
}

coding_needed(a) if {
	a.early_use
	a.early_grazing
}

coding_needed(a) if a.third_arable_use

div_minimum(mown_ha) := mown_ha * 0.07 if mown_ha > 2

else := 0 if mown_ha >= 0

div_field_minimum(total_mown, field_mown) := 0.15 if {
	total_mown >= 10
	field_mown > 5
}

else := 0 if {
	total_mown >= 0
	field_mown >= 0
}

div_field_shortfalls contains f.field_id if {
	companion
	some f in input.land.div_field_blocks
	f.eligible_div_ha + f.assigned_gloez_lse_ha < div_field_minimum(agl_mown_ha, f.mown_excluding_mountain_ha)
}

bio_cycle_rate := 40 if {
	input.farm.year >= 2025
	input.farm.year <= 2028
	some m in input.farm.o6_17.active_measures
	m in {"BIO", "BIO-Teilbetrieb"}
	stocking_density >= 0.3
	stocking_density < 1.4
	bio_grass := input.land.bio_circular_grass
	bio_grass.mown_ha > 0
	100 * bio_grass.div_or_species_rich_union_ha > 8 * bio_grass.mown_ha
	bio_grass.div_or_species_rich_union_ha <= bio_grass.mown_ha
}

div_grass_exception(p) if {
	input.farm.year == 2026
	p.land_use == "grassland"
	p.constraints.biodiversity_area.is_biodiversity_area
	g := p.div_grass
	g.early_exception
	g.other_restrictive_conditions == false
	code := {"UBB": "OPUBB", "BIO": "OPBIO", "BIO-Teilbetrieb": "OPBIO"}[g.partner]
	code in p.mfa_codes
}

div_rest_days(p) := 49 if {
	p.div_grass.variant == "DIVNFZ"
	div_grass_exception(p)
}

else := 63 if p.div_grass.variant == "DIVNFZ"

date_ns(d) := time.parse_rfc3339_ns(sprintf("%sT00:00:00Z", [d]))
phenology_2026(n) if n == 0

phenology_2026(n) if {
	n >= 4
	n <= 7
	round(n) == n
}

divsz_day(p) := date_ns(p.div_grass.use_date) if {
	input.farm.year == 2026
	p.land_use == "grassland"
	p.div_grass.variant == "DIVSZ"
	startswith(p.div_grass.use_date, "2026-")
	phenology_2026(p.div_grass.phenology_days)
}

divsz_use_allowed(p) if {
	g := p.div_grass
	divsz_day(p) >= date_ns("2026-07-15") - (g.phenology_days * 86400000000000)
}

divsz_use_allowed(p) if {
	g := p.div_grass
	g.comparable_second_cut_started
	divsz_day(p) >= date_ns("2026-06-15") - (g.phenology_days * 86400000000000)
}

divsz_use_allowed(p) if {
	div_grass_exception(p)
	g := p.div_grass
	g.comparable_second_cut_started
	divsz_day(p) >= date_ns("2026-06-15") - ((14 + g.phenology_days) * 86400000000000)
}

conditionality_findings contains f.domain if {
	some f in input.documentation.conditionality_findings
	f.year == input.farm.year
	f.official_noncompliance
}

permitted_conversion(e) if {
	e.old_use in {"A", "S", "WI", "WT"}
	e.new_use in {"G", "D"}
}

permitted_conversion(e) if {
	e.old_use in {"G", "D"}
	e.new_use == "L"
}

permitted_conversion(e) if {
	e.new_use == "LSE Mehrnutzenhecke"
	e.hedge_or_agroforestry_measure in {"UBB", "BIO", "BIO-Teilbetrieb"}
}

permitted_conversion(e) if {
	e.new_use == "LSE Agroforststreifen"
	e.hedge_or_agroforestry_measure == "1C"
}

control_transfer_exception(e) if {
	e.transferred_control
	e.operator_succession == false
}

# Gründe für OP im Bereich der betroffenen Maßnahme. Amtlich anerkannte
# Ausnahmen sind bei Ermittlung der nicht erfüllten Verpflichtung zu beachten.
op_required_reasons[p.parcel_id] contains reason if {
	some p in input.land.parcels
	some key, reason in {"overlap_public_or_mandatory": "Leistungsüberschneidung", "official_compensation_area": "Behördlicher Ausgleich", "full_contract_unachievable": "Vertrag nicht durchgehend erfüllbar", "sole_external_fault": "Reines Fremdverschulden"}
	p.op_reasons[key]
}

op_required_reasons[p.parcel_id] contains "Übernehmer führt Auflagen nicht bis Jahresende weiter" if {
	some p in input.land.parcels
	p.op_reasons.successor_continues_to_year_end == false
}

op_required_reasons[p.parcel_id] contains "Ernteverpflichtung verfehlt" if {
	some p in input.land.parcels
	p.op_reasons.harvest_obligation_missed
	not drought_harvest_exception(p)
}

max_advance := (input.documentation.payment.approved_annual_eur * 75) / 100 if {
	input.documentation.payment.administrative_checks_complete
	input.documentation.payment.approved_annual_eur >= 0
}

payment_deadline(y) := sprintf("%d-06-30", [y + 1]) if {
	y >= 2023
	y <= 2028
}

over_ceiling(p, y) := max([0, amount - limit.eur_ha]) if {
	some regular in tab.payment_ceilings
	regular.group == "regulär"
	between_years(regular, y)
	some limit in tab.payment_ceilings
	limit.group == p.ceiling_group
	between_years(limit, y)
	is_array(p.stacked_area_payments)
	every pay in p.stacked_area_payments { is_string(pay.measure_code); is_number(pay.eur_per_ha); pay.eur_per_ha >= 0}
	amount := sum([pay.eur_per_ha | some pay in p.stacked_area_payments; not pay.measure_code in regular.excluded_measures])
}
