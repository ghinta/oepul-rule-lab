# o6_3: Tabellen und tatsächliche Verbraucher

Gebunden an den rohen, unveränderten Run `v2-o6_3-opus-5.5-high-20260930`, Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Das Originalmerkblatt Oktober 2025 wurde vollständig gelesen: **sechs von sechs Seiten** einschließlich Ausnahmen, Tabellen und Aktualisierungen. Alle 13 JSON-Dateien, **35 Inventarcontainer mit 385 direkten Zeilen**, sämtliche verschachtelten Werte und sieben weitere Metadatencontainer wurden geprüft. Alle sieben nativen Rego-Module wurden vollständig gelesen.

Die sieben gemeinsamen Quellen stimmen im Hash mit der früheren vollständigen Lektüre überein; die relevanten Originalklauseln wurden neu verglichen, darunter Anhang A S.3, die gerenderte Kombinationstabelle S.103, Anhang I S.68, Anhang K S.99, SRL S.35/50 und die allgemeinen Tabellen. Keine Studienreferenzen, GM-Fallurteile oder Adaptations-Sollwerte verwendet. GSP-/MOG-Originale lagen diesem Run nicht vor; zusätzlich bekannte Rechtsquellen sind kein rückwirkender historischer Extraktionsmaßstab.

Alle acht Tarifkombinationen sind numerisch korrekt: 0/135/155 EUR im Jahr 2023 und 0/145,8/167,4 EUR ab 2024. Alle 20 RGVE-Faktoren und drei Schweine-GVE-Faktoren stimmen; GVE werden nicht als RGVE gezählt. Alle sieben Ackerfutterkulturen, fünf Grünlandklassen, Futterbeispiele und Praktiken sind erfasst. Ackerweide zählt zur Besatzfläche, aber nicht zur Heuprämie; Zweitkulturen zählen weder zur Besatzfläche noch zur Prämie.

## Befunde

- **O63-TABLE-001 · TABLE_CONSUMPTION · hoch**: UBB-Acker-DIV auf gemähtem Sonstigem Feldfutter kann trotz des ausdrücklichen Ausschlusses in SRL S.35 eine Heuprämie erhalten. Das tatsächlich gelesene Matrixpaar 3×1A=x bildet diese Teilflächenbedingung nicht ab. Dafür wurde eine neue Quellprobe vorbereitet; ein früherer AG-Fall wird nicht pauschal übertragen.
- **O63-TABLE-002 · IDENTITY_NORMALIZATION · mittel**: ATB S.7 nennt „Neusiedlersee“, gespeichert ist „Neusiedler See – Seewinkel“. Der exakte Vergleich verfehlt die Originalbezeichnung. Die Probe ist ausdrücklich Namensvertragsdiagnostik; keine kanonische App-Aliasabbildung. Relevante Bewirtschaftungsauflagen werden dagegen tatsächlich geprüft, anders als im vorigen Run.
- **O63-TABLE-003 · TABLE_CONSUMPTION · mittel**: Richtige Obergrenzen und Sanktionsstufen führen nicht zu einer vollständigen Zahlungskürzung. Kappung ist Diagnose, `sanction_share` ein nicht eingebundener Helper, die elf Kürzungsschritte bleiben Daten. Zahlungsproben besitzt der Quellen-/Regelagent.
- **O63-TABLE-004 · EXTERNAL_DEPENDENCY · mittel**: Die korrekten Faktoren setzen positiv klassifizierte Tierkategorien voraus. Futtermittel werden anhand von Beispiel-ID oder Gärungs-Flag geprüft; erlaubte Praktiken sind kein vollständiger ausführbarer Verarbeitungsvorgang. Keine unabhängige Produktzertifizierung durch bloße Listenanwesenheit.
- **O63-TABLE-005 · FOREIGN_SCOPE · niedrig**: GM01 mit 108 EUR Zuschlag ist ein Naturschutz-Satzexport. Er addiert keine zweite Heuprämie und berechnet keine vollständige Fremdzahlung. GM02/BH01 ist als kombinierte Quellzeile gespeichert; BH01 ab 2025 steht ergänzend in Anhang K S.99 und wird nicht strukturiert ausgeführt.
- **O63-TABLE-006 · SOURCE_VERSION · niedrig**: GSP-/MOG-Paketlücke und der UBB-Codefehler 1B auf SRL S.18 bleiben Quellenkontext. Eigene UBB-Bindung an 1A und Tarife sind an eindeutigen Originalstellen belegt.

## Vollständiges Inventar

Das JSON enthält jede unveränderte Zeile mit Originalseite, wörtlichem Beleg und tatsächlichen Codeverweisen. **515 Quellbindungen und 48 unterschiedliche Codezeilen** wurden verifiziert; kein Fehlzitat. Alle 13 Datenhashes und acht Quellhashes stimmen. Direkte Referenz bedeutet keine automatische semantische Vollständigkeit; unmittelbar wiederholte Bedingungen und lediglich dokumentierte Metadaten sind ausdrücklich bezeichnet.

| Container | Direkte Einträge | Inventarzählung | Verbraucher |
|---|---:|---:|---|
| `/rgve_key/rows` | 20 | 20 | direkt referenziert |
| `/rgve_key/eligible_species_groups` | 10 | 10 | nicht referenziert |
| `/rgve_key/dwarf_cattle_breeds` | 4 | 4 | nicht referenziert |
| `/rgve_key/non_roughage_gve_rows` | 3 | 3 | nicht referenziert |
| `/premium_rates/rows` | 8 | 8 | direkt referenziert |
| `/premium_rates/eligible_area_classes` | 2 | 2 | nicht referenziert |
| `/contract_periods/rows` | 3 | 3 | direkt referenziert |
| `/forage_areas/arable_forage_crops` | 7 | 7 | direkt referenziert |
| `/forage_areas/grassland_types` | 5 | 5 | direkt referenziert |
| `/feed_rules/not_permitted_feed_examples` | 4 | 4 | direkt referenziert |
| `/feed_rules/permitted_feed_examples` | 2 | 2 | nicht referenziert |
| `/feed_rules/permitted_practices` | 4 | 4 | nicht referenziert |
| `/feed_rules/prohibited_practices` | 10 | 10 | nicht referenziert |
| `/combination_table/measures` | 21 | 21 | nicht referenziert |
| `/combination_table/cells` | 134 | 134 | direkt referenziert |
| `/combination_table/legend` | 3 | 3 | nicht referenziert |
| `/combination_table/footnotes` | 4 | 4 | nicht referenziert |
| `/combination_table/farm_level_exclusions` | 5 | 5 | direkt referenziert |
| `/combination_table/required_companion_measures_o6_3` | 3 | 3 | direkt referenziert |
| `/general_params` | 18 | 34 | direkt referenziert |
| `/modulation/brackets` | 4 | 4 | direkt referenziert |
| `/premium_caps/rows` | 9 | 9 | direkt referenziert |
| `/sanctions/levels` | 8 | 8 | direkt referenziert |
| `/sanctions/recovery_reasons` | 5 | 5 | nicht referenziert |
| `/sanctions/assessment_criteria` | 4 | 4 | nicht referenziert |
| `/sanctions/reduction_order` | 11 | 11 | nicht referenziert |
| `/area_eligibility/non_eligible_area_types` | 10 | 10 | direkt referenziert |
| `/area_eligibility/mandatory_op_cases` | 7 | 7 | nicht referenziert |
| `/measure_lists/multi_year_measures` | 13 | 13 | direkt referenziert |
| `/measure_lists/annual_measures` | 13 | 13 | nicht referenziert |
| `/measure_lists/area_increase_restricted_measures` | 9 | 9 | direkt referenziert |
| `/measure_lists/annually_bound_area_measures` | 5 | 5 | nicht referenziert |
| `/measure_lists/public_body_permitted_measures` | 5 | 5 | nicht referenziert |
| `/measure_lists/conversion_paths` | 10 | 10 | nicht referenziert |
| `/naturschutz_interaction/rows` | 2 | 2 | direkt referenziert |

Die Kombinationstabelle verwendet eine vollständige **Sparse-Darstellung der 134 Nichtleerzellen**. Alle 134 Koordinaten, Marker, Zellfußnoten und Bedeutungen wurden gegen das Original geprüft; zusätzlich alle 286 impliziten Leerpaare. Keine fehlende positive Zelle, kein zusätzlich erlaubtes Paar, keine doppelte Koordinate. Die eigene Zeile und Spalte 3 umfassen **neun x und elf Leerzellen**. Es werden ausdrücklich nicht 420 gespeicherte Zeilen behauptet. Die vier Fußnotentexte sind vollständig vorhanden, werden aber nicht semantisch als Fremdmaßnahmen-Entscheidungsregeln ausgeführt.

Das Parameterobjekt besitzt 18 direkte Schlüssel; die Inventarzählung 34 entspricht den aufgefalteten Skalarwerten. Alle verschachtelten Werte wurden gelesen, einschließlich 183 Tagen Vegetationsperiode, strikt überwiegendem Anteil, 2-ha-/0,30-Grenzen, Flächenänderungen, Übernahmefristen, Auszahlungswerten und Warnungswechsel 2027. Quellenbeispiele sind als Beispiele erhalten; die vorhandenen Listen werden nicht zu einer behaupteten universellen Futter- oder Artenzulassung umgedeutet.

37 öffentliche Quellproben sind vorbereitet: acht Tarifkombinationen, 20 Tierfaktoren, sechs Futterbeispiele sowie Acker-DIV-/Parknamensfall mit Donau-Auen-Kontrolle. Die Eingabevokabeln stammen aus dem nativen Kandidaten, die Sollwerte aus Originalquellen. Tierkategorien und Futtermittel-IDs sind ausdrücklich positive vorgelagerte Klassifikationen. Keine eigene OPA-Ausführung behauptet; die zentrale Ausführung bleibt an den unveränderten Kandidaten und seine Laufzeit gebunden. Keine historischen Änderungen oder fachliche Freigabe.
