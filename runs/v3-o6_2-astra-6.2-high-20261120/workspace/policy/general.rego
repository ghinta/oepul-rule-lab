package oepul.o6_2

import rego.v1

eligible_size_use(use) if {
	use in t.size_eligible_uses
	use != "K20 auf NF"
	use != "Agroforststreifen"
}

eligible_size_use("K20 auf NF") if year <= 2024
eligible_size_use("Agroforststreifen") if year >= 2025
reduction_order := t.reduction_order

special_management(p) if {
	some row in t.minimum_management_exceptions
	row.use == p.mfa.management_exception
	year <= row.through
	some m in p.mfa.parcel_measures
	m in row.measures
	year_valid_measure(m)
}

year_valid_measure(m) if m != "1C"
year_valid_measure("1C") if year >= 2025

permanent_management_ok(p) if {
	p.land_use == "special_crop"
	p.operations.harvest.proper_planting
	p.operations.harvest.annual_care
	p.operations.harvest.harvested_and_removed
}

forage_management_ok(p) if {
	sensitive(p)
	p.operations.harvest.full_cut_removed_this_year
}

forage_management_ok(p) if {
	sensitive(p)
	p.operations.harvest.full_grazing_this_year
}

forage_management_ok(p) if {
	sensitive(p)
	p.mfa.mountain_meadow
	p.operations.harvest.full_cut_removed_last_year
}

retired_cover_ok(p) if p.operations.harvest.proper_green_cover

retired_cover_ok(p) if {
	p.mfa.management_exception == "Nichtproduktive Ackerfläche"
	"1C" in p.mfa.parcel_measures
	year >= 2025
	p.operations.harvest.self_greened
}

retired_management_ok(p) if {
	p.mfa.out_of_production
	retired_cover_ok(p)
	p.operations.harvest.mulched_or_care_cut_in_two_years
}

op_reason(p, "Ernte") if {
	p.mfa.harvest_duty
	p.operations.harvest.harvest_duty_failed
	p.operations.harvest.individual_force_majeure_approved == false
	not drought_waiver(p)
}

op_reason(p, "Öffentliche Leistungsüberschneidung") if p.mfa.overlap_public
op_reason(p, "Behördlicher Ausgleich") if p.mfa.mandated_compensation_or_infrastructure
op_reason(p, "Laufzeit") if p.mfa.can_complete_commitment == false
op_reason(p, "Weitergabe") if p.mfa.transfer_without_continuation
op_reason(p, "Fremdverschulden") if p.mfa.exclusively_third_party_breach

op_reason(p, "Obstqualität") if {
	p.crop.crop_category == "orchard"
	p.crop.high_quality_stock == false
}

op_reasons[p.parcel_id] contains reason if {
	some p in input.land.parcels
	some reason in {"Ernte", "Öffentliche Leistungsüberschneidung", "Behördlicher Ausgleich", "Laufzeit", "Weitergabe", "Fremdverschulden", "Obstqualität"}
	op_reason(p, reason)
}

fertilizer_legal_issue(p) if {
	p.mfa.country == "AT"
	p.mfa.agricultural_area
	p.operations.fertilizer.legal_limits_and_periods_met == false
}

missing_psm_codes[p.parcel_id] contains c if {
	some p in input.land.parcels
	p.mfa.country == "AT"
	is_array(p.mfa.codes)
	some c in required_psm_codes(p)
	not c in p.mfa.codes
}

psm_update_due(p) if {
	year >= 2023
	year <= 2025
	sensitive(p)
	p.mfa.planned_psm_cancelled_or_changed
}

ubb_hours_ok if input.documentation.credited_ubb_biodiversity_hours >= 3
div_minimum_ha(area) := area * 0.07 if area > 2

else := 0 if {
	area >= 0
	area <= 2
}

# Teilprüfung der UBB-/BIO-Ausnahme. Auflagen der Projektbestätigung sind vorrangig.
div_op(p) if {
	some c in p.mfa.codes
	c in {"OPUBB", "OPBIO"}
}

early_arable_div(p) if {
	year == 2026
	p.land_use == "arable"
	p.mfa.ubb_arable_div
	p.mfa.other_use_restrictions == false
	div_op(p)
}

third_div_use(p) if {
	early_arable_div(p)
	p.operations.div_uses_this_year == 3
}

annual_div_mowing(p) if {
	p.land_use == "grassland"
	some code in t.div_codes
	code in p.mfa.codes
	p.operations.harvest.cut_and_removed_at_least_once
}

div_rest_days(p) := 49 if {
	year == 2026
	"DIVNFZ" in p.mfa.codes
	div_op(p)
	p.mfa.other_use_restrictions == false
}

else := 7 * div_variant("DIVNFZ").rest_weeks if "DIVNFZ" in p.mfa.codes

field_div_minimum(relevant_farm_ha, field_block_ha) := 0.15 if {
	relevant_farm_ha >= 10
	field_block_ha > 5
}

else := 0 if {
	is_number(relevant_farm_ha)
	is_number(field_block_ha)
}

div_2026_example(state) := row if {
	some row in t.district_div_early_examples
	row.state == state
}

parcel_combinations[m] := {"measure": t.measure_names[m], "marker": marker} if {
	some m, marker in combination_row("2")
	m != "2"
}

commitment_class(id) := "mehrjährig" if id in t.multiyear_contracts

commitment_class(id) := "einjährig" if {
	id in t.annual_contracts
	year_valid_measure(id)
}

annually_variable(id) if id in t.annual_units
special_takeover(id) if id in t.special_takeovers

public_body_exception(id) if {
	some r in t.public_body_exceptions
	r.measure == id
	r.year_from <= year
	year <= r.year_to
}

stock_loss_effect(previous_density) := {"earlier_payments_recovered_for_status_change": false, "obligations_continue": true} if {
	previous_density >= 0.30
	stock_band == "none"
}

known_incompatibility if app.ubb == false
known_incompatibility if app.bio_scope in {"whole_farm", "other_partial"}

known_incompatibility if {
	app.bio_scope == "wine_fruit_hops"
	some f in ["separate_units", "separate_crop_sectors", "separate_stores"]
	app[f] == false
}

missing_combination_consequence := access_consequence(year == app.start_year) if {
	known_incompatibility
	contract.start_year <= year
	year <= 2028
}

# Bei gleichem Kalendertag ist die Uhrzeit für die Reihenfolge entscheidend.
before_or_unset(_, end) if end == null

before_or_unset(d, end) if {
	valid_date(end)
	d < end
}

exit_before_control if {
	proceedings := input.documentation.proceedings
	valid_date(proceedings.withdrawal_date)
	before_or_unset(proceedings.withdrawal_date, proceedings.onsite_announced_or_started)
	before_or_unset(proceedings.withdrawal_date, proceedings.administrative_result_received)
}

correction_window_open if {
	proceedings := input.documentation.proceedings
	proceedings.impossible_combination_requested
	proceedings.control_objection == false
	proceedings.payment_notification_received == null
}

third_party_evidence_due(p) if {
	p.mfa.exclusively_third_party_breach
	input.documentation.proceedings.third_party_proof_retained == false
}

trial_evidence_due(p) if {
	p.mfa.approved_trial_precludes_obligation
	false in [object.get(input.documentation.proceedings, "trial_approval_retained", null), object.get(input.documentation.proceedings, "trial_type_size_location_recorded", null)]
}

training_at_deadline := "erfüllt" if count(trained_people) > 0

else := "Einzelfallprüfung Stichtag" if {
	is_array(input.documentation.courses)
	some c in input.documentation.courses
	c.left_on == "2025-12-31"
}

else := "Stundennachweis fehlt" if {
	is_array(input.documentation.courses)
	input.documentation.course_history_complete
	year >= 2025
	valid_date(input.documentation.training_assessment_date)
	input.documentation.training_assessment_date >= "2025-12-31"
}

annual_stock_change := stock_loss_effect(input.livestock.previous_rgve_per_forage_ha)
