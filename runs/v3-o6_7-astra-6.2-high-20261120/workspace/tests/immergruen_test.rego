package oepul.o6_7_test

import data.oepul.o6_7 as ig
import rego.v1

main(a, b) := {"kind": "main", "sown": true, "declared": true, "start": a, "end": b}
mix := [{"species": "A", "family": "X", "winter_hardy": false, "percent": 25}, {"species": "B", "family": "X", "winter_hardy": false, "percent": 24}, {"species": "C", "family": "Y", "winter_hardy": true, "percent": 51}]
catch(a, b) := {"kind": "catch", "sown": true, "declared": false, "threshed": false, "proper_establishment": true, "full_cover": true, "undersown": false, "cereal_maize_percent": 50, "mix": mix, "start": a, "end": b}
plot(id, ha, periods) := {"parcel_id": id, "land_use": "arable", "area_ha": ha, "ig": {"country": "AT", "control_from": "2020-01-01", "control_until": "2030-01-01", "periods": periods}}
farm(ps) := {"farm": {"year": 2026}, "immergruen": {"timeline_complete": true, "first_measure_year": 2023}, "land": {"parcels": ps}}
fallow := {"kind": "fallow", "start": "2025-12-01", "end": "2027-04-01"}

test_annual_minimum_inclusive if {
	ig.minimum_area with input.land.arable_area_ha as 1.5
	not ig.minimum_area with input.land.arable_area_ha as 1.499
}

test_entry_limits if {
	ig.entry_timely with input.immergruen as {"entry_year": 2027, "application_date": "2026-12-31"}
	not ig.entry_timely with input.immergruen as {"entry_year": 2027, "application_date": "2027-01-01"}
	not ig.entry_timely with input.immergruen as {"entry_year": 2028, "application_date": "2027-12-30"}
}

test_cover_85_is_inclusive if {
	ig.annual_cover_ok with input as farm([plot("A", 85, [fallow]), plot("B", 15, [])])
	not ig.annual_cover_ok with input as farm([plot("A", 84.99, [fallow]), plot("B", 15.01, [])])
}

test_midyear_failure_is_detected if {
	a := main("2025-09-15", "2026-07-01")
	b := main("2026-08-21", "2027-07-01")
	ps := [plot("A", 100, [a, b])]
	r := ig.cover_failures with input as farm(ps)
	r == {{"date": "2026-07-01", "assessed_ha": 100, "bare_ha": 100, "excluded_ha": 0, "meets_85_percent": false}}
}

test_gap_boundaries if {
	a := main("2026-01-01", "2026-07-01")
	ig.gap_ok(a, catch("2026-07-31", "2026-10-10"))
	not ig.gap_ok(a, catch("2026-08-01", "2026-10-10"))
	ig.gap_ok(a, main("2026-08-20", "2026-12-20"))
	not ig.gap_ok(a, main("2026-08-21", "2026-12-20"))
	ig.gap_ok(catch("2026-05-01", "2026-07-01"), main("2026-07-31", "2026-12-20"))
	not ig.gap_ok(catch("2026-05-01", "2026-07-01"), main("2026-08-01", "2026-12-20"))
}

test_invalid_41_days_contaminates_both_gaps if {
	a := main("2025-10-01", "2026-07-01")
	b := main("2026-09-30", "2027-08-04")
	p := plot("Z", 8, [a, catch("2026-07-30", "2026-09-09"), b])
	every d in ["2026-07-01", "2026-07-30", "2026-09-10"] { not ig.green(p, d) }
	ig.green(p, "2026-09-30")
	p2 := plot("Z", 8, [a, catch("2026-07-30", "2026-09-10"), b])
	every d in ["2026-07-01", "2026-07-30", "2026-09-10"] { ig.green(p2, d) }
}

test_valid_catch_survives_excess_preceding_gap if {
	p := plot("A", 5, [main("2025-11-01", "2026-07-01"), catch("2026-08-10", "2026-09-29"), main("2026-10-01", "2027-08-20")])
	not ig.green(p, "2026-07-01")
	ig.green(p, "2026-08-10")
	ig.green(p, "2026-09-29")
}

test_mixture_species_families_and_proof if {
	c := catch("2026-09-20", "2026-11-01")
	ig.catch_valid(c)
	not ig.mix_ok(object.union(c, {"mix": [mix[0], mix[0], mix[2]]}))
	not ig.mix_ok(object.union(c, {"mix": [mix[0], mix[1], object.union(mix[2], {"family": "X"})]}))
	ig.seed_evidence_ok({"partners_visible": false, "seed_evidence": "Etikett"})
	not ig.seed_evidence_ok({"partners_visible": false, "seed_evidence": "unbekannt"})
}

test_fifty_percent_cereals_but_strictly_less_than_fifty_frost_sensitive if {
	c := catch("2026-09-21", "2027-02-15")
	ig.catch_valid(c)
	not ig.crop_share_ok(object.union(c, {"cereal_maize_percent": 50.001}))
	m := [mix[0], object.union(mix[1], {"percent": 25}), object.union(mix[2], {"percent": 50})]
	not ig.mix_ok(object.union(c, {"mix": m}))
}

test_late_mixture_versions_and_termination if {
	not ig.mix_ok(catch("2024-09-21", "2025-02-15"))
	ig.mix_ok(catch("2025-09-21", "2026-02-15"))
	ig.termination_ok(catch("2025-10-15", "2026-02-15"))
	not ig.termination_ok(catch("2025-10-15", "2026-02-14"))
	not ig.deadline_ok(catch("2025-10-16", "2026-04-01")) with input.immergruen.first_measure_year as 2023
	ig.deadline_ok(catch("2025-10-16", "2026-04-01")) with input.immergruen.first_measure_year as 2026
}

test_undersowing_and_staggered_harvest if {
	c := object.union(catch("2026-06-01", "2027-02-15"), {"undersown": true, "harvest_date": "2026-10-01", "mix": [mix[0], mix[1]]})
	ig.start(c) == "2026-10-01"
	not ig.mix_ok(c)
	ig.finish({"partial_harvest_dates": ["2026-09-01", "2026-09-15"]}) == "2026-09-15"
	ig.finish({"hemp": true, "seed_harvest_date": "2026-09-01", "end": "2026-10-10"}) == "2026-09-01"
}

test_renewal_immediate_and_both_42 if {
	a := catch("2026-07-01", "2026-08-12")
	ig.renewal_ok(a, catch("2026-08-12", "2026-09-23"))
	not ig.renewal_ok(a, catch("2026-08-13", "2026-10-01"))
	not ig.renewal_ok(a, catch("2026-08-12", "2026-09-22"))
}

test_drought_gap_requires_evidence_and_earliest_date if {
	a := main("2026-01-01", "2026-07-01")
	delay := {"foreseeable_management": true, "reason": "phytosanitär", "necessity_evidenced": true, "earliest_feasible_date": "2026-09-01"}
	b := object.union(main("2026-09-01", "2027-05-01"), {"delay": delay})
	ig.gap_ok(a, b)
	not ig.gap_ok(a, object.union(b, {"start": "2026-09-02"}))
	not ig.gap_ok(a, object.union(b, {"delay": object.union(delay, {"necessity_evidenced": false})}))
	not ig.gap_ok(object.union(a, {"kind": "catch", "declared": false}), b)
}

test_drought_emergence_exceptions_do_not_waive_sowing if {
	c := object.union(catch("2026-09-01", "2026-11-01"), {"full_cover": false, "drought_patchy": true, "cereal_maize_percent": 58, "drought_volunteer_excess": true})
	ig.catch_valid(c)
	not ig.catch_valid(object.union(c, {"sown": false}))
	not ig.catch_valid(object.union(c, {"proper_establishment": false}))
	not ig.catch_valid(object.union(c, {"start": "2025-09-01", "end": "2025-11-01"}))
}

test_nature_regrowth_50_day_boundary if {
	base := {"kind": "nature_regrowth", "project_requires_regrowth": true, "start": "2026-06-01", "end": "2027-01-01"}
	constraints := {"constraints": {"is_contract_nature_area": true}}
	p := object.union(plot("N", 3, [object.union(base, {"full_regrowth_date": "2026-07-21"})]), constraints)
	ig.green(p, "2026-06-01")
	q := object.union(plot("N", 3, [object.union(base, {"full_regrowth_date": "2026-07-22"})]), constraints)
	not ig.green(q, "2026-06-01")
	ig.green(q, "2026-07-22")
}

test_late_bare_access_only_after_october_15 if {
	a := plot("A", 8, [fallow])
	b := plot("B", 2, [])
	g := object.union(b.ig, {"control_from": "2026-10-16", "bare_on_acquisition": true})
	ig.annual_cover_ok with input as farm([a, object.union(b, {"ig": g})])
	not ig.annual_cover_ok with input as farm([a, object.union(b, {"ig": object.union(g, {"control_from": "2026-10-15"})})])
}

test_acquisition_does_not_excuse_preexisting_breach if {
	a := plot("A", 8, [fallow])
	b := plot("B", 2, [])
	c := plot("C", 10, [])
	q := object.union(c, {"ig": object.union(c.ig, {"control_from": "2026-10-22", "bare_on_acquisition": true})})
	r := ig.area_result("2026-10-22") with input as farm([a, b, q])
	r.excluded_ha == 0
	not r.meets_85_percent
}

test_public_location_for_drought_harvest if {
	p := {"land_use": "arable", "ig": {"state": "Steiermark", "district": "Weiz", "country": "AT", "late_summer_autumn_crop": true, "drought_no_harvestable_stand": true}}
	ig.harvest_waiver(p) with input.farm.year as 2026
	not ig.harvest_waiver(p) with input.farm.year as 2025
	not ig.harvest_waiver(object.union(p, {"ig": object.union(p.ig, {"district": "Liezen"})})) with input.farm.year as 2026
}

test_op_is_measure_specific if {
	ig.payment_exclusions({"ig": {"codes": ["OPBIO"], "excluded_measures": ["1B"]}}) == set()
	ig.payment_exclusions({"ig": {"codes": ["OP"]}}) == {"IG-op"}
	ig.payment_exclusions({"ig": {"npf": "Variante 6 NPF"}}) == {"IG-npf"} with input.farm.year as 2024
	ig.payment_exclusions({"ig": {"npf": "Variante 6 NPF"}}) == set() with input.farm.year as 2025
}

test_matrix_and_footnotes if {
	ig.combination("7", "6", []) == "keine Kombination"
	ig.combination("7", "16", []) == "kombinierbar"
	ig.combination("7", "16", ["AG"]) == "keine Kombination"
	ig.combination("1A", "8", ["BAW"]) == "nur Landschaftselemente"
	ig.combination("1B", "16", []) == "mit Prämienabschlag"
	ig.combination("1B", "16", ["PSM-Verzicht"]) == "keine Kombination"
	ig.combination("8", "16", ["Humusaufbau Wien"]) == "keine Kombination"
}

test_ruinous_tillage_nitrogen_after_destruction_psm_after_sowing if {
	events := [{"type": "Messerwalze", "date": "2026-08-01"}, {"type": "Mineralstickstoff", "date": "2026-12-01"}, {"type": "Pflanzenschutz", "date": "2026-10-06"}, {"type": "Pflanzenschutz", "date": "2026-10-10", "after_sowing": true}]
	c := object.union(catch("2026-07-01", "2026-10-01"), {"mechanically_removed": false, "next_sowing": "2026-10-10", "napv_ban_end": "2027-02-14", "events": events})
	r := ig.operation_violations with input as farm([plot("P", 3, [c])])
	count(r) == 3
	{"parcel": "P", "date": "2026-12-01", "rule": "IG-stickstoff"} in r
	{"parcel": "P", "date": "2026-10-06", "rule": "IG-psm"} in r
}

test_ranked_modulation_and_premium_band if {
	p := ig.premium_band with input as {"farm": {"year": 2026}, "immergruen": {"home_area_ha": 220, "payable_area_ha": 220}}
	p.min_modulated_eur == 15260
	p.max_modulated_eur == 19620
	ig.modulation_factor == (((200 + 90) + 595) + 75) / 1100 with input.immergruen.home_area_ha as 1100
}

test_care_prior_to_november_requires_named_plant_and_proof if {
	c := object.union(catch("2026-09-01", "2027-03-01"), {"overwinters": true})
	e := {"date": "2026-10-31", "type": "Häckseln", "low_cut": false, "regrowth": true, "erosion_protection": true, "nitrogen_retention": true, "cover_retained_or_recovers": true, "weed": "Gefleckter Schierling", "containment_needed": true, "proof_retained": true}
	ig.care_ok(c, e)
	not ig.care_ok(c, object.union(e, {"proof_retained": false}))
	not ig.care_ok(c, object.union(e, {"low_cut": true}))
	ig.care_ok(c, object.union(e, {"date": "2026-11-01", "proof_retained": false}))
}

test_mechanical_removal_types if {
	c := {"mix": [mix[0]]}
	ig.removal(c, {"type": "Striegeln"}) == "keine Beseitigung"
	ig.removal(c, {"type": "Direktsaat", "after_cover_period": true}) == "direkter Übergang"
	ig.removal(c, {"type": "niedergebrochen", "fully_frozen": true}) == "abfrostender Bestand"
	not ig.removal({"mix": mix}, {"type": "niedergewalzt"})
}

test_records_include_non_green_share_and_both_year_edges if {
	c := main("2026-03-01", "2026-08-01")
	g := {"record_from": "2026-01-01", "record_until": "2026-12-31", "periods": [c], "records": [{"type": "Anlage Nachfolge-Hauptfrucht", "date": "2026-03-01"}, {"type": "Ernte Hauptfrucht", "date": "2026-08-01"}]}
	ig.records_ok({"ig": g}) with input as {"farm": {"year": 2026}, "documentation": {"field_records_complete": true}}
	not ig.records_ok({"ig": object.union(g, {"records": []})}) with input as {"farm": {"year": 2026}, "documentation": {"field_records_complete": true}}
}

test_incomplete_or_overlapping_timeline_is_undefined if {
	not ig.area_result("2026-01-01") with input as {"farm": {"year": 2026}}
	f := farm([plot("A", 3, [main("2025-09-01", "2026-08-01"), main("2026-07-01", "2027-06-01")])])
	not ig.area_result("2026-07-10") with input as f
}

test_registered_following_mfa_is_main_crop if {
	c := object.union(catch("2026-09-24", "2027-02-01"), {"declared": true})
	ig.effective_kind(c) == "main"
	not ig.catch_valid(c)
	ig.green(plot("P", 4, [c]), "2026-11-01")
}

test_frost_only_bare_period_starts_at_first_trigger if {
	c := object.union(catch("2026-08-27", "2027-04-08"), {"mix": [mix[0]], "next_sowing": "2027-04-08", "events": [{"type": "niedergebrochen", "fully_frozen": true, "date": "2026-12-01"}, {"type": "Mineralstickstoff", "date": "2027-03-10"}, {"type": "Bodenbearbeitung", "date": "2027-03-20"}]})
	ig.finish(c) == "2027-03-10"
}

test_close_forage_cut_without_regrowth_ends_stand if {
	c := object.union(catch("2026-08-01", "2026-12-20"), {"events": [{"type": "Mahd mit Abtransport", "low_cut": true, "regrowth": false, "date": "2026-10-01"}]})
	ig.finish(c) == "2026-10-01"
}

test_nature_pending_regrowth_does_not_credit_bare_interval if {
	c := {"kind": "nature_regrowth", "start": "2026-06-01", "end": "2026-12-31", "project_requires_regrowth": true, "full_regrowth_date": null}
	p := object.union(plot("N", 5, [c]), {"constraints": {"is_contract_nature_area": true}})
	not ig.green(p, "2026-07-01")
}

test_carryover_exemption_ends_on_following_cultivation if {
	p := plot("C", 3, [])
	g := object.union(p.ig, {"control_from": "2025-10-20", "bare_on_acquisition": true, "prior_acquisition_exception": true, "first_following_cultivation": "2026-03-01"})

	# The unseeded interval up to first cultivation is excepted. A subsequent
	# bare interval is assessed in the ordinary way.
	q := object.union(p, {"ig": object.union(g, {"periods": [main("2026-03-01", "2026-07-15")]})})
	f := farm([q, plot("A", 7, [fallow])])
	before := ig.area_result("2026-02-28") with input as f
	before.excluded_ha == 3
	after := ig.area_result("2026-07-15") with input as f
	after.excluded_ha == 0
	not after.meets_85_percent
}

test_actual_payment_area_k20_vs_coverage_scope if {
	a := plot("K", 2, [fallow])
	k := object.union(a, {"ig": object.union(a.ig, {"claimed_ha": 2, "scheme_uses": [{"measure": "K20", "use": "K20"}]})})
	b := plot("B", 3, [fallow])
	q := object.union(b, {"ig": object.union(b.ig, {"claimed_ha": 3, "codes": ["OPBIO"]})})
	f := {"farm": {"year": 2024}, "land": {"parcels": [q, k]}, "immergruen": {"payment_units_complete": true, "home_area_ha": 5}}
	ig.assessed_claim_area == 3 with input as f
	r := ig.premium_band with input as f
	r.min_modulated_eur == 210
	ig.payment_exclusions(k) == {"IG-k20-kombination"} with input as f
}

test_grazing_and_nitrogen_psm_same_day if {
	c := object.union(catch("2026-07-01", "2026-09-01"), {"mechanically_removed": true, "napv_ban_end": "2027-02-15", "events": [{"type": "Pflanzenschutz", "date": "2026-09-01", "after_removal": true}, {"type": "Mineralstickstoff", "date": "2027-02-15"}, {"type": "Mineralstickstoff", "date": "2027-02-16"}, {"type": "Beweidung", "date": "2026-08-12", "cover_retained": false}]})
	r := ig.operation_violations with input as farm([plot("P", 4, [c])])
	count(r) == 2
	{"parcel": "P", "date": "2027-02-15", "rule": "IG-stickstoff"} in r
	{"parcel": "P", "date": "2026-08-12", "rule": "IG-nutzung"} in r
}

test_sanction_step_changes_in_2027 if {
	ig.sanction_outcome == {"action": "Verwarnung", "percent": 0} with input as {"farm": {"year": 2026}, "immergruen": {"sanction": {"assessed_stage": "niedrigste"}}}
	ig.sanction_outcome == {"action": "Einbehalt", "percent": 1} with input as {"farm": {"year": 2027}, "immergruen": {"sanction": {"assessed_stage": "niedrigste"}}}
	ig.sanction_outcome == {"action": "Ausschluss und Rückforderung"} with input.immergruen.sanction.full_cuts_in_contract as 2
}

test_groundwater_and_general_lookup_tables if {
	ig.groundwater_kg("32001")
	not ig.groundwater_kg("00103")
	ig.crop_groups("Felsenbirne", 2024) == set()
	"Obst" in ig.crop_groups("Felsenbirne", 2025)
	"Getreide" in ig.crop_groups("Grünschnittroggen", 2025)
	"Feldgemüse" in ig.crop_groups("Pak Choi", 2026)
	ig.contract_family("Begrünung von Ackerflächen – System Immergrün") == "einjährig"
	"7" in ig.public_body_measures(2026)
}

test_takeover_last_day_and_area if {
	x := {"previous_area_ha": 2, "expansion_ha": 1, "date": "2028-04-17"}
	ig.takeover_limits with input as {"farm": {"year": 2028}, "immergruen": {"takeover": x}}
	not ig.takeover_limits with input as {"farm": {"year": 2028}, "immergruen": {"takeover": object.union(x, {"expansion_ha": 1.001})}}
	not ig.takeover_limits with input as {"farm": {"year": 2026}, "immergruen": {"takeover": object.union(x, {"date": "2026-04-16"})}}
}

test_contract_continuation_and_lapse if {
	f := {"farm": {"year": 2026}, "land": {"arable_area_ha": 1.5}, "immergruen": {"measures": ["7"], "contract": {"prior_contract": true, "last_mfa_year": 2026, "withdrawal_date": null, "exclusion": false}}}
	ig.contract_status == "Vorjahresvertrag mit Jahres-MFA fortgeführt" with input as f
	r := ig.public_contract_barriers with input as f with input.land.arable_area_ha as 1.49
	"IG-mindestacker" in r
}

test_separate_short_stand_finding_below_fifteen_percent if {
	c := catch("2026-07-30", "2026-09-09")
	p := plot("short", 8, [main("2025-10-01", "2026-07-01"), c, main("2026-09-30", "2027-08-04")])
	f := farm([p, plot("A", 92, [fallow])])
	ig.annual_cover_ok with input as f
	fs := ig.parcel_findings with input as f
	{"parcel": "short", "start": "2026-07-30", "rule": "IG-dauer"} in fs
}

test_groundwater_special_case_after_late_harvest if {
	g := {"in_current_groundwater_map": true, "previous_harvest": "2026-10-02", "n_surplus_kg_ha": 50}
	f := {"farm": {"year": 2026}, "immergruen": {"measures": ["7", "16"]}}
	not ig.groundwater_autumn_required({"ig": g}) with input as f
	ig.groundwater_autumn_required({"ig": object.union(g, {"previous_fodder_broken": true, "break_date": "2026-11-14"})}) with input as f
}

test_matrix_conditional_annotations if {
	d := ig.combination_details("7", "8", [])
	d.source_mark == "x"
	count(d.footnotes) == 1
	d.footnotes[0].number == 4
}

test_erosion_mulch_sowing_four_weeks if {
	m := {"method": "Mulchsaat", "following_crop_erosion_prone": true, "shallow_noninverting": true, "surface_mulch": true, "deep_mixing": false, "first_tillage": "2026-03-01", "sowing": "2026-03-29"}
	ig.erosion_method_ok(m)
	not ig.erosion_method_ok(object.union(m, {"sowing": "2026-03-30"}))
}

test_pure_grain_and_approved_green_rye if {
	c := catch("2026-09-21", "2027-02-15")
	p := {"species": "Grünschnittroggen", "family": "Süßgräser", "winter_hardy": true, "percent": 100, "approved_green_rye": true}
	ig.catch_valid(object.union(c, {"mix": [p], "cereal_maize_percent": 0}))
	not ig.catch_valid(object.union(c, {"mix": [object.union(p, {"species": "Roggen"})], "cereal_maize_percent": 20}))
}
