# Einzelprüfung 17/26: Tierwohl Behirtung

Die Quellenprüfung von `v2-o6_15-opus-5.5-high-20260926` ist abgeschlossen;
Befunde blockieren die fachliche Freigabe und native App-Aufnahme.
Gebunden ist der unveränderte Kandidatencommit
`e009eed4a83ff076b26eba33ac433ac2b0642621`. Die Sammlung gehört weiterhin in
[Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) und auf den
bestehenden Branch. Historische Policies, Originale und Profile bleiben
unverändert. Die nächste Einzelprüfung beginnt erst nach diesem Abschluss.

Das neue Merkblatt wurde auf allen zehn Seiten einschließlich Tabellen,
Beispielen, Aktualisierungen und Schlussvermerken vollständig gelesen.
Alle sechs Module mit 1.175 Zeilen, alle 20 nummerierten Rohannahmen und
alle sieben tatsächlichen Vorschlagsbäume wurden vollständig gelesen.
Aktuell vollständig rückgelesen wurden SRL 18/72/73, Anhang A 3 und ATB
19/20. Sieben identische gemeinsame Originale werden mit Hashnachweis an
frühere vollständige Lektüren gebunden; die aktuellen Klauseln werden neu
abgeglichen. Insgesamt sind acht Originale und 42 historische Dateien
gebunden. GSP-AV, NAPV und das eigene Almbewirtschaftungs-Merkblatt aus
Run 14 sind hier nicht beigefügt.

## Bekannte positive Komponenten

Drei vor Ausführung gespeicherte öffentliche Szenarien für 2023, 2024
und 2026 enthalten zwei getrennte österreichische Teilbetriebsalmen mit
je sechs Hektar. Jede Alm hat zwölf getrennt dargestellte erwachsene
Standardrinder, jedes mit eigener synthetischer Kennung und Stückzahl
eins. Art, Geburt, bekannte Nichtzwergrasse und tatsächliche Meldungen
sind ausdrücklich positive Szenariovoraussetzungen; die öffentlichen
Kennungen sind keine echten Registerbelege.

Alle Tiere werden vom 1. Juni bis zum 1. August vollständig behirtet:
61 Tage, der Auftrieb zählt und der Abtrieb nicht. Alle tatsächlichen
Meldungen erfolgen am Ereignistag. Die zwölf Milchkühe auf Alm A haben
vor dem 1. Juli abgekalbt, werden an allen 61 Tagen gemolken und tragen
das rechtzeitig gemeldete Kennzeichen. Alm B hat zwölf bekannte sonstige
Rinder ohne Milchviehanspruch. Je Alm arbeitet eine eigene bekannte
Person, die keine andere Alm behirtet. Versorgung, Unterkunft und alle
sonstigen jährlichen Auflagen sind positiv erfüllt.

Ein Hund auf Alm A erfüllt alle tatsächlichen Ausbildung-, Zertifikats-,
Versicherungs-, Anwesenheits-, Arbeits- und Beantragungsvoraussetzungen.
Diese extern verifizierten Tatsachen werden im hypothetischen Fall
vorausgesetzt; aus dem Booleschen Flag oder der nativen Ausgabe wird
kein echtes Zertifikat gewonnen. Kein Hund wird auf Alm B beantragt.

Die aktuelle Teilnahme an Almbewirtschaftung, die ursprüngliche gültige
Beantragung, alle vorangegangenen wirksamen Jahresverlängerungen und
der aktuelle Zahlungsantrag mit allen Tierkategorien, Personen und Hund
sind ausdrücklich bekannt. Es gibt keinen weiteren Zuschuss, kein
Landes-Top-up, keine Kontrollverweigerung, Abmeldung, außergewöhnlichen
Umstand oder behördlich festgesetzte Kürzung. Nicht eingetretene Ereignisse
erhalten keine erfundenen Daten.

Die zwei Almen erhalten jeweils zwölf RGVE zur höheren ersten Rate.
Zusammen 24 RGVE werden nicht auf einen gemeinsamen ersten 20er-Block
begrenzt. Der Milchviehbestand bleibt mit zwölf RGVE unter seiner ersten
Blockgrenze; die offene Verteilungsannahme entscheidet diesen Fall nicht.
Die aus den Originaltarifen vor OPA mit Decimal berechneten Summen sind
4.180 / 4.514,40 / 4.958,40 Euro. Alle 135 Vergleiche der drei tatsächlichen
MAIN-Auswertungen einschließlich kompletter Tierkomponententupel sind
erfüllt. Zwölf maßgebliche Hektar bleiben unter jeder Modulationsschwelle;
die offene globale oder einzelalmweise Aggregation wird damit nicht
entschieden.

Die optionale RGVE-Kategorie ist hier explizit `null`. Der Code leitet
sie in diesem Run korrekt aus bekannter Art, Geburt und Rasse ab.
Der entsprechende Fehler aus Run 14 wird nicht übertragen. Ebenso
enthält der tatsächliche Eingabevertrag dieses Runs kein numerisches
Enum. Die eigene Prüfung von 2.187 vorhandenen Formen und 153 Enums
findet keine Abweichung; sie bescheinigt keine Pflichtvollständigkeit,
Registerwahrheit oder tatsächliche Behördenfreigabe.

## Quellenkonflikte und weiterer Prüfumfang

Der zweite gedruckte Prämienfall auf MB 8 enthält einen Rechenfehler:
20 × 81 + 30 × 27 ergibt 2.430 und nicht 2.295 Euro. Die historische
Annahme 1 benennt das bereits korrekt. Gedrucktes Beispiel und Formel
bleiben getrennt; kein falsches Modellurteil wird aus dem Druckfehler
abgeleitet. Das aktuelle ATB 20 nennt tatsächlich 98,66 Prozent für
230 ha und 250 RGVE, während die angegebene Formel 227/230 ergibt.
Auch dieser aktuelle Quellenkonflikt bleibt ausdrücklich sichtbar.

## Gemeinsames Ergebnis und tatsächliche Verbraucher

Alle 95 historischen Regel-IDs sind einzeln beurteilt. Sieben tatsächliche
Profilvorschläge und alle 20 Tabellenzeiger sind erfasst. Die gemeinsame
native Ausführung umfasst 601 öffentliche Entwicklungsproben mit 841
Einzelprüfungen: 792 erfüllt, 49 abweichend. 588 Ergebnisse sind definiert,
13 enden mit Laufzeitfehlern, keines ist undefiniert. Die 39 überlappenden
Befundgruppen sind keine Anzahl unabhängiger Fehler. Gezielt ausgewählte,
teils verwandte oder bewusst identische Eingaben sind keine private
Partition, Modellgenauigkeit oder unabhängige Expertenabnahme. Historische
Selbsttests, manuelle Adaptationen und die 24 GM-Studienfälle liefern keine
Sollwerte dieses Dossiers.

Aktuelle Abmeldung, bekannte fehlende Mindestteilnahme oder Kombination,
persönliche Zugangsmängel und unentschuldigte Kontrollverweigerung sperren
tatsächlich die Zahlung. Die korrekt anerkannte kausale Kontrollausnahme
bleibt erhalten. Tier-/Milchalter, Kalbung, 45 Milchtage, 7-/14-Tage-Meldung,
15. Juli-Auftrieb und getrennte 17. Juli-Listenfristen sind frisch geprüft.
Diese funktionierenden Verbraucher und die sicheren Null-Ableitungen werden
ausdrücklich gewürdigt.

Die maßgeblichen allgemeinen Gegenfälle und ihre Grenzen sind:

- **Auslands-Modulationsscope:** Eine bekannte österreichische Alm mit
  drei ha/drei RGVE erhält 243 Euro. Eine zusätzlich übertragene bekannte
  ausländische Einheit mit 1.000 ha/1.000 RGVE erhält lokal richtig 0,
  geht aber in die Modulationsbasis ein. Die österreichische Zahlung fällt
  auf 214,96 Euro. Mindestteilnahme und österreichische Flächensumme
  bleiben unabhängig durch die österreichischen Tiere/Flächen erfüllt.
- **Positiver aktueller Vertragsnachweis:** Vier gekoppelte Historien-/
  Anerkennungskontraste betreffen nie gebildeten historischen Vertrag,
  alleinigen Altprogrammantrag, noch nicht anerkannten verspäteten
  Wiedereinstieg und überbreiten alten Wiedereinstiegsstatus. Ein
  vorbereiteter historisch beantragter Beginn ist keine amtliche Bildung.
  Garantiert Upstream schon wirksame Originalverträge, fällt die erste
  Variante außerhalb dieses stärkeren Vertrags. Die vier Kontraste
  bleiben eine qualifizierte Evidenzfamilie, keine vier Agrarverstöße.
- **Wirksamer Ausschluss und fehlender aktueller Antrag:** Ein bereits
  tatsächlich wirksamer Ausschluss reagiert nur im separaten Helfer.
  Tatsächlich vollständig fehlende Zahlungs- und Rindermeldungsanträge
  erzeugen eine Fristdiagnose; jeweils bleiben 243 Euro payable stehen.
  Der physische Tarifbestandteil ist getrennt korrekt. Ein bloß lokaler
  Rohverstoß erhält keinen erfundenen 100-Prozent-Sanktionssatz.
- **Informationslabel:** Bei bekannt aktuell inaktivem Antragsteller
  bleibt das Vertragslabel valid; die Zahlung ist korrekt 0. Dies ist
  eine eigene Informationsgrenze und kein zweiter Geldfehler.

## Bedingte Maßnahmenkontraste und fehlende Nachweise

Im Maßnahmenteil sind alle 297 Fälle definiert. Die sieben abweichenden
Vergleiche gehören ausdrücklich zu fünf bedingten Darstellungs- und
Vorbereitungsverträgen: Lage von Unterbrechungen im verspätet anerkannten
Zeitfenster, maßgebliche Tiere/Union der Alm-Bestoßung, aktuelle Aktivierung
eines zukünftigen Hundezuschlags, vollständiger Hundebestand gegenüber
reiner Claimliste und wiederholte Personenzeilen gegenüber eindeutigen
Hirt:innen. Das zeitliche Kontextpaar hat bewusst dieselbe vollständige
Eingabe/Query und verschiedene externe Intervalle; es ist kein gewöhnliches
deterministisches Gold. Zwei Hundekontexte prüfen zusätzlich MAIN, dessen
Beträge unter den jeweiligen Listen-/Jahresverträgen bedingt bleiben.

Drei weitere Befunde betreffen sofortige Entfernung eines ungültigen
Milchkennzeichens, vorbereitete Register-/Pflege-/Aufenthaltsnachweise und
die offengelegte Milchblock-/erste-Alm-Konvention. Keine allgemeine
amtliche Verteilungsregel wird aus erfolgreichen Originalbeispielen oder
aus der Policy selbst rückbegründet. Das im Run nicht bereitgestellte
14-Merkblatt liefert hier kein hartes globales Modulationsgold.

Die 13 Laufzeitfehler kommen ausschließlich aus dem Eingabeteil: vier
zulässige Nullable-MAIN-Fälle, zwei funktionale Kennungskonflikte, sechs
Outside-MAIN-Fälle und ein separater Outside-Argumentstress am Exithelfer.
Das vorgeschlagene Abmeldedatumsfeld selbst wird nicht gelesen. Keine
gültige Nullable-Helferstörung oder numerische Enumambiguität wird aus
Run 14 übernommen. Geburt/Rasse mit Kategorie-null, nulliger Bestand und
nullige Gesamttage haben hier sichere Ableitungen.

Unbekannte notwendige Meldungs-/Antrags-/Geografienachweise dürfen keine
Freigabe begründen. Der native volle Auftriebszeitraum bei fehlendem
Meldedatum wird deshalb als gewünschte Positivnachweisgrenze dokumentiert.
Ein technischer Untercheck nennt ihn nur absturzfrei: Die ursprüngliche
Erwartung 0 bleibt unerfüllt; eine reale Meldung oder rechtmäßige Freigabe
wird nicht daraus gewonnen. Bekannte Nichterfüllung, unbekannte Extraktion,
explizite Nullwerte, fehlende Felder und ungültige Formen bleiben getrennt.

## Tabellen und tatsächliche App-Projektion

Fünf native Datenfiles enthalten 146 direkte Einträge statt 147 deklarierter
Zeilen. Die einzige Differenz ist eine Zählbasis: zehn Fristenschlüssel
mit elf verschachtelten Werten. Kein Termin fehlt. 616 Skalarblätter und
24 übrige Metadaten, davon zwölf direkt gelesen, sind vollständig erfasst.
Alle 43 Tabellenkontrollen bestehen. Beide tatsächlichen Quellenrechenfehler
bleiben von korrekten nativen Formeln getrennt. Es gibt keine eigene
Anhang-E-/L-Tabelle; Maßnahme 15 ist eine Tiermaßnahme außerhalb der dortigen
21 Flächencodes.

Die sieben Vorschläge umfassen 93 Blätter: 90 gelesen und drei ungelesen,
231 dokumentierte Lesestellen. Drei gelesene Blätter wirken nur in Helfern,
acht in MAIN-Meldungen, 79 bedingt in MAIN-Nachweisen, Identität, Mengen
oder Betrag. Zwei weitere Pfade gehören zum unveränderten Canonical.
Die echte App-Projektion am gebundenen Commit
`529eadb34c4fdd249fbf739a372d63185b7374a2` erhält 0/7 Wurzeln und 0/93
Vorschlagsblätter, aber beide Canonicalpfade. Der SQL-Guard misst null
Aufrufe. Die exakte unveränderte Ausgabe wurde separat nativ ausgewertet:
definiert, eligible=false und payable_premium_eur=0. Diese zusätzliche
Integrationsbeobachtung zählt nicht zu den 601 Proben.

## Reproduzierbarkeit und eigene Konstruktionen

Alle fünf Teile wurden vor der gemeinsamen Sammlung eingefroren. Originale
Policy-/Datenverzeichnisse, die gepinnte OPA-Binary, strikte Builtinfehler,
feste Grenzen und gesperrte Netzwerk-/Jetzt-/Zufalls-/Runtimebuiltins bleiben
unverändert. General speichert zusätzlich 74 vollständige MAIN-Ergebnisse
für verschiedene Eingaben; sie erhöhen die Quellenfallzahl nicht. Ein
weiterer unabhängiger 16-Fälle-Bericht reproduziert alle 13 Fehler und drei
definierte Kontexte mit vollständigen nativen Objekten; ein absturzfreier
fehlender Meldenachweis bleibt ausdrücklich unerfülltes Positivnachweissoll.

Eigene Eingabekorrekturen sind als solche belegt: General korrigierte die
fälschlich mit 62 statt 61 Tagen angesetzte Dauer und das erste ÖPUL-Jahr
zur tatsächlich vorbereiteten historischen 14-Teilnahme; alle finalen 148
Fälle wurden danach ausgeführt. Domain bereinigte acht echte Fixtures:
einen reinen Nachschaufall mit widersprüchlich positiver Tagesbetreuung,
drei ungültige Milchkuh-Claims ohne aktive jährliche Kategorienliste und
vier bekannte Zwergrassen mit widersprüchlichem false-Flag. Alte ganze
Inputs und Hashes sind erhalten; Queries/Sollwerte wurden nicht umgeschrieben.
Alle 297 finalen Fälle wurden nach sämtlichen Änderungen erneut ausgeführt.

Fünf Tabellenqueries wurden vor ihrer ersten Ausführung syntaktisch
korrigiert, ohne Inputs oder Quellerwartungen zu ändern. Inputs ergänzte
vier vorher gespeicherte Kontextfälle und wiederholte alle 110; die ersten
106 bleiben unverändert. Zwei spätere Quellenmetadaten nennen die richtigen
Ziegen-/Kamelidzeilen mit gleichem 0,15-Faktor. Spätere Metadatenrevisionen
und tatsächliche Eingabeänderungen werden ausdrücklich unterschieden.
Kein verworfener Autorenfehler wird zum Modellbefund.

Die vollständigen Berichte [General](general.md), [Maßnahme](measure.md),
[Tabellen](tables.md), [Eingaben/App](inputs.md) und [Qualität](quality.md)
binden die Einzelbelege, nativen Beobachtungen und die abschließende
unabhängige Gegenprüfung. Keine historische Policy, Originalquelle,
Canonical- oder Appdatei wurde geändert; keine Promotion, Expertenabnahme
oder Serverfreigabe erfolgt.
