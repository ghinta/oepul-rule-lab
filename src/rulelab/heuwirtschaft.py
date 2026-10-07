"""Typed input and read-only evaluator for the source-bound o6_3 adaptation.

The host maps effective current facts to this contract. No business decision or
normative rate is calculated here; Rego evaluates the explicit clause slice.
"""
from __future__ import annotations

import argparse
from datetime import date
import json
from pathlib import Path
import subprocess
import sys
from typing import Annotated, Literal

from pydantic import BaseModel, ConfigDict, Field, ValidationError, model_validator

from .cli import REPO_ROOT, verify_opa_binary

Nonnegative = Annotated[float, Field(ge=0)]
Identifier = Annotated[str, Field(min_length=1)]


class Facts(BaseModel):
    model_config = ConfigDict(extra="forbid", strict=True, allow_inf_nan=False)


class Context(Facts):
    current_year: int | None = None
    snapshot_year: int | None = None
    as_of: date | None = None


class HistoricalAccess(Facts):
    year: int | None = None
    mown_meadow_meadow_pasture_ha: Nonnegative | None = None
    rgve_total: Nonnegative | None = None
    fodder_area_ha: Nonnegative | None = None


class Participation(Facts):
    combined_measure: str | None = None


class HayFarm(Facts):
    contract_start_year: int | None = None
    first_year: HistoricalAccess = Field(default_factory=HistoricalAccess)
    participation: Participation = Field(default_factory=Participation)
    silage_preparation_and_feeding: bool | None = None
    feed_fermentation: bool | None = None
    silage_storage: bool | None = None
    green_feeding_majority_april_to_september: bool | None = None
    third_party_cuttings_only_dry_hay: bool | None = None
    no_mower_conditioner_option: bool | None = None
    mower_conditioner_used: bool | None = None
    mower_conditioner_present: bool | None = None


class Farm(Facts):
    year: int | None = None
    heuwirtschaft: HayFarm = Field(default_factory=HayFarm)


class Crop(Facts):
    forage_crop_type: str | None = None
    is_second_crop: bool | None = None


class Operations(Facts):
    cutting_dates: list[date] | None = None
    full_mowing_and_removal: bool | None = None
    full_grazing: bool | None = None


class Parcel(Facts):
    parcel_id: Identifier
    area_ha: Nonnegative
    land_use: Literal["grassland", "arable", "special_crop", "alpine_pasture", "other"]
    located_in_austria: bool | None = None
    is_applied: bool | None = None
    grassland_type: str | None = None
    crop: Crop = Field(default_factory=Crop)
    operations: Operations = Field(default_factory=Operations)


class Land(Facts):
    parcels_complete: bool | None = None
    parcels: list[Parcel] | None = None


class Group(Facts):
    group_id: Identifier
    species: Literal["cattle", "pigs", "sheep_goats", "horses", "poultry", "rabbits", "other"]
    rgve_category: str | None = None
    animal_count: Nonnegative | None = None
    average_count: Nonnegative | None = None
    kept_in_austria: bool | None = None


class Livestock(Facts):
    species_groups_complete: bool | None = None
    species_groups: list[Group] | None = None


class Recognition(Facts):
    reference: Identifier
    authority: Literal["AMA"]
    recognised: bool
    year: int
    obligation_id: Literal["SILAGE", "FERMENTATION", "STORAGE", "GREEN_FEEDING", "HAY_TRANSFER", "MOWER_CONDITIONER", "MINIMUM_MANAGEMENT"]
    parcel_ids: list[Identifier] | None = None
    valid_from: date
    valid_to: date

    @model_validator(mode="after")
    def valid_period(self) -> Recognition:
        if self.valid_from > self.valid_to:
            raise ValueError("recognition valid_from must precede valid_to")
        if self.valid_from.year != self.year or self.valid_to.year != self.year:
            raise ValueError("recognition period must belong to its declared year")
        if self.obligation_id == "MINIMUM_MANAGEMENT" and not self.parcel_ids:
            raise ValueError("parcel obligation requires explicit parcel_ids")
        return self


class Exceptions(Facts):
    recognitions_complete: bool | None = None
    recognitions: list[Recognition] | None = None


class Input(Facts):
    context: Context = Field(default_factory=Context)
    farm: Farm = Field(default_factory=Farm)
    land: Land = Field(default_factory=Land)
    livestock: Livestock = Field(default_factory=Livestock)
    exceptions: Exceptions = Field(default_factory=Exceptions)

    @model_validator(mode="after")
    def coherent_entities_and_dates(self) -> Input:
        for values, field in [(self.land.parcels, "parcel_id"), (self.livestock.species_groups, "group_id")]:
            identifiers = [getattr(value, field) for value in values or []]
            if len(identifiers) != len(set(identifiers)):
                raise ValueError(f"duplicate {field}")
        for parcel in self.land.parcels or []:
            for cutting in parcel.operations.cutting_dates or []:
                if self.farm.year is not None and cutting.year != self.farm.year:
                    raise ValueError("cutting date does not belong to farm.year")
                if self.context.as_of is not None and cutting > self.context.as_of:
                    raise ValueError("future cutting date is not an observed fact")
        return self


def evaluate(payload: str, opa: Path, bundle: Path | None = None) -> dict:
    facts = Input.model_validate_json(payload)
    bundle = bundle or REPO_ROOT / "adaptations" / "o6_3"
    version = (REPO_ROOT / "runner/validation/opa-version.txt").read_text().strip()
    verify_opa_binary(opa, version)
    result = subprocess.run(
        [str(opa.resolve()), "eval", "--format=json", "--stdin-input", "-d", "policy", "-d", "data", "data.adapted.o6_3.decision"],
        cwd=bundle, input=facts.model_dump_json(), text=True, capture_output=True, check=True,
    )
    evaluated = json.loads(result.stdout)
    if not evaluated.get("result"):
        raise ValueError("adapted decision is undefined")
    return evaluated["result"][0]["expressions"][0]["value"]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", type=Path, required=True)
    parser.add_argument("--opa-bin", type=Path, required=True)
    args = parser.parse_args()
    try:
        print(json.dumps(evaluate(args.input.read_text(), args.opa_bin), ensure_ascii=False, indent=2))
    except (ValidationError, ValueError, subprocess.CalledProcessError) as exc:
        print(str(exc), file=sys.stderr)
        return 2
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
