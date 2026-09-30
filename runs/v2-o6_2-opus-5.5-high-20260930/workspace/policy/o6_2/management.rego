# Mindestbewirtschaftungskriterien (SRL 1.6.3, Allg. Teilnahmebedingungen 5.4)
# und Dürre-Ausnahmen 2026 zur Ernteverpflichtung auf Ackerflächen.
package oepul.o6_2

ops_of(p) := object.get(p, "operations", {})

harvested_share(p) := object.get(ops_of(p), "harvested_share_percent", null)

# Ackerflächen (ohne Ackerfutter): Ernte und Verbringen auf mind. 85 % des Schlags.
minimum_management_failed(p) if {
	parcel_category(p) == "arable"
	harvested_share(p) != null
	harvested_share(p) < general.arable_harvest_min_share_percent
	not drought_harvest_exemption(p)
}

no_mowing_with_removal(p) if count(object.get(ops_of(p), "cutting_dates", [])) == 0

no_mowing_with_removal(p) if object.get(ops_of(p), "mowing_material_removed", true) == false

# Grünland/Ackerfutter: mind. einmal jährlich vollflächige Mahd mit Verbringen
# des Mähguts oder vollflächige Beweidung (nur bei ausdrücklich verneinter
# Beweidung als Verstoß gewertet).
minimum_management_failed(p) if {
	parcel_category(p) in {"grassland", "arable_forage"}
	no_mowing_with_removal(p)
	object.get(ops_of(p), "full_area_grazing", null) == false
}

minimum_management_met(p) if not minimum_management_failed(p)

# Dürre 2026: in den ausgewiesenen Bezirken gilt die Wettersituation automatisch
# als höhere Gewalt; Ernte auf 85 % nicht erforderlich, Prämie wird gewährt.
parcel_federal_state(p) := object.get(p, "federal_state", object.get(input, ["farm", "region", "federal_state"], ""))

parcel_district(p) := object.get(p, "district", object.get(input, ["farm", "region", "district"], ""))

in_drought_district(p) if {
	some d in drought.harvest_obligation_exempt_districts
	d.federal_state == parcel_federal_state(p)
	d.district in {"*", parcel_district(p)}
}

drought_harvest_exemption(p) if {
	year == drought.year
	p.land_use == "arable"
	not is_arable_forage_main(p)
	object.get(ops_of(p), "no_harvestable_crop_due_to_drought", false) == true
	object.get(p, ["crop", "usually_harvested_late_summer_or_autumn"], false) == true
	in_drought_district(p)
}

# Außerhalb der Gebietskulisse (oder für andere Kulturen) ist bei Ernteausfall
# ein einzelflächenbezogenes Ansuchen auf höhere Gewalt mit Nachweisen nötig.
force_majeure_application_required contains p.parcel_id if {
	some p in parcels
	parcel_category(p) == "arable"
	object.get(ops_of(p), "no_harvestable_crop_due_to_drought", false) == true
	not drought_harvest_exemption(p)
}
