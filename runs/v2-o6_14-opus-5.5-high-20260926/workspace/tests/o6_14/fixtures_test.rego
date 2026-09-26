package oepul.o6_14_test

# Gemeinsame Test-Fixtures fuer o6_14.

approx(a, b) if abs(a - b) < 0.005

base_farm(y) := {
	"year": y,
	"applicant": {"legal_form": "natural_person", "public_body_share_pct": 0, "is_active_farmer": true},
	"oepul": {"first_oepul_year": 2023, "participating_measures": []},
}

base_measure := {"applied": true, "application_date": "2022-12-10", "commitment_start_year": 2023}

alm(id, ha) := {
	"alm_id": id,
	"in_alm_cadastre_or_alm_area": true,
	"managed_from_home_farm": false,
	"boundary_or_management_difference_visible": true,
	"alm_pasture_area_ha": ha,
	"national_park": "none",
	"access_level": 1,
	"drive_up_list_submission_date": "2026-07-01",
	"field_list_submission_date": "2026-04-10",
	"plots": [{"plot_id": sprintf("%s-1", [id]), "codes": []}],
}

stay(alm_id, up, down) := {
	"alm_id": alm_id,
	"drive_up_date": up,
	"drive_down_date": down,
	"drive_up_report_date": up,
	"drive_down_report_date": down,
}

cattle(id, birth, n, s) := {"animal_id": id, "species": "cattle", "birth_date": birth, "count": n, "stays": s}

sheep(id, birth, n, s) := {"animal_id": id, "species": "sheep", "birth_date": birth, "count": n, "ear_tag": sprintf("AT-%s", [id]), "stays": s}

mk_input(y, alms, animals) := {
	"farm": base_farm(y),
	"land": {"total_area_ha": 20},
	"alpine_farming": {
		"is_alm_manager": true,
		"measure": base_measure,
		"alms": alms,
		"animals": animals,
	},
}

with_af(inp, patch) := object.union(inp, {"alpine_farming": object.union(inp.alpine_farming, patch)})

# Beispiel 1 Kapitel 5.2: 10 ha, 18 Kuehe je 120 Tage, 8 Kaelber je 20 Tage.
example_stocking_1 := mk_input(2026, [alm("A", 10)], [
	cattle("cows", "2019-03-01", 18, [stay("A", "2026-06-01", "2026-09-29")]),
	cattle("calves", "2026-03-01", 8, [stay("A", "2026-06-01", "2026-06-21")]),
])

# Beispiel 2 Kapitel 5.2: Alm A 10 ha, Alm B 3,5 ha.
example_stocking_2 := mk_input(2026, [alm("A", 10), alm("B", 3.5)], [
	cattle("cows", "2019-03-01", 20, [stay("A", "2026-06-01", "2026-09-29")]),
	cattle("calves", "2026-03-01", 4, [stay("A", "2026-06-01", "2026-07-01"), stay("B", "2026-07-01", "2026-08-20")]),
	cattle("heifers", "2023-05-01", 2, [stay("A", "2026-06-01", "2026-08-20"), stay("B", "2026-08-20", "2026-10-09")]),
	sheep("ewes", "2023-04-01", 9, [stay("B", "2026-06-01", "2026-09-29")]),
	sheep("lambs", "2026-03-01", 10, [stay("B", "2026-06-01", "2026-09-29")]),
])

herd_input(y, alm_list, animal_list) := mk_input(y, alm_list, animal_list)
