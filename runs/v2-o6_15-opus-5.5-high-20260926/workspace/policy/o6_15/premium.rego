# Prämienberechnung (Kapitel 9 Informationsblatt, Punkt 2.15 Höhe der Förderung SRL)
# inklusive Landes-Top-up, Modulation und Mindestauszahlungsbetrag.
package oepul.o6_15

rate_period := p if {
	some p in rates.rate_periods
	p.from_year <= year
	year <= p.to_year
}

# ---------------------------------------------------------------------------
# Behirtete RGVE je Alm
# ---------------------------------------------------------------------------

alm_herded_rgve(alm) := sum([animal_rgve_on_alm(a) |
	some a in alm_animals(alm)
	eligible_herded_animal(alm, a)
])

alm_dairy_rgve(alm) := sum([animal_rgve_on_alm(a) |
	some a in alm_animals(alm)
	animal_is_dairy_rgve(alm, a)
])

farm_herded_rgve := sum([alm_herded_rgve(alm) | some alm in alms])

# Pro Hirtin oder Hirte Prämie für maximal 50 RGVE
herder_capacity_rgve(alm) := valid_herder_count(alm) * rates.limits.max_rgve_per_herder

# Erhöhte Prämie für die ersten 20 RGVE je 50 RGVE und Hirtin/Hirte
# (Blöcke werden der Reihe nach je Hirtin/Hirte befüllt).
higher_rate_rgve(x) := h if {
	block := rates.limits.herder_block_size_rgve
	first := rates.limits.higher_rate_rgve_per_herder_block
	full_blocks := floor(x / block)
	h := (full_blocks * first) + min_of(first, x - (full_blocks * block))
}

alm_capped_rgve(alm) := min_of(alm_herded_rgve(alm), herder_capacity_rgve(alm))

# Milchvieh wird bei der Blockbefüllung vorrangig berücksichtigt (vgl. Beispiele Kapitel 9)
alm_capped_dairy_rgve(alm) := min_of(alm_dairy_rgve(alm), alm_capped_rgve(alm))

alm_base_premium(alm) := amount if {
	x := alm_capped_rgve(alm)
	hi := higher_rate_rgve(x)
	amount := (hi * rate_period.herded_first_20_rgve_eur_per_rgve) + ((x - hi) * rate_period.herded_from_21st_rgve_eur_per_rgve)
}

alm_dairy_premium(alm) := amount if {
	x := alm_capped_dairy_rgve(alm)
	hi := higher_rate_rgve(x)
	amount := (hi * rate_period.dairy_supplement_first_20_rgve_eur_per_rgve) + ((x - hi) * rate_period.dairy_supplement_from_21st_rgve_eur_per_rgve)
}

# Landes-Top-up: 40 Euro/RGVE zusätzlich zum Zuschlag Milchvieh für die ersten 20 RGVE
top_up_available if {
	object.get(herding_application, "federal_state_top_up_granted", false) == true
	object.get(herding_application, "federal_state_top_up_notified_by_may_15", false) == true
}

alm_top_up(alm) := higher_rate_rgve(alm_capped_dairy_rgve(alm)) * rates.federal_state_top_up.eur_per_rgve if top_up_available

alm_top_up(_) := 0 if not top_up_available

# ---------------------------------------------------------------------------
# Optionaler Zuschlag Herdenschutzhunde
# ---------------------------------------------------------------------------

dog_supplement_active if {
	object.get(herding_application, "dog_supplement_requested", false) == true
	dog_supplement_entry_ok
}

alm_dog_premium(alm) := paid_dog_count(alm) * rate_period.herd_protection_dog_eur_per_dog if dog_supplement_active

alm_dog_premium(_) := 0 if not dog_supplement_active

# ---------------------------------------------------------------------------
# Ergebnis je Alm
# ---------------------------------------------------------------------------

alm_results[alm.alm_id] := result if {
	some alm in alms
	eligible := alm_eligible_bool(alm)
	base := alm_base_premium(alm)
	dairy := alm_dairy_premium(alm)
	dogs := alm_dog_premium(alm)
	top_up := alm_top_up(alm)
	result := {
		"eligible": eligible,
		"failures": alm_failures(alm),
		"valid_herders": valid_herder_count(alm),
		"herded_rgve": round2(alm_herded_rgve(alm)),
		"capped_rgve": round2(alm_capped_rgve(alm)),
		"higher_rate_rgve": round2(higher_rate_rgve(alm_capped_rgve(alm))),
		"dairy_rgve": round2(alm_dairy_rgve(alm)),
		"capped_dairy_rgve": round2(alm_capped_dairy_rgve(alm)),
		"base_premium_eur": round2(base),
		"dairy_premium_eur": round2(dairy),
		"federal_state_top_up_eur": round2(top_up),
		"eligible_dogs": count(eligible_dogs(alm)),
		"paid_dogs": paid_dog_count(alm),
		"dog_premium_eur": round2(dogs),
		"gross_premium_eur": round2(gross_if_eligible(eligible, ((base + dairy) + dogs) + top_up)),
	}
}

alm_eligible_bool(alm) if alm_eligible(alm)

alm_eligible_bool(alm) := false if not alm_eligible(alm)

gross_if_eligible(true, amount) := amount

gross_if_eligible(false, _) := 0

gross_premium := round2(sum([r.gross_premium_eur | some r in alm_results]))

# ---------------------------------------------------------------------------
# Modulation (Almen getrennt von der Heimfläche betrachtet)
# ---------------------------------------------------------------------------

# Aufgetriebene RGVE je Alm (Tiere mit mindestens 60 Tagen Auftriebsdauer)
alm_stocked_rgve(alm) := alm.stocked_rgve if object.get(alm, "stocked_rgve", null) != null

alm_stocked_rgve(alm) := sum([animal_rgve_on_alm(a) |
	some a in alm_animals(alm)
	a.species in params.eligible_species
	meets_min_herding_duration(a)
]) if {
	object.get(alm, "stocked_rgve", null) == null
}

# RGVE über 1 RGVE/ha Almweidefläche werden auf die Almweidefläche gekürzt
alm_modulation_basis(alm) := min_of(alm_stocked_rgve(alm), object.get(alm, "alpine_pasture_area_ha", 0))

modulation_basis := sum([alm_modulation_basis(alm) | some alm in alms])

band_portion(b, band) := max_of(min_of(b, band.to_inclusive) - band.from_exclusive, 0) if band.to_inclusive != null

band_portion(b, band) := max_of(b - band.from_exclusive, 0) if band.to_inclusive == null

modulation_factor_for(b) := 1 if b <= 0

modulation_factor_for(b) := f if {
	b > 0
	weighted := sum([(band_portion(b, band) * band.payout_share) | some band in reductions.modulation_bands])
	f := weighted / b
}

modulation_factor := modulation_factor_for(modulation_basis)

net_premium := round2(gross_premium * modulation_factor)

# Von der Gewährung kann abgesehen werden, wenn der Betrag 50 Euro nicht überschreitet
payout_may_be_waived if net_premium <= rates.minimum_payout_eur

max_advance_payment := round2(net_premium * rates.max_advance_payment_share)

payment_deadline := sprintf("%d-%s", [year + 1, rates.payment_deadline_month_day_following_year])
