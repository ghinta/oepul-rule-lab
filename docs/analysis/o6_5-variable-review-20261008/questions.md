# o6_5: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_5-INDIVIDUAL_IDENTITY_AND_CATEGORY

Welche stabilen Einzeltier-IDs samt Tierart, Kategorie, Rasse, Kennzeichnung/Zuchtbuch und datierten Registerbelegen werden geführt? Wie werden Rinderdatenbank, UELN und beantragte Nicht-Rinder-/Ersatztierrollen zusammengeführt, ohne Tiergruppen als förderbare Einzeltiere auszugeben? Bitte explizite Mappingtabelle für cow/kuh, horse/horses, goat/goats, pig/pigs bestätigen.

**Anlass:** App supported species + animal_count > 0 reicht für eligible ohne Rassen-/Zuchtprüfung. Luna lässt Noriker mit animal_type cow als förderbar passieren; Kategorie/Tierart-Konsistenz fehlt.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 1: „Die Prämie wird einzeltierbezogen“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 6: „durch die AMA aus der Rinderdatenbank“.

## o6_5-BREEDING_SEQUENCE_AND_REPLACEMENT_DATE

Welche datierten Geburts-/Zulassungs-/Zuchteinsatz-/Wurf-/Nachkommen- und Abfohlbelege gelten pro Original-/Ersatztier? Bedeutet jeder zweite reinrassige Wurf eine Sequenzregel oder Quote? Welche Referenz gilt beim Ersatztier vor 31.5.; es muss bei Nachbesetzung alle Verpflichtungen erfüllen. Bitte Herd-/Zuchtbuch-Zuordnung und 42-Monats-Lesart bestätigen.

**Anlass:** Luna nutzt vorab berechnete Alters-/Zuchtbooleans; Opus 50%-Wurfquote und max(Stichtag,Nachbesetzung) sind unbestätigte Lesarten. Probe erlaubt eine erst nach April-Nachbesetzung erstmals abfohlende Stute.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 2: „mindestens jeder 2. Wurf reinrassig“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 52: „alle Förderverpflichtungen zum Zeitpunkt der“.

## o6_5-COMPLETE_REPLACEMENT_GRAPH

Welche vollständige datierte Nachbesetzungskette und tatsächlichen Bestands-/Zugangsnachweise gelten ohne feste Tiefengrenze? Wie werden gleiche Rasse, eindeutige Zuordnung, mehrere Kandidaten, Rinder-Frist und Prämienminimum fachlich bestätigt? Eine replacement_date ist kein tatsächlicher Nachweis, dass das Tier am Betrieb war.

**Anlass:** Opus begrenzt Ketten auf zwei Ersatzebenen und prüft bei Ersatztieren on_farm_from nicht. Luna Melde-/Nachbesetzungshelfer sind nicht an eligible gebunden.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 4: „Innerhalb von 5 Wochen“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 4: „Die Frist gilt“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 4: „auch über den 31. Dezember“.

## o6_5-DROUGHT_2026_HOLDING_AND_REPORT_SCOPE

Wie gelten die aktuelle AMA-Mitteilung und vollständige Bestandsbelege für Haltedauer bis einschließlich 31.8.2026, Abgang ab 1.9. und fortbestehende Bewegungsmeldungen? Welche Nachbesetzungspflicht gilt für Abgänge am 31.8., Ersatz nach 31.8. und ggf. Rinder? Die entfallende Nachbesetzungsmeldung nicht mit pauschalem Ende aller Meldepflichten gleichsetzen.

**Anlass:** Beide Runs ändern das Haltedatum. Luna kann mit held_to=31.8. und tatsächlichem unrepariertem Juli-Abgang eligible bleiben; datiertes Bestandsereignis und zusammengefasster Haltebeleg widersprechen sich.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „die Haltedauer bis einschließlich 31. August (anstatt 31. Dezember)“.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „Die vorgeschriebenen Meldungen zu Tierbewegungen (bis Ende des Jahres) müssen weiterhin erfolgen.“.

## o6_5-DATED_ORG_CONFIRMATION_AND_ACTUAL_REPORTS

Welche verantwortliche Zuchtorganisation bestätigt welches Tier/Antragsjahr einschließlich Zuchtbuch, Kategorie, Programm und Milchleistungskontrolle bis 10.2. des Folgejahres? Wie wird pending bis Fristablauf von fehlend/abgelehnt unterschieden? Welche AMA-/VIS-/Rinder-/UELN-Meldungsbelege und welche Rechtsfolgen gelten bei fehlender Vorab- oder verspäteter Meldung? Vollständigen Hinweis vom 2.9.2026 ergänzen, Sidebar-Teaser genügt nicht.

**Anlass:** Luna application_and_confirmation ist vorgeschlagen, aber für eligible nicht konsumiert. Opus confirmed ohne Datum zählt fristgerecht; Meldefindings lassen eligibility/Payout bestehen, Rechtsfolge offen. September-Mitteilung ist im Quellpaket nicht als voller Artikel vorhanden.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 3: „bis spätestens am 10. Februar des“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 5: „Vor der Weitergabe“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 6: „unabhängig“.

## o6_5-TEMPORARY_ABSENCE_INTERVAL_EVIDENCE

Welche datierten Abwesenheitsintervalle und Betreuungs-/Verfügungsgewaltbelege gelten für Zuchtstation, männlichen Zuchteinsatz, Alm-/Gemeinschafts-/Fremdweide und belegte Kurzaufenthalte? Kalenderdauer, Vorabmeldung, nichtnegatives Intervall und jährliche Zuordnung müssen aus tatsächlichen Daten geprüft werden, keine frei eingegebenen duration_days/months übernehmen.

**Anlass:** Luna Dauerzahlen werden nicht aus Daten abgeleitet oder an eligible gebunden. Opus akzeptiert end_date vor start_date als negative Kurzaufenthaltsdauer.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 5: „maximal 6 Monate“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 5: „maximal 3 Monate“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 5: „maximal 10 Tagen“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 4: „Verfügungsgewalt“.

## o6_5-ACTUAL_GEP_AND_MILK_PROGRAMME

Welche jährliche Verbandsbestätigung belegt tatsächliche GEP-Umsetzung und individuellen Auflagen-/MLK-Status? Alle 27 Rassen, Prämienstufen, GEP-Kennungen und sechs Annex-D-Programmauflagen versioniert übernehmen; Tabellenfähigkeit allein bestätigt keine Umsetzung. Steirische Scheckenziege hat laut Annex D/MB GEP ja: Luna false berichtigen erst im späteren zugelassenen Kandidaten.

**Anlass:** Luna liefert 64,8 statt tabellarisch 86,4 Euro für diese Mutterziege. Beide Runs vergeben GEP sonst allein nach breed.special_gep; Lunas program_implemented bleibt ungenutzt, sechs Auflagen nur als Datenliste.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 5: „falls ein besonderes Generhaltungsprogramm vom jeweiligen Zuchtverband“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 9: „Steirische Scheckenziege B ja“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 9: „gezielte Paarung nach Anpaarungsplan“.

## o6_5-ANNUAL_CONTRACT_AND_APPROVED_REENTRY

Wie werden jährlicher Vertrag, automatische Verlängerung, mindestens ein tatsächlich förderbares Tier, Abmeldung und Wiedereinstieg mit ausdrücklicher AMA-Entscheidung im aktuellen Jahr gebunden? Korrektur plus Ersuchen ist keine unterstellte Genehmigung. Letzter Einstieg 2027 von Fortsetzung bestehender Verträge unterscheiden; Zukunft nur begründete Notiz.

**Anlass:** Luna contract_year_valid/application_on_time sind nicht an eligible gebunden und bleibt 2029 eligible. Opus reentry_ok unterstellt Genehmigung bei zwei Booleans; ohne aktuellen Jahres-/Snapshot-Gate können laufende Auszahlung und Folgevertrag über den Programmrahmen hinaus erscheinen.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 1: „grundsätzlich ein“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 1: „Kalenderjahr“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 6: „gesondertes“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 6: „schriftliches Ersuchen an die AMA“.

## o6_5-GENERAL_PROVENANCE_AND_PAYMENT_SCOPE

Welche tatsächlichen Bewerber-/Erstteilnahme-/anrechenbaren Flächen-/Kontroll-/AMA-Sanktionsbelege gelten? Mindestfläche und gewichtete Modulation mit bestätigter Flächenbasis getrennt vom Tierbestand; Kleinbetrag-Ermessen auf Gesamtauszahlung, keine Tierprämien-ha-Kappung erfinden. Wie werden theoretische Prämie, Zugangsstatus, offene Melde-/Bestätigungsfälle und behördlich bestätigte Auszahlung getrennt?

**Anlass:** Opus ist stärker an applicant/contract und externe Kürzungsstufe gebunden, nimmt bei unbekannter Erstteilnahme aber Mindestfläche nicht als offen auf; Nullfläche erzeugt Modulation 1. Vollständigkeit, Jahresabschluss und AMA-Entscheidung fehlen.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 7: „Prämien“.

Original `sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf`, PDF-Seite 1: „mindestens einem förderbaren Tier“.
