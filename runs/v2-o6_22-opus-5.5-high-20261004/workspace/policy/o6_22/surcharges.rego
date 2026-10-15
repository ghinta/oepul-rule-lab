# Modul: o6_22 – optionale Zuschläge (unkupiert, GVO-frei, Festmistkompostierung)
package oepul.o6_22

# ---------------------------------------------------------------------------
# Zuschlag unkupierte Tiere (O622-UNK-001 bis O622-UNK-004)
# ---------------------------------------------------------------------------

unkupiert_active_categories := {row.category |
	some code in active_codes
	row := application_code_row(code)
	row.surcharge == "unkupiert"
	row.category in active_categories
}

# Alle an der Kategorie teilnehmenden Tiere (Tierwohlstall) ganzjährig unkupiert.
group_all_undocked(g) if object.get(g, ["pig_welfare", "participating_animals_all_undocked_full_year"], false) == true

unkupiert_ok(c) if {
	c in unkupiert_active_categories
	every g in pig_groups {
		undocked_or_other_category(g, c)
	}
}

undocked_or_other_category(g, c) if not group_measure_category(g) == c

undocked_or_other_category(g, c) if {
	group_measure_category(g) == c
	group_all_undocked(g)
}

violations contains {
	"rule_id": "O622-UNK-001",
	"message": sprintf("Zuschlag unkupiert für Kategorie '%v': nicht alle teilnehmenden Tiere sind im gesamten Antragsjahr unkupiert", [c]),
} if {
	some c in unkupiert_active_categories
	not unkupiert_ok(c)
}

# ---------------------------------------------------------------------------
# Zuschlag GVO-freie Eiweißfuttermittel (O622-GVO-001 bis O622-GVO-005)
# ---------------------------------------------------------------------------

gvo_active if "gvo_frei" in active_codes

protein_feed := object.get(pig_farm, "protein_feed", {})

# O622-GVO-003: Eiweißfuttermittel-Definition (> 20 % Rohprotein in der Trockenmasse,
# Raufuttermittel ausgenommen).
is_protein_feed(feed) if {
	feed.type == "compound"
	feed.crude_protein_percent_dm > params.protein_feed_min_crude_protein_percent_dm_exclusive
}

is_protein_feed(feed) if {
	feed.type == "single_component"
	object.get(feed, "is_roughage", false) == false
	feed.typical_crude_protein_percent_dm > params.protein_feed_min_crude_protein_percent_dm_exclusive
}

# O622-GVO-001 / O622-GVO-005: GVO-frei und europäische Herkunft (Kontinent Europa).
feed_compliant(feed) if {
	feed.gmo_free == true
	feed.origin_continent == "europe"
}

# O622-GVO-004: Nachweis bei zugekauften Eiweißfuttermitteln.
feed_proof_ok(feed) if object.get(feed, "produced_on_farm", false) == true

feed_proof_ok(feed) if {
	object.get(feed, "produced_on_farm", false) == false
	object.get(feed, "proof_documents_available", false) == true
}

non_compliant_protein_feeds contains feed.name if {
	some feed in object.get(protein_feed, "feeds", [])
	is_protein_feed(feed)
	not feed_compliant(feed)
}

violations contains {
	"rule_id": "O622-GVO-001",
	"message": sprintf("Zuschlag GVO-frei: nicht konformes Eiweißfuttermittel '%v' am Betrieb gelagert oder verfüttert (gilt für alle Tierarten)", [name]),
} if {
	gvo_active
	some name in non_compliant_protein_feeds
}

violations contains {
	"rule_id": "O622-GVO-002",
	"message": "Zuschlag GVO-frei: Lagerung oder Verfütterung nicht konformer Eiweißfuttermittel (auch Restbestände, andere Tierarten) am Betrieb",
} if {
	gvo_active
	object.get(protein_feed, "non_compliant_protein_feed_stored_or_fed", false) == true
}

violations contains {
	"rule_id": "O622-GVO-004",
	"message": sprintf("Zuschlag GVO-frei: kein Herkunfts- bzw. GVO-Freiheitsnachweis für zugekauftes Eiweißfuttermittel '%v'", [feed.name]),
} if {
	gvo_active
	some feed in object.get(protein_feed, "feeds", [])
	is_protein_feed(feed)
	not feed_proof_ok(feed)
}

# ---------------------------------------------------------------------------
# Zuschlag Festmistkompostierung (O622-FMK-001 bis O622-FMK-010)
# ---------------------------------------------------------------------------

festmist_active if {
	"festmistkompostierung" in active_codes
	year >= params.festmist_surcharge_from_year
}

composting := object.get(pig_farm, "manure_composting", {})

sorted_turn_dates(heap) := sort(object.get(heap, "turn_dates", []))

turn_intervals_days(heap) := [d |
	dates := sorted_turn_dates(heap)
	some k in numbers.range(1, count(dates) - 1)
	d := days_between(dates[k - 1], dates[k])
]

# O622-FMK-003: mindestens zweimal im Abstand von >= 14 Kalendertagen umgesetzt.
turned_sufficiently(heap) if {
	count(sorted_turn_dates(heap)) >= params.compost_min_turnings
	every d in turn_intervals_days(heap) {
		d >= params.compost_min_turning_interval_days
	}
}

# O622-FMK-004 / O622-FMK-005: Kompostwender (am Betrieb oder überbetrieblich belegt);
# Miststreuer/gleichwertiges Gerät nur bei vollständigem Umsetzen; Frontlader unzulässig.
turning_device_ok(heap) if {
	heap.turning_device == "compost_turner"
	heap.device_on_farm_or_use_documented == true
}

turning_device_ok(heap) if {
	heap.turning_device in {"manure_spreader", "equivalent_device"}
	heap.device_on_farm_or_use_documented == true
	heap.heap_fully_turned == true
}

# O622-FMK-006 / O622-FMK-007: Mischung/Schichtung mit organischem Material der
# Feldproduktion oder Strauch-/Astschnitt, ohne Umsetzpflicht.
mixed_heap_ok(heap) if {
	heap.mixed_with_plant_material == true
	heap.plant_material_noteworthy_share == true
	heap.composting_procedure_applied == true
	object.get(heap, "straw_rich_manure_only", false) == false
}

heap_ok(heap) if {
	turned_sufficiently(heap)
	turning_device_ok(heap)
}

heap_ok(heap) if mixed_heap_ok(heap)

violations contains {
	"rule_id": "O622-FMK-002",
	"message": "Zuschlag Festmistkompostierung: nicht der gesamte am Betrieb anfallende Festmist (aller Tierarten) wird am Betrieb kompostiert",
} if {
	festmist_active
	object.get(composting, "all_solid_manure_composted_on_farm", false) != true
}

violations contains {
	"rule_id": "O622-FMK-003",
	"message": sprintf("Zuschlag Festmistkompostierung: Kompostmiete %v erfüllt weder Umsetzvorgaben (>= 2 x, >= 14 Tage, Kompostwender) noch die Vorgaben für Mischmieten", [heap.heap_id]),
} if {
	festmist_active
	some heap in object.get(composting, "heaps", [])
	not heap_ok(heap)
}

violations contains {
	"rule_id": "O622-FMK-003",
	"message": "Zuschlag Festmistkompostierung: keine Kompostmiete angegeben",
} if {
	festmist_active
	count(object.get(composting, "heaps", [])) == 0
}

violations contains {
	"rule_id": "O622-FMK-008",
	"message": "Zuschlag Festmistkompostierung: Anlage, Umsetzen, Ausbringung bzw. Abgabe des Komposts nicht dokumentiert",
} if {
	festmist_active
	object.get(composting, "records_complete", false) != true
}

violations contains {
	"rule_id": "O622-FMK-009",
	"message": "Zuschlag Festmistkompostierung: Vorgaben der Nitrat-Aktionsprogramm-Verordnung für Kompostmieten nicht eingehalten",
} if {
	festmist_active
	not napv_compost_storage_ok
}

# O622-FMK-009: NAPV § 6 Abs. 1 Z 3 – Lagerung zur Kompostierung auf unbefestigten
# Flächen nur bei Einhaltung von § 6 Abs. 7 Z 2, 4, 5 und 6 und abgedeckter Miete.
napv_compost_storage_ok if object.get(composting, "heaps_on_unpaved_ground", false) == false

napv_compost_storage_ok if {
	composting.heaps_on_unpaved_ground == true
	napv := object.get(composting, "napv", {})
	napv.distance_to_surface_water_m >= 25
	napv.flat_non_sandy_ground == true
	napv.no_runoff_risk_to_surface_water == true
	napv.not_waterlogged_soil == true
	napv.groundwater_distance_m > 1
	napv.heap_covered == true
}

violations contains {
	"rule_id": "O622-FMK-010",
	"message": "Zuschlag Festmistkompostierung kann für Kompostställe nicht gewährt werden",
} if {
	festmist_active
	object.get(composting, "is_compost_barn", false) == true
}
