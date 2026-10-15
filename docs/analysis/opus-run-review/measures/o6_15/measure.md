# o6_15 – Tierwohl – Behirtung: fachliche Quellenprüfung

Run `v2-o6_15-opus-5.5-high-20260926`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Exakt **46 historische IDs** dieses Maßnahmenteils: 30 Elternprüfung und 16 unabhängig geprüfte Hunde-/Hirten-/Block-IDs, vollständig integriert.

Alle **297 finalen Fälle** wurden nach sämtlichen tatsächlichen Eingabekorrekturen nochmals mit dem vollständigen ursprünglichen Policy-/Datenbestand ausgeführt:**297 definiert, 290 lokale Sollwerte erfüllt, 0 Laufzeitfehler, 0 undefined**. Alle sieben Abweichungen sind vorab offengelegte **bedingte** Kontraste in fünf Eingabe-/Vorbereitungs-/Projektionsfamilien. Sie sind weder sieben unabhängige Agrarfehler noch eine globale Fehlerquote. Drei weitere Befunde betreffen fehlende bedingte Abläufe, vorbereitete Evidenz oder native Konventionen.

Die aktuelle Nullable-RGVE-Ableitung ist eine tatsächliche Verbesserung gegenüber 14: Bei `rgve_category:null` und bekanntem Geburtstag/Rasse wird korrekt abgeleitet. Der frühere Null-Guardfehler wird nicht auf diesen Run übertragen. Alle bekannten Geburtstags-, Milch 45-Tage-, Kalbungs-, 7-/14-Tage-, 15. Juli- und Betreuungskontrollen passen im abgegrenzten Quellenvertrag.

## Bedingte Gegenchecks

| Kontrast | Quellengebundenes Soll unter der angegebenen Lesart | Native Beobachtung | Entscheidende Grenze |
| --- | --- | --- | --- |
| 10 Unterbrechungstage vor dem nach verspäteter Meldung neuen Beginn 16. Juni |46 anrechenbare Tage |36 Tage | Derselbe Payload wäre bei Unterbrechung nach 16. Juni korrekt 36; ein bereits auf das Fenster beschnittener Eingabewert müsste davor 0 sein |
| 30 Rindertage plus 61 Tage bekannte nicht teilnahmefähige Tierart | Almminimum nicht erfüllt, falls aktuelle zulässige Tiergruppen maßgeblich sind | erfüllt | Aktuelles 15-Merkblatt wiederholt nicht den ausdrücklichen Artensatz von Maßnahme 14; alternativ wäre stocking_days 30 unter einem allgemeinen physischen Besatzvertrag inkonsistent |
| Hundezuschlag beginnt 2026, Auswertung 2025 |0 Hundezuschlag, 243 Euro bekannter Basisbestandteil |1200 Euro Hund und 1443 Euro MAIN | Gegenfall setzt jahresübergreifende Antragsprojektion voraus; ein ausschließlich aktuell wirksamer Eingang müsste den Zukunftsantrag zurückhalten |
| Derselbe zertifizierte Hund 65+65 Tage auf zwei Almen, nur auf A beantragt |1 bezahlter Hund auf A/0 auf B; bedingter MAIN 1443 Euro |0 A/0 B; MAIN 243 Euro | Vollständiger Anwesenheitsbestand versus reine Claimliste; keine doppelte Beantragung im Szenario erfunden |
| Zwei Listenzeilen derselben Person, tatsächliche eine Person, deklariert 2 | lokale Personenabweichung | keine Diagnose; Kapazität korrekt eine Person | Unter einem strikten eindeutigen Personenlistenvertrag wäre die wiederholte Zeile upstream unzulässig |

Das Unterbrechungs-Kontextpaar besitzt ausdrücklich identische komplette Eingabe und Abfrage, aber zwei verschiedene externe tatsächliche Intervalle. Es wird als Darstellungsgrenze geprüft und nicht als gewöhnliches deterministisches Gold gezählt. Die Tages-/Almminimum-Checks sind lokal; daraus wird keine nicht abgefragte MAIN-Zahlung abgeleitet. Die zwei Hunde-Projektionen enthalten zusätzlich echte native MAIN-Abfragen, deren Zahlen ebenfalls nur unter den genannten Eingangsverträgen bewertet werden.

## Befunde

### O615-MEASURE-01: Unterbrechungszahl braucht eine eindeutige Bindung an das anrechenbare Zeitfenster

Eine tatsächliche verspätete Meldung am 30. Juni schiebt den anrechenbaren Beginn auf 16. Juni. Eine Unterbrechung von 10 Tagen vor diesem Beginn hinterlässt 46 anrechenbare Tage, dieselbe 10-Tage-Unterbrechung nach diesem Beginn 36. Die beiden Quellenkontexte haben identische Eingabe und Abfrage; native zieht in beiden Fällen 10 von 46 ab. Es fehlt die Lage der Unterbrechung. Wenn interruption_days bereits nur die nach dem neuen Beginn liegenden Tage überträgt, müsste der erste Kontext 0 statt 10 übergeben und ist sonst außerhalb dieses stärkeren vorbereiteten Vertrags. Der Paarvergleich ist ausdrücklich eine Darstellungs-/Vorbereitungsgrenze und keine deterministische Agrarfehlerquote. Keine MAIN- oder Sanktionsbehauptung aus dem lokalen Tageswert.

Einordnung: `source_conditional_interruption_window_representation`. Zugeordnet: `o6_15.calc.interruptions`, `o6_15.app.drive_up_report_deadline`.

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 3): „Die Unterbrechungszeiten zählen jedoch nicht zur Mindestbehirtungsdauer dazu.“

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 5): „Bei späterer Meldung gelten die Tiere maximal 14 Tage vor dem Meldedatum als gealpt.“

### O615-MEASURE-02: Alm-Bestoßung benötigt einen geklärten Tier- und Aggregatbereich

Der Alm-Helfer akzeptiert einen langen anerkannten Einzelaufenthalt oder einen vorbereiteten stocking_days-Wert. Er filtert im Einzelzweig nicht selbst die aktuell zulässigen Tierarten. Die bekannte Schwein-/30-Rindertage-Projektion liefert deshalb erfüllt. Im aktuellen 15-Merkblatt ist die Mindestbestoßung nicht mit dem ausdrücklichen Artensatz des 14-Merkblatts wiederholt; dieses andere Original ist hier außerdem nicht Teil des Pakets. Soll stocking_days die maßgeblichen Tage der aktuellen zulässigen Tiergruppen enthalten, kann allgemeine Schweineanwesenheit die Lücke nicht schließen. Soll das Feld dagegen jede physische Bestoßung umfassen, wäre der übergebene 30-Tage-Wert inkonsistent. Die Gegenprobe bleibt eine qualifizierte Bereichs-/Aggregatlesart; kein unbedingter 14-Fehler wird auf 15 übertragen.

Einordnung: `source_conditional_occupancy_scope_contract`. Zugeordnet: `o6_15.obl.min_stocking_per_alm`, `o6_15.def.other_roughage_gve_not_eligible`.

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 3): „Sowohl die Mindestbehirtungsdauer pro Tier als auch die Mindestbestoßungsdauer pro Alm beträgt 60 Tage.“

### O615-MEASURE-03: Ungültige Milchqualifikation ist getrennt von der sofortigen Kennzeichenentfernung

45 Tage, Altersgrenze, erste Abkalbung und Frist der Nachmeldung werden tatsächlich geprüft. Ein ungültig als Milchkuh beanspruchtes Tier erhält eine Diagnose und keinen Milchviehzuschlag. Der Zeitpunkt der tatsächlichen sofortigen Kennzeichenentfernung nach ausbleibender Abkalbung oder zu kurzer Melkdauer fehlt jedoch als eigener Workflow-Fakt. Ein Diagnoseobjekt beweist die Handlung nicht. Das Null-Amendmentdatum kann außerdem eine bereits ursprüngliche Kennzeichnung oder fehlendes Datumswissen repräsentieren; daraus wird kein unbekannter Agrarverstoß erfunden. Die native A10-Basisbehandlung bleibt von einer nicht festgelegten Sanktion getrennt.

Einordnung: `source_only_immediate_milk_flag_workflow`. Zugeordnet: `o6_15.app.milked_flag_removal`, `o6_15.app.milked_flag_deadline`, `o6_15.def.dairy`.

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 5): „Sollte die Abkalbung nicht bis einschließlich dem 1. Juli erfolgen oder das Tier nicht zumindest 45 Tage gemolken werden, ist das Kennzeichen „gemolken“ unmittelbar wieder zu entfernen.“

### O615-MEASURE-04: Vorbereitete Tier-, Register-, Aufenthalts- und Betreuungsfakten benötigen Evidenz

Die Positivfälle enthalten bekannte individuelle Tiere und tatsächliche Termine; Ausgabe und Typform beweisen keinen Rinderdatenbank-/VIS-Abruf. Auch tatsächlicher Übermittlungskanal, Vollständigkeit aller Tiere einer Kategorie, echte Almdefinition, Equidengrößenklasse, zulässige Zertifikate und vollständige Betreuung sind vorbereitete Tatsachen. Lokale Tage, total_alpine_days_all_herded_alms und stocking_days brauchen gleiche Einheit und Herkunft; fehlendes report_date_up wird nativ wie kein zu berücksichtigender Meldeverzug behandelt und ist deshalb kein positiver Meldenachweis. Fehlende Extraktion wird nicht als echte Nichtbetreuung oder nachweislich unterlassene Meldung ausgegeben. Der Übernachtungshilfswert ist nur eine Verfahrenskomponente; er ersetzt keine Prüfung einer tatsächlichen Nachtversorgung.

Einordnung: `prepared_animal_and_herding_evidence_contract`. Zugeordnet: `o6_15.calc.proportional_multiple_alms`, `o6_15.obl.all_animals_per_category`, `o6_15.app.payment_application_channel`, `o6_15.gen.animal_id_reporting_independent`, `o6_15.obl.daily_care`, `o6_15.obl.overnight_not_mandatory`, `o6_15.def.alm`.

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 3): „werden die behirteten Tiere für jede einzelne Alm anteilig bezogen auf die gesamte Alpungsdauer angerechnet.“

### O615-CHILD-01: Aktuelle Aktivierung des Hundezuschlags braucht eine Vertragsjahr-Grenze

dog_supplement_active prüft beantragt und oberen Einstieg/Frist, aber nicht, ob das Auswertungsjahr den bekannten Optionsbeginn bereits erreicht. Ein bereits früher gestellter bekannter Antrag mit Start 2026 wird im Jahr 2025 trotzdem gezahlt. Der Kontrast ist an eine jahresübergreifende Antragsprojektion gebunden; wenn ausschließlich aktuell wirksame Optionen übertragen werden, ist dieser positive Aktivierungsvertrag ausdrücklich nötig. Fehlende Daten sind gesonderte Inputs-Grenzen, keine unterstellte Agrarverletzung.

Einordnung: `source_conditional_option_term_projection`. Zugeordnet: `o6_15.opt.dog_supplement`, `o6_15.opt.dog_last_entry`.

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 1): „Optional erfolgt ein Zuschlag für Herdenschutzhunde.“

### O615-CHILD-02: Hundebestand und echte Einzelbeantragung werden nicht unterschieden

duplicate_dogs zählt jede Alm-Anwesenheitszeile. Beim ausdrücklich erlaubten 65+65-Muster mit tatsächlichem Claim nur auf A führt ein zusätzlich übertragener unbeantragter B-Anwesenheitsrecord zur Sperre auch auf A. Der Anspruch hängt deshalb am erklärten Rostervertrag: Claimliste mit nur A funktioniert; vollständiger Anwesenheitsbestand mit entered=false auf B funktioniert nicht. Keine doppelte Beantragung und keine mangelhafte Zertifizierung wird im Gegenfall erfunden.

Einordnung: `source_conditional_presence_vs_claim_roster`. Zugeordnet: `o6_15.opt.dog_one_alm`, `o6_15.opt.dog_requirements`.

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 4): „Schafe werden mit einem Herdenschutzhund auf eine Alm getrieben und 65 Tage gealpt. Danach ziehen sie mit dem Hund für weitere 65 Tage auf einen anderen Almbetrieb. Der Herdenschutzhund darf nur für eine Alm beantragt werden.“

### O615-CHILD-03: Hirtenabweichung vergleicht Zeilen statt derselben eindeutigen Personenbasis

Zwei Zeilen derselben bekannten Person werden für die Kapazität korrekt zu einer Person dedupliziert. Bei deklarierten 2 Hirten fehlt dennoch die lokale Abweichungsdiagnose, weil die Deklaration mit der Rohlistenlänge 2 verglichen wird. Dies ist ein ausdrücklich bedingter Eingabevertragsfall bei wiederholten Personenzeilen, keine behauptete doppelte Auszahlung und keine frei bestimmte Sanktionshöhe. Wenn solche Zeilen upstream verboten sind, muss diese Konsistenz garantiert oder geprüft werden.

Einordnung: `source_conditional_duplicate_person_roster`. Zugeordnet: `o6_15.app.herder_count_declared`, `o6_15.calc.max_50_rgve_per_herder`.

Originalbeleg (o6_allgemeine_teilnahmebedingungen_2026_04.pdf, PDF-Seite 17): „Flächenabweichungen und Abweichungen bei anderen Angaben (z. B. Anzahl der Tiere, Hirtinnen und Hirten“

### O615-CHILD-04: Allgemeine Milchblockpriorität und erste Alm sind offengelegte Annahmen

Originalbeispiel 95 RGVE/40 Milchvieh/2 Hirten und das 110 Tage-Umtriebsbeispiel werden direkt geprüft. Jenseits dieser Beispiele sind sequentielle Personenblockbefüllung und Milchpriorisierung A04/A05, die lexikographische Almwahl bei derselben Person A11. Für diese generalisierten Fälle wird nur die deklarierte native Konvention gemessen; es wird keine eindeutige amtliche Verteilungsregel aus dem Policycode zurückbegründet.

Einordnung: `native_disclosed_block_and_assignment_conventions`. Zugeordnet: `o6_15.app.one_alm_per_herder`, `o6_15.calc.higher_rate_blocks`, `o6_15.calc.dairy_block_allocation`.

Originalbeleg (o6_15_tierwohl-behirtung_2026_04.pdf, PDF-Seite 4): „Die Behirtung mehrerer Almen durch ein und dieselbe Person ist nicht zulässig, d.h. die Prämie kann für eine Person nur einmal beantragt werden.“

## Erhaltenes und frisch geprüftes Verhalten

- Jährliche Mindestteilnahme 3 RGVE wird betriebsbezogen und unabhängig vom 50-RGVE-Personendeckel geprüft. Das Originalbeispiel 4 Jungtiere=2,40 RGVE scheitert. Die fünf aktuellen Arten sind enger als alle allgemeinen Anhang-A-Wildhuftiere; sechs Behirtungskategorien bleiben getrennt.
- Alle Tiere einer tatsächlich beantragten Kategorie müssen behirtet werden; eine nicht beantragte andere Kategorie darf unbehirtet bleiben. Bekannte Art-/Kategorienkonflikte werden diagnostiziert. Vollständiger Bestand und tatsächliche individuelle Meldungen sind vorbereitet.
- Auftriebstag zählt, Abtriebstag nicht.59/60/61 Tage, Unterbrechungen, vorbereitete aufeinanderfolgende 30+30-Tage-Union und anteilige 30/80-, 66/110-, 44/110-Alpung wurden geprüft. Aggregierte fremde Almtage sind ausdrücklich bekannte anerkannte Tage.
- Tägliche ordentliche Versorgung, nötige Nachtversorgung, wesentlicher Tagesanteil, Wasser, Tierpflege, Behandlung, Sicherung und standortgerechte Beweidung haben tatsächliche Verbraucher. Reine Nachschau reicht nicht. Geeignete Unterkunft ist Pflicht, tatsächliche Nächtigung nicht allgemein verlangt.
- Milchvieh: 45 Melktage; Kühe am 1. Juli mindestens 2 Jahre und einmal abgekalbt; Schaf/Ziege mindestens 1 Jahr. Geburtstagsgrenzen sowie 44/45/46 Melktage und fehlende Abkalbung sind frisch geprüft. Drei eindeutig qualifizierte einzelne Kühe ergeben den nominalen 696,60-Euro-Bestandteil.
- Auftrieb spätestens 15. Juli bleibt von 17. Juli-Listenfristen 2023/2028 getrennt. Bekannter späterer Weitertrieb verwendet unter A08 den ersten Auftrieb des Originalmusters. Auf-/Abtrieb und Nachreichung des Gemolken-Kennzeichens haben getrennte 7-/14-Tage-Fristen; Schaf/Ziege zusätzlich 15. Juli.
- Rinder-/Schaf-/Ziegen-Hauptfixtures verwenden getrennte Tierobjekte mit `count:1`. Zulässige Stückgruppen sind auf Equiden/Neuweltkamele begrenzt. Pflichtohrmarken und passendes/abweichendes vorab bekanntes Abtriebsdatum werden getrennt geprüft.
- Alle acht tatsächlichen Hundepflichten, mindestens 60 Tage auf einer Alm, gesamte relevante Alpungsperiode, Österreichzentrum-anerkanntes am Betrieb vorhandenes Zertifikat, Haftpflicht, höchstens 5 Hunde und tatsächliche Einzelbeantragung sind positiv oder negativ abgegrenzt. Synthetische Hund-IDs behaupten keine echte Dokumentenprüfung.
- 75/25 Euro 2023,81/27 Euro ab 2024, Milchzuschläge 140/100 bzw 151,2/108 sowie Hund 700/756/1200 werden tatsächlich verbraucht. Eine Person deckelt 50 RGVE, erste 20 pro 50er-Block; außerhalb der belegten Beispiele sind Verallgemeinerungen A04/A05.

## Originalbeispiele und Quellenkonflikt

Beide vollständigen Originalrechenbeispiele sind als einzelne Tierdatensätze geprüft. Beispiel 1 mit 95 RGVE/40 Milchvieh/2 Hirten ergibt 9.909 Euro. Im Beispiel 2 druckt das aktuelle Merkblatt für `20 × 81 + 30 × 27` den Wert 2.295 Euro. Die Multiplikation ergibt 2.430 Euro und die Gesamtsumme 12.669,60 Euro statt gedruckt 12.534,60 Euro. Native rechnet diese reine Arithmetik richtig; das Original bleibt unverändert und der Quellenrechenfehler bleibt sichtbar.

Dies beweist keine uneingeschränkte allgemeine Milchblockpriorität. Sequentielle Personenblockbefüllung und Milchpriorisierung außerhalb der Beispiele bleiben A04/A05; die lexikographische erste Alm bei mehrfach genannter Person ist A11. Es wird keine amtliche Regel aus einem erfolgreichen Policy-Selbsttest zurückbegründet. Die tatsächlichen Quellenbeispiele und die offen deklarierten Konventionskontrollen sind getrennt.

## Vollständige Regelzuordnung

| Historische ID | Ergebnis | Prüfung |
| --- | --- | --- |
| `o6_15.elig.min_rgve` | implemented | Genau 3 behirtete RGVE bestehen in jedem geprüften Förderjahr;2 RGVE und das originale 4 Jungtiere-Beispiel mit 2,40 RGVE nicht. Zwei Almen können die betriebliche Schwelle gemeinsam erfüllen. Keine Deckelung auf 50 RGVE je Person für diese Zugangsschwelle. |
| `o6_15.app.species_eligible` | implemented | Alle fünf aktuellen Gruppen sind mit bekannten korrekten Alters-/Kategoriefakten positiv geprüft. Tatsächlich bekanntes Wild/Schwein unter other bleibt ausgeschlossen; keine unbekannte echte Tierart wird erfunden. |
| `o6_15.def.other_roughage_gve_not_eligible` | implemented | Das vollständige Anhang-A-Wildhuftierangebot erweitert die aktuelle Fünf-Gruppen-Liste nicht. Bekannte nicht teilnahmefähige Tiere erhalten keine herded-RGVE; die separate Alm-Bestoßungslesart bleibt ausdrücklich qualifiziert. |
| `o6_15.cat.herding_categories` | implemented | Sechs tatsächliche Behirtungskategorien und die fünf Tiergruppen werden getrennt verarbeitet. Milchkuh und sonstiges Rind bleiben verschiedene Kategorien; keine jährliche Pflicht zur Beantragung jeder Tiergruppe wird erfunden. |
| `o6_15.cat.category_species_match` | implemented | Bekannt falsch als Ziegenkategorie beantragtes Rind wird als Art-/Kategorienkonflikt erkannt. Richtige Zuordnungen aller fünf Gruppen bestehen. |
| `o6_15.obl.all_animals_per_category` | implemented | Bekannt unbehirtetes Tier einer beantragten Kategorie erzeugt die Pflichtdiagnose; ein tatsächlich unbehirtetes Tier einer nicht beantragten anderen Kategorie nicht. Vollständiger Tierbestand ist vorbereitet, keine freie feste Gesamtkürzung. |
| `o6_15.def.alm` | partial | Positive vorbereitete Definition ist vorhanden. Fehlender Kataster-/Almgebietsstatus, Heimbewirtschaftung, fehlende Grenze oder 0 Almfläche schließen die lokale Almdefinition aus. Reale Vegetation/Lage werden nicht aus einem booleschen Flag bewiesen. |
| `o6_15.def.dairy` | implemented | 44/45/46 Melktage, zwei Jahre/erste Abkalbung bei Kühen und ein Jahr bei Schaf/Ziege am 1. Juli sind frisch geprüft. Bekannte drei qualifizierte Kühe ergeben den nominalen 696,60-Euro-Bestandteil; kein echter Register-/Bewilligungsbeleg behauptet. |
| `o6_15.def.herd_protection_dog` | partial | Alle tatsächlichen Definitionsflags haben Verbraucher. Ausbildung und Österreichzentrum-Anerkennung des am Betrieb vorhandenen Zertifikats werden upstream positiv geprüft, nicht vom booleschen Vorhandenseinsflag bewiesen. |
| `o6_15.obl.min_herding_per_animal` | implemented | 59/60/61 anerkannte Tage sowie Unterbrechungen sind geprüft. Ein positiver Mehralmen-Gesamtwert ist nur bei tatsächlich bekannter Herkunft vorbereitet; er wird nicht aus fehlenden Tagen erfunden. |
| `o6_15.obl.min_stocking_per_alm` | partial | Bekannte aufeinanderfolgende 30+30 Tage bestehen als vorbereitete 60-Tage-Union; zwei gleichzeitig 30 Tage anwesende Tiere nicht. A13 verlangt ein korrektes Aggregat; die bekannte andere Tierart ist ausdrücklich bedingte Bereichslesart. |
| `o6_15.calc.day_counting` | implemented | Auftriebstag zählt, Abtriebstag nicht; konkrete 59/60/61-Tage-Grenzen liefern die Quellenwerte. |
| `o6_15.calc.interruptions` | partial | Ohne Meldefensterkonflikt werden bekannte 10 Unterbrechungstage korrekt abgezogen. Bei verspäteter Meldung braucht das Feld einen klaren Fenstervertrag;46/36-Kontextpaar ist eine Darstellungsgrenze, keine deterministische Fehlerquote. |
| `o6_15.calc.proportional_multiple_alms` | partial | Bekannte 30/80-, 66/110- und 44/110-Anteile werden korrekt gebildet. Andere behirtete Almen können außerhalb des aktuellen Betreiberbestands liegen; deren anerkannte Tage müssen positiv dokumentiert sein. A07 bleibt Eingabevertrag. |
| `o6_15.obl.daily_care` | implemented | Alle acht tatsächlich bekannten Betreuungs-/Versorgungsmerkmale und reine Nachschau werden geprüft. Die Negativfälle setzen echte Nichterfüllung voraus, keine bloß unbekannte Extraktion. Die Quelle liefert hier keinen frei wählbaren 100%-Sanktionssatz. |
| `o6_15.obl.site_adapted_grazing` | implemented | Bekannt fehlende standortgerechte Weidemaßnahmen lassen die Betreuungsprüfung scheitern; bekannte vollständige Versorgung und Beweidung bestehen. Umtrieb/Zäunung sind vorbereitete reale Maßnahmen. |
| `o6_15.obl.accommodation` | implemented | Tatsächlich vorhandene geeignete Unterkunft besteht, positiv bekannte Abwesenheit scheitert. Der Befund ist von der nicht generell verlangten tatsächlichen Nächtigung getrennt. |
| `o6_15.obl.overnight_not_mandatory` | implemented | Bei bekannter erfüllter täglicher Versorgung verlangt der lokale Hinweis keine tatsächliche Nächtigung. Er hebt geeignete Unterkunft und nötige Nachtversorgung nicht auf; keine unbekannte Aufenthaltsnacht wird verifiziert. |
| `o6_15.opt.dog_supplement` | partial | Optionaler Zahlungszweig ist vorhanden; tatsächliche Einstiegsfrist und aktuelles Vertragsjahr müssen getrennt beachtet werden. |
| `o6_15.opt.dog_requirements` | implemented | Alle acht Pflichtflags, mindestens 60 Tage auf einer Alm und anderer Claim werden tatsächlich geprüft. Ganze relevante Alpungsperiode und Versicherungsumfang sind positiv vorbereitete Fakten, keine fiktiven Realbelege. |
| `o6_15.opt.dog_one_alm` | partial | Mehrfachnennungen im Hundebestand sperren den Hund auf allen betroffenen Almen. Ob der Bestand ausschließlich beantragte Hunde oder auch tatsächlich anwesende nicht beantragte Hunde enthält, ist ein notwendiger Claim-/Anwesenheitsvertrag. |
| `o6_15.opt.dog_max_per_alm` | implemented | Höchstens fünf unterschiedliche zuschlagsfähige Hunde werden je Alm gezahlt; weitere Hunde erhöhen den Betrag nicht. |
| `o6_15.opt.dog_last_entry` | partial | Oberes Einstiegsjahr und vorhandenes verspätetes Antragsdatum werden geprüft. Aktuelle zeitliche Aktivierung und fehlender Fristnachweis sind getrennte Eingabevertragsgrenzen. |
| `o6_15.app.herder_count` | implemented | Tatsächlich unterschiedliche gültige Personen bestimmen 50 RGVE-Kapazität. Liste und rechtzeitige Angaben sind positiv vorbereitete tatsächliche Fakten; ein Personenstring ist kein Registerbeweis. |
| `o6_15.app.herder_count_declared` | partial | Native vergleicht deklarierte Zahl mit Rohlistenlänge; die tatsächliche Kapazität zählt dagegen eindeutige Personen. Eine bekannte Wiederholung derselben Person muss als Daten-/Einheitenabweichung gesondert beurteilt werden, ohne freie Sanktionshöhe. |
| `o6_15.app.one_alm_per_herder` | partial | Bekannte andere Alm und Mehrfachzuordnung werden erfasst. Auswahl der lexikographisch ersten Alm bei Mehrfachnennung ist offengelegte A11-Konvention und keine quellbestimmte Bewilligungsentscheidung. |
| `o6_15.app.payment_application_deadline` | implemented | 15. Juli und 17. Juli 2023/2028 sind am Grenztag und Folgetag geprüft. Die Meldediagnose ist getrennt von nicht tabellierten finanziellen Folgen. |
| `o6_15.app.payment_application_channel` | partial | Alle fünf Quellenkanäle werden korrekt zugeordnet. Der tatsächlich genutzte technische Übermittlungsweg samt Beleg ist kein eigener Eingabefakt. |
| `o6_15.app.drive_up_by_july_15` | implemented | Tatsächlicher erster Auftrieb 15. Juli besteht, 16. Juli nicht, auch 2023/2028. Der bekannte spätere Weitertrieb des Originalmusters verwendet unter A08 die frühere erste Alpung. |
| `o6_15.app.drive_up_report_deadline` | partial | 14 Tage bei Rindern und 7 Tage sonst sind an Grenze/Folgetag samt zeitlicher Anrechnung geprüft. Fehlendes Datumswissen wird nicht als echter verspäteter Bericht behauptet. |
| `o6_15.app.drive_down_report_deadline` | implemented | Abtriebsgrenzen 14/7 Tage und die passende vorab bekannte Equiden-/Neuweltkamel-Angabe funktionieren. Ein Nullwert im Negativfall steht ausdrücklich für bekannte tatsächliche Nichtkorrektur, keine unbekannte Extraktion. |
| `o6_15.app.milked_flag_deadline` | implemented | Tatsächliche Nachmeldung innerhalb 14/7 Tagen besteht, am Folgetag nicht. Schaf/Ziege sind zusätzlich getrennt am 15./16. Juli geprüft. |
| `o6_15.app.milked_flag_removal` | partial | Ungültige aktuelle Milchqualifikation schließt den Milchzuschlag aus und wird bei beanspruchten Milchkühen diagnostiziert. Unmittelbare tatsächliche Entfernung und ihr Zeitpunkt sind nicht modelliert. |
| `o6_15.app.sheep_goat_ear_tag` | implemented | Tatsächlich bekannte vorhandene oder fehlende Einzeltierohrmarke wird unterschieden, auch mit explizitem Nullwert. Damit wird kein unbekannter Identitätsextrakt in echte Nichtmeldung umgedeutet. |
| `o6_15.app.equids_in_pieces` | implemented | Explizit zulässige Stückgruppen werden für Equiden/Neuweltkamele gezählt. Rinder-/Schaf-/Ziegen-Hauptfixtures bleiben einzelne echte projizierte Identitäten mit count 1. |
| `o6_15.gen.animal_id_reporting_independent` | partial | Der richtige unabhängige Kennzeichnungshinweis erscheint. Er ist keine Prüfung einer tatsächlichen Rinderdatenbank-/VIS-Erfüllung. |
| `o6_15.calc.rgve_key` | implemented | Alle 18 aktuellen Faktorgruppen und zusätzliche Geburtstagsgrenzen sind geprüft. Anders als in 14 ist rgve_category: null ausdrücklich vom direkt angegebenen Wert getrennt und löst bei bekanntem Geburtstag die korrekte Ableitung aus. |
| `o6_15.calc.age_reference_july_1` | implemented | Bekannte Halbjahres-, Ein-/Zwei-/Dreijahresgrenzen werden zum 1. Juli beurteilt; kein unbekanntes Alter oder späterer Auszahlungstag ersetzt den Quellenstichtag. |
| `o6_15.def.dwarf_cattle` | implemented | Alle vier Originalrassen werden aus positiv bekanntem Rassenamen abgeleitet, wenn das optionale generische Flag fehlt; Standard-Fleckvieh bleibt beim Standardfaktor. Keine widersprüchliche false-Klassifikation bleibt im finalen Positivfall. |
| `o6_15.calc.rate_herded_first_20` | implemented | 75 Euro 2023 und 81 Euro ab 2024 sind tatsächliche Verbraucher. Für mehrere Hirten bleibt die konkrete Blockbefüllung außerhalb des expliziten Beispiels A05. |
| `o6_15.calc.rate_herded_from_21` | implemented | 25 Euro 2023 und 27 Euro ab 2024 sind tatsächliche Verbraucher oberhalb der ersten 20 RGVE des belegten Blocks. |
| `o6_15.calc.rate_dairy_supplement` | implemented | 140/100 Euro 2023 und 151,2/108 Euro ab 2024 werden auf tatsächlich als Milchvieh qualifizierte RGVE angewandt. Zusätzliche Milchblockpriorisierung ist außerhalb der Originalbeispiele A04/A05. |
| `o6_15.calc.rate_dog` | implemented | 700 Euro 2023,756 Euro 2024 und 1200 Euro ab 2025 werden je tatsächlich zuschlagsfähigem Hund angewandt. |
| `o6_15.calc.max_50_rgve_per_herder` | implemented | Die tatsächliche eindeutige gültige Hirtenzahl deckelt je Alm auf 50 RGVE pro Person. Die Begrenzung gilt getrennt von der betriebsweiten Mindestteilnahme. |
| `o6_15.calc.higher_rate_blocks` | partial | Native berechnet 20 je 50er-Block;95 RGVE mit 2 Hirten entspricht dem Originalbeispiel. Andere Mehrpersonen-Aufteilungen bleiben als A05 und komponentenbezogene Konvention kenntlich. |
| `o6_15.calc.dairy_block_allocation` | partial | Die beiden Originalbeispiele werden separat geprüft. Verallgemeinerte Milchviehpriorität und sequentielle Befüllung sind A04/A05 und nicht als eindeutige allgemeine Rechtsregel bewiesen. |

Alle 46 zugeteilten historischen IDs sind genau einmal zugeordnet. Jede Zeile hat aktuelle Originalbelege, tatsächliche Codebindungen und zugeordnete frische Fälle; zusätzliche Quellen-/Workflowgrenzen erhöhen die historische ID-Zahl nicht.

## Persönliche Quellenlektüre und Eingabevertrag

Persönlich vollständig gelesen: neues Merkblatt mit allen 10 Seiten einschließlich beider Beispiele, aller Tabellen, Aktualisierungen 9–10 und Impressum; alle 6 nativen Module mit 1175 Zeilen; sämtliche 20 Rohannahmen samt offenen Notizen; alle 7 vollständigen tatsächlichen Profilvorschläge und alle 5 aktuellen Datenobjekte. Sieben gemeinsame Originale werden nach exakt gleichen Hashes aus früheren vollständigen Quellenprüfungen wiederverwendet. Aktuelle Eltern-Klauselrereads: SRL 72/73,AnhangA 3,ATB 13. Der unabhängige Child hat ebenfalls alle neuen Gesamtlektüren erledigt und zusätzlich SRL 4/24/27/72/73,AnhangA 3,ATB 12/17 frisch gelesen. Eigen- und delegierte Lesespuren stehen getrennt im JSON.

| Aktuelles Original | Umfang | SHA-256 |
| --- | --- | --- |
| 20241011_srl_oepul_2023.pdf | 94 | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| 20241011_srl_oepul_2023_anhaenge.pdf | 103 | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| 2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html | HTML-Artikel | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html | HTML-Artikel | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| 2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html | HTML-Artikel | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| 2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html | HTML-Artikel | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| o6_15_tierwohl-behirtung_2026_04.pdf | 10 | `b3dc90508e4a9e859aef76a2a6794a7237ad3c89991486339d3c926bf8161189` |
| o6_allgemeine_teilnahmebedingungen_2026_04.pdf | 21 | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle acht Originale wurden nach tatsächlicher Bytezahl und Hash geprüft. Weder das 14-Maßnahmenmerkblatt noch GSP-AV/NAPV-PDF liegt im aktuellen Paket. Der ausdrücklich aufgezählte 14-Artenbesatzsatz oder eine erst anderswo bereitgestellte Rechtsfassung wird nicht als aktuelles 15-Gold importiert. Aktuelle SRL-Verweise auf diese Rechtsgrundlagen ersetzen deren fehlenden Text nicht. Studien-, GM-, private Fallurteile und native Selbsttests liefern keine Sollwerte.

Vorbereitete physische Klassifikationen und echte Register-/Meldungs-/Zertifikatsfakten sind ausdrücklich bekannte hypothetische Tatsachen; die Programme beweisen sie nicht durch IDs oder Flags. Unbekanntes, fehlende Extraktion und tatsächliche Nichterfüllung bleiben getrennt. Der aktuelle Deskriptorbestand enthält keine mehrdeutigen Zahlenenums. Vorhandene Typen belegen trotzdem weder Vollständigkeit noch tatsächliche Wahrheit.

Geldbeträge sind nominale Komponenten vor nicht angegebenen behördlichen Sanktionen. Der native volle Alm-Ausschluss bei bestimmten Prüfungen und die A10-Basisbehandlung einer nicht als Milchvieh qualifizierten Kuh werden nicht durch eine frei erfundene 100%-Sanktionsnorm gerechtfertigt. Auch ein Hinweis zur höheren Gewalt ist keine Anerkennung. Root/General prüfen Vertrags-/Zugang-/Sanktionsfolgen und Modulation separat; daraus wird kein weiterer unabhängiger Domänengeldfehler gezählt.

## Konstruktion, vollständiger Replay und Qualität

Der vollständige frühe Elternentwurf mit 30 IDs/170 Inputs, Abfragen und Quellen-Sollwerten wurde vor dem ersten OPA-Lauf gespeichert; der unabhängige 16-ID-/125-Fälle-Entwurf ebenfalls. Anschließend wurde die konkrete zeitliche Darstellungsgrenze als zwei zusätzliche, vor ihrer ersten Ausführung gespeicherte Kontextfälle ergänzt. Nach Integration gab es genau 297 Fälle.

**Acht Fälle hatten echte Eingabekonstruktionskorrekturen:** Ein nur auf Nachschau beschränkter Fall musste zusätzlich tatsächlich fehlende tägliche/wesentliche Betreuung tragen; drei ausdrücklich ungültige Milchkuh-Claimfälle mussten die Milchkuhkategorie auch in der jährlichen Kategorienliste enthalten. Vier weitere bekannte Zwergrassenfixtures hatten versehentlich `is_dwarf_breed:false`; das optionale Flag wurde ausgelassen, damit die bekannte Originalrasse ohne widersprüchlichen zweiten Sachverhalt abgeleitet wird. Alte vollständige JSONs, Hashes und Vorher/Nachher-Inputs sind erhalten. **Abfragen und fachliche Sollwerte wurden nicht angepasst. Alle 297 finalen Fälle wurden nach sämtlichen dieser Eingabeänderungen nochmals vollständig ausgeführt.** Die tatsächlichen Korrekturen werden nicht als bloße Metadatenänderung ausgegeben.

Erst nach diesem vollständigen letzten Replay wurden redaktionelle Bewertungen, engere Codebindungen, zusätzliche wörtliche Belegpräzision und Qualitätsangaben ergänzt. Diese spätere Endredaktion hat keine finalen Inputs, Abfragen, Sollwerte oder tatsächlichen OPA-Ausgaben verändert; ein gemeinsamer Digest bindet diese Felder.

- Runtime: exakt gepinnte OPA 1.18.2, vollständige originale Policy-/Datenverzeichnisse, `--strict-builtin-errors`, 10 Sekunden OPA-/20 Sekunden Prozesslimit. Kein Adapter, keine Typnormalisierung.
- 6.701 explizite Enumvorkommen und 95.208 vorhandene Typwerte: 0 Enum-/Typabweichungen, 0 unbekannte Pfade, 0 ununterstützte Deskriptoren. Notwendige Elternobjekte sind nur aus tatsächlich deklarierten Kindpfaden abgeleitet; keine zusätzliche Blattannahme.
- 1.369 wörtliche Belegvorkommen mit 108 verschiedenen Bindungen: 0 Fehlbelege, 0 ungeklärte Quellen, 0 Kompakt-Fallbacks. Nur Leerraum/Soft-Hyphen-Abgleich; keine NFKC-Umformung.
- 162 Codebindungs-Vorkommen und 14 aktuelle Seitenbindungen haben gültige Grenzen. Die tatsächlichen Funktionen und Verbraucher wurden zusätzlich semantisch gelesen; Grenzen allein gelten nicht als Beweis.

JSON-Endbindung: `e68cdcb041cbf329e6a249fcd026d0478f71f4c3bad5bafbd7170dda13ad4946`.
Finale native Felder aller 297 Fälle: `521a1a5b3bcf7fc6265eb5aa6d464f4b37021d8d2729a305ddfc3363e4bc3348`.

Im Repository wurden ausschließlich `measure.json` und `measure.md` dieses aktuellen Runs verfasst. Quellen, historische Artefakte, Policies, Daten, Canonical und App sind unverändert. Der Teil ist für unabhängige Root-/QA-Sammlung eingefroren; keine weitere Maßnahme begonnen.
