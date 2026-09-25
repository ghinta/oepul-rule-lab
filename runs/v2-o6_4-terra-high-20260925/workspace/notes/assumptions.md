# Assumptions and open points

- `area_above_1200m_ha > area_ha / 2` implements “more than half” from the current information sheet. The legal directive's “überwiegende Teil” is interpreted consistently as strictly greater than 50%.
- The information sheet describes altitude relative to the home farm and the alpine-farm exception, but supplies no GIS data model. These facts are retained in the discover-mode `mountain_meadow` object and reported as eligibility evidence rather than inferred from `slope_percent`.
- The 2026 drought notices were read in full. None changes an o6_4 obligation; they are deliberately not converted to Bergmahd rules.
- The general 1,300 EUR/ha ceiling has exclusions that require other-measure payment detail. The catalog records it, but the supplied executable policy calculates the standalone o6_4 rate and does not claim to calculate a whole-farm multi-measure cap or sanction percentage.
