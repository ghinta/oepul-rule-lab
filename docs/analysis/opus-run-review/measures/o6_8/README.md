# Einzelprüfung 10/26: Erosionsschutz Acker

Der unveränderte Run bleibt für eine native App-Aufnahme blockiert.
Gegenstand ist ausschließlich der historische
Run `v2-o6_8-opus-5.5-high-20261001` am Kandidatencommit
`e009eed4a83ff076b26eba33ac433ac2b0642621`. Befunde bleiben im
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) und dem
bestehenden gemeinsamen Branch. Historische Regeln werden nicht repariert;
der spätere Prüfabschluss erteilt keine Expertenfreigabe.

Alle zwölf Seiten des neuen Merkblatts, sämtliche zehn Produktionsmodule und
die 24 ursprünglichen Annahmen wurden vollständig gelesen. Die sieben
gemeinsamen Quellen sind mit identischem Hash an die vorherigen vollständigen
Lektüren gebunden; aktuelle Klauseln und Verbraucher wurden erneut abgeglichen.
SRL-Seiten 24–25 und 59–60 sowie ATB-Seite 9 wurden für die Kernkontrollen erneut gelesen.
Die GSP-AV ist in diesem achtteiligen historischen Quellpaket nicht enthalten.
Zusätzliche Rechtsstände anderer Pakete werden nicht als damals bereitgestellte
Quellen angerechnet.

Die Teilberichte [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md) und [inputs.md](inputs.md) besitzen jeweils ein JSON-Ledger.
[core.json](core.json) ergänzt drei historische IDs mit vier vollständigen
positiven beziehungsweise abgegrenzten Schwellenkontrollen.
Die Sammlung deckt alle 114 historischen Regel-IDs mit 114 Bewertungen,
alle 23 Profilvorschläge und alle 30 Tabellencontainer ab. Die fünf Teile
dokumentieren 30 zum Teil überlappende Befundgruppen; daraus wird keine Zahl
unabhängiger Modellfehler abgeleitet.

| Bereich | Quellenvergleich und Abgrenzung |
|---|---|
| Gesamtberechnung | Ein bekannter gültiger Betrieb mit MS+US auf einem Hektar Mais, 0,5 Hektar Kartoffelanhäufungen, 0,4 Hektar begrüntem Abflussweg auf 0,1 Hektar tatsächlichem GIS-Pfad und einem Hektar Soja im Strip-Till-Verfahren ergibt 556,20 Euro einschließlich 16,20 Euro Bio-Untersaatzuschlag. Ohne Bio-Teilnahme sind es 540 Euro. Das sind Komponenten vor gesonderter Behördenbewertung. |
| Flächenzählung | Die Hauptsummierung zählt die gemeinsame MS+US-Fläche einmal und ergibt 2,9 Hektar Teilnahmefläche. Ein zusätzlicher Hektar unbeantragte Dauerwiese erhält keine Komponente. Die 0,09-/0,10-Hektar-Kontrollen isolieren die Teilnahmeschwelle; dem negativen Schwellenfall wird kein erfundener Vollkürzungsbetrag zugewiesen. |
| BAW und Quellenhierarchie | Der bekannte 0,4-/0,1-Hektar-Fall liegt genau auf der Viertelgrenze und entscheidet den offengelegten Konflikt zwischen Mindestanteil und maximaler Prämienfläche nicht. Die tatsächliche GIS-Pfadüberschneidung wird ausdrücklich als belegt vorausgesetzt. Ein Treffer in der KG-Liste ersetzt diesen Sachverhalt nicht. Auf der BAW-Fläche wird keine zusätzliche flächenbezogene Bio-Prämie unterstellt. |
| Beobachtete Verbesserungen | Der aktuelle Vertragszeitraum wird tatsächlich auf Beginn bis Ende geprüft. Die regionale Dürre-Ernteausnahme verlangt zusätzlich den passenden Erntezeitraum. Kulturlisten besitzen aktive Verbraucher, einschließlich Kartoffeln nur mit MS, Freigabe erweiterter US-Kulturen ab 2025 und BAW-Kleegras nur als Altbestand. Unterschiede zu früheren Runs bleiben erhalten. |
| Aktueller Vertragsstatus | Bekannte wirksame Ausstiege und ein fehlender aktueller Zahlungsantrag besitzen separate Helfer, erreichen aber das tatsächliche Vertrags-/Prämiengate nicht vollständig. Kontrollverweigerung und weitere allgemeine Pflichten haben keinen ausführbaren vorgeschlagenen Eingabepfad; dafür werden keine fingierten nativen Felder als Rechtsorakel verwendet. |
| Winterackerbohnen | Die tatsächliche Herbstsaat wird zusätzlich mit der allgemeinen Acht-Wochen-Frist verglichen. Das neuere Merkblatt verlangt für die Frühjahr-Untersaat dagegen einen mit Sommerackerbohnen vergleichbaren Zeitraum, spätestens 30. April. Die Kontrolle isoliert diese zusätzliche Diagnose; keine pauschale Nullzahlung wird daraus abgeleitet. |
| Helferreichweite | Ein alternatives Flächensummen-Hilfssymbol zählt dieselbe Fläche mehrfach bei einem Doppelverfahren unter der offengelegten Annahme zu nicht ausdrücklich geregelten Kombinationen. Die tatsächlich ausgegebene primäre Teilnahmefläche dedupliziert korrekt. Dieser Helferbefund ist kein falscher positiver Gesamtbetrag. Ebenso sind Wirkungen auf UBB/BIO getrennte Helfer, keine vollständige Prüfung jener Maßnahmen. |
| Finanzielle Stufen | Die eigene Eurokomponente wird moduliert; das Cap-Flag verwendet jedoch den Betrag vor Modulation. Für Heim-/Almbetriebe ist die Bedeutung des Flächeneingangs entscheidend: Nur wenn die 300 Hektar ausdrücklich 100 Hektar Heimfläche und 200 separat behandelte Almhektar enthalten, prüft der Gegenfall den falschen Nenner. Ein bereits auf Heimfläche begrenzter Eingang ist kein solcher Gegenfall. Sanktionswerte und Reihenfolge sind nicht vollständig als Nettoabrechnung verbunden. |
| Kopplung von Befund und Zugang | Jeder zugeordnete lokale Auflagenbefund kann die Codekonformität, daraufhin die gezählte Teilnahmefläche und gegebenenfalls den Betriebszugang ausschließen. Dieser gemeinsame Kontrollfluss unterscheidet nicht ausdrücklich zwischen fehlendem teilnahmefähigem Verfahren und einer bewertungsbedürftigen inhaltlichen Auflage. Das ist ein eigener Abbildungsbefund; weder wird jeder Nullbetrag für rechtswidrig erklärt noch ein beliebiger Gegenbetrag erfunden. |
| Grenzen der Abbildung | BAW-Einsatzangaben besitzen keine datierte Abgrenzung von Umbruch oder Umdeklaration. Der gespeicherte, ungenutzte Force-majeure-Stichtag benennt den engeren Quellenbereich für dauerhafte Umstände zu weit. Offene Quellenlesarten, Benennung und nicht ausgeführte Verfahren bleiben von tatsächlich beobachteten Fehlentscheidungen getrennt. |

Alle acht Datendateien und alle 30 Inventarcontainer mit 2.407 direkten
Einträgen wurden vollständig geprüft. Die unabhängige Rückextraktion der
Anhang-F-Seiten 12–37 ergibt genau dieselben 1.952 eindeutigen
Katastralgemeindezeilen mit allen Namen, Nummern und Seitenwerten. Die
Kombinationstabelle speichert 134 positive Zellen; fehlende Zellen werden
entsprechend ihrer tatsächlichen Bedeutung behandelt. Eine Probe über fremde
Förderung muss die tatsächliche Wahl dieser Förderung ausdrücklich benennen.

## Entwicklungsfälle und Eingabekompatibilität

313 eigenständig abgeleitete Entwicklungsfälle ergeben 343 Prüfungen:
281 sind erfüllt, 62 nicht erfüllt. 300 native Ergebnisse sind definiert;
13 enden in einem Laufzeitfehler. Zehn davon sind explizit erlaubte Nullwerte
auf neun neuen Blättern, fünf in der Hauptentscheidung und fünf in separaten
Helferaufrufen. Ein weiterer Hauptpfadfehler folgt einem fehlenden Wert mit
nativem Null-Default. Zwei Fehler liegen ausdrücklich außerhalb des Schemas.
Es gibt keine undefinierte Ausgabe in dieser gezielten Fallmenge.

| Teil | Fälle | Prüfungen | Erfüllt | Nicht erfüllt |
|---|---:|---:|---:|---:|
| Kernkontrollen | 4 | 24 | 24 | 0 |
| Allgemeine Regeln | 91 | 91 | 84 | 7 |
| Maßnahme | 131 | 131 | 128 | 3 |
| Tabellen | 22 | 22 | 22 | 0 |
| Eingaben | 65 | 75 | 23 | 52 |

Nicht erfüllte Sollwerte sind keine pauschale Fehler- oder Genauigkeitsquote.
Positive Nachweiswünsche, technische Diagnosefähigkeit, tatsächlich bekannte
Quellenkomponenten, bedingte Schnittstellen und offene Lesarten behalten ihre
jeweilige Kennzeichnung. Die 22 Tabellenfälle prüfen teils ganze Arrays und
geschlossene Listen; deren Zeilen werden nicht als zusätzliche unabhängige
Fälle gezählt.

23 Profilvorschläge umfassen 22 Ergänzungen und eine Änderung am bestehenden
`operations.tillage_type`. Das hinzugefügte `strip_till` allein wählt den nativen
DS-Untertyp nicht aus; dieser liest ein eigenes neues Methodenfeld. Das
tatsächliche Vorhandensein eines Pfades und die Erhaltung seines Wertes bleiben
getrennte Fragen.

Die 22 Ergänzungen umfassen 93 neue Blätter; zusammen mit dem geänderten
Enum sind es 94. 93 werden gelesen, ein Vorjahresflächenwert bleibt ungelesen.
Sechs gelesene Blätter bleiben auf separate Helfer beschränkt, ein weiteres
wirkt nur auf das Cap-Diagnoseflag. 131 kontextuelle Lesestellen und vier
generische Feldhelfer mit 47 konkreten Schlüsseln wurden verfolgt; zusätzlich
werden zwölf bestehende Canonical-Pfade gelesen. Es bleiben keine ungeregelten
weiteren Eingabepfade.

Die tatsächlich ausgeführte App-Projektion mit gesperrtem SQL-Zugriff erhält
keinen der 22 neuen Vorschlagspfade und auch den geprüften geänderten
Bodenbearbeitungspfad nicht. Neun von zwölf zusätzlich gelesenen Canonical-
Pfaden bleiben erhalten. Die native Folgeauswertung ist definiert: Vertrag und
Zugang sind false, die eigene Komponente ist leer beziehungsweise null Euro.
Das belegt fehlende positive Eingabeanbindung, keinen tatsächlich
landwirtschaftlich pflichtwidrigen Betrieb. Eine andere produktive Regeladaption
wird damit nicht bewertet; der zusätzliche Projektionslauf ist kein weiterer
unabhängiger Quellenfall.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_8 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Der native Regelpfad ist `data.oepul.o6_8.decision`, die Originaldaten liegen
unter `data.o6_8`. Beide ursprünglichen Verzeichnisse werden unverändert
geladen. Die unabhängige Gegenprüfung steht in [quality.md](quality.md).
Numerische Laufzeitkontrollen, zulässige Nullwerte, fehlende Nachweise,
schemawidriger Stress, offene Quellenauslegung und endgültige finanzielle
Rechtsfolgen bleiben getrennt. Studienreferenzen, Expertenantworten und Sollwerte
manueller Adaptationstests sind keine Orakel. Originale, Canonical-Profile und
produktive App bleiben unverändert. Gemeinsame Lösungen werden nach allen 26
Einzelprüfungen zusammen durchgesehen.


Nachträgliche Eingabekorrektur der Root-Kernkontrollen: Nicht zulässige
Canonical-Enumwerte wurden durch die erlaubte Nutzung `grassland` ersetzt.
Zusätzlich wurde der nicht zulässige Bodenbearbeitungswert `minimum` bei
MS als `mulch` präzisiert und bei nicht gewählten Verfahren entfernt; das für
DS vorgeschlagene `strip_till` bleibt erhalten.
Quellen, Abfragen, fachliche Erwartungen und beabsichtigte Bewirtschaftungsfälle
bleiben gleich. Die konstruierten Eingaben und ihre Hashes sind ausdrücklich
geändert; Sammlung, vollständige Ausführung und unabhängige Qualitätsbindung
werden deshalb erneut hergestellt. Der Qualitätsbericht dokumentiert die
Ausgangsbindung und den Vergleich der tatsächlichen Ausgaben.
