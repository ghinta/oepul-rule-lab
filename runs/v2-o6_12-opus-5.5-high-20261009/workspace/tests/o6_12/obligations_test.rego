package oepul.o6_12_test

import data.oepul.o6_12

app(action, chem, bio) := {"date": "2026-06-01", "action_type": action, "chemical_synthetic": chem, "eu_2018_848_permitted": bio, "product_name": "X"}

test_chemical_insecticide_is_prohibited if {
	p := object.union(vineyard, {"psm_applications": [app("insecticide", true, false)]})
	inp := with_parcels([p])
	count(o6_12.prohibited_insecticide_applications) == 1 with input as inp
	"insecticide_use" in o6_12.obligation_breaches with input as inp
	not o6_12.insecticide_ban_complied with input as inp
}

test_bio_permitted_insecticide_allowed if {
	p := object.union(vineyard, {"psm_applications": [app("insecticide", false, true)]})
	inp := with_parcels([p])
	count(o6_12.prohibited_insecticide_applications) == 0 with input as inp
	o6_12.insecticide_ban_complied with input as inp
}

test_ban_covers_non_declared_wine_fruit_hop_parcels if {
	p := object.union(orchard, {"declared_measures": [], "psm_applications": [app("insecticide", true, false)]})
	inp := with_parcels([p])
	count(o6_12.prohibited_insecticide_applications) == 1 with input as inp
}

test_insecticide_on_arable_not_covered if {
	p := object.union(arable, {"psm_applications": [app("insecticide", true, false)]})
	inp := with_parcels([vineyard, p])
	count(o6_12.prohibited_insecticide_applications) == 0 with input as inp
}

test_authority_order_explicit_chemical_allowed if {
	a := object.union(app("insecticide", true, false), {"authority_order_id": "BH-1", "substance_approved_by_order": true})
	p := object.union(vineyard, {"psm_applications": [a]})
	inp := json.patch(with_parcels([p]), [{"op": "add", "path": "/oepul/o6_12/authority_orders", "value": [{"order_id": "BH-1", "federal_state": "Niederösterreich", "pest": "Amerikanische Rebzikade", "chemical_synthetic_explicitly_ordered": true, "bio_substances_available": true, "documented_on_farm": true}]}])
	count(o6_12.prohibited_insecticide_applications) == 0 with input as inp
	count(o6_12.authority_order_documentation_missing) == 0 with input as inp
	count(o6_12.authority_order_upload_missing) == 0 with input as inp
}

test_authority_order_bio_available_chemical_not_allowed if {
	a := object.union(app("insecticide", true, false), {"authority_order_id": "BH-2", "substance_approved_by_order": true})
	p := object.union(vineyard, {"psm_applications": [a]})
	inp := json.patch(with_parcels([p]), [{"op": "add", "path": "/oepul/o6_12/authority_orders", "value": [{"order_id": "BH-2", "chemical_synthetic_explicitly_ordered": false, "bio_substances_available": true, "documented_on_farm": false}]}])
	count(o6_12.prohibited_insecticide_applications) == 1 with input as inp
	o6_12.authority_order_documentation_missing == {"BH-2"} with input as inp
}

test_authority_order_upload_required_until_2025 if {
	a := object.union(app("insecticide", true, false), {"authority_order_id": "BH-3", "substance_approved_by_order": true})
	p := object.union(vineyard, {"psm_applications": [a]})
	inp := json.patch(with_parcels([p]), [
		{"op": "replace", "path": "/farm/year", "value": 2025},
		{"op": "add", "path": "/oepul/o6_12/authority_orders", "value": [{"order_id": "BH-3", "chemical_synthetic_explicitly_ordered": true, "documented_on_farm": true, "uploaded_to_eama": false}]},
	])
	o6_12.authority_order_upload_missing == {"BH-3"} with input as inp
}

test_purchase_and_storage if {
	inp := with_o612({"insecticide_stock": [
		{"product_name": "Chem-Ins", "is_insecticide": true, "eu_2018_848_permitted": false},
		{"product_name": "Bio-Ins", "is_insecticide": true, "eu_2018_848_permitted": true},
		{"product_name": "Acker-Ins", "is_insecticide": true, "eu_2018_848_permitted": false, "intended_for_other_crops": true, "quantity_plausible": true, "records_kept": false},
		{"product_name": "Acker-Ins-OK", "is_insecticide": true, "eu_2018_848_permitted": false, "intended_for_other_crops": true, "quantity_plausible": true, "records_kept": true},
	]})
	o6_12.prohibited_insecticide_stock == {"Chem-Ins"} with input as inp
	o6_12.stock_for_other_crops_not_substantiated == {"Acker-Ins"} with input as inp
}

test_psm_codes_required_2025_not_2026 if {
	mixed := [app("fungicide", false, true), app("fungicide", true, false), app("insecticide", true, false)]
	p := object.union(vineyard, {"psm_applications": mixed, "oepul_codes": ["PSMCS"]})
	inp25 := json.patch(with_parcels([p]), [{"op": "replace", "path": "/farm/year", "value": 2025}])
	o6_12.missing_psm_codes.W1 == {"PSMCSI"} with input as inp25
	inp26 := with_parcels([p])
	not o6_12.psm_coding_required with input as inp26
	count(o6_12.missing_psm_codes) == 0 with input as inp26
}

test_psm_code_bio_only if {
	p := object.union(vineyard, {"psm_applications": [app("fungicide", false, true)]})
	inp := json.patch(with_parcels([p]), [{"op": "replace", "path": "/farm/year", "value": 2024}])
	o6_12.missing_psm_codes.W1 == {"PSMBIO"} with input as inp
}

test_minimum_management_harvest_missing if {
	p := object.union(vineyard, {"minimum_management": {"properly_planted": true, "annual_care": true, "harvested": false}})
	inp := with_parcels([p])
	o6_12.minimum_management_violations.W1 == {"harvested"} with input as inp
	"W1" in o6_12.op_code_required_parcels with input as inp
	"W1" in o6_12.individual_force_majeure_claim_needed with input as inp
}
