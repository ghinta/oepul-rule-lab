# o6_18: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_18-CURRENT_CONFIRMED_CONTRACT_PERSON_APPLICATION_HOST_EXIT

Welche bestätigten aktuellen Verträge/Personen/MFA-/Maßnahmen-/Zahlungsanträge, Übernahmen/Ausstiege und Hostdaten gelten? Hauptstart nur 2023/24/25 bis Ende 2028, mindestens ein tatsächlich konformer Schlag jährlich, nicht bloß ein NAT-Code. Ohne Vertrag/Antrag bleibt Aufnahme unbekannt; frühere oder zukünftige Ereignisse nicht als heutige Erfüllung.

**Anlass:** Luna ignoriert start_year/Vertragszeitraum und vertraut has_managed/defaulttrue. Opus fehlender Antrag/Vertrag/Person erzeugt keinen Fehler; in_contract_period nicht im Premium konsumiert. Numerische Maßnahmen-IDs sind keine App-o6_*-Aliase.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 2: „In jedem Teilnahmejahr“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 6: „Der letzte Einstieg in die Maßnahme“.

## o6_18-PROJECT_ID_VERSION_AUTHORITY_FULL_GEOMETRY_PARAMS_AND_AMENDMENT

Welche zuständige Landesstelle, aktuelle Projekt-ID/Version/Bestätigung, Schlag-/Teilflächengeometrie und vollständigen verbindlichen Auflagen mit $-Werten gelten? Für Zahlung grafische Naturschutz-Referenz, Naturänderung nur nach Rücksprache und vorheriger schriftlicher Abänderung. Bestätigungsbool/freie Codeliste/Parameter ohne Herkunft bestätigt keine individuellen Pflichten.

**Anlass:** Luna erste Parzelle plus globale Bestätigung; Opus present/reference-Bools ohne Dokument/Version, fehlende $-Parameter überspringen Prüfungen. Keine realen Landes-/GIS-Daten verfügbar.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 2: „je Schlag“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 3: „schriftlicher Abänderung“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 6: „grafische Projektbestätigung“.

## o6_18-ALL_PARCELS_FULL_CATALOG_ALIASES_DUPLICATES_AND_RULE_COVERAGE

Welche vollständige jährliche Schlag-/Auflagenliste und bestätigten Alias-/Codeidentitäten werden aufgenommen? Anhang I umfasst 332 Hauptzeilen/353 Codes inklusive 21 Aliase und zwei Jahrstufen GG03/GG04. Gleiche Auflage nicht doppelt zahlen; jeder verbindliche Code braucht tatsächliche maschinelle Prüfung oder explizit unbekannt. Dateninventar ist keine Regelabdeckung.

**Anlass:** Beide Code-Sets vollständig. Luna 83 Ausschnitte enden unter anderem mitten im Wort, GG-Jahrstufe verloren; prüft nur codes erster Parzelle. Opus viele N-/SB-/AD-/GL38..40-/GE-GF-Pflichten und biennial-Felder ungenutzt, behauptete OBL016/017 existieren in Policy nicht.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 62: „konkrete Termine“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 90: „zwei Buchstaben“.

## o6_18-ACTUAL_USE_CARE_REMOVAL_FULL_YEAR_AND_TWO_YEAR_HISTORY

Welche datierten tatsächlichen Nutzungs-/Pflege-/Mahd-/Abtransportereignisse mit IDs/Flächenabdeckung und überjähriger Historie belegen sämtliche Codes? Mindestens zweijährliche Pflege, höchstens drei Grünlandnutzungen; GA13/14/21 benötigen konkretes Startjahr. Jahresabschluss kommt vom Host/Snapshot. Doppelte oder fremdjährige Schnitte/Unterbrechungen sind keine Nutzungen; Mähgutabtransport getrennt belegen.

**Anlass:** Luna freie globale Flags. Opus zählt jedes cutting_dates-Element/Weideperiodenobjekt ohne Jahr/Stichtag/ID, kein Abtransport; falscher year_completed-Bool kann Pflichten verstecken oder verfrüht verletzen. Biennial-Startpflicht wird nicht konsumiert.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 3: „alle 2 Jahre“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 62: „Abtransport des Mähgutes“.

## o6_18-ALL_PROJECT_OPERATION_GATES_ZERO_RATE_CODES_AND_NONBINDING_INFO

Wie werden vollständige Projektauflagen einschließlich Null-Prämiencodes von Empfehlungen und Informationen getrennt? GE/GF-Rotation/Winter, SB-Pflege/Teilflächen/Termine, AD/NE-Kultur-/Saat-/Vertragsgeschichte, NA/NB/NG/NH/NM/NO/NV/NW-$-Pflichten mit jeweiligen Daten belegen. Behördenentscheidung/Ausnahme kennt Dokument, Datum, Pflicht und Fläche; keine fehlenden Pflichten als erfüllt markieren.

**Anlass:** Opus nur Teil der katalogisierten Parameter und abgeleiteten Flags, NE01-Liste ohne Regel; Notiz verweist auf nicht vorhandene Coverage-Helper. Luna prüft die konkreten Katalogpflichten überwiegend gar nicht.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 3: „auch wenn sie“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 80: „Fotodokumentation“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 89: „maximal“.

## o6_18-ACTUAL_RESEEDING_PRIOR_WRITTEN_APPROVAL_BAN_SCOPES

Welche notwendigen Sanierungsereignisse/Gründe und vorherigen schriftlichen Landesgenehmigungen gelten für Ein-/Nachsaat? Maschinelle Entsteinung, Gelände/Ablagerung/Aufschüttung, Neuentwässerung und Siloballen grundsätzlich verboten, spezifische Null-Code-Ausnahmen mit tatsächlichem Scope. o6_17-Mischungs-/300m²-Ausnahme ist keine NAT-Ausnahme.

**Anlass:** Luna resowing_approval-Bool ohne Ursache/Fläche/Datum; Opus enumReason+approvalBool ohne Behörde/Chronologie. Activities sind undatierte globale Schlagflags.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 3: „schriftlicher Genehmigung“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 3: „Keine Lagerung von Siloballen“.

## o6_18-GRAZING_IDS_DATED_UNION_RGVE_VS_GVE_LIMITS_AND_DIARY

Welche eindeutigen Tiere/Kategorien, tatsächlichen Aufenthaltsunionen und Feldstück-/Schlaggruppen bilden die Weideprüfung? WA01/03 Jahres-RGVE, NW05 gleichzeitig GVE, NW06 jährlich GVE, spezifische Fenster und tägliche Dokumentation samt Hinderungs-/Unterbrechungsgründen. Überlappungen/Kopien, Zukunft und negative Aufenthalte abweisen; Schalttag und vollständige Tierklassen fachlich bestätigen.

**Anlass:** Opus NW06 verwendet RGVE statt GVE, NW05 fehlt, unbekannte/pig-Keys fallen aus Summe; keine Tier-ID, union/as_of oder Chronologie, fixer365. Diarybool ersetzt keinen Inhalt; keine tatsächliche Mindestbeweidungspflicht in WA/BA-gates.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 4: „tagaktuell“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 88: „gleichzeitig“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 88: „GVE/ha und Jahr“.

## o6_18-VISIBLE_GRAZING_UNIT_COMPLETE_ALL_PROJECT_SCOPES

Welche natürliche gemeinsam eingezäunte und gleich bewirtschaftete Einheit erlaubt zusammengefasste Weideaufzeichnungen? Alle zugehörigen Projektbestätigungsauflagen müssen gelten. Bergmahd-NAT-Nachweide braucht ausdrücklich erlaubende Auflage und tatsächlichen Termin; auch fehlende vorherige Mahd erlaubt keine Umgehung. GA15/17 und GA16/18 eigene Nutzungs-/Tagebuchscopes.

**Anlass:** Luna einzig grazing_diary_complete. Opus same_managementBool ohne tatsächlichen Feldstückjoin; Bergmahd-Nachweide wird nur bei mindestens einem Schnitt geprüft, notwendige grazing-Ereignisse nicht aus Code erzwungen.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 4: „aller zusammengefassten“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 3: „auch nicht ab dem 16. August“.

## o6_18-PRODUCT_FERTILIZER_ORIGIN_YEAR_BIO_PSM_COMPLETE_RULES

Welche datierten Dünger-, PSM-, Bewässerungs- und Silageereignisse mit Produkt-ID, Menge, Herkunft, Wirkstoffen und Registerstand prüfen die konkreten Projektauflagen? TC01 verlangt die aktuelle EU-Bio-Zulassung; Festmist, sonstiger organischer Stickstoff und Weideausscheidungen sind getrennt zu behandeln. Welche Belege gelten für die besonderen ND-/GI-Pflichten?

**Anlass:** Luna verwendet globale Flags. Opus wertet mehrere besondere Düngerauflagen nicht aus, verwendet teilweise nur Monat und Tag und vertraut bei TC01 einem Zulassungsbool.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 3: „Klärschlamm“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 75: „aktueller EU-Bio-Verordnung“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 82: „kompostiertem Festmist“.

## o6_18-DIV_COUNT_FELDSTUECK_SCOPES_MONITORING_AND_ACTUAL_UBB_BIO

Welche tatsächlichen UBB-/BIO-Verträge, Monitoringoptionen und NAT-/DIV-/DIVSZ-Schlag- und Feldstückidentitäten erlauben die Anrechnung? Die Originalgruppen SA01, GA09–11, GL01–25, GL36/37, GN03 und NM05 müssen mit ihrem Nutzungs- und Pflegescope geprüft werden. Wie gelten die 0,15 ha auf Feldstücken über 5 ha und die jeweiligen UBB-/BIO-Schwellen? Wie ist der Monitoringumfang für TA/TB/TC/TD abzugrenzen?

**Anlass:** Freie Kulturstrings, fehlende Vertragsnachweise und zusammengefasste Feldstückflächen belegen keine tatsächliche Anrechnung. Luna genügt ein Monitoringbool; Opus lässt relevante Maßnahmen- und Flächenschwellen offen.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 4: „TA und TB“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 5: „GL01 bis GL 25“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 5: „mindestens 0,15 ha“.

## o6_18-ANNEX_J_FULL_MATRIX_REQUIRED_AND_EXCLUDED_COMBINATIONS

Welche Codekombinationen gelten auf derselben tatsächlichen Fläche? Anhang J hat 64 Zellen, zählt T zu A und schließt S/H aus. Wie werden Pflichtkombinationen GF/GE, BD/BC und SB/SA01 sowie SC02 und der Ausschluss AA06/AC01/AC03 bestätigt? Anhang L erlaubt für 18 die Kombination mit 23 und mit 1A/1B nur im Landschaftselement-Scope. Die betriebliche Kombination mit 19 erlaubt keine doppelte Flächenförderung.

**Anlass:** Luna lässt S/H aus und ordnet T nicht A zu. Opus bildet die 64 Zellen korrekt ab; fehlende Flächenidentitäten, andere Maßnahmen und doppelte Codes bleiben offen. Kombinationsverstöße verhindern den ausgegebenen Betrag nicht.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 90: „inklusive Auflagen zur Großtrappe“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 73: „mit AA06 nicht kombinierbar“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 7: „punktförmige“.

## o6_18-HABITAT_OFFICIAL_TYPE_SPECIES_LAYER_AND_SHARE_GEOMETRY

Welche aktuelle Landesmeldung und AMA-GIS-Geometrie mit einem förderfähigen Original-Lebensraumtyp oder einer Art belegt HG01/HG02? Die Quelle nennt 24 Typen und 38 Arten. Wie wird der tatsächliche Schutzgutanteil von mindestens 50 % für 108 €/ha berechnet? Schreibweisen und GIS-/Artidentitäten benötigen ausdrückliche Bestätigung.

**Anlass:** Opus enthält die Listen, konsumiert sie jedoch in der Entscheidung nicht. Ein Layerbool und ein freier Anteil lösen den Zuschlag aus. Wald-Wiesenvögelchen weicht bei der Normalisierung wegen eines Leerzeichens im Original ab; dies ist keine Freigabe eines Alias.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 77: „ausschließlich“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 77: „zumindest 50 %“.

## o6_18-REGIONAL_PLAN_CONFIRMED_YEAR_REGION_RENEWAL_AND_SINGLE_PAYMENT

Welche regionale Projektgemeinschaft, Ziele, individuellen Auflagen und jährliche Landes-Teilnahmebestätigung belegen den Zuschlag zusätzlich zur Projektbestätigung? Antrag bis Ende des Vorjahres, letzter Einstieg 2027 für 2028 und Verlängerung nur ohne Abmeldung und mit aktueller Bestätigung prüfen. Wie wird der Zuschlag für NAT und EBW nur einmal je Betrieb und Jahr gezahlt?

**Anlass:** Luna berechnet keinen Regionalbetrag. Opus zahlt trotz Abmeldung und verspätetem Antrag 270 €. Aktueller Behördennachweis und die Behandlung innerhalb der Modulation sind offen.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 2: „jährliche Teilnahmebestätigung“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 7: „nur einmal pro Teilnahmejahr“.

## o6_18-DROUGHT_2026_RELEASE_CURRENT_SOURCE_SCOPE_AND_HARVEST_PROOF

Welche tatsächlichen Nutzungsereignisse und aktuelle amtliche Daten wenden die NAT-Freigabe ab 12.08.2026 für die erste und zweite Nutzung an? Die Mai-Ausnahmen für UBB/BIO und die dritte Acker-DIV-Nutzung gelten nicht für NAT. Wie werden für die 85-%-Ernteausnahme Kultur, Schlagbezirk, tatsächlicher Dürregrund und gegebenenfalls Behördenanerkennung belegt?

**Anlass:** Luna akzeptiert die Mai-Ausnahme auf NAT und einen freien Dürrebool. Opus zählt auch fremdjährige Schnitte; fehlender Ernteanteil kann die Prüfung entfallen lassen. Ein Farmbezirk bestätigt nicht den tatsächlichen Schlagstandort.

Original `sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html`, HTML-Artikel: „von der Ausnahme nicht umfasst“.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „erste oder zweite Nutzung“.

## o6_18-YEAR_RATES_2023_MISSING_GG_K20_NEW_CODES_AND_DUPLICATE_CHARGES

Welche Tarifversionen werden fachlich freigegeben? Der bereitgestellte Anhang gilt ab 2024 und liefert keine Flächenraten für 2023. GG03/GG04 ändern sich ab 2025, K20 endet 2024; neue Codes und der Originalfehler „BI02 und BI02“ benötigen Klärung. Wie werden SA01-/GM01-/HG-Zuschläge und eindeutige Auflagensatz-IDs ohne doppelte Zahlung behandelt? NW23 nennt im Original 0 €/ha.

**Anlass:** Luna verwendet NW23 mit 248,40 €/ha, alte GG-Raten und K20 im Jahr 2026. Opus vervielfacht Beträge durch doppelte Codes. Für 2023 ist der Regionalzuschlag 250 €, der Gesamtbetrag jedoch null; fehlende Flächenraten dürfen nicht erfunden werden.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 62: „ab 01.01.2024“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 65: „ab dem Antragsjahr 2025“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 78: „bis längstens 2024“.

## o6_18-NET_AREAS_FALLOW_GLOEZ_ACCESS_AND_THEORETICAL_PAYMENT_GATES

Welche tatsächliche Prämien-/GLÖZ-Teilflächengeometrie, Stilllegung von höchstens 25 % beziehungsweise jedenfalls 2 ha, MFA2025-Zugangsbasis und weitere Zahlungen bestimmen den Betrag? Negative Abzüge und überlappende Parzellen ablehnen. Wie gelten Flächenkappung, Modulation und 1.500-€/ha-Grenze? Wie werden theoretischer Betrag, ungeklärte Aufnahme und behördliche Zahlungsentscheidung getrennt dargestellt?

**Anlass:** Negative GLÖZ-Abzüge erhöhen bei Opus die bezahlte Fläche. Ausstieg, Kontrollverweigerung, fehlender Zahlungsantrag und Vollkürzungen verhindern den Betrag nicht. Luna liefert trotz Verletzungen positive Beträge und nutzt einen undifferenzierten GLÖZ-Bool.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 7: „betroffenen Flächenteil“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 7: „25 %“.

Original `sources/oepul/originals/o6_18_naturschutz_2025_10.pdf`, PDF-Seite 6: „Auszahlung“.
