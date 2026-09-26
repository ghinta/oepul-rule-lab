# Assumptions and unresolved implementation boundaries

- The rule engine uses the proposed `o6_1c.parcels` extension in discover mode. The canonical profile is intentionally untouched; the parallel parcel-level proposal documents the same field facts for a future canonical integration.
- The source expresses the 50% late-mowing requirement across all NPA, and the at-least-once-every-two-years duty across years. Those cross-parcel and cross-year aggregates are catalogued but are not mechanically derived by the supplied single-year profile; the input extension records the facts needed for a future aggregate check.
- The actual premium within each stated band depends on total claimed area and available budget. Rego returns the legal band and computes only the separate farm-size modulation factor; it does not invent an allocation algorithm.
- The 2026 notices concern UBB/BIO biodiversity, insecticide avoidance, cover crops, erosion control, nature conservation or animal measures. No notice changes an O6_1C obligation in the supplied sources; they are recorded as reviewed but not measure rules in coverage.
