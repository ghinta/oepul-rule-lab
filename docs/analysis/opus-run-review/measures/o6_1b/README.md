# Einzelprüfung 2/26: Biologische Wirtschaftsweise (o6_1b)

Der unveränderte Run `v2-o6_1b-opus-5.5-high-20260925` ist für eine native
App-Aufnahme weiterhin blockiert. Diese Prüfung sammelt Befunde für
[Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112). Sie repariert
keine Regeln und erteilt keine Expertenfreigabe.

Geprüft wurden das vollständige BIO-Original mit 51 Seiten, sämtliche elf
Produktionsmodule, alle 200 Katalogregeln, 92 Datentabellen und 89
Profilvorschläge mit 192 neuen Blattpfaden. Die sieben gemeinsamen Quellen
haben exakt dieselben Hashes wie beim UBB-Audit. Der dort dokumentierte
vollständige Lesedurchgang wird gebunden wiederverwendet; BIO-relevante
Abschnitte, Kombinationen und tatsächliche Verbraucher wurden erneut geprüft.
Die Tabellenprüfung umfasst alle 940 direkten Zeilen/Schlüssel einschließlich
verschachtelter Inhalte. Das sind Daten-/Reviewumfänge, keine Korrektheitsquote.

Die vollständigen Teilprüfungen stehen in [general.md](general.md),
[measure.md](measure.md), [tables.md](tables.md) und [inputs.md](inputs.md),
jeweils mit einem maschinenlesbaren Ledger gleichen Namens. [core.json](core.json)
ergänzt gemeinsame Flächenbasis und Satzwahl. Überlappende Beurteilungen bleiben
in [audit.json](audit.json) erhalten; 43 Teilbefunde sind keine 43 disjunkten
Fehlerursachen.

## Für die gemeinsame Auswertung relevante Befunde

| Bereich | Beobachtung / Beleg |
|---|---|
| Teilnahme und Zeit | Fehlende Vertrags-/Antrags-/Kontrollvertragsangaben können mit positivem `compliant` vereinbar bleiben. Vertragshilfen und Zahlungsfolgen steuern das ausgewiesene Ergebnis nicht vollständig. Definierter Teilflag, vollständiges Ergebnis und Betrag werden getrennt beurteilt. |
| Flächenumfang | Konventioneller Teil eines Bio-Teilbetriebs und ausländische Flächen sind nicht in allen Grundlagen konsequent getrennt. Der Nenner kann sich trotz Ausschluss von direkten Prämien ändern. |
| Maßnahmenkombination | Die gespeicherte Anhang-L-Zeile wird nicht ausgeführt. NAT/EBW sowie BAW/AG ohne DIV können BIO-Flächenprämie erhalten, obwohl nur LSE-Abgeltung kombinierbar ist. |
| Dürre-/Prämienbezug | OPUBB kann im BIO-Run eine Dürre-Ausnahme öffnen, ohne den BIO-Prämienzweig zu schließen. Der gepaarte OPBIO/OPUBB-Konsistenzfall prüft ausschließlich dieses Verhältnis. |
| Identität | SLK wird nicht an die Kultur gebunden; die Streifen-Ausnahme ist nicht auf die zwei genannten Mohnsorten begrenzt. Einzelne Tomaten-/Raps-/Maisbezeichnungen werden trotz vorhandener anderer Normalisierungstabellen falsch behandelt. |
| Physische Fläche | Ein zugleich als DIV und artenreich gekennzeichneter Schlag kann beim Kreislaufzähler doppelt zählen. Ein zusätzlicher Status erzeugt keine zweite Fläche. |
| Nutzungen und Termine | WB-Verbotsende ist am 30. Juni nicht inklusiv; DIVNFZ kann den Abschluss aus der ersten Mahd erfinden und verlangt den Abtransport der zweiten Mahd nicht vollständig. Düngungsverbot bleibt nach erlaubtem Umbruch aktiv. |
| Unbekannt und Typ | `slope_percent:null` kann eine Standortprüfung bestehen. Nullwerte für Phänologie, Erstjahr oder Feldstück-GLÖZ-Fläche führen zu drei reproduzierten Laufzeitabbrüchen. |
| Tierhaltung | Zertifizierte Eigenbedarfstiere werden von der Ausnahmegrenze für nicht zertifizierte Tiere erfasst. Eine konventionelle Equidengruppe mit null Tieren kann als tatsächliche Mischhaltung gewertet werden. Zertifizierung allein beweist nicht alle Haltungsvorschriften. |
| Externe Nachweise | Arten-/Familienzähler und andere Vorentscheidungen werden übernommen, ohne die vollständige zugrunde liegende Prüfung selbst durchzuführen. Ein neuer App-Vertrag müsste diese Herkunft sichtbar binden. |

Es gibt auch wichtige Unterschiede zu UBB: BIO enthält echte Kultur-/
Erosionsnormalisierungstabellen; der betreffende Reinigungsschnitt ist anders
modelliert und wird nicht mit derselben UBB-Fehlerbehauptung versehen. Die
10-ha-Ersatzerfüllung verwendet eine andere Auslegung desselben Quellenkonflikts.
Diese Unterschiede bleiben für die spätere gemeinsame Lösung erhalten.

## Entwicklungsfälle und Reproduktion

[development-probes.json](development-probes.json) enthält 107 öffentliche,
Entwicklungsfälle mit 108 Komponentenprüfungen. Der Fall vor dem ersten
Prämienjahr bindet nur die native Darstellung, keine rechtlich vorgeschriebene
Repräsentation als `undefined`. Der korrekte
Verzeichnislader ergibt 101 definierte Ausgaben, drei ausdrücklich erhaltene
undefinierte Ergebnisse und drei Laufzeitfehler. 59 Erwartungen treffen zu,
49 nicht. Gezielt gewählte Gegen-/Fehlerfälle und Fälle des gewünschten
positiven Nachweisvertrags ergeben keine Modellgenauigkeitsquote.

Die drei undefinierten Ergebnisse sind getrennt erklärt: vor dem ersten
Prämienjahr gibt es keinen vollständigen Result-Wert; zwei direkte
Standortprädikate sind bei fehlender bzw. zu hoher Hangneigung nicht definiert.
Das ist nicht derselbe Zustand wie ein JSON-Wert `false`, `null` oder ein Fehler.

Kontrollen decken unter anderem richtige Jahresstaffeln, Antrags-/
Kontrollvertragsgrenzen, 25-%-Beteiligung, RGVE-Grenzen, zulässige
Eigenbedarfsmengen, Abgang/Zugang und Sanktionsjahre ab. Die 44 Eingabeproben
und anderen Teilproben sind in diesem einen Satz enthalten und werden nicht
zusätzlich aufsummiert. Keine privaten Studienfälle oder Selbsttestlabels.

Vier RGVE-Rechenkontrollen verwenden absichtlich einen gebrochenen
`animal_count`, um Jahresdurchschnitts-Arithmetik zu isolieren. Die eingefrorene
Canonical-Deklaration verlangt dort eine ganze Kopfzahl. Diese vier Fälle sind
deshalb ausdrücklich Typ-/Einheiten-Stresstests und keine freigegebenen realen
Betriebseingaben; eine Jahresmittel-Abbildung bleibt gesondert zu prüfen.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_1b \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Der gemeinsame Prüflader wurde zusätzlich gegen die vollständig gebundene
ursprüngliche BIO-Diagnose geprüft. Nur das Laden der ursprünglichen
Verzeichnisstruktur erhält den Daten-Namensraum. Eine vorläufige falsche
Einzeldatei-Ladung wurde vor Abschluss verworfen; ihre Ausgaben werden nicht
als Modellbefunde verwendet. Die neue Vorprüfung schützt diesen Unterschied.
Die [numerischen Laufzeitabweichungen](../../runtime-numeric.md) bleiben als
gesonderter Befund der gepinnten Binary erhalten.

Die tatsächliche App-Projektion wurde mit gesperrtem Datenbankzugriff
ausgeführt: keiner der 89 nativen Vorschlagspfade wird übernommen. 191 von
192 vorgeschlagenen Blättern werden im nativen Code gelesen, eines bleibt
ungenutzt; acht Eingaben wirken nur in nicht ausgegebenen Helfern. Die
historische Canonical-Datei und die produktive App wurden nicht verändert.

Die getrennte [Qualitätskontrolle](quality.md) hat Bindungen, Vollständigkeit,
Quellenzitate und den abschließenden Replay geprüft.

Die gemeinsame Ursachen- und Lösungsdurchsicht folgt nach dem Gesamtdurchgang.
Offene Quellenfassungen, Arten-/Projektidentitäten und Rechtsfolgen werden
dabei als offene Entscheidungen geführt, nicht durch Defaults ersetzt.
