# Independent original workbook inventory — 2026-10-11

The independently established inventory is
`sources/oepul/reviews/20261011/premium_rates.inventory.json`. It binds only to
the complete, 95,793-byte ministerial XLSX with SHA-256
`2750d4f96ef0007c05ba0bfbcdee08f6a46418bea3c038de33bd07e9ec39ad02`, archived at
`sources/oepul/supplemental/premium_rates/2750d4f96ef0007c05ba0bfbcdee08f6a46418bea3c038de33bd07e9ec39ad02/OEPUL_Praemiensaetze_ha_ab_2024_final_und_ab_2025.xlsx`.
The ministerial index actually linked the following original when captured:

- [Ministerial ÖPUL index](https://www.bmluk.gv.at/themen/landwirtschaft/gemeinsame-agrarpolitik-foerderungen/nationaler-strategieplan/foerderinfo/sonderrichtlinien-2023-2027/agrarumweltprogramm-oepul-ab-2023-inklusive-oekoregelungen.html)
- [Ministerial original XLSX](https://www.bmluk.gv.at/dam/jcr:67b453b5-a56e-423d-ba95-342521be6f53/OEPUL_Praemiensaetze_ha_ab_2024_final_und_ab_2025.xlsx)

The initial independently inspected original probe record is stamped
`2026-10-11T07:13:29.859563+00:00`. The existing source manager subsequently
captured byte-identical original content at `2026-10-11T07:17:09Z`; its actual
index/original HTTP evidence is
`sources/oepul/provenance/premium-bmluk-20261011T071706373952Z/capture-report.json`.
The original used for this repository inventory is the latter archived original.

## Independence and boundaries

This work read every populated original worksheet cell, all six worksheet
OOXML parts, the shared-string table, workbook sheet states and print
metadata. The expected coordinates and note selection were established
without viewing any premium extraction artifact or historical premium inventory.
The item boundaries are original cell coordinates and original merged ranges,
not inferred business rules or grouped measure-level rates.

A populated cell means a raw OOXML cell containing a value, inline string or
formula. This includes numeric zero, newline-only text and values stored
under a merge; formatting-only blank XML cells are not populated items. All
214 merged ranges are retained, including their empty anchors, because merging
establishes the source table layout and heading/group relationships. Every
populated item has ID `sheet:<original-name>:cell:<coordinate>`; every merged
layout item has ID `sheet:<original-name>:layout:<range>`. Every original note
cell is also expected under `sheet:<original-name>:note:<coordinate>`.

| Original worksheet | State | Raw populated cells | Cells returned as occupied by openpyxl | Merged ranges |
| --- | --- | ---: | ---: | ---: |
| OEPUL_Prämiensätze ab 2024-25 | visible | 677 | 677 | 95 |
| Prämiensätze_Naturschutz_Alm | visible | 45 | 45 | 4 |
| Prämiensätze_Naturschutz | visible | 741 | 741 | 27 |
| Prämiensätze_EBW | visible | 526 | 526 | 26 |
| ÖPUL_2015_Prämiensätze | hidden | 303 | 287 | 57 |
| ÖPUL_2007_Prämiensätze | hidden | 341 | 341 | 5 |
| Total | | 2,633 | 2,617 | 214 |

The expected inventory therefore contains 2,847 unique item IDs and 14 unique
note IDs. Populated source cells comprise 1,356 text cells, 991 numeric cells
and 286 formula cells. The bounded rate-grid inventory records 580 original
blank coordinates separately; heading-row blanks within these grids are also
retained, without classifying them as payable rates. A review must preserve
this blank metadata as well as item-ID coverage. Print areas do not filter
source content: the `Prämiensätze_Naturschutz` print area ends at column E,
while F8 and its populated 2025 cells are part of the original. Four stored
2007 cells, IJ51/IK51/IN51/IO51, lie outside that hidden sheet's print area and
are included.

## Notes, conditions and units

Explicit note/annotation cells are:

- Main sheet: A216, A217 and A218. Together they state eco-scheme allocation
  within the premium bands, distribution according to claimed area/GVE and
  the guaranteed printed minimum.
- EBW sheet: S27 and S28, the original correction/ceiling and 8-percent
  annotations.
- Hidden 2015 sheet: A132 and D133, the original version note and attribution.
- Hidden 2007 sheet: A179–A184 and E185, all five numbered notes (note 1
  spans two cells) and attribution.

All row-embedded conditions remain original occupied-cell items. These include
land-area caps, slope and soil-quality classes, livestock thresholds, crop
lists, quantity and participation limits, units per hectare/animal/RGVE/GVE/
cubic metre/hive/farm, year-specific additions, regional limitations and project
references. The full main D/E/F columns, every Naturschutz code row and group,
all nine Alm NAW/NAD/NAB levels and both historical/new EBW matrices are in
scope. The 2024/2025 Braunkehlchen distinction and EBBA02 ab 2025 remain explicit.

Examples of source-limited regional/project content are main B161 (listed
states and Gebietskulisse), C165 (Oberösterreich top-up), C167 (Wien), B169
(the restriction through 2024), C178 (Projektbestätigung), C181 (area-specific
objectives/indicators), B179/B182 (regional nature-conservation plan), and C212
(Graz–Bad Radkersburg). Naturschutz C24 references an Artenschutzprojekt;
C144 names the Heidelerche project in Waldviertel/NÖ and Mühlviertel/OÖ;
C146/C147/C148 retain original `$` placeholders; C153 retains the full
Großtrappenschutz obligations and references to the responsible regional body.
These are examples, not an alternative to the exhaustive cell inventory.

The main and two historical sheets retain their original Grünen Bericht 2023
header and ministry attribution footer in sheet metadata. The archive contains
no comments, drawings, hyperlinks or external-link parts and no hidden
rows/columns. Main-sheet conditional formatting compares with the literal
markers `!` and `x`; it supplies no separate rate amounts or rate formula.

## Original anomalies and completeness limits

The raw XML check found 16 stored strings masked by openpyxl on the hidden 2015
sheet: D35/D42/D49/D59/D62/D69/D72/D77/D84/D92/D94/D96 contain `Ausgenommen
Ackerfutter`, while D118/D121/D124/D130 contain `Variante D.1 winterhart`.
They are inventoried as stored, non-displayed historical source content.
Their apparently unrelated wording is not a new eligibility condition.

The main E160/E170 and Naturschutz E171 formulas reference original blank
D160/D170/D171 cells and have cached zero values. They sit on heading rows;
the inventory records them as original anomalies, without treating them as
zero-rate facts. OOXML shared formulas require expansion from their anchor;
an empty shared-formula `<f>` node does not mean a blank formula. A review
must retain original formula storage/expanded formula and cached source values
without recalculating them or replacing manually specified rates.

Original blank, zero, slash, dash, whitespace and merged-subordinate states
are distinct. No missing 2025 value is forward-filled from 2024. No premium
bands are collapsed to one guaranteed payment or interpreted as permission
to add component premiums. Hidden 2015/2007 content remains historical.

**The captured workbook inventory is complete; the broad `premium_rates`
intake scope remains pending.** Its requirement includes the ministerial
workbook and any needed clause/project/regional rate tables, units, ceilings
and notes. The workbook alone does not prove current 2026 legal applicability,
all SRL clause-to-rate mappings, the external regional Gebietskulisse, individual
Projektbestätigungen, unresolved project placeholders or later applicable
amendments/notices. This inventory does not establish that all such evidence
is contained in this workbook or that no supplementary source is needed.
The broad scope must retain `review: null` until that mapping/completeness
proof exists; the exhaustive workbook artifact may be reconciled and documented
independently without promoting the whole premium scope.

## Verification

Checks against the archived original established six unique worksheet names,
2,633 unique raw populated coordinates, 214 unique merged ranges and 14
nonempty original note cells. All expected note coordinates also occur among
the expected occupied-cell IDs. Raw OOXML and the workbook API agree after
accounting for the 16 masked merge-subordinate strings. All 286 formula cells
have original cached values. The three blank-operand heading formulas, four
off-print 2007 cells and every original blank in the declared rate grids are
explicitly retained. The inventory is source-bound and contains no executable
rule or claim of legal completeness.
