# Einzelprüfung 5/26: Heuwirtschaft

Der unveränderte Run `v2-o6_3-opus-5.5-high-20260930` wird im
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) geprüft.
Die native App-Aufnahme bleibt blockiert. Diese Prüfung sammelt Befunde; sie
repariert keine Regel und erteilt keine Expertenfreigabe.

Gelesen wurden das vollständige sechsseitige Maßnahmenmerkblatt und alle sieben
Produktionsmodule; alle 74 Katalogregeln, 35 Tabellencontainer und 34 Profilvorschläge
sind einzeln erfasst. Die sieben gemeinsamen Quellen sind mit ihren früheren
vollständigen Lesedurchgängen hashgebunden; die einschlägigen Passagen und
aktuellen Verbraucher wurden erneut abgeglichen. Die detaillierten GSP-/MOG-
Texte und das referenzierte Konditionalitätsmerkblatt fehlen im ursprünglichen
Paket. Insbesondere wird die erstmals bei o6_1c gelieferte GSP-AV diesem Run
nicht rückwirkend als Modelleeingabe zugerechnet.

Die Teilberichte [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md) und [inputs.md](inputs.md) besitzen jeweils ein JSON-Ledger.
[core.json](core.json) ergänzt die gemeinsame Flächenauswahl und Gesamtentscheidung.
[audit.json](audit.json) erhält 85 Bewertungen der 74 historischen IDs und 32
überlappende Teilbefunde; sie sind keine unabhängigen Fehlerzahlen. Zusätzliche Quellenpflichten außerhalb des
historischen Katalogs bleiben im Maßnahmenledger ausdrücklich separat.

| Bereich | Quellenvergleich und Abgrenzung |
|---|---|
| Mahd und Antragsjahr | Das veröffentlichte 8+2+3-ha-Beispiel liefert korrekt 11 prämienfähige ha und 1.603,80 Euro. Enthält das ausdrücklich abgeschlossene Jahresprotokoll für die 8 ha nur einen Vorjahresschnitt, bleiben dennoch 11 ha stehen. Die leere Gegenkontrolle lässt richtig nur die 3 aktuell gemähten Ackerfutter-ha zu. |
| Futter und Maschinen | Die einzelnen Silage-, Gärungs-, Lager- und Transferverbote sowie die Verzichtsoption besitzen zahlreiche funktionierende Kontrollen. Vollflächige Nutzung, Abtransport und die Vereinigung von Grünfütterungs-/Almtagen für alle Tiere benötigen zusätzliche Belege. Die Quelle gibt keine erfundene Mindeststundenzahl je Tag vor. |
| Prämienausschlüsse | VF und die zusätzliche UBB-Acker-DIV-Bedingung werden nicht vollständig als Prämienausschlüsse ausgeführt. Eine richtige Matrixzelle ersetzt diese Zusatzbedingungen nicht. Die Parkauflagenprüfung ist gegenüber o6_2 verbessert; eine abweichende Parknamenszeichenfolge bleibt dagegen ein bedingter Identitätsbefund. |
| Höhe und Kürzungsstufe | Alle acht Tarife stimmen. Der Cap-Hinweis verwendet den Rohsatz vor der vorgeschriebenen Modulation und meldet im gezielten 220-ha-Gegenfall eine Überschreitung trotz Betrag unter 1.300 Euro. Der ausgegebene Betrag heißt ausdrücklich „nach Modulation“; fehlende weitere Kürzungsstufen werden als Aufnahmegrenze dokumentiert und nicht als versprochene endgültige Auszahlung umgedeutet. |
| Vertrag und Rückabwicklung | Aktuelle Jahre und Kontrollsperren sind besser gebunden als in manchen Vorgängern. Der Erstjahresindikator `contract_established` ist kein allgemeiner Fortbestandsindikator. Bekannt verspätete Erstanträge, tatsächliche Vertragsbeendigungen und Rückforderungsfolgen werden gesondert geprüft. |
| Durchschnittstiere | Ein eigenes numerisches `average_count` unterstützt auch Bruchteile eines vorab berechneten Jahresmittels. Das ist eine vorhandene Verbesserung. Herkunft, Referenzzeitraum und die Einordnung in den RGVE-Schlüssel benötigen weiterhin einen belegten Vorverarbeitungsvertrag. |
| Fehlende Angaben und `null` | Günstige Defaults ersetzen an mehreren Stellen fehlende Nachweise. Fünf ausdrücklich erlaubte Nullable-Zahlenzustände erzeugen Arithmetikfehler; vier betreffen die Hauptentscheidung, einer den getrennten Cap-Helfer. Zwei weitere Abstürze liegen außerhalb des historischen Schemas. |
| Höhere Gewalt | Die Dürre-Antragsmöglichkeit und der eAMA-Kanal werden erkannt. Ein einziges Anerkennungsflag löscht jedoch sämtliche wirksamen Verstöße. Ob die Anerkennung alle betroffenen Pflichten und Zeiträume umfasst, ist nicht darstellbar; dafür wird kein erfundener behördlicher Umfang als Sollwert eingesetzt. |

Alle 13 Datendateien, 35 Tabellencontainer mit 385 direkten Zeilen und sieben
weitere Metadatencontainer wurden einschließlich verschachtelter Werte gelesen.
Die sparse Kombinationsmatrix enthält korrekt 134 Nichtleerzellen und 286
implizite Leerpaare. Fehlende Einträge bedeuten hier unzulässige Kombinationen.
Alle 20 RGVE-Faktoren und die ausdrücklich gelisteten Futterbeispiele wurden
vollständig kontrolliert.

## Entwicklungsfälle und Eingabegrenze

[development-probes.json](development-probes.json) enthält 158 öffentliche
Entwicklungsfälle mit 166 Komponentenprüfungen. Die vollständige Ausführung mit
dem unveränderten Kandidaten und der exakt gepinnten OPA-Binary ergibt 151
definierte Ausgaben und sieben Laufzeitfehler. 129 Prüfungen treffen zu, 37 nicht. Quellenfälle,
positive Nachweisanforderungen, Robustheitskontrollen und schemawidriger Stress
bleiben unterscheidbar. Diese gezielte Auswahl ergibt keine Modellgenauigkeitsquote.
Die separaten [numerischen Laufzeitabweichungen](../../runtime-numeric.md)
werden nicht als zusätzliche fachliche Modellfehler gezählt.

34 Profilvorschläge enthalten 65 neue und ein geändertes Blatt. 65 Blätter werden
gelesen; die erweiterte Tierart bleibt ungelesen, weil die RGVE-Kategorie allein
maßgeblich ist. 107 Lesestellen einschließlich zwölf dynamischer Flag-Zugriffe
und sieben bestehende Canonical-Pfade wurden geprüft. Die tatsächliche,
mit gesperrtem Datenbankzugriff ausgeführte App-Projektion erhält keinen der
33 neuen Vorschlagspfade. Nur das bestehende Tierartfeld bleibt erhalten;
seine Enum-Erweiterung erzeugt keine native Nutzung. Die anschließende native
Ausführung mit dieser Projektion scheitert separat. Dieser Integrationslauf
wird nicht als zusätzlicher Quellenfall gezählt.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_3 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die getrennte Gegenprüfung steht in [quality.md](quality.md).
Historische Selbsttests, öffentliche/private Studienreferenzen und Test-Sollwerte
der manuellen Heuwirtschaftsanpassung wurden nicht als Quellenorakel verwendet.
Originale, Canonical-Profile und produktive App bleiben unverändert. Gemeinsame
Lösungen folgen nach dem vollständigen Durchgang der 26 Runs.
