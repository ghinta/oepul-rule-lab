# o6_3 raw Opus source audit: obligations and premium

Frozen historical run `v2-o6_3-opus-5.5-high-20260930` at `e009eed4a83ff076b26eba33ac433ac2b0642621`. Audit and collection only; no source, policy or profile changes.

All six pages of the new October 2025 Heuwirtschaft original were read, including the premium and RGVE tables, warnings and updates. Both assigned modules were read in full. Seven shared sources are reused by their exact previously read hashes; relevant source clauses and actual current consumers were rechecked. No manual adaptation, study cases, reference answers or adaptation tests were read.

This part contains 39 historical rule assessments, one separately labelled source-only duty, 39 source-coverage entries, six collected finding groups and 29 fresh public development probes.

All 29 OPA executions returned code 0. There are 27 matching source/boundary controls and two unmet source expectations: the VF experiment exclusion and the cap check after modulation. This diagnostic set is not an accuracy estimate or an expert acceptance.

Raw premium components remain distinct from a final payable amount. The absence of integrated sanctions and cap reductions is documented without changing the stated meaning of `premium_after_modulation_eur` or assuming that every content violation requires zero payment.

## O6_3-MEASURE-01 — Full-area mowing and removal of cut material are not represented

`MISSING_EVIDENCE` · high · source_coverage_or_semantics

cutting_dates and a grazed boolean can show some operation, but neither establishes the source full-area operation or removal of cut material. The ordinary ecological exemptions are also absent. A source-only exemption does not establish premium combination eligibility. The separate date-history error is owned by core.json.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 6: “jährlich mindestens einmal vollflächige Mahd und Verbringen des Mähgutes oder”.

Code: `workspace/policy/o6_3/obligations.rego:100`, `workspace/policy/o6_3/common.rego:32`.

## O6_3-MEASURE-02 — Green-feeding counters cannot establish distinct days for every animal

`EVENT_SEMANTICS` · medium · input_contract_gap

Adding home and communal/alpine day counts works only after an upstream disjointness/per-animal calculation. The input contract lacks intervals or identities to validate that premise. Actual haymaking and the fresh-crop rapid-processing conditions are also not represented by the checker. This is a proof/input-contract limitation, not an invented numerical oracle for unknown overlap or a required hay-feed ratio.

Source: `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, page 3: “Die Heugewinnung muss mit Grünfütterung in Form von Eingrasen oder Weide im”.

Code: `workspace/policy/o6_3/obligations.rego:24`.

## O6_3-MEASURE-03 — VF experiment code is not consumed as a premium exclusion

`TABLE_CONSUMPTION` · high · source_coverage_or_semantics

premium_parcels reads OP codes and noneligible classifications, but not VF. A mown experimental parcel carrying the source-required VF code can remain premium-eligible unless it is redundantly labelled as a noneligible type. The source explicitly gives no current-year premium for VF experiments.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 7: “des Mehrfachantrages mit dem Code VF zu versehen. Für diese Flächen werden im laufenden Antragsjahr keine Prämien gewährt.”.

Code: `workspace/policy/o6_3/premium.rego:37`, `workspace/policy/o6_3/premium.rego:78`.

Probe: `o6_3-vf-code-premium-exclusion`.

## O6_3-MEASURE-04 — Cap warning uses the raw rate before modulation

`TABLE_CONSUMPTION` · medium · source_coverage_or_semantics

The helper compares the raw 145.8 €/ha with other capped payments instead of the post-modulation rate. A 220 ha farm with 1155 €/ha of already modulated cap-relevant other payments is falsely flagged:1155+145.8×218/220=1299.4745…<1300. The helper is also not used to cap an amount. This is an effective-cap diagnostic, not a claim that the named after-modulation estimate is final payout.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 19: “Es gelten folgende Prämienobergrenzen für die Summe der flächenbezogenen Zahlungen”.

Code: `workspace/policy/o6_3/premium.rego:172`.

Probe: `o6_3-cap-after-modulation-boundary`.

## O6_3-MEASURE-05 — Final sanctions, caps and payment stages are not integrated

`PAYMENT_GATING` · high · app_admission_and_external_dependency

premium_after_modulation is correctly named as a component; it multiplies gross by modulation but does not apply sanction_share or cap a parcel amount. The decision exposes this estimate, and the advance/de-minimis helpers depend on it. A final payable amount cannot be obtained from these components without external remaining stages. No numeric expectation rewrites the raw component definition, and no automatic 100% reduction is inferred merely from a violation.

Source: `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, page 25: “Inhaltliche Kürzungen gemäß Punkt 1.12.1.3,”.

Code: `workspace/policy/o6_3/premium.rego:109`, `workspace/policy/o6_3/general.rego:100`.

## O6_3-MEASURE-06 — Incoming previously enrolled grassland has no distinct access credit

`MISSING_EVIDENCE` · medium · input_contract_gap

The source exempts land already in the same measure from access. The formula caps all premium grassland against actual 2025base without a separately represented incoming-already-enrolled credit. Native assumptions tell callers to incorporate it into base/current figures, but the proposed fields are historical factual areas. Admission needs an explicit effective-base/history contract; do not silently change actual 2025 hectares or manufacture a source oracle when this fact cannot be encoded.

Source: `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, page 17: “Wenn die hinzugekommenen Flächen bereits vorher mit der gleichen Maßnahme belegt waren, handelt es sich nicht um einen Flächenzugang im Sinne der Bestimmung.”.

Code: `workspace/policy/o6_3/premium.rego:88`.

## Historical catalog ledger

| Rule | Status | Assessment |
|---|---|---|
| O6_3-OVR-01 | implemented | Premium categories require mowing and the rate table differentiates livestock status and the no-conditioner option. The overview describes compensated practice; it does not itself supply an additional numerical mosaic-pattern threshold. |
| O6_3-LH-06 | implemented | A second arable forage crop is excluded from premium_area_class; the independent livestock consumer also excludes it from density area. The current crop and second-crop identity are upstream structured inputs. |
| O6_3-OBL-01 | partial | Explicit silage production or feeding flags create whole-farm violations without a species exception, matching the source scope. These booleans must summarize every unit, including distant buildings and non-RGVE species. Absence of a flag is no positive proof of compliance, and the violation collection does not certify an unreported farm. |
| O6_3-OBL-02 | implemented | The positive foil-dependent pressing flag produces the source prohibition. Actual storage suitability is an externally established factual classification, not inferred from a feed label. |
| O6_3-OBL-03 | partial | An occurred fermentation flag is executable. The permitted fresh-crop/immediate-use/rapid-transport/drying/pelletisation-for-own-farm conditions are stored in data but have no corresponding facts or workflow checker. No evidence of prevention is established by the absence of a past fermentation event. |
| O6_3-OBL-04 | partial | The prohibited example IDs and an explicit production-fermentation flag are consumed; the permitted examples are data/context and are not a blanket override when actual fermentation is declared. IDs and user product names require consistent classification. Whether any unlisted processing product fermented is an external factual input. |
| O6_3-OBL-05 | partial | The native convention uses >50% of 183 days (92 integer days), sums home grazing/cut-and-carry with communal/alpine days, and requires the all-roughage-animals flag. The two counters contain no interval identity or per-animal exposure, so distinct eligible days and duration for every animal must be validated upstream. Actual haymaking is not separately represented. Daily minimum duration remains expressly open in the native assumptions; no unsupported daily-hours threshold is invented. |
| O6_3-OBL-06 | partial | Silage storage and using up own stock create violations. The stock-use flag expressly refers to after contract start; storage itself has no event date or active-contract guard, so a caller must bind these annual facts to the applicable commitment period. No statutory prohibition before the contract is inferred. |
| O6_3-OBL-07 | implemented | Every listed transfer whose form is not dry_hay is rejected. Dry hay is allowed without restrictions on the recipient later making pellets, compost or biogas. The input list must represent actual transfers to third parties, separately from temporary transport for own-farm processing. |
| O6_3-OBL-08 | implemented | A transfer with the once-tedded-then-removed flag produces the specific prohibition even if the form is otherwise labelled dry hay. This is a directly represented source practice, not a minimum drying-duration invention. |
| O6_3-OBL-09 | implemented | A transfer indicating use as silage creates the source prohibition, including use outside the farm. The factual evidence for the indicator must be established upstream. |
| O6_3-OBL-10 | implemented | Green-fodder transfer to another hay farm produces the specific violation; it is also covered by the general non-dry-hay transfer prohibition. Reporting both IDs reflects separate source clauses, not duplicate numerical sanctions. |
| O6_3-OBL-11 | implemented | The haylage/fermented-hay production flag generates the source prohibition. A corresponding prohibited feed ID additionally detects its use in the feed checker; these are distinct production and feed facts. |
| O6_3-OPT-01 | implemented | When the option is requested, using a conditioner or having one present generates an option violation. The source requires a whole-farm prohibition for both fresh feeding and hay harvest. The native question about a retired but present unit is preserved rather than silently exempted. |
| O6_3-OPT-02 | external_dependency | The definition is represented through two preclassified machinery booleans; no device inventory tests whether a combined or separate machine crushes, kinks or shreds cut material. This can be an admitted expert assertion, but the definition is not automatically derived by the consumer. |
| O6_3-PREM-01 | implemented | All rate rows are consumed by year, livestock boolean and active option. Component rates are distinct from compliance and payment authority; requesting an option and violating it does not by itself alter the raw rate helper. Table values and option admission are independently reviewed by peers. |
| O6_3-PREM-02 | partial | Eligible categories correctly require mowing, exclude second arable crops and use the grassland/forage eligibility lists. is_mown only counts cutting_dates, with no year, full-area or material-removal evidence; the core review owns the independent current-year probe. OP, land-type, park and combination consumers then apply. The table review separately covers the missing Acker-DIV combination restriction. |
| O6_3-PREM-03 | implemented | Later-year nonlivestock status makes the rate zero, without automatic repayment for former livestock years; obligations_apply still follows a numeric contract start. This is a raw obligation/applicability indicator, not proof that every current-year obligation was checked. Detailed start/exit scope is owned by general/core. |
| O6_3-PREM-04 | implemented | Eligible premium area is multiplied by the raw rate and rounded to cents, gated by premium_payable_year. The original source worked example is independently reconstructed by core. Later modulation is a separate component; the source example does not specify a general statutory rounding algorithm. |
| GEN-MBK-01 | partial | The checker tests any mowing or grazing for ordinary forage land, and mowing this or the previous year for Bergmähder. Full-area operation and removal of cut material are not represented. The source ecological exemptions are not applied. Current-year cutting_dates are not enforced; core supplies the date-history probe. The two-year Bergmähder shape is an improvement over the previous run but still lacks removal/full-area proof. |
| GEN-AREA-01 | partial | The complete named noneligible-type list is consumed, conditional on correct upstream classification. VF is not inspected directly from oepul_codes; unless independently classified as experiment, a VF parcel can escape this exclusion. The source requires no current-year premium on such parcels. Reference correctness/active agriculture/public overlap require independent factual evidence. |
| GEN-AREA-02 | partial | Both relevant national-park management restrictions and the two generally excluded park names are consumed, an improvement over measure2. However, the stored Neusiedler See–Seewinkel name differs from the source literal Neusiedlersee and matching is exact; the table report owns the source-literal input-contract probe. Missing restrictions default false and cannot establish positive admissibility. |
| GEN-OP-01 | partial | General OP and the generic measure-specific op_measures containing o6_3 exclude the parcel. The source circumstances that require OP are not independently derived. A caller must not infer year-long compliance solely because no OP code was supplied. |
| GEN-OP-02 | partial | A supplied measure-specific OP marker excludes premium. Evidence retention, pure third-party causation, correction and self-report timing are not modeled; the sanction helper does not derive the source lesser-sanction consequence. |
| GEN-OP-03 | implemented | An OP marker limited to another measure does not exclude this measure; only general OP or op_measures containing o6_3 is read. No official o6_3-specific public code name is invented. |
| GEN-DUR-01 | partial | A supplied OP marker can express failure over the commitment period, but parcel transfer dates and continuation by the successor are not independently checked. Contract-year scope is handled elsewhere. Mere current mowing does not establish a full calendar year of obligations. |
| GEN-CP-03 | implemented | Arable premium area is computed anew each year without applying the grassland access limit. This implements variable annually available arable hectares; the count still depends on actual current-year mowing and correct crop/second-crop identity. |
| GEN-EXIT-01 | partial | obligations_apply requires only a numeric contract start and has no exit cutoff. It is a broad indicator, while the premium primitive consumes exited_without_recognition. Source timing and whole-contract consequences are audited in the general report; this module alone cannot establish compliance up to a particular exit date. |
| GEN-COMB-02 | partial | Sparse nonempty combination cells and the explicit UBB/BIO alias set are consumed to exclude incompatible parcel measures. Header/measure-specific conditions are not automatically enforced; the table peer documents the Acker-DIV restriction and complete matrix values. A stored x marker is not unconditional premium authority. |
| GEN-AREA-INC-01 | partial | From 2026, grassland premium area is capped at base 2025 plus max(50%,5ha); arable area is unaffected. Missing/null base falls back to unrestricted premium area. Already-enrolled incoming land is exempt in the source, but no separate credit/history input exists. Native assumptions demand prior enrollment be reflected in the base/current figures; the proposed field names describe actual historical areas, so that preprocessing contract needs clarification rather than silently rewriting history. |
| SRL-PAY-02 | partial | The discretionary <=50 euro helper is based on premium_after_modulation, not on an amount after every applicable sanction/cap/access stage. It correctly does not automatically zero the amount, but cannot establish the final payout de-minimis decision while later stages are absent. |
| GEN-CAP-01 | partial | The helper reports a parcel ID above the cap but does not cap a payment amount. It compares other capped payments plus current raw rate, before modulation or any substantive reduction, contrary to the stage order if it is interpreted as an effective-cap decision. The excluded-payment schemes must be removed upstream; their table list is not consumed. Special cap types incompatible with3 do not alone establish an additional payable3 entitlement. |
| GEN-MOD-01 | implemented | The weighted four-tier formula is consumed and premium_after_modulation rounds its product to cents. The asserted total must be Austrian Heimfläche, excluding separately modulated alms; native assumptions say this but do not derive the inventory. Type/null and physical-scope checks are separate core/input concerns. |
| NAT-GM01 | implemented | The 108 euro value is exposed as an informational unit surcharge when farm participation in3 exists. It does not add a Naturschutz parcel payment to the measure 3 premium or establish that a specific parcel has GM01. Complete row values are checked by the table peer. |
| GEN-SANC-02 | partial | The reduction-order list is data only. premium_after_modulation performs gross-times-modulation; sanction_share and cap_for are not used to derive a final net payment. Access area is restricted before gross. This component must remain labelled an estimate; no numerical source oracle overwrites its accurately named after-modulation meaning. |
| GEN-PAY-01 | partial | The general module formats the deadline and computes 75% of the after-modulation component. Completed administrative controls and final net reduction stages are not checked, so the result is an advance estimate, not authorization for an actual payment. |
| SRL-ACC-01 | partial | premium_payable_year consumes current access checks for first/later years, but reconstructed historical establishment is not proven in later years. The general/core audit owns start-year/history correctness. This consumer is not an independent source of contract validity. |
| SRL-ZA-01 | partial | An explicitly absent current payment application blocks the gross component. More-than-one-year absence generates repayment elsewhere but is not directly among premium_blocked causes; legal/contract evaluation is owned by the general peer. |
| SRL-VOK-01 | partial | The gross premium is blocked when control_refused is true. The general peer audits refusal exceptions and contract recovery consequences; this module does not independently assess recognized force-majeure coverage. |

## Additional source-only duty

These authored IDs do not expand the historical rule catalog or its extracted-rule coverage.

`O6_3-AUDIT-MBK-ECOLOGICAL-EXEMPTIONS` (missing): The supplied general source exempts listed ecological areas from ordinary minimum-management criteria and instead applies their respective measure duties. The generic forage-land branch does not inspect those statuses. This is a source-only clause omitted from the native minimum-management catalog statement, and does not establish that an exempt parcel is premium-combinable with3.

## Source coverage

| Section | Page | Status | Assessment |
|---|---|---|---|
| MB1-overview | 1 | reviewed | Complete page read. Overview and aims distinguished from independent numerical gates. |
| MB1-contract | 1 | peer_review | All three contract rows and one-calendar-year option read; general owns exact contract admission. |
| MB2-combination | 2 | peer_review | Whole source clause including BIO partial farm read; companion measure admission belongs to general. |
| MB2-minimum | 2 | peer_review | 2 ha, excluded Streuwiesen/Bergmähder, included Naturschutz and later-year exception read. |
| MB2-livestock | 2 | peer_review | First-year-only access,0.30 threshold, all forage including NAT/Bergmähder and seven named cultures read. |
| MB2-3-silage | 2 | partial | Positive whole-farm booleans consumed; scope must include every species/unit. |
| MB3-foil | 3 | reviewed | Exact pressing prohibition represented. |
| MB3-greenprocessing | 3 | partial | Permitted routes read completely, but only fermentation occurrence is executable. |
| MB3-products | 3 | partial | All prohibited/permitted examples read; actual processing evidence is an external input. |
| MB3-greenfeeding | 3 | partial | All sentence conditions read;183 days and92-day threshold are native interpretation, overlap/per-animal coverage unvalidated. |
| MB3-storage | 3 | partial | Both storage and stock usage checked as flags; binding to active period is a caller contract. |
| MB3-transfers | 3 | reviewed | Dry-hay transfer distinguished from permitted later reuse and own-farm temporary processing. |
| MB3-tedding | 3 | reviewed | Specific positive practice flag is executable. |
| MB3-silage-inference | 3 | reviewed | Positive factual silage-use indicator consumed. |
| MB3-hayfarms | 3 | reviewed | Specific prohibition preserved alongside general dry-hay restriction. |
| MB3-haylage | 3 | reviewed | No exception for fermented hay; production and feeding are distinct inputs. |
| MB4-option | 4 | partial | Use and presence checked, including fresh feeding; machine classification preprocessed. |
| MB4-application | 4 | peer_review | All four bullet points read, including 2025 measure and 2028 option last entry; general audits admission. |
| MB4-rates | 4 | reviewed | All category/year/livestock/option cells read; complete values also crosschecked by tables peer. |
| MB4-status | 4 | reviewed | Rate effect separated from ongoing duties and contract scope. |
| MB5-example | 5 | peer_review | 8 ha mown + 2 ha pasture + 3 ha forage / 5 RGVE example read; root owns independently derived full calculation control. |
| MB5-secondcrop | 5 | reviewed | Both no premium and no forage denominator credit read and actual consumers checked. |
| MB5-RGVE | 5 | peer_review | All cattle/dwarf/sheep/goat/horse rows and both horse weight/height qualifiers read; tables/general own factors and classification. |
| MB6-RGVE | 6 | peer_review | All deer/camelid/young-game rows read; table continues across page boundary. |
| MB6-updates | 6 | context_only | All revision bullets and legal disclaimer read. Publication metadata is not treated as an additional eligibility gate. |
| SRL50 | 50 | reviewed | Complete shared SRL page 50 reread, including support/access/four obligations/option/rate table. No source version conflict identified beyond infosheet added detail. |
| AT6 | 6 | partial | Complete shared page6 reread, including ecological exemptions and alternative measure duties. |
| AT7 | 7 | partial | Complete shared page7 reread; source-requiredVF marker absent from code consumer. |
| AT8 | 8 | partial | Complete shared page8 reread; supplied codes consumed but required causes/corrections not independently established. |
| AT10 | 10 | partial | Complete shared page10 reread; no parcel continuation-event model. |
| AT17 | 17 | partial | Complete shared page17 reread; already-enrolled incoming credit needs a factual history contract. |
| AT19 | 19 | partial | Complete shared page19 reread and actual staged consumers checked. |
| SRL22 | 22 | partial | Complete shared page22 reread; current payment gates and raw advance estimates separated. |
| SRL25 | 25 | partial | Complete shared page25 reread; staged final amount not implemented by premium consumer. |
| AN68 | 68 | reviewed | Current GM01 clause and actual helper rechecked after exact-hash shared-source reuse;108 €/ha remains an informational unit value, not automatic measure 3 premium. |
| NOTICE-2026-05-22 | None | peer_review | Complete prior main-content reading reused by exact SHA256. May22 provides only a general application/control context, not automatic Heuwirtschaft relief; June12 belongs to12. August5/12 other-measure relaxations do not silently change3 obligations. Root owns recognized-force-majeure application coverage. |
| NOTICE-2026-06-12 | None | peer_review | Complete prior main-content reading reused by exact SHA256. May22 provides only a general application/control context, not automatic Heuwirtschaft relief; June12 belongs to12. August5/12 other-measure relaxations do not silently change3 obligations. Root owns recognized-force-majeure application coverage. |
| NOTICE-2026-08-05 | None | peer_review | Complete prior main-content reading reused by exact SHA256. May22 provides only a general application/control context, not automatic Heuwirtschaft relief; June12 belongs to12. August5/12 other-measure relaxations do not silently change3 obligations. Root owns recognized-force-majeure application coverage. |
| NOTICE-2026-08-12 | None | peer_review | Complete prior main-content reading reused by exact SHA256. May22 provides only a general application/control context, not automatic Heuwirtschaft relief; June12 belongs to12. August5/12 other-measure relaxations do not silently change3 obligations. Root owns recognized-force-majeure application coverage. |

## Probe boundaries

All inputs, queries, expectations, exact source evidence and unmodified pinned-OPA observations are embedded in `measure.json`. Original policy and data directories were loaded together to preserve the native `data.o6_3` package and data namespace.

The green-feeding controls derive the 91/92-day boundary independently from a majority of the 183-day period. The communal/alpine credit control explicitly stipulates disjoint eligible days for all roughage animals; it does not claim that the native counters can verify that premise. No unsupported minimum daily duration is imposed.

The cap probe stipulates 220 ha of Austrian Heimfläche, 70 RGVE, 2 ha of mown premium area and 1,155 €/ha of already modulated cap-relevant other payments. The source-order result is 1,155 + 145.8 × 218/220 = 1,299.4745… €/ha, below 1,300. The raw-rate comparison nevertheless flags P1.

The root review owns the current-year mowing-date pair and the source worked example; table review owns DIV and park-name consumers; general/legal review owns contract, livestock and sanction-history admission. Their cases are not duplicated here. GSP-AV and MOG were absent from this historical source packet. No subsequent measure was started.
