package oepul.o6_1c

# Zugangs- und Fördervoraussetzungen auf Betriebsebene.

applicant := object.get(input, ["farm", "applicant"], {})

lists := data.o6_1c

# O6_1C-SCOPE-002: Maßnahme wird ab dem Antragsjahr 2025 angeboten.
measure_offered if year >= params.application.first_offered_year

access_violations contains farm_violation("O6_1C-SCOPE-002", "Die Maßnahme wird erst ab dem Antragsjahr 2025 angeboten") if {
	not measure_offered
}

# O6_1C-ELIG-001: Teilnahme an der Kategorie NPA schließt UBB und BIO
# (ausgenommen BIO-Teilbetrieb Wein, Obst und Hopfen) am Betrieb aus.
npa_farm_level_conflicts contains row.measure_id if {
	"npa" in applied_categories
	some row in lists.npa_farm_level_exclusions.rows
	row.measure_id in participating_measures
	not npa_exclusion_exception_applies(row)
}

npa_exclusion_exception_applies(row) if {
	row.exception == "bio_partial_farm_wine_fruit_hops"
	object.get(oepul, "bio_participation_type", null) == "partial_wine_fruit_hops"
}

access_violations contains farm_violation("O6_1C-ELIG-001", sprintf("Kategorie Nichtproduktive Ackerflächen nicht gleichzeitig mit %s möglich", [m])) if {
	some m in npa_farm_level_conflicts
}

# O6_1C-ELIG-002: Gebietskörperschaften und Einrichtungen mit bestimmendem
# Einfluss (> 25 %) sind ausgeschlossen, ausgenommen in Ausnahme-Maßnahmen.
public_body_influence if applicant.type == "public_body"

public_body_influence if {
	object.get(applicant, "public_body_share_percent", 0) > params.general.max_public_body_share_percent
}

public_body_exception_applies if {
	some row in lists.public_body_exception_measures.rows
	row.measure_id == measure_id
	year_within(year, row.from_year, row.to_year)
}

year_within(y, from, to) if {
	from_ok(y, from)
	to_ok(y, to)
}

from_ok(_, null)

from_ok(y, from) if {
	from != null
	y >= from
}

to_ok(_, null)

to_ok(y, to) if {
	to != null
	y <= to
}

access_violations contains farm_violation("O6_1C-ELIG-002", "Gebietskörperschaft bzw. Einrichtung mit bestimmendem Einfluss einer Gebietskörperschaft ist im betroffenen Jahr nicht förderwerbend") if {
	public_body_influence
	not public_body_exception_applies
}

# O6_1C-ELIG-003: aktiver Landwirt und landwirtschaftliche Tätigkeit.
access_violations contains farm_violation("O6_1C-ELIG-003", "Förderwerbende Person muss aktiver Landwirt sein und eine landwirtschaftliche Tätigkeit ausüben") if {
	applicant.is_active_farmer == false
}

access_violations contains farm_violation("O6_1C-ELIG-003", "Förderwerbende Person muss aktiver Landwirt sein und eine landwirtschaftliche Tätigkeit ausüben") if {
	applicant.carries_out_agricultural_activity == false
}

# O6_1C-ELIG-004: Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr.
first_oepul_year if object.get(oepul, "first_participation_year", null) == year

minimum_farm_size_met if {
	object.get(input, ["land", "protected_cultivation_area_ha"], 0) >= params.general.minimum_farm_size_protected_cultivation_ha
}

minimum_farm_size_met if {
	object.get(input, ["land", "total_area_ha"], 0) >= params.general.minimum_farm_size_agricultural_area_ha
}

access_violations contains farm_violation("O6_1C-ELIG-004", "Betriebsmindestgröße im ersten ÖPUL-Teilnahmejahr (0,50 ha geschützter Anbau oder 1,50 ha landwirtschaftliche Fläche) nicht erreicht") if {
	first_oepul_year
	not minimum_farm_size_met
}

# O6_1C-ELIG-006: Bei einjährigen Maßnahmen kommt bei Nichterfüllung von
# Förder- bzw. Zugangsvoraussetzungen kein Vertrag zustande.
is_one_year_measure if {
	some row in lists.one_year_measures.rows
	row.measure_id == measure_id
}

contract_valid if {
	is_one_year_measure
	count(access_violations) == 0
	count(application_violations) == 0
	not deregistered_in_year
	not contract_ended_before_year
}
