# o6_11: Eingabevertrag und tatsächliche Verbraucher

Geprüft wird ausschließlich der ursprüngliche Opus-Run `v2-o6_11-opus-5.5-high-20261001` am Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. [inputs.json](inputs.json) ist mit SHA256 `88256f19e401b22a490cd25770ce1b0160c6404fa1389d93aac3449ed4d0cc7f` eingefroren. Dies ist eine öffentliche Entwicklungsprüfung, keine Promotion, behördliche Freigabe, Expert:innenabnahme oder Genauigkeitsmessung.

Das neue Maßnahmenblatt wurde vollständig auf allen vier Seiten einschließlich sämtlicher Tabellen, Fortsetzungen und Ausnahmen gelesen. Alle sechs Produktionsmodule und sämtliche Rohannahmen wurden vollständig gelesen. Alle acht tatsächlich gelieferten Originale sind einzeln hashgebunden. Sieben gemeinsame Originale werden aus früheren dokumentierten vollständigen Lesungen wiederverwendet; aktuelle ATB-/SRL-/Anhang- und Meldungsklauseln wurden am Original erneut geprüft. Alle 49 zugewiesenen Vorschlagsbelege sind nach bloßer Whitespace-Normalisierung auf ihrer angegebenen Originalseite auffindbar. Das Paket enthält kein GSP-AV- oder NAPV-Original; die zusätzlichen Originale aus o6_9 werden nicht nachträglich zugerechnet. Die vier gebundenen Meldungen eröffnen keine besondere Herbizidausnahme für Maßnahme11. Historische Selbsttests, Studienfälle, GM-/Expert:innenlabels und manuelle Adaptationstests lieferten keine Sollwerte.

## Vollständiger Katalog

Die zehn tatsächlichen Vorschläge sind ausschließlich Ergänzungen. Sie ergeben 67 effektive Blätter: 62 werden gelesen und fünf bleiben ungenutzt. 127 kontextuelle Lesestellen sind erfasst. Die dynamische Schleife `mgmt[key]` wurde auf die drei tatsächlichen Mindestbewirtschaftungskriterien aufgelöst. Generische Herbizid-/Wirkstoffhelfer wurden sowohl ihren Anwendungs- als auch ihren Inventar-Aufrufern zugeordnet. Paketnamen und statische Tabellenvariablen zählen nicht als Eingabepfade. Dies ist ein manuell kontrollierter Ledger dieses Runs, kein allgemeiner Rego-Parser.

| Nr. | Originaler Vorschlagspfad | Blätter |
| --- | --- | ---: |
| 1 | `farm.applicant` | 5 |
| 2 | `farm.oepul` | 27 |
| 3 | `land.protected_cultivation_area_ha` | 1 |
| 4 | `land.parcels[].crop.usage_type` | 1 |
| 5 | `land.parcels[].crop.is_grafted` | 1 |
| 6 | `land.parcels[].is_fenced` | 1 |
| 7 | `land.parcels[].oepul` | 11 |
| 8 | `land.parcels[].operations.psm_applications` | 7 |
| 9 | `land.parcels[].operations.permanent_crop_management` | 3 |
| 10 | `documentation.plant_protection_inventory` | 10 |

Jedes Blatt besitzt Typ, Einheit, fachliche und zeitliche Bedeutung, Identitäts-/Konditionalitätsvertrag, Fehlend-/Nullverhalten und sämtliche tatsächlichen Lesestellen. `[]` bezeichnet ein wiederholtes Arrayelement; seine Container bleiben Arrays. Die tatsächlichen Vertragsdaten sind `farm.oepul.measures[]`; der erste exakt passende Eintrag mit `measure_id="11"` wird ausgewählt. Ähnlich benannte App-Felder gelten nicht als bestätigte Aliase.

Ungenutzt sind `land.parcels[].is_fenced` sowie `quantity`, `unit`, `purchased_date` und `in_storage` unter `documentation.plant_protection_inventory[]`. Daraus wird nicht behauptet, die Zaunpflicht sei vollständig unmodelliert: der tatsächliche Anwendungsbereich und das Gesamtflächenverbot können sie trotzdem erfassen. Inventarmengen, Einheiten, Kaufzeitpunkt und tatsächlicher Lagerstatus werden dagegen nicht unabhängig gerechnet. Die Plausibilitätsbeurteilung bleibt ein vorgelagerter Tatsachenvertrag.

`farm.oepul.previous_year_measure_area_ha` wirkt nur in separaten Flächenabgangshelfern. 21 gelesene Blätter erreichen Meldungen oder Rückforderungsflags ohne eigenen **aktuellen** Betragsschalter. Eine rückwirkende Rückforderung wird deshalb nicht als finanziell bedeutungslos bezeichnet. Zusätzlich werden sechs bestehende Canonical-Blätter gelesen: Jahr, Gesamtfläche, Schlag-ID und -fläche, Nutzpflanzenname und -kategorie. Es gibt keinen unvorgeschlagenen Lesepfad. Globale Canonical-PSM- oder Dokumentationsflags ersetzen die einzelnen Datensätze nicht.

## Bekannte Quellenkomponenten

Die gewöhnlichen positiven Kontrollen verwenden einen vollständig bekannten österreichischen Betrieb mit 2 ha Wein, veredelten Äpfeln oder Hopfen. Originalantrag, gültiger Vertragsbeginn, aktuelle Zahlungsbeantragung, Bewirtschaftung, Lage, Qualität und vollständiger Verzicht auf verbotenen Einsatz/Kauf/Lagerung sind positiv stipuliert. Nicht gewählte PSM-, Inventar-, Ausstiegs-, Umstiegs-, Übernahme- oder Ausnahmeereignisse werden nicht erfunden. Optionale Nicht-Ereignis-Daten fehlen in diesen Quellenpositiven; technische Nullproben sind getrennt.

| Komponente | Quellenableitung | Natives Ergebnis |
| --- | --- | ---: |
| Wein, Obst oder Hopfen | jeweils 2 ha × 270 €/ha ab2024 | jeweils 540 € |
| Bekannte Weiterführung 2026 | positiver gültiger2025Vertrag und aktuellerZahlungsantrag | 540 € |
| Späteres Teilnahmejahr mit0,4ha | Erstjahresminimum zuvor bekannt erfüllt; jährlich verfügbare Fläche | 108 € |
| Erstes Teilnahmejahr mit0,4ha | tatsächliches0,50ha-Mindestkriterium verfehlt | 0 €, kein Vertrag |
| Herbizidinventar für tatsächlich andere Getreidekultur | tatsächliche erlaubte Zielkultur, dokumentierte und plausible Mengen | kein Verstoß, 540 € |
| Zulässiges Nicht-Herbizid2025/2026 | 2025passenderPSM-Code;2026keinePSM-Codierung mehr nötig | jeweils540 € |
| Bekannte spätere Zahlungsnichtabgabe bzw. Kontrollverweigerung | tatsächlicher Zahlungs-/Kontrollblock | jeweils0 € |
| Behördlich bewertete25%-Kürzung | 540 € ×75% | 405 € |

Die spätere0,4-ha-Kontrolle enthält tatsächlich weitere1,6ha Ackerfläche als bekannten Betriebskontext. Die0,50ha gelten im ersten Maßnahmenjahr; sie werden nicht jedes Jahr erneut verlangt. Das erste Programmjahr und der ursprüngliche Maßnahmenbeginn sind getrennte Angaben. Der Inventar-Ausnahmefall enthält eine tatsächlich vorhandene andere Getreidekultur; er erfindet weder eine Herbizidzulassung auf Wein noch eine aus den Mengen berechnete Plausibilitätsprüfung.

Drei ausdrücklich hypothetische Kreuzklassifikationskontrollen setzen gleichzeitig `effect_type="herbicide"` und `is_organic_approved=true`. Sie prüfen technisch die Verbotspredicate und die Flächen-/Stamm-/Zaunbefunde. Der synthetische Name `PUBLIC-SOURCE-QUALIFIED-PRODUCT` ist kein AGES-Register- oder Bio-Zulassungsbeleg. Es wird nicht behauptet, dass ein entsprechendes reales Bio-Herbizid existiert oder zugelassen wäre; diese drei Fälle sind keine Quellenpositiven. Die Quelle eröffnet für Maßnahme11 keine Bio-Ausnahme vom Verbot des Wirkungstyps Herbizid. Ab2026 entfällt allein die PSM-Codierung. Der Run führt keine AGES-Abfrage oder unabhängige Produkt-/Registerprüfung durch; die synthetischen Klassifikationsangaben ersetzen keinen realen Produktbeleg. Aus einem lokalen Herbizidbefund wird keine frei erfundene100%-Sanktion abgeleitet.

Hektar bleiben Hektar; öffentliche Beteiligung wird in Prozentpunkten0bis100 angegeben. Andere Flächenzahlungen sind andere, bereits angemessen reduzierte EUR/ha ohne erneute Einrechnung des eigenen Anteils. Wirkstoffnamen sind Strings, Wirkungstyp und Anwendungszone unterschiedliche Enums. Inventarmenge und -einheit sind vorgeschlagen, werden aber nicht umgerechnet. Behördliche Sanktionsstufen werden nicht aus beliebigen lokalen Meldungen erzeugt.

## Fehlend, null und technische Konsistenz

Die86 frischen Proben bestehen aus13 Quellenkomponenten,30 gewünschten positiven Nachweisverträgen,34 technischen/Konsistenzproben und neun ausdrücklich schemawidrigen Stresstests.83 Abfragen laufen über den Hauptentscheid, drei über separate Helfer.73 Ergebnisse sind definiert, elf brechen im Hauptpfad ab und zwei bleiben undefiniert.121 Assertions ergeben83 erfüllte und38 unerfüllte Verträge. Daraus entsteht keine Genauigkeitsquote.

| Tatsächlicher Fehlerpfad | Klasse | Hauptpfadursache |
| --- | --- | --- |
| `farm.oepul.measures[].contract_start_year` | neu, gültiges `int|null` | Subtraktion vonnull |
| `farm.oepul.measures[].exit_date` | neu, gültiges `date|null` | `substring(null)` |
| `farm.oepul.measures[].conversion_application_date` | neu, gültiges `date|null`, Ziel1B tatsächlich ausgewählt | `substring(null)` |
| `farm.oepul.takeover.takeover_date` | neu, gültiges `date|null` | `substring(null)` |
| `farm.oepul.takeover.expansion_area_ha` | neu, gültiges `number|null` | Multiplikation mitnull |
| `land.parcels[].oepul.other_area_payments_eur_per_ha` | neu, gültiges `number|null` | Addition mitnull |
| Doppelte `land.parcels[].parcel_id` mit unterschiedlichen Records | strukturelle Identitätskonsistenz | widersprüchliche Objekt-Schlüssel |
| `land.parcels[].operations.psm_applications[].date=null` | außerhalb des **nichtnullable** PSM-Datumstyps | `substring(null)` |
| `documentation.plant_protection_inventory[].active_substances[]=42` | Zahl außerhalb desStringvertrags | `lower(42)` |
| `farm.oepul.special_circumstances[].occurrence_date=null` | außerhalb des nichtnullable Ereignisdatums | `substring(null)` |
| `land.parcels[].area_ha=null` | außerhalb des Canonical-Zahlentyps | Summe enthältnull |

Genau sechs unterschiedliche neue Nullableblätter brechen den Hauptpfad ab. Es gibt keinen beobachteten Abbruch auf einem bestehenden erlaubten nullable Canonical-Blatt und keinen beobachteten Fehlend-zu-null-Defaultabbruch. Der erlaubte ursprüngliche Antragspfad `farm.oepul.measures[].application_date=null` ist ausdrücklich **nicht** der schemawidrige PSM-Datumspfad: er kann günstig lexikalisch verglichen werden und bleibt eine Nachweisgrenze, kein gezählter Absturz. Ein nicht ausgewählter optionaler Umstieg mit leerem Datum ist ebenfalls nicht derselbe Fall wie der ausgewählte1B-Umstieg mit erforderlichem unbekanntem Datum.

Die zwei undefinierten Ergebnisse bleiben getrennt: ein ungültiges Sanktions-Enum `r7` lässt die Hauptentscheidung undefiniert; ein explizites gültigesnull beim separaten Vorjahresflächenhelfer ist erwartbar unbelegt. Keines wird als zusätzlicher Laufzeitfehler oder positiver Quellenfall gezählt. Der primitive0-ha-Bereichstest bleibt hier definiert; der Divisionsfehler aus o6_10 wird nicht übernommen.0ha ist trotzdem kein normaler positiver physischer Schlag. Doppelte Vertrags-/Schlag-IDs erhalten kein erfundenes Urteil darüber, welche widersprüchliche Seite die tatsächliche Wahrheit sei.

Der Scan aller vorhandenen Werte gegen das unveränderte Canonical-Profil und die tatsächlichen zehn Ergänzungen prüft5.635 Primitive/Containerwerte. Er findet ausschließlich die neun deklarierten Stresstests und keine unbekannten Eingabepfade. Der Enumscan prüft499 Werte auf zwölf Pfaden: ausschließlich das deklariert unzulässige `effect_type=null` und `sanction_level="r7"` weichen ab. Das ist keine Zertifizierung fehlender Pflichtfelder, realer Tatsachen, zeitlicher Vollständigkeit oder Identitätskonsistenz.

## Nachweise und finanzielle Reichweite

Offen bleiben Nachweise dort, wo fehlende Originalantrags-/Personenangaben, aktuelle Zahlungsbeantragung, Obstveredelung, Lage, aktive Produktion oder permanente Bewirtschaftung nur bei bestimmten negativen Werten beanstandet werden. Fehlende schlagbezogene Maßnahmenlisten werden durch `["11"]` ersetzt. Nutzungsart-null fällt auf die grobe Canonical-Kultur zurück; Obstname-null wird als Obst behandelt. Diese Eingabekonventionen beweisen weder GIS-Klassifikation noch tatsächliche Veredelung oder Bewirtschaftung. Unbekannte Angaben sind in den gewünschten Nachweisverträgen keine erwiesenen tatsächlichen Frist-, Herbizid- oder Bewirtschaftungsverstöße.

Vorhandene sichere Verbraucher bleiben erhalten: der bekannte aktuelle fehlende Zahlungsantrag nach dem ersten Jahr, bekannte Kontrollverweigerung ohne positive Ausnahme und bekannte Ausschlüsse sperren die Auszahlung. Eine tatsächliche anerkannte Kontroll-Ausnahme verlangt positivtrue. Die Inventar-Ausnahme verlangt gleichzeitig tatsächlich andere Kultur, positive Aufzeichnungen und positive Plausibilität. Das sind wirksame Eingaben, keine pauschal als fehlend bezeichneten Gates.

Die21 Blätter ohne eigenen aktuellen Betragsschalter erreichen Anwendungen-/Inventarmeldungen, Übernahmediagnosen oder Rückforderungsstatus. Vergangene Rückforderungsfolgen werden vom aktuellen Betrag getrennt. Aus einer lokalen Meldung wird keine willkürliche behördliche Sanktionsstufe abgeleitet. Eine Übernahmediagnose und der separat abfragbare Helfer `takeover_valid` begründen im Hauptpfad keinen alternativen ursprünglichen Vertrag.

Produkt-/Batch-/Zielschlag-/Mengenverknüpfung und Registerevidenz bleiben teilweise vorgelagert. Der Inventarfall mit altem Kaufdatum, `in_storage=false` und0Menge prüft ausschließlich Typ-/Zeitvertragsverhalten: ob die Liste einen aktuellen Bestand oder historische Käufe enthalten darf, ist nicht vollständig definiert. Dafür wird weder eine frei erfundene Archiv-Ausnahme noch eine tatsächliche aktuelle Kauf-/Lagerverletzung als Quellen-Sollwert behauptet. Überschneidungen mit den Allgemein-, Quellen- und Tabellendossiers werden nicht als mehrere unabhängige Auswirkungen ausgegeben.

## Tatsächliche App-Projektion

Die unveränderte reine Funktion `adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` ausgeführt. Ein Guard auf `CursorWrapper.execute` hätte jeden SQL-Aufruf sofort gestoppt; tatsächlich gab es0Datenbankaufrufe. Recommender, Canonical-Builder und Schema-Blueprint sind mit tatsächlichen Codehashes gebunden. Exakte Eingangs-/Ausgangswerte, Typen und Pfadvergleiche stehen im JSON. Die Vereinigung aller Vorschläge dient ausschließlich der Strukturdiagnose und ist kein tatsächlicher Betrieb mit sämtlichen gleichzeitig ausgewählten Optionen.

| Projektionsgruppe | Vorher vorhanden | Mit identischem Wert und Typ erhalten |
| --- | ---: | ---: |
| Vorschlagspfade |10|0|
| Effektive neue Blätter |67|0|
| Weitere Canonical-Blätter |6|4|

Nutzpflanzenname und -kategorie gehen verloren; die übrigen vier zusätzlichen Werte bleiben erhalten. Ähnliche App-Namensräume werden nicht als freigegebene Aliase gerechnet. Dieses Ergebnis wurde für o6_11 tatsächlich neu gemessen und nicht aus Vorgängerruns übernommen.

Der exakt projizierte Ausgang wurde unverändert separat durch den ursprünglichen Run abgespielt. Er bleibt definiert mit `participates=false`, `contract_valid=false`, `compliant=false`,0€ Prämie und leeren Verstoßlisten. Dieser eine Integrationslauf zählt getrennt von den86 frischen Entwicklungsproben. Er belegt weder einen realen Bewirtschaftungsverstoß noch eine positive Endpunkt-/Serverfreigabe.

Alle nativen Läufe verwenden `/tmp/issue-51-review-opa` in Version1.18.2 mit SHA256 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`, strikten Builtin-Fehlern, zehn Sekunden Auswertungslimit,20Sekunden Prozesslimit und ausgeschlossenen Netzwerk-/Zeit-/Zufalls-/Runtimebuiltins. Geladen werden die ursprünglichen Policy- und Datenverzeichnisse. Hauptquery ist `data.oepul.o6_11.decision`, statische Daten bleiben unter `data.o6_11`. Regelobjektmatcher werden nur für tatsächliche Objektarrays benutzt. Typen, Namespace, Originalquellen, Canonical-Profil, historische Policies und produktive App bleiben unverändert. Geschrieben wurden nur diese beiden Dossierteile und eigene temporäre Prüfdateien; kein weiterer Run wurde begonnen.

## Transparente Metadatenkorrektur

Die frühere JSON-Fassung `81168b8cd4b3a49344158d3f822aa4fdc140fb6c498bd61e5aa378494dbabdef` und Markdown-Fassung `8b5d65edb4780efdaaaf859ce31429de8fc996f9f3ea023ed36182babf54d265` bezeichneten die drei gleichzeitig auf Herbizid/Bio gesetzten Flächen-/Stamm-/Zaunfälle zu weitgehend als bekannte Quellenkomponenten. Ohne tatsächlichen AGES-/Bio-Produktbeleg sind dies hypothetische technische Kreuzklassifikationskontrollen. Die Klassenzahlen ändern sich deshalb von16 Quellenkomponenten/31 technischen Proben auf13/34. Alle86 Eingaben, Queries, Erwartungen und Beobachtungen sowie die übrigen83 Probendatensätze bleiben unverändert. Die Metadatenrevision und die unveränderte Eingabe-/Query-/Erwartungsbindung sind im JSON festgehalten.
