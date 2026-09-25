# Near-ground application of liquid farm manure and biogas slurry.
package oepul.o6_9

defs := data.o6_9.manure_definitions

application_records := object.get(manure, "applications", [])

eligible_manure_kind(kind) if {
	some e in defs.eligible_manure_kinds
	e.kind == kind
}

eligible_technique(technique) if technique in {t | some t in defs.eligible_techniques}

excluded_technique(technique) if {
	some e in defs.excluded_techniques
	e.technique == technique
}

permitted_biogas_input(input_id) if {
	some i in defs.biogas_permitted_inputs
	i.input_id == input_id
}

biogas_inputs := object.get(manure, "biogas_inputs", [])

biogas_excluded_components := object.get(manure, "biogas_excluded_components_present", [])

# Any component outside the definition disqualifies the entire biogas slurry.
default biogas_ineligible := false

biogas_ineligible if {
	some i in biogas_inputs
	not permitted_biogas_input(i)
}

biogas_ineligible if count(biogas_excluded_components) > 0

record_parcel_ids(r) := r.parcel_ids if is_array(r.parcel_ids)

else := [r.parcel_id]

# Application must take place on arable or grassland parcels of the farm.
record_on_eligible_parcels(r) if {
	ids := record_parcel_ids(r)
	count(ids) > 0
	every id in ids {
		p := parcel_index[id]
		p.land_use in {x | some x in params.eligible_land_uses_for_application}
		parcel_in_austria(p)
	}
}

record_ineligibility_reasons(r) := {reason |
	some check in [
		[fails_manure_kind(r), "manure_kind_not_eligible"],
		[fails_technique(r), "technique_not_eligible"],
		[fails_parcel(r), "parcel_not_farm_arable_or_grassland"],
		[fails_biogas(r), "biogas_slurry_outside_definition"],
		[fails_volume(r), "no_positive_volume"],
	]
	check[0] == true
	reason := check[1]
}

fails_manure_kind(r) := false if eligible_manure_kind(r.manure_kind)

else := true

fails_technique(r) := false if eligible_technique(r.technique)

else := true

fails_parcel(r) := false if record_on_eligible_parcels(r)

else := true

fails_biogas(r) if {
	r.manure_kind == "biogasguelle"
	biogas_ineligible
}

else := false

fails_volume(r) := false if r.volume_m3 > 0

else := true

record_eligible(r) if count(record_ineligibility_reasons(r)) == 0

recorded_eligible_m3(technique) := sum([r.volume_m3 |
	some r in application_records
	r.technique == technique
	record_eligible(r)
])

ineligible_application_records contains {"index": i, "reasons": record_ineligibility_reasons(r)} if {
	some i, r in application_records
	not record_eligible(r)
}

# Chronological, parcel-related record fields.
required_record_fields := ["date", "manure_kind", "volume_m3", "technique"]

record_complete(r) if {
	every f in required_record_fields {
		object.get(r, f, null) != null
	}
	count(record_parcel_ids(r)) > 0
}

# Several parcels may be summarised if crop, quantity, date and technique are identical.
records_groupable(a, b) if {
	a.crop_name == b.crop_name
	a.volume_m3_per_ha == b.volume_m3_per_ha
	a.date == b.date
	a.technique == b.technique
}

# Summarised records must state the added-up parcel sizes.
grouped_record_area_ok(r) if {
	not is_array(object.get(r, "parcel_ids", null))
}

grouped_record_area_ok(r) if {
	is_array(r.parcel_ids)
	expected := sum([parcel_index[id].area_ha | some id in r.parcel_ids])
	abs(expected - number_or_zero(object.get(r, "area_ha", 0))) < 0.0001
}

records_chronological if {
	dates := [r.date | some r in application_records]
	dates == sort(dates)
}

# Fertilisable area: arable and grassland with nitrogen demand according to
# NAPV; pure legume stands and parcels with a total fertilisation ban excluded.
has_pure_legume_flag(p) if is_boolean(p.crop.is_pure_legume_stand)

pure_legume_stand(p) if p.crop.is_pure_legume_stand == true

pure_legume_stand(p) if {
	not has_pure_legume_flag(p)
	p.crop.crop_category == "legume"
}

fertilisable_parcel(p) if {
	p.land_use in {"arable", "grassland"}
	parcel_in_austria(p)
	not pure_legume_stand(p)
	object.get(p, ["constraints", "total_fertilization_ban"], false) != true
	object.get(p, ["constraints", "has_n_fertilization_need"], true) != false
}

fertilisable_area_ha := sum([p.area_ha | some p in parcels; fertilisable_parcel(p)])

slurry_cap_m3 := params.caps.slurry_m3_per_fertilizable_ha * fertilisable_area_ha

# The cap refers to the total near-ground volume; when exceeded, all
# techniques are reduced proportionally (assumption A-03).
default slurry_scale := 1

slurry_scale := slurry_cap_m3 / declared_slurry_total_m3 if declared_slurry_total_m3 > slurry_cap_m3

eligible_slurry_m3(category) := declared_m3(category) * slurry_scale if volumes_declared_in_time

else := 0

default slurry_cap_exceeded := false

slurry_cap_exceeded if declared_slurry_total_m3 > slurry_cap_m3
