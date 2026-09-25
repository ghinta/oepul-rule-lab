# General ÖPUL conditions applicable to o6_9 (applicant, farm size,
# minimum management, 2026 drought relief, sanctions).
package oepul.o6_9

applicant := object.get(input, ["farm", "applicant"], {})

# Eligible applicants: natural persons, registered partnerships, legal persons
# and associations of persons (public-body share max. 25 %); active farmer.
default applicant_eligible := false

applicant_eligible if {
	some lf in general.applicant_legal_forms
	lf.legal_form == applicant.legal_form
	public_body_share_ok(lf)
	applicant.is_active_farmer == true
}

public_body_share_ok(lf) if lf.public_body_share_limit_applies == false

public_body_share_ok(lf) if {
	lf.public_body_share_limit_applies == true
	number_or_zero(object.get(applicant, "public_body_share_percent", 0)) <= params.applicant.max_public_body_share_percent
}

# Minimum farm size applies only in the first year of ÖPUL participation.
default first_year_min_size_met := false

first_year_min_size_met if input.farm.oepul_first_participation_year != year

first_year_min_size_met if {
	input.farm.oepul_first_participation_year == year
	number_or_zero(object.get(input, ["land", "protected_cultivation_area_ha"], 0)) >= params.first_year_min_farm_size.protected_cultivation_min_ha
}

first_year_min_size_met if {
	input.farm.oepul_first_participation_year == year
	total_area_ha >= params.first_year_min_farm_size.agricultural_area_min_ha
}

# 2026 drought: no harvest needed in listed districts if no harvestable crop.
parcel_district(p) := p.district if is_string(p.district)

else := input.farm.region.district

drought_district_listed(state, district) if {
	some row in data.o6_9.drought_2026.harvest_exemption_districts
	row.federal_state == state
	row.district in {"*", district}
}

drought_harvest_exempt(p) if {
	year == data.o6_9.drought_2026.year
	drought_district_listed(input.farm.region.federal_state, parcel_district(p))
	object.get(p, ["operations", "no_harvestable_crop_due_to_drought"], false) == true
}

# Minimum management on arable land: harvest on at least 85 % of the parcel.
harvest_obligation_met(p) if object.get(p, ["operations", "harvested_share_percent"], 100) >= data.o6_9.drought_2026.harvest_obligation_min_share_percent

harvest_obligation_met(p) if drought_harvest_exempt(p)

# Area payment cap per parcel (sum of area-related ÖPUL payments).
area_payment_cap_eur_per_ha(y) := row.eur_per_ha if {
	some row in general.area_payment_caps
	row.scope == "general"
	row.valid_from <= y
	cap_row_valid_to(row, y)
}

cap_row_valid_to(row, _) if row.valid_to == null

cap_row_valid_to(row, y) if {
	row.valid_to != null
	y <= row.valid_to
}

# Sanction stages for breaches of content obligations; from 2027 the
# warning is replaced by a 1 % retention.
sanction_reduction_share(stage, y) := row.reduction_share if {
	y < 2027
	some row in general.sanction_stages
	row.stage == stage
}

sanction_reduction_share(stage, y) := row.reduction_share_from_2027 if {
	y >= 2027
	some row in general.sanction_stages
	row.stage == stage
}
