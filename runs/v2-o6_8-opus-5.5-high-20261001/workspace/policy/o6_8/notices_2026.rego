# o6_8 - Sonderregelungen Antragsjahr 2026 (Dürre)
# AMA-Aktuelles vom 22.05.2026, 05.08.2026 und 12.08.2026 mit Wirkung auf
# o6_8-Flächen (Untersaat-Flächendeckung, Ernteverpflichtung, höhere Gewalt).
package oepul.o6_8

drought := data.o6_8.drought_2026

# 12.08.2026: bei Untersaaten (US) muss 2026 keine Flächendeckung erreicht werden,
# wenn die Untersaat ordnungsgemäß mit den vorgegebenen Mischungspartnern angelegt wurde.
us_full_coverage_waived(p) if {
	year == drought.year
	has_code(p, "US")
	us_field(p, "mixture_partner_count") >= params.us_min_mixture_partners
	us_field(p, "properly_established") != false
}

# 05.08.2026 / 12.08.2026: Gebietskulisse mit automatischer Anerkennung höherer Gewalt
# für die Ernteverpflichtung auf Ackerflächen.
drought_waiver_area(p) if {
	loc := parcel_location(p)
	some r in drought.harvest_obligation_waiver_districts
	r.federal_state == loc.federal_state
	r.district in {"*", loc.district}
}

harvest_field(p, f) := object.get(p, ["oepul_o6_8", "harvest", f], null)

harvest_obligation_waived(p) if {
	year == drought.year
	drought_waiver_area(p)
	harvest_field(p, "no_harvestable_stand_due_to_drought") == true
	harvest_field(p, "late_summer_or_autumn_harvest_crop") == true
}

harvest_obligation_waived(p) if harvest_field(p, "force_majeure_recognised") == true

# Außerhalb der Gebietskulisse bleibt ein einzelflächenbezogenes Ansuchen auf
# Anerkennung höherer Gewalt mit Nachweisen erforderlich.
force_majeure_application_required(p) if {
	min_management_category(p) == "arable"
	harvest_field(p, "harvest_prevented_by_force_majeure") == true
	not harvest_obligation_waived(p)
}

parcel_violations contains violation("n2026.harvest_obligation_individual_application", p, null, "Ernte verunmöglicht: einzelflächenbezogenes Ansuchen auf Anerkennung höherer Gewalt über eAMA (Eingaben) erforderlich.") if {
	some p in parcels
	count(codes(p)) > 0
	force_majeure_application_required(p)
	harvest_field(p, "force_majeure_application_filed") != true
}

# 22.05.2026: Vor-Ort-Kontrollen berücksichtigen 2026 die Trockenheit (z. B. Feldaufgang).
drought_considered_in_controls(y) if y == drought.year
