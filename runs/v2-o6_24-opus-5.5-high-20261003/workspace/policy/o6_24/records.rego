package oepul.o6_24

import rego.v1

# Förderverpflichtung Aufzeichnungen (Maßnahmenblatt 4.2; SRL 2.24) gemäß GWSP § 5.

wrrl_records := object.get(input, ["documentation", "wrrl_records"], {})

aufz := data.o6_24.gwsp_aufzeichnungen

# Maßnahmenblatt 4.2: Betriebsbuch am Betrieb aufzubewahren.
farm_record_violations contains "Betriebsbuch gemäß § 5 GWSP nicht geführt" if {
	object.get(wrrl_records, "farm_book_kept", false) == false
}

farm_record_violations contains "Betriebsbuch nicht am Betrieb aufbewahrt" if {
	object.get(wrrl_records, "kept_at_farm", false) == false
}

# GWSP § 5 Abs. 1: jährliche betriebsbezogene Daten.
farm_record_violations contains sprintf("jährliche Betriebsdaten fehlen: %s", [f.key]) if {
	some f in aufz.farm_annual_fields
	not f.key in {k | some k in object.get(wrrl_records, "annual_fields_recorded", [])}
}

# Maßnahmenblatt 4.2: Aufzeichnungen für alle Schläge, auch ohne Düngung.
farm_record_violations contains "Aufzeichnungen nicht für alle Schläge (auch ohne Düngung) geführt" if {
	object.get(wrrl_records, "records_for_all_plots", false) == false
}

# GWSP § 5 Abs. 3: Aufbewahrung mindestens sieben Jahre.
farm_record_violations contains "Aufbewahrungsdauer unter sieben Jahren" if {
	object.get(wrrl_records, "retention_years", aufz.retention_years_min) < aufz.retention_years_min
}

# GWSP § 5 Abs. 2: schlagbezogene Pflichtangaben.
required_application_fields := ["date", "fertilizer_type", "amount", "n_effective_kg_per_ha"]

plot_record_missing[p.parcel_id] contains sprintf("Düngung %v: %s", [object.get(a, "date", "?"), f]) if {
	some p in area_arable_parcels
	some a in applications_of(p)
	some f in required_application_fields
	object.get(a, f, null) == null
}

plot_record_missing[p.parcel_id] contains f if {
	some p in area_arable_parcels
	not is_fallow(p)
	some f in ["sowing_date", "n_requirement_kg_per_ha", "previous_crop_n_credit_kg_per_ha"]
	object.get(wrrl_of(p), f, null) == null
}

plot_record_missing[p.parcel_id] contains f if {
	some p in area_arable_parcels
	is_string(object.get(wrrl_of(p), "harvest_date", null))
	some f in ["harvested_crop", "yield"]
	object.get(wrrl_of(p), f, null) == null
}

plot_record_missing[p.parcel_id] contains "Einstufung nach Anlage 2B" if {
	some p in area_arable_parcels
	object.get(wrrl_of(p), "class_recorded", true) == false
}

plot_record_missing[p.parcel_id] contains "Stickstoff im Gießwasser" if {
	some p in area_arable_parcels
	object.get(wrrl_of(p), "irrigated", false) == true
	object.get(wrrl_of(p), "irrigation_n_kg_per_ha", null) == null
}

plot_record_missing[p.parcel_id] contains sprintf("PSM %v: %s", [object.get(u, "date", "?"), f]) if {
	some p in area_arable_parcels
	some u in object.get(wrrl_of(p), "psm_applications", [])
	some f in ["product_name", "date", "method", "rate"]
	object.get(u, f, null) == null
}

# GWSP § 5 Abs. 2: Eintragung innerhalb einer Woche nach der Maßnahme.
late_entries[p.parcel_id] contains a.date if {
	some p in area_arable_parcels
	some a in applications_of(p)
	is_string(object.get(a, "recorded_date", null))
	days_between(a.date, a.recorded_date) > aufz.entry_deadline_days
}
