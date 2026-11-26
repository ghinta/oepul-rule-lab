package oepul.o6_1b_test

import data.oepul.o6_1b as bio
import rego.v1

test_bildung_getrennte_themen_und_stichtag if {
	c := {"date": "2025-12-31", "hours": 3, "topic": "Biodiversität", "event_id": "A", "participant_eligible": true, "provider_recognised": true, "allocated_to_this_farm": true, "person_retained_at_deadline": true}
	d := object.union(c, {"date": "2022-01-01", "topic": "Biologische Wirtschaftsweise", "hours": 5, "event_id": "B"})
	bio.training_met with input.documentation.bio_training as [c, d]
	not bio.training_met with input.documentation.bio_training as [c, object.union(d, {"event_id": "A"})]
	not bio.training_met with input.documentation.bio_training as [c, object.union(d, {"date": "2026-01-01"})]
	bio.training_deficit["Biodiversität"] == 3 with input.documentation.bio_training as [d]
}

test_teilbetriebsgrenze if {
	bio.farm_combination_blocked("12", "wine_fruit_hops", "whole")
	not bio.farm_combination_blocked("12", "wine_fruit_hops", "arable_grassland")
	bio.farm_combination_blocked("1C:NPF", "arable_grassland", "arable_grassland") with input.farm.year as 2026
}

test_brache_reinigung_zaehlt_ab_2025 if {
	clean := {"date": "2026-06-01", "kind": "Reinigungsschnitt", "removed": false}
	b := {"codes": ["DIV", "DIVRS"], "use": "Grünbrache", "first_claim_new_sowing": true, "uses": [clean], "previous_year_counted_uses": 0}
	bio.arable_fallow_rs_management_met({"land_use": "arable", "oepul": b}) with input.farm.year as 2026
	not bio.arable_fallow_rs_management_met({"land_use": "arable", "oepul": object.union(b, {"uses": [clean, {"kind": "Häckseln", "date": "2026-10-01"}]})}) with input.farm.year as 2026
	not bio.arable_fallow_rs_management_met({"land_use": "arable", "oepul": object.union(b, {"first_claim_new_sowing": false})}) with input.farm.year as 2026
}

test_projektcode_auf_der_flaeche if {
	p := {"land_use": "arable", "oepul": {"codes": ["NAT", "DIV"], "project_codes": ["SA01"], "use": "Grünbrache"}}
	bio.project_div_credit(p)
	not bio.project_div_credit(object.union(p, {"oepul": object.union(p.oepul, {"project_codes": ["SB04"]})}))
	bio.nat_fallow_care("SB10").eur_ha == 151.2
	bio.nat_phenology("GL25").tage == 42
	bio.n2_project_rate("N2GL36", 2025) == 410.4
}

test_kg_und_gis if {
	p := {"oepul": {"kg_nummer": 31001, "baw_gis_confirmed": true}}
	bio.listed_baw_site(p)
	not bio.listed_baw_site({"oepul": {"kg_nummer": 31001, "baw_gis_confirmed": false}})
	bio.listed_ag_site({"oepul": {"kg_nummer": 32001, "annual_groundwater_zone_confirmed": true, "soil_rating": 40}})
	not bio.listed_ag_site({"oepul": {"kg_nummer": 32001, "annual_groundwater_zone_confirmed": true, "soil_rating": 41}})
}

test_sorten_mit_offener_herkunft if {
	bio.slk_all_origins("Waldstaudenroggen", 2026) == "A"
	bio.slk_all_origins("Stoppelrübe", 2026) == "B"
	not bio.slk_all_origins("Mais", 2026)
	bio.fruit("Brombeere", 2023)
	not bio.fruit("Felsenbirne", 2024)
}

test_untersaat_jahr_und_kultur if {
	p := {"crop": {"crop_name": "Mais"}, "oepul": {"erosion_procedure": "Untersaat", "measure8": true, "crop_sowing_date": "2025-05-05", "undersowing_date": "2025-06-30", "undersowing_species_count": 3}}
	bio.erosion_full(p) with input.farm.year as 2025
	not bio.erosion_full(p) with input.farm.year as 2024
	not bio.erosion_full(object.union(p, {"oepul": object.union(p.oepul, {"erosion_procedure": "Anhäufungen bei Kartoffeln"})}))
	bio.undersowing_timing_met(p) with input.farm.year as 2025
	not bio.undersowing_timing_met(object.union(p, {"oepul": object.union(p.oepul, {"undersowing_date": "2025-07-01"})})) with input.farm.year as 2025
}

test_pzr_fuenf_wochen_und_zwei_leerungen if {
	t := {"number": 15, "empty_dates": ["2025-05-15", "2025-06-05"], "annual_lures_installed": true, "catch_containers": true, "installed": "2025-05-01", "sowing_or_comparable_date": "2025-04-17", "removed": "2025-06-05", "harvest": "2025-09-20"}
	o := {"traps": t, "codes": ["PZR"], "sugar_beet_current_or_previous_harvest": true}
	bio.trap_operation_met({"area_ha": 1, "oepul": o}) with input.farm.year as 2025
	not bio.trap_operation_met({"area_ha": 1.01, "oepul": o}) with input.farm.year as 2025
	not bio.trap_operation_met({"area_ha": 1, "oepul": object.union(o, {"traps": object.union(t, {"empty_dates": ["2025-05-15", "2025-06-06"]})})}) with input.farm.year as 2025
}

test_ernte_je_schlag if {
	o := {"crop_properly_established": true, "annual_care_complete": true, "use": "Mais", "specific_minimum_management_exemption": false, "harvested_and_removed_ha": 0.85}
	bio.arable_harvest_standard_met({"area_ha": 1, "land_use": "arable", "oepul": o})
	not bio.arable_harvest_standard_met({"area_ha": 1.01, "land_use": "arable", "oepul": o})
}

test_saatgewicht_gleicher_art_aggregiert if {
	rows := array.slice(data.bio_tables.arten_acker, 0, 40)
	base := [{"species": r.deutsch, "regional_origin_verified": true, "weight_percent": 2.5, "certified_ecotype": false} | some r in array.slice(rows, 0, 38)]
	extra := {"species": rows[0].wissenschaftlich, "regional_origin_verified": true, "weight_percent": 5, "certified_ecotype": false}
	m := {"kg_per_ha": 20, "labels_and_invoices": true, "components": array.concat(base, [extra])}
	not bio.regional_mix_met("arable", m)
	bio.regional_mix_met("arable", object.union(m, {"components": array.concat(base, [object.union(extra, {"certified_ecotype": true})])}))
}

test_regelmaessige_kennarten_je_abschnitt if {
	p := {"land_use": "grassland", "oepul": {"use": "Mähwiese/-weide zwei Nutzungen", "species_survey": [
		{"strip": 1, "date": "2026-05-01", "documented": true, "indicator_groups": ["Primula elatior", "Primula veris", "Wiesen-Salbei"]},
		{"strip": 1, "date": "2026-06-01", "documented": true, "indicator_groups": ["Philippendula", "Echtes Labkraut", "Sichel-Luzerne", "Zaun-Wicke"]},
	]}}
	bio.indicator_density_met(p) with input.farm.year as 2026
	not bio.indicator_density_met(p) with input.farm.year as 2025
	bio.kennarten_count(["Primula elatior", "Primula veris"]) == 1
}

test_acker_pflege_alte_und_neue_fassung if {
	p := {"land_use": "arable", "oepul": {"codes": ["DIV"], "uses": [{"kind": "Weide"}], "previous_year_counted_uses": 0}}
	bio.arable_frequency_met(p) with input.farm.year as 2025
	not bio.arable_frequency_met(p) with input.farm.year as 2024
	not bio.arable_frequency_met({"land_use": "arable", "oepul": object.union(p.oepul, {"uses": [{"kind": "Drusch"}]})}) with input.farm.year as 2026
}

test_gemuese_und_ausschlussstufe if {
	bio.vegetable_or_strawberry("Tomaten")
	bio.vegetable_or_strawberry("Paradeiser")
	some s in bio.sanction_options(2026)
	s.stufe == "Ausschluss und Rückforderung"
}

test_bonitaet_begrenzt_und_schlagstatus if {
	p := {"land_use": "arable", "area_ha": 3, "oepul": {"soil_rating": 50, "qualifies_for_bio_div_premium": true}}
	bio.soil_bonus_area("arable", 10) == 2 with input.land.parcels as [p] with input.farm.year as 2026
	not bio.soil_bonus_rate(object.union(p, {"oepul": {"soil_rating": 80, "qualifies_for_bio_div_premium": false}})) with input.farm.year as 2026
	bio.lse_field_maximum(0.19) == 15
}

test_monitoring_letzter_einstieg if {
	bio.monitoring_entry_timely("2027-12-31", 2028)
	not bio.monitoring_entry_timely("2028-01-01", 2028)
	not bio.monitoring_entry_timely("2028-12-31", 2029)
}
