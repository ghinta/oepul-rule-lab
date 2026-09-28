package oepul.o6_20.rules_extra_test

import data.oepul.o6_20.decision
import data.oepul.o6_20.decision_test
import data.oepul.o6_20.premium
import data.oepul.o6_20.rgve

patched(ops) := json.patch(decision_test.base_input, ops)

rule_hit(inp, rule_id) if {
	some v in decision.violations with input as inp
	v.rule_id == rule_id
}

review_hit(inp, rule_id) if {
	some r in decision.review_items with input as inp
	r.rule_id == rule_id
}

tw := "/oepul_measures/tierwohl_weide"

# --- Förderwerbende Person -------------------------------------------------------

test_invalid_legal_form_invalidates_contract if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/legal_form", "value": "public_authority"}])
	rule_hit(inp, "o6_20.gen.applicant.legal_form")
	not decision.result.contract_valid with input as inp
}

test_not_active_farmer_invalidates_contract if {
	inp := patched([{"op": "replace", "path": "/farm/applicant/is_active_farmer", "value": false}])
	rule_hit(inp, "o6_20.gen.applicant.active_farmer")
	not decision.result.contract_valid with input as inp
}

# --- Allgemeine Bedingungen --------------------------------------------------------

test_conditionality_breach_flagged if {
	inp := patched([{"op": "replace", "path": "/farm/oepul_participation/conditionality_compliant", "value": false}])
	rule_hit(inp, "o6_20.gen.conditionality")
}

test_obligations_not_kept_whole_year if {
	inp := patched([{"op": "add", "path": sprintf("%s/obligations_kept_whole_year", [tw]), "value": false}])
	rule_hit(inp, "o6_20.gen.commitment_whole_year")
}

test_double_funding_flagged if {
	inp := patched([{"op": "add", "path": sprintf("%s/same_service_funded_elsewhere", [tw]), "value": true}])
	rule_hit(inp, "o6_20.gen.double_funding")
}

test_excluded_combination_is_review_item if {
	inp := patched([{"op": "add", "path": sprintf("%s/excluded_combinations_applied", [tw]), "value": ["measure_x"]}])
	review_hit(inp, "o6_20.gen.combination")
	decision.result.contract_valid with input as inp
}

# --- RGVE und Mindestteilnahme -------------------------------------------------------

test_rgve_class_not_allowed_for_category if {
	inp := patched([{"op": "replace", "path": sprintf("%s/animals/0/rgve_class", [tw]), "value": "cattle_6m_to_2y"}])
	rule_hit(inp, "o6_20.rgve.key")
	abs(rgve.category_rgve("cattle_female_2y_plus") - 2.0) < 0.0001 with input as inp
}

test_structure_change_cattle_ends_counting if {
	inp := patched([{"op": "add", "path": sprintf("%s/animals/1/structure_change_date", [tw]), "value": "2026-07-01"}])
	review_hit(inp, "o6_20.min_participation.structure_change_cattle")

	# 1.4.–30.6. = 91 Tage
	rgve.animal_days(inp.oepul_measures.tierwohl_weide.animals[1]) == 91 with input as inp
}

# --- Meldepflichten -------------------------------------------------------------------

test_animals_not_grazed_without_report if {
	inp := patched([{"op": "add", "path": sprintf("%s/categories/0/animals_not_grazed_without_report", [tw]), "value": 2}])
	rule_hit(inp, "o6_20.reporting.all_animals_participate")
}

test_sheep_non_participating_must_be_deleted if {
	inp := patched([{"op": "add", "path": sprintf("%s/animals/3/participating", [tw]), "value": false}])
	rule_hit(inp, "o6_20.reporting.sheep_goat_non_participation")
	deleted := json.patch(inp, [{"op": "add", "path": sprintf("%s/animals/3/deleted_from_list", [tw]), "value": true}])
	not rule_hit(deleted, "o6_20.reporting.sheep_goat_non_participation")
	abs(rgve.category_rgve("sheep_female_1y_plus") - 1.35) < 0.0001 with input as deleted
}

test_alm_only_requires_home_farm_application if {
	inp := patched([
		{"op": "add", "path": sprintf("%s/categories/1/alm_only_fulfilment", [tw]), "value": true},
		{"op": "add", "path": sprintf("%s/categories/1/applied_at_home_farm", [tw]), "value": false},
	])
	rule_hit(inp, "o6_20.reporting.sheep_goat_alm_only")
}

test_vis_and_animal_list_incomplete if {
	inp := patched([
		{"op": "replace", "path": sprintf("%s/vis_reporting_complete", [tw]), "value": false},
		{"op": "replace", "path": sprintf("%s/animal_list_complete", [tw]), "value": false},
	])
	rule_hit(inp, "o6_20.reporting.vis")
	rule_hit(inp, "o6_20.application.animal_list")
}

test_cattle_late_deregistration_is_review_item if {
	a := object.union(decision_test.cow("c9", false), {
		"non_compliance_known_date": "2026-06-01",
		"non_compliance_report_date": "2026-06-10",
		"reported_non_compliant": true,
	})
	inp := patched([{"op": "add", "path": sprintf("%s/animals/-", [tw]), "value": a}])
	not rule_hit(inp, "o6_20.reporting.cattle_deregistration")
	review_hit(inp, "o6_20.reporting.cattle_deregistration")
}

# --- Beantragung und Ausstieg ------------------------------------------------------------

test_equid_count_increase_after_deadline_not_allowed if {
	inp := patched([{"op": "add", "path": sprintf("%s/categories/2/count_entries/0/count_increased_after_deadline", [tw]), "value": true}])
	rule_hit(inp, "o6_20.application.equid_camelid_count")
}

test_replaced_category_must_be_deregistered if {
	inp := patched([{"op": "add", "path": sprintf("%s/categories/2/replaced_by_other_category", [tw]), "value": true}])
	rule_hit(inp, "o6_20.application.category_replacement")
	ok := json.patch(inp, [{"op": "add", "path": sprintf("%s/categories/2/deregistration_date", [tw]), "value": "2027-01-05"}])
	not rule_hit(ok, "o6_20.application.category_replacement")
}

test_exit_after_control_announcement_is_review_item if {
	inp := patched([
		{"op": "add", "path": sprintf("%s/deregistration_date", [tw]), "value": "2027-01-10"},
		{"op": "add", "path": sprintf("%s/exit_context", [tw]), "value": {"on_site_control_announced": true}},
	])
	review_hit(inp, "o6_20.exit.timing_controls")
}

test_force_majeure_claim_pending_is_review_item if {
	inp := patched([{"op": "add", "path": sprintf("%s/force_majeure_claimed", [tw]), "value": true}])
	review_hit(inp, "o6_20.notice2026.force_majeure_application")
	recognized := json.patch(inp, [{"op": "add", "path": sprintf("%s/force_majeure_recognized", [tw]), "value": true}])
	not review_hit(recognized, "o6_20.notice2026.force_majeure_application")
}

# --- Prämie ohne Kategorien -----------------------------------------------------------

test_no_categories_no_contract if {
	inp := patched([{"op": "replace", "path": sprintf("%s/categories", [tw]), "value": []}])
	not premium.contract_valid with input as inp
	premium.gross_min == 0 with input as inp
}
