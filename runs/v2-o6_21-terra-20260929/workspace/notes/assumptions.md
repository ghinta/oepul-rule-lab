# Assumptions and unresolved implementation limits

- The source requires actual Rinderdatenbank histories. The policy therefore consumes already-calculated annual-average RGVE and category eligibility facts; it does not reconstruct individual daily histories.
- A qualifying open-stall building, milk delivery including seasonal alp delivery, Qplus evidence, and compost method/documentation require evidence fields not present in the canonical profile. They are proposed only in `rules/profile_changes.json`.
- The 2026 notices supplied with this run do not alter measure o6_21. They concern biodiversity areas, insecticide abstinence, harvest/greening or other named measures; this non-applicability is recorded in the coverage ledger.
- The information sheet gives detailed arrangements for an alternative unturned compost mixture; the boolean `eligible_unturned_mixture_from_2025` is deliberately an evidence-backed input rather than an automated agronomic determination.
