# METADATA
# title: ÖPUL 2023 Naturschutz (18) – Prämienberechnung
package oepul.o6_18.premium

import data.oepul.o6_18.eligibility
import data.oepul.o6_18.lib

p := lib.params

y := lib.year

# O618-PREM-012: Die Prämiensätze des Anhang I gelten ab 01.01.2024; für 2023 enthalten die Quellen keine Sätze.
rates_available if y >= 2024

# O618-PREM-001: Schlagprämie ergibt sich aus der Summe der Teilprämien der Auflagen laut Projektbestätigung (Anhang I).
base_rate(parcel) := sum([r |
	some c in lib.auflagen_of(parcel)
	lib.valid_in_year(c, y)
	r := lib.rate_for(c, y)
])

# O618-PREM-002: Prämienzuschläge (SA01 Ackerzahl > 50; GM01 bei Heuwirtschaft; HG01/HG02 bei >= 50 % Schutzgutflächen).
surcharge_applies("ackerzahl_over_50", parcel) if object.get(lib.ns(parcel), "ackerzahl", 0) > 50

surcharge_applies("participation_heuwirtschaft", _) if lib.participates("3")

surcharge_applies("schutzgut_layer_share_at_least_50_percent", parcel) if object.get(lib.ns(parcel), "schutzgut_layer_share", 0) >= 0.5

surcharge_rate(parcel) := sum([s.eur_ha |
	some c in lib.auflagen_of(parcel)
	lib.valid_in_year(c, y)
	some s in lib.auflage_by_code[c].surcharges
	surcharge_applies(s.condition, parcel)
])

rate_per_ha(parcel) := base_rate(parcel) + surcharge_rate(parcel)

# O618-PREM-003: GLÖZ-4-Pufferstreifen und (bis 2024) GLÖZ-8-Stilllegungen sind auf dem Flächenteil nicht förderbar.
gloez8_area(parcel) := object.get(parcel, ["oepul", "gloez8_fallow_area_ha"], 0) if y <= p.gloez8_non_eligible_until_year

gloez8_area(_) := 0 if y > p.gloez8_non_eligible_until_year

eligible_area(parcel) := lib.max2(0, (lib.area(parcel) - object.get(parcel, ["oepul", "gloez4_buffer_area_ha"], 0)) - gloez8_area(parcel))

# O618-PREM-005/006/007/016: Schläge ohne Prämie.
reason_applies("code_without_premium", parcel) if {
	some c in p.no_premium_codes
	c != "NPF"
	lib.has_code(parcel, c)
}

reason_applies("npf_gloez8", parcel) if {
	lib.has_code(parcel, "NPF")
	y <= p.npf_code_until_year
}

reason_applies("national_park_no_area_premium", parcel) if {
	object.get(parcel, ["oepul", "national_park"], null) in p.national_parks_without_area_premiums
}

reason_applies("national_park_relevant_requirements", parcel) if {
	np := object.get(parcel, ["oepul", "national_park"], null)
	np != null
	not np in p.national_parks_without_area_premiums
	object.get(parcel, ["oepul", "national_park_relevant_requirements"], false)
}

reason_applies("no_reference_area", parcel) if {
	parcel.parcel_id in eligibility.no_payment_parcels
}

reason_applies("transferred_without_continuation", parcel) if {
	object.get(parcel, ["oepul", "transferred_during_year"], false)
	not object.get(parcel, ["oepul", "successor_continues_until_year_end"], false)
}

reason_applies("no_project_confirmation", parcel) if {
	not object.get(lib.pc(parcel), "present", false)
}

reason_codes := [
	"code_without_premium", "npf_gloez8", "national_park_no_area_premium",
	"national_park_relevant_requirements", "no_reference_area",
	"transferred_without_continuation", "no_project_confirmation",
]

reasons(parcel) := {r | some r in reason_codes; reason_applies(r, parcel)}

paid_parcels := [parcel |
	some parcel in lib.nat_parcels
	count(reasons(parcel)) == 0
]

# O618-PREM-004: Ackerstilllegungen max. 25 % der Ackerfläche des Betriebes, jedenfalls 2 ha förderfähig.
is_set_aside(parcel) if lib.has_any_auflage(parcel, p.set_aside_cap.auflage_codes)

set_aside_area := sum([eligible_area(parcel) | some parcel in paid_parcels; is_set_aside(parcel)])

set_aside_cap_ha := lib.max2(p.set_aside_cap.share_of_arable_area * object.get(input, ["land", "arable_area_ha"], 0), p.set_aside_cap.minimum_ha)

set_aside_factor := 1 if set_aside_area <= set_aside_cap_ha

set_aside_factor := set_aside_cap_ha / set_aside_area if set_aside_area > set_aside_cap_ha

area_factor(parcel) := set_aside_factor if is_set_aside(parcel)

area_factor(parcel) := 1 if not is_set_aside(parcel)

# O618-PREM-013: Prämienfähigkeit von Flächenzugängen ab 2026 max. 50 % auf Basis 2025, jedenfalls + 5 ha.
nat_area_total := sum([lib.area(parcel) | some parcel in lib.nat_parcels])

access_limit_ha := base + lib.max2(p.area_increase.max_increase_share * base, p.area_increase.always_allowed_ha) if {
	y > 2025
	base := object.get(lib.nat, "area_2025_ha", null)
	base != null
}

eligible_nat_area_total := lib.min2(nat_area_total, access_limit_ha) + object.get(lib.nat, "previously_committed_added_area_ha", 0)

access_factor := 1 if not access_limit_ha

access_factor := 1 if {
	access_limit_ha
	nat_area_total <= eligible_nat_area_total
}

access_factor := eligible_nat_area_total / nat_area_total if {
	access_limit_ha
	nat_area_total > eligible_nat_area_total
}

# O618-PREM-009: Modulation nach Gesamtfläche des Betriebes.
farm_area := object.get(input, ["land", "total_area_ha"], 0)

band_amount(b) := (lib.min2(farm_area, b.to_ha) - b.from_ha) * b.factor if {
	b.to_ha != null
	farm_area > b.from_ha
}

band_amount(b) := (farm_area - b.from_ha) * b.factor if {
	b.to_ha == null
	farm_area > b.from_ha
}

band_amount(b) := 0 if farm_area <= b.from_ha

modulation_factor := 1 if farm_area <= 0

modulation_factor := sum([band_amount(b) | some b in p.modulation_bands]) / farm_area if farm_area > 0

# O618-PREM-008: Obergrenze der flächenbezogenen Zahlungen je Schlag (NAT/EBW: 1.300 €/ha 2023, 1.500 €/ha ab 2024).
cap_per_ha := lib.year_value(p.payment_caps_eur_per_ha, y)

other_payments(parcel) := object.get(parcel, ["oepul", "other_area_payments_eur_per_ha"], 0)

capped_rate(parcel) := lib.max2(0, lib.min2(rate_per_ha(parcel) * modulation_factor, cap_per_ha - other_payments(parcel)))

parcel_premium[parcel.parcel_id] := round((((eligible_area(parcel) * area_factor(parcel)) * access_factor) * capped_rate(parcel)) * 100) / 100 if {
	rates_available
	some parcel in paid_parcels
}

parcel_premium[parcel.parcel_id] := 0 if {
	some parcel in lib.nat_parcels
	count(reasons(parcel)) > 0
}

no_premium_reasons[parcel.parcel_id] := reasons(parcel) if {
	some parcel in lib.nat_parcels
	count(reasons(parcel)) > 0
}

# O618-PREM-010: Zuschlag Regionaler Naturschutzplan je Betrieb und Jahr (250 € 2023, 270 € ab 2024), bei NAT+EBW nur einmal.
regional_plan_premium := lib.year_value(p.regional_plan.premium_eur_per_farm, y) * modulation_factor if eligibility.regional_plan_eligible

regional_plan_premium := 0 if not eligibility.regional_plan_eligible

regional_plan_already_granted_via_ebw if object.get(object.get(lib.nat, "regional_plan", {}), "granted_via_ebw", false)

regional_plan_payable := 0 if regional_plan_already_granted_via_ebw

regional_plan_payable := regional_plan_premium if not regional_plan_already_granted_via_ebw

total_premium := round((sum([v | some v in parcel_premium]) + regional_plan_payable) * 100) / 100 if rates_available

# O618-PREM-011: Auszahlungsbeträge bis 50 € können unterbleiben.
payment_may_be_withheld if total_premium <= p.min_payout_eur

# O618-PREM-015: Teilzahlung max. 75 % nach Verwaltungskontrolle; Auszahlung bis 30.06. des Folgejahres.
max_advance_payment := total_premium * p.advance_payment_max_share

payout_deadline := sprintf("%d-06-30", [y + 1])

findings contains f if {
	not rates_available
	f := {"rule_id": "O618-PREM-012", "message": "Für das Antragsjahr 2023 enthalten die Quellen keine Anhang-I-Prämiensätze (gelten ab 01.01.2024)"}
}

findings contains f if {
	set_aside_area > set_aside_cap_ha
	f := {"rule_id": "O618-PREM-004", "message": sprintf("Ackerstilllegungen %.2f ha über förderfähiger Obergrenze %.2f ha", [set_aside_area, set_aside_cap_ha])}
}

findings contains f if {
	access_factor < 1
	f := {"rule_id": "O618-PREM-013", "message": "Flächenzugang über prämienfähiger Grenze (50 % auf Basis 2025, mind. 5 ha)"}
}

findings contains f if {
	some parcel in paid_parcels
	rate_per_ha(parcel) * modulation_factor > cap_per_ha - other_payments(parcel)
	f := {"rule_id": "O618-PREM-008", "message": sprintf("Schlag %v: Prämienobergrenze %v €/ha greift", [parcel.parcel_id, cap_per_ha])}
}
