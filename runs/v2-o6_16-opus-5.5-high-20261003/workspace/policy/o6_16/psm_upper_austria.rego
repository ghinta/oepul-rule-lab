# Pflanzenschutz (Kapitel 4.6) und zusätzliche Förderverpflichtungen in Oberösterreich (Kapitel 4.7).
package oepul.o6_16

import data.o6_16 as d

psm_applications(p) := object.get(p, ["operations", "psm_applications"], [])

fertilizer_applications(p) := object.get(p, ["operations", "fertilizer_applications"], [])

restricted_crop_set := {r.crop | some r in d.psm_restricted_crops}

bentazon_reauthorised := object.get(input, ["context", "bentazon_reauthorised"], false)

banned_substances := {s.substance | some s in d.psm_banned_active_substances; not s.conditional} | conditional_banned

conditional_banned := {"Bentazon"} if bentazon_reauthorised

conditional_banned := set() if not bentazon_reauthorised

# Wirkstoffverbot bei Sorghum, Sudangras, Mais (inkl. Zuckermais, Saatmaisvermehrung), Raps, Soja, Zuckerrübe
obligation_violations contains v if {
	some p in area_parcels
	parcel_crop_name(p) in restricted_crop_set
	some a in psm_applications(p)
	some s in a.active_substances
	s in banned_substances
	v := {
		"rule_id": "O616-PSM-001",
		"parcel_id": p.parcel_id,
		"message": sprintf("Wirkstoff %v auf %v in der Gebietskulisse eingesetzt", [s, parcel_crop_name(p)]),
	}
}

# Angabeverpflichtung PSMBIO/PSMCS bis einschließlich Antragsjahr 2025 (gebeiztes Saatgut = flächige Anwendung)
psm_code_required(p) := "PSMCS" if {
	some a in psm_applications(p)
	a.product_type == "chemical_synthetic"
}

psm_code_required(p) := "PSMBIO" if {
	count(psm_applications(p)) > 0
	every a in psm_applications(p) {
		a.product_type == "organic_approved"
	}
}

obligation_violations contains v if {
	year <= 2025
	some p in area_parcels
	code := psm_code_required(p)
	not psm_code_satisfied(p, code)
	v := {
		"rule_id": "O616-PSM-002",
		"parcel_id": p.parcel_id,
		"message": sprintf("Flächiger PSM-Einsatz ohne Code %v im Mehrfachantrag", [code]),
	}
}

psm_code_satisfied(p, code) if code in parcel_codes(p)

# Bei Einsatz von Bio- und chemisch-synthetischen Mitteln genügt PSMCS
psm_code_satisfied(p, "PSMBIO") if "PSMCS" in parcel_codes(p)

psm_coding_required_in_year if year <= 2025

# --- Oberösterreich: Ausbringungsverbot leichtlöslicher N-Dünger 15.10.–15.02. (Mais: bis 21.03.) ---
in_window_oct15_feb15(date) if month_day(date) >= "10-15"

in_window_oct15_feb15(date) if month_day(date) <= "02-15"

in_window_oct15_mar21(date) if month_day(date) >= "10-15"

in_window_oct15_mar21(date) if month_day(date) <= "03-21"

maize_crop(p) if parcel_crop_name(p) in {"Mais", "Körnermais", "Silomais", "Zuckermais", "Saatmaisvermehrung", "Corn-Cob-Mix"}

maize_crop(p) if object.get(p, ["crop", "crop_category"], "") == "maize"

arable_forage_crop(p) if parcel_crop_name(p) in {c | some c in d.arable_forage_crops}

obligation_violations contains v if {
	some p in upper_austria_area_parcels
	not arable_forage_crop(p)
	not maize_crop(p)
	some a in fertilizer_applications(p)
	object.get(a, "readily_soluble", false) == true
	in_window_oct15_feb15(a.date)
	v := {
		"rule_id": "O616-OOE-001",
		"parcel_id": p.parcel_id,
		"message": sprintf("Leichtlöslicher N-Dünger am %v im Verbotszeitraum 15.10.–15.02. (Oberösterreich)", [a.date]),
	}
}

obligation_violations contains v if {
	some p in upper_austria_area_parcels
	maize_crop(p)
	some a in fertilizer_applications(p)
	object.get(a, "readily_soluble", false) == true
	in_window_oct15_mar21(a.date)
	v := {
		"rule_id": "O616-OOE-001",
		"parcel_id": p.parcel_id,
		"message": sprintf("Leichtlöslicher N-Dünger am %v bei Mais im Verbotszeitraum 15.10.–21.03. (Oberösterreich)", [a.date]),
	}
}

# Gabenteilung: > 80 kg/ha Nitrat-, Ammonium- oder Carbamid-N je Gabe (nach Stall- und Lagerverlusten)
obligation_violations contains v if {
	some p in upper_austria_area_parcels
	some a in fertilizer_applications(p)
	object.get(a, "slow_release", false) != true
	readily_available_n(a) > 80
	v := {
		"rule_id": "O616-OOE-002",
		"parcel_id": p.parcel_id,
		"message": sprintf("Stickstoffgabe am %v mit %v kg/ha leicht verfügbarem N nicht geteilt (max. 80 kg/ha)", [a.date, readily_available_n(a)]),
	}
}

# Ammonium-N aus Wirtschaftsdüngern gemäß NAPV Anlage 2, sonst angegebener Wert
readily_available_n(a) := a.readily_available_n_kg_ha if a.readily_available_n_kg_ha != null

readily_available_n(a) := round2((a.total_n_after_losses_kg_ha * share) / 100) if {
	object.get(a, "readily_available_n_kg_ha", null) == null
	some r in d.napv_anlage2_ammonium_share
	r.fertilizer == a.fertilizer_type
	share := r.nh4_n_percent
}

# Variante 3 der Maßnahme „Zwischenfruchtanbau“ in Oberösterreich unzulässig
obligation_violations contains v if {
	some p in upper_austria_area_parcels
	object.get(p, ["operations", "cover_crop", "variant"], null) == 3
	v := {
		"rule_id": "O616-OOE-003",
		"parcel_id": p.parcel_id,
		"message": "Begrünungsvariante 3 innerhalb der Gebietskulisse Oberösterreich nicht zulässig",
	}
}

# Kontrollgang oder Warndienstmeldung vor jeder chemisch-synthetischen PSM-Maßnahme
obligation_violations contains v if {
	some p in upper_austria_area_parcels
	some a in psm_applications(p)
	a.product_type == "chemical_synthetic"
	object.get(a, "prior_field_inspection_documented", false) != true
	object.get(a, "warning_service_documented", false) != true
	v := {
		"rule_id": "O616-OOE-004",
		"parcel_id": p.parcel_id,
		"message": sprintf("Chemisch-synthetische PSM-Maßnahme am %v ohne dokumentierten Kontrollgang/Warndienst", [a.date]),
	}
}
