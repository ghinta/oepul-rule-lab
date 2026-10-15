# Einzelprüfung 7/26: Erhaltung gefährdeter Nutztierrassen

Der unveränderte Run `v2-o6_5-opus-5.5-high-20260925` bleibt für eine native
App-Aufnahme blockiert. Sämtliche Befunde werden im
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) und im
bestehenden gemeinsamen Branch gesammelt. Historische Regeln werden nicht
repariert; der Prüfabschluss erteilt keine Expertenfreigabe.

Vollständig gelesen wurden das neue zehnseitige Maßnahmenmerkblatt und alle
sieben Produktionsmodule samt Rohannahmen. Die sieben gemeinsamen Quellen
wurden mit identischem Hash aus den vorangegangenen Volllektüren wiederverwendet;
ihre aktuellen Verbraucher und einschlägigen Klauseln wurden erneut geprüft.
Die GSP-AV gehört nicht zu diesem achtteiligen Quellpaket. Sie wird dem damaligen
Run nicht nachträglich als bereitgestellte Quelle zugerechnet.

Die Teilberichte [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md) und [inputs.md](inputs.md) besitzen jeweils ein JSON-Ledger.
[core.json](core.json) ergänzt die Gesamtentscheidung und den Bezug zwischen
Originaltier, Ersatz und Förderplatz. Alle 97 historischen Katalogregeln, alle 13
Tabellencontainer und sämtliche sieben Profilvorschläge werden vollständig
abgedeckt. [audit.json](audit.json) erhält 109 Bewertungen dieser 97 IDs und
26 überlappende Teilbefunde. Die Bewertungen bleiben erhalten und sind keine unabhängigen
Fehlerzahlen.

| Bereich | Quellenvergleich und Abgrenzung |
|---|---|
| Positive Tiernachweise | Reinrassigkeit, Herdbuch, genehmigtes Zuchtprogramm, regelmäßige Zuchtverwendung und Tierhaltung in Österreich werden positiv verlangt. Rasse, Tierart und Kategorie werden tatsächlich verbunden; fehlende Nachweise werden hier nicht pauschal günstig ersetzt. |
| Förderplatz und Ersatz | Die Kontrollen unterscheiden ein ursprüngliches förderfähiges Tier, einen rechtzeitigen Ersatz und dessen späteren unersetzten Abgang. Ersatztiere erzeugen keine zweite Prämie. Die Ergebniszeile `eligible` meint beim Ersatz jedoch nur dessen Grundbedingungen, beim Original den gesamten Förderplatz. Diese unterschiedliche Reichweite braucht einen eindeutigen App-Ausgabevertrag. |
| Nachbesetzungszeitpunkt | Für ein Ersatztier müssen die Bedingungen ab der tatsächlichen Übernahme erfüllt sein. Der spätere normale Altersstichtag kann einen zu jungen Ersatz dennoch durchlassen. Eine zulässige Nachbesetzung im Januar wird bei der Ausnahme für das Zulassungsjahr noch mit dem alten Antragsjahr verglichen. |
| Nachbesetzungskette | Zwei aufeinanderfolgende Ersatztiere werden verarbeitet; ein dritter rechtzeitiger und geeigneter Nachfolger scheitert an der ausdrücklich dokumentierten technischen Kettenbegrenzung. Diese Begrenzung steht nicht in der Quelle. |
| Zeitbezug und Stuten | Vollständig vergangene vorübergehende Aufenthalte können heutige Tier- und Meldebefunde auslösen. Die gesonderte Folgeabfohlfrist wird nur zum 31. Mai geprüft. Der Stutenfall isoliert den lokalen Befund bei abgeschlossener Jahresbeobachtung; widersprüchliche Detailhistorie und pauschale Organisationsbestätigung belegen für sich keine gesichert rechtswidrige Auszahlung. |
| Tatsachenwidersprüche | Ein Nachbesetzungsdatum vor der angegebenen ersten tatsächlichen Ankunft ist eine Eingabekonsistenzfrage. Früheres Eintreffen mit späterer Übernahme eines Förderplatzes bleibt zulässig. Diese Kontrollen verlangen keine Gleichheit beider Datumsfelder. |
| Förderhöhe und GEP | Die Rassenliste und alle Tarife stimmen. Der GEP-Zuschlag liest die Rassenkennzeichnung, während die tatsächliche Jahresumsetzung durch die Organisation nicht modelliert wird. Die Tarifkontrollen setzen diese Umsetzung ausdrücklich voraus; sie erfinden keinen fehlenden Eingabepfad. |
| Teilnahme und Verfahren | Aktive Bewirtschaftung und Antrags-/Startdaten werden positiv geprüft. Programmgrenzen, spätere Abmeldung, öffentliche Beherrschung und behördliche Lebenszyklusentscheidungen bleiben unvollständig. Eine beantragte Korrektur oder Übernahme ersetzt keine nachgewiesene Genehmigung. |
| Meldepflichten | Einzelne unabhängige Registerpflichten werden auf Förderkategorien eingeschränkt; eine leere Pferdekennung kann als Identifikation gelten. Meldebefunde werden von einer automatisch unterstellten vollständigen Prämienkürzung getrennt. |
| Nullable Eingaben | Gültige nullable Datums- und Wurfzahlen bleiben geschützt. Die Eingabestressfehler betreffen ausschließlich schemawidrige Datumswerte. Fehlende Rechtsform wird anders behandelt als explizites null oder ein unbekannter Token. |

Alle vier Datendateien wurden vollständig gelesen: 13 Container mit 131 direkten
Zeilen einschließlich sämtlicher 27 Rassen aus Anhang D, sechs besonderer
GEP-Pflichten, 20 Tarifzeilen und zehn Tierkategorien. 32 numerische A/B-Tarifzellen
und die Milchleistungskontrollkombinationen werden einzeln geprüft. Zwei
Organisationssuffixe unterscheiden sich zwischen Quellen; die Daten folgen dem
Anhang D. Das ist eine dokumentierte Quellenvariante und kein Modellfehler.

Die gekürzte Haltedauer bis 31. August 2026 wird tatsächlich umgesetzt, während
Bewegungsmeldungen bis Jahresende getrennt fortbestehen. Hektarobergrenzen für
Flächenzahlungen werden zutreffend nicht auf diese Tierprämie angewandt.
Ausgewiesene Inhaltskürzung und Betriebsmodulation werden konsumiert. Die
50-Euro-Regel bleibt eine behördliche Ermessensfrage. Offene native Auslegungen
zur Sauenfolge, zur allgemeinen Ersatzprämienminimumregel und zu Folgen fehlender
Vorabmeldungen werden nicht durch erfundene Sollwerte geschlossen.

## Entwicklungsfälle und Eingabekompatibilität

[development-probes.json](development-probes.json) enthält 233 öffentliche
Entwicklungsfälle mit 315 Komponentenprüfungen. 230 Ausgaben sind definiert;
drei enden im ursprünglichen Laufzeitfehler. 294 Prüfungen treffen zu, 21 nicht.
Alle drei Abstürze stammen aus schemawidrigen Datumswerten; in den gezielten
Kontrollen wurde kein gültiger nullable Absturz beobachtet. Das ist kein
Totalitätsnachweis über beliebige Eingaben.

Die gezielte Auswahl aus Quellenfällen, positiven Nachweisanforderungen,
Eingabekonsistenz und ausdrücklich schemawidrigem Stress ergibt keine
Modellgenauigkeitsquote. Eine Quelle schreibt keinen OPA-Verfügbarkeitsstatus
vor. Native Prädikatsabwesenheit, rechtliches false und Laufzeitfehler bleiben
getrennt. Sämtliche Sammlungsvergleiche verwenden zur tatsächlichen Ergebnisform
passende exakte Erwartungen; kein ungültiger Objektmatcher wird benutzt.

Sieben Profilvorschläge enthalten 62 neue Blätter. Alle werden gelesen, sieben
davon ausschließlich für sichtbare Meldefindings. 156 konkrete Lesestellen,
zwei bestehende Canonical-Pfade und die dynamisch aufgelösten Datumsschlüssel
wurden geprüft; kein weiterer unvorgeschlagener Eingabepfad wurde gefunden.

Die tatsächliche App-Projektion wurde bei gesperrtem SQL-Zugriff ausgeführt.
Sie erhält keinen der sieben neuen nativen Vorschlagspfade, aber beide bestehenden
Canonical-Pfade. Die native Ausführung nach Projektion liefert eine definierte
Entscheidung mit Auszahlung 0. Das belegt die Schnittstellenlücke und keine fachliche
Nutzbarkeit. Dieser Integrationslauf zählt nicht als zusätzlicher Quellenfall.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_5 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die unabhängige Gegenprüfung steht in [quality.md](quality.md). Die separat
untersuchten [numerischen Laufzeitabweichungen](../../runtime-numeric.md) bleiben
auf die exakt gebundene Binary und ihre Kontrollen begrenzt. Keine öffentlichen
oder privaten Studienreferenzen, Expertenantworten oder Sollwerte manueller
Adaptationstests dienen als Orakel. Originale, Canonical-Profile und produktive App
bleiben unverändert. Gemeinsame Lösungen werden nach allen 26 Einzelprüfungen
zusammen durchgesehen.
