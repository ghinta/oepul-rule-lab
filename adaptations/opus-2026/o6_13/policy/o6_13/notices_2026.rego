# o6_13 – anwendbare Sonderregelungen 2026 (Dürre, höhere Gewalt)
package oepul.o6_13

# ---------------------------------------------------------------------------
# O6_13-DRT-01: Dürre 2026 – in den gelisteten Bezirken wird die Wettersituation
# automatisch als höhere Gewalt anerkannt; Ernte auf 85 % muss nicht erfolgen,
# wenn kein erntbarer Bestand vorliegt (Ackerkulturen mit Ernte im Spätsommer/Herbst)
# ---------------------------------------------------------------------------
drought := notices.drought_harvest_exemption

farm_state := object.get(input, ["farm", "region", "federal_state"], null)

farm_district := object.get(input, ["farm", "region", "district"], null)

drought_area_listed(fs, _) if {
	some a in drought.areas
	a.federal_state == fs
	a.all_districts == true
}

drought_area_listed(fs, district) if {
	some a in drought.areas
	a.federal_state == fs
	district in a.districts
}

parcel_drought(p) := object.get(p, "drought", {})

drought_2026_harvest_exemption(p) if {
	year == drought.year
	drought_area_listed(farm_state, farm_district)
	is_true(parcel_drought(p), "no_harvestable_crop_due_to_drought")
	is_true(parcel_drought(p), "crop_usually_harvested_late_summer_or_autumn")
}

# O6_13-DRT-02: außerhalb der Gebietskulisse ist bei verunmöglichter Ernte ein
# einzelflächenbezogenes Ansuchen (höhere Gewalt) mit Nachweisen erforderlich
force_majeure_application_required contains p.parcel_id if {
	some p in nue_parcels
	harvest_shortfall(p)
	not drought_2026_harvest_exemption(p)
	not is_true(p, "force_majeure_recognised")
}
