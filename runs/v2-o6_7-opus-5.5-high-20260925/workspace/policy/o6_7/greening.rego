# Ganzjährige Begrünung: mindestens 85 % der Ackerfläche müssen zu jedem
# Zeitpunkt des Jahres begrünt sein (Kapitel 5.1 Merkblatt, SRL Punkt 2.7
# Förderverpflichtungen). Tagesgenaue Berechnung der unbegrünten Fläche.
package o6_7.greening

import data.o6_7.catch_crop
import data.o6_7.lib

main_kinds := {"main_crop", "green_fallow", "nat_self_greening"}

group(kind) := "main_crop" if kind in main_kinds

group(kind) := "catch_crop" if kind == "catch_crop"

gap_limit(from_group, to_group) := l.max_days if {
	some l in lib.params.gap_limits_days
	l.from_kind == from_group
	l.to_kind == to_group
}

# Abschnitt zählt als Begrünungskultur (Hauptfrucht, Grünbrache, gültige
# Zwischenfrucht, Naturschutz-Selbstbegrünung).
counts_as_greening(_, s) if catch_crop.effective_kind(s) in main_kinds

counts_as_greening(key, s) if {
	catch_crop.is_catch_crop(s)
	catch_crop.valid[key]
}

end_day(s) := lib.day(s.end_date) if s.end_date

end_day(s) := null if not s.end_date

norm(key, s) := {
	"key": key,
	"group": group(catch_crop.effective_kind(s)),
	"start": catch_crop.start_day(s),
	"end": end_day(s),
	"drought_2026_justified": object.get(s, "drought_2026_late_sowing_justified", false),
}

valid_segments[pid] := [t[2] | some t in sort(tuples)] if {
	some p in lib.arable_parcels
	pid := p.parcel_id
	tuples := [[catch_crop.start_day(e.seg), key, norm(key, e.seg)] |
		some key, e in lib.segments
		e.parcel_id == pid
		counts_as_greening(key, e.seg)
	]
}

clip_lo(d) := max([d, lib.year_start_day])

clip_hi(d) := min([d, lib.year_end_day])

# Dürre 2026: Überschreitung der 30-/50-Tage-Fristen bei Glaubhaftmachung einer
# vorausschauenden Bewirtschaftung, Nachholung noch im Antragsjahr 2026.
drought_gap_relief(next) if {
	lib.year == lib.params.drought_2026.year
	next.drought_2026_justified == true
	lib.year_of(lib.date_of(next.start)) == lib.params.drought_2026.year
}

# Unbegrünte Tage aus überschrittenen Zeiträumen zwischen zwei Kulturen.
gap_violations contains {"parcel_id": pid, "from": prev.key, "to": next.key, "gap_days": g, "max_days": limit} if {
	some pid, segs in valid_segments
	count(segs) >= 2
	some i in numbers.range(0, count(segs) - 2)
	prev := segs[i]
	next := segs[i + 1]
	prev.end != null
	g := next.start - prev.end
	limit := gap_limit(prev.group, next.group)
	g > limit
	not drought_gap_relief(next)
	next.start - 1 >= lib.year_start_day
	prev.end <= lib.year_end_day
}

ungreened[pid] contains d if {
	some gv in gap_violations
	pid := gv.parcel_id
	segs := valid_segments[pid]
	some prev in segs
	prev.key == gv.from
	some next in segs
	next.key == gv.to
	some d in numbers.range(clip_lo(prev.end), clip_hi(next.start - 1))
}

# Kein Begrünungsabschnitt vor dem ersten Abschnitt im Jahr.
ungreened[pid] contains d if {
	some pid, segs in valid_segments
	count(segs) > 0
	first := segs[0]
	first.start > lib.year_start_day
	some d in numbers.range(lib.year_start_day, clip_hi(first.start - 1))
}

# Offener Zeitraum nach dem letzten Abschnitt: Tage jenseits der höchstens
# zulässigen Frist bis zur nächsten Hauptfrucht gelten als unbegrünt.
trailing_open_from[pid] := last.end + gap_limit(last.group, "main_crop") if {
	some pid, segs in valid_segments
	count(segs) > 0
	last := segs[count(segs) - 1]
	last.end != null
	every s in segs {
		s.end != null
		s.end <= last.end
	}
}

ungreened[pid] contains d if {
	some pid, from in trailing_open_from
	from <= lib.year_end_day
	some d in numbers.range(clip_lo(from), lib.year_end_day)
}

# Ackerschlag ohne jeglichen Begrünungsabschnitt.
ungreened[pid] contains d if {
	some pid, segs in valid_segments
	count(segs) == 0
	some d in numbers.range(lib.year_start_day, lib.year_end_day)
}

# „Sonstige Ackerflächen“ gelten ganzjährig als unbegrünt.
ungreened[pid] contains d if {
	some p in lib.arable_parcels
	p.usage_category in lib.lists.always_ungreened_usage_categories
	pid := p.parcel_id
	some d in numbers.range(lib.year_start_day, lib.year_end_day)
}

# Code GI (Grundinanspruchnahme): für die Dauer der Inanspruchnahme unbegrünt.
ungreened[pid] contains d if {
	some p in lib.arable_parcels
	some gi in object.get(p, "gi_periods", [])
	pid := p.parcel_id
	lo := clip_lo(lib.day(gi.start_date))
	hi := clip_hi(lib.day(object.get(gi, "end_date", lib.date_of(lib.year_end_day))))
	lo <= hi
	some d in numbers.range(lo, hi)
}

# Naturschutzflächen mit vorgeschriebener Bodenbearbeitung ohne Neueinsaat:
# nur bei vollständiger Wiederbegrünung binnen 50 Tagen gültige Hauptfrucht.
nat_self_greening_exceeded contains {"parcel_id": e.parcel_id, "key": key, "days": n} if {
	some key, e in lib.segments
	e.seg.kind == "nat_self_greening"
	e.seg.tillage_date
	n := lib.days_between(e.seg.tillage_date, e.seg.full_regreening_date)
	n > lib.params.nat_self_greening_max_days
}

ungreened[pid] contains d if {
	some x in nat_self_greening_exceeded
	pid := x.parcel_id
	s := lib.segments[x.key].seg
	lo := clip_lo(lib.day(s.tillage_date))
	hi := clip_hi(lib.day(s.full_regreening_date) - 1)
	lo <= hi
	some d in numbers.range(lo, hi)
}

# Flächenhinzunahmen nach dem 15. Oktober (unbegrünt/unbebaut) werden nicht in
# die 15 %-Grenze einberechnet.
late_acquired(p) if {
	acq := p.acquisition
	acq.unvegetated_at_acquisition == true
	lib.day(acq.acquired_date) > lib.mmdd_day(lib.year, lib.params.coverage.late_acquisition_cutoff_mmdd)
	lib.year_of(acq.acquired_date) == lib.year
}

base_parcels contains p if {
	some p in lib.arable_parcels
	not late_acquired(p)
}

base_area_ha := sum([p.area_ha | some p in base_parcels])

ungreened_area_on(d) := sum([p.area_ha |
	some p in base_parcels
	d in object.get(ungreened, p.parcel_id, set())
])

daily_ungreened_share[d] := round((ungreened_area_on(d) / base_area_ha) * 1000000) / 1000000 if {
	base_area_ha > 0
	some d in numbers.range(lib.year_start_day, lib.year_end_day)
}

max_ungreened_share := max([v | some v in daily_ungreened_share]) if {
	count(daily_ungreened_share) > 0
} else := 0

violation_days contains d if {
	some d, share in daily_ungreened_share
	lib.approx_gt(share, lib.params.coverage.max_ungreened_share)
}

default coverage_ok := false

coverage_ok if {
	base_area_ha > 0
	count(violation_days) == 0
}

first_violation_date := lib.date_of(min(violation_days)) if count(violation_days) > 0

violations contains {
	"rule_id": "O67-COVER-85",
	"code": "ungreened_share_above_15_percent",
	"first_date": first_violation_date,
	"violation_day_count": count(violation_days),
	"max_ungreened_share": max_ungreened_share,
} if {
	count(violation_days) > 0
}

violations contains {
	"rule_id": "O67-GAP-MAX-PERIODS",
	"code": "maximum_gap_exceeded",
	"parcel_id": gv.parcel_id,
	"gap_days": gv.gap_days,
	"max_days": gv.max_days,
} if {
	some gv in gap_violations
}

violations contains {
	"rule_id": "O67-NAT-SELF-GREENING",
	"code": "nat_self_greening_over_50_days",
	"parcel_id": x.parcel_id,
	"days": x.days,
} if {
	some x in nat_self_greening_exceeded
}

summary := {
	"base_area_ha": base_area_ha,
	"excluded_late_acquisitions": [p.parcel_id | some p in lib.arable_parcels; late_acquired(p)],
	"max_ungreened_share": max_ungreened_share,
	"violation_day_count": count(violation_days),
	"coverage_ok": coverage_ok,
}
