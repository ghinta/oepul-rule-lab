# o6_13 – Tabellen, Listen und tatsächliche Verbraucher

Dieser Teil prüft ausschließlich den rohen Run `v2-o6_13-opus-5.5-high-20260926` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Das neue Maßnahmenblatt hat **vier Seiten** und wurde vollständig persönlich gelesen, einschließlich Tabellen, Bedingungen, Ausnahmen, Aktualisierungen und Impressum. Alle neun Produktionsmodule mit **1.136 Zeilen** und die gesamten Rohnotizen einschließlich zwölf nummerierter Annahmen wurden gelesen. Sieben gemeinsame Originale werden anhand identischer Hashes und dokumentierter früherer Volllektüre wiederverwendet; die aktuellen Klauseln und Verbraucher wurden verglichen.

**GSP-AV und NAPV sind diesem Paket nicht bereitgestellt.** Verweise in ATB/SRL und der historischen Kürzungsreihenfolge ersetzen ihre Bereitstellung nicht. Das Review rechnet keine Quellen aus o6_12 nachträglich diesem Run zu. Historische Selbsttests, tatsächliche Modellausgaben, private Studienfälle und Expertenurteile liefern keine Sollwerte.

## Vollständiger tatsächlicher Umfang

Vier native Datendateien enthalten 31 Inventarpointer mit 349 direkten Einträgen. Alle deklarierten Containerzählungen stimmen. 62 weitere Metadatenblätter außerhalb der Container sind separat vollständig erfasst. Die Summen zählen direkte Elemente je Pointer; die fünf Gebietseinträge enthalten ihrerseits Bezirkslisten, die nochmals separat inventarisiert sind. 349 ist deshalb keine Zahl verschiedener atomarer Normen.

| Datei | Pointer | Tatsächlich / deklariert |
|---|---|---:|
| `measure.json` | `/measure/premium_rates` | 4 / 4 |
| `measure.json` | `/measure/eligible_field_use_types` | 2 / 2 |
| `measure.json` | `/measure/eligible_structure_types` | 2 / 2 |
| `measure.json` | `/measure/fixed_greenhouse_coverings` | 3 / 3 |
| `measure.json` | `/measure/field_use_type_by_growing_system` | 4 / 4 |
| `measure.json` | `/measure/non_eligible_area_components` | 5 / 5 |
| `measure.json` | `/measure/record_required_fields` | 6 / 6 |
| `measure.json` | `/measure/non_creditable_organism_uses` | 1 / 1 |
| `general.json` | `/general/applicant_legal_forms` | 4 / 4 |
| `general.json` | `/general/public_body_exception_measures` | 5 / 5 |
| `general.json` | `/general/non_eligible_area_types` | 8 / 8 |
| `general.json` | `/general/no_premium_parcel_codes` | 2 / 2 |
| `general.json` | `/general/national_park_rules` | 3 / 3 |
| `general.json` | `/general/one_year_measures` | 13 / 13 |
| `general.json` | `/general/multi_year_measures` | 13 / 13 |
| `general.json` | `/general/multi_year_contract_periods` | 3 / 3 |
| `general.json` | `/general/annually_variable_area_measures` | 5 / 5 |
| `general.json` | `/general/area_access_restricted_measures` | 9 / 9 |
| `general.json` | `/general/measure_conversions` | 10 / 10 |
| `general.json` | `/general/takeover_individual_case_only_measures` | 12 / 12 |
| `general.json` | `/general/area_payment_caps` | 9 / 9 |
| `general.json` | `/general/modulation_brackets` | 4 / 4 |
| `general.json` | `/general/sanction_stages` | 8 / 8 |
| `general.json` | `/general/reduction_order` | 11 / 11 |
| `anhang_l.json` | `/anhang_l/measures` | 21 / 21 |
| `anhang_l.json` | `/anhang_l/cells` | 134 / 134 |
| `anhang_l.json` | `/anhang_l/footnotes` | 4 / 4 |
| `notices_2026.json` | `/notices_2026/drought_harvest_exemption/areas` | 5 / 5 |
| `notices_2026.json` | `/notices_2026/drought_harvest_exemption/areas/1/districts` | 22 / 22 |
| `notices_2026.json` | `/notices_2026/drought_harvest_exemption/areas/2/districts` | 11 / 11 |
| `notices_2026.json` | `/notices_2026/drought_harvest_exemption/areas/4/districts` | 6 / 6 |

Alle direkten Werte und Unterfelder einschließlich der Bezeichnungen, technischen Schlüssel, Nullwerte, Jahresgrenzen, Einheiten, Qualifikationen und Fußnoten stehen in den zeilenweisen JSON-Reviews. Jedes Tabellenreview trennt ausgewählte Felder von nicht direkt gelesenen Feldern. Von den 62 übrigen Blättern haben 14 einen direkten Feld-/Containerverweis und sieben einen Verweis auf einen übergeordneten gelesenen Container; 41 haben keinen solchen Verweis. Diese Ebenen werden nicht als gleichartige einzelne Blattzugriffe ausgegeben. Separat hardcodiertes Verhalten kann einem gespeicherten Wert entsprechen.

## Originalmatrix, eigene Zeile und Fußnoten

Die native Datei enthält diesmal tatsächlich die vollständigen 21 Maßnahmen und 134 positiven Kombinationen. Sämtliche Koordinaten, Markierungen, Zellfußnoten und gespeicherten Rollenflags stimmen mit der unabhängigen Originaltranskription des identischen Anhang-L-Standes aus o6_8 überein. Der Pfad und SHA dieser vollständigen Transkription sind gebunden. Es wird keine Quelle aus der ausschließlich eigenen 20-Zeile von o6_12 als volle Matrix ausgegeben.

Alle 286 impliziten leeren Offdiagonalpaare werden separat verglichen; die 21 Diagonalen sind eine weitere Kategorie. Die eigene Zeile und Spalte 13 sowie Header und Fußnoten wurden zusätzlich frisch auf dem Originalbild der PDF-Seite 103 angesehen. Sämtliche 20 eigenen Gegenmaßnahmen sind leer. Eine zweite unabhängige Rekonstruktion aller fremden Zellen am Bild wird nicht behauptet.

**Die Headerverweise 8→4, 13→2 und 16→4 sind in `row_footnotes` ausdrücklich gespeichert.** Aus früheren Runs wird deshalb kein fehlender Headerbefund übernommen. Die vier vollständigen Fußnotentexte und die technische Legende stimmen. Die eigene Fußnote 2 nennt Topf-/Substratkultur; das aktuelle Maßnahmenblatt und SRL-Seite 68 schließen eine andere Prämie auf der Einzelfläche insgesamt aus, also auch bei A-Flächen auf gewachsenem Boden.

Der generische Kombinationshelper liest die Präsenz einer Koordinate in beiden Richtungen. Er führt die gespeicherten fremden Fußnoten oder Abschlagsbedingungen nicht als vollständigen Regelmotor aus. Das begründet hier keinen eigenen monetären Gegenfall, weil Zeile und Spalte 13 ohnehin vollständig leer sind. Die frische eigene Konfliktprobe prüft alle 20 Partner und projiziert die strukturierte Regel-ID; sie sucht keine Zeichenkette in einem Array von Objekten.

## Vier Raten und geschlossene Maßnahmentabellen

Die vier Tarifzeilen sind vollständig: jeweils 2.000 €/ha für A und GA im Jahr 2023 und 2.160 €/ha ab 2024. Ein offenes Tarifende erlaubt keinen neuen Einstieg nach 2027. Die eigene Obergrenze entspricht jeweils dem Satz; `capped_rate` verändert diese Grundrate daher nicht. Eine korrekte Raten- oder Capfunktion ist keine vollständige Freigabe des Betriebs, seiner Aufzeichnungen oder des tatsächlichen Registereintrags.

Zwei Strukturtypen, drei Eindeckungen und vier Zuordnungen des Anbausystems sind korrekt gespeichert. Befestigte Gewächshäuser können Folie, Glas oder Kunststoff verwenden; unbefestigte Folientunnel sind eine eigene Struktur. `eligible_structure_codes` ist aus der Tabelle definiert, die eigentlichen Strukturbedingungen benutzen jedoch die technischen Typnamen als Literale. Gewachsener Boden wird A, Topf-/Substrat-/Containerkultur GA zugeordnet. Bei wechselnder Bewirtschaftung entscheidet der Zustand am 1. April; das ist ein Auswahlmechanismus und keine fünfte feste Zuordnung. Der gespeicherte Referenzmonat/-tag wird nicht selbst gelesen, das aktuelle Eingabefeld ist ausdrücklich auf April 1 benannt.

Alle fünf ausgeschlossenen Teilflächen sind erfasst: Verkauf, Schau, Lager, ungenutzte Zwischenflächen und der über das nötige Ausmaß hinausgehende Ganganteil. Notwendige Gänge bleiben innerhalb der Bruttofläche enthalten und werden nicht zusätzlich aufgeschlagen. Die Komponentenprobes setzen disjunkte, nicht negative Teilflächen voraus. Eine Tabelle von Flächenschlüsseln prüft weder eine geometrische Überschneidung noch die sachliche Richtigkeit der gemeldeten Bruttofläche.

Alle sechs erforderlichen Aufzeichnungsangaben sind vollständig: Art, Menge, Zukaufsbelege, Grund, Ziel und Datum. Der Verbraucher benutzt die Schlüssel; die Aufzeichnung je Schlag ist eine zusätzliche Bedingung. Die frischen Missing-Field-Probes lassen jede der sechs Angaben einzeln aus und vergleichen die exakte fehlende Schlüsselmenge. Ein vorhandener Wert beweist weder die tatsächliche Aufwandsmenge noch eine behördlich verifizierte Produkteigenschaft.

Hummelvölker zur Bestäubung sind als ausdrückliches nicht anrechenbares Beispiel erfasst. Dieses eine Beispiel ist keine vollständige biologische Taxonomie. Unabhängig davon verlangt der Code einen positiven Register-, Aufwandsmengen- und Ersatznachweis. Die Probes mit positiven Flags behandeln diese als benannte vorgelagerte Fallannahmen; sie behaupten keine Live-Registerabfrage oder reale Produktzulassung. Die Reichweite flächendeckender Einzel- gegenüber mehreren Teilanwendungen bleibt native Annahme 1; eine ungeklärte Flächendeckungsunion wird hier nicht als vorbehaltloser Sollwert eingeführt.

## Allgemeine Kataloge und Rollen

Die vier Rechtsformen, fünf zeitlich qualifizierten Gebietskörperschaftsausnahmen, acht Flächenkategorien, zwei Codes und drei benannten Nationalparkregeln wurden vollständig gegen die Originale verglichen. Die amtliche Schreibweise „Neusiedlersee“ und der gespeicherte Schlüssel „Neusiedler See“ bezeichnen dieselbe Parkrolle. Das freie Eingabefeld und der exakte aktive Vergleich stellen jedoch keine Aliasabbildung bereit. Die konkrete Namens-/Identitätswirkung wird im Allgemeinteil gesondert geprüft und nicht als eigener ausgeführter Tabellengegenfall ausgegeben. Es handelt sich weder um einen zusätzlichen Originalpark noch um eine fehlende vierte Tabellenzeile. Der Quellumfang bestimmenden öffentlichen Einflusses geht über bloße Rechtsform- und Kapitalfelder hinaus; fehlende direkte Feldreferenz wird nicht mit vollständiger fachlicher Abbildung verwechselt.

Die 13 einjährigen und 13 mehrjährigen Maßnahmen, drei fremden Mehrjahresverträge, fünf jährlich variablen und neun zugangsbeschränkten Maßnahmen sind vollständig. Heuwirtschaft auf Acker bzw. auf Grünland bleibt in den Bezeichnungen qualifiziert. Solche fremden Kataloge machen die eigene Maßnahme 13 nicht mehrjährig. Ihre einjährige Laufzeit, Verlängerung, Erlöschen ohne NUE, Neueinstiegsfrist und Unterbrechungsfolgen sind verschiedene Rollen.

Zehn Umwandlungszeilen und zwölf technische Kennungen für nur in Einzelfällen mögliche Übernahmen wurden verglichen. Die zwölf Kennungen expandieren zehn Originalaufzählungspunkte, weil Monitoring und regionaler Naturschutzplan je zwei Maßnahmen betreffen. Die auf Betriebsauflösung, -teilung oder -zusammenlegung begrenzte Bedingung wird nicht als beliebiges „insbesondere“ geöffnet. K20 ist nur bis 2024 weiterführbar; die allgemeine Umwandlungsfrist und die nominalen Datenkanten sind getrennt. Der generische Zielhelper ist keine vollständige, jahrgenaue fremde Umwandlungsentscheidung.

Die eigenen Mitgliedschaftsprobes ergeben für 13: einjährig, keine verfügbare Umwandlung und keine Beschränkung auf Einzelfallübernahmen. Die April-Terminprobe prüft nur den wörtlichen ATB-Zeitplan. Eine abweichende externe Feiertagsauslegung wird ohne bereitgestellte GSP-AV nicht als zusätzlicher Rechtsoracle importiert. Genehmigung, Frist und maximale Erweiterung bleiben unabhängig von einer Katalogkennung.

## Hinweise 2026 und Zahlungsverbraucher

Die Dürrekulisse enthält fünf Gebietseinträge: 39 konkrete Bezirksnamen (22 Niederösterreich, elf Oberösterreich, sechs Steiermark) und zwei Bundesland-Wildcards für Burgenland und Wien. Das sind 41 Mitgliedschaften einschließlich Wildcards, keine 41 namentlich aufgezählten Bezirke. Originalschreibweisen, Wildcardrollen und Publikationsdaten stimmen vollständig.

Der aktive Verbraucher prüft diesmal beide sachlichen Flags: übliche Ernte im Spätsommer/Herbst und dürrebedingt kein erntbarer Bestand. Diese geprüfte Verbesserung wird von der noch offenen praktischen Reichweite auf geschützten Anbau getrennt. Die native Annahme 5 benennt A-Flächen; der generische Helper selbst prüft die Nutzungsart nicht. Es wird kein vorbehaltloser GA-Ausnahmefall behauptet. Farmregion und konkrete Lage eines Schlags bleiben ebenfalls verschiedene Sachverhalte. Die übrigen mitgelieferten Hinweise schaffen keine neue allgemeine Ausnahme für die Maßnahme 13.

Alle neun historischen Capzeilen und vier Modulationsbänder stimmen. Die relevante Heimfläche darf nicht mit getrennt zu modulierenden Alm-/Behirtungsflächen vermischt werden. Acht gespeicherte Sanktionszeilen bilden sieben amtliche Stufen plus die separate technische Ausschlusszeile ab; der Wechsel von Verwarnung zu 1 % ab 2027 ist korrekt. Die amtliche Einstufung ist eine Eingabe. Die vollständige elfteilige Kürzungsreihenfolge wird ausgegeben, aber nicht als vollständiger Berechnungsmotor durchlaufen. Die nicht bereitgestellte GSP-AV wird dadurch nicht nachträglich als geprüfte Quelle für Flächenabweichungen oder Kumulation angeführt.

## Öffentliche Probes, Korrekturbeleg und Abschlussgrenze

32 frische öffentliche Probes prüfen vollständige Matrix-Tupel und Leerpaare, Header, alle eigenen Kombinationen, Raten und Caps, Strukturen, Zuordnungen, fünf Teilflächen, sechs Aufzeichnungsfelder und deren Verbraucher, Hummelbestäubung, allgemeine Kataloge, Umwandlungs-/Übernahmerollen, sämtliche Modulationsbänder, zugeteilte Sanktionsstufen sowie alle Gebietseinträge und ihre sachlichen Bedingungen. Erwartete Quellenmitglieder werden extern deterministisch sortiert, wenn die Query sortiert. Beobachtete Modellausgaben bestimmen keine Erwartungswerte.

Vor dem ersten Freeze wurde genau eine beschreibende Fixtureangabe berichtigt: Im negativen Hummel-Bestäubungsfall lautet die Art nun wörtlich „Hummelvölker“ statt des generischen positiven Vorlagenlabels. Die zutreffenden negativen Register-/Ersatzflags, `use_type`, Query und erwartetes `false` blieben gleich. Das Revisionsledger bindet den alten Entwurfshash und die genaue Vorher-/Nachher-Angabe. Es handelt sich um eine Prüfautorenkorrektur, keinen Modellbefund. Der gesamte isolierte Lauf wurde danach erneut ausgeführt.

Der vollständige isolierte Wiederholungslauf nach der Fixturekorrektur ergibt **32 definierte Ergebnisse und 32 erfüllte Erwartungen**. Er verwendet den gepinnten Root-OPA, deaktiviertes Netzwerk, blockierte Fähigkeiten, die tatsächlichen nativen Policy-/Data-Verzeichniswurzeln sowie strikte Kompilierung und strikte Builtinfehler. Die Fallprojektion ist gesondert mit SHA-256 gebunden; seit diesem Vorlauf blieben Inputs, Querys und Erwartungen gleich.

Der finale Census bestätigt alle vier nativen Datendateihashes, 31 Container mit sämtlichen 349 direkten Werten, 62 erneut enumerierte übrige Metadatenblätter und alle neun Produktionsmodulhashes. Die 349 deklarierten Einträge stimmen vollständig. 2.005 Belegvorkommen mit 94 unterschiedlichen Quellen-/Seiten-/Zitatbindungen und 48 Codeverweise sind ohne offene Fehler geprüft. Der Literalvergleich verwendet ausschließlich Whitespace-Normalisierung gegen Plain- oder Layout-Extraktion derselben hashgebundenen Seite; Unicode oder Satzzeichen werden nicht umgeschrieben. Diese Präsenzprüfung ersetzt keine Volllektüre.

Alle tatsächlich vorhandenen Typen und expliziten Enumwerte der 32 Fallinputs wurden gegen das unveränderte Canonical-Profil mit den tatsächlichen Run-Erweiterungen geprüft: 2.203 skalare Werte, 371 Objekte und 486 Arrays, darunter 293 Enumvorkommen; keine Abweichung. Von den skalaren Werten gehören 702 zu gesondert deklarierten temporären Helperargumenten. Fehlende Eingaben, vollständige Sachverhalte, reale Produkteigenschaften und rechtliche Genehmigung werden dadurch nicht zertifiziert.

**Tabellen-JSON und Markdown sind eingefroren. Gemeinsamer vollständiger Root-Replay und unabhängige QA stehen noch aus.** Quellen, historische Regeln und Daten, Canonical-Profil und App wurden nicht verändert. Diese öffentlichen Entwicklungsprobes sind keine private Genauigkeitsmessung oder Domänenexpert:innen-Abnahme. JSON-SHA256: `749b09a7970137d39a88b3a9b55124860b9959608ce1d34ca1da5c97a3cb7a6d`.
