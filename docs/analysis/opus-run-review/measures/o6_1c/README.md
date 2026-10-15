# Einzelprüfung 3/26: Nichtproduktive Ackerflächen und Agroforststreifen

Der unveränderte Run `v2-o6_1c-opus-5.5-high-20261009` bleibt für eine native
App-Aufnahme blockiert. Diese Prüfung sammelt Befunde für
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112).
Sie repariert keine Regeln und erteilt keine Expertenfreigabe.

Vollständig geprüft wurden das fünfseitige Maßnahmenmerkblatt, alle neun
Produktionsmodule, 97 Katalogregeln, 22 Tabellencontainer und 16 Profilvorschläge
mit 88 neuen Blättern. Die zusätzliche GSP-AV-Fassung vom 28. Januar 2026 wurde
auf allen 94 PDF-Seiten neu gelesen, einschließlich Inkrafttreten und Anlagen.
Die sieben gemeinsamen Quellen sind im Hash identisch mit früheren vollständigen
Lesedurchgängen. Diese werden gebunden wiederverwendet; die für diesen Run
maßgeblichen Klauseln und Verbraucher wurden erneut verglichen.

Die ausführlichen Teilberichte stehen in [general.md](general.md),
[measure.md](measure.md), [tables.md](tables.md) und [inputs.md](inputs.md),
jeweils mit einem JSON-Ledger. [core.json](core.json) ergänzt gemeinsame Helfer,
Gesamtentscheidung, Kategorien und Prämienbandkontrollen. Zwei Regelbewertungen
überlappen; [audit.json](audit.json) erhält alle 99 Bewertungen und 30 Teilbefunde.
Diese Befunde sind keine 30 voneinander unabhängigen Fehlerursachen.

## Wesentliche Ergebnisse

| Bereich | Befund und Abgrenzung |
|---|---|
| Fristen | Die Feldlistenfrist wird immer auf den 15. April gesetzt. GSP-AV §5 unterscheidet Fristen mit Arbeitstagsverschiebung von ausdrücklich ausgenommenen Terminen. Die Frist für den Maßnahmenantrag am 31. Dezember gehört zu den Ausnahmen. Auch die Meldung höherer Gewalt benötigt die passende Arbeitstagsregel. |
| Quellenstand | Die mitgelieferte GSP-AV setzt die frühere GLÖZ-8-Mindeststilllegung von vier Prozent ab 2025 ausdrücklich außer Anwendung. Die historische Annahmennotiz lässt diese bereits entschiedene Frage offen. Der Vier-Prozent-Deckel der NPA-Prämie ist eine andere Vorschrift. |
| Vertrag und Nachweise | Fehlende Angaben können einen positiven Vertrag erhalten. Außerdem kann ein ausdrücklich erst 2027 beginnender Vertrag schon 2026 als gültig erscheinen; eine Verlängerung wird auch außerhalb des gebundenen Programmzeitraums berechnet. Fehlendfälle werden getrennt vom bekannten falschen Zeitbezug bewertet. |
| Jahresbezug | Alte NPA-Schnitte können die Höchstzahl für das aktuelle Jahr überschreiten lassen, eine aktuelle zweijährliche Pflegepflicht scheinbar erfüllen und den aktuellen Frühpflegeanteil erhöhen. Die Schnittliste wird nicht nach Auswertungsjahr gefiltert. |
| Agroforstdefinition | Fehlende Breite, Länge oder andere Definitionsnachweise können ein positives `afs_meets_definition` und eine prämienrelevante Fläche ergeben. Eine Länge von null überspringt die Dichteprüfung. Die Schnittstelle benötigt klare Typ- und Nachweisgrenzen. |
| Sanktionen | Der Run zählt einzelne 100-Prozent-Befunde für den Ausschluss statt jährlicher Kürzungen. Zwei solche Befunde in einem Jahr sowie zwei zu 100 Prozent kumulierte Teilkürzungen werden dadurch unterschiedlich falsch behandelt. |
| Betrag und Rechtsfolge | Das Prämienband ist auf `contract_valid` begrenzt, verarbeitet aber Kontrollablehnung und Sanktionen nicht zum endgültigen Auszahlungsbetrag. `guaranteed_eur` darf deshalb nicht als bestätigter zahlbarer Mindestbetrag verstanden werden. Eine beliebige Pflegeverletzung rechtfertigt keine erfundene automatische Nullprämie. |
| Identität und Eingabebedeutung | „Fertile“ ist im Paulownia-Datenlabel erhalten, fehlt aber im ausführbaren Artenvertrag. Autorenangaben bei botanischen Namen und Bio-Verbissschutz im allgemeinen PSM-Flag werden ausdrücklich als zu klärende Feldverträge geführt. Keine erfundene Zulässigkeitsentscheidung für sterile Pflanzen. |
| Weitere Nachweise | Verfügung am 1. April, Referenzflächenbegrenzung, eindeutige Flächenidentität und erforderliche Begrünung bleiben teilweise externe oder nur katalogisierte Pflichten. Begrünung ist mit zulässigen Ansaat-/Umbruchterminen und Ausnahmen zusammen zu beurteilen; es wird keine pauschale ununterbrochene April–September-Bedeckung erfunden. |

Die Tabellenwerte selbst wurden vollständig verglichen: sieben Datendateien,
586 direkte Zeilen einschließlich verschachtelter Werte, alle 14 Negativlistentaxa,
beide Prämienbänder und 420 gerichtete Kombinationszellen mit vier Fußnoten.
Keine fehlende Taxonzeile, falsche 1C-Prämiengrenze oder Matrix-Tokenabweichung
festgestellt. Anders als bei BIO wird die Matrix hier tatsächlich für das
NPA-Kombinationsverbot verwendet. Grenzen des allgemeinen Matrixhelfers bei
anderen Maßnahmen sind als solche gekennzeichnet.

Die Quellen nennen fünf zusätzliche Fälle höherer Gewalt ausdrücklich als
offene Beispiele. Ein nicht bekannter Fallcode ist allein kein Ablehnungsgrund.
Bei der Übernahmefrist 2028 bleibt ein konkreter Konflikt sichtbar: Die ATB
nennt den 17. April, während Feiertags- und Arbeitstagsregeln eine weitere
Verschiebung nahelegen. Diese Quellenhierarchie wird nicht stillschweigend
entschieden; die Feldlistenfälle bleiben davon getrennt.

## Öffentliche Entwicklungsfälle und Reproduktion

[development-probes.json](development-probes.json) enthält 109 öffentliche
Entwicklungsfälle mit 111 Komponentenprüfungen. 102 Ausgaben sind definiert,
zwei undefiniert und fünf enden im ursprünglichen Laufzeitfehler. 65 Prüfungen
treffen zu, 46 nicht. Gezielte Gegen-/Grenzfälle, verwandte Proben,
Vertragsfragen und technische Kontrollen ergeben keine Modellgenauigkeitsquote.

Die fünf Laufzeitfehler betreffen absichtlich schemawidrige Null-/Boolean-/
String-Werte in nicht-nullbaren Zahlen- oder Jahresfeldern. Sie zeigen
Robustheitsgrenzen und werden nicht als fachliche Fehlentscheidung bei gültigen
Eingaben gezählt. Auch die undefinierte Breitenprobe liegt außerhalb des
vorgeschlagenen Zahlenvertrags. Die zweite undefinierte Ausgabe ist die native
Darstellung eines Ablehnungsprädikats bei bereits akzeptierter höherer Gewalt.
Die Quelle schreibt keine OPA-Repräsentation als `undefined` vor; beide
Kontrollverweigerungs-Statusfälle sind technische Darstellungsdiagnosen.

Die Kontrollen decken korrekte Prämienbänder, Vier-Prozent-Kappung, beide
zulässigen Kategorien, genau halbe Frühpflegefläche, Antragsgrenzen,
Maßnahmenkombinationen, Mindestflächen und Sanktionsstufen ab. Ungültige
Enumwerte sind ausdrücklich Eingabestress außerhalb der Deklaration.
Keine privaten Studienfälle oder Modell-Selbsttestlabels wurden verwendet.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_1c \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die [gesonderten numerischen Laufzeitabweichungen](../../runtime-numeric.md)
bleiben an die exakte historische Binary gebunden. Sie werden nicht pauschal
allen Regelbefunden zugerechnet. Der originale Daten-Namensraum und sämtliche
ursprünglichen Ausgaben bleiben erhalten.

86 von 88 vorgeschlagenen Blättern werden gelesen; `case_id` und `event_date`
der Höhere-Gewalt-Meldung bleiben ungenutzt. Alle 139 deklarierten Lesestellen
und acht bestehende Canonical-Blattpfade sind dokumentiert. Die tatsächliche
App-Projektion wurde mit gesperrtem Datenbankzugriff ausgeführt: Keiner der 16
nativen Vorschlagspfade wird übernommen. Bestehende PSM-/Düngungsaggregate
benötigen hier laut historischer Annahme bereits eine zeitliche Vorfilterung;
der datierte Nach-Umbruch-Befund anderer Runs wird deshalb nicht pauschal kopiert.

Die getrennte Qualitätskontrolle steht in [quality.md](quality.md).
Historische Quellen, Regeln, Profile und die produktive App wurden nicht verändert.
Die gemeinsame Ursachen- und Lösungsdurchsicht folgt nach dem Gesamtdurchgang.
