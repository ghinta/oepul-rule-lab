# o6_19: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_19-CURRENT_CONTRACT_HOST_FIRST_YEAR_PERSON_APPLICATION_EXIT

Welche aktuellen bestätigten Personen-, Vertrags-, Antrags-, Zahlungs-, Erstjahres-, Übernahme- und Ausstiegsdaten gelten? Beginn nur 2023/24/25 bis Ende 2028; 1 ha nur im ersten Maßnahmenjahr, danach ein tatsächlich konformer Schlag. Host-Jahr und Stichtag sind maßgeblich. Welche Wirkung haben Wechsel nach NAT, fehlende Zahlungsanträge und Abmeldungen?

**Anlass:** Die App fordert 1 ha jedes Jahr und bestätigt ohne Vertrag. Luna kennt keinen heutigen Vertragsstatus. Opus within_contract_period und mehrere Ausstiegs-/Übernahmehelper sind nicht mit der Gesamtentscheidung verbunden.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 2: „Im ersten Jahr“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 5: „31. Dezember 2025“.

## o6_19-VERSIONED_PROJECT_GIS_INDICATOR_PARAMS_BINDING_AUTHORITY

Welche aktuelle Koordinationsstellenbestätigung, Projekt-/Schlag-ID, Version, EBW-Referenzgeometrie und vollständigen individuellen Indikatoren mit $-Werten gelten? Wer bestätigt verbindlich gegenüber Zusatzindikator? Lebensraum, Zielzustand, Istzustand und bei Teilung mindestens 0,1 ha getrennt erfassen. Fehlende Liste bleibt ungeklärt.

**Anlass:** Luna akzeptiert eine leere Schlagliste. Opus akzeptiert leere Indikatoren und caller binding=false; PB-Designfragen verhindern die Förderung nicht. Code allein ist keine projektbezogene Indikatoridentität.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 2: „je beantragtem Schlag“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 3: „nicht bindend“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 91: „mindestens 0,1 ha“.

## o6_19-ACTUAL_OBSERVATION_DATABASE_TIME_SPECIES_AND_FREE_TEXT

Welche tatsächlichen datierten Beobachtungen, Artidentitäten, Geometrien, Messwerte und strukturierten Datenbanknachweise erfüllen jeden ausgewählten Indikator? Freitext benötigt eine autorisierte konkrete Auswertung. Wiederholte Codes in verschiedenen Lebensräumen nicht vereinheitlichen; EBGT17-Varianten und der abgeschnittene EBGH07-Text sind fachlich zu bestätigen.

**Anlass:** Beide Runs prüfen Ergebnisbools, keine tatsächlichen Indikatorwerte. Opus enthält 144 Kontextzeilen, verwendet zur Auswertung aber nur den Code; frei gesetztes fulfilled/binding kann Zielerreichung vortäuschen. Vollständiger Originalcodevergleich: Luna lässt neun EBPR-Codes aus und enthält EBGB06 ohne Originalcode; Opus enthält alle 100 Codes in 144 Kontextzeilen.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 3: „laufend zu beobachten“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 93: „EBGH07“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 96: „EBGT17“.

## o6_19-ACTUAL_BIENNIAL_CARE_AND_PRIOR_WRITTEN_AMENDMENT

Welche datierten tatsächlichen Pflege-/Nutzungsereignisse und vollständigen Zweijahresverläufe gelten? Wie grenzt die EBW-Zweijahresregel die allgemeinen jährlichen Mindestkriterien ab? Abweichende Bewirtschaftung braucht vorherige Rücksprache und schriftliche Änderung; Zeitpunkt, Fläche und Dokument belegen.

**Anlass:** Luna vertraut globalem Pflegebool. Opus lässt requires_regular_care fehlen und akzeptiert zukünftiges last_use_or_care_year. Allgemeine jährliche Kriterien bleiben in den Notizen offen; Genehmigungsbools enthalten keine Chronologie.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 3: „zumindest jedes zweite Jahr“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 3: „schriftlicher Abänderung“.

## o6_19-TRAINING_REAL_PERSON_EVENT_PROVIDER_DATE_REPLACEMENT

Welche tatsächliche Person, Koordinationsstelleneinladung, Vernetzungstreffen-ID, Datum, Rolle und Besuchsbestätigung erfüllen die Pflicht bis 31.12.2026? Keine Doppelanrechnung auf andere Betriebe oder Pflichten; Ausscheiden vor Frist verlangt Ersatz. Offene Frist und zukünftige Veranstaltung unterscheiden.

**Anlass:** Luna verlangt die Teilnahme bereits im Oktober, setzt sie nach 2026 pauschal voraus. Opus kennt die Frist, akzeptiert aber Zukunftsdatum und freie Rollen; reale IDs und Einladungsbelege fehlen.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 3: „31. Dezember 2026“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 3: „mehrere Betriebe“.

## o6_19-DIV_HABITAT_USAGE_ALL_FIELDPIECES_UBB_BIO_SCOPE

Welche tatsächlichen aktuellen UBB/BIO-Verträge, Kapitel-7-Lebensräume, Erhaltungszustände, zulässigen Schlagnutzungen und Codes erlauben DIV/DIVSZ? Alle Feldstücke und tatsächliche anrechenbare Teilflächen für 0,15 ha über 5 ha erfassen. Wie gelten dortige UBB/BIO-Schwellen und Quoten? Prämienhabitat und Kapitel-7-Name sind keine ungeprüften Aliase.

**Anlass:** Luna hat eine ungruppierte Liste ohne ausführbare DIV-Prüfung. Opus prüft Gruppen, jedoch weder tatsächliche Projektkonformität noch alle UBB/BIO-Quoten; freies Feldstückmaximum und DIV-String genügen für Teile der Berechnung.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 4: „Je Lebensraumtyp“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 4: „mindestens 0,15 ha“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 7: „Lebensräume einmähdig“.

## o6_19-ORIGINAL_RATE_VERSION_FULL_CELLS_NULLS_NAMES_2023

Welche Originaltarife, Zustände, Erschwernisklassen und Habitatnamen werden freigegeben? 2023-Flächenraten fehlen; Slash-Zellen sind nicht automatisch Nullprämien. Auffällige Originalwerte wie 1.124,0 und 1.285,2 unverändert zur Fachprüfung vorlegen. Luna enthält für Frische Magerwiese B/schwer 1.198,8 statt 1.177,2. Braunkehlchen gilt ab 2025 mit 1.053 €.

**Anlass:** Vollständiger Zellvergleich erforderlich, keine Rückrechnung oder Namensnormalisierung ohne Freigabe. Luna hat keinen ausführbaren Vogeltarif und keine Tarifjahresbindung. Opus meldet fehlende Raten, summiert bei fehlender Basis aber teilweise 0 als Gesamtbetrag.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 101: „Frische Magerwiese“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 102: „Braunkehlchen“.

## o6_19-EBBA_ACTUAL_AUTHORITY_REASONS_LIMITS_YEAR_SINGLE_STAGE

Welche tatsächliche dokumentierte Koordinationsstellenvergabe und Belege erfüllen jeden der 15 EBBA-Gründe mit dessen Einschränkungen? Regionale Schnittzahl, tatsächliche Verringerung, Entfernung, Erschwernis, Vorjahresacker, geschützte Art und Nutzung nachweisen. EBBA02 ab 2025 bei Zustand A: ersetzt es EBBA01? Nur einmal je Fläche fachlich bestätigen.

**Anlass:** Opus reason_id übernimmt teilweise das Urteil, prüft Entfernung und Extensivierung nicht vollständig. Zwei EBBA-Codes entfernen den ganzen berechenbaren Satz. Luna reason_qualifies-Bool und EBBA02 lassen konkrete Nachweise weg.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 98: „nur einmal pro Fläche“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 99: „Entfernung über 5 km“.

## o6_19-HABITAT_GIS_OFFICIAL_TYPES_SPECIES_SHARE_GEOMETRY

Welche tatsächliche Landesmeldung, GIS-Version und Schutzgutgeometrie mit förderfähigem Typ/Art erfüllt EBHG01/02? Mindestens 50 % tatsächlicher Fläche für 108 €/ha. Abgrenzung zu NAT-HG und Zuständigkeit bestätigen; freie Prozentzahl ist kein geometrischer Nachweis.

**Anlass:** Opus enthält 24 Typen/38 Arten, konsumiert die tatsächliche Zugehörigkeit nicht. Luna setzt nur den Anteil voraus. Keine aktuellen amtlichen Layerdaten vorhanden.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 100: „ausschließlich“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 100: „zumindest 50 %“.

## o6_19-REGIONAL_PLAN_ANNUAL_CONFIRMATION_REGION_ONCE_NAT

Welche aktuelle jährliche Bestätigung zusätzlich zur Projektbestätigung, abgegrenzte Projektgemeinschaft, Ziele, Pflichten, rechtzeitiger Antrag und Abmeldung gelten? NAT/EBW-Zuschlag nur einmal je Betrieb/Jahr mit tatsächlicher Zahlungsidentität. 250 € im Jahr 2023, 270 € ab 2024; Modulation dieses Betriebsteils klären.

**Anlass:** Opus prüft Antrag/Abmeldung stärker als NAT18, vertraut jedoch Bestätigungsbool und naturschutz_regional_plan_granted. Luna awards_this_year-Helper verhindert Mehrfachvergabe nicht in der Zuschlagsberechnung.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 2: „jährliche Teilnahmebestätigung“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 7: „nur einmal“.

## o6_19-NET_GEOMETRY_GLOEZ_FALLOW_2025_ACCESS_CAP_ALLOCATION

Welche tatsächlichen Nettoflächen, GLÖZ-Teilflächen bis/ab 2025, Stilllegung und feste MFA2025-Basis bestimmen Zugang und Betrag? Negative Werte, Kopien und überlappende Geometrien abweisen. Auswahl/proportionale Kürzung, alte versus neue Maßnahmenfläche, Modulation, 1.500-€/ha-Grenze und weitere Zahlungen fachlich entscheiden.

**Anlass:** Opus negative GLÖZ-Abzüge erhöhen Fläche, fehlende MFA2025-Basis umgeht Zugangskürzung. Proportionale Flächenkürzung und Auswahl gekürzter Zahlungen sind Annahmen. Luna berechnet überwiegend einzelne unverbundene Helper.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 6: „betroffenen Flächenteil“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 6: „25 %“.

## o6_19-ACTUAL_COMBINATION_SCOPE_UNKNOWN_VIOLATION_PAYMENT

Wie werden tatsächliche Kombinationen auf identischer Fläche und Betrieb, ungeklärte Aufnahme, Projektverstöße, amtliche Sanktion und theoretischer Betrag getrennt? Anhang L19 erlaubt 23 und 1A/1B nur LSE; NAT18 am Betrieb, nicht doppelt je Fläche. Kontrollverweigerung/Ausstieg nicht als aktuelle Zahlbarkeit darstellen.

**Anlass:** Luna Kombinationshelper nicht in eligible. Opus Kombinationen und verschiedene Genehmigungs-/Ausstiegs-/Kontrollfragen ändern die positive Prämie nicht vollständig; Sanktion darf nicht automatisch aus jedem Verstoß geraten werden.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 6: „Einzelfläche“.

Original `sources/oepul/originals/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf`, PDF-Seite 5: „am Betrieb kombinierbar“.

## o6_19-DROUGHT_CURRENT_NOTICE_EBW_EXCLUSION_REAL_HARVEST

Welche tatsächlichen datierten Nutzungen, Kultur-/Schlagbezirke und behördlichen Dürrebelege sind aktuell maßgeblich? EBW-Acker-DIV bleibt an Projektbestätigung gebunden; NAT-Freigabe vom 12.08.2026 gilt nicht automatisch für EBW. Grünland-Analogie und Erntepflichtscope fachlich klären.

**Anlass:** Luna Dürrehelper ist nicht mit Aufnahme verbunden. Opus meldet Nutzungsabweichung separat, verwendet den Farmbezirk und boolbasierte Erntegründe; keine tatsächlichen heutigen Ereignisse werden bestätigt.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „Ergebnisorientierte Bewirtschaftung“.
