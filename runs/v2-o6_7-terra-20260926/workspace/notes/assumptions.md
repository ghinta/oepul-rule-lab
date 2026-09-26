# Assumptions and open modelling points

- The sources specify the end of the mineral-nitrogen prohibition by reference to the Nitrat-Aktionsprogramm-Verordnung. Its yearly exact date is therefore represented as `o6_7.intercrops[].napv_prohibition_end`; it is not guessed here.
- The 2026 drought exception for 30/50-day planting intervals requires credible evidence of forward-looking management and planting at the earliest possible date. This is modelled through explicit boolean evidence fields. It does not relax the 20 September / 15 October establishment deadlines or the 42-day duration.
- The source requires a point-in-time 85% calculation across all arable land. The canonical profile contains static parcels but no time series. The executable policy consequently consumes a supplied `minimum_green_cover_percent` (the annual minimum) and event history.
- The consequence amount for a breach is not mechanically specified per individual obligation. The rules report breaches; the general conditions require an authority assessment based on severity, extent, duration and frequency.
