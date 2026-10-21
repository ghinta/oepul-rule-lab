# Gesamtentscheidung für ÖPUL 2023 – Tierwohl – Stallhaltung Rinder (o6_21).
package oepul.o6_21.main

import data.oepul.o6_21.administration
import data.oepul.o6_21.animals
import data.oepul.o6_21.application
import data.oepul.o6_21.composting
import data.oepul.o6_21.eligibility
import data.oepul.o6_21.housing
import data.oepul.o6_21.lib
import data.oepul.o6_21.premium

violations contains {"rule_id": "O6_21-ELIG-01", "code": "min_participation_not_met"} if {
	"min_participation_not_met" in eligibility.access_issues
}

violations contains {"rule_id": "O6_21-TGD-01", "code": "animal_health_service_missing"} if {
	"animal_health_service_missing" in eligibility.access_issues
}

violations contains {"rule_id": "O6_21-QPL-01", "code": "quality_programme_missing"} if {
	"quality_programme_missing" in eligibility.access_issues
}

violations contains {"rule_id": "O6_21-TAKE-01", "code": "takeover_not_permitted"} if {
	"takeover_not_permitted" in eligibility.access_issues
}

violations contains {"rule_id": "O6_21-ELIG-05", "code": "farm_min_size_not_met"} if {
	"farm_min_size_not_met" in eligibility.access_issues
}

violations contains {"rule_id": "O6_21-ELIG-04", "code": "milk_delivery_excludes_female_half_to_2_years"} if {
	eligibility.milk_delivery_conflict
}

violations contains {"rule_id": "O6_21-REP-01", "code": "missing_deregistration", "ear_tag": tag} if {
	some tag in animals.missing_deregistrations
}

violations contains {"rule_id": "O6_21-GROUP-02", "code": code, "ear_tag": a.ear_tag} if {
	some a in animals.animals
	some code in {"individual_housing_not_documented"}
	animals.documentation_issue(a, code)
}

violations contains {"rule_id": "O6_21-PLAN-01", "code": "stall_sketch_or_occupancy_plan_missing"} if {
	housing.stall_sketch_missing
}

violations contains {"rule_id": "O6_21-COMP-01", "code": code} if {
	application.supplement_valid
	some code in composting.supplement_violations
}

violations contains {"rule_id": "O6_21-APPL-01", "code": code} if {
	some code in administration.applicant_issues
}

violations contains {"rule_id": "O6_21-CTRL-01", "code": "control_refused"} if {
	administration.control_refused
}

violations contains {"rule_id": "O6_21-APP-01", "code": "late_category_application", "category_id": cat} if {
	some cat in application.late_or_invalid_category_applications
}

violations contains {"rule_id": "O6_21-APP-03", "code": "category_entry_after_last_entry_year", "category_id": cat} if {
	some cat in application.category_applications_after_last_entry
}

violations contains {"rule_id": "O6_21-REC-02", "code": "farm_transfer_notified_late"} if {
	administration.farm_transfer_notification_late
}

notices contains {"rule_id": "O6_21-APP-06", "code": "category_lapses_after_year", "category_id": cat} if {
	some cat in animals.categories_lapsing
}

notices contains {"rule_id": "O6_21-CONTRACT-02", "code": "measure_contract_lapses"} if {
	eligibility.contract_lapses
}

notices contains {"rule_id": "O6_21-EXIT-02", "code": "exit_during_year_invalidates_year", "declared_on": e.declared_on} if {
	some e in application.exits_invalidating_current_year
}

notices contains {"rule_id": "O6_21-EXIT-04", "code": "exit_after_control_announcement_ineffective", "declared_on": e.declared_on} if {
	some e in application.exits_ineffective_after_control
}

notices contains {"rule_id": "O6_21-PAY-01", "code": "payout_may_be_withheld_below_50_eur"} if {
	premium.payout_may_be_withheld
}

notices contains {"rule_id": "O6_21-SANC-03", "code": "exclusion_and_recovery"} if {
	administration.exclusion_from_measure
}

notices contains {"rule_id": "O6_21-APP-05", "code": "replaced_category_still_binding", "category_id": cat} if {
	some cat in application.replaced_categories_still_binding
}

# Verpflichtende Aufzeichnungen und Nachweise, die sich aus der Teilnahme ergeben.
obligations contains {"rule_id": "O6_21-TGD-02", "code": "submit_animal_health_service_proof_on_request"} if {
	eligibility.animal_health_service_required
}

obligations contains {"rule_id": "O6_21-QPL-02", "code": "submit_quality_programme_proof_on_request"} if {
	eligibility.female_category_applied
}

obligations contains {"rule_id": "O6_21-GROUP-02", "code": "document_illness_and_individual_housing_duration"} if {
	count(application.valid_categories) > 0
}

obligations contains {"rule_id": "O6_21-COMP-07", "code": "document_windrow_set_up_turning_application_transfer"} if {
	application.supplement_valid
}

obligations contains {"rule_id": "O6_21-REC-01", "code": "retain_records_until", "until": administration.records_retention_until} if {
	count(application.valid_categories) > 0
}

obligations contains {"rule_id": "O6_21-PLAN-01", "code": "keep_stall_sketch_and_occupancy_plan_on_farm"} if {
	housing.stall_sketch_required
	count(application.valid_categories) > 0
}

# Allgemeine, bei Teilnahme stets geltende Bedingungen (keine automatisierte Prüfung möglich,
# daher als verbindliche Pflichten ausgewiesen).
participating if count(application.valid_categories) > 0

general_obligations contains {"rule_id": "O6_21-GEN-01", "code": "comply_with_conditionality_and_social_conditionality"} if participating

general_obligations contains {"rule_id": "O6_21-GEN-02", "code": "no_double_funding_of_same_service"} if participating

general_obligations contains {"rule_id": "O6_21-GEN-03", "code": "notify_changes_without_delay"} if participating

general_obligations contains {"rule_id": "O6_21-GEN-04", "code": "no_artificial_creation_of_conditions"} if participating

general_obligations contains {"rule_id": "O6_21-GEN-05", "code": "revision_clause_contract_adaptation_may_be_refused"} if participating

general_obligations contains {"rule_id": "O6_21-GEN-06", "code": "claims_not_assignable"} if participating

general_obligations contains {"rule_id": "O6_21-CTRL-02", "code": "allow_controls_and_provide_information"} if participating

general_obligations contains {"rule_id": "O6_21-REP-03", "code": "cattle_database_notifications_independent_of_application"} if participating

general_obligations contains {"rule_id": "O6_21-COMB-01", "code": "stall_at_home_farm_required_pasture_and_alpine_periods_allowed"} if participating

general_obligations contains {"rule_id": "O6_21-HOUS-01", "code": "comply_from_birth_or_half_year_until_leaving_or_end"} if participating

general_obligations contains {"rule_id": "O6_21-LIE-05", "code": "bedding_material_free_choice_soft_and_dry"} if participating

general_obligations contains {"rule_id": "O6_21-FM-02", "code": "force_majeure_apply_via_eama_within_three_weeks"} if participating

general_obligations contains {"rule_id": "O6_21-FM-04", "code": "missed_deadline_due_to_force_majeure_catch_up_immediately"} if participating

general_obligations contains {"rule_id": "O6_21-GEN-07", "code": "obvious_errors_correctable_in_good_faith"} if participating

general_obligations contains {"rule_id": "O6_21-GEN-08", "code": "contract_accession_joint_liability_for_recovery"} if participating

general_obligations contains {"rule_id": "O6_21-APP-09", "code": "impossible_combinations_correctable_until_payment_notice"} if participating

general_obligations contains {"rule_id": "O6_21-PAY-02", "code": "annual_premium_contract_formed_on_approval_notice"} if participating

general_obligations contains {"rule_id": "O6_21-EXIT-03", "code": "obligations_apply_until_exit_exit_online_in_mfa"} if participating

decision := {
	"measure": "o6_21",
	"year": lib.year,
	"valid_categories": application.valid_categories,
	"supplement_valid": supplement_valid_flag,
	"supplement_compliant": supplement_compliant_flag,
	"access_issues": eligibility.access_issues,
	"eligible": count(eligibility.access_issues) == 0,
	"eligible_rgve": animals.eligible_rgve,
	"gross_category_rgve": animals.gross_category_rgve,
	"compartment_violations": housing.compartment_violations,
	"deregistration_required": animals.deregistration_required,
	"premium": premium.summary,
	"payment_window": administration.payment_window,
	"violations": violations,
	"notices": notices,
	"obligations": obligations,
	"general_obligations": general_obligations,
}

supplement_valid_flag if application.supplement_valid

supplement_valid_flag := false if not application.supplement_valid

supplement_compliant_flag if composting.supplement_compliant

supplement_compliant_flag := false if not composting.supplement_compliant
