# o6_1c: zehn offene Fachentscheidungen

Diese Fragen präzisieren die fünf vorhandenen vorläufigen Fragen im Sammelissue #140.
Sie ersetzen oder schließen keine ursprüngliche Frage. Alle Antworten fehlen; keine App-Aufnahme ist freigegeben.

## o6_1c-CATEGORY_YEAR

Welche amtlichen Nachweise und datierten Snapshot-Felder belegen NPA und AFS jeweils getrennt: wirksamer Kategorieantrag, laufender Kalendervertrag, MFA, Erstteilnahme, Abmeldung und gegebenenfalls Übernahme? Wie wird eine mögliche Beantragung für 2027 als begründete Zukunftsnotiz vom Ergebnis für das aktuelle Jahr getrennt?

**Anlass:** Luna liest mehrere vorgeschlagene Antragsteller-/Antragsfelder nicht; Opus setzt fehlenden MFA-Nachweis auf true. App-Auswahl ist kein Kategorieantrag.

Betroffene Gruppen: `participation`, `npa_identity`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 1: „Der Verpflichtungs- und Vertragszeitraum der Maßnahme beträgt grundsätzlich ein Kalenderjahr“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 4: „müssen jeweils vor Vertragsbeginn im Maßnahmenantrag des Mehrfachantrages bis spätestens am 31. Dezember beantragt werden“.

## o6_1c-AFS_ENTITY_IDENTITY

Wie werden amtliche AFS-Element-ID, Geometrie und zugeordnetes Feldstück im Snapshot abgebildet und verbunden? Welche Nachweise liefern direkte Ackerangrenzung, Längsseiten, Anlagejahr, Breite, Länge, Baumzahl und maximalen Abstand? Soll die App eine eigene AFS-Collection führen, und wie werden Mehrfachzuordnung und Doppelzählung ausgeschlossen?

**Anlass:** Luna modelliert AFS am Schlag, Opus als eigenes Element. Die App filtert auf Ackerschläge und verliert beide neuen Strukturen; fehlender Abstand passiert die Opus-Prüfung.

Betroffene Gruppen: `afs_identity_geometry`, `area_codes_combination`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 2: „Agroforststreifen sind direkt an Ackerflächen angrenzende, ab dem Jahr 2020 neu angelegte Elemente“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 4: „Dem Feldstück zugeordnete Agroforststreifen“.

## o6_1c-NPA_QUOTA_PART_AREA

Welche amtliche Flächenbasis gilt für die 4-%-Prämiengrenze und welche für die 50-%-Pflegegrenze? Wie werden früh gepflegte Teilflächen, Mehrfachereignisse, Reinigungsschnitte und GLÖZ-4-Überlagerungen flächengenau und ohne Doppelzählung dokumentiert? Bitte die getrennten Berechnungen und Grenzfälle bestätigen.

**Anlass:** Aggregierte Hektar, Schlagflags und die gesamte Schlagfläche pro frühem Ereignis bilden Teilflächen nicht zuverlässig ab.

Betroffene Gruppen: `npa_management`, `area_codes_combination`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 1: „bis maximal 4 % der Ackerfläche“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „Auf 50 % der nichtproduktiven Ackerflächen ist je Kalenderjahr Mähen/Häckseln frühestens am 1. August erlaubt“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 4: „sind auf dem betroffenen Flächenteil nicht förderbar“.

## o6_1c-NPA_EVENTS_AND_YEAR_END

Welche Ereignisdaten und Vollständigkeitsbestätigungen belegen Neuansaat, Erstdeklaration, Vorjahrespflege, Pflegeart, Biomasseverbleib, Umbruch und Folgekultur? Zählt ein erlaubter Reinigungsschnitt zur Mindestpflege jedes zweiten Jahres? Ab wann darf fehlende Pflege im laufenden Jahr als Verstoß gelten, und wie werden unbekannte Historie und bestätigte leere Ereignislisten unterschieden?

**Anlass:** Opus setzt fehlende Vorjahrespflege auf true und fehlendes Erstdeklarationsjahr auf das aktuelle Jahr; eine Juni-Probe ergibt schon einen Pflegeverstoß ohne Jahresabschluss.

Betroffene Gruppen: `npa_management`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „mindestens 1 x jedes zweite Jahr vorzunehmen“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „Dieser Pflegeschnitt zählt nicht zur Maximalanzahl und hinsichtlich der 50 %-Grenze.“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „Ein Reinigungsschnitt auf bestehenden Grünbrachen ist daher nicht zulässig.“.

## o6_1c-NPA_BIO_PSM_AND_FERT

Welche vollständigen Anwendungsbelege und zeitlich gültigen Zulassungsquellen belegen jegliche Düngung einschließlich P/K sowie PSM-Wirkstoffe? Wie werden NPA-Ausnahmen für ausschließlich BIO-zulässige Wirkstoffe und die engere AFS-Verbissschutz-Ausnahme getrennt erfasst? Welcher Zeitraum und welche Experten-/Betreiberbestätigung gelten jeweils?

**Anlass:** N=0 belegt keine fehlende Gesamtdüngung. Luna verwirft jedes PSM-Flag und liest seine Wirkstoffliste nicht; ein pauschales BIO-Boolean ersetzt keine datierte Zulassungsprüfung.

Betroffene Gruppen: `npa_inputs`, `afs_care_inputs`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „Sowohl der Einsatz von Pflanzenschutzmitteln als auch jegliche Düngung“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „Zulässig sind nur Pflanzenschutzmittel, die ausschließlich Wirkstoffe enthalten“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „Zulässig ist nur der Einsatz von gemäß Bio- Verordnung (EU) 2018/848 zugelassenem Verbissschutz“.

## o6_1c-AFS_TAXON_GSPAV

Welche verbindliche Taxonomie und aktuellen amtlichen Quellen gelten für Arten/Gattungen, fertile Paulownia und Spezialkulturen gemäß GSP-AV §25(4)? Wie werden gepflanzte und natürlich angeflogene Gehölze vollständig erfasst, Bäume von erlaubten Sträuchern unterschieden und unklare Namen zur Klärung markiert?

**Anlass:** Luna erkennt Elaeagnus angustifolia nicht über den Gattungseintrag; Opus tut dies. Die erwähnte GSP-AV-Definition fehlt im vorliegenden Quellenpaket.

Betroffene Gruppen: `afs_species`, `afs_identity_geometry`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 2: „Ölweiden (Elaeagnus)“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 2: „Diese Gehölze dürfen nicht gepflanzt werden und müssen entfernt werden“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 2: „Die Pflanzung von Sträuchern zwischen den Bäumen ist zulässig.“.

## o6_1c-AFS_CARE_ESTABLISHMENT

Welche situationsbezogenen Nachweise gelten für Stabilisierung nach der Pflanzung, Verbissschutz, bedarfsgerechte Pflegeschnitte und dauerhaft begrünten krautigen Bereich? Wie werden Neuanlage, vorhandener Streifen, Gehölzentnahme mit weiter erfüllten Mindestkriterien und fristgerechte Nachpflanzung unterschieden?

**Anlass:** Die Modelle schlagen pauschale Pflegeflags vor. Ob und wann die einzelne Handlung erforderlich war, ist damit noch nicht belegt.

Betroffene Gruppen: `afs_care_inputs`, `afs_identity_geometry`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „wenn die Mindestkriterien weiter eingehalten werden oder eine Nachpflanzung“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 3: „die Stabilisierung nach der Pflanzung mittels Pflanzpfahl, Verbissschutz sowie bedarfsgerechte Pflegeschnitte“.

## o6_1c-COMBINATION_VS_CREDIT

Bitte betriebliche NPA-Unvereinbarkeit mit UBB/BIO samt Teilbetriebs-Ausnahme, Prämienkombination auf derselben Fläche und AFS-Anrechnung auf das Feldstücksminimum getrennt bestätigen. Wie ist AFS gegenüber der Kombinationstabelle Anhang L auszulegen? Welche Daten belegen Feldstückszuteilung und Anrechnung auf 0,15 ha, ohne daraus ungeprüft eine Anrechnung auf andere Quoten abzuleiten?

**Anlass:** Betriebsteilnahme, Zahlungskombination und AFS-Anrechnung sind verschiedene Regeln. Historische Policies lösen die AFS-Kombinationsauslegung nicht verlässlich auf.

Betroffene Gruppen: `area_codes_combination`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 4: „ausgenommen Biologische Wirtschaftsweise – Teilbetrieb mit dem Kulturbereich Wein, Obst und Hopfen“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 4: „zumindest 0,15 ha Biodiversitätsflächen auf Ackerfeldstücken größer als 5,00 ha“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 4: „Nichtproduktive Ackerflächen sind prämienmäßig mit keiner anderen Maßnahme auf der Einzelfläche kombinierbar“.

## o6_1c-OFFICIAL_OP_CODES

Welche amtliche Codeliste mit Maßnahmenbezug gilt für NPA/AFS, OP, VF und maßnahmenbezogene OP-Codes? Welche Ausschlüsse und Ausnahmen betreffen jeweils o6_1c? Bitte den Umgang mit unbekannten Codes sowie benötigte amtliche Dokumente bestätigen; ein beliebiger OP-Präfix darf keine Fachentscheidung ersetzen.

**Anlass:** Opus akzeptiert auch OPINVENTED als OP-Code. Seine Flächen- und Prämienprüfungen verwenden außerdem unterschiedliche Codefilter.

Betroffene Gruppen: `area_codes_combination`.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 4: „Schlagnutzungsart „Grünbrache“ zu beantragen und mit dem Code NPA“.

Original `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 7: „Bei Flächen mit dem Code OP wird im jeweiligen Förderjahr keine ÖPUL-Prämie gewährt.“.

Original `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 8: „eine maßnahmenbezogene Kennzeichnung von Flächen“.

## o6_1c-AREA_AND_PREMIUM

Welche bestätigte Flächenbasis und Erstteilnahmehistorie gelten für die Betriebsmindestgröße einschließlich AFS/LSE ohne Doppelzählung? Welche aktuelle amtliche Grundlage und Darstellung gelten für Prämienband, Modulation und mögliche Auswirkungen von Verstößen? Das Tool soll ein Band von einem bestätigten Zahlungsanspruch unterscheiden; bitte den fachlichen Ergebnisvertrag bestätigen.

**Anlass:** Opus liefert ein positives Band trotz bekannter Düngung. Daraus wird weder tatsächliche Auszahlung noch automatisch eine konkrete Sanktion abgeleitet.

Betroffene Gruppen: `participation`, `area_codes_combination`.

Original `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 5: „Im ersten ÖPUL-Teilnahmejahr muss ein Betrieb mindestens folgende Flächen“.

Original `o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf`, PDF-Seite 5: „Garantiert ist dabei der angegebene Mindestbetrag.“.

Original `o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 19: „Das Prämienausmaß aller Maßnahmen wird in Abhängigkeit zur gesamten Fläche des Betriebes reduziert.“.

