package oepul.o6_12

import rego.v1

# Betriebliche Fristen und finanzielle Teilberechnungen.
farm_payment := input.farm.payment_assessment
advance_max_eur := advance_limit(farm_payment.expected_payment_eur) if farm_payment.administrative_checks_closed == true

else := 0 if farm_payment.administrative_checks_closed == false

home_modulation := modulation_factor(farm_payment.home_area_ha)

statutory_reduction := sanction_consequence("second_100", year) if {
	is_number(farm_payment.full_reductions_in_term)
	farm_payment.full_reductions_in_term >= 2
}

else := sanction_consequence(farm_payment.sanction_level, year) if {
	farm_payment.full_reductions_in_term < 2
	is_number(farm_payment.full_reductions_in_term)
}

reclaim_difference_ha := 0 if farm_payment.exception_applies == true

else := 0 if farm_payment.fixed_parcel_obligation == false

else := delta if {
	farm_payment.exception_applies == false
	farm_payment.fixed_parcel_obligation == true
	delta := farm_payment.reduction_ha
	is_number(delta)
	delta >= 0
	limit := loss_tolerance(farm_payment.prior_committed_ha)
	delta > limit
} else := 0 if {
	farm_payment.fixed_parcel_obligation == true
	farm_payment.exception_applies == false
	is_number(farm_payment.reduction_ha)
	farm_payment.reduction_ha >= 0
	farm_payment.reduction_ha <= loss_tolerance(farm_payment.prior_committed_ha)
}

combination_correction_possible := allowed if {
	valid_date(farm_payment.combination_correction_date)
	is_boolean(farm_payment.control_objection)
	end := farm_payment.payout_notification_date
	end != farm_payment.combination_correction_date
	allowed := valid_correction(farm_payment.combination_correction_date, end, farm_payment.control_objection)
}

default valid_correction(_, _, _) := false

valid_correction(d, end, objection) if {
	not objection
	before_receipt(d, end)
}

before_receipt(d, end) if {
	end == null
	valid_date(d)
}

before_receipt(d, end) if {
	valid_date(end)
	d < end
}

# Bei Prüfung und Meldung am selben Tag ist die Reihenfolge der Ereignisse erforderlich.
withdrawal_timing := "rechtzeitig" if {
	valid_date(farm_payment.withdrawal_date)
	every key in {"first_on_site_notice", "first_on_site_control", "administrative_result"} { before_receipt(farm_payment.withdrawal_date, farm_payment[key]) }
}

else := "verspätet" if {
	valid_date(farm_payment.withdrawal_date)
	some key in {"first_on_site_notice", "first_on_site_control", "administrative_result"}
	valid_date(farm_payment[key])
	farm_payment[key] < farm_payment.withdrawal_date
}

else := "Reihenfolge am selben Tag prüfen" if {
	valid_date(farm_payment.withdrawal_date)
	some key in {"first_on_site_notice", "first_on_site_control", "administrative_result"}
	farm_payment[key] == farm_payment.withdrawal_date
}

capped_sum_per_ha(p, group) := min([cap.eur_ha, total]) if {
	cap := cap_per_ha(group, year)
	is_array(p.combined_payments)
	every part in p.combined_payments { is_string(part.measure); is_number(part.eur_ha_after_modulation); part.eur_ha_after_modulation >= 0}
	total := sum([part.eur_ha_after_modulation | some part in p.combined_payments; not part.measure in cap.exclude])
}

parcel_combination(partner, component) := "nicht kombinierbar" if {
	cell := combination_cell(partner)
	cell.mark == ""
	partner != "12"
	is_string(component)
} else := "nur Landschaftselemente" if {
	cell := combination_cell(partner)
	cell.footnote == 1
	component != "Landschaftselemente"
}

else := "kombinierbar mit 50 % Zuschlagsabschlag" if {
	cell := combination_cell(partner)
	cell.footnote == 3
	component == "Organismen/Pheromone"
}

else := "kombinierbar" if {
	cell := combination_cell(partner)
	cell.mark == "x"
	is_string(component)
}

# Tabellenbezug auch für die Einordnung anderer Maßnahmen des Betriebs.
programme_context(measure_name) := {
	"one_year": measure_name in catalog.annual_measures,
	"multi_year_list": measure_name in catalog.multiannual_measures,
	"annually_variable_area": measure_name in catalog.variable_area_measures,
	"restricted_additions": measure_name in catalog.restricted_additions,
	"exceptional_takeover_list": measure_name in catalog.special_takeovers,
}

minimum_cultivation_exceptions := catalog.minimum_cultivation_exceptions
public_body_exception_list := catalog.public_body_exceptions

combination_note(number) := r.text if {
	some r in catalog.matrix_notes
	r.number == number
}

erosion_rate(group, slope, y) := row if {
	y >= 2023
	y <= 2028
	is_number(slope)
	slope >= 0
	some row in catalog.erosion_rates
	row.crop == group
	row.component == "Grundprämie"
	row.slope_from <= slope
	below_limit(slope, row.slope_below)
}

below_limit(slope, bound) if {
	is_number(slope)
	bound == null
}

below_limit(slope, bound) if {
	is_number(bound)
	slope < bound
}

gve_factor(category, group) := r.factor if {
	some r in catalog.gve_factors
	r.category == category
	r.group == group
}

# Rückzahlungsfreier Ausstieg und Verbleib haben unterschiedliche Meldewege.
exit_request_requirements := {
	"portal": "www.eama.at",
	"navigation": ["Eingaben", "Andere Eingaben"],
	"form": "Ansuchen auf Anerkennung von höherer Gewalt oder besonderer flächen- und bewirtschaftungsverändernder Umstände",
	"reason": "Bekämpfungsmaßnahme gegen die Amerikanische Rebzikade",
	"chamber_assistance_optional": true,
} if {
	exit_available
}

document_findings contains {"parcel": p.parcel_id, "event": i, "requirement": requirement} if {
	some p in input.land.parcels
	covered(p)
	some i, e in p.operations.psm_events
	bound_on(e.date)
	e.status == "applied"
	e.order.applies == true
	"Insektizid" in e.effect_types
	some requirement in missing_order_records(p, e)
}

missing_order_records(p, e) := {label | some key, label in order_requirements(p, e); object.get(e.order, key, null) == false}
order_requirements(p, e) := {"documented": "Anordnung und Einsatz am Betrieb dokumentieren", "uploaded": "Anordnung via eAMA hochladen"} if {
	submission(e, p) == "eAMA Eingaben / andere Eingaben"
} else := {"documented": "Anordnung und Einsatz am Betrieb dokumentieren"}

parcel_actions(p) := {action | some action in {"Walnüsse mit OP beantragen", "Unveredelte Obstbäume mit OP beantragen", "VF im MFA setzen und Versuch dokumentieren", "OP oder maßnahmenbezogenen OP-Code setzen"}; action_required(p, action)}

action_required(p, "Walnüsse mit OP beantragen") if {
	p.ungrafted_tree
	crop_group(p) == "orchard"
	fruit_name(p.crop) == "Walnuss"
}

action_required(p, "Unveredelte Obstbäume mit OP beantragen") if {
	p.ungrafted_tree
	crop_group(p) == "orchard"
	fruit_name(p.crop) != "Walnuss"
}

action_required(p, "VF im MFA setzen und Versuch dokumentieren") if p.payment.trial_noncompliance
action_required(p, "OP oder maßnahmenbezogenen OP-Code setzen") if p.payment.public_overlap
action_required(p, "OP oder maßnahmenbezogenen OP-Code setzen") if p.payment.term_possible == false
action_required(p, "OP oder maßnahmenbezogenen OP-Code setzen") if p.payment.full_year == false

# Prüfwert für die reguläre Neuverpflichtung. Ein Vertrag bedarf der AMA-Genehmigung.
regular_entry_checks_pass := false if {
	year == contract.start_year
	some k in {"applicant", "farm_first_year_size", "measure_first_year_size", "bio_combination", "regular_application_timely"}
	entry_checks[k] == false
} else if {
	year == contract.start_year
	every k in {"applicant", "farm_first_year_size", "measure_first_year_size", "bio_combination", "regular_application_timely"} { entry_checks[k] == true }
}

combination_partner(code) := axis if {
	some axis in catalog.matrix_axes
	axis.code == code
}
