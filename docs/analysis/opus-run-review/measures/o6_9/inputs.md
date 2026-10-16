# o6_9: Eingabevertrag und tatsächliche Verbraucher

Geprüft wird ausschließlich der ursprüngliche Opus-Run `v2-o6_9-opus-5.5-high-20261003` am Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieses Entwicklungsdossier enthält keine Promotion, Produktfreigabe oder fachliche Gesamtgenauigkeit. Die ausführliche maschinenlesbare Fassung liegt in [inputs.json](inputs.json). Sie ist mit SHA256 `7d4f7632eac411876fea5a2fba215cad951d4b1c1cddc6a6b4b6007af51e89c4` eingefroren.

Das neue Maßnahmenblatt vom Juni 2026 wurde auf allen neun Seiten vollständig gelesen. Neu vollständig gelesen wurden außerdem alle 42 Seiten der NAPV-Fassung vom 28.10.2024: Begriffe, Verbots- und Ausbringungsregeln, Lagerung, Aufzeichnungen, Inkrafttreten, sämtliche Tabellen und Fußnoten sowie die gesamte Gebietsliste. Alle acht Produktionsmodule und die Rohannahmen wurden gelesen. Zehn tatsächlich gelieferte Originalquellen sind einzeln hashgebunden. Die acht gemeinsamen Originale stimmen mit früher vollständig gelesenen Fassungen überein; aktuelle Klauseln wurden erneut am Original geprüft. Die hier gelieferte GSP-AV mit Hashbeginn `d01dd802` wird aus den vollständigen Lesungen zu o6_1c/o6_4 wiederverwendet und gezielt erneut gelesen. Das rechnet sie nicht nachträglich Runs an, denen sie fehlte.

Alle 62 den Vorschlägen zugewiesenen Belege sind auf der angegebenen Originalseite beziehungsweise im Original-HTML wortgetreu nach bloßer Whitespace-Normalisierung auffindbar. Auch die zusätzlichen eigenen Probe- und Befundbelege wurden so überprüft. Historische Selbsttests, Studienfälle, Expert:innenantworten, GM-Labels und manuelle Adaptationstests lieferten keine Sollwerte.

## Vollständiger Katalog

Der tatsächliche Katalog enthält 25 Vorschläge: 24 Ergänzungen und eine Änderung des bestehenden Tierkategorie-Enums. Daraus entstehen 97 effektive Blätter, davon 96 neue und ein geändertes. Alle 97 werden gelesen. Fünf wirken nur in separat abfragbaren Helfern; 48 wirken als Hauptmeldungs-/Warnverbraucher ohne eigenen Betragsschalter. Das allgemeine `eligible` kann sich durch einen Verstoß trotzdem ändern. Diese Wirkung wird von einer finanziellen Kürzung getrennt.

Der JSON-Ledger erfasst jedes Blatt mit genauem Typ, Einheit, fachlicher und zeitlicher Bedeutung, Identitätsvertrag, Konditionalität, Fehlend-/Nullverhalten und sämtlichen tatsächlichen Lesestellen. Ein Blatt `...[]` beschreibt ein Arrayelement, keinen als Skalar missverstandenen Container. Bei Objektarrays kennzeichnet `[]` den wiederholten Record; ihre einzelnen Blätter tragen weiter ihren skalaren Typ.

| Nr. | Originaler Vorschlagspfad | Aktion | Blätter |
| --- | --- | --- | ---: |
| 1 | `farm.applicant_type` | Ergänzung | 1 |
| 2 | `farm.public_body_share_percent` | Ergänzung | 1 |
| 3 | `farm.manages_in_own_name_and_account` | Ergänzung | 1 |
| 4 | `farm.is_active_farmer` | Ergänzung | 1 |
| 5 | `farm.exercises_agricultural_activity` | Ergänzung | 1 |
| 6 | `farm.oepul_first_participation_year` | Ergänzung | 1 |
| 7 | `farm.all_areas_in_austria` | Ergänzung | 1 |
| 8 | `land.protected_cultivation_area_ha` | Ergänzung | 1 |
| 9 | `land.parcels[].crop.is_legume_pure_stand` | Ergänzung | 1 |
| 10 | `land.parcels[].constraints.full_fertilization_ban` | Ergänzung | 1 |
| 11 | `land.parcels[].oepul_codes` | Ergänzung | 1 |
| 12 | `land.parcels[].oepul_measures` | Ergänzung | 1 |
| 13 | `land.parcels[].harvest_share` | Ergänzung | 1 |
| 14 | `land.parcels[].force_majeure_recognised` | Ergänzung | 1 |
| 15 | `land.parcels[].no_harvestable_crop_due_to_drought` | Ergänzung | 1 |
| 16 | `land.parcels[].late_summer_or_autumn_harvest_crop` | Ergänzung | 1 |
| 17 | `land.parcels[].non_eligible_area` | Ergänzung | 1 |
| 18 | `land.parcels[].in_national_park` | Ergänzung | 1 |
| 19 | `land.parcels[].located_in_austria` | Ergänzung | 1 |
| 20 | `land.parcels[].protected_cultivation_pot_or_substrate` | Ergänzung | 1 |
| 21 | `land.parcels[].area_payments_eur_per_ha` | Ergänzung | 1 |
| 22 | `livestock.species_groups[].annual_average_count` | Ergänzung | 1 |
| 23 | `livestock.species_groups[].kept_in_austria` | Ergänzung | 1 |
| 24 | `livestock.species_groups[].category` | Änderung | 1 |
| 25 | `oepul_measures.o6_9` | Ergänzung | 73 |

203 kontextuelle Lesestellen sind erfasst. Zwei dynamische Leser werden konkret aufgelöst: `required_record_fields` liest fünf Pflichtrecordfelder; `volumes_m3[t]` liest die drei tatsächlich in der Technik-Tabelle enthaltenen Schlüssel. `is_true`, `is_false` und `has_value` sind an ihren konkreten Aufrufstellen aufgelöst. Die generische Prüfung gemeinschaftlicher Geräte wird beiden realen Empfängern zugeordnet, während jeder konkrete `used`-Aufruf bei seiner tatsächlichen Komponente bleibt. Verschachtelte Crop-, Constraint- und Shared-Equipment-Empfänger wurden ausdrücklich nachgetragen. Das ist ein manuell überprüfter, auf diesen Run zugeschnittener Ledger und kein behaupteter allgemeiner Rego-Parser.

Zusätzlich gibt es 13 tatsächlich gelesene Canonical-Pfade und zwei unvorgeschlagene Schlagfelder: `land.parcels[].federal_state` und `land.parcels[].district`. Sie stehen weder im Canonical-Profil noch in den 25 Vorschlägen. Bei vorhandenen Feldern überschreiben sie den Regionsfallback des Betriebs; vorhandenes null wird dabei nicht wie ein fehlender Schlüssel ersetzt. Die gesamten zusätzlichen Pfade samt Lesestellen stehen ebenfalls im JSON.

Die fünf ausschließlich separaten Helferblätter sind `excluded_from_measure`, `multiple_application_not_submitted_previous_year`, `revision_adaptation_refused`, `farm_transferred_after_mfa` und `all_conditions_met_in_transferred_farm` unter `oepul_measures.o6_9`. Der Hauptentscheidungsblock konsumiert deren Wiederantrags-, Revisions- beziehungsweise Zahlungsempfängerfolgen nicht. Globale Canonical-Dokumentationsflags, die alten Manure-Technikfelder und die vorhandenen N-Mengen pro Hektar werden nicht ersatzweise gelesen.

## Einheiten und positive Kontrollen

Die 66 frischen Proben verwenden keine fremden Run- oder Adaptationssollwerte. Drei vollständige positive Kontrollen bleiben nativ definiert, `eligible=true` und ausdrücklich ohne `violations` oder `warnings`:

| Kontrolle | Bekannte positive Tatsachen | Rohbetrag |
| --- | --- | ---: |
| Bodennahe Ausbringung | 60 m³ eigene Rindergülle per Schleppschlauch auf 3 ha Winterweizen; vollständiger Schlagrecord, normale Frühjahrsbedingungen und rechtzeitige Mengen-/Maßnahmenbeantragung | 66 € |
| Separation | 36 m³ eigene Rindergülle, mechanische Trennung mit vollständigem Datums-/Mengenrecord; zwei Jahres-Rinder-GVE und damit 40 m³ Cap | 54 € |
| Schweineoption | 20 Jahresdurchschnitts-Mastschweine = 6 GVE auf 3 ha Acker; vollständig bekannte 60–90-kg-Kategorie, 150 g Rohprotein/kg bei 88 % TM, Analyse-/Rezepturbeleg und tatsächlich mögliche/durchgeführte Phasenfütterung | 162 € |

Die Kontrollen haben jeweils nur die ausgewählte Maßnahmenkategorie; ungewählte Anwendungen, Separationsmethoden oder Optionen werden nicht erfunden. Alle Flächen liegen hypothetisch in Niederösterreich/Amstetten in Österreich. Der bekannte Winterweizen hat 5,5 t/ha Ertrag, 12 % Rohprotein und 14 % Kornfeuchte. Sein positiver N-Bedarf und die mittlere Obergrenze von 145 kg jahreswirksamem N/ha sind mit NAPV Anlage 3 I Tabelle 1 vereinbar. Vorfrucht-/Rest-/Bewässerungs-N sind hier bekannt 0. Im Ausbringungsfall entsprechen 3 kg N/m³ nach Stall-/Lagerverlusten insgesamt 60 kg N/ha; nach Ausbringungsverlust und Rindergülle-Jahreswirksamkeit sind das 36,54 kg N/ha. Das ist belegter Quellenkontext der synthetischen Kontrolle, keine Behauptung, diese zusätzlichen Berechnungseingaben würden vom Run nativ gelesen.

Bei Schweinen ist der Eingabewert bereits auf Gramm Rohprotein pro Kilogramm Ration bei 88 % Trockenmasse normiert. Die Regel berechnet keine Feuchteumrechnung und keinen nach Rationsmengen gewichteten Durchschnitt. GVE sind Jahresmittelwerte, Hektar des Pig-Denominators die gesamte Ackerfläche ohne Abzüge, die Erntequote ein Bruch von 0 bis 1 und öffentliche Beteiligung Prozentpunkte von 0 bis 100. Mengen bleiben Kubikmeter; Fläche wird nicht stillschweigend in Menge oder N umgerechnet.

Die Bruchteilrepräsentation ist tatsächlich verbessert: Ein zusätzlicher bekannter 2024-Kontext verwendet 183/366 = 0,5 Jahresrinder, ein Tier als ganzen Kopfbestand und eine eigene Separationsmenge von 10 m³. Der neue Mittelwert hat nativ Vorrang und ergibt genau 10 m³ Cap. Ein gültiges null fällt gezielt auf den nächsten Rang zurück; ein vorhandener numerischer GVE-Wert 0 wird korrekt nicht ersetzt. Ein gewöhnlicher Integer-Kopfbestand belegt außerhalb dieses bekannten Kontexts aber noch keine Jahresmittelung.

## Fehlend, null und Konsistenz

Die 66 Proben bestehen aus vier Quellenkomponenten, 34 gewünschten positiven Nachweisverträgen, 21 technischen beziehungsweise Konsistenzdiagnosen und sieben ausdrücklich schemawidrigen Stresstests. Der Quellenblock enthält die drei positiven Kontrollen sowie einen bekannten fremden Schlagverweis. 60 Abfragen sind definiert; sechs brechen nativ ab. Fehlgeschlagene Assertions werden nicht als Prozentzahl fachlicher Genauigkeit verwendet.

| Hauptpfadfehler | Eingabeklasse | Beobachtung |
| --- | --- | --- |
| `takeover.date=null` | neues, ausdrücklich nullable Vorschlagsblatt | `time.parse_ns` erhält null |
| `n_reduced_pig_feeding.start_year=null` | neues, ausdrücklich nullable Vorschlagsblatt | Fristberechnung subtrahiert von null |
| `crop.crop_name=null` | bestehendes Canonical-Blatt `string|null` | `lower(null)` |
| Zwei unterschiedliche Proteinwerte für dieselbe Rationskategorie | strukturell erlaubtes Array, widersprüchlicher Funktions-/Zeitscope | `ration_value` erzeugt mehrere Werte |
| Mengenwert als String | außerhalb des Zahlenvertrags | Summe enthält String |
| Recordarray als null | außerhalb des Arrayvertrags | `count(null)` |

Es sind genau drei erlaubte Nullable-Abbrüche auf drei verschiedenen Blättern: zwei neue Vorschlagsblätter und ein vorhandenes Canonical-Blatt. Der Rationskonflikt ist keine vierte Nullprobe. Mehrere tatsächlich zeitlich getrennte Rationen sind damit nicht rechtlich verboten; dem nativen Schlüssel fehlen Zeitraum und weiterer Identitätskontext. Die zwei schemawidrigen Abbrüche sind keine gültigen Betriebsfälle. Kein fehlender Wert wird in dieser Sammlung als beobachteter Fehlend-zu-null-Absturz gezählt. Insbesondere meldet ein fehlendes direktes `takeover.date` einen Befund, während das erlaubte explizite null abstürzt. Sämtliche sechs Abbrüche betreffen den Hauptpfad, keiner einen nur separat abgefragten Helfer.

Der vollständige tatsächliche Typ-/Enumscan verwendet das eingefrorene Canonical-Profil mit genau den vorgeschlagenen Ersetzungen. Er findet ausschließlich die sieben fallweise deklarierten Schema-Stresstests: vier nichtnullable Booleanfelder mit null, eine Mengen-Zahl als String, ein Recordarray als null und eine nichtnullable Protein-Zahl als null. Die Arten-/Kategorie-Konsistenzprobe und der Rationskonflikt sind einzeln kenntlich gemacht; beide erfüllen die jeweiligen Blatt-/Container-Typen. Die Kontrollen verwenden ausschließlich gültige `cereal`-, Tierarten-, Tierkategorie- und Optionskategorie-Werte.

Erhalten werden sichere Verbesserungen: fehlende/null-Maßnahmen- und Optionsantragsdaten erzeugen tatsächlich die passenden Befunde; unbekannte GVE-Aggregate und Mittelwerte besitzen bewusste Fallbacks; Daten zu höherer Gewalt und Obergrenzenwerte sind vor Nullarithmetik geschützt. Fremdgeräte verlangen positiv Rechnung oder geeignete Unterlagen. Gemeinschaftsgeräte verlangen positiv Kontrollierbarkeit und an Teilnehmer adressierte Rechnung; Biogas verlangt positiv Ausgangsproduktnachweise. Rezeptur- und erforderliche Phasenfütterungsbelege werden ebenfalls positiv abgefragt. Diese Gates werden nicht mit pauschalen früheren Fehlern überschrieben.

Offen bleiben positive Nachweise bei Mengenantragsdatum, persönlichen Voraussetzungen, mechanischer Separation und vollständigem gehaltenem Tierkategorieninventar. Hier verlangen Unbekanntproben einen gewünschten Nachweisbericht oder eine zurückgehaltene Freigabe. Sie behaupten nicht, dass ein unbekannter Antrag tatsächlich zu spät, eine unbekannte Technik tatsächlich falsch oder eine unbekannte Quote tatsächlich zu niedrig war. Beim zulässigen null-Ernteanteil führt dagegen der native Typvergleich zu einer Managementwarnung; diese Beobachtung belegt keinen tatsächlichen Ernteverstoß.

## Identität und finanzielle Reichweite

Pflichtrecordfelder und unbekannte Fremd-Schlag-IDs sind echte Verbraucher. Die erfassten Materialtypen und Kulturlisten werden jedoch nur teilweise zusammengeführt: `record.manure_type` benötigt bloß einen vorhandenen Wert, während die Allowlist ein getrenntes Materialaggregat prüft. Die Mehrschlagprüfung zählt eine selbst gelieferte gemeinsame Kulturliste und verbindet sie nicht mit den tatsächlichen Schlagkulturen. Der frische bekannte Weizen/Gerste-Widerspruch bleibt damit ungemeldet. Fehlende/null-Aufzeichnungsfläche überspringt die Flächensumme. Diese Proben sind ausdrücklich Konsistenz- beziehungsweise Nachweisgrenzen; keine widersprüchliche Eingabeseite wird zur wahren Wirklichkeit erklärt.

Nicht jede fehlende redundante Aggregatliste ist ein Quellenfehler: In der Kontrolle mit weiterhin vollständig bekannten 60 m³ Slurry-/Schleppschlauchrecords bleiben die tatsächlichen Material-/Technikdaten positiv vorhanden, obwohl die zusätzliche Aggregatliste fehlt. Dieser Fall erwartet gerade kein erfundenes Duplikatdokument. Die leere Biogas-Inhaltsstoffliste bei positiver Menge ist hingegen als Inventarkonsistenzdiagnose markiert; sie wird nicht zu einer tatsächlich verbotenen Zutat umetikettiert.

Die NAPV enthält eine umfassendere N-Bedarfsableitung aus Ertragslage, Vorfrucht, Nmin und Bewässerungswasser, als dieser Eingabevertrag verarbeitet. Kurze Nutzpflanzennamenlisten und externe Kategorie-/Reinbestandsflags ersetzen keine vollständige fachliche Bedarfsberechnung. Für gegebene Klassifikation wird nur der tatsächlich implementierte Verbraucher beurteilt; ähnliche Schreibweisen oder ein nicht gelistetes Wort sind keine genehmigte botanische Normalisierung.

Der native Befundblock sperrt das allgemeine `eligible`, der rohe Prämienblock wird aber separat berechnet. Viele Nachweis-, Herkunfts-, Kontroll- und Technikbefunde wirken dort nicht als eigener Betragsschalter; NAPV und flächenbezogene Obergrenzen werden ausdrücklich nur gewarnt. Die fünf separaten Helfer sind ebenfalls nicht in den Hauptvertrag eingebunden. Das ist dokumentierter Implementierungsumfang und kein frei erfundener gesetzlicher Vollkürzungssatz. Die Rohannahmen lassen die Sanktionseinstufung bei der AMA. Ob ein bestimmter Quellenverstoß eine konkrete finanzielle Folge verlangt, wird im Dossier aus dessen Quelle getrennt geprüft.

## Tatsächliche App-Projektion

Die unveränderte reine Funktion `adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` ausgeführt. Ein Guard auf `CursorWrapper.execute` hätte jeden SQL-Aufruf sofort gestoppt; es gab 0 Datenbankaufrufe. Recommender, Canonical-Builder und Schema-Blueprint sind mit ihren tatsächlichen Codehashes gebunden. Die vollständigen Eingangs-/Ausgangswerte sowie die Typen jeder projizierten Pfadmenge stehen im JSON. Die diagnostische Vereinigung aller Vorschläge ist kein behaupteter tatsächlicher Betrieb mit sämtlichen gleichzeitig gewählten Optionen.

| Projektionsgruppe | Vorher vorhanden | Nativ am selben Pfad erhalten |
| --- | ---: | ---: |
| Neue Vorschlagspfade | 24 | 0 |
| Geändertes bestehendes Kategorie-Enum | 1 | 0 |
| Effektive Vorschlagsblätter | 97 | 0 |
| Weitere Canonical-Pfade | 13 | 9 |
| Unvorgeschlagene Schlag-Regionspfade | 2 | 0 |

Das geänderte Kategorie-Enum ist am Ausgang vollständig abwesend. Der Eingangsstring `cattle_from_2_years` wird nicht lediglich in eine andere gleichwertige Kategorie übersetzt. Ebenso sind `oepul.measures`, `oepul_measures.o6_9` und andere ähnlich benannte App-Bereiche keine freigegebenen Aliase. Von den zusätzlichen Canonical-Pfaden gehen Bundesland, Bezirk sowie Nutzpflanzenname und -kategorie verloren; die neun übrigen Werte und Typen bleiben gleich.

Der exakt projizierte Ausgang wurde separat und unverändert durch denselben Roh-Run abgespielt. Er ist definiert mit `eligible=false`, `contract_lapsed=true`, `no_valid_contract=false`, leeren Befund- und Warnlisten und 0 € Gesamtbetrag. Die rohe Klassifikationsheuristik berechnet trotz fehlender Crop-Klassifikation weiterhin 3 ha düngungswürdige Fläche beziehungsweise 150 m³ Ausbringungscap; vorhandene Gruppen-GVE liefern 40 m³ Separationscap. Das belegt weder eine positive reale N-Bedarfsprüfung noch eine Antragsfreigabe. Die Projektion und ihr Replay werden als ein eigener Integrationslauf getrennt von den 66 Quellen-/Nachweis-/Robustheitsproben gezählt.

Alle nativen Läufe verwenden `/tmp/issue-51-review-opa` in Version 1.18.2 mit SHA256 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`, strikten Builtin-Fehlern, Zeitlimit und deaktivierten Netzwerkbuiltins. Geladen werden die ursprünglichen Policy- und Datenverzeichnisse; Hauptquery ist `data.oepul.o6_9.decision`, statische Daten liegen unter `data.o6_9`. Typen, Namespace und Datenpfade wurden nicht umgeformt. Regelobjektmatcher werden ausschließlich für tatsächliche `violations`-/`warnings`-Objekte benutzt, auch bei leeren Ergebnissen. String-IDs, Kategorien und Indexlisten werden nicht als Regelobjektarrays behandelt.

Es wurden ausschließlich diese beiden Eingabedossierteile geschrieben. Historischer Run, Originalquellen, Canonical-Profil, Policies und produktive App bleiben unverändert; kein weiterer Run, neuer Modellaufruf, Branch oder Commit wurde begonnen.
