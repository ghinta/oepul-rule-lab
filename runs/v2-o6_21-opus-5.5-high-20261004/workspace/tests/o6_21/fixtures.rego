# Testfixtures für o6_21 (Tierwohl – Stallhaltung Rinder).
package oepul.o6_21.fixtures

paved_building := {
	"is_fixed_building": true,
	"enclosed_sides_count": 4,
	"lying_area_roofed": true,
	"floor_material": "concrete",
	"liquid_excreta_occur": false,
}

compartment(cid, area, bedded) := {
	"compartment_id": cid,
	"usable_paved_area_m2": area,
	"bedded_lying_area_m2": bedded,
	"lying_area_perforation_percent": 0,
	"lying_surface_material": "paved",
	"bedding_depth_cm": 5,
	"bedding_soft_and_dry": true,
	"group_housing": true,
	"bedded_system": true,
	"building": paved_building,
}

bull(tag, weight) := {
	"ear_tag": tag,
	"sex": "male",
	"birth_date": "2024-01-01",
	"on_farm_from": "2024-01-01",
	"on_farm_until": null,
	"current_weight_kg": weight,
	"stall_compartment_id": "B1",
}

applicant := {
	"person_type": "natural_person",
	"is_active_farmer": true,
	"manages_farm_in_own_name_and_account": true,
}

full_year(y) := {"participating": true, "from": sprintf("%d-01-01", [y]), "until": sprintf("%d-12-31", [y])}

# Basisbetrieb 2025: vier Stiere (½–2 Jahre) in Box B1, Kategorie männliche Rinder ab ½ Jahr.
base := {
	"farm": {
		"year": 2025,
		"applicant": applicant,
		"programmes": {"animal_health_service_cattle": full_year(2025)},
		"dairy": {"milk_delivery_to_dairy": false},
	},
	"land": {"total_area_ha": 50},
	"livestock": {
		"cattle_animals": [bull("AT1", 520), bull("AT2", 520), bull("AT3", 520), bull("AT4", 520)],
		"stall_compartments": [compartment("B1", 16.8, 6.72)],
	},
	"oepul_measures": {"o6_21": {"categories": [{"category_id": "male_ge_half_year", "applied_on": "2023-12-10", "first_year": 2024}]}},
}

with_animals(inp, list) := json.patch(inp, [{"op": "replace", "path": "/livestock/cattle_animals", "value": list}])

with_compartments(inp, list) := json.patch(inp, [{"op": "replace", "path": "/livestock/stall_compartments", "value": list}])

with_measure(inp, obj) := json.patch(inp, [{"op": "replace", "path": "/oepul_measures/o6_21", "value": obj}])

with_year(inp, y) := json.patch(inp, [{"op": "replace", "path": "/farm/year", "value": y}])

set_path(inp, path, value) := json.patch(inp, [{"op": "add", "path": path, "value": value}])

good_windrow := {
	"windrow_id": "W1",
	"method": "turned",
	"documented_set_up": true,
	"documented_turnings": true,
	"turnings": [
		{"date": "2025-05-01", "equipment": "compost_turner"},
		{"date": "2025-05-15", "equipment": "compost_turner"},
	],
}

composting(windrows) := {
	"all_solid_manure_composted_on_farm": true,
	"compost_turner_on_farm": true,
	"documented_application_or_transfer": true,
	"windrows": windrows,
}

with_supplement(inp, windrows) := json.patch(inp, [
	{"op": "add", "path": "/livestock/solid_manure_composting", "value": composting(windrows)},
	{"op": "add", "path": "/oepul_measures/o6_21/composting_supplement", "value": {"applied_on": "2024-12-10", "first_year": 2025}},
])
