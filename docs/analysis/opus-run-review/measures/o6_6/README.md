# Einzelprüfung 8/26: Zwischenfruchtanbau

Der unveränderte Run `v2-o6_6-opus-5.5-high-20260925` bleibt für eine native
App-Aufnahme blockiert. Die Befunde werden im
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) und im
bestehenden gemeinsamen Branch gesammelt. Historische Regeln werden nicht
repariert; der Prüfabschluss erteilt keine Expertenfreigabe.

Das neue Maßnahmenmerkblatt wurde auf allen 14 Seiten einschließlich Varianten,
Tabellen, Fußnoten, Beispiele und Änderungen gelesen. Ebenso wurden alle fünf
Produktionsmodule samt Rohannahmen vollständig gelesen. Sieben identische
allgemeine Quellen werden mit Hashnachweis aus den vorangegangenen Volllektüren
wiederverwendet; aktuelle Klauseln und ihre Verbraucher wurden erneut verglichen.
Die GSP-AV gehört nicht zu diesem achtteiligen historischen Quellpaket.
Quellentreue gegenüber dem gelieferten Paket und heutige Aufnahmebedingungen
bleiben getrennte Fragen.

Die Teilberichte [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md) und [inputs.md](inputs.md) besitzen jeweils ein JSON-Ledger.
[core.json](core.json) ergänzt Auswahl, Vertrags-/Variantenzeitraum und
Gesamtausgaben. [audit.json](audit.json) erhält 114 Bewertungen aller 111 historischen IDs,
47 Profilvorschläge, 32 Tabellencontainer und 27 überlappende Befund-, Hinweis-
und Abgrenzungsgruppen. Diese Gruppen sind keine unabhängigen Fehlerzahlen.

| Bereich | Quellenvergleich und Abgrenzung |
|---|---|
| Veröffentlichte Datumsbeispiele | Variante 1 berücksichtigt ab 2025 das Maximum aus Anlage plus 70 Tagen und 15. September. Beide Beispiele stimmen: 10. August → 19. Oktober und 7. Juli → 15. September. Der Anlagetag zählt, der Umbruchtag nicht. |
| Auswahl und Prämienband | Ein beantragter qualifizierter Schlag wird bewertet, ein bekannter nicht beantragter zweiter Schlag verdient keine zusätzliche Prämie. Die Mindest-/Höchstbeträge beschreiben ein Prämienband; nur der Mindesttarif ist laut Quelle garantiert. Ein errechnetes Band ist keine amtlich festgelegte Auszahlung. |
| Begrünungsjahr | Eine ausschließlich im Vorjahr angesäte Begrünung ohne erneute aktive Anlage im aktuellen Jahr kann dennoch als aktueller Schlag prämienfähig werden. Die Quelle verlangt ausdrücklich die aktive Anlage im Begrünungsjahr. Der isolierende Gegenfall prüft diesen bekannten Einheitenausschluss und erfindet keine Inhaltsstrafe. |
| Listen und Namen | Die Roggensortenlisten geben einen damaligen Zulassungsstand wieder. Nicht aufgelistete Sorten sind nicht allein deswegen nachweislich unzulässig. Die Quelle nennt zudem Synonyme bei insektenblütigen Pflanzen; die gespeicherten Namensschlüssel und deren Verbraucher werden getrennt geprüft. |
| Beseitigung und PSM | Tabellen enthalten Varianten- und Frostbedingungen mechanischer Beseitigung. Der vorgelagerte PSM-Helfer verwendet nur einen Teil dieser Bedingungen. Ein Methodenbefund ist außerdem keine automatisch festgesetzte vollständige Prämienkürzung. |
| Pflege und Variantenpflichten | Die Problempflanzen-Ausnahme für frühes nicht-bodennahes Häckseln wird auch auf frühe Pflegemahd angewandt. Ein V7-Herbizidbefund kann nach dem Begrünungsende fortbestehen. Bei bekannter nächster Hauptfruchtdeklaration wird die Fläche bereits ausgeschlossen; die zusätzlich verlangte Streichungsdiagnose fehlt dennoch. Das sind getrennte lokale und Verfahrensbefunde. |
| Teilnahme und Flächenweitergabe | Die aktuelle gleichzeitige Teilnahme an 6 und 7 wird gemeldet, aber nicht vom Farmprämiengate konsumiert. Frühere wirksame Abmeldung, künftiger Vertragsbeginn und Transfers nach bereits vollständig erfüllten Variantenpflichten benötigen einen korrekten Zeitbezug. Eine nach Kontrollankündigung unwirksame Abmeldung ist hingegen kein automatischer Zahlungsstopp: Der bestehende Vertrag kann fortbestehen. |
| Regionale Dürre-Ausnahme | Die Gebietsliste ist vollständig. Der regionale Helfer erfasst jedoch weder den dürrebedingt nicht erntbaren Bestand noch die betroffenen Spätsommer-/Herbstkulturen. Seine derzeitige Wirkung ist ein unterdrückter Hinweis. Positive Gebietskontrollen setzen die weiteren Voraussetzungen ausdrücklich voraus und belegen keine vollständige Prämienentscheidung. |
| Finanzielle Reichweite | Inhaltsstufe und Modulation werden tatsächlich verrechnet. Für eine fachlich richtige Modulation muss die relevante Heimfläche von getrennt behandelter Almfläche abgegrenzt sein. Die ausgegebene Kürzungsliste belegt keine vollständig ausgeführte Endabrechnung. Das 50-Euro-Flag prüft nur das untere Bandende; bei einem Band über die Schwelle hinweg ist die tatsächliche Ermessensvoraussetzung offen. |
| Quellenkonflikte | Die Rohannahmen legen Konflikte zwischen SRL und Merkblatt bei Walzterminen und Beseitigung offen. Eine vertauschte Fristenreihenfolge im Augusthinweis 2026 wird mit dessen eigenem Beispiel und dem Maßnahmenblatt abgeglichen. Offene rechtliche Hierarchiefragen werden nicht als eindeutiges Goldlabel geschlossen. |

Die sechs Datendateien enthalten 32 Inventarcontainer und 278 direkte
Zeilen/Schlüssel. Die historische Zahl 280 zählt in einem Ausnahmeobjekt dessen
dreigliedrige Maßnahmenliste einzeln statt als einen direkten Schlüssel. Diese
Zähldifferenz sind keine zwei fehlenden Datensätze. Arten-/Sortenlisten umfassen
33 ausdrücklich offene Insektenbeispiele, sieben Schlüssel für Kulturen der Variante 6,
vier österreichische und 19 EU-Roggensorten, vier Problempflanzen sowie elf
Getreidearten. Die gespeicherte Kombinationstabelle hat 21 Zeilen und 134
positive Zellen; implizite Leerpaare sind keine zusätzlich gespeicherten Zeilen.

## Entwicklungsfälle und Eingabekompatibilität

[development-probes.json](development-probes.json) enthält 391 öffentliche
Entwicklungsfälle mit 438 Komponentenprüfungen. 378 Ausgaben sind definiert;
13 enden im ursprünglichen Laufzeitfehler. 371 Prüfungen treffen zu, 67 nicht.
Zwölf Abstürze betreffen gültige nullable Angaben: elf neue Vorschlagsfelder
und ein bestehendes Canonical-Saatdatum. Nach Ausführungspfad sind es elf
Hauptentscheidungen und ein gesonderter Helfer für permanente Umstände.
Der zusätzliche Ereignisdatum-null-Absturz liegt außerhalb des Schemas.

Die Auswahl aus bekannten Quellenfällen, gewünschten positiven Nachweisen,
Robustheitskontrollen, bedingten Namens-/Evidenzverträgen und schemawidrigem
Stress ergibt keine Modellgenauigkeitsquote. Für die synthetisch stipulierte
zusätzliche amtliche Roggensortenzulassung wird keine echte neue Sorte oder
Abnahme behauptet. Technische Verfügbarkeit ist keine quellenrechtlich
vorgeschriebene OPA-Ausgabe; rechtliches false, Prädikatsabwesenheit und Fehler
bleiben getrennt. Objektmatcher werden nur auf echte `rule_id`-Objekte angewandt;
verschachtelte String-ID-Arrays verwenden exakte passende Erwartungen.

47 Profilvorschläge enthalten 72 neue Blätter. 71 werden gelesen;
`following_main_crop.crop_name` bleibt ungenutzt. 193 konkrete Lesestellen und
zehn zusätzlich gelesene Canonical-Pfade wurden geprüft. Fünf neue Blätter wirken
nur in separaten Helfern oder Hinweisen: die drei Angaben zu besonderen
Umständen, der Ernteanteil und das Saatverfahren der Folgekultur. Die
Schlagmaßnahmenliste speist die sichtbaren Kombinationsbefunde; diese sind
keine automatisch festgesetzte Prämienkürzung.

Die tatsächliche App-Projektion wurde bei gesperrtem SQL-Zugriff ausgeführt.
Sie erhält keinen der 47 neuen nativen Vorschlagspfade und sechs der zehn
zusätzlich gelesenen Canonical-Pfade. Verloren gehen beide Regionsangaben,
der verschachtelte Kulturname und das native Begrünungs-Saatdatum. Ähnliche
anders benannte Felder gelten ohne nachgewiesene Abbildung nicht als erhalten.
Der separate native Lauf nach Projektion erreicht zwar die Ackerflächen-
Mindestgröße, findet aber keinen beantragten Begrünungsschlag: Vertrag erlischt,
leere Schlagergebnisse, Prämienband 0/0. Das dokumentiert die Schnittstellenlücke
und keine fachliche Nutzbarkeit. Der Integrationslauf zählt nicht als weiterer
Quellenfall.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_6 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Die unabhängige Gegenprüfung steht in [quality.md](quality.md). Die gesondert
untersuchten [numerischen Laufzeitabweichungen](../../runtime-numeric.md) bleiben
auf die exakt gebundene Binary und ihre Kontrollen begrenzt. Fehlende Nachweise,
nachgewiesene Verstöße, native Ausgabelücken und schemawidriger Stress bleiben
getrennt. Keine öffentlichen oder privaten Studienreferenzen, Expertenantworten
oder Sollwerte manueller Adaptationstests dienen als Orakel. Originale,
Canonical-Profile und produktive App bleiben unverändert. Gemeinsame Lösungen
werden nach allen 26 Einzelprüfungen zusammen durchgesehen.

Die nachträgliche [Metadatenkorrektur](measure.md) berichtigt ausschließlich den
ATB-Lesebereich von 25 auf die tatsächlichen 21 PDF-Seiten. Quellenfälle und
fachliche Urteile bleiben gleich; Sammlung und Replay werden neu gebunden.
