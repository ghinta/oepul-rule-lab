# Why this adaptation exists

[Issue #97](https://github.com/ghinta/oepul-rule-lab/issues/97) records supported
limits of the Luna candidate. A separate adaptation repairs them while retaining
the historical rules for comparison.

Current stock determines the current rate; dated first-year evidence determines
historical entry. All 20 RGVE categories are used, including small equids and
New World camelids. Cattle need average stock. A valid submitted average takes
priority over reference-date stock for other categories.

Year, snapshot and assessment date must agree. Wrong-year or missing facts
produce `missing_data`. Only confirmed complete empty sets count as zero.
Types remain distinct. Areas come from land classification and actual cutting
records. An estimate is suppressed when required conditions are open or failed.
Normative factors and rates come from bound tables.

There is no blanket drought or force-majeure exemption. Recognition is scoped
to obligation, year, period and parcel; experts must review its legal effect.
“Predominant” is an explicit domain fact, not an invented 92-day rule.

Review #99 added protection for unknown crop codes, nonfinite numbers and exact
obligation-to-source links. Only confirmed `non_fodder` excludes arable land
from the forage denominator. Source, schema, provenance and OPA checks run
locally and in CI. These visible regression cases are not hidden or golden tests.
App integration and full eligibility checks remain separate work.
