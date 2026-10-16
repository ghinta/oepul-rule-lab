# Einzelprüfung 12/26: Erosionsschutz Wein, Obst und Hopfen

Der unveränderte Run bleibt für eine native App-Aufnahme blockiert. Gegenstand
ist ausschließlich `v2-o6_10-opus-5.5-high-20260925` am Kandidatencommit
`e009eed4a83ff076b26eba33ac433ac2b0642621`.
Befunde bleiben im [Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112)
und auf dem bestehenden gemeinsamen Branch. Der nächste Run beginnt erst nach
dem dokumentierten Abschluss. Die Prüfung erteilt keine Expertenfreigabe oder
App-Promotion und repariert keine historischen Policies.

Das neue Merkblatt wurde auf allen sechs Seiten einschließlich Tabellen,
Fußnoten, Updates und Schlussvermerken vollständig gelesen. Alle acht
Produktionsmodule mit 1.196 Zeilen und die 20 tatsächlichen Annahmelabels wurden
gelesen. Die Tariftabellen auf Merkblattseiten 5–6 wurden zusätzlich am Bild
kontrolliert. Sieben gemeinsame Originale werden mit identischen Hashes an die
früheren vollständigen Lektüren gebunden; die aktuellen Klauseln und Verbraucher
wurden erneut verglichen. Für die Kernkontrollen wurden SRL-Seiten 12, 23,
64–65 und ATB-Seiten 18–19 direkt erneut gelesen.

Das historische Paket enthält acht Originale und **keine GSP-AV oder NAPV**.
Die tatsächlich in o6_9 gelieferten zusätzlichen Originale werden hier nicht
rückwirkend als bereitgestellte Quellen angerechnet. Paketlücken und zusätzliche
für eine spätere App-Aufnahme nötige Rechtsstände bleiben getrennt sichtbar.

Die Sammlung besteht aus [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md), [inputs.md](inputs.md) und [core.json](core.json).
Jeder Teil besitzt einen maschinenlesbaren Ledger. Alle 91 historischen IDs
sind mit 91 Bewertungen abgedeckt, sämtliche 20 Eingabeergänzungen und
38 Tabellencontainer in fünf Datendateien erfasst. 35 überlappende Befundgruppen
bleiben getrennt belegt; die 13 zusätzlichen Pflichtgruppen und sechs nicht
ausführbaren Normkontrollen im allgemeinen Teil sind keine zusätzlichen
historischen IDs oder nativen Entwicklungsfälle.

## Vollständig bekannte positive Kernkontrollen

Sieben Hektar eigener österreichischer Heimfläche decken alle sieben
Grundtarife ab: Wein unter 25 % und ab 25 %, zwei echte Weinterrassen ab 35 %
beziehungsweise ab 50 %, zwei veredelte Apfelanlagen unter beziehungsweise ab
25 % und Hopfen. Jeder Schlag ist genau einen Hektar groß. Die GIS-Neigungen,
gültige aktuelle Teilnahme und sämtliche tatsächlichen Jahrespflichten sind
positiv bekannt; andere Flächenzahlungen und behördliche Kürzungen liegen
nicht vor.

Die Grundkomponente beträgt 2.754 Euro. Mit tatsächlich registerkonformem,
einen PSM-Einsatz ersetzendem EOP-Einsatz und vollständigen Belegen auf jedem
der sieben codierten Schläge kommen 1.134 Euro hinzu, insgesamt 3.888 Euro.
Es besteht keine Teilnahme an BIO oder Maßnahme 12 und keine entgegenstehende
Erzeugerorganisationsförderung. Die offene Bemessungsflächenannahme A08 wird
dadurch nicht entschieden. Behandlungen finden an den Dauerkulturen statt,
ohne Pflanzenschutzmitteleinsatz auf der Fahrgassenbegrünung.

Eine gesonderte vollständig bekannte Terrasse mit 0,50 Hektar und genau 25 %
GIS-Neigung ergibt 162 Euro ohne Begrünungspflicht. Das ist ein tatsächliches
späteres ÖPUL-Teilnahmejahr mit positiv belegter vorheriger Teilnahme; eine
unbekannte Erstteilnahme wird nicht aus einem Default abgeleitet. Der Fall
entscheidet keine Lesart für als Terrasse bezeichnete Flächen unter 25 %.

Alle drei Kernfälle sind nativ definiert und bestehen sämtliche 78 Prüfungen.
137 vorhandene Enum-Werte stimmen mit dem unveränderten Canonical und den
tatsächlichen Vorschlägen überein. Das ist keine vollständige Schema- oder
Tatsachenzertifizierung.

## Tatsächlich verbundene Berechnung und ihre Grenze

Mehrere finanzielle Sperren funktionieren: Der gültige Vertrag steuert bereits
die Grundkomponenten; Kontrollverweigerung, ausgeschlossene Teilnahme und ein
fehlender jährlicher Zahlungsantrag sperren den tatsächlichen Gesamtbetrag.
Behördlich vorgegebene Kontrollstufen, Modulation und Flächenobergrenze werden
verrechnet. Nationalparkflächen werden anhand konkreter Parkkategorien statt
eines pauschalen Flags unterschieden. Diese Verbesserungen bleiben erhalten.

Verbleibende lokale und betriebliche Auflagendiagnosen sind von einer
behördlichen Sanktionsstufe verschieden. Die höchste übergebene Kontrollstufe
unter A09 und die proportionale Cap-Zuordnung unter A10 sind offengelegte
Annahmen. Ein beliebiger Auflagenbefund erhält keinen erfundenen pauschalen
100-%-Abschlag. Der als `payable_total_eur` bezeichnete Wert ist zusammen mit
seinen tatsächlichen Diagnose-, Nachweis- und Behördenzuständen zu lesen;
allein er erteilt keine Auszahlungsfreigabe. Diese verbleibende Ausgabegrenze
ist in der Root-Befundgruppe `OUTPUT_SCOPE` abgegrenzt.

## Quellenbefunde und ausdrücklich bedingte Verträge

| Bereich | Beobachtung und Abgrenzung |
|---|---|
| Aktuelle Ereignisfrist | Eine bekannt physisch zerstörende Tiefenlockerung und eine alleinige Neuauspflanzung lösen keine lokale Acht-Wochen-Prüfung aus. Für beide vollständig bekannten Jahreslisten fehlt die Neuanlage bis Jahresende. Daraus wird keine feste Sanktion oder Nullzahlung abgeleitet. |
| Überjährige Rodung | Bei einer Rodung vom 16. September 2025 ohne tatsächliche Neuanlage bis Ende 2026 bleibt der Status wegen fehlender Folgejahreseinträge offen, obwohl die Frist am 15. Mai 2026 abgelaufen ist. Zwei Prüfungen betreffen denselben tatsächlichen Eingabefall. |
| Archiv und Terrassen | Eine reine Archivhistorie ist ein erweiterter Eingabevertrag. Die Reichweite der Terrassenausnahme für Pflichten auf tatsächlich vorhandener Begrünung ist eine offene bedingte Lesart. Beide Bereiche werden von den konkreten aktuellen Fristfällen getrennt. |
| Ausnahme 2026 | Die Rohfelder unterscheiden den qualifizierten mangelhaften Feldaufgang nicht vollständig von späterer Zerstörung und qualifiziertes Ausfallgetreide nicht von der Herkunft eingesäter Komponenten. Zwei Quellenkontexte mit identischer darstellbarer Eingabe zeigen diese Grenze ausdrücklich; sie sind keine unabhängige Genauigkeitsstichprobe. |
| Antragshorizont | Ein einziger Antrag von 2021 kann eine aktuelle Teilnahme begründen, obwohl die beigefügte SRL erst auf ab 2. November 2022 gestellte Anträge und begründete Verpflichtungen anzuwenden ist. Tatsächlich fehlende neue Antragstellung und Übernahme sind positiv bekannt. |
| Kulturidentität | Der wörtliche Merkblattname „Walnüsse“ wird nicht als Obst erkannt; Veredelung und OP-Ausschluss sind im Gegenfall bereits richtig angegeben, ohne einen Prämienanspruch zu behaupten. Eine positiv bestimmte Pistazie fällt als Mitglied der offenen Quellgruppe „andere Schalenfrüchte“ ebenfalls aus dem Literalvergleich. Ein unbekannter String wird damit nicht pauschal freigegeben. |
| Eingabebedeutung | Ungefilterte ausländische Bruttofläche, Heim-/Alm-Gesamtfläche, das rohe Kontrollverhinderungsereignis trotz anerkannter Ausnahme und bereits endgültige unveränderte andere Zahlungen erzeugen jeweils bedingte Gegenfälle. Bei vorgelagert anders qualifizierten Werten gelten diese Sollwerte ausdrücklich nicht. |

Der Maßnahmenteil enthält vier konkrete Frist-/Ereignisprüfungen auf drei
tatsächlichen Eingabefällen, eine bedingte Archivprüfung, drei bedingte
Terrassenprüfungen und zwei fehlende Quellenqualifikationen. Die zehn
Abweichungen sind keine zehn unabhängigen bestätigten Regeldefekte.
Auch die acht Abweichungen im allgemeinen Teil behalten ihre jeweils
ausdrücklich beschriebenen Eingabe- und Behördenverträge.

Alle fünf Datendateien mit 38 Containern und 410 direkten Einträgen wurden
vollständig abgeglichen. Die 134 gespeicherten Kombinationstupel und
286 impliziten Leerpaare sind am identischen Originalstand geprüft;
21 Diagonalen bleiben gesondert. 34 Obstnamen, Tarife und Hanggrenzen besitzen
eigene Verbraucherprüfungen. 14 zusätzliche Metadatenblätter sind separat
gezählt (zwei direkte Leser, zwölf ohne); von 31 Programmparametern werden
22 direkt gelesen. Ein niedriger fremder Katalogbefund betrifft fehlende
Grünland-/Ackerqualifikation zweier Heuwirtschaftslisten, ohne Wirkung auf die
eigene Maßnahme 10.

Ein Darstellungsfehler in einer Tabellenprobe wurde vor dem gemeinsamen
Abschluss korrigiert: dieselben fünf belegten Partner werden entsprechend der
explizit sortierenden Query lexikografisch erwartet. Die geänderte Reihenfolge
und die alte Bindung stehen im Tabellenledger. Eingabe, Query und Mitgliederset
bleiben gleich. Das ist ein Prüfautorenfehler, kein Modellbefund; danach wurden
alle Fälle vollständig neu ausgeführt und unabhängig reproduziert.

## Eingaben und tatsächliche App-Projektion

Die 20 Ergänzungen umfassen 62 Blätter. 61 werden gelesen;
`permanent_crop.planting_year` bleibt ungelesen. 23 gelesene Blätter wirken als
Diagnose oder Hinweis ohne eigenen Betragsschalter. Ein ausschließlich
separater Vorschlagshelfer bleibt nicht übrig. 151 kontextuelle Lesestellen,
zwei dynamische Schleifen mit fünf tatsächlichen Schlüsseln und sieben weitere
Canonical-Blätter sind verfolgt; unvorgeschlagene gelesene Pfade gibt es nicht.

Die reine App-Projektion wurde am gebundenen Commit
`529eadb34c4fdd249fbf739a372d63185b7374a2` mit blockiertem SQL-Zugriff tatsächlich
ausgeführt: null Datenbankaufrufe. Kein Vorschlagspfad und keines der 62 Blätter
bleibt am nativen Pfad erhalten. Fünf der sieben zusätzlichen Canonical-Werte
bleiben erhalten; Nutzpflanzenname und -kategorie gehen verloren. Die getrennte
native Folgeauswertung ist definiert mit `no_application`, ungültigem Vertrag,
null Hektar VFH und null Euro. Sie zählt als eigener Integrationslauf und
belegt keinen tatsächlichen Bewirtschaftungsverstoß.

Frische Quellenfälle bleiben getrennt von Studienreferenzen, GM-/Expertenlabels,
historischen Selbsttests und Sollwerten manueller Adaptationen. Fehlende
Nachweise, erlaubte Nullwerte, Bereichs-/Identitätskonflikte, Schema-Stress,
offene Quellenlesarten und behördliche Folgen werden einzeln klassifiziert.
Die Fälle sind öffentlich und keine unabhängige Genauigkeitsmessung.
Originale, Canonical-Profile, historische Policies und produktive App bleiben
unverändert. Gemeinsame Lösungen werden nach allen 26 Einzelprüfungen zusammen
durchgesehen.


## Gemeinsame Ausführung und Qualität

373 neue öffentliche Entwicklungsfälle ergeben 490 Prüfungen: 443 sind erfüllt,
47 nicht erfüllt. 364 native Ergebnisse sind definiert; neun enden im
Laufzeitfehler. Es gibt keine undefinierte Ausgabe in dieser gezielten Menge.
Bedingte Eingabeverträge, Darstellungsgrenzen, technische Nachweiswünsche und
konkrete Quellengegenfälle sind keine pauschale Modellfehlerquote.

| Teil | Fälle | Prüfungen | Erfüllt | Nicht erfüllt |
|---|---:|---:|---:|---:|
| Kernkontrollen | 3 | 78 | 78 | 0 |
| Allgemeine Regeln | 124 | 124 | 116 | 8 |
| Maßnahme | 135 | 135 | 125 | 10 |
| Tabellen | 41 | 41 | 41 | 0 |
| Eingaben | 70 | 112 | 83 | 29 |

Alle neun Laufzeitfehler betreffen die Hauptentscheidung: drei ausdrücklich
erlaubte Nullwerte auf neuen Blättern, zwei Bereichs-/Identitätskonflikte
(Nullfläche und doppelte Schlagkennung) und vier Werte außerhalb des Schemas.
Ein Nullflächenschlag ist kein gewöhnlicher positiver physischer Fall. Es gibt
keinen zusätzlichen beobachteten Fehlend-zu-Null-Defaultabbruch. Die beiden
separaten Eingabehelferabfragen bleiben definiert. Ein unabhängiger begrenzter
14-Eval-Untercheck reproduziert diese neun Fehler und fünf technisch definierte
Nullable-Beobachtungen; er erhöht die Quellenfallzahlen nicht und behauptet
keine vollständige Schema- oder Tatsachenprüfung.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_10 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die nativen Verzeichnisse bleiben unverändert: Regelquery
`data.oepul.o6_10.decision`, Daten unter `data.o6_10`. Die unabhängige
Gegenprüfung mit den 14 finalen Artefaktbindungen steht in
[quality.md](quality.md) und [quality.json](quality.json). Die begrenzte
zusätzliche Eingabeprüfung wird dort vollständig und gesondert dokumentiert.
Die SQL-blockierte App-Projektion zählt als eigener Integrationslauf.

Die getrennten [numerischen Laufzeitkontrollen](../../runtime-numeric.md)
beziehen sich auf die exakt gepinnte Binary und sind keine zusätzlichen
Modellfehler. Positive Komponenten und saubere Reproduzierbarkeit erteilen
keine Expertenfreigabe oder Promotion. Gemeinsame Lösungen werden nach allen
26 Einzelprüfungen zusammen durchgesehen.
