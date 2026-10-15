# o6_2: vollständige Tabellen- und Verbraucherprüfung

Gebunden an den unveränderten Run `v2-o6_2-opus-5.5-high-20260930`, Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Das neue Originalmerkblatt April 2026 wurde vollständig gelesen: **acht von acht Seiten** einschließlich Tabellen, Ausnahmen und Aktualisierungen. Alle sechs JSON-Dateien, **28 Inventarcontainer mit 249 direkten Zeilen**, sämtliche verschachtelten Werte und 23 weitere Metadatencontainer wurden geprüft. Alle acht nativen Rego-Module wurden vollständig gelesen.

Die sieben gemeinsamen Quellen haben identische Hashes wie bei der früheren vollständigen Quellenlektüre. Die einschlägigen Klauseln wurden neu gelesen, insbesondere SRL S.35/48/49/77, Anhang A S.3, die gerenderte Kombinationsmatrix S.103, die allgemeinen Tabellen und beide Dürreartikel vom August. **GSP-AV und MOG gehörten diesem Quellenpaket nicht an.** Später verfügbare Rechtskenntnis wird als zusätzlicher Kontext bezeichnet, nicht rückwirkend als historischer Extraktionsmaßstab verwendet.

Alle 14 Prämienzeilen einschließlich Jahresgrenzen, Nullsätzen und Besatzstufen sind numerisch korrekt. Alle 20 RGVE- und drei Schweine-GVE-Zeilen stimmen; GVE wird nicht als RGVE gezählt. Ebenfalls vollständig: vier Zwergrinderrassen, sieben Ackerfutterkulturen, 32 Basis-Fruchtzeichenketten und drei Ergänzungen ab 2025, 17 Düngemittelklassifikationen, drei PSM-Modi, zwei PSM-Codes und 41 Dürregebietseinträge. Korrektes Abschreiben ersetzt keine korrekte Anwendung der gespeicherten Einschränkungen.

## Konkrete Befunde

- **O62-TABLE-001 · TABLE_CONSUMPTION · hoch**: Die Kombinationstabelle wird tatsächlich benutzt, aber nur ihre Marker. AG-Flächen und UBB-Acker-DIV können deshalb die 2-Prämie erhalten, obwohl SRL S.77 beziehungsweise S.35 dies ausschließen. Dazu sind zwei Quellenproben sowie eine NAT-Leerzellenkontrolle vorbereitet. Der gespeicherte 50%-Abschlag betrifft richtig die Basisprämie 16; ein fehlender Abschlag auf die eigene 2-Prämie ist kein Befund.
- **O62-TABLE-002 · IDENTITY_NORMALIZATION · mittel**: Die Quelle umfasst Aronia-verwandte Züchtungen, Brombeerkreuzungen und andere Schalenfrüchte. Der Verbraucher akzeptiert nur gespeicherte exakte Fruchtnamen. Gruppenproben sind ausdrücklich als bedingte Namens-/Klassifikationsdiagnostik ausgewiesen; eine kanonische Sortenabbildung wird nicht behauptet.
- **O62-TABLE-003 · TABLE_CONSUMPTION · mittel**: Kalkalpen/andere Nationalparks sind pauschal als prämienmöglich gespeichert; die Ausnahme abhängig von relevanten Bewirtschaftungsauflagen fehlt auch im Verbraucher. Das ist eine bedingte Vertragslücke, keine Behauptung über tatsächlich bestehende Auflagen in einem beliebigen Park. Der Quellenagent besitzt die bedingte Probe.
- **O62-TABLE-004 · EXTERNAL_DEPENDENCY · mittel**: Die entsprechende Menge bei Biogasrücknahme wird nicht berechnet; ein Boolean vertritt den Nachweis. RGVE-Schlüssel setzen die richtige Art-/Alters-/Rasseklassifikation voraus; die Rassenliste wird nicht automatisch angewandt. Konkrete Eingabekonflikte prüft der Eingabeagent. Keine falschen Faktoren behauptet.
- **O62-TABLE-005 · SOURCE_VERSION · niedrig**: Fehlende GSP-/MOG-Originale begrenzen das historische Paket. Die falsche UBB-Codenennung 1B auf SRL S.18 stammt aus der Quelle; Pflicht 1A steht eindeutig in den eigenen Zugangsklauseln und ist korrekt gespeichert.

## Vollständiges Inventar

Das JSON enthält pro Zeile den unveränderten Wert, Quellseite und wörtlichen Beleg sowie genaue tatsächliche Rego-Verweise. Die 379 Quellbindungen wurden ohne Fehlzitat gegen die Originaltexte geprüft. Alle sechs Datenhashes und jede Originalzeile stimmen. Direkte Referenz bedeutet noch keine vollständige semantische Auswertung; identische unmittelbar formulierte Regeln sind bei unreferenzierten Daten ausdrücklich vermerkt.

| Container | Zeilen | Nativer Verbraucher |
|---|---:|---|
| `/o6_2_premium/rates` | 14 | direkt referenziert |
| `/o6_2_rgve/key` | 23 | direkt referenziert |
| `/o6_2_rgve/dwarf_cattle_breeds` | 4 | nicht referenziert |
| `/o6_2_rgve/livestock_farm_species_groups` | 9 | direkt referenziert |
| `/o6_2_combinations/required_concurrent_measures` | 1 | nicht referenziert |
| `/o6_2_combinations/business_level_exclusions` | 1 | nicht referenziert |
| `/o6_2_combinations/single_area_combination_row` | 20 | direkt referenziert |
| `/o6_2_combinations/premium_reductions_on_combination` | 1 | nicht referenziert |
| `/o6_2_combinations/measure_switch_targets` | 10 | nicht referenziert |
| `/o6_2_lists/arable_forage_crops` | 7 | direkt referenziert |
| `/o6_2_lists/glaez8_npf_forage_crops_without_forage_premium_until_2024` | 3 | direkt referenziert |
| `/o6_2_lists/fruit_crops` | 32 | direkt referenziert |
| `/o6_2_lists/fruit_crops_from_2025` | 3 | direkt referenziert |
| `/o6_2_lists/non_eligible_land_use_codes` | 1 | nicht referenziert |
| `/o6_2_lists/non_eligible_crop_types` | 8 | direkt referenziert |
| `/o6_2_lists/fertilizer_inputs` | 17 | direkt referenziert |
| `/o6_2_lists/psm_application_modes` | 3 | direkt referenziert |
| `/o6_2_lists/psm_codes` | 2 | nicht referenziert |
| `/o6_2_general/contract_periods` | 3 | direkt referenziert |
| `/o6_2_general/public_body_eligible_measures` | 5 | nicht referenziert |
| `/o6_2_general/allowed_land_use_conversions` | 3 | direkt referenziert |
| `/o6_2_general/modulation_tiers` | 4 | direkt referenziert |
| `/o6_2_general/area_payment_caps` | 9 | direkt referenziert |
| `/o6_2_general/sanction_levels` | 8 | direkt referenziert |
| `/o6_2_general/reduction_order` | 11 | nicht referenziert |
| `/o6_2_general/national_parks` | 4 | direkt referenziert |
| `/o6_2_general/no_premium_codes` | 2 | direkt referenziert |
| `/o6_2_drought_2026/harvest_obligation_exempt_districts` | 41 | direkt referenziert |

Die gesamte Zeile und Spalte 2 aus Anhang L wurden gegen die gerenderte Originalseite geprüft: **zwölf x, ein a, sieben Leerzellen**, alle 20 Partner korrekt. Die Headerfußnoten 4 bei 8/16 und 2 bei 13 sowie sämtliche vier Fußnotentexte sind erhalten. Es fehlen keine Partner und es gibt keine doppelten Koordinaten.

Außerhalb des Inventars wurden unter anderem beide Besatzschwellen 0,30/1,40, die vollständigen Trainingsparameter, 170-kg-N-Grenze, Mindestgrößen, Flächenzu-/abgangswerte, Übernahmefristen, Auszahlung und Viehzählmethoden geprüft. Einige sind lediglich dokumentiert oder unmittelbar im Code wiederholt. Der Kürzungsablauf ist ausdrücklich nur teilweise umgesetzt; fremde Prämienobergrenzen werden nicht als vollständig implementierte Entscheidungen anderer Maßnahmen ausgegeben.

22 öffentliche Quellproben sind zur zentralen Ausführung vorbereitet: alle 14 Prämienzeilen, zwei Kombinationseinschränkungen mit NAT-Kontrolle sowie fünf ausdrücklich bedingte Fruchtnamenfälle. Hier wird keine eigene OPA-Ausführung behauptet. Die numerische Besonderheit der angehefteten Laufzeit bleibt getrennt von Tarif- und Quellinhalt. Keine historischen Änderungen, Modelle, privaten Studienfälle oder fachliche Freigabe.
