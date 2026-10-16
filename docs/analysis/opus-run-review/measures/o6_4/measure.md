# o6_4 raw Opus audit: obligations and premium

Frozen run `v2-o6_4-opus-5.5-high-20261009` at `e009eed4a83ff076b26eba33ac433ac2b0642621`. Audit and collection only; no historical policy, productive policy, original source or profile changes.

The new October 2025 measure original was read completely, all four pages including the rate table, warnings, examples and updates. Both assigned modules were read in full. Seven shared sources and the identical GSP-AV reuse actual earlier full readings by exact hash; relevant current clauses were reread. GSP-AV is actually provided in this run and supports the legal amount findings. No new full GSP reading is claimed.

This part contains 33 historical rule assessments, 39 source-coverage entries, five collected finding groups and 28 fresh public development probes. All normative new-measure clauses in the assigned scope already have historical catalog IDs; missing executable subclauses remain in those assessments. `additional_source_rules` is therefore empty.

All 28 OPA calls returned code 0. There are 23 matching controls and five unmet expectations: a grazing interval crossing the year boundary, a paired official-area basis check, missing overdeclaration reduction, and the LSE cap-stage amount. The fifth finding group is an open BM0 interpretation without an invented expected code or payment. The diagnostic set is not an accuracy score or expert acceptance.

Correct behavior is preserved explicitly: actual year filtering for mowing, fertilizer and PSM; full-area mowing and removal evidence; annual postgrazing from 16 August even in BM0 years; continuing nonmowing duties; separate area/LSE channels; and the integrated substantive-reduction, modulation, cap and access subsequence. A fresh equal-rate control produces the expected 2,809.23 € after 50% content reduction, 218/220 modulation and a 0.75 access factor.

## O6_4-MEASURE-01 — Grazing intervals crossing NewYear are ignored

`TEMPORAL_SCOPE` · high · source_coverage_or_semantics

Only the start year is tested. An explicitly recorded period 31 December 2025–2 January 2026 has prohibited current-year grazing before 16 August, but produces no O64-OBL-004 violation. end_date is in the proposed contract and is not consumed.

Source: `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, page 2: “Bergmähder dürfen grundsätzlich nicht beweidet werden.”.

Code: `workspace/policy/o6_4/obligations.rego:68`.

Probes: `o6_4-grazing-cross-year-interval`.

## O6_4-MEASURE-02 — Official declared/determined area basis does not feed gross amount

`PAYMENT_GATING` · high · source_coverage_or_semantics

§42(3)/(4)requires the smaller claimed/determined measure area as benefit basis. Gross uses p.area_ha even when the official one-parcel figures differ. Paired 0.02 ha cases below 3% isolate missing basis selection without any extra administrative sanction or allocation ambiguity.

Source: `sources/oepul/legal/gsp-av-fassung-vom-28012026.pdf`, page 28: “(3) Ist die im Rahmen einer Fördermaßnahme ermittelte Fläche größer als die im Mehrfachantrag angemeldete Fläche (Untererklärung), so wird für die Berechnung der Beihilfe die angemeldete Fläche herangezogen.”.

Code: `workspace/policy/o6_4/premium.rego:118`.

Probes: `o6_4-official-area-basis-over`, `o6_4-official-area-basis-under`.

## O6_4-MEASURE-03 — Overdeclaration penalty is reported separately but not paid through

`PAYMENT_GATING` · high · source_coverage_or_semantics

The supplied GSP §46 consequence is not connected to net_premium. With a single uniform-rate parcel, 3 ha claimed versus 2 ha determined requires the equivalent of 0.5 ha after the extra 1.5 ha reduction; the nominal 378 rate and 756 gross remain distinct. The probe stipulates no statutory waiver/correction exception and does not invent a mixed-rate rule.

Source: `sources/oepul/legal/gsp-av-fassung-vom-28012026.pdf`, page 30: “verringert um das 1,5fache der festgestellten Differenz, berechnet, wenn diese Differenz mehr als 3% der ermittelten Fläche oder mehr als 2 ha beträgt.”.

Code: `workspace/policy/o6_4/premium.rego:118`.

Probes: `o6_4-overdeclaration-payment-integration`.

## O6_4-MEASURE-04 — Unmodulated LSE amount inflates the aggregate cap excess

`TABLE_CONSUMPTION` · medium · source_coverage_or_semantics

Own measure 4 premium is modulated before cap, but companion 1A/1B point-element payment is added at its raw rate. The source applies farm modulation to all measure premiums before the cap. Even with valid 80 trees on a 2 ha field and no LSE-cap violation, aggregate excess is overstated. The probe leaves the cross-measure allocation of the overlap unresolved.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 19: “Das Prämienausmaß aller Maßnahmen wird in Abhängigkeit zur gesamten Fläche des”.

Code: `workspace/policy/o6_4/premium.rego:49`, `workspace/policy/o6_4/premium.rego:148`.

Probes: `o6_4-lse-modulation-before-cap`.

## O6_4-MEASURE-05 — BM0 after an actually performed but unlawful mowing is an open code interpretation

`SOURCE_VERSION` · medium · unresolved_interpretation

Native assumption6 equates nonqualifying mowing with no mowing for coding. The source instead says BM0 if no mowing occurs, while separately prohibiting unremoved material/mulching. This is preserved as an unresolved interpretation; no code/payment expected label is manufactured for the disputed event.

Source: `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, page 3: “Erfolgt keine Mahd, so ist die betroffene Fläche im jeweiligen Jahr mit BM0 zu codieren.”.

Code: `workspace/policy/o6_4/obligations.rego:143`.

## Historical catalog ledger

| Rule | Status | Assessment |
|---|---|---|
| O64-ELIG-003 | implemented | The premium consumer blocks a parcel unless its Bergmahd definition is established. The strict >50% above 1200 m criterion is implemented in eligibility; general/input reports separately assess source hierarchy, Alm/home-site identity and types. A farm Alm flag is not reinterpreted here as proof of permission below the actual home site. |
| O64-OBL-001 | partial | Current-year mowing qualifies only with positive full_area and cut_material_removed evidence and no mulching. Current and previous-year history enforce the two-year interval after the first contract year. This corrects the prior run missing-removal/year-filter issues. First-year exemption and year-end-only evaluation are explicitly disclosed interpretations; history is assumed to represent completed qualifying mowing. Older precontract years alone cannot satisfy a later current/previous-year window. |
| O64-OBL-002 | implemented | All mowing events in the application year are counted and more than one produces a violation. Prior-year events do not inflate the count. The event must represent one mowing operation with its main method, not separately entered finishing around rocks; duplicate identity is an upstream validation issue. |
| O64-OBL-003 | implemented | Current-year mulching and explicitly unremoved cut material each produce the source prohibition. Only full-area, removed and nonmulched mowing contributes to the qualifying-mowing frequency. Missing field behavior is independently assessed in the input report. |
| O64-OBL-004 | partial | A current-year grazing start before 16 August is rejected and 16 August is allowed. However, the supplied end_date is ignored, so an interval beginning in a previous year and continuing before 16 August of the current year is missed. This is a temporal interval defect within the proposed period contract, not merely missing input. |
| O64-OBL-005 | implemented | Postgrazing is allowed every year including BM0/no-mowing years, and does not count as a qualifying mowing year. Paired controls distinguish permitted postgrazing from satisfying the biennial mowing duty. |
| O64-OBL-006 | implemented | The complete fertilizer-type allowlist is consumed on enrolled parcels with current-year event filtering; all nonallowed types generate the relevant prohibition. Positive mineral-nitrogen aggregate additionally generates a violation. Off-measure parcels are not subjected to this measure-specific checker; root tests that scope. |
| O64-OBL-007 | partial | Original solid manure is allowed and dissolved manure is rejected. An explicit false demand_based flag generates a violation, but null is admitted by the proposed profile and silently escapes it; missing defaults true. The input reviewer owns positive-evidence/null diagnostics. Unknown demand is not itself evidence of an actual excessive application. |
| O64-OBL-008 | implemented | Lime is a prohibited fertilizer type and is mapped to its specific rule ID. A prior-year lime application does not become a current-year violation; no organic/non-N exception is invented. |
| O64-OBL-009 | implemented | Own household wastewater is permitted by the consumed type table. That identity must actually mean own domestic wastewater; this local exception does not override other applicable legal restrictions. |
| O64-OBL-010 | partial | An explicitly non-BIO current-year PSM event is prohibited; a positive only-EU2018/848 flag receives the source exception. Missing event details with psm_used create a warning. Null or malformed flags are not positive approval evidence; proposed-schema and native comparison details are independently tested by the input report. Actual product register qualification remains external. |
| O64-OBL-012 | implemented | Fertilizer, PSM and grazing consumers do not stop when the declared/effective code is BM0. Public controls confirm a no-mowing year still reports current prohibited applications while permitting postgrazing from 16 August. |
| O64-OBL-013 | implemented | The obligation checker iterates every enrolled parcel regardless of national-park payment exclusions. National-park scope is therefore not confused with permission to ignore management duties. |
| O64-COD-002 | partial | Documented qualifying mowing maps the main method to BM1/2/3, and a mismatch is reported. Missing declared code is collected explicitly. If there are no event details, the premium module can fall back to the declared code; an application code is not independent confirmation of actual mowing. The input review owns unknown-method and fallback diagnostics. |
| O64-COD-003 | unresolved | An explicit empty/currently nonqualifying event collection gives BM0. Native assumption6 also treats an actual but unlawful mowing (unremoved material or mulching) as BM0, while separately reporting its violation. The source says BM0 when no mowing occurs; whether a failed mowing must instead retain its actual method code is an interpretation question. Do not manufacture a settled code/payment oracle from this conflict. |
| O64-COD-004 | implemented | The method field is explicitly the main mowing method. hand_motor_mower therefore maps to BM2; using a scythe only to finish around obstacles does not create a separate main-method event. More than one whole mowing event remains independently prohibited. |
| O64-COD-005 | implemented | mower_transporter maps to BM1 and consumes the tractor/Mähtrak rate. A fresh end-to-end source control verifies the method, code and nominal amount. |
| O64-COD-006 | implemented | scythe and brush_cutter map to BM3 without a slope threshold. The relatively level source example does not impose an alternative eligibility or code rule. |
| O64-PRM-001 | implemented | All method/year rates are consumed from the complete table, including 2023 and from 2024. Source controls verify actual method-to-code-to-rate integration; complete cell values are separately checked in tables.json. |
| O64-PRM-002 | partial | An explicit no-mowing event list produces BM0 and blocks payment. If mowing_events is absent, effective_code can use BM1/2/3 declared on the application, permitting a component estimate without independent actual mowing evidence. This is a positive-evidence admission limitation, not proof that an absent array means actual no mowing. |
| O64-PRM-003 | implemented | All other area premiums are rejected on an enrolled mountain-meadow parcel; UBB/BIO point-landscape-element payments use a separate channel. A farm may participate in1A/1B without claiming their area premium on this parcel. Corrected combinations are evaluated from the current declaration; procedural correction timing is not modeled. |
| O64-PRM-004 | partial | Point-element counts and 13/8.6 unit rates are consumed according to farm 1A/1B participation. The stored 80 trees/ha-field cap and detailed element eligibility are not enforced because field identity/geometric/species evidence is absent; the table peer owns that isolated probe. The raw LSE amount is then fed to the cap without its own source-required farm modulation, causing the separate cap-stage defect below. |
| O64-PRM-005 | partial | Gross amount uses p.area_ha exclusively. Official measure declared_area_ha and determined_area_ha are not used to choose the smaller statutory basis, even in a one-parcel equal-rate case with no allocation ambiguity. Fresh sub3%paired cases isolate this basis error from any overdeclaration penalty. Component rate itself remains correct. |
| O64-PRM-007 | implemented | The <=50 euro result is a discretionary flag after the implemented net calculation; it does not automatically zero the amount. This is the required Kann behavior, and does not establish final AMA payout authority. |
| O64-GEN-017 | partial | A current incompatible premium declaration blocks the parcel until corrected. The date of payment notice and control findings that determine correction eligibility are not represented; those procedural conditions remain external. |
| O64-GEN-023 | implemented | The monetary consumer applies area_increase_limit after cap, as a proportional factor. The administration limit includes base2025, max(50%,5ha) and incoming previously committed hectares, correcting the previous run missing-credit contract. Which parcels bear a mixed-rate cut is an explicit allocation assumption; the positive integration control uses equal rates. |
| O64-GEN-024 | partial | The general year cap is actually applied to own modulated amount plus LSE. Other area premiums are incompatible here, so no arbitrary generic other-payments scalar is invented. LSE enters at its unmodulated raw amount. The documented choice to deduct the entire overlap from measure 4 is an unresolved allocation convention; the probe tests aggregate cap_excess only, not an externally settled cross-measure split. |
| O64-GEN-028 | partial | Substantive percentage reduction, modulation, cap and access are genuinely integrated in the stated order. Over/underdeclaration, late filing and conditionality are not applied to this amount despite being supplied/cross-referenced. The missing official area-basis and overdeclaration-payment connections are substantive coverage gaps now that GSP is actually in the packet. Raw and partially net estimates remain distinct from a final authoritative award. |
| O64-GEN-029 | implemented | The four-band weighted formula is consumed by after_modulation and matches the220 ha / 218 equivalent-ha source example. Total_area_ha must be a correctly scoped Austrian Heimfläche input; original data types/runtime and physical-scope concerns are separately audited. |
| O64-GEN-033 | implemented | The premium path consumes current applicant eligibility and active contract and blocks the whole farm on failure. The general/legal peer owns detailed access/contract evidence and year effects; local components are not treated as independent approval of those prerequisites. |
| O64-GEN-035 | partial | The separate over_declaration_sanction_ha helper does not feed the premium amount; §42 basis selection is also missing. Underdeclaration, §45 exceptions and §46(2) prämienbezogene calculation are separately assessed by general/legal. A uniform-rate single-parcel development case can isolate the missing cash consequence without making assumptions about a mixed-rate distribution. |

| O64-XM-001 | catalog_only | The ten cross-measure exclusion summaries are stored in cross_measure_bergmaehder_exclusions and match the relevant UBB/BIO bases/variants/supplements, Heuwirtschaft minimum/premium classes and measure17 species-rich-grassland supplement clauses. No target-measure policy consumes them here. This is source-grounded interaction data, not an executable check of another measure or a reason to award an extra measure4 payment. |
| O64-XM-002 | catalog_only | The current source annexes describe possible Naturschutz GG01–GG04 reachability conditions and EBW EBBA reachability reasons on mountain meadows. This is correctly retained as informational interaction after a valid conversion; no target-measure amount is calculated in4. Actual target participation, project confirmation, distance/use/biotope conditions and year-specific amounts require the target policy. No18/19-run review or automatic supplement entitlement is implied. |

## Source coverage

| Section | Page | Status | Assessment |
|---|---|---|---|
| MB1-overview | 1 | reviewed | Complete first page read. Difficult-management context is distinguished from strict measurable parcel definition and compensation. |
| MB1-contract | 1 | peer_review | All 2023/2024/2025 start durations and 2028 end read; general owns contract admission. |
| MB2-definition | 2 | peer_review | Whole definition read, including above-home versus below-Alm-site distinction and normally-not-adjacent qualifier; general owns hierarchy/identity. |
| MB2-participation | 2 | peer_review | All three note clauses read; root checks opt-in scope independently. |
| MB2-mowing | 2 | reviewed | Complete clause read; actual positive full-area/removal/current-year evidence is consumed. First-year and year-end interpretations remain explicit. |
| MB2-grazing | 2 | partial | All sentences read; correct start-date boundary but incomplete interval handling. |
| MB2-fertilizer | 2 | partial | Every named input/exception read; type values consumed and current-year scope preserved; demand-null is an input-contract limitation. |
| MB2-3-PSM | 2 | partial | Both sides of the page break read. Explicit approved/nonapproved cases respected; actual registry evidence remains external. |
| MB3-application | 3 | peer_review | All three bullets read; general owns legal deadline and conversion semantics. |
| MB3-code | 3 | partial | Main-method classification consumed. Missing actual mowing must remain distinct from declaration-only fallback. |
| MB3-BM0 | 3 | partial | No-mowing code and continuing other duties read; native nonqualifying-mowingBM0 interpretation left open. |
| MB3-examples | 3 | reviewed | Motormäher+finishingSense=BM2, Mähtrak=BM1, levelSense=BM3 all read and consumed as main method. |
| MB4-rates | 4 | reviewed | All BM0 and 2023/from 2024 amounts read, table peer independently checks every cell. |
| MB4-no-mow | 4 | partial | Explicit[]blocks amount; missing detail declaration fallback is not proof of no actual mowing. |
| MB4-combinations | 4 | reviewed | Separate area and point-payment channels correctly consumed; LSEqualification and cap stage checked with peer. |
| MB4-updates | 4 | context_only | All update bullets and disclaimer read; no additional executable gate inferred from metadata. |
| SRL51 | 51 | reviewed | Complete shared SRL page 51 reread against current consumers: support, altitude, mowing/grazing, fertilizer/PSM, rates and no-combination condition. |
| GSP19 | 19 | reviewed | Complete relevant page19 reread. Existing identical 94-page full-GSPreading is reused from 1c; no fresh full-GSPread is claimed. |
| GSP28 | 28 | partial | Complete page28 reread; smaller official-area basis absent from premium consumer. |
| GSP30 | 30 | partial | Complete page30 reread; uniform-rate integration probe isolates missing overdeclaration amount, exceptions not silently dismissed. |
| AT7 | 7 | reviewed | Current obligation consumer does not stop for no-premium national-park land; general assesses park eligibility. |
| AT17 | 17 | reviewed | Cap now includes incoming already-committed land, represented by a dedicated field; proportional monetary allocation disclosed. |
| AT19 | 19 | partial | Complete shared page19 reread; own amount modulated, LSE amount remains raw at cap. |
| SRL25 | 25 | partial | Complete shared page25 reread. Positive integrated subsequence preserved, missing earlier stages separately documented. |
| SRL28 | 28 | partial | Whole shared page28 reread, including geometry/ownership/year retention/species; current count input is a preclassified assertion. |
| SRL34 | 34 | partial | Whole shared page34 reread; full table checked by peer, missing field-cap consumer and LSE modulation distinct. |
| SRL22 | 22 | reviewed | Supplied discretionary 50 euro wording retained; other actual payout stages owned by general. |
| NOTICE-2026-05-22 | None | peer_review | No automatic measure 4 waiver is inferred from other-measure 2026 notices. May 22 general application/control context remains relevant; root/general own individualized claim scope. |
| NOTICE-2026-06-12 | None | peer_review | No automatic measure 4 waiver is inferred from other-measure 2026 notices. May 22 general application/control context remains relevant; root/general own individualized claim scope. |
| NOTICE-2026-08-05 | None | peer_review | No automatic measure 4 waiver is inferred from other-measure 2026 notices. May 22 general application/control context remains relevant; root/general own individualized claim scope. |
| NOTICE-2026-08-12 | None | peer_review | No automatic measure 4 waiver is inferred from other-measure 2026 notices. May 22 general application/control context remains relevant; root/general own individualized claim scope. |

| XM-SRL30 | 30 | catalog_only | Current clause reread: Bergmähder excluded from the mown-grassland biodiversity base. |
| XM-SRL31 | 31 | catalog_only | Current clauses reread, retaining field-level and variant exclusions as cross-measure information. |
| XM-SRL39 | 39 | catalog_only | Current analogous BIO clauses reread; no executable BIO denominator consumer exists in this4policy. |
| XM-SRL43 | 43 | catalog_only | Relevant premium table qualifier reread: mown grassland base without Bergmähder. |
| XM-SRL50 | 50 | catalog_only | Relevant source classes reread; the stored interaction identifies minimum and premium classes, not a general livestock-density exclusion. |
| XM-SRL79 | 79 | catalog_only | Relevant exclusion clause reread; no separate17-run policy or study labels inspected. |
| XM-ANNEX65 | 65 | catalog_only | Entire annex page65 reread including reachability rows, use frequency and2024/from2025 distinctions. The4policy does not calculate these target-measure payments. |
| XM-ANNEX98 | 98 | catalog_only | Entire annex page98 reread including stated reasons, biotope/exception context and EBBA01/02. This does not establish automatic target-measure eligibility. |

## Probe boundaries

Original policy and data directories were loaded together with pinned OPA, retaining `data.oepul.o6_4` and native numeric representations. Inputs, queries, expectations, exact source evidence and original observations are embedded in `measure.json`. All cases were authored afresh from original sources; no public/private study labels, GM answers or manual adaptation tests were consulted.

The area-basis pair uses one parcel, one rate and a difference of only 0.02 ha, below the extra-sanction threshold. It isolates §42(3)/(4) basis selection. The separate overdeclaration integration case stipulates an ordinary official determination without a §45 waiver or correction exemption. Uniform rates make the §46(2) premium-based and area-equivalent computation agree: (2 − 1.5 × (3 − 2)) × 378 = 189 €. The 378 €/ha rate and 756 € on determined hectares are separately checked.

The LSE probe uses 80 fully eligible Streuobst elements on a complete 2 ha field, below its 160-tree field limit, with 220 ha Austrian Heimfläche in total. Both the 1,944 € mountain-meadow component and 1,040 € LSE component must be modulated before the 2,600 € cap: the aggregate overlap is 356.87 €, whereas the native raw-LSE consumer gives 366.33 €. The case does not invent how the overlap must be allocated between measures.

Missing evidence, admitted nulls and malformed-schema/date stress are handled separately by the input review. Missing mowing events are not asserted to prove actual no mowing. The BM0 coding interpretation for a performed but unlawful mowing remains open. No arbitrary violation is translated automatically into a 100% payment reduction.

Root owns opt-in/common/decision controls; general/legal owns contract, eligibility, assessed sanctions and statutory exception details; tables own complete closed values and the isolated 80-tree field-cap case. The historical XM-001/XM-002 interaction clauses are explicitly covered as data/information, using the current shared sources. They do not assert target-measure eligibility or start a target-measure run review. No subsequent measure was read.
