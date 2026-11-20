# o6_10 – Teilnahmefähige Flächen und Prämienausschlüsse je Schlag
package oepul.o6_10

# O610-GEN-DEF-FRUIT: Obstkulturen gemäß Definition (inkl. Erweiterung ab 2025)
valid_fruit_name(name) if {
	some f in defs.fruit_crops
	f.name == name
	f.from_year <= year
}

valid_fruit_name(name) if {
	target := defs.fruit_crop_aliases[name]
	some f in defs.fruit_crops
	f.name == target
	f.from_year <= year
}

fruit_species_ok(p) if effective_crop_type(p) != "fruit"

fruit_species_ok(p) if {
	effective_crop_type(p) == "fruit"
	object.get(p, ["crop", "crop_name"], null) == null
}

fruit_species_ok(p) if {
	effective_crop_type(p) == "fruit"
	valid_fruit_name(p.crop.crop_name)
}

# O610-GEN-LOCATION-AT
located_in_austria(p) if object.get(p, ["location", "is_in_austria"], true) == true

# O610-ELIG-ONLY-VFH / O610-ELIG-ALL-AREAS: Wein-, Obst-, Hopfen- und Weinterrassenflächen des Betriebes
vfh_parcel(p) if {
	effective_crop_type(p) in eligible_crop_types
	fruit_species_ok(p)
	located_in_austria(p)
	object.get(p, "is_gloez_landscape_element", false) != true
}

vfh_parcels := [p | some p in parcels; vfh_parcel(p)]

vfh_area_ha := sum([parcel_area(p) | some p in vfh_parcels])

# Gründe, warum ein Schlag nicht teilnahmefähig ist (O610-ELIG-ONLY-VFH, O610-GEN-NONELIG-AREAS)
ineligible_parcels contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-ELIG-ONLY-VFH",
	"reason": sprintf("Kulturart '%s' ist keine teilnahmefähige Wein-, Obst- oder Hopfenfläche", [effective_crop_type(p)]),
} if {
	some p in parcels
	declared_crop_type(p) != "none"
	not effective_crop_type(p) in eligible_crop_types
}

ineligible_parcels contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-DEF-FRUIT",
	"reason": sprintf("'%s' ist im Antragsjahr %d keine Obstkultur im Sinne des ÖPUL 2023", [p.crop.crop_name, year]),
} if {
	some p in parcels
	effective_crop_type(p) == "fruit"
	not fruit_species_ok(p)
}

ineligible_parcels contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-LOCATION-AT",
	"reason": "Fläche liegt nicht in Österreich",
} if {
	some p in parcels
	effective_crop_type(p) in eligible_crop_types
	not located_in_austria(p)
}

ineligible_parcels contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-NONELIG-AREAS",
	"reason": "GLÖZ-Landschaftselement ist nicht förderfähig",
} if {
	some p in parcels
	object.get(p, "is_gloez_landscape_element", false) == true
}

# Prämienausschlüsse auf teilnahmefähigen Schlägen
premium_exclusions contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-OP-CODE",
	"reason": "Schlag mit ÖPUL-Code OP: keine ÖPUL-Prämie im Förderjahr",
} if {
	some p in vfh_parcels
	params.op_code in parcel_codes(p)
}

premium_exclusions contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-OP-MEASURE-SPECIFIC",
	"reason": "Maßnahmenbezogener OP-Code für Maßnahme 10: keine Prämie in dieser Maßnahme",
} if {
	some p in vfh_parcels
	params.measure_code in {m | some m in object.get(p, "op_excluded_measures", [])}
}

premium_exclusions contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-TRIAL-AREAS",
	"reason": "Versuchsfläche (Code VF): keine Prämie im laufenden Antragsjahr",
} if {
	some p in vfh_parcels
	params.trial_area_code in parcel_codes(p)
}

premium_exclusions contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-NATIONAL-PARK",
	"reason": sprintf("Nationalpark '%s': keine Prämie für Maßnahme 10", [np.park_id]),
} if {
	some p in vfh_parcels
	some np in defs.national_parks
	np.park_id == object.get(p, ["location", "national_park"], null)
	np.o6_10_premium_possible == false
}

premium_exclusions contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-FRUIT-GRAFTED",
	"reason": "Obstanlage ohne veredeltes Pflanzgut: keine ÖPUL-Prämie",
} if {
	some p in vfh_parcels
	effective_crop_type(p) == "fruit"
	object.get(p, ["permanent_crop", "is_grafted_planting_material"], null) == false
}

premium_exclusions contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-TRANSFER-MIDYEAR",
	"reason": "Unterjährig weitergegebene Fläche ohne Weiterführung bis Jahresende: keine Prämie",
} if {
	some p in vfh_parcels
	object.get(p, ["transfer", "transferred_during_year"], false) == true
	object.get(p, ["transfer", "successor_continues_until_year_end"], false) != true
}

premium_exclusions contains {
	"parcel_id": p.parcel_id,
	"rule_id": "O610-GEN-MIN-MGMT-PERMANENT",
	"reason": sprintf("Mindestbewirtschaftungskriterium '%s' auf Dauerkulturfläche nicht erfüllt", [criterion]),
} if {
	some p in vfh_parcels
	some criterion in ["properly_planted", "annual_care", "harvest_and_removal"]
	object.get(p, ["permanent_crop", "minimum_management", criterion], true) == false
}

premium_excluded_ids := {e.parcel_id | some e in premium_exclusions}

premium_parcels := [p | some p in vfh_parcels; not p.parcel_id in premium_excluded_ids]
