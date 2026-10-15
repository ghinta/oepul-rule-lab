# o6_10: Eingabevertrag und tatsächliche Verbraucher

Geprüft wird ausschließlich der ursprüngliche Opus-Run `v2-o6_10-opus-5.5-high-20260925` am Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Die maschinenlesbare Fassung [inputs.json](inputs.json) ist mit SHA256 `49fc933ae7b97a4afc4413409473987b6b0b18aac0caeff10b4b7f705656a48a` eingefroren. Dieses Dossier ist eine öffentliche Entwicklungsprüfung und keine Promotion, behördliche Freigabe, Expert:innenabnahme oder Genauigkeitsmessung.

Das neue Maßnahmenblatt wurde vollständig auf allen sechs Seiten einschließlich sämtlicher Tabellen, Fortsetzungen und Ausnahmen gelesen. Alle acht Produktionsmodule und sämtliche Rohannahmen wurden vollständig gelesen. Alle acht tatsächlich gelieferten Originale sind hashgebunden; sieben gemeinsame Originale werden aus den dokumentierten früheren vollständigen Lesungen wiederverwendet. Die aktuellen ATB-/SRL-/Anhang- und Meldeklauseln wurden erneut am Original geprüft; genaue Seiten und Ausschnitte stehen im JSON-Lesebeleg. Alle 56 den Vorschlägen zugewiesenen Zitate sind nach bloßer Whitespace-Normalisierung auf ihrer angegebenen Originalseite auffindbar. Das Paket enthält kein GSP-AV- oder NAPV-Original. Die zusätzlichen Quellen aus o6_9 werden diesem Run nicht nachträglich angerechnet. Historische Selbsttests, Studienfälle, GM-/Expert:innenlabels und manuelle Adaptationstests liefern keine Sollwerte.

## Vollständiger Katalog

Die 20 tatsächlichen Vorschläge sind ausschließlich Ergänzungen. Sie ergeben 62 effektive Blätter: 61 werden gelesen, `land.parcels[].permanent_crop.planting_year` bleibt ungenutzt. Es gibt keinen nur separat abgefragten Vorschlagshelfer. 23 gelesene Blätter wirken als Meldungs-/Hinweisverbraucher ohne eigenen Betragsschalter: 18 Begrünungsblätter, zwei Dokumentinventare, die schlagbezogene Maßnahmenliste und zwei betriebliche Hinweise. Diese Reichweite wird von tatsächlichen finanziellen Gates getrennt.

| Nr. | Originaler Vorschlagspfad | Blätter |
| --- | --- | ---: |
| 1 | `farm.applicant` | 4 |
| 2 | `farm.oepul.first_oepul_participation_year` | 1 |
| 3 | `farm.oepul.participating_measures` | 1 |
| 4 | `farm.oepul.producer_organisation` | 2 |
| 5 | `farm.oepul.conditionality_breach` | 1 |
| 6 | `farm.oepul.exited_measure_12_rebzikade_2026` | 1 |
| 7 | `farm.oepul.o6_10` | 12 |
| 8 | `land.protected_cultivation_area_ha` | 1 |
| 9 | `land.parcels[].permanent_crop` | 7 |
| 10 | `land.parcels[].oepul_codes` | 1 |
| 11 | `land.parcels[].oepul_measures` | 1 |
| 12 | `land.parcels[].op_excluded_measures` | 1 |
| 13 | `land.parcels[].location` | 2 |
| 14 | `land.parcels[].is_gloez_landscape_element` | 1 |
| 15 | `land.parcels[].other_area_payments_eur_per_ha` | 1 |
| 16 | `land.parcels[].transfer` | 2 |
| 17 | `land.parcels[].operations.inter_row_greening` | 18 |
| 18 | `land.parcels[].operations.organisms_pheromones` | 3 |
| 19 | `documentation.o6_10_greening_record_items` | 1 |
| 20 | `documentation.o6_10_organisms_pheromones_record_items` | 1 |

Der Ledger erfasst für jedes Blatt den tatsächlichen Typ, Einheit, fachliche und zeitliche Bedeutung, Identitäts- und Konditionalitätsvertrag, Fehlend-/Nullverhalten und sämtliche tatsächlichen Lesestellen. `[]` bezeichnet ein wiederholtes Arrayelement, keinen als Skalar missverstandenen Container. Der neu vorgeschlagene Stamm `farm.oepul.o6_10` und `farm.applicant` sind die wirklichen Verbraucher; ähnlich benannte bisherige App-Felder gelten nicht als bestätigte Aliase.

151 kontextuelle Lesestellen sind erfasst. Zwei dynamische Schleifen werden auf die tatsächlichen Schlüssel aufgelöst: zwei persönliche Voraussetzungen und drei Mindestbewirtschaftungskriterien. Empfänger wie `greening(p)`, konkrete Organismenobjekte, Ereignisse und Kontrollfeststellungen wurden verfolgt; `r.item` aus statischen Tabellen wird nicht als Eingaberecord missverstanden. Dies ist ein manuell kontrollierter Ledger dieses Runs, kein allgemeiner Rego-Parser. Zusätzlich werden sieben bestehende Canonical-Blätter gelesen: Jahr, Gesamtfläche, Schlag-ID und -fläche, Nutzpflanzenname/-kategorie und Hangneigung. Es gibt keinen tatsächlich gelesenen unvorgeschlagenen Pfad. Globale Canonical-PSM-, Ackerbegrünungs- und Dokumentationsflags ersetzen die speziellen Felder nicht.

## Positive Komponenten und Einheiten

Die 70 frischen Proben enthalten sechs bekannte positive Ausgangsfälle. Jeweils der ganze hypothetische österreichische Betrieb besteht aus dem beschriebenen 2-ha-Schlag. Alle tatsächlichen Bewirtschaftungs- und Nachweisvoraussetzungen sind unabhängig positiv stipuliert; keine unbekannte Arbeit wird als zusätzliche Ausführung erfunden. Bestehende Begrünung wird belassen. Die Terrassenkontrolle hat eine bekannte GIS-Hangneigung von 30 Prozent und benötigt keine Begrünung. Nicht gewählte EOP- oder Übernahmeereignisse bleiben tatsächlich nicht gewählt.

| Kontrolle | Bekannte Quelle und Komponente | Nativer Betrag |
| --- | --- | ---: |
| Wein | 2 ha, 30 % Hangneigung × 324 €/ha | 648 € |
| Obst | 2 ha Apfel, veredeltes Material, 30 % × 378 €/ha | 756 € |
| Hopfen | 2 ha × 216 €/ha | 432 € |
| Weinterrasse | 2 ha, anerkannte 30 % × 324 €/ha | 648 € |
| Wein mit EOP | 648 € Basis + 2 ha × 162 €/ha, keine Kürzung | 972 € |
| Bekannte Übernahme | 2 ha Wein; rechtzeitig, vorheriger Nichtteilnehmer, 0 ha Erweiterung | 648 € |

Alle sechs sind definiert, `contract_valid=true` und ohne Verpflichtungsbefunde. Die EOP-Kontrolle setzt einen tatsächlich verifizierten zulässigen Registeraufwand und PSM-Ersatz sowie vorhandene vollständige schlagbezogene Belege voraus. Die drei Eingabeflags führen selbst keine AGES-Abfrage durch. Die Übernahmekontrolle setzt die anerkannte vollständige Quellensituation voraus; der native Datums-/Flächencheck ersetzt keine AMA-Genehmigung.

Hektar bleiben Hektar, Streifenbreiten Zentimeter und Grün-/Getreideanteile Prozentpunkte von 0 bis 100. Der maximale Getreide-/Maisanteil beschreibt den Bestand zu jedem Zeitpunkt des Jahres, keinen Saatgutmassenanteil. Öffentliche Beteiligung wird ebenfalls in Prozentpunkten angegeben. Andere Flächenzahlungen sind **andere** EUR/ha, also ohne nochmalige Einrechnung des eigenen Maßnahmenteils. Jahresangaben unterscheiden erstes ÖPUL-Programmjahr, Originalantragsdatum und daraus abgeleiteten Vertragsstart. Kontrollstufen sind behördlich bewertete aktuelle Feststellungen; sie werden nicht aus beliebigen lokalen Bewirtschaftungsmeldungen errechnet.

## Fehlend, null und technische Konsistenz

Die Sammlung enthält 11 Quellenkomponenten, 32 gewünschte positive Nachweisverträge, 19 technische/Konsistenzproben und acht ausdrücklich schemawidrige Stresstests. 68 Abfragen laufen über den Hauptentscheid, zwei über gesonderte Helfer. 61 Abfragen sind definiert, neun brechen im Hauptpfad ab; keiner der zwei Helfer bricht ab. 112 Assertions ergeben 83 erfüllte und 29 unerfüllte Verträge. Daraus wird keine fachliche Genauigkeitsquote berechnet.

| Hauptpfadabbruch | Eingabeklasse | Ursache |
| --- | --- | --- |
| `takeover.request_date=null` | neues gültiges `date|null` | ungeprüftes `time.parse_ns(null)` |
| `takeover.taken_over_area_ha=null` | neues gültiges `number|null` | Multiplikation mit null |
| `other_area_payments_eur_per_ha=null` | neues gültiges `number|null` | Addition mit null |
| Zusätzlicher 0-ha-Schlag | primitiver Typ gültig, Bereichs-/Konsistenzdiagnose | Division durch 0 |
| Zwei unterschiedliche Records mit derselben `parcel_id` | Typen gültig, Identitätskonflikt | mehrdeutiger Objekt-Schlüssel |
| Ereignisdatum als null | außerhalb des nichtnullable Datumstyps | Datumsparser |
| Vorherige Vollkürzungszahl als null | außerhalb des Integervertrags | Addition |
| Maßnahmenobjekt als null | außerhalb des Objektvertrags | `object.get` |
| Canonical-Schlagfläche als null | außerhalb des Zahlentyps | Summe enthält null |

Es gibt genau drei erlaubte Nullable-Abbrüche auf drei neuen Blättern, keinen auf einem bestehenden nullable Canonical-Blatt und keinen beobachteten Fehlend-zu-null-Defaultabbruch. Insbesondere bleibt ein fehlendes Übernahmedatum definiert und führt zur Ablehnung, während dessen explizites erlaubtes null abstürzt. Ein 0-ha-Schlag ist kein normaler positiver physischer Fall und kein Fördergold. Mehrdeutige Schlag-IDs sind ebenfalls ein eigener Identitätsvertrag. Die vier schemawidrigen Abbrüche sind keine gültigen Betriebsfälle.

Der vollständige Scan aller **vorhandenen** Werte gegen das unveränderte Canonical-Profil und die tatsächlichen 20 Ergänzungen prüft 5.764 Primitive/Containerwerte. Er findet ausschließlich die acht deklarierten Stresstests: nichtnullable Boolean-, Enum-, Datums-, Integer-, Zahl-, Array- und Objektwerte. Es gibt keine zusätzlichen Abweichungen oder unvorgeschlagenen Pfade. Dieser Scan zertifiziert weder fehlende Pflichtfelder noch reale Tatsachen, zeitliche Vollständigkeit oder Identitätskonsistenz. Der ergänzende Enumscan prüft 1.085 vorhandene Enum-Werte auf 14 tatsächlichen Pfaden. Er findet ausschließlich den deklarierten Stresstest `permanent_crop.type="grape"`; kein weiterer Wert weicht ab.

Positive sichere Verbraucher bleiben erhalten: ein fehlendes/null Originalantragsdatum begründet keinen Vertrag; ein aus dem Antragsdatum erst zukünftig abgeleiteter Vertragsstart wird zurückgehalten. Bekannte MFA-Nichtabgabe, Kontrollverweigerung oder behördliche Exclusion setzen die tatsächliche Auszahlung auf 0. EOP benötigt die drei positiven Einsatz-/Register-/Ersatzflags. Canonical-Nullhangneigung und -Nullobstname sowie optionale Nicht-Ereignis-Datumswerte bleiben technisch definiert. Der neutrale Hangfallback ist eine deklarierte Modellannahme, kein bekanntes GIS-Ergebnis von 0 Prozent.

Offen bleiben positive Nachweise dort, wo günstige Defaults persönliche Voraussetzungen, öffentliche Beteiligung, aktuellen MFA, österreichische Lage, Mindestbewirtschaftung oder bekannte Übernahmeflächen/-vorgeschichte ersetzen. Fehlende/null Pflanzgut-, Streifenbreiten- und Bestandsanteilswerte können weiterhin Prämien oder stille Vergleiche zulassen. Unbekannte Angaben werden in den gewünschten Nachweisverträgen nicht als tatsächlich verspätete Anträge, unveredeltes Material, rechtswidrige Technik oder behördlich festgelegte Vollsanktionen bezeichnet.

## Identität und finanzielle Reichweite

Die Aufzeichnungsfelder enthalten Inventare von Dokumentarten. Sie prüfen weder tatsächliche Betrieb-/Feldstück-/Schlagnummern noch Datumswerte, Mengen, Einkaufsbelege oder den Join zwischen tatsächlichem EOP-Einsatz und schlagbezogenen Aufzeichnungen. Vollständige reale Nachweise sind damit ein vorgelagerter Tatsachenvertrag. Das Kennzeichen zur Erzeugerorganisation muss das Programm der Organisation beschreiben, unabhängig davon, ob der einzelne Betrieb selbst abgegolten wird; der widersprüchlich enge Feldname darf nicht als Individualabrechnung interpretiert werden.

23 Blätter erreichen Meldungen/Hinweise ohne eigenen Betragsschalter. Die Rohannahmen lassen die Schwere-/Ausmaß-/Dauer-/Häufigkeitsbewertung bei der Behörde. Deshalb wird aus einer lokalen Begrünungs- oder Dokumentationsmeldung keine frei erfundene finanzielle 100-Prozent-Kürzung abgeleitet. Gleichzeitig werden die vorhandenen wirksamen Vertrags-, EOP-, MFA-, Kontroll- und Exclusionsgates ausdrücklich gutgeschrieben. Mögliche Überschneidungen mit Quellen-, Allgemein- und Tabellendossiers sind gekennzeichnet; dieselbe Ursache wird nicht als mehrere unabhängige Auswirkungen ausgegeben.

## Tatsächliche App-Projektion

Die unveränderte reine Funktion `adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` ausgeführt. Ein Guard auf `CursorWrapper.execute` hätte jeden SQL-Aufruf sofort gestoppt; tatsächlich gab es **0 Datenbankaufrufe**. Recommender, Canonical-Builder und Schema-Blueprint sind mit ihren wirklichen Codehashes gebunden. Exakte Eingangs-/Ausgangswerte, Typen und Pfadvergleiche stehen im JSON. Die Vereinigung aller 20 Vorschläge dient ausschließlich dieser Strukturdiagnose und wird nicht als tatsächlicher Betrieb mit sämtlichen gleichzeitigen Optionen behauptet.

| Projektionsgruppe | Vorher vorhanden | Mit identischem Wert und Typ erhalten |
| --- | ---: | ---: |
| Vorschlagspfade | 20 | 0 |
| Effektive neue Blätter | 62 | 0 |
| Zusätzliche Canonical-Blätter | 7 | 5 |

Nutzpflanzenname und -kategorie gehen verloren. Die übrigen fünf zusätzlichen Werte bleiben erhalten. Ähnlich benannte App-Namensräume werden nicht als freigegebene Aliase zugerechnet. Das Ergebnis wurde für o6_10 tatsächlich neu gemessen und nicht aus dem Vorgängerrun übernommen.

Der exakt projizierte Ausgang wurde unverändert separat durch den Originalrun abgespielt. Er bleibt definiert, hat `contract_status="no_application"`, `contract_valid=false`, 0 ha VFH-Fläche, einen Mindestteilnahmeflächenbefund, keinen gewährten EOP und 0 € Auszahlung. Dieser eine Integrationslauf zählt getrennt von den 70 frischen Entwicklungsproben. Das belegt keinen realen Bewirtschaftungsverstoß und keine positive Endpunkt-/Serverfreigabe.

Alle nativen Läufe verwenden `/tmp/issue-51-review-opa` in Version 1.18.2 mit SHA256 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`, strikten Builtin-Fehlern, zehn Sekunden Auswertungslimit, 20 Sekunden Prozesslimit und ausgeschlossenen Netzwerk-/Zeit-/Zufalls-/Runtimebuiltins. Geladen werden die ursprünglichen Policy- und Datenverzeichnisse. Hauptquery ist `data.oepul.o6_10.decision`; statische Daten liegen unverändert unter `data.o6_10`. Regelobjektmatcher werden ausschließlich für tatsächliche Objektarrays benutzt. Niemand ändert Typen, Namespace, Quellen, Canonical-Profil, historische Policies oder produktive App. Nur diese beiden Dossierteile und eigene temporäre Prüfskripte wurden geschrieben; kein nächster Run wurde begonnen.
