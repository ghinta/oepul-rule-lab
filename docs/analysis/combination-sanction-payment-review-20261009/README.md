# Block 7: Kombination, Sanktion und Zahlung

Stand 09.10.2026, Europe/Vienna. Gezielte Vertiefung der 26 einzeln geprüften Maßnahmen
auf Draft #103, Ausgangscommit `b0eda09c2233f7178e456de4f667667a634683e8`.
Aktuelle App: `5296108f5756ef1463c25a49d93d4a346e9b5e9c`.
Historische Originale: `7a296d28cb5b92e2758c5a3889c929ea1db60fe5`.

**Eine positive Basisprüfung ist noch kein vollständiger Maßnahmen- oder Zahlbetrag.**
Die aktuelle generische Einzelprüfung berechnet keine Prämien und konsumiert die
Kombinationstabelle nicht. Der bestehende Szenariopfad annotiert Maßnahmenpaare,
ohne tatsächliche gemeinsame Flächen, Teilbetriebsbereiche oder Tierkategorien zu
prüfen oder Einzelstatus zu ändern. Native o6_3 berechnet einen ausdrücklich
indikativen Bruttobetrag; der aktuelle Gesamtergebnisadapter hält `missing_data`
und alle acht offenen fachlichen Blocker aufrecht. Die geprüfte Übersicht zeigt
Status und Gründe, keinen tatsächlichen EUR-Zahlbetrag.

## Vorher und benötigte Ergänzung

Diese Ergänzungen sind vorbereitete fachliche Verträge, keine neuen Canonical-Pfade.

| Bisheriger Iststand / häufiger verkürzter Begriff | Benötigte fachliche Unterscheidung | Prüfbare Auswirkung |
| --- | --- | --- |
| Maßnahmenstring oder positives Basisresultat | Tatsächlich wirksamer Vertrag, jährlicher Antrag, Option, Teilbetriebsbereich und Förderjahr | Pflichtkombination und Betriebsverbot nur im echten Scope. |
| Ein globales Maßnahmenpaar | Betriebszulässigkeit, Einzelflächenprämienkombination, Auflagenkombination, Tier-/Almkategorie | L-Matrix ist kein universelles Betriebsverbot. Ausnahmen brauchen reale Überlappung. |
| DIV-Gesamtfläche | Quotenanrechnung, Basismodulfläche, Zuschlagsfläche und LSE-Abgeltung | NAT/EBW/BAW/AG können anders angerechnet als bezahlt werden; kein doppelter Zuschlag. |
| Einfach Fläche × Rate | Nettofläche, Einheit, Tier-/Personen-/Mengenbasis, Tarifjahr, beantragte Option und regionale Bedingungen | ha, PLSE, GVE/RGVE, m³, Person, Betrieb und Alm nicht beliebig austauschbar. |
| Prämienband oder historische Tabellenrate | Jahresgültiger Satz, Band, garantierter Mindestbetrag, budgetabhängige Festlegung | Aktuelle Art 31-/70-/72-Zuordnung berücksichtigen; obere Bandgrenze ist keine garantierte Auszahlung. |
| Beliebig hintereinander angewandte Faktoren | Geordnete Kürzung, Maßnahmenkappe, Modulation, gemeinsame Einzelflächenkappe und weitere Schritte | Die Reihenfolge verändert das Ergebnis. Keine globale 1300-EUR-Betriebskappe. |
| Kontrollfeststellung oder Verstoß-Bool | Betroffene Pflicht/Option, Feststellungs-/Kontrolljahr, Umfang, Schwere, Wiederholung und tatsächliche Entscheidung | Kein automatisch gewählter Höchstsatz und kein unknown→0/okay. |
| Betrag oder bestätigte Eingabe | Indikativer Bruttobetrag, noch offene Berechnung, behördliche Festsetzung, Teilzahlung, Buchung und Rückforderung | Status/Provenienz bleiben nachvollziehbar; eine Eingabe erzeugt keine AMA-Zahlung. |
| Gerundete Summe | Präzision, Einzelpositions-/Summenrundung und Stufenrundung | Konkreter technischer Centunterschied bleibt offene fachliche Entscheidung. |

## Konkrete aktuelle App-Diagnosen

1. Generische UBB/BIO-Fälle liefern positive Basisstatus ohne allgemeinen
   Prämien-/Sanktions-/Zahlungsvertrag. Ergänzte ausdrücklich noch nicht registrierte
   synthetische Finanzobjekte erreichen die generische Policy nicht. Dies sind
   Diagnosefelder, keine vorhandenen oder vorgeschlagenen verbindlichen Pfade.
2. Derselbe EBW-Schlag mit 0,5 ha einmal ergibt `not_eligible`; zweimal mit derselben
   `parcel_id` ergibt 1,0 ha und `eligible`. Das ist Identitäts-/Basisproxy-Drift,
   keine heute ausgeführte doppelte Prämienzahlung. Native o6_3 weist doppelte IDs,
   negative Flächen und NaN bereits mit vorhandenem Pydantic vor OPA zurück.
3. Der originale Kombinationshelper behält UBB/BIO-Einzelstatus `eligible`, ergänzt
   aber `relation_label=not_combinable`. `active` bezeichnet dort nur zwei positive
   Einzelstatus. Eine Tiermaßnahme außerhalb L bleibt `not_evaluated`, nicht verboten.
4. Native o6_3: 11 anrechenbare ha × gepinnte 2026-Bruttorate 145,8 ergeben
   1603,80 EUR; mit Option 167,4 ergeben sich 1841,40 EUR. Unbeantragtes 3-ha-Feldfutter
   wird ausgeschlossen. Keine allgemeine Förderfähigkeit/Kombination/Sanktion/Zahlung
   bestätigt; `SOURCE_CURRENTNESS` bleibt offen.
5. Native Aggregation 8,003+3,003 ha mit 145,8 ergibt 1604,67 EUR. Illustrative getrennte
   Cent-Rundung ergäbe 1604,68 EUR. Dieses Vergleichsergebnis ist kein fachlicher
   Sollwert. Der separate UBB-Grenzbefund aus Block 6 bleibt eigene Folgearbeit.

[53 genaue Codeanker / 28 geprüfte Dateien](app-paths.json) und
[synthetische Beobachtungen mit Eingaben/Ergebnissen](policy-observations.json)
machen diese Befunde reproduzierbar. Es gab keinen HTTP-/DB-/Browser-Durchlauf,
keine realen Betriebszahlungen und keine Golden-Qualitätsmessung.

## Historische Originaltabellen und Quellenkonflikte

Der [vollständige App-CSV-Abgleich](app-matrix-comparison.json) bestätigt alle 441
historischen gerichteten Zellen einschließlich Symbole und Zellfußnoten ohne
fehlende, zusätzliche oder doppelte Einträge. Die Ausführungslücke liegt damit
im Scope und in fehlendem Kontext: globale Fußnoten 2 (Topf/Substrat) und 4
(Wien/PSM-Verzicht/BAW/AG) sind im CSV nicht vollständig enthalten. Die vorhandene
Konvention `not_combinable` für Leerstellen betrifft Einzelflächenprämien und
beweist kein allgemeines Betriebsverbot. Das im CSV referenzierte PDF fehlt am
App-Pin; Originalbeweise kommen hier aus der bytegleichen lokalen Lab-Quelle.

[Anhang L](combination-audit.json) ist für die gehashte lokale Fassung 11.10.2024
vollständig aus PDF-Koordinaten aufgenommen und gegen eine separate visuelle
Zeilentranskription geprüft: **21×21=441 Zellen**,134 markiert und 307 leer,
einschließlich Diagonalen und vier Fußnoten. Die fünf Tiermaßnahmen 5/15/20/21/22
stehen nicht in dieser Einzelflächenmatrix. Leerstellen sind erhalten und
begründen kein automatisches Verbot im gesamten Betrieb. Anhang J ist zusätzlich
mit allen 64 Code-Kombinationszellen erfasst; `T→A` ist eine belegte Codeabbildung,
kein Alias für fachlich andere Auflagen oder beliebige Kombination im selben Kapitel.

[Prämienbasis](payment-basis.json) belegt alle 29 genannten Prämienseiten der 16
UBB/BIO-/Flächen-/Betriebsmittelmaßnahmen einschließlich Fußnoten. Diese Vollseiten
sind kein normalisierter freigegebener Tarifkatalog. Die übrigen zehn Maßnahmen
sind in der [Scopematrix](scope-matrix.json) geprüft; bestehende Originaltabellenaudits
bleiben mit Hash und genauem Teilscope referenziert. Die seltenen Nutztierrassen
haben zusätzlich alle 80 historischen Tarifpositionen:54 Zahlen und 26 ausdrücklich
nicht anwendbare Striche. Strich ist kein Null-Euro-Satz.

Vier allgemeine [Rechenbeobachtungen](payment-arithmetic.json) unterscheiden
gedruckte Beispiele und ein ausdrücklich synthetisches Reihenfolgebeispiel.
Das Behirtungsmerkblatt nennt 2295 EUR, die gedruckten Faktoren ergeben 2430 EUR;
entsprechende Gesamtsummen differieren um 135 EUR. Allgemeine Bedingungen nennen
für 230 ha/250 RGVE 98,66%, während die Formel 98,70% auf zwei Dezimalstellen ergibt.
Beide Konflikte bleiben offen. Keine automatisch korrigierten Golden-Erwartungen.

## Aktueller Rechtsstand als getrennte Beobachtung

Fünf [gezielte Onlinebeobachtungen](evidence.json) ergänzen die historischen Quellen.
SRL/Anhänge 01.10.2026 und der heutige RIS§48 wurden auf relevante allgemeine
Kombinations-/Zahlungs-/Sanktionspassagen geprüft. Die volle aktuelle 441-Zellen-Matrix,
alle aktuellen Tariftabellen und das individuelle automatisierte Sanktionsschema
sind damit nicht vollständig aufgenommen. Online-PDF-Fließtext bestätigt keine
sichere Spaltenzuordnung; keine heruntergeladenen Onlinebytes oder SHA-Hashes behauptet.

Wichtige Grenzen: Einzelflächenkappe für Art 70/72 mit Ausnahmen und LSE, zuerst
Maßnahmenkappe, danach Modulation, danach gemeinsame Einzelflächenkappe. Alm 14/15
nutzen für Modulation eine eigene gemeinsame Alm-Betriebsbasis gegenüber Heimflächen.
Art 31-Bandscope änderte sich 2025:1 C hinzu, 10 zu festen Art 70-Sätzen. Optionaler
UBB-Bio-Zuschlag 2027 bleibt Zukunftsnotiz. PSM-Verwendungsangabe als separate
inhaltliche Verpflichtung entfällt bereits 2026; maßnahmenspezifische PSM-Verbote
entfallen dadurch nicht. Der 1%-Einbehalt statt Verwarnung beginnt erst 2027.

Heute verlinkter§48 unterscheidet Pflichtbefund, Stufen und wiederholte Verstöße,
Addition bis 100%, optionsbezogenen Scope und tatsächliche Fallbeurteilung. Quelle
verleiht dem Kontrollorgan keine eigene Rechtsfolgenentscheidung. Fehlender
jährlicher Antrag beendet mehrjährige Bindung zunächst nicht. Ein Auszahlungsbetrag
bis 50 EUR ist Ermessensregel, keine zwingende Null-Euro-Regel für jede Maßnahme.
Die AMA-Mitteilung 09.01.2026 bezieht sich auf 2025-Zahlungen/Nachberechnungen;
Förderjahr, Zustellung und Buchung bleiben getrennt. Tatsächliche Nachbeantragung
und Einspruch benötigen den echten fristauslösenden Zugang.

## Herkunft und nächste Schritte

Dokumentierte Experten-/Betreiberwerte gehen AMA-Werten vor; Abweichung allein
blockiert sie nicht. Dokumentierte Aggregate bleiben zulässig. Auto-Werte werden
gemäß bestätigter Entscheidung im eigenen Auto-Snapshot ausgewertet. Derselbe
fachliche Vertrag gilt für jede Eingabequelle. Eingabeherkunft und rechtlich
wirksame Festsetzung unterscheiden sich: manuelle Erfassung eines Bescheids ist
zulässig, Auto setzt keine echte Behördenentscheidung oder Zahlung in Gang.
Neu angelegte Flächen/Elemente behalten stabile IDs und die sichtbare Markierung
„Neu angelegt – Experte / Betreiber / Auto“. Der heutige Generator-Evaluation Run
ist noch kein eigener FarmProfileSnapshot.

[Restfragen](questions.md) und [158 echte bestehende Verweise](coverage-index.json)
(104 direkt / 54 eng begrenzte Querverweise) werden im Sammelissue 140 ergänzt.
Alle 289 Originalfragen und exakt acht offene o6_3-Blocker bleiben bytegleich.
UBB besitzt keine frühere genuine allgemeine Zahlungsfrage; die gemeinsame
Klärung wird sichtbar ergänzt. Teilscopes sind keine globalen UND-Gates.

Damit sind die gemeinsamen Blöcke 1–7 als Quellen-/Istpfadvorbereitung erfasst.
Als Nächstes werden gemeinsame Entscheidungen und maßnahmenspezifische Ausnahmen
zusammengeführt. Die fachlich bestätigten Mengen-/Identitäts-/Zeit-/Einheitenverträge
tragen danach Editor, Adapter und konsumierende einzelne Regeln. Der EBW-Dublettenbefund
und der UBB-Präzisionsbefund bleiben ausdrücklich technische Folgearbeiten; konkrete
Ergebnis-/Rundungsentscheidungen werden nicht vorweggenommen. Erst danach unabhängige
bewertete Fälle/Golden-Tests und Luna–Opus-Qualitätsvergleich, keine bloße
Übernahme historischer Modellbehauptungen. Vor Merge bleibt separate Freigabe nötig.

[Prüfgrenzen](verification.md), [maschinelle Verifikation](verification.json),
[kurze Gründe](reasons.md). Keine App-/Policy-/Canonical-/Thesisänderung,
kein Modelllauf und kein Merge; Drafts 102/103 bleiben offen.
