# AMA-Hinweise 2026 mit Auswirkung auf die Maßnahme 16 (Dürre-Erleichterungen, Aufzeichnungspflichten).
package oepul.o6_16

import data.o6_16 as d

farm_state := object.get(input, ["farm", "region", "federal_state"], "")

farm_district := object.get(input, ["farm", "region", "district"], "")

parcel_district(p) := object.get(p, "district", farm_district)

drought_waiver_district(state, district) if {
	some r in d.drought_2026_harvest_waiver_districts
	r.federal_state == state
	r.district in {"*", district}
}

# Dürre 2026: Ernteverpflichtung (85 %) entfällt automatisch (höhere Gewalt) in den gelisteten Bezirken,
# wenn aufgrund der Dürre kein erntbarer Bestand vorliegt; gilt für spät (Spätsommer/Herbst) geerntete Ackerkulturen.
harvest_obligation_waived(p) if {
	year == 2026
	drought_waiver_district(object.get(p, "federal_state", farm_state), parcel_district(p))
	object.get(p, ["operations", "no_harvestable_stand_due_to_drought"], false) == true
	object.get(p, ["crop", "usually_harvested_late_summer_or_autumn"], false) == true
}

# Außerhalb der Gebietskulisse der Dürre-Hinweise: einzelflächenbezogenes Ansuchen auf höhere Gewalt erforderlich
harvest_waiver_requires_individual_claim(p) if {
	year == 2026
	not drought_waiver_district(object.get(p, "federal_state", farm_state), parcel_district(p))
	object.get(p, ["operations", "no_harvestable_stand_due_to_drought"], false) == true
}

# System Immergrün 2026: Fristüberschreitung bei Anlage zulässig, Zwischenfrucht aber spätestens 20.09./15.10.
immergruen_2026_catch_crop_deadline(mix) := "2026-09-20" if mix == "frost_killed"

immergruen_2026_catch_crop_deadline(mix) := "2026-10-15" if mix == "predominantly_winter_hardy"

# Begrünung 2026: fehlende Flächendeckung trotz ordnungsgemäßer Anlage wird nicht beanstandet (Kombinationsmaßnahme 6/7)
cover_crop_coverage_waived_2026(p) if {
	year == 2026
	object.get(p, ["operations", "cover_crop", "properly_established"], false) == true
}
