# o6_9 – Tabellen, Listen und tatsächliche Verbraucher

Geprüft ist ausschließlich der rohe Run `v2-o6_9-opus-5.5-high-20261003` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Daten liegen unter `data.o6_9`, Produktionsregeln unter `data.oepul.o6_9`. Es wurden keine historischen Regeln, Originale oder Canonical-Felder geändert.

Der Tabellenumfang umfasst zehn Dateien, 29 Inventarpointer mit 232 direkten Einträgen sowie 41 zusätzliche Metadatenblätter. Alle Werte, Nullspalten, Einheiten, Datumsgrenzen, Bedingungstexte und Verbraucher sind einzeln in `tables.json` dokumentiert. 18 Metadatenblätter haben echte direkte Blattreferenzen; 23 haben keine. Einige nicht eingelesene relative Jahreswerte entsprechen separat hardcodierten Verschiebungen.

## Quellenlektüre und Fortsetzung

Der erste Tabellenagent `o6_1a_tables_audit` dokumentierte die vollständige Lektüre des neuen neunseitigen Maßnahmenblatts und aller 42 Seiten der neuen NAPV einschließlich Anlagen, Fußnoten und vollständiger KG-Liste. Acht gemeinsame Originale wurden anhand identischer SHA-256-Hashes und früherer Volllektüreledger wiederverwendet. Die GSP-AV ist hier tatsächlich bereitgestellt; sie wird nicht rückwirkend anderen Runs zugerechnet.

Der fortsetzende Tabellenagent `o69_tables_review` hat das gesamte Maßnahmenblatt, sämtliche zehn Datendateien, acht Produktionsmodule und 21 nummerierten Rohannahmen persönlich erneut gelesen. Hinzu kommen NAPV-Seiten 1–21, SRL-Seiten 14/61–63, Anhangseiten 3/103, ATB-Seiten 15/18–21 sowie GSP-Seiten 10/31/32/86. Die vollständige erste Lektüre der NAPV-KG-Seiten 22–42 bleibt ausdrücklich attribuierte Vorarbeit; eine zweite persönliche Volllektüre dieser Seiten wird nicht behauptet. Die exakten Bindungen und dieser Unterschied stehen in `review_continuation`.

Die Originalbilder von MB-Seite 5 und den gedrehten NAPV-Kopfzeilen auf Seiten 11/12/13/18 wurden persönlich betrachtet. Die 157-g-Durchschnittszelle des MB ist tatsächlich über alle drei Mastphasen verbunden. Die gegenteilige Beschreibung in Rohannahme 2 ist irreführend; der ausführbare Gruppenhelper ist an diesem Punkt belegt.

## Vollständiges Tabelleninventar

| Datei | JSON-Pointer | Direkte Einträge |
|---|---|---:|
| `application_techniques.json` | `/application_techniques/eligible` | 3 |
| `application_techniques.json` | `/application_techniques/excluded` | 2 |
| `combination_table.json` | `/combination_table/rows` | 20 |
| `deadlines.json` | `/deadlines/last_entry` | 2 |
| `deadlines.json` | `/deadlines/multiple_application/exception_years` | 2 |
| `drought_2026_districts.json` | `/drought_2026_districts/rows` | 41 |
| `fertilizable_area.json` | `/fertilizable_area/non_fertilizable_crops` | 9 |
| `fertilizable_area.json` | `/fertilizable_area/non_fertilizable_crop_categories` | 2 |
| `fertilizable_area.json` | `/fertilizable_area/eligible_land_uses` | 2 |
| `fertilizable_area.json` | `/fertilizable_area/napv_application_ban_periods` | 3 |
| `general_conditions.json` | `/general_conditions/modulation_bands` | 4 |
| `general_conditions.json` | `/general_conditions/sanction_stages` | 9 |
| `general_conditions.json` | `/general_conditions/area_payment_caps` | 9 |
| `general_conditions.json` | `/general_conditions/one_year_measures` | 13 |
| `general_conditions.json` | `/general_conditions/public_body_exception_measures` | 5 |
| `general_conditions.json` | `/general_conditions/eligible_applicant_types` | 4 |
| `general_conditions.json` | `/general_conditions/single_case_takeover_measures` | 10 |
| `general_conditions.json` | `/general_conditions/single_case_takeover_reasons` | 3 |
| `general_conditions.json` | `/general_conditions/deduction_order` | 11 |
| `gve_key.json` | `/gve_key/rows` | 23 |
| `gve_key.json` | `/gve_key/dwarf_cattle_breeds` | 4 |
| `manure_definitions.json` | `/manure_definitions/eligible_manure_types` | 3 |
| `manure_definitions.json` | `/manure_definitions/non_eligible_components` | 2 |
| `manure_definitions.json` | `/manure_definitions/permitted_water_components` | 3 |
| `manure_definitions.json` | `/manure_definitions/biogas_feedstocks` | 22 |
| `pig_crude_protein_limits.json` | `/pig_crude_protein_limits/rows` | 7 |
| `pig_crude_protein_limits.json` | `/pig_crude_protein_limits/fattening_group_categories` | 3 |
| `premium_rates.json` | `/premium_rates/rows` | 9 |
| `premium_rates.json` | `/premium_rates/caps` | 2 |

„Direkte Einträge“ zählt die Elemente des jeweils inventarisierten Containers. Metadaten außerhalb dieser Container werden separat gezählt; Querverweise und mehrfach verwendete Quellzeilen vergrößern den Zensus nicht.

## Fachliche Befunde und positive Kontrollen

1. **GVE/RGVE:** Alle 23 Anhang-A-Zeilen stimmen, darunter 20 RGVE- und drei Schweine-GVE-Zeilen. Die Rindersumme verwendet richtig die RGVE-Spalte. Alle vier Zwergrassen sind vorhanden; deren Liste wird jedoch nicht selbst gelesen, sondern die zugeteilte Kategorie. Bei vier fremden Andere-RGVE-Zeilen fehlt die gespeicherte Fußnote zur Wildhuftierhaltung in Gefangenschaft auf landwirtschaftlichen Nutzflächen. Die eigenen Rinder-/Schweinesummen sind davon nicht betroffen.

2. **Stoffe und Geräte:** Drei erlaubte Verfahren, zwei ausdrücklich ausgeschlossene Geräte, drei Wirtschaftsdüngerklassen, 22 Biogasgruppen und alle vier Stoffbedingungen sind erhalten. Die Biogasprüfung liest Schlüssel und ein aggregiertes Negativflag; sie prüft Hygiene, Beizung, Extraktionsmittel oder Speiseöl nicht aus Einzelbefunden. Erlaubtes geringes Regen-/Waschwasser und begründetes Verdünnungswasser müssen vorgelagert zutreffend klassifiziert werden. Die Probes geben diese Tatsachen ausdrücklich vor; sie erfinden keine Stoffzulassungen.

3. **Protein:** Alle sieben Kategorien und Grenzwerte bei 88 % TM stimmen. Der gesamte Mastdurchschnitt von 157 g und die Phasengrenzen 170/155/150 g sind Alternativen. Der echte Unterschied „ungedeckte Jungsauen ab 32 kg“ im neueren MB gegenüber „ab 50 kg“ in der älteren SRL bleibt offen; die Kontrollen vermeiden diesen Streitbereich.

4. **Düngungswürdige Fläche/NAPV:** Die kurze Negativliste ist keine vollständige N-Bedarfsrechnung. Ertrag, Vorfrucht, Nmin, Bewässerungs-N sowie Anlage-5-KG und deren besondere Grenzwerte fehlen als vollständige Daten-/Verbraucherkette. Die vollständige Quellenlektüre wird von dieser nur teilweisen Modellaufnahme getrennt. Reinleguminosen sind nach der besonderen Förderdefinition ausgeschlossen; bedingte NAPV-Gaben von 60/50 kg bzw. kleebetontem Ackerfutter sind deshalb kein automatischer Förderwiderspruch. Den konkreten Brache-false-Override prüft der Maßnahmenteil gesondert.

5. **NAPV-Zeiten:** Drei gespeicherte Warnzeilen decken nur einen Ausschnitt ab. Der Ackerbeginn wird auf 16.10. pauschaliert, während das Original ab Ernte der letzten Hauptfrucht ansetzt. Die textliche Herbstverlängerung verkürzt Gemüse-/Blühkulturqualifikationen. Positive Flags müssen die vollständigen Ausnahmegründe tragen. Weitere operative NAPV-Pflichten und die zeitlich beschränkte Sonderregel 2024 werden durch diese drei Zeilen nicht umfassend geprüft. Warnungen sind keine automatische amtliche Zahlungsentscheidung.

6. **Kombination/Region:** Der eigene 9-Auszug stimmt in allen 20 Anhang-L-Koordinaten: zehn positive und zehn leere Paare. Eine vollständige 21×21-Matrix wird nicht behauptet. BAW-/AG-Unterfälle sind zusätzliche Optionsgrenzen. Die 39 Dürrebezirke und zwei Ganzland-Wildcards stimmen; Jahr, Ernteausfall und übliche Spätsommer-/Herbsternte bleiben zusätzliche aktive Bedingungen. Diese Dürreliste ersetzt keine NAPV-KG-Liste.

7. **Tarife, Caps und Nettozahlung:** Alle neun Tarife, zwei Mengencaps, vier Modulationsbänder, neun Sanktionszeilen und neun Flächencaps wurden vollständig verglichen. Tarife/Volumencaps/Modulation werden aktiv verwendet. Sanktions- und Kürzungsreihenfolgehelper ergeben keinen vollständigen ausgeführten Nettozahlungsworkflow; Flächencaps warnen nur. Die 50-Euro-Regel ist eine Kann-Bestimmung, kein automatischer Nullbetrag. Die ATB-Stufe 8 nennt Vertragszeitraum; die bereitgestellte GSP §48(2)Z6 nennt Förderperiode und begrenzt die Rückforderungsfläche. Diese Normgrenze und konkrete Nettofolgen verbleiben ausdrücklich im allgemeinen Audit.

## Fristen und Quellenstände

Der Tabellencheck der MFA-Ausnahmejahre prüft nur die ausdrücklich im MB gespeicherten Einzeljahre 2023/2028 mit dem 17. April. Das ist keine abschließend anerkannte Einreichfrist: Die hier vorliegende GSP §5(1) kann den Ostermontag 2028 auf den 18. April verschieben. §242(7) ordnet die geänderte §5-Fassung zeitlich zu; daraus wird kein rückwirkender 2024-/2025-Goldfall konstruiert. Der allgemeine Auditteil hält den Quellen-/Versionskonflikt fest. Ein positiver MB-Zeilencheck widerlegt ihn nicht.

Die drei Maßnahmenübernahmegründe sind genau Betriebsauflösung, -teilung oder -zusammenlegung. Es wird keine unbelegte offene „insbesondere“-Klausel ergänzt. §51 der bereitgestellten GSP betrifft Junglandwirte; Zahlungen stehen in §52. Die Aufbewahrungsjahre beziehen sich auf das Kalenderjahr, auf das sich die Zahlungen beziehen; es wird nicht ohne Beleg das tatsächliche Überweisungsjahr als neuer Bezug gewählt.

## Öffentliche Entwicklungsprobes

33 neue öffentliche Probes mit 33 strikten Vergleichen kontrollieren Geräte-/Stoffschlüssel, alle Biogasgruppen einschließlich ganzer Ausschlusscharge, Wasserzuordnung, alle 23 Faktor-/Spaltenpaare, die tatsächlichen neun eigenen Tiergruppenfallbacks, alle sieben Proteinwerte und die Durchschnitt-/Phasenalternative, sämtliche neun Tarifzeilen, Vor-2025-Abwesenheit des Schweinetarifs, Negativnamen und Mengencaps, alle 20 Kombinationspaare, 39 Bezirke plus zwei Ganzlandfälle, die isolierte MB-Ausnahmejahrkarte, Sanktionszeilen sowie alle vier Modulationsbänder.

Die Probes unterscheiden leere Helper-Ergebnisse, Boolean false und die Zahl 0. Quellenqualifikationen, externer positiver Tatsachennachweis und reine Helper-/Tabellenrolle sind pro Fall angegeben. Es handelt sich um bekannte Entwicklungsprobes, weder um private Testdaten noch um Domänenexpert:innen-Abnahme oder eine unverzerrte Genauigkeitsmessung. Ein gemeinsamer unveränderter Replay mit anschließender unabhängiger QA erfolgt durch Root; dieser Teil führt keine eigene OPA-Ausführung aus und beansprucht noch keine Replay-Ergebnisse.

Vor dem ersten eingefrorenen gemeinsamen Replay wurde die Entwurfseingabe `o69-tables-all-nine-names-and-land-scope-cap` an genau einem Blatt korrigiert: `crop_category: grass` → `other`. `grass` ist kein kanonischer Enum-Wert. `land_use: grassland`, benannte Dauerwiese, ursprüngliche Quellannahmen, Abfrage und fachlicher Erwartungswert bleiben erhalten. Der Entwurfshash und die genaue Blattänderung stehen im Fortsetzungsledger; der korrigierte Input bekommt seinen eigenen Hash.

## Bindung und Prüfgrenze

Alle Original- und Datendateihashes, 29 Container mit sämtlichen Zeilen, 41 Metadatenblätter, genaue Codezeilen und wörtliche Seitenbelege stehen in `tables.json`. Die maschinelle Quote-/Zeilenprüfung ist ein Bindungscheck und ersetzt die dokumentierte Quellenlektüre nicht. Historische Selbsttests, Studienreferenzen und manuelle Adaptationen wurden nicht als Sollwerte verwendet. Befunde anderer Auditteile bleiben referenziert; ihre konkreten Fälle werden hier nicht doppelt als neue Fehler gezählt.
