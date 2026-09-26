package oepul.o6_6

import rego.v1

# Expected supplement: input.o6_6.parcels is an array of declared greenings.
# Dates are ISO-8601 strings; operation booleans describe the commitment period.

variant := data.variants

eligible_parcel(p) if {
	p.arable
	p.active_establishment
	p.cover_is_dense
	p.after_main_crop
	p.followed_by_active_main_crop
	not p.volunteer_crop
	not p.self_greening
	not p.is_cereal
	not p.is_maize
	not p.cereal_or_maize_share_gt_50
}

variant_mixture_ok(p) if {
	v := variant[object.get(p, "variant", "")]
	not object.get(v, "winter_hardy_only", false)
	p.mixture_partners >= object.get(v, "minimum_partners", 0)
	p.plant_families >= object.get(v, "minimum_families", 0)
	not object.get(v, "insect_flowering", false)
}

variant_mixture_ok(p) if {
	v := variant[object.get(p, "variant", "")]
	not object.get(v, "winter_hardy_only", false)
	p.mixture_partners >= object.get(v, "minimum_partners", 0)
	p.plant_families >= object.get(v, "minimum_families", 0)
	object.get(v, "insect_flowering", false)
	p.insect_flowering_partners >= 5
}

variant_mixture_ok(p) if {
	p.variant == "6"
	every crop in p.crops { data.variants["6"].allowed_crops[_] == crop }
}

management_ok(p) if {
	not p.mineral_n_during_period
	not p.combined_n_at_sowing
	p.variant != "7"
	not p.plant_protection_during_period
	p.mechanically_terminated
}

management_ok(p) if {
	not p.mineral_n_during_period
	not p.combined_n_at_sowing
	p.variant == "7"
	not p.herbicide_after_rape_four_leaf
}

compliant[p.parcel_id] if {
	p := input.o6_6.parcels[_]
	eligible_parcel(p)
	variant_mixture_ok(p)
	management_ok(p)
}

violations contains {"parcel_id": p.parcel_id, "reason": "minimum arable area of 1.50 ha is not met"} if {
	input.land.arable_area_ha < 1.5
	p := input.o6_6.parcels[_]
}

violations contains {"parcel_id": p.parcel_id, "reason": "not an eligible actively established cover crop"} if {
	p := input.o6_6.parcels[_]
	not eligible_parcel(p)
}

violations contains {"parcel_id": p.parcel_id, "reason": "variant mixture or permitted crop requirement is not met"} if {
	p := input.o6_6.parcels[_]
	not variant_mixture_ok(p)
}

violations contains {"parcel_id": p.parcel_id, "reason": "nitrogen, plant-protection, or mechanical-termination requirement is not met"} if {
	p := input.o6_6.parcels[_]
	not management_ok(p)
}

premium_band[band] if {
	p := input.o6_6.parcels[_]
	v := variant[p.variant]
	band := {"parcel_id": p.parcel_id, "variant": p.variant, "eur_per_ha": v.premium_eur_per_ha}
}
