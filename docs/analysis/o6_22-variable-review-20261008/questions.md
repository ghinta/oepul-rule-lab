# o6_22: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_22-CURRENT_SNAPSHOT_YEAR_VIS_AND_COMPLETE_REGISTER

Welche heutigen AMA-/VIS-/Betriebs-/Expertensnapshots mit Datums-/Versions-/Bestandsvollständigkeit bilden das aktuelle Förderjahr ab? Fehlenden vollständigen Meldeartikel 02.09.2026 prüfen. Zukunftspläne nur begründete Notiz; kein Jahresmittel aus noch nicht erfolgten Ereignissen bestätigen.

**Anlass:** Luna eigenes livestock.o6_22.year und freie GVE. Opus farm.year ohne as_of-Bindung, Ende 2028 Parameter ungenutzt, keine tatsächlichen VIS-Nachweise.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 12: „Plausibilität“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 13: „Stichtag 1. April“.

## o6_22-ACTUAL_APRIL1_VERSUS_CALENDAR_AVERAGE_AND_CORRECTION

Welche tatsächliche Tierliste am 01.04. oder belegte Kalenderjahres-Durchschnittstierliste ist maßgeblich? Alle Gruppen, Bestandswechsel, datierte Belege und Korrektur innerhalb vier Wochen nach tatsächlicher Mitteilung verknüpfen; Durchschnittsliste darf ohne Jahresdurchschnitt nicht still auf heutigen Besatz zurückfallen.

**Anlass:** Opus average_animal_list_submitted=true fällt bei fehlendem Durchschnitt auf animal_count zurück. Keine belegte Referenzzeit, gruppenübergreifende Identität oder Mitteilungsfrist; doppelte Gruppen verdoppeln Bestand.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 2: „Jahresdurchschnitt“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 13: „vierwöchigen“.

## o6_22-THREE_CATEGORIES_TEN_TIERLIST_ROWS_ALIASES_AND_BOUNDARIES

Wie werden drei Maßnahmenkategorien, zehn förderfähige Tierlistenunterklassen und Zuchteber/Wildschweine tatsächlich zugeordnet? Tierlistengrenzen 50/80/110 kg sind keine Stallgrenzen 50/85 kg. Exakt 32 und 85 kg sowie ältere ungedeckte Sauen/ausgemerzte Zuchttiere und ungedeckte Jungsauen fachlich klären; 0,3 versus Anhang-A-0,5 nicht still gleichsetzen.

**Anlass:** Luna Aggregat-Enums statt Tierlistenjoin. Opus wählt exakt 85 kg anders als Luna; Klärung der Kategorien-/Faktorgrenzen und Alters-/Deckereignisse erforderlich.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 7: „ungedeckte“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 16: „Jungsauen nicht gedeckt“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 3: „Zucht- und Jungsauen“.

## o6_22-FULL_YEAR_ALL_CATEGORY_HISTORY_AND_IMMEDIATE_DEREGISTRATION

Welche tatsächlichen lückenlosen Haltungs-/Gewichts-/Deck-/Schlachtperioden zeigen Erfüllung ab 8/32 kg? Nichtkonforme Tiere ganzjährig abmelden, auch nur zwei Monate Verstoß; bestehende andere Stallung zulässig mit tatsächlichem Ausschluss. Jahresdurchschnitts-Abmeldezahl, Umfang, Zeitpunkt und AMA-Bestätigung erfassen.

**Anlass:** Opus nicht gemeldete Mängel bleiben in Prämien-GVE; negativer Abmeldewert erhöht Prämie. required_deregistration_count bezieht ganze Gruppe ohne tatsächliche Tier-/Periodenmenge ein. Luna unverbundene flags/heads/eligible_gve.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 6: „durchgängig“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 12: „24 Tieren“.

## o6_22-CURRENT_CONTRACT_ANNUAL_RENEWAL_ENTRY_EXIT_AUTHORITY

Welche wirklichen Kategorie-/Zuschlagsanträge, Jahresfortsetzung, Erlöschen, Austausch und behördlich anerkannte verspätete Wiederaufnahme gelten heute? Einstieg Kategorien 2027, Zuschläge 2028, Kompost frühestens 2025. Zukünftiger Ausstieg gehört zur Notiz, Altvertrag nach Programmende braucht neue Quelle.

**Anlass:** Luna eligible hängt nur an participation_gve. Opus frühere Vertragslücken nicht modelliert und zukünftige Dezember-Abmeldung beendet heutigen Vertrag.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 13: „Förderjahr 2027“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 14: „fristgerechte Anerkennung“.

## o6_22-FULL_YEAR_ACTUAL_TGD_RECOGNITION_AND_THRESHOLD

Welche anerkannten tatsächlichen TGD-Teilnahme-/Übermittlungsnachweise decken Volljahr bzw. 15.04.–31.12.2023 ab? Basis über 10 GVE vor/nach Antrag/Ausschluss fachlich bestätigen. Frei behauptete Participates-Bools sind keine behördliche Anerkennung.

**Anlass:** Opus TGD-Verstoß blockiert measure_valid/Betrag nicht; proof_available wird nicht genutzt. Luna keine Vertrags-/Programmgate-Verbindung.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 3: „Tiergesundheitsdienst“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 3: „15. April“.

## o6_22-ACTUAL_PEN_ALL_OCCUPANTS_WEIGHT_SPACE_AND_BEDDING

Welche datierten realen Boxenflächen und vollständigen Besatz-/Gewichtsgruppen belegen Mindestplatz pro Abteil? Kein Kategoriedurchschnitt, homogene Gruppen nur bei belegter Homogenität. 40 % erforderliche Fläche versus tatsächliche zusätzliche Fläche; Sauen/Jungsauen 3/2 und 1,3/0,95 m². Gebäudeboden/Dach/Entwässerung/Einstreu und ständig Gras/Stroh/Heu belegen.

**Anlass:** Luna stall_area_compliant verlangt 40 % tatsächlicher Fläche zusätzlich. Opus jede Gruppe kann dieselbe Boxfläche erneut verwenden, kein Box-ID-Join; missing Fläche steht neben positiven Beträgen.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 7: „nicht für die gesamte Kategorie“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 8: „1,30“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 4: „jederzeit“.

## o6_22-ACTUAL_SOW_MATING_FARROWING_BUILDING_TRANSITION

Welche echten Deck-/Abferkeltermine und Bau-/Umbau-/Platzbefunde bestimmen Sauenfenster? Seit 2013 10 Tage nach Decken bis 5 Tage vor Abferkeln; Bestand bis 2033 28/7 nur wenn ohne Baumaßnahme nicht erfüllbar. Außerhalb entfallen auch Einstreu/Platz, auch unter zehn Sauen bleibt tatsächliche Gruppenpflicht im Fenster.

**Anlass:** Opus Zeitfenster nur Hilfsfunktion, nicht decision-Verknüpfung; Gruppenverstoß auch außerhalb zulässigem Fenster. Luna freier Ausnahme-Bool wird nicht mit Aufnahme verbunden.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 5: „2033“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 6: „ohne bauliche“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 6: „weniger als 10“.

## o6_22-ACTUAL_HEALTH_SINGLE_EXCEPTION_AND_DOCUMENTS

Welche tatsächlichen gesundheitlich notwendigen Einzelperioden, Tier-/Gruppezahlen, Einstreu und aufbewahrten Unterlagen belegen maximal zehn Tage? Über zehn Tage tatsächlichen Anteil vollständig abmelden, nicht gesamte Jahresgruppe erraten.

**Anlass:** Opus akzeptiert Gesundheitsausnahme aus einem Gruppenobjekt, ohne konkrete Tiere/Zeiträume. Luna Reporthelper ohne eligibility-Verbindung.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 5: „maximal 10 Tage“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 5: „Tierarztrechnungen“.

## o6_22-REAL_FREE_RANGE_PERMIT_ROTATION_GEOMETRY_AND_CAPACITY

Welche gültigen Behördenbewilligungen mit Dokumentdatum, wirklichem Gehege-/Schlagjoin und Höchstbestand gelten? Ohne Höchstbesatz maximal 4 GVE/ha; Koppelung nur tatsächlich während Haltung verfügbare Gesamtfläche. Rotationsflächen nicht doppeln, zwei Gruppen auf gleichem Schlag zusammen prüfen; ein Jahr durchgehender Nutzung samt Folgejahr-Fruchtfolge/Grünland ohne Schweinehaltung.

**Anlass:** Opus beliebige rotation_total_area_ha überschreibt echte Fläche, Gruppen jeweils isoliert; negative Dichte möglich. Luna rotation offener Scope und freie actual_gve_per_ha.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 8: „4 GVE“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 9: „höchstens ein Jahr“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 14: „Fruchtfolge“.

## o6_22-REAL_FREE_RANGE_DIARY_FENCES_FACILITIES_AND_SEASONS

Welche tatsächlichen Schlagperioden/Tierzahlen, doppelte Umzäunung, getrennte Futter-/Tränkstellen, Versatz, Dach und gleichzeitige Liegekapazität gelten? Abferkelhütten abhängig von wirklicher Sauenphase; Winterstall außerhalb Freilandzeit getrennt. Andere Aufzeichnungen mit allen Originalinhalten zulässig.

**Anlass:** Beide Modelle verwenden summarische Bools; Opus missing bools lösen viele Prüfungen nicht aus, unknown housing überspringt Stall und Freiland. Keine tatsächlichen Perioden/GIS-/Einrichtungsnachweise.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 9: „Beginn und das Ende“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 8: „Säugephase“.

## o6_22-UNDocked_CATEGORY_ALL_PARTICIPANTS_FULLYEAR_SCOPE

Wie wird Zuschlag unkupiert nur für alle tatsächlichen teilnehmenden Ferkel/Masttiere einer Kategorie während gesamtem Jahr geprüft? Abgemeldete konventionelle Tiere getrennt, keine Einzelbox-/Einzeltieroption und keine Sauenoption.

**Anlass:** Opus tail_docked=true erzeugt Verstoß, lässt Zuschlag trotzdem stehen; noncompliant_groups werden bei Tailprüfung ausgeblendet, ohne tatsächliche Abmeldung. Luna Zuschlaghelper unverknüpft mit eligible.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 9: „gesamten Antragsjahr“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 9: „Einzeltiere“.

## o6_22-GVO_PROTEIN_ALL_SPECIES_STOCKS_EUROPE_AND_REAL_RECIPES

Welche tatsächlichen Futtermittel-/Chargen-/Lager-/Rations-/Einkaufsbelege zeigen im gesamten Jahr GVO-freie europäische Eiweißfuttermittel bei allen Tierarten? Europa umfasst auch Nicht-EU. Mischfutter >20 % TM, Einzelkomponenten in der Regel >20 %, Raufutter ausgenommen; alte Bestände und andere Tierarten beachten.

**Anlass:** Luna all_farm_pigs_compliant ist enger als All-Tierarten-Scope, keine reale Futterdefinition. Opus is_protein_feed behandelt Einzelkomponente nur nach aktuellem Prozent und helper unverbunden; explizit falsche Gesamtbelege verhindern Zuschlag nicht.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 9: „andere Tierarten“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 10: „in der Regel“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 10: „außerhalb“.

## o6_22-ALL_SPECIES_REAL_COMPOST_NAPV_PROOFS_AND_DUPLICATE21

Welche echten gesamten Festmistmengen/Mieten aller Tierarten, Zwei-Termin-/Geräte-/Fremdrechnungs- und NAPV-/Anlage-/Abgabeaufzeichnungen gelten? Zuschlag erst 2025. Wendefreie Alternativen fachlich bestätigen; nennenswert ≠ jede positive Spur, 50:50 nur Beispiel. Gemeinsamer gesamter Mist in Rinder21/Schweine22: sind beide Zuschläge gleichzeitig zulässig?

**Anlass:** Opus zahlt trotz ungültiger/leer erfasster Miete, außer explizitem Kompoststall. Luna benötigt selbst bei legitimer Mischalternative zwei turns; Geräte-/Alternativ-/NAPVhelper nicht in Zuschlagberechnung eingebunden. Quellen klären Doppelzahlung nicht.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 10: „unabhängig von der Tierart“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 11: „nennenswertem“.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 11: „Kompostställe“.

## o6_22-UNKNOWN_THEORETICAL_VERSUS_CONFIRMED_PAYMENT_PERSON_SANCTION

Wie werden unbekannte Pflichtdaten, theoretische Prämie, tatsächliche Aufnahme und amtliche Auszahlung/Sanktion getrennt? Noch ungeklärte Nachweise/Verstöße nicht als gültiger nutzbarer App-Vorschlag ausgeben. Modulation gewichtet, allgemeine 50-€-Ermessensgrenze und echte Sanktionen getrennt.

**Anlass:** App Category C bleibt missing_data. Opus measure_valid trotz fehlender Person/Erstjahr/Boxdaten und Zuschlagsverstößen positiv. Luna eligibility frei, Gesamtbetrag unabhängig von Voraussetzungen; stufenweise Modulationshelper statt gewichteter Gesamtrechnung.

Original `sources/oepul/originals/o6_22_tierwohl-schweinehaltung_2025_10.pdf`, PDF-Seite 15: „abzüglich“.
