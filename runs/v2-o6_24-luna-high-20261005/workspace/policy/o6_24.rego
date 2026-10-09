package oepul.o6_24

import rego.v1

eligible_parcel(p) if {
	p.land_use == "arable"
	p.constraints.is_wrrl_area == true
	p.constraints.wrrl_higher_n_authorization != true
}

eligible_area_ha := total if {
	areas := [p.area_ha | some p in input.land.parcels; eligible_parcel(p)]
	total := sum(areas)
}

default eligible_area_ha := 0

default minimum_participation_met := false

minimum_participation_met if {
	eligible_area_ha >= 2
}

default fertilizer_limits_met := false

fertilizer_limits_met if {
	violations := [p | some p in input.land.parcels; eligible_parcel(p); p.operations.fertilizer.annual_effective_n_kg_per_ha > p.operations.fertilizer.wrrl_annual_limit_kg_per_ha]
	count(violations) == 0
}

default application_periods_met := false

application_periods_met if {
	violations := [p | some p in input.land.parcels; eligible_parcel(p); p.operations.fertilizer.application_period_compliant != true]
	count(violations) == 0
}

default farm_book_complete := false

farm_book_complete if {
	input.documentation.wrrl_farm_book_complete == true
}

default all_measure_conditions_met := false

all_measure_conditions_met if {
	minimum_participation_met
	fertilizer_limits_met
	application_periods_met
	farm_book_complete
}

premium_eur_per_ha := 50 if {
	input.farm.year == 2023
}

premium_eur_per_ha := 54 if {
	input.farm.year >= 2024
}

premium_eur_per_ha := null if {
	input.farm.year < 2023
}

district_in_exception_area if {
	state := input.farm.region.federal_state
	allowed := data.drought_2026_exception_districts[state]
	"all" in allowed
}

district_in_exception_area if {
	state := input.farm.region.federal_state
	district := input.farm.region.district
	allowed := data.drought_2026_exception_districts[state]
	district in allowed
}

default drought_exception_applies := false

drought_exception_applies if {
	input.farm.year == 2026
	input.documentation.drought_no_harvestable_stand == true
	district_in_exception_area
}

decision := {
	"measure": "o6_24",
	"eligible_area_ha": eligible_area_ha,
	"minimum_participation_met": minimum_participation_met,
	"fertilizer_limits_met": fertilizer_limits_met,
	"application_periods_met": application_periods_met,
	"farm_book_complete": farm_book_complete,
	"all_measure_conditions_met": all_measure_conditions_met,
	"premium_eur_per_ha": premium_eur_per_ha,
	"drought_exception_applies": drought_exception_applies,
}

allowed_combination contains code if {
	some code in data.allowed_measure_combinations
}
