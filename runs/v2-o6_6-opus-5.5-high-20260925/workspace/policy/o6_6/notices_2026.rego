# Jahresspezifische Festlegungen 2026 (AMA-Meldungen Dürre 2026) mit Bezug zu o6_6.
package oepul.o6_6

n26 := data.o6_6.notices_2026

# Dürre 2026: fehlende Flächendeckung wird bei ordnungsgemäßer Anlage nicht beanstandet.
drought_2026_coverage_excused(p) if {
	year == n26.coverage_exception.year
	cc(p).properly_established == true
}

# Dürre 2026: Überschreitung der 50 %-Grenze durch Ausfallgetreide wird nicht beanstandet.
drought_2026_cereal_excused(p) if {
	year == n26.coverage_exception.year
	cc(p).properly_established == true
	cc(p).cereal_share_from_volunteer == true
}

# Dürre 2026: Ernteverpflichtung (85 %) in den ausgewiesenen Bezirken automatisch höhere Gewalt.
harvest_obligation_waived_2026 if {
	year == n26.harvest_obligation_waiver_districts.year
	some r in n26.harvest_obligation_waiver_districts.rows
	r.federal_state == input.farm.region.federal_state
	district_covered(r)
}

district_covered(r) if r.all_districts

district_covered(r) if input.farm.region.district in r.districts

# Streichung/Änderung einer Variante, die nicht fristgerecht angelegt werden kann.
variant_withdrawal_required contains {"parcel_id": p.parcel_id, "variant": cc(p).variant, "rule_id": "O6_6-WITHDRAW-VARIANT"} if {
	some p in cover_parcels
	not cc(p).variant_withdrawn == true
	not_established_by_deadline(p)
}

not_established_by_deadline(p) if {
	not establishment_date(p)
}

not_established_by_deadline(p) if {
	establishment_ns(p) > ns_md(year, row_of(p).sowing_deadline)
}
