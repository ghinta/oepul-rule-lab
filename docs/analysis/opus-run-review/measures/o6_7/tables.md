# Vollständige Tabellenprüfung – o6_7 System Immergrün

Geprüft wurde ausschließlich `v2-o6_7-opus-5.5-high-20260925` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Alle elf Seiten des neuen Maßnahmenmerkblatts einschließlich Beispiele, Tabellen, Übergänge und Aktualisierungen, sämtliche fünf Datendateien, neun Produktionsmodule und Rohannahmen wurden vollständig gelesen. Sieben gemeinsame Originalquellen sind durch identische SHA-256 an die vollständigen Vorlektüren gebunden; einschlägige aktuelle Klauseln und sämtliche Matrixkoordinaten wurden erneut abgeglichen.

Der abgeschlossene Zeilenledger [tables.json](tables.json) hat SHA-256 `14ee1c815fd8001c9dd6b3e0d51a717f4222fba45aa82a2ea105ce86f5d665d2`. Er enthält alle 58 Inventarpointer mit 448 direkten Einträgen einschließlich der Eltern-/Kindüberlappung. Die Inventarsumme 486 zählt dieselben Daten anders: /parameters hat zwölf direkte Schlüssel, die sich zu 50 terminalen Parametereinträgen entfalten; acht Unterpointer wiederholen 46 dieser 50 Einträge. Dabei zählt das native Inventar die vier Lückentupel als vier Zeilen. Es fehlen keine 38 Datensätze. Ohne diese Parameterdoppelabdeckung ergeben sich 440 terminale Tabellen-Eintragseinheiten. Alle Datenblätter und Metadaten liegen unter Inventarpointern; es gibt keinen zusätzlichen unüberprüften Metadatenzweig.

Originaldaten liegen unter `data.oepul.o6_7`, Produktionspakete und Proben unter `data.o6_7`. Diese Unterscheidung ist in den tatsächlichen Codeverbrauchern und in jeder Probe erhalten. Keine flache Ersatzladung, Typnormalisierung oder eigene OPA-Ausführung.

| Inventarpointer | Direkte Einträge | Inventarzahl | Tatsächlicher Tabellenverbrauch |
|---|---:|---:|---|
| `/combinations/legend` | 3 | 3 | Gespeichert, nicht referenziert |
| `/combinations/columns` | 21 | 21 | Gespeichert, nicht referenziert |
| `/combinations/annex_l_matrix` | 21 | 21 | Gesamte Matrix unreferenziert; eigener Partnerauszug separat aktiv |
| `/combinations/footnotes` | 4 | 4 | Gespeichert, nicht referenziert |
| `/combinations/o6_7_parcel_combinable_measures` | 8 | 8 | Direkte oder indirekte Referenz |
| `/combinations/farm_level_exclusions` | 8 | 8 | Gespeichert, nicht referenziert |
| `/general/modulation_brackets` | 4 | 4 | Direkte oder indirekte Referenz |
| `/general/sanction_steps` | 8 | 8 | Exporthelper; nicht im Prämienbetrag |
| `/general/payment_caps` | 9 | 9 | Jahres-/Ausnahmecodes aktiv; fremde Eurocaps nicht ausgeführt |
| `/general/multi_year_contract_periods` | 3 | 3 | Gespeichert, nicht referenziert |
| `/general/measure_switch_options` | 10 | 10 | Gespeichert, nicht referenziert |
| `/general/area_reduction_tolerance` | 4 | 4 | Gespeichert, nicht referenziert |
| `/general/area_access_restricted_measures` | 9 | 9 | Gespeichert, nicht referenziert |
| `/general/measures_with_annually_variable_area` | 5 | 5 | Gespeichert, nicht referenziert |
| `/general/take_over_only_in_individual_cases` | 10 | 10 | Gespeichert, nicht referenziert |
| `/general/multiple_reduction_order` | 11 | 11 | Gespeichert, nicht referenziert |
| `/lists/cereals` | 11 | 11 | Gespeichert, nicht referenziert |
| `/lists/not_cereals` | 8 | 8 | Gespeichert, nicht referenziert |
| `/lists/arable_fodder_crops` | 7 | 7 | Gespeichert, nicht referenziert |
| `/lists/field_vegetables` | 56 | 56 | Gespeichert, nicht referenziert |
| `/lists/fruit_crops` | 31 | 31 | Gespeichert, nicht referenziert |
| `/lists/fruit_crops_from_2025` | 3 | 3 | Gespeichert, nicht referenziert |
| `/lists/segment_kinds` | 4 | 4 | Gespeichert, nicht referenziert |
| `/lists/always_ungreened_usage_categories` | 1 | 1 | Direkte oder indirekte Referenz |
| `/lists/ungreened_period_codes` | 1 | 1 | Gespeichert, nicht referenziert |
| `/lists/coverage_base_included_categories` | 5 | 5 | Gespeichert, nicht referenziert |
| `/lists/coverage_base_included_measure_codes` | 3 | 3 | Gespeichert, nicht referenziert |
| `/lists/mechanical_removal_methods` | 5 | 5 | Direkte oder indirekte Referenz |
| `/lists/mechanical_removal_tillage_implements` | 8 | 8 | Gespeichert, nicht referenziert |
| `/lists/not_mechanical_removal_methods` | 2 | 2 | Gespeichert, nicht referenziert |
| `/lists/catch_crop_operations` | 13 | 13 | Gespeichert, nicht referenziert |
| `/lists/overwintering_care_operation_codes` | 3 | 3 | Gespeichert, nicht referenziert |
| `/lists/use_operation_codes` | 2 | 2 | Gespeichert, nicht referenziert |
| `/lists/problem_weeds_early_chopping` | 4 | 4 | Direkte oder indirekte Referenz |
| `/lists/record_events` | 4 | 4 | Direkte oder indirekte Referenz |
| `/lists/applicant_types` | 5 | 5 | Direkte oder indirekte Referenz |
| `/lists/territorial_authority_exception_measures` | 5 | 5 | Direkte oder indirekte Referenz |
| `/lists/gloez8_npf_catch_crop_variants_not_eligible_2024` | 6 | 6 | Direkte oder indirekte Referenz |
| `/lists/no_premium_parcel_codes` | 2 | 2 | Direkte oder indirekte Referenz |
| `/lists/no_premium_national_parks` | 2 | 2 | Direkte oder indirekte Referenz |
| `/lists/non_eligible_area_types` | 10 | 10 | Gespeichert, nicht referenziert |
| `/lists/non_eligible_area_type_codes` | 10 | 10 | Direkte oder indirekte Referenz |
| `/lists/op_code_mandatory_cases` | 7 | 7 | Gespeichert, nicht referenziert |
| `/lists/one_year_measures` | 13 | 13 | Direkte oder indirekte Referenz |
| `/lists/eco_scheme_art31_measures` | 5 | 5 | Gespeichert, nicht referenziert |
| `/lists/measures_requiring_participation_in_6_or_7` | 2 | 2 | Direkte oder indirekte Referenz |
| `/notices_2026/drought_harvest_exemption_regions` | 5 | 5 | Direkte oder indirekte Referenz |
| `/notices_2026/greening_measures_with_coverage_relief` | 3 | 3 | Gespeichert, nicht referenziert |
| `/notices_2026/proper_sowing_elements` | 6 | 6 | Gespeichert, nicht referenziert |
| `/parameters` | 12 | 50 | Elternobjekt; detaillierte Unterpointer und Feldverweise |
| `/parameters/access` | 1 | 1 | Direkte oder indirekte Referenz |
| `/parameters/coverage` | 3 | 3 | Direkte oder indirekte Referenz |
| `/parameters/gap_limits_days` | 4 | 4 | Direkte oder indirekte Referenz |
| `/parameters/catch_crop` | 11 | 11 | Direkte oder indirekte Referenz |
| `/parameters/contract` | 6 | 6 | Direkte oder indirekte Referenz |
| `/parameters/premium` | 8 | 8 | Direkte oder indirekte Referenz |
| `/parameters/drought_2026` | 4 | 4 | Direkte oder indirekte Referenz |
| `/parameters/general` | 9 | 9 | Direkte oder indirekte Referenz |

Die Matrix ist diesmal vollständig explizit gespeichert: 441 Zellen einschließlich 21 grauer Diagonalen, 134 positiver und 286 leerer Offdiagonalzellen. Alle fünf Felder jeder Zelle sowie sämtliche 21 Codes, 21 Zeilennamen und vier Fußnotentexte stimmen mit dem Original. Es gibt keine impliziten Leerpaare wie beim vorigen Run. Die Diagonalen sind technische null/false-Platzhalter und keine eigenständige Quellenbehauptung über ein Verbot einer Maßnahme mit sich selbst. Der aktive Partnerauszug für Maßnahme 7 enthält vollständig 1A, 1B, 2, 3, 8, 9, 16 und 24. Headerfußnoten 2/4 sind als Text gespeichert, jedoch nicht ausdrücklich an die Header gebunden. Eine vollständige Ausführung fremder Matrixmaßnahmen wird nicht behauptet.

Die Kulturlisten sind vollständig: elf Getreidearten, sieben Nichtgetreidebeispiele plus der definierte Gemengefall unter 50 Prozent, sieben Ackerfuttergruppen, 56 Feldgemüsezeilen, 31 Obstzeilen und drei zusätzliche Obstkulturen ab 2025. Aronia und verwandte Züchtungen, Brombeer-Kreuzungen und andere Schalenfrüchte bleiben ausdrücklich erhalten. Pak Choi wurde korrekt über den Seitenwechsel zwischen den ATB-Seiten 3 und 4 zusammengefügt und zusätzlich gegen PakChoi auf SRL-Seite 9 gebunden. Diese Tabellen werden nicht zur automatischen botanischen Klassifikation benutzt; Anteil und Grünschnittroggenzulässigkeit sind vorgelagerte Eingaben. Es wird keine unbekannte neue Art oder reale Sortenzulassung erfunden.

Alle vier Abschnittsarten, fünf Basisuntergruppen und die Codes NAT, EBW und K20 sind vollständig gespeichert. Obwohl diese Übersichtslisten nicht direkt gelesen werden, iteriert die tatsächliche Begrünungsbasis alle Ackerparzellen und schließt diese Gruppen positiv ein. Basisumfang, Tagesbegrünung und Prämienfähigkeit bleiben getrennt. Die fünf regionalen Dürrezeilen enthalten alle 39 einzelnen Bezirksnamen sowie beide Ganzlandfälle Burgenland/Wien mit richtigen Meldedaten. Alle sechs Elemente ordnungsgemäßer Anlage sind gespeichert; der operative Nachweis bleibt ein positiver externer Sachverhalt.

**O67-TABLE-001 – PSM-Helper verliert die korrekt gespeicherten Frostqualifikationen mechanischer Methoden** (TABLE_CONSUMPTION; high)

Alle fünf positiven Methoden und ihre beiden Frostbedingungen sind korrekt kopiert. Separate Verletzungen erkennen fehlendes vollständiges Abfrosten oder nicht ausschließlich abfrostende Komponenten. mechanical_removal() bleibt dennoch bei bloßer Mitgliedschaft des Keys true. Der spätere PSM-Zweig benutzt diesen unqualifizierten Helper und kann deshalb den erforderlichen PSM-Verstoß vor der Folgesaat unterdrücken. Die Proben liefern fehlende Qualifikationen ausdrücklich als Tatsachen; eine behauptete Methode überschreibt diese nicht. Positive Verfahren und beide negativen Methoden bleiben separat geprüft.

> ausschließlich aus abfrostenden — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 8
> nach dem Abfrosten bodennah gehäckselt — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 8
> Pflanzenschutzmitteleinsatz erst nach der Saat der Folgekultur zulässig — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 6
> vollständig abgefrostet — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 7

**O67-TABLE-002 – Fremde Übersichtslisten bewahren nicht sämtliche einschränkenden Detailqualifikationen** (FOREIGN_SCOPE; low)

Die neun Flächenzugangsgruppen stimmen als Mitgliedschaft, aber Key3 bewahrt nicht den Zusatz nur auf Grünlandflächen. Die OP-Obstübersicht nennt unveredelte Bäume ohne die ausdrückliche Streuobst-LSE-Ausnahme. Beide Listen sind unreferenziert und wirken nicht auf eigene7. Die Rohdaten sind deshalb als Übersichten, nicht als vollständig ausführbare fremde Policy zu verstehen. Pflanzenlisten bewahren dagegen die Obstgruppen ausdrücklich; es wird kein früherer Fehler pauschal übertragen.

> Heuwirtschaft (nur auf Grünlandflächen) — `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 16
> Dies gilt jedoch nicht für die Option Streuobstbäume — `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 8

**O67-TABLE-003 – Korrekte Kulturlisten ersetzen keine eigene botanische Klassifikation des Zwischenfruchtinputs** (EXTERNAL_DEPENDENCY; info)

Alle 11 Getreide-, 8 Nichtgetreide-/Gemenge-, 7 Ackerfutter-, 56 Feldgemüse-, 31 Obst- und 3 späteren Obstzeilen sind vollständig geprüft. Sie werden nirgends konsumiert. Anteil und Grünschnittroggenqualifikation kommen als positive Eingabemerkmale. Der Bool green_rye_varieties_only ist damit ein externer Nachweis gemäß Saatgutgesetz, kein Vergleich mit einer gelieferten Sortenliste. Für diese Maßnahme enthält das Paket keine solche Sortenliste. Keine echte neue Sorte oder Zulassung wird erfunden. Typ-, Park- und Flächenklassifikationen bleiben ebenfalls vorgelagerte Tatsachen; ihre Gültigkeit folgt nicht aus einer richtigen Datenkopie.

> Grünschnittroggensorten gemäß Saatgutgesetz — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 2
> Als Getreide — `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 3

**O67-TABLE-004 – Unmittelbare Folge, ein Tag Rückverfestigung und neuere Methodenerläuterungen bleiben offene Auslegungen** (SOURCE_VERSION; info)

catch→catch=0Tage und reconsolidation≤1Tag sind native Operationalisierungen von unmittelbar, keine wörtlichen Quellzahlen. Die SRL formuliert die Drei-Partner-Regel ohne den ausdrücklichen Datumsbezug des Merkblatts, während die Reinsaatregel für späte winterharte Kulturen besteht. Walzen ist im neueren Merkblatt zugleich im Restzeitraum verboten und unter Bedingungen bei Frost möglich; die native Lesart ist dokumentiert. Mechanische Erweiterungen aus dem neueren Merkblatt werden nicht stillschweigend als abschließend juristisch aufgelöst behandelt. Die konkreten Wertesätze bleiben korrekt nach der offengelegten Quelle.

> unmittelbar hintereinander — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 5
> unmittelbar nach der Anlage — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 6
> Zwischenfrüchte müssen mindestens 3 Mischungspartner — `20241011_srl_oepul_2023.pdf`, PDF-Seite 57
> bis einschließlich 31.10. verboten — `20241011_srl_oepul_2023.pdf`, PDF-Seite 58

**O67-TABLE-005 – Vollständige Matrix und Sanktionswerte sind nur teilweise operative Verbraucher** (TABLE_CONSUMPTION; info)

Die vollständige Matrix ist richtig. Aktiv ist nur die Liste der acht eigenen Partner. Zwölf leere Partner werden nativ der eigenen Immergrün-Prämie angelastet; diese Auswahl ist eine offengelegte Annahme. NAT, EBW und K20 zählen trotzdem korrekt zur Begrünungsbasis. Sanktionsstufen samt Warningwechsel sind richtige Exporthelper, werden aber vom Prämienbetrag nicht gelesen; der allgemeine Prüfungsteil bewertet diese Zahlungsfolgen gesondert. Fremde Caps dienen hier nur der korrekten Ausnahme der eigenen Maßnahme. Aus gespeicherten Werten folgt keine vollständige fremde Förderentscheidung oder amtliche Nettoberechnung.

> auf der Einzelfläche kombinierbar — `20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 103
> sämtliche Ackerflächen zur — `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 3
> Kürzung um 25 % — `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 18

Die fünf positiven und zwei negativen mechanischen Verfahren wurden vollständig mit allen Frostbedingungen geprüft. Die acht Geräte sind quellgetreu gespeichert; ein Eingabekey tillage_implement setzt einen tatsächlich anrechenbaren Einsatz dieser Klasse voraus. Bei kollabierten oder niedergewalzten reinen Abfrostmischungen beginnt die offene Phase laut Original erst mit PSM, mineralischem Stickstoff oder Bodenbearbeitung. Die Proben setzen end_date daher als tatsächlichen Beginn dieser Phase; ein künstlich zu früh gesetztes Enddatum wird nicht als Quellenfehler behauptet.

Die elf Zwischenfruchtparameter, sechs Vertragsparameter, acht Prämienparameter, vier Dürreparameter und neun allgemeinen Parameter wurden feldweise samt realen Verbrauchern geprüft. Die Lückenwerte 30/30/50 Tage sind an die vollständigen Originalzeilen gebunden. Catch→catch gleich null Tage und unmittelbar gleich höchstens ein Tag bleiben offengelegte native Auslegungen, keine wörtlichen Quellkonstanten. Die diskreten Sonderjahre 2023 und 2028 beim Übernahmetermin sind kein durchgehendes Intervall. Unbenutzte Duplikatparameter werden nicht als Beweis fehlender Bedingungen ausgegeben, wenn dieselbe Bedingung über einen gemeinsamen aktiven Parameter geprüft wird.

80 neue öffentliche Quellenproben sind für den gemeinsamen Replay bereit. Sie kontrollieren Band/Satzwahl, alle vier Modulationsbänder, fünf positive und zwei negative Methoden samt vier falschen Frostqualifikationen, vier Problempflanzen, vier Aufzeichnungsarten, fünf Antragstellerklassen, sechs NPF-Varianten, zwei blockierende Codes, zwei Parks, zehn Ausschlussklassen, acht Basisgruppen/-codes und 20 Kombinationspartner. Jede Probe enthält ihren tatsächlichen Query, Input, ausdrückliche Erwartungen und Originalbelege. String- oder Boolresultate verwenden equals; Regelmatcher werden ausschließlich bei echten rule_id-Objektarrays verwendet.

Bei leeren Kombinationspaaren ist die Auswahl ausdrücklich bedingt: Die andere Prämie bleibt beansprucht, deshalb wird die eigene Immergrün-Prämie ausgeschlossen. Die Matrix allein entscheidet nicht, welche Zahlung zu streichen ist. Damit wird die native Annahme kontrolliert, ohne eine unbelegte universelle Zahlungsauswahl zu erfinden. Die konkreten Sanktions-/Auswahlfolgen werden im allgemeinen Teil derselben Maßnahmenprüfung zusammengeführt.

Keine historischen Quellen, Profile, Daten, Regeln oder Laufzeitpins geändert. Root/QC führen nach explizitem Freeze den gemeinsamen Replay mit /tmp/issue-51-review-opa und den ursprünglichen Daten-/Policy-Verzeichnissen aus. GSP-AV fehlt im historischen Paket; frühere Lektüre bleibt zusätzlicher Kontext und wird nicht rückwirkend als geliefertes Generationsorakel benutzt. Numerische Effekte des unveränderten Pins bleiben von der Originalwerteprüfung getrennt.

| Native Datendatei | Bytes | SHA-256 |
|---|---:|---|
| `combinations.json` | 87491 | `edbf603008f5d8b0adfbfd1a467473ad03c4c0f8366ba543a28f9fc9e936f0b7` |
| `general.json` | 7287 | `dd56cdcdb555e749170da25c8510fd4074e7cf29e65559eafa45273c6977eb5d` |
| `lists.json` | 13283 | `9529a57f1b93c03aa5fac0c90bc4ebfd65c629f5908ab82f0484298dd20e4152` |
| `notices_2026.json` | 2095 | `ad4dbb8f2001e1203a05fa25ffd46c9120aa1dee772265336214c45bce644b83` |
| `parameters.json` | 2829 | `cf90a690f2ba2ffab2d5c154e05ad3bf9cb30d885b266a57dd40c8c085306c5a` |

| Originalquelle | SHA-256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf` | `ec88c013768e73337a093aa3bf6241470462ad1aba26f79fd52f71137ac0aa8f` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle 1,319 Quellenbelegvorkommen mit 463 unterschiedlichen Bindungen werden gegen die exakten Originalseiten geprüft. 110 unterschiedliche Codezeilen sind exakt am Kandidaten gebunden. Die Fremdzugangsklausel für Maßnahme 16 liegt auf SRL-PDF-Seite 74 und lautet „Teilnahme an den Maßnahmen … (6) oder … (7)“; beide entsprechenden Auditbelege sind an diese tatsächliche Seite gebunden.
