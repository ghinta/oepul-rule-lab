# METADATA
# title: UBB (o6_1a) – Eigenschaft als tierhaltender Betrieb (RGVE-Schlüssel Kapitel 12 / Anhang A)
package oepul.o6_1a.livestock

import data.oepul.o6_1a.common

groups := object.get(input, ["livestock", "species_groups"], [])

rgve_factor(key) := row.rgve_per_head if {
	some row in common.tables.o6_1a_rgve_key
	row.key == key
	row.counts_for_rgve
}

# UBB-TH-002: RGVE nach Umrechnungsfaktoren; Durchschnittsbestand (anteilig bei Hineinwachsen) wird als animal_count übergeben.
group_rgve(g) := object.get(g, "average_count", object.get(g, "animal_count", 0)) * rgve_factor(object.get(g, "rgve_category", ""))

total_rgve := sum([group_rgve(g) | some g in groups; object.get(g, "kept_in_austria", true); rgve_factor(object.get(g, "rgve_category", ""))])

# UBB-TH-003: Futterfläche = Summe aller beantragten Grünland- und Ackerfutterflächen (auch NAT, Bergmähder).
forage_area_ha := common.forage_area_ha

stocking_density := total_rgve / forage_area_ha if forage_area_ha > 0

# UBB-TH-001: Tierhaltender Betrieb ab 0,30 RGVE je ha Futterfläche.
default is_livestock_farm := false

is_livestock_farm if stocking_density >= common.tables.o6_1a_livestock_thresholds.tierhaltend_min_rgve_per_ha_forage

# Hinweis auf Tierkategorien ohne RGVE-Faktor (z. B. Schweine, Geflügel).
unknown_categories contains object.get(g, "rgve_category", "") if {
	some g in groups
	not rgve_factor(object.get(g, "rgve_category", ""))
}
