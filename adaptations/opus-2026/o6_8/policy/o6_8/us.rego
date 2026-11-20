# o6_8 - Untersaat (US)
# Kapitel 4.4 des Maßnahmeninformationsblatts und SRL 2.8 (Untersaaten bei
# Ackerbohne, Kürbis, Soja, Sonnenblume, ab 2025 auch Mais, Sorghum, Sudangras).
package oepul.o6_8

undersowing(p) := object.get(p, ["oepul_o6_8", "undersowing"], {})

us_field(p, f) := object.get(undersowing(p), f, null)

parcel_violations contains violation("o6_8.us.min_3_mixture_partners", p, "US", sprintf("Untersaat mit %v Mischungspartnern (mindestens 3 erforderlich).", [us_field(p, "mixture_partner_count")])) if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "mixture_partner_count") != null
	us_field(p, "mixture_partner_count") < params.us_min_mixture_partners
}

parcel_violations contains violation("o6_8.us.min_3_mixture_partners", p, "US", "Untersaat ist aktiv zwischen den Reihen der Hauptkultur anzulegen.") if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "between_rows") == false
}

us_is_winter_field_bean(p) if usage(p) == "Winterackerbohnen"

us_is_winter_field_bean(p) if us_field(p, "winter_field_bean") == true

us_latest_by_main_crop(p) := time.format([date_ns(main_crop_sowing_date(p)) + (params.us_max_days_after_main_crop_sowing * ns_per_day), "UTC", "2006-01-02"])

us_calendar_deadline(p) := ymd(date_year(us_field(p, "sowing_date")), params.us_winter_field_bean_deadline_mmdd) if {
	us_is_winter_field_bean(p)
} else := ymd(date_year(us_field(p, "sowing_date")), params.us_deadline_mmdd)

parcel_violations contains violation("o6_8.us.sowing_within_8_weeks_latest_30_june", p, "US", sprintf("Untersaat am %v später als 8 Wochen nach Anbau der Hauptkultur (%v).", [us_field(p, "sowing_date"), main_crop_sowing_date(p)])) if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "sowing_date") != null
	main_crop_sowing_date(p) != null
	days_between(main_crop_sowing_date(p), us_field(p, "sowing_date")) > params.us_max_days_after_main_crop_sowing
}

parcel_violations contains violation("o6_8.us.sowing_within_8_weeks_latest_30_june", p, "US", sprintf("Untersaat am %v nach dem spätesten Anlagetermin %v.", [us_field(p, "sowing_date"), us_calendar_deadline(p)])) if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "sowing_date") != null
	after(us_field(p, "sowing_date"), us_calendar_deadline(p))
}

parcel_violations contains violation("o6_8.us.seed_proof_if_not_visible", p, "US", "Mischungspartner am Feld nicht ersichtlich: Saatgutnachweis (Rechnung oder Etikett) erforderlich.") if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "partners_visible_in_field") == false
	us_field(p, "seed_proof_available") != true
}

parcel_violations contains violation("o6_8.us.adequate_emergence", p, "US", "Saatstärke, Anbautechnik und Anbauzeitpunkt müssen ausreichenden Feldaufgang mit Erosionsschutzwirkung gewährleisten.") if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "adequate_emergence") == false
	not us_full_coverage_waived(p)
}

parcel_violations contains violation("o6_8.us.full_coverage", p, "US", "Untersaat muss flächendeckend angelegt sein.") if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "full_coverage_achieved") == false
	not us_full_coverage_waived(p)
}

us_post_sowing_soil_or_herbicide(p) if {
	some f in ["tillage_after_sowing", "harrowing_after_sowing", "herbicide_after_sowing"]
	us_field(p, f) == true
}

parcel_violations contains violation("o6_8.us.no_tillage_no_herbicide_after_sowing", p, "US", "Nach Anlage der Untersaat bis zur Ernte der Hauptkultur keine Bodenbearbeitung (inkl. Striegeln) und kein Herbizideinsatz.") if {
	some p in parcels
	has_code(p, "US")
	us_post_sowing_soil_or_herbicide(p)
}

parcel_violations contains violation("o6_8.us.maintain_until_harvest_not_harvested", p, "US", "Untersaat muss bis zur Ernte der Hauptkultur erhalten bleiben.") if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "maintained_until_main_crop_harvest") == false
}

parcel_violations contains violation("o6_8.us.maintain_until_harvest_not_harvested", p, "US", "Mitgeerntete Untersaat gilt als Mischkultur, nicht als Untersaat.") if {
	some p in parcels
	has_code(p, "US")
	us_field(p, "harvested_with_main_crop") == true
}

# Untersaat als Zwischenfrucht für "Zwischenfruchtanbau" (6): Anlagetermin ist die
# Ernte der Hauptkultur, die vor dem verpflichtenden Anlagetermin der Variante liegen muss.
us_catch_crop_establishment_date(p) := us_field(p, "main_crop_harvest_date")

us_can_count_as_catch_crop(p, variant_latest_establishment_date) if {
	on_or_before(us_catch_crop_establishment_date(p), variant_latest_establishment_date)
}
