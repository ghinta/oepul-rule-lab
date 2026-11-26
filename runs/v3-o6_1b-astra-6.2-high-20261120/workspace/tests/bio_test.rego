package oepul.o6_1b_test

import data.oepul.o6_1b as bio
import rego.v1

test_einstiegsstaffel if {
	bio.contract_years == 4 with input.farm.oepul.first_bio_year as 2025
	not bio.contract_years with input.farm.oepul.first_bio_year as 2026
}

test_praemiensaetze_nach_jahr if {
	bio.rate("acker_basis", 2023) == 205
	bio.rate("acker_basis", 2024) == 221.4
	bio.rate("acker_basis", 2026) == 235
	not bio.rate("transaktion", 2024)
	bio.rate("transaktion", 2026) == 400
	not bio.rate("acker_basis", 2029)
}

test_feldstuecksschwellen if {
	bio.required_field_div(9.99, 6) == 0
	bio.required_field_div(10, 5) == 0
	bio.required_field_div(10, 5.01) == 0.15
	bio.required_div(2) == 0
	bio.required_div(2.01) == 0.1407
}

test_ersatz_nur_ueberschuss if {
	f := {"arable_area_ha": 9, "oepul": {"mown_grassland_without_mountain_meadows_ha": 5, "arable_div_ha": 0.25, "grass_div_ha": 0.80, "additional_qualifying_grass_div_ha": 0.8}}
	bio.arable_div_met with input.land as f
	not bio.arable_div_met with input.land as f with input.land.oepul.grass_div_ha as 0.70
}

test_zehn_ha_streitfall if {
	not bio.grass_credit_ha with input.land as {"arable_area_ha": 10, "oepul": {"additional_qualifying_grass_div_ha": 1, "grass_div_ha": 1, "mown_grassland_without_mountain_meadows_ha": 1}}
}

test_feld_lse_nur_lokal if {
	sample := {"arable_area_ha": 30, "oepul": {"fields": [{"id": "A", "use": "arable", "basis_ha": 6, "div_ha": 0.10, "gloez_lse_ha": 0.02, "assigned_1c_strip_ha": 0.03}]}}
	bio.field_shortfall.A == 0 with input.land as sample with input.farm.year as 2025
	bio.field_shortfall.A == 0.03 with input.land as sample with input.farm.year as 2024
	bio.arable_div_required_ha == 2.1 with input.land as sample
}

test_div_zuschlag_und_dichte if {
	bio.div_bonus_area(100, 7) == 0
	bio.div_bonus_area(100, 8) == 1
	bio.div_bonus_area(100, 29) == 13
	not bio.density_bonus(6.01, [0.05, 0.10, 0.10])
	bio.density_bonus(6.01, [0.051, 0.10, 0.10])
}

test_anteile_einschliesslich_grenze if {
	bio.excess_cereal_maize_ha == 0 with input.land as {"arable_area_ha": 8, "oepul": {"cereal_and_maize_ha": 6}}
	bio.crop_exempt("Spargel", 2025)
	not bio.crop_exempt("Spargel", 2024)
	not bio.excess_cereal_maize_ha with input.land as {"arable_area_ha": 5, "oepul": {"cereal_and_maize_ha": 5}}
}

test_einzelkulturanteil_aus_hauptkulturen if {
	kulturen := [
		{"botanical_species": "Zea mays", "use": "Mais", "area_ha": 6},
		{"botanical_species": "Solanum tuberosum", "use": "Kartoffeln", "area_ha": 4},
	]
	flaechen := {"arable_area_ha": 10, "oepul": {"main_crops": kulturen}}
	bio.single_crop_excess == {"Zea mays": 0.5} with input.land as flaechen with input.farm.year as 2026
}

test_eigenbedarf_tiergrenzen_und_futtertrennung if {
	tiere := {"household_pigs": 2, "household_hens": 10, "other_nonorganic_household_animals": 0, "separate_household_feed": true}
	bio.household_exception_met with input.livestock.oepul as tiere
	not bio.household_exception_met with input.livestock.oepul as object.union(tiere, {"household_hens": 11})
	not bio.household_exception_met with input.livestock.oepul as object.union(tiere, {"household_pigs": 3})
	not bio.household_exception_met with input.livestock.oepul as object.union(tiere, {"separate_household_feed": false})
}

test_viehbesatz_grenzen if {
	base := {"land": {"grassland_area_ha": 8, "oepul": {"arable_forage_ha": 2}}, "livestock": {"species_groups": [{"category": "Rinder ab 2 Jahre", "annual_assessable_count": 3, "qualifies_for_bio_rgve": true}, {"qualifies_for_bio_rgve": false}]}, "farm": {"year": 2026}}
	bio.stock_class == "mittel" with input as base
	bio.grass_base_rate == 232.2 with input as base
	bio.stock_class == "hoch" with input as base with input.livestock.species_groups as [{"category": "Rinder ab 2 Jahre", "annual_assessable_count": 14, "qualifies_for_bio_rgve": true}]
	not bio.stock_class with input as base with input.livestock.species_groups as [{"qualifies_for_bio_rgve": true, "category": "unbekannt", "annual_assessable_count": 1}]
	bio.rgve_factor("Rinder unter ½ Jahr") == 0.4
}

test_kulturdeckel_und_rang if {
	plots := [{"land_use": "arable", "area_ha": 5, "eligible_crop_positions": ["leguminosen", "feldfutter"]}, {"land_use": "arable", "area_ha": 10, "eligible_crop_positions": ["sonnenblume"]}, {"land_use": "arable", "area_ha": 10, "eligible_crop_positions": ["feldfutter"]}]
	bio.crop_bonus_eur == 1836 with input.farm.year as 2026 with input.land as {"arable_area_ha": 50, "oepul": {"arable_div_ha": 0}, "parcels": plots}
}

test_sorten_und_saatgut if {
	not bio.slk_tier("Soblus", 2024)
	bio.slk_amount("Soblus", 12, 2025) == 1296
	bio.slk_tier("Tarko", 2026) == "B"
	bio.seed_taxon("grassland", "Plantago lanceolata").deutsch == "Spitz-Wegerich"
	not bio.seed_taxon("arable", "Spitz-Wegerich")
	rows := array.slice(data.bio_tables.arten_acker, 0, 40)
	mix := {"kg_per_ha": 20, "labels_and_invoices": true, "components": [{"species": r.deutsch, "regional_origin_verified": true, "weight_percent": 2.5, "certified_ecotype": false} | some r in rows]}
	bio.regional_mix_met("arable", mix)
	not bio.regional_mix_met("arable", object.union(mix, {"kg_per_ha": 19.99}))
}

test_regionale_standortgrenze if {
	bio.regional_grass_site({"slope_percent": 17.99, "oepul": {"soil_rating": 30}})
	not bio.regional_grass_site({"slope_percent": 18, "oepul": {"soil_rating": 30}})
}

test_nfzkalendarisch if {
	p := {"oepul": {"codes": ["DIVNFZ"], "first_use_completed": "2026-06-24", "second_use": "2026-08-27"}}
	bio.nfz_second_use_met(p) with input.farm.year as 2026
	not bio.nfz_second_use_met({"oepul": object.union(p.oepul, {"second_use": "2026-08-26"})}) with input.farm.year as 2026
	early := object.union(p.oepul, {"codes": ["DIVNFZ", "OPBIO"], "other_use_restrictions": false, "second_use": "2026-08-13"})
	bio.nfz_second_use_met({"oepul": early}) with input.farm.year as 2026
	not bio.nfz_second_use_met({"oepul": object.union(early, {"codes": ["DIVNFZ", "NAT", "OPBIO"]})}) with input.farm.year as 2026
}

test_trockenheit_dritte_nutzung if {
	p := {"land_use": "arable", "oepul": {"codes": ["DIV", "OPBIO"], "counted_uses": 3, "other_use_restrictions": false}}
	bio.arable_drought_third_use(p) with input.farm.year as 2026
	bio.parcel_premium_blocked(p)
	not bio.arable_drought_third_use(p) with input.farm.year as 2027
	not bio.arable_drought_third_use({"land_use": "arable", "oepul": object.union(p.oepul, {"codes": ["DIV", "OPBIO", "EBW"]})}) with input.farm.year as 2026
}

test_duerre_bezirke if {
	p := {"land_use": "arable", "oepul": {"federal_state": "Steiermark", "district": "Weiz", "heat_sensitive_late_crop": true, "drought_destroyed_harvest": true}}
	bio.harvest_waiver(p) with input.farm.year as 2026
	not bio.harvest_waiver(p) with input.farm.year as 2025
	not bio.drought_region("Steiermark", "Liezen")
	bio.drought_region("Wien", "Donaustadt")
	bio.drought_region("Niederösterreich", "Zwettl")
	not bio.drought_region("Oberösterreich", "Zwettl")
}

test_wechsel_grenzen if {
	bio.variant_change("DIVSZ", "DIVNFZ", "2026-06-15", 2026)
	not bio.variant_change("DIVSZ", "DIVNFZ", "2026-06-16", 2026)
	not bio.variant_change("DIVNFZ", "DIVSZ", "2026-04-16", 2026)
	bio.variant_change("DIVNFZ", "DIVAGF", "2026-08-15", 2026)
}

test_bienenstaffel if {
	bio.bee_premium_eur == 23740 with input.farm.year as 2026 with input.livestock.oepul as {"claimed_eligible_colonies": 901, "sector_programme_feed_or_wax": false}
	bio.bee_premium_eur == 0 with input.livestock.oepul.sector_programme_feed_or_wax as true
}

test_abgaenge if {
	bio.repay_area_ha == 0 with input.land.oepul as {"prior_committed_ha": 2, "chargeable_loss_ha": 0.50}
	bio.repay_area_ha == 5.01 with input.land.oepul as {"prior_committed_ha": 150, "chargeable_loss_ha": 5.01}
}

test_zugang_kumulativ if {
	bio.new_area_payable_ha == 1 with input.farm.year as 2027 with input.land.oepul as {"bio_2025_ha": 8, "additions_already_counted_ha": 4, "new_uncommitted_ha": 3}
}

test_modulation if {
	abs(bio.modulation(220) - (218 / 220)) < 0.00000001
	bio.modulation(200) == 1
	bio.modulation(1200) == (((200 + 90) + 595) + 150) / 1200
}

test_matrix if {
	bio.combination("1B", "4") == "x 1)"
	bio.combination("16", "1B") == "a"
	bio.combination("1B", "1C") == ""
	bio.combination("1B", "10") == "x 3)"
	bio.project_combination("S", "H") == "nein"
	bio.project_combination("S", "L") == "ja"
}

test_erosion if {
	p := {"area_ha": 0.51, "land_use": "arable", "crop": {"crop_name": "Mais"}, "oepul": {"predominant_slope_percent": 10, "measure8": true, "erosion_procedure": "Mulchsaat", "measure6_or_7": false}}
	bio.erosion_base_factor(p) == 0 with input.farm.year as 2024
	bio.erosion_base_factor(p) == 0.5 with input.farm.year as 2025
	bio.erosion_base_factor(object.union(p, {"oepul": object.union(p.oepul, {"measure6_or_7": true})})) == 1 with input.farm.year as 2026
	not bio.erosion_risk(object.union(p, {"area_ha": 0.5}))
}
