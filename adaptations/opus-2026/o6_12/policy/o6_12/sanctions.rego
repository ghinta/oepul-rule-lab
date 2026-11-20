package oepul.o6_12

# Verwaltungssanktionen bei Nichteinhaltung inhaltlicher Bewirtschaftungsauflagen (§ 48 GSP-AV,
# SRL 1.12.1.3, Allg. TNB 8.2).

violations := object.get(o612, "violations", [])

level_percent(level, yr) := l.reduction_percent_from_2027 if {
	some l in data.o6_12.sanction_levels
	l.level == level
	yr >= sanction_rules.warning_replaced_by_retention_from_year
}

level_percent(level, yr) := l.reduction_percent if {
	some l in data.o6_12.sanction_levels
	l.level == level
	yr < sanction_rules.warning_replaced_by_retention_from_year
}

# Wiederholter Verstoß gegen dieselbe Förderverpflichtung: ab dem 2. Mal eine Stufe höher, ab dem 3. Mal zwei Stufen usw.
effective_level(v) := min([7, v.level + max([object.get(v, "occurrence_same_obligation", 1) - 1, 0])])

violation_percent(v) := level_percent(effective_level(v), year)

content_reduction_percent := min([sanction_rules.max_annual_reduction_percent, sum([violation_percent(v) | some v in violations])])

full_reduction_this_year if content_reduction_percent >= 100

full_reductions_in_period := object.get(o612, "previous_full_reductions", 0) + count({1 | full_reduction_this_year})

# Zweimalige 100 %-Kürzung im Vertragszeitraum: Ausschluss und Rückforderung bis Verpflichtungsbeginn.
excluded_from_measure if full_reductions_in_period >= sanction_rules.exclusion_after_full_reductions_in_period

# Mehr als drei Verstöße bei einer Vor-Ort-Kontrolle oder schwerwiegender Verstoß: bis zu 100 % Kürzung möglich.
full_reduction_possible if {
	count([v | some v in violations; v.detected_by == "on_site"]) > sanction_rules.on_site_max_violations_before_full_reduction
}

full_reduction_possible if {
	some v in violations
	v.serious == true
}

# Untererklärung (§ 47 GSP-AV): Kürzung um bis zu 3 % aller flächenbezogenen Beihilfen.
underdeclaration_reduction_possible if {
	undeclared := object.get(input, ["oepul", "undeclared_parcels_area_ha"], 0)
	declared_total := object.get(input, ["land", "total_area_ha"], 0)
	declared_total > 0
	undeclared > (sanction_rules.underdeclaration_threshold_percent / 100) * declared_total
}
