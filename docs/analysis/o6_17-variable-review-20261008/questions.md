# o6_17: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_17-CURRENT_CONTRACT_HOST_YEAR_FIRST_YEAR_PROOF

Welche bestätigten Verträge, Anträge, Erstjahresnachweise, Übernahmen und aktuellen Personen-/Betriebsdaten tragen die Empfehlung? Hauptmaßnahme beginnt nur 2023/24/25 und endet 2028, AGL jährlich. Erstjahrbedingungen dürfen weder frei per Bool umgangen noch in späteren Jahren erneut gefordert werden. Hostjahr und aktueller Datenstand statt frei wählbarer Zukunftsjahre.

**Anlass:** Luna akzeptiert Vertragsbeginn 2026/27/28 und null-Erstjahr; Opus prüft fehlendes Antragsdatum nicht und rekonstruiert frühere Zugangserfüllung nicht. App prüft Fläche/Anteil jedes Jahr ohne Vertrag.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 7: „Der letzte Einstieg in die Maßnahme“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 2: „Im ersten Teilnahmejahr“.

## o6_17-ACTUAL_ANNUAL_RGVE_FORAGE_AND_LN_WITHOUT_ALM

Welche tatsächlichen Jahresbestände mit Art, Alter, Rasse, Größe und Haltung in Österreich bestätigen mindestens 0,30 RGVE je ha Futterfläche im Erstjahr? Futterfläche umfasst auch NAT/Bergmähder und die sieben Feldfutternutzungen; LN-Grünlandanteil ohne Alm muss mit amtlichen Flächen und Erstjahreshistorie nachvollziehbar sein. GVE, freie Faktor-/Gesamtwerte und falsch zugeordnete Kulturcodes sind keine bestätigten RGVE.

**Anlass:** Luna konsumiert freie rgve_total/forage_area statt vorgeschlagener Tiermerkmale. Opus vertraut rgve_category ohne Art/Alter und domestic-default true; unbekannte Grünlandnutzungen und Feldfuttercode auf fremder land_use werden mitgezählt.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 3: „Futterfläche“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 3: „förderfähigen RGVE“.

## o6_17-ALL_GRASS_BREAK_HISTORY_SCOPE_AND_PRIOR_PERMIT

Wie werden alle tatsächlichen Umbrüche im gesamten Vertrag, betroffene Einzelflächen/Geometrien, notwendige Schädlingssanierung mit Unterlagen und echte dauerhafte regionale Biodiversitätsmischung erfasst? Bis 300 m² je Einzelfläche, nicht je frei teilbarem Event; negative Flächen abweisen. Aufschüttung über 300 m² braucht vorherige Landesbewilligung. Ungenutzte Flächen im Ereignisjahr und Flächentausch gesondert prüfen, künftige Maßnahmen nur als Notiz.

**Anlass:** Luna nur break-Bool ohne Ausnahmennachweis. Opus DIVRS-Code/Grund genügt ohne Mischung, bool-Bewilligung ohne Datum; eventweise 300 m², ganze Vertragszukunft und fremdjährige Schnittdaten werden konsumiert.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 3: „je Einzelfläche“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 3: „vorab“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 4: „dauerhaften, regionalen“.

## o6_17-TRAINING_SUBJECT_PERSON_DATED_PROVIDER_NO_DOUBLE_CREDIT

Welche einzigartigen datierten Kurse und tatsächlich eingebundenen Personen mit Anbieter-/Themen-/Stunden-/Bestätigungsnachweis erfüllen fünf Stunden 2022 bis Ende 2025? Merkblatt nennt mögliche Themen mit oder, SRL verlangt Inhalt dieser Kurse: fachliche Themenanerkennung und aktuelle Quellenversion bestätigen. Kein Doppelzählen gleicher Kurs-/Person-IDs oder anderer Verpflichtungen; Ersatz bei Weggang vor Frist. Zusätzlich drei Stunden UBB/BIO und fünf Stunden BIO getrennt prüfen.

**Anlass:** Luna vorgeschlagene Kursfelder werden nicht konsumiert. Opus summiert Kopien ohne ID und Themenprüfung; trainingdeadline_passed basiert allein auf Jahr>=2025, zusätzliche UBB/BIO-Stunden sind nicht verbunden.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 4: „Mögliche Themen“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 5: „zusätzlich“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 78: „müssen jedenfalls“.

## o6_17-FIXED_MFA2025_SOIL_BASIS_GLOEZ_AND_UNKNOWN

Welche amtliche MFA-2025-Version/Schlagbasis bestätigt alle Grünlandflächen unter 18 % einschließlich NAT und ohne GLÖZ 2/4/9? Pro angefangene fünf ha eine Probe. Spätere Flächenänderung ändert Basis nicht; absent/null bleibt unbekannt. Bedeutet base bereits Nettofläche oder Bruttofläche vor GLÖZ-Abzug? Keine doppelte oder negative Absetzung.

**Anlass:** Luna freier soil_basis ohne MFA-Join. Opus Bruttobasis minus freiem Abzug; im Jahr 2026 ohne Basis ist required_soil_samples undefined und beide entsprechenden Verstöße verschwinden.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 5: „Mehrfachantrag 2025“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 5: „Naturschutz“.

## o6_17-UNIQUE_SOIL_DATES_LAB_PARAMETERS_GIS_MFA_ASSIGNMENT

Welche eindeutigen Probe-/Ort-/Labor-IDs, tatsächliche Entnahme seit 2022 und chronologische Laborübermittlung bis Ende 2025, Akkreditierung, SGD/EUF, pH/P/K/Humus und zugewiesenes MFA-Jahr/GIS-Ergebnis bestätigen Erfüllung? Keine fremden übernommenen Bodenproben, Duplikate oder Zukunftsproben; Methode/Parameter nicht mit o6_16-N-Prüfung gleichsetzen.

**Anlass:** Luna zählt soil_samples_submitted. Opus zählt identische Objekte und zukünftige Entnahme mit altem Einreichdatum; assigned_mfa_year wird nicht konsumiert. GIS nur Bool.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 5: „pH-Wertes“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 6: „nicht möglich“.

## o6_17-AGL_ANNUAL_SECTION_GEOMETRY_ACTUAL_IDENTIFICATION

Welche jährlichen Begehungs- und Abschnitts-IDs/Geometrien je tatsächlichem beantragten Schlag belegen regelmäßig verteilte, eindeutig identifizierte und blühende fünf Kennarten je Abschnitt? Längste Gerade, mindestens fünf Meter innen, ungefähr zwei Meter Streifen; ungleiche Verteilung erfordert tatsächliche Schlagteilung. Erhebung aus mehreren Besuchen zusammenführen, ohne Arten doppelt zu zählen.

**Anlass:** Luna globale Namensliste ignoriert alle vorgeschlagenen Abschnitte/Identifikationen. Opus Abschnittslisten ohne IDs und bool-Dokumentation belegen keine Verteilung/Blüte/Geometrie.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 8: „in jedem Abschnitt“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 8: „regelmäßig“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 8: „eindeutig identifizierte“.

## o6_17-AGL_VISIT_YEAR_DEADLINE_SOURCE_AND_PHOTO_ALTERNATIVE

Welcher aktuelle Quellenvorrang gilt für Erhebungstermin/Frist? Anhang H sagt jedenfalls vor dem 30. Juni innerhalb einer Empfehlung; Merkblatt nennt jährlich und sinnvolle Mai/Juni-Termine. Keine harte Frist erfinden. Tatsächliches Erhebungsjahr, erster Schnitt und alternativ gleichmäßig verteilte geolokalisierte MFA-Fotos müssen nachgewiesen werden.

**Anlass:** Luna Datums-/Skizzenfelder ungenutzt. Opus beliebiges survey_dates-Element und sketch-Bool akzeptiert Vorjahr/Zukunft; Fotoalternative wird nicht als eigenständiger Nachweis anerkannt.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 60: „vor dem 30. Juni“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 9: „geolokalisierter“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 8: „für jedes Jahr“.

## o6_17-KENNART_GROUP_ID_ALIAS_AND_SOURCE_TAXONOMY

Welche freigegebenen Kennartgruppen-IDs und Aliasregeln gelten für alle 50 Originaleinträge? Mehrere wissenschaftliche Namen einer Gruppenzeile dürfen nicht ohne Entscheidung als mehrere Kennarten gelten. Karthäuser/Kartäuser, Zaunwicke/Zaun-Wicke, Ehrenpreis-Familienabweichung und Taubenkropf-Familienzuordnung zwischen MB/Anhang dokumentieren; keine taxonomische Korrektur ohne Fachfreigabe.

**Anlass:** Luna matcht exakten deutschen Namen, Opus erfundene snake_case-IDs. Beide 50 Gruppen vorhanden; Vollständigkeit erlaubt weder automatische Aliase noch wissenschaftliche Modernisierung.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 9: „Pimpinella major“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 61: „Kartäuser-Nelke“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 61: „Löwenmaulgewächse“.

## o6_17-ACTUAL_USAGE_ANNUAL_AGL_CODE_FIRST_MOW_AND_EXCEPTIONS

Welche amtlichen Nutzungs-/AGL-Codes und tatsächliche erste Mahd bestätigen Zuschlag? Zwei-/drei+-Nutzungen brauchen jährlichen Code und Nachweise. Einmähdige Wiese/Streuwiese automatisch ohne Kennarten/Begehung/Dokumentation, Bergmähder ausgeschlossen. Reine Weide/Brache/sonstige/NAT/GLÖZ mit getrenntem Grund-/AGL- und Pflichtscope prüfen.

**Anlass:** Luna beliebige fünf Namen reichen auch ohne AGL oder gemähte Nutzung; schließt NAT pauschal aus Grundprämie. Opus erkennt Nutzungsenum, aber code_only plus Vorjahrsdaten reicht; unbekannte Nutzungen bleiben in Teilen offen.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 7: „werden automatisch“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 8: „ohne Bergmähder“.

## o6_17-GIS_PARCEL_SCORE_RATE_BOUNDARY_MIXED_SLOPES_AND_AGL_CAP

Welche amtliche Schlag-Geometrie/GIS-Version, durchschnittliche Grünlandzahl pro Schlag und jährliche Tarife gelten? Grenzwert 20: MB bis20 überschneidet ab20, SRL <20 bzw >=20. AGL-Obergrenze 15/25 %, jedenfalls zwei ha und unterschiedliche Steigungen: tatsächliche Auswahl-/Kürzungsreihenfolge bestätigen, keine proportionale Aufteilung als Golden-Regel setzen.

**Anlass:** Luna globaler Score/Slope statt Schlagwerte und 2023 bereits ab2024-Tarife; ganze Betriebsfläche abgestuft als pauschaler Multiplikator. Opus proportionaler AGL-cap ist eigene Annahme, 2025-Flächenbasis bei Fehlen ohne Kürzung.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 7: „Grünlandzahl bis 20“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 79: „Grünlandzahl < 20“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 8: „jedenfalls aber 2,00 ha“.

## o6_17-COMBINATION_ACTUAL_CONTRACTS_FULL_PARCEL_JOIN

Welche aktuellen UBB/BIO/BIO-Teilbetrieb-Verträge auf Betrieb und gleicher Fläche bestätigen Kombination? Anhang L17 erlaubt 1A/1B/2/3/9; keine freie measures-Liste oder bloße Bio-Zertifizierung. Landschaftselemente, NAT/Bergmähder und unterschiedliche Flächen-/Pflichtscopes zusammen mit übrigen Maßnahmen abstimmen.

**Anlass:** Luna combination-Enum, Opus measure_id-Objekte mit ungenutztem is_bio_partial_farm; App prüft keine Pflichtkombination. Opus passende Zeile17, keine vollständige fachliche Matrixfreigabe.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 2: „Teilbetrieb“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 103: „Humuserhalt und Bodenschutz“.

## o6_17-UNKNOWN_VIOLATIONS_THEORETICAL_PAYMENT_EXIT_AND_GENERAL_GATES

Wie werden unbekannte Nachweise, Zugang, Pflichten, theoretischer Betrag, behördliche Sanktion/Ernte-/OP-Ausnahme und tatsächlicher Zahlungsstatus getrennt? Übernahme, Flächenverlust/-zugang, Exit, zweifache Vollkürzung, Modulation und Flächenobergrenzen verbrauchen echte bestätigte Ereignisse. Dürre erzeugt keine pauschale Umbruch-/AGL-Ausnahme; Zukunft nur begründete Notiz.

**Anlass:** Opus premium_payable hängt nur an Zugang; Pflichtverstöße, Generalhelper/Ausstieg/Obergrenzen nicht durchgehend im Betrag. Luna eligible kann mit Bodenproben-Verstoß true bleiben. App slope>=18 ab2025 allein eligible ohne AGL-Nachweis.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 3: „Vertragszeitraums“.

Original `sources/oepul/originals/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`, PDF-Seite 7: „gültigen Vertrag“.
