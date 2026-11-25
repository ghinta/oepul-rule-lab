# o6_13 – Kürzungsstufen bei Verstößen gegen inhaltliche Förderverpflichtungen
package oepul.o6_13

compliance := object.get(state, "compliance", {})

sanction_stage := object.get(compliance, "sanction_stage", "none")

hundred_percent_reductions := object.get(compliance, "hundred_percent_reductions_in_contract_period", 0)

stage_row(stage) := row if {
	some row in general.sanction_stages
	row.stage == stage
}

# O6_13-SANC-02 / O6_13-SANC-03: Kürzungsprozentsatz je Stufe; ab 2027 statt
# Verwarnung Einbehalt von 1 %
stage_reduction_percent(stage, y) := stage_row(stage).reduction_percent_from_2027 if {
	y >= general.warning_retention_from_year
} else := stage_row(stage).reduction_percent

# O6_13-SANC-04: Ausschluss bei zweimaliger 100 %-Kürzung im Vertragszeitraum
exclusion_from_measure if hundred_percent_reductions >= general.exclusion_after_hundred_percent_reductions

exclusion_from_measure if sanction_stage == "exclusion"

content_reduction_percent := 100 if {
	exclusion_from_measure
} else := stage_reduction_percent(sanction_stage, year) if {
	stage_row(sanction_stage)
} else := 0

sanction_result := {
	"stage": sanction_stage,
	"reduction_percent": content_reduction_percent,
	"exclusion_and_recovery": exclusion_flag,
	"reduction_order": general.reduction_order,
}

exclusion_flag if {
	exclusion_from_measure
} else := false
