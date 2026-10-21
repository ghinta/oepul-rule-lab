# o6_8 - teilnahmefähige Kulturen je erosionsminderndem Verfahren
# Kapitel 7 des Maßnahmeninformationsblatts, Tabelle in data.o6_8.eligible_crops.
package oepul.o6_8

ms_ds_crop_entry(name) := e if {
	some e in crop_lists.ms_ds
	e.schlagnutzungsart == name
}

us_entry_year_ok(e) if e.from_year == null

us_entry_year_ok(e) if {
	e.from_year != null
	year >= e.from_year
}

baw_new_sowing_ok(_, e) if e.new_sowing_allowed == true

baw_new_sowing_ok(p, e) if {
	e.new_sowing_allowed == false
	object.get(p, ["oepul_o6_8", "baw", "existing_stand_retained"], false) == true
}

crop_eligible_for_code(p, "MS") if ms_ds_crop_entry(usage(p))

crop_eligible_for_code(p, "DS") if {
	e := ms_ds_crop_entry(usage(p))
	e.ds == true
}

crop_eligible_for_code(p, "AH") if {
	some e in crop_lists.ah
	e.schlagnutzungsart == usage(p)
}

crop_eligible_for_code(p, "US") if {
	some e in crop_lists.us
	e.schlagnutzungsart == usage(p)
	us_entry_year_ok(e)
}

crop_eligible_for_code(p, "BAW") if {
	some e in crop_lists.baw
	e.schlagnutzungsart == usage(p)
	baw_new_sowing_ok(p, e)
}

crop_rule_id := {
	"MS": "o6_8.crops.ms_ds_list",
	"DS": "o6_8.crops.ms_ds_list",
	"AH": "o6_8.crops.ah_list",
	"US": "o6_8.crops.us_list",
	"BAW": "o6_8.crops.baw_list",
}

parcel_violations contains violation(crop_rule_id[c], p, c, sprintf("Schlagnutzungsart %v ist für Code %v nicht teilnahmefähig.", [usage(p), c])) if {
	some p in parcels
	some c in codes(p)
	c in all_codes
	not crop_eligible_for_code(p, c)
}

parcel_violations contains violation("o6_8.application.codes_required", p, c, sprintf("Unbekannter Maßnahmencode %v; zulässig sind MS, DS, AH, BAW, US.", [c])) if {
	some p in parcels
	some c in codes(p)
	not c in all_codes
}

# Kartoffeln können nur mittels Mulchsaat angebaut werden (Kapitel 7).
potato_only_ms(p) if ms_ds_crop_entry(usage(p)).only_ms == true

# Erosionsgefährdete Kultur im Sinne von MS/DS (für Querverweise UBB/BIO).
erosion_prone_crop(p) if ms_ds_crop_entry(usage(p))
