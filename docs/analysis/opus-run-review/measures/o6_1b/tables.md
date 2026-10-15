# o6_1b: vollständige Tabellen- und Verbraucherprüfung

Gebunden an den unveränderten Run `v2-o6_1b-opus-5.5-high-20260925`, Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Die 51 Seiten des BIO-Originalmerkblatts April 2026 wurden vollständig neu gelesen. Die sieben gemeinsamen Quellen stimmen im Hash mit der vorangegangenen vollständigen Quellenlektüre überein; die BIO-Kombinationszeile und die hier benötigten Klauseln wurden neu verglichen. Keine Änderungen an historischen Daten, Regeln, Quellen oder Profilen.

Alle acht JSON-Dateien, alle **92 im Dateninventar bezeichneten Tabellencontainer** und sämtliche darin enthaltenen Werte wurden geprüft. Das JSON-Protokoll enthält zu jeder Zeile den unveränderten Wert, Originalseiten/-zitate sowie genaue Rego-Verbraucher. Diese Vollständigkeitsangabe bezeichnet den dokumentierten Prüfumfang; sie ist keine fachliche Freigabe.

Die **40 Prämienkomponenten** einschließlich Landes-Top-up, sämtliche Jahresstaffeln, **85 Sortenzeilen**, **73 Acker- und 68 Grünland-Artenzeilen**, **20 RGVE- und 3 Schweine-GVE-Zeilen** sowie alle **41 Dürregebiets-/Wildcard-Einträge** wurden verglichen. Keine fehlende BIO-Sortenzeile oder falscher numerischer Prämiensatz festgestellt. Der frühere UBB-Befund über74 Ackerzeilen ist hier nicht übertragbar: Das BIO-Blatt enthält73 Artenzeilen. Ebenso besitzt dieser Run bereits eine tatsächlich verwendete 15 Einträge umfassende Erosions-Aliastabelle.

## Konkrete Auswertungsbefunde

- **BIO-TABLE-001 · TABLE_CONSUMPTION · medium**: Artenzähler ersetzen eine ausgeführte Listenprüfung. Der native Code übernimmt species_count, family_count und species_outside_list als Zusammenfassungen; die 73 bzw. 68 Artenzeilen werden nicht ausgewertet. species_outside_list hat bei fehlender Angabe den günstigen Standardwert 0. Die App muss externe, positiv geprüfte Zähler von einer durch den Run ausgeführten Listenprüfung unterscheiden.
- **BIO-TABLE-002 · IDENTITY_NORMALIZATION · high**: Sortenlookup bindet die Kultur nicht und erkennt offene Gruppen nicht. Der Lookup vergleicht Sortenname und Jahr, jedoch nicht die tatsächliche Kultur. Damit kann eine Mais-Sorte auf einem Weizenschlag einen SLK-Satz auslösen. Die sieben ausdrücklich offenen Herkunfts-/Sortengruppen werden nur als exakte Überschriftentexte erkannt. Alle 85 Tabellenzeilen sind vorhanden; die Identitätsprüfung ist unvollständig.
- **BIO-TABLE-003 · TABLE_CONSUMPTION · high**: Streifenbau-Ausnahme ist nicht auf die beiden Mohnsorten begrenzt. crop.poppy_strip_cultivation=true reicht bei jeder gelisteten Sorte als Reinheitsnachweis, auch bei nicht sortenreinem Mais. Die Quelle beschränkt diese Ausnahme auf Edel-Rot und Edel-Weiß. Die korrekte Zweierliste wird von keiner Regel gelesen.
- **BIO-TABLE-004 · IDENTITY_NORMALIZATION · high**: Tomaten-Synonyme bleiben ein gemeinsamer Literalwert. Alle 56 Feldgemüse-Einträge sind erhalten. Einzeln eingegebene Tomaten oder Paradeiser treffen den gemeinsamen Literalwert Paradeiser/Tomaten jedoch nicht. Dadurch entfällt der Zuschlag von 216 Euro/ha ab 2024 allein aufgrund der Schreibweise.
- **BIO-TABLE-005 · IDENTITY_NORMALIZATION · high**: Zuckermais fehlt im Mais-Classifier der Anbaudiversifizierung. crop_species_map enthält Zuckermais nicht, während die Erosions-Aliastabelle Zuckermais bereits Mais zuordnet. is_maize prüft nach der Normalisierung ausschließlich den Wert Mais. Zuckermais kann dadurch der gemeinsamen 75-Prozent-Grenze für Getreide und Mais entgehen.
- **BIO-TABLE-006 · IDENTITY_NORMALIZATION · high**: Raps-Normalisierung ist zwischen Diversifizierung und FWK ungleich. Winterraps und Sommerraps werden für die Anbaudiversifizierung zu Raps normalisiert. fw_group_rates übernimmt diese Normalisierung nicht. Wenn Kultur und Schlagnutzungsart Winterraps lauten, entfällt der sonst passende FWK-Satz von 86,4 Euro/ha.
- **BIO-TABLE-007 · FOREIGN_SCOPE · high**: UBB-Code löst BIO-Ausnahme ohne BIO-Prämienausschluss aus. drought_2026_opt_out akzeptiert OPUBB; opted_out schließt dagegen nur OP und OPBIO von der BIO-Prämie aus. Ein BIO-Schlag kann dadurch die Ausnahme für vorzeitige bzw. dritte Nutzung erhalten und weiter BIO-Prämie auslösen. Die Meldung verlangt, dass für die betroffene Maßnahme keine Prämie gewährt wird.
- **BIO-TABLE-008 · TABLE_CONSUMPTION · high**: LSE-Kombinationsbeschränkungen werden nur bei DIV-Codierung umgesetzt. NAT-, EBW-, BAW- und AG-Flächen werden nur dann von der BIO-Prämie ausgeschlossen, wenn sie zugleich als DIV erkannt werden. Ein NAT-Ackerschlag ohne DIV erhält so 2026 die BIO-Basisprämie von 235 Euro/ha. Anhang L lässt die Kombination mit NAT/EBW nur für Landschaftselemente zu; Fußnote 4 enthält die entsprechende Einschränkung für BAW/AG. Die gespeicherte Kombinationszeile wird nicht gelesen.
- **BIO-TABLE-009 · TABLE_CONSUMPTION · medium**: Pheromonfallen-Aufbewahrungsfrist wird nicht ausgewertet. general.pheromone.keep_traps_until=09-30 ist korrekt gespeichert. pzr_eligible prüft die Aufbewahrung bis zu diesem Datum jedoch nicht. Diese Pflicht ist von den mindestens 35 Tagen Betrieb am Feld zu unterscheiden.
- **BIO-TABLE-010 · EXTERNAL_DEPENDENCY · medium**: Monitoring-Gegenrichtung und EBW-Matrix bleiben externe Abhängigkeiten. Monitoring-Regeln prüfen eingetragene Optionen, jedoch nicht die Teilnahmeverpflichtung aus TA01 bzw. GL06/GL15/GL25. Die EBW-Anrechenbarkeit wird als ebw_habitat_creditable übernommen; die genaue Lebensraum/Nutzungs-Matrix ist im gesonderten EBW-Informationsblatt beschrieben, das nicht zu diesen Run-Quellen gehört. Daraus folgt keine vollständige Kombinationen- oder EBW-Listenprüfung.
- **BIO-TABLE-011 · SOURCE_VERSION · low**: Wissenschaftliche Namen unterscheiden sich bereits zwischen Originalquellen. BIO schreibt im Ackerabschnitt Scorconeroides und im Grünlandabschnitt Scorzoneroides; Plantago lanceolate im BIO-Blatt steht Plantago lanceolata im Anhang gegenüber. Die Daten geben die BIO-Originalschreibweisen wieder. Diese Konflikte sind keine Modellhalluzinationen; Taxon-Aliasse werden hier nicht fachlich zugelassen.

## Vollständiges Inventar

`referenziert` bezeichnet einen direkten Rego-Verweis, noch keine vollständige fachliche Auswertung jeder Tabellenzeile. Nicht referenzierte Beispiele können sachgerecht reine Dokumentation sein; bei normativen Einschränkungen sind die Folgen oben einzeln beschrieben.

| Tabelle | Einträge | Verbraucher |
|---|---:|---|
| `combination.legend` | 5 | nicht referenziert |
| `combination.row_1b` | 20 | nicht referenziert |
| `combination.cross_measure_effects` | 3 | nicht referenziert |
| `combination.footnotes` | 4 | nicht referenziert |
| `general.contract_periods` | 3 | referenziert |
| `general.deadlines` | 7 | referenziert |
| `general.measure_switch_into_o6_1b_from` | 4 | referenziert |
| `general.min_farm_size_first_year` | 2 | referenziert |
| `general.area_loss_tolerance` | 3 | referenziert |
| `general.area_increase` | 4 | referenziert |
| `general.takeover_deadline` | 2 | referenziert |
| `general.tolerances` | 2 | referenziert |
| `general.modulation_bands` | 4 | nicht referenziert |
| `general.area_payment_caps` | 5 | referenziert |
| `general.sanction_levels` | 9 | referenziert |
| `general.payment` | 3 | referenziert |
| `general.multiple_reduction_order` | 11 | nicht referenziert |
| `general.national_parks_no_area_premium` | 2 | referenziert |
| `general.diversification` | 3 | referenziert |
| `general.arable_div` | 16 | referenziert |
| `general.grassland_div` | 10 | referenziert |
| `general.divrs_arable` | 3 | referenziert |
| `general.training` | 5 | referenziert |
| `general.own_use_animals` | 2 | referenziert |
| `general.wildkraeuter` | 4 | referenziert |
| `general.pheromone` | 5 | referenziert |
| `general.hedge` | 5 | referenziert |
| `general.lse` | 4 | referenziert |
| `lists.excluded_land_use_types` | 11 | nicht referenziert |
| `lists.excluded_land_use_type_keys` | 11 | referenziert |
| `lists.non_premium_measure_land_use_types` | 2 | referenziert |
| `lists.cereals` | 11 | referenziert |
| `lists.not_cereals` | 7 | nicht referenziert |
| `lists.maize` | 1 | referenziert |
| `lists.arable_forage` | 7 | referenziert |
| `lists.diversification_55_exempt_from_2025` | 2 | referenziert |
| `lists.diversification_basis_excluded` | 3 | nicht referenziert |
| `lists.crop_species_map` | 33 | referenziert |
| `lists.insect_pollinated_examples` | 33 | nicht referenziert |
| `lists.invasive_species_early_cut` | 4 | nicht referenziert |
| `lists.div_mechanical_removal_implements` | 5 | referenziert |
| `lists.sowing_exemption_oepul2015_codes` | 7 | nicht referenziert |
| `lists.arable_div_land_use_types` | 3 | referenziert |
| `lists.arable_divrs_land_use_types` | 2 | referenziert |
| `lists.arable_div_other_measure_codes` | 4 | referenziert |
| `lists.arable_div_excluded_from_over7_supplement_codes` | 5 | nicht referenziert |
| `lists.grassland_div_land_use_types` | 4 | referenziert |
| `lists.grassland_div_variant_codes` | 4 | referenziert |
| `lists.grassland_div_other_measure_codes` | 3 | referenziert |
| `lists.grassland_div_nat_creditable_auflagen` | 32 | referenziert |
| `lists.grassland_div_n2_creditable_auflagen` | 6 | referenziert |
| `lists.parameters` | 3 | referenziert |
| `lists.steep_slope_land_use_types` | 4 | referenziert |
| `lists.streuobst_species` | 15 | referenziert |
| `lists.streuobst_wild_forms_allowed` | 3 | referenziert |
| `lists.streuobst_stem_forms` | 2 | referenziert |
| `lists.foerderwuerdige_groups` | 5 | referenziert |
| `lists.bhg_crops` | 53 | referenziert |
| `lists.bhg_code_land_use_types` | 3 | referenziert |
| `lists.kreislauf_acker_crops` | 15 | referenziert |
| `lists.feldgemuese` | 56 | referenziert |
| `lists.erdbeeren` | 1 | referenziert |
| `lists.obst` | 34 | referenziert |
| `lists.woh_walnut_chestnut` | 2 | referenziert |
| `lists.erosion_prone_crops` | 8 | referenziert |
| `lists.erosion_reducing_measures_full_base` | 2 | referenziert |
| `lists.monitoring_programmes` | 4 | referenziert |
| `lists.excluded_combination_measures` | 5 | referenziert |
| `lists.bee_non_eligible_forms` | 4 | nicht referenziert |
| `lists.pheromone_land_use_types` | 2 | referenziert |
| `lists.psm_codes_until_2025` | 2 | referenziert |
| `lists.applicant_types_eligible` | 4 | referenziert |
| `lists.culture_areas` | 2 | referenziert |
| `lists.erosion_prone_crop_aliases` | 15 | referenziert |
| `lists.woh_crop_categories` | 3 | referenziert |
| `notices_2026.drought_2026_harvest_waiver_districts` | 5 | referenziert |
| `notices_2026.early_use_2026` | 7 | referenziert |
| `notices_2026.grassland_variant_changes_after_04_15` | 3 | referenziert |
| `notices_2026.grassland_variant_changes_forbidden_after_04_15` | 1 | nicht referenziert |
| `notices_2026.deadlines` | 1 | referenziert |
| `rare_varieties.varieties` | 85 | referenziert |
| `rare_varieties.poppy_strip_exception_varieties` | 2 | nicht referenziert |
| `rates.rows` | 40 | referenziert |
| `rates.caps` | 20 | referenziert |
| `regional_seed_species.arable` | 73 | nicht referenziert |
| `regional_seed_species.grassland` | 68 | nicht referenziert |
| `regional_seed_species.requirements` | 4 | referenziert |
| `rgve_key.rgve_factors` | 20 | referenziert |
| `rgve_key.pig_gve_factors` | 3 | nicht referenziert |
| `rgve_key.dwarf_cattle_breeds` | 4 | nicht referenziert |
| `rgve_key.thresholds` | 1 | referenziert |
| `rgve_key.livestock_species_counted` | 6 | nicht referenziert |

Die vorgeschlagenen öffentlichen Entwicklungsfälle im JSON stammen aus den Originalquellen; ihre unabhängige Ausführung und Ergebnisse werden zentral dokumentiert. Keine Modell-Selbsttests als Sollwert übernommen, keine private Referenzfälle betrachtet und keine Fehler behoben. Das Ergebnis bleibt ein Befund zur späteren manuellen Adaptation, keine Zulassung des nativen Runs für Zahlungsentscheidungen.
