# o6_11 – Tabellen, Listen und tatsächliche Verbraucher

Gegenstand ist ausschließlich der rohe Run `v2-o6_11-opus-5.5-high-20261001` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Geprüft wurden **15 Datendateien, 30 Inventarpointer mit 350 direkten Einträgen und 62 zusätzliche Metadatenblätter**. Die vollständigen Werte, Unterfelder, Nullspalten, Einheiten, Jahresgrenzen, Qualifikationen und tatsächlichen Codeverweise stehen zeilenweise in `tables.json`.

Das neue vierseitige Maßnahmenblatt wurde vollständig persönlich gelesen, einschließlich Vertrags- und PSM-Tabellen, Ausnahmen, Tarifzeilen, Aktualisierungen und Impressum. Sieben gemeinsame Originale werden mit identischen SHA-256-Hashes und dokumentierter früherer Volllektüre wiederverwendet; die aktuellen Verbraucher und einschlägigen Originalklauseln wurden erneut verglichen. Sämtliche sechs Produktionsmodule mit 1.199 Zeilen und alle 19 nummerierten Annahmen einschließlich der übrigen Eingabenotizen wurden vollständig gelesen.

**GSP-AV und NAPV sind diesem Paket nicht bereitgestellt.** Verweise in ATB/SRL oder Annahmen bedeuten keine vollständige Bereitstellung. Ein in einem früheren Run tatsächlich vorhandener Gesetzestext wird hier weder nachträglich zugerechnet noch als zusätzliche Quelle für einen Gegenoracle benutzt.

## Vollständiges Inventar

| Datei | JSON-Pointer | Direkte Einträge |
|---|---|---:|
| `combination_table.json` | `/combination_table/columns` | 21 |
| `combination_table.json` | `/combination_table/rows` | 21 |
| `combination_table.json` | `/combination_table/cells` | 134 |
| `contract_periods.json` | `/contract_periods/rows` | 3 |
| `farm_combination_exclusions.json` | `/farm_combination_exclusions` | 5 |
| `fruit_crops.json` | `/fruit_crops/base` | 31 |
| `fruit_crops.json` | `/fruit_crops/from_2025` | 3 |
| `fruit_crops.json` | `/fruit_crops/excluded_from_o6_11_premium` | 2 |
| `general_conditions.json` | `/general_conditions/applicant_types` | 4 |
| `general_conditions.json` | `/general_conditions/public_body_exception_measures` | 5 |
| `general_conditions.json` | `/general_conditions/multi_year_measures` | 13 |
| `general_conditions.json` | `/general_conditions/annual_area_flexible_measures` | 5 |
| `general_conditions.json` | `/general_conditions/area_addition_restricted_measures` | 9 |
| `general_conditions.json` | `/general_conditions/takeover/special_years` | 2 |
| `measure_switch_table.json` | `/measure_switch_table/rows` | 10 |
| `modulation.json` | `/modulation/bands` | 4 |
| `modulation.json` | `/modulation/separately_modulated_measures` | 2 |
| `non_eligible_areas.json` | `/non_eligible_areas/categories` | 8 |
| `non_eligible_areas.json` | `/non_eligible_areas/national_parks_no_area_premium/parks` | 4 |
| `non_eligible_areas.json` | `/non_eligible_areas/national_parks_no_area_premium/exempt_measures` | 2 |
| `op_code_cases.json` | `/op_code_cases` | 7 |
| `payment_caps.json` | `/payment_caps/rows` | 9 |
| `premium_rates.json` | `/premium_rates/rows` | 6 |
| `premium_rates.json` | `/premium_rates/no_premium_usage_types` | 4 |
| `prohibited_substances.json` | `/prohibited_substances/non_approved_active_substances` | 1 |
| `psm_codes.json` | `/psm_codes/rows` | 3 |
| `sanctions.json` | `/sanctions/levels` | 8 |
| `sanctions.json` | `/sanctions/violation_grounds` | 5 |
| `sanctions.json` | `/sanctions/reduction_order` | 11 |
| `usage_types.json` | `/usage_types` | 8 |

Die 350 Einträge sind die direkten Elemente der 30 deklarierten Container. 62 weitere Blätter außerhalb dieser Container werden separat gezählt. 18 haben direkte Blattreferenzen, 44 werden nicht direkt gelesen. Das betrifft unter anderem Namen/Legenden/Fußnotentexte der Matrix, drei weiter gefasste Obstgruppenhinweise sowie beschreibende Frist- und Zahlungsparameter. Ein gleicher Wert kann separat hardcodiert oder über einen anderen aktiven Parameter abgebildet sein; fehlende Blattreferenz bedeutet daher nicht automatisch fehlende Funktion.

## Kombinationstabelle und verlorene Headerbindungen

Die Daten enthalten 21 Spalten, 21 Zeilencodes und 134 positive Zelltuples. Alle Koordinaten, `x`-/`a`-Markierungen und Zellfußnoten stimmen mit der bereits unabhängig am Original erstellten Transkription des exakt identischen Anhang-L-Standes aus o6_8 überein. Außerdem wurden alle 286 impliziten leeren Offdiagonalpaare verglichen. Das ergibt 420 Kombinationen; 21 Diagonalen werden separat geführt und nicht als Verbote gewertet. Das ist eine vollständige aktuelle Tupelprüfung gegen eine hashgebundene Originaltranskription, keine behauptete zweite Rekonstruktion sämtlicher fremder Zellen am Bild.

Die eigene Zeile 11 hat vier positive Partner: 1A mit Fußnote 1 sowie 2, 10 und 12 ohne Zellfußnote. Die übrigen 16 eigenen Offdiagonalpaare sind leer. Der aktive Helper liest nur diese eigene Zeile. Die erwartete Darstellung einer sortierten Mitgliedermenge wird ausdrücklich mit `sorted(original_source_members)` hergestellt; die Papierfolge wird nicht als Sortierfolge ausgegeben.

Die vier vollständigen Fußnotentexte sind gespeichert. **Die Headerzuordnungen 8→4, 13→2 und 16→4 fehlen jedoch im Datenmodell.** Spalten-/Zeilenarrays und Maßnahmennamen haben keine entsprechende Verbindung. QA hat die drei Zuordnungen unabhängig am Originalbild bestätigt. Da die eigene Zeile 11 zu allen drei Maßnahmen bereits leere Zellen hat, wird daraus kein eigener Zahlungsgegenfall konstruiert. Die fehlende fremde Bereichsqualifikation bleibt ein geringer Tabellenbefund.

Die betriebliche BIO-Teilbetriebsausnahme ist eine andere Ebene als die Kombination auf derselben Einzelfläche. Ein Betrieb mit BIO nur für Acker/Grünland erhält dadurch keine zusätzliche positive BIO-/11-Zelle auf der Weinfläche. Ebenso ist die eigene 1A-Kombination nur hinsichtlich Landschaftselemente positiv; ein Hinweis auf die Fußnote ersetzt keinen vollständigen Landschaftselemente-Zahlungsworkflow.

## Kulturen, Stoffnamen und Dokumentation

31 Grundschlüssel und drei zusätzliche Obstkulturen ab 2025 sind vollständig. Aronia-Verwandte, Brombeer-Kreuzungen und andere Schalenfrüchte sind als Notizen erhalten; der Namenshelper liest diese Notizen jedoch nicht. Die kurzen Schlüssel bilden keine vollständige botanische Arten-/Kultivarliste. Die Probes behaupten deshalb keine neue Zulassung einer erfundenen oder unbekannten Sorte.

Walnuss und Edelkastanie sind Obst, erhalten aber ausdrücklich keine Prämie dieser Maßnahme. Das ist keine Ausnahme vom betrieblichen Herbizidverzicht auf der gesamten Obstfläche. Die Anforderungen an hochwertiges/veredeltes Pflanzgut und eine nötige OP-Codierung bleiben weitere Rollen. Schnittweingärten zählen nach der Quelle zur Weinfläche und unterliegen dem Verzicht; der konkrete Weinprämiensatz bleibt die benannte native Annahme 2. Sonstige Weinflächen werden ohne Mindest-/Prämienanrechnung geführt; die Verzichtsrolle wird als offene Annahme 3 gekennzeichnet. Rebschulen zählen nicht zur Weinfläche.

Der Verbotstatbestand knüpft an den tatsächlichen AGES-Wirkungstyp „Herbizid“ an. Der Code führt keine eigene Registerabfrage durch. Das Original nennt Ameisensäure sowie Formalinsäure, Formylsäure, Hydrocarbonsäure und Methansäure: fünf Namen für denselben Stoff. Der zusätzliche englische String `formic acid` ist eine technische Benennung, kein sechster Originalstoff und keine zusätzliche bereitgestellte Rechtsquelle. Die positiven Aliasprobes verwenden nur die fünf wörtlich genannten Namen.

Drei PSM-Codes sind vollständig: PSMBIO, PSMCSH und PSMCS. Die gesonderte Meldepflicht gilt bis einschließlich 2025; ab 2026 entfallen diese Regelungen. Der aktive Hauptdiagnostikpfad verwendet tatsächlich die Jahresgrenze. Eine gleichzeitige BIO-Nicht-Herbizid-/chemisch-synthetische Nicht-Herbizid-Anwendung wird mit PSMCS abgebildet. Ein Berichtscode schafft keine Herbiziderlaubnis. Hypothetische Wirkungs-/BIO-Kreuzklassifikationen werden nicht als nachgewiesene reale Produktzulassungen ausgegeben.

## Vertragsjahre, Tarife und allgemeine Tabellen

Alle drei Vertragsstarts sind korrekt: 2023 mit sechs, 2024 mit fünf und 2025 mit vier Jahren, jeweils bis 31.12.2028. Die 0,50-ha-Mindestteilnahme gilt im ersten Verpflichtungsjahr. Davon getrennt ist die allgemeine Betriebsmindestgröße im allerersten ÖPUL-Teilnahmejahr. Maßnahme 11 ist mehrjährig und zugleich an die jährlich verfügbare Fläche gebunden. Die fremde Heuwirtschaft ist in den Katalogen jetzt ausdrücklich als Acker- bzw. Grünlandrolle unterschieden.

Alle sechs Tarifzeilen stimmen: 250 EUR/ha im Jahr 2023, 270 EUR/ha ab 2024 für Wein, förderfähiges Obst und Hopfen. Vier Prämienausschlusszeilen, vier Modulationsbänder, neun Flächencaps, acht Sanktionsstufen, fünf Verstoßgruppen und elf Kürzungsschritte wurden vollständig verglichen. Die zehn Maßnahmenwechselzeilen erhalten auch die Unteroptionen 8-BAW/16-AG und die zeitliche K20-Einschränkung. Die fünf betrieblichen Ausschlussgruppen behalten ihre Textqualifikationen; fremde Teiloptionen sind keine pauschalen Verbote jeder Teilnahme an den genannten Maßnahmen.

Vier gespeicherte Parknamen sind Schreibweisen für zwei ausdrücklich ausgeschlossene Nationalparks, keine vier unterschiedlichen Parks. Die übrigen Flächen-/OP-Kategorien setzen die Originalqualifikationen voraus. Nicht jeder Versuch oder jede fremde Zahlung ist ohne weiteren Sachverhalt ein Ausschlussgrund.

Bei Flächencaps müssen andere Zahlungen die quellenmäßigen Ausnahmen bereits berücksichtigen; das Feld `excluded_measures` wird nicht selbst vom Capverbraucher gelesen. Die proportionale Verteilung einer Überschreitung bleibt Annahme 10. Sanktionen sind bereits amtlich zugeteilte Stufen, keine automatisch erfundene ganze Kürzung für einen beliebigen Bewirtschaftungsverstoß. Die Warnung ergibt bis 2026 0 %, ab 2027 1 %. Die 50-Euro-Regel bleibt eine Kann-Bestimmung; die maximale Vorauszahlung ist keine amtliche Zahlungsanordnung.

## Befundgruppen

**O611-TABLE-001 · Drei Headerfußnoten sind nicht mit den Maßnahmencodes verbunden (low)**

Alle 134 Zellmarkierungen und Zellfußnoten sowie 286 Leerpaare stimmen. Die vier Fußnotentexte sind gespeichert; die Originalheader 8→4, 13→2 und 16→4 besitzen im Datenmodell jedoch keine Verknüpfung. Eigene 11 hat zu allen dreien ohnehin leere Zellen. Daraus wird kein eigener Zahlungsfehler abgeleitet.

**O611-TABLE-002 · Obstgruppenhinweise werden gespeichert, aber nicht vom Namenshelper gelesen (info)**

31 Grundschlüssel und drei zusätzliche Arten ab 2025 sind vollständig. Aronia-Verwandte, Brombeer-Kreuzungen und andere Schalenfrüchte bleiben breitere Originalgruppen; ihre Notizen werden nicht gelesen. Die Schlüssel sind keine vollständige botanische Arten-/Kultivarliste. Kein erfundener Einzelkultivar wird hier als neuer Gegenoracle eingeführt.

**O611-TABLE-003 · Fünf Originalnamen und eine zusätzliche englische technische Benennung (info)**

Die Originalquelle nennt Ameisensäure und vier deutsche Synonyme. Das zusätzlich gespeicherte formic acid ist eine englische technische Benennung derselben Substanz, kein sechster Originalstoff und keine zusätzliche bereitgestellte Rechtsquelle. Positive Aliasprobes decken nur die fünf wörtlich genannten Namen ab; der Wirkungs- und Produkteinstufung liegt ein gesondert verifizierter AGES-Sachverhalt zugrunde.

**O611-TABLE-004 · Korrekte Raten und Kataloge ersetzen keine vollständige Zahlungsfreigabe (info)**

Prämienausschluss, betriebliche Herbizidpflicht, erster Mindestflächenzeitpunkt, mehrjähriger Vertrag und jährlich flexible Fläche sind getrennte Rollen. Schnittweingarten-Tarif und sonstige Weinflächen bleiben ausdrücklich native Annahmen. Capausnahmen müssen in anderen Zahlungen bereits berücksichtigt sein; proportionale Kürzung bleibt eine offene Zurechnung. Sanktionen sind amtlich zugeteilte Stufen; GSP/NAPV sind nicht bereitgestellt und werden nicht als zusätzliche Quelle importiert.

## Öffentliche Entwicklungsprobes und Prüfgrenze

32 neue öffentliche Probes mit jeweils einem strikten Vergleich prüfen sämtliche Matrix-Zelltuples und Leerpaare, eigene Kombinationen/Fußnote, alle 34 Obstschlüssel über drei Jahre, bekannte Obst-Prämienausschlüsse und Verzichtsrollen, Wein/Schnittweingarten/Rebschule, drei Vertragsstarts und den geschlossenen Lookup, alle Tarifzeilen, PSM-Codes und die tatsächlich wirksame 2025/2026-Grenze, fünf Originalstoffnamen, positive Wirkungstypklassifikation, Parknamensrollen, Vertrags-/Flächenkataloge, allgemeine Toleranzgrenzen, Modulation und zugeteilte Warnstufen.

Die vollständigen Matrizenprobes benutzen das unabhängige Originaltranskript am identischen Quellenhash. Reine Datenexportkontrollen sind ausdrücklich so bezeichnet. Helpervergleiche ergeben keine vollständige Betriebsfreigabe oder beliebige Geldfolge. Leere Ergebnisse, Boolean false und die Zahl 0 bleiben getrennt. Die Fälle sind bekannte öffentliche Entwicklungsprobes; sie sind keine privaten Testdaten, Domänenexpert:innen-Abnahme oder unverzerrte Genauigkeitsmessung.

Vor dem ersten Freeze wurde ein eigener Query-Konstruktionsfehler im Wirkungstyp-Batch erkannt: Ein Vergleich war als nackter Kopf einer Array-Comprehension syntaktisch ungültig. Dieselbe Boolean-Projektion wird nun über ein Objektfeld ausgegeben. Das Revisionsledger bindet die frühere Entwurfsfassung und die genaue Queryänderung; sämtliche Inputs und fachlichen Erwartungswerte bleiben gleich. Das war ein Prüfautorenfehler, kein Modellbefund.

Der isolierte strikte OPA-Vorlauf ergibt **32 definierte Ergebnisse und 32 erfüllte Erwartungen**. Er verwendet denselben gepinnten Runtimehash, blockierte Fähigkeiten, deaktivierten Netzwerkzugriff, native Policy-/Data-Verzeichniswurzeln, strikte Kompilierung und strikte Builtinfehler. Sein früherer Teilhash ist im JSON gebunden. Danach wurden ausschließlich zwei Belegwiederholungen an die Originalschreibweise der Plain-Extraktion angepasst: „Wein -, Obst - …“. Die Rücknahme genau dieser zwei Literaländerungen rekonstruiert den Preview-Teilhash bytegenau. Inputs, Querys und fachliche Erwartungen blieben unverändert; danach kamen nur Prüfmetadaten hinzu. Eine gesonderte Projektion der 32 Inputs, Querys und erwarteten Pfade/Operatoren/Werte ist ebenfalls mit SHA-256 gebunden.

Der abschließende mechanische Abgleich bestätigt sämtliche 15 nativen Dateihashes, alle 30 Inventarpointer und 350 direkten Werte sowie genau die erneut enumerierten 62 übrigen Metadatenblätter. 1.517 Belegvorkommen mit 84 unterschiedlichen Quellen-/Seiten-/Zitatbindungen und 54 Codeverweise ergeben keine offenen Fehler. Literalvergleiche verwenden ausschließlich Whitespace-Normalisierung gegen Plain- oder Layout-Extraktion derselben hashgebundenen Originalseite; Satzzeichen und Unicode werden nicht umgeschrieben. Diese Präsenzprüfung ersetzt keine Volllektüre. 108 tatsächlich vorhandene explizite Enumwerte in allen 32 Fallinputs stimmen mit dem unveränderten Canonical-Profil einschließlich der tatsächlichen Run-Erweiterungen überein. Dieser begrenzte Enumcheck zertifiziert keine fehlenden Felder, übrigen Typen, Vollständigkeit oder Sachverhaltswahrheit.

**Der Tabellenteil ist eingefroren; gemeinsamer vollständiger Root-Replay und unabhängige QA stehen noch aus.** Originale, historische Regeln, Canonical-Profil und App bleiben unverändert.
