# o6_2 measure-source and executable-consumer audit

Frozen run `v2-o6_2-opus-5.5-high-20260930` at `e009eed4a83ff076b26eba33ac433ac2b0642621`. Audit only; no source, policy or profile changes.

The new April 2026 measure PDF was read completely: all eight pages, including tables, exceptions and updates. The three assigned modules were read in full. Seven shared sources have exactly the previously read hashes; current relevant legal, management, payment and notice clauses were checked against their actual consumers. GSP-AV and MOG are not in this run packet.

This part contains 43 individually assessed historical catalog rows plus 3 separately labelled source-only duty assessments, 39 source-coverage entries, 9 collected findings and 25 public source-derived or explicitly labelled App-contract probes. These are development diagnostics, not study reference cases or accuracy scores.

The local minimum-management result, raw premium components and final payable outcome are kept separate. Historical favorable missing fields, organic-treated-seed and own-digestate interpretations remain explicit. A DIV management exemption does not itself entitle a parcel to the measure 2 premium; combination exclusions are checked separately.

## O6_2-MEASURE-01 — Historical cut satisfies the annual mowing requirement

`TEMPORAL_SCOPE` · high · source_coverage_or_semantics

Any cutting_dates entry is counted, including a prior year; an ordinary meadow with no current-year mowing or grazing passes the local management check and escapes that parcel exclusion. This is independent of input absence and of Bergmähder exceptions. The canonical date-array contract contains no current-year-only restriction; if the App later imposes one, out-of-year dates must be rejected before calling this helper.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 6: “jährlich mindestens einmal vollflächige Mahd und Verbringen des Mähgutes oder”.

Code: `workspace/policy/o6_2/management.rego:17`, `workspace/policy/o6_2/premium.rego:67`.

Probes: `o6_2-management-historical-cut-only`.

## O6_2-MEASURE-02 — Source exemptions are absent from the minimum-management checker

`EVENT_SEMANTICS` · medium · source_coverage_or_semantics

A stipulated valid UBB DIV parcel with no harvest fails the ordinary 85% branch even though this general source exempts it. This local error does not establish measure2 premium entitlement: the separate DIV/forage premium combination restriction, audited by the table agent, must also be applied.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 6: “Folgende Flächen sind von den Mindestbewirtschaftungskriterien ausgenommen”.

Code: `workspace/policy/o6_2/management.rego:10`.

Probes: `o6_2-management-div-exempt-local`.

## O6_2-MEASURE-03 — Perennial management and differential maintenance duties are not executable

`MISSING_EVIDENCE` · high · source_coverage_or_semantics

The catalog mentions perennial establishment/care/harvest, but no input or branch verifies them. Ordinary arable sowing/care and the source two-year Bergmähder/out-of-production alternatives are also absent. The checker therefore cannot substantiate its broad minimum_management_met output for all supported land classes.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 6: “jährliche ordnungsgemäße Pflege von Fläche und Aufwuchs”.

Code: `workspace/policy/o6_2/management.rego:10`.

## O6_2-MEASURE-04 — Favorable missing evidence conflicts with positive-evidence App admission

`MISSING_EVIDENCE` · high · app_contract_gap

Missing harvest, fertilizer origin and orchard-quality evidence are accepted under the expressly documented native convention. This is a current App admission limitation requiring validation/proof, not a retrospective assertion that a missing JSON key establishes a statutory violation. Null orchard quality is admitted by the proposed profile and similarly escapes exclusion.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 6: “Ernte und Verbringen des Erntegutes auf zumindest 85 % des jeweiligen Schlages”.

Code: `workspace/policy/o6_2/management.rego:7`, `workspace/policy/o6_2/obligations.rego:12`, `workspace/policy/o6_2/premium.rego:82`.

Probes: `o6_2-management-missing-harvest-admission`, `o6_2-fertilizer-digestate-missing_origin`.

## O6_2-MEASURE-05 — Biogas return amount is delegated to an unquantified flag

`MISSING_EVIDENCE` · medium · input_contract_gap

A return-of-delivered-slurry flag establishes the type of return, but no delivered/returned quantities are proposed or compared. The corresponding-amount condition in the source therefore needs an externally evidenced composite assertion before admission. No invented numeric amount was added to the original contract.

Source: `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, page 3: “Nur im Falle der Verbringung von Gülle in eine Biogasanlage ist die Rücknahme entsprechender Mengen an Biogasgülle möglich, ansonsten darf Biogasgülle nicht übernommen werden.”.

Code: `workspace/policy/o6_2/obligations.rego:20`.

## O6_2-MEASURE-06 — Second forage phase and malformed PSM mode cannot be diagnosed

`EVENT_SEMANTICS` · medium · input_contract_gap

A main grain crop with forage_as_second_crop cannot attach a PSM application to the grain or forage phase. The native intent says the actual forage restriction persists, but the helper only recognizes the current crop_name. Unknown/missing application_mode also falls through without the existing missing-array review item. These are temporal/validation contract boundaries, not an unconditional source violation for an application of unknown phase.

Source: `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, page 3: “Auf allen Ackerfutter- und Grünlandflächen des Betriebes ist der Einsatz von flächig”.

Code: `workspace/policy/o6_2/common.rego:38`, `workspace/policy/o6_2/common.rego:94`, `workspace/policy/o6_2/obligations.rego:65`, `workspace/policy/o6_2/obligations.rego:196`.

## O6_2-MEASURE-07 — Other-national-park premium eligibility omits the relevant-restrictions condition

`MISSING_EVIDENCE` · medium · input_contract_gap

The source first qualifies national-park eligibility by relevant management restrictions, while the table consumer unconditionally accepts Kalkalpen and other. No such restriction field is proposed. This is conditional: do not claim all other parks are actually constrained or insert an invented field into a source oracle.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 7: “wenn keine relevanten Bewirtschaftungsauflagen auf den Nationalparkflächen”.

Code: `workspace/policy/o6_2/premium.rego:16`, `workspace/policy/o6_2/premium.rego:52`.

## O6_2-MEASURE-08 — Cap aggregation and final payment are not a complete payout decision

`EXTERNAL_DEPENDENCY` · medium · app_admission_and_external_dependency

The other-payments scalar is assumed premodulated but does not specify removal of cap-exempt schemes in its proposed rationale. Only the disclosed sanction/modulation/cap/access subsequence is executable; other reduction stages, AMA sanction assessment, actual administrative controls and the payment schedule remain external. Local component estimates cannot be represented as authorized final payout. The implemented subsequence has a positive equal-rate integration control.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 19: “Es gelten folgende Prämienobergrenzen für die Summe der flächenbezogenen Zahlungen”.

Code: `workspace/policy/o6_2/premium.rego:109`.

Probes: `o6_2-premium-order-equal-rates-control`.

## O6_2-MEASURE-09 — Training has no evaluation date or event identity

`TEMPORAL_SCOPE` · medium · input_contract_gap

Year2025 reports a violation before the December31 deadline as acknowledged in the assumptions; repeated records of one event can be summed without identity. Recognized-provider/person and cross-credit flags are upstream claims. The absence of an event API is an input-contract limitation; the report does not infer source-authorized duplicate credit.

Source: `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, page 4: “im Mindestausmaß von 3 Stunden”.

Code: `workspace/policy/o6_2/obligations.rego:165`.

## Rule-by-rule ledger

| Rule | Status | Assessment |
|---|---|---|
| O6_2-SCOPE-001 | implemented | The premium module consumes parcel_category and excludes foreign parcels. Fertilizer obligations are deliberately evaluated even on nonpremium land; physical Austrian/agricultural scope and classification are independently reviewed in core.json. |
| O6_2-ACC-UBB-001 | implemented | premium_granted consumes contract_valid and no_premium_this_year_due_to_access. The UBB access prerequisite is implemented in eligibility.rego; the general/core review owns its legal admission assessment. |
| O6_2-LIVESTOCK-010 | implemented | Rates depend on current livestock status, while obligations are not suppressed for nonlivestock farms. There is no repayment triggered solely by a lower current livestock status. Livestock measurement and threshold cases are owned by the general review. |
| O6_2-OBL-N-FERT-001 | partial | Known prohibited inputs and unknown external nitrogen inputs generate the expected violation on all parcels, including nonpremium protected cultivation. Missing external_origin defaults to own-farm rather than establishing origin. This follows the explicit historical favorable-input convention; positive-evidence admission needs a separate validation contract. Austrian physical scope is a core integration concern. |
| O6_2-OBL-N-FERT-002 | implemented | A positive mineral_n_kg_per_ha independently creates the mineral-nitrogen violation, without relying on a fertilizer input identifier. Mineral nitrogen is within the external nitrogen prohibition; explicit-null/type handling remains an input-contract concern. |
| O6_2-OBL-N-FERT-003 | partial | The allowed fertilizer exceptions are consumed from the complete input table. Imported digestate return requires a positive return flag, but neither delivered nor returned amounts are represented; the corresponding-quantity condition must be established externally before that flag supports admission. Own compost/digestate provenance is an explicit historical interpretation, not an independently verified blanket permission. |
| O6_2-OBL-N-FERT-005 | partial | Organic residues and sewage sludge are rejected independently of origin. Imported ordinary digestate is rejected. Own-farm digestate is allowed by an explicit native interpretation of the farm-external prohibition; the wording otherwise disallows taking over digestate. Keep that provenance interpretation open instead of turning it into an invented universal source oracle. |
| O6_2-OBL-N-FERT-004 | external_dependency | A review_item correctly states that statutory limits and prohibition periods still apply. It is not an executable assessment of those duties. GSP-AV/MOG were not in this run packet, so their absence is a source-package/application admission limitation, not proof of a missed supplied norm. |
| O6_2-OBL-N-LIMIT-001 | partial | This module reports nitrogen_limit_exceeded from livestock.rego. Complete denominator, nitrogen provenance, missing/null and pasture-deduction analysis is owned by general.json; this report verifies the actual violation consumer only. |
| O6_2-OBL-N-LIMIT-002 | partial | The N-limit consumer delegates current-calendar-year, pasture deduction, no export-offset and Austrian-unit processing to livestock.rego; see the independently inspected general ledger for those details. |
| O6_2-OBL-PSM-001 | partial | Known broadcast and seed-treatment modes consume the PSM mode table; nonorganic applications on named forage/grassland are violations and single-plant treatment is exempt. Organic-only seed treatment uses an explicit native interpretation of the source exception and its later sentence saying seed treatment is therefore impermissible; it remains an interpretation boundary. Missing/invalid modes silently fail lookup, and second-crop phase cannot be distinguished from the permitted preceding grain crop. |
| O6_2-OBL-PSM-002 | external_dependency | Broadcast PSM on genuine grain/maize arable land is not rejected by this measure. Whether the actual product/use is authorized in the AGES register remains an external lookup; no product registry or product-to-use consumer is supplied. |
| O6_2-OBL-PSM-CODE-001 | implemented | The missing-code violation is gated to years through 2025. The required code is PSMCS for a nonorganic broadcast and otherwise PSMBIO; coding itself does not legalize a prohibited application. |
| O6_2-OBL-PSM-CODE-002 | partial | PSMCS suffices for mixed chemical-plus-BIO applications as required. It is also accepted when the only recorded broadcast is BIO, which extends the explicit mixed-use example; the source does not independently settle that broader substitution. Keep the condition qualified. |
| O6_2-OBL-PSM-CODE-003 | catalog_only | Advance declaration, removal of an unperformed planned application and immediate amendment are documented but not executable. No planned-application/correction event dates are proposed; the year flag is not a test of these procedural duties. |
| O6_2-OBL-PSM-CODE-004 | implemented | The code checker stops in 2026 while the substantive application prohibition remains active. Public paired-year controls cover the boundary. |
| O6_2-OBL-SUPPLY-001 | partial | Purchase or storage of a prohibited fertilizer or nonorganic PSM is rejected. The PSM exception requires all three positive flags: allowed use in other crops, plausible quantity and records. The quantities, records and actual crop authorization are preprocessed assertions; fertilizer origin/biogas quantity limitations are shared with the application checker. |
| O6_2-OBL-TRAIN-001 | partial | Creditable hours are summed and the 3h threshold is enforced from year 2025. Topics, provider, date and attendee role are consumed. There is no as-of date, so a 2025 evaluation before 31 December may prematurely present a provisional deficiency as a violation; this is expressly acknowledged in native assumption 13, not hidden historical intent. |
| O6_2-OBL-TRAIN-002 | implemented | The applicant and involved farm person roles are accepted; other roles are not. Whether an individual actually satisfies the involved-person condition is an upstream factual assessment. |
| O6_2-OBL-TRAIN-003 | partial | Date boundaries and explicit cross-farm/cross-commitment credit flags are enforced. However, duplicate entries of the same course have no identity and are summed independently. A single 1.5h event represented twice can meet 3h. This is an input/event identity boundary; the source directly forbids cross-obligation double credit but does not itself define a duplicate-record API. |
| O6_2-OBL-TRAIN-004 | implemented | An attendee leaving strictly before 31 December 2025 makes their course noncreditable; leaving after the deadline does not. The precise on-deadline case follows the catalog interpretation and is not independently resolved beyond the source wording. |
| O6_2-OBL-TRAIN-005 | catalog_only | The AMA certificate request/provider submission and eAMA viewing procedure are catalogued but not automated; no request/submission evidence model is supplied. |
| O6_2-OBL-TRAIN-006 | external_dependency | Biodiversity hours are excluded from this measure-specific credit, but the separate UBB 3h biodiversity training requirement is not evaluated by this policy. Participating in 1A is an asserted dependency, not proof of compliance with its entire policy. |
| O6_2-PREM-RATE-001 | implemented | rate_for consumes category, livestock status, band and year from the complete premium table; multiplication uses parcel area. Components are gross estimates before contract/payment/control gates, not awards. All table cells are separately cross-checked by the table review. |
| O6_2-PREM-BAND-001 | implemented | The premium consumer uses the livestock band derived by livestock.rego, including the exact >=1.4 boundary. The numerical/runtime and density contract are independently audited in general/core reports. |
| O6_2-PREM-GLOEZ8-001 | unresolved | Matching 2023/2024 NPF Klee/Kleegras/Luzerne parcels are excluded entirely from this measure premium. The source says no forage premium, and native assumption 9 explicitly leaves open whether an arable rate instead applies. Do not silently choose a source oracle. Later years are not excluded by this clause. |
| O6_2-PREM-FRUIT-001 | partial | An explicit false quality-material flag excludes orchard premium, but omitted or null quality evidence does not. This honors the stated historical favorable-input convention while falling short of the agreed positive-evidence admission contract. Grafted planting stock is a source-based requirement, not inferred from a crop name. |
| O6_2-PREM-NONELIG-001 | partial | Known noneligible types, protected cultivation and unsupported categories are excluded. The consumer relies on correct upstream land/crop classification and membership; it does not itself establish active agriculture, correct parcel reference or measure declaration. The latter gaps are assigned to general/core/input reports. |
| O6_2-PREM-NP-001 | partial | Neusiedlersee and Donau-Auen correctly exclude premium while management obligations remain. Kalkalpen/other are unconditionally allowed by the table consumer; the relevant-management-restrictions condition in the opening source exception is not represented in the input contract. This is a conditional coverage gap, not a claim that every other park has such restrictions. |
| O6_2-PREM-CODE-001 | implemented | The general OP and VF code list is consumed as a parcel premium exclusion. OPUBB/OPBIO do not automatically exclude this separate measure; interpretation and specific other-measure combination restrictions remain separate. |
| O6_2-GEN-MINMGMT-001 | partial | The 85% arable threshold and grassland mowing/removal-or-grazing shape are executable. Dates are counted without the current-year filter; DIV and other source exemptions are ignored; planting/care/harvest for perennial/special crops and ordinary arable sowing/care are not checked. The Bergmähder two-year and nonproduction two-year branches are absent. Missing evidence is explicitly treated favorably in the historical run and needs a separate positive-evidence contract. |
| O6_2-AREA-INC-001 | partial | The monetary consumer uses max(50% of base-2025 area,5 ha), then removes excess area at average net rate after modulation/cap. That allocation is an explicit assumption because parcel selection is not specified by the supplied sources. The contract module owns access/history validity. Equal-rate public controls avoid claiming a disputed mixed-rate allocation oracle. |
| O6_2-FM-001 | external_dependency | The management module implements a specific automatic 2026 drought exception and emits parcel IDs needing an individual application. It does not establish a general force-majeure decision, timeliness or supporting evidence. Underlying GSP rules are referenced but not provided in this source packet. |
| O6_2-PAYAPP-001 | partial | An explicitly absent current payment application gates net premium to zero while gross components may remain estimates. The boolean defaults true under the native convention. More-than-one-year absence is a contract/repayment interface, fully audited by the general/legal peer. |
| O6_2-SANCT-001 | partial | A supplied AMA level maps to the correct percentage, including warning->1% from 2027. Exclusion or two recorded full reductions yields exclusion and repayment. The run does not derive severity from violations, and null means no supplied reduction; this is explicitly external, not a warrant that every violation pays in full. The temporal unit of the full-reduction count is unspecified; a prior-run GSP clarification is outside this packet and must be supplied before app admission, not retroactively used as extraction gold. |
| O6_2-SANCT-ORDER-001 | partial | The executed subsequence is substantive reduction, modulation, parcel cap and access reduction, matching the supplied SRL order. Over/underdeclaration, late submission, conditionality and other listed stages are stored in data only; a complete final payment calculation is not implemented. The native assumptions disclose this. No absent GSP thresholds are invented. |
| O6_2-MOD-001 | partial | The weighted four-tier formula and 220 ha example are correctly executable. The factor uses an asserted land.total_area_ha when positive; Heimfläche/Austrian scope and agreement with the parcel inventory must be established upstream, with a fallback sum excluding alms. This report checks formula/integration and cross-refers the physical-scope core review. |
| O6_2-CAP-001 | partial | The standard year cap is correctly consumed after sanction and modulation. The other-payments scalar must already contain only cap-relevant, modulated payments; its proposed rationale merely says sum of other area payments and omits the source exceptions for measures 6/7 and 10 through 2024 or 1C from 2025. Special cap rows are stored but not selected; normally incompatible same-parcel measures do not independently prove an o6_2 special-cap defect. This is an upstream aggregation/contract gap, not an oracle to sum all grants. |
| O6_2-PAY-001 | partial | max_advance_payment_eur is a 75% estimate. The payment deadline is data only and completed administrative controls are not checked, so the helper does not authorize an actual advance or demonstrate an AMA payout. |
| O6_2-PAY-002 | implemented | The <=50 euro rule is exposed as a discretionary payout_may_be_waived flag and does not automatically zero the amount. This matches the supplied Kann wording. |
| O6_2-DROUGHT-2026-001 | implemented | Automatic harvest relief is restricted to 2026, arable nonmain-forage, drought-caused nonharvestable crop, late-summer/autumn crop and the supplied district list including the August12 Styria extension. It removes only the harvest failure and does not excuse unrelated duties or coding in other measures. |
| O6_2-DROUGHT-2026-002 | partial | Affected arable parcels without the automatic exception are listed for an individual force-majeure application. The consumer does not capture filing, evidence or acceptance and consequently cannot itself grant relief on the basis of such an application. |
| O6_2-DECISION-001 | partial | premium_granted gates the premium primitive using contract/access/exclusion/current payment application; the outer decision additionally zeroes for control refusal. Gross/parcel rates remain component estimates. Whole-decision availability and exact final aggregation are independently checked by core.json, including the no-forage undefined-field issue. |

## Additional source-only duties

These authored audit IDs do not expand the historical rule catalog or count as extracted-rule coverage.

| Duty | Status | Assessment |
|---|---|---|
| O6_2-AUDIT-MINMGMT-PERENNIAL | missing | There is no input or executable check for proper perennial/special-crop establishment, annual care and harvest/removal. Every wine/fruit/hop parcel passes minimum_management_met unless another independent exclusion applies. A missing-duty finding does not invent an orchard harvest-share field contract. |
| O6_2-AUDIT-MINMGMT-EXCEPTIONS | missing | The source-exempt DIV/Mehrnutzenhecken and other listed ecological area classes do not bypass the ordinary 85%/annual management branch. The local minimum-management result is wrong for an otherwise valid source-exempt parcel. This does not establish that the parcel is premium-combinable with measure2: separate table/combination exclusions still apply. |
| O6_2-AUDIT-MINMGMT-BIENNIAL | missing | The general source distinguishes Bergmähder and out-of-production two-year maintenance. No corresponding type/year-history branch exists. This is a coverage limitation; no invented parcel premium entitlement is asserted because premium exclusions and other-measure combinations still govern. |

## Source coverage

| Source section | Page | Status | Assessment |
|---|---|---|---|
| MB1-overview | 1 | reviewed | Overview establishes compensated costs and participating land classes; goals are context rather than independent executable gates. Actual coverage is detailed below. |
| MB1-2-contract | 2 | peer_review | All three start/end/duration rows read; contract implementation is owned by general review. |
| MB2-combination | 2 | peer_review | Mandatory UBB participation and separate biodiversity obligations are distinguished; general/core own admission. |
| MB2-land | 2 | reviewed | All-land fertilizer obligations are independent of premium eligibility. |
| MB2-livestock | 2 | peer_review | Read full definition, current-year changes, included nonpremium forage and all seven named crops; general/table/core own the underlying consumers. |
| MB2-3-N | 2 | partial | Known fertilizer inputs and positive mineral nitrogen checked; provenance defaults require a distinct admission contract. |
| MB3-N-exceptions | 3 | partial | All exceptions read; quantitative biogas equivalence and own-origin interpretation explicitly qualified. |
| MB3-N-residue | 3 | partial | All named residues and wastewater source statements read; table cells co-reviewed, provenance retained as interpretation. |
| MB3-statutory | 3 | external_dependency | Explicit manual reminder; the source packet does not contain the full referenced GSP/MOG regimes. |
| MB3-N170 | 3 | peer_review | 170 limit, losses, proportional alpine/community deduction, current year, no export credit and Austrian units all read; general owns their detailed audit. |
| MB3-PSM | 3 | partial | Application modes checked with the source BIO-treated-seed ambiguity and crop-phase input boundary explicit. |
| MB3-PSM-arable | 3 | external_dependency | Other-crop permission does not establish the actual registry authorization. |
| MB3-4-PSM-code | 4 | partial | Full two-row code table and2026 removal checked; broader pure-BIO PSMCS substitution remains qualified. |
| MB4-PSM-code-events | 4 | catalog_only | No actual event dates or correction record model. |
| MB4-supplies | 4 | partial | All exception conditions consumed as preprocessed positive flags; recorded quantity and actual product authorization remain external. |
| MB4-training | 4 | partial | All course constraints read and checker consumers audited; as-of date, duplicate identity and provider/person factual proof need a contract. |
| MB5-training-person | 5 | reviewed | Before/after deadline distinction preserved. |
| MB5-training-certificate | 5 | catalog_only | Procedural statement retained, not pretended executable. |
| MB5-training-double | 5 | partial | Explicit cross-credit flags checked; no event identity validation. |
| MB5-training-UBB | 5 | external_dependency | The mandatory separate 3h UBB course is not fulfilled merely by topic exclusion in2. |
| MB5-application | 5 | peer_review | All five bullet points read; general peer audits the contract combination and source-version boundary. |
| MB5-fruit | 5 | partial | False excludes but missing/null favorable; quality/group taxonomy separately co-reviewed. |
| MB6-rates | 6 | reviewed | Every category/status/year cell read and actual rate consumer inspected; complete values bound in tables report. |
| MB6-nonlivestock | 6 | reviewed | No current-status-only repayment and no suspension of substantive obligations. |
| MB6-secondcrop | 6 | peer_review | Arable premium and forage denominator distinction inspected by root; actual PSM phase requires extra semantics. |
| MB6-NPF | 6 | unresolved | The native0versusarable-rate open question remains open; year boundary is executable. |
| MB7-RGVE | 7 | peer_review | All20measure rows read, including horse conjunction/disjunction qualifier; data/consumer completeness owned by tables/general. |
| MB8-revision | 8 | context_only | All updates from2023 through 2025 and impressum/disclaimer read; no extra payment gate inferred from publication history. |
| AT6-management | 6 | partial | Complete shared page6 reread against actual module, including exceptions and biennial rules. |
| AT7-parks | 7 | partial | Complete shared page7 reread; park conditions not flattened into universal entitlements. |
| AT17-access | 17 | partial | Complete shared page17 reread; equal-rate source control checks monetary sequence. |
| AT18-sanctions | 18 | partial | Complete shared page18 reread; all levels consumed, external AMA grading and control prerequisite separated. |
| AT19-caps-modulation | 19 | partial | Complete shared page19 reread; cap-exempt schemes and Heimfläche scope are input contracts. |
| SRL22-payment | 22 | partial | Complete shared page22 reread; current application and discretionary minimum use checked. |
| SRL25-order | 25 | partial | Complete shared page25 reread; implemented subsequence distinguished from missing external stages. |
| NOTICE0522 | None | reviewed | Full prior main-content reading reused by exact hash. OPUBB/OPBIO are measure-specific; individual force-majeure channel remains relevant. No universal measure2 exemption inferred. |
| NOTICE0612 | None | not_applicable | Full prior main-content reading reused by exact hash. Rebzikade exit from measure12 does not change measure2. |
| NOTICE0805 | None | reviewed | Relevant harvest-relief section reread in full; all district/crop conditions and individual-application procedure checked. Other cover-crop measures remain out of measure2 scope. |
| NOTICE0812 | None | reviewed | Relevant Styria extension reread; thirdDIVuse/OPUBB/OPBIO and other measure-specific relaxations do not automatically waive measure2 obligations. |

## Probe interpretation

All 25 independent queries completed with OPA return code 0. There are two unmet source-normative expectations (annual cut and the local DIV exemption), two unmet current App positive-evidence expectations (missing harvest and origin), and 21 matching source/boundary/control outcomes. These are diagnostic cases, not a prevalence estimate or an accuracy score.

The embedded JSON preserves each independent input, query, source evidence, expected result, unmodified OPA output and return code. The historical-cut and local-DIV probes test supplied source duties. Missing-harvest and missing-origin expectations are expressly the agreed positive-evidence App admission contract, not invented historical statutory outcomes. The two-full-reduction probe stipulates separate contract years.

The equal-rate calculation control combines a 50% substantive reduction, 220 ha weighted modulation (218 equivalent ha), a 1,300 €/ha cap with 1,270 €/ha other cap-relevant payments, and 5 ha excess access. It expects 30 €/ha after the cap, 600 € before access and 450 € after access. Equal rates remove the disputed parcel-allocation question.

Detailed exact sources, code line bindings and probe results are in `measure.json`. No subsequent measure has been started.
