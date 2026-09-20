package oepul.o6_16_test

import data.oepul.o6_16
import rego.v1

test_eligible if {
	o6_16.eligible with input as {"farm": {"year": 2026}, "oepul": {"o6_16": {"enrolled": true, "cover_crop_measure": "system_immergruen", "first_year_area_in_eligible_zone_ha": 2}}}
}

test_nitrogen_transfer_60_percent if {
	o6_16.nitrogen_transfer_kg_per_ha(30, 2026, false) == 18
}

test_nitrogen_transfer_80_percent_and_cap if {
	o6_16.nitrogen_transfer_kg_per_ha(150, 2026, true) == 80
}

test_soil_samples_round_up if {
	o6_16.required_soil_samples(5.03) == 2
}

test_wien_soil_samples_round_up_and_double if {
	o6_16.required_wien_soil_samples(5.03) == 4
}

test_annex_g_kg_is_available_as_data if {
	o6_16.kg_in_eligible_zone(32001)
	not o6_16.kg_in_eligible_zone(99999)
}

test_bio_base_premium_is_halved if {
	o6_16.premium_base_for_participation_eur_per_ha(2026, true) == 27
	o6_16.premium_base_for_participation_eur_per_ha(2026, false) == 54
}

test_ag_premium_area_cap if {
	o6_16.ag_option_premium_area_ha(100, 25) == 20
}

test_banned_active_ingredient_detected if {
	violations := o6_16.violations with input as {"farm": {"year": 2026}, "oepul": {"o6_16": {"enrolled": true, "cover_crop_measure": "system_immergruen", "first_year_area_in_eligible_zone_ha": 2, "parcels": [{"parcel_id": "p1", "in_eligible_zone": true, "crop": "Mais", "active_ingredients": ["Terbuthylazin"]}]}}}
	some v in violations
	v.rule_id == "o6_16.psm.ban"
}
