package oepul.o6_23_test

import data.oepul.o6_23 as n
import rego.v1

terms := [{"code": "N2GI06"}, {"code": "N2GL03", "earliest_cut": "2026-08-29"}]
facts := {
	"mfa_codes": ["N2", "DIVSZ"], "grassland_type": "meadow", "zone": "article10_high_nature_value", "habitat": true,
	"authority_confirmation": true, "conditions": terms, "nat_conditions": [], "code_combinations_confirmed": true,
	"further_terms_met": true, "year_obligation_kept": true, "uses": 2, "fertilizer_applied": false,
	"ordinance_changed": false, "country": "AT", "correctly_identified": true, "disposal_right": true, "excluded_land": false,
	"trial_breach": false, "public_overlap": false, "infrastructure_offset": false, "n2_op": false, "full_cut_removed": true,
	"active_production": true, "other_area_measures": ["1A"],
}

parcel := {"parcel_id": "A", "area_ha": 2, "land_use": "grassland", "operations": {"cutting_dates": ["2026-08-29", "2026-09-21"]}, "natura": facts}
app := {
	"previous_contract": true, "reentry_required": false, "mfa_submitted": true, "withdrawal_date": null,
	"legal_form": "legal_entity", "public_share_pct": 25, "equivalent_public_control": false, "own_name_account": true, "agricultural_activity": true,
	"active_farmer": true, "first_oepul_year": true, "qualifying_at_ha": 1.5, "measures": ["1A", "23"],
}

profile := {"farm": {"year": 2026, "oepul": app}, "land": {"parcels": [parcel], "home_area_ha": 220}}
change_natura(v) := object.union(parcel, {"natura": object.union(facts, v)})

test_renewal_two_partial_premiums if {
	n.annual_gross_eur == {"A": 853.2} with input as profile
	n.div_credit_ha == {"A": 2} with input as profile
	n.minimum_status == "erfüllt" with input as profile
}

test_missing_data_open if {
	n.minimum_status == "offen" with input.land.parcels as [{}]
	n.minimum_status == "offen" with input as {}
	n.annual_gross_eur == {} with input as {}
	n.minimum_status == "verfehlt" with input.land.parcels as []
}

test_scope if {
	every changes in [{"zone": "other"}, {"habitat": false}, {"authority_confirmation": false}, {"grassland_type": "rough_pasture"}, {"grassland_type": "permanent_pasture"}] {
		not n.site_ok(change_natura(changes))
	}
	n.site_ok(change_natura({"grassland_type": "mown_pasture", "zone": "natura2000"}))
}

test_fertilizer_and_uses if {
	n.condition_ok(change_natura({"uses": 4}), {"code": "N2GI05"})
	not n.condition_ok(change_natura({"fertilizer_applied": true}), {"code": "N2GI06"})
	not n.condition_ok(change_natura({"uses": 3}), {"code": "N2GI06"})
	n.condition_ok(change_natura({"uses": 1}), {"code": "N2GI07"})
	not n.condition_ok(change_natura({"grassland_type": "mown_pasture"}), {"code": "N2GI06"})
}

test_rates if {
	expected := {"GI05": [325, 351], "GI06": [245, 264.6], "GI07": [170, 183.6], "GL02": [90, 97.2], "GL03": [150, 162], "GL04": [210, 226.8], "GL05": [250, 270], "GL36": [380, 410.4], "GL37": [500, 540]}
	every k, pair in expected {
		c := concat("", ["N2", k])
		n.rate(c, 2023) == pair[0]
		n.rate(c, 2024) == pair[1]
		n.rate(c, 2028) == pair[1]
	}
	not n.rate("N2GL01", 2026)
}

test_drought_state_law_required if {
	term := terms[1]
	early := object.union(parcel, {"operations": {"cutting_dates": ["2026-08-12"]}})
	not n.condition_ok(early, term) with input.farm.year as 2026
	changed := object.union(early, {"natura": object.union(facts, {"ordinance_changed": true, "ordinance_cut_date": "2026-08-12"})})
	n.condition_ok(changed, term) with input.farm.year as 2026
	not n.condition_ok(object.union(changed, {"operations": {"cutting_dates": ["2026-08-11"]}}), term) with input.farm.year as 2026
	n.cut_limit(changed.natura, {"earliest_cut": "2027-08-29"}) == "2027-08-29" with input.farm.year as 2027
	not n.cut_limit({"ordinance_changed": true}, term) with input.farm.year as 2026
}

test_combinations if {
	every m in ["1A", "1B", "1B-Teilbetrieb", "2", "18", "19"] { n.pairs_ok({"other_area_measures": [m]}) }
	every m in ["3", "14", "24", "K20"] { not n.pairs_ok({"other_area_measures": [m]}) }
	not n.pairs_ok({"other_area_measures": ["18", "19"]})
	not n.pairs_ok({"other_area_measures": ["18", "1A"]})
	n.pairs_ok({"other_area_measures": ["18", "1A"], "lse_only_measures": ["1A"]})
	n.chapter_conflicts({"nat_conditions": ["TA01", "AA01", "WA01", "HA01", "LA01", "GA01"]}) == {"TA01", "AA01", "WA01"}
}

test_credit_requires_both_codes_and_gl if {
	n.div_credit_ha == {} with input as profile with input.land.parcels as [change_natura({"conditions": [terms[0]]})]
	n.div_credit_ha == {} with input as profile with input.land.parcels as [change_natura({"mfa_codes": ["N2"]})]
	not n.div_required_ha with input as profile with input.land.mown_grassland_excl_mountain_ha as 2
	n.div_required_ha == 0.7 with input as profile with input.land.mown_grassland_excl_mountain_ha as 10
}

test_contract_entry if {
	n.timely_entry with input.farm as {"year": 2027, "oepul": {"entry_application_date": "2026-12-31", "mfa_submitted": true}}
	not n.timely_entry with input.farm as {"year": 2028, "oepul": {"entry_application_date": "2027-12-31", "mfa_submitted": true}}
	not n.timely_entry with input.farm as {"year": 2027, "oepul": {"entry_application_date": "2027-01-01", "mfa_submitted": true}}
	n.application_route == {"renewal"} with input as profile with input.farm.year as 2028
	every d in ["2026-01-01", "2026-12-31"] { n.application_route == set() with input as profile with input.farm.oepul.withdrawal_date as d }
	n.application_route == {"renewal"} with input as profile with input.farm.oepul.withdrawal_date as "2027-01-01"
}

test_payability if {
	every changes in [{"mfa_codes": ["N2", "OP"]}, {"n2_op": true}, {"trial_breach": true}, {"country": "DE"}, {"public_overlap": true}, {"year_obligation_kept": false}] {
		n.annual_gross_eur == {} with input as profile with input.land.parcels as [change_natura(changes)]
	}
}

test_min_size if {
	n.size_ok with input.farm.oepul as {"first_oepul_year": true, "protected_at_ha": 0.5}
	not n.size_ok with input.farm.oepul as {"first_oepul_year": true, "protected_at_ha": 0.49, "qualifying_at_ha": 1.49}
	n.size_ok with input.farm.oepul as {"first_oepul_year": false}
	not n.person_ok with input.farm.oepul as {"legal_form": "association", "public_share_pct": 25.1}
}

test_transfer if {
	transfer := {"date": "2028-04-17", "acquired_ha": 2, "extra_ha": 1, "online_mfa": true, "ama_approved": true, "previously_participating": false}
	n.transfer_ok with input.farm as {"year": 2028, "oepul": {"transfer": transfer}}
	not n.transfer_ok with input.farm as {"year": 2028, "oepul": {"transfer": object.union(transfer, {"extra_ha": 1.01})}}
	not n.transfer_ok with input.farm as {"year": 2026, "oepul": {"transfer": object.union(transfer, {"date": "2026-04-16"})}}
}

test_caps_and_modulation if {
	n.cap_for([], 2023) == 1200
	n.cap_for(["18"], 2026) == 1500
	n.cap_basis({"payments": [{"measure": "23", "eur_ha": 162}, {"measure": "1C", "eur_ha": 300}]}, 2026) == 162
	round(n.modulation_factor(220) * 10000) == 9909
	n.modulation_factor(200) == 1
	n.modulation_factor(1100) == 960 / 1100
}

test_sanction_change if {
	n.sanction_consequence == {"percent": 0} with input.farm as {"year": 2026, "oepul": {"assessed_sanction": "warning"}}
	n.sanction_consequence == {"percent": 1} with input.farm as {"year": 2027, "oepul": {"assessed_sanction": "warning"}}
	n.sanction_consequence.recover_term with input.farm.oepul.full_cuts_in_term as 2
}

test_general_tables if {
	n.crop_group("Papau", 2025) == "Obst"
	not n.crop_group("Papau", 2024)
	n.switch_listed("18", "19", 2025)
	not n.switch_listed("18", "23", 2025)
	n.arable_drought_region("Steiermark", "Graz", 2026)
	not n.arable_drought_region("Steiermark", "Liezen", 2026)
}

test_public_control_and_absent_area if {
	n.participation_status == "Teilnahmevoraussetzungen belegt" with input as profile
	n.annual_gross_eur == {} with input as profile with input.farm.oepul.equivalent_public_control as true
	n.annual_gross_eur == {} with input as profile with input.land.parcels as [object.remove(parcel, ["area_ha"])]
}

test_unit_table if {
	n.units_for("Rinder", "Rinder ab 2 Jahre", 2) == {"unit": "RGVE", "value": 2}
	n.units_for("Schweine", "Ferkel ab 8 kg Lebendgewicht", 10) == {"unit": "GVE", "value": 0.7}
}

test_bonus_and_cap if {
	n.bonus_threshold_contribution == {"A": 0} with input as profile
	n.capped_total_eur_ha({"other_area_measures": ["18"], "payments": [{"measure": "18", "eur_ha": 1200}, {"measure": "23", "eur_ha": 540}]}, 2026) == 1500
}

test_amended_date_preserves_rate if {
	amended := change_natura({"ordinance_changed": true, "ordinance_cut_date": "2026-08-12"})
	earlier := object.union(amended, {"operations": {"cutting_dates": ["2026-08-12", "2026-09-21"]}})
	n.annual_gross_eur == {"A": 853.2} with input as profile with input.land.parcels as [earlier]
}

test_reporting_and_control if {
	n.exit_window_open with input.farm.oepul as {"inspection_announced_or_started": false, "administrative_result_received": false}
	not n.combination_correction_possible with input.farm.oepul as {"payout_notice_received": false, "control_objection": true}
	n.remedy_for({"breach": true, "third_party_only": true}) == "maßnahmenbezogener OP-Code und Belege"
	n.op_required({"public_overlap": true})
	n.trial_record_complete({"trial_breach": true, "trial_authorization_on_file": true, "trial_details_recorded": true, "mfa_codes": ["N2", "VF"]})
}

test_single_condition_requires_no_pair_confirmation if {
	p := change_natura({"conditions": [terms[0]]})
	n.project_ok(object.union(p, {"natura": object.remove(p.natura, ["code_combinations_confirmed"])})) with input as profile
}
