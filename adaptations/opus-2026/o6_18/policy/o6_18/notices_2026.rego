# METADATA
# title: ÖPUL 2023 Naturschutz (18) – Sonderregelungen 2026 (AMA-Aktuell-Meldungen)
package oepul.o6_18.notices_2026

import data.oepul.o6_18.lib

p := lib.params

# O618-N26-001: Ab 12.08.2026 dürfen NAT-Flächen mit festgelegtem Nutzungstermin genutzt werden (1. oder 2. Nutzung);
# Projektbestätigung bleibt unverändert, Prämie wird gewährt.
early_use_release_active if {
	lib.year == 2026
}

released_use_allowed(parcel, date) if {
	early_use_release_active
	lib.is_nat(parcel)
	date >= p.drought_2026.naturschutz_use_release_date
}

premium_kept_despite_release if early_use_release_active

# O618-N26-002: Trockenheitsbedingte DIV-Ausnahmen (vorzeitige Nutzung mit OPUBB/OPBIO) umfassen keine NAT-Flächen.
violations contains v if {
	lib.year == 2026
	some parcel in lib.nat_parcels
	object.get(lib.ns(parcel), "drought_div_exception_used", false)
	v := {"rule_id": "O618-N26-002", "parcel_id": parcel.parcel_id, "message": "Trockenheitsbedingte DIV-Ausnahme gilt nicht für Naturschutzflächen – Bewirtschaftung nach Projektbestätigung"}
}

# O618-N26-003: Acker-Biodiversitätsflächen, die zusätzlich in NAT eingebracht sind: keine dritte Nutzung – nur nach Projektbestätigung.
violations contains v if {
	lib.year == 2026
	some parcel in lib.nat_parcels
	lib.has_code(parcel, "DIV")
	parcel.land_use == "arable"
	count(lib.cutting_dates(parcel)) + count(lib.grazing_periods(parcel)) >= 3
	not object.get(lib.pc(parcel), "third_use_permitted", false)
	v := {"rule_id": "O618-N26-003", "parcel_id": parcel.parcel_id, "message": "Dritte Nutzung 2026 auf NAT-Acker-Biodiversitätsfläche nicht von der Dürre-Erleichterung umfasst"}
}

# O618-N26-004: Dürre 2026 – Entfall der Ernteverpflichtung (85 %) ohne einzelbetriebliche Meldung in gelisteten Bezirken.
harvest_exemption_district if {
	lib.year == 2026
	some row in data.o6_18.drought_2026_harvest_exemption.districts
	row.federal_state == object.get(input, ["farm", "region", "federal_state"], null)
	district_match(row)
}

district_match(row) if row.all_districts

district_match(row) if row.district == object.get(input, ["farm", "region", "district"], null)

# O618-N26-005: Außerhalb der Gebietskulisse: einzelflächenbezogenes Ansuchen auf höhere Gewalt mit Nachweisen.
force_majeure_application_required contains parcel.parcel_id if {
	lib.year == 2026
	some parcel in lib.nat_parcels
	object.get(lib.ns(parcel), "drought_no_harvestable_crop", false)
	not harvest_exemption_district
}
