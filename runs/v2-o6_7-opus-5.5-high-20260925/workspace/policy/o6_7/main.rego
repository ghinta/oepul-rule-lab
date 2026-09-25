# Gesamtentscheidung für die Maßnahme „Begrünung von Ackerflächen – System
# Immergrün“ (o6_7): Zugang, Vertragsgültigkeit, Verstöße und Prämie.
package o6_7

import data.o6_7.catch_crop
import data.o6_7.eligibility
import data.o6_7.exit
import data.o6_7.general
import data.o6_7.greening
import data.o6_7.lib
import data.o6_7.premium
import data.o6_7.records

violations := ((((eligibility.violations | greening.violations) | catch_crop.violations) | records.violations) | exit.violations) | general.violations

violation_rule_ids := {v.rule_id | some v in violations}

catch_crop_invalid := {key: reasons |
	some key, reasons in catch_crop.invalid_reasons
}

decision := {
	"measure": lib.params.measure_id,
	"year": lib.year,
	"access_ok": eligibility.access_ok,
	"measure_valid": premium.measure_valid,
	"coverage": greening.summary,
	"catch_crops_not_counted": catch_crop_invalid,
	"catch_crops_reclassified_as_main_crop": records.reclassified_as_main_crop,
	"violations": violations,
	"premium": premium.summary,
}
