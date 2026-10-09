package oepul

payload := object.get(input, "payload", {})
farm := object.get(payload, "farm", {})
farm_region := object.get(farm, "region", {})
land := object.get(payload, "land", {})
aggregate := object.get(land, "aggregate", {})
parcels := object.get(land, "parcels", [])
livestock := object.get(payload, "livestock", {})
species_groups := object.get(livestock, "species_groups", [])
documentation := object.get(payload, "documentation", {})
oepul := object.get(payload, "oepul", {})
shared := object.get(oepul, "shared", {})
shared_parcels := object.get(shared, "parcels", [])
shared_livestock_events := object.get(shared, "livestock_events", [])
oepul_measures := object.get(oepul, "measures", {})
certifications := object.get(farm, "certifications", {})
organic_certification := object.get(object.get(certifications, "organic", {}), "is_certified", null)

default measure_decision := {
  "measure_id": "",
  "status": "missing_data",
  "missing_keys": [],
  "reasons": ["measure_not_supported"],
  "failed_conditions": [],
  "satisfied_conditions": [],
}

measure_decision := result if {
  input.measure_id == "o6_1a"
  result := o6_1a_result
}

measure_decision := result if {
  input.measure_id == "o6_1b"
  result := o6_1b_result
}

measure_decision := result if {
  input.measure_id == "o6_1c"
  result := o6_1c_result
}

measure_decision := result if {
  input.measure_id == "o6_2"
  result := o6_2_result
}

measure_decision := result if {
  input.measure_id == "o6_3"
  result := o6_3_result
}

measure_decision := result if {
  input.measure_id == "o6_4"
  result := o6_4_result
}

measure_decision := result if {
  input.measure_id == "o6_5"
  result := o6_5_result
}

measure_decision := result if {
  input.measure_id == "o6_6"
  result := o6_6_result
}

measure_decision := result if {
  input.measure_id == "o6_7"
  result := o6_7_result
}

measure_decision := result if {
  input.measure_id == "o6_8"
  result := o6_8_result
}

measure_decision := result if {
  input.measure_id == "o6_9"
  result := o6_9_result
}

measure_decision := result if {
  input.measure_id == "o6_10"
  result := o6_10_result
}

measure_decision := result if {
  input.measure_id == "o6_11"
  result := o6_11_result
}

measure_decision := result if {
  input.measure_id == "o6_12"
  result := o6_12_result
}

measure_decision := result if {
  input.measure_id == "o6_13"
  result := o6_13_result
}

measure_decision := result if {
  input.measure_id == "o6_14"
  result := o6_14_result
}

measure_decision := result if {
  input.measure_id == "o6_15"
  result := o6_15_result
}

measure_decision := result if {
  input.measure_id == "o6_16"
  result := o6_16_result
}

measure_decision := result if {
  input.measure_id == "o6_17"
  result := o6_17_result
}

measure_decision := result if {
  input.measure_id == "o6_18"
  result := o6_18_result
}

measure_decision := result if {
  input.measure_id == "o6_19"
  result := o6_19_result
}

measure_decision := result if {
  input.measure_id == "o6_20"
  result := o6_20_result
}

measure_decision := result if {
  input.measure_id == "o6_21"
  result := o6_21_result
}

measure_decision := result if {
  input.measure_id == "o6_22"
  result := o6_22_result
}

measure_decision := result if {
  input.measure_id == "o6_23"
  result := o6_23_result
}

measure_decision := result if {
  input.measure_id == "o6_24"
  result := o6_24_result
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #80 DecisionTrace v1): identifies
# the exact checked-in rule branch for safe, server-owned Rego-text extraction.
# Do not remove/rename without updating
# backend/app/review/adapters/oepul/rego_rules.py CONDITION_MARKERS.
o6_1a_result := {
  "measure_id": "o6_1a",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.grassland_area_ha", object.get(land, "grassland_area_ha", null)],
    ["payload.land.aggregate.existing_biodiversity_area_ha", object.get(aggregate, "existing_biodiversity_area_ha", null)],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: land_use_specific_biodiversity_split_not_available
# Stable, non-semantic anchor comment (Issue #80 DecisionTrace v1); see note
# above. This branch is a technical coverage gap, not a normative rule: the
# DecisionTrace adapter must never attach a normative source reference to it.
o6_1a_result := {
  "measure_id": "o6_1a",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].is_biodiversity_area"],
  "reasons": ["land_use_specific_biodiversity_split_not_available"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_1a_required_inputs_complete
  object.get(land, "grassland_area_ha", null) > 0
}

# decision-trace-condition: biodiversity_min_share_below_required
# Stable, non-semantic anchor comment (Issue #80 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1a_result := {
  "measure_id": "o6_1a",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["biodiversity_min_share_below_required"],
  "failed_conditions": [{
    "code": "biodiversity_min_share_below_required",
    "paths": ["payload.land.arable_area_ha", "payload.land.aggregate.existing_biodiversity_area_ha"],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "payload.land.aggregate.existing_biodiversity_area_ha": biodiversity_area,
    },
  }],
  "satisfied_conditions": [],
} if {
  o6_1a_required_inputs_complete
  arable_area := object.get(land, "arable_area_ha", null)
  object.get(land, "grassland_area_ha", null) == 0
  biodiversity_area := object.get(aggregate, "existing_biodiversity_area_ha", null)
  arable_area != null
  biodiversity_area != null
  arable_area > 2.0
  biodiversity_area < arable_area * 0.07
}

# decision-trace-condition: biodiversity_min_share_met
# Stable, non-semantic anchor comment (Issue #80 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1a_result := {
  "measure_id": "o6_1a",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "biodiversity_min_share_met",
    "paths": [
      "payload.land.arable_area_ha",
      "payload.land.grassland_area_ha",
      "payload.land.aggregate.existing_biodiversity_area_ha",
    ],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "payload.land.grassland_area_ha": grassland_area,
      "payload.land.aggregate.existing_biodiversity_area_ha": biodiversity_area,
    },
  }],
} if {
  o6_1a_required_inputs_complete
  arable_area := object.get(land, "arable_area_ha", null)
  grassland_area := object.get(land, "grassland_area_ha", null)
  grassland_area == 0
  biodiversity_area := object.get(aggregate, "existing_biodiversity_area_ha", null)
  arable_area != null
  biodiversity_area != null
  arable_area > 2.0
  biodiversity_area >= arable_area * 0.07
}

# decision-trace-condition: small_arable_area_baseline_met
# Stable, non-semantic anchor comment (Issue #80 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1a_result := {
  "measure_id": "o6_1a",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "small_arable_area_baseline_met",
    "paths": ["payload.land.arable_area_ha", "payload.land.grassland_area_ha"],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "payload.land.grassland_area_ha": 0,
    },
  }],
} if {
  o6_1a_required_inputs_complete
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area <= 2.0
  object.get(land, "grassland_area_ha", null) == 0
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see the
# note above the first o6_1a_result branch. o6_1b has two checked-in
# "required_inputs_missing" branches (this one and the later
# biodiversity-area-specific gate below) -- both are captured, verbatim, by
# backend/app/review/adapters/oepul/rego_rules.py. Do not remove/rename
# without updating that module.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.farm.certifications.organic.is_certified", organic_certification],
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.grassland_area_ha", object.get(land, "grassland_area_ha", null)],
    ["payload.land.special_crops_area_ha", object.get(land, "special_crops_area_ha", null)],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: organic_certification_not_met
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["organic_certification_not_met"],
  "failed_conditions": [{
    "code": "organic_certification_not_met",
    "paths": ["payload.farm.certifications.organic.is_certified"],
    "actual_values": {
      "payload.farm.certifications.organic.is_certified": organic_certification,
    },
  }],
  "satisfied_conditions": [],
} if {
  o6_1b_required_inputs_complete
  organic_certification == false
}

# decision-trace-condition: no_relevant_land_area_available
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["no_relevant_land_area_available"],
  "failed_conditions": [{
    "code": "no_relevant_land_area_available",
    "paths": [
      "payload.land.arable_area_ha",
      "payload.land.grassland_area_ha",
      "payload.land.special_crops_area_ha",
    ],
    "actual_values": {
      "payload.land.arable_area_ha": object.get(land, "arable_area_ha", null),
      "payload.land.grassland_area_ha": object.get(land, "grassland_area_ha", null),
      "payload.land.special_crops_area_ha": object.get(land, "special_crops_area_ha", null),
    },
  }],
  "satisfied_conditions": [],
} if {
  o6_1b_required_inputs_complete
  organic_certification == true
  not has_o6_1b_relevant_land
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see note
# above the first o6_1b_result branch: this is the second of the two
# "required_inputs_missing" branches for o6_1b.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "missing_data",
  "missing_keys": ["payload.land.aggregate.existing_biodiversity_area_ha"],
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_1b_required_inputs_complete
  organic_certification == true
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area > 2.0
  object.get(aggregate, "existing_biodiversity_area_ha", null) == null
}

# decision-trace-condition: land_use_specific_biodiversity_split_not_available
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see note
# above the first o6_1a_result branch. This branch is a technical coverage
# gap, not a normative rule: the DecisionTrace adapter must never attach a
# normative source reference to it.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].is_biodiversity_area"],
  "reasons": ["land_use_specific_biodiversity_split_not_available"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_1b_required_inputs_complete
  organic_certification == true
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area > 2.0
  object.get(aggregate, "existing_biodiversity_area_ha", null) != null
  has_non_arable_relevant_land
}

# decision-trace-condition: biodiversity_min_share_below_required
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["biodiversity_min_share_below_required"],
  "failed_conditions": [{
    "code": "biodiversity_min_share_below_required",
    "paths": ["payload.land.arable_area_ha", "payload.land.aggregate.existing_biodiversity_area_ha"],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "payload.land.aggregate.existing_biodiversity_area_ha": biodiversity_area,
    },
  }],
  "satisfied_conditions": [],
} if {
  o6_1b_required_inputs_complete
  organic_certification == true
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area > 2.0
  not has_non_arable_relevant_land
  biodiversity_area := object.get(aggregate, "existing_biodiversity_area_ha", null)
  biodiversity_area != null
  biodiversity_area < arable_area * 0.07
}

# decision-trace-condition: biodiversity_min_share_met
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "biodiversity_min_share_met",
    "paths": [
      "payload.farm.certifications.organic.is_certified",
      "payload.land.arable_area_ha",
      "payload.land.grassland_area_ha",
      "payload.land.special_crops_area_ha",
      "payload.land.aggregate.existing_biodiversity_area_ha",
    ],
    "actual_values": {
      "payload.farm.certifications.organic.is_certified": organic_certification,
      "payload.land.arable_area_ha": arable_area,
      "payload.land.grassland_area_ha": object.get(land, "grassland_area_ha", null),
      "payload.land.special_crops_area_ha": object.get(land, "special_crops_area_ha", null),
      "payload.land.aggregate.existing_biodiversity_area_ha": biodiversity_area,
    },
  }],
} if {
  o6_1b_required_inputs_complete
  organic_certification == true
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area > 2.0
  not has_non_arable_relevant_land
  biodiversity_area := object.get(aggregate, "existing_biodiversity_area_ha", null)
  biodiversity_area != null
  biodiversity_area >= arable_area * 0.07
}

# decision-trace-condition: small_arable_area_baseline_met
# Stable, non-semantic anchor comment (Issue #90 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1b_result := {
  "measure_id": "o6_1b",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "small_arable_area_baseline_met",
    "paths": [
      "payload.farm.certifications.organic.is_certified",
      "payload.land.arable_area_ha",
      "payload.land.grassland_area_ha",
      "payload.land.special_crops_area_ha",
    ],
    "actual_values": {
      "payload.farm.certifications.organic.is_certified": organic_certification,
      "payload.land.arable_area_ha": arable_area,
      "payload.land.grassland_area_ha": object.get(land, "grassland_area_ha", null),
      "payload.land.special_crops_area_ha": object.get(land, "special_crops_area_ha", null),
    },
  }],
} if {
  o6_1b_required_inputs_complete
  organic_certification == true
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area <= 2.0
  has_o6_1b_relevant_land
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1c_result := {
  "measure_id": "o6_1c",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.parcels[]", parcels],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_arable_area_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1c_result := {
  "measure_id": "o6_1c",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_arable_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_arable_area_not_met",
    "paths": ["payload.land.arable_area_ha"],
    "actual_values": {
      "payload.land.arable_area_ha": object.get(land, "arable_area_ha", null),
    },
  }],
  "satisfied_conditions": [],
} if {
  o6_1c_required_inputs_complete
  object.get(land, "arable_area_ha", null) == 0
}

# decision-trace-condition: no_arable_parcels_available
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1c_result := {
  "measure_id": "o6_1c",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].land_use"],
  "reasons": ["no_arable_parcels_available"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_1c_required_inputs_complete
  object.get(land, "arable_area_ha", null) > 0
  count(arable_parcels) == 0
}

# decision-trace-condition: phase1_proxy_signal_detected
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1c_result := {
  "measure_id": "o6_1c",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_proxy_signal_detected"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "phase1_proxy_signal_detected",
    "paths": ["payload.land.arable_area_ha", "payload.land.parcels[].is_nonproductive_area", "payload.land.parcels[].is_agroforestry_strip"],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "arable_parcel_proxy_flags": arable_parcel_proxy_flags,
    },
  }],
} if {
  o6_1c_required_inputs_complete
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area > 0
  any_arable_proxy_signal
}

# decision-trace-condition: parcel_proxy_classification_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1c_result := {
  "measure_id": "o6_1c",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["parcel_proxy_classification_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_1c_required_inputs_complete
  object.get(land, "arable_area_ha", null) > 0
  not any_arable_proxy_signal
  missing_keys := array.concat(
    ["payload.land.parcels[].is_nonproductive_area" | arable_nonproductive_proxy_missing],
    ["payload.land.parcels[].is_agroforestry_strip" | arable_agroforestry_proxy_missing],
  )
  count(missing_keys) > 0
}

# decision-trace-condition: no_nonproductive_or_agroforestry_proxy_detected
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_1c_result := {
  "measure_id": "o6_1c",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["no_nonproductive_or_agroforestry_proxy_detected"],
  "failed_conditions": [{
    "code": "no_nonproductive_or_agroforestry_proxy_detected",
    "paths": ["payload.land.parcels[].is_nonproductive_area", "payload.land.parcels[].is_agroforestry_strip"],
    "actual_values": {"arable_parcel_proxy_flags": arable_parcel_proxy_flags},
  }],
  "satisfied_conditions": [],
} if {
  o6_1c_required_inputs_complete
  object.get(land, "arable_area_ha", null) > 0
  not any_arable_proxy_signal
  any_arable_nonproductive_proxy_complete
  any_arable_agroforestry_proxy_complete
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_5_result := {
  "measure_id": "o6_5",
  "status": "missing_data",
  "missing_keys": ["payload.livestock.species_groups[]"],
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  species_groups == null
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_5_result := {
  "measure_id": "o6_5",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  species_groups != null
  missing_keys := array.concat(
    ["payload.livestock.species_groups[].species" | some_species_group_missing_species],
    ["payload.livestock.species_groups[].animal_count" | some_supported_group_missing_animal_count],
  )
  count(missing_keys) > 0
}

# decision-trace-condition: supported_species_group_with_positive_count_found
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_5_result := {
  "measure_id": "o6_5",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "supported_species_group_with_positive_count_found",
    "paths": ["payload.livestock.species_groups[].species", "payload.livestock.species_groups[].animal_count"],
    "actual_values": {"livestock_group_species_and_counts": livestock_group_species_and_counts},
  }],
} if {
  supported_group_species_complete
  supported_group_animal_counts_complete
  has_supported_positive_animal_count
}

# decision-trace-condition: no_supported_species_group_found
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_5_result := {
  "measure_id": "o6_5",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["no_supported_species_group_found"],
  "failed_conditions": [{
    "code": "no_supported_species_group_found",
    "paths": ["payload.livestock.species_groups[].species", "payload.livestock.species_groups[].animal_count"],
    "actual_values": {"livestock_group_species_and_counts": livestock_group_species_and_counts},
  }],
  "satisfied_conditions": [],
} if {
  not has_supported_positive_animal_count
  supported_group_species_complete
  supported_group_animal_counts_complete
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_6_result := {
  "measure_id": "o6_6",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_arable_area_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_6_result := {
  "measure_id": "o6_6",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_arable_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_arable_area_not_met",
    "paths": ["payload.land.arable_area_ha"],
    "actual_values": {"payload.land.arable_area_ha": arable_area},
  }],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area < 1.5
}

# decision-trace-condition: greening_proxy_area_not_detected
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_6_result := {
  "measure_id": "o6_6",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["greening_proxy_area_not_detected"],
  "failed_conditions": [{
    "code": "greening_proxy_area_not_detected",
    "paths": ["payload.land.aggregate.begruenungsflaeche_ha", "payload.land.aggregate.soil_cover"],
    "actual_values": {
      "payload.land.aggregate.begruenungsflaeche_ha": object.get(aggregate, "begruenungsflaeche_ha", null),
      "payload.land.aggregate.soil_cover": object.get(aggregate, "soil_cover", null),
    },
  }],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area >= 1.5
  not has_positive_greening_proxy
  object.get(aggregate, "begruenungsflaeche_ha", null) == 0
  object.get(aggregate, "soil_cover", null) != null
}

# decision-trace-condition: greening_proxy_area_detected
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_6_result := {
  "measure_id": "o6_6",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_proxy_signal_detected"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "greening_proxy_area_detected",
    "paths": ["payload.land.arable_area_ha", "payload.land.aggregate.begruenungsflaeche_ha", "payload.land.aggregate.soil_cover"],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "payload.land.aggregate.begruenungsflaeche_ha": object.get(aggregate, "begruenungsflaeche_ha", null),
      "payload.land.aggregate.soil_cover": object.get(aggregate, "soil_cover", null),
    },
  }],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area >= 1.5
  has_positive_greening_proxy
}

# decision-trace-condition: greening_proxy_signal_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_6_result := {
  "measure_id": "o6_6",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["greening_proxy_signal_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area >= 1.5
  not has_positive_greening_proxy
  missing_keys := missing_keys_from_pairs([
    ["payload.land.aggregate.begruenungsflaeche_ha", object.get(aggregate, "begruenungsflaeche_ha", null)],
    ["payload.land.aggregate.soil_cover", object.get(aggregate, "soil_cover", null)],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_7_result := {
  "measure_id": "o6_7",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.aggregate.begruenungsflaeche_ha", object.get(aggregate, "begruenungsflaeche_ha", null)],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_arable_area_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_7_result := {
  "measure_id": "o6_7",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_arable_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_arable_area_not_met",
    "paths": ["payload.land.arable_area_ha"],
    "actual_values": {"payload.land.arable_area_ha": arable_area},
  }],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  object.get(aggregate, "begruenungsflaeche_ha", null) != null
  arable_area < 1.5
}

# decision-trace-condition: minimum_green_cover_share_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_7_result := {
  "measure_id": "o6_7",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_green_cover_share_not_met"],
  "failed_conditions": [{
    "code": "minimum_green_cover_share_not_met",
    "paths": ["payload.land.arable_area_ha", "payload.land.aggregate.begruenungsflaeche_ha"],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "payload.land.aggregate.begruenungsflaeche_ha": begruenungsflaeche,
    },
  }],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  begruenungsflaeche := object.get(aggregate, "begruenungsflaeche_ha", null)
  arable_area != null
  begruenungsflaeche != null
  arable_area >= 1.5
  begruenungsflaeche / arable_area < 0.85
}

# decision-trace-condition: minimum_green_cover_share_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_7_result := {
  "measure_id": "o6_7",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "minimum_green_cover_share_met",
    "paths": ["payload.land.arable_area_ha", "payload.land.aggregate.begruenungsflaeche_ha"],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "payload.land.aggregate.begruenungsflaeche_ha": begruenungsflaeche,
    },
  }],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  begruenungsflaeche := object.get(aggregate, "begruenungsflaeche_ha", null)
  arable_area != null
  begruenungsflaeche != null
  arable_area >= 1.5
  begruenungsflaeche / arable_area >= 0.85
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_8_result := {
  "measure_id": "o6_8",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.parcels[]", parcels],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_arable_area_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_8_result := {
  "measure_id": "o6_8",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_arable_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_arable_area_not_met",
    "paths": ["payload.land.arable_area_ha"],
    "actual_values": {"payload.land.arable_area_ha": arable_area},
  }],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area < 0.1
}

# decision-trace-condition: no_arable_parcels_available
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_8_result := {
  "measure_id": "o6_8",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].land_use"],
  "reasons": ["no_arable_parcels_available"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area >= 0.1
  count(arable_parcels) == 0
}

# decision-trace-condition: arable_slope_data_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_8_result := {
  "measure_id": "o6_8",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].slope_percent"],
  "reasons": ["arable_slope_data_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area >= 0.1
  count(arable_parcels) > 0
  not has_arable_slope
}

# decision-trace-condition: erosion_practice_signal_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_8_result := {
  "measure_id": "o6_8",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["erosion_practice_signal_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area != null
  arable_area >= 0.1
  count(arable_parcels) > 0
  has_arable_slope
  not has_erosion_practice_signal
  missing_keys := missing_keys_from_pairs([
    ["payload.land.aggregate.tillage_type", object.get(aggregate, "tillage_type", null)],
    ["payload.land.aggregate.soil_cover", object.get(aggregate, "soil_cover", null)],
    ["payload.land.aggregate.mulchsaat_technology_available", object.get(aggregate, "mulchsaat_technology_available", null)],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: erosion_practice_signal_detected
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_8_result := {
  "measure_id": "o6_8",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "erosion_practice_signal_detected",
    "paths": [
      "payload.land.arable_area_ha",
      "payload.land.parcels[].slope_percent",
      "payload.land.aggregate.tillage_type",
      "payload.land.aggregate.soil_cover",
      "payload.land.aggregate.mulchsaat_technology_available",
    ],
    "actual_values": {
      "payload.land.arable_area_ha": arable_area,
      "arable_parcel_slopes": arable_parcel_slopes,
      "payload.land.aggregate.tillage_type": object.get(aggregate, "tillage_type", null),
      "payload.land.aggregate.soil_cover": object.get(aggregate, "soil_cover", null),
      "payload.land.aggregate.mulchsaat_technology_available": object.get(aggregate, "mulchsaat_technology_available", null),
    },
  }],
} if {
  arable_area := object.get(land, "arable_area_ha", null)
  arable_area >= 0.1
  count(arable_parcels) > 0
  has_arable_slope
  has_erosion_practice_signal
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.land.special_crops_area_ha", object.get(land, "special_crops_area_ha", null)],
    ["payload.land.parcels[]", parcels],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_special_crop_area_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_special_crop_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_special_crop_area_not_met",
    "paths": ["payload.land.special_crops_area_ha"],
    "actual_values": {"payload.land.special_crops_area_ha": special_crops_area},
  }],
  "satisfied_conditions": [],
} if {
  special_crops_area := object.get(land, "special_crops_area_ha", null)
  special_crops_area != null
  special_crops_area < 0.5
}

# decision-trace-condition: no_special_crop_parcels_available
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].land_use"],
  "reasons": ["no_special_crop_parcels_available"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  special_crops_area := object.get(land, "special_crops_area_ha", null)
  special_crops_area != null
  special_crops_area >= 0.5
  count(special_crop_parcels) == 0
}

# decision-trace-condition: phase1_proxy_signal_detected
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_proxy_signal_detected"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "phase1_proxy_signal_detected",
    "paths": [
      "payload.land.special_crops_area_ha",
      "payload.land.parcels[].slope_percent",
      "payload.land.aggregate.soil_cover",
    ],
    "actual_values": {
      "payload.land.special_crops_area_ha": special_crops_area,
      "special_crop_parcel_slopes": special_crop_parcel_slopes,
      "payload.land.aggregate.soil_cover": true,
    },
  }],
} if {
  special_crops_area := object.get(land, "special_crops_area_ha", null)
  special_crops_area != null
  special_crops_area >= 0.5
  has_special_crop_slope_at_or_above_25
  object.get(aggregate, "soil_cover", null) == true
}

# decision-trace-condition: special_crop_proxy_signal_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch. o6_10 has two checked-in
# "special_crop_proxy_signal_missing" branches (this one and the slope/
# soil-cover-combined gate below) -- both are captured, verbatim, by
# backend/app/review/adapters/oepul/rego_rules.py. Do not remove/rename
# without updating that module.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "missing_data",
  "missing_keys": ["payload.land.aggregate.soil_cover"],
  "reasons": ["special_crop_proxy_signal_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  special_crops_area := object.get(land, "special_crops_area_ha", null)
  special_crops_area != null
  special_crops_area >= 0.5
  has_special_crop_slope_at_or_above_25
  object.get(aggregate, "soil_cover", null) == null
}

# decision-trace-condition: special_crop_proxy_signal_missing
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_10_result "special_crop_proxy_signal_missing" branch:
# this is the second of the two branches for this condition code.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["special_crop_proxy_signal_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  special_crops_area := object.get(land, "special_crops_area_ha", null)
  special_crops_area != null
  special_crops_area >= 0.5
  count(special_crop_parcels) > 0
  not has_special_crop_slope_at_or_above_25
  missing_keys := array.concat(
    ["payload.land.parcels[].slope_percent" | special_crop_slope_missing],
    ["payload.land.aggregate.soil_cover" | object.get(aggregate, "soil_cover", null) == null],
  )
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_slope_requirement_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_slope_requirement_not_met"],
  "failed_conditions": [{
    "code": "minimum_slope_requirement_not_met",
    "paths": ["payload.land.special_crops_area_ha", "payload.land.parcels[].slope_percent"],
    "actual_values": {
      "payload.land.special_crops_area_ha": special_crops_area,
      "special_crop_parcel_slopes": special_crop_parcel_slopes,
    },
  }],
  "satisfied_conditions": [],
} if {
  special_crops_area := object.get(land, "special_crops_area_ha", null)
  special_crops_area != null
  special_crops_area >= 0.5
  special_crop_slopes_complete
  not has_special_crop_slope_at_or_above_25
  object.get(aggregate, "soil_cover", null) != null
}

# decision-trace-condition: soil_cover_proxy_not_met
# Stable, non-semantic anchor comment (Issue #94 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_10_result := {
  "measure_id": "o6_10",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["soil_cover_proxy_not_met"],
  "failed_conditions": [{
    "code": "soil_cover_proxy_not_met",
    "paths": ["payload.land.special_crops_area_ha", "payload.land.aggregate.soil_cover"],
    "actual_values": {
      "payload.land.special_crops_area_ha": special_crops_area,
      "payload.land.aggregate.soil_cover": object.get(aggregate, "soil_cover", null),
    },
  }],
  "satisfied_conditions": [],
} if {
  special_crops_area := object.get(land, "special_crops_area_ha", null)
  special_crops_area != null
  special_crops_area >= 0.5
  has_special_crop_slope_at_or_above_25
  object.get(aggregate, "soil_cover", null) == false
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_14_result := {
  "measure_id": "o6_14",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.land.alpine_pasture_area_ha", object.get(land, "alpine_pasture_area_ha", null)],
    ["payload.livestock.species_groups[].gve", total_supported_livestock_gve],
    ["payload.livestock.species_groups[].housing.pasture.weide_days_per_year", max_supported_grazing_days],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_alpine_pasture_area_not_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_14_result := {
  "measure_id": "o6_14",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_alpine_pasture_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_alpine_pasture_area_not_met",
    "paths": ["payload.land.alpine_pasture_area_ha"],
    "actual_values": {"payload.land.alpine_pasture_area_ha": alpine_pasture_area},
  }],
  "satisfied_conditions": [],
} if {
  alpine_pasture_area := object.get(land, "alpine_pasture_area_ha", null)
  alpine_pasture_area != null
  alpine_pasture_area < 3.0
  total_supported_livestock_gve != null
  max_supported_grazing_days != null
}

# decision-trace-condition: minimum_gve_not_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_14_result := {
  "measure_id": "o6_14",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_gve_not_met"],
  "failed_conditions": [{
    "code": "minimum_gve_not_met",
    "paths": ["payload.livestock.species_groups[].gve"],
    "actual_values": {"total_supported_livestock_gve": total_supported_livestock_gve},
  }],
  "satisfied_conditions": [],
} if {
  alpine_pasture_area := object.get(land, "alpine_pasture_area_ha", null)
  alpine_pasture_area >= 3.0
  total_supported_livestock_gve != null
  total_supported_livestock_gve < 3.0
  max_supported_grazing_days != null
}

# decision-trace-condition: minimum_grazing_days_not_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_14_result := {
  "measure_id": "o6_14",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_grazing_days_not_met"],
  "failed_conditions": [{
    "code": "minimum_grazing_days_not_met",
    "paths": ["payload.livestock.species_groups[].housing.pasture.weide_days_per_year"],
    "actual_values": {
      "max_supported_grazing_days": max_supported_grazing_days,
    },
  }],
  "satisfied_conditions": [],
} if {
  alpine_pasture_area := object.get(land, "alpine_pasture_area_ha", null)
  alpine_pasture_area >= 3.0
  total_supported_livestock_gve != null
  total_supported_livestock_gve >= 3.0
  max_supported_grazing_days != null
  max_supported_grazing_days < 60
}

# decision-trace-condition: maximum_stocking_density_exceeded
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_14_result := {
  "measure_id": "o6_14",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["maximum_stocking_density_exceeded"],
  "failed_conditions": [{
    "code": "maximum_stocking_density_exceeded",
    "paths": ["payload.land.alpine_pasture_area_ha", "payload.livestock.species_groups[].gve"],
    "actual_values": {
      "payload.land.alpine_pasture_area_ha": alpine_pasture_area,
      "total_supported_livestock_gve": total_supported_livestock_gve,
    },
  }],
  "satisfied_conditions": [],
} if {
  alpine_pasture_area := object.get(land, "alpine_pasture_area_ha", null)
  alpine_pasture_area >= 3.0
  total_supported_livestock_gve != null
  total_supported_livestock_gve >= 3.0
  max_supported_grazing_days != null
  max_supported_grazing_days >= 60
  total_supported_livestock_gve / alpine_pasture_area > 2.0
}

# decision-trace-condition: maximum_stocking_density_within_limit
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_14_result := {
  "measure_id": "o6_14",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "maximum_stocking_density_within_limit",
    "paths": [
      "payload.land.alpine_pasture_area_ha",
      "payload.livestock.species_groups[].gve",
      "payload.livestock.species_groups[].housing.pasture.weide_days_per_year",
    ],
    "actual_values": {
      "payload.land.alpine_pasture_area_ha": alpine_pasture_area,
      "total_supported_livestock_gve": total_supported_livestock_gve,
      "max_supported_grazing_days": max_supported_grazing_days,
    },
  }],
} if {
  alpine_pasture_area := object.get(land, "alpine_pasture_area_ha", null)
  alpine_pasture_area >= 3.0
  total_supported_livestock_gve != null
  total_supported_livestock_gve >= 3.0
  max_supported_grazing_days != null
  max_supported_grazing_days >= 60
  total_supported_livestock_gve / alpine_pasture_area <= 2.0
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_keys_from_pairs([
    ["payload.farm.year", object.get(farm, "year", null)],
    ["payload.land.total_area_ha", object.get(land, "total_area_ha", null)],
    ["payload.land.grassland_area_ha", object.get(land, "grassland_area_ha", null)],
    ["payload.land.parcels[]", parcels],
  ])
  count(missing_keys) > 0
}

# decision-trace-condition: minimum_grassland_area_not_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_grassland_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_grassland_area_not_met",
    "paths": ["payload.land.grassland_area_ha"],
    "actual_values": {"payload.land.grassland_area_ha": grassland_area},
  }],
  "satisfied_conditions": [],
} if {
  o6_17_required_inputs_complete
  grassland_area := object.get(land, "grassland_area_ha", null)
  grassland_area != null
  grassland_area < 2.0
}

# decision-trace-condition: total_area_must_be_positive
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "missing_data",
  "missing_keys": ["payload.land.total_area_ha"],
  "reasons": ["total_area_must_be_positive"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_17_required_inputs_complete
  total_area := object.get(land, "total_area_ha", null)
  grassland_area := object.get(land, "grassland_area_ha", null)
  total_area != null
  grassland_area >= 2.0
  total_area <= 0
}

# decision-trace-condition: minimum_grassland_share_not_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_grassland_share_not_met"],
  "failed_conditions": [{
    "code": "minimum_grassland_share_not_met",
    "paths": ["payload.land.total_area_ha", "payload.land.grassland_area_ha"],
    "actual_values": {
      "payload.land.total_area_ha": total_area,
      "payload.land.grassland_area_ha": grassland_area,
    },
  }],
  "satisfied_conditions": [],
} if {
  o6_17_required_inputs_complete
  total_area := object.get(land, "total_area_ha", null)
  grassland_area := object.get(land, "grassland_area_ha", null)
  total_area != null
  grassland_area != null
  grassland_area >= 2.0
  total_area > 0
  grassland_area / total_area < 0.4
}

# decision-trace-condition: no_grassland_parcels_available
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].land_use"],
  "reasons": ["no_grassland_parcels_available"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_17_required_inputs_complete
  o6_17_baseline_thresholds_met
  count(grassland_parcels) == 0
}

# decision-trace-condition: grassland_slope_data_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].slope_percent"],
  "reasons": ["grassland_slope_data_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  o6_17_required_inputs_complete
  o6_17_baseline_thresholds_met
  count(grassland_parcels) > 0
  not has_grassland_slope
}

# decision-trace-condition: pre_2025_requires_grassland_below_18_percent_slope
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["pre_2025_requires_grassland_below_18_percent_slope"],
  "failed_conditions": [{
    "code": "pre_2025_requires_grassland_below_18_percent_slope",
    "paths": ["payload.farm.year", "payload.land.parcels[].slope_percent"],
    "actual_values": {
      "payload.farm.year": farm_year,
      "grassland_parcel_slopes": grassland_parcel_slopes,
    },
  }],
  "satisfied_conditions": [],
} if {
  o6_17_required_inputs_complete
  farm_year := object.get(farm, "year", null)
  farm_year != null
  farm_year < 2025
  o6_17_baseline_thresholds_met
  count(grassland_parcels) > 0
  has_grassland_slope
  not has_pre_2025_eligible_grassland_slope
}

# decision-trace-condition: grassland_slope_baseline_met_2025_or_later
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "grassland_slope_baseline_met_2025_or_later",
    "paths": [
      "payload.farm.year",
      "payload.land.total_area_ha",
      "payload.land.grassland_area_ha",
      "payload.land.parcels[].slope_percent",
    ],
    "actual_values": {
      "payload.farm.year": farm_year,
      "payload.land.total_area_ha": object.get(land, "total_area_ha", null),
      "payload.land.grassland_area_ha": object.get(land, "grassland_area_ha", null),
      "grassland_parcel_slopes": grassland_parcel_slopes,
    },
  }],
} if {
  o6_17_required_inputs_complete
  farm_year := object.get(farm, "year", null)
  farm_year != null
  farm_year >= 2025
  o6_17_baseline_thresholds_met
  count(grassland_parcels) > 0
  has_grassland_slope
}

# decision-trace-condition: pre_2025_grassland_below_18_percent_slope_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_17_result := {
  "measure_id": "o6_17",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "pre_2025_grassland_below_18_percent_slope_met",
    "paths": [
      "payload.farm.year",
      "payload.land.total_area_ha",
      "payload.land.grassland_area_ha",
      "payload.land.parcels[].slope_percent",
    ],
    "actual_values": {
      "payload.farm.year": farm_year,
      "payload.land.total_area_ha": object.get(land, "total_area_ha", null),
      "payload.land.grassland_area_ha": object.get(land, "grassland_area_ha", null),
      "grassland_parcel_slopes": grassland_parcel_slopes,
    },
  }],
} if {
  o6_17_required_inputs_complete
  farm_year := object.get(farm, "year", null)
  farm_year != null
  farm_year < 2025
  o6_17_baseline_thresholds_met
  count(grassland_parcels) > 0
  has_pre_2025_eligible_grassland_slope
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_19_result := {
  "measure_id": "o6_19",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[]"],
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  parcels == null
}

# decision-trace-condition: eligible_parcel_classification_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_19_result := {
  "measure_id": "o6_19",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].land_use"],
  "reasons": ["eligible_parcel_classification_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == null
}

# decision-trace-condition: eligible_parcel_area_missing
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_19_result := {
  "measure_id": "o6_19",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[].area_ha"],
  "reasons": ["eligible_parcel_area_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  not o6_19_has_missing_land_use
  some parcel in parcels
  eligible_o6_19_land_use(object.get(parcel, "land_use", null))
  object.get(parcel, "area_ha", null) == null
}

# decision-trace-condition: minimum_eligible_area_not_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_19_result := {
  "measure_id": "o6_19",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["minimum_eligible_area_not_met"],
  "failed_conditions": [{
    "code": "minimum_eligible_area_not_met",
    "paths": ["payload.land.parcels[].area_ha"],
    "actual_values": {"eligible_parcel_area_sum_ha": o6_19_eligible_area},
  }],
  "satisfied_conditions": [],
} if {
  not o6_19_has_missing_land_use
  not o6_19_has_missing_area
  o6_19_eligible_area < 1.0
}

# decision-trace-condition: minimum_eligible_area_met
# Stable, non-semantic anchor comment (Issue #98 DecisionTrace v1); see note
# above the first o6_1a_result branch.
o6_19_result := {
  "measure_id": "o6_19",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["phase1_baseline_check_passed"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "minimum_eligible_area_met",
    "paths": ["payload.land.parcels[].area_ha"],
    "actual_values": {"eligible_parcel_area_sum_ha": o6_19_eligible_area},
  }],
} if {
  not o6_19_has_missing_land_use
  not o6_19_has_missing_area
  o6_19_eligible_area >= 1.0
}

o6_2_result := c_measure_result("o6_2", [
  ["payload.land.parcels[].operations.psm_used", parcel_psm_used_values],
  ["payload.land.aggregate.nitrogen_input_kg_per_ha", object.get(aggregate, "nitrogen_input_kg_per_ha", null)],
  ["payload.documentation.nutrient_balance_complete", object.get(documentation, "nutrient_balance_complete", null)],
])

o6_3_result := c_measure_result("o6_3", [
  ["payload.land.parcels[].operations.cutting_dates", parcel_cutting_date_values],
  ["payload.oepul.shared.parcels[].management_events", shared_parcel_management_event_values],
])

o6_4_result := c_measure_result("o6_4", [
  ["payload.land.parcels[].operations.cutting_dates", parcel_cutting_date_values],
  ["payload.oepul.shared.parcels[].oepul_codes", shared_parcel_oepul_code_values],
])

# o6_9 access check (Informationsblatt Juni 2026, 3.1 VERTRAGSZEITRAUM and
# 3.2 MINDESTTEILNAHME): participation needs, in every year, a declared
# quantity for one of the three near-ground application methods or for
# cattle slurry separation, or participation in the pig feeding category.
# Declared quantities are behaviour, not farm structure: a farm without a
# declared quantity could still start, so the absence of a quantity is never
# not_eligible, only missing_data.
o6_9 := object.get(oepul_measures, "o6_9", {})

o6_9_declared_volumes := object.get(o6_9, "declared_volumes_m3", {})

o6_9_volume_paths := [
  "payload.oepul.measures.o6_9.declared_volumes_m3.trailing_hose",
  "payload.oepul.measures.o6_9.declared_volumes_m3.trailing_shoe",
  "payload.oepul.measures.o6_9.declared_volumes_m3.injection",
  "payload.oepul.measures.o6_9.declared_volumes_m3.separated_cattle_slurry",
]

o6_9_volume_values := {
  "payload.oepul.measures.o6_9.declared_volumes_m3.trailing_hose": object.get(o6_9_declared_volumes, "trailing_hose", null),
  "payload.oepul.measures.o6_9.declared_volumes_m3.trailing_shoe": object.get(o6_9_declared_volumes, "trailing_shoe", null),
  "payload.oepul.measures.o6_9.declared_volumes_m3.injection": object.get(o6_9_declared_volumes, "injection", null),
  "payload.oepul.measures.o6_9.declared_volumes_m3.separated_cattle_slurry": object.get(o6_9_declared_volumes, "separated_cattle_slurry", null),
}

o6_9_positive_volume_m3 := sum([value |
  some path in o6_9_volume_paths
  value := o6_9_volume_values[path]
  is_number(value)
  value > 0
])

o6_9_declaration_present if {
  object.get(o6_9, "mfa_declaration_present", null) == true
}

o6_9_declaration_present if {
  some path in o6_9_volume_paths
  is_number(o6_9_volume_values[path])
}

# decision-trace-condition: minimum_participation_met
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch.
o6_9_result := {
  "measure_id": "o6_9",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["minimum_participation_met"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "minimum_participation_met",
    "paths": o6_9_volume_paths,
    "actual_values": {"declared_volume_sum_m3": o6_9_positive_volume_m3},
  }],
} if {
  o6_9_positive_volume_m3 > 0
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch.
o6_9_result := {
  "measure_id": "o6_9",
  "status": "missing_data",
  "missing_keys": o6_9_volume_paths,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  not o6_9_positive_volume_m3 > 0
  not o6_9_declaration_present
}

# decision-trace-condition: minimum_participation_not_evidenced
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch. A declaration exists but names no positive
# quantity: the farm may still start a category, so this stays missing_data.
o6_9_result := {
  "measure_id": "o6_9",
  "status": "missing_data",
  "missing_keys": o6_9_volume_paths,
  "reasons": ["minimum_participation_not_evidenced"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  not o6_9_positive_volume_m3 > 0
  o6_9_declaration_present
}

o6_11_result := c_measure_result("o6_11", [
  ["payload.land.parcels[].operations.psm_used", parcel_psm_used_values],
  ["payload.oepul.shared.parcels[].psm_applications", shared_parcel_psm_application_values],
])

o6_12_result := c_measure_result("o6_12", [
  ["payload.land.parcels[].operations.psm_used", parcel_psm_used_values],
  ["payload.oepul.shared.parcels[].psm_applications", shared_parcel_psm_application_values],
])

o6_13_result := c_measure_result("o6_13", [
  ["payload.oepul.measures.o6_13.parcels[].is_protected_cultivation", o6_13_protected_cultivation_values],
  ["payload.oepul.measures.o6_13.beneficials", o6_13_beneficial_values],
])

o6_15_result := c_measure_result("o6_15", [
  ["payload.oepul.measures.o6_15.behirtung_days", o6_15_behirtung_days],
  ["payload.land.alpine_pasture_area_ha", object.get(land, "alpine_pasture_area_ha", null)],
])

# o6_16 access check (Informationsblatt April 2026, 3.3 MINDESTTEILNAHME):
# at least 2,00 ha arable land inside the Gebietskulisse of SRL ÖPUL 2023
# Anhang G in the first participation year. The Gebietskulisse is a list of
# cadastral communities (KG numbers, backend/policy/oepul_reference/
# o6_16_gebietskulisse/data.json); a parcel counts with its AMA
# "max Schlag Katastralgemeinde Nummer". The optional pig feeding supplement
# also funds arable land outside the Gebietskulisse, so a farm below the
# area threshold that may reach 1,00 GVE pigs per ha arable land stays
# missing_data until `pig_feeding_supplement_planned` is answered; only an
# explicit `false` closes that route.
o6_16 := object.get(oepul_measures, "o6_16", {})

o6_16_pig_feeding_supplement_planned := object.get(o6_16, "pig_feeding_supplement_planned", null)

o6_16_zone_kg_numbers := {number | some number in data.oepul_reference.o6_16_gebietskulisse.kg_numbers}

o6_16_zone_area_ha := sum([area |
  some parcel in parcels
  object.get(parcel, "land_use", null) == "arable"
  o6_16_zone_kg_numbers[object.get(parcel, "cadastral_community_number", null)]
  area := object.get(parcel, "area_ha", null)
  is_number(area)
])

o6_16_unresolved_parcel_keys contains "payload.land.parcels[].land_use" if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == null
}

o6_16_unresolved_parcel_keys contains "payload.land.parcels[].cadastral_community_number" if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == "arable"
  object.get(parcel, "cadastral_community_number", null) == null
}

o6_16_unresolved_parcel_keys contains "payload.land.parcels[].area_ha" if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == "arable"
  object.get(parcel, "area_ha", null) == null
}

o6_16_pig_gve := sum([gve |
  some group in species_groups
  object.get(group, "species", null) == "pigs"
  gve := object.get(group, "gve", null)
  is_number(gve)
])

o6_16_pig_route_open if {
  some group in species_groups
  object.get(group, "species", null) == "pigs"
  not is_number(object.get(group, "gve", null))
}

o6_16_pig_route_open if {
  o6_16_pig_gve > 0
  arable_area := object.get(land, "arable_area_ha", null)
  not is_number(arable_area)
}

o6_16_pig_route_open if {
  arable_area := object.get(land, "arable_area_ha", null)
  is_number(arable_area)
  arable_area > 0
  o6_16_pig_gve / arable_area >= 1.0
}

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch.
o6_16_result := {
  "measure_id": "o6_16",
  "status": "missing_data",
  "missing_keys": ["payload.land.parcels[]"],
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  required_value_missing(parcels)
}

# decision-trace-condition: zone_minimum_area_met
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch.
o6_16_result := {
  "measure_id": "o6_16",
  "status": "eligible",
  "missing_keys": [],
  "reasons": ["zone_minimum_area_met"],
  "failed_conditions": [],
  "satisfied_conditions": [{
    "code": "zone_minimum_area_met",
    "paths": ["payload.land.parcels[].cadastral_community_number", "payload.land.parcels[].area_ha"],
    "actual_values": {"zone_arable_area_ha": o6_16_zone_area_ha},
  }],
} if {
  not required_value_missing(parcels)
  o6_16_zone_area_ha >= 2.0
}

# decision-trace-condition: zone_parcel_inputs_missing
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch.
o6_16_result := {
  "measure_id": "o6_16",
  "status": "missing_data",
  "missing_keys": sort([key | some key in o6_16_unresolved_parcel_keys]),
  "reasons": ["zone_parcel_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  not required_value_missing(parcels)
  o6_16_zone_area_ha < 2.0
  count(o6_16_unresolved_parcel_keys) > 0
}

# decision-trace-condition: pig_feeding_supplement_route_open
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch.
o6_16_result := {
  "measure_id": "o6_16",
  "status": "missing_data",
  "missing_keys": ["payload.oepul.measures.o6_16.pig_feeding_supplement_planned"],
  "reasons": ["pig_feeding_supplement_route_open"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  not required_value_missing(parcels)
  o6_16_zone_area_ha < 2.0
  count(o6_16_unresolved_parcel_keys) == 0
  o6_16_pig_route_open
  o6_16_pig_feeding_supplement_planned != false
}

# decision-trace-condition: zone_minimum_area_not_met
# Stable, non-semantic anchor comment (DecisionTrace v1); see note above the
# first o6_1a_result branch.
o6_16_result := {
  "measure_id": "o6_16",
  "status": "not_eligible",
  "missing_keys": [],
  "reasons": ["zone_minimum_area_not_met"],
  "failed_conditions": [{
    "code": "zone_minimum_area_not_met",
    "paths": ["payload.land.parcels[].cadastral_community_number", "payload.land.parcels[].area_ha"],
    "actual_values": {"zone_arable_area_ha": o6_16_zone_area_ha},
  }],
  "satisfied_conditions": [],
} if {
  not required_value_missing(parcels)
  o6_16_zone_area_ha < 2.0
  count(o6_16_unresolved_parcel_keys) == 0
  not o6_16_pig_route_still_open
}

o6_16_pig_route_still_open if {
  o6_16_pig_route_open
  o6_16_pig_feeding_supplement_planned != false
}

o6_18_result := c_measure_result("o6_18", [
  ["payload.land.parcels[].operations.cutting_dates", parcel_cutting_date_values],
  ["payload.land.parcels[].operations.psm_used", parcel_psm_used_values],
  ["payload.land.aggregate.nitrogen_input_kg_per_ha", object.get(aggregate, "nitrogen_input_kg_per_ha", null)],
  ["payload.oepul.shared.parcels[].project_confirmation_codes", shared_parcel_project_confirmation_values],
])

o6_20_result := c_measure_result("o6_20", [
  ["payload.livestock.species_groups[].housing.pasture.weide_hours_per_day", pasture_weide_hours_values],
  ["payload.livestock.species_groups[].housing.pasture.water_availability", pasture_water_availability_values],
  ["payload.oepul.shared.livestock_events", shared_livestock_events],
])

o6_21_result := c_measure_result("o6_21", [
  ["payload.livestock.species_groups[].housing.stall.stall_area_m2", stall_area_values],
  ["payload.livestock.species_groups[].housing.stall.floor_type", stall_floor_type_values],
  ["payload.livestock.species_groups[].housing.stall.bedding_type", stall_bedding_type_values],
  ["payload.livestock.species_groups[].housing.stall.daylight_percentage", stall_daylight_percentage_values],
])

o6_22_result := c_measure_result("o6_22", [
  ["payload.livestock.species_groups[].housing.stall.stall_area_m2", stall_area_values],
  ["payload.livestock.species_groups[].housing.stall.floor_type", stall_floor_type_values],
  ["payload.livestock.species_groups[].housing.stall.bedding_type", stall_bedding_type_values],
])

o6_23_result := c_measure_result("o6_23", [
  ["payload.farm.region.is_protected_area", object.get(farm_region, "is_protected_area", null)],
  ["payload.oepul.shared.parcels[].project_confirmation_codes", shared_parcel_project_confirmation_values],
  ["payload.land.parcels[].operations.cutting_dates", parcel_cutting_date_values],
])

o6_24_result := c_measure_result("o6_24", [
  ["payload.land.aggregate.nitrogen_input_kg_per_ha", object.get(aggregate, "nitrogen_input_kg_per_ha", null)],
  ["payload.documentation.nutrient_balance_complete", object.get(documentation, "nutrient_balance_complete", null)],
])

o6_1a_required_inputs_complete if {
  count(missing_keys_from_pairs([
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.grassland_area_ha", object.get(land, "grassland_area_ha", null)],
    ["payload.land.aggregate.existing_biodiversity_area_ha", object.get(aggregate, "existing_biodiversity_area_ha", null)],
  ])) == 0
}

o6_1b_required_inputs_complete if {
  count(missing_keys_from_pairs([
    ["payload.farm.certifications.organic.is_certified", organic_certification],
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.grassland_area_ha", object.get(land, "grassland_area_ha", null)],
    ["payload.land.special_crops_area_ha", object.get(land, "special_crops_area_ha", null)],
  ])) == 0
}

o6_1c_required_inputs_complete if {
  count(missing_keys_from_pairs([
    ["payload.land.arable_area_ha", object.get(land, "arable_area_ha", null)],
    ["payload.land.parcels[]", parcels],
  ])) == 0
}

o6_17_required_inputs_complete if {
  count(missing_keys_from_pairs([
    ["payload.farm.year", object.get(farm, "year", null)],
    ["payload.land.total_area_ha", object.get(land, "total_area_ha", null)],
    ["payload.land.grassland_area_ha", object.get(land, "grassland_area_ha", null)],
    ["payload.land.parcels[]", parcels],
  ])) == 0
}

missing_keys_from_pairs(pairs) := [key |
  some pair in pairs
  pair[1] == null
  key := pair[0]
]

missing_required_keys_from_pairs(pairs) := [key |
  some pair in pairs
  required_value_missing(pair[1])
  key := pair[0]
]

# decision-trace-condition: required_inputs_missing
# Stable, non-semantic anchor comment (Issue #100 DecisionTrace v1): this
# shared helper backs all thirteen Category C conservative measures
# (o6_2/o6_3/o6_4/o6_11/o6_12/o6_13/o6_15/o6_18/o6_20/o6_21/o6_22/o6_23/
# o6_24) alike -- never a per-measure branch -- so one marker
# here anchors every one of those measures' own "required_inputs_missing"
# catalog entry via the shared rule_name "c_measure_result". Do not
# remove/rename without updating
# backend/app/review/adapters/oepul/rego_rules.py/catalog.py.
c_measure_result(measure_id, pairs) := {
  "measure_id": measure_id,
  "status": "missing_data",
  "missing_keys": missing_keys,
  "reasons": ["required_inputs_missing"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_required_keys_from_pairs(pairs)
  count(missing_keys) > 0
}

# decision-trace-condition: category_c_conservative_missing_data
# Stable, non-semantic anchor comment (Issue #100 DecisionTrace v1); see note
# above. This branch is a technical coverage limitation of the checked-in
# policy (no formalised eligibility rule yet for any of the thirteen measures
# this helper backs), not a normative rule: the DecisionTrace adapter must
# never attach a normative source reference to it.
c_measure_result(measure_id, pairs) := {
  "measure_id": measure_id,
  "status": "missing_data",
  "missing_keys": [],
  "reasons": ["category_c_conservative_missing_data"],
  "failed_conditions": [],
  "satisfied_conditions": [],
} if {
  missing_keys := missing_required_keys_from_pairs(pairs)
  count(missing_keys) == 0
}

required_value_missing(value) if {
  value == null
}

required_value_missing(value) if {
  type_name(value) == "array"
  count(value) == 0
}

parcel_psm_used_values := [value |
  some parcel in parcels
  operations := object.get(parcel, "operations", {})
  value := object.get(operations, "psm_used", null)
  value != null
]

parcel_cutting_date_values := [date |
  some parcel in parcels
  operations := object.get(parcel, "operations", {})
  cutting_dates := object.get(operations, "cutting_dates", [])
  some date in cutting_dates
]

shared_parcel_oepul_code_values := [code |
  some parcel in shared_parcels
  codes := object.get(parcel, "oepul_codes", [])
  some code in codes
]

shared_parcel_management_event_values := [event |
  some parcel in shared_parcels
  events := object.get(parcel, "management_events", [])
  some event in events
]

shared_parcel_psm_application_values := [application |
  some parcel in shared_parcels
  applications := object.get(parcel, "psm_applications", [])
  some application in applications
]

shared_parcel_project_confirmation_values := [code |
  some parcel in shared_parcels
  codes := object.get(parcel, "project_confirmation_codes", [])
  some code in codes
]

o6_13_protected_cultivation_values := [flag |
  o6_13_measure := object.get(oepul_measures, "o6_13", {})
  protected_parcels := object.get(o6_13_measure, "parcels", [])
  some parcel in protected_parcels
  flag := object.get(parcel, "is_protected_cultivation", null)
  flag != null
]

o6_13_beneficial_values := [beneficial |
  o6_13_measure := object.get(oepul_measures, "o6_13", {})
  beneficials := object.get(o6_13_measure, "beneficials", [])
  some beneficial in beneficials
]

o6_15_behirtung_days := object.get(object.get(oepul_measures, "o6_15", {}), "behirtung_days", null)

pasture_weide_hours_values := [hours |
  some group in species_groups
  housing := object.get(group, "housing", {})
  pasture := object.get(housing, "pasture", {})
  hours := object.get(pasture, "weide_hours_per_day", null)
  hours != null
]

pasture_water_availability_values := [value |
  some group in species_groups
  housing := object.get(group, "housing", {})
  pasture := object.get(housing, "pasture", {})
  value := object.get(pasture, "water_availability", null)
  value != null
]

stall_area_values := [value |
  some group in species_groups
  housing := object.get(group, "housing", {})
  stall := object.get(housing, "stall", {})
  value := object.get(stall, "stall_area_m2", null)
  value != null
]

stall_floor_type_values := [value |
  some group in species_groups
  housing := object.get(group, "housing", {})
  stall := object.get(housing, "stall", {})
  value := object.get(stall, "floor_type", null)
  value != null
]

stall_bedding_type_values := [value |
  some group in species_groups
  housing := object.get(group, "housing", {})
  stall := object.get(housing, "stall", {})
  value := object.get(stall, "bedding_type", null)
  value != null
]

stall_daylight_percentage_values := [value |
  some group in species_groups
  housing := object.get(group, "housing", {})
  stall := object.get(housing, "stall", {})
  value := object.get(stall, "daylight_percentage", null)
  value != null
]

manure_incorporation_time_values := [value |
  some group in species_groups
  manure := object.get(group, "manure", {})
  value := object.get(manure, "incorporation_time_hours", null)
  value != null
]

nh3_reduction_percent_values := [value |
  some group in species_groups
  nh3_reduction := object.get(group, "nh3_reduction", {})
  value := object.get(nh3_reduction, "ammonia_reduction_percent", null)
  value != null
]

eligible_o6_19_land_use(land_use) if {
  land_use == "arable"
}

eligible_o6_19_land_use(land_use) if {
  land_use == "grassland"
}

o6_17_baseline_thresholds_met if {
  total_area := object.get(land, "total_area_ha", null)
  grassland_area := object.get(land, "grassland_area_ha", null)
  total_area > 0
  grassland_area >= 2.0
  grassland_area / total_area >= 0.4
}

o6_19_eligible_area := sum([area |
  some parcel in parcels
  eligible_o6_19_land_use(object.get(parcel, "land_use", null))
  area := object.get(parcel, "area_ha", null)
  area != null
])

o6_19_has_missing_land_use if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == null
}

o6_19_has_missing_area if {
  some parcel in parcels
  eligible_o6_19_land_use(object.get(parcel, "land_use", null))
  object.get(parcel, "area_ha", null) == null
}

has_o6_1b_relevant_land if {
  object.get(land, "arable_area_ha", null) > 0
}

has_o6_1b_relevant_land if {
  object.get(land, "grassland_area_ha", null) > 0
}

has_o6_1b_relevant_land if {
  object.get(land, "special_crops_area_ha", null) > 0
}

has_non_arable_relevant_land if {
  object.get(land, "grassland_area_ha", null) > 0
}

has_non_arable_relevant_land if {
  object.get(land, "special_crops_area_ha", null) > 0
}

has_positive_greening_proxy if {
  object.get(aggregate, "begruenungsflaeche_ha", null) > 0
}

has_positive_greening_proxy if {
  object.get(aggregate, "soil_cover", null) == true
}

supported_livestock_groups contains group if {
  some group in species_groups
  species := object.get(group, "species", null)
  species != null
  species != "other"
}

supported_group_species_complete if {
  not some_species_group_missing_species
}

supported_group_animal_counts_complete if {
  not some_supported_group_missing_animal_count
}

has_supported_positive_animal_count if {
  some group in supported_livestock_groups
  object.get(group, "animal_count", null) > 0
}

# Named collection for condition evidence: a raw wildcard payload path (e.g.
# "payload.livestock.species_groups[].species") cannot be a literal
# actual_values key, so the observed species/count pairs actually inspected
# by the no_supported_species_group_found condition are exposed under this
# explicit, stable aggregate key instead (Issue #37 corrective slice 7).
#
# Iterates over every observed `species_groups` entry, not only the
# already-filtered `supported_livestock_groups` subset (species != null and
# != "other"): the no_supported_species_group_found condition is genuinely
# about why none of the observed groups qualified, so a group with an
# unsupported species value (e.g. "other") must remain visible as evidence
# instead of silently disappearing when the filtered set is empty
# (independent-review follow-up finding, 2026-07-21).
livestock_group_species_and_counts := [entry |
  some group in species_groups
  entry := {
    "species": object.get(group, "species", null),
    "animal_count": object.get(group, "animal_count", null),
  }
]

total_supported_livestock_gve := sum([gve |
  some group in supported_livestock_groups
  gve := object.get(group, "gve", null)
  gve != null
]) if {
  count([gve |
    some group in supported_livestock_groups
    gve := object.get(group, "gve", null)
    gve != null
  ]) > 0
}

total_supported_livestock_gve := null if {
  count([gve |
    some group in supported_livestock_groups
    gve := object.get(group, "gve", null)
    gve != null
  ]) == 0
}

max_supported_grazing_days := max([days |
  some group in supported_livestock_groups
  pasture := object.get(object.get(group, "housing", {}), "pasture", {})
  days := object.get(pasture, "weide_days_per_year", null)
  days != null
]) if {
  count([days |
    some group in supported_livestock_groups
    pasture := object.get(object.get(group, "housing", {}), "pasture", {})
    days := object.get(pasture, "weide_days_per_year", null)
    days != null
  ]) > 0
}

max_supported_grazing_days := null if {
  count([days |
    some group in supported_livestock_groups
    pasture := object.get(object.get(group, "housing", {}), "pasture", {})
    days := object.get(pasture, "weide_days_per_year", null)
    days != null
  ]) == 0
}

arable_parcels contains parcel if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == "arable"
}

grassland_parcels contains parcel if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == "grassland"
}

special_crop_parcels contains parcel if {
  some parcel in parcels
  object.get(parcel, "land_use", null) == "special_crop"
}

any_arable_proxy_signal if {
  some parcel in arable_parcels
  object.get(parcel, "is_nonproductive_area", null) == true
}

any_arable_proxy_signal if {
  some parcel in arable_parcels
  object.get(parcel, "is_agroforestry_strip", null) == true
}

some_species_group_missing_species if {
  some group in species_groups
  object.get(group, "species", null) == null
}

some_supported_group_missing_animal_count if {
  some group in supported_livestock_groups
  object.get(group, "animal_count", null) == null
}

arable_nonproductive_proxy_missing if {
  some parcel in arable_parcels
  object.get(parcel, "is_nonproductive_area", null) == null
}

any_arable_nonproductive_proxy_complete if {
  count(arable_parcels) > 0
  not arable_nonproductive_proxy_missing
}

arable_agroforestry_proxy_missing if {
  some parcel in arable_parcels
  object.get(parcel, "is_agroforestry_strip", null) == null
}

any_arable_agroforestry_proxy_complete if {
  count(arable_parcels) > 0
  not arable_agroforestry_proxy_missing
}

# Named collection for condition evidence: the observed nonproductive/
# agroforestry proxy flags per arable parcel, used by
# no_nonproductive_or_agroforestry_proxy_detected (only reachable when both
# proxy flags are complete for every arable parcel).
arable_parcel_proxy_flags := [entry |
  some parcel in arable_parcels
  entry := {
    "parcel_id": object.get(parcel, "parcel_id", null),
    "is_nonproductive_area": object.get(parcel, "is_nonproductive_area", null),
    "is_agroforestry_strip": object.get(parcel, "is_agroforestry_strip", null),
  }
]

has_arable_slope if {
  some parcel in arable_parcels
  object.get(parcel, "slope_percent", null) != null
}

# Named collection for condition evidence: only the arable parcels with a
# known slope_percent (a raw wildcard path cannot be a literal actual_values
# key), used by o6_8's erosion_practice_signal_detected eligible branch.
arable_parcel_slopes := [entry |
  some parcel in arable_parcels
  slope := object.get(parcel, "slope_percent", null)
  slope != null
  entry := {
    "parcel_id": object.get(parcel, "parcel_id", null),
    "slope_percent": slope,
  }
]

has_grassland_slope if {
  some parcel in grassland_parcels
  object.get(parcel, "slope_percent", null) != null
}

has_pre_2025_eligible_grassland_slope if {
  some parcel in grassland_parcels
  slope := object.get(parcel, "slope_percent", null)
  slope != null
  slope < 18
}

# Named collection for condition evidence: only the grassland parcels with a
# known slope_percent are included (a raw wildcard path cannot be a literal
# actual_values key, and a parcel with no known slope contributed nothing to
# the pre_2025_requires_grassland_below_18_percent_slope condition).
grassland_parcel_slopes := [entry |
  some parcel in grassland_parcels
  slope := object.get(parcel, "slope_percent", null)
  slope != null
  entry := {
    "parcel_id": object.get(parcel, "parcel_id", null),
    "slope_percent": slope,
  }
]

special_crop_slopes_complete if {
  count(special_crop_parcels) > 0
  not special_crop_slope_missing
}

special_crop_slope_missing if {
  some parcel in special_crop_parcels
  object.get(parcel, "slope_percent", null) == null
}

has_special_crop_slope_at_or_above_25 if {
  some parcel in special_crop_parcels
  slope := object.get(parcel, "slope_percent", null)
  slope != null
  slope >= 25
}

# Named collection for condition evidence: every special-crop parcel's
# slope_percent, used by minimum_slope_requirement_not_met (only reachable
# when special_crop_slopes_complete, i.e. every special-crop parcel's slope
# is known).
special_crop_parcel_slopes := [entry |
  some parcel in special_crop_parcels
  entry := {
    "parcel_id": object.get(parcel, "parcel_id", null),
    "slope_percent": object.get(parcel, "slope_percent", null),
  }
]

has_erosion_practice_signal if {
  tillage_type := object.get(aggregate, "tillage_type", null)
  tillage_type == "direct_seed_or_strip_till"
}

has_erosion_practice_signal if {
  tillage_type := object.get(aggregate, "tillage_type", null)
  tillage_type == "mulch_seed"
}

has_erosion_practice_signal if {
  object.get(aggregate, "soil_cover", null) == true
}

has_erosion_practice_signal if {
  object.get(aggregate, "mulchsaat_technology_available", null) == true
}
