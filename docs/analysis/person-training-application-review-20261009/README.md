# Block 6: Personen, Kurse und tatsächliche Anträge

Stand 09.10.2026, Europe/Vienna · gezielte Vertiefung der vorhandenen
Einzelprüfungen · App-Pin `5296108f5756ef1463c25a49d93d4a346e9b5e9c` ·
historische Quellenbasis `7a296d28cb5b92e2758c5a3889c929ea1db60fe5`.

Die aktuelle App kann bei UBB, BIO, Almbewirtschaftung, Humuserhalt und EBW
einen positiven Basisstatus liefern, obwohl Personen-, Kurs- und tatsächliche
Antragsnachweise fehlen. Teilweise vorhandene AMA-Antragsdaten werden bei der
Aufbereitung reduziert und erreichen die generische Policy nicht. Die gemeinsame
Grundlage muss deshalb tatsächliche Person, Bildungsereignis, Anrechnung,
Antrag und bestätigten Vertragszustand verbinden. Die fachliche Auswertung bleibt
maßnahmenspezifisch.

Dieser Bericht ergänzt die [26 Einzelprüfungen](../sequential-variable-reviews-20261008/README.md)
und [Block 5](../authority-project-review-20261008/README.md). Er ändert keine
App-Regel, keinen Canonical-Pfad und keine Aufnahmeentscheidung. Öffentliche
Quellen belegen Anforderungen; echte individuelle Betriebsanträge und
Kursbestätigungen liegen hier nicht vor.

## Vorher / benötigte Ergänzung

| Geprüfter heutiger App-Stand | Aussage und Grenze | Benötigter Vertrag |
| --- | --- | --- |
| RAW `ama_raw_d619_23_st_oepul_mana` | Eingang, Berechnungsstatus, Abmeldung, abgebender Betrieb und Übernahmekommentar existieren teilweise als Rohspalten. | Tatsächlicher Maßnahmen-/Options-/Kategorieantrag mit stabiler Identität, MFA-/Förderjahr, Eingang, Status, Beginn, wirksamer Abmeldung und Übernahmekette; keine Statusableitung allein aus einem vorhandenen Rohdatensatz. |
| `ama_additional.farm.oepul_mana[]` | Builder übernimmt Code, Bezeichnung und Verpflichtungsbeginn und dedupliziert. Die generische Policy-Projektion übernimmt diese Liste nicht. | Antragsereignis, Genehmigungsverständigung und aktueller Vertragszustand getrennt erfassen und verlustfrei konsumieren. Anzeige- oder Modellvorschlag ist kein tatsächlicher Antrag. |
| Anspruchsberechtigtenname / Betriebsanzeige | Anzeigename ist keine Personenkennung und belegt weder Rolle noch zeitliche Betriebsbindung. | Interne Personen-ID; datierte Beziehung zu Betrieb und konkreter Rolle: Förderwerber, Bewirtschafter, maßgeblich mitarbeitende Person, Almbewirtschafter oder Hirte. Nicht jede Prüfung braucht einen Klarnamen. |
| Personen-/Kurs-/Anrechnungsbestand | In den geprüften konsumierten generischen Inputs fehlt ein gemeinsamer Vertrag. | Bildungsereignis-ID, tatsächliche Teilnahme, Person-/Betriebsbindung, Datum, Anbieter, Thema, anrechenbare Stunden beziehungsweise Treffen, Nachweis und konkrete Anrechnung auf eine Pflicht. Bestätigte dokumentierte Aggregate bleiben zulässig. |
| UBB/BIO/14/17/19-Basisregeln | Acht technische Fälle ergeben fünfmal `eligible` ohne diese Nachweise; 2/16/15 bleiben bei gefüllten bisherigen Inputs konservativ `missing_data`. | Den begrenzten Basisprüfstand sichtbar machen; neue Nachweise mit tatsächlich konsumierenden konkreten Regeln verbinden. Mehr Pflichtfeldnamen allein schließen die Lücke nicht. |
| Native o6_3-Teilprüfung | Vertragsbeginn, historische Erstjahreswerte, kombinierte Maßnahme und `land.parcels[].is_applied` sind registriert und werden im Current-Mode konsumiert. | Bestehende Teilgrundlage erhalten; konkreten Antrags-/Personen-/Übernahmebezug ergänzen. Alle acht Fachblocker bleiben offen. Die acht generischen Runtimefälle testen diesen nativen Zweig nicht. |
| Current-Fakten und generischer Editor | Hostdatum, aktueller Snapshot und Digest sowie dokumentierte Fakten sind bereits vorhanden. Der generische Editor bietet nur registrierte Collections. | Passende Personen-/Kurs-/Antragsobjekte registrieren, in Oberfläche und Adapter anbinden und im jeweiligen Pflichtscope konsumieren. Keine zusätzliche AMA-only-Eingabesperre. |
| Auto-Generator | Numerische Vorschläge auf Arbeitskopie und `EvaluationRun`; kein eigener Auto-`FarmProfileSnapshot`. | Bereits bestätigten eigenen dokumentierten Auto-Snapshot mit Quelle `auto` umsetzen. Die bestehende Eindeutigkeit `farm_id + year` braucht dafür eine angepasste Snapshotidentität. |

Die [App-Pfade](app-paths.json) enthalten acht Vertragsbeobachtungen,
58 genaue Codeanker und 26 gegen den aktuellen App-Pin geprüfte Dateien.
[Policybeobachtungen](policy-observations.json) enthalten acht reproduzierte
synthetische Fälle. Acht zusätzliche Parameterpaare mit leerer gegenüber
gefüllter bestehender MANA-Liste ergeben identische effektive Policy-Eingaben.
Unveränderte Produktionsprojektionen wurden isoliert und die aktuelle Policy
mit der offiziellen, per Releasechecksum geprüften OPA 1.18.2 ausgeführt.
Das ist keine HTTP-/DB-/Browser-E2E-Prüfung und kein fachliches Golden-Soll.
Der Kontext 09.10.2026 ist ausdrücklich simuliert, keine echte Betriebsbewertung.
Ein zusätzlich reproduzierter [numerischer UBB-Grenzbefund](technical-followup.json)
bei 3,0 ha Acker und 0,21 ha DIV bleibt als gesonderte technische Folgearbeit
erfasst; er gehört nicht zur Personen-/Kurs-/Antragsbewertung.

## Kurs- und Personenverträge getrennt halten

| Pflicht / Option | Umfang und frühester Besuch | Frist / weitere Trennung |
| --- | --- | --- |
| UBB-Biodiversität | 3 Stunden, ab 01.01.2022 | Feste Frist 31.12.2025; konkrete Personen-/Betriebsbindung. |
| BIO | 3 Stunden Biodiversität plus 5 Stunden biologische Wirtschaftsweise, ab 01.01.2022 | Feste Frist 31.12.2025; eigene Pflichten, kein freier Stundenpool. |
| Einschränkung ertragssteigernder Betriebsmittel | 3 Stunden Stickstoffdüngung / angepasste Grünlandnutzung, ab 01.01.2022 | Feste Frist 31.12.2025; zusätzliche UBB-Biodiversitätspflicht getrennt. |
| Naturschutz auf der Alm (NATA) | 4 Stunden naturschutzorientierte / biodiversitätsfördernde Almbewirtschaftung, ab 01.01.2022 | Feste Frist 31.12.2025. Nur tatsächlicher optionaler NATA-Scope; keine daraus abgeleitete Kurspflicht der Alm-Grundmaßnahme. |
| Almweideplan | 4 Stunden Almwirtschaft / ökologische Auswirkungen, ab 01.10.2024 | Bis 15.07. des ersten Zuschlagsjahres. Jährliche Erstellung / Überprüfung des Plans ist eine zusätzliche Pflicht. Keine globale NATA-Ersatzkursregel übertragen. |
| Grundwasserschutz Acker | 10 Stunden beziehungsweise Fachexkursionen, ab 01.01.2022 | Bis 31.12.2026; eigenes Gewässerschutzkonzept. Wiener Zuschlag zusätzlich 3 Stunden, mit eigenem Scope. |
| Humuserhalt | 5 Stunden Grünlandbewirtschaftung, ab 01.01.2022 | Feste Frist 31.12.2025. UBB-/BIO-Pflichten zusätzlich; Themenwortlaut Merkblatt gegenüber SRL bleibt offen. |
| EBW | Mindestens ein tatsächliches regionales Vernetzungstreffen auf Einladung der beauftragten Stelle | Bis 31.12.2026; keine erfundene Mindeststundenzahl oder allgemeine Anbieter-Whitelist. |
| UBB-/BIO-Monitoring | Einführung des tatsächlich bestätigten Monitoringprogramms | Erstes tatsächliches Programmteilnahmejahr; reguläre Biodiversitätsschulung und jährliche vollständige Monitoringdaten getrennt. |

Der Nachweis gehört zur tatsächlich geschulten Person und ihrem Betrieb.
Voraussetzungen für Mehrbetriebsanrechnung sowie Ausscheiden vor, genau am oder
nach dem jeweiligen Stichtag bleiben im konkreten Quellen-/Pflichtscope.
Insbesondere erzeugt späteres Ausscheiden nach einer ausdrücklich abgeschlossenen
festen Frist keine neue allgemeine Schulungspflicht. Grenzfälle werden nicht geraten.
Doppelanrechnung derselben Bildungsveranstaltung darf nicht durch zwei unterschiedlich
benannte Datensätze verschwinden; die Granularität einer anrechenbaren Veranstaltung
und ihrer Teile benötigt Bestätigung.

Eine AMA-Abfrage ist ein Datenübermittlungsstand. Fehlende Anzeige beweist nicht
automatisch fehlende Teilnahme. Der aktuelle AMA-Hinweis vom 09.07.2026 nennt
für nach Ende 2025 absolvierte GWA-Kurse eine nächste Dateneinspielung frühestens
März 2027. Kursdatum und AMA-Anzeigestand bleiben daher ausdrücklich getrennt.
Dokumentierte Experten-/Betreiberbestätigungen
bleiben zulässige Eingaben. Anbieteranerkennung und eigentliche Teilnahme müssen
im maßnahmenspezifischen Scope nachvollziehbar sein. Die heute verlinkte
Anbieter-Maßnahmen-Matrix trägt Stand Oktober 2025; ihre vollständige sichere
Spaltenextraktion, datierte Anerkennung und konkrete Kurszuordnung fehlen lokal.
EBW-Einladung, Monitoring-Einführung und Regionalplanbestätigung werden nicht als
beliebiger Kurs desselben Stundenpools behandelt.

## Tatsächlicher Antrag und aktueller Vertragszustand

1. **Maßnahmenantrag / Option:** tatsächliche Einreichung, Antragsidentität und
   Förderjahr; gewöhnlicher Einstieg, bestätigte Weiterführung, besondere
   Übernahme und genehmigter Wiedereinstieg sind eigene Wege.
2. **Jährlicher Zahlungsantrag:** konkrete Flächen, Tiere und ergänzende Angaben
   im tatsächlichen MFA; bei Alm/Behirtung gegebenenfalls Rindermeldung oder
   Auftriebsliste. Automatische Vorbeantragung der Maßnahme ersetzt diese
   jährlichen tatsächlichen Angaben nicht. Hier keine Auszahlung berechnen.
3. **Genehmigung / Bindung:** eingegangener Antrag, Beginn der einzuhaltenden
   Bedingungen und schriftliche Genehmigungsverständigung getrennt speichern.
   Ein einzelner gültiger Gesamtvertrag kann je Maßnahme unterschiedliche
   Rechtsfolgen haben. `confirmed=true` ersetzt diese Historie nicht.
4. **Tatsächliche Erstjahre / Personenwechsel:** erste ÖPUL-Teilnahme, erstes
   Maßnahmenjahr, erstes Options-/Monitoringjahr und aktuelles Vertragsjahr
   unterscheiden. Bewirtschafterwechsel am selben Betrieb setzt die Vertrags-
   und Flächenhistorie nicht automatisch zurück.
5. **Weiterführung / fehlender Antrag / Ausstieg:** zunächst fehlender jährlicher
   Zahlungsantrag bei mehrjähriger Maßnahme beendet die Bewirtschaftungspflichten
   nicht sofort. Nachholung, Frist, Ausstieg, Ausschluss und echte Kontrollankündigung
   beziehungsweise Mitteilung sind eigene Ereignisse. Zahlungs-/Sanktionsfolgen
   werden in Block 7 vertieft.
6. **Tier- und Almverfahren:** Almbewirtschafter, Auftreiber und Hirte getrennt;
   tatsächliche Zuordnung, Listen, Datenbankmeldung, Abgang und rechtzeitige
   Abmeldung dürfen nicht durch einen Betriebs-Bool ersetzt werden. Zulässige
   vorab beantragte spätere Equiden-/Kamelzugänge bei Weide sind Antragserfassung,
   kein Beleg bereits erfolgter Haltung oder Weide.

Der reguläre neue Einstieg in mehrjährige Maßnahmen endete mit Förderjahr 2025;
einjähriger letzter Einstieg ist laut aktuell verlinkten Generalbedingungen
Förderjahr 2027 über Beantragung bis 31.12.2026. Eigenständige Optionen und echte
genehmigte Übernahmen brauchen ihren jeweils eigenen Weg. Das historische
Optionsinventar wird deshalb nicht als vollständiger aktueller Katalog ausgegeben.

Die SRL 01.10.2026 enthält den optionalen UBB-Bio-Zuschlag ab 2027 mit eigenem
Maßnahmenantrag, Vollbetriebsanerkennung und lückenlosem Bio-Kontrollvertrag.
Er eröffnet den gewöhnlichen BIO-Maßnahmeneinstieg nicht erneut. Für die aktuelle
2026-Prüfung kann eine künftige Möglichkeit nur als begründete Notiz erscheinen.
Der vollständige AMA-Meldeartikel vom 02.09.2026 wurde separat online gelesen.
Er präzisiert tatsächliche art- und maßnahmenspezifische Meldungen, zeitverzögerte
Anzeige und VIS-Verantwortung. Die historische Sidebarquelle wird damit nicht
umgeschrieben; der individuelle tatsächliche Melde-/Antragsstand bleibt offen.

Der Wortlautkonflikt bei HUM-Kursthemen besteht auch im gezielt kontrollierten
aktuellen Stand. Unterschiedliche Jahreslabels in Weide-/Rinder-Stall-Beispielen
bleiben eine offene Zuordnung zu tatsächlichem AMA-Formular und Förderjahr.

## Herkunft, offene Klärung und Umsetzung

Der ausgewählte aktuelle Datenstand enthält AMA-Ausgangswerte und dokumentierte
Experten-/Betreiberwerte, die AMA vorgehen. Abweichung allein blockiert sie nicht.
Auto-Werte werden entsprechend der bereits bestätigten Produktentscheidung im
eigenen dokumentierten Auto-Snapshot ausgewertet. Für alle Eingabequellen gelten
dieselben fachlichen Bedeutungen und Nachweisanforderungen; keine zusätzliche
Herkunftssperre. Die Angabe einer Eingabequelle ist getrennt von Teilnehmerrolle,
amtlicher Anbieteranerkennung und tatsächlich wirksamer Antrags-/Genehmigungsgrundlage.
Auto führt durch das Setzen von Werten keine echte Einreichung bei AMA aus.
Neu angelegte Flächen/Elemente behalten ihre sichtbare Herkunftsmarkierung und
stabile Identität gemäß Block 2.

[Restfragen](questions.md), [Scopematrix](scope-matrix.json) und
[Fragenindex](coverage-index.json) gehen ins Sammelissue #140. Alle 289 ursprünglichen
Fragen sowie die vollständigen acht o6_3-Blocker bleiben unverändert und offen.
Der Index verbindet alle 26 Maßnahmen mit 114 vorhandenen fachlichen Frageverweisen:
69 direkte Fragen und 45 begrenzte Querverweise. UBB hat in seinen fünf vorhandenen
IDs keine eigene Personen-/Kurs-/Antragsfrage; diese echte Lücke wird sichtbar
ergänzt, ohne eine frühere ID zu erfinden. Temporäre Teilscopes schließen keine
Frage und bilden kein globales UND-Gate für jede Maßnahme.

Nach bestätigter Fachklärung: gemeinsame Identitäten und Datumsrollen,
typisierte Kurs-/Teilnahme-/Antragsbelege, Editor und verlustfreier Adapter,
dann einzelne tatsächlich konsumierende Maßnahmenscopes mit unabhängig bewerteten
Grenzfällen. Block 7 vertieft Kombination, Sanktion und Zahlung. Die Prüfung und
ihre Grenzen stehen in [verification.md](verification.md), kurze Gründe in
[reasons.md](reasons.md).

Keine App-/Policy-/Canonical-/Thesisänderung, kein Modelllauf und kein Merge.
[Draft #103](https://github.com/ghinta/oepul-rule-lab/pull/103) und
[UBB-Draft #102](https://github.com/ghinta/oepul-rule-lab/pull/102) bleiben offen.
