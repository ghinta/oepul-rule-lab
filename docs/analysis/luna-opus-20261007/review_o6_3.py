"""Visible source-derived development probes; not held-out model evaluation."""
import argparse
import hashlib
import json
from pathlib import Path
import subprocess

LUNA_RUN = "v2-o6_3-luna-high-20261001"
OPUS_RUN = "v2-o6_3-opus-5.5-high-20260930"


def inputs(year=2026, start=2024, area=2, count=1):
    luna = {
        "farm": {"heuwirtschaft": {
            "measure": "o6_3", "year": year, "contract_start_year": start,
            "participation": {"combined_measure": "o6_1a"},
            "first_year": {"mown_meadow_meadow_pasture_ha": 2,
                           "rgve_total": 0.6, "fodder_area_ha": 2},
            "silage_preparation_and_feeding": False, "feed_fermentation": False,
            "silage_storage": False, "green_feeding_majority_april_to_september": True,
            "third_party_cuttings_only_dry_hay": True,
            "no_mower_conditioner_option": False,
        }},
        "land": {"parcels": [{"area_ha": area, "land_use": "grassland",
            "oepul": {"is_applied": True, "is_premium_eligible": True,
                      "is_second_crop": False}}]},
        "livestock": {"species_groups": [{"species": "cattle",
            "category": "ab_2_jahre", "animal_count": count}]},
    }
    opus = {
        "farm": {"year": year,
            "applicant": {"legal_form": "natural_person", "is_active_farmer": True},
            "oepul": {"first_participation_year": start,
                "participating_measures": ["o6_1a", "o6_3"],
                "o6_3": {"contract_start_year": start,
                    "measure_application_date": f"{start-1}-12-15",
                    "option_no_mower_conditioner": {"applied": False}}},
            "feeding": {"silage_produced": False, "silage_fed": False,
                "silage_stored": False,
                "green_feeding": {"eingrasen_or_pasture_days_apr_sep": 120,
                    "communal_pasture_or_alm_days_apr_sep": 0,
                    "all_roughage_animals_included": True}, "feedstuffs": []},
            "forage_transfers": [],
        },
        "land": {"total_area_ha": area, "parcels": [{"parcel_id": "G1",
            "area_ha": area, "land_use": "grassland",
            "grassland_type": "maehwiese_maehweide",
            "operations": {"cutting_dates": [f"{year}-06-01"]}}]},
        "livestock": {"species_groups": [{"species": "cattle",
            "rgve_category": "cattle_2y_plus", "animal_count": count}]},
    }
    return luna, opus


def cases():
    result = []
    def add(case_id, source, expectation, pair):
        result.append({"id": case_id, "source": source,
                       "expectation": expectation,
                       "inputs": dict(zip(["luna", "opus"], pair))})

    l, o = inputs(area=13, count=5)
    l["land"]["parcels"] = [
        {"area_ha": 8, "land_use": "grassland", "oepul": {"is_applied": True, "is_premium_eligible": True}},
        {"area_ha": 2, "land_use": "grassland", "oepul": {"is_applied": True, "is_premium_eligible": False}},
        {"area_ha": 3, "land_use": "arable", "oepul": {"is_applied": True, "is_premium_eligible": True, "crop_name": "kleegras"}},
    ]
    o["land"]["parcels"] = [
        {"parcel_id": "G1", "area_ha": 8, "land_use": "grassland", "grassland_type": "maehwiese_maehweide", "operations": {"cutting_dates": ["2026-06-01"]}},
        {"parcel_id": "G2", "area_ha": 2, "land_use": "grassland", "grassland_type": "dauerweide", "operations": {"cutting_dates": [], "grazed": True}},
        {"parcel_id": "A1", "area_ha": 3, "land_use": "arable", "crop": {"forage_crop_type": "kleegras", "is_second_crop": False}, "operations": {"cutting_dates": ["2026-06-01"]}},
    ]
    add("source_example", "Merkblatt S. 5, Kap. 7", "5 RGVE / 13 ha; 11 ha * 145.8 = 1603.8 EUR", (l, o))

    add("later_year_no_animals", "Merkblatt S. 2, Kap. 3.4; S. 4, Kap. 7",
        "Kein neuer Erstjahres-Zugangstest; aktuelle Prämie 0, Verpflichtungen bleiben.", inputs(count=0))

    l, o = inputs(year=2025, start=2025)
    l["livestock"]["species_groups"] = [{"species": "neuweltkamele", "category": "ab_1_jahr", "animal_count": 4}]
    o["livestock"]["species_groups"] = [{"species": "camelids", "rgve_category": "new_world_camelids_1y_plus", "animal_count": 4}]
    add("camelids_threshold", "Merkblatt S. 2, Kap. 4; S. 6, Kap. 8",
        "4 * 0.15 = 0.6 RGVE; auf 2 ha genau 0.30, Tierhaltereigenschaft erfüllt.", (l, o))

    l, o = inputs(year=2025, start=2025)
    l["livestock"]["species_groups"] = [{"species": "horses", "category": "adulte_ab_3_jahre", "animal_count": 1, "small_equid": True}]
    o["livestock"]["species_groups"] = [{"species": "horses", "rgve_category": "equids_small_adult_3y_plus", "animal_count": 1}]
    add("small_equid_threshold", "Merkblatt S. 5, Kap. 8 (kleine adulte Equiden)",
        "1 * 0.50 = 0.50 RGVE; auf 2 ha 0.25, Erstjahresschwelle nicht erfüllt.", (l, o))

    add("after_contract_end", "Merkblatt S. 1, Kap. 3.1 (Ende 31.12.2028)",
        "2030 keine Prämie aus diesem Vertrag.", inputs(year=2030))

    l, o = inputs()
    del l["farm"]["heuwirtschaft"]["silage_storage"]
    del o["farm"]["feeding"]["silage_stored"]
    add("unknown_silage_storage", "App-Plan P1: fehlende aktuelle Fakten; Merkblatt S. 3, Kap. 5.3",
        "Unbekannte Lagerung darf keine bestätigte Einhaltung sein; Integrationsvertrag erforderlich.", (l, o))

    l, o = inputs()
    l["farm"]["heuwirtschaft"].update({"drought_exception_area": True, "no_harvestable_stand": True})
    l["land"]["parcels"] = [{"area_ha": 2, "land_use": "arable", "oepul": {"is_applied": True, "is_premium_eligible": False, "crop_name": "kleegras"}}]
    o["land"]["parcels"] = [{"parcel_id": "A1", "area_ha": 2, "land_use": "arable", "crop": {"forage_crop_type": "kleegras"}, "operations": {"cutting_dates": []}}]
    add("drought_arable_fodder", "SRL PDF-S. 11, 1.6.3.1/1.6.3.3; Hinweis 05.08.2026, Ernteverpflichtung",
        "85%-Ackerernteregel schließt Ackerfutter aus; keine automatische Befreiung seiner eigenen Bewirtschaftungspflicht ableiten.", (l, o))
    return result


def evaluate(opa, root, run_id, query, value):
    work = root / "runs" / run_id / "workspace"
    cmd = [str(opa), "eval", "--format=json", "--stdin-input", "-d", "policy", "-d", "data", query]
    process = subprocess.run(cmd, cwd=work, input=json.dumps(value), text=True, capture_output=True, check=True)
    output = json.loads(process.stdout)
    if not output.get("result"):
        return {"undefined": True}
    return output["result"][0]["expressions"][0]["value"]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, required=True)
    parser.add_argument("--opa", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    rows = cases()
    for case in rows:
        case["observed"] = {
            "luna": evaluate(args.opa, args.repo, LUNA_RUN, "data.oepul.o6_3.result", case["inputs"]["luna"]),
            "opus": {key: evaluate(args.opa, args.repo, OPUS_RUN, query, case["inputs"]["opus"])
                     for key, query in {
                         "rgve": "data.o6_3.total_rgve",
                         "access_met": "count(data.o6_3.access_requirement_failures) == 0",
                         "rate": "data.o6_3.current_rate",
                         "premium": "data.o6_3.premium_gross_eur",
                         "violations": "data.o6_3.effective_violations",
                     }.items()},
        }
    files = {}
    for run in [LUNA_RUN, OPUS_RUN]:
        for folder in ["policy", "data"]:
            for path in sorted((args.repo / "runs" / run / "workspace" / folder).rglob("*")):
                if path.is_file():
                    files[str(path.relative_to(args.repo))] = hashlib.sha256(path.read_bytes()).hexdigest()
    doc = {"kind": "visible_exploratory_development_probes", "measure": "o6_3",
           "not_a_controlled_model_benchmark": True,
           "adapter_note": "Explizite Modelleingaben je Run; Luna übernimmt vorbereitete Prämienflächenflags, Opus berechnet sie selbst. Keine Gleichwertigkeit aller ungeprüften Pfade behauptet.",
           "opa_version": subprocess.check_output([str(args.opa), "version"], text=True),
           "opa_sha256": hashlib.sha256(args.opa.read_bytes()).hexdigest(),
           "artifact_sha256": files, "cases": rows}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(doc, ensure_ascii=False, indent=2) + "\n")
    for row in rows:
        print(row["id"], json.dumps(row["observed"], ensure_ascii=False))


if __name__ == "__main__":
    main()
