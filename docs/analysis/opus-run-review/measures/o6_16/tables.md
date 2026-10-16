# o6_16 – Alle Tabellen und ihre Verbraucher

25 öffentliche Entwicklungsfälle mit 50 typisierten Prüfungen: 48 erfüllt, 2 nicht erfüllt. Native Statuswerte: `{'defined': 24, 'undefined': 1}`. Das sind gezielte Entwicklungsfälle, keine Genauigkeitsquote oder Expertenabnahme.

Alle 33 tatsächlich katalogisierten Dateizeiger sind in [tables.json](tables.json) mit Hash, Zeilenzahl, Quellverweisen, Befund und tatsächlichen Verbrauchern dokumentiert. Eine vollständige Datentabelle belegt noch keine ausführbare Prüfung ihrer Pflichten.

Der neue Abgleich von Anhang G umfasst alle 20 Seiten 40–59 und alle sechs Felder jeder der 1.566 Zeilen einschließlich Gemeinde, KG-Name und Quellseite. Die Spaltengrenzen wurden aus den gedruckten Tabellenköpfen bestimmt. Die 1.565 eindeutigen KG und die doppelte Quellzeile Bergham 51106 bleiben erhalten. Zehn Randmarkierungen 1b mussten im eigenen Parser von den KG-Nummern getrennt werden; Seite 54 wurde dafür zusätzlich visuell gelesen. Das waren Parserkorrekturen, keine Opus-Fehler. Die ältere zeitliche Kulisse der Karten 38/39 ist damit nicht geklärt.

Anhang L wurde auf Seite 103 vollständig als Text und Bild gelesen: 21 Maßnahmenzeilen, 420 gerichtete Zellen und alle vier Fußnoten. Die NAPV-Tabelle 18 wurde mit allen 27 Zeilen und 270 Feldern unabhängig aus dem PDF abgeleitet; 190 Zahlen und 80 leere/null Felder stimmen. Ungewöhnliche gedruckte Gerstenwerte wurden nicht geglättet. Auch die übrigen aktuellen NAPV-Tabellen auf 10–19 einschließlich Ertragsklassen und Fußnoten wurden mit den gelieferten Daten verglichen.

| Tabelle | Zeilen/Schlüssel | Statische Verbraucherstellen |
|---|---:|---:|
| `ag_permitted_land_uses` | 4 | 2 |
| `annex_a_gve_key` | 23 | 1 |
| `annex_g_cadastral_communities` | 1566 | 2 |
| `annex_l_combination_table` | 21 | 0 |
| `annex_l_footnotes` | 4 | 0 |
| `applicant_public_body_exempt_measures` | 5 | 0 |
| `arable_forage_crops` | 7 | 1 |
| `cereals` | 11 | 0 |
| `contract_periods` | 3 | 1 |
| `drought_2026_harvest_waiver_districts` | 41 | 1 |
| `field_vegetables` | 56 | 1 |
| `modulation_brackets` | 4 | 1 |
| `n_carryover_parameters` | 2 | 1 |
| `n_reduction_zones` | 4 | 2 |
| `napv_anlage2_ammonium_share` | 9 | 1 |
| `napv_anlage3_a2_vegetable_nmin` | 11 | 0 |
| `napv_anlage3_a3_previous_crop_effect` | 22 | 0 |
| `napv_anlage3_a5_uptake_factors` | 30 | 1 |
| `napv_anlage3_a5_wheat_barley_uptake` | 27 | 1 |
| `napv_anlage3_t1_arable_caps` | 29 | 0 |
| `napv_anlage3_t2_arable_caps_anlage5` | 29 | 0 |
| `napv_anlage3_t3_vegetable_caps` | 9 | 0 |
| `offered_federal_states` | 6 | 1 |
| `payment_caps` | 9 | 2 |
| `pig_category_gve_mapping` | 8 | 1 |
| `pig_crude_protein_limits` | 8 | 1 |
| `premium_rates` | 10 | 1 |
| `psm_banned_active_substances` | 5 | 1 |
| `psm_codes_until_2025` | 2 | 0 |
| `psm_restricted_crops` | 8 | 2 |
| `sanction_stages` | 7 | 2 |
| `soil_sample_parameters` | 5 | 1 |
| `training_topics` | 4 | 0 |

Die beiden Acker-Obergrenzentabellen enthalten je 29 Kulturzeilen und je 114 gespeicherte Klassen. Gemüse umfasst neun Zeilen mit drei Klassen; Nmin elf Zeilen mit zwei Zahlen, Vorfruchtwirkung 22 und Entzugsfaktoren 30. Alle zehn Prämienkomponenten mit drei Jahreswerten und die geschlossenen Listen wurden vollständig geprüft. Ertragsgrenzen und bedingte Klammerwerte sind teils nur Metadaten; daraus wird kein tatsächlich implementierter NAPV-Verbraucher konstruiert.

Stallmistkompost speichert die Quellenangabe <1 als Qualifier, während der Rechenverbraucher den Zahlenwert 1 exakt verwendet. Die Speicherung wird gutgeschrieben, der verlorene Unsicherheitsumfang bleibt ein Befund. Die 23 Anhang-A-Zeilen stimmen; für diese Maßnahme werden davon die Schweinefaktoren verwendet. Eberzuordnung und außerhalb des Schweinebereichs nicht strukturierte Fußnotendefinitionen bleiben ausdrücklich offen.

Die Tabellen sind vollständig gelesen und abgeglichen im angegebenen Umfang. Für allgemeine Anhang-L-Kombinationen, NAPV-Kappung und Kursthemen fehlen tatsächliche allgemeine Verbraucher; andere Tabellen werden nur in separaten Helfern verwendet. Die volle früher dokumentierte Lektüre der gemeinsamen Originale wird bei identischen Hashes wiederverwendet; eine neue vollständige Lektüre aller 103 Anhangseiten wird nicht behauptet.
