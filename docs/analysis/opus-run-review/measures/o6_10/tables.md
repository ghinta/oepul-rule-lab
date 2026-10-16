# o6_10 – Tabellen, Listen und tatsächliche Verbraucher

Geprüft ist ausschließlich der rohe Run `v2-o6_10-opus-5.5-high-20260925` am Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Der Tabellenstand umfasst **fünf Dateien, 38 Inventarpointer mit 410 direkten Einträgen und 14 zusätzliche Metadatenblätter**. Alle Werte, verschachtelten Felder, Einheiten, Nullgrenzen, Fußnoten und tatsächlichen Verbraucher sind einzeln in `tables.json` dokumentiert.

Das neue Maßnahmenblatt wurde vollständig gelesen: alle sechs Seiten einschließlich der Tabellen, Ausnahmen, Aktualisierungen und des Impressums. Die Tariftabellen auf Seiten 5 und 6 wurden zusätzlich am Originalbild geprüft. Sieben gemeinsame Originale werden anhand exakt identischer SHA-256-Hashes und dokumentierter früherer Volllektüre wiederverwendet; die hier einschlägigen Originalklauseln wurden erneut gelesen. Sämtliche acht Produktionsmodule mit 1.196 Zeilen und alle 20 nummerierten Annahmen einschließlich der Eingabenotizen wurden vollständig persönlich gelesen.

**GSP-AV und NAPV sind diesem Run nicht bereitgestellt.** Verweise in ATB/SRL oder Rohannahmen sind keine Volltextbereitstellung. Ein in o6_9 tatsächlich vorliegender Gesetzestext wird diesem Paket nicht nachträglich zugerechnet und liefert hier keinen zusätzlichen Sollwert.

## Vollständiges Inventar

| Datei | JSON-Pointer | Direkte Einträge |
|---|---|---:|
| `combination_table_annex_l.json` | `/annex_l_combination_table/cells` | 134 |
| `combination_table_annex_l.json` | `/annex_l_combination_table/measures` | 21 |
| `combination_table_annex_l.json` | `/annex_l_combination_table/footnotes` | 4 |
| `combination_table_annex_l.json` | `/annex_l_combination_table/legend` | 2 |
| `definitions.json` | `/definitions/fruit_crops` | 34 |
| `definitions.json` | `/definitions/fruit_crop_aliases` | 3 |
| `definitions.json` | `/definitions/cereals` | 11 |
| `definitions.json` | `/definitions/not_cereals` | 8 |
| `definitions.json` | `/definitions/greening_cereal_exceptions` | 2 |
| `definitions.json` | `/definitions/invalid_greening_cover_types` | 3 |
| `definitions.json` | `/definitions/eligible_crop_types` | 4 |
| `definitions.json` | `/definitions/non_eligible_crop_types` | 7 |
| `definitions.json` | `/definitions/greening_open_strip_max_cm` | 4 |
| `definitions.json` | `/definitions/national_parks` | 4 |
| `definitions.json` | `/definitions/eligible_applicant_types` | 4 |
| `definitions.json` | `/definitions/public_authority_exception_measures` | 5 |
| `definitions.json` | `/definitions/grazing_types` | 4 |
| `definitions.json` | `/definitions/greening_removal_methods` | 3 |
| `general_payment_rules.json` | `/modulation_bands` | 4 |
| `general_payment_rules.json` | `/area_payment_caps` | 9 |
| `general_payment_rules.json` | `/sanction_stages` | 8 |
| `general_payment_rules.json` | `/sanction_parameters` | 2 |
| `general_payment_rules.json` | `/sanction_grounds` | 5 |
| `general_payment_rules.json` | `/reduction_order` | 11 |
| `general_payment_rules.json` | `/payment_parameters` | 4 |
| `premium_rates.json` | `/premium_rates/base` | 7 |
| `premium_rates.json` | `/premium_rates/supplement_organisms_pheromones` | 3 |
| `premium_rates.json` | `/premium_rates/supplement_reduction/triggering_measures` | 2 |
| `premium_rates.json` | `/premium_rates/band_regime` | 3 |
| `programme_rules.json` | `/measure_catalog/one_year_measures` | 13 |
| `programme_rules.json` | `/measure_catalog/multi_year_measures` | 13 |
| `programme_rules.json` | `/measure_catalog/area_access_restricted_measures` | 9 |
| `programme_rules.json` | `/measure_catalog/annually_variable_area_measures` | 5 |
| `programme_rules.json` | `/measure_catalog/takeover_only_in_individual_cases` | 12 |
| `programme_rules.json` | `/programme_parameters` | 31 |
| `programme_rules.json` | `/record_requirements/greening_records` | 5 |
| `programme_rules.json` | `/record_requirements/organisms_pheromones_records` | 4 |
| `programme_rules.json` | `/drought_2026/greening_coverage_relief_measures` | 3 |

Die 410 Einträge zählen jedes direkte Element der 38 deklarierten Container einmal. Weitere Blätter außerhalb dieser Container werden separat gezählt. Von den 14 zusätzlichen Metadatenblättern haben zwei eine direkte Blattreferenz: der 50-%-Abschlag und das Dürrejahr. Zwölf haben keine direkte Referenz. Im inventarisierten Block mit 31 Programmparametern werden 22 Blätter direkt gelesen; neun sind beschreibend, fremd oder separat hardcodiert. Die genaue Zuordnung steht pro Blatt in JSON.

## Vollständige Anhang-L-Kontrolle

Die Kombinationstabelle ist hier eine vollständige dünn besetzte Tabelle, kein bloßer Auszug für Maßnahme 10. Alle **134 gespeicherten positiven Zellen** stimmen einschließlich `x`/`a` und Zellfußnoten mit dem bereits unabhängig am Original erstellten Transkript des exakt identischen Anhang-L-Standes aus o6_8 überein. Ebenfalls verglichen wurden alle **286 impliziten leeren Offdiagonalpaare**. Zusammen sind das 420 Kombinationen; die 21 Diagonalen werden separat geführt und nicht als Verbote gezählt. Das ist eine Wiederverwendung der hashgebundenen Originaltranskription mit vollständigem aktuellem Tupelvergleich, keine behauptete zweite vollständige Rekonstruktion am Bild.

Alle 21 Überschriften, beide Legendenwerte, vier vollständigen Fußnotentexte und drei Headerfußnoten sind vorhanden. Die eigene Zeile 10 hat fünf positive Partner: 1A mit Fußnote 1, 1B mit Fußnote 3, 2 ohne Fußnote, 11 ohne Fußnote und 12 mit Fußnote 3. Die übrigen 15 eigenen Offdiagonalpaare sind leer. Diese eigene Zeile wurde durch QA zusätzlich am Originalbild unabhängig geprüft.

Der generische Helper kann jede gespeicherte Zelle ausgeben; der Hauptkonfliktcheck verwendet die eigene Zeile 10. Fußnoten 1 und 3 werden als Hinweise ausgegeben. Das ersetzt weder eine vollständige fremde Optionsprüfung noch eine amtliche Entscheidung darüber, welche Prämie bei einem Konflikt entfällt. Ein positives `x` ist insbesondere bei der Landschaftselemente- oder EOP-Qualifikation keine uneingeschränkte Zahlungsfreigabe.

## Kulturen, Bestandsanteile und Nutzung

Alle 34 Obstkulturen sind korrekt: 31 ursprüngliche Gruppen sowie Felsenbirne, Maulbeere und Papau erst ab 2025. Der Namenshelper liest den Jahreszugang tatsächlich. Die drei Kurzformen Aronia, Brombeere und Haselnuss verweisen passend auf die ausdrücklich weiter gefassten Originalgruppen. Aus einer Gruppenbezeichnung wird keine unbekannte individuelle Sorte zugelassen.

Alle elf Getreidearten und acht Nichtgetreideeinträge sind vollständig. Die Nichtgetreideliste ist im Original mit „unter anderem“ eingeleitet; sie bildet keine abgeschlossene botanische Gegenmenge. Diese beiden Listen und die beiden Begrünungsausnahmen werden nicht direkt gelesen. Die aktive Begrünungsprüfung setzt positive Sachverhaltsflags für Getreide/Mais, gesetzeskonforme Grünschnittroggensorten und echte Hafer-/Sommergerste-Deckfrucht voraus.

Die zwei 50-%-Regeln sind getrennt: Die allgemeine Getreidedefinition nimmt Gemenge mit **weniger als 50 %** Getreide aus. Die besondere Begrünungsregel verbietet **mehr als 50 %** Getreide und/oder Mais im tatsächlichen Bestand zu irgendeinem Zeitpunkt des Jahres. Ein angegebener Maximalwert muss deshalb den gesamten Jahresbestand betreffen; die Saatmischung oder eine einzelne Beobachtung genügen dafür nicht. Die Tabellenkontrollen prüfen 49,99 / 50 / 50,01 % und die positiv belegte Deckfruchtausnahme.

Drei unzulässige Bedeckungsrollen, vier positive und sieben negative technische Kulturtypen, Offenhaltebreiten von 80 bzw. 100 cm, vier Weiderollen und drei Beseitigungsrollen sind vollständig verglichen. Terrassen brauchen mindestens 25 % durchschnittliche GIS-Hangneigung und sind von der Begrünungspflicht ausgenommen. Die 60-%-Flächenregel gilt nur für tatsächlich abweichende Pflanzsysteme, bei denen die normale Zeilenbreite nicht eingehalten werden kann. Bereits bestehende zulässige Begrünung und reine Selbstbegrünung bleiben sachlich abzugrenzen.

Die vier Nationalparkzeilen unterscheiden die eigene Maßnahme korrekt: Neusiedlersee und Donau-Auen schließen die Flächenprämie aus; Kalkalpen und andere Parks erlauben sie. Die fremden Ausnahmen für 23/24 bzw. 14 werden nicht als eigene Prämienlogik ausgeführt.

## Tarife, Zahlungsregeln und offene Auslegungen

Alle sieben Basistarifzeilen und drei EOP-Zuschlagszeilen stimmen. Wein hat Grenzen bei 25, 35 und 50 %, Obst bei 25 %, Hopfen eine einheitliche Zeile; Terrassen verwenden dieselben Weinzeilen. Untergrenzen sind einschließlich, Obergrenzen ausschließlich. Sämtliche Angaben lauten EUR/ha, die Hangneigung ist Prozent. Die frischen Probes prüfen jede Stufe einschließlich der Grenzen sowie die Jahre 2024 und 2025.

Bis einschließlich 2024 sind Mindest- und Höchstband gespeichert. Garantiert ist der Mindestbetrag; die damalige tatsächliche budgetabhängige Auszahlung wird nicht rekonstruiert. Ab 2025 gilt das Fixum. Beim EOP-Zuschlag bewirkt die bekannte aktuelle betriebliche Teilnahme an 12 oder 1B einmal 50 % Abschlag; mehrfache technische Nennung einer Teilnahme führt zu keinem weiteren Abschlag auf 25 %. Teilbetriebs-, Ausstiegs- und Bemessungsflächenfragen bleiben die ausdrücklich offenen Annahmen A-04/A-08/A-12. Tarifverfügbarkeit allein prüft weder anrechenbaren PSM-Ersatz noch EOP-Code oder PO-Ausschluss.

Alle vier Modulationsbänder, neun historischen/aktuellen Flächencaps, acht Sanktionsstufen, zwei Sanktionsparameter, fünf Grundgruppen und elf Kürzungsschritte sind vollständig. Die eigene Maßnahme 10 wird 2023/24 nicht in den allgemeinen Flächencap eingerechnet, ab 2025 schon. Die proportional angenommene Verteilung einer Capüberschreitung (A-10) bleibt offen. Die Kürzungsreihenfolge ist korrekt gespeichert, wird aber nicht als Liste ausgeführt. Das Maximum bei mehreren amtlichen Kontrollfeststellungen (A-09) wird durch diesen Tabellencheck nicht bestätigt oder mit einer hier nicht bereitgestellten Gesetzesfassung widerlegt.

Die 75-%-Vorauszahlung ist eine rechnerische Obergrenze; tatsächliche Teilzahlung setzt zusätzlich abgeschlossene Verwaltungskontrollen voraus. Die 50-Euro-Regel bleibt eine Kann-Bestimmung und erzeugt keine automatische Nullzahlung. Die allgemeine Frist 31.12.2027 betrifft nur über den Maßnahmenantrag abgewickelte Zuschläge. Der eigene EOP-Zuschlag braucht ausdrücklich keinen gesonderten Vorjahresantrag, sondern den Schlagcode.

## Befundgruppen

**O610-TABLE-001 · Getreide- und Ausnahmebestände sind Daten, Flags sind tatsächliche Nachweise (info)**

Alle elf Getreideeinträge, acht Nichtgetreideeinträge und zwei Begrünungsausnahmen sind korrekt. Die Datenlisten werden nicht gelesen; die aktive Prüfung verwendet vorgelagerte Klassifikations-, Sorten- und Deckfruchtflags sowie den maximalen Bestandsanteil. Die allgemeine Definition für Gemenge mit weniger als 50 % Getreide bleibt von der besonderen Begrünungsgrenze größer als 50 % getrennt. Ein beliebiger Roggenname ist kein positiver Sortennachweis.

**O610-TABLE-002 · Heuwirtschaft-Katalog verliert zwei gegensätzliche Nutzungsqualifikationen (low)**

Bei Heuwirtschaft (3) gilt die Flächenzugangsbeschränkung nur auf Grünland und die jährlich variable Fläche nur auf Acker. Gespeichert ist in beiden Katalogen lediglich Code 3. Die zweite Liste ist unreferenziert; die erste dient nur der eigenen 10-Mitgliedschaft, die korrekt false ergibt. Es wird kein eigener Zahlungsfehler der Maßnahme 10 aus diesen fremden Zeilen behauptet.

**O610-TABLE-003 · Vollständige Matrix ist vorhanden, nur eigene10 wird als Konfliktworkflow verwendet (info)**

Alle 134 gefüllten und 286 leeren Offdiagonalpaare stimmen. Die 21 Diagonalen sind keine Kombinationspaare. Die eigenen Fußnoten 1 und 3 werden als Hinweise ausgegeben; Headerfußnoten 2/4 und fremde Optionen werden nicht als vollständiger Workflow ausgewertet. Welche Prämie bei einer unmöglichen Kombination entfällt, bleibt Annahme A-11. Ein gespeichertes x bedeutet keine uneingeschränkte Förderfreigabe.

**O610-TABLE-004 · Generischer Zuschlagstermin ist keine separate EOP-Vorjahresfrist (info)**

Der allgemeine Termin 31.12.2027 gilt nur für Optionen oder Zuschläge, die über den Maßnahmenantrag abgewickelt werden. Der eigene EOP-Zuschlag wird über den Schlagcode beantragt, ausdrücklich ohne gesonderten Vorjahresantrag. Das Datumsblatt wird nicht gelesen und begründet keinen zusätzlichen EOP-Ausschluss.

**O610-TABLE-005 · Rechtsform- und Beteiligungswerte brauchen die volle öffentliche Kontrollqualifikation (info)**

Die vier ATB-Rechtsformen und ihre Bereichsflags sind richtig gespeichert. Der Verbraucher liest Personentyp und pauschalen Beteiligungswert. SRL 8 erfasst zusätzlich sonstigen bestimmenden Einfluss und weitere Einrichtungsstufen. Daraus wird kein unqualifizierter Gegenfall für natürliche Personen oder Personengesellschaften konstruiert. Konkrete juristische 25/25.01-%- und öffentliche 2024/2025-Kontrollen gehören zum allgemeinen Auditteil.

**O610-TABLE-006 · Korrekte Zahlungsdaten lösen offene Sanktion-/Cap-/EOP-Teilbetriebsfragen nicht (info)**

Alle Raten, Bänder, Capwerte, Stufen und elf Kürzungsschritte sind korrekt. Die Kürzungsreihenfolge wird nicht aus der Liste ausgeführt. Das Maximum bei mehreren Kontrollfeststellungen (A-09), die anteilige Verteilung einer Capüberschreitung (A-10) und die betriebliche EOP-Teilnahmeauslegung (A-04) bleiben ausdrückliche Annahmen. GSP-AV und NAPV sind nicht bereitgestellt; eine dortige Kumulationsnorm wird nicht als Paket-Gold importiert. Der berechnete Vorauszahlungsbetrag ist nur eine Obergrenze und setzt vor tatsächlicher Teilzahlung weitere Verwaltungskontrollen voraus.

Insgesamt sind sechs Gruppen dokumentiert: fünf Informations-/Bereichsgrenzen und eine geringe gespeicherte fremde Bereichsauslassung. Die beiden Heuwirtschaft-Katalogeinträge verlieren Grünland-/Ackerqualifikationen; daraus wird kein eigener Zahlungsfehler von Maßnahme 10 konstruiert. Aus dem Rechtsform-Bereichsflag wird ebenfalls kein unqualifizierter Gegenfall erfunden: SRL 8 erfasst bestimmenden öffentlichen Einfluss und Einrichtungen weiterer Stufen über die verkürzte ATB-Rechtsformliste hinaus.

## Öffentliche Entwicklungsprobes und Bindung

41 neue öffentliche Probes mit jeweils einem strikten Vergleich kontrollieren die vollständigen Matrixtupel und Leerpaare, die eigenen Kombinationen und Fußnotentexte, sämtliche Obstnamen über drei Jahre, Kulturrollen, Bestands- und Breitenlimits, Nutzungsrollen, alle Tarife und Neigungsgrenzen, EOP-Faktoren, Cap-Jahreswechsel, Stufenwerte, Modulation, Einjahreskatalog, vollständige Dokumentationsgruppen und die qualifizierte Dürrejahresausnahme. Leere Helper-Ergebnisse, Boolean false und die Zahl 0 bleiben getrennt.

Die vollständigen Matrizenprobes verwenden das unabhängige Originaltranskript am identischen Quellenhash, keine historischen Modelloutputs. Reine Datenexportkontrollen für unreferenzierte Listen sind ausdrücklich so markiert. Bei Helperkontrollen werden keine vollständige Betriebsgenehmigung oder beliebige Sanktion aus einem einzelnen Verstoß behauptet. Alle positiv vorausgesetzten Sachverhalte stehen pro Fall dabei. Überschneidungen mit General/Domain sind Verbraucher- und Quellenkontrollen und werden nicht als zusätzliche unabhängige Fehler gezählt.

Die Prüfungen sind bekannte Entwicklungsfälle und keine privaten Testdaten, Domänenexpert:innen-Abnahme oder unverzerrte Genauigkeitsmessung. Dieser Tabellenagent führt keine eigene OPA-Ausführung aus. Nach dem Freeze folgen der gemeinsame unveränderte Replay und eine unabhängige QA durch Root. Entsprechend werden hier noch keine OPA-Fallergebnisse beansprucht.

Zusätzlich zu den persönlichen Quellenvergleichen wurden alle fünf Datendateihashes, sämtliche 38 Containerwerte und 14 Metadatenblätter gegen das unveränderte Kandidatenbundle gebunden. Der maschinelle Belegcheck bestätigte 1.517 Belegvorkommen mit 159 verschiedenen Seitenbelegen und 159 Codezeilenbindungen ohne Fehler. Diese Bindungsprüfung ersetzt die Quellenlektüre nicht. Der begrenzte Eingabecheck ergab für 379 vorhandene Enum-Werte keine Abweichung vom Canonical-Profil plus tatsächlichem Vorschlag. Er ist keine vollständige Schema- oder Tatsachenzertifizierung. Vor dem Freeze wurde ein unnötig strittiger gemeinsamer BIO-/12-Faktorinput durch die doppelte technische Nennung derselben bekannten 12-Teilnahme ersetzt; Abfrage und 50-%-Erwartung bleiben gleich, der geänderte Input erhält einen eigenen Hash. Originale, historische Regeln, Canonical-Profil und App wurden nicht geändert.

## Korrektur der Erwartungsdarstellung nach dem ersten gemeinsamen Replay

Im Fall `o610-tables-own10-all-five-positive-partners` lieferte die Abfrage ausdrücklich eine lexikografisch sortierte Menge. Mein Erwartungsarray hatte dagegen die Reihenfolge der Quellendarstellung behalten. Das war ein Fehler des Prüfautors und kein Modellfehler. Die Erwartung wurde von `["1A", "1B", "2", "11", "12"]` auf `sorted(original_source_members)`, also `["11", "12", "1A", "1B", "2"]`, geändert. Die fünf belegten Mitglieder sowie Input und Abfrage bleiben gleich; die Darstellung des Erwartungsarrays ändert sich ausdrücklich.

Das Revisionsledger bindet den früheren Tabellen-SHA `0526cd84741d738925f4cb45e56459c6128806c8f44aee87ca9fa83ce11c9b4c` und die genaue Änderung. Root muss sämtliche 373 Fälle erneut sammeln und vollständig ausführen; danach folgt die unabhängige QA. Aus diesem Fall wird weder eine neue fachliche Abweichung noch eine Geldfolge abgeleitet.
