# o6_14 – Almbewirtschaftung: fachliche Quellenprüfung

Run `v2-o6_14-opus-5.5-high-20260926`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Maßnahmenteil mit exakt **78 historischen IDs**: 55 Elternprüfung und 23 unabhängig geprüfte NATA-/Almweideplan-IDs, vollständig integriert.

Alle **318 finalen Fälle** wurden mit dem vollständigen ursprünglichen Policy- und Datenverzeichnis erneut nativ ausgeführt: **318 definiert, 314 lokale Sollwerte erfüllt, 0 Laufzeitfehler, 0 undefined**. Die vier Abweichungen sind drei gekoppelte Gegenchecks zu **zwei konkreten Verbraucherfamilien** und ein ausdrücklich **bedingter Antragsflag-Gegencheck**. Sie sind keine vier unabhängigen Modellfehler. Sieben weitere Befunde beschreiben vorbereitete Evidenzverträge, fehlende bedingte Abläufe oder offengelegte Jahres-/Sanktionskonventionen. Eine globale Fehlerquote wird daraus nicht abgeleitet.

## Nachgewiesene Abweichungen und ihre Grenzen

| Fall | Quellengebundenes Soll | Native Beobachtung | Einordnung |
| --- | --- | --- | --- |
| Optionale Kategorie `null`, bekannte erwachsene Standardrinder | Kategorie aus bekanntem Geburtsdatum ableiten | `null` | Derselbe Null-Guardfehler wie die folgenden Tabellen-/MAIN-Gegenchecks |
| Drei bekannte erwachsene Rinder, 3 ha, 61 Tage, optionale Kategorie `null` | nominal 129,60 Euro vor gesonderten Kürzungen |0 Euro | Bekannte positive Anspruchskomponente wird unterdrückt; keine unbekannte Tierart/Altersangabe |
|30 Tage zulässige Rinderbestoßung plus 61 Tage bekanntes Hausschwein |30 maßgebliche Alm-Tage |61 Alm-Tage; MAIN korrekt 0 Euro | Lokaler Bereichsfehler; kein Nachweis einer falschen Gesamtzahlung |
| Begründeter gewünschter 2,4-Auftrieb, tatsächlicher separater Listeneintrag fehlt |2,0 nur unter dem offengelegten schwächeren `applied`-Vertrag |2,4; getrennte Meldediagnose vorhanden | Bedingt: Wenn `applied` bereits den wirksamen vollständigen Antrag bestätigt, widerspricht das fehlende Listenflag diesem stärkeren Eingang |

## Befunde

### O614-MEASURE-01: Erlaubtes null verhindert die Ableitung bekannter RGVE und unterdrückt die Prämie

Bei drei getrennten erwachsenen Standardrindern sind Geburtsdatum, Tierart, Österreich-Aufenthalt, 61 anrechenbare Tage und 3 ha vollständig bekannt. Der tatsächlich erlaubte Wert rgve_category_id: null wird als definierter direkter Ausdruck angenommen; der not-Fallback greift nicht. Native liefert Kategorie null und 0 Euro statt des ableitbaren nominalen 129,60-Euro-Bestandteils. Bei ausgelassenem optionalen Kategorienfeld funktioniert die Ableitung. Kein unbekanntes Alter oder erfundenes Produktwissen liegt vor. Die Tabellengegenchecks bestätigen dieselbe Verbraucherfamilie, keine zusätzlichen unabhängigen Defekte.

Einordnung: `source_known_runtime_counter`. Zugeordnet: `O614-ANIMAL-002`, `O614-APPL-009`, `O614-PREM-003`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 14): „Der Altersstichtag für die Einstufung ist für alle Tierkategorien der 1. Juli des Antragsjahres.“

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 14): „Rinder ab 2 Jahre 1,00“

### O614-MEASURE-02: Ausgeschlossene Tierart zählt für die Mindestbestoßung der Alm

Eine positiv bekannte nicht teilnahmefähige Tierart (Hausschwein, enum other) bleibt korrekt ohne Tierprämie. Der Alm-Tage-Verbraucher vereinigt jedoch auch deren Aufenthalte: bei 30 Tagen zulässiger Rinderbestoßung und 61 Tagen Schweineaufenthalt entstehen 61 statt 30 maßgebliche Alm-Tage. MAIN bleibt im abgegrenzten Fall korrekt bei 0 Euro, da auch das Rind keine 60 Tage erreicht. Nachgewiesen ist der lokale Bereichsfehler; eine falsche Gesamtzahlung oder frei gewählte 100%-Sanktion wird daraus nicht abgeleitet.

Einordnung: `source_known_local_counter_main_zero_credited`. Zugeordnet: `O614-ANIMAL-001`, `O614-GRAZE-001`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 4): „Dementsprechend muss an mindestens 60 Tagen die Bestoßung einer in Österreich liegenden Alm durch die in der Alm/Gemeinschaftsweide-Auftriebsliste angeführten Schafe, Ziegen, Equiden (Pferde, Ponys, Esel und Kreuzungen) oder Neuweltkamele bzw. die in der „Alm-/Weidemeldung Rinder“ angeführten Rinder erfolgen.“

### O614-MEASURE-03: 2,4-Ausnahme hängt vom vorbereiteten Antragsflag ab

Der Grenzwertverbraucher liest increased_intensity_applied und die Planbegründung, nicht den tatsächlichen Jahreslisteneintrag. Ein fehlender Eintrag wird separat als APPL007-Verstoß diagnostiziert. Die Gegenprobe 2,0 gegen 2,4 ist nur unter der offengelegten Lesart gültig, dass applied den gewünschten/beantragten Intensitätswert und noch keine vollständig wirksame gesonderte Jahresbeantragung bescheinigt. Unter einem stärkeren vorbereiteten Wirksamkeitsflag wären applied: true und declared_in_drive_up_list: false widersprüchlich. Dies ist eine bedingte Eingabekonsistenz-/Evidenzgrenze; keine unbedingte Fehlentscheidung und kein fester Geldabzug.

Einordnung: `source_conditional_prepared_application_contract`. Zugeordnet: `O614-STOCK-004`, `O614-APPL-007`.

Originalbeleg (20241011_srl_oepul_2023.pdf, PDF-Seite 71): „Eine entsprechende Begründung ist im Almweideplan darzulegen und es hat eine gesonderte Beantragung zu erfolgen.“

### O614-MEASURE-04: Produkt-, Alm-, Futter- und Meldefakten brauchen einen überprüfbaren Eingabevertrag

Die tatsächlichen bekannten Verbotsflags und Zulässigkeitsausnahmen werden geprüft. Die vier Profilvorschläge enthalten jedoch keine eigene Produkt-/Wirkstoffzulassungsprüfung, kein Naturfutter-Suffizienzobjekt, keine physischen 50 m-/Straßenklassifikationsmerkmale und keinen tatsächlichen Übermittlungskanal. Almdefinition und Erschließungsstufe sind vorbereitete Sachverhalte. Ein false-Verbotsflag belegt bei unbekannter Bio-Zulässigkeit keinen positiven Nachweis. In den positiven synthetischen Fällen ist die Zulässigkeit ausdrücklich bekannt; keine reale Mittelzulassung oder Behördengenehmigung wird erfunden. Unabhängige Tierkennzeichnungsmeldungen bleiben katalogisierte zusätzliche Pflichten.

Einordnung: `prepared_domain_evidence_contract`. Zugeordnet: `O614-PSM-001`, `O614-FERT-001`, `O614-FEED-001`, `O614-AREA-002`, `O614-ACCESSLVL-001`, `O614-APPL-008`, `O614-APPL-016`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 7): „Der Einsatz von Pflanzenschutzmitteln ist nicht erlaubt. Ausgenommen sind“

### O614-MEASURE-05: Geplante PSM-Codes und umgehende Änderungen fehlen als eigener Ablauf

Die tatsächliche flächige PSM-Codierung bis 2025, PSMCS bei gemischtem Einsatz und der Wegfall ab 2026 sind umgesetzt. Die vorherige Planung, erkannter Nichteinsatz und die Zeit der anschließenden Streichung/Änderung sind dagegen keine getrennten Eingabefakten. Eine aktuell leere Anwendungsliste allein belegt keinen verspätet stehen gebliebenen Code: eine noch zulässige Planung und ein bereits bekannter Nichteinsatz wären darin nicht unterscheidbar. Der Quellenauftrag bleibt dokumentiert; kein erfundener Zeitpunkt oder 100%-Abzug.

Einordnung: `source_only_conditional_workflow`. Zugeordnet: `O614-PSM-002`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 8): „Die Angabe der Codes kann auch im Vorhinein erfolgen, wenn ein entsprechender Pflanzenschutzmitteleinsatz geplant ist. Sobald absehbar ist, dass doch kein Einsatz durchgeführt wird, ist die Codierung zu streichen. Änderungen oder Nachtragungen von Codes haben umgehend zu erfolgen.“

### O 614-NATA-AWP-01: Projektbestätigung und Erfüllungsflags brauchen einen nachprüfbaren Evidenzvertrag

Native prüft alle übertragenen Projektbestätigungsflags und bekannte Nichterfüllung korrekt. Landeszuständigkeit, vollständiger Feldstückbestand, tatsächlich festgelegte Maßnahmen und zugehörige Prozentstufen werden jedoch vorausgesetzt. Der Auszahlungspfad summiert Codes und verwendet den separaten Prozentstufenhelper nicht. Kein freier Code wird als amtlich genehmigt ausgegeben; ohne zusätzliches Register-/Prüfobjekt bleibt dies eine Grenze des vorbereiteten Vertrags, kein behaupteter gewöhnlicher Agrarverstoß.

Einordnung: `prepared_project_evidence_contract`. Zugeordnet: `O614-ACCESS-004`, `O614-NATA-001`, `O614-NATA-011`, `O614-NATA-013`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 2): „das Vorliegen einer Projektbestätigung für alle Feldstücke einer Alm. Projektbestätigungen“

### O 614-NATA-AWP-02: Anforderung und bedarfsweise Übermittlung fehlen als Workflow

NATA-/AWP-Kursnachweis nach tatsächlicher AMA-Anforderung (sofern Anbieter nicht übermittelt) sowie Planübermittlung an BMLUK/AMA im Bedarfsfall sind katalogisiert, aber die vier Vorschläge führen keine Anforderungs-/Anbieterübermittlungs-/Antwortfelder und es gibt keinen nativen Verbraucher. Keine Pflicht ohne tatsächlichen Auslöser und keine frei erfundene Eingabe oder Sanktion.

Einordnung: `source_only_requested_document_workflow`. Zugeordnet: `O614-NATA-009`, `O614-AWP-004`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 9): „Eine schriftliche Kursbesuchsbestätigung ist nach Aufforderung an die AMA zu“

### O 614-NATA-AWP-03: Ersatzkurs und bedingte Planaktualisierung sind nur zusammengefasst

replacement_course_completed trägt kein eigenes Datum, Anbieter-, Inhalts- oder Personenobjekt; annual_review_documented trägt weder Aktualisierungsbedarf noch tatsächliche erforderliche Aktualisierung. Die Positivfälle stipulieren diese echten Zusatzfakten ausdrücklich. Eine bloße Jahresprüfung beweist keine notwendige Aktualisierung und ein unqualifiziertes Ersatzflag keinen fristgerechten gültigen Ersatzkurs.

Einordnung: `prepared_conditional_followup_contract`. Zugeordnet: `O614-NATA-008`, `O614-AWP-005`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 9): „geschulte Person vor 31. Dezember 2025 den Betrieb, muss ein Kurs bis dahin“

### O 614-NATA-AWP-04: Verfahrenshelper ersetzt keine Entscheidung über AWP-Übernahme

Die drei Kontextstrings werden quellengetreu als mögliche Einzelfälle erkannt; der Helfer hat keinen Aufrufer im Gesamtentscheidungs-/Zahlungspfad. Bewilligung, Antrag und tatsächliche Übernahme fehlen als eigene AWP-Tatsachen. Die Helperergebnisse sind daher nur eine Verfahrensauskunft und keine automatisierte Freigabe.

Einordnung: `source_procedure_component_scope`. Zugeordnet: `O614-AWP-009`.

Originalbeleg (o6_allgemeine_teilnahmebedingungen_2026_04.pdf, PDF-Seite 15): „Optionaler Zuschlag „Almweideplan“ im Rahmen der Maßnahme „Almbewirtschaftung““

### O 614-NATA-AWP-05: Jahresurteile und vollständiger AWP-Entzug sind offengelegte Konventionen

A-11 erklärt den NATA-Kursfehler schon für das Jahr 2025, ohne as-of-Datum; die Tests urteilen erst über abgeschlossene Fristen. A-10 entzieht für jeden AWP-Pflichtverstoß den gesamten Zuschlag, obwohl die übergebenen Quellen keine feste Sanktionshöhe dieses Verstoßes zuordnen. Nachweis von Pflichtdiagnosen bleibt getrennt vom zulässigen Geldbetrag; kein selbst erfundener 100%-Goldabzug.

Einordnung: `native_disclosed_annual_and_sanction_convention`. Zugeordnet: `O614-NATA-006`, `O614-AWP-003`, `O614-AWP-007`.

Originalbeleg (o6_14_almbewirtschaftung_2026_04.pdf, PDF-Seite 9): „Bis spätestens 31. Dezember 2025 sind von einer am Almbetrieb maßgeblich tätigen“

## Tatsächlich erhaltenes Verhalten

- Die aktuelle Maßnahme erlaubt genau Rinder, Schafe, Ziegen, Equiden und Neuweltkamele; die allgemeineren Wildhuftierklassen aus AnhangA werden nicht als zusätzliche teilnahmefähige Tiere importiert. Vier Zwergrassen, bekannte Geburtstagsgrenzen und kleine/große Equiden wurden anhand der aktuellen Quellen abgegrenzt.
- Mindestteilnahme 3 ha/3 RGVE im ersten Jahr gilt betriebsbezogen über mehrere Almen; danach dürfen beide Werte darunter liegen. Auftriebstag zählt, Abtriebstag nicht;59/60/61 Tage, Unterbrechungen, aufeinanderfolgende Tiere und anteilige Rinder-/Schaf-/Ziegenalpung wurden geprüft.
- 7/14-Tage-Meldegrenzen und Anrechnung, 15.Juli als spätester tatsächlicher Tierauftrieb sowie 17.April/17.Juli nur für die ausdrücklich genannten Antragsfristen 2023/2028 bleiben getrennt. Meldung der Nichteinhaltung ersetzt die fehlende Anwesenheitsqualifikation nicht.
- Maximalbesatz wird je Alm geprüft. Auslandsfläche entlastet nur unter ausdrücklich vorbereitetem aktuellen Jahresnachweis und erhöht keine prämienfähige österreichische Fläche. Post 1.Juli geborene Tiere sind nur beim Maximalbesatz sicher ausgeschlossen; Prämienbehandlung ist die offengelegte AnnahmeA-05.
- Almeigene Silage ab 2025, Fremdalm bei Heuwirtschaft, Eigenalmverbot, almfremdes Grünfutter, Gülle/Jauche, Klärschlamm, separierte Heimbetriebsanteile und erlaubter Heimbetriebsmist sind getrennt geprüft. Biologisch zulässiger Pflanzenschutz aus Maßnahme 14 wird weder mit Herbizidverzicht 11 noch mit Insektizidverzicht 12 gleichgesetzt.
- Flächige PSM-Codes 2025, ausreichendes PSMCS bei gemischtem Einsatz und Wegfall der MFA-Codierung 2026 werden aktuell richtig verarbeitet. Der aktuelle Acht-Quellen-Bestand enthält keine GSP-AV-Fassung; ein in einem anderen Run tatsächlich bereitgestellter Normtext wird hier nicht als übergebenes Gold behandelt.
- NATA-Landesbestätigung auf allen übergebenen Feldstücken, 1,5-RGVE-Grenze, Lebensraumschutz, Eingriffe/Einvernehmen, Kurse und Codezahlungen sind eigene Verbraucher. Die Anhang-E-Prozentstufenhilfe ist vom tatsächlich Codes summierenden Auszahlungspfad getrennt.
- Almweideplan: 4 Stunden, Kreditierungsbeginn 1.Oktober 2024,15.Juli-Fristen, erforderliche Inhalte, Kommunikation und dokumentierte jährliche Prüfung sind tatsächlich geprüft.20 Euro/ha und 20 ha je Alm sowie der Ausschluss mit NATA werden getrennt berechnet. Positive gesamte Zuschlagsentscheidungen sind enthalten.
- Prämien-RGVE, 1 ha/RGVE und Erschließungsstufe werden je Alm separat berechnet. Die unterschiedlichen Beispielalmen können keine freie RGVE-/Flächenkappung untereinander übertragen. Die leere aktuelle Anhang-L-Zeile 14 gilt für die gelisteten prämienmäßigen Einzelflächenkombinationen; bloße andere Betriebsmaßnahmen werden dadurch nicht ausgeschlossen.

## Vollständige Regelzuordnung

| Historische ID | Ergebnis | Prüfung |
| --- | --- | --- |
| O614-SCOPE-003 | implemented | Beide optionalen Verbraucher sind vorhanden; AWP-Geld erst ab 2025. Aktive aktuelle Teilnahme bleibt ein vorbereiteter Eingang, keine Bestätigung eines behördlichen Vertrags. |
| O614-APPL-004 | implemented | Die tatsächlichen Feldstückslisten-Fristen 15.April sowie 17.April 2023/2028 sind mit rechtzeitigem Grenztag und Folgetag geprüft. Null/Meldungsunsicherheit wird nicht als landwirtschaftlicher Verstoß erfunden. |
| O614-APPL-005 | implemented | Tatsächliche verpflichtende Auftriebslisten am 15.Juli bzw.17.Juli 2023/2028 und am jeweils folgenden Tag werden korrekt unterschieden; die reine Rinderalm-Ausnahme ist gesondert geprüft. |
| O614-APPL-006 | implemented | Reine Rinderalm mit vorbereiteter Stufe 1 ist ohne Liste zulässig; Stufe 2, weitere Tierart oder Tierwohl-Behirtung machen sie erforderlich. Verstärkte AWP-Intensität hat einen eigenen Listenverbraucher. |
| O614-APPL-007 | implemented | Tatsächlich bekannter fehlender gesonderter Listeneintrag erzeugt die richtige Meldediagnose. Die Wirkung auf die 2,4-Ausnahme hängt zusätzlich vom vorbereiteten applied-Vertrag ab und wird separat qualifiziert. |
| O614-APPL-008 | partial | Alle fünf tatsächlichen Tiergruppen erhalten den richtigen Verfahrenskanal. Der tatsächlich benutzte Übermittlungsweg und einzelne Registermeldungen sind keine eigenen Eingabefakten. |
| O614-APPL-009 | partial | Der 1.Juli und die gelesenen Geburtstagsschwellen funktionieren bei tatsächlicher Ableitung. rgve_category_id: null verhindert diese Ableitung; bekannte Altersfakten werden dann nicht ausgewertet. |
| O614-APPL-010 | implemented | Tatsächlicher erster Tierauftrieb am 15.Juli wird anerkannt, am 16.Juli nicht; auch 2023/2028 gilt hier keine erfundene 17.Juli-Ausnahme. Alle anderen Tierqualifikationen sind im Grenzfall bekannt erfüllt. |
| O614-APPL-011 | implemented | Für Rinder funktionieren 14-Tage-Grenze, verspätete Anrechnung und Abtriebsdiagnose. Einzelidentität und echter Kanal bleiben vorbereitete Meldefakten, keine aus dem Datum bewiesene Registerprüfung. |
| O614-APPL-012 | implemented | Schaf-/Ziegen-Ohrmarke, 7-Tage-Meldegrenze und Anrechnung sind für tatsächlich bekannte Meldungen geprüft. Der negative Ohrmarkenfall bedeutet bekannte tatsächliche Nichtangabe, keine unbekannte Extraktion. |
| O614-APPL-013 | implemented | Bei bekanntem Verkauf ohne Abtrieb und passender zusätzlicher Tiermaßnahme wird die fehlende Neumeldung erkannt; tatsächlich erfolgte Neumeldung beseitigt nur diese Diagnose. |
| O614-APPL-014 | implemented | Equiden/Neuweltkamele haben 7-Tage-Grenze und Stückzahl. Passendes vorab bekanntes Abtriebsdatum benötigt keine Nachmeldung; bekannt abweichendes Datum erfordert tatsächliche Korrektur. |
| O614-APPL-015 | implemented | Alle betroffenen Schläge benötigen NATA. Tatsächliche Codierung am 15.April bzw.17.April 2023/2028 und einen Tag später ist getrennt geprüft; fehlender Code wird diagnostiziert. |
| O614-APPL-016 | catalog_only | Unabhängige Tierkennzeichnungsmeldungen sind korrekt dokumentiert. Tatsächliche Rinderdatenbank-/VIS-Erfüllung ist kein eigenes Eingabefeld und hat keinen nativen Prüfer; unbekannte Extraktion gilt nicht als Verstoß. |
| O614-ACCESS-001 | partial | Genau 3 ha/3 bekannte prämienfähige RGVE bestehen, 2,99 ha oder 2 RGVE nicht; zwei Almen dürfen gemeinsam die Betriebsschwelle erreichen. A-01 bleibt offen, soweit sonst nicht prämienfähige Tiere für die Zugangsschwelle zählen könnten. |
| O614-ACCESS-002 | implemented | Nach dem ersten Vertragsjahr erzeugen bekannte 0,5 ha/1 RGVE keinen erneuten Mindestteilnahme-Verstoß. Sonstige tatsächliche Förderbedingungen bleiben davon unabhängig. |
| O614-ACCESS-004 | partial | Alle tatsächlich übergebenen Schläge müssen eine positiv geprüfte Projektbestätigung tragen; leere Liste wird abgewiesen. Der vollständige Feldstücksbestand und zuständige Landesaussteller sind vorbereitete Evidenz, kein eigener Registerabruf. |
| O614-AREA-001 | implemented | Inhaltliche Pflichten werden auf allen übergebenen Almen ausgewertet, auch auf positiv bekannter nicht prämienfähiger Kalkalpen-Alm. Ein Prämienausschluss ist kein Befreiungsflag. |
| O614-AREA-002 | implemented | Die drei vorbereiteten Almdefinitionsmerkmale werden tatsächlich verbraucht. Je ein bekannt fehlendes Merkmal verhindert die lokale Almqualifikation und die MAIN-Prämienfläche. Physische Vegetation/Katasterlage bleiben upstream qualifizierte Tatsachen. |
| O614-ANIMAL-001 | partial | Die fünf zulässigen Tiergruppen werden korrekt erkannt, andere bleiben ohne Tierprämie. Die separate Alm-Tage-Summe zählt deren Aufenthalte trotzdem; der lokale Bereichsfehler ist durch den bekannten Schweinefall belegt. |
| O614-ANIMAL-002 | partial | Explizite konsistente Kategorien und die Ableitung bei ausgelassenem optionalen Feld funktionieren. Der erlaubte explizite Nullwert blockiert dagegen die Ableitung trotz bekannter Geburt/Rasse und unterdrückt RGVE/Prämie; zwei gekoppelte Gegenchecks bilden eine Familie. |
| O614-ANIMAL-003 | implemented | Dahomey, Dexter, Kerry und Zwergzebu verwenden den Zwergfaktor; bekannte Standardrasse bleibt beim Standardfaktor. Originale Anhang-A-Fußnote wurde aktuell vollständig gelesen. |
| O614-ANIMAL-004 | implemented | Positiv bekannte Auslandsaufenthalte tragen 0 Tage bei und begründen keine Tierprämie. Dies ist von angrenzender ausländischer Entlastungsfläche beim Maximalbesatz getrennt. |
| O614-GRAZE-001 | partial | 59/60 Tage je Tier, Alm-Union und Unterbrechungen funktionieren. Alm-Tage schließen jedoch bekannte ausgeschlossene Tierarten nicht aus. Der abgegrenzte MAIN bleibt korrekt 0; keine freie Sanktion abgeleitet. |
| O614-GRAZE-002 | implemented | Die konkreten 59/60/61-Tage-Fälle zählen den Auftrieb und schließen den Abtrieb aus; kein zusätzlicher Kalendertag wird erfunden. |
| O614-GRAZE-003 | implemented | Zwei nacheinander 30 Tage aufgetriebene Tiere können 60 Alm-Tage erreichen, ohne einzeln prämienfähig zu werden. Zwei gleichzeitig 30 Tage anwesende Tiere ergeben 30 und nicht 60 Alm-Tage. |
| O614-GRAZE-004 | implemented | Getrennte 30-Tage-Aufenthalte mit tatsächlicher Unterbrechung ergeben 60 Tage; die bekannte Unterbrechung wird weder Tier- noch Alm-Tagen zugerechnet. |
| O614-GRAZE-005 | implemented | Ein bekanntes Rind mit 30/50 Tagen auf zwei Almen erhält exakt 30/80 bzw.50/80 Anteil bei Besatz und Prämien-RGVE. Die Quelle nennt Weitertrieb ausdrücklich für Rinder, Schafe, Ziegen; keine neue gleich starke Goldaussage für jede andere Tiergruppe. |
| O614-GRAZE-006 | implemented | Alle fünf zulässigen Gruppen sind am 7-/14-Tage-Melderand sowie einen Tag darüber geprüft; verspätete Meldung verkürzt tatsächliche Anrechnung korrekt. |
| O614-GRAZE-007 | implemented | Abtriebsmeldung am 7-/14-Tage-Rand bzw. einen Tag später erzeugt die erwartete Diagnose. Equiden-/Neuweltkamel-Ausnahme bei richtigem vorab bekanntem Datum bleibt erhalten. |
| O614-GRAZE-008 | implemented | Bekannt nicht eingehaltene Anwesenheit verhindert Tierprämie. Die erforderliche AMA-Meldung wird getrennt geprüft; erfolgte Meldung stellt die fehlende Tierqualifikation nicht wieder her. |
| O614-GRAZE-009 | implemented | Bei tatsächlich angrenzender Alm wird überlange Heimstallnutzung diagnostiziert. Bekannte Beschränkung auf die Melkdauer ist zulässig; keine unbekannte Stallzeit wird in einen Verstoß umgedeutet. |
| O614-STOCK-001 | implemented | Sechs erwachsene Rinder auf 3 ha erreichen genau 2 RGVE/ha ohne Überbesatz; sieben überschreiten die Grenze. Einzelalmen werden getrennt berechnet, ohne freie pauschale Nullzahlung. |
| O614-STOCK-002 | implemented | Bekannt weniger als 60 tatsächliche Alpungstage und Geburt nach 1.Juli schließen Maximalbesatz-Anrechnung aus. Prämien-Anrechnung eines nach 1.Juli geborenen Tieres bleibt die offengelegte A-05-Konvention. |
| O614-STOCK-003 | implemented | Angrenzende Auslandsfläche entlastet nur mit positiv vorbereitetem aktuellen Jahresbericht samt echtem Bewirtschaftungsnachweis; ohne diesen qualifizierten Status bleibt sie außen vor. Keine ausländische Prämienfläche. |
| O614-STOCK-004 | partial | Der 2,4-Verbraucher verlangt applied und Planbegründung; ein fehlender Jahreslisteneintrag wird separat diagnostiziert. Die Wirkung des applied-Flags bleibt ausdrücklich vorbereiteter Vertragsinhalt. Der Gegencheck ist unter schwächerem Flagvertrag bedingt, bei starkem Wirksamkeitsflag widersprüchlich. |
| O614-STOCK-005 | implemented | Aktive bekannte NATA-Alm verwendet 1,5 RGVE/ha und erhält keinen freieren 2,0-/2,4 Grenzwert. Die gesonderten Kurs-/Projektbedingungen des Zuschlags sind im Child geprüft. |
| O614-FEED-001 | partial | Bekannte verbotene Grundfutterzufütterung wird diagnostiziert. Die natürliche Futter-Suffizienz ist nicht gesondert erfasst; zulässige Ausgleichsfütterung muss upstream richtig klassifiziert sein. |
| O614-FEED-002 | implemented | Bekannt zulässige Ausgleichsfütterung mit Rohfaser-Heu/Mineralien/Milchleistungs-Kraftfutter löst keinen Grundfutterverstoß aus; fremdes Heu darf unter dieser tatsächlichen Funktion vom Heimkommen. |
| O614-FEED-003 | implemented | Silage 2024 und bekannte almfremde Silage 2025 sind verboten; tatsächlich auf derselben Alm im Antragsjahr 2025/2026 produzierte eigene Silage ist unter den übrigen Voraussetzungen zulässig. Produktionsjahr ist vorbereitet, nicht aus einem fehlenden Feld bewiesen. |
| O614-FEED-004 | implemented | Tatsächlich bekannte Verbringung von Alm-Silage auf den Heimbetrieb wird erfasst. Es wird nicht allein aus einem unklaren Herkunfts-/Bestandsstatus auf Transport geschlossen. |
| O614-FEED-005 | implemented | Für einen bekannten Heuwirtschaft-Auftreiber auf tatsächlicher Fremdalm kann die dort 2025 produzierte eigene Alm-Silage dort verfüttert werden. Daraus folgt keine Erlaubnis zur Heimverfütterung. |
| O614-FEED-006 | implemented | Bekannte Heuwirtschaft mit Eigenalm erfasst Silagefütterung, -produktion und-lagerung getrennt. Das Eigen-/Fremdalm-Verhältnis ist explizit bekannt vorbereitet. |
| O614-PSM-001 | partial | Bekannter verbotener Einsatz wird diagnostiziert; die ausschließlich zulässigen Wirkstoffe sind in Positivfällen ausdrücklich upstream verifiziert. Ein false-Flag bei unbekannter Zulässigkeit wäre kein positiver Zulassungsnachweis. |
| O614-PSM-002 | partial | Tatsächliche Codes einschließlich PSMCS bei gemischtem Einsatz sind bis 2025 geprüft. Planung, Erkennen des Nichteinsatzes und umgehende Streichung/Änderung fehlen als getrennte Workflow-Fakten. |
| O614-PSM-003 | implemented | Ab 2026 erzeugt ein tatsächlicher flächiger Einsatz keine MFA-Codierungsdiagnose mehr. Das inhaltliche Zulässigkeitsverbot gilt unabhängig davon fort; kein neuer GSP-AV-Originaltext wird in diesen Quellenbestand importiert. |
| O614-FERT-001 | partial | Bekannte verbotene Düngung wird erfasst; die positive Bio-Zulässigkeit ist in erlaubten Fällen ausdrücklich vorbereitet. Almfremde Gülle, Klärschlamm und separierte Heimbetriebsanteile haben getrennte, unabhängig geltende Verbote. |
| O614-FERT-002 | implemented | Positiv bekannte almfremde Gülle/Jauche löst den eigenen Verstoß aus. Bio-Zulässigkeit allein hebt dieses Herkunftsverbot nicht auf. |
| O614-FERT-003 | implemented | Positiv bekannte Klärschlamm-/kompostierte-Klärschlammausbringung hat einen eigenen Verbotsverbraucher; keine hypothetische Düngermenge wird erfunden. |
| O614-FERT-004 | implemented | Bekannt separierter fester Gülleanteil vom Heimbetrieb wird unabhängig von allgemeinen Bio-Flags erfasst. |
| O614-FERT-005 | implemented | Positiv zulässiger Heimbetriebsmist bleibt erlaubt, auch von einem anderen Heimbetrieb. Mist wird nicht mit almfremder flüssiger Gülle oder separierten Festanteilen gleichgesetzt. |
| O614-NATA-001 | partial | Tatsächlich bekannte Nichtbefolgung der Projektauflagen wird diagnostiziert. Das zusammengefasste Erfüllungsflag ersetzt keine Prüfung einzelner konkret genehmigter Auflagen. |
| O614-NATA-003 | implemented | Alle vier geschützten Lebensraumklassen werden erfasst; Borstgrasrasen bleibt ausgenommen. Tatsächliche Düngung und Lebensraumkartierung sind positiv vorbereitete Fakten. |
| O614-NATA-004 | implemented | Geländekorrektur, Neuentwässerung und Ertüchtigung ohne tatsächliches Landes-Einvernehmen sind getrennte Verbraucher; bestehende rechtmäßige Drainage bleibt zulässig. |
| O614-NATA-005 | implemented | Bekannt tatsächlich neu errichtete Tränke in Feuchtfläche oder Quellflur wird erfasst. Das Flag ist kein bloßer unbekannter Lagebefund. |
| O614-NATA-006 | partial | Stunden, Anerkennung, Inhalt, Rolle und feste Datumsgrenzen werden geprüft. Die Jahresaggregation 2025 ist die offengelegte A-11-Konvention und kein taggenaues Urteil vor Fristablauf. |
| O614-NATA-007 | implemented | Andere Betriebsanrechnung und Doppelanrechnung schließen die Kursgültigkeit aus; Ausnahmen zu grundsätzlich bleiben ggf. externe behördliche Einordnung. |
| O614-NATA-008 | partial | Frühes Ausscheiden ohne Ersatz wird erfasst; das Ersatzflag belegt weder eigenes Abschlussdatum noch weitere Ersatzkursdetails. Die Lesart für genau 31.12. bleibt offen. |
| O614-NATA-009 | partial | Übermittlung nach tatsächlicher AMA-Aufforderung und fehlender Anbieterübermittlung ist nur katalogisiert; diese Workflow-Tatsachen fehlen in den vier Vorschlägen und im tatsächlichen Verbraucher. |
| O614-NATA-010 | implemented | Drei Jahressätze sind vorhanden und werden auf die bekannte prämienfähige Fläche angewandt. Der Betrag bleibt vor gesonderter inhaltlicher Kürzung gemäß offengelegter A-04. |
| O614-NATA-011 | partial | Neun Codes, Grenzen und Einzelgehölzfläche werden geprüft; tatsächliche Auflagen- und Flächenkartierung bleibt die Projektbestätigung. Rohcode und Prozentanteil sind nicht gegeneinander validiert; A-08 legt die gesamte prämienfähige Almfläche zugrunde. |
| O614-NATA-012 | implemented | Der NATA-Verbraucher verwendet dieselbe auf min(Almfläche, RGVE) begrenzte Fläche; Herkunft und Zuordnung der tatsächlich bestätigten Tiere werden positiv vorbereitet. |
| O614-NATA-013 | partial | Landeszuständigkeit, Kartierung und Flächenbezug sind korrekt katalogisiert, aber ohne getrennte prüfbare Evidenzfelder oder automatisierte Verifikation. |
| O614-AWP-001 | implemented | Alle-Almen-Flag und Kursvalidität sind tatsächliche Verbraucher; Vollständigkeit des Almregisters wird upstream positiv vorbereitet. |
| O614-AWP-002 | partial | Kursstunden, Themen, Rolle, Anerkennung, Mehrfachanrechnung und beide Datumsgrenzen werden geprüft. Betriebliche Erfordernisse für eine Ersatzperson sind im Rollenflag vorausgesetzt, nicht gesondert belegt. |
| O614-AWP-003 | implemented | Planerstellung bis 15.07. wird geprüft; ein bestehender Plan mit aktueller dokumentierter unveränderter Überprüfung kann weiter bestehen. Keine taggenaue Behauptung vor Jahresfrist. |
| O614-AWP-004 | partial | Sechs tatsächliche Inhalts-/Kommunikationsflags haben Verbraucher. Die bedarfsweise Übermittlung an BMLUK/AMA besitzt keine Anforderungs- oder Übermittlungsfelder. |
| O614-AWP-005 | partial | Ab dem zweiten Teilnahmejahr wird eine dokumentierte Jahresprüfung verlangt. Aktualisierungsbedarf und tatsächliche Umsetzung einer dann notwendigen Aktualisierung fehlen als getrennte Fakten. |
| O614-AWP-006 | implemented | Bekannte notwendige Planbegründung und der vorbereitete 2,4-Antragsstatus werden geprüft. Der Grenzhelper liest den gesonderten Listeneintrag nicht selbst; dessen Fehlen hat eine getrennte Diagnose. Ob applied bereits die wirksame getrennte Beantragung belegt, bleibt Eingabevertragsgrenze. |
| O614-AWP-007 | partial | 20 Euro je prämienfähigem Hektar, höchstens 20 ha je Alm. Vollständiger Entzug bei jedem AWP-Pflichtverstoß ist A-10; die Quelle bestimmt dafür keine feste Sanktionshöhe. |
| O614-AWP-008 | implemented | Beide gleichzeitig beantragten Optionen werden als Kombination diagnostiziert und beide Zuschlagsbeträge unterdrückt. Auf Almen getrennte Auswahl ist nicht als erlaubte Ausnahme erfunden. |
| O614-AWP-009 | partial | Kontexthelper erkennt drei mögliche Einzelfallkategorien. Das ist eine Möglichkeit zur behördlichen Einzelfallprüfung; Antrag und Genehmigung einer AWP-Übernahme werden damit nicht bewiesen. |
| O614-PREM-003 | partial | Prämien-RGVE werden für bekannte zulässige Tiere und Meldedaten anteilig ermittelt. Null statt ausgelassener optionaler Kategorie unterdrückt bekannte RGVE und im MAIN den nominalen Bestandteil. |
| O614-PREM-004 | implemented | Bei bekannten 1 ha/2 RGVE und 5 ha/1 RGVE entstehen getrennt 1 ha/1 ha Prämienfläche, 2,0/0,2 Besatz sowie Stufen 1/3. Nominaler MAIN-Bestandteil 129,60 Euro; kein freier Flächen-/RGVE-Ausgleich. Den 20 ha-AWP-Deckel je Alm prüft der Child zusätzlich. |
| O614-ACCESSLVL-001 | partial | Vorbereitete bekannte Erschließungsstufen 1/2/3 werden übernommen. Reale Straßen-/Transport-/50 m-Zentrumsmerkmale sind nicht eigenständig im Profil nachweisbar; Zahlenprimitive ausdrücklich offen. |
| O614-ACCESSLVL-002 | implemented | Bei bekannt nicht angrenzenden Teilflächen und stark verschiedenen Zeiten entscheidet die längere Auftriebsperiode. Ein abweichend größerer Alptagewert der anderen Teilfläche ändert diese Grenze nicht. |
| O614-ACCESSLVL-003 | partial | Das vollständige Originalbeispiel 3750 Alptage Stufe 1 und 4800 Alptage Stufe 3 ergibt 2. Allgemeine gewichtete Rundung außerhalb dieses belegten Beispiels bleibt die native A-06-Annahme, kein neues hartes Rechtsgold. |
| O614-GEN-015 | partial | Die aktuelle leere Zeile 14 sperrt die gelisteten prämienbezogenen Einzelflächenkombinationen; bloße betriebliche Teilnahme bleibt möglich. Tiermaßnahmen oder unbekannte Codes werden nicht als gleicher Quellenfall ausgegeben. Keine feste finanzielle Sanktion wird erfunden. |

Die drei katalogisierten Verfahrensregeln `O614-APPL-016`, `O614-NATA-009` und `O614-NATA-013` haben bewusst keinen erfundenen Laufzeitfall: Die tatsächlichen unabhängigen Kennzeichnungsmeldungen, angeforderten Nachweisübermittlungen und Landesregister-/Ausstellerbeweise fehlen als eigene Eingabefakten. Sie sind trotzdem vollständig anhand der Originale und tatsächlichen Profil-/Verbrauchergrenze geprüft.

## Quellenlektüre und Eingabevertrag

Persönlich vollständig gelesen wurden alle 16 Seiten des neuen Merkblatts einschließlich Tabellen, Hinweise, Aktualisierungen 15–16 und Impressum; alle 8 nativen Module mit 1377 Zeilen; alle 17 nummerierten Annahmen samt offenen Rohfragen; alle 4 vollständigen tatsächlichen Profilvorschläge und alle 4 aktuellen Datenobjekte. Die sieben gemeinsamen Originale werden nach exakt gleichen Hashes aus früheren vollständigen Quellenprüfungen wiederverwendet. Aktuell persönlich erneut gelesen: SRL 9–11,18–20,69–71; AnhangA 3,E 10,L 103; ATB 5,7,13,15 sowie der gesamte aktuelle 22.Mai-Artikel mit dem tatsächlichen Almbezug. Die unabhängige NATA/AWP-Person hat dieselben neuen Gesamtlektüren und ihre aktuellen Klauselrereads separat dokumentiert.

| Original | Umfang | SHA-256 |
| --- | --- | --- |
| 20241011_srl_oepul_2023.pdf | 94 | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| 20241011_srl_oepul_2023_anhaenge.pdf | 103 | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| 2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html | HTML-Artikel | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| 2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html | HTML-Artikel | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| 2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html | HTML-Artikel | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| 2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html | HTML-Artikel | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| o6_14_almbewirtschaftung_2026_04.pdf | 16 | `b7958c79e990c03cc1c0624e1ecd3f1e15c94322d00a2ede794c8e52727ecd43` |
| o6_allgemeine_teilnahmebedingungen_2026_04.pdf | 21 | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle acht Dateien wurden gegen ihre tatsächlichen Bytezahlen und Hashes geprüft. Der vollständige Leselog und genaue aktuelle Seitenbindungen stehen im JSON. Weder GSP-AV noch NAPV ist als eigenes Original in diesem Runpaket enthalten. Keine Studie, GM-Konvention, private Fallantwort oder nativer Selbsttest liefert die fachlichen Sollwerte.

Die positiven Produkt-/Projekt-/Anbieter-/Rollen-/Einvernehmens-/Auslandsnachweisflags sind ausdrücklich bekannte vorbereitete Tatsachen. Sie sind keine aus dem Programm gewonnenen amtlichen Beweise. Unbekanntes, tatsächliche Nichtbefolgung und ein unvollständiger Extraktionsdatensatz bleiben getrennt. Die Elterngegenfälle zur RGVE-/MAIN-Wirkung verwenden drei getrennte Rinderobjekte mit Stückzahl 1. Einige Child-Zuschlagfälle projizieren ausdrücklich eine homogene vorgeprüfte Kohorte; echte individuelle Kennzeichnungen und rechtzeitige Einzeltiermeldungen sind upstream vorausgesetzt und aus Sammel-ID/Ohrmarkenstring nicht bewiesen.

Die ursprünglichen Deskriptoren `enum(1|2|3)` für zwei Erschließungsfelder legen ihre JSON-Primitive nicht fest. Alle 331 Zahlenenumvorkommen werden deshalb ausdrücklich als native Zahlen-Komponentenkonvention behandelt. Sie werden weder still in Strings umgewandelt noch als unzweideutig schemakonform zertifiziert.

Die AnnahmenA-01/A-02/A-03/A-05/A-06/A-07/A-08/A-10/A-11/A-12/A-13/A-14/A-16 sind erkennbar erhalten. Insbesondere sind gewichtete Erschließungsrundung jenseits des Originalbeispiels, NATA-Codeanwendung, Jahresurteil vor Fristende und vollständiger AWP-Entzug nicht still zu neuem Rechtsgold gemacht. Inhaltliche Verstöße erhalten keine frei erfundene 100%-Sanktion; berechnete Geldbeträge sind nominale Komponenten vor behördlich bestimmten Kürzungen.

## Konstruktion, Replay und Qualität

Der vollständige frühe 55-ID-/191-Fälle-Entwurf mit ganzen Inputs, Abfragen und Sollwerten wurde vor dem formellen Replay gespeichert; die unabhängigen 23 IDs/127 Fälle ebenfalls. Nach Integration wurden alle 318 Fälle ausgeführt. Dabei aktivierten acht Eltern-Meldungsfälle eine Option, beließen aber versehentlich deren nicht aktive Basis-Antragsdaten bei `null`. Diese Testkonstruktion wurde transparent berichtigt: elf betroffene aktive Optionsfixtures, 78 geänderte Lifecycle-/Kurs-/Planblätter; altes JSON, alter Hash und jede Vorher/Nachher-Änderung sind erhalten. Abfragen und Sollwerte blieben unverändert. Anschließend wurden **alle 318 finalen Fälle** vollständig erneut ausgeführt. Die acht verworfenen Konstruktionsfehler zählen nicht als Modellbefunde.

Der reale Null-Kategorie-Gegenfall wurde dabei beibehalten. Er betrifft einen zulässigen optionalen Nullwert bei tatsächlich bekannten Geburt-/Rassefakten. Die 2,4-Gegenprobe wurde in ihrer Evidenz-/Wirksamkeitslesart ausdrücklich qualifiziert. Die spätere redaktionelle Endfassung änderte keine finalen Inputs, Abfragen, Erwartungen oder tatsächlichen OPA-Ausgaben; ein gemeinsamer Hash bindet diese Felder.

- Runtime: exakt gepinnte OPA 1.18.2, ursprüngliche vollständige Policy- und Datenverzeichnisse, `--strict-builtin-errors`, 10 Sekunden OPA-/20 Sekunden Prozesslimit. Kein Adapter, keine Typnormalisierung.
- 3.698 explizite Enumvorkommen und 60.770 vorhandene Typwerte geprüft. Außer den 331 offen mehrdeutigen Zahlenenumvorkommen keine Abweichung, keine unbekannten Pfade und keine ununterstützten Deskriptoren. Das prüft vorhandene Werte und zertifiziert weder erforderliche Vollständigkeit noch Tatsachenwahrheit.
- 1.816 wörtliche Originalbelegvorkommen mit 191 verschiedenen Bindungen gefunden;0 Fehlbelege, 0 ungeklärte Quellen, 0 Kompakt-Fallbacks. Nur Leerraum/Soft-Hyphen-Ausgleich, keine NFKC-Normalisierung.
- 190 Codebindungs-Vorkommen und 33 Seiten-/Bereichsbindungen besitzen gültige Grenzen; tatsächliche Funktionen und Verbraucher wurden zusätzlich semantisch gelesen. Ein gültiger Zeilenbereich allein gilt nicht als fachlicher Nachweis.

JSON-Endbindung: `7e5ba27bef2bd5e4a77e51eaf2bfe27852fbbb315998e83166e8cb10b3207d63`.
Native-Felder aller 318 Fälle: `0b326198c5f00972b5e279ebe41a6b53856185447459da21d4aa8f6418f98d34`.

Nur `measure.json` und `measure.md` dieses aktuellen Runs wurden im Repository verfasst. Quellen, historische Artefakte, Policies, Canonical und App wurden nicht geändert. Dieser Teil ist zur unabhängigen Root-/QA-Sammlung eingefroren; kein weiterer Run wurde begonnen.
