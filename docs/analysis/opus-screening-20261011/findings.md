# Opus-Befunde und nächste Thesis-Entscheidung

Die 26 veröffentlichten Kandidaten sind diagnostisch gesichtet; eine vollständige
App-Integration ist für den begrenzten Thesis-Versuch nicht erforderlich.
[Matrix](matrix.csv), [Vertrags-/Quellenvergleich](comparison.csv) und
[native Rohoutputs](results.json) binden jeden Befund an exakte Artefakte.

Alle 26 isolierten Policy-/Datenbundles kompilieren mit OPA 1.18.2 strikt.
59 belegbar übersetzte Entwicklungsproben wurden ausgeführt: 54 liefern einen
definierten nativen Wert, fünf einen Laufzeitfehler. Bei fünf Maßnahmen gibt es
keine sinnvolle native Probe aus den vorhandenen Luna-Fakten. Diese Zahlen
sind Ausführungsbefunde mit unterschiedlichen Prüfumfängen, keine Genauigkeitsquote
und kein Ranking gegenüber den 78 Luna-Entwicklungsfällen.

## Konkrete Ausführungs- und Vertragsgrenzen

| Bereich | Beobachtung | Bedeutung |
|---|---|---|
| o6_3 | Alle drei Proben: `general.rego:24`, Multiplikation mit fehlendem Vorjahresflächenwert | Ein streng ausgeführter Kandidat kann bei unvollständigen Betriebsfakten abbrechen, obwohl historische Modelltests bestanden wurden |
| o6_14 | Beide belegbar übersetzten Proben: `participation.rego:19`, fehlendes Vertragsjahr minus eins | Reproduzierbarer Laufzeitfehler; Tierzahl/Alter oder exakte Vertragsdaten werden nicht erfunden |
| o6_1a, o6_1b, o6_2, o6_5 | Native Variationsinputs sind identisch zur Basis | Der ursprüngliche veränderte Luna-Fakt ist nicht belegbar übersetzbar; Outputgleichheit belegt keine fehlende Sensitivität |
| o6_12 | Insektizidvariation ohne bekanntes Einsatzdatum erzeugt keinen Verstoß im nativen Satz | Das Fehlen eines Verstoßes bestätigt keine regelkonforme Anwendung; Jahr 2024 bleibt unverändert |
| o6_13, o6_15 | Fehlende Parzellen-/Almidentität unterdrückt Teilbefunde | Breitere native Verträge brauchen Fakten, die die alten Entwicklungsproben nicht liefern |
| o6_16 | Keine einzelnen Kursnachweise aus zehn aggregierten Stunden ableitbar | Ein nativer Default von null Stunden ist keine Aussage über tatsächliche Weiterbildung; Variation/Auslassung bleiben Lücken |
| o6_20, o6_23 | Fehlende Angaben können günstige Defaults erhalten und die Ausgabe unverändert lassen | `false`, fehlend und bestätigte Regelkonformität haben keine gemeinsame modellübergreifende Bedeutung |

Für o6_17, o6_19, o6_21, o6_22 und o6_24 sind ausdrückliche `fixture_gap`-Befunde
versioniert. Gründe sind fehlende datierte Laborbelege, Einzelparzellen/
Indikatoren, Tier-/Gebäudeinformationen, Kategorie-/Tierzahlbelege sowie
datierte N-Gaben und kulturbezogene Grenzwerte. Alle drei ursprünglichen
Luna-Fälle bleiben im jeweiligen Übersetzungsledger nachvollziehbar.

Einige belegbare Einzelvariationen erzeugen sichtbare native Reaktionen:
Mindestfläche (o6_7), Vierfachflächenhinweis (o6_8), Technik-/Mengenbefunde (o6_9),
81-cm-Breite (o6_10), Herbizideinsatz (o6_11), Auflagencode (o6_18),
119 Weidetage (o6_20) und mineralische N-Gabe (o6_23). Sie belegen nur die
Reaktion dieser Query auf diese Eingabe, nicht deren unabhängige Quellkorrektheit.

## Historische Gegenüberstellung

Neun Opus-Pakete haben zusätzliche Quellen gegenüber Luna; 17 haben identische
Quellenhash-Sets. Adapter, Werkzeugnutzung, Feedback, Fortsetzungen, Laufzeiten
und Budgets bleiben verschieden. Die genaue Anbieterrevision fehlt in den
historischen Metadaten. Es entsteht daher kein kontrollierter Modelleffekt.

Die Modell-Ledger melden insgesamt elf offene Coverage-Punkte. Acht stammen
aus den neun erneuerten Kandidaten; je ein weiterer aus o6_1a, o6_10 und o6_23.
Coverage-PASS, Regelzahl und selbst generierte Tests belegen keine unabhängig
bestätigte Vollständigkeit. Die veröffentlichte v2-Metadatenprüfung darf nicht
als damaliges Generierungsgate oder Fachfreigabe dargestellt werden.

Kosten aus dem jeweils letzten `generator_result`: 414,68 USD für die aktuellen
26 Kandidaten und 548,64 USD für alle 36 Veröffentlichungen. Es sind berichtete
Listenpreisäquivalente; kumulative Sitzungswerte werden nicht nochmals pro
Fortsetzung summiert. Fehlende Luna-Kosten werden nicht geschätzt.

## Anschluss an #56 ohne Erweiterung des Versuchs

Die vier vorgeschlagenen Originalklauseln und ihre PDF-Hashes bleiben erhalten:
Insektizidverbot/Bio-Ausnahme, Antragsfrist, Tiergruppenmitgliedschaft und
erforderliche Bodenprobenzahl. Alle vier direkten Originale sind auch im
jeweiligen Opus-Quellensatz bytegleich vorhanden. Die breiteren Vertragsprobleme
sind kein sachlicher Grund, den kontrollierten Versuch auf ganze Maßnahmen
oder vollständige App-Empfehlungen auszudehnen.

| Vorschlag | Was die aktuelle Diagnose dazu nicht bestätigt |
|---|---|
| o6_12 Verbot/Bio-Ausnahme | Fehlendes Einsatzdatum verdeckt den Verbotsbefund; Bio-Ausnahme braucht unabhängige Applicability-/Produktklassifikation |
| o6_13 Antragsfrist | Die Luna-Variation untersucht Bestäubung, nicht Fristendpunkte |
| o6_14 Tiergruppen | Die Luna-Variation untersucht Alpungstage, nicht Kategoriezugehörigkeit; Gesamtvertragsarithmetik bleibt außerhalb des Einzelklausel-Tasks |
| o6_17 erforderliche Proben | Die Luna-Variation verändert vorhandene Proben statt die erforderliche Zahl; datierte Laborbelege gehören nicht zur ausgewählten Rundungsklausel |

Nächster Schritt ist die verbindliche Quellen-/Input-/Output-Abgrenzung der
vier Einzelklauseln in [App #56](https://github.com/ghinta/oepul-recommender/issues/56).
Dann werden unabhängige Referenzfälle unter
[#51](https://github.com/ghinta/oepul-recommender/issues/51) und der Collector unter
[#52](https://github.com/ghinta/oepul-recommender/issues/52) vorbereitet.
Die Diagnose ersetzt weder diese Referenzen noch eine Methodfreigabe.
Die Obergrenze des Entwurfs bleibt 48 initiale Generierungen mit höchstens
zwei Repair-Aufrufen je Ausgangsartefakt. Diese Diagnose startet keinen davon.

App #140 ist nur dort ein fachlicher Blocker, wo ein konkretes Sollurteil eine
noch offene Auslegung benötigt. Das verhindert weder diese technische Diagnose
noch die Abgrenzung direkt belegbarer Einzelklauseln. Allgemeine App-Integration,
größere Rule-Coverage und zusätzliche Modelle bleiben getrennte Arbeiten.
