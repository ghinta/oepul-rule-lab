# Assumptions and retained ambiguities

- The canonical profile has no measure participation, product-register, purchase/storage, parcel country, grafting, OP-code, or official-order fields. `rules/profile_changes.json` proposes discover-mode additions; it does not alter the canonical profile.
- The April 2026 measure sheet says the organic exception can be checked at Betriebsmittelbewertung. The executable model uses the evidence flag `bio_2018_848_permitted`; it cannot independently query that external register.
- The official-order exception is represented by explicit evidence fields. The 12 June notice adds 2026 facts about designated areas in Styria, Burgenland and Lower Austria but does not list the districts; no district whitelist was invented.
- Annex L's rendered matrix is visually column-dependent. Page 65 of the Special Directive independently states the 50% reduction for the optional Erosionsschutz Wein/Obst/Hopfen organism supplement, so that factor is executable; no broader row-by-row combination matrix was inferred from the rendered Annex L layout.
- The 2026 drought notices of 22 May, 5 August and 12 August concern biodiversity, arable, erosion, nature-conservation or livestock obligations, not o6_12. They were fully reviewed and recorded as out of scope in the coverage ledger.
