# o6_1b: Teilnahme, allgemeine Bedingungen und Tierhaltung

Diese Prüfung betrifft nur den eingefrorenen Run
`v2-o6_1b-opus-5.5-high-20260925` aus Commit
`e009eed4a83ff076b26eba33ac433ac2b0642621`. Sie sammelt Befunde; Policies,
Quelldokumente, Farm Profile und Laufzeit bleiben unverändert. Eine fachliche
Freigabe für die App wird daraus nicht abgeleitet.

Das BIO-Informationsblatt vom April 2026 wurde auf **allen 51 PDF-Seiten**
vollständig gelesen, einschließlich Tabellen, Fußnoten und Aktualisierungen.
Die sieben anderen Quelldateien sind anhand ihrer SHA-256-Werte mit o6_1a
identisch. Die dortige vollständige Lektüre der 21 ATB- und 94 SRL-Seiten wird
wiederverwendet; BIO S. 36–45 der Sonderrichtlinie und die relevanten
übergreifenden Pflichten wurden gegen die neue Implementierung erneut geprüft.
Tabellen- und weitere Fachmodulbefunde werden gesondert geführt.

Vollständig geprüft wurden `participation.rego`, `general_conditions.rego` und
`livestock.rego` sowie ihre Schnittstellen zu `main.rego` und `common.rego`.
Die relevanten Verbraucher in `obligations.rego` und `premiums.rego` wurden für
die Quell- und Rechtsfolgenprüfung einbezogen.
[general.json](general.json) enthält **63 einzeln bewertete Katalogregeln**,
zehn Befunde, Quellenbindungen und **35 neu abgeleitete Entwicklungsproben**.
Diese Proben werden vom gemeinsamen Audit-Runner ausgeführt; hier werden noch
keine Ausführungsergebnisse behauptet.

## Wesentliche Befunde

**Der konventionelle Bereich eines Bio-Teilbetriebs ist nicht durchgehend aus
der Bio-Berechnung ausgeschlossen.** BIO S. 5, § 3.3, und SRL S. 37
unterscheiden die beiden Kulturbereiche. Die Implementierung verwendet den
gewählten Bereich für BIO-Codierung und Tierhaltung, aber `premium_eligible`
prüft ihn nicht. Die Entwicklungsprobe `bio-legal-partial-scope` fragt deshalb
gezielt nach der Bio-Grünlandprämie für 2 ha konventionelle Dauerweide bei einem
Teilbetrieb, der ausschließlich Wein/Obst/Hopfen biologisch bewirtschaftet.
Der aus der Quelle abgeleitete Sollbetrag für diese Komponente ist 0.

**Vertragsgültigkeit und mehrere zwingende Zahlungsfolgen bleiben von
`result` getrennt.** `within_contract_period` wird berechnet, aber weder von
`compliant` noch vom Betrag verwendet. Nur ein bekannter verspäteter Antrag
oder ein Beginn nach 2025 erzeugt den entsprechenden Verstoß. Fehlende Angaben
und ein Beginn vor 2023 werden nicht vollständig behandelt. Die 400-Euro-
Transaktionskostenkomponente ist allein vom Prämiensatz abhängig.
`access_failure_consequence`, Jahresungültigkeit nach Ausstieg,
Sanktionsstufe und Ausschluss werden ebenfalls nicht vollständig in das
Gesamtergebnis übernommen. Der fehlende Zahlungsantrag ist bei diesem Run nur
katalogisiert, ohne ausführbaren Tatbestand. Ein berechneter Betrag ist damit
kein bestätigter Auszahlungsbetrag.

**Auslandsflächen beeinflussen weiter die inländische Prüfung.** ATB S. 9,
§ 5.6, schließt sie auch aus Begrenzungen aus. Der Run schützt zwar direkte
Schlagprämien durch einen Österreichfilter. Futterfläche, Acker-/Grünlandsummen,
Mindestgröße und die ersatzweise verwendete Modulationsbasis enthalten jedoch
auch ausländische Schläge. Die Probe `bio-legal-foreign-forage` verlangt daher
2 ha Futterfläche für 2 ha inländische und 10 ha ausdrücklich ausländische
Dauerweide. Ein falscher Nenner kann die Tierhalterklasse und anschließend die
Prämie auf inländischen Flächen verändern.

**Mehrere erforderliche Nachweise werden günstig vorbelegt.** Ein wichtiger
Unterschied zu o6_1a: Dieser Run hat Eingabeflags für aktiven Landwirt,
Bewirtschaftung im eigenen Namen und Verfügungsgewalt. Fehlend bedeuten sie
allerdings `true`. Auch Kontrollkontinuität, jährliche Vollnutzung und
Ernteanteil werden bei fehlenden Angaben günstig behandelt. Anerkennung der
Kontrollstelle, eigene Rechnung, tatsächliche landwirtschaftliche Tätigkeit
sowie mittelbarer oder organisatorischer öffentlicher Einfluss sind nicht
vollständig abgebildet. Eine Registrierung wird dagegen ausdrücklich verlangt.
Diese Unterschiede sind einzeln dokumentiert; ein Katalogeintrag ersetzt keinen
ausführbaren Nachweis.

**Die Tierhaltung enthält zusätzliche Bedeutungs- und Mengenprobleme.** Die
Quelle verlangt Bio-Tierhaltung unabhängig von der Bio-Zertifizierung. Der Code
verwendet `is_certified_organic` als Stellvertreter; diese beiden Tatsachen
brauchen einen präzisen Eingabevertrag. Die Grenze von zwei nicht zertifizierten
Mastschweinen und zehn nicht zertifizierten Hühnern wird außerdem auf alle als
`own_use` markierten Tiere angewandt, einschließlich zertifizierter Tiere.
Die Probe für elf zertifizierte Hühner unterscheidet Eigenbedarf als Zweck von
einer beantragten Ausnahme. Getrennte Lagerung konventioneller
Eigenbedarfsfuttermittel fehlt in der Ausführung.

Bei der Equiden-Mischhaltungsprüfung benötigt die konventionelle Tiergruppe
keinen positiven Bestand. Eine konventionelle Gruppe mit **0 Tieren** und eine
biologische Gruppe mit einem Tier erfüllen dadurch den Prüfzweig für
gleichzeitige Haltung. Die paarigen Null-/Ein-Tier-Proben prüfen diesen
Quellbegriff direkt. Für die RGVE-Klassifikation werden passend gekennzeichnete
konventionelle Equiden dagegen ausdrücklich ausgeschlossen.

**Ein Teilbetriebsflag genügt für alle vier Kombinationserleichterungen.** BIO
S. 32 erlaubt sie nur mit dem jeweils gegenseitigen Kulturbereich.
`participation.rego:150` prüft lediglich, ob überhaupt ein Teilbetrieb vorliegt.
Die Probe mit biologischem Acker/Grünland und gleichzeitiger UBB-Teilnahme auf
demselben Kulturbereich soll deshalb `O61B-AN-001` ergeben. Die separate
Sonderregel für nichtproduktiven Acker verlangt hingegen ausdrücklich den
WOH-Teilbetrieb.

## Entwicklungsproben und Grenzen

Die Proben prüfen auch korrekte Teilumsetzungen: Antrags- und
Kontrollvertragsfristen, 25-Prozent-Beteiligung, ausdrücklich fehlende
Aktivlandwirteigenschaft, die Tierhaltergrenzen von 0,30 und 1,40 RGVE/ha,
Eigenbedarfsgrenzen, Nichtanrechnung konventioneller Equiden,
Flächenabgang 5 Prozent/maximal 5 ha/mindestens 0,50 ha, Flächenzugang sowie den
Wechsel von Verwarnung zu 1-Prozent-Einbehalt ab 2027. Eingaben, Abfrage,
Quellen-Sollwert und genaue Erwartungsoperatoren stehen im JSON.

Der übergreifende Audit hat einen eigenständigen Zahlenvergleichsfehler des
historisch gepinnten OPA nachgewiesen. Bereits die historischen BIO-Annahmen
dokumentieren dafür eine Ganzzahlliteral-Umgehung. Deshalb beweisen auch
bestandene numerische Teilproben keine allgemeine Zuverlässigkeit dieser
Laufzeit. Die aus den Quellen abgeleiteten Sollwerte werden deshalb beibehalten;
abweichende Ergebnisse werden aufgezeichnet und nicht durch Anpassung der
historischen Policies oder Erwartungen verborgen.

Nicht jede inhaltliche Pflichtverletzung verlangt automatisch eine Nullprämie:
Die Sanktionsstufe hängt von der behördlichen Bewertung ab. Ebenso ist ein
Verzicht auf Zahlungen bis 50 Euro eine Möglichkeit, keine zwingende
Nullsetzung. Fehlender Zahlungsantrag, Zugangsausschluss oder ein außerhalb
des biologischen Kulturbereichs liegender Schlag sind davon getrennte Fragen.

Die offenen Rechts- und Eingabefragen werden gesammelt. Weder die separate
öffentliche Studienkonvention noch ein technisch erfolgreicher Lauf wird als
nachträgliche fachliche Abnahme dieses historischen Runs ausgegeben.
