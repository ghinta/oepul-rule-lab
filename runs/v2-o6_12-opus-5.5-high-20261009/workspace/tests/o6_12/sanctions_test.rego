package oepul.o6_12_test

import data.oepul.o6_12

test_warning_before_2027_and_retention_from_2027 if {
	inp := with_o612({"violations": [{"obligation_id": "psm_codes", "level": 1, "detected_by": "administrative"}]})
	o6_12.content_reduction_percent == 0 with input as inp
	inp27 := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": 2027}])
	o6_12.content_reduction_percent == 1 with input as inp27
}

test_repeated_violation_escalates if {
	inp := with_o612({"violations": [{"obligation_id": "insecticide_use", "level": 3, "occurrence_same_obligation": 2, "detected_by": "on_site"}]})
	o6_12.content_reduction_percent == 10 with input as inp
}

test_cumulation_capped_at_100 if {
	inp := with_o612({"violations": [
		{"obligation_id": "a", "level": 6, "detected_by": "on_site"},
		{"obligation_id": "b", "level": 6, "detected_by": "on_site"},
		{"obligation_id": "c", "level": 2, "detected_by": "on_site"},
	]})
	o6_12.content_reduction_percent == 100 with input as inp
	o6_12.full_reduction_this_year with input as inp
	not o6_12.excluded_from_measure with input as inp
}

test_second_full_reduction_excludes if {
	inp := with_o612({"previous_full_reductions": 1, "violations": [{"obligation_id": "insecticide_use", "level": 7, "detected_by": "on_site"}]})
	o6_12.excluded_from_measure with input as inp
	"excluded_after_second_full_reduction" in o6_12.repayment_required_reasons with input as inp
	"excluded_from_measure" in o6_12.premium_blocking_reasons with input as inp
}

test_more_than_three_on_site_violations if {
	vs := [{"obligation_id": sprintf("v%d", [i]), "level": 2, "detected_by": "on_site"} | some i in numbers.range(1, 4)]
	inp := with_o612({"violations": vs})
	o6_12.full_reduction_possible with input as inp
}

test_content_reduction_applied_to_payment if {
	inp := with_o612({"violations": [{"obligation_id": "x", "level": 4, "detected_by": "administrative"}]})
	o6_12.payment_estimate_eur == 729.0 with input as inp
}
