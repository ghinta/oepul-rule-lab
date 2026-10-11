# Supplemental AMA capture — 11 October 2026

Seven selected originals were fetched again on 11 October 2026 through the existing
`manage_sources.request` / `pdf_response` implementation and archived with
`import_original`. Fresh raw AMA legal, lists and 2026 notices indices confirm
every exact selected target URL. HTTP response observations are separate from the
truthful import records; `import_original` still makes no HTTP acquisition claim.

The immutable capture report contains each original capture pin, its matching raw
index observation, actual UTC retrieval time and response metadata:

`sources/oepul/provenance/supplemental-ama-20261011T071757662245Z/capture-report.json`

SHA-256: `0d7e3376810fffb73de5dcb09bba21095146d338cbcf4d68c2717e428df00c15`

| Selected original | Pages | SHA-256 | Comparison with 10 October capture |
| --- | ---: | --- | --- |
| `wrrl_programme` | 11 | `d96e759017f5d19721c02fec78050fda9914beaa742c9d747e4e366495093338` | Identical bytes |
| `wrrl_annex3` | 6 | `a8e3350cc070209213513f1e7711ec71dddb7f842f0c65eb92957bedc0f209d2` | Identical bytes; prior scoped review reusable |
| `training_providers` | 2 | `81f82e2f676f51a4359a3b43e622891ee92697501e2ffe2709859c7c1ac32199` | Identical bytes; prior scoped review reusable |
| AMA `gsp_av` mirror | 94 | `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10` | Identical bytes |
| AMA `napv` mirror | 42 | `6bec588cc818a8e6620f9abda47c4de0489e4cc65bdd20466595722ac0e0fc92` | Identical bytes |
| Groundwater recordkeeping notice, published 25 August 2026 | HTML | `b08d0dc7e0907586fdfd75f35ad2deabbe832058c029e8582528689573e43481` | Identical bytes |
| Animal reporting notice, published 2 September 2026 | HTML | `4c682af3dd6c47f5819b38d456573f8a501f486b4b2820082e216b885c9c4d04` | Identical bytes |

Original retrieval times are 07:17:59–07:18:00 UTC on 11 October 2026. Raw index
bytes are also identical to the historical snapshots, but the report and new
import records carry the actual fresh observation times. Historical originals,
capture records and reviews remain unchanged.

`source_intake.verify_capture` passed for all seven fresh captures. Each pinned
raw index was checked for the exact original target URL, and both additional
notice publication dates were confirmed in the respective current index links.
`source_intake.verify_review` passed for the existing WRRL Anlage 3 and provider
reviews after binding them to the freshly captured, identical originals. Their
review files and independently established inventories remain in `reviews/20261010/`
with their original dates and hashes.

The AMA GSP-AV and NAPV mirrors remain dated publisher copies; their current AMA
links do not establish legal consolidation completeness. RIS reconciliation,
remaining scoped reviews, expert admission and rule implementation are separate.
This capture report claims neither legal completeness nor completion of the full
source intake.
