# Findings and next decision

All 26 candidates compile in isolation. Of 78 synthetic development cases,
76 return a native value and two return no value. These are execution counts,
not an accuracy score. See the [full report](README.md), [preview](index.html)
and [method](method.md).

| Observation | Development cases | Consequence for a limited app preview |
| --- | --- | --- |
| Whole query is undefined | [o6_8 variation](results/o6_8.json), [o6_17 missing_fact](results/o6_17.json) | Show the missing output; infer neither approval nor rejection. |
| Positive partial result coexists with a violation | [o6_9 missing_fact](results/o6_9.json), [o6_11 variation](results/o6_11.json), [o6_17 variation](results/o6_17.json) | Show scope, partial results and violations separately. Do not use `eligible` alone. |
| A positive result survives a missing fact | missing_fact in [o6_6](results/o6_6.json), [o6_7](results/o6_7.json), [o6_12](results/o6_12.json), [o6_14](results/o6_14.json), [o6_16](results/o6_16.json), [o6_19](results/o6_19.json), [o6_23](results/o6_23.json), [o6_24](results/o6_24.json) | Check input completeness separately; this observation alone gives no expert judgement. |
| Negative result has no matching missing-data reason | [o6_3 missing_fact](results/o6_3.json): `eligible=false`, `violations=[]` | Keep unknown facts separate from known failure. |
| Payment arithmetic continues despite violations | variation in [o6_3](results/o6_3.json): EUR 1,674; [o6_11](results/o6_11.json): EUR 162; [o6_15](results/o6_15.json): EUR 243; [o6_21](results/o6_21.json): EUR 972 | Label these as native calculated values, not approved payments. |
| Missing input silently changes a rate | [o6_10 missing_fact](results/o6_10.json): missing slope, EUR 324 → 216 | Do not treat a default as confirmed domain evidence. |
| Data reference gives an empty payment map | [o6_14 baseline](results/o6_14.json): `premium_base={}` | Resolve data namespaces before displaying a payment. |
| Native output is only a Boolean | [o6_1b](results/o6_1b.json), [o6_22](results/o6_22.json) | Record missing reasons/overall decision as integration gaps. |

Next, choose a small set of relevant rule forms: threshold, time condition,
closed list/mapping, aggregation and exception. Keep all 26 measures' catalog
types and dependencies visible; do not select by a ranking of favorable outputs.
Then create independent cases and expert-confirmed expected decisions.
A full app is not needed for this step. Opus follow-up is tracked in
[Lab #107](https://github.com/ghinta/oepul-rule-lab/issues/107).
