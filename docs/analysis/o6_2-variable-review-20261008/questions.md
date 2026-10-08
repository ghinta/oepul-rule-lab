# o6_2: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_2-CONTRACT_UBB_BIO_SCOPE

Welche datierten Antrags-/Vertragsnachweise bestätigen eine laufende Teilnahme aus Einstieg 2023–2025, UBB-Verpflichtung, BIO-Teilbetriebs-Kulturbereich und gegebenenfalls Übernahme? Wie werden aktuelles Förderjahr, Vertragsbeginn und zukünftige Möglichkeit getrennt geführt? Bitte die BIO-Teilbetriebs-Ausnahme gegenüber dem älteren SRL-Stand bestätigen.

**Anlass:** Luna führt year, application_year, program und farm.measures parallel; Opus liest farm.year/farm.oepul. Die App übernimmt keine dieser Antragsstrukturen; keine Neuaufnahme 2026 aus bloßer App-Auswahl ableiten.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 5: „Der letzte Einstieg in die Maßnahme ist mit dem Förderjahr 2025 möglich“.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 5: „Kulturbereich Wein, Obst und Hopfen“.

## o6_2-RGVE_FODDER_BASIS

Welche Tierkategorien, alters-/rassespezifischen Nachweise und jahresbezogenen Bestandsmethoden gelten für 0,30 und 1,40 RGVE/ha? Welche Hauptkulturflächen bilden die Futterfläche einschließlich NAT/Bergmähdern und ohne Ackerfutter als Zweitkultur? Können die belegten rgve_cohorts aus #137 nach Scopevergleich wiederverwendet werden?

**Anlass:** Luna verwendet category statt des vorgeschlagenen category_code und zählt Schweine-GVE als RGVE. Die App species_groups sind kein bestätigter Jahresbestand; rgve_cohorts werden nicht im o6_2-Payload konsumiert.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 2: „sämtliche beantragte Futterflächen des Betriebes“.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 6: „die Fläche zählt auch nicht als Ackerfutterfläche“.

## o6_2-N_CURRENT_CALENDAR_YEAR

Welche vollständige Produktionseinheiten-/Flächenbasis in Österreich und welche aktuelle Kalenderjahresmenge nach Stall-/Lagerverlusten und Alm-/Gemeinschaftsweideabzug belegen die 170-kg-Grenze? Welche NAPV-/Faktorquelle wird benötigt, wie wird der Datenstand bestätigt und wie bleiben fehlende Mengen unbekannt? Düngerabnahmeverträge sind getrennt zu erfassen.

**Anlass:** Opus setzt fehlende N-Mengen auf 0. Das App-Feld nitrogen_input_kg_per_ha beschreibt keinen belegten Tierhaltungsanfall nach den verlangten Abzügen.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 3: „Der Wirtschaftsdüngeranfall wird auf Basis des aktuellen Kalenderjahres berechnet.“.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 3: „Düngerabnahmeverträge zur Unterschreitung der 170 kg Stickstoffgrenze können dabei nicht berücksichtigt werden.“.

## o6_2-INPUT_ORIGIN_AND_SLURRY_RETURN

Welche Produkt-/Anwendungs- und Kauf-/Lagerdaten belegen Stickstoffgehalt, betriebsfremde Herkunft, zulässigen Kompost, Wirtschaftsdünger und mengenmäßig passende Biogasgülle-Rücknahme? Wie werden eigene organische Rückstände abgegrenzt und Kauf/Lagerung für andere Kulturen mit Mengenplausibilität belegt? Bitte aktuelle Zulassungsquellen und vollständige Stoffliste bestätigen.

**Anlass:** Lunas external_n_fertilizer_kg==0 unterscheidet keine erlaubten betriebsfremden Mittel. Seine Inventarliste wird nicht gelesen; bei Opus fehlt ein Mengenvertrag für Rücknahme.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 3: „Nur im Falle der Verbringung von Gülle in eine Biogasanlage“.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 4: „Nicht nur der Einsatz, sondern auch der Kauf und die Lagerung“.

## o6_2-PSM_APPLICATION_AND_CODE_YEAR

Welche Wirkstoff-/Produktzulassung, Anwendungsart, Kultur und Datum werden erfasst? Gilt die BIO-Wirkstoff-Ausnahme auch für Saatgutbeizung und Zweitkultur-Ackerfutter? Bitte diese Auslegung bestätigen. Wie werden geplante vs. tatsächliche Anwendungen und PSMBIO/PSMCS bis 2025 vom Wegfall der Codierung ab 2026 getrennt?

**Anlass:** Lunas all_psm_ok bleibt selbst bei ausdrücklich unerlaubter Anwendung true. Opus erlaubt bio-zulässige Beizung; das App-PSM-Flag verliert Wirkstoffe und Anwendungsart.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 3: „Eine Saatgutbeizung zählt als flächige Anwendung und ist daher nicht zulässig.“.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 4: „Ab dem Antragsjahr 2026 entfallen die Regelungen zur PSM-Codierung“.

## o6_2-TRAINING_PERSON_AND_CUTOFF

Welche datierten Kurs-/Personen-/Betriebsnachweise belegen drei anrechenbare Stunden, anerkannten Anbieter, Thema, Rolle, Ausscheiden und ausgeschlossene Doppelanrechnung? Wie wird die zusätzliche UBB-Biodiversitätsschulung getrennt gezählt? Ab welchem tatsächlichen Datenstand ist die Pflicht bis 31.12.2025 abschließend prüfbar?

**Anlass:** Opus meldet schon im Antragsjahr 2025 einen Verstoß ohne as_of; Luna liest das vorgeschlagene Ausscheidedatum nicht. Gemeinsames Schulungsmodell möglich, fachliche Anrechnung getrennt.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 4: „Bis spätestens am 31. Dezember 2025“.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 5: „Doppelanrechnungen von ein und derselben Bildungsveranstaltung auf mehrere Verpflichtungen sind nicht zulässig.“.

## o6_2-PARCEL_CODES_AND_PAYMENT_HISTORY

Welche amtlichen Kulturnamen/Codes und schlagbezogenen Historien gelten für GLÖZ-8-NPF bis 2024, Obstqualität, OP/VF, Flächenab-/zugang und Einzelflächenkombination? Gibt es bei NPF eine Ackerprämie statt Nullprämie? Welche konkrete Fläche wird bei Zugangskappung gekürzt? Bitte Modulation, weitere Zahlungen und behördlich bestätigte Sanktionsstufe voneinander trennen.

**Anlass:** Luna verwendet einen pauschalen Stufensatz für den gesamten Betrieb. Opus wählt eine mittlere Zugangskürzung als Modellannahme; ein bloßer Verstoß legt keine AMA-Sanktion fest.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 6: „keine Ackerfutterflächen-Prämie gewährt.“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 19: „bis zum 200. ha: 100 % der Prämie“.

## o6_2-DROUGHT_PROOF_AND_SCOPE

Welche amtliche 2026-Gebietskulisse, Kulturklassifikation, datierten Ernteausfallnachweise und Behördenentscheidung belegen die Dürreausnahme je Schlag? Wie wird außerhalb der automatischen Kulisse ein noch offenes Ansuchen abgebildet? DIVSZ-/UBB-Ausnahmen dürfen nicht unbesehen zur o6_2-Entscheidung werden.

**Anlass:** Luna verwendet root region und nur parcels[0], Opus Schlagdaten mit farm.region-Fallback. Der App-Adapter transportiert weder diese Regionsdaten noch Dürrebelege.

Original `sources/oepul/originals/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf`, PDF-Seite 2: „Die Förderverpflichtungen beziehen sich auf Ackerland, Grünland, Wein-, Obst- und Hopfenflächen des Betriebes.“.


Zusätzlicher Originalbeleg für `o6_2-DROUGHT_PROOF_AND_SCOPE`: HTML-Mitteilung 12.08.2026 (keine PDF-Seite): „Die in unserer Internetmeldung vom 5. August 2026 ausgewiesene Gebietskulisse wird im Bundesland Steiermark um die Bezirke Graz, Graz-Umgebung, Hartberg-Fürstenfeld, Leibnitz, Südoststeiermark und Weiz erweitert.“.
