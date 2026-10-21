# METADATA
# title: UBB (o6_1a) – Gesamtentscheidung
# description: Aggregiert Verstöße und Prämienberechnung aller UBB-Module.
package oepul.o6_1a

import data.oepul.o6_1a.arable_supplements
import data.oepul.o6_1a.biodiversity_arable
import data.oepul.o6_1a.biodiversity_grassland
import data.oepul.o6_1a.common
import data.oepul.o6_1a.eligibility
import data.oepul.o6_1a.general_conditions
import data.oepul.o6_1a.general_obligations
import data.oepul.o6_1a.grassland_supplements
import data.oepul.o6_1a.livestock
import data.oepul.o6_1a.notices_2026
import data.oepul.o6_1a.options
import data.oepul.o6_1a.premium

violations := (((((((eligibility.violations | general_obligations.violations) | biodiversity_arable.violations) | biodiversity_grassland.violations) | options.violations) | arable_supplements.violations) | premium.violations) | general_conditions.violations) | notices_2026.violations

violated_rule_ids := {v.rule_id | some v in violations}

# Zugangsvoraussetzungen: ohne diese kommt kein Vertrag zustande bzw. keine Prämie im betroffenen Jahr.
access_rule_ids := {"UBB-ANT-001", "UBB-ANT-002", "UBB-VZ-001", "UBB-KOMB-001", "UBB-KOMB-002", "ATB-FWP-001", "ATB-MIN-001"}

default access_conditions_met := false

access_conditions_met if {
	common.participates("1A")
	count(violated_rule_ids & access_rule_ids) == 0
}

decision := {
	"measure": "o6_1a",
	"year": common.year,
	"access_conditions_met": access_conditions_met,
	"livestock_farm": livestock.is_livestock_farm,
	"arable_area_ha": common.arable_area_ha,
	"mown_grassland_area_ha": common.mown_grassland_area_ha,
	"arable_div_area_ha": biodiversity_arable.arable_div_area_ha,
	"grassland_div_area_ha": biodiversity_grassland.grassland_div_area_ha,
	"premium": premium.breakdown,
	"grassland_supplement_total": grassland_supplements.total,
	"violations": violations,
}
