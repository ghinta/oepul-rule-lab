# Einzelprüfung 11/26: Bodennahe Ausbringung und Gülleseparation

Der unveränderte Run bleibt für eine native App-Aufnahme blockiert. Gegenstand
ist ausschließlich `v2-o6_9-opus-5.5-high-20261003` am Kandidatencommit
`e009eed4a83ff076b26eba33ac433ac2b0642621`.
Befunde bleiben im [Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112)
und auf dem bestehenden gemeinsamen Branch. Der nächste Run beginnt erst nach
dem dokumentierten Abschluss dieser Prüfung. Eine fachliche Gesamtfreigabe oder
App-Aufnahme folgt daraus nicht.

Die neun Seiten des neuen Merkblatts und alle 42 Seiten der neu gelieferten
Nitrat-Aktionsprogramm-Verordnung wurden vollständig gelesen, einschließlich
Tabellen, Fußnoten und Gebietsliste. Alle acht Produktionsmodule und die
21 Rohannahmen wurden gelesen. Acht gemeinsame Quellen sind mit ihren
identischen Originalhashes an dokumentierte frühere vollständige Lektüren
gebunden; die aktuellen Klauseln und Verbraucher wurden erneut geprüft.
Die GSP-AV ist in diesem historischen Zehn-Quellen-Paket tatsächlich enthalten.
Ihre neue Fristenfassung ab 2026 wird nicht rückwirkend als Sollwert für frühere
Antragsjahre benutzt und früheren Paketen ohne diese Quelle nicht angerechnet.

Die Sammlung besteht aus [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md), [inputs.md](inputs.md) und den Kernkontrollen in
[core.json](core.json). Jedes Fachteil besitzt einen maschinenlesbaren Ledger.
Alle 89 historischen Regel-IDs sind mit 89 Bewertungen abgedeckt, alle
25 Profilvorschläge und 29 Tabellencontainer in zehn Datendateien erfasst.
36 zum Teil überlappende Befundgruppen und neun zusätzliche Pflichtgruppen im
allgemeinen Teil bleiben einzeln belegt. Das sind keine gleich großen Mengen
unabhängiger Modellfehler.

## Bereits abgegrenzte Kernkontrollen

Ein vollständig bekannter Betrieb mit drei Hektar Winterweichweizen und zwei
Hektar Dauerwiese ergibt für 60 m³ Schleppschlauch, 40 m³ Schleppschuh und
20 m³ Injektion eine Ausbringungskomponente von 160 Euro. Die 120 m³ liegen
unter dem Flächencap von 250 m³; der Fall entscheidet keine offene Reihenfolge
bei einer Mengenüberschreitung. Der positive N-Bedarf und alle tatsächlichen
NAPV-Pflichten sind eigenständig als erfüllt vorausgesetzt. Die kurze native
Flächenklassifikation dient dafür nicht als Nachweis.

30 m³ tatsächlich am Betrieb angefallene und mechanisch separierte Rindergülle
ergeben bei drei Jahres-Rinder-GVE 45 Euro. Der Cap beträgt 60 m³. Die
50-Euro-Grenze ist eine Kann-Bestimmung; die Kontrolle erzwingt deshalb keinen
automatischen Nullbetrag. Zehn gewöhnliche Jahres-Mastschweine ab 32 kg ergeben
drei GVE auf drei Hektar Acker und eine Schweinefütterungskomponente von
162 Euro. Tatsächliche Phasenfütterung und Rationsbelege sind positiv bekannt.
Der offene Quellenunterschied zur Gewichtsgrenze ungedeckter Jungsauen entscheidet
diesen Fall nicht.

Alle drei gewählten Kategorien ergeben zusammen 367 Euro. Jede Kategorie wird
zusätzlich einzeln mit tatsächlich nicht beantragten anderen Kategorien geprüft.
Ein nominaler Komponentenbetrag ist von wirksamem Antrag, Vertragsstatus,
Kontrollentscheidung und behördlich bewerteter Kürzung zu unterscheiden. Der
Prämienblock wird im Roh-Run unabhängig von mehreren dieser Diagnosen berechnet.
Das ist eine Grenze seines Ausgabeauftrags; daraus wird weder eine automatische
Auszahlungsfreigabe noch ein erfundener pauschaler Vollkürzungssatz abgeleitet.

Bei der Konstruktion der vier Root-Kontrollen wurde vor dem Abschluss der
unzulässige Kulturkategoriewert `grassland` auf das erlaubte `other` korrigiert;
die Flächennutzung bleibt `grassland`. Eingaben und Hashes sind ausdrücklich
neu. Quellen, Abfragen und fachliche Erwartungen bleiben gleich. Die erneute
Ausführung bestätigt alle 45 Prüfungen und dieselben nativen Ergebnisse.

## Fachliche Befunde und Tabellen

| Bereich | Beobachtung und Grenze |
|---|---|
| Verfahrenszuordnung | 40 m³ förderfähige Schleppschlauchgülle und 60 m³ vollständig ausgeschlossene Biogasgülle per Injektion ergeben nativ 58,40 statt 44 Euro. Die förderfähige Gesamtmenge von 40 m³ stimmt; der Fehler entsteht bei ihrer Verteilung auf Verfahren. Die Gesamtmenge liegt genau am Cap, ohne offene Überkappungszuordnung. |
| Bracheklassifikation | Eine bekannte nichtlegume Brache mit `crop_category=fallow` und `is_legume_pure_stand=false` wird als zwei statt null Hektar düngungswürdig gezählt. Der Fall verwendet ausschließlich Separation und behauptet keine Düngung oder rechtswidrige Auszahlung auf der Brache. |
| NAPV-Reichweite | Die Verbotszeit für sonstige landwirtschaftliche Flächen ist gespeichert, besitzt aber keinen ausgeführten Warnzweig. Eine bekannte Obstanlage erhält deshalb null statt einer Baselinewarnung. Die gesonderte Diagnose zum Förderflächenumfang funktioniert. Weitere NAPV-Auflagen und deren vollständige Berechnungsgrundlagen sind nur teilweise abgebildet. |
| Vertragszustand | Ein einziger bekannter Vertrag beziehungsweise eine einzige bekannte Schweineoption mit Beginn 2027 kann im Jahr 2026 bereits positiv gelten. Nach bekanntem Erlöschen bleibt die Verlängerungsanzeige positiv. Der letzte mögliche Neueinstieg wird dagegen nicht in ein unbelegtes allgemeines Vertragsende 2028 umgedeutet. |
| Meldefrist | Die 21-Tage-Frist ab Meldefähigkeit am 9. Mai 2026 endet am Samstag, 30. Mai. Die nach aktueller GSP-AV rechtzeitige Meldung am Montag, 1. Juni, wird vom Helfer als verspätet gewertet. Rechtzeitige Meldung und behördliche Anerkennung bleiben getrennt. |
| Flächen und Tiere | Bekannte ausländische Tiere werden diagnostiziert, aber weiter in Rinder-/Schweine-GVE-Fallbacksummen angerechnet. Ordnungsgemäß vollflächig beweidetes Ackerfutter wird zusätzlich am unzutreffenden 85-%-Erntekriterium gemessen. Das pauschale Nationalparkflag verliert die positiv bekannte Ausnahme ohne relevante Auflagen; die gesondert ausgeschlossenen Parkkulissen gehören ausdrücklich nicht zum Gegenfall. |
| Rationswerte | Sieben Kategorien, Phasengrenzen und der Mastdurchschnitt von 157 g bei 88 % TM stimmen. Die verbundene Originalzelle wurde bildlich geprüft. Die abweichende Beschreibung in Rohannahme A02 ist kein zusätzlicher ausführbarer Fehler. Die tatsächliche 32-/50-kg-Fassungsgrenze bei ungedeckten Jungsauen bleibt offen. |
| Tatsachenverträge | Herkunft, vollständige Tiergruppen, Biogasbedingungen, aktuelle tatsächliche Mengen und zeitliche Zuordnung verlangen passende vorgelagerte Nachweise. Die Kontrollen setzen bekannte Tatsachen ausdrücklich voraus; ein widersprüchlicher Eingabeaggregatewert wird nicht zum landwirtschaftlichen Goldfall. |
| Mengencaps | Die positive Ausbringung unter dem Cap und die Rinderseparation sind belegt. Für mehrere tatsächlich förderfähige Verfahren oberhalb der 50-m³-Grenze bleibt die proportionale Zuordnung eine offengelegte Annahme. Dafür wird kein verbindlicher anderer Betrag erfunden. |
| Fristenquellen | Der positive Tabellencheck des Merkblattdatums 17. April 2028 prüft diese Quellenfacette. Die tatsächlich gelieferte GSP-AV kann den Ostermontag auf den 18. April verschieben. Sie wird getrennt beurteilt und widerlegt den gespeicherten Tabellenwert nicht rückwirkend. |

Alle zehn Datendateien und 29 Inventarcontainer mit 232 direkten Einträgen
wurden vollständig abgeglichen. 41 zusätzliche Metadatenblätter sind gesondert
erfasst; 18 haben direkte Blattreferenzen, 23 keine. Alle 23 GVE-/RGVE-Zeilen,
vier Zwergrassen, 22 Biogasgruppen, sieben Proteinzeilen, neun Tarifzeilen und
beide Mengencaps sind enthalten. Die Kombinationstabelle ist ein korrekter
20-Koordinaten-Auszug zur eigenen Maßnahme. Eine vollständige Gesamtmatrix wird
nicht behauptet. Vier gespeicherten fremden RGVE-Zeilen fehlt eine
Wildhuftier-/Flächennutzungsfußnote; die eigenen Rinder- und Schweinesummen
sind davon nicht betroffen.

## Eingaben und App-Grenze

Die 25 Profilvorschläge bestehen aus 24 Ergänzungen und einer Änderung des
bestehenden Tierkategorie-Enums. Alle 97 effektiven Blätter werden gelesen.
Fünf bleiben auf separate Helfer beschränkt; 48 wirken als Meldungs- oder
Warnverbraucher ohne eigenen Betragsschalter. Der Eingabeteil verfolgt
203 kontextuelle Lesestellen, 13 zusätzliche Canonical-Pfade und zwei nicht
vorgeschlagene Schlag-Regionspfade. Vorhandensein, Wert, Typ, Jahresbezug,
Identität und tatsächliche Verbraucher bleiben getrennt dokumentiert.

Die tatsächlich ausgeführte App-Projektion am gebundenen App-Commit
`529eadb34c4fdd249fbf739a372d63185b7374a2` verwendet keine Datenbankabfrage.
Keiner der 24 neuen Pfade, das geänderte Kategorie-Enum oder eines der
97 Vorschlagsblätter bleibt am nativen Pfad erhalten. Neun der 13 zusätzlichen
Canonical-Pfade bleiben erhalten. Das nachfolgende native Replay ist definiert
mit `eligible=false`, abgelaufenem Vertrag, leeren Befund-/Warnlisten und
null Euro. Es belegt eine fehlende positive Anbindung und keinen tatsächlich
pflichtwidrig bewirtschafteten Betrieb.

Fehlende positive Nachweise, erlaubte Nullwerte, widersprüchliche Eingabeobjekte,
Stress außerhalb des Schemas, offene Quellenstände und tatsächlich bekannte
fachliche Gegenfälle werden getrennt geführt. Die gezielten Entwicklungsfälle
sind bereits öffentlich; sie sind keine unabhängige Genauigkeitsmessung oder
Expertenabnahme. Studienreferenzen, Expertenantworten, historische Selbsttests
und Sollwerte manueller Adaptationen lieferten keine Orakel. Originale,
Canonical-Profile, historische Policies und produktive App bleiben unverändert.


## Gemeinsame Ausführung und Qualität

335 neue öffentliche Entwicklungsfälle ergeben 407 Prüfungen: 366 sind erfüllt,
41 nicht erfüllt. 329 native Ergebnisse sind definiert; sechs enden im
Laufzeitfehler. Es gibt keine undefinierte Ausgabe in dieser gezielten Fallmenge.
Nicht erfüllte technische Nachweisanforderungen, tatsächlich bekannte fachliche
Gegenfälle und offene Quellenstände liefern keine pauschale Fehlerquote.

| Teil | Fälle | Prüfungen | Erfüllt | Nicht erfüllt |
|---|---:|---:|---:|---:|
| Kernkontrollen | 4 | 45 | 45 | 0 |
| Allgemeine Regeln | 135 | 135 | 125 | 10 |
| Maßnahme | 97 | 97 | 94 | 3 |
| Tabellen | 33 | 33 | 33 | 0 |
| Eingaben | 66 | 97 | 69 | 28 |

Alle sechs Laufzeitfehler betreffen die Hauptentscheidung: drei ausdrücklich
erlaubte Nullwerte (zwei neue Blätter und der bestehende Canonical-Kulturname),
ein strukturell erlaubter, aber funktional widersprüchlicher Rations-ID-Vertrag
und zwei Stresswerte außerhalb des Schemas. Ein fehlender Wert mit nativem
Null-Default und separate Helfer verursachen in dieser gezielten Menge keinen
weiteren Fehler. Die sicheren Jahresmittel-/GVE-Fallbacks und echte numerische
Null wurden ausdrücklich kontrolliert.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_9 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die nativen Verzeichnisse bleiben unverändert: Regelquery
`data.oepul.o6_9.decision`, Daten unter `data.o6_9`. Die unabhängige
Gegenprüfung und die 14 finalen Artefaktbindungen stehen in
[quality.md](quality.md) und [quality.json](quality.json). Deren begrenzte
zusätzliche Eingabekontrolle ist separat beschrieben; sie zählt keine weiteren
unabhängigen Quellenfälle hinzu. Die vorhandenen Enum-Werte wurden gegen das
unveränderte Canonical und die tatsächlichen Run-Vorschläge geprüft. Das ist
keine vollständige Schema-, Tatsachen- oder Behördenprüfung.

Die getrennten [numerischen Laufzeitkontrollen](../../runtime-numeric.md)
beziehen sich auf die exakt gepinnte Binary; sie werden nicht als zusätzliche
Modellfehler gezählt. Die SQL-blockierte App-Projektion bleibt ein eigener
Integrationslauf. Es gibt keine Expertenfreigabe, Regelreparatur oder Promotion.
Gemeinsame Lösungen werden nach allen 26 Einzelprüfungen zusammen durchgesehen.
