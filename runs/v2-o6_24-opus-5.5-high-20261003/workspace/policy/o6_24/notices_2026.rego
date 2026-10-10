package oepul.o6_24

import rego.v1

# AMA-Meldungen 2026 mit Wirkung auf o6_24 (Ernteverpflichtung bei Dürre 2026).

drought_notice := data.o6_24.notice_2026_ernteverpflichtung_duerre

farm_district_in_drought_area if {
	some d in drought_notice.districts
	d.federal_state == object.get(input, ["farm", "region", "federal_state"], "")
	d.district in {"*", object.get(input, ["farm", "region", "district"], "")}
}

# Meldungen 05.08.2026 und 12.08.2026: In den angeführten Bezirken muss die Ernte auf
# zumindest 85 % des Schlages nicht erfolgen, wenn auf Grund der Dürre kein erntbarer
# Bestand vorliegt (spät geerntete Ackerkulturen); Prämie wird dennoch gewährt, keine
# einzelbetriebliche Meldung erforderlich.
drought_harvest_exemption[p.parcel_id] if {
	farm_year == drought_notice.year
	farm_district_in_drought_area
	some p in parcels
	p.land_use == "arable"
	object.get(management_of(p), "usually_harvested_late_summer_or_autumn", false) == true
	object.get(management_of(p), "no_harvestable_stand_due_to_drought", false) == true
}

# Außerhalb der Gebietskulisse der Meldungen ist für Ernteausfälle ein einzelflächen-
# bezogenes Ansuchen auf höhere Gewalt über eAMA erforderlich.
individual_force_majeure_request_required[p.parcel_id] if {
	some p in parcels
	p.land_use == "arable"
	object.get(management_of(p), "no_harvestable_stand_due_to_drought", false) == true
	not drought_harvest_exemption[p.parcel_id]
	object.get(management_of(p), "force_majeure_recognised", false) == false
}
