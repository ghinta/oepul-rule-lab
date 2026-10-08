# o6_3: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_3-CONTRACT_AND_COMPANION_SCOPE

Welche datierten Vertrags-/Antrags-/Übernahmebelege bestätigen Einstieg 2023–2025 und zeitgleiche UBB/BIO/BIO-Teilbetriebs-Kombination im aktuellen Jahr? Wie werden frühere Zugangsnachweise und Folgen eines späteren Kombinationswegfalls getrennt? Der Vertrag endet 2028; Optionen werden jährlich belegt.

**Anlass:** Luna bleibt mit passenden Eingaben auch 2030 eligible und verlangt aktuelle Tierhaltereigenschaft wieder als Zugang. Opus prüft den historischen Antrag in späteren Jahren nicht erneut; die Adaptation benötigt tatsächliche Vertragsnachweise.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 1: „läuft bis 31. Dezember 2028.“.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 2: „Es muss zeitgleich entweder an der Maßnahme“.

## o6_3-RGVE_COHORTS_AND_FIRST_YEAR

Wie werden die inzwischen technisch verfügbaren rgve_cohorts samt stabiler ID, Alter/Rasse/Größe und Bestandsmethode an Heuwirtschaft gebunden? Welche historischen Erstjahresbelege und welche aktuellen Listen-/Perioden-/Lagenachweise gelten? COUNT_BASIS/GROUP_IDENTITY aus dem vorhandenen Dossier bleiben bis zur vollständigen Adapter-/Fachklärung offen; keine willkürliche average_count-Präferenz.

**Anlass:** Luna mappt Pferde pauschal auf große Equiden und erkennt Neuweltkamele nicht. Opus akzeptiert eine Rinderkategorie selbst an einer Schweinegruppe. App-Adapter verwirft die neuen Kategorien und rgve_cohorts.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 2: „Im ersten Jahr der Teilnahme muss die Eigenschaft als tierhaltender Betrieb erfüllt sein.“.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 5: „Rassen mit Widerristhöhe bis 1,48 m und Endgewicht bis 300 kg“.

## o6_3-FORAGE_MINIMUM_PREMIUM_SEPARATION

Welche beantragten Flächen bilden Erstjahresminimum, Futterflächen-Nenner und tatsächlich gemähte Prämienfläche jeweils getrennt? Wie zählen Streuwiesen, Bergmähder, Dauerweiden, NAT-Flächen und Ackerweide, wie werden Zweitkulturen ausgeschlossen? Welche vollflächigen Mahd-/Abfuhr-/Beweidungs- und Vollständigkeitsnachweise gelten?

**Anlass:** Luna bepreist bloß als is_premium_eligible markierte Dauerweide ohne Mahdbeleg. Opus und App-Schnittdatum beweisen keine vollflächige Mahd mit Abfuhr.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 2: „Streuwiesen und Bergmähder zählen nicht für die Erreichung der Mindestteilnahmebedingung.“.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 5: „die Fläche zählt auch nicht als Ackerfutterfläche“.

## o6_3-GREEN_FEEDING_METHOD_AND_HISTORY

Welche bestätigte Methode und datierten Tier-/Fütterungs-/Weideintervalle belegen überwiegende Grünfütterung für alle Raufutterverzehrer zwischen 1.4. und 30.9.? Wie werden Überlappungen, Teil-Tage und Heim-/Alm-/Gemeinschaftsweide sowie wechselnder Tierbestand behandelt? Ein heutiger Nullbestand ersetzt keine Saisonhistorie; keine unbelegte 92-Tage-Definition übernehmen.

**Anlass:** Opus addiert zwei Tageszahlen ohne Intervalle und prüft bei aktuellem RGVE=0 keine Grünfütterung. Die vorhandene Adaptation hat dazu bereits GREEN_FEEDING_HISTORY und ANNUAL_EVIDENCE offen.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 3: „überwiegenden Teil der Vegetationsperiode (1. April bis 30. September)“.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 3: „Dies gilt für alle raufutterverzehrenden Tiere am Betrieb.“.

## o6_3-WHOLE_FARM_FEED_AND_TRANSFERS

Welche vollständigen datierten Futter-/Lager-/Herstellungs- und Abgabebelege erfassen alle Gebäude, Tierarten, Altvorräte und Nebenprodukte? Wie wird ausdrücklich keine Abgabe von einer fehlenden Transferliste unterschieden und trockener Heuzustand einschließlich Kreiseln/Grünfuttertausch belegt?

**Anlass:** Opus behandelt fehlende Silageflags und fehlende Transferliste als keine Verletzung. Luna aggregiert mehrere Vorgänge in globale Booleans; fehlende Detaildaten beweisen keine Einhaltung.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 2: „Dies gilt unabhängig davon, für welche Tierart die Silage eingesetzt werden soll.“.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 3: „Die Abgabe von Mähgut an Dritte darf nur in Form von trockenem Heu erfolgen.“.

## o6_3-ANNUAL_MACHINERY_OPTION

Wie werden der jeweils jährliche Optionsantrag und vollständige Geräte-/Einsatznachweise auf der gesamten Betriebsfläche erfasst? Wie sind stillgelegte Einheiten, getrennte Arbeitsschritte und Eingrasen einzuordnen? Bitte die Auslegung eines vorhandenen stillgelegten Geräts fachlich bestätigen.

**Anlass:** Luna schlägt option_application_year vor, liest es aber nicht. Opus/Adaptation brauchen bestätigte Jahresgültigkeit und situativ belastbare Inventarbelege.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 1: „über ein Kalenderjahr (1. Jänner bis 31. Dezember)“.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 4: „Es darf kein entsprechendes Gerät am Betrieb vorhanden sein.“.

## o6_3-RECOGNITION_INCIDENT_SCOPE

Welche AMA-Dokumente mit betroffener Pflicht, Fläche/Betrieb, Vorfallszeitraum und Rechtsfolge gelten für höhere Gewalt? Wie wird ein früherer anerkannter Vorfall bei späterem Prüfstichtag berücksichtigt? RECOGNITION_TIME bleibt offen; ein globales recognised-Flag oder eine andere Maßnahme betreffende Dürremeldung darf keine pauschale Freistellung erzeugen.

**Anlass:** Opus recognised:true entfernt alle bekannten Verstöße. Die bestehende Adaptation begrenzt Anerkennungen zwar auf Pflichten/Zeiträume, verliert aber frühere Vorfälle, wenn as_of außerhalb liegt.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 3: „Es gilt ein generelles Lagerungsverbot von Silage.“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 15: „Es gelten die Bestimmungen gemäß § 6 GSP-AV.“.

## o6_3-GENERAL_PAYMENT_AND_SOURCE_GATES

Welche aktuellen amtlichen Quellen, Codes/Kombinationszellen, Flächen-/2025-Historien, Modulationsbasis und behördlichen Sanktionen vervollständigen GENERAL_FUNDING und SOURCE_CURRENTNESS? Welche neue Opus-Revision ist tatsächlich freigegeben und mit Hash gebunden? Alte September-Runs bleiben Referenz; ein Prämienbetrag ist kein bestätigter Zahlungsanspruch.

**Anlass:** Opus lässt eine fehlende 2025-Basis ohne Kappung und liefert Prämie neben Silageverstoß. Acht bestehende Promotionsblocker einschließlich OPUS_REVISION bleiben unverändert offen.

Original `sources/oepul/originals/o6_3_heuwirtschaft_2025_10.pdf`, PDF-Seite 4: „Die Förderbedingungen sind jedoch trotz Nicht-Gewährung der Prämie einzuhalten.“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 19: „Das Prämienausmaß aller Maßnahmen wird in Abhängigkeit zur gesamten Fläche des Betriebes reduziert.“.

