# METADATA
# title: o6_17 Humuserhalt und Bodenschutz auf umbruchsfähigem Grünland – Basis
# description: >-
#   Gemeinsame Hilfsregeln, Vertragszeitraum, Kombinationsverpflichtung und
#   Zugangsvoraussetzungen (Merkblatt o6_17 Kap. 3-5, SRL 2.17, SRL 1.5.4, 1.7.1.2).
package oepul.o6_17

import rego.v1

tables := data.o6_17

year := input.farm.year

measure := object.get(input, ["farm", "oepul", "o6_17"], {})

parcels := object.get(input, ["land", "parcels"], [])

livestock_groups := object.get(input, ["livestock", "species_groups"], [])

field_use_types := {f.code: f | some f in tables.lists.field_use_types}

parcel_field_use(p) := object.get(p, ["oepul", "field_use_type"], "")

parcel_codes(p) := {c | some c in object.get(p, ["oepul", "codes"], [])}

parcel_measures(p) := {m | some m in object.get(p, ["oepul", "measures"], [])}

is_grassland(p) if p.land_use == "grassland"

# ---------------------------------------------------------------------------
# Vertragszeitraum (Merkblatt 3.1; Allg. Bedingungen 5.9; SRL 1.7.1.2)
# ---------------------------------------------------------------------------

contract_start_year := object.get(measure, "contract_start_year", null)

contract_period := period if {
	some period in tables.contract_periods.periods
	period.start_year == contract_start_year
}

# Letzter Einstieg mit Förderjahr 2025 (Merkblatt Kap. 7).
valid_entry_year if contract_period

contract_years := contract_period.years

contract_end := tables.contract_periods.contract_end

is_first_commitment_year if year == contract_start_year

in_contract_period if {
	contract_period
	year >= contract_start_year
	year <= 2028
}

# Maßnahmenantrag bis spätestens 31.12. vor Vertragsbeginn (Merkblatt Kap. 7).
application_deadline := sprintf("%d-12-31", [contract_start_year - 1]) if contract_period

application_timely if {
	submitted := measure.measure_application_date
	is_string(submitted)
	submitted <= application_deadline
}

# Vertragszeitraum des Zuschlags artenreiches Grünland: ein Kalenderjahr.
agl_contract_period := {
	"start": sprintf("%d-01-01", [year]),
	"end": sprintf("%d-12-31", [year]),
}

# ---------------------------------------------------------------------------
# Kombinationsverpflichtung (Merkblatt 3.2; SRL 2.17 Zugangsvoraussetzungen)
# ---------------------------------------------------------------------------

farm_measures := {m.measure_id | some m in object.get(input, ["farm", "oepul", "measures"], [])}

combination_requirement_met if {
	some required in tables.lists.combination_required_measures
	required.measure_id in farm_measures
}

# ---------------------------------------------------------------------------
# Mindestteilnahme (Merkblatt 3.3)
# ---------------------------------------------------------------------------

grassland_area_ha := object.get(input, ["land", "grassland_area_ha"], 0)

ln_without_alpine_ha := object.get(input, ["land", "total_area_ha"], 0) - object.get(input, ["land", "alpine_pasture_area_ha"], 0)

grassland_share := grassland_area_ha / ln_without_alpine_ha if ln_without_alpine_ha > 0

min_grassland_area_met if grassland_area_ha >= tables.thresholds.min_grassland_ha_first_year

grassland_share_met if grassland_share >= tables.thresholds.min_grassland_share_first_year

# ---------------------------------------------------------------------------
# Tierhaltender Betrieb (Merkblatt 3.4, 4, 11; SRL 1.5.4/1.5.5; Anhang A)
# ---------------------------------------------------------------------------

rgve_factor := {c.category_id: c.rgve_per_head |
	some c in tables.rgve_key.categories
	c.rgve_per_head != null
}

group_counts_for_rgve(g) if {
	rgve_factor[g.rgve_category]
	object.get(g, "kept_in_austria", true) == true
}

rgve_total := sum([(g.animal_count * rgve_factor[g.rgve_category]) |
	some g in livestock_groups
	group_counts_for_rgve(g)
])

non_feed_grassland(p) if field_use_types[parcel_field_use(p)].feed_area == false

is_feed_parcel(p) if {
	is_grassland(p)
	not non_feed_grassland(p)
}

is_feed_parcel(p) if {
	fu := field_use_types[parcel_field_use(p)]
	fu.land_use == "arable"
	fu.feed_area == true
}

feed_area_ha := sum([p.area_ha | some p in parcels; is_feed_parcel(p)])

livestock_density := rgve_total / feed_area_ha if feed_area_ha > 0

is_livestock_farm if livestock_density >= tables.thresholds.livestock_density_min_rgve_per_ha

# ---------------------------------------------------------------------------
# Zugangsvoraussetzungen und Folgen (SRL 2.17; SRL 1.12.1.1)
# ---------------------------------------------------------------------------

access_violations contains {
	"rule_id": "O617-ACC-COMBINATION",
	"message": "Keine zeitgleiche Teilnahme an UBB (o6_1a) oder BIO (o6_1b).",
} if {
	in_contract_period
	not combination_requirement_met
}

access_violations contains {
	"rule_id": "O617-ACC-MIN-GRASSLAND",
	"message": "Im ersten Teilnahmejahr werden weniger als 2,00 ha Grünland bewirtschaftet.",
} if {
	is_first_commitment_year
	not min_grassland_area_met
}

access_violations contains {
	"rule_id": "O617-ACC-GRASSLAND-SHARE",
	"message": "Im ersten Teilnahmejahr beträgt der Grünlandanteil weniger als 40 % der LN ohne Almweideflächen.",
} if {
	is_first_commitment_year
	not grassland_share_met
}

access_violations contains {
	"rule_id": "O617-ACC-LIVESTOCK",
	"message": "Im ersten Teilnahmejahr ist die Eigenschaft als tierhaltender Betrieb (>= 0,30 RGVE/ha Futterfläche) nicht erfüllt.",
} if {
	is_first_commitment_year
	not is_livestock_farm
}

access_violations contains {
	"rule_id": "O617-APP-LAST-ENTRY",
	"message": "Vertragsbeginn liegt außerhalb der zulässigen Einstiegsjahre 2023 bis 2025.",
} if {
	contract_start_year != null
	not valid_entry_year
}

access_violations contains {
	"rule_id": "O617-APP-DEADLINE",
	"message": "Maßnahmenantrag nicht bis 31.12. vor Vertragsbeginn gestellt.",
} if {
	contract_period
	is_string(object.get(measure, "measure_application_date", null))
	not application_timely
}

access_conditions_met if count(access_violations) == 0

# Nichterfüllung im 1. Jahr: kein Vertrag; ab dem 2. Jahr: keine Prämie im betroffenen Jahr.
contract_concluded if {
	valid_entry_year
	not first_year_access_failure
}

first_year_access_failure if {
	is_first_commitment_year
	count(access_violations) > 0
}

no_premium_due_to_access if {
	not is_first_commitment_year
	count(access_violations) > 0
}
