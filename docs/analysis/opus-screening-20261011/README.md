# Opus: development screening of existing rule candidates

These visible synthetic development cases run on unchanged historical Opus rules. Only supported mappings of the same Luna facts are used; unmapped facts remain explicit gaps. Outputs have no independent expert labels and do not measure accuracy or approve funding. Different sources, tools and budgets prevent an isolated claim about model quality.

App issue #140 blocks domain judgements that need an unresolved interpretation. Technical execution and output gaps can be studied separately.

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

Original evidence (German) is preserved in the detailed sections: model notes, case descriptions and observed outputs keep their original wording. `eligible` has a different scope in each candidate. `undefined` means no value; a defined JSON `null` remains a separate value.

[Findings and next decision](findings.md) · [Expandable preview](index.html) · [Manifest](manifest.json) · [All results](results.json) · [CSV matrix](matrix.csv) · [Frozen inputs and replay](method.md)

Base commit: `d2b63972c99056fde4e032029e1432639e281fda`. OPA: `1.18.2`. Policy and data are loaded separately for each run. No new model generation takes place.

Candidate commit: `e009eed4a83ff076b26eba33ac433ac2b0642621` (fixed PR #79 snapshot). 26 selected candidates from 36 finalized publications; ten superseded runs remain in the history. [Historical conditions and mapping](comparison.json) · [Comparison matrix](comparison.csv).

## Execution overview

| Measure | Run | Compilation | Baseline | Variation | Missing fact |
|---|---|---|---|---|---|
| [o6_1a](results/o6_1a.json) | `v2-o6_1a-opus-5.5-high-20260929` | compiled | defined | defined | defined |
| [o6_1b](results/o6_1b.json) | `v2-o6_1b-opus-5.5-high-20260925` | compiled | defined | defined | defined |
| [o6_1c](results/o6_1c.json) | `v2-o6_1c-opus-5.5-high-20261009` | compiled | defined | defined | defined |
| [o6_2](results/o6_2.json) | `v2-o6_2-opus-5.5-high-20260930` | compiled | defined | defined | defined |
| [o6_3](results/o6_3.json) | `v2-o6_3-opus-5.5-high-20260930` | compiled | runtime_error | runtime_error | runtime_error |
| [o6_4](results/o6_4.json) | `v2-o6_4-opus-5.5-high-20261009` | compiled | defined | defined | defined |
| [o6_5](results/o6_5.json) | `v2-o6_5-opus-5.5-high-20260925` | compiled | defined | defined | defined |
| [o6_6](results/o6_6.json) | `v2-o6_6-opus-5.5-high-20260925` | compiled | defined | defined | defined |
| [o6_7](results/o6_7.json) | `v2-o6_7-opus-5.5-high-20260925` | compiled | defined | defined | defined |
| [o6_8](results/o6_8.json) | `v2-o6_8-opus-5.5-high-20261001` | compiled | defined | defined | defined |
| [o6_9](results/o6_9.json) | `v2-o6_9-opus-5.5-high-20261003` | compiled | defined | defined | defined |
| [o6_10](results/o6_10.json) | `v2-o6_10-opus-5.5-high-20260925` | compiled | defined | defined | defined |
| [o6_11](results/o6_11.json) | `v2-o6_11-opus-5.5-high-20261001` | compiled | defined | defined | defined |
| [o6_12](results/o6_12.json) | `v2-o6_12-opus-5.5-high-20261009` | compiled | defined | defined | defined |
| [o6_13](results/o6_13.json) | `v2-o6_13-opus-5.5-high-20260926` | compiled | defined | fixture_gap | defined |
| [o6_14](results/o6_14.json) | `v2-o6_14-opus-5.5-high-20260926` | compiled | runtime_error | fixture_gap | runtime_error |
| [o6_15](results/o6_15.json) | `v2-o6_15-opus-5.5-high-20260926` | compiled | defined | defined | defined |
| [o6_16](results/o6_16.json) | `v2-o6_16-opus-5.5-high-20261003` | compiled | defined | fixture_gap | fixture_gap |
| [o6_17](results/o6_17.json) | `v2-o6_17-opus-5.5-high-20261011` | compiled | fixture_gap | fixture_gap | fixture_gap |
| [o6_18](results/o6_18.json) | `v2-o6_18-opus-5.5-high-20260927` | compiled | defined | defined | defined |
| [o6_19](results/o6_19.json) | `v2-o6_19-opus-5.5-high-20260927` | compiled | fixture_gap | fixture_gap | fixture_gap |
| [o6_20](results/o6_20.json) | `v2-o6_20-opus-5.5-high-20260928` | compiled | defined | defined | defined |
| [o6_21](results/o6_21.json) | `v2-o6_21-opus-5.5-high-20261004` | compiled | fixture_gap | fixture_gap | fixture_gap |
| [o6_22](results/o6_22.json) | `v2-o6_22-opus-5.5-high-20261004` | compiled | fixture_gap | fixture_gap | fixture_gap |
| [o6_23](results/o6_23.json) | `v2-o6_23-opus-5.5-high-20260928` | compiled | defined | defined | defined |
| [o6_24](results/o6_24.json) | `v2-o6_24-opus-5.5-high-20261003` | compiled | fixture_gap | fixture_gap | fixture_gap |

`defined`: the query returns a value. `undefined`: no value. `runtime_error` and `compile_error`: technical errors; the original OPA details are in the result JSON. `fixture_gap`: no executable case; see the candidate's gap description. These statuses are not domain judgements.

## Reproduce

From the repository root, using the matching OPA executable:

```bash
PYTHONPATH=src OPA_BIN=./tools/opa python -m rulelab.opus_screening verify --candidate-root ../candidate-e009eed
```

Verification compares the bound files and outputs. Input, source and artifact hashes are recorded in the manifest and result JSON. See [method.md](method.md) for the scope and limits.

## Candidates and observed cases

### o6_1a

Run: `v2-o6_1a-opus-5.5-high-20260929`. [Fixture](fixtures/o6_1a.json) · [Native results](results/o6_1a.json)

**Inputs:** Opus liest /farm/year und parzellenbezogene land_use/area_ha/codes/field_piece_id sowie datierte Bewirtschaftungsereignisse. Die Luna-Basis liefert vor allem Acker-/DIV-Aggregate; diese werden nicht in erfundene Detailparzellen aufgeteilt. Die drei Inputs enthalten nur Jahr und bekannte Parzelleneigung und sind deshalb identisch. Fehlende Felder bleiben fehlend; native Defaultwerte sind keine ergänzten Betriebsfakten.

**Output meaning:** Native decision enthält year, access_conditions_met, livestock_farm, aus Parzellen berechnete Flächen, premium-Breakdown, Zuschläge und violations. Eine Ausführung auf der partiellen Übersetzung prüft weder den Luna-7-%-Fall noch einen vollständigen Förderfall; abgeleitete Nullflächen/Verstöße können aus fehlenden Detailangaben und Defaults stammen.

**Origin:** Öffentliche synthetische DEVELOPMENT-ONLY-Diagnose: ausschließlich Übersetzung der bestehenden Luna-Entwicklungsfälle aus docs/analysis/luna-screening-20261011/fixtures/o6_1a.json. Native Opus-Policies und Modelltests wurden zur Feldform gelesen; keine zusätzlichen Jahres-, Flächen-, Vertrags-, Veranstaltungs- oder Genehmigungsfakten werden aus Modelltests übernommen. Kein Golden-/Heldout-Test, keine unabhängigen Expertenlabels, keine erwarteten fachlichen Ergebnisse.

**Query:** `data.oepul.o6_1a.decision`

**Inventory:** 166 rule catalog entries; 8 sources; 0 static input paths; 67 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"application": 8, "calculation": 6, "cap": 6, "combination": 7, "deadline": 9, "definition": 14, "documentation": 2, "eligibility": 13, "exception": 14, "exclusion": 7, "information": 2, "obligation": 28, "option": 4, "premium_rate": 16, "procedure": 9, "prohibition": 14, "sanction": 5, "scope": 2}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    []

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_1a | full_document | 64 | {"not_rule": 4, "rules": 60} |
| o6_general | full_document | 33 | {"not_rule": 9, "rules": 24} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 19 | {"not_rule": 1, "rules": 17, "unresolved": 1} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"rules": 6} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 7 | {"not_rule": 1, "rules": 6} |
| rebzikade_2026_insektizidverzicht | full_document | 2 | {"not_rule": 2} |
| duerre_2026_oepul_ausgleichszulage | full_document | 3 | {"not_rule": 2, "rules": 1} |
| duerre_2026_foerderungsabwicklung | full_document | 7 | {"not_rule": 4, "rules": 3} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year → Opus /farm/year: unverändertes Jahr 2026.",
            "Luna /land/parcels/0/slope_percent → Opus /land/parcels/0/slope_percent: unveränderte Neigung 0; die native Verwendung ist an weitere Parzellenmerkmale gebunden."
          ],
          "unmapped_facts": [
            "Luna /documentation/arable_div_ha 0.7 hat keinen nativen Aggregatpfad. Opus berechnet DIV aus /land/parcels/*/area_ha, land_use und codes. Die ursprüngliche Parzelle enthält weder Fläche noch Nutzungsart noch DIV-Code; der DIV-Anteil wird daher nicht in neue Parzellen zerlegt.",
            "Luna /land/total_area_ha=10, /land/arable_area_ha=10 und /land/grassland_area_ha=0 sowie /documentation/grassland_div_ha=0: Opus leitet diese Größen aus Detailparzellen ab. Die Aggregate belegen weder eine vollständige Flächenliste noch die Fläche des einen vorhandenen Parzellenobjekts.",
            "Luna /documentation/arable_fieldpieces (10 ha, 0.15 ha anrechenbar) und /documentation/grassland_fieldpieces=[]: kein nativer Aggregateingang; Opus benötigt konkrete /land/parcels/*/field_piece_id und Codes. Feldstück-IDs und Flächenzuordnungen fehlen.",
            "Luna /documentation/arable_uses_in_two_years=1 und arable_uses_this_year=1 benötigen bei Opus datierte /land/parcels/*/operations/use_events. Es wird kein Datum oder Ereignistyp ergänzt.",
            "Luna /documentation/arable_grazing=false, arable_threshing=false, arable_psm_used=false, arable_fertilizer_used=false und arable_removal_method=mechanical haben globalen Ackerbezug. Opus benötigt parzellenbezogene Ereignisse beziehungsweise /biodiversity/removal_method; der Bezug zur vorhandenen unklassifizierten Parzelle ist offen.",
            "Luna /documentation/regional_seed=false, /documentation/pheromone=false und /land/parcels/0/biodiversity_management/variant=synthetic_no_grassland_option sind keine direkten nativen Optionspfade. Konkrete DIVRS-/PZR-Codes, Managementvariante und explizite Teilnahme /farm/oepul/measures sind nicht vorhanden."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year → Opus /farm/year: unverändertes Jahr 2026.",
            "Luna /land/parcels/0/slope_percent → Opus /land/parcels/0/slope_percent: unveränderte Neigung 0; die native Verwendung ist an weitere Parzellenmerkmale gebunden."
          ],
          "unmapped_facts": [
            "Luna /documentation/arable_div_ha 0.69 hat keinen nativen Aggregatpfad. Opus berechnet DIV aus /land/parcels/*/area_ha, land_use und codes. Die ursprüngliche Parzelle enthält weder Fläche noch Nutzungsart noch DIV-Code; der DIV-Anteil wird daher nicht in neue Parzellen zerlegt.",
            "Luna /land/total_area_ha=10, /land/arable_area_ha=10 und /land/grassland_area_ha=0 sowie /documentation/grassland_div_ha=0: Opus leitet diese Größen aus Detailparzellen ab. Die Aggregate belegen weder eine vollständige Flächenliste noch die Fläche des einen vorhandenen Parzellenobjekts.",
            "Luna /documentation/arable_fieldpieces (10 ha, 0.15 ha anrechenbar) und /documentation/grassland_fieldpieces=[]: kein nativer Aggregateingang; Opus benötigt konkrete /land/parcels/*/field_piece_id und Codes. Feldstück-IDs und Flächenzuordnungen fehlen.",
            "Luna /documentation/arable_uses_in_two_years=1 und arable_uses_this_year=1 benötigen bei Opus datierte /land/parcels/*/operations/use_events. Es wird kein Datum oder Ereignistyp ergänzt.",
            "Luna /documentation/arable_grazing=false, arable_threshing=false, arable_psm_used=false, arable_fertilizer_used=false und arable_removal_method=mechanical haben globalen Ackerbezug. Opus benötigt parzellenbezogene Ereignisse beziehungsweise /biodiversity/removal_method; der Bezug zur vorhandenen unklassifizierten Parzelle ist offen.",
            "Luna /documentation/regional_seed=false, /documentation/pheromone=false und /land/parcels/0/biodiversity_management/variant=synthetic_no_grassland_option sind keine direkten nativen Optionspfade. Konkrete DIVRS-/PZR-Codes, Managementvariante und explizite Teilnahme /farm/oepul/measures sind nicht vorhanden."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year → Opus /farm/year: unverändertes Jahr 2026.",
            "Luna /land/parcels/0/slope_percent → Opus /land/parcels/0/slope_percent: unveränderte Neigung 0; die native Verwendung ist an weitere Parzellenmerkmale gebunden."
          ],
          "unmapped_facts": [
            "Luna /documentation/arable_div_ha fehlt hat keinen nativen Aggregatpfad. Opus berechnet DIV aus /land/parcels/*/area_ha, land_use und codes. Die ursprüngliche Parzelle enthält weder Fläche noch Nutzungsart noch DIV-Code; der DIV-Anteil wird daher nicht in neue Parzellen zerlegt.",
            "Luna /land/total_area_ha=10, /land/arable_area_ha=10 und /land/grassland_area_ha=0 sowie /documentation/grassland_div_ha=0: Opus leitet diese Größen aus Detailparzellen ab. Die Aggregate belegen weder eine vollständige Flächenliste noch die Fläche des einen vorhandenen Parzellenobjekts.",
            "Luna /documentation/arable_fieldpieces (10 ha, 0.15 ha anrechenbar) und /documentation/grassland_fieldpieces=[]: kein nativer Aggregateingang; Opus benötigt konkrete /land/parcels/*/field_piece_id und Codes. Feldstück-IDs und Flächenzuordnungen fehlen.",
            "Luna /documentation/arable_uses_in_two_years=1 und arable_uses_this_year=1 benötigen bei Opus datierte /land/parcels/*/operations/use_events. Es wird kein Datum oder Ereignistyp ergänzt.",
            "Luna /documentation/arable_grazing=false, arable_threshing=false, arable_psm_used=false, arable_fertilizer_used=false und arable_removal_method=mechanical haben globalen Ackerbezug. Opus benötigt parzellenbezogene Ereignisse beziehungsweise /biodiversity/removal_method; der Bezug zur vorhandenen unklassifizierten Parzelle ist offen.",
            "Luna /documentation/regional_seed=false, /documentation/pheromone=false und /land/parcels/0/biodiversity_management/variant=synthetic_no_grassland_option sind keine direkten nativen Optionspfade. Konkrete DIVRS-/PZR-Codes, Managementvariante und explizite Teilnahme /farm/oepul/measures sind nicht vorhanden."
          ]
        }
      ],
      "comparison_limit": "Der entscheidende Luna-Unterschied 0.70 → 0.69 ha sowie das Entfernen des DIV-Aggregats sind im Opus-Vertrag nicht abbildbar. Gleiche native Antworten sind hier keine beobachtete Unempfindlichkeit der DIV-Regel, sondern eine Übersetzungslücke. Ausgaben dürfen nicht als Modellvergleich oder als App-Freigabe gewertet werden.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_1a.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Partielle native Übersetzung der bekannten Luna-Fakten; die aggregierten Acker-/DIV-Fakten bleiben als dokumentierte Lücke bestehen. |
| variation | defined | no | Luna ändert ausschließlich /documentation/arable_div_ha von 0.70 auf 0.69. Dieser Fakt besitzt keinen nativen Aggregateingang; der Opus-Input bleibt bewusst identisch. |
| missing_fact | defined | no | Luna entfernt ausschließlich /documentation/arable_div_ha. Bereits der Basiswert ist nicht nativ übersetzbar; keine künstliche Entfernung einer anderen Opus-Eingabe. |

**Fixture gap:** Die drei Luna-Fälle sind nur partiell übersetzbar; der entscheidende DIV-Fakt bleibt unabbildbar, daher identische native Inputs.


**Open dependencies:**

- Für dieselben DIV-Fälle fehlen belegte Detailparzellen mit Nutzungsart, Fläche, Codes und Feldstückbezug sowie datierte Pflegeereignisse; dies ist eine Eingabevertragslücke vor jeder normativen Prüfung.
- Native Defaults können fehlende Detaildaten als Nullfläche oder Verletzung behandeln; die Diagnose ist keine vollständige Missing-Fact-Behandlung.
- Fachliche Anrechenbarkeit von DIV/DIVRS, Feldstückzusätzen und Betriebsoptionen benötigt eine passende Quellen-/Referenzprüfung; nur dafür einschlägige offene Entscheidungen aus App #140 heranziehen.

**Evidence:**

- [runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/main.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/main.rego): Native decision und begrenzte Felder des zusammenfassenden Ausgabepunkts.
- [runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/common.rego): Parzellen, Flächen und field_piece-Zuordnung statt direkter Ackerflächenaggregate; /farm/year via object.get.
- [runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/biodiversity_arable.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/biodiversity_arable.rego): DIV-Flächen aus codierten Ackerparzellen; 7-%- und Feldstückpflicht, datierte use_events.
- [runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/grassland_supplements.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/workspace/policy/o6_1a/grassland_supplements.rego): Parzellenbezogener slope_percent-Pfad und daran gebundene Zusatzbedingungen.
- [runs/v2-o6_1a-opus-5.5-high-20260929/workspace/tests/o6_1a/biodiversity_arable_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/workspace/tests/o6_1a/biodiversity_arable_test.rego): Öffentliche Modelltests bestätigen die Detailparzellen-/Ereignisform; keine Testkonstanten oder Sollausgaben übernommen.
- [runs/v2-o6_1a-opus-5.5-high-20260929/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/artifacts/input-paths.json): Historischer Pfadscan; erfasst direkte input-Pfade nur teilweise. object.get-Zugriffe wurden zusätzlich in der nativen Policy gelesen; der Scan ist kein vollständiger Eingabevertrag.
- [runs/v2-o6_1a-opus-5.5-high-20260929/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/artifacts/proposed-profile.json): Historischer Modellvorschlag des Eingabeprofils; daraus werden hier nur belegte Feldformen gelesen, keine Beispieldaten oder Freigabe übernommen.
- [runs/v2-o6_1a-opus-5.5-high-20260929/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/workspace/rules/profile_changes.json): Historische Vorschläge für zusätzliche Eingabefelder; keine Änderung des Canonical Farm Profile und kein Beleg für die fachliche Richtigkeit.
- [runs/v2-o6_1a-opus-5.5-high-20260929/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1a-opus-5.5-high-20260929/workspace/rules/rules.json): Historischer Regelkatalog dient der Rückverfolgung des Kandidaten; keine unabhängigen Sollwerte oder Expertenlabels.

### o6_1b

Run: `v2-o6_1b-opus-5.5-high-20260925`. [Fixture](fixtures/o6_1b.json) · [Native results](results/o6_1b.json)

**Inputs:** Opus result liest /farm/year, /oepul/o6_1b/contract_start_year, /oepul/first_participation_year, land.total_area_ha und Detailparzellen/Tiergruppen. Die explizite Luna-Angabe has_livestock=false wird als leere Tiergruppenliste wiedergegeben. Crop-/DIV-Anteile und Zertifizierungsstatus werden ohne zusätzliche Kultur- oder Kontrolldaten nicht übersetzt; alle drei nativen Inputs sind identisch.

**Output meaning:** Native result enthält compliant/violations, aus Detaildaten berechnete livestock/areas, Prämienkomponenten sowie Modulation und Summen. Es gibt kein eigenständiges insufficient_data. compliant und Nullflächen sind hier von der partiellen Datenlage und nativen Defaults abhängig; result ist keine vollständige fachliche Prüfung des Luna-Falls. Der Kandidat berechnet die Prämien separat vom compliant-Flag; selbst ohne Flächen und mit Verletzungen können Transaktionskosten ausgegeben werden. Eine positive Summe ist deshalb keine Förderfreigabe.

**Origin:** Öffentliche synthetische DEVELOPMENT-ONLY-Diagnose: ausschließlich Übersetzung der bestehenden Luna-Entwicklungsfälle aus docs/analysis/luna-screening-20261011/fixtures/o6_1b.json. Native Opus-Policies und Modelltests wurden zur Feldform gelesen; keine zusätzlichen Jahres-, Flächen-, Vertrags-, Veranstaltungs- oder Genehmigungsfakten werden aus Modelltests übernommen. Kein Golden-/Heldout-Test, keine unabhängigen Expertenlabels, keine erwarteten fachlichen Ergebnisse.

**Query:** `data.oepul.o6_1b.result`

**Inventory:** 200 rule catalog entries; 8 sources; 1 static input paths; 89 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"applicability": 1, "calculation": 11, "cap": 2, "classification": 2, "coding": 8, "combination": 6, "consequence": 4, "contract_period": 2, "deadline": 7, "definition": 16, "documentation": 2, "eligibility": 21, "exception": 10, "exclusion": 8, "information": 1, "limit": 3, "notice_2026": 12, "obligation": 35, "option": 4, "premium_rate": 23, "procedure": 11, "prohibition": 5, "reduction": 1, "sanction": 1, "scope": 1, "summary_table": 1, "threshold": 1, "tolerance": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_1b | full_document | 122 | {"not_rule": 7, "rules": 115} |
| o6_general | full_document | 37 | {"not_rule": 8, "rules": 29} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 10 | {"not_rule": 1, "rules": 9} |
| rebzikade_2026_insektizidverzicht | full_document | 5 | {"not_rule": 2, "rules": 3} |
| duerre_2026_oepul_ausgleichszulage | full_document | 7 | {"not_rule": 4, "rules": 3} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 5, "rules": 3} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 41 | {"not_rule": 5, "rules": 36} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 9 | {"not_rule": 1, "rules": 8} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /year → Opus /farm/year: unverändertes Jahr 2026.",
            "Luna /first_participation_year → Opus /oepul/first_participation_year und /contract/start_year → /oepul/o6_1b/contract_start_year: jeweils 2025.",
            "Luna /land/total_area_ha → Opus /land/total_area_ha: 100 ha für die native Modulation; dies ergänzt keine Detailparzellen.",
            "Luna /livestock/has_livestock=false wird als keine Tiergruppen /livestock/species_groups=[] übersetzt; die ebenfalls angegebenen null nicht zertifizierten Mastschweine/Hühner und conventional_equines_only=false werden dadurch nicht mit neuen Tieren ergänzt."
          ],
          "unmapped_facts": [
            "Luna /land/grain_and_maize_share=0.7 und /land/max_crop_share=0.5 sind Aggregate ohne native Inputentsprechung. Opus benötigt /land/parcels mit Nutzungsart, crop.species/crop_name und Flächen. Es werden keine Kulturen, Parzellen oder Anbauverteilungen ergänzt.",
            "Luna /certifications/organic/is_certified true und control_body=synthetic_control_body belegen weder Opus /farm/certifications/organic/registered_with_food_authority noch control_contract_start_date/end_date. Auch bei true wird keine Registrierung und kein Vertragsdatum behauptet.",
            "Luna /land/arable_area_ha=20, mowed_grassland_area_ha=20, arable_biodiversity_area_ha=1.4, grassland_biodiversity_area_ha=1.4 und protected_cultivation_area_ha=0 benötigen bei Opus konkrete Nutzungs-/Mäh-/Code-Parzellen. Die Detailflächen fehlen.",
            "Luna /land/arable_fields_with_more_than_5ha_are_valid=true und grassland_fields_with_more_than_5ha_are_valid=true belegen keine nativen /land/field_pieces oder Parzellenzuordnung; Feldstücke werden nicht erfunden.",
            "Luna /contract/end_date=2028-12-31 hat keinen deklarativen nativen Pfad; Opus leitet das Vertragsende aus seiner Tabelle ab. Explizite Maßnahmenantragstellung/Teilnahmeliste und Kontrollvertrag bleiben offen."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /year → Opus /farm/year: unverändertes Jahr 2026.",
            "Luna /first_participation_year → Opus /oepul/first_participation_year und /contract/start_year → /oepul/o6_1b/contract_start_year: jeweils 2025.",
            "Luna /land/total_area_ha → Opus /land/total_area_ha: 100 ha für die native Modulation; dies ergänzt keine Detailparzellen.",
            "Luna /livestock/has_livestock=false wird als keine Tiergruppen /livestock/species_groups=[] übersetzt; die ebenfalls angegebenen null nicht zertifizierten Mastschweine/Hühner und conventional_equines_only=false werden dadurch nicht mit neuen Tieren ergänzt."
          ],
          "unmapped_facts": [
            "Luna /land/grain_and_maize_share=0.76 und /land/max_crop_share=0.5 sind Aggregate ohne native Inputentsprechung. Opus benötigt /land/parcels mit Nutzungsart, crop.species/crop_name und Flächen. Es werden keine Kulturen, Parzellen oder Anbauverteilungen ergänzt.",
            "Luna /certifications/organic/is_certified true und control_body=synthetic_control_body belegen weder Opus /farm/certifications/organic/registered_with_food_authority noch control_contract_start_date/end_date. Auch bei true wird keine Registrierung und kein Vertragsdatum behauptet.",
            "Luna /land/arable_area_ha=20, mowed_grassland_area_ha=20, arable_biodiversity_area_ha=1.4, grassland_biodiversity_area_ha=1.4 und protected_cultivation_area_ha=0 benötigen bei Opus konkrete Nutzungs-/Mäh-/Code-Parzellen. Die Detailflächen fehlen.",
            "Luna /land/arable_fields_with_more_than_5ha_are_valid=true und grassland_fields_with_more_than_5ha_are_valid=true belegen keine nativen /land/field_pieces oder Parzellenzuordnung; Feldstücke werden nicht erfunden.",
            "Luna /contract/end_date=2028-12-31 hat keinen deklarativen nativen Pfad; Opus leitet das Vertragsende aus seiner Tabelle ab. Explizite Maßnahmenantragstellung/Teilnahmeliste und Kontrollvertrag bleiben offen."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /year → Opus /farm/year: unverändertes Jahr 2026.",
            "Luna /first_participation_year → Opus /oepul/first_participation_year und /contract/start_year → /oepul/o6_1b/contract_start_year: jeweils 2025.",
            "Luna /land/total_area_ha → Opus /land/total_area_ha: 100 ha für die native Modulation; dies ergänzt keine Detailparzellen.",
            "Luna /livestock/has_livestock=false wird als keine Tiergruppen /livestock/species_groups=[] übersetzt; die ebenfalls angegebenen null nicht zertifizierten Mastschweine/Hühner und conventional_equines_only=false werden dadurch nicht mit neuen Tieren ergänzt."
          ],
          "unmapped_facts": [
            "Luna /land/grain_and_maize_share=0.7 und /land/max_crop_share=0.5 sind Aggregate ohne native Inputentsprechung. Opus benötigt /land/parcels mit Nutzungsart, crop.species/crop_name und Flächen. Es werden keine Kulturen, Parzellen oder Anbauverteilungen ergänzt.",
            "Luna /certifications/organic/is_certified fehlt und control_body=synthetic_control_body belegen weder Opus /farm/certifications/organic/registered_with_food_authority noch control_contract_start_date/end_date. Auch bei true wird keine Registrierung und kein Vertragsdatum behauptet.",
            "Luna /land/arable_area_ha=20, mowed_grassland_area_ha=20, arable_biodiversity_area_ha=1.4, grassland_biodiversity_area_ha=1.4 und protected_cultivation_area_ha=0 benötigen bei Opus konkrete Nutzungs-/Mäh-/Code-Parzellen. Die Detailflächen fehlen.",
            "Luna /land/arable_fields_with_more_than_5ha_are_valid=true und grassland_fields_with_more_than_5ha_are_valid=true belegen keine nativen /land/field_pieces oder Parzellenzuordnung; Feldstücke werden nicht erfunden.",
            "Luna /contract/end_date=2028-12-31 hat keinen deklarativen nativen Pfad; Opus leitet das Vertragsende aus seiner Tabelle ab. Explizite Maßnahmenantragstellung/Teilnahmeliste und Kontrollvertrag bleiben offen."
          ]
        }
      ],
      "comparison_limit": "Die Luna-Änderung des Getreide-/Maisanteils 0.70 → 0.76 und das fehlende is_certified haben keine unverfälschte native Entsprechung. Identische Opus-Ausgaben sind für diese Sensitivitäten nicht auswertbar. Insbesondere ist is_certified=true keine Autorisierung, Registrierung oder Kontrollvertrag zu erfinden.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_1b.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Bekanntes Jahr, Vertragsbeginnjahr, erste Teilnahme, Gesamtfläche und ausdrücklich fehlende Tierhaltung nativ übersetzen; Flächen-/Kontrolldetails bleiben offen. |
| variation | defined | no | Luna ändert ausschließlich grain_and_maize_share von 0.70 auf 0.76; ohne Detailkulturen bleibt der native Input identisch und der Diversifizierungsfall untestbar. |
| missing_fact | defined | no | Luna entfernt is_certified; da dieses Flag bereits in der Basis keinen nativen Registrierungs-/Vertragsbeleg liefert, bleibt der native Input identisch. |

**Fixture gap:** Die drei Luna-Fälle besitzen nur eine partielle native Übersetzung; Getreideanteil und Zertifizierungsflag bleiben unabbildbar.


**Open dependencies:**

- Für die identische Diversifizierungsvariation fehlen eine belegte vollständige Kultur-/Flächenaufteilung und für die Zertifizierung Registrierung plus datierter Kontrollvertrag; keine bloße Feldumbenennung genügt.
- DIV-/Feldstückanrechnung und Bio-Teilbetriebs-/Tierhaltungsabgrenzung bleiben vor normativen Sollwerten quellenbezogen zu prüfen; einschlägige Referenzentscheidungen aus App #140 erst für solche Sollwerte.
- Fehlende Detaildaten werden von result als Nullaggregate bzw. violations behandelt, ohne eigenständige Datenlückenklassifikation.

**Evidence:**

- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/main.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/main.rego): Native result: vollständiger definierter Ausgabepunkt, compliant/violations, livestock/areas und Prämien.
- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/common.rego): Detailparzellen statt Aggregatflächen und Kulturanteilen; share(_,whole) ist bei whole &lt;= 0 nativ 0.
- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/participation.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/participation.rego): Registrierung und datierter Kontrollvertrag; is_certified/control_body werden nicht konsumiert. Startjahr und erste ÖPUL-Teilnahme sind native Pfade.
- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/livestock.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/livestock.rego): Tiergruppen- und RGVE-Vertrag sowie leere Tiergruppen als native Darstellung fehlender Tierhaltung.
- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/premiums.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/policy/o6_1b/premiums.rego): Native land.total_area_ha für Modulation.
- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/tests/o6_1b/fixtures_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/tests/o6_1b/fixtures_test.rego): Öffentliche Modellfixture zeigt native Detailparzellen, Tiergruppen und Kontrollvertragsform; keine fachlichen Konstanten daraus übernommen.
- [runs/v2-o6_1b-opus-5.5-high-20260925/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/artifacts/input-paths.json): Historischer Pfadscan; erfasst direkte input-Pfade nur teilweise. object.get-Zugriffe wurden zusätzlich in der nativen Policy gelesen; der Scan ist kein vollständiger Eingabevertrag.
- [runs/v2-o6_1b-opus-5.5-high-20260925/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/artifacts/proposed-profile.json): Historischer Modellvorschlag des Eingabeprofils; daraus werden hier nur belegte Feldformen gelesen, keine Beispieldaten oder Freigabe übernommen.
- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/rules/profile_changes.json): Historische Vorschläge für zusätzliche Eingabefelder; keine Änderung des Canonical Farm Profile und kein Beleg für die fachliche Richtigkeit.
- [runs/v2-o6_1b-opus-5.5-high-20260925/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1b-opus-5.5-high-20260925/workspace/rules/rules.json): Historischer Regelkatalog dient der Rückverfolgung des Kandidaten; keine unabhängigen Sollwerte oder Expertenlabels.

### o6_1c

Run: `v2-o6_1c-opus-5.5-high-20261009`. [Fixture](fixtures/o6_1c.json) · [Native results](results/o6_1c.json)

**Inputs:** Direkte Übersetzung zu /farm/year, /farm/oepul/o6_1c/first_contract_year, land.arable_area_ha, parcel.o6_1c.category/npa und operations. Die NPA-Parzellenfläche und fehlende Ackerfläche behalten exakt die Luna-Werte. Pflegezählungen, 0.1 ha frühe Pflege und bloß mechanical lassen sich ohne Ereignisse/Unterart nicht vollständig übersetzen; beantragte Codes und Kategorien werden nicht hinzuerfunden.

**Output meaning:** Native decision enthält categories, access/application/commitment_violations, contract_valid, parcel_exclusions, npa_eligible_area_ha/npa_area_cap_ha, Prämienband und Modulation. Die 4-%-Flächenkappung ist direkt beobachtbar; fehlende Antrags-/Codes-/Etablierungsangaben begrenzen die Interpretation des übrigen Ergebnisses. Es wird keine vollständige NPA-Konformität zugesprochen.

**Origin:** Öffentliche synthetische DEVELOPMENT-ONLY-Diagnose: ausschließlich Übersetzung der bestehenden Luna-Entwicklungsfälle aus docs/analysis/luna-screening-20261011/fixtures/o6_1c.json. Native Opus-Policies und Modelltests wurden zur Feldform gelesen; keine zusätzlichen Jahres-, Flächen-, Vertrags-, Veranstaltungs- oder Genehmigungsfakten werden aus Modelltests übernommen. Kein Golden-/Heldout-Test, keine unabhängigen Expertenlabels, keine erwarteten fachlichen Ergebnisse.

**Query:** `data.oepul.o6_1c.decision`

**Inventory:** 97 rule catalog entries; 9 sources; 1 static input paths; 16 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"applicability": 1, "application_requirement": 3, "calculation": 4, "combination": 3, "consequence": 3, "contract_period": 2, "correction": 1, "cross_measure_credit": 1, "deadline": 7, "definition": 8, "eligibility": 12, "exception": 2, "exclusion": 1, "exemption": 1, "exit": 2, "force_majeure": 5, "legal_effect": 1, "limit": 3, "obligation": 11, "option": 1, "payment": 1, "permission": 2, "premium_rate": 2, "procedure": 1, "prohibition": 6, "re_entry": 1, "restriction": 1, "sanction": 6, "scope": 1, "takeover": 1, "threshold": 3}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_1c | full_document | 30 | {"not_rule": 3, "rules": 27} |
| o6_general | full_document | 39 | {"not_rule": 17, "rules": 22} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 6 | {"not_rule": 5, "rules": 1} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 3 | {"not_rule": 2, "rules": 1} |
| duerre_2026_foerderungsabwicklung | full_document | 6 | {"not_rule": 6} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 36 | {"not_rule": 11, "rules": 25} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"rules": 6} |
| gsp_anwendungsverordnung | targeted_sections | 22 | {"not_rule": 4, "rules": 18} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year → Opus /farm/year: 2026; /measure/contract_start=2026-01-01 → /farm/oepul/o6_1c/first_contract_year=2026, ausschließlich das vorhandene Startjahr.",
            "Luna /land/arable_area_ha → Opus /land/arable_area_ha: 10 ha in baseline/variation; in missing_fact weiterhin fehlend. Native premium.rego liest das Aggregat direkt.",
            "Luna /land/parcels/0/parcel_id und /area_ha → dieselben Opus-Pfade: Fläche 0.3 ha, Identität unverändert; die Variation 0.30 → 0.50 bleibt erhalten.",
            "Luna /land/parcels/0/measure_category=nonproductive_arable → Opus /land/parcels/0/o6_1c/category=npa; /npa/sowing_date → /o6_1c/npa/sowing_date; /npa/following_crop=cover_crop (Zwischenfrucht des Luna-Vertrags) → /o6_1c/npa/follow_crop=catch_crop; /npa/grazing=false → /o6_1c/npa/grazed=false.",
            "Luna /land/parcels/0/operations/psm_used und /operations/fertilizer unverändert an dieselben Opus-Pfade; /combination/other_measure_ids=[] → /other_oepul_measures=[]."
          ],
          "unmapped_facts": [
            "Luna /measure/npa_area_with_care_before_august_ha=0.1, /land/parcels/0/npa/care_events_last_two_years=1 und care_events_current_year=1 sind Aggregate. Opus benötigt cutting_events mit Datum, Typ und Biomasseverbringung; insbesondere dürfen 0.1 ha nicht der ganzen 0.3/0.5-ha-Parzelle als frühes Ereignis zugeordnet werden.",
            "Luna /land/parcels/0/npa/clearance_method=mechanical unterscheidet nicht Opus removal_method=mulching oder incorporation. Keine mechanische Unterart wird ausgewählt; der Fakt bleibt unabbildbar.",
            "Luna sowing_date liefert nicht eindeutig die Opus-Etablierungsart new_sowing/self_greening/retained_existing. Native establishment, first_application_year und breaking_date bleiben offen; ein Antragsjahr oder Umbruchdatum wird nicht aus dem Datum erzeugt.",
            "Luna /measure/contract_end=2026-12-31 und /farm/region/nUTS=AT11 sind keine nativen Eingabepfade. Native categories als beantragte Kategorie, field_use_type=Grünbrache, oepul_codes=[NPA] sowie Antrag-/Feldlistenabgabedatum sind zusätzliche Deklarationsfakten und werden nicht aus der Parzellenkategorie abgeleitet."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year → Opus /farm/year: 2026; /measure/contract_start=2026-01-01 → /farm/oepul/o6_1c/first_contract_year=2026, ausschließlich das vorhandene Startjahr.",
            "Luna /land/arable_area_ha → Opus /land/arable_area_ha: 10 ha in baseline/variation; in missing_fact weiterhin fehlend. Native premium.rego liest das Aggregat direkt.",
            "Luna /land/parcels/0/parcel_id und /area_ha → dieselben Opus-Pfade: Fläche 0.5 ha, Identität unverändert; die Variation 0.30 → 0.50 bleibt erhalten.",
            "Luna /land/parcels/0/measure_category=nonproductive_arable → Opus /land/parcels/0/o6_1c/category=npa; /npa/sowing_date → /o6_1c/npa/sowing_date; /npa/following_crop=cover_crop (Zwischenfrucht des Luna-Vertrags) → /o6_1c/npa/follow_crop=catch_crop; /npa/grazing=false → /o6_1c/npa/grazed=false.",
            "Luna /land/parcels/0/operations/psm_used und /operations/fertilizer unverändert an dieselben Opus-Pfade; /combination/other_measure_ids=[] → /other_oepul_measures=[]."
          ],
          "unmapped_facts": [
            "Luna /measure/npa_area_with_care_before_august_ha=0.1, /land/parcels/0/npa/care_events_last_two_years=1 und care_events_current_year=1 sind Aggregate. Opus benötigt cutting_events mit Datum, Typ und Biomasseverbringung; insbesondere dürfen 0.1 ha nicht der ganzen 0.3/0.5-ha-Parzelle als frühes Ereignis zugeordnet werden.",
            "Luna /land/parcels/0/npa/clearance_method=mechanical unterscheidet nicht Opus removal_method=mulching oder incorporation. Keine mechanische Unterart wird ausgewählt; der Fakt bleibt unabbildbar.",
            "Luna sowing_date liefert nicht eindeutig die Opus-Etablierungsart new_sowing/self_greening/retained_existing. Native establishment, first_application_year und breaking_date bleiben offen; ein Antragsjahr oder Umbruchdatum wird nicht aus dem Datum erzeugt.",
            "Luna /measure/contract_end=2026-12-31 und /farm/region/nUTS=AT11 sind keine nativen Eingabepfade. Native categories als beantragte Kategorie, field_use_type=Grünbrache, oepul_codes=[NPA] sowie Antrag-/Feldlistenabgabedatum sind zusätzliche Deklarationsfakten und werden nicht aus der Parzellenkategorie abgeleitet."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year → Opus /farm/year: 2026; /measure/contract_start=2026-01-01 → /farm/oepul/o6_1c/first_contract_year=2026, ausschließlich das vorhandene Startjahr.",
            "Luna /land/arable_area_ha → Opus /land/arable_area_ha: 10 ha in baseline/variation; in missing_fact weiterhin fehlend. Native premium.rego liest das Aggregat direkt.",
            "Luna /land/parcels/0/parcel_id und /area_ha → dieselben Opus-Pfade: Fläche 0.3 ha, Identität unverändert; die Variation 0.30 → 0.50 bleibt erhalten.",
            "Luna /land/parcels/0/measure_category=nonproductive_arable → Opus /land/parcels/0/o6_1c/category=npa; /npa/sowing_date → /o6_1c/npa/sowing_date; /npa/following_crop=cover_crop (Zwischenfrucht des Luna-Vertrags) → /o6_1c/npa/follow_crop=catch_crop; /npa/grazing=false → /o6_1c/npa/grazed=false.",
            "Luna /land/parcels/0/operations/psm_used und /operations/fertilizer unverändert an dieselben Opus-Pfade; /combination/other_measure_ids=[] → /other_oepul_measures=[]."
          ],
          "unmapped_facts": [
            "Luna /measure/npa_area_with_care_before_august_ha=0.1, /land/parcels/0/npa/care_events_last_two_years=1 und care_events_current_year=1 sind Aggregate. Opus benötigt cutting_events mit Datum, Typ und Biomasseverbringung; insbesondere dürfen 0.1 ha nicht der ganzen 0.3/0.5-ha-Parzelle als frühes Ereignis zugeordnet werden.",
            "Luna /land/parcels/0/npa/clearance_method=mechanical unterscheidet nicht Opus removal_method=mulching oder incorporation. Keine mechanische Unterart wird ausgewählt; der Fakt bleibt unabbildbar.",
            "Luna sowing_date liefert nicht eindeutig die Opus-Etablierungsart new_sowing/self_greening/retained_existing. Native establishment, first_application_year und breaking_date bleiben offen; ein Antragsjahr oder Umbruchdatum wird nicht aus dem Datum erzeugt.",
            "Luna /measure/contract_end=2026-12-31 und /farm/region/nUTS=AT11 sind keine nativen Eingabepfade. Native categories als beantragte Kategorie, field_use_type=Grünbrache, oepul_codes=[NPA] sowie Antrag-/Feldlistenabgabedatum sind zusätzliche Deklarationsfakten und werden nicht aus der Parzellenkategorie abgeleitet."
          ]
        }
      ],
      "comparison_limit": "Flächenvariation und Missing-Ackerfläche sind im nativen Vertrag exakt erhalten, Pflege- und Deklarationsfakten nur teilweise. Eine Ausgabeänderung beweist ausschließlich Verhalten dieses Kandidaten unter den dokumentierten Lücken; keine fachlichen Sollwerte oder Rangfolge der Modelle.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_1c.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die vorhandene 0.30-ha-NPA-Fläche auf 10 ha Acker und direkte Managementfakten nativ übersetzen; keine Pflege-/Antragstermine ergänzen. |
| variation | defined | yes | Ausschließlich dieselbe NPA-Parzellenfläche von 0.30 auf 0.50 ha ändern; alle anderen übersetzbaren Fakten bleiben gleich. |
| missing_fact | defined | yes | Ausschließlich /land/arable_area_ha entfernen wie im Luna-Fall; native Aggregat-Defaultbehandlung beobachten. |

**Open dependencies:**

- Pflegeereignisse, mechanische Beseitigungsunterart, Etablierungsart und tatsächliche Antrags-/Code-Deklarationen fehlen für einen vollständigen vergleichbaren NPA-Fall.
- NPA-Kategorie ist bekannt, die formale Beantragung der Kategorie ist ein zusätzlicher Fakt; native Antragsverletzungen dürfen deshalb nicht als festgestellte Rechtsverstöße interpretiert werden.
- Eine normative Prüfung der Kategorie-, Kombinations- und Anrechnungsregeln sowie fehlender Tatsachen braucht Quellen/Referenzentscheidung, gegebenenfalls die dazu passende offene Frage aus App #140.

**Evidence:**

- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/decision.rego): Native zusammenfassende decision mit Flächenkap, Prämienband und getrennten Verletzungsgruppen.
- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/common.rego): Native category-, Anwendungs- und Farmjahrpfade.
- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/npa.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/npa.rego): NPA-Kategorie, datierte Pflegeereignisse, follow_crop, grazed und PSM-/Düngepfade; kein direkter Pflegeflächen-Aggregateingang.
- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/premium.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/policy/o6_1c/premium.rego): Direkter /land/arable_area_ha-Pfad und 4-%-Kap; verändert die nativen Flächen bei Variation/Missing-Fact.
- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/data/o6_1c/parameters.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/data/o6_1c/parameters.json): Native Folgefrucht-ID catch_crop und erlaubte mechanische Unterarten mulching/incorporation; mechanical allein ist keine eindeutige Enumübersetzung.
- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/tests/o6_1c/fixtures_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/tests/o6_1c/fixtures_test.rego): Öffentliche Modellfixture belegt Feldform und separates Etablierungs-/Antrags-/Ereignismodell; keine dieser neuen Sachverhaltsangaben übernommen.
- [runs/v2-o6_1c-opus-5.5-high-20261009/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/artifacts/input-paths.json): Historischer Pfadscan; erfasst direkte input-Pfade nur teilweise. object.get-Zugriffe wurden zusätzlich in der nativen Policy gelesen; der Scan ist kein vollständiger Eingabevertrag.
- [runs/v2-o6_1c-opus-5.5-high-20261009/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/artifacts/proposed-profile.json): Historischer Modellvorschlag des Eingabeprofils; daraus werden hier nur belegte Feldformen gelesen, keine Beispieldaten oder Freigabe übernommen.
- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/rules/profile_changes.json): Historische Vorschläge für zusätzliche Eingabefelder; keine Änderung des Canonical Farm Profile und kein Beleg für die fachliche Richtigkeit.
- [runs/v2-o6_1c-opus-5.5-high-20261009/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_1c-opus-5.5-high-20261009/workspace/rules/rules.json): Historischer Regelkatalog dient der Rückverfolgung des Kandidaten; keine unabhängigen Sollwerte oder Expertenlabels.

### o6_2

Run: `v2-o6_2-opus-5.5-high-20260930`. [Fixture](fixtures/o6_2.json) · [Native results](results/o6_2.json)

**Inputs:** Native /farm/year, /farm/oepul, /farm/region, unveränderte Grünlandparzelle und zugeordnete Rinder-Alterskategorie. Antrags-/Kursdatum und Tierzahl bleiben exakt erhalten. Opus benötigt N-Mengen nach Verlusten und Alm-Abzug statt Luna kg/ha, konkrete Betriebsmittel statt Fremd-N-Aggregat sowie Kursthema/Rolle. Diese fehlen; drei partielle native Inputs sind trotz Luna-Variation/Missing-Fact identisch.

**Output meaning:** Native decision enthält eligible/contract_valid, N- und RGVE-Verhältnisse, violations/review_items sowie Prämienflächen/-summen und Vertragsfolgen. livestock.nitrogen wird bei Fehlen nativ mit N-Mengen 0 gerechnet; dieses Ergebnis ist keine übersetzte Luna-N-Aussage. Kursverstöße können aus fehlendem Thema/Rolle stammen. Kein vollständiger Förder- oder N-Grenzfall. eligible prüft native Zugangs-/Vertragsbedingungen separat von violations; ein Weiterbildungsverstoß kann gleichzeitig mit eligible=true und positiven Prämien auftreten.

**Origin:** Öffentliche synthetische DEVELOPMENT-ONLY-Diagnose: ausschließlich Übersetzung der bestehenden Luna-Entwicklungsfälle aus docs/analysis/luna-screening-20261011/fixtures/o6_2.json. Native Opus-Policies und Modelltests wurden zur Feldform gelesen; keine zusätzlichen Jahres-, Flächen-, Vertrags-, Veranstaltungs- oder Genehmigungsfakten werden aus Modelltests übernommen. Kein Golden-/Heldout-Test, keine unabhängigen Expertenlabels, keine erwarteten fachlichen Ergebnisse.

**Query:** `data.oepul.o6_2.decision`

**Inventory:** 82 rule catalog entries; 8 sources; 2 static input paths; 26 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 3, "aggregation": 1, "calculation": 7, "calculation_note": 1, "classification": 1, "combination_exclusion": 1, "combination_premium_reduction": 1, "combination_table": 2, "consequence": 4, "contract_period": 1, "cross_reference": 2, "deadline": 2, "definition": 5, "documentation_obligation": 3, "eligibility": 3, "exception": 6, "notice": 1, "obligation": 10, "option": 3, "payment": 2, "premium_exclusion": 5, "premium_limit": 2, "premium_rate": 1, "procedure": 6, "prohibition": 1, "restriction": 2, "sanction": 1, "scope": 1, "temporary_exception": 1, "threshold": 1, "tolerance": 1, "transition": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year",
      "input.land.total_area_ha"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_2 | full_document | 42 | {"not_rule": 4, "rules": 38} |
| o6_general | full_document | 39 | {"not_rule": 10, "rules": 29} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 41 | {"not_rule": 10, "rules": 31} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 9 | {"not_rule": 4, "rules": 5} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 7 | {"not_rule": 6, "rules": 1} |
| rebzikade_2026_insektizidverzicht | full_document | 4 | {"not_rule": 4} |
| duerre_2026_oepul_ausgleichszulage | full_document | 7 | {"not_rule": 4, "rules": 3} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 7, "rules": 1} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /year und /application_year (beide 2026) → Opus /farm/year=2026; /region → /farm/region unverändert.",
            "Luna /program/o6_1a/participates=true und /program/o6_2/participates=true → Opus /farm/oepul/participating_measures=[1A,2]; o6_1b.participates=false → kein 1B-Eintrag; /program/o6_1b/partial_farm=false → /farm/oepul/bio_partial_farm/is_partial_farm=false.",
            "Luna /program/o6_2/application_year=2025 → Opus /farm/oepul/o6_2/contract_start_year=2025: der Luna-Kandidat nutzt dieses Jahr als Einstiegsjahr mit Vorjahresfrist. /program/o6_2/application_date → /farm/oepul/o6_2/application_date unverändert 2024-12-31.",
            "Luna /land/total_area_ha=100 sowie /land/parcels/0/parcel_id, area_ha=10, land_use=grassland, crop und operations.psm_used/psm_applications bleiben an entsprechenden Opus-Pfaden erhalten; combined_area_payments_eur_per_ha=0 → other_area_payments_eur_per_ha=0.",
            "Luna /livestock/species_groups/0/category=cattle_from_two_years und animal_count=5 → Opus /livestock/species_groups/0/species=cattle, rgve_key_id=cattle_ge_2y, animal_count=5 gemäß nativer Alterskategorie; keine zusätzliche Tierzahl oder Zählmethode.",
            "Luna /farm/training/hours=3, course_date=2022-01-01, provider_approved=true und double_counted=false → Opus /farm/oepul/trainings/0/hours/date/provider_recognized und beide credited_to_other_farm/credited_to_other_commitment=false. Thema und Rolle bleiben fehlend.",
            "Luna /farm/forage_area_ha=10 ist aus der unveränderten einzelnen 10-ha-Grünlandparzelle nativ berechenbar; kein zusätzlicher Aggregatpfad wird erfunden."
          ],
          "unmapped_facts": [
            "Luna /farm/compliance/livestock_n_kg_per_ha=170 ist ein Verhältnis nach Stall-/Lagerverlusten. Opus benötigt /livestock/nitrogen/n_after_stall_storage_losses_kg und n_on_alm_or_community_pasture_kg, mit LN-Nenner aus Detailparzellen. Diese beiden Mengen und eine vollständige LN-Flächenliste sind nicht vorhanden; aus 100 ha Gesamtfläche oder 10 ha sichtbarer Parzelle wird kein N-Zähler erfunden.",
            "Luna /farm/compliance/external_n_fertilizer_kg =0 hat keinen nativen Aggregatpfad. Opus benötigt genaue Betriebsmittel und externe Herkunft /land/parcels/*/operations/fertilizer/inputs. Ein Null-N-Aggregat belegt keine vollständige Betriebsmittelliste.",
            "Luna /farm/compliance/purchase_storage_records_complete=true belegt keine Opus-Betriebsmittel, Kauf-/Lagerereignisse, Plausibilitätsmenge oder records_available je Mittel unter /farm/oepul/operating_supplies.",
            "Luna /farm/training/completed_by=2025-12-31 sowie die bekannten Kursdaten liefern weder /farm/oepul/trainings/0/topic noch attendee_role. Kein zugelassenes Kursthema und keine Rolle werden ergänzt.",
            "Luna /land/parcels/0/operations/seed_treatment=false ist kein einzelnes Opus-PSM-Anwendungsereignis; die explizite leere psm_applications-Liste bleibt erhalten, ohne zusätzliche Ereignisse."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /year und /application_year (beide 2026) → Opus /farm/year=2026; /region → /farm/region unverändert.",
            "Luna /program/o6_1a/participates=true und /program/o6_2/participates=true → Opus /farm/oepul/participating_measures=[1A,2]; o6_1b.participates=false → kein 1B-Eintrag; /program/o6_1b/partial_farm=false → /farm/oepul/bio_partial_farm/is_partial_farm=false.",
            "Luna /program/o6_2/application_year=2025 → Opus /farm/oepul/o6_2/contract_start_year=2025: der Luna-Kandidat nutzt dieses Jahr als Einstiegsjahr mit Vorjahresfrist. /program/o6_2/application_date → /farm/oepul/o6_2/application_date unverändert 2024-12-31.",
            "Luna /land/total_area_ha=100 sowie /land/parcels/0/parcel_id, area_ha=10, land_use=grassland, crop und operations.psm_used/psm_applications bleiben an entsprechenden Opus-Pfaden erhalten; combined_area_payments_eur_per_ha=0 → other_area_payments_eur_per_ha=0.",
            "Luna /livestock/species_groups/0/category=cattle_from_two_years und animal_count=5 → Opus /livestock/species_groups/0/species=cattle, rgve_key_id=cattle_ge_2y, animal_count=5 gemäß nativer Alterskategorie; keine zusätzliche Tierzahl oder Zählmethode.",
            "Luna /farm/training/hours=3, course_date=2022-01-01, provider_approved=true und double_counted=false → Opus /farm/oepul/trainings/0/hours/date/provider_recognized und beide credited_to_other_farm/credited_to_other_commitment=false. Thema und Rolle bleiben fehlend.",
            "Luna /farm/forage_area_ha=10 ist aus der unveränderten einzelnen 10-ha-Grünlandparzelle nativ berechenbar; kein zusätzlicher Aggregatpfad wird erfunden."
          ],
          "unmapped_facts": [
            "Luna /farm/compliance/livestock_n_kg_per_ha=171 ist ein Verhältnis nach Stall-/Lagerverlusten. Opus benötigt /livestock/nitrogen/n_after_stall_storage_losses_kg und n_on_alm_or_community_pasture_kg, mit LN-Nenner aus Detailparzellen. Diese beiden Mengen und eine vollständige LN-Flächenliste sind nicht vorhanden; aus 100 ha Gesamtfläche oder 10 ha sichtbarer Parzelle wird kein N-Zähler erfunden.",
            "Luna /farm/compliance/external_n_fertilizer_kg =0 hat keinen nativen Aggregatpfad. Opus benötigt genaue Betriebsmittel und externe Herkunft /land/parcels/*/operations/fertilizer/inputs. Ein Null-N-Aggregat belegt keine vollständige Betriebsmittelliste.",
            "Luna /farm/compliance/purchase_storage_records_complete=true belegt keine Opus-Betriebsmittel, Kauf-/Lagerereignisse, Plausibilitätsmenge oder records_available je Mittel unter /farm/oepul/operating_supplies.",
            "Luna /farm/training/completed_by=2025-12-31 sowie die bekannten Kursdaten liefern weder /farm/oepul/trainings/0/topic noch attendee_role. Kein zugelassenes Kursthema und keine Rolle werden ergänzt.",
            "Luna /land/parcels/0/operations/seed_treatment=false ist kein einzelnes Opus-PSM-Anwendungsereignis; die explizite leere psm_applications-Liste bleibt erhalten, ohne zusätzliche Ereignisse."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /year und /application_year (beide 2026) → Opus /farm/year=2026; /region → /farm/region unverändert.",
            "Luna /program/o6_1a/participates=true und /program/o6_2/participates=true → Opus /farm/oepul/participating_measures=[1A,2]; o6_1b.participates=false → kein 1B-Eintrag; /program/o6_1b/partial_farm=false → /farm/oepul/bio_partial_farm/is_partial_farm=false.",
            "Luna /program/o6_2/application_year=2025 → Opus /farm/oepul/o6_2/contract_start_year=2025: der Luna-Kandidat nutzt dieses Jahr als Einstiegsjahr mit Vorjahresfrist. /program/o6_2/application_date → /farm/oepul/o6_2/application_date unverändert 2024-12-31.",
            "Luna /land/total_area_ha=100 sowie /land/parcels/0/parcel_id, area_ha=10, land_use=grassland, crop und operations.psm_used/psm_applications bleiben an entsprechenden Opus-Pfaden erhalten; combined_area_payments_eur_per_ha=0 → other_area_payments_eur_per_ha=0.",
            "Luna /livestock/species_groups/0/category=cattle_from_two_years und animal_count=5 → Opus /livestock/species_groups/0/species=cattle, rgve_key_id=cattle_ge_2y, animal_count=5 gemäß nativer Alterskategorie; keine zusätzliche Tierzahl oder Zählmethode.",
            "Luna /farm/training/hours=3, course_date=2022-01-01, provider_approved=true und double_counted=false → Opus /farm/oepul/trainings/0/hours/date/provider_recognized und beide credited_to_other_farm/credited_to_other_commitment=false. Thema und Rolle bleiben fehlend.",
            "Luna /farm/forage_area_ha=10 ist aus der unveränderten einzelnen 10-ha-Grünlandparzelle nativ berechenbar; kein zusätzlicher Aggregatpfad wird erfunden."
          ],
          "unmapped_facts": [
            "Luna /farm/compliance/livestock_n_kg_per_ha=170 ist ein Verhältnis nach Stall-/Lagerverlusten. Opus benötigt /livestock/nitrogen/n_after_stall_storage_losses_kg und n_on_alm_or_community_pasture_kg, mit LN-Nenner aus Detailparzellen. Diese beiden Mengen und eine vollständige LN-Flächenliste sind nicht vorhanden; aus 100 ha Gesamtfläche oder 10 ha sichtbarer Parzelle wird kein N-Zähler erfunden.",
            "Luna /farm/compliance/external_n_fertilizer_kg fehlt hat keinen nativen Aggregatpfad. Opus benötigt genaue Betriebsmittel und externe Herkunft /land/parcels/*/operations/fertilizer/inputs. Ein Null-N-Aggregat belegt keine vollständige Betriebsmittelliste.",
            "Luna /farm/compliance/purchase_storage_records_complete=true belegt keine Opus-Betriebsmittel, Kauf-/Lagerereignisse, Plausibilitätsmenge oder records_available je Mittel unter /farm/oepul/operating_supplies.",
            "Luna /farm/training/completed_by=2025-12-31 sowie die bekannten Kursdaten liefern weder /farm/oepul/trainings/0/topic noch attendee_role. Kein zugelassenes Kursthema und keine Rolle werden ergänzt.",
            "Luna /land/parcels/0/operations/seed_treatment=false ist kein einzelnes Opus-PSM-Anwendungsereignis; die explizite leere psm_applications-Liste bleibt erhalten, ohne zusätzliche Ereignisse."
          ]
        }
      ],
      "comparison_limit": "Die N-Variation 170 → 171 kg/ha und Entfernung von external_n_fertilizer_kg sind ohne zusätzliche N-Mengen/Betriebsmitteldetails nicht abbildbar. Identische native Ergebnisse haben hierfür keine Sensitivitätsaussage; die erhaltenen Kurs-/Tier-/Parzellenfakten erlauben nur eine partielle Entwicklungsdiagnose.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_2.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Vorhandene Flächen-, Altersgruppen-, Teilnahme-, Antrags- und Kursfakten nativ übersetzen; N-Mengen, Betriebsmittel, Kursthema und Rolle bleiben offen. |
| variation | defined | no | Luna ändert ausschließlich das N-Verhältnis von 170 auf 171; ohne belegte N-Mengen und Nennerauflösung keine neue native N-Menge und deshalb identischer nativer Input. |
| missing_fact | defined | no | Luna entfernt ausschließlich external_n_fertilizer_kg; es existiert kein gleichwertiger nativer Aggregateingang, deshalb identischer partieller Input. |

**Fixture gap:** Der entscheidende N-Verhältnis-/Fremd-N-Fakt ist nicht nativ übersetzbar; drei bewusst identische partielle Inputs.


**Open dependencies:**

- Für die identische N-Grenzvariation fehlen getrennte N-Mengen nach Stall-/Lagerverlusten, Alm-N sowie belegte vollständige LN-Denominatorflächen. App #140 ist erst für normative N-Ermittlung/Sollwerte relevant; diese Eingabevertragslücke besteht schon vorher.
- Eine fehlende Fremd-N-Summe kann nicht als fehlende vollständige Betriebsmittelliste ersetzt werden; Detailinputs/-käufe und Lagerdaten wären ein anderer Sachverhalt.
- Kursteilnehmerrolle und Kursthema fehlen; native defaults erzeugen deshalb ggf. einen Weiterbildungsverstoß trotz der bei Luna direkt angenommenen Weiterbildung.

**Evidence:**

- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/decision.rego): Native decision mit N-Verhältnis, RGVE, Prüfgruppen, Prämien und Vertragsfolgen.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/common.rego): Farmjahr und Region-/Parzellenvertrag; agricultural_area_ha wird aus Detailparzellen berechnet.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/livestock.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/livestock.rego): N-Zähler = nach Verlusten minus Alm/Gemeinschaftsweide; fehlende Mengen default 0. RGVE via rgve_key_id.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/obligations.rego): Einzelne Betriebsmittel, operating_supplies und Kurse mit topic/attendee_role statt allgemeiner Complianceflags.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/policy/o6_2/eligibility.rego): Teilnahmecodes 1A/1B, contract_start_year und Vorjahres-Antragsfrist.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/data/o6_2_rgve_key.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/data/o6_2_rgve_key.json): cattle_ge_2y bedeutet Rinder ab 2 Jahre und erlaubt die eindeutige Altersgruppenübersetzung.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/tests/o6_2/fixtures_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/tests/o6_2/fixtures_test.rego): Öffentliche Modellfixture belegt native Eingabeform; N-Zähler, Kursthema, Rolle und weitere Modelltestdaten werden nicht übernommen.
- [runs/v2-o6_2-opus-5.5-high-20260930/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/artifacts/input-paths.json): Historischer Pfadscan; erfasst direkte input-Pfade nur teilweise. object.get-Zugriffe wurden zusätzlich in der nativen Policy gelesen; der Scan ist kein vollständiger Eingabevertrag.
- [runs/v2-o6_2-opus-5.5-high-20260930/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/artifacts/proposed-profile.json): Historischer Modellvorschlag des Eingabeprofils; daraus werden hier nur belegte Feldformen gelesen, keine Beispieldaten oder Freigabe übernommen.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/rules/profile_changes.json): Historische Vorschläge für zusätzliche Eingabefelder; keine Änderung des Canonical Farm Profile und kein Beleg für die fachliche Richtigkeit.
- [runs/v2-o6_2-opus-5.5-high-20260930/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_2-opus-5.5-high-20260930/workspace/rules/rules.json): Historischer Regelkatalog dient der Rückverfolgung des Kandidaten; keine unabhängigen Sollwerte oder Expertenlabels.

### o6_3

Run: `v2-o6_3-opus-5.5-high-20260930`. [Fixture](fixtures/o6_3.json) · [Native results](results/o6_3.json)

**Inputs:** Native Vertragspfade /farm/year, /farm/oepul/o6_3, /farm/feeding, /farm/machinery, /land/parcels und RGVE-Kategorien. Das ursprüngliche Jahr bleibt 2025. Silagelagerung wird exakt übersetzt und im Missing-Fact-Fall wirklich entfernt. Erste-Jahr-Aggregate, Grünfütterungsmehrheit und zusammengefasste Schafe/Ziegen sind ohne zusätzliche Detailfakten nur teilweise abbildbar.

**Output meaning:** Native decision enthält first_contract_year/contract_established, access_requirement_failures, livestock_status, RGVE/Futter-/Mindestflächen, option_application_issues, violations, Prämien und Vertragsfolgen. Fehlende Weide-/Mähdaten, Grünfütterungstage, MFA-Markierung und Schaf-/Ziegenzuordnung beeinflussen zusätzliche Prüfungen. Eine einzelne Silage-Reaktion belegt keine gesamte Heuwirtschaftskonformität; fehlende silage_stored wird nativ wie false behandelt. Beim direkten Aufruf des vollständigen decision mit strict-builtin-errors scheitern alle drei übersetzten Fälle an general.rego:24: allowed_decrease_ha multipliziert den fehlenden Vorjahreswert null. Dieser Runtimefehler bleibt sichtbar; die Query wird nicht auf einen fehlerfreien Hilfsausgang umgestellt.

**Origin:** Öffentliche synthetische DEVELOPMENT-ONLY-Diagnose: ausschließlich Übersetzung der bestehenden Luna-Entwicklungsfälle aus docs/analysis/luna-screening-20261011/fixtures/o6_3.json. Native Opus-Policies und Modelltests wurden zur Feldform gelesen; keine zusätzlichen Jahres-, Flächen-, Vertrags-, Veranstaltungs- oder Genehmigungsfakten werden aus Modelltests übernommen. Kein Golden-/Heldout-Test, keine unabhängigen Expertenlabels, keine erwarteten fachlichen Ergebnisse.

**Query:** `data.o6_3.decision`

**Inventory:** 74 rule catalog entries; 8 sources; 1 static input paths; 34 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_requirement": 4, "area_change": 2, "calculation": 6, "combination": 2, "consequence": 4, "contract_period": 5, "deadline": 3, "definition": 3, "eligibility": 2, "exception": 9, "exclusion": 3, "interaction": 1, "obligation": 13, "option_obligation": 1, "payment": 2, "premium_cap": 1, "premium_eligibility": 1, "premium_rate": 2, "procedure": 6, "sanction": 2, "scope": 1, "transition": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_3 | full_document | 27 | {"not_rule": 3, "rules": 24} |
| o6_general | full_document | 47 | {"not_rule": 17, "rules": 30} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 28 | {"not_rule": 8, "rules": 20} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 8 | {"not_rule": 2, "rules": 6} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 6 | {"not_rule": 4, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 2 | {"not_rule": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 6 | {"not_rule": 6} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/heuwirtschaft/year → Opus /farm/year: ausdrücklich 2025, kein Jahresupdate; /contract_start_year → /farm/oepul/o6_3/contract_start_year=2025.",
            "Luna /farm/heuwirtschaft/participation/combined_measure=o6_1a und /measure=o6_3 → Opus /farm/oepul/participating_measures=[o6_1a,o6_3]; /no_mower_conditioner_option=true → /farm/oepul/o6_3/option_no_mower_conditioner/applied=true, ohne MFA-Markierungsfakt.",
            "Luna /farm/heuwirtschaft/silage_preparation_and_feeding=false → Opus /farm/feeding/silage_produced=false und silage_fed=false; /feed_fermentation=false → /farm/feeding/green_forage_fermentation_occurred=false (ebenfalls keine Grünfuttergärung).",
            "Luna /farm/heuwirtschaft/silage_storage → Opus /farm/feeding/silage_stored: baseline=false, variation=true und in missing_fact fehlend; exakt derselbe Lagerungsfakt.",
            "Luna /farm/heuwirtschaft/mower_conditioner_used und mower_conditioner_present → Opus /farm/machinery mit unveränderten false-Werten.",
            "Luna /land/parcels/0/parcel_id, area_ha=10, land_use=grassland → dieselben Opus-Pfade; /oepul/is_second_crop=false → /crop/is_second_crop=false; /oepul/is_applied=true für den Heuwirtschaftsfall → /enrolled_measures=[o6_3].",
            "Luna /livestock/species_groups/0 (cattle, ab_2_jahre, 3 Tiere) → Opus /livestock/species_groups/0 (cattle, rgve_category=cattle_2y_plus, 3); bei Gruppe 1 bleiben species=sheep_goats und animal_count=6 erhalten, ohne erfundene Tierartaufteilung."
          ],
          "unmapped_facts": [
            "Luna /farm/heuwirtschaft/first_year/mown_meadow_meadow_pasture_ha=2.5 und rgve_total=3.9 werden nativ aus klassifizierten Parzellen und Altersgruppen berechnet. Die eine 10-ha-Grünlandparzelle trägt keinen grassland_type und keine Mähtermine; daraus werden weder 2.5 ha Mähwiese abgespalten noch Mähereignisse erzeugt. first_year/fodder_area_ha=10 ist aus der 10-ha-Grünlandparzelle ableitbar.",
            "Luna /livestock/species_groups/1/category=ab_1_jahr mit species=sheep_goats kann nicht eindeutig zwischen Opus sheep_1y_plus und goats_1y_plus unterscheiden. Beide Faktoren sind 0.15, aber gleiche Faktoren erlauben keine erfundene Tierartzuordnung; rgve_category bleibt deshalb fehlend und natives RGVE unterschätzt den Luna-Aggregatwert.",
            "Luna /farm/heuwirtschaft/green_feeding_majority_april_to_september=true liefert keine genauen Opus Tage eingrasen_or_pasture_days_apr_sep/communal_pasture_or_alm_days_apr_sep und keinen separat erklärten all_roughage_animals_included-Fakt. Die Mehrheit wird nicht in eine erfundene Tageszahl umgerechnet.",
            "Luna /farm/heuwirtschaft/third_party_cuttings_only_dry_hay=true liefert keine konkreten forage_transfers-Ereignisse; es werden weder ein Transfer noch Empfänger-/Silageindizien ergänzt.",
            "Luna /land/parcels/0/oepul/is_premium_eligible=true ist keine native grassland_type-/Bewirtschaftungs-/Ausschlussprüfung. MFA-Optionsmarkierung, tatsächliches Maßnahmenantragsdatum sowie neue Ereignis-/Futterlisten bleiben offen.",
            "Luna enthält keinen /farm/oepul/o6_3/area_change/previous_year_grassland_measure_area_ha-Fakt. Der native vollständige decision-Aufruf scheitert bei diesem fehlenden Vorjahreswert; es wird kein Wert 0 oder 10 aus aktuellen Flächen eingefügt."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/heuwirtschaft/year → Opus /farm/year: ausdrücklich 2025, kein Jahresupdate; /contract_start_year → /farm/oepul/o6_3/contract_start_year=2025.",
            "Luna /farm/heuwirtschaft/participation/combined_measure=o6_1a und /measure=o6_3 → Opus /farm/oepul/participating_measures=[o6_1a,o6_3]; /no_mower_conditioner_option=true → /farm/oepul/o6_3/option_no_mower_conditioner/applied=true, ohne MFA-Markierungsfakt.",
            "Luna /farm/heuwirtschaft/silage_preparation_and_feeding=false → Opus /farm/feeding/silage_produced=false und silage_fed=false; /feed_fermentation=false → /farm/feeding/green_forage_fermentation_occurred=false (ebenfalls keine Grünfuttergärung).",
            "Luna /farm/heuwirtschaft/silage_storage → Opus /farm/feeding/silage_stored: baseline=false, variation=true und in missing_fact fehlend; exakt derselbe Lagerungsfakt.",
            "Luna /farm/heuwirtschaft/mower_conditioner_used und mower_conditioner_present → Opus /farm/machinery mit unveränderten false-Werten.",
            "Luna /land/parcels/0/parcel_id, area_ha=10, land_use=grassland → dieselben Opus-Pfade; /oepul/is_second_crop=false → /crop/is_second_crop=false; /oepul/is_applied=true für den Heuwirtschaftsfall → /enrolled_measures=[o6_3].",
            "Luna /livestock/species_groups/0 (cattle, ab_2_jahre, 3 Tiere) → Opus /livestock/species_groups/0 (cattle, rgve_category=cattle_2y_plus, 3); bei Gruppe 1 bleiben species=sheep_goats und animal_count=6 erhalten, ohne erfundene Tierartaufteilung."
          ],
          "unmapped_facts": [
            "Luna /farm/heuwirtschaft/first_year/mown_meadow_meadow_pasture_ha=2.5 und rgve_total=3.9 werden nativ aus klassifizierten Parzellen und Altersgruppen berechnet. Die eine 10-ha-Grünlandparzelle trägt keinen grassland_type und keine Mähtermine; daraus werden weder 2.5 ha Mähwiese abgespalten noch Mähereignisse erzeugt. first_year/fodder_area_ha=10 ist aus der 10-ha-Grünlandparzelle ableitbar.",
            "Luna /livestock/species_groups/1/category=ab_1_jahr mit species=sheep_goats kann nicht eindeutig zwischen Opus sheep_1y_plus und goats_1y_plus unterscheiden. Beide Faktoren sind 0.15, aber gleiche Faktoren erlauben keine erfundene Tierartzuordnung; rgve_category bleibt deshalb fehlend und natives RGVE unterschätzt den Luna-Aggregatwert.",
            "Luna /farm/heuwirtschaft/green_feeding_majority_april_to_september=true liefert keine genauen Opus Tage eingrasen_or_pasture_days_apr_sep/communal_pasture_or_alm_days_apr_sep und keinen separat erklärten all_roughage_animals_included-Fakt. Die Mehrheit wird nicht in eine erfundene Tageszahl umgerechnet.",
            "Luna /farm/heuwirtschaft/third_party_cuttings_only_dry_hay=true liefert keine konkreten forage_transfers-Ereignisse; es werden weder ein Transfer noch Empfänger-/Silageindizien ergänzt.",
            "Luna /land/parcels/0/oepul/is_premium_eligible=true ist keine native grassland_type-/Bewirtschaftungs-/Ausschlussprüfung. MFA-Optionsmarkierung, tatsächliches Maßnahmenantragsdatum sowie neue Ereignis-/Futterlisten bleiben offen.",
            "Luna enthält keinen /farm/oepul/o6_3/area_change/previous_year_grassland_measure_area_ha-Fakt. Der native vollständige decision-Aufruf scheitert bei diesem fehlenden Vorjahreswert; es wird kein Wert 0 oder 10 aus aktuellen Flächen eingefügt."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/heuwirtschaft/year → Opus /farm/year: ausdrücklich 2025, kein Jahresupdate; /contract_start_year → /farm/oepul/o6_3/contract_start_year=2025.",
            "Luna /farm/heuwirtschaft/participation/combined_measure=o6_1a und /measure=o6_3 → Opus /farm/oepul/participating_measures=[o6_1a,o6_3]; /no_mower_conditioner_option=true → /farm/oepul/o6_3/option_no_mower_conditioner/applied=true, ohne MFA-Markierungsfakt.",
            "Luna /farm/heuwirtschaft/silage_preparation_and_feeding=false → Opus /farm/feeding/silage_produced=false und silage_fed=false; /feed_fermentation=false → /farm/feeding/green_forage_fermentation_occurred=false (ebenfalls keine Grünfuttergärung).",
            "Luna /farm/heuwirtschaft/silage_storage → Opus /farm/feeding/silage_stored: baseline=false, variation=true und in missing_fact fehlend; exakt derselbe Lagerungsfakt.",
            "Luna /farm/heuwirtschaft/mower_conditioner_used und mower_conditioner_present → Opus /farm/machinery mit unveränderten false-Werten.",
            "Luna /land/parcels/0/parcel_id, area_ha=10, land_use=grassland → dieselben Opus-Pfade; /oepul/is_second_crop=false → /crop/is_second_crop=false; /oepul/is_applied=true für den Heuwirtschaftsfall → /enrolled_measures=[o6_3].",
            "Luna /livestock/species_groups/0 (cattle, ab_2_jahre, 3 Tiere) → Opus /livestock/species_groups/0 (cattle, rgve_category=cattle_2y_plus, 3); bei Gruppe 1 bleiben species=sheep_goats und animal_count=6 erhalten, ohne erfundene Tierartaufteilung."
          ],
          "unmapped_facts": [
            "Luna /farm/heuwirtschaft/first_year/mown_meadow_meadow_pasture_ha=2.5 und rgve_total=3.9 werden nativ aus klassifizierten Parzellen und Altersgruppen berechnet. Die eine 10-ha-Grünlandparzelle trägt keinen grassland_type und keine Mähtermine; daraus werden weder 2.5 ha Mähwiese abgespalten noch Mähereignisse erzeugt. first_year/fodder_area_ha=10 ist aus der 10-ha-Grünlandparzelle ableitbar.",
            "Luna /livestock/species_groups/1/category=ab_1_jahr mit species=sheep_goats kann nicht eindeutig zwischen Opus sheep_1y_plus und goats_1y_plus unterscheiden. Beide Faktoren sind 0.15, aber gleiche Faktoren erlauben keine erfundene Tierartzuordnung; rgve_category bleibt deshalb fehlend und natives RGVE unterschätzt den Luna-Aggregatwert.",
            "Luna /farm/heuwirtschaft/green_feeding_majority_april_to_september=true liefert keine genauen Opus Tage eingrasen_or_pasture_days_apr_sep/communal_pasture_or_alm_days_apr_sep und keinen separat erklärten all_roughage_animals_included-Fakt. Die Mehrheit wird nicht in eine erfundene Tageszahl umgerechnet.",
            "Luna /farm/heuwirtschaft/third_party_cuttings_only_dry_hay=true liefert keine konkreten forage_transfers-Ereignisse; es werden weder ein Transfer noch Empfänger-/Silageindizien ergänzt.",
            "Luna /land/parcels/0/oepul/is_premium_eligible=true ist keine native grassland_type-/Bewirtschaftungs-/Ausschlussprüfung. MFA-Optionsmarkierung, tatsächliches Maßnahmenantragsdatum sowie neue Ereignis-/Futterlisten bleiben offen.",
            "Luna enthält keinen /farm/oepul/o6_3/area_change/previous_year_grassland_measure_area_ha-Fakt. Der native vollständige decision-Aufruf scheitert bei diesem fehlenden Vorjahreswert; es wird kein Wert 0 oder 10 aus aktuellen Flächen eingefügt."
          ]
        }
      ],
      "comparison_limit": "Silagebaseline/-variation/-fehlender Fakt sind exakt parallel. Die übrige Übersetzung ist partiell: RGVE 3.9 und 2.5 ha Mindestmähfläche bleiben ohne eindeutige Detailzuordnung offen, obwohl das Jahr 2025 unverändert bleibt. Zusätzliche Opus-Verstöße können diese Lücken widerspiegeln und sind keine normativen Sollabweichungen. Der vollständige native Ausgabepunkt scheitert zudem bei fehlender Vorjahresfläche an einem null-Builtinfehler, sodass die erhaltene Silagevariation hier keinen decision-Vergleich ermöglicht.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_3.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | runtime_error | Baseline | Die bekannten 2025-Vertrags-, Tier-, Parzellen- und Silagefakten nativ übersetzen; keine neuen Tage/Mähtermine oder Schaf-/Ziegenaufteilung. |
| variation | runtime_error | no | Ausschließlich /farm/feeding/silage_stored von false auf true ändern; derselbe Luna-Lagerungsfakt. |
| missing_fact | runtime_error | no | Ausschließlich /farm/feeding/silage_stored entfernen; absent bleibt von false im Input unterschieden. |

**Open dependencies:**

- Technische Vertragsgrenze: /farm/oepul/o6_3/area_change/previous_year_grassland_measure_area_ha fehlt im Luna-Fall. Der Kandidat setzt ihn auf null und verwendet ihn in general.rego:24 ohne ausreichende Zahlenprüfung; alle drei vollständigen decision-Aufrufe enden unter strict-builtin-errors mit eval_type_error (mul, operand null). Ein Vorjahreswert wird nicht ergänzt und der Fehler nicht durch eine Teilquery verdeckt.
- Für vollständige Heuwirtschaftsbewertung fehlen grasland_type/Mähereignisse, Grünfütterungstage, MFA-Markierung/Antragsdatum und getrennte Schaf-/Ziegenkategorien; das ist kein Grund, das ursprüngliche Jahr 2025 umzudatieren.
- Fehlende Silagelagerung wird nativ als false behandelt und nicht als Datenlücke ausgewiesen; der Inputunterschied muss getrennt von der Outputgleichheit erhalten bleiben.
- Einzelne Fütterungs-/Tierhaltungs- und Erstjahrbedingungen brauchen vor fachlichen Sollwerten eine quellenbezogene Referenzprüfung; gegebenenfalls einschlägige Entscheidungen aus App #140, ohne die Entwicklungsdiagnose zu blockieren.

**Evidence:**

- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/decision.rego): Native data.o6_3.decision, eigenständiger Namespace und zusammenfassende Vertrags-/Prämien-/Verletzungsfelder.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/common.rego): Native Farmjahr-/Teilnahme-/Parzellenpfade; Vertragserstjahr bleibt 2025.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/obligations.rego): Direkter silage_stored-Pfad und flag(...)=object.get(...,false); exakte Variation/Missing-Fact, Grünfütterungstage statt Mehrheitsbool.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/general.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/general.rego): previous_year_grassland_ha default null; allowed_decrease_ha(prev) multipliziert prev in Zeile 24. Vollständige decision-Auswertung scheitert unter strict-builtin-errors auf dem fehlenden Vorjahresfakt.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/eligibility.rego): MFA-Markierung und Parzellengraslandtypen sind zusätzliche Fakten; kein direkter erste-Jahr-Flächenaggregatpfad.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/livestock.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/policy/o6_3/livestock.rego): RGVE wird aus rgve_category und Tierzahl berechnet; gruppierte Schafe/Ziegen ohne eindeutige Kategorie werden nicht gezählt.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/data/o6_3/rgve_key.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/data/o6_3/rgve_key.json): cattle_2y_plus ist eindeutig; sheep_1y_plus und goats_1y_plus besitzen gleichen Faktor, aber unterschiedliche Tierart-IDs.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/tests/o6_3/o6_3_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/tests/o6_3/o6_3_test.rego): Öffentliche Modelltests zeigen native Fütterungs-/Options-/Graslandform; die dortigen 2026-Daten und Beispieltermine werden nicht übernommen.
- [runs/v2-o6_3-opus-5.5-high-20260930/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/artifacts/input-paths.json): Historischer Pfadscan; erfasst direkte input-Pfade nur teilweise. object.get-Zugriffe wurden zusätzlich in der nativen Policy gelesen; der Scan ist kein vollständiger Eingabevertrag.
- [runs/v2-o6_3-opus-5.5-high-20260930/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/artifacts/proposed-profile.json): Historischer Modellvorschlag des Eingabeprofils; daraus werden hier nur belegte Feldformen gelesen, keine Beispieldaten oder Freigabe übernommen.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/rules/profile_changes.json): Historische Vorschläge für zusätzliche Eingabefelder; keine Änderung des Canonical Farm Profile und kein Beleg für die fachliche Richtigkeit.
- [runs/v2-o6_3-opus-5.5-high-20260930/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_3-opus-5.5-high-20260930/workspace/rules/rules.json): Historischer Regelkatalog dient der Rückverfolgung des Kandidaten; keine unabhängigen Sollwerte oder Expertenlabels.

### o6_4

Run: `v2-o6_4-opus-5.5-high-20261009`. [Fixture](fixtures/o6_4.json) · [Native results](results/o6_4.json)

**Inputs:** Native /farm/year, /oepul/o6_4/application_date und parcel.mountain_meadow. Der Höhenanteil ist exakt die arithmetische Umrechnung 1.1/2*100=55 Prozent; bei fehlendem Zähler bleibt er fehlend. Der vollständige Mahd-Jahresfakt wird über full_mowing_years abgebildet, ohne Mahddatum oder Verfahren. contract_start_date und Vorjahresflächen fehlen weiterhin; es wird kein 1.-Jänner-Vertragsdatum oder Vorjahreswert erfunden.

**Output meaning:** Native decision enthält contract_missing_inputs/contract_failures, je Parzelle is_bergmahd, missing_inputs/failures/warnings, erwarteten/effektiven Mähcode, premium_blockers, violations und Prämien. Der fehlende Höhenanteil kann eigenständig ausgewiesen werden. Die Mahdjahresliste ersetzt keine Ereignis-/Mähcodeprüfung; ohne Vertragsstartdatum bleibt eine Mahdpflicht-Sensitivität begrenzt und Prämien sind keine vollständige Bewertung.

**Origin:** Öffentliche synthetische DEVELOPMENT-ONLY-Diagnose: ausschließlich Übersetzung der bestehenden Luna-Entwicklungsfälle aus docs/analysis/luna-screening-20261011/fixtures/o6_4.json. Native Opus-Policies und Modelltests wurden zur Feldform gelesen; keine zusätzlichen Jahres-, Flächen-, Vertrags-, Veranstaltungs- oder Genehmigungsfakten werden aus Modelltests übernommen. Kein Golden-/Heldout-Test, keine unabhängigen Expertenlabels, keine erwarteten fachlichen Ergebnisse.

**Query:** `data.oepul.o6_4.decision`

**Inventory:** 90 rule catalog entries; 9 sources; 1 static input paths; 13 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"calculation": 3, "cap": 1, "coding": 5, "combination": 1, "condition": 4, "conditionality": 1, "consequence": 5, "contract_period": 1, "control": 1, "deadline": 4, "definition": 2, "eligibility": 9, "exception": 9, "exclusion": 3, "indicator": 1, "interaction": 2, "obligation": 8, "option": 2, "payment": 1, "permission": 1, "premium_condition": 1, "premium_rate": 2, "procedural_hint": 1, "procedure": 7, "prohibition": 5, "sanction": 3, "scope": 1, "temporal_exception_check": 1, "threshold": 5}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_4 | full_document | 23 | {"not_rule": 3, "rules": 20} |
| o6_general | full_document | 49 | {"not_rule": 12, "rules": 37} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 11 | {"not_rule": 8, "rules": 3} |
| rebzikade_2026_insektizidverzicht | full_document | 5 | {"not_rule": 3, "rules": 2} |
| duerre_2026_oepul_ausgleichszulage | full_document | 6 | {"not_rule": 4, "rules": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 6, "rules": 2} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 32 | {"not_rule": 6, "rules": 26} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 4 | {"rules": 4} |
| gsp_anwendungsverordnung | targeted_sections | 20 | {"not_rule": 3, "rules": 17} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/o6_4/year → Opus /farm/year: 2026; /measure_application_date → /oepul/o6_4/application_date unverändert 2024-12-31; /land/total_area_ha=2 → derselbe Opus-Pfad.",
            "Luna /land/parcels/0/parcel_id und area_ha=2 → dieselben Opus-Pfade; /measure_participation/0/participating=true → /mountain_meadow/enrolled_in_o6_4=true; land_use=Bergmähder plus correctly_identified_for_measure=true → /mountain_meadow/declared_as_bergmaehder=true.",
            "Luna /land/parcels/0/above_local_settlement_boundary=true → Opus /land/parcels/0/mountain_meadow/above_permanent_settlement_limit=true; elevation_m=1250 und /land/home_farm_elevation_m=900 → above_home_farm_elevation=true durch den arithmetischen Vergleich 1250 > 900; /is_alpine_farm_exception=false → /farm/is_alm_operation=false für diese einzige Parzelle.",
            "Luna /land/parcels/0/elevation_above_1200_area_ha=1.1 und /area_ha=2 → Opus /land/parcels/0/mountain_meadow/share_above_1200m_percent=55 Prozent durch 100*1.1/2; fehlt der Zähler in missing_fact, bleibt auch der native Prozentpfad fehlend.",
            "Luna /land/parcels/0/code=BM1 und /farm/o6_4/code=BM1 stimmen überein → Opus /land/parcels/0/mountain_meadow/declared_mowing_code=BM1.",
            "Luna /land/parcels/0/operations/mowing_years/0 mit year=2026, full_area=true, mowed_material_removed=true und mulching=false → Opus /land/parcels/0/mountain_meadow/full_mowing_years=[2026]. Dies ist ausschließlich die Liste im Luna-Fall bestätigter qualifizierender Jahre, keine erfundene datierte Mahd und keine vollständige Historie.",
            "Luna /land/parcels/0/operations/grazing_periods=[], fertilizer_applications=[] und plant_protection_applications=[] → Opus /operations/grazing_events=[], fertilizer_applications=[] und psm_applications=[]; /other_measures=[] → /oepul/premium_measures=[]."
          ],
          "unmapped_facts": [
            "Luna /farm/o6_4/contract_start_year=2025 ist kein exaktes Opus /oepul/o6_4/contract_start_date. Obwohl native Vertragstabellen Jahresanfangsstarts nennen, wird kein tatsächlicher Vertragsbeginn am 1. Jänner hinzugefügt; Datum bleibt fehlend.",
            "Luna /land/parcels/0/operations/mowing_years/0/year=2026 liefert kein genaues mowing_events.date und kein method. full_mowing_years bildet den bestätigten Jahresfakt ab, erlaubt aber keine Ereigniszählung oder BM1-Verfahrensprüfung. Vorjahre sind unbekannt; Opus behandelt ungenannte Jahre ggf. als nicht vollständig gemäht.",
            "Luna /farm/first_oepul_year=false liefert kein bestimmtes Opus /oepul/first_participation_year; es wird kein historisches Jahr ausgewählt.",
            "Luna /farm/o6_4/compliance/conditionality_compliant=true, /land/parcels/0/difficult_to_manage=true und active_agricultural_management=true sind keine entsprechenden nativen umfassenden Prüfpfade. Sie werden nicht in neue Antragstellerflags oder festgestellte Sanktionen umgedeutet.",
            "Alte Vertrags-/Flächenhistorie und insbesondere area_2025_ha, Vorgängerjahresflächen und Zahlungsantrag sind nicht gegeben. Aktuelle 2 ha werden nicht auf die Vergangenheit übertragen."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/o6_4/year → Opus /farm/year: 2026; /measure_application_date → /oepul/o6_4/application_date unverändert 2024-12-31; /land/total_area_ha=2 → derselbe Opus-Pfad.",
            "Luna /land/parcels/0/parcel_id und area_ha=2 → dieselben Opus-Pfade; /measure_participation/0/participating=true → /mountain_meadow/enrolled_in_o6_4=true; land_use=Bergmähder plus correctly_identified_for_measure=true → /mountain_meadow/declared_as_bergmaehder=true.",
            "Luna /land/parcels/0/above_local_settlement_boundary=true → Opus /land/parcels/0/mountain_meadow/above_permanent_settlement_limit=true; elevation_m=1250 und /land/home_farm_elevation_m=900 → above_home_farm_elevation=true durch den arithmetischen Vergleich 1250 > 900; /is_alpine_farm_exception=false → /farm/is_alm_operation=false für diese einzige Parzelle.",
            "Luna /land/parcels/0/elevation_above_1200_area_ha=1.1 und /area_ha=2 → Opus /land/parcels/0/mountain_meadow/share_above_1200m_percent=55 Prozent durch 100*1.1/2; fehlt der Zähler in missing_fact, bleibt auch der native Prozentpfad fehlend.",
            "Luna /land/parcels/0/code=BM1 und /farm/o6_4/code=BM1 stimmen überein → Opus /land/parcels/0/mountain_meadow/declared_mowing_code=BM1.",
            "Luna /land/parcels/0/operations/mowing_years/0 mit year=2026, full_area=false, mowed_material_removed=true und mulching=false → Opus /land/parcels/0/mountain_meadow/full_mowing_years=[]. Dies ist ausschließlich die Liste im Luna-Fall bestätigter qualifizierender Jahre, keine erfundene datierte Mahd und keine vollständige Historie.",
            "Luna /land/parcels/0/operations/grazing_periods=[], fertilizer_applications=[] und plant_protection_applications=[] → Opus /operations/grazing_events=[], fertilizer_applications=[] und psm_applications=[]; /other_measures=[] → /oepul/premium_measures=[]."
          ],
          "unmapped_facts": [
            "Luna /farm/o6_4/contract_start_year=2025 ist kein exaktes Opus /oepul/o6_4/contract_start_date. Obwohl native Vertragstabellen Jahresanfangsstarts nennen, wird kein tatsächlicher Vertragsbeginn am 1. Jänner hinzugefügt; Datum bleibt fehlend.",
            "Luna /land/parcels/0/operations/mowing_years/0/year=2026 liefert kein genaues mowing_events.date und kein method. full_mowing_years bildet den bestätigten Jahresfakt ab, erlaubt aber keine Ereigniszählung oder BM1-Verfahrensprüfung. Vorjahre sind unbekannt; Opus behandelt ungenannte Jahre ggf. als nicht vollständig gemäht.",
            "Luna /farm/first_oepul_year=false liefert kein bestimmtes Opus /oepul/first_participation_year; es wird kein historisches Jahr ausgewählt.",
            "Luna /farm/o6_4/compliance/conditionality_compliant=true, /land/parcels/0/difficult_to_manage=true und active_agricultural_management=true sind keine entsprechenden nativen umfassenden Prüfpfade. Sie werden nicht in neue Antragstellerflags oder festgestellte Sanktionen umgedeutet.",
            "Alte Vertrags-/Flächenhistorie und insbesondere area_2025_ha, Vorgängerjahresflächen und Zahlungsantrag sind nicht gegeben. Aktuelle 2 ha werden nicht auf die Vergangenheit übertragen."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/o6_4/year → Opus /farm/year: 2026; /measure_application_date → /oepul/o6_4/application_date unverändert 2024-12-31; /land/total_area_ha=2 → derselbe Opus-Pfad.",
            "Luna /land/parcels/0/parcel_id und area_ha=2 → dieselben Opus-Pfade; /measure_participation/0/participating=true → /mountain_meadow/enrolled_in_o6_4=true; land_use=Bergmähder plus correctly_identified_for_measure=true → /mountain_meadow/declared_as_bergmaehder=true.",
            "Luna /land/parcels/0/above_local_settlement_boundary=true → Opus /land/parcels/0/mountain_meadow/above_permanent_settlement_limit=true; elevation_m=1250 und /land/home_farm_elevation_m=900 → above_home_farm_elevation=true durch den arithmetischen Vergleich 1250 > 900; /is_alpine_farm_exception=false → /farm/is_alm_operation=false für diese einzige Parzelle.",
            "Luna /land/parcels/0/elevation_above_1200_area_ha=1.1 und /area_ha=2 → Opus /land/parcels/0/mountain_meadow/share_above_1200m_percent=55 Prozent durch 100*1.1/2; fehlt der Zähler in missing_fact, bleibt auch der native Prozentpfad fehlend.",
            "Luna /land/parcels/0/code=BM1 und /farm/o6_4/code=BM1 stimmen überein → Opus /land/parcels/0/mountain_meadow/declared_mowing_code=BM1.",
            "Luna /land/parcels/0/operations/mowing_years/0 mit year=2026, full_area=true, mowed_material_removed=true und mulching=false → Opus /land/parcels/0/mountain_meadow/full_mowing_years=[2026]. Dies ist ausschließlich die Liste im Luna-Fall bestätigter qualifizierender Jahre, keine erfundene datierte Mahd und keine vollständige Historie.",
            "Luna /land/parcels/0/operations/grazing_periods=[], fertilizer_applications=[] und plant_protection_applications=[] → Opus /operations/grazing_events=[], fertilizer_applications=[] und psm_applications=[]; /other_measures=[] → /oepul/premium_measures=[]."
          ],
          "unmapped_facts": [
            "Luna /farm/o6_4/contract_start_year=2025 ist kein exaktes Opus /oepul/o6_4/contract_start_date. Obwohl native Vertragstabellen Jahresanfangsstarts nennen, wird kein tatsächlicher Vertragsbeginn am 1. Jänner hinzugefügt; Datum bleibt fehlend.",
            "Luna /land/parcels/0/operations/mowing_years/0/year=2026 liefert kein genaues mowing_events.date und kein method. full_mowing_years bildet den bestätigten Jahresfakt ab, erlaubt aber keine Ereigniszählung oder BM1-Verfahrensprüfung. Vorjahre sind unbekannt; Opus behandelt ungenannte Jahre ggf. als nicht vollständig gemäht.",
            "Luna /farm/first_oepul_year=false liefert kein bestimmtes Opus /oepul/first_participation_year; es wird kein historisches Jahr ausgewählt.",
            "Luna /farm/o6_4/compliance/conditionality_compliant=true, /land/parcels/0/difficult_to_manage=true und active_agricultural_management=true sind keine entsprechenden nativen umfassenden Prüfpfade. Sie werden nicht in neue Antragstellerflags oder festgestellte Sanktionen umgedeutet.",
            "Alte Vertrags-/Flächenhistorie und insbesondere area_2025_ha, Vorgängerjahresflächen und Zahlungsantrag sind nicht gegeben. Aktuelle 2 ha werden nicht auf die Vergangenheit übertragen."
          ]
        }
      ],
      "comparison_limit": "Höhenanteil und bestätigtes vollständiges Mähjahr sind aus denselben Luna-Fakten abgeleitet. Variation leert nur die bestätigte Jahresliste, Missing-Fact entfernt nur den Höhenprozentsatz. Ein unverändertes decision bei der Mahdvariation kann durch fehlendes Vertragsdatum/Ereignisdetails entstehen und belegt keine fachliche Unempfindlichkeit. Der Jahresvergleich nutzt eine partielle bekannte Historie.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_4.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die bekannte 2-ha-Bergmahd, 55-%-Höhenanteil und bestätigte vollständige Mahd 2026 nativ übersetzen; Vertragsdatum/Mähdatum/Verfahren bleiben offen. |
| variation | defined | no | Dieselbe Luna-Mahd ist full_area=false; daher 2026 aus der Liste bestätigter qualifizierender Mähjahre entfernen. Kein neues Ereignis oder Datum. |
| missing_fact | defined | yes | Luna entfernt nur elevation_above_1200_area_ha; deshalb ausschließlich den nativen share_above_1200m_percent-Pfad entfernen. |

**Open dependencies:**

- Das genaue Vertragsstartdatum, Mähereignisdatum und Mähverfahren fehlen; vorhandene BM1-Deklaration erlaubt keine Verfahrensinferenz. Zusätzlich ist die Jahresliste nur bekannte Teilhistorie.
- Die Übersetzung der parzellenbezogenen Almbetriebs-Ausnahme in den nativen Betriebsflag gilt nur für diese einzelne Parzelle; keine allgemeine mehrparzellige App-Adaption.
- Normative Bergmahd-/BM-Code- und Mahdpflichtbewertung benötigt passende Quellen-/Referenzentscheidungen, gegebenenfalls einschlägige Fragen aus App #140; die native Höhen-Missing-Diagnose ist bereits ohne diese Freigabe beobachtbar.

**Evidence:**

- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/decision.rego): Native decision mit contract_missing_inputs und je Parzelle missing_inputs/Prämienblockern.
- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/common.rego): Farmjahr, mountain_meadow-Teilnahme und root oepul.o6_4; Ereignisse benötigen ISO-Datum.
- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/eligibility.rego): Native Höhen-/Dauersiedlungsfelder und ausdrückliches Missing-Feld share_above_1200m_percent.
- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/obligations.rego): full_mowing_years als Liste bestätigter vollständiger Mähjahre neben datierten mowing_events; Verfahrens-/Codeprüfung erfordert Ereignisse.
- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/administration.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/policy/o6_4/administration.rego): Native contract_start_date und application_date, fehlende Vertragsdaten separat; area_2025_ha ist historische Eingabe.
- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/tests/o6_4/o6_4_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/tests/o6_4/o6_4_test.rego): Öffentliche Modelltests zeigen Höhen-Missing-Fact und getrennte Jahreshistorie/datierte Mahd. Keine Beispieltermine oder BM2-/Vorjahresdaten übernommen.
- [runs/v2-o6_4-opus-5.5-high-20261009/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/artifacts/input-paths.json): Historischer Pfadscan; erfasst direkte input-Pfade nur teilweise. object.get-Zugriffe wurden zusätzlich in der nativen Policy gelesen; der Scan ist kein vollständiger Eingabevertrag.
- [runs/v2-o6_4-opus-5.5-high-20261009/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/artifacts/proposed-profile.json): Historischer Modellvorschlag des Eingabeprofils; daraus werden hier nur belegte Feldformen gelesen, keine Beispieldaten oder Freigabe übernommen.
- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/rules/profile_changes.json): Historische Vorschläge für zusätzliche Eingabefelder; keine Änderung des Canonical Farm Profile und kein Beleg für die fachliche Richtigkeit.
- [runs/v2-o6_4-opus-5.5-high-20261009/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_4-opus-5.5-high-20261009/workspace/rules/rules.json): Historischer Regelkatalog dient der Rückverfolgung des Kandidaten; keine unabhängigen Sollwerte oder Expertenlabels.

### o6_5

Run: `v2-o6_5-opus-5.5-high-20260925`. [Fixture](fixtures/o6_5.json) · [Native results](results/o6_5.json)

**Inputs:** farm.year bleibt 2025. Die bekannte Kuh wird unter livestock.endangered_breed_animals mit nativer animal_category=kuh, Rasse, Reinrassigkeit, Zuchtprogramm, Zuchteinsatz, reinrassiger Anpaarung und on_farm_from abgebildet. diagnostic-animal-0 ist allein eine strukturelle Index-ID. Fehlende Erstkalbedaten, Zuchtbuch-/Orts-/Bestätigungs- und Antragsdaten bleiben fehlen.

**Output meaning:** Die native decision enthält getrennte Zugangs-, Vertrags-, Tier- und Prämienbefunde. Aus boolescher Mindestflächen-/Tierprüfung oder Prämienwerten folgt keine unabhängig bestätigte Förderfreigabe. Der Opus-Vertrag prüft zusätzliche Nachweise, die Luna nicht als konkrete Werte geliefert hat.

**Origin:** Öffentliche synthetische Entwicklungsdiagnose: ausschließlich Übersetzung der drei bereits sichtbaren Luna-Fälle aus docs/analysis/luna-screening-20261011/fixtures/o6_5.json. Keine unabhängigen Sollurteile und keine zurückgehaltenen Testfälle. Strukturelle Index-IDs bezeichnen nur synthetische Datensätze; fehlende fachliche Fakten werden nicht ergänzt.

**Query:** `data.oepul.o6_5.decision`

**Inventory:** 97 rule catalog entries; 8 sources; 2 static input paths; 7 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_requirement": 7, "application": 4, "calculation": 11, "combination": 1, "consequence": 3, "contract": 4, "control": 1, "deadline": 3, "definition": 4, "eligibility": 15, "exception": 7, "exit": 3, "information": 1, "legal_basis": 2, "obligation": 13, "procedure": 8, "reporting": 3, "sanction": 5, "scope": 2}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.documentation.vis_reports_complete",
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_5 | full_document | 24 | {"not_rule": 2, "rules": 22} |
| o6_general | full_document | 33 | {"not_rule": 15, "rules": 18} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 59 | {"not_rule": 16, "rules": 43} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"not_rule": 3, "rules": 3} |
| duerre_2026_foerderungsabwicklung | full_document | 9 | {"not_rule": 6, "rules": 3} |
| duerre_2026_oepul_ausgleichszulage | full_document | 6 | {"not_rule": 6} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 5 | {"not_rule": 4, "rules": 1} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; keine Aktualisierung des Untersuchungsjahrs.",
            "/livestock/animals/0/species=cattle und /animal_type=cow → /livestock/endangered_breed_animals/0/animal_category=kuh; der native Kategoriekatalog ordnet kuh der Art cattle zu.",
            "/livestock/animals/0/{breed,purebred,regular_breeding_use,purebred_mating,held_from} → /livestock/endangered_breed_animals/0/{breed,is_purebred,regular_breeding_use,purebred_mating_only,on_farm_from}: dieselben Werte; keine zusätzlichen Nachweise.",
            "Für /livestock/endangered_breed_animals/0/animal_id wird nur der synthetische Index diagnostic-animal-0 benötigt; keine reale Tierkennung wird behauptet.",
            "/livestock/animals/0/approved_breeding_program → /livestock/endangered_breed_animals/0/approved_breeding_program: true unverändert."
          ],
          "unmapped_facts": [
            "/livestock/animals/0/breeding_facts/calved_by_stichtag=true hat keinen verlustfreien Ersatz durch /livestock/endangered_breed_animals/0/first_offspring_date: bekannt ist nur die Frist-Erfüllung, kein konkretes Kalbedatum.",
            "Luna liefert keine Werte für /livestock/endangered_breed_animals/0/{herdbook_registered,kept_in_austria,breeding_org_confirmation}; true wird nicht aus genehmigtem Zuchtprogramm abgeleitet.",
            "Luna liefert keine konkreten /oepul_participation/o6_5-Antragsdaten oder /farm/applicant-Fakten.",
            "/livestock/animals/0/held_to=2025-12-31: Opus verlangt gegebenenfalls /livestock/endangered_breed_animals/0/departure mit Abgangsgrund und Melde-/Ausnahmefakten. Ein Ende des bekannten Halteintervalls beweist weder Abgang an diesem Tag noch dessen Grund; es wird kein Ereignis erfunden."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; keine Aktualisierung des Untersuchungsjahrs.",
            "/livestock/animals/0/species=cattle und /animal_type=cow → /livestock/endangered_breed_animals/0/animal_category=kuh; der native Kategoriekatalog ordnet kuh der Art cattle zu.",
            "/livestock/animals/0/{breed,purebred,regular_breeding_use,purebred_mating,held_from} → /livestock/endangered_breed_animals/0/{breed,is_purebred,regular_breeding_use,purebred_mating_only,on_farm_from}: dieselben Werte; keine zusätzlichen Nachweise.",
            "Für /livestock/endangered_breed_animals/0/animal_id wird nur der synthetische Index diagnostic-animal-0 benötigt; keine reale Tierkennung wird behauptet.",
            "/livestock/animals/0/approved_breeding_program → /livestock/endangered_breed_animals/0/approved_breeding_program: true unverändert."
          ],
          "unmapped_facts": [
            "/livestock/animals/0/breeding_facts/calved_by_stichtag=true hat keinen verlustfreien Ersatz durch /livestock/endangered_breed_animals/0/first_offspring_date: bekannt ist nur die Frist-Erfüllung, kein konkretes Kalbedatum.",
            "Luna liefert keine Werte für /livestock/endangered_breed_animals/0/{herdbook_registered,kept_in_austria,breeding_org_confirmation}; true wird nicht aus genehmigtem Zuchtprogramm abgeleitet.",
            "Luna liefert keine konkreten /oepul_participation/o6_5-Antragsdaten oder /farm/applicant-Fakten.",
            "/livestock/animals/0/held_to=2025-12-30: Opus verlangt gegebenenfalls /livestock/endangered_breed_animals/0/departure mit Abgangsgrund und Melde-/Ausnahmefakten. Ein Ende des bekannten Halteintervalls beweist weder Abgang an diesem Tag noch dessen Grund; es wird kein Ereignis erfunden."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; keine Aktualisierung des Untersuchungsjahrs.",
            "/livestock/animals/0/species=cattle und /animal_type=cow → /livestock/endangered_breed_animals/0/animal_category=kuh; der native Kategoriekatalog ordnet kuh der Art cattle zu.",
            "/livestock/animals/0/{breed,purebred,regular_breeding_use,purebred_mating,held_from} → /livestock/endangered_breed_animals/0/{breed,is_purebred,regular_breeding_use,purebred_mating_only,on_farm_from}: dieselben Werte; keine zusätzlichen Nachweise.",
            "Für /livestock/endangered_breed_animals/0/animal_id wird nur der synthetische Index diagnostic-animal-0 benötigt; keine reale Tierkennung wird behauptet.",
            "/livestock/animals/0/approved_breeding_program → /livestock/endangered_breed_animals/0/approved_breeding_program: fehlt in beiden Eingaben."
          ],
          "unmapped_facts": [
            "/livestock/animals/0/breeding_facts/calved_by_stichtag=true hat keinen verlustfreien Ersatz durch /livestock/endangered_breed_animals/0/first_offspring_date: bekannt ist nur die Frist-Erfüllung, kein konkretes Kalbedatum.",
            "Luna liefert keine Werte für /livestock/endangered_breed_animals/0/{herdbook_registered,kept_in_austria,breeding_org_confirmation}; true wird nicht aus genehmigtem Zuchtprogramm abgeleitet.",
            "Luna liefert keine konkreten /oepul_participation/o6_5-Antragsdaten oder /farm/applicant-Fakten.",
            "/livestock/animals/0/held_to=2025-12-31: Opus verlangt gegebenenfalls /livestock/endangered_breed_animals/0/departure mit Abgangsgrund und Melde-/Ausnahmefakten. Ein Ende des bekannten Halteintervalls beweist weder Abgang an diesem Tag noch dessen Grund; es wird kein Ereignis erfunden."
          ]
        }
      ],
      "comparison_limit": "Nur abbildbare Einzelfakten werden verglichen. Die held_to-Variation hat im nativen Opus-Vertrag ohne erfundenen Abgang keine Eingabeänderung; gleiche Ausgaben dafür zeigen eine Übersetzungslücke, keine fachliche Robustheit. Zusätzliche Opus-Nachweise und konkrete Kalbedaten fehlen, deshalb kein direkter Vergleich vollständiger Tierförderbarkeit.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_5.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Einen synthetischen Einzeltiersachverhalt mit dem historischen Kandidaten ausführen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| variation | defined | no | Das Ende der Haltung um einen Tag vor die in holding_deadline verwendete Jahresendgrenze setzen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| missing_fact | defined | no | Den konsumierten Nachweis approved_breeding_program entfernen und den nativen Umgang mit unbekannten Fakten beobachten. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |

**Fixture gap:** Teilübersetzung: Die Jahresend-Haltevariation und der bloße Kalbe-Fristnachweis besitzen keine vollständig belegte native Ereignis-/Datumsabbildung.


**Open dependencies:**

- Konkretes Erstkalbedatum und eigenständige Zuchtbuch-/Zuchtorganisations-/Ortsnachweise für den nativen Opus-Vertrag fehlen im sichtbaren Luna-Fall.
- Die Haltedatum-Variation ist ohne Abgangsereignis und dessen fachliche Ausnahmen nicht verlustfrei abbildbar.
- Antragsteller- und Vertragsdaten fehlen; native Zugangs-/Prämienausgaben sind kein freigegebener Gesamtbescheid.

**Evidence:**

- [runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/common.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/eligibility.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/holding.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/holding.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_5-opus-5.5-high-20260925/workspace/policy/o6_5/decision.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_5-opus-5.5-high-20260925/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_5-opus-5.5-high-20260925/workspace/rules/profile_changes.json): Discover-Vorschläge zeigen die nativen Zusatzfelder; sie liefern keine fehlenden Betriebs-, Datums- oder Nachweiswerte.
- [runs/v2-o6_5-opus-5.5-high-20260925/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_5-opus-5.5-high-20260925/artifacts/input-paths.json): Historisches statisches Pfadinventar; Aliase und dynamische Zugriffe sind nicht vollständig abgebildet und es ist keine Laufzeitspur.

### o6_6

Run: `v2-o6_6-opus-5.5-high-20260925`. [Fixture](fixtures/o6_6.json) · [Native results](results/o6_6.json)

**Inputs:** Nativer Opus-Vertrag mit farm.year=2026, farm.oepul.measures und land.parcels[].operations.cover_crop. Flächen bleiben 2 ha; Saat-/Umbruch-/Antragsdaten und Variante 2 bleiben unverändert. harvested_share=1 wird rein rechnerisch zu 100 Prozent. Die synthetische Parzellen-ID ersetzt keine reale Identität; Mineral-N-Einsatz bekommt kein erfundenes Datum oder konkrete mechanische Methode.

**Output meaning:** decision liefert Betriebs-/Parzellenbefunde, fehlende Eingaben und Prämienbänder. Ein positiver nativer Teilbefund kann trotz fehlender konkreter Ereignis-/Methodennachweise entstehen. Insbesondere die übersetzte N-Variation ist kein datierter Opus-Sollfall; keine fachliche Gleichwertigkeit oder vollständige Förderfreigabe wird behauptet.

**Origin:** Öffentliche synthetische Entwicklungsdiagnose: ausschließlich Übersetzung der drei bereits sichtbaren Luna-Fälle aus docs/analysis/luna-screening-20261011/fixtures/o6_6.json. Keine unabhängigen Sollurteile und keine zurückgehaltenen Testfälle. Strukturelle Index-IDs bezeichnen nur synthetische Datensätze; fehlende fachliche Fakten werden nicht ergänzt.

**Query:** `data.oepul.o6_6.decision`

**Inventory:** 111 rule catalog entries; 8 sources; 10 static input paths; 47 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"calculation": 8, "combination": 5, "consequence": 2, "contract": 2, "deadline": 7, "definition": 11, "eligibility": 21, "exception": 16, "informational": 4, "obligation": 11, "permission": 4, "procedure": 9, "prohibition": 9, "sanction": 2}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.applicant",
      "input.farm.applicant.is_active_farmer",
      "input.farm.applicant.legal_form",
      "input.farm.applicant.public_body_share_percent",
      "input.farm.oepul.first_participation_year",
      "input.farm.oepul.inspection_announced_on",
      "input.farm.oepul.measures",
      "input.farm.region.district",
      "input.farm.region.federal_state",
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_6 | full_document | 46 | {"not_rule": 2, "rules": 44} |
| o6_general | full_document | 43 | {"not_rule": 14, "rules": 29} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 34 | {"not_rule": 9, "rules": 25} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"not_rule": 1, "rules": 5} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 7 | {"not_rule": 6, "rules": 1} |
| rebzikade_2026_insektizidverzicht | full_document | 2 | {"not_rule": 2} |
| duerre_2026_oepul_ausgleichszulage | full_document | 8 | {"not_rule": 2, "rules": 6} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 5, "rules": 3} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/o6_6/application_year → /farm/year: 2026 unverändert; kein erfundener erstmaliger Vertragsbeginn.",
            "/o6_6/{area_ha,arable_area_ha,land_use} → /land/parcels/0/area_ha, /land/arable_area_ha, /land/parcels/0/land_use: 2 ha/2 ha/arable unverändert.",
            "/o6_6/{variant,sow_date,break_date,full_coverage,mixing_partner_count,plant_family_count,variant_application_date} → /land/parcels/0/operations/cover_crop/{variant,sowing_date,termination_date,full_coverage_achieved,mixture_partner_count,plant_family_count,variant_applied_on}: unveränderte Fakten.",
            "/o6_6/measure_application_date → /farm/oepul/measures/0/applied_on; der Maßnahmencode 6 benennt ausschließlich den vorhandenen o6_6-Sachverhalt.",
            "/o6_6/harvested_share=1 → /land/parcels/0/operations/main_crop_harvest_share_percent=100: reine Einheitenumrechnung.",
            "/o6_6/active_sowing=true ist zusammen mit dem bekannten sow_date als vorhandene aktive Anlage repräsentiert; kein unbekannter Untersaat-/Hauptfruchternte-Sachverhalt wird ergänzt."
          ],
          "unmapped_facts": [
            "/o6_6/mechanical_removal=true ist keine konkrete /land/parcels/0/operations/cover_crop/termination_method aus der geschlossenen Methodenliste; es wird weder Pflug noch Grubber geraten.",
            "/o6_6/removal_done=true wird durch den bekannten break_date/termination_date-Kontext erhalten, kann aber den konkreten Methoden-Code nicht ersetzen.",
            "/o6_6/psm_applied=false hat im datierten Ereignisvertrag keinen getrennten Vollständigkeitsnachweis; es werden keine PSM-Ereignisse oder Ereigniszeitpunkte ergänzt.",
            "/o6_6/participates_immergruen=false wird durch keinen bekannten 7-Eintrag in der dargestellten, nur für diesen Sachverhalt befüllten Maßnahmenliste abgebildet. Dies bestätigt keine vollständige Liste anderer Teilnahmen.",
            "Der betrachtete application_year beweist keinen /farm/oepul/measures/0/contract_start_year; weitere Antragsteller-/Folgekulturfakten fehlen.",
            "/o6_6/mineral_n_applied ist false: Opus hat keine entsprechende Dreizustands-Eingabe, sondern eine Ereignisliste mit Datum. Baseline-Nichteinsatz und unbekannter Einsatz bleiben in der nativen Teilübersetzung ohne datiertes Event nicht unterscheidbar."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/o6_6/application_year → /farm/year: 2026 unverändert; kein erfundener erstmaliger Vertragsbeginn.",
            "/o6_6/{area_ha,arable_area_ha,land_use} → /land/parcels/0/area_ha, /land/arable_area_ha, /land/parcels/0/land_use: 2 ha/2 ha/arable unverändert.",
            "/o6_6/{variant,sow_date,break_date,full_coverage,mixing_partner_count,plant_family_count,variant_application_date} → /land/parcels/0/operations/cover_crop/{variant,sowing_date,termination_date,full_coverage_achieved,mixture_partner_count,plant_family_count,variant_applied_on}: unveränderte Fakten.",
            "/o6_6/measure_application_date → /farm/oepul/measures/0/applied_on; der Maßnahmencode 6 benennt ausschließlich den vorhandenen o6_6-Sachverhalt.",
            "/o6_6/harvested_share=1 → /land/parcels/0/operations/main_crop_harvest_share_percent=100: reine Einheitenumrechnung.",
            "/o6_6/active_sowing=true ist zusammen mit dem bekannten sow_date als vorhandene aktive Anlage repräsentiert; kein unbekannter Untersaat-/Hauptfruchternte-Sachverhalt wird ergänzt.",
            "/o6_6/mineral_n_applied=true → /land/parcels/0/operations/cover_crop/events/0/type=mineral_n_fertilization: nur Ereignisart/Existenz bekannt, Datum bewusst nicht ergänzt."
          ],
          "unmapped_facts": [
            "/o6_6/mechanical_removal=true ist keine konkrete /land/parcels/0/operations/cover_crop/termination_method aus der geschlossenen Methodenliste; es wird weder Pflug noch Grubber geraten.",
            "/o6_6/removal_done=true wird durch den bekannten break_date/termination_date-Kontext erhalten, kann aber den konkreten Methoden-Code nicht ersetzen.",
            "/o6_6/psm_applied=false hat im datierten Ereignisvertrag keinen getrennten Vollständigkeitsnachweis; es werden keine PSM-Ereignisse oder Ereigniszeitpunkte ergänzt.",
            "/o6_6/participates_immergruen=false wird durch keinen bekannten 7-Eintrag in der dargestellten, nur für diesen Sachverhalt befüllten Maßnahmenliste abgebildet. Dies bestätigt keine vollständige Liste anderer Teilnahmen.",
            "Der betrachtete application_year beweist keinen /farm/oepul/measures/0/contract_start_year; weitere Antragsteller-/Folgekulturfakten fehlen.",
            "/o6_6/mineral_n_applied=true belegt Einsatz im Luna-Prüfbereich, aber kein /land/parcels/0/operations/cover_crop/events/0/date. Opus event_in_period kann damit keine datierte Zeitraumprüfung vornehmen."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/o6_6/application_year → /farm/year: 2026 unverändert; kein erfundener erstmaliger Vertragsbeginn.",
            "/o6_6/{area_ha,arable_area_ha,land_use} → /land/parcels/0/area_ha, /land/arable_area_ha, /land/parcels/0/land_use: 2 ha/2 ha/arable unverändert.",
            "/o6_6/{variant,sow_date,break_date,full_coverage,mixing_partner_count,plant_family_count,variant_application_date} → /land/parcels/0/operations/cover_crop/{variant,sowing_date,termination_date,full_coverage_achieved,mixture_partner_count,plant_family_count,variant_applied_on}: unveränderte Fakten.",
            "/o6_6/measure_application_date → /farm/oepul/measures/0/applied_on; der Maßnahmencode 6 benennt ausschließlich den vorhandenen o6_6-Sachverhalt.",
            "/o6_6/harvested_share=1 → /land/parcels/0/operations/main_crop_harvest_share_percent=100: reine Einheitenumrechnung.",
            "/o6_6/active_sowing=true ist zusammen mit dem bekannten sow_date als vorhandene aktive Anlage repräsentiert; kein unbekannter Untersaat-/Hauptfruchternte-Sachverhalt wird ergänzt."
          ],
          "unmapped_facts": [
            "/o6_6/mechanical_removal=true ist keine konkrete /land/parcels/0/operations/cover_crop/termination_method aus der geschlossenen Methodenliste; es wird weder Pflug noch Grubber geraten.",
            "/o6_6/removal_done=true wird durch den bekannten break_date/termination_date-Kontext erhalten, kann aber den konkreten Methoden-Code nicht ersetzen.",
            "/o6_6/psm_applied=false hat im datierten Ereignisvertrag keinen getrennten Vollständigkeitsnachweis; es werden keine PSM-Ereignisse oder Ereigniszeitpunkte ergänzt.",
            "/o6_6/participates_immergruen=false wird durch keinen bekannten 7-Eintrag in der dargestellten, nur für diesen Sachverhalt befüllten Maßnahmenliste abgebildet. Dies bestätigt keine vollständige Liste anderer Teilnahmen.",
            "Der betrachtete application_year beweist keinen /farm/oepul/measures/0/contract_start_year; weitere Antragsteller-/Folgekulturfakten fehlen.",
            "/o6_6/mineral_n_applied ist nicht vorhanden: Opus hat keine entsprechende Dreizustands-Eingabe, sondern eine Ereignisliste mit Datum. Baseline-Nichteinsatz und unbekannter Einsatz bleiben in der nativen Teilübersetzung ohne datiertes Event nicht unterscheidbar."
          ]
        }
      ],
      "comparison_limit": "Jahre, Flächen, Varianten und die angegebenen Termine bleiben gleich. Mineral-N-Variation und Missing-Fact können nicht vollständig durch datierte Ereignisse ersetzt werden; gleicher Output ist dafür nicht als Modellqualität bewertbar. Mechanisch=true bestimmt keinen Methoden-Code. Breitere Opus-Antrags-/Folgekulturbedingungen sind nicht mit unabhängig ergänzten Werten befüllt.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_6.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Das native Entscheidungsobjekt für einen synthetischen Variante-2-Sachverhalt erfassen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| variation | defined | no | Nur mineral_n_applied auf true setzen, um eine konkret konsumierte Düngeinformation zu variieren. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| missing_fact | defined | no | mineral_n_applied entfernen und profile_missing gemeinsam mit eligible und violations beobachten. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |

**Fixture gap:** Teilübersetzung: N-Einsatz/Unbekanntheit ohne konkretes Ereignisdatum und boolesche mechanische Beseitigung ohne Methoden-Code.


**Open dependencies:**

- Datierte Düngungsereignisse und ein unabhängiger Vollständigkeitsnachweis der Ereignisliste fehlen.
- Die konkrete mechanische Beseitigungsmethode und Folgekulturinformationen sind im Luna-Fall nicht enthalten.
- Erstmaliger Vertragsbeginn und weitere allgemeine Antrags-/Betriebsnachweise dürfen nicht aus dem aktuellen Förderjahr abgeleitet werden.

**Evidence:**

- [runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/helpers.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/helpers.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/parcel.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/parcel.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/farm.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/farm.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/premium.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_6-opus-5.5-high-20260925/workspace/policy/o6_6/premium.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_6-opus-5.5-high-20260925/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_6-opus-5.5-high-20260925/workspace/rules/profile_changes.json): Discover-Vorschläge zeigen die nativen Zusatzfelder; sie liefern keine fehlenden Betriebs-, Datums- oder Nachweiswerte.
- [runs/v2-o6_6-opus-5.5-high-20260925/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_6-opus-5.5-high-20260925/artifacts/input-paths.json): Historisches statisches Pfadinventar; Aliase und dynamische Zugriffe sind nicht vollständig abgebildet und es ist keine Laufzeitspur.

### o6_7

Run: `v2-o6_7-opus-5.5-high-20260925`. [Fixture](fixtures/o6_7.json) · [Native results](results/o6_7.json)

**Inputs:** farm.year bleibt 2025; die aggregierte Ackerfläche ist 10 beziehungsweise 1,4 ha. Teilnahme und vorhandener Aufzeichnungsnachweis werden in farm.oepul.participations und documentation übertragen. Ein einziger bekannter Zwischenfruchtbeginn (Tag 250 = 2025-09-07), Partner-/Familienanzahl und Drusch-/PSM-Nichteinsatz werden als Teilsegment dargestellt. Es fehlen explizite Parzellenfläche/land_use und eine vollständige Zeitreihe; diese werden nicht aus der Betriebsfläche erfunden.

**Output meaning:** Die native Gesamtentscheidung trennt access_ok, measure_valid, tägliche coverage und violations. Opus berechnet Begrünung aus nativen Ackerschlägen und datierten Segmenten, statt eine aggregierte Eingangsquote zu prüfen. Mangels belegter Parzellenflächen/Jahresgeschichte ist diese coverage-Ausgabe kein gleichwertiger Test der Luna-Quote und keine vollständige Förderfreigabe.

**Origin:** Öffentliche synthetische Entwicklungsdiagnose: ausschließlich Übersetzung der drei bereits sichtbaren Luna-Fälle aus docs/analysis/luna-screening-20261011/fixtures/o6_7.json. Keine unabhängigen Sollurteile und keine zurückgehaltenen Testfälle. Strukturelle Index-IDs bezeichnen nur synthetische Datensätze; fehlende fachliche Fakten werden nicht ergänzt.

**Query:** `data.o6_7.decision`

**Inventory:** 107 rule catalog entries; 8 sources; 7 static input paths; 25 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"calculation": 8, "combination": 4, "consequence": 6, "context": 1, "contract_period": 2, "cross_reference": 1, "deadline": 3, "definition": 16, "documentation": 2, "eligibility": 6, "exception": 9, "exclusion": 6, "obligation": 12, "payment": 2, "permission": 8, "procedure": 7, "prohibition": 10, "sanction": 2, "scope": 1, "transition": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.documentation.field_records_complete",
      "input.farm.oepul.control_refusal_force_majeure",
      "input.farm.oepul.control_refused",
      "input.farm.oepul.first_participation_year",
      "input.farm.oepul.o6_7.first_contract_year",
      "input.farm.oepul.o6_7.premium_rate_eur_per_ha",
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_7 | full_document | 48 | {"not_rule": 5, "rules": 43} |
| o6_general | full_document | 39 | {"not_rule": 6, "rules": 33} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 41 | {"not_rule": 9, "rules": 32} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 8 | {"not_rule": 1, "rules": 7} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 6 | {"not_rule": 4, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 4 | {"not_rule": 4} |
| duerre_2026_oepul_ausgleichszulage | full_document | 7 | {"not_rule": 3, "rules": 4} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 6, "rules": 2} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; /farm/region und /land/arable_area_ha bleiben unverändert.",
            "/measure/o6_7/participating=true → /farm/oepul/participations/0/measure_code=7 im selben Jahr. /measure/o6_7/measure_6_participating=false bedeutet keinen bekannten 6-Eintrag, keine Vollständigkeitsbehauptung über weitere Maßnahmen.",
            "/measure/o6_7/field_records_complete → /documentation/field_records_complete: true unverändert.",
            "/land/parcels/0/parcel_id → /land/parcels/0/parcel_id: A1 bleibt synthetisch; keine Fläche oder Flächennutzung hinzuerfunden.",
            "/land/parcels/0/operations/cover_crop/is_used=true benennt /land/parcels/0/greening/segments/0/kind=catch_crop; active_planting_day_of_year=250 und /farm/year=2025 bestimmen start_date=2025-09-07 eindeutig.",
            "/land/parcels/0/operations/cover_crop/mixture_partners → /land/parcels/0/greening/segments/0/mixture/{partner_count,plant_family_count}: drei vorhandene Partner aus drei ausdrücklich verschiedenen Familien, keine Artennamen erfunden.",
            "/land/parcels/0/operations/cover_crop/threshed=false → /land/parcels/0/greening/segments/0/threshed=false; /land/parcels/0/operations/psm_used=false → /land/parcels/0/greening/segments/0/psm_dates=[] als bekannter Nichteinsatz."
          ],
          "unmapped_facts": [
            "/land/parcels/0 besitzt keine area_ha oder land_use. Die Aggregatfläche /land/arable_area_ha beweist nicht die Fläche/Flächennutzung dieses einzelnen Datensatzes; native arable_parcels kann das Teilsegment deshalb nicht als vollständig belegten Ackerschlag übernehmen.",
            "/land/parcels/0/operations/cover_crop/{duration_days=60,turnover_day_of_year=80} erlaubt ohne Jahr des Umbruchs und Endpunktdefinition keine eindeutige konsistente /land/parcels/0/greening/segments/0/end_date. Es wird kein Datum passend zum erwarteten Ergebnis erzeugt.",
            "/land/parcels/0/operations/cover_crop/gap_days/* liefert keine konkreten End-/Anfangsdaten angrenzender Hauptkultursegmente; die Jahresgeschichte und 100-%-Quote werden nicht synthetisch vervollständigt.",
            "/land/parcels/0/operations/cover_crop/winter_hardy_share_percent=80 ist keine belegte tatsächliche Abfrostungsquote frost_killed_share; es wird nicht blind zu 0,2 komplementiert.",
            "/land/parcels/0/operations/cover_crop/mechanical_removal=true nennt keinen nativen removal_method-Code; tillage_kills_cover=false und /operations/fertilizer/mineral_n_kg_per_ha=0 nennen keine datierten Bewirtschaftungsereignisse.",
            "/measure/o6_7/harvest_share_percent=100 ist im Opus-Vertrag ein schlagbezogener operations-Nachweis; ohne passende Schlagfläche/Flächennutzung wird kein Vollbetriebs-Nachweis auf einen unbekannten Ackerschlag übertragen.",
            "/measure/o6_7/cover_share_percent ist 100: Opus hat keinen aggregierten Eingabepfad für diese Quote. /land/parcels/*/greening/segments mit konkreten Flächen und vollständiger Jahresgeschichte ist erforderlich; der fehlende-Quote-Fall wird daher nicht durch eine erfundene Zeitreihe ersetzt."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; /farm/region und /land/arable_area_ha bleiben unverändert.",
            "/measure/o6_7/participating=true → /farm/oepul/participations/0/measure_code=7 im selben Jahr. /measure/o6_7/measure_6_participating=false bedeutet keinen bekannten 6-Eintrag, keine Vollständigkeitsbehauptung über weitere Maßnahmen.",
            "/measure/o6_7/field_records_complete → /documentation/field_records_complete: true unverändert.",
            "/land/parcels/0/parcel_id → /land/parcels/0/parcel_id: A1 bleibt synthetisch; keine Fläche oder Flächennutzung hinzuerfunden.",
            "/land/parcels/0/operations/cover_crop/is_used=true benennt /land/parcels/0/greening/segments/0/kind=catch_crop; active_planting_day_of_year=250 und /farm/year=2025 bestimmen start_date=2025-09-07 eindeutig.",
            "/land/parcels/0/operations/cover_crop/mixture_partners → /land/parcels/0/greening/segments/0/mixture/{partner_count,plant_family_count}: drei vorhandene Partner aus drei ausdrücklich verschiedenen Familien, keine Artennamen erfunden.",
            "/land/parcels/0/operations/cover_crop/threshed=false → /land/parcels/0/greening/segments/0/threshed=false; /land/parcels/0/operations/psm_used=false → /land/parcels/0/greening/segments/0/psm_dates=[] als bekannter Nichteinsatz."
          ],
          "unmapped_facts": [
            "/land/parcels/0 besitzt keine area_ha oder land_use. Die Aggregatfläche /land/arable_area_ha beweist nicht die Fläche/Flächennutzung dieses einzelnen Datensatzes; native arable_parcels kann das Teilsegment deshalb nicht als vollständig belegten Ackerschlag übernehmen.",
            "/land/parcels/0/operations/cover_crop/{duration_days=60,turnover_day_of_year=80} erlaubt ohne Jahr des Umbruchs und Endpunktdefinition keine eindeutige konsistente /land/parcels/0/greening/segments/0/end_date. Es wird kein Datum passend zum erwarteten Ergebnis erzeugt.",
            "/land/parcels/0/operations/cover_crop/gap_days/* liefert keine konkreten End-/Anfangsdaten angrenzender Hauptkultursegmente; die Jahresgeschichte und 100-%-Quote werden nicht synthetisch vervollständigt.",
            "/land/parcels/0/operations/cover_crop/winter_hardy_share_percent=80 ist keine belegte tatsächliche Abfrostungsquote frost_killed_share; es wird nicht blind zu 0,2 komplementiert.",
            "/land/parcels/0/operations/cover_crop/mechanical_removal=true nennt keinen nativen removal_method-Code; tillage_kills_cover=false und /operations/fertilizer/mineral_n_kg_per_ha=0 nennen keine datierten Bewirtschaftungsereignisse.",
            "/measure/o6_7/harvest_share_percent=100 ist im Opus-Vertrag ein schlagbezogener operations-Nachweis; ohne passende Schlagfläche/Flächennutzung wird kein Vollbetriebs-Nachweis auf einen unbekannten Ackerschlag übertragen.",
            "/measure/o6_7/cover_share_percent ist 100: Opus hat keinen aggregierten Eingabepfad für diese Quote. /land/parcels/*/greening/segments mit konkreten Flächen und vollständiger Jahresgeschichte ist erforderlich; der fehlende-Quote-Fall wird daher nicht durch eine erfundene Zeitreihe ersetzt."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; /farm/region und /land/arable_area_ha bleiben unverändert.",
            "/measure/o6_7/participating=true → /farm/oepul/participations/0/measure_code=7 im selben Jahr. /measure/o6_7/measure_6_participating=false bedeutet keinen bekannten 6-Eintrag, keine Vollständigkeitsbehauptung über weitere Maßnahmen.",
            "/measure/o6_7/field_records_complete → /documentation/field_records_complete: true unverändert.",
            "/land/parcels/0/parcel_id → /land/parcels/0/parcel_id: A1 bleibt synthetisch; keine Fläche oder Flächennutzung hinzuerfunden.",
            "/land/parcels/0/operations/cover_crop/is_used=true benennt /land/parcels/0/greening/segments/0/kind=catch_crop; active_planting_day_of_year=250 und /farm/year=2025 bestimmen start_date=2025-09-07 eindeutig.",
            "/land/parcels/0/operations/cover_crop/mixture_partners → /land/parcels/0/greening/segments/0/mixture/{partner_count,plant_family_count}: drei vorhandene Partner aus drei ausdrücklich verschiedenen Familien, keine Artennamen erfunden.",
            "/land/parcels/0/operations/cover_crop/threshed=false → /land/parcels/0/greening/segments/0/threshed=false; /land/parcels/0/operations/psm_used=false → /land/parcels/0/greening/segments/0/psm_dates=[] als bekannter Nichteinsatz."
          ],
          "unmapped_facts": [
            "/land/parcels/0 besitzt keine area_ha oder land_use. Die Aggregatfläche /land/arable_area_ha beweist nicht die Fläche/Flächennutzung dieses einzelnen Datensatzes; native arable_parcels kann das Teilsegment deshalb nicht als vollständig belegten Ackerschlag übernehmen.",
            "/land/parcels/0/operations/cover_crop/{duration_days=60,turnover_day_of_year=80} erlaubt ohne Jahr des Umbruchs und Endpunktdefinition keine eindeutige konsistente /land/parcels/0/greening/segments/0/end_date. Es wird kein Datum passend zum erwarteten Ergebnis erzeugt.",
            "/land/parcels/0/operations/cover_crop/gap_days/* liefert keine konkreten End-/Anfangsdaten angrenzender Hauptkultursegmente; die Jahresgeschichte und 100-%-Quote werden nicht synthetisch vervollständigt.",
            "/land/parcels/0/operations/cover_crop/winter_hardy_share_percent=80 ist keine belegte tatsächliche Abfrostungsquote frost_killed_share; es wird nicht blind zu 0,2 komplementiert.",
            "/land/parcels/0/operations/cover_crop/mechanical_removal=true nennt keinen nativen removal_method-Code; tillage_kills_cover=false und /operations/fertilizer/mineral_n_kg_per_ha=0 nennen keine datierten Bewirtschaftungsereignisse.",
            "/measure/o6_7/harvest_share_percent=100 ist im Opus-Vertrag ein schlagbezogener operations-Nachweis; ohne passende Schlagfläche/Flächennutzung wird kein Vollbetriebs-Nachweis auf einen unbekannten Ackerschlag übertragen.",
            "/measure/o6_7/cover_share_percent ist nicht vorhanden: Opus hat keinen aggregierten Eingabepfad für diese Quote. /land/parcels/*/greening/segments mit konkreten Flächen und vollständiger Jahresgeschichte ist erforderlich; der fehlende-Quote-Fall wird daher nicht durch eine erfundene Zeitreihe ersetzt."
          ]
        }
      ],
      "comparison_limit": "Nur der Mindestflächenvergleich und einzelne sicher übersetzbare Sachverhalte sind diagnostisch vergleichbar. Aggregierte Quote und fehlende Quote haben im nativen Zeitraumvertrag keine verlustfreie Repräsentation; gleichbleibende Ausgaben des Missing-Fact-Falls zeigen keine Robustheit. Tagesgenaue Begrünung kann erst mit unabhängig belegter Parzellen-/Zeitreihenbasis untersucht werden.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_7.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die native compliance-Ausgabe für einen synthetischen Begrünungssachverhalt aufnehmen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| variation | defined | yes | Nur die Ackerfläche von 10 auf 1,4 ha ändern und die Mindestflächenprüfung beobachten. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| missing_fact | defined | no | cover_share_percent entfernen und prüfen, ob der Kandidat fehlende Quote und festgestellte Erfüllung unterscheidet. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |

**Fixture gap:** Teilübersetzung: Aggregierte Quote, unbekannte Quote und grobe Dauer-/Tagwerte ersetzen keine vollständige native Parzellen-Zeitreihe.


**Open dependencies:**

- Die konkrete, vollständige Jahresgeschichte und Ackerschlagflächen/-nutzungen fehlen für den nativen täglichen Coverage-Vertrag.
- Umbruchjahr/-endpunkt sowie konkrete Beseitigungsverfahren und Bewirtschaftungsereignisse sind nicht aus den Luna-Aggregaten ableitbar.
- Zusätzliche Antrags-/Vertragsbeginnfakten bleiben offen; keine künstliche Positivbasis wird hergestellt.

**Evidence:**

- [runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/lib.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/lib.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/main.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/main.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_7-opus-5.5-high-20260925/workspace/rules/profile_changes.json): Discover-Vorschläge zeigen die nativen Zusatzfelder; sie liefern keine fehlenden Betriebs-, Datums- oder Nachweiswerte.
- [runs/v2-o6_7-opus-5.5-high-20260925/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_7-opus-5.5-high-20260925/artifacts/input-paths.json): Historisches statisches Pfadinventar; Aliase und dynamische Zugriffe sind nicht vollständig abgebildet und es ist keine Laufzeitspur.

### o6_8

Run: `v2-o6_8-opus-5.5-high-20261001`. [Fixture](fixtures/o6_8.json) · [Native results](results/o6_8.json)

**Inputs:** farm.year bleibt 2026 und Betriebsregion Burgenland/Güssing. Parzelle p1 mit 0,4 ha Acker/Grünbrache; BAW-Code, Ländercode AT und KG-Nummer werden in oepul_o6_8 umbenannt. Erosionspfadanteil bleibt 0,25 (Anteil, keine Prozentzahl), Fläche 0,10 beziehungsweise 0,09 ha. Der Missing-Fact-Fall entfernt auch im nativen Vertrag ausschließlich die KG-Nummer.

**Output meaning:** Native decision trennt contract_active/farm_access_ok, compliant_codes, Verstöße, Anwendungshinweise und Prämiensummen. Die Vierfachgrenze erscheint in Opus unter Anwendungshinweisen und Flächenkappung; das entspricht nicht automatisch Lunas Verletzungs-/Gesamtentscheidung. Fehlende Vertragsdaten können Prämienausgabe blockieren, obwohl der BAW-Teilbefund auswertbar bleibt; keine Förderung wird bestätigt.

**Origin:** Öffentliche synthetische Entwicklungsdiagnose: ausschließlich Übersetzung der drei bereits sichtbaren Luna-Fälle aus docs/analysis/luna-screening-20261011/fixtures/o6_8.json. Keine unabhängigen Sollurteile und keine zurückgehaltenen Testfälle. Strukturelle Index-IDs bezeichnen nur synthetische Datensätze; fehlende fachliche Fakten werden nicht ergänzt.

**Query:** `data.oepul.o6_8.decision`

**Inventory:** 114 rule catalog entries; 8 sources; 1 static input paths; 23 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 4, "combination": 5, "consequence": 8, "contract_period": 1, "cross_measure_effect": 4, "data_table": 4, "deadline": 4, "definition": 7, "documentation": 1, "eligibility": 7, "exception": 10, "exclusion": 8, "interpretation": 2, "obligation": 18, "option": 1, "permission": 4, "premium_calculation": 4, "premium_rate": 6, "procedure": 10, "prohibition": 5, "scope": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_8 | full_document | 59 | {"not_rule": 5, "rules": 54} |
| o6_general | full_document | 46 | {"not_rule": 13, "rules": 33} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 52 | {"not_rule": 11, "rules": 41} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 9 | {"not_rule": 4, "rules": 5} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 10 | {"not_rule": 7, "rules": 3} |
| rebzikade_2026_insektizidverzicht | full_document | 4 | {"not_rule": 4} |
| duerre_2026_oepul_ausgleichszulage | full_document | 7 | {"not_rule": 4, "rules": 3} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 6, "rules": 2} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/{year,region} → /farm/{year,region}: 2026/Burgenland/Güssing unverändert.",
            "/land/parcels/0/{parcel_id,area_ha,land_use,crop} bleiben unverändert; /application_codes → /oepul_o6_8/codes mit identischem BAW-Code.",
            "/land/parcels/0/country → /land/parcels/0/oepul_o6_8/location/country: AT unverändert.",
            "/land/parcels/0/erosion/erosion_entry_path_kg_number → /land/parcels/0/oepul_o6_8/location/kg_nr: String 31001 unverändert, wenn vorhanden.",
            "/land/parcels/0/erosion/{erosion_entry_path_share,erosion_entry_path_area_ha} → /land/parcels/0/oepul_o6_8/baw/{erosion_path_share,erosion_path_area_ha}: 0,25 und 0,10/0,09 ha unverändert."
          ],
          "unmapped_facts": [
            "Luna liefert keine Werte für /farm/oepul/o6_8/{contract_start_year,application_submitted_date} und allgemeine Antragsteller-/Vertragsnachweise; diese bleiben unbekannt.",
            "Luna liefert keine BAW-Neueinsaat-/Pflege-/Verpflichtungshistorie, Pufferstreifen oder vollständigen GIS-Lagenachweis. Der synthetische KG-Lookup ersetzt diese nicht."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/{year,region} → /farm/{year,region}: 2026/Burgenland/Güssing unverändert.",
            "/land/parcels/0/{parcel_id,area_ha,land_use,crop} bleiben unverändert; /application_codes → /oepul_o6_8/codes mit identischem BAW-Code.",
            "/land/parcels/0/country → /land/parcels/0/oepul_o6_8/location/country: AT unverändert.",
            "/land/parcels/0/erosion/erosion_entry_path_kg_number → /land/parcels/0/oepul_o6_8/location/kg_nr: String 31001 unverändert, wenn vorhanden.",
            "/land/parcels/0/erosion/{erosion_entry_path_share,erosion_entry_path_area_ha} → /land/parcels/0/oepul_o6_8/baw/{erosion_path_share,erosion_path_area_ha}: 0,25 und 0,10/0,09 ha unverändert."
          ],
          "unmapped_facts": [
            "Luna liefert keine Werte für /farm/oepul/o6_8/{contract_start_year,application_submitted_date} und allgemeine Antragsteller-/Vertragsnachweise; diese bleiben unbekannt.",
            "Luna liefert keine BAW-Neueinsaat-/Pflege-/Verpflichtungshistorie, Pufferstreifen oder vollständigen GIS-Lagenachweis. Der synthetische KG-Lookup ersetzt diese nicht."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/{year,region} → /farm/{year,region}: 2026/Burgenland/Güssing unverändert.",
            "/land/parcels/0/{parcel_id,area_ha,land_use,crop} bleiben unverändert; /application_codes → /oepul_o6_8/codes mit identischem BAW-Code.",
            "/land/parcels/0/country → /land/parcels/0/oepul_o6_8/location/country: AT unverändert.",
            "/land/parcels/0/erosion/erosion_entry_path_kg_number → /land/parcels/0/oepul_o6_8/location/kg_nr: String 31001 unverändert, wenn vorhanden.",
            "/land/parcels/0/erosion/{erosion_entry_path_share,erosion_entry_path_area_ha} → /land/parcels/0/oepul_o6_8/baw/{erosion_path_share,erosion_path_area_ha}: 0,25 und 0,10/0,09 ha unverändert.",
            "/land/parcels/0/erosion/erosion_entry_path_kg_number fehlt → /land/parcels/0/oepul_o6_8/location/kg_nr bleibt ebenfalls entfernt; kein Null-/Default-Ersatz."
          ],
          "unmapped_facts": [
            "Luna liefert keine Werte für /farm/oepul/o6_8/{contract_start_year,application_submitted_date} und allgemeine Antragsteller-/Vertragsnachweise; diese bleiben unbekannt.",
            "Luna liefert keine BAW-Neueinsaat-/Pflege-/Verpflichtungshistorie, Pufferstreifen oder vollständigen GIS-Lagenachweis. Der synthetische KG-Lookup ersetzt diese nicht."
          ]
        }
      ],
      "comparison_limit": "Die drei BAW-Kernfakten sind direkt übersetzt. Verglichen werden konkrete native Teilbefunde, nicht semantisch gleich benannte Gesamtflags oder vollständige Prämien: Opus behandelt Vierfachüberschreitung unter anderem als Anwendungshinweis/Flächenkappung, während Luna eine Verletzung mit teilweise undefinierter Entscheidung ausgibt. Breitere fehlende Vertragsdaten werden nicht ergänzt.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_8.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die native Entscheidung mit dem synthetischen BAW- und Vierfachflächenbeispiel erfassen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| variation | defined | yes | Nur die Eintragspfadfläche von 0,10 auf 0,09 ha setzen, sodass der native Vierfachvergleich eine andere Tatsachenbasis erhält. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| missing_fact | defined | no | Die konsumierte KG-Nummer entfernen; getrennt von Flächenbegrenzung und compliant die native Ausgabe beobachten. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |

**Open dependencies:**

- Antrags- und Vertragsbeginnfakten fehlen; native Gesamtfreigabe und Prämien sind deshalb keine unabhängigen Sollentscheidungen.
- Die fachliche Abgrenzung Viertelschwelle/teilweise und die maßgebliche GIS-Kulisse benötigen Referenzevidenz, wenn diese Fälle Teil der eigentlichen Studie werden.
- Pflege-, Anlage- und Flächenhistorie bleiben außerhalb der sichtbaren Luna-Fakten unbekannt.

**Evidence:**

- [runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/common.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_8-opus-5.5-high-20261001/workspace/rules/profile_changes.json): Discover-Vorschläge zeigen die nativen Zusatzfelder; sie liefern keine fehlenden Betriebs-, Datums- oder Nachweiswerte.
- [runs/v2-o6_8-opus-5.5-high-20261001/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_8-opus-5.5-high-20261001/artifacts/input-paths.json): Historisches statisches Pfadinventar; Aliase und dynamische Zugriffe sind nicht vollständig abgebildet und es ist keine Laufzeitspur.

### o6_9

Run: `v2-o6_9-opus-5.5-high-20261003`. [Fixture](fixtures/o6_9.json) · [Native results](results/o6_9.json)

**Inputs:** farm.year bleibt 2026 und Ackerfläche 20 ha. Natives oepul_measures.o6_9 enthält nur bekannte Ausbringungs-/Separationsaggregate 100/40 m³, die unverändert deklarierte Technik, Gülleart, mechanische Trennung, aggregierte 3 Rinder-GVE und ausdrücklich nicht gewählte Schweinefütterung. application.records und separation.records werden vollständig weggelassen: Luna liefert weder konkrete Einzelsätze, noch deren Anzahl, Mengen, Datum oder Parzellenzuordnung. Die fehlenden Felder bedeuten unbekannte Aufzeichnungen, keine bestätigte Abwesenheit von Ereignissen. 2 ha düngungswürdige Aggregatfläche wird nicht durch erfundene N-bedürftige Parzellen ersetzt.

**Output meaning:** decision verbindet eligible mit violations und liefert zusätzlich Prämienkomponenten, Fristen und Warnungen. Der neuere Opus-Kandidat erwartet konkrete Ereignisaufzeichnungen und parzellengestützte N-Bedarfsfläche. Der Kandidat behandelt die bewusst unbekannt gelassenen Aufzeichnungsfelder nativ möglicherweise wie leere Listen; daraus folgende Verletzungen sind diagnostische Vertrags-/Datenlücken, keine bestätigte tatsächliche Aufzeichnungslosigkeit und keine unabhängig gemessene Verschlechterung gegenüber Luna. Chronologie, Einzelmengen und Mengenabgleich sind nicht bestätigt. Prämien und Gesamtflags sind keine bestätigte Auszahlung.

**Origin:** Öffentliche synthetische Entwicklungsdiagnose: ausschließlich Übersetzung der drei bereits sichtbaren Luna-Fälle aus docs/analysis/luna-screening-20261011/fixtures/o6_9.json. Keine unabhängigen Sollurteile und keine zurückgehaltenen Testfälle. Strukturelle Index-IDs bezeichnen nur synthetische Datensätze; fehlende fachliche Fakten werden nicht ergänzt.

**Query:** `data.oepul.o6_9.decision`

**Inventory:** 89 rule catalog entries; 10 sources; 4 static input paths; 25 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_requirement": 2, "application": 2, "calculation": 6, "cap": 3, "combination": 2, "consequence": 1, "contract_period": 2, "contract_termination": 2, "cross_check": 2, "deadline": 7, "definition": 5, "documentation": 10, "eligibility": 8, "exception": 2, "exclusion": 5, "exit": 3, "force_majeure": 2, "minimum_participation": 1, "obligation": 8, "option": 2, "payment": 2, "premium_rate": 2, "procedure": 4, "sanction": 4, "threshold": 2}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm",
      "input.farm.applicant_type",
      "input.farm.oepul_first_participation_year",
      "input.farm.public_body_share_percent"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_9 | full_document | 38 | {"not_rule": 4, "rules": 34} |
| o6_general | full_document | 34 | {"not_rule": 16, "rules": 18} |
| srl_oepul_2023 | targeted_sections | 21 | {"not_rule": 2, "rules": 19} |
| srl_oepul_2023_anhaenge | targeted_sections | 4 | {"not_rule": 1, "rules": 3} |
| gsp_av_2026_01_28 | targeted_sections | 16 | {"not_rule": 2, "rules": 14} |
| napv_2024_10_28 | targeted_sections | 7 | {"not_rule": 1, "rules": 4, "unresolved": 2} |
| notice_2026_05_22_biodiversitaetsflaechen | full_document | 9 | {"not_rule": 8, "rules": 1} |
| notice_2026_06_12_insektizidverzicht_rebzikade | full_document | 3 | {"not_rule": 3} |
| notice_2026_08_05_duerre_oepul_az | full_document | 6 | {"not_rule": 4, "rules": 2} |
| notice_2026_08_12_duerre_foerderungsabwicklung | full_document | 7 | {"not_rule": 6, "rules": 1} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/year → /farm/year: 2026 unverändert; /farm/arable_area_ha und /calculation/arable_area_ha sind beide 20 und werden als /land/arable_area_ha=20 übertragen.",
            "/measure=o6_9 und /participation/categories=[application,separation] → Befüllung /oepul_measures/o6_9/slurry_application und /slurry_separation; diese bekannten Inhalte machen die Maßnahme im nativen Vertrag angefragt.",
            "/application/requested_m3 und /application/method → /oepul_measures/o6_9/slurry_application/volumes_m3/<method>: 100 m³ unter unverändert trailing_shoe beziehungsweise broadcast. broadcast wird nicht auf eine förderbare Technik korrigiert; der native Kandidat zählt nur seine zugelassenen Technikschlüssel.",
            "/application/manure_type=slurry → /oepul_measures/o6_9/slurry_application/manure_types=[slurry], ohne Umdeutung der Düngerart.",
            "/application/{injected_rainwater,is_water_mixed_solid_manure}=false → /oepul_measures/o6_9/slurry_application/{rainwater_volume_m3,solid_manure_with_water_volume_m3}=0: bekannte Abwesenheit dieser Komponenten, keine unbekannte positive Menge gesetzt.",
            "/separation/requested_m3=40 und /separation/mechanical_phase_separation=true → /oepul_measures/o6_9/slurry_separation/{separated_volume_m3=40,mechanical_separation=true}: bekannte beantragte Gesamtmenge und Trennungsart; kein Einzelaufzeichnungssatz abgeleitet.",
            "/separation/origin=own_cattle → /oepul_measures/o6_9/slurry_separation/{external_cattle_slurry_m3,non_cattle_slurry_m3}=0: ausschließlich eigener Rinderursprung bedeutet keine Fremd- oder Nicht-Rindermenge.",
            "/calculation/cattle_gve=3 → /livestock/species_groups/0/{species=cattle,gve=3}: der native alternative GVE-Pfad übernimmt den bekannten aggregierten Rinder-GVE-Wert, ohne eine neue Jahresmittel-Erhebung oder Roh-Tierzahl zu behaupten.",
            "/participation/groundwater_protection_pig_bonus=false → /oepul_measures/o6_9/participates_gwa_n_reduced_feeding_topup=false; fehlende pig_feeding-Kategorie und /pig_feeding/gve_pigs_annual_average=0 → /n_reduced_pig_feeding/{participates=false,pig_gve_annual_average=0}."
          ],
          "unmapped_facts": [
            "/calculation/eligible_fertilizable_area_ha=2 ist keine konkrete Liste /land/parcels mit Flächennutzung, Kultur und N-Düngebedarf. Es werden keine Parzellen, Kulturen oder Düngebedarfsnachweise erfunden; die native Kappungsbasis ist deshalb nicht direkt vergleichbar.",
            "/application/records_complete=true und die Namen /application/records_include liefern keine Werte für /oepul_measures/o6_9/slurry_application/records/*/{date,parcel_ids}. Ein vollständiger Nachweis kann nicht allein aus Feldnamen erzeugt werden.",
            "/separation/records_complete=true und /separation/records_include liefern kein konkretes /oepul_measures/o6_9/slurry_separation/records/*/date.",
            "/participation/measure_requested_by_december_31=true und /application/requested_by_december_31=true sind keine konkreten /oepul_measures/o6_9/{measure_application_date,contract_start_year} oder quantities/quantity_claim_date. Zudem verwendet Opus für die Mengenbeantragung 30.11.; der Luna-31.12.-Bool wird nicht mit einem erfundenen Novemberdatum ersetzt.",
            "/application/land_use=arable und /application/records_include enthält parcel belegen keine konkrete Parzellenkennung/-fläche. Die schlagbezogene Aufzeichnung bleibt unvollständig.",
            "/participation/base_measure_valid=true ist kein belastbarer Ersatz der im Opus-Vertrag einzeln zu prüfenden Antrags-/Zugangsvoraussetzungen; die allgemeine Vollständigkeit wird nicht per Flag erfunden.",
            "/pig_feeding/{all_pigs_compliant,proof_available}=true nennt keine Rations-/Rezepturwerte. Der nicht gewählte Schweinefütterungsteil wird nicht künstlich mit diesen Zusatzdaten befüllt.",
            "/participation/application_m3=100 und /application/requested_m3=100 belegen bekannte Gesamt-/Antragsmengen, aber weder Anzahl der Einzelausbringungen noch /oepul_measures/o6_9/slurry_application/records/*/volume_m3=100. Keine records-Sätze und keine leere als bestätigt geltende Liste werden erzeugt.",
            "/separation/separated_m3=40 und /separation/requested_m3=40 belegen Gesamt-/Antragsmengen, aber weder einen einzelnen Separationsvorgang noch /oepul_measures/o6_9/slurry_separation/records/*/volume_m3=40. Das gesamte records-Feld bleibt unbekannt und wird nicht gesetzt.",
            "/application/records_complete und /application/records_include sowie /separation/records_complete und /separation/records_include liefern nur summarische Bestätigungen beziehungsweise Feldnamen, keine konkreten Einträge. Chronologie, Einzelsatzmengen, Datums-/Parzellenzuordnung und nativer Mengenabgleich sind nicht ableitbar.",
            "/application/method ist ein bekanntes Vorgangsaggregat, kein belegter /oepul_measures/o6_9/slurry_application/records/*/technique-Eintrag. Die native Einzelrecord-Technikprüfung kann mit den vorhandenen Luna-Fakten nicht unabhängig ausgeführt werden."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/year → /farm/year: 2026 unverändert; /farm/arable_area_ha und /calculation/arable_area_ha sind beide 20 und werden als /land/arable_area_ha=20 übertragen.",
            "/measure=o6_9 und /participation/categories=[application,separation] → Befüllung /oepul_measures/o6_9/slurry_application und /slurry_separation; diese bekannten Inhalte machen die Maßnahme im nativen Vertrag angefragt.",
            "/application/requested_m3 und /application/method → /oepul_measures/o6_9/slurry_application/volumes_m3/<method>: 100 m³ unter unverändert trailing_shoe beziehungsweise broadcast. broadcast wird nicht auf eine förderbare Technik korrigiert; der native Kandidat zählt nur seine zugelassenen Technikschlüssel.",
            "/application/manure_type=slurry → /oepul_measures/o6_9/slurry_application/manure_types=[slurry], ohne Umdeutung der Düngerart.",
            "/application/{injected_rainwater,is_water_mixed_solid_manure}=false → /oepul_measures/o6_9/slurry_application/{rainwater_volume_m3,solid_manure_with_water_volume_m3}=0: bekannte Abwesenheit dieser Komponenten, keine unbekannte positive Menge gesetzt.",
            "/separation/requested_m3=40 und /separation/mechanical_phase_separation=true → /oepul_measures/o6_9/slurry_separation/{separated_volume_m3=40,mechanical_separation=true}: bekannte beantragte Gesamtmenge und Trennungsart; kein Einzelaufzeichnungssatz abgeleitet.",
            "/separation/origin=own_cattle → /oepul_measures/o6_9/slurry_separation/{external_cattle_slurry_m3,non_cattle_slurry_m3}=0: ausschließlich eigener Rinderursprung bedeutet keine Fremd- oder Nicht-Rindermenge.",
            "/calculation/cattle_gve=3 → /livestock/species_groups/0/{species=cattle,gve=3}: der native alternative GVE-Pfad übernimmt den bekannten aggregierten Rinder-GVE-Wert, ohne eine neue Jahresmittel-Erhebung oder Roh-Tierzahl zu behaupten.",
            "/participation/groundwater_protection_pig_bonus=false → /oepul_measures/o6_9/participates_gwa_n_reduced_feeding_topup=false; fehlende pig_feeding-Kategorie und /pig_feeding/gve_pigs_annual_average=0 → /n_reduced_pig_feeding/{participates=false,pig_gve_annual_average=0}."
          ],
          "unmapped_facts": [
            "/calculation/eligible_fertilizable_area_ha=2 ist keine konkrete Liste /land/parcels mit Flächennutzung, Kultur und N-Düngebedarf. Es werden keine Parzellen, Kulturen oder Düngebedarfsnachweise erfunden; die native Kappungsbasis ist deshalb nicht direkt vergleichbar.",
            "/application/records_complete=true und die Namen /application/records_include liefern keine Werte für /oepul_measures/o6_9/slurry_application/records/*/{date,parcel_ids}. Ein vollständiger Nachweis kann nicht allein aus Feldnamen erzeugt werden.",
            "/separation/records_complete=true und /separation/records_include liefern kein konkretes /oepul_measures/o6_9/slurry_separation/records/*/date.",
            "/participation/measure_requested_by_december_31=true und /application/requested_by_december_31=true sind keine konkreten /oepul_measures/o6_9/{measure_application_date,contract_start_year} oder quantities/quantity_claim_date. Zudem verwendet Opus für die Mengenbeantragung 30.11.; der Luna-31.12.-Bool wird nicht mit einem erfundenen Novemberdatum ersetzt.",
            "/application/land_use=arable und /application/records_include enthält parcel belegen keine konkrete Parzellenkennung/-fläche. Die schlagbezogene Aufzeichnung bleibt unvollständig.",
            "/participation/base_measure_valid=true ist kein belastbarer Ersatz der im Opus-Vertrag einzeln zu prüfenden Antrags-/Zugangsvoraussetzungen; die allgemeine Vollständigkeit wird nicht per Flag erfunden.",
            "/pig_feeding/{all_pigs_compliant,proof_available}=true nennt keine Rations-/Rezepturwerte. Der nicht gewählte Schweinefütterungsteil wird nicht künstlich mit diesen Zusatzdaten befüllt.",
            "/participation/application_m3=100 und /application/requested_m3=100 belegen bekannte Gesamt-/Antragsmengen, aber weder Anzahl der Einzelausbringungen noch /oepul_measures/o6_9/slurry_application/records/*/volume_m3=100. Keine records-Sätze und keine leere als bestätigt geltende Liste werden erzeugt.",
            "/separation/separated_m3=40 und /separation/requested_m3=40 belegen Gesamt-/Antragsmengen, aber weder einen einzelnen Separationsvorgang noch /oepul_measures/o6_9/slurry_separation/records/*/volume_m3=40. Das gesamte records-Feld bleibt unbekannt und wird nicht gesetzt.",
            "/application/records_complete und /application/records_include sowie /separation/records_complete und /separation/records_include liefern nur summarische Bestätigungen beziehungsweise Feldnamen, keine konkreten Einträge. Chronologie, Einzelsatzmengen, Datums-/Parzellenzuordnung und nativer Mengenabgleich sind nicht ableitbar.",
            "/application/method ist ein bekanntes Vorgangsaggregat, kein belegter /oepul_measures/o6_9/slurry_application/records/*/technique-Eintrag. Die native Einzelrecord-Technikprüfung kann mit den vorhandenen Luna-Fakten nicht unabhängig ausgeführt werden."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/year → /farm/year: 2026 unverändert; /farm/arable_area_ha und /calculation/arable_area_ha sind beide 20 und werden als /land/arable_area_ha=20 übertragen.",
            "/measure=o6_9 und /participation/categories=[application,separation] → Befüllung /oepul_measures/o6_9/slurry_application und /slurry_separation; diese bekannten Inhalte machen die Maßnahme im nativen Vertrag angefragt.",
            "/application/requested_m3 und /application/method → /oepul_measures/o6_9/slurry_application/volumes_m3/<method>: 100 m³ unter unverändert trailing_shoe beziehungsweise broadcast. broadcast wird nicht auf eine förderbare Technik korrigiert; der native Kandidat zählt nur seine zugelassenen Technikschlüssel.",
            "/application/manure_type=slurry → /oepul_measures/o6_9/slurry_application/manure_types=[slurry], ohne Umdeutung der Düngerart.",
            "/application/{injected_rainwater,is_water_mixed_solid_manure}=false → /oepul_measures/o6_9/slurry_application/{rainwater_volume_m3,solid_manure_with_water_volume_m3}=0: bekannte Abwesenheit dieser Komponenten, keine unbekannte positive Menge gesetzt.",
            "/separation/requested_m3=40 und /separation/mechanical_phase_separation=true → /oepul_measures/o6_9/slurry_separation/{separated_volume_m3=40,mechanical_separation=true}: bekannte beantragte Gesamtmenge und Trennungsart; kein Einzelaufzeichnungssatz abgeleitet.",
            "/separation/origin=own_cattle → /oepul_measures/o6_9/slurry_separation/{external_cattle_slurry_m3,non_cattle_slurry_m3}=0: ausschließlich eigener Rinderursprung bedeutet keine Fremd- oder Nicht-Rindermenge.",
            "/calculation/cattle_gve=3 → /livestock/species_groups/0/{species=cattle,gve=3}: der native alternative GVE-Pfad übernimmt den bekannten aggregierten Rinder-GVE-Wert, ohne eine neue Jahresmittel-Erhebung oder Roh-Tierzahl zu behaupten.",
            "/participation/groundwater_protection_pig_bonus=false → /oepul_measures/o6_9/participates_gwa_n_reduced_feeding_topup=false; fehlende pig_feeding-Kategorie und /pig_feeding/gve_pigs_annual_average=0 → /n_reduced_pig_feeding/{participates=false,pig_gve_annual_average=0}."
          ],
          "unmapped_facts": [
            "/calculation/eligible_fertilizable_area_ha=2 ist keine konkrete Liste /land/parcels mit Flächennutzung, Kultur und N-Düngebedarf. Es werden keine Parzellen, Kulturen oder Düngebedarfsnachweise erfunden; die native Kappungsbasis ist deshalb nicht direkt vergleichbar.",
            "/application/records_complete=true und die Namen /application/records_include liefern keine Werte für /oepul_measures/o6_9/slurry_application/records/*/{date,parcel_ids}. Ein vollständiger Nachweis kann nicht allein aus Feldnamen erzeugt werden.",
            "/separation/records_complete=true und /separation/records_include liefern kein konkretes /oepul_measures/o6_9/slurry_separation/records/*/date.",
            "/participation/measure_requested_by_december_31=true und /application/requested_by_december_31=true sind keine konkreten /oepul_measures/o6_9/{measure_application_date,contract_start_year} oder quantities/quantity_claim_date. Zudem verwendet Opus für die Mengenbeantragung 30.11.; der Luna-31.12.-Bool wird nicht mit einem erfundenen Novemberdatum ersetzt.",
            "/application/land_use=arable und /application/records_include enthält parcel belegen keine konkrete Parzellenkennung/-fläche. Die schlagbezogene Aufzeichnung bleibt unvollständig.",
            "/participation/base_measure_valid=true ist kein belastbarer Ersatz der im Opus-Vertrag einzeln zu prüfenden Antrags-/Zugangsvoraussetzungen; die allgemeine Vollständigkeit wird nicht per Flag erfunden.",
            "/pig_feeding/{all_pigs_compliant,proof_available}=true nennt keine Rations-/Rezepturwerte. Der nicht gewählte Schweinefütterungsteil wird nicht künstlich mit diesen Zusatzdaten befüllt.",
            "/application/records_include fehlt. /oepul_measures/o6_9/slurry_application/records wird ebenfalls nicht befüllt; records_complete=true aus Luna liefert keine individuellen Aufzeichnungswerte.",
            "/participation/application_m3=100 und /application/requested_m3=100 belegen bekannte Gesamt-/Antragsmengen, aber weder Anzahl der Einzelausbringungen noch /oepul_measures/o6_9/slurry_application/records/*/volume_m3=100. Keine records-Sätze und keine leere als bestätigt geltende Liste werden erzeugt.",
            "/separation/separated_m3=40 und /separation/requested_m3=40 belegen Gesamt-/Antragsmengen, aber weder einen einzelnen Separationsvorgang noch /oepul_measures/o6_9/slurry_separation/records/*/volume_m3=40. Das gesamte records-Feld bleibt unbekannt und wird nicht gesetzt.",
            "/application/records_complete und /application/records_include sowie /separation/records_complete und /separation/records_include liefern nur summarische Bestätigungen beziehungsweise Feldnamen, keine konkreten Einträge. Chronologie, Einzelsatzmengen, Datums-/Parzellenzuordnung und nativer Mengenabgleich sind nicht ableitbar.",
            "/application/method ist ein bekanntes Vorgangsaggregat, kein belegter /oepul_measures/o6_9/slurry_application/records/*/technique-Eintrag. Die native Einzelrecord-Technikprüfung kann mit den vorhandenen Luna-Fakten nicht unabhängig ausgeführt werden."
          ]
        }
      ],
      "comparison_limit": "Mengen, Jahr und bekannte deklarierte Technik bleiben gleich. Die Variante broadcast bleibt unverändert, wird jedoch vom nativen Opus-MFA-Mengenkatalog nicht als zulässiger Mengenschlüssel gezählt. Einzelaufzeichnungen werden nicht aus 100/40-m³-Aggregaten, records_complete oder Feldnamen erzeugt; beide records-Felder fehlen als unbekannte Daten. Deshalb sind Chronologie, Einzeltechniken und Mengenabgleich nicht bestätigt. Baseline und missing_fact besitzen bezüglich der unbekannten Records denselben nativen Input; identische Ausgaben dafür belegen keine Robustheit. Auch die 2-ha-Prämienbasis und konkreten Fristen sind nicht verlustfrei abbildbar. Kein direkter Gesamtprämien-/eligible-Qualitätsvergleich.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_9.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Native Ausbringungs- und Separationsausgabe auf einer vollständig synthetischen Mengenbasis aufnehmen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. Einzelaufzeichnungen bleiben unbekannt und fehlen im nativen Input; keine Aggregate werden zu Ereignissätzen umgedeutet. |
| variation | defined | yes | Nur application.method von trailing_shoe auf broadcast ändern und Teilurteil sowie verbleibende Prämienkomponenten prüfen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. Einzelaufzeichnungen bleiben unbekannt und fehlen im nativen Input; keine Aggregate werden zu Ereignissätzen umgedeutet. |
| missing_fact | defined | no | Nur application.records_include entfernen und violations gemeinsam mit eligible und premium beobachten. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. Einzelaufzeichnungen bleiben unbekannt und fehlen im nativen Input; keine Aggregate werden zu Ereignissätzen umgedeutet. |

**Fixture gap:** Teilübersetzung: Aggregatflächen/-mengen, bestätigte Aufzeichnungs-Feldnamen und Frist-Bools liefern keine konkreten Opus-Ereignis-, Parzellen- oder Datumsnachweise; records bleiben als unbekannt vollständig ungesetzt.


**Open dependencies:**

- Native Ausbringungs-/Separationsaufzeichnungen brauchen unabhängig festgelegte konkrete synthetische Einzelsätze mit Datums-, Einzelmengen-, Technik- und Parzellenwerten. Bekannte Aggregate liefern weder Ereigniszahl noch Chronologie oder Mengenabgleich.
- Parzellengestützter N-Düngebedarf und die 2-ha-Aggregatbasis müssen in einem gemeinsamen Studienvertrag vereinbart werden.
- Antrags-/Mengenfristen und Jahresmittel-Rinder-GVE sind zwischen Kandidaten nicht allein durch gleichnamige Aggregate äquivalent.
- Unzulässige broadcast-Technik wird nicht zu einer zugelassenen Methode normalisiert; Mengen- und Fehlermeldungssemantik bleiben getrennt zu beurteilen.

**Evidence:**

- [runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/common.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/participation.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/participation.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/decision.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_9-opus-5.5-high-20261003/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/workspace/rules/profile_changes.json): Discover-Vorschläge zeigen die nativen Zusatzfelder; sie liefern keine fehlenden Betriebs-, Datums- oder Nachweiswerte.
- [runs/v2-o6_9-opus-5.5-high-20261003/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_9-opus-5.5-high-20261003/artifacts/input-paths.json): Historisches statisches Pfadinventar; Aliase und dynamische Zugriffe sind nicht vollständig abgebildet und es ist keine Laufzeitspur.

### o6_10

Run: `v2-o6_10-opus-5.5-high-20260925`. [Fixture](fixtures/o6_10.json) · [Native results](results/o6_10.json)

**Inputs:** farm.year bleibt 2025; die bekannte Weinfläche bleibt 1 ha mit 30 Prozent Hangneigung, außer dem unverändert fehlenden Hangwert im Missing-Fact-Fall. Die inter_row_greening-Felder übernehmen volle Fahrgassenbegrünung, drei winterharte Partner, 80/81 cm offene Breite, sown_mixture und mechanical. Der synthetische Parzellenindex ist keine zusätzliche reale Flächenidentität. Keine erfundenen Antragsdaten oder Aufzeichnungspunkte.

**Output meaning:** decision trennt contract_status/contract_valid, Zugang, Parzellen-/Betriebsverpflichtungen und Prämienkomponenten. requested=true aus Luna ersetzt im Opus-Vertrag keinen konkreten rechtzeitigen Maßnahmenantrag; no_application oder Aufzeichnungslücken dürfen nicht als fachliche Modellgüte bewertet werden. Die Breiten- und fehlende-Hangneigung-Teilprüfungen bleiben sichtbar; keine Förder-/Auszahlungsfreigabe.

**Origin:** Öffentliche synthetische Entwicklungsdiagnose: ausschließlich Übersetzung der drei bereits sichtbaren Luna-Fälle aus docs/analysis/luna-screening-20261011/fixtures/o6_10.json. Keine unabhängigen Sollurteile und keine zurückgehaltenen Testfälle. Strukturelle Index-IDs bezeichnen nur synthetische Datensätze; fehlende fachliche Fakten werden nicht ergänzt.

**Query:** `data.oepul.o6_10.decision`

**Inventory:** 91 rule catalog entries; 8 sources; 1 static input paths; 20 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 6, "application": 5, "classification": 1, "combination": 2, "consequence": 2, "contract_term": 3, "data_source": 1, "deadline": 3, "definition": 3, "eligibility": 5, "exemption": 7, "exit": 4, "general_condition": 2, "interpretation": 1, "obligation": 13, "payment": 2, "premium_calculation": 8, "premium_exclusion": 7, "procedure": 5, "record_keeping": 3, "sanction": 3, "scope": 2, "scope_exclusion": 1, "supplement_condition": 2}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_10 | full_document | 28 | {"not_rule": 4, "rules": 24} |
| o6_general | full_document | 40 | {"not_rule": 13, "rules": 27} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 33 | {"not_rule": 7, "rules": 26} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"not_rule": 3, "rules": 3} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 6 | {"not_rule": 4, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 3 | {"not_rule": 1, "rules": 1, "unresolved": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 3 | {"not_rule": 1, "rules": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 7 | {"not_rule": 6, "rules": 1} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; /land/parcels/0/{area_ha,land_use,crop,slope_percent} bleiben unverändert, soweit vorhanden.",
            "/land/parcels/0/o6_10/{full_year_and_all_alleys_cover,hardy_mixture_partners,open_stem_width_cm,cover_type,cover_removal_method} → /land/parcels/0/operations/inter_row_greening/{full_coverage_all_inter_rows_all_year,winter_hardy_mixture_partners,open_strip_width_cm,establishment_method,removal_method}: dieselben Werte inklusive 80/81 cm.",
            "/o6_10/requested=true → /farm/oepul/participating_measures=[10] als bekannter Teilnahme-/Anfragebezug, ohne Behauptung konkreter fristgerechter Antragswerte.",
            "/o6_10/organism_or_pheromone_surcharge_requested=false → kein EOP-Code in /land/parcels/0/oepul_codes; es werden keine anderen unbekannten Schlagcodes behauptet.",
            "Für /land/parcels/0/parcel_id wird nur diagnostic-parcel-0 als struktureller Index eingeführt, weil Luna keinen Identifier liefert."
          ],
          "unmapped_facts": [
            "/o6_10/requested=true benennt weder /farm/oepul/o6_10/measure_application_date noch eine gültige Übernahme; diese werden nicht durch ein frei gewähltes Vorjahresdatum ersetzt.",
            "/o6_10/records={} enthält keine /documentation/o6_10_greening_record_items; die native Aufzeichnungsliste wird nicht mit verlangten Belegnamen künstlich gefüllt.",
            "/land/parcels/0/o6_10/surcharge_applied=true ist zusammen mit /o6_10/organism_or_pheromone_surcharge_requested=false keine eindeutige Grundlage für einen EOP-Antrag oder registerkonformen Organismen-/Pheromoneneinsatz. Es wird kein EOP-Code oder Nachweis erfunden.",
            "Luna liefert kein /land/parcels/0/permanent_crop/planting_system. Opus verwendet seinen dokumentierten single_row-Default; das ist keine neu bestätigte Pflanzsystemtatsache."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; /land/parcels/0/{area_ha,land_use,crop,slope_percent} bleiben unverändert, soweit vorhanden.",
            "/land/parcels/0/o6_10/{full_year_and_all_alleys_cover,hardy_mixture_partners,open_stem_width_cm,cover_type,cover_removal_method} → /land/parcels/0/operations/inter_row_greening/{full_coverage_all_inter_rows_all_year,winter_hardy_mixture_partners,open_strip_width_cm,establishment_method,removal_method}: dieselben Werte inklusive 80/81 cm.",
            "/o6_10/requested=true → /farm/oepul/participating_measures=[10] als bekannter Teilnahme-/Anfragebezug, ohne Behauptung konkreter fristgerechter Antragswerte.",
            "/o6_10/organism_or_pheromone_surcharge_requested=false → kein EOP-Code in /land/parcels/0/oepul_codes; es werden keine anderen unbekannten Schlagcodes behauptet.",
            "Für /land/parcels/0/parcel_id wird nur diagnostic-parcel-0 als struktureller Index eingeführt, weil Luna keinen Identifier liefert."
          ],
          "unmapped_facts": [
            "/o6_10/requested=true benennt weder /farm/oepul/o6_10/measure_application_date noch eine gültige Übernahme; diese werden nicht durch ein frei gewähltes Vorjahresdatum ersetzt.",
            "/o6_10/records={} enthält keine /documentation/o6_10_greening_record_items; die native Aufzeichnungsliste wird nicht mit verlangten Belegnamen künstlich gefüllt.",
            "/land/parcels/0/o6_10/surcharge_applied=true ist zusammen mit /o6_10/organism_or_pheromone_surcharge_requested=false keine eindeutige Grundlage für einen EOP-Antrag oder registerkonformen Organismen-/Pheromoneneinsatz. Es wird kein EOP-Code oder Nachweis erfunden.",
            "Luna liefert kein /land/parcels/0/permanent_crop/planting_system. Opus verwendet seinen dokumentierten single_row-Default; das ist keine neu bestätigte Pflanzsystemtatsache."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/year → /farm/year: 2025 unverändert; /land/parcels/0/{area_ha,land_use,crop,slope_percent} bleiben unverändert, soweit vorhanden.",
            "/land/parcels/0/o6_10/{full_year_and_all_alleys_cover,hardy_mixture_partners,open_stem_width_cm,cover_type,cover_removal_method} → /land/parcels/0/operations/inter_row_greening/{full_coverage_all_inter_rows_all_year,winter_hardy_mixture_partners,open_strip_width_cm,establishment_method,removal_method}: dieselben Werte inklusive 80/81 cm.",
            "/o6_10/requested=true → /farm/oepul/participating_measures=[10] als bekannter Teilnahme-/Anfragebezug, ohne Behauptung konkreter fristgerechter Antragswerte.",
            "/o6_10/organism_or_pheromone_surcharge_requested=false → kein EOP-Code in /land/parcels/0/oepul_codes; es werden keine anderen unbekannten Schlagcodes behauptet.",
            "Für /land/parcels/0/parcel_id wird nur diagnostic-parcel-0 als struktureller Index eingeführt, weil Luna keinen Identifier liefert.",
            "/land/parcels/0/slope_percent fehlt → /land/parcels/0/slope_percent bleibt entfernt. Der native Default 0 wird nicht als belegte flache Lage übernommen."
          ],
          "unmapped_facts": [
            "/o6_10/requested=true benennt weder /farm/oepul/o6_10/measure_application_date noch eine gültige Übernahme; diese werden nicht durch ein frei gewähltes Vorjahresdatum ersetzt.",
            "/o6_10/records={} enthält keine /documentation/o6_10_greening_record_items; die native Aufzeichnungsliste wird nicht mit verlangten Belegnamen künstlich gefüllt.",
            "/land/parcels/0/o6_10/surcharge_applied=true ist zusammen mit /o6_10/organism_or_pheromone_surcharge_requested=false keine eindeutige Grundlage für einen EOP-Antrag oder registerkonformen Organismen-/Pheromoneneinsatz. Es wird kein EOP-Code oder Nachweis erfunden.",
            "Luna liefert kein /land/parcels/0/permanent_crop/planting_system. Opus verwendet seinen dokumentierten single_row-Default; das ist keine neu bestätigte Pflanzsystemtatsache."
          ]
        }
      ],
      "comparison_limit": "Die konkrete Breitenvariation und das entfernte Hangfeld sind direkt übersetzbar. Die native Gesamtförderung ist wegen fehlender echter Antrags-/Aufzeichnungsdaten nicht mit Lunas requested-Flag identisch. Opus-Defaults (unter anderem single_row und fehlende Hangneigung als 0) sind beobachtete Kandidatenannahmen, keine Ergänzung unabhängiger Fakten.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_10.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die öffentlichen nativen Teilurteile und Prämienausgaben für das synthetische Weinflächenbeispiel aufnehmen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| variation | defined | yes | Nur open_stem_width_cm von 80 auf 81 cm setzen und die konsumierte Breitenprüfung beobachten. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |
| missing_fact | defined | no | slope_percent entfernen und den nativen Default bei der für Prämiensätze verwendeten Hangneigung sichtbar machen. Identische Luna-Fakten soweit der native Opus-Vertrag sie ohne Zusatzannahmen darstellen kann; Übersetzungslücken separat dokumentiert. |

**Open dependencies:**

- Konkrete Antrags-/Vertrags- und Aufzeichnungsnachweise fehlen für die vollständige native Entscheidung.
- Pflanzsystem und belastbare GIS-Hangneigung erfordern einen gemeinsamen Eingabevertrag; Defaults werden nicht als echte Farmfakten bestätigt.
- Die uneindeutige Kombination surcharge_applied=true/surcharge_requested=false wird nicht zu einem erfundenen EOP-Antrag normalisiert.

**Evidence:**

- [runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/helpers.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/helpers.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/access.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/access.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/decision.rego): Nativer Eingabe-/Ausgabevertrag; unveränderter, aus dem gepinnten Opus-Bestand gelesener Kandidat.
- [runs/v2-o6_10-opus-5.5-high-20260925/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_10-opus-5.5-high-20260925/workspace/rules/profile_changes.json): Discover-Vorschläge zeigen die nativen Zusatzfelder; sie liefern keine fehlenden Betriebs-, Datums- oder Nachweiswerte.
- [runs/v2-o6_10-opus-5.5-high-20260925/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_10-opus-5.5-high-20260925/artifacts/input-paths.json): Historisches statisches Pfadinventar; Aliase und dynamische Zugriffe sind nicht vollständig abgebildet und es ist keine Laufzeitspur.

### o6_11

Run: `v2-o6_11-opus-5.5-high-20261001`. [Fixture](fixtures/o6_11.json) · [Native results](results/o6_11.json)

**Inputs:** Jahr 2024, schlagbezogene Fläche in ha, Weinfläche und PSM-Anwendungsliste. Antrags-/Vertragsjahr werden nicht zu erfundenen Antragstagen ergänzt. Die gesamte Anwendungsliste fehlt im missing_fact-Fall; baseline enthält die explizit leere Liste.

**Output meaning:** Native Gesamtentscheidung mit participates, contract_valid, compliant, Zugangsausfällen, Verletzungen, schlagbezogenen Ergebnissen und Prämien. False oder leere Verletzungen sind native Beobachtungen und kein Beweis vollständiger Eingaben oder Förderfähigkeit.

**Origin:** Öffentliche synthetische Entwicklungsfälle der eingefrorenen Luna-Diagnose, durch Codex ausschließlich auf belegte native Opus-Pfade übersetzt. Keine unabhängigen Sollurteile, keine Expertenfreigabe und keine Held-out-Fälle. Fehlende Fachfakten werden nicht aus Opus-Modelltests ergänzt.

**Query:** `data.oepul.o6_11.decision`

**Inventory:** 76 rule catalog entries; 8 sources; 1 static input paths; 10 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 5, "application": 3, "calculation": 5, "classification": 1, "combination": 2, "consequence": 1, "contract_period": 3, "definition": 4, "documentation_obligation": 5, "eligibility_scope": 1, "exception": 1, "exit": 7, "general_condition": 2, "measure_switch": 1, "obligation": 5, "payment": 2, "premium": 1, "premium_eligibility": 11, "procedure": 12, "sanction": 1, "scope_note": 2, "transition": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_11 | full_document | 28 | {"not_rule": 4, "rules": 24} |
| o6_general | full_document | 39 | {"not_rule": 11, "rules": 28} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 27 | {"not_rule": 7, "rules": 20} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 4 | {"not_rule": 2, "rules": 2} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 4 | {"not_rule": 3, "rules": 1} |
| rebzikade_2026_insektizidverzicht | full_document | 3 | {"not_rule": 2, "rules": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 2 | {"not_rule": 1, "rules": 1} |
| duerre_2026_foerderungsabwicklung | full_document | 7 | {"not_rule": 6, "rules": 1} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Historisches Betrachtungsjahr unverändert.",
            "Luna /farm/oepul/o6_11_contract_start_year -> Opus /farm/oepul/measures/0/contract_start_year: Expliziter Vertragsbeginn der Maßnahme11; measure_id wird lediglich als native Maßnahmenkennung ergänzt.",
            "Luna /land/parcels/0 -> Opus /land/parcels/0: Schlagidentität, Fläche, Nutzungsart und Kultur unverändert; Anwendungsliste wird anschließend auf den belegten Alias umbenannt.",
            "Luna /land/parcels/0/operations/pesticide_applications -> Opus /land/parcels/0/operations/psm_applications; Herbizid wird zum belegten effect_type herbicide übersetzt. Der redundante is_herbicide-Flag hat keinen nativen Zielpfad."
          ],
          "unmapped_facts": [
            "Luna /farm/oepul/o6_11_application_year = 2024: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/oepul/measure_applications = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/oepul_eligible_area_ha = 1.5: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Historisches Betrachtungsjahr unverändert.",
            "Luna /farm/oepul/o6_11_contract_start_year -> Opus /farm/oepul/measures/0/contract_start_year: Expliziter Vertragsbeginn der Maßnahme11; measure_id wird lediglich als native Maßnahmenkennung ergänzt.",
            "Luna /land/parcels/0 -> Opus /land/parcels/0: Schlagidentität, Fläche, Nutzungsart und Kultur unverändert; Anwendungsliste wird anschließend auf den belegten Alias umbenannt.",
            "Luna /land/parcels/0/operations/pesticide_applications -> Opus /land/parcels/0/operations/psm_applications; Herbizid wird zum belegten effect_type herbicide übersetzt. Der redundante is_herbicide-Flag hat keinen nativen Zielpfad."
          ],
          "unmapped_facts": [
            "Luna /farm/oepul/o6_11_application_year = 2024: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/oepul/measure_applications = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/oepul_eligible_area_ha = 1.5: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/pesticide_applications/0/is_herbicide=true ist redundant zum belegten effect_type; Opus hat dafür keinen eigenen Eingabepfad."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Historisches Betrachtungsjahr unverändert.",
            "Luna /farm/oepul/o6_11_contract_start_year -> Opus /farm/oepul/measures/0/contract_start_year: Expliziter Vertragsbeginn der Maßnahme11; measure_id wird lediglich als native Maßnahmenkennung ergänzt.",
            "Luna /land/parcels/0 -> Opus /land/parcels/0: Schlagidentität, Fläche, Nutzungsart und Kultur unverändert; Anwendungsliste wird anschließend auf den belegten Alias umbenannt.",
            "Luna /land/parcels/0/operations/pesticide_applications fehlt -> Opus /land/parcels/0/operations/psm_applications bleibt ebenfalls abwesend."
          ],
          "unmapped_facts": [
            "Luna /farm/oepul/o6_11_application_year = 2024: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/oepul/measure_applications = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/oepul_eligible_area_ha = 1.5: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        }
      ],
      "comparison_limit": "Gleicher Herbizidfall im Jahr 2024 und gleiche Änderungsachse. Gesamtförderfähigkeit/Prämien sind wegen zusätzlicher Opus-Zugangsinputs nicht direkt mit Luna vergleichbar.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_11.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die native Entscheidung mit synthetischer Weinfläche und expliziter Mindestbetriebsfläche aufnehmen. |
| variation | defined | yes | Nur eine native Herbizidanwendung hinzufügen und eligible gemeinsam mit herbicide_ban_satisfied, violations und premium_amount_eur beobachten. |
| missing_fact | defined | no | Die gesamte PSM-Anwendungsliste entfernen, um fehlende Information gegenüber einer explizit leeren Liste zu untersuchen. |

**Open dependencies:**

- Lunas oepul_eligible_area_ha=1,5 ist keine belegte Gesamtbetriebsfläche; keine Umdeutung zu land.total_area_ha.
- Antragsjahr 2024 belegt keinen konkreten Antragstag; applicant- und Zahlungsnachweise fehlen.
- Opus verwendet bei fehlender PSM-Liste [], und bei fehlendem Einsatzdatum das Betrachtungsjahr; diese Defaults sind Teil der Beobachtung.
- Beobachtung: fehlende Gesamtbetriebsfläche erzeugt einen Betriebsmindestgrößenbefund in allen drei Fällen. Nur variation ergänzt O611-HERB-BAN; baseline und fehlende Anwendungsliste zeigen denselben Output.

**Evidence:**

- [runs/v2-o6_11-opus-5.5-high-20261001/workspace/policy/o6_11/base.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_11-opus-5.5-high-20261001/workspace/policy/o6_11/base.rego): Native farm.oepul.measures, Weinflächenklassifikation und land.parcels.
- [runs/v2-o6_11-opus-5.5-high-20261001/workspace/policy/o6_11/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_11-opus-5.5-high-20261001/workspace/policy/o6_11/obligations.rego): operations.psm_applications und effect_type=herbicide; fehlendes Anwendungsdatum wird nativ als Betrachtungsjahr behandelt.
- [runs/v2-o6_11-opus-5.5-high-20261001/workspace/policy/o6_11/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_11-opus-5.5-high-20261001/workspace/policy/o6_11/decision.rego): Nativer data.oepul.o6_11.decision-Vertrag.
- [runs/v2-o6_11-opus-5.5-high-20261001/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_11-opus-5.5-high-20261001/artifacts/input-paths.json): Historisches Alias-/Inputpfad-Inventar; kein vollständiger semantischer Nachweis der tatsächlich benötigten Fakten.
- [runs/v2-o6_11-opus-5.5-high-20261001/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_11-opus-5.5-high-20261001/artifacts/proposed-profile.json): Historischer Vorschlag des nativen Eingabevertrags; Typen werden gelesen, konkrete positive Testkonstanten nicht übernommen.
- [runs/v2-o6_11-opus-5.5-high-20261001/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_11-opus-5.5-high-20261001/workspace/rules/rules.json): Modellgeneriertes Klauselinventar und Querverweise; kein unabhängiger Referenzstandard.
- [runs/v2-o6_11-opus-5.5-high-20261001/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_11-opus-5.5-high-20261001/workspace/notes/assumptions.md): Historische Annahmen und offene Abhängigkeiten bleiben erhalten.

### o6_12

Run: `v2-o6_12-opus-5.5-high-20261009`. [Fixture](fixtures/o6_12.json) · [Native results](results/o6_12.json)

**Inputs:** Historisches Jahr 2024 und Vertrags-/Erstteilnahmejahr 2024 bleiben erhalten. land.parcels enthält0,6 ha Schnittweingarten. Native Maßnahme liegt unter oepul.o6_12; Einsätze unter parcels[].psm_applications. Luna nennt kein konkretes Einsatzdatum. Der true-Einsatz behält die vorhandenen negativen Flächen-/Chemieflags als flat_application=false und chemical_synthetic=false. Die Listendarstellung ist nur die belegte Insektizidachse, kein ergänzter Nachweis vollständiger anderer PSM-Anwendungen.

**Output meaning:** Begrenzte native Projektion der Mindestfläche und der Insektizid-Verstoßmenge. Die partielle Einsatzliste beschreibt ausschließlich die belegte Insektizidachse. Andere PSM-Einsätze, Kauf/Lagerung, PSM-Codierungen, Gesamtförderfähigkeit und Prämien liegen außerhalb der Query. Ein leerer Insektizid-Verstoßsatz kann wegen des nicht gelieferten Einsatzdatums entstehen und belegt keine Einhaltung.

**Origin:** Öffentliche synthetische Entwicklungsfälle der eingefrorenen Luna-Diagnose, durch Codex ausschließlich auf belegte native Opus-Pfade übersetzt. Keine unabhängigen Sollurteile, keine Expertenfreigabe und keine Held-out-Fälle. Fehlende Fachfakten werden nicht aus Opus-Modelltests ergänzt.

**Query:** `{"first_year_minimum_area_status": data.oepul.o6_12.first_year_minimum_area_status, "wine_fruit_hop_area_ha": data.oepul.o6_12.wine_fruit_hop_area_ha, "prohibited_insecticide_applications": data.oepul.o6_12.prohibited_insecticide_applications}`

**Inventory:** 94 rule catalog entries; 9 sources; 3 static input paths; 24 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 4, "combination": 3, "consequence": 7, "contract_period": 2, "deadline": 3, "definition": 8, "documentation": 5, "eligibility_condition": 15, "exception": 12, "measure_switch": 1, "obligation": 7, "payment": 2, "premium_calculation": 7, "premium_cap": 1, "premium_rate": 1, "procedure": 5, "sanction": 8, "scope": 2, "tolerance": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.region.district",
      "input.farm.region.federal_state",
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_12 | full_document | 24 | {"not_rule": 3, "rules": 21} |
| o6_general | full_document | 39 | {"not_rule": 10, "rules": 29} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 30 | {"not_rule": 8, "rules": 22} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"not_rule": 3, "rules": 3} |
| gsp_anwendungsverordnung | targeted_sections | 24 | {"not_rule": 6, "rules": 18} |
| rebzikade_2026_insektizidverzicht | full_document | 4 | {"not_rule": 1, "rules": 3} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 4 | {"not_rule": 3, "rules": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 4 | {"not_rule": 2, "rules": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 6 | {"not_rule": 5, "rules": 1} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2024 unverändert.",
            "Luna /farm/region/federal_state -> Opus /farm/region/federal_state: Bundesland unverändert.",
            "Luna /farm/measures/o6_12/participating -> Opus /oepul/o6_12/participating: Belegte Maßnahmenteilnahme.",
            "Luna /farm/measures/o6_12/contract_start_year -> Opus /oepul/o6_12/contract_start_year: Vertragsbeginn2024 unverändert.",
            "Luna /land/parcels/0/parcel_id -> Opus /land/parcels/0/parcel_id: Identität W1 unverändert.",
            "Luna /land/parcels/0/area_ha -> Opus /land/parcels/0/area_ha: 0,6 ha unverändert.",
            "Luna /land/parcels/0/crop/crop_category -> Opus /land/parcels/0/crop/crop_category: Weinfläche unverändert.",
            "Luna /land/parcels/0/crop/crop_name -> Opus /land/parcels/0/crop/crop_name: Schnittweingarten unverändert.",
            "Luna /land/parcels/0/crop/crop_name=Schnittweingarten -> Opus /land/parcels/0/crop/usage_type=schnittweingarten gemäß common.rego; native Codierung desselben Kulturtyps.",
            "Luna /land/parcels/0/operations/insecticide_use=false -> Opus /land/parcels/0/psm_applications=[] als explizit leere Insektizidachse. Dies ist kein Nachweis einer vollständigen leeren Liste anderer PSM; die Query enthält keine Aussagen dazu."
          ],
          "unmapped_facts": [
            "Luna /farm/measures/o6_12/first_participation_year = 2024: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/premium_target_type = \"vineyard\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/quality_planting_material_ok = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/sonstige_target_land_use = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/biological_farming_participation = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/area_wide_psm_application = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/chemical_synthetic_insecticide_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/land_use = \"vineyard\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_is_bio_permitted = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_authority_order = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_authority_documented = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_purchase_or_storage = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_in_other_culture = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_purchase_storage_plausible = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/first_participation_year=2024 und contract_start_year=2024 sind konsistent; das erste Maßnahmenjahr wird Opus aus contract_start_year abgeleitet, nicht als erstes allgemeines ÖPUL-Jahr behauptet."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2024 unverändert.",
            "Luna /farm/region/federal_state -> Opus /farm/region/federal_state: Bundesland unverändert.",
            "Luna /farm/measures/o6_12/participating -> Opus /oepul/o6_12/participating: Belegte Maßnahmenteilnahme.",
            "Luna /farm/measures/o6_12/contract_start_year -> Opus /oepul/o6_12/contract_start_year: Vertragsbeginn2024 unverändert.",
            "Luna /land/parcels/0/parcel_id -> Opus /land/parcels/0/parcel_id: Identität W1 unverändert.",
            "Luna /land/parcels/0/area_ha -> Opus /land/parcels/0/area_ha: 0,6 ha unverändert.",
            "Luna /land/parcels/0/crop/crop_category -> Opus /land/parcels/0/crop/crop_category: Weinfläche unverändert.",
            "Luna /land/parcels/0/crop/crop_name -> Opus /land/parcels/0/crop/crop_name: Schnittweingarten unverändert.",
            "Luna /land/parcels/0/crop/crop_name=Schnittweingarten -> Opus /land/parcels/0/crop/usage_type=schnittweingarten gemäß common.rego; native Codierung desselben Kulturtyps.",
            "Luna /farm/measures/o6_12/area_wide_psm_application=false und chemical_synthetic_insecticide_used=false -> Opus /land/parcels/0/psm_applications/0/flat_application=false und chemical_synthetic=false: die vorhandenen negativen Gesamteinsatzflags gelten auch für diesen einzigen belegten Einsatz; native Defaults werden nicht zu einem gegenteiligen Einsatz umgedeutet.",
            "Luna /land/parcels/0/operations/insecticide_use=true -> Opus /land/parcels/0/psm_applications/0/action_type=insecticide: der boolesche Einsatzfakt ist abgebildet; er belegt kein Einsatzdatum.",
            "Luna /land/parcels/0/operations/insecticide_is_bio_permitted=false -> Opus /land/parcels/0/psm_applications/0/eu_2018_848_permitted=false: die Bio-Zulässigkeit bleibt ein separater synthetischer Fakt."
          ],
          "unmapped_facts": [
            "Luna /farm/measures/o6_12/first_participation_year = 2024: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/premium_target_type = \"vineyard\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/quality_planting_material_ok = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/sonstige_target_land_use = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/biological_farming_participation = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/land_use = \"vineyard\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_authority_order = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_authority_documented = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_purchase_or_storage = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_in_other_culture = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_purchase_storage_plausible = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Für Opus /land/parcels/0/psm_applications/0/date existiert kein Luna-Fakt. Dadurch kann das native Verstoßobjekt ausbleiben.",
            "Luna /farm/measures/o6_12/first_participation_year=2024 und contract_start_year=2024 sind konsistent; das erste Maßnahmenjahr wird Opus aus contract_start_year abgeleitet, nicht als erstes allgemeines ÖPUL-Jahr behauptet."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2024 unverändert.",
            "Luna /farm/region/federal_state -> Opus /farm/region/federal_state: Bundesland unverändert.",
            "Luna /farm/measures/o6_12/participating -> Opus /oepul/o6_12/participating: Belegte Maßnahmenteilnahme.",
            "Luna /farm/measures/o6_12/contract_start_year -> Opus /oepul/o6_12/contract_start_year: Vertragsbeginn2024 unverändert.",
            "Luna /land/parcels/0/parcel_id -> Opus /land/parcels/0/parcel_id: Identität W1 unverändert.",
            "Luna /land/parcels/0/area_ha -> Opus /land/parcels/0/area_ha: 0,6 ha unverändert.",
            "Luna /land/parcels/0/crop/crop_category -> Opus /land/parcels/0/crop/crop_category: Weinfläche unverändert.",
            "Luna /land/parcels/0/crop/crop_name -> Opus /land/parcels/0/crop/crop_name: Schnittweingarten unverändert.",
            "Luna /land/parcels/0/crop/crop_name=Schnittweingarten -> Opus /land/parcels/0/crop/usage_type=schnittweingarten gemäß common.rego; native Codierung desselben Kulturtyps.",
            "Luna /land/parcels/0/operations/insecticide_use fehlt -> Opus /land/parcels/0/psm_applications wird nicht gesetzt; fehlend bleibt fehlend."
          ],
          "unmapped_facts": [
            "Luna /farm/measures/o6_12/first_participation_year = 2024: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/premium_target_type = \"vineyard\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/quality_planting_material_ok = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/sonstige_target_land_use = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/biological_farming_participation = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/area_wide_psm_application = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/chemical_synthetic_insecticide_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/land_use = \"vineyard\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_is_bio_permitted = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_authority_order = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_authority_documented = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_purchase_or_storage = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_in_other_culture = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/operations/insecticide_purchase_storage_plausible = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measures/o6_12/first_participation_year=2024 und contract_start_year=2024 sind konsistent; das erste Maßnahmenjahr wird Opus aus contract_start_year abgeleitet, nicht als erstes allgemeines ÖPUL-Jahr behauptet."
          ]
        }
      ],
      "comparison_limit": "Insektizid false/true/fehlend bleibt dieselbe fachliche Änderungsachse im Jahr 2024. Opus benötigt bei true zusätzlich ein unbekanntes Datum; die Ausführung ist daher ein partieller Vertragsbefund, kein gleichwertiger Vollvergleich.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_12.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | no | insecticide_use von false auf true ändern; belegte eingesetzte Kultur und alle übrigen Fakten beibehalten. |
| missing_fact | defined | no | insecticide_use entfernen; beobachten, ob ein fehlender Einsatznachweis als unbekannt sichtbar wird oder die Verletzung ausbleibt. |

**Open dependencies:**

- Luna liefert für insecticide_use=true kein Einsatzdatum. Das Datum wird nicht aus Opus-Testbeispielen ergänzt; ein dadurch leerer Verbotssatz ist keine positive Wirkung des Modells.
- Lunas Boolesche Kauf-/Lager- und Qualitätsaussagen haben keine gleichwertige vollständige native Liste bzw. parcel-spezifischen Beleg; fehlende Zusatznachweise bleiben offen.
- Ein Antragsdatum, applicant-Rechtsform und jährlicher Zahlungsantrag fehlen in Luna.
- Das Jahr 2024 wird ausdrücklich nicht auf2026 verschoben; Quellen- und Jahresunterschiede bleiben getrennte Abhängigkeiten.
- Beobachtung der engeren Query: alle drei Projektionen sind identisch; Mindestfläche met bei 0,6 ha und leere Insektizid-Verstoßmenge. Der true-Fall kann wegen fehlendem a.date nicht als datierter Verstoß ausgegeben werden. Unbekannte andere PSM und Lagerbestände liegen ausdrücklich außerhalb dieser Query.

**Evidence:**

- [runs/v2-o6_12-opus-5.5-high-20261009/workspace/policy/o6_12/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_12-opus-5.5-high-20261009/workspace/policy/o6_12/common.rego): Native Maßnahme oepul.o6_12 und usage_type für Schnittweingarten.
- [runs/v2-o6_12-opus-5.5-high-20261009/workspace/policy/o6_12/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_12-opus-5.5-high-20261009/workspace/policy/o6_12/obligations.rego): Insektizid-Einsatzobjekt verlangt action_type und referenziert a.date im Verstoßobjekt; Bio-/Anordnungslogik und PSM-Codierung.
- [runs/v2-o6_12-opus-5.5-high-20261009/workspace/policy/o6_12/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_12-opus-5.5-high-20261009/workspace/policy/o6_12/eligibility.rego): first_year_minimum_area_status auf Jahr/Vertragsbeginn und Flächensumme.
- [runs/v2-o6_12-opus-5.5-high-20261009/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_12-opus-5.5-high-20261009/artifacts/input-paths.json): Historisches Alias-/Inputpfad-Inventar; kein vollständiger semantischer Nachweis der tatsächlich benötigten Fakten.
- [runs/v2-o6_12-opus-5.5-high-20261009/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_12-opus-5.5-high-20261009/artifacts/proposed-profile.json): Historischer Vorschlag des nativen Eingabevertrags; Typen werden gelesen, konkrete positive Testkonstanten nicht übernommen.
- [runs/v2-o6_12-opus-5.5-high-20261009/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_12-opus-5.5-high-20261009/workspace/rules/rules.json): Modellgeneriertes Klauselinventar und Querverweise; kein unabhängiger Referenzstandard.
- [runs/v2-o6_12-opus-5.5-high-20261009/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_12-opus-5.5-high-20261009/workspace/notes/assumptions.md): Historische Annahmen und offene Abhängigkeiten bleiben erhalten.

### o6_13

Run: `v2-o6_13-opus-5.5-high-20260926`. [Fixture](fixtures/o6_13.json) · [Native results](results/o6_13.json)

**Inputs:** Jahr 2026, Vertragsantrag31.12.2025,0,6 ha geschützter Anbau auf gewachsenem Boden; Fläche in ha, Ernteanteil100% bleibt unter minimum_management.harvested_share_percent=100 erhalten. Organismenmengen bleiben1000 ohne neu erfundene Einheit. Luna hat keine parcel_id und keine ausdrückliche volle Einsatzabdeckung.

**Output meaning:** Nativer decision-Vertrag mit getrennten Zugangsausfällen, Vertrag, Nichtanrechenbarkeit, Aufzeichnungslücken, Schlagbefunden und Prämie. Positive eligible-/Prämienwerte sind keine unabhängige Gesamtförderfreigabe; fehlende parcel_id kann schlagbezogene Befunde unterdrücken.

**Origin:** Öffentliche synthetische Entwicklungsfälle der eingefrorenen Luna-Diagnose, durch Codex ausschließlich auf belegte native Opus-Pfade übersetzt. Keine unabhängigen Sollurteile, keine Expertenfreigabe und keine Held-out-Fälle. Fehlende Fachfakten werden nicht aus Opus-Modelltests ergänzt. Nicht abbildbare Fälle sind bewusst als Lücke statt als zusätzliche Beobachtung erhalten.

**Query:** `data.oepul.o6_13.decision`

**Inventory:** 80 rule catalog entries; 8 sources; 1 static input paths; 23 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_requirement": 7, "application_procedure": 10, "calculation": 2, "combination_restriction": 2, "contract_term": 6, "documentation_requirement": 2, "eligibility_condition": 7, "exception": 6, "exclusion": 10, "exit_procedure": 4, "legal_reference": 1, "modulation": 1, "obligation": 7, "payment_cap": 1, "payment_procedure": 3, "premium_rate": 1, "sanction": 7, "scope": 2, "transfer": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_13 | full_document | 21 | {"not_rule": 5, "rules": 16} |
| o6_general | full_document | 42 | {"not_rule": 17, "rules": 25} |
| srl_oepul_2023 | targeted_sections | 50 | {"not_rule": 11, "rules": 39} |
| srl_oepul_2023_anhaenge | targeted_sections | 6 | {"not_rule": 2, "rules": 4} |
| notice_2026-05-22 | full_document | 5 | {"not_rule": 4, "rules": 1} |
| notice_2026-06-12 | full_document | 3 | {"not_rule": 3} |
| notice_2026-08-05 | full_document | 4 | {"not_rule": 2, "rules": 2} |
| notice_2026-08-12 | full_document | 6 | {"not_rule": 5, "rules": 1} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2026 unverändert.",
            "Luna /farm/region -> Opus /farm/region: Region unverändert.",
            "Luna /farm/measure_application/contract_year -> Opus /farm/oepul/o6_13/entry_year: Antrag für Einstieg2026.",
            "Luna /farm/measure_application/submitted_by -> Opus /farm/oepul/o6_13/measure_application_date: Antragsdatum unverändert.",
            "Luna /land/total_area_ha -> Opus /land/total_area_ha: Gesamtfläche10 ha unverändert.",
            "Luna /land/arable_area_ha -> Opus /land/arable_area_ha: Aggregat unverändert.",
            "Luna /land/grassland_area_ha -> Opus /land/grassland_area_ha: Aggregat unverändert.",
            "Luna /land/special_crops_area_ha -> Opus /land/special_crops_area_ha: Aggregat unverändert.",
            "Luna /land/alpine_pasture_area_ha -> Opus /land/alpine_pasture_area_ha: Aggregat unverändert.",
            "Luna /land/parcels/0/area_ha -> Opus /land/parcels/0/area_ha: 0,6 ha unverändert.",
            "Luna /land/parcels/0/land_use -> Opus /land/parcels/0/protected_cultivation/field_use_type: Native FeldstücksnutzungsartA, kein frei erfundenes land_use=arable.",
            "Luna /land/parcels/0/protected_cultivation/cultivation_medium -> Opus /land/parcels/0/protected_cultivation/growing_system: grown_soil bleibt grown_soil.",
            "Luna /land/parcels/0/protected_cultivation/active_production -> Opus /land/parcels/0/actively_managed: Aktive Produktion.",
            "Luna /land/parcels/0/measure_application/code -> Opus /land/parcels/0/oepul_codes: Einzelner bestätigter Code NUE als native Codeliste.",
            "Luna /land/parcels/0/measure_application/harvested_percent -> Opus /land/parcels/0/minimum_management/harvested_share_percent: Ernteanteil100 Prozent unverändert.",
            "Luna /land/parcels/0/organism_application/organism_type -> Opus /land/parcels/0/beneficial_organism_applications/0/organism_species: Raubmilbe unverändert, keine Hummel eingeführt.",
            "Luna /land/parcels/0/organism_application/quantity -> Opus /land/parcels/0/beneficial_organism_applications/0/quantity: Menge1000 unverändert; Einheit weiterhin ungebunden.",
            "Luna /land/parcels/0/organism_application/ages_register_entry -> Opus /land/parcels/0/beneficial_organism_applications/0/listed_in_psm_register: Synthetischer Registerflag unverändert.",
            "Luna /land/parcels/0/organism_application/application_rate_compliant -> Opus /land/parcels/0/beneficial_organism_applications/0/applied_at_register_rate: Aufwandsflag unverändert.",
            "Luna /land/parcels/0/organism_application/replaces_plant_protection_use -> Opus /land/parcels/0/beneficial_organism_applications/0/replaces_psm_use: PSM-Ersatzflag unverändert.",
            "Luna /land/parcels/0/organism_application/purchase_evidence -> Opus /land/parcels/0/beneficial_organism_applications/0/purchase_receipt_available: Fehlender Kaufbeleg bleibt im missing_fact-Fall abwesend.",
            "Luna /land/parcels/0/organism_application/reason -> Opus /land/parcels/0/beneficial_organism_applications/0/reason: Grund unverändert.",
            "Luna /land/parcels/0/organism_application/goal -> Opus /land/parcels/0/beneficial_organism_applications/0/target: Ziel unverändert.",
            "Luna /land/parcels/0/organism_application/date -> Opus /land/parcels/0/beneficial_organism_applications/0/date: Einsatzdatum unverändert.",
            "Luna /land/parcels/0/protected_cultivation/structure_type=fixed_greenhouse_glass -> Opus structure_type=fixed_greenhouse und covering_material=glass; explizit dasselbe Glasgewächshaus.",
            "Luna is_pollinator_only=false zusammen mit replaces_plant_protection_use=true und Ziel Schädlingsbekämpfung -> Opus use_type=plant_protection.",
            "Luna /land/parcels/0/measure_application/{proper_cultivation,proper_annual_care,crop_is_late_summer_or_autumn} -> Opus /land/parcels/0/minimum_management/{properly_cultivated,annual_care} und /crop/usually_harvested_late_summer_or_autumn mit denselben Booleschen Werten.",
            "Luna /farm/operation_program/member=false und organism_use_compensated=false -> Opus /farm/oepul/o6_13/member_of_producer_organisation_with_op_covering_organisms=false; keine Mitgliedschaft erfunden."
          ],
          "unmapped_facts": [
            "Luna /farm/measure_application/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measure_application/first_participation = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/protected_cultivation/is_protected_cultivation = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/protected_cultivation/area_role = \"production\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/measure_application/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/measure_application/other_premium = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2026 unverändert.",
            "Luna /farm/region -> Opus /farm/region: Region unverändert.",
            "Luna /farm/measure_application/contract_year -> Opus /farm/oepul/o6_13/entry_year: Antrag für Einstieg2026.",
            "Luna /farm/measure_application/submitted_by -> Opus /farm/oepul/o6_13/measure_application_date: Antragsdatum unverändert.",
            "Luna /land/total_area_ha -> Opus /land/total_area_ha: Gesamtfläche10 ha unverändert.",
            "Luna /land/arable_area_ha -> Opus /land/arable_area_ha: Aggregat unverändert.",
            "Luna /land/grassland_area_ha -> Opus /land/grassland_area_ha: Aggregat unverändert.",
            "Luna /land/special_crops_area_ha -> Opus /land/special_crops_area_ha: Aggregat unverändert.",
            "Luna /land/alpine_pasture_area_ha -> Opus /land/alpine_pasture_area_ha: Aggregat unverändert.",
            "Luna /land/parcels/0/area_ha -> Opus /land/parcels/0/area_ha: 0,6 ha unverändert.",
            "Luna /land/parcels/0/land_use -> Opus /land/parcels/0/protected_cultivation/field_use_type: Native FeldstücksnutzungsartA, kein frei erfundenes land_use=arable.",
            "Luna /land/parcels/0/protected_cultivation/cultivation_medium -> Opus /land/parcels/0/protected_cultivation/growing_system: grown_soil bleibt grown_soil.",
            "Luna /land/parcels/0/protected_cultivation/active_production -> Opus /land/parcels/0/actively_managed: Aktive Produktion.",
            "Luna /land/parcels/0/measure_application/code -> Opus /land/parcels/0/oepul_codes: Einzelner bestätigter Code NUE als native Codeliste.",
            "Luna /land/parcels/0/measure_application/harvested_percent -> Opus /land/parcels/0/minimum_management/harvested_share_percent: Ernteanteil100 Prozent unverändert.",
            "Luna /land/parcels/0/organism_application/organism_type -> Opus /land/parcels/0/beneficial_organism_applications/0/organism_species: Raubmilbe unverändert, keine Hummel eingeführt.",
            "Luna /land/parcels/0/organism_application/quantity -> Opus /land/parcels/0/beneficial_organism_applications/0/quantity: Menge1000 unverändert; Einheit weiterhin ungebunden.",
            "Luna /land/parcels/0/organism_application/ages_register_entry -> Opus /land/parcels/0/beneficial_organism_applications/0/listed_in_psm_register: Synthetischer Registerflag unverändert.",
            "Luna /land/parcels/0/organism_application/application_rate_compliant -> Opus /land/parcels/0/beneficial_organism_applications/0/applied_at_register_rate: Aufwandsflag unverändert.",
            "Luna /land/parcels/0/organism_application/replaces_plant_protection_use -> Opus /land/parcels/0/beneficial_organism_applications/0/replaces_psm_use: PSM-Ersatzflag unverändert.",
            "Luna /land/parcels/0/organism_application/purchase_evidence -> Opus /land/parcels/0/beneficial_organism_applications/0/purchase_receipt_available: Fehlender Kaufbeleg bleibt im missing_fact-Fall abwesend.",
            "Luna /land/parcels/0/organism_application/reason -> Opus /land/parcels/0/beneficial_organism_applications/0/reason: Grund unverändert.",
            "Luna /land/parcels/0/organism_application/goal -> Opus /land/parcels/0/beneficial_organism_applications/0/target: Ziel unverändert.",
            "Luna /land/parcels/0/organism_application/date -> Opus /land/parcels/0/beneficial_organism_applications/0/date: Einsatzdatum unverändert.",
            "Luna /land/parcels/0/protected_cultivation/structure_type=fixed_greenhouse_glass -> Opus structure_type=fixed_greenhouse und covering_material=glass; explizit dasselbe Glasgewächshaus.",
            "Luna /land/parcels/0/measure_application/{proper_cultivation,proper_annual_care,crop_is_late_summer_or_autumn} -> Opus /land/parcels/0/minimum_management/{properly_cultivated,annual_care} und /crop/usually_harvested_late_summer_or_autumn mit denselben Booleschen Werten.",
            "Luna /farm/operation_program/member=false und organism_use_compensated=false -> Opus /farm/oepul/o6_13/member_of_producer_organisation_with_op_covering_organisms=false; keine Mitgliedschaft erfunden."
          ],
          "unmapped_facts": [
            "Luna /farm/measure_application/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measure_application/first_participation = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/protected_cultivation/is_protected_cultivation = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/protected_cultivation/area_role = \"production\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/measure_application/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/measure_application/other_premium = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/organism_application/is_pollinator_only = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna is_pollinator_only=true bei predatory_mite hat keinen belegten gleichwertigen Opus-use_type; bumblebee_pollination wird nicht erfunden.",
            "Dieser Luna-Fall besitzt keine vollständig belegbare veränderte native Eingabe und wird daher nicht als ausführbarer Opus-Vergleichsfall ausgegeben."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2026 unverändert.",
            "Luna /farm/region -> Opus /farm/region: Region unverändert.",
            "Luna /farm/measure_application/contract_year -> Opus /farm/oepul/o6_13/entry_year: Antrag für Einstieg2026.",
            "Luna /farm/measure_application/submitted_by -> Opus /farm/oepul/o6_13/measure_application_date: Antragsdatum unverändert.",
            "Luna /land/total_area_ha -> Opus /land/total_area_ha: Gesamtfläche10 ha unverändert.",
            "Luna /land/arable_area_ha -> Opus /land/arable_area_ha: Aggregat unverändert.",
            "Luna /land/grassland_area_ha -> Opus /land/grassland_area_ha: Aggregat unverändert.",
            "Luna /land/special_crops_area_ha -> Opus /land/special_crops_area_ha: Aggregat unverändert.",
            "Luna /land/alpine_pasture_area_ha -> Opus /land/alpine_pasture_area_ha: Aggregat unverändert.",
            "Luna /land/parcels/0/area_ha -> Opus /land/parcels/0/area_ha: 0,6 ha unverändert.",
            "Luna /land/parcels/0/land_use -> Opus /land/parcels/0/protected_cultivation/field_use_type: Native FeldstücksnutzungsartA, kein frei erfundenes land_use=arable.",
            "Luna /land/parcels/0/protected_cultivation/cultivation_medium -> Opus /land/parcels/0/protected_cultivation/growing_system: grown_soil bleibt grown_soil.",
            "Luna /land/parcels/0/protected_cultivation/active_production -> Opus /land/parcels/0/actively_managed: Aktive Produktion.",
            "Luna /land/parcels/0/measure_application/code -> Opus /land/parcels/0/oepul_codes: Einzelner bestätigter Code NUE als native Codeliste.",
            "Luna /land/parcels/0/measure_application/harvested_percent -> Opus /land/parcels/0/minimum_management/harvested_share_percent: Ernteanteil100 Prozent unverändert.",
            "Luna /land/parcels/0/organism_application/organism_type -> Opus /land/parcels/0/beneficial_organism_applications/0/organism_species: Raubmilbe unverändert, keine Hummel eingeführt.",
            "Luna /land/parcels/0/organism_application/quantity -> Opus /land/parcels/0/beneficial_organism_applications/0/quantity: Menge1000 unverändert; Einheit weiterhin ungebunden.",
            "Luna /land/parcels/0/organism_application/ages_register_entry -> Opus /land/parcels/0/beneficial_organism_applications/0/listed_in_psm_register: Synthetischer Registerflag unverändert.",
            "Luna /land/parcels/0/organism_application/application_rate_compliant -> Opus /land/parcels/0/beneficial_organism_applications/0/applied_at_register_rate: Aufwandsflag unverändert.",
            "Luna /land/parcels/0/organism_application/replaces_plant_protection_use -> Opus /land/parcels/0/beneficial_organism_applications/0/replaces_psm_use: PSM-Ersatzflag unverändert.",
            "Luna /land/parcels/0/organism_application/purchase_evidence fehlt -> Opus /land/parcels/0/beneficial_organism_applications/0/purchase_receipt_available wird ebenfalls nicht gesetzt; Fehlender Kaufbeleg bleibt im missing_fact-Fall abwesend.",
            "Luna /land/parcels/0/organism_application/reason -> Opus /land/parcels/0/beneficial_organism_applications/0/reason: Grund unverändert.",
            "Luna /land/parcels/0/organism_application/goal -> Opus /land/parcels/0/beneficial_organism_applications/0/target: Ziel unverändert.",
            "Luna /land/parcels/0/organism_application/date -> Opus /land/parcels/0/beneficial_organism_applications/0/date: Einsatzdatum unverändert.",
            "Luna /land/parcels/0/protected_cultivation/structure_type=fixed_greenhouse_glass -> Opus structure_type=fixed_greenhouse und covering_material=glass; explizit dasselbe Glasgewächshaus.",
            "Luna is_pollinator_only=false zusammen mit replaces_plant_protection_use=true und Ziel Schädlingsbekämpfung -> Opus use_type=plant_protection.",
            "Luna /land/parcels/0/measure_application/{proper_cultivation,proper_annual_care,crop_is_late_summer_or_autumn} -> Opus /land/parcels/0/minimum_management/{properly_cultivated,annual_care} und /crop/usually_harvested_late_summer_or_autumn mit denselben Booleschen Werten.",
            "Luna /farm/operation_program/member=false und organism_use_compensated=false -> Opus /farm/oepul/o6_13/member_of_producer_organisation_with_op_covering_organisms=false; keine Mitgliedschaft erfunden."
          ],
          "unmapped_facts": [
            "Luna /farm/measure_application/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /farm/measure_application/first_participation = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/protected_cultivation/is_protected_cultivation = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/protected_cultivation/area_role = \"production\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/measure_application/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/measure_application/other_premium = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        }
      ],
      "comparison_limit": "baseline und missing_fact erhalten den gleichen Nützlingseinsatz/Kaufbelegunterschied. variation ist nicht ausführbar übersetzt, weil die enge native Hummel-Ausnahme nicht dieselbe Aussage wie Lunas genereller Bestäubungsflag mit Raubmilben ausdrückt.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_13.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| missing_fact | defined | no | purchase_evidence aus organism_application entfernen; untersuchen, ob die fehlende Kaufbelegeingabe getrennt von einer belegten Nichterfüllung erkennbar ist. |

**Fixture gap:** Nicht ausführbar übersetzte Luna-Fälle: variation. Einzelne fehlende Fakten und verlorene Änderungsachsen stehen in luna_translation; keine Ersatzfälle erfunden.


**Open dependencies:**

- Luna enthält keine parcel_id; keine neue Schlagidentität eingeführt, auch wenn der native Output sie verlangt.
- Die Opus-Ausnahme use_type=bumblebee_pollination bezeichnet Hummelvölker. Luna behält in variation predatory_mite und setzt nur is_pollinator_only=true; eine Hummelklassifikation wäre erfunden.
- Ernteanteil100% belegt nicht covers_entire_area für den Nützlingseinsatz.
- Applicant- und weitere Vertrags-/Dokumentationsinputs fehlen; native Defaults werden nicht als nachgewiesene Fakten ausgegeben.
- Beobachtung: baseline und fehlender Kaufbeleg haben denselben nativen Output, obligation_violations=[] und parcels=[]; fehlende parcel_id verhindert die schlagbezogenen Befundobjekte. eligible=false, gross1296 Euro und net0Euro sind unterschiedliche native Teilaussagen.

**Evidence:**

- [runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/decision.rego): Native aggregierte Entscheidung mit expliziten Default-Outputs.
- [runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/obligations.rego): beneficial_organism_applications, Kaufbeleg und spezifisch bumblebee_pollination.
- [runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/parcels.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/parcels.rego): NUE-Codierung, fixed_greenhouse plus glass, growing_system und field_use_type.
- [runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/contract.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/workspace/policy/o6_13/contract.rego): farm.oepul.o6_13.entry_year und measure_application_date.
- [runs/v2-o6_13-opus-5.5-high-20260926/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/artifacts/input-paths.json): Historisches Alias-/Inputpfad-Inventar; kein vollständiger semantischer Nachweis der tatsächlich benötigten Fakten.
- [runs/v2-o6_13-opus-5.5-high-20260926/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/artifacts/proposed-profile.json): Historischer Vorschlag des nativen Eingabevertrags; Typen werden gelesen, konkrete positive Testkonstanten nicht übernommen.
- [runs/v2-o6_13-opus-5.5-high-20260926/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/workspace/rules/rules.json): Modellgeneriertes Klauselinventar und Querverweise; kein unabhängiger Referenzstandard.
- [runs/v2-o6_13-opus-5.5-high-20260926/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_13-opus-5.5-high-20260926/workspace/notes/assumptions.md): Historische Annahmen und offene Abhängigkeiten bleiben erhalten.

### o6_14

Run: `v2-o6_14-opus-5.5-high-20260926`. [Fixture](fixtures/o6_14.json) · [Native results](results/o6_14.json)

**Inputs:** Jahr 2026, Alm A mit3ha und Erschließungsstufe2, synthetisches Rindc1. Luna gibt3RGVE und60/59 Tage aggregiert an; Opus benötigt stattdessen Geburtsdatum/Kategorie/Tierzahl und datierte Aufenthalte/Meldungen. Diese Zusatzdaten werden nicht erfunden.

**Output meaning:** Begrenzte native Projektion von Zugang, Tier-/Almtagen, Dichte, Befunden und Prämie. Tage0/RGVE0 aus unvollständigen Listen belegen keine tatsächliche Nichtbeweidung. Keine Gleichsetzung mit Lunas eligible oder dem Quellenurteil.

**Origin:** Öffentliche synthetische Entwicklungsfälle der eingefrorenen Luna-Diagnose, durch Codex ausschließlich auf belegte native Opus-Pfade übersetzt. Keine unabhängigen Sollurteile, keine Expertenfreigabe und keine Held-out-Fälle. Fehlende Fachfakten werden nicht aus Opus-Modelltests ergänzt. Nicht abbildbare Fälle sind bewusst als Lücke statt als zusätzliche Beobachtung erhalten.

**Query:** `{"access_conditions_met": data.oepul.o6_14.access_conditions_met, "access_violations": data.oepul.o6_14.access_violations, "total_actual_days": data.oepul.o6_14.total_actual_days, "total_credited_days": data.oepul.o6_14.total_credited_days, "alm_occupied_days": data.oepul.o6_14.alm_occupied_days, "alm_stocking_density": data.oepul.o6_14.alm_stocking_density, "animal_notices": data.oepul.o6_14.animal_notices, "violations": data.oepul.o6_14.violations, "premium_total": data.oepul.o6_14.premium_total}`

**Inventory:** 126 rule catalog entries; 8 sources; 15 static input paths; 4 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 4, "calculation": 16, "cap": 1, "code_requirement": 2, "combination": 5, "consequence": 3, "contract_period": 2, "contract_rule": 7, "deadline": 8, "definition": 3, "eligibility": 10, "exception": 13, "general_condition": 2, "obligation": 26, "option": 1, "premium_rate": 4, "procedure": 9, "reporting": 5, "sanction": 2, "scope": 2, "threshold": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.alpine_farming",
      "input.alpine_farming.alms",
      "input.alpine_farming.animals",
      "input.alpine_farming.grazing_plan_supplement",
      "input.alpine_farming.measure",
      "input.alpine_farming.nature_conservation_supplement",
      "input.farm",
      "input.farm.applicant",
      "input.farm.applicant.legal_form",
      "input.farm.applicant.public_body_share_pct",
      "input.farm.oepul.first_oepul_year",
      "input.farm.oepul.participating_measures",
      "input.farm.year",
      "input.land.protected_cultivation_area_ha",
      "input.land.total_area_ha"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_14 | full_document | 31 | {"not_rule": 5, "rules": 26} |
| o6_general | full_document | 34 | {"not_rule": 11, "rules": 23} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 31 | {"not_rule": 6, "rules": 25} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 12 | {"not_rule": 4, "rules": 8} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 4 | {"not_rule": 2, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 2 | {"not_rule": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 6 | {"not_rule": 6} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr unverändert.",
            "Luna /preferences_constraints/oepul_participation_requested -> Opus /alpine_farming/measure/applied: Beantragte Maßnahme unverändert.",
            "Luna /land/alpine_pastures/0/alm_id -> Opus /alpine_farming/alms/0/alm_id: Alm A unverändert.",
            "Luna /land/alpine_pastures/0/area_ha -> Opus /alpine_farming/alms/0/alm_pasture_area_ha: 3 ha unverändert.",
            "Luna /land/alpine_pastures/0/access_stage -> Opus /alpine_farming/alms/0/access_level: stage_2 -> native Stufe 2 ohne Änderung der Erschließung.",
            "Luna /livestock/alpine_movements/0/animal_id -> Opus /alpine_farming/animals/0/animal_id: Synthetische Identität c1 unverändert; keine neue Tierzahl gesetzt.",
            "Luna /livestock/alpine_movements/0/species -> Opus /alpine_farming/animals/0/species: Rinderart unverändert.",
            "Luna /livestock/alpine_movements/0/alm_id -> Opus /alpine_farming/animals/0/stays/0/alm_id: Die einzige belegte Zuordnung zu Alm A.",
            "Luna /land/alpine_pastures/0/is_in_austria -> Opus /alpine_farming/animals/0/stays/0/in_austria: Standort der zugeordneten Alm/Beweidung; fehlender Standort bleibt abwesend."
          ],
          "unmapped_facts": [
            "Luna /land/alpine_pastures/0/feed_practices/natural_fodder_sufficient = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/feed_practices/non_alpine_silage_or_green_fodder = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/alm_inputs/pesticide_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/alm_inputs/fertilizer_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/gve = 3: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/alpung_days = 60: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/is_held_in_austria = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /preferences_constraints/oepul_first_participation_year = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /preferences_constraints/oepul_options = {}: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/cattle_arrival_days = 14: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/cattle_departure_days = 14: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/other_arrival_days = 7: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/other_departure_days = 7: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr unverändert.",
            "Luna /preferences_constraints/oepul_participation_requested -> Opus /alpine_farming/measure/applied: Beantragte Maßnahme unverändert.",
            "Luna /land/alpine_pastures/0/alm_id -> Opus /alpine_farming/alms/0/alm_id: Alm A unverändert.",
            "Luna /land/alpine_pastures/0/area_ha -> Opus /alpine_farming/alms/0/alm_pasture_area_ha: 3 ha unverändert.",
            "Luna /land/alpine_pastures/0/access_stage -> Opus /alpine_farming/alms/0/access_level: stage_2 -> native Stufe 2 ohne Änderung der Erschließung.",
            "Luna /livestock/alpine_movements/0/animal_id -> Opus /alpine_farming/animals/0/animal_id: Synthetische Identität c1 unverändert; keine neue Tierzahl gesetzt.",
            "Luna /livestock/alpine_movements/0/species -> Opus /alpine_farming/animals/0/species: Rinderart unverändert.",
            "Luna /livestock/alpine_movements/0/alm_id -> Opus /alpine_farming/animals/0/stays/0/alm_id: Die einzige belegte Zuordnung zu Alm A.",
            "Luna /land/alpine_pastures/0/is_in_austria -> Opus /alpine_farming/animals/0/stays/0/in_austria: Standort der zugeordneten Alm/Beweidung; fehlender Standort bleibt abwesend."
          ],
          "unmapped_facts": [
            "Luna /land/alpine_pastures/0/feed_practices/natural_fodder_sufficient = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/feed_practices/non_alpine_silage_or_green_fodder = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/alm_inputs/pesticide_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/alm_inputs/fertilizer_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/gve = 3: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/alpung_days = 59: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/is_held_in_austria = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /preferences_constraints/oepul_first_participation_year = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /preferences_constraints/oepul_options = {}: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/cattle_arrival_days = 14: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/cattle_departure_days = 14: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/other_arrival_days = 7: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/other_departure_days = 7: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Dieser Luna-Fall besitzt keine vollständig belegbare veränderte native Eingabe und wird daher nicht als ausführbarer Opus-Vergleichsfall ausgegeben."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr unverändert.",
            "Luna /preferences_constraints/oepul_participation_requested -> Opus /alpine_farming/measure/applied: Beantragte Maßnahme unverändert.",
            "Luna /land/alpine_pastures/0/alm_id -> Opus /alpine_farming/alms/0/alm_id: Alm A unverändert.",
            "Luna /land/alpine_pastures/0/area_ha -> Opus /alpine_farming/alms/0/alm_pasture_area_ha: 3 ha unverändert.",
            "Luna /land/alpine_pastures/0/access_stage -> Opus /alpine_farming/alms/0/access_level: stage_2 -> native Stufe 2 ohne Änderung der Erschließung.",
            "Luna /livestock/alpine_movements/0/animal_id -> Opus /alpine_farming/animals/0/animal_id: Synthetische Identität c1 unverändert; keine neue Tierzahl gesetzt.",
            "Luna /livestock/alpine_movements/0/species -> Opus /alpine_farming/animals/0/species: Rinderart unverändert.",
            "Luna /livestock/alpine_movements/0/alm_id -> Opus /alpine_farming/animals/0/stays/0/alm_id: Die einzige belegte Zuordnung zu Alm A.",
            "Luna /land/alpine_pastures/0/is_in_austria fehlt -> Opus /alpine_farming/animals/0/stays/0/in_austria wird ebenfalls nicht gesetzt; Standort der zugeordneten Alm/Beweidung; fehlender Standort bleibt abwesend."
          ],
          "unmapped_facts": [
            "Luna /land/alpine_pastures/0/feed_practices/natural_fodder_sufficient = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/feed_practices/non_alpine_silage_or_green_fodder = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/alm_inputs/pesticide_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/alpine_pastures/0/alm_inputs/fertilizer_used = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/gve = 3: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/alpung_days = 60: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/alpine_movements/0/is_held_in_austria = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /preferences_constraints/oepul_first_participation_year = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /preferences_constraints/oepul_options = {}: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/cattle_arrival_days = 14: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/cattle_departure_days = 14: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/other_arrival_days = 7: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /documentation/oepul_reports/other_departure_days = 7: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        }
      ],
      "comparison_limit": "Nur baseline und die fehlende Standortinformation werden partiell übersetzt. Die Mindesttagevariation und RGVE-/Prämienhöhe sind ohne zusätzliche Fachfakten nicht gleichwertig vergleichbar.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_14.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | runtime_error | Baseline | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| missing_fact | runtime_error | no | is_in_austria bei der Alm entfernen; prüfen, ob fehlender Standortnachweis die Zulassung verhindert oder wegen negierter Verletzungsprüfung unauffällig bleibt. |

**Fixture gap:** Nicht ausführbar übersetzte Luna-Fälle: variation. Einzelne fehlende Fakten und verlorene Änderungsachsen stehen in luna_translation; keine Ersatzfälle erfunden.


**Open dependencies:**

- Luna-GVE3 beweist weder3Tiere noch Alter/RGVE-Kategorie. count, birth_date und rgve_category_id bleiben abwesend.
- Die 60→59-Tage-Änderung kann ohne erfundene Auf-/Abtriebs- und Meldedaten nicht als nativer stays-Zeitraum umgesetzt werden; variation wird ausgelassen.
- Lunas is_in_austria der Alm wird auf den zugeordneten Aufenthaltsort übertragen; ohne Datumsgrenzen ist dieser Aufenthalt nativ nicht valid_stay. missing_fact kann daher unauffällig bleiben.
- Erstteilnahme=true in2026 liefert kein zulässiges bzw. bestätigtes commitment_start_year und keinen Antrag; kein Vertragsjahr erfunden.
- Meldetage14/7 sind keine konkreten Meldedaten. Zusatzanforderungen und Default-Tierzahl 1 bleiben unbekannte native Annahmen.
- Beobachtung: beide ausgegebenen Fälle scheitern unter --strict-builtin-errors mit eval_type_error in policy/o6_14/participation.rego:19: nicht gelieferter commitment_start_year wird nativ zu null und anschließend als null minus1 verwendet. Fehler bleibt erhalten; kein günstiges Vertragsjahr ergänzt.

**Evidence:**

- [runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/common.rego): Native alpine_farming.alms/animals und measures.
- [runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/animals.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/animals.rego): RGVE aus Kategorie/Alter und count; Alpungstage aus stays mit konkreten Datums-/Meldedaten.
- [runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/participation.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/participation.rego): Zugangsbedingungen; Erstteilnahme wird aus commitment_start_year berechnet.
- [runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/obligations.rego): Teilbefunde und violations.
- [runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/premium.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/workspace/policy/o6_14/premium.rego): access_level und nativer premium_total.
- [runs/v2-o6_14-opus-5.5-high-20260926/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/artifacts/input-paths.json): Historisches Alias-/Inputpfad-Inventar; kein vollständiger semantischer Nachweis der tatsächlich benötigten Fakten.
- [runs/v2-o6_14-opus-5.5-high-20260926/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/artifacts/proposed-profile.json): Historischer Vorschlag des nativen Eingabevertrags; Typen werden gelesen, konkrete positive Testkonstanten nicht übernommen.
- [runs/v2-o6_14-opus-5.5-high-20260926/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/workspace/rules/rules.json): Modellgeneriertes Klauselinventar und Querverweise; kein unabhängiger Referenzstandard.
- [runs/v2-o6_14-opus-5.5-high-20260926/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_14-opus-5.5-high-20260926/workspace/notes/assumptions.md): Historische Annahmen und offene Abhängigkeiten bleiben erhalten.

### o6_15

Run: `v2-o6_15-opus-5.5-high-20260926`. [Fixture](fixtures/o6_15.json) · [Native results](results/o6_15.json)

**Inputs:** Jahr 2026, Teilnahme an Almbewirtschaftung und vorhandene Antragsdaten. Die einzelne Luna-Schafgruppe mit3RGVE wird als unquantifizierter nativer Tiergruppenrecord mit species=sheep abgebildet; keine Kopfzahl, Alterskategorie oder individuellen Bewegungsdaten ergänzt. Gruppen-Behirtungstage60/59 werden auf den belegten Gesamtbehirtungsdauerpfad übertragen.

**Output meaning:** Native Entscheidung enthält Vertragsstatus, eligible, Ausfälle, Alm-/Tierbefunde und gross/net/payable premium. Wegen fehlender Alm-ID und individueller RGVE-/Auftriebsdaten können Schaf-/Almbefunde und Prämie ausbleiben; keine positive bzw. negative unabhängige Referenzwertung.

**Origin:** Öffentliche synthetische Entwicklungsfälle der eingefrorenen Luna-Diagnose, durch Codex ausschließlich auf belegte native Opus-Pfade übersetzt. Keine unabhängigen Sollurteile, keine Expertenfreigabe und keine Held-out-Fälle. Fehlende Fachfakten werden nicht aus Opus-Modelltests ergänzt.

**Query:** `data.oepul.o6_15.decision`

**Inventory:** 95 rule catalog entries; 8 sources; 14 static input paths; 7 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"applicability": 1, "application_requirement": 3, "calculation": 12, "calculation_order": 1, "closed_list": 1, "combination_requirement": 1, "combination_rule": 1, "consequence": 6, "consistency": 1, "contract_term": 3, "cross_reference": 1, "deadline": 8, "definition": 5, "eligibility": 6, "exception": 5, "exit": 1, "information": 2, "interpretation": 1, "limit": 2, "notice_2026": 2, "obligation": 11, "option": 2, "payment": 3, "premium_rate": 4, "procedure": 3, "restriction": 4, "sanction": 4, "scope": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.alpine_farming.alms",
      "input.alpine_farming.herding_application",
      "input.documentation.control_refusal_force_majeure",
      "input.documentation.on_site_control_refused",
      "input.farm.applicant",
      "input.farm.applicant.is_active_farmer",
      "input.farm.applicant.is_alm_operator",
      "input.farm.applicant.legal_form",
      "input.farm.applicant.public_body_share_percent",
      "input.farm.year",
      "input.land",
      "input.oepul_participation",
      "input.oepul_participation.first_oepul_year",
      "input.oepul_participation.measures"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_15 | full_document | 45 | {"not_rule": 5, "rules": 40} |
| o6_general | full_document | 30 | {"not_rule": 12, "rules": 18} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 34 | {"not_rule": 12, "rules": 22} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 5 | {"not_rule": 2, "rules": 3} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 6 | {"not_rule": 4, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 2 | {"not_rule": 2} |
| duerre_2026_oepul_ausgleichszulage | full_document | 3 | {"not_rule": 3} |
| duerre_2026_foerderungsabwicklung | full_document | 7 | {"not_rule": 7} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr unverändert.",
            "Luna /farm/o6_15_application_date -> Opus /oepul_participation/measures/0/application_date: Maßnahmenantragsdatum unverändert; kein Vertragsbeginn daraus erfunden.",
            "Luna /farm/participates_almbewirtschaftung -> Opus /oepul_participation/measures/1/participating_in_year: Bestätigte Kombination unverändert.",
            "Luna /farm/o6_15_payment_application_date -> Opus /alpine_farming/herding_application/payment_application_submission_date: Zahlungsantragsdatum unverändert.",
            "Luna /land/parcels/0/stocking_days -> Opus /alpine_farming/alms/0/stocking_days: Alm-Bestoßungsdauer60 Tage unverändert.",
            "Luna /land/parcels/0/care/daily_care -> Opus /alpine_farming/alms/0/care/daily_care: Daily-Care unverändert.",
            "Luna /land/parcels/0/care/care_essential_part_of_day -> Opus /alpine_farming/alms/0/care/herding_substantial_part_of_day: Wesentlicher Teil des Tages unverändert.",
            "Luna /land/parcels/0/care/water_available -> Opus /alpine_farming/alms/0/care/sufficient_water_supply: Wasserversorgung unverändert.",
            "Luna /land/parcels/0/care/animal_care -> Opus /alpine_farming/alms/0/care/animal_care: Tierbetreuung unverändert.",
            "Luna /land/parcels/0/care/disease_and_injury_treatment -> Opus /alpine_farming/alms/0/care/treatment_of_diseases_and_injuries: Behandlung unverändert.",
            "Luna /land/parcels/0/care/security_measures -> Opus /alpine_farming/alms/0/care/safety_measures: Sicherheitsmaßnahmen unverändert.",
            "Luna /land/parcels/0/grazing_management/site_adapted_grazing -> Opus /alpine_farming/alms/0/care/site_adapted_grazing_management: Standortangepasste Beweidung unverändert.",
            "Luna /land/parcels/0/accommodation_available -> Opus /alpine_farming/alms/0/herder_accommodation_available: Unterkunft unverändert.",
            "Luna /livestock/species_groups/0/species -> Opus /alpine_farming/alms/0/animals/0/species: Schafgruppe ohne erfundene Kopfzahl/Kategorie.",
            "Luna /livestock/species_groups/0/herded -> Opus /alpine_farming/alms/0/animals/0/is_herded: Behirtung unverändert.",
            "Luna /livestock/species_groups/0/herding_days -> Opus /alpine_farming/alms/0/animals/0/total_alpine_days_all_herded_alms: Gruppen-Dauer 60/59 Tage, bzw. abwesend; keine Datumsgrenzen ergänzt.",
            "Luna /livestock/species_groups/0/milked_days_on_alms -> Opus /alpine_farming/alms/0/animals/0/milked_days: 0 Melktage unverändert.",
            "Luna /livestock/herd_protection_dog/requested -> Opus /alpine_farming/herding_application/dog_supplement_requested: Kein beantragter Hundezuschlag.",
            "Luna /livestock/species_groups/0/category=Schafe und herded=true -> Opus /alpine_farming/alms/0/herded_categories=[sheep] und animals/0/behirtung_category=sheep; keine RGVE-Alterskategorie gesetzt."
          ],
          "unmapped_facts": [
            "Luna /land/parcels/0/is_alm = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/grazing_management/subarea_rotation_or_fencing = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/species_groups/0/gve = 3: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/species_groups/0/report = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/herd_protection_dog/dogs_on_alm = 0: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr unverändert.",
            "Luna /farm/o6_15_application_date -> Opus /oepul_participation/measures/0/application_date: Maßnahmenantragsdatum unverändert; kein Vertragsbeginn daraus erfunden.",
            "Luna /farm/participates_almbewirtschaftung -> Opus /oepul_participation/measures/1/participating_in_year: Bestätigte Kombination unverändert.",
            "Luna /farm/o6_15_payment_application_date -> Opus /alpine_farming/herding_application/payment_application_submission_date: Zahlungsantragsdatum unverändert.",
            "Luna /land/parcels/0/stocking_days -> Opus /alpine_farming/alms/0/stocking_days: Alm-Bestoßungsdauer60 Tage unverändert.",
            "Luna /land/parcels/0/care/daily_care -> Opus /alpine_farming/alms/0/care/daily_care: Daily-Care unverändert.",
            "Luna /land/parcels/0/care/care_essential_part_of_day -> Opus /alpine_farming/alms/0/care/herding_substantial_part_of_day: Wesentlicher Teil des Tages unverändert.",
            "Luna /land/parcels/0/care/water_available -> Opus /alpine_farming/alms/0/care/sufficient_water_supply: Wasserversorgung unverändert.",
            "Luna /land/parcels/0/care/animal_care -> Opus /alpine_farming/alms/0/care/animal_care: Tierbetreuung unverändert.",
            "Luna /land/parcels/0/care/disease_and_injury_treatment -> Opus /alpine_farming/alms/0/care/treatment_of_diseases_and_injuries: Behandlung unverändert.",
            "Luna /land/parcels/0/care/security_measures -> Opus /alpine_farming/alms/0/care/safety_measures: Sicherheitsmaßnahmen unverändert.",
            "Luna /land/parcels/0/grazing_management/site_adapted_grazing -> Opus /alpine_farming/alms/0/care/site_adapted_grazing_management: Standortangepasste Beweidung unverändert.",
            "Luna /land/parcels/0/accommodation_available -> Opus /alpine_farming/alms/0/herder_accommodation_available: Unterkunft unverändert.",
            "Luna /livestock/species_groups/0/species -> Opus /alpine_farming/alms/0/animals/0/species: Schafgruppe ohne erfundene Kopfzahl/Kategorie.",
            "Luna /livestock/species_groups/0/herded -> Opus /alpine_farming/alms/0/animals/0/is_herded: Behirtung unverändert.",
            "Luna /livestock/species_groups/0/herding_days -> Opus /alpine_farming/alms/0/animals/0/total_alpine_days_all_herded_alms: Gruppen-Dauer 60/59 Tage, bzw. abwesend; keine Datumsgrenzen ergänzt.",
            "Luna /livestock/species_groups/0/milked_days_on_alms -> Opus /alpine_farming/alms/0/animals/0/milked_days: 0 Melktage unverändert.",
            "Luna /livestock/herd_protection_dog/requested -> Opus /alpine_farming/herding_application/dog_supplement_requested: Kein beantragter Hundezuschlag.",
            "Luna /livestock/species_groups/0/category=Schafe und herded=true -> Opus /alpine_farming/alms/0/herded_categories=[sheep] und animals/0/behirtung_category=sheep; keine RGVE-Alterskategorie gesetzt."
          ],
          "unmapped_facts": [
            "Luna /land/parcels/0/is_alm = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/grazing_management/subarea_rotation_or_fencing = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/species_groups/0/gve = 3: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/species_groups/0/report = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/herd_protection_dog/dogs_on_alm = 0: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr unverändert.",
            "Luna /farm/o6_15_application_date -> Opus /oepul_participation/measures/0/application_date: Maßnahmenantragsdatum unverändert; kein Vertragsbeginn daraus erfunden.",
            "Luna /farm/participates_almbewirtschaftung -> Opus /oepul_participation/measures/1/participating_in_year: Bestätigte Kombination unverändert.",
            "Luna /farm/o6_15_payment_application_date -> Opus /alpine_farming/herding_application/payment_application_submission_date: Zahlungsantragsdatum unverändert.",
            "Luna /land/parcels/0/stocking_days -> Opus /alpine_farming/alms/0/stocking_days: Alm-Bestoßungsdauer60 Tage unverändert.",
            "Luna /land/parcels/0/care/daily_care -> Opus /alpine_farming/alms/0/care/daily_care: Daily-Care unverändert.",
            "Luna /land/parcels/0/care/care_essential_part_of_day -> Opus /alpine_farming/alms/0/care/herding_substantial_part_of_day: Wesentlicher Teil des Tages unverändert.",
            "Luna /land/parcels/0/care/water_available -> Opus /alpine_farming/alms/0/care/sufficient_water_supply: Wasserversorgung unverändert.",
            "Luna /land/parcels/0/care/animal_care -> Opus /alpine_farming/alms/0/care/animal_care: Tierbetreuung unverändert.",
            "Luna /land/parcels/0/care/disease_and_injury_treatment -> Opus /alpine_farming/alms/0/care/treatment_of_diseases_and_injuries: Behandlung unverändert.",
            "Luna /land/parcels/0/care/security_measures -> Opus /alpine_farming/alms/0/care/safety_measures: Sicherheitsmaßnahmen unverändert.",
            "Luna /land/parcels/0/grazing_management/site_adapted_grazing -> Opus /alpine_farming/alms/0/care/site_adapted_grazing_management: Standortangepasste Beweidung unverändert.",
            "Luna /land/parcels/0/accommodation_available -> Opus /alpine_farming/alms/0/herder_accommodation_available: Unterkunft unverändert.",
            "Luna /livestock/species_groups/0/species -> Opus /alpine_farming/alms/0/animals/0/species: Schafgruppe ohne erfundene Kopfzahl/Kategorie.",
            "Luna /livestock/species_groups/0/herded -> Opus /alpine_farming/alms/0/animals/0/is_herded: Behirtung unverändert.",
            "Luna /livestock/species_groups/0/herding_days fehlt -> Opus /alpine_farming/alms/0/animals/0/total_alpine_days_all_herded_alms wird ebenfalls nicht gesetzt; Gruppen-Dauer 60/59 Tage, bzw. abwesend; keine Datumsgrenzen ergänzt.",
            "Luna /livestock/species_groups/0/milked_days_on_alms -> Opus /alpine_farming/alms/0/animals/0/milked_days: 0 Melktage unverändert.",
            "Luna /livestock/herd_protection_dog/requested -> Opus /alpine_farming/herding_application/dog_supplement_requested: Kein beantragter Hundezuschlag.",
            "Luna /livestock/species_groups/0/category=Schafe und herded=true -> Opus /alpine_farming/alms/0/herded_categories=[sheep] und animals/0/behirtung_category=sheep; keine RGVE-Alterskategorie gesetzt."
          ],
          "unmapped_facts": [
            "Luna /land/parcels/0/is_alm = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/grazing_management/subarea_rotation_or_fencing = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/species_groups/0/gve = 3: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/species_groups/0/report = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /livestock/herd_protection_dog/dogs_on_alm = 0: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        }
      ],
      "comparison_limit": "Alle drei fachlichen Dauerfälle bleiben als partielle native Eingaben erhalten. Fehlende individuelle/almbezogene Identifikations- und Zeitdaten verhindern einen gleichwertigen Prämien-/Gesamtzulassungsvergleich.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_15.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |
| variation | defined | no | herding_days der Schafgruppe von 60 auf 59 ändern; die 60-Tage-Grenze getrennt von Teilnahme und Prämienberechnung beobachten. |
| missing_fact | defined | no | herding_days entfernen; untersuchen, ob der Teilcheck zwischen fehlendem Zeitraum und dokumentierter Unterschreitung unterscheidet. |

**Open dependencies:**

- Luna enthält keine Alm-ID, Tieridentität, Tierzahl, Geburtsdatum oder RGVE-Kategorie; diese Fakten bleiben offen.3 RGVE werden nicht zu einer Zahl Schafe umgerechnet.
- Der unquantifizierte Gruppenrecord ersetzt keine vollständig identifizierten Einzeltiere; nativ kann der Default count=1 greifen, ohne dass1Tier bestätigt ist.
- stocking_days60 und Gruppen-Behirtungstage60/59 liefern keine Auf-/Abtriebsdaten. Fehlende IDs können die native Dauerverletzung im aggregierten Output unterdrücken.
- Luna hat keinen night_care_when_required-Flag und keine Kataster-/Abgrenzungsnachweise; Daily-Care=true ersetzt diese nicht.
- Die Zugehörigkeit der einzigen Schafgruppe zur einzigen Alm wird lediglich als synthetische Strukturzuordnung verwendet; keine reale Tierbewegung belegt.
- Beobachtung: alle drei Entscheidungen identisch, alm_results={}, obligation_violations=[], contract_status=not_concluded und payable_premium_eur=0. Die native Gesamtprojektion zeigt die erhaltene60/59/fehlend-Dauerachse wegen fehlender alm_id und Individualdaten nicht an.

**Evidence:**

- [runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/lib.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/lib.rego): Native alpine_farming.alms; RGVE braucht Kategorie oder Geburtsdatum und count.
- [runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/animals.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/animals.rego): total_alpine_days_all_herded_alms kann die belegte Gesamtbehirtungsdauer aufnehmen; erkennbare Tage auf dieser Alm brauchen zusätzlich Datumsgrenzen.
- [runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/alm.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/alm.rego): Native Care-/Unterkunfts- und stocking_days-Felder.
- [runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/contract.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/contract.rego): oepul_participation.measures und herding_application.
- [runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/workspace/policy/o6_15/decision.rego): Native Entscheidung; alm_id ist für schlag-/tierbezogene Befundobjekte nötig.
- [runs/v2-o6_15-opus-5.5-high-20260926/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/artifacts/input-paths.json): Historisches Alias-/Inputpfad-Inventar; kein vollständiger semantischer Nachweis der tatsächlich benötigten Fakten.
- [runs/v2-o6_15-opus-5.5-high-20260926/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/artifacts/proposed-profile.json): Historischer Vorschlag des nativen Eingabevertrags; Typen werden gelesen, konkrete positive Testkonstanten nicht übernommen.
- [runs/v2-o6_15-opus-5.5-high-20260926/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/workspace/rules/rules.json): Modellgeneriertes Klauselinventar und Querverweise; kein unabhängiger Referenzstandard.
- [runs/v2-o6_15-opus-5.5-high-20260926/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_15-opus-5.5-high-20260926/workspace/notes/assumptions.md): Historische Annahmen und offene Abhängigkeiten bleiben erhalten.

### o6_16

Run: `v2-o6_16-opus-5.5-high-20261003`. [Fixture](fixtures/o6_16.json) · [Native results](results/o6_16.json)

**Inputs:** Jahr 2026 und Maßnahmebeginn2024 bleiben erhalten. Katastergemeinde32001 und Schlagfläche0,2 ha bleiben unverändert. Luna enthält aggregierte10/9 Bildungsstunden und ein Abschlussdatum, Opus verlangt datierte einzelne Kurse; keine Kursliste aus der Aggregation erfunden. Bodenprobendaten und akkreditierter Laborflag werden erhalten, fehlende Laborübermittlungs-/Parameterangaben nicht ergänzt.

**Output meaning:** Begrenzte Projektion tatsächlicher nativer Bildungsstunden, Bodenproben-/Flächenzahlen und Verstoßmengen. Die native Default-Kursliste[] kann0 anrechenbare Stunden ergeben; das ist ausdrücklich kein Beweis für0tatsächliche Bildungsstunden und keine gleichwertige Bewertung der Luna10/9 Stunden.

**Origin:** Öffentliche synthetische Entwicklungsfälle der eingefrorenen Luna-Diagnose, durch Codex ausschließlich auf belegte native Opus-Pfade übersetzt. Keine unabhängigen Sollurteile, keine Expertenfreigabe und keine Held-out-Fälle. Fehlende Fachfakten werden nicht aus Opus-Modelltests ergänzt. Nicht abbildbare Fälle sind bewusst als Lücke statt als zusätzliche Beobachtung erhalten.

**Query:** `{"creditable_training_hours": data.oepul.o6_16.creditable_training_hours, "obligation_violations": data.oepul.o6_16.obligation_violations, "access_violations": data.oepul.o6_16.access_violations, "soil_samples_required": data.oepul.o6_16.soil_samples_required, "creditable_soil_samples": data.oepul.o6_16.creditable_soil_samples, "gwa_arable_area_ha": data.oepul.o6_16.gwa_arable_area_ha}`

**Inventory:** 98 rule catalog entries; 11 sources; 2 static input paths; 34 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"calculation": 12, "combination_rule": 4, "deadline": 7, "definition": 5, "eligibility_condition": 12, "exception": 4, "obligation": 32, "premium_rate": 7, "premium_rule": 1, "procedure": 7, "prohibition": 6, "sanction": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.region.federal_state",
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_16 | full_document | 40 | {"not_rule": 4, "rules": 36} |
| o6_general | full_document | 30 | {"not_rule": 6, "rules": 24} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 24 | {"not_rule": 4, "rules": 20} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"not_rule": 1, "rules": 4, "unresolved": 1} |
| gsp_anwendungsverordnung | targeted_sections | 13 | {"not_rule": 3, "rules": 10} |
| napv | targeted_sections | 12 | {"rules": 10, "unresolved": 2} |
| aufzeichnungen_2026_grundwasserschutz_acker | full_document | 4 | {"not_rule": 1, "rules": 3} |
| duerre_2026_oepul_ausgleichszulage | full_document | 4 | {"not_rule": 2, "rules": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 5 | {"not_rule": 3, "rules": 2} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 4 | {"not_rule": 2, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 2 | {"not_rule": 2} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2026 unverändert.",
            "Luna /farm/region/federal_state -> Opus /farm/region/federal_state: Burgenland unverändert.",
            "Luna /farm/region/bentazon_reauthorized -> Opus /context/bentazon_reauthorised: Native Schreibweise desselben Zulassungsflags.",
            "Luna /measure/first_participation_year -> Opus /farm/oepul/o6_16/commitment_start_year: Erstes Maßnahmenjahr 2024 unverändert, nicht allgemeines ÖPUL-Jahr.",
            "Luna /land/parcels/0/id -> Opus /land/parcels/0/parcel_id: Identität p1 unverändert.",
            "Luna /land/parcels/0/kg_number -> Opus /land/parcels/0/kg_number: KG32001 unverändert.",
            "Luna /land/parcels/0/crop_area_ha -> Opus /land/parcels/0/area_ha: 0,2 ha unverändert.",
            "Luna /land/parcels/0/crop_category -> Opus /land/parcels/0/crop/crop_category: Getreide unverändert.",
            "Luna /land/parcels/0/field_record_complete -> Opus /land/parcels/0/plot_records/complete: Schlagaufzeichnung unverändert.",
            "Luna /land/parcels/0/nitrogen_surplus_kg_per_ha -> Opus /land/parcels/0/n_balance/previous_crop_n_saldo_kg_ha: 0kgN/ha unverändert.",
            "Luna /land/parcels/0/following_crop_reduction_kg_per_ha -> Opus /land/parcels/0/n_balance/following_crop_n_reduction_kg_ha: 0kgN/ha unverändert.",
            "Luna /land/parcels/0/following_crop_planted_by_11_15 -> Opus /land/parcels/0/n_balance/follow_crop_sown_by_nov15: Folgekultur bis 15.11.unverändert.",
            "Luna /records/soil_samples/0/lab_accredited -> Opus /documentation/o6_16/soil_samples/0/accredited_lab: Laborflag unverändert.",
            "Luna /records/soil_samples/0/draw_date -> Opus /documentation/o6_16/soil_samples/0/sample_date: Probennahme01.01.2024 unverändert.",
            "Luna /records/soil_samples/1/lab_accredited -> Opus /documentation/o6_16/soil_samples/1/accredited_lab: Laborflag unverändert.",
            "Luna /records/soil_samples/1/draw_date -> Opus /documentation/o6_16/soil_samples/1/sample_date: Probennahme01.01.2025 unverändert.",
            "Luna /measure/{participates_cover_intercrop,participates_cover_evergreen,participates_organic} -> Opus /farm/oepul/participating_measures=[6] entsprechend denselben ausdrücklichen Teilnahmeflags. requested=true wird nicht zu nachgewiesener Teilnahme16 umgedeutet.",
            "Luna /land/parcels/0/crop_category=cereal und /land/total_arable_area_ha bestätigen die als Acker dargestellte Parzelle -> Opus /land/parcels/0/land_use=arable; Fläche bleibt0,2 ha."
          ],
          "unmapped_facts": [
            "Luna /farm/region/is_eastern_lower_austria_or_tullnerfeld = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /measure/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/total_arable_area_ha = 10: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/groundwater_arable_area_ha = 5.03: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/in_groundwater_area = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/psm_active_ingredients = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/cover_crop_planted_by_11_15 = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/farm_planning_completed_by_02_28 = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/farm_balance_completed_by_next_01_31 = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_hours = 10: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_provider_recognized = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_completed_date = \"2026-12-31\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/water_protection_concept_complete = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/oo_ipm_inspection_or_warning_documented = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/vienna_extra_education_hours = 0: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/pig_feed_recipe_evidence = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/cultan_field_records_complete = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/cultan_external_service_evidence = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/washout_risk/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/washout_risk/parcel_ids = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/turning_tillage_other_than_after_maize = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/recognized_carbon_project_confirmation = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/feed_categories = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/also_claimed_in_liquid_manure_measure = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/has_ammonium_depot_injection = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/external_equipment = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/psm_avoidance_surcharge/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2026 unverändert.",
            "Luna /farm/region/federal_state -> Opus /farm/region/federal_state: Burgenland unverändert.",
            "Luna /farm/region/bentazon_reauthorized -> Opus /context/bentazon_reauthorised: Native Schreibweise desselben Zulassungsflags.",
            "Luna /measure/first_participation_year -> Opus /farm/oepul/o6_16/commitment_start_year: Erstes Maßnahmenjahr 2024 unverändert, nicht allgemeines ÖPUL-Jahr.",
            "Luna /land/parcels/0/id -> Opus /land/parcels/0/parcel_id: Identität p1 unverändert.",
            "Luna /land/parcels/0/kg_number -> Opus /land/parcels/0/kg_number: KG32001 unverändert.",
            "Luna /land/parcels/0/crop_area_ha -> Opus /land/parcels/0/area_ha: 0,2 ha unverändert.",
            "Luna /land/parcels/0/crop_category -> Opus /land/parcels/0/crop/crop_category: Getreide unverändert.",
            "Luna /land/parcels/0/field_record_complete -> Opus /land/parcels/0/plot_records/complete: Schlagaufzeichnung unverändert.",
            "Luna /land/parcels/0/nitrogen_surplus_kg_per_ha -> Opus /land/parcels/0/n_balance/previous_crop_n_saldo_kg_ha: 0kgN/ha unverändert.",
            "Luna /land/parcels/0/following_crop_reduction_kg_per_ha -> Opus /land/parcels/0/n_balance/following_crop_n_reduction_kg_ha: 0kgN/ha unverändert.",
            "Luna /land/parcels/0/following_crop_planted_by_11_15 -> Opus /land/parcels/0/n_balance/follow_crop_sown_by_nov15: Folgekultur bis 15.11.unverändert.",
            "Luna /records/soil_samples/0/lab_accredited -> Opus /documentation/o6_16/soil_samples/0/accredited_lab: Laborflag unverändert.",
            "Luna /records/soil_samples/0/draw_date -> Opus /documentation/o6_16/soil_samples/0/sample_date: Probennahme01.01.2024 unverändert.",
            "Luna /records/soil_samples/1/lab_accredited -> Opus /documentation/o6_16/soil_samples/1/accredited_lab: Laborflag unverändert.",
            "Luna /records/soil_samples/1/draw_date -> Opus /documentation/o6_16/soil_samples/1/sample_date: Probennahme01.01.2025 unverändert.",
            "Luna /measure/{participates_cover_intercrop,participates_cover_evergreen,participates_organic} -> Opus /farm/oepul/participating_measures=[6] entsprechend denselben ausdrücklichen Teilnahmeflags. requested=true wird nicht zu nachgewiesener Teilnahme16 umgedeutet.",
            "Luna /land/parcels/0/crop_category=cereal und /land/total_arable_area_ha bestätigen die als Acker dargestellte Parzelle -> Opus /land/parcels/0/land_use=arable; Fläche bleibt0,2 ha."
          ],
          "unmapped_facts": [
            "Luna /farm/region/is_eastern_lower_austria_or_tullnerfeld = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /measure/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/total_arable_area_ha = 10: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/groundwater_arable_area_ha = 5.03: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/in_groundwater_area = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/psm_active_ingredients = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/cover_crop_planted_by_11_15 = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/farm_planning_completed_by_02_28 = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/farm_balance_completed_by_next_01_31 = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_hours = 9: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_provider_recognized = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_completed_date = \"2026-12-31\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/water_protection_concept_complete = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/oo_ipm_inspection_or_warning_documented = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/vienna_extra_education_hours = 0: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/pig_feed_recipe_evidence = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/cultan_field_records_complete = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/cultan_external_service_evidence = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/washout_risk/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/washout_risk/parcel_ids = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/turning_tillage_other_than_after_maize = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/recognized_carbon_project_confirmation = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/feed_categories = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/also_claimed_in_liquid_manure_measure = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/has_ammonium_depot_injection = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/external_equipment = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/psm_avoidance_surcharge/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Dieser Luna-Fall besitzt keine vollständig belegbare veränderte native Eingabe und wird daher nicht als ausführbarer Opus-Vergleichsfall ausgegeben."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "Luna /farm/year -> Opus /farm/year: Jahr 2026 unverändert.",
            "Luna /farm/region/federal_state -> Opus /farm/region/federal_state: Burgenland unverändert.",
            "Luna /farm/region/bentazon_reauthorized -> Opus /context/bentazon_reauthorised: Native Schreibweise desselben Zulassungsflags.",
            "Luna /measure/first_participation_year -> Opus /farm/oepul/o6_16/commitment_start_year: Erstes Maßnahmenjahr 2024 unverändert, nicht allgemeines ÖPUL-Jahr.",
            "Luna /land/parcels/0/id -> Opus /land/parcels/0/parcel_id: Identität p1 unverändert.",
            "Luna /land/parcels/0/kg_number -> Opus /land/parcels/0/kg_number: KG32001 unverändert.",
            "Luna /land/parcels/0/crop_area_ha -> Opus /land/parcels/0/area_ha: 0,2 ha unverändert.",
            "Luna /land/parcels/0/crop_category -> Opus /land/parcels/0/crop/crop_category: Getreide unverändert.",
            "Luna /land/parcels/0/field_record_complete -> Opus /land/parcels/0/plot_records/complete: Schlagaufzeichnung unverändert.",
            "Luna /land/parcels/0/nitrogen_surplus_kg_per_ha -> Opus /land/parcels/0/n_balance/previous_crop_n_saldo_kg_ha: 0kgN/ha unverändert.",
            "Luna /land/parcels/0/following_crop_reduction_kg_per_ha -> Opus /land/parcels/0/n_balance/following_crop_n_reduction_kg_ha: 0kgN/ha unverändert.",
            "Luna /land/parcels/0/following_crop_planted_by_11_15 -> Opus /land/parcels/0/n_balance/follow_crop_sown_by_nov15: Folgekultur bis 15.11.unverändert.",
            "Luna /records/soil_samples/0/lab_accredited -> Opus /documentation/o6_16/soil_samples/0/accredited_lab: Laborflag unverändert.",
            "Luna /records/soil_samples/0/draw_date -> Opus /documentation/o6_16/soil_samples/0/sample_date: Probennahme01.01.2024 unverändert.",
            "Luna /records/soil_samples/1/lab_accredited -> Opus /documentation/o6_16/soil_samples/1/accredited_lab: Laborflag unverändert.",
            "Luna /records/soil_samples/1/draw_date -> Opus /documentation/o6_16/soil_samples/1/sample_date: Probennahme01.01.2025 unverändert.",
            "Luna /measure/{participates_cover_intercrop,participates_cover_evergreen,participates_organic} -> Opus /farm/oepul/participating_measures=[6] entsprechend denselben ausdrücklichen Teilnahmeflags. requested=true wird nicht zu nachgewiesener Teilnahme16 umgedeutet.",
            "Luna /land/parcels/0/crop_category=cereal und /land/total_arable_area_ha bestätigen die als Acker dargestellte Parzelle -> Opus /land/parcels/0/land_use=arable; Fläche bleibt0,2 ha."
          ],
          "unmapped_facts": [
            "Luna /farm/region/is_eastern_lower_austria_or_tullnerfeld = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /measure/requested = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/total_arable_area_ha = 10: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/groundwater_arable_area_ha = 5.03: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/in_groundwater_area = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/psm_active_ingredients = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /land/parcels/0/cover_crop_planted_by_11_15 = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/farm_planning_completed_by_02_28 = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/farm_balance_completed_by_next_01_31 = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_provider_recognized = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/education_completed_date = \"2026-12-31\": kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/water_protection_concept_complete = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/oo_ipm_inspection_or_warning_documented = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/vienna_extra_education_hours = 0: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/pig_feed_recipe_evidence = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/cultan_field_records_complete = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /records/cultan_external_service_evidence = true: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/washout_risk/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/washout_risk/parcel_ids = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/turning_tillage_other_than_after_maize = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/vienna_humus/recognized_carbon_project_confirmation = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/feed_categories = []: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/strong_n_reduced_pig_feeding/also_claimed_in_liquid_manure_measure = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/has_ammonium_depot_injection = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/cultan/external_equipment = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Luna /options/psm_avoidance_surcharge/requested = false: kein fachlich gleichwertiger nativer Zielpfad belegt; keine Ersatzinformation ergänzt.",
            "Dieser Luna-Fall besitzt keine vollständig belegbare veränderte native Eingabe und wird daher nicht als ausführbarer Opus-Vergleichsfall ausgegeben."
          ]
        }
      ],
      "comparison_limit": "Nur partieller baseline-Fall ausführbar. Der ursprüngliche Bildungsstundenkontrast ist als Übersetzungslücke erhalten und wird nicht durch modellsynthetische Einzelkurse ersetzt. Zusätzliche Opus-Gebiets-/Probenanforderungen verhindern einen direkten Gesamtvergleich.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_16.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Synthetische Ausgangskonstellation zur Beobachtung der nativen Ausgabe; kein fachlich bestätigter Positivfall. |

**Fixture gap:** Nicht ausführbar übersetzte Luna-Fälle: variation, missing_fact. Einzelne fehlende Fakten und verlorene Änderungsachsen stehen in luna_translation; keine Ersatzfälle erfunden.


**Open dependencies:**

- Die 10→9-Stunden-Variation und fehlende Stundensumme sind ohne individuelle Kursnachweise nicht nativ abbildbar; beide Zusatzfälle werden bewusst ausgelassen.
- Ein Abschlussdatum belegt weder ein einzelnes10 Stunden-Seminar noch alle Kursdaten/Anrechnungskriterien; keine Kursanzahl oder Teilnahme-/Doppelanrechnungsflags erfunden.
- Lunas5,03 ha Gebiets-/10 ha Ackeraggregat passen nicht zur einzigen0,2 ha-Parzelle. Keine zusätzlichen Parzellen oder Flächenskalierung ergänzt; Opus aggregiert0,2 ha.
- Luna in_groundwater_area=true ersetzt nicht den nativen KG-Katalog. KG32001 wird exakt behalten, auch wenn der Katalog den synthetischen Flag nicht bestätigt.
- Bodenproben brauchen zusätzlich Laborübermittlungsdatum, Methode und Parameter; accredited_lab=true allein macht sie nicht nativ anrechenbar.
- Boolesche Planungs-/Bilanzierungs-/Konzeptnachweise liefern keine verlangten konkreten Datumsangaben.
- Beobachtung des partiellen baseline:0 anrechenbare Stunden,0 anrechenbare Proben,1 erforderliche Probe aus0,2 ha. Die bekannte aggregierte Luna-Bildung/Fläche wird dadurch nicht widerlegt; vollständige native Einzelbelege fehlen.

**Evidence:**

- [runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/base.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/base.rego): Native Gebietszuordnung über KG-Liste und Aggregation aus einzelnen Ackerparzellen.
- [runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/training_soil.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/training_soil.rego): Individuelle datierte Kurse, Soll-/Ist-Bodenproben und zusätzliche Labor-/Parameteranforderungen.
- [runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/access.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/access.rego): Native farm.oepul.o6_16 und Maßnahmenteilnahme.
- [runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/nitrogen.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/workspace/policy/o6_16/nitrogen.rego): Native n_balance-Pfade und benötigte stickstoffbezogene Grunddaten.
- [runs/v2-o6_16-opus-5.5-high-20261003/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/artifacts/input-paths.json): Historisches Alias-/Inputpfad-Inventar; kein vollständiger semantischer Nachweis der tatsächlich benötigten Fakten.
- [runs/v2-o6_16-opus-5.5-high-20261003/artifacts/proposed-profile.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/artifacts/proposed-profile.json): Historischer Vorschlag des nativen Eingabevertrags; Typen werden gelesen, konkrete positive Testkonstanten nicht übernommen.
- [runs/v2-o6_16-opus-5.5-high-20261003/workspace/rules/rules.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/workspace/rules/rules.json): Modellgeneriertes Klauselinventar und Querverweise; kein unabhängiger Referenzstandard.
- [runs/v2-o6_16-opus-5.5-high-20261003/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_16-opus-5.5-high-20261003/workspace/notes/assumptions.md): Historische Annahmen und offene Abhängigkeiten bleiben erhalten.

### o6_17

Run: `v2-o6_17-opus-5.5-high-20261011`. [Fixture](fixtures/o6_17.json) · [Native results](results/o6_17.json)

**Inputs:** Nativer Vertrag: farm.year, land.parcels, oepul.participating_measures und oepul.o6_17 mit eligible_grassland_lt18_mfa2025_ha sowie einzelnen soil_samples-Belegen. RGVE werden aus Tierbeständen und Bonität je Schlag berechnet. Luna liefert 2025, 10 ha Grünland, 50 % Grünlandanteil, 100 ha Gesamtfläche, 3 RGVE, drei beziehungsweise zwei Bodenproben und die mittlere Bonität 25. Diese Aggregate werden weder vereinheitlicht noch in erfundene Einzelbelege zerlegt.

**Output meaning:** decision kombiniert Zugangs-, Verpflichtungs- und Prämienbefunde des aktuellen ausgewählten historischen Kandidaten. Hier keine gleichartige Ausführung: fixture_gap dokumentiert die unterschiedlichen Aggregate-/Belegverträge und ist keine fachliche Ablehnung oder Genauigkeitsmessung.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_17.decision`

**Inventory:** 133 rule catalog entries; 9 sources; 1 static input paths; 38 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 8, "application": 4, "calculation": 13, "combination_constraint": 2, "consequence": 6, "constraint": 2, "cross_reference": 1, "definition": 10, "documentation": 6, "eligibility": 11, "exception": 17, "interpretation": 3, "method": 3, "obligation": 17, "procedure": 7, "prohibition": 4, "reference_list": 1, "sanction": 6, "temporal_constraint": 12}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_17 | full_document | 34 | {"not_rule": 3, "rules": 31} |
| o6_general | full_document | 41 | {"not_rule": 11, "rules": 30} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 38 | {"not_rule": 8, "rules": 30} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 8 | {"not_rule": 1, "rules": 7} |
| gsp_anwendungsverordnung | targeted_sections | 21 | {"not_rule": 2, "rules": 19} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 10 | {"not_rule": 5, "rules": 5} |
| rebzikade_2026_insektizidverzicht | full_document | 4 | {"not_rule": 3, "rules": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 4 | {"not_rule": 2, "rules": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 5, "rules": 3} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [],
          "unmapped_facts": [
            "/oepul/o6_17/soil_samples_submitted = 3:Opus zählt konkrete gültige /oepul/o6_17/soil_samples mit Proben-/Abgabedatum, Labor, Methode und Parametern; keine Zahlen-zu-Belegen-Erfindung.",
            "/oepul/o6_17/average_grassland_score  = 25:Opus benötigt /land/parcels/0/grassland_figure; Betriebsaggregate bestimmen keine einzelne Schlagbonität.",
            "/oepul/o6_17/rgve_total = 3:Opus leitet aus Tierkategorien/Bestand ab; keine drei Kühe oder andere Tierzerlegung erfunden.",
            "/oepul/o6_17/soil_basis_grassland_under_18_ha = 10.4 wäre exakt als /oepul/o6_17/eligible_grassland_lt18_mfa2025_ha übertragbar; unverändert 10,4 ha, kein zusätzlicher0,4-ha-Schlag.",
            "/oepul/o6_17/grassland_share_excluding_alpine_percent = 50, /land/grassland_area_ha = 10, /oepul/o6_17/total_farm_area_ha = 100:Opus-Anteil wird aus Parzellen/Gesamt-/Almfläche berechnet; keine Anpassung100 → 20 oder erfundene Almfläche.",
            "2025, Vertragsbeginn 2025, UBB, vorhandener10-ha-Schlag/12 % Hang und einmähdige Wiese sind Kontextfakten; sie lösen die nicht übersetzbare primäre Probenvariation/Bonitätsauslassung nicht."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [],
          "unmapped_facts": [
            "/oepul/o6_17/soil_samples_submitted = 2:Opus zählt konkrete gültige /oepul/o6_17/soil_samples mit Proben-/Abgabedatum, Labor, Methode und Parametern; keine Zahlen-zu-Belegen-Erfindung.",
            "/oepul/o6_17/average_grassland_score  = 25:Opus benötigt /land/parcels/0/grassland_figure; Betriebsaggregate bestimmen keine einzelne Schlagbonität.",
            "/oepul/o6_17/rgve_total = 3:Opus leitet aus Tierkategorien/Bestand ab; keine drei Kühe oder andere Tierzerlegung erfunden.",
            "/oepul/o6_17/soil_basis_grassland_under_18_ha = 10.4 wäre exakt als /oepul/o6_17/eligible_grassland_lt18_mfa2025_ha übertragbar; unverändert 10,4 ha, kein zusätzlicher0,4-ha-Schlag.",
            "/oepul/o6_17/grassland_share_excluding_alpine_percent = 50, /land/grassland_area_ha = 10, /oepul/o6_17/total_farm_area_ha = 100:Opus-Anteil wird aus Parzellen/Gesamt-/Almfläche berechnet; keine Anpassung100 → 20 oder erfundene Almfläche.",
            "2025, Vertragsbeginn 2025, UBB, vorhandener10-ha-Schlag/12 % Hang und einmähdige Wiese sind Kontextfakten; sie lösen die nicht übersetzbare primäre Probenvariation/Bonitätsauslassung nicht."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [],
          "unmapped_facts": [
            "/oepul/o6_17/soil_samples_submitted = 3:Opus zählt konkrete gültige /oepul/o6_17/soil_samples mit Proben-/Abgabedatum, Labor, Methode und Parametern; keine Zahlen-zu-Belegen-Erfindung.",
            "/oepul/o6_17/average_grassland_score fehlt absichtlich:Opus benötigt /land/parcels/0/grassland_figure; Betriebsaggregate bestimmen keine einzelne Schlagbonität.",
            "/oepul/o6_17/rgve_total = 3:Opus leitet aus Tierkategorien/Bestand ab; keine drei Kühe oder andere Tierzerlegung erfunden.",
            "/oepul/o6_17/soil_basis_grassland_under_18_ha = 10.4 wäre exakt als /oepul/o6_17/eligible_grassland_lt18_mfa2025_ha übertragbar; unverändert 10,4 ha, kein zusätzlicher0,4-ha-Schlag.",
            "/oepul/o6_17/grassland_share_excluding_alpine_percent = 50, /land/grassland_area_ha = 10, /oepul/o6_17/total_farm_area_ha = 100:Opus-Anteil wird aus Parzellen/Gesamt-/Almfläche berechnet; keine Anpassung100 → 20 oder erfundene Almfläche.",
            "2025, Vertragsbeginn 2025, UBB, vorhandener10-ha-Schlag/12 % Hang und einmähdige Wiese sind Kontextfakten; sie lösen die nicht übersetzbare primäre Probenvariation/Bonitätsauslassung nicht."
          ]
        }
      ],
      "comparison_limit": "Luna liefert die Bodenprobenzahl 3 → 2, die mittlere Bonität 25 und 3 RGVE als Aggregate. Opus verlangt konkrete gültige Bodenproben, schlagbezogene Bonität und Tierbestände. Die Probenvariation und Bonitätsauslassung lassen sich ohne neue Labor-, Datums-, Schlag- oder Tierfakten nicht gleich übersetzen. Die vorhandene MFA-2025-Probenbasis von 10,4 ha hat dagegen einen direkten nativen Aggregatpfad und bleibt 10,4 ha; sie erzeugt keinen zusätzlichen Schlag von 0,4 ha.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_17.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| — | fixture_gap | fixture_gap | No executable cases |

**Fixture gap:** Luna liefert die Bodenprobenzahl 3 → 2, die mittlere Bonität 25 und 3 RGVE als Aggregate. Opus verlangt konkrete gültige Bodenproben, schlagbezogene Bonität und Tierbestände. Die Probenvariation und Bonitätsauslassung lassen sich ohne neue Labor-, Datums-, Schlag- oder Tierfakten nicht gleich übersetzen. Die vorhandene MFA-2025-Probenbasis von 10,4 ha hat dagegen einen direkten nativen Aggregatpfad und bleibt 10,4 ha; sie erzeugt keinen zusätzlichen Schlag von 0,4 ha.


**Open dependencies:**

- Luna liefert die Bodenprobenzahl 3 → 2, die mittlere Bonität 25 und 3 RGVE als Aggregate. Opus verlangt konkrete gültige Bodenproben, schlagbezogene Bonität und Tierbestände. Die Probenvariation und Bonitätsauslassung lassen sich ohne neue Labor-, Datums-, Schlag- oder Tierfakten nicht gleich übersetzen. Die vorhandene MFA-2025-Probenbasis von 10,4 ha hat dagegen einen direkten nativen Aggregatpfad und bleibt 10,4 ha; sie erzeugt keinen zusätzlichen Schlag von 0,4 ha.
- Für eigenständige neue Opus-Entwicklungsfälle wären zusätzliche ausdrücklich synthetische Belege separat zu erstellen; sie wären keine Übersetzung der eingefrorenen Luna-Fälle.

**Evidence:**

- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/common.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/contract.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/contract.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/obligations.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/livestock.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/livestock.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/premium.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/premium.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/policy/o6_17/eligibility.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/tests/o6_17_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/tests/o6_17_test.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/rules/profile_changes.json): Belegte Vorschläge zum nativen Eingabevertrag und Einheiten; keine Veränderung des Canonical Farm Profile.
- [runs/v2-o6_17-opus-5.5-high-20261011/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_17-opus-5.5-high-20261011/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_17-opus-5.5-high-20261011/workspace/notes/assumptions.md): Historische Annahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.

### o6_18

Run: `v2-o6_18-opus-5.5-high-20260927`. [Fixture](fixtures/o6_18.json) · [Native results](results/o6_18.json)

**Inputs:** Native Teilübersetzung: farm.year = 2026, land.total_area_ha = 20, vorhandener Grünlandschlag und Projektbestätigung mit Auflagencode GA09 beziehungsweise GL06; NAT-Marker unter oepul.codes. Der technische Identifier luna-parcel-0 bezeichnet nur das vorhandene Arrayelement. Keine Schlagfläche, Antrags- oder Vertragsdaten, Nutzungsereignisse oder Referenzflächenzuordnung werden ergänzt.

**Output meaning:** decision bündelt compliant, Verstöße, Befunde und Prämienarithmetik. Die vorhandenen Projekt-/Auflagencodeproben werden sichtbar; unbekannte Schlagfläche, Referenzzuordnung oder Fristbelege dürfen nicht als bestätigt gelten. Ein nativer Null-/Nullbetragswert ist aufgrund der unvollständigen Eingabe kein Qualitätsvergleich oder bewilligter Zahlbetrag.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_18.decision`

**Inventory:** 125 rule catalog entries; 8 sources; 1 static input paths; 30 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"administrative_consequence": 6, "combination": 12, "deadline": 5, "definition": 5, "documentation": 2, "eligibility": 13, "exception": 9, "information": 4, "obligation": 19, "premium_calculation": 14, "procedure": 18, "prohibition": 17, "sanction": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_18 | full_document | 23 | {"not_rule": 2, "rules": 21} |
| o6_general | full_document | 39 | {"not_rule": 9, "rules": 30} |
| srl_oepul_2023 | targeted_sections | 22 | {"not_rule": 3, "rules": 19} |
| srl_oepul_2023_anhaenge | targeted_sections | 15 | {"rules": 15} |
| notice_2026-05-22_trockenheit_biodiversitaetsflaechen | full_document | 6 | {"not_rule": 2, "rules": 4} |
| notice_2026-06-12_insektizidverzicht_rebzikade | full_document | 1 | {"not_rule": 1} |
| notice_2026-08-05_duerre_erleichterungen_oepul_az | full_document | 3 | {"not_rule": 1, "rules": 2} |
| notice_2026-08-12_duerre_erleichterungen_abwicklung | full_document | 6 | {"not_rule": 3, "rules": 3} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/year → /farm/year:2026; /land/total_area_ha → derselbe Pfad:20 ha Gesamtbetriebsfläche, keine Schlagfläche.",
            "/application/measure = o6_18 → /farm/oepul/measures/0 = 18; /application/nat_code = true → /land/parcels/0/oepul/codes/0 = NAT für das vorhandene einzige Schlagarrayelement.",
            "/land/parcels/0/land_use = grassland bleibt; /land/parcels/0 bekommt ausschließlich technischen Struktur-Identifier luna-parcel-0, keine neue Fläche oder Parzelle.",
            "/land/parcels/0/naturschutz_codes/0/code → /land/parcels/0/naturschutz/project_confirmation/auflagen/0:GA09 bzw.GL06 unverändert.",
            "/land/parcels/0/project_confirmation → /land/parcels/0/naturschutz/project_confirmation/present; der fehlende Fakt bleibt im missing_fact-Fall abwesend."
          ],
          "unmapped_facts": [
            "/application/nature_reference_area = true ist ein Betriebs-Sammelbefund und bestimmt keine schlagbezogene /naturschutz/reference_area_present-Zuordnung; nicht zum einzigen Schlag hinzugeraten.",
            "Schlagfläche fehlt schon bei Luna; 20 ha Gesamtfläche wird nicht als Schlagfläche verwendet.",
            "Vertragsbeginn, Antragstermin, Projektparameter und Nutzungs-/Monitoring-Einzelbelege fehlen bereits; native Defaults sind keine neuen bestätigten Fakten."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/year → /farm/year:2026; /land/total_area_ha → derselbe Pfad:20 ha Gesamtbetriebsfläche, keine Schlagfläche.",
            "/application/measure = o6_18 → /farm/oepul/measures/0 = 18; /application/nat_code = true → /land/parcels/0/oepul/codes/0 = NAT für das vorhandene einzige Schlagarrayelement.",
            "/land/parcels/0/land_use = grassland bleibt; /land/parcels/0 bekommt ausschließlich technischen Struktur-Identifier luna-parcel-0, keine neue Fläche oder Parzelle.",
            "/land/parcels/0/naturschutz_codes/0/code → /land/parcels/0/naturschutz/project_confirmation/auflagen/0:GA09 bzw.GL06 unverändert.",
            "/land/parcels/0/project_confirmation → /land/parcels/0/naturschutz/project_confirmation/present; der fehlende Fakt bleibt im missing_fact-Fall abwesend."
          ],
          "unmapped_facts": [
            "/application/nature_reference_area = true ist ein Betriebs-Sammelbefund und bestimmt keine schlagbezogene /naturschutz/reference_area_present-Zuordnung; nicht zum einzigen Schlag hinzugeraten.",
            "Schlagfläche fehlt schon bei Luna; 20 ha Gesamtfläche wird nicht als Schlagfläche verwendet.",
            "Vertragsbeginn, Antragstermin, Projektparameter und Nutzungs-/Monitoring-Einzelbelege fehlen bereits; native Defaults sind keine neuen bestätigten Fakten."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/year → /farm/year:2026; /land/total_area_ha → derselbe Pfad:20 ha Gesamtbetriebsfläche, keine Schlagfläche.",
            "/application/measure = o6_18 → /farm/oepul/measures/0 = 18; /application/nat_code = true → /land/parcels/0/oepul/codes/0 = NAT für das vorhandene einzige Schlagarrayelement.",
            "/land/parcels/0/land_use = grassland bleibt; /land/parcels/0 bekommt ausschließlich technischen Struktur-Identifier luna-parcel-0, keine neue Fläche oder Parzelle.",
            "/land/parcels/0/naturschutz_codes/0/code → /land/parcels/0/naturschutz/project_confirmation/auflagen/0:GA09 bzw.GL06 unverändert.",
            "/land/parcels/0/project_confirmation → /land/parcels/0/naturschutz/project_confirmation/present; der fehlende Fakt bleibt im missing_fact-Fall abwesend."
          ],
          "unmapped_facts": [
            "/application/nature_reference_area = true ist ein Betriebs-Sammelbefund und bestimmt keine schlagbezogene /naturschutz/reference_area_present-Zuordnung; nicht zum einzigen Schlag hinzugeraten.",
            "Schlagfläche fehlt schon bei Luna; 20 ha Gesamtfläche wird nicht als Schlagfläche verwendet.",
            "Vertragsbeginn, Antragstermin, Projektparameter und Nutzungs-/Monitoring-Einzelbelege fehlen bereits; native Defaults sind keine neuen bestätigten Fakten."
          ]
        }
      ],
      "comparison_limit": "Auflagencode-/Projektbestätigungsprobe fachlich gleich übertragen; unbekannte Schlagfläche/Referenzzuordnung und Datierungen begrenzen Gesamt-/Prämienvergleich.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_18.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die unveränderten öffentlichen Luna-Basisfakten im belegbaren nativen Opus-Teilvertrag ausführen; keine unabhängige Sollentscheidung und keine direkte Wiederverwendung eines Opus-Testbetriebs. |
| variation | defined | yes | Den einzelnen Code GA09 durch den im Modelltest belegten Code GL06 ersetzen; beobachten, ob ein zusätzlicher Monitoringnachweis als Verletzung erscheint. Gleiche Auflagencode-/Projektfaktprobe auf dem nativen Teilvertrag. |
| missing_fact | defined | yes | project_confirmation aus dem Schlag entfernen; den fehlenden Projektbestätigungsnachweis mit dem Basisfall vergleichen. Gleiche Auflagencode-/Projektfaktprobe auf dem nativen Teilvertrag. |

**Open dependencies:**

- Unabhängige fachliche Sollurteile und vollständige tatsächliche Belege fehlen; diese Fälle bleiben öffentliche Entwicklungsdiagnosen.
- Unterschiedliche native Vertrags-/Prämienumfänge und günstige Defaults dürfen nicht als fachliche Korrektheit oder Genauigkeitsvergleich ausgegeben werden.
- Auflagencode-/Projektbestätigungsprobe fachlich gleich übertragen; unbekannte Schlagfläche/Referenzzuordnung und Datierungen begrenzen Gesamt-/Prämienvergleich.

**Evidence:**

- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/main.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/main.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/lib.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/lib.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/eligibility.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/policy/o6_18/obligations.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/tests/o6_18_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/tests/o6_18_test.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/data/o6_18/annex_i_auflagen.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/data/o6_18/annex_i_auflagen.json): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/rules/profile_changes.json): Belegte Vorschläge zum nativen Eingabevertrag und Einheiten; keine Veränderung des Canonical Farm Profile.
- [runs/v2-o6_18-opus-5.5-high-20260927/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_18-opus-5.5-high-20260927/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_18-opus-5.5-high-20260927/workspace/notes/assumptions.md): Historische Annahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.

### o6_19

Run: `v2-o6_19-opus-5.5-high-20260927`. [Fixture](fixtures/o6_19.json) · [Native results](results/o6_19.json)

**Inputs:** Nativer Vertrag: farm.year, land mit einzelnen EBW-Parzellen, oepul.o6_19 sowie einzelne Projekt-, Schulungs- und Planbelege. Luna measure liefert das Jahr 2025 und Zugangs- beziehungsweise Prämienaggregate. Die Fläche 1,2 ha und mandatory_indicators_met werden nicht in erfundene Schläge oder Indikatorcodes zerlegt.

**Output meaning:** decision aggregiert Zugangs-/Projekt-/Indikator-/Verpflichtungsbefunde und Prämienrechnung. Hier keine Ausführung wegen nicht übersetzbarer Aggregatproben; fixture_gap ist weder fachliche Ablehnung noch ein Beweis für mehr/weniger Modellqualität.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_19.decision`

**Inventory:** 102 rule catalog entries; 8 sources; 12 static input paths; 94 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"cap": 4, "combination": 3, "crediting": 3, "deadline": 3, "definition": 6, "eligibility": 13, "exception": 9, "exclusion": 7, "information_requirement": 1, "obligation": 11, "option": 4, "premium_calculation": 13, "procedure": 17, "sanction": 7, "scope": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year",
      "input.land.arable_area_ha",
      "input.land.total_area_ha",
      "input.oepul",
      "input.oepul.applicant",
      "input.oepul.applicant.active_farmer",
      "input.oepul.applicant.public_body_share_percent",
      "input.oepul.applicant.type",
      "input.oepul.control_refused",
      "input.oepul.first_oepul_participation_year",
      "input.oepul.force_majeure_recognised",
      "input.oepul.protected_cultivation_area_ha"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_19 | full_document | 44 | {"not_rule": 5, "rules": 39} |
| o6_general | full_document | 37 | {"not_rule": 12, "rules": 25} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 33 | {"not_rule": 5, "rules": 28} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 20 | {"not_rule": 1, "rules": 19} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 6 | {"not_rule": 2, "rules": 4} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 4 | {"not_rule": 1, "rules": 3} |
| duerre_2026_foerderungsabwicklung | full_document | 6 | {"not_rule": 3, "rules": 3} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [],
          "unmapped_facts": [
            "/measure/eligible_area_ha = 1.2:Opus summiert physische förderfähige EBW-Schläge; keine physische Schlagfläche, Nutzungsart oder EBW-Schlagidentität bei Luna vorhanden.",
            "/measure/project_confirmation/parcels/0/mandatory_indicators_met  = true:keine konkreten /land/parcels/0/ebw/indicators-Codes, Bindung oder Erfüllungsbelege; keine leere/willkürliche Indikatorliste erfunden.",
            "/measure/project_confirmation/reference_area_present, regular_care_every_second_year, indicator_observation_database_current sind Sammelfakten; keine schlagbezogenen Referenz-/Pflege-/Beobachtungsereignisse daraus bestimmt.",
            "/measure/training und /regional_nature_conservation_plan sowie /surcharges sind Nachweis-/Bewertungsaggregate ohne erforderliche Datierungen, konkrete Gründe oder zusätzliche Eignungsmerkmale.",
            "/measure/application_year = 2025, start_year = 2025, commitment_years = 4, commitment_end_date = 2028-12-31, contract_end_year = 2028, total_farm_area_ha = 220, arable_area_ha = 10 wären als Kontext übertragbar; kein identischer Area-/Indikatorprobevertrag dadurch vorhanden.",
            "Prämienkatalog-Kennungen und difficulty_index = 1 werden nicht in eine neue naturschutzfachliche Klasse umgedeutet; keine zusätzlichen Prämienfacts zum Erreichen einer definierten Ausgabe."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [],
          "unmapped_facts": [
            "/measure/eligible_area_ha = 0.99:Opus summiert physische förderfähige EBW-Schläge; keine physische Schlagfläche, Nutzungsart oder EBW-Schlagidentität bei Luna vorhanden.",
            "/measure/project_confirmation/parcels/0/mandatory_indicators_met  = true:keine konkreten /land/parcels/0/ebw/indicators-Codes, Bindung oder Erfüllungsbelege; keine leere/willkürliche Indikatorliste erfunden.",
            "/measure/project_confirmation/reference_area_present, regular_care_every_second_year, indicator_observation_database_current sind Sammelfakten; keine schlagbezogenen Referenz-/Pflege-/Beobachtungsereignisse daraus bestimmt.",
            "/measure/training und /regional_nature_conservation_plan sowie /surcharges sind Nachweis-/Bewertungsaggregate ohne erforderliche Datierungen, konkrete Gründe oder zusätzliche Eignungsmerkmale.",
            "/measure/application_year = 2025, start_year = 2025, commitment_years = 4, commitment_end_date = 2028-12-31, contract_end_year = 2028, total_farm_area_ha = 220, arable_area_ha = 10 wären als Kontext übertragbar; kein identischer Area-/Indikatorprobevertrag dadurch vorhanden.",
            "Prämienkatalog-Kennungen und difficulty_index = 1 werden nicht in eine neue naturschutzfachliche Klasse umgedeutet; keine zusätzlichen Prämienfacts zum Erreichen einer definierten Ausgabe."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [],
          "unmapped_facts": [
            "/measure/eligible_area_ha = 1.2:Opus summiert physische förderfähige EBW-Schläge; keine physische Schlagfläche, Nutzungsart oder EBW-Schlagidentität bei Luna vorhanden.",
            "/measure/project_confirmation/parcels/0/mandatory_indicators_met fehlt absichtlich:keine konkreten /land/parcels/0/ebw/indicators-Codes, Bindung oder Erfüllungsbelege; keine leere/willkürliche Indikatorliste erfunden.",
            "/measure/project_confirmation/reference_area_present, regular_care_every_second_year, indicator_observation_database_current sind Sammelfakten; keine schlagbezogenen Referenz-/Pflege-/Beobachtungsereignisse daraus bestimmt.",
            "/measure/training und /regional_nature_conservation_plan sowie /surcharges sind Nachweis-/Bewertungsaggregate ohne erforderliche Datierungen, konkrete Gründe oder zusätzliche Eignungsmerkmale.",
            "/measure/application_year = 2025, start_year = 2025, commitment_years = 4, commitment_end_date = 2028-12-31, contract_end_year = 2028, total_farm_area_ha = 220, arable_area_ha = 10 wären als Kontext übertragbar; kein identischer Area-/Indikatorprobevertrag dadurch vorhanden.",
            "Prämienkatalog-Kennungen und difficulty_index = 1 werden nicht in eine neue naturschutzfachliche Klasse umgedeutet; keine zusätzlichen Prämienfacts zum Erreichen einer definierten Ausgabe."
          ]
        }
      ],
      "comparison_limit": "Luna variiert eligible_area_ha von 1,2 auf 0,99 ha und entfernt mandatory_indicators_met. Opus leitet förderfähige Fläche aus tatsächlich bestimmten EBW-Schlägen und Erfüllung aus konkreten verpflichtenden Indikatoren ab. Luna enthält keine physische Schlagfläche, Nutzungsart, Indikatorcodes oder Bindungsdetails. Eine Parzelle von 1,2 ha oder eine willkürliche Indikatorliste würde neue fachliche Fakten hinzufügen.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_19.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| — | fixture_gap | fixture_gap | No executable cases |

**Fixture gap:** Luna variiert eligible_area_ha von 1,2 auf 0,99 ha und entfernt mandatory_indicators_met. Opus leitet förderfähige Fläche aus tatsächlich bestimmten EBW-Schlägen und Erfüllung aus konkreten verpflichtenden Indikatoren ab. Luna enthält keine physische Schlagfläche, Nutzungsart, Indikatorcodes oder Bindungsdetails. Eine Parzelle von 1,2 ha oder eine willkürliche Indikatorliste würde neue fachliche Fakten hinzufügen.


**Open dependencies:**

- Luna variiert eligible_area_ha von 1,2 auf 0,99 ha und entfernt mandatory_indicators_met. Opus leitet förderfähige Fläche aus tatsächlich bestimmten EBW-Schlägen und Erfüllung aus konkreten verpflichtenden Indikatoren ab. Luna enthält keine physische Schlagfläche, Nutzungsart, Indikatorcodes oder Bindungsdetails. Eine Parzelle von 1,2 ha oder eine willkürliche Indikatorliste würde neue fachliche Fakten hinzufügen.
- Für eigenständige neue Opus-Entwicklungsfälle wären zusätzliche ausdrücklich synthetische Belege separat zu erstellen; sie wären keine Übersetzung der eingefrorenen Luna-Fälle.

**Evidence:**

- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/decision.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/common.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/parcel.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/parcel.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/participation.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/policy/o6_19/participation.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/tests/fixtures_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/tests/fixtures_test.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/data/oepul_o6_19/indicators.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/data/oepul_o6_19/indicators.json): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/rules/profile_changes.json): Belegte Vorschläge zum nativen Eingabevertrag und Einheiten; keine Veränderung des Canonical Farm Profile.
- [runs/v2-o6_19-opus-5.5-high-20260927/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_19-opus-5.5-high-20260927/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_19-opus-5.5-high-20260927/workspace/notes/assumptions.md): Historische Annahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.

### o6_20

Run: `v2-o6_20-opus-5.5-high-20260928`. [Fixture](fixtures/o6_20.json) · [Native results](results/o6_20.json)

**Inputs:** Native Teilübersetzung unter oepul_measures.tierwohl_weide.categories: dieselbe Rinder- und Schafkategorie, 1,2 beziehungsweise 0,9 durchschnittliche RGVE, 120 beziehungsweise 150 Weidetage sowie Infrastruktur- und Grundfutterflags. farm.year = 2026 bleibt unverändert; category_code wird anhand der vorhandenen Opus-Liste umcodiert. Keine Tiere, Geburts-, Antrags- oder Zuschlagsdaten sowie Tagebuch-Einzelbelege werden ergänzt.

**Output meaning:** Native result bündelt contract_valid, Prämienzusammenfassung, violations, review_items und missing_inputs. Nicht übersetzte Zeit-/Tagebuchbelege bleiben fehlend und können den Vertrag unabhängig von den Primärproben sperren. Fehlendes water_access hat einen günstigen nativen Default; dies ist keine bestätigte Tränkenversorgung.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_20.decision.result`

**Inventory:** 97 rule catalog entries; 8 sources; 1 static input paths; 6 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"calculation": 15, "combination": 2, "consequence": 8, "deadline": 5, "definition": 5, "eligibility": 8, "exception": 11, "exclusion": 1, "interpretation": 4, "legal_obligation": 1, "obligation": 13, "option": 4, "procedure": 11, "reporting_obligation": 4, "sanction": 3, "table": 2}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_20 | full_document | 78 | {"not_rule": 5, "rules": 73} |
| o6_general | full_document | 48 | {"not_rule": 22, "rules": 26} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 54 | {"not_rule": 21, "rules": 33} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 6 | {"not_rule": 3, "rules": 3} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 11 | {"not_rule": 9, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 5 | {"not_rule": 5} |
| duerre_2026_oepul_ausgleichszulage | full_document | 6 | {"not_rule": 6} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 8} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/year → /farm/year:2026 unverändert; /context/drought_2026 → /oepul_measures/tierwohl_weide/drought_affected_2026:false.",
            "/farm/livestock/o6_20/0,1/category → /oepul_measures/tierwohl_weide/categories/0,1/category_code:cattle_female_2y_plus bzw.sheep_female_1y_plus nach nativer Kategorientabelle.",
            "/farm/livestock/o6_20/0,1/average_rgve → /oepul_measures/tierwohl_weide/categories/0,1/average_rgve:1.2/.9; direkte Eingabe ist durch rgve.rego unterstützt, keine Tiere erzeugt.",
            "/farm/livestock/o6_20/0,1/optional_150_days → /oepul_measures/tierwohl_weide/categories/0,1/supplement_150_applied:false/true.",
            "/farm/livestock/o6_20/0,1/weide_days mit all_category_animals_participate = true → /oepul_measures/tierwohl_weide/categories/0,1/grazing_days_all_animals:120 beziehungsweise 119 für Rinder und 150 für Schafe; kein Anwesenheitstag oder Datum ergänzt.",
            "/farm/livestock/o6_20/0,1/groundfeed_predominantly_grazing, grazing_substantial_part_of_day, shelter_access → native forage_mainly_from_grazing, grazing_substantial_part_of_day, shelter_or_rapid_stall_access:true.",
            "/farm/livestock/o6_20/0,1/water_access → /oepul_measures/tierwohl_weide/categories/0,1/water_access; Rinderfeld bleibt im missing_fact-Fall fehlend."
          ],
          "unmapped_facts": [
            "/o6_20_application/measure_requested und /application_date_before_31_december sowie participating:true bestimmen keine exakten Maßnahmen-/Kategorien-/Zuschlags-Antragsdaten.",
            "/farm/livestock/o6_20/0,1/animal_count2 beziehungsweise 6, animals_held_in_austria, weide_period_valid und vis_reporting_complete sind Aggregate ohne Einzeltiere/Präsenz-/Meldeereignisse; keine Erfindung einer native Ereigniszeitleiste.",
            "/farm/livestock/o6_20/0,1/weide_diary_complete = true bestimmt nicht die sechs einzelnen nativen grazing_diary-Belege.",
            "/context/control_note_acknowledged = true hat kein gleichbedeutendes natives Wahrheitsfeld; keine zusätzliche Ausnahme-/Anerkennungsentscheidung."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/year → /farm/year:2026 unverändert; /context/drought_2026 → /oepul_measures/tierwohl_weide/drought_affected_2026:false.",
            "/farm/livestock/o6_20/0,1/category → /oepul_measures/tierwohl_weide/categories/0,1/category_code:cattle_female_2y_plus bzw.sheep_female_1y_plus nach nativer Kategorientabelle.",
            "/farm/livestock/o6_20/0,1/average_rgve → /oepul_measures/tierwohl_weide/categories/0,1/average_rgve:1.2/.9; direkte Eingabe ist durch rgve.rego unterstützt, keine Tiere erzeugt.",
            "/farm/livestock/o6_20/0,1/optional_150_days → /oepul_measures/tierwohl_weide/categories/0,1/supplement_150_applied:false/true.",
            "/farm/livestock/o6_20/0,1/weide_days mit all_category_animals_participate = true → /oepul_measures/tierwohl_weide/categories/0,1/grazing_days_all_animals:120 beziehungsweise 119 für Rinder und 150 für Schafe; kein Anwesenheitstag oder Datum ergänzt.",
            "/farm/livestock/o6_20/0,1/groundfeed_predominantly_grazing, grazing_substantial_part_of_day, shelter_access → native forage_mainly_from_grazing, grazing_substantial_part_of_day, shelter_or_rapid_stall_access:true.",
            "/farm/livestock/o6_20/0,1/water_access → /oepul_measures/tierwohl_weide/categories/0,1/water_access; Rinderfeld bleibt im missing_fact-Fall fehlend."
          ],
          "unmapped_facts": [
            "/o6_20_application/measure_requested und /application_date_before_31_december sowie participating:true bestimmen keine exakten Maßnahmen-/Kategorien-/Zuschlags-Antragsdaten.",
            "/farm/livestock/o6_20/0,1/animal_count2 beziehungsweise 6, animals_held_in_austria, weide_period_valid und vis_reporting_complete sind Aggregate ohne Einzeltiere/Präsenz-/Meldeereignisse; keine Erfindung einer native Ereigniszeitleiste.",
            "/farm/livestock/o6_20/0,1/weide_diary_complete = true bestimmt nicht die sechs einzelnen nativen grazing_diary-Belege.",
            "/context/control_note_acknowledged = true hat kein gleichbedeutendes natives Wahrheitsfeld; keine zusätzliche Ausnahme-/Anerkennungsentscheidung."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/year → /farm/year:2026 unverändert; /context/drought_2026 → /oepul_measures/tierwohl_weide/drought_affected_2026:false.",
            "/farm/livestock/o6_20/0,1/category → /oepul_measures/tierwohl_weide/categories/0,1/category_code:cattle_female_2y_plus bzw.sheep_female_1y_plus nach nativer Kategorientabelle.",
            "/farm/livestock/o6_20/0,1/average_rgve → /oepul_measures/tierwohl_weide/categories/0,1/average_rgve:1.2/.9; direkte Eingabe ist durch rgve.rego unterstützt, keine Tiere erzeugt.",
            "/farm/livestock/o6_20/0,1/optional_150_days → /oepul_measures/tierwohl_weide/categories/0,1/supplement_150_applied:false/true.",
            "/farm/livestock/o6_20/0,1/weide_days mit all_category_animals_participate = true → /oepul_measures/tierwohl_weide/categories/0,1/grazing_days_all_animals:120 beziehungsweise 119 für Rinder und 150 für Schafe; kein Anwesenheitstag oder Datum ergänzt.",
            "/farm/livestock/o6_20/0,1/groundfeed_predominantly_grazing, grazing_substantial_part_of_day, shelter_access → native forage_mainly_from_grazing, grazing_substantial_part_of_day, shelter_or_rapid_stall_access:true.",
            "/farm/livestock/o6_20/0,1/water_access → /oepul_measures/tierwohl_weide/categories/0,1/water_access; Rinderfeld bleibt im missing_fact-Fall fehlend."
          ],
          "unmapped_facts": [
            "/o6_20_application/measure_requested und /application_date_before_31_december sowie participating:true bestimmen keine exakten Maßnahmen-/Kategorien-/Zuschlags-Antragsdaten.",
            "/farm/livestock/o6_20/0,1/animal_count2 beziehungsweise 6, animals_held_in_austria, weide_period_valid und vis_reporting_complete sind Aggregate ohne Einzeltiere/Präsenz-/Meldeereignisse; keine Erfindung einer native Ereigniszeitleiste.",
            "/farm/livestock/o6_20/0,1/weide_diary_complete = true bestimmt nicht die sechs einzelnen nativen grazing_diary-Belege.",
            "/context/control_note_acknowledged = true hat kein gleichbedeutendes natives Wahrheitsfeld; keine zusätzliche Ausnahme-/Anerkennungsentscheidung."
          ]
        }
      ],
      "comparison_limit": "Tages- und Tränkenproben sind identisch übertragen; exakte Datierungen, Anwesenheits-/Melde-/Tagebuchbelege fehlen und dürfen Unterschiede von Gesamtvertrag/Prämie nicht als Modellqualität erscheinen lassen.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_20.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die unveränderten öffentlichen Luna-Basisfakten im belegbaren nativen Opus-Teilvertrag ausführen; keine unabhängige Sollentscheidung und keine direkte Wiederverwendung eines Opus-Testbetriebs. |
| variation | defined | yes | Einzige Änderung: Weidetage der Rinderkategorie von 120 auf 119 Tage; Reaktion an der im Kandidaten konsumierten Schwelle beobachten. Gleiche Tages-/Tränkenprobe im nativen Kategorienvertrag. |
| missing_fact | defined | no | Einzige Auslassung: water_access der Rinderkategorie; prüfen, ob fehlende Evidenz von einer tatsächlich fehlenden Tränke unterschieden wird. Gleiche Tages-/Tränkenprobe im nativen Kategorienvertrag. |

**Open dependencies:**

- Unabhängige fachliche Sollurteile und vollständige tatsächliche Belege fehlen; diese Fälle bleiben öffentliche Entwicklungsdiagnosen.
- Unterschiedliche native Vertrags-/Prämienumfänge und günstige Defaults dürfen nicht als fachliche Korrektheit oder Genauigkeitsvergleich ausgegeben werden.
- Tages- und Tränkenproben sind identisch übertragen; exakte Datierungen, Anwesenheits-/Melde-/Tagebuchbelege fehlen und dürfen Unterschiede von Gesamtvertrag/Prämie nicht als Modellqualität erscheinen lassen.

**Evidence:**

- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/decision.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/common.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/rgve.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/rgve.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/obligations.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/application.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/policy/o6_20/application.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/tests/o6_20/decision_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/tests/o6_20/decision_test.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/data/o6_20/categories.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/data/o6_20/categories.json): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder Modelltest; keine neue normative Regel.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/rules/profile_changes.json): Belegte Vorschläge zum nativen Eingabevertrag und Einheiten; keine Veränderung des Canonical Farm Profile.
- [runs/v2-o6_20-opus-5.5-high-20260928/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_20-opus-5.5-high-20260928/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_20-opus-5.5-high-20260928/workspace/notes/assumptions.md): Historische Annahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.

### o6_21

Run: `v2-o6_21-opus-5.5-high-20261004`. [Fixture](fixtures/o6_21.json) · [Native results](results/o6_21.json)

**Inputs:** Nativer Vertrag: farm.year, oepul_measures.o6_21, livestock.cattle_animals[] mit Ohrmarke, Geburts- und Anwesenheitsdaten sowie livestock.stall_compartments[] mit Fläche in m² und einzelnen Gebäudemerkmalen. Luna liefert stattdessen farm.o6_21, 5 RGVE, 501 kg, 4,2 m² je Tier und boolesche Sammelnachweise. Kein zusätzlicher Tierbestand, Stall oder Gebäudebeleg wird ergänzt.

**Output meaning:** main.decision enthält Zugangsurteil, Kategorien-/RGVE-Aggregate, Abteilverletzungen und Prämienzusammenfassung; eligible aggregiert access_issues und ist keine automatische Bestätigung aller allgemeinen Pflichten. Hier keine Ausführung: fixture_gap dokumentiert den nicht abbildbaren Eingabevertrag und ist weder fachliche Ablehnung noch Genauigkeitsbefund.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_21.main.decision`

**Inventory:** 95 rule catalog entries; 11 sources; 1 static input paths; 9 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 2, "calculation": 6, "calculation_input": 1, "combination": 1, "condition": 1, "consequence": 7, "contract_period": 1, "deadline": 5, "definition": 4, "documentation": 5, "eligibility": 4, "exception": 6, "exclusion": 6, "obligation": 12, "option": 5, "premium_rate": 3, "procedure": 5, "renewal": 1, "reporting": 4, "restriction": 4, "sanction": 4, "threshold": 8}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_21 | full_document | 55 | {"not_rule": 3, "rules": 52} |
| o6_general | full_document | 32 | {"not_rule": 16, "rules": 16} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 39 | {"not_rule": 11, "rules": 27, "unresolved": 1} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 7 | {"not_rule": 5, "rules": 2} |
| gsp_anwendungsverordnung | targeted_sections | 22 | {"not_rule": 4, "rules": 18} |
| napv | targeted_sections | 5 | {"not_rule": 2, "rules": 2, "unresolved": 1} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 2 | {"not_rule": 1, "rules": 1} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 3 | {"not_rule": 3} |
| duerre_2026_foerderungsabwicklung | full_document | 1 | {"not_rule": 1} |
| meldepflichten_2026_tierbezogene_massnahmen | full_document | 7 | {"not_rule": 5, "rules": 2} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [],
          "unmapped_facts": [
            "/farm/o6_21/year = 2026 wäre als /farm/year kopierbar, aber allein kein ausführbarer identischer Tier-/Stallfall.",
            "/farm/o6_21/average_fundable_rgve und /fundable_rgve_total = 5:Opus berechnet Jahres-RGVE aus /livestock/cattle_animals mit Geburt/Anwesenheit/Kategorie; keine Tierdaten zur Herleitung vorhanden.",
            "/farm/o6_21/animals/0/animal_id = r1 und /weight_kg = 501 bestimmen kein vollständiges Einzeltierschema mit Ohrmarke, Geburtsdatum, Sex, Anwesenheit und Abteil.",
            "/farm/o6_21/stall/total_area_m2_per_animal = 4.2 und /lying_area_m2_per_animal = 1.68:Opus benötigt Gesamtflächen und vollständige Abteilbelegung; kein Multiplikator oder zusätzlicher Tierbestand wird erfunden.",
            "/farm/o6_21/stall/structural_requirements_met  = true:keine Umkehrung in die einzeln erforderlichen Gebäudemerkmale von /livestock/stall_compartments/0/building.",
            "Weitere Luna-Sammelfakten zu Kategorien, Antragsfrist, Programmen, Haltungszeiträumen, Belegung und Einstreu ergeben keine exakten datierten Opus-Anträge/Programme oder vollständigen Stallabteilvertrag."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [],
          "unmapped_facts": [
            "/farm/o6_21/year = 2026 wäre als /farm/year kopierbar, aber allein kein ausführbarer identischer Tier-/Stallfall.",
            "/farm/o6_21/average_fundable_rgve und /fundable_rgve_total = 5:Opus berechnet Jahres-RGVE aus /livestock/cattle_animals mit Geburt/Anwesenheit/Kategorie; keine Tierdaten zur Herleitung vorhanden.",
            "/farm/o6_21/animals/0/animal_id = r1 und /weight_kg = 501 bestimmen kein vollständiges Einzeltierschema mit Ohrmarke, Geburtsdatum, Sex, Anwesenheit und Abteil.",
            "/farm/o6_21/stall/total_area_m2_per_animal = 4.19 und /lying_area_m2_per_animal = 1.68:Opus benötigt Gesamtflächen und vollständige Abteilbelegung; kein Multiplikator oder zusätzlicher Tierbestand wird erfunden.",
            "/farm/o6_21/stall/structural_requirements_met  = true:keine Umkehrung in die einzeln erforderlichen Gebäudemerkmale von /livestock/stall_compartments/0/building.",
            "Weitere Luna-Sammelfakten zu Kategorien, Antragsfrist, Programmen, Haltungszeiträumen, Belegung und Einstreu ergeben keine exakten datierten Opus-Anträge/Programme oder vollständigen Stallabteilvertrag."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [],
          "unmapped_facts": [
            "/farm/o6_21/year = 2026 wäre als /farm/year kopierbar, aber allein kein ausführbarer identischer Tier-/Stallfall.",
            "/farm/o6_21/average_fundable_rgve und /fundable_rgve_total = 5:Opus berechnet Jahres-RGVE aus /livestock/cattle_animals mit Geburt/Anwesenheit/Kategorie; keine Tierdaten zur Herleitung vorhanden.",
            "/farm/o6_21/animals/0/animal_id = r1 und /weight_kg = 501 bestimmen kein vollständiges Einzeltierschema mit Ohrmarke, Geburtsdatum, Sex, Anwesenheit und Abteil.",
            "/farm/o6_21/stall/total_area_m2_per_animal = 4.2 und /lying_area_m2_per_animal = 1.68:Opus benötigt Gesamtflächen und vollständige Abteilbelegung; kein Multiplikator oder zusätzlicher Tierbestand wird erfunden.",
            "/farm/o6_21/stall/structural_requirements_met fehlt absichtlich:keine Umkehrung in die einzeln erforderlichen Gebäudemerkmale von /livestock/stall_compartments/0/building.",
            "Weitere Luna-Sammelfakten zu Kategorien, Antragsfrist, Programmen, Haltungszeiträumen, Belegung und Einstreu ergeben keine exakten datierten Opus-Anträge/Programme oder vollständigen Stallabteilvertrag."
          ]
        }
      ],
      "comparison_limit": "Die Luna-Basis enthält RGVE-Aggregate, einen Tierbeispielfakt mit 501 kg, Flächen je Tier und zusammengefasste Stallnachweise. Opus benötigt taggenaue Einzeltiere und Stallabteile. Ohne ergänzte Geburts- und Anwesenheitsdaten, vollständige Abteilbelegung und Gebäudemerkmale sind weder dieselbe RGVE-Basis noch die Probe 4,20 → 4,19 m² je Tier oder die Auslassung structural_requirements_met sinnvoll ausführbar.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_21.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| — | fixture_gap | fixture_gap | No executable cases |

**Fixture gap:** Die Luna-Basis enthält RGVE-Aggregate, einen Tierbeispielfakt mit 501 kg, Flächen je Tier und zusammengefasste Stallnachweise. Opus benötigt taggenaue Einzeltiere und Stallabteile. Ohne ergänzte Geburts- und Anwesenheitsdaten, vollständige Abteilbelegung und Gebäudemerkmale sind weder dieselbe RGVE-Basis noch die Probe 4,20 → 4,19 m² je Tier oder die Auslassung structural_requirements_met sinnvoll ausführbar.


**Open dependencies:**

- Die Luna-Basis enthält RGVE-Aggregate, einen Tierbeispielfakt mit 501 kg, Flächen je Tier und zusammengefasste Stallnachweise. Opus benötigt taggenaue Einzeltiere und Stallabteile. Ohne ergänzte Geburts- und Anwesenheitsdaten, vollständige Abteilbelegung und Gebäudemerkmale sind weder dieselbe RGVE-Basis noch die Probe 4,20 → 4,19 m² je Tier oder die Auslassung structural_requirements_met sinnvoll ausführbar.
- Für eine spätere eigenständige Opus-Entwicklungsprobe können neue ausdrücklich synthetische Fälle erstellt werden; sie wären dann keine Übersetzung dieser Luna-Fälle.

**Evidence:**

- [runs/v2-o6_21-opus-5.5-high-20261004/workspace/policy/o6_21/main.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/workspace/policy/o6_21/main.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_21-opus-5.5-high-20261004/workspace/policy/o6_21/lib.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/workspace/policy/o6_21/lib.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_21-opus-5.5-high-20261004/workspace/policy/o6_21/housing.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/workspace/policy/o6_21/housing.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_21-opus-5.5-high-20261004/workspace/tests/o6_21/fixtures.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/workspace/tests/o6_21/fixtures.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_21-opus-5.5-high-20261004/workspace/data/o6_21/housing.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/workspace/data/o6_21/housing.json): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_21-opus-5.5-high-20261004/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/workspace/rules/profile_changes.json): Vorgeschlagene native Felder und Eingabeeinheiten; das Canonical Farm Profile bleibt unverändert.
- [runs/v2-o6_21-opus-5.5-high-20261004/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_21-opus-5.5-high-20261004/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_21-opus-5.5-high-20261004/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.

### o6_22

Run: `v2-o6_22-opus-5.5-high-20261004`. [Fixture](fixtures/o6_22.json) · [Native results](results/o6_22.json)

**Inputs:** Nativer Vertrag: farm.year, farm.oepul_measures.o6_22.applications[] und livestock.species_groups[] mit Tierlistenkategorie und Stückzahl beziehungsweise Durchschnittsbestand. GVE werden daraus berechnet. Lunas participation_gve bleibt ein vorgegebenes Aggregat ohne Zerlegung. Das bei Luna fehlende Förderjahr bleibt fehlend.

**Output meaning:** decision enthält min_participation_met, participating_gve, compliant, violations und Prämienrechnung. Der native Gesamtausschnitt unterscheidet sich von Lunas reinem Scope-/2-GVE-Boolean. Hier keine Ausführung wegen nicht abbildbarer Aggregate/fehlendem Jahr; fixture_gap ist keine negative fachliche Entscheidung.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_22.decision`

**Inventory:** 125 rule catalog entries; 11 sources; 1 static input paths; 17 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 1, "calculation_basis": 1, "calculation_rule": 8, "category_assignment": 3, "category_definition": 1, "clarification": 1, "combination": 1, "commitment_period": 1, "consequence": 5, "contract_clause": 1, "contract_extension": 1, "contract_lapse": 2, "control": 2, "conversion_factor": 1, "cross_compliance": 2, "data_requirement": 1, "deadline": 4, "definition": 6, "documentation": 7, "eligibility": 4, "eligibility_period": 1, "eligible_animals": 1, "exception": 5, "exclusion": 3, "force_majeure": 1, "measurement_rule": 1, "obligation": 14, "option": 5, "payment": 1, "premium_rate": 1, "procedure": 4, "prohibition": 1, "repayment": 1, "reporting": 6, "sanction": 4, "surcharge_condition": 8, "temporal_scope": 2, "threshold": 9, "transitional": 3, "validation": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_22 | full_document | 44 | {"not_rule": 3, "rules": 41} |
| o6_general | full_document | 28 | {"not_rule": 12, "rules": 16} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 3 | {"not_rule": 2, "rules": 1} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 2 | {"not_rule": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 6 | {"not_rule": 6} |
| meldepflichten_2026_tierbezogene_massnahmen | full_document | 7 | {"not_rule": 4, "rules": 3} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 24 | {"not_rule": 5, "rules": 19} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 3 | {"not_rule": 1, "rules": 2} |
| gsp_anwendungsverordnung | targeted_sections | 18 | {"not_rule": 3, "rules": 15} |
| napv | targeted_sections | 3 | {"not_rule": 1, "rules": 2} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [],
          "unmapped_facts": [
            "/livestock/o6_22/measure = o6_22:Maßnahmenmarker ist kein Opus-Antragscode oder aktiv beantragte Tierkategorie.",
            "/livestock/o6_22/participation_gve = 2:kein nativer Eingabeaggregate-Pfad; /participating_gve wird aus Tierlistenkategorie, Stück-/Durchschnittsbestand, Abmeldungen und aktiven Anträgen berechnet.",
            "/farm/year fehlt bereits im Luna-Fall und wird nicht ergänzt; kein synthetisches2026 oder ein anderes Förderjahr.",
            "Tierliste, Bestandsbasis, Schweinegruppen, Haltungsfakten und Antragstermine fehlen in allen drei Luna-Fällen; keine Aufteilung der2GVE in erfundene Tiere."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [],
          "unmapped_facts": [
            "/livestock/o6_22/measure = o6_22:Maßnahmenmarker ist kein Opus-Antragscode oder aktiv beantragte Tierkategorie.",
            "/livestock/o6_22/participation_gve = 1.99:kein nativer Eingabeaggregate-Pfad; /participating_gve wird aus Tierlistenkategorie, Stück-/Durchschnittsbestand, Abmeldungen und aktiven Anträgen berechnet.",
            "/farm/year fehlt bereits im Luna-Fall und wird nicht ergänzt; kein synthetisches2026 oder ein anderes Förderjahr.",
            "Tierliste, Bestandsbasis, Schweinegruppen, Haltungsfakten und Antragstermine fehlen in allen drei Luna-Fällen; keine Aufteilung der2GVE in erfundene Tiere."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [],
          "unmapped_facts": [
            "/livestock/o6_22/measure = o6_22:Maßnahmenmarker ist kein Opus-Antragscode oder aktiv beantragte Tierkategorie.",
            "/livestock/o6_22/participation_gve = absichtlich fehlend:kein nativer Eingabeaggregate-Pfad; /participating_gve wird aus Tierlistenkategorie, Stück-/Durchschnittsbestand, Abmeldungen und aktiven Anträgen berechnet.",
            "/farm/year fehlt bereits im Luna-Fall und wird nicht ergänzt; kein synthetisches2026 oder ein anderes Förderjahr.",
            "Tierliste, Bestandsbasis, Schweinegruppen, Haltungsfakten und Antragstermine fehlen in allen drei Luna-Fällen; keine Aufteilung der2GVE in erfundene Tiere."
          ]
        }
      ],
      "comparison_limit": "Luna liefert nur die Maßnahmenkennung und participation_gve = 2 beziehungsweise 1,99, jedoch kein Förderjahr, keine Tierlistenkategorien, Tierzahlen oder datierten Anträge. Opus berechnet participating_gve aus beantragten Kategorien und Schweinegruppen; es gibt keinen Eingabepfad für dieses Aggregat. Drei native Entscheidungen wären nur mit zusätzlichen unbelegten Fakten möglich.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_22.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| — | fixture_gap | fixture_gap | No executable cases |

**Fixture gap:** Luna liefert nur die Maßnahmenkennung und participation_gve = 2 beziehungsweise 1,99, jedoch kein Förderjahr, keine Tierlistenkategorien, Tierzahlen oder datierten Anträge. Opus berechnet participating_gve aus beantragten Kategorien und Schweinegruppen; es gibt keinen Eingabepfad für dieses Aggregat. Drei native Entscheidungen wären nur mit zusätzlichen unbelegten Fakten möglich.


**Open dependencies:**

- Luna liefert nur die Maßnahmenkennung und participation_gve = 2 beziehungsweise 1,99, jedoch kein Förderjahr, keine Tierlistenkategorien, Tierzahlen oder datierten Anträge. Opus berechnet participating_gve aus beantragten Kategorien und Schweinegruppen; es gibt keinen Eingabepfad für dieses Aggregat. Drei native Entscheidungen wären nur mit zusätzlichen unbelegten Fakten möglich.
- Für eine spätere eigenständige Opus-Entwicklungsprobe können neue ausdrücklich synthetische Fälle erstellt werden; sie wären dann keine Übersetzung dieser Luna-Fälle.

**Evidence:**

- [runs/v2-o6_22-opus-5.5-high-20261004/workspace/policy/o6_22/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/workspace/policy/o6_22/decision.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_22-opus-5.5-high-20261004/workspace/policy/o6_22/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/workspace/policy/o6_22/common.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_22-opus-5.5-high-20261004/workspace/policy/o6_22/participation.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/workspace/policy/o6_22/participation.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_22-opus-5.5-high-20261004/workspace/tests/o6_22/fixtures_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/workspace/tests/o6_22/fixtures_test.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_22-opus-5.5-high-20261004/workspace/data/o6_22/categories.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/workspace/data/o6_22/categories.json): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_22-opus-5.5-high-20261004/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/workspace/rules/profile_changes.json): Vorgeschlagene native Felder und Eingabeeinheiten; das Canonical Farm Profile bleibt unverändert.
- [runs/v2-o6_22-opus-5.5-high-20261004/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_22-opus-5.5-high-20261004/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_22-opus-5.5-high-20261004/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.

### o6_23

Run: `v2-o6_23-opus-5.5-high-20260928`. [Fixture](fixtures/o6_23.json) · [Native results](results/o6_23.json)

**Inputs:** Teilübersetzung der unveränderten Luna-Fakten: farm.year = 2026 und land.total_area_ha = 100 bleiben gleich. Der vorhandene Schlag P1, 2 ha, grassland, AT, N2, N2GI05 und die Projektbestätigung werden in constraints.natura2000 beziehungsweise eligibility eingeordnet. Mineralische und organische N-Gaben in kg N/ha sowie cutting_dates bleiben auf den nativen operations-Pfaden. Kein Grünland-Untertyp, Vertragsbeginn, Mähgutabtransport oder Beweidungsereignis wird ergänzt.

**Output meaning:** decision enthält contract_valid, farm_failures, schlagbezogene Zugangs-/Auflagenbefunde und Prämienarithmetik. Nicht übersetzbare Eingaben bleiben unbekannt; daraus resultierende Zugangsdefizite sind Vertragsunterschiede und kein Beweis für Modellqualität. Die direkte N-Mengenvariation kann unabhängig davon als Auflagenbefund sichtbar werden. Günstige native Defaults und fehlende Verletzungen ersetzen keine vollständige Datenprüfung.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_23.decision`

**Inventory:** 88 rule catalog entries; 8 sources; 1 static input paths; 9 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 4, "calculation_order": 1, "cap": 1, "classification": 1, "closed_list": 3, "combination": 4, "contract": 6, "crediting": 1, "deadline": 5, "definition": 3, "eligibility": 7, "exception": 13, "financing": 1, "information": 1, "interpretation": 1, "legal_basis": 2, "limit": 1, "modulation": 1, "obligation": 9, "payment": 4, "premium_calculation": 1, "premium_rate_table": 1, "procedure": 11, "sanction": 6}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.farm.year"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_23 | full_document | 21 | {"not_rule": 3, "rules": 18} |
| o6_general | full_document | 43 | {"not_rule": 19, "rules": 24} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 47 | {"not_rule": 12, "rules": 34, "unresolved": 1} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 10 | {"not_rule": 2, "rules": 8} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 5 | {"not_rule": 3, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 2 | {"not_rule": 2} |
| duerre_2026_oepul_ausgleichszulage | full_document | 4 | {"not_rule": 3, "rules": 1} |
| duerre_2026_foerderungsabwicklung | full_document | 8 | {"not_rule": 6, "rules": 2} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [
            "/farm/year → /farm/year:2026 unverändert; /land/total_area_ha → /land/total_area_ha:100ha unverändert.",
            "/land/parcels/0/parcel_id, area_ha, land_use → dieselben nativen Pfade:P1,2 ha, grassland.",
            "/land/parcels/0/country = AT → /land/parcels/0/eligibility/located_in_austria = true; nur vorhandene Länderangabe umcodiert.",
            "/land/parcels/0/is_natura2000_or_high_nature_value und /project_confirmation → /constraints/natura2000/in_natura2000_or_high_nature_value_area und /project_confirmation_present ohne Wertänderung.",
            "/land/parcels/0/application_code = N2 → /constraints/natura2000/n2_code_marked = true; /n2_code = N2GI05 → /project_confirmation_codes/0 = N2GI05, durch native Tabelle belegt.",
            "/land/parcels/0/operations/cutting_dates und /operations/fertilizer → dieselben nativen Pfade; die fehlende mineral_n_kg_per_ha bleibt im Auslassungsfall abwesend.",
            "/measure/o6_23/application_date → /farm/oepul/o6_23/measure_application_date:2025-12-31 unverändert, kein Vertragsbeginn daraus abgeleitet."
          ],
          "unmapped_facts": [
            "/land/parcels/0/annual_full_area_mown_or_grazed = true:Opus verlangt konkrete Schnitttermine+Mähgutabtransport oder full_area_grazed; der Sammelfakt entscheidet nicht, welche Alternative vorliegt.",
            "/measure/o6_23/requested, contract_years, other_measures:keine eindeutige Umcodierung in datierten Vertragsbeginn oder schlagbezogene Kombinationsbelegung; requested = true/1Jahr ist kein Nachweis von contract_start_year.",
            "Grünland-Untertyp und konkrete Nutzungshäufigkeit fehlen bereits bei Luna; N2GI05 ist eine Auflage und ergänzt keinen unabhängigen Tatsachennachweis zur tatsächlichen Nutzungsart."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [
            "/farm/year → /farm/year:2026 unverändert; /land/total_area_ha → /land/total_area_ha:100ha unverändert.",
            "/land/parcels/0/parcel_id, area_ha, land_use → dieselben nativen Pfade:P1,2 ha, grassland.",
            "/land/parcels/0/country = AT → /land/parcels/0/eligibility/located_in_austria = true; nur vorhandene Länderangabe umcodiert.",
            "/land/parcels/0/is_natura2000_or_high_nature_value und /project_confirmation → /constraints/natura2000/in_natura2000_or_high_nature_value_area und /project_confirmation_present ohne Wertänderung.",
            "/land/parcels/0/application_code = N2 → /constraints/natura2000/n2_code_marked = true; /n2_code = N2GI05 → /project_confirmation_codes/0 = N2GI05, durch native Tabelle belegt.",
            "/land/parcels/0/operations/cutting_dates und /operations/fertilizer → dieselben nativen Pfade; die fehlende mineral_n_kg_per_ha bleibt im Auslassungsfall abwesend.",
            "/measure/o6_23/application_date → /farm/oepul/o6_23/measure_application_date:2025-12-31 unverändert, kein Vertragsbeginn daraus abgeleitet."
          ],
          "unmapped_facts": [
            "/land/parcels/0/annual_full_area_mown_or_grazed = true:Opus verlangt konkrete Schnitttermine+Mähgutabtransport oder full_area_grazed; der Sammelfakt entscheidet nicht, welche Alternative vorliegt.",
            "/measure/o6_23/requested, contract_years, other_measures:keine eindeutige Umcodierung in datierten Vertragsbeginn oder schlagbezogene Kombinationsbelegung; requested = true/1Jahr ist kein Nachweis von contract_start_year.",
            "Grünland-Untertyp und konkrete Nutzungshäufigkeit fehlen bereits bei Luna; N2GI05 ist eine Auflage und ergänzt keinen unabhängigen Tatsachennachweis zur tatsächlichen Nutzungsart."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [
            "/farm/year → /farm/year:2026 unverändert; /land/total_area_ha → /land/total_area_ha:100ha unverändert.",
            "/land/parcels/0/parcel_id, area_ha, land_use → dieselben nativen Pfade:P1,2 ha, grassland.",
            "/land/parcels/0/country = AT → /land/parcels/0/eligibility/located_in_austria = true; nur vorhandene Länderangabe umcodiert.",
            "/land/parcels/0/is_natura2000_or_high_nature_value und /project_confirmation → /constraints/natura2000/in_natura2000_or_high_nature_value_area und /project_confirmation_present ohne Wertänderung.",
            "/land/parcels/0/application_code = N2 → /constraints/natura2000/n2_code_marked = true; /n2_code = N2GI05 → /project_confirmation_codes/0 = N2GI05, durch native Tabelle belegt.",
            "/land/parcels/0/operations/cutting_dates und /operations/fertilizer → dieselben nativen Pfade; die fehlende mineral_n_kg_per_ha bleibt im Auslassungsfall abwesend.",
            "/measure/o6_23/application_date → /farm/oepul/o6_23/measure_application_date:2025-12-31 unverändert, kein Vertragsbeginn daraus abgeleitet."
          ],
          "unmapped_facts": [
            "/land/parcels/0/annual_full_area_mown_or_grazed = true:Opus verlangt konkrete Schnitttermine+Mähgutabtransport oder full_area_grazed; der Sammelfakt entscheidet nicht, welche Alternative vorliegt.",
            "/measure/o6_23/requested, contract_years, other_measures:keine eindeutige Umcodierung in datierten Vertragsbeginn oder schlagbezogene Kombinationsbelegung; requested = true/1Jahr ist kein Nachweis von contract_start_year.",
            "Grünland-Untertyp und konkrete Nutzungshäufigkeit fehlen bereits bei Luna; N2GI05 ist eine Auflage und ergänzt keinen unabhängigen Tatsachennachweis zur tatsächlichen Nutzungsart."
          ]
        }
      ],
      "comparison_limit": "Nur direkt übersetzte N-Gaben und vorhandene Schlag-/Projektmarker sind zwischen den drei Entwicklungsproben vergleichbar. Fehlende Grünland-/Vertrags-/Bewirtschaftungsdetails verhindern ein gemeinsames Soll-/Gesamturteil; keine neue fachliche Faktenergänzung.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_23.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| baseline | defined | Baseline | Die unveränderten öffentlichen Luna-Basisfakten im belegbaren nativen Opus-Teilvertrag ausführen; keine unabhängige Sollentscheidung und keine direkte Wiederverwendung eines Opus-Testbetriebs. |
| variation | defined | yes | Einzige Änderung: mineralische N-Gabe von 0 auf 1 kg N/ha bei N2GI05; Düngungs- und Gesamtteilbefund beobachten. Dieselbe Einzeländerung auf dem nativen Mengenpfad; sonstige Übersetzungslücken bleiben unverändert. |
| missing_fact | defined | no | Einzige Auslassung: mineral_n_kg_per_ha bei weiterhin 0 organischem N; prüfen, ob eine unbekannte mineralische Gabe als fehlende Evidenz sichtbar wird. Dieselbe Einzeländerung auf dem nativen Mengenpfad; sonstige Übersetzungslücken bleiben unverändert. |

**Open dependencies:**

- Grünland-Untertyp, Vertragsbeginn und konkrete Mahd-/Beweidungsevidenz sind im Luna-Ausgangsfall nicht bestimmt und werden nicht ergänzt.
- Die native Prämien-/Vertragsentscheidung enthält allgemeinere Prüfungen als Lunas measure-spezifisches compliant; ihre Gesamtausgaben sind nicht direkt vergleichbar.
- Die Düngeverbot-Teilbefunde sind beobachtbare Entwicklungsdiagnosen; fehlende N-Menge darf nicht als bestätigte Nullgabe gelten.

**Evidence:**

- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/decision.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/common.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/common.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/eligibility.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/eligibility.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/obligations.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/policy/o6_23/obligations.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/tests/o6_23_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/tests/o6_23_test.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/data/o6_23/premium_rates.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/data/o6_23/premium_rates.json): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/rules/profile_changes.json): Vorgeschlagene native Felder und Eingabeeinheiten; das Canonical Farm Profile bleibt unverändert.
- [runs/v2-o6_23-opus-5.5-high-20260928/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_23-opus-5.5-high-20260928/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.

### o6_24

Run: `v2-o6_24-opus-5.5-high-20261003`. [Fixture](fixtures/o6_24.json) · [Native results](results/o6_24.json)

**Inputs:** Nativer Vertrag: farm.year, land.parcels[].parcel_id und wrrl mit Kultur, Düngeklassen und datierten n_applications sowie documentation.wrrl_records. Luna hat das Jahr 2026, Steiermark/Graz, 2,5 ha Ackerfläche, einen Gebietsflag, keine erhöhte Bewilligung, 120 kg N/ha, den Grenzwert 130, einen Fristflag und einen Betriebsbuchflag. Die Jahresmenge wird nicht in ein erfundenes Düngeereignis zerlegt.

**Output meaning:** decision trennt participation_eligible, Verpflichtungsverletzungen, wasserrechtliche Basisbefunde, Hinweise, N-Grenzwerte und Prämienrechnung. Hier wegen nicht übersetzbarer Jahresaggregate/Tabellenbasis keine Ausführung. Die dokumentierte fixture_gap ist ein Eingabevertragsbefund, keine WRRL-Ablehnung oder fachliche Qualitätsbewertung.

**Origin:** Öffentliche synthetische DEVELOPMENT-Diagnose: ausschließlich die drei bereits veröffentlichten Luna-Entwicklungsfälle in den nativen Opus-Vertrag übersetzt bzw. als nicht übersetzbar dokumentiert. Keine neuen Betriebsfakten, keine Modellgenerierung, keine unabhängig adjudizierten Sollwerte, kein Gold-/Heldout-Test.

**Query:** `data.oepul.o6_24.decision`

**Inventory:** 95 rule catalog entries; 11 sources; 2 static input paths; 11 profile proposals. Independent reference cases: `not_adjudicated`.

**Rule types:** `{"access_condition": 2, "application": 1, "calculation": 6, "classification": 2, "combination": 1, "commitment": 11, "consequence": 2, "contract_period": 3, "control": 2, "data_source": 1, "deadline": 2, "default": 1, "eligibility": 15, "exception": 9, "exit": 2, "external_reference": 1, "legal_baseline": 11, "option": 1, "payment": 3, "premium": 2, "procedure": 9, "sanction": 5, "scope": 1, "temporal": 1, "transitional": 1}`

<details>
<summary>Static input paths and model-reported source coverage</summary>

Rule counts and reported source coverage come from historical model outputs. They do not prove completeness. Static input paths may miss dynamic references; they do not show every fact read during execution.

Static input paths (not an execution trace):

    [
      "input.land.parcels",
      "input.land.total_area_ha"
    ]

| Source ID | Reported review scope | Entries | Classification |
|---|---|---|---|
| o6_24 | full_document | 25 | {"not_rule": 4, "rules": 21} |
| o6_general | full_document | 41 | {"not_rule": 17, "rules": 24} |
| trockenheit_2026_biodiversitaetsflaechen | full_document | 5 | {"not_rule": 3, "rules": 2} |
| rebzikade_2026_insektizidverzicht | full_document | 1 | {"not_rule": 1} |
| duerre_2026_oepul_ausgleichszulage | full_document | 3 | {"not_rule": 1, "rules": 2} |
| duerre_2026_foerderungsabwicklung | full_document | 6 | {"not_rule": 5, "rules": 1} |
| grundwasserschutzprogramm_graz_bad_radkersburg_2018 | full_document | 20 | {"not_rule": 8, "rules": 11, "unresolved": 1} |
| grundwasserschutzprogramm_graz_bad_radkersburg_2018_anlage3 | full_document | 21 | {"rules": 21} |
| oepul_sonderrichtlinie_2023 | targeted_sections | 33 | {"not_rule": 12, "rules": 21} |
| oepul_sonderrichtlinie_2023_anhaenge | targeted_sections | 4 | {"not_rule": 2, "rules": 2} |
| gsp_anwendungsverordnung | targeted_sections | 30 | {"not_rule": 11, "rules": 19} |

</details>

Rule types, sources, required facts and open questions help choose the study scope. No estimate of expert hours is made. not_adjudicated means that independent cases and expert-confirmed expected decisions are still needed. These visible development cases must not later be described as hidden test cases.

**Luna fact mapping and comparison gaps:**

    {
      "cases": [
        {
          "case_id": "baseline",
          "mapped_facts": [],
          "unmapped_facts": [
            "/farm/year = 2026, /farm/region und /land/parcels/0/area_ha = 2.5, land_use = arable wären als Kontext kopierbar; keine vorhandene /parcel_id und keine identische N-Teilprobe.",
            "/land/parcels/0/constraints/is_wrrl_area = true und /wrrl_higher_n_authorization = false sind Gebiet-/Bewilligungssammelfakten; sie ergänzen keine Kultur oder Düngeklasse.",
            "/land/parcels/0/operations/fertilizer/annual_effective_n_kg_per_ha = 120:Opus verlangt /wrrl/n_applications[] mit Datum, Typ und N-Menge; die Jahressumme wird nicht in ein erfundenes Einzelereignis umgeschrieben.",
            "/land/parcels/0/operations/fertilizer/wrrl_annual_limit_kg_per_ha = 130:Opus berechnet /n_limits_kg_per_ha aus Kultur und Düngeklassenanteilen; keine umkehrbare Tabellenzuordnung.",
            "/land/parcels/0/operations/fertilizer/application_period_compliant = true ist kein Nachweis konkreter Düngetermine/-typen; /documentation/wrrl_farm_book_complete = true ist keine vollständige Aufteilung in /wrrl_records-Einzelbelege."
          ]
        },
        {
          "case_id": "variation",
          "mapped_facts": [],
          "unmapped_facts": [
            "/farm/year = 2026, /farm/region und /land/parcels/0/area_ha = 2.5, land_use = arable wären als Kontext kopierbar; keine vorhandene /parcel_id und keine identische N-Teilprobe.",
            "/land/parcels/0/constraints/is_wrrl_area = true und /wrrl_higher_n_authorization = false sind Gebiet-/Bewilligungssammelfakten; sie ergänzen keine Kultur oder Düngeklasse.",
            "/land/parcels/0/operations/fertilizer/annual_effective_n_kg_per_ha = 131:Opus verlangt /wrrl/n_applications[] mit Datum, Typ und N-Menge; die Jahressumme wird nicht in ein erfundenes Einzelereignis umgeschrieben.",
            "/land/parcels/0/operations/fertilizer/wrrl_annual_limit_kg_per_ha = 130:Opus berechnet /n_limits_kg_per_ha aus Kultur und Düngeklassenanteilen; keine umkehrbare Tabellenzuordnung.",
            "/land/parcels/0/operations/fertilizer/application_period_compliant = true ist kein Nachweis konkreter Düngetermine/-typen; /documentation/wrrl_farm_book_complete = true ist keine vollständige Aufteilung in /wrrl_records-Einzelbelege."
          ]
        },
        {
          "case_id": "missing_fact",
          "mapped_facts": [],
          "unmapped_facts": [
            "/farm/year = 2026, /farm/region und /land/parcels/0/area_ha = 2.5, land_use = arable wären als Kontext kopierbar; keine vorhandene /parcel_id und keine identische N-Teilprobe.",
            "/land/parcels/0/constraints/is_wrrl_area = true und /wrrl_higher_n_authorization = false sind Gebiet-/Bewilligungssammelfakten; sie ergänzen keine Kultur oder Düngeklasse.",
            "/land/parcels/0/operations/fertilizer/annual_effective_n_kg_per_ha = absichtlich fehlend:Opus verlangt /wrrl/n_applications[] mit Datum, Typ und N-Menge; die Jahressumme wird nicht in ein erfundenes Einzelereignis umgeschrieben.",
            "/land/parcels/0/operations/fertilizer/wrrl_annual_limit_kg_per_ha = 130:Opus berechnet /n_limits_kg_per_ha aus Kultur und Düngeklassenanteilen; keine umkehrbare Tabellenzuordnung.",
            "/land/parcels/0/operations/fertilizer/application_period_compliant = true ist kein Nachweis konkreter Düngetermine/-typen; /documentation/wrrl_farm_book_complete = true ist keine vollständige Aufteilung in /wrrl_records-Einzelbelege."
          ]
        }
      ],
      "comparison_limit": "Luna liefert eine Jahressumme von 120 → 131 kg N/ha, den vorgegebenen Grenzwert 130 und einen booleschen Fristbefund. Opus berechnet die Menge aus Einzelgaben und den Grenzwert aus Kultur und Düngeklasse. Ohne Parzellenkennung, Kultur, Klasse, Gabenzeitpunkte und -typen sowie Buchführungsdetails lassen sich die drei N-Proben nicht fachlich gleich übersetzen.",
      "fixture_path": "docs/analysis/luna-screening-20261011/fixtures/o6_24.json"
    }

| Case | Observed status | Output changed from baseline | Purpose |
|---|---|---|---|
| — | fixture_gap | fixture_gap | No executable cases |

**Fixture gap:** Luna liefert eine Jahressumme von 120 → 131 kg N/ha, den vorgegebenen Grenzwert 130 und einen booleschen Fristbefund. Opus berechnet die Menge aus Einzelgaben und den Grenzwert aus Kultur und Düngeklasse. Ohne Parzellenkennung, Kultur, Klasse, Gabenzeitpunkte und -typen sowie Buchführungsdetails lassen sich die drei N-Proben nicht fachlich gleich übersetzen.


**Open dependencies:**

- Luna liefert eine Jahressumme von 120 → 131 kg N/ha, den vorgegebenen Grenzwert 130 und einen booleschen Fristbefund. Opus berechnet die Menge aus Einzelgaben und den Grenzwert aus Kultur und Düngeklasse. Ohne Parzellenkennung, Kultur, Klasse, Gabenzeitpunkte und -typen sowie Buchführungsdetails lassen sich die drei N-Proben nicht fachlich gleich übersetzen.
- Für eine spätere eigenständige Opus-Entwicklungsprobe können neue ausdrücklich synthetische Fälle erstellt werden; sie wären dann keine Übersetzung dieser Luna-Fälle.

**Evidence:**

- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/decision.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/decision.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/lib.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/lib.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/fertilization.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/fertilization.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/records.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/policy/o6_24/records.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/tests/o6_24/fixture_test.rego](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/tests/o6_24/fixture_test.rego): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/data/o6_24/gwsp_anlage3_tab2_acker.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/data/o6_24/gwsp_anlage3_tab2_acker.json): Nativer Opus-Eingabe-/Ausgabevertrag, konsumierte Pfade oder geschlossene Tabelle; keine neue normative Regel.
- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/rules/profile_changes.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/rules/profile_changes.json): Vorgeschlagene native Felder und Eingabeeinheiten; das Canonical Farm Profile bleibt unverändert.
- [runs/v2-o6_24-opus-5.5-high-20261003/artifacts/input-paths.json](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/artifacts/input-paths.json): Historisch statisch erkannte Eingabepfade, kein vollständiger dynamischer Verbrauchsnachweis.
- [runs/v2-o6_24-opus-5.5-high-20261003/workspace/notes/assumptions.md](https://github.com/ghinta/oepul-rule-lab/blob/e009eed4a83ff076b26eba33ac433ac2b0642621/runs/v2-o6_24-opus-5.5-high-20261003/workspace/notes/assumptions.md): Historische Modellannahmen und offene Abgrenzungen, keine unabhängige fachliche Bestätigung.
