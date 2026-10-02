# o6_16 – Pflanzenschutz (4.6) und zusätzliche Förderverpflichtungen in Oberösterreich (4.7)
package oepul.o6_16

# ---------------------------------------------------------------------------
# 4.6 Wirkstoffverbot in der Gebietskulisse
# ---------------------------------------------------------------------------

bentazon_reauthorized := o16.bentazon_reauthorized if {
	is_boolean(object.get(o16, "bentazon_reauthorized", null))
} else := params.psm.bentazon_reauthorized_default

banned_substances := {lower(s) | some s in params.psm.banned_active_substances} | conditional_banned

conditional_banned := {lower(c.substance) | some c in params.psm.conditional_banned_active_substances} if bentazon_reauthorized

conditional_banned := set() if not bentazon_reauthorized

psm_restricted_crop(p) if name_in(crop_name(p), params.psm.restricted_crops)

psm_restricted_crop(p) if is_maize(p)

psm_applications(p) := object.get(p, ["operations", "psm_applications"], [])

violations contains {
	"rule_id": "o6_16.psm.banned_active_substances",
	"parcel_id": p.parcel_id,
	"message": sprintf("Wirkstoff %v auf %v in der Gebietskulisse nicht zulässig.", [s, crop_name(p)]),
} if {
	some p in arable_in_area
	psm_restricted_crop(p)
	some a in psm_applications(p)
	some s in a.active_substances
	lower(s) in banned_substances
}

# Codierung PSMBIO/PSMCS im Mehrfachantrag bis einschließlich Antragsjahr 2025
psm_coding_required(yr) if yr <= params.psm.coding_until_year

required_psm_code(p) := "PSMCS" if {
	some a in psm_applications(p)
	a.product_type == "chemical_synthetic"
}

required_psm_code(p) := "PSMBIO" if {
	count(psm_applications(p)) > 0
	every a in psm_applications(p) {
		a.product_type == "bio"
	}
}

psm_code_ok(p) if has_code(p, "PSMCS")

psm_code_ok(p) if {
	required_psm_code(p) == "PSMBIO"
	has_code(p, "PSMBIO")
}

violations contains {
	"rule_id": "o6_16.psm.coding_until_2025",
	"parcel_id": p.parcel_id,
	"message": sprintf("Flächiger Pflanzenschutzmitteleinsatz: Code %v im Mehrfachantrag fehlt.", [required_psm_code(p)]),
} if {
	psm_coding_required(year)
	some p in arable_in_area
	required_psm_code(p)
	not psm_code_ok(p)
}

# ---------------------------------------------------------------------------
# 4.7 Oberösterreich
# ---------------------------------------------------------------------------

ooe := params.upper_austria

ooe_parcels := [p | some p in arable_in_area; in_upper_austria_area(p)]

fertilizer_applications(p) := object.get(p, ["operations", "fertilizer_applications"], [])

# Datum liegt im über den Jahreswechsel reichenden Sperrzeitraum [from, to]
in_winter_window(d, from_md, _) if month_day(d) >= from_md

in_winter_window(d, _, to_md) if month_day(d) <= to_md

ooe_ban_window(p) := w if {
	is_maize(p)
	some w in ooe.readily_soluble_n_ban
	w.scope == "mais"
}

ooe_ban_window(p) := w if {
	not is_maize(p)
	not is_arable_forage(p)
	some w in ooe.readily_soluble_n_ban
	w.scope == "ackerflaechen_ausser_ackerfutter"
}

violations contains {
	"rule_id": "o6_16.ooe.readily_soluble_n_ban",
	"parcel_id": p.parcel_id,
	"message": sprintf("Ausbringung leichtlöslicher stickstoffhaltiger Dünger am %v im Sperrzeitraum %v bis %v.", [a.date, w.from_month_day, w.to_month_day]),
} if {
	some p in ooe_parcels
	w := ooe_ban_window(p)
	some a in fertilizer_applications(p)
	object.get(a, "readily_soluble_n", false) == true
	in_winter_window(a.date, w.from_month_day, w.to_month_day)
}

violations contains {
	"rule_id": "o6_16.ooe.split_n_applications",
	"parcel_id": p.parcel_id,
	"message": sprintf("Stickstoffgabe mit %v kg/ha Nitrat-, Ammonium- oder Carbamid-N (> 80 kg/ha) ist zu teilen.", [a.n_available_kg_ha]),
} if {
	some p in ooe_parcels
	some a in fertilizer_applications(p)
	a.n_available_kg_ha > ooe.max_single_n_application_kg_ha
	object.get(a, "slow_release", false) == false
}

violations contains {
	"rule_id": "o6_16.ooe.no_cover_crop_variant_3",
	"parcel_id": p.parcel_id,
	"message": "Begrünungsvariante 3 (o6_6) in der Gebietskulisse Oberösterreich nicht zulässig.",
} if {
	some p in ooe_parcels
	object.get(p, ["operations", "cover_crop", "o6_6_variant"], null) == ooe.forbidden_cover_crop_variant_o6_6
}

violations contains {
	"rule_id": "o6_16.ooe.ipm_control_walk",
	"parcel_id": p.parcel_id,
	"message": "Chemisch-synthetische Pflanzenschutzmaßnahme ohne dokumentierten Kontrollgang bzw. Warndienstmeldung.",
} if {
	some p in ooe_parcels
	some a in psm_applications(p)
	a.product_type == "chemical_synthetic"
	object.get(a, "prior_field_inspection_documented", false) == false
	object.get(a, "warning_service_documented", false) == false
}
