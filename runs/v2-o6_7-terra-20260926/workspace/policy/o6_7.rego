package oepul.o6_7

import rego.v1

# Input extensions are intentionally kept below input.o6_7.  They are proposed in
# rules/profile_changes.json because the canonical farm profile has no crop-history
# or event-log model.
minimum_arable_area_ha := 1.5
minimum_green_cover_percent := 85

eligible if {
	input.land.arable_area_ha >= minimum_arable_area_ha
}

violations contains v if {
	input.land.arable_area_ha < minimum_arable_area_ha
	v := {"rule_id": "O67.eligibility.minimum-arable-area", "message": "At least 1.50 ha arable land is required in every participation year."}
}

violations contains v if {
	input.o6_7.minimum_green_cover_percent < minimum_green_cover_percent
	v := {"rule_id": "O67.coverage.annual-85-percent", "message": "Green cover must reach 85 percent of arable area at every point in the year."}
}

violations contains v if {
	gap := input.o6_7.gaps[_]
	gap.kind == "harvest_to_intercrop"
	gap.days > 30
	not drought_gap_exception(gap)
	v := {"rule_id": "O67.coverage.gap-harvest-to-intercrop", "message": "The interval from main-crop harvest to intercrop establishment exceeds 30 days."}
}

violations contains v if {
	gap := input.o6_7.gaps[_]
	gap.kind == "intercrop_termination_to_main_crop"
	gap.days > 30
	not drought_gap_exception(gap)
	v := {"rule_id": "O67.coverage.gap-intercrop-to-main-crop", "message": "The interval from intercrop termination to main-crop establishment exceeds 30 days."}
}

violations contains v if {
	gap := input.o6_7.gaps[_]
	gap.kind == "harvest_to_main_crop"
	gap.days > 50
	not drought_gap_exception(gap)
	v := {"rule_id": "O67.coverage.gap-harvest-to-main-crop", "message": "The interval from main-crop harvest to main-crop establishment exceeds 50 days."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.established_on > sprintf("%d-10-15", [input.farm.year])
	v := {"rule_id": "O67.intercrop.latest-establishment", "message": "An intercrop must be actively established by 15 October."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.duration_days < 42
	v := {"rule_id": "O67.intercrop.minimum-duration", "message": "An intercrop must remain for at least 42 days."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.established_on <= sprintf("%d-09-20", [input.farm.year])
	intercrop.mixture_partner_count < 3
	v := {"rule_id": "O67.intercrop.mixture-before-20-september", "message": "Intercrops established by 20 September need at least three mixture partners from two plant families."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.established_on <= sprintf("%d-09-20", [input.farm.year])
	intercrop.plant_family_count < 2
	v := {"rule_id": "O67.intercrop.mixture-before-20-september", "message": "Intercrops established by 20 September need at least three mixture partners from two plant families."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.established_on > sprintf("%d-09-20", [input.farm.year])
	not intercrop.predominantly_winter_hardy
	v := {"rule_id": "O67.intercrop.after-20-september", "message": "An intercrop established after 20 September must be predominantly winter hardy."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.established_on > sprintf("%d-09-20", [input.farm.year])
	intercrop.terminated_on < sprintf("%d-02-15", [input.farm.year + 1])
	v := {"rule_id": "O67.intercrop.after-20-september", "message": "An intercrop established after 20 September may not be terminated before 15 February of the following year."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	event := intercrop.fertilizer_events[_]
	event.kind == "mineral_nitrogen"
	event.date >= intercrop.established_on
	event.date <= intercrop.napv_prohibition_end
	v := {"rule_id": "O67.intercrop.mineral-n-ban", "message": "Mineral nitrogen is prohibited from intercrop establishment through the following NAPV closed period."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	event := intercrop.plant_protection_events[_]
	event.date >= intercrop.established_on
	event.date <= intercrop.terminated_on
	v := {"rule_id": "O67.intercrop.plant-protection-ban", "message": "Plant-protection products are prohibited from intercrop establishment until termination."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.removal_method == "chemical"
	v := {"rule_id": "O67.intercrop.mechanical-removal", "message": "Intercrops must be removed mechanically, not chemically."}
}

violations contains v if {
	intercrop := input.o6_7.intercrops[_]
	intercrop.used_for == "threshing"
	v := {"rule_id": "O67.intercrop.use-no-threshing", "message": "An intercrop may not be threshed."}
}

violations contains v if {
	not input.o6_7.field_records.complete
	v := {"rule_id": "O67.records.parcel-events", "message": "Continuous parcel-specific records are required for all arable land from 1 January through 31 December."}
}

violations contains v if {
	input.o6_7.selected_measures[_] == data.o6_7_operations.o6_7_incompatible_measure
	v := {"rule_id": "O67.combination.no-simultaneous-intercrop-scheme", "message": "System Immergrün and the Zwischenfruchtanbau scheme cannot be joined simultaneously."}
}

premium_eur_per_ha := {"minimum": 70, "maximum": 90}

drought_gap_exception(gap) if {
	input.farm.year == 2026
	gap.drought_2026_exception
	gap.prospective_management_credible
	gap.established_at_earliest_possible_date
}
