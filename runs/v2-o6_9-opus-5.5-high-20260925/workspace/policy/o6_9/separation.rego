# Separation of cattle slurry produced on the farm.
package oepul.o6_9

separation_records := object.get(manure, "separations", [])

# Only slurry from the farm's own cattle keeping is eligible.
separation_record_eligible(r) if {
	r.slurry_origin == "own_cattle"
	r.volume_m3 > 0
	object.get(r, "phases_separated_mechanically", true) == true
}

recorded_separation_m3 := sum([r.volume_m3 |
	some r in separation_records
	separation_record_eligible(r)
])

ineligible_separation_records contains i if {
	some i, r in separation_records
	not separation_record_eligible(r)
}

separation_record_complete(r) if {
	object.get(r, "date", null) != null
	object.get(r, "volume_m3", null) != null
}

# Premium only for max. 20 m³ per cattle GVE and year.
separation_cap_m3 := params.caps.separation_m3_per_cattle_gve * cattle_gve

eligible_separation_m3 := min([declared_separation_m3, separation_cap_m3]) if volumes_declared_in_time

else := 0

default separation_cap_exceeded := false

separation_cap_exceeded if declared_separation_m3 > separation_cap_m3
