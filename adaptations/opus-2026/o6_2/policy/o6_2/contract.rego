# Vertragszeitraum, Ausstieg, Maßnahmenwechsel, Flächenab- und -zugänge,
# Maßnahmenübernahme (Allg. Teilnahmebedingungen 5.8-7.2, SRL 1.7).
package oepul.o6_2

contract_period := cp if {
	some cp in general.contract_periods
	cp.start_year == contract_start_year
}

contract_end_date := "2028-12-31"

exit_info := object.get(o6_2_state, "exit", {})

exit_date := object.get(exit_info, "exit_date", null)

exit_reason := object.get(exit_info, "reason", "none")

switched_to_bio_date := object.get(o6_2_state, "switched_to_bio_date", null)

# Umstieg in "Biologische Wirtschaftsweise" bis 31.12.2025 ohne Rückzahlung.
switch_to_bio_without_repayment if {
	switched_to_bio_date != null
	switched_to_bio_date <= combos.measure_switch_deadline
}

repayment_free_exit_reasons := {"loss_of_control", "revision_clause_refusal", "permanent_circumstances"}

exit_before_contract_end if {
	exit_date != null
	exit_date < contract_end_date
}

# Ausstieg vor Ende des Vertragszeitraums: Rückforderung aller bisher gewährten Prämien.
repayment_of_all_premiums_required if {
	exit_before_contract_end
	not exit_reason in repayment_free_exit_reasons
	not switch_to_bio_without_repayment
}

repayment_of_all_premiums_required if excluded_from_measure

# Zahlungsantrag nicht innerhalb 1 Jahr nachgereicht: Verpflichtung endet, Rückzahlung.
repayment_of_all_premiums_required if {
	object.get(o6_2_state, "payment_application_missing_over_one_year", false) == true
}

# Betriebsübertragung: Nachfolger tritt dem Vertrag bei, Flächen weiterführen.
farm_transfer_continues_contract if exit_reason == "farm_transfer"

# Flächenabgang: Toleranz max(0,5 ha; min(5 % Vorjahresfläche; 5 ha)).
previous_year_area_ha := object.get(o6_2_state, "previous_year_committed_area_ha", 0)

area_reduction_ha := object.get(o6_2_state, "area_reduction_ha", 0)

area_decrease_tolerance_ha := max([
	general.area_decrease_tolerance.always_allowed_ha_per_year,
	min([
		(previous_year_area_ha * general.area_decrease_tolerance.max_percent_of_previous_year) / 100,
		general.area_decrease_tolerance.max_ha_per_year,
	]),
])

area_decrease_repayment_ha := area_reduction_ha if {
	area_reduction_ha > area_decrease_tolerance_ha
} else := 0

conversion_allowed(from_code, to_code) if {
	some c in general.allowed_land_use_conversions
	from_code in c.from
	to_code in c.to
}

conversion_allowed(_, to_code) if {
	some c in general.allowed_land_use_conversions
	"*" in c.from
	to_code in c.to
}

# Maßnahmenübernahme durch einen bisher nicht teilnehmenden Betrieb.
takeover := object.get(o6_2_state, "takeover", null)

takeover_deadline(y) := sprintf("%d-%s", [y, general.takeover.deadline_month_day_2023_2028]) if {
	y in {2023, 2028}
} else := sprintf("%d-%s", [y, general.takeover.deadline_month_day])

takeover_valid if {
	takeover != null
	takeover.takeover_date <= takeover_deadline(year)
	object.get(takeover, "taker_previously_participating", false) == false
	object.get(takeover, "extension_percent", 0) <= general.takeover.max_extension_percent
}

# Unterjährige Flächenweitergabe ohne Weiterführung: Code OP erforderlich.
parcels_requiring_op_code contains p.parcel_id if {
	some p in parcels
	object.get(p, "transferred_during_year_without_continuation", false) == true
	not "OP" in oepul_codes_of(p)
}

# Verweigerung/Verhinderung der Vor-Ort-Kontrolle: Antrag abzulehnen.
control_refused if object.get(oepul, "on_site_control_refused", false) == true

sanction_percent_for(level_id, y) := lvl.reduction_percent_from_2027 if {
	y >= 2027
	some lvl in general.sanction_levels
	lvl.id == level_id
} else := lvl.reduction_percent if {
	some lvl in general.sanction_levels
	lvl.id == level_id
}
