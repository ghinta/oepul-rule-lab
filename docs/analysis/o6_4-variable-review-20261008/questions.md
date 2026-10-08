# o6_4: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_4-GIS_AREA_AND_ALPINE_SCOPE

Welche versionierten Schlaggeometrien und amtlichen GIS-Layer belegen mehr als 50 % über 1.200 m sowie örtliche Dauersiedlungsgrenze, schwierige Bewirtschaftung und Heimbetriebshöhe? Was zählt als Almbetrieb und wie ist „in der Regel“ bei angrenzenden Flächen zu bewerten? Absolute Teilfläche und Prozentanteil dürfen nur aus derselben Geometrie/Fassung abgeleitet werden.

**Anlass:** Ein Höhenpunkt ersetzt den Schlagflächenanteil nicht. Opus liest difficult_to_manage nicht in parcel_eligible; Luna und Opus führen unterschiedliche räumliche und Ausnahmeflags.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „mehr als die Hälfte“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „Gebietsabgrenzungen/Seehöhe > 1200 m“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „Bei Almbetrieben kann die Bergmahdfläche“.

## o6_4-CURRENT_CONTRACT_AND_ENTRY

Welche tatsächlichen datierten Antrags-, Vertrags-, Übernahme- und Umstiegsbelege gelten im aktuellen Jahr? Kein neuer Einstieg 2026 aus historischem Vertragsschluss ableiten. Wie werden Jahres-/Stichtag und gültiger Maßnahmenflächenbestand verbunden?

**Anlass:** Luna bindet Vertrags-/Antragshelfer nicht an compliance. Opus liefert Prämien bei fehlendem Maßnahmendatensatz und nach 2028; contract_valid enthält keinen aktuellen Laufzeitfilter.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 1: „läuft bis 31. Dezember 2028.“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 3: „Der letzte Einstieg in die Maßnahme ist mit dem Förderjahr 2025 möglich“.

## o6_4-TWO_YEAR_FULL_MOWING

Welche datierten Mahdbelege bestätigen je Schlag vollflächige Mahd mit Abtransport im laufenden oder Vorjahr? Wie wird vor Abschluss des laufenden Bewirtschaftungsjahres zwischen offenem Nachweis und bestätigtem Verstoß unterschieden? Eine Schnittdatumsliste oder mowed_previous_year allein beweist keine vollflächige Mahd mit Abtransport.

**Anlass:** Luna hat keine Zweijahresprüfung. Opus akzeptiert ein beliebiges Vorjahresschnittdatum und meldet ohne aktuellen Schnitt bereits im Juni einen Verstoß.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „zumindest jedes zweite Jahr eine vollflächige“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „Mahd inklusive Verbringung des Mähgutes“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „maximal eine Mahd“.

## o6_4-METHOD_AND_ANNUAL_BM_CODE

Wie werden tatsächliches Mähverfahren und BM0/BM1/BM2/BM3 je Schlag und Jahr erfasst? Welche Entscheidung gilt bei echten gemischten Verfahren statt bloßem Ausmähen von Bäumen/Felsen? Die belegte BM2-Ausnahme nicht als frei gewählte Mehrheitsregel verallgemeinern.

**Anlass:** Luna berechnet den Satz aus einem Betriebs-BM-Code und prüft das vorgeschlagene Mahdverfahren nicht. Opus liefert einen BM3-Satz selbst bei fehlendem method-Beleg.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 3: „Die Fläche ist mit BM2 zu codieren.“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 3: „mit BM0 zu codieren.“.

## o6_4-AFTERMATH_YEAR_AND_INTERVALS

Welche vollständigen jährlichen Nachweideintervalle gelten, auch im Nichtmahdjahr? Wie werden tatsächliche und geplante Ereignisse sowie frühere Jahre getrennt? Die 2026-NAT-Erleichterung ab 12.8. darf ohne eigene Rechtsgrundlage nicht auf Bergmähder übertragen werden.

**Anlass:** Luna vergleicht historische Startdaten mit dem aktuellen Jahresdatum und markiert zulässige Nachweide 2025 bei Prüfung 2026 als zu früh. Opus hat nur einzelne grazing_dates, keine Ende-/Typbelege.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „Nachweide der Fläche ab dem 16. August.“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „auch in einem Jahr, in dem keine Mahd erfolgt.“.

## o6_4-MANURE_FORM_NEED_AND_ACTIVE_INGREDIENTS

Welche vollständigen schlagbezogenen Anwendungen belegen ursprünglichen bedarfsgerechten Festmist, Herkunft häuslicher Abwässer und ausschließlich BIO-zulässige Wirkstoffe im jeweiligen Registerstand? Wie werden ausdrücklich keine Anwendung und fehlende Liste getrennt?

**Anlass:** Opus solid_manure-Typ prüft Bedarf nicht; fehlende PSM-/Düngerangaben erzeugen keine Unbekannt-Meldung. Luna household_wastewater bestätigt die eigene Herkunft nicht.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „bedarfsgerechte Ausbringung von Festmist“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „nicht in Wasser aufgelöst“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 3: „www.betriebsmittelbewertung.at“.

## o6_4-POINT_LSE_COMBINATION_AND_CODES

Wie wird der Umfang der Ausnahme für punktförmige Landschaftselemente in UBB/BIO gegenüber der allgemeineren SRL-/Anhang-L-Fußnote bestätigt? Welche datierten Antrags-/OP-/VF-Codes und zulässigen Prämienkomponenten gelten pro Schlag, welche Zahlung ist bei Konflikt betroffen?

**Anlass:** Luna erlaubt eine measurespezifische LSE-Kennung, liest component nicht. Opus landscape_element unterscheidet Punkt-/Flächentyp nicht; Konflikte werden angezeigt, Betrag bleibt separat positiv.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 4: „ausgenommen punktförmige“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 4: „Landschaftselemente im Rahmen der Maßnahmen“.

## o6_4-HISTORY_AND_PAYMENT_DECISION

Welche Gesamtbetriebsfläche, 2025-/Vorjahres-/aktuellen Maßnahmenflächen, anerkannte Reduktionsgründe und behördlichen Sanktionen vervollständigen die Zahlungsentscheidung? Keine Mindestmaßnahmefläche erfinden; allgemeine Erstteilnahme-Mindestfläche getrennt prüfen. Wie werden theoretischer Satz/Betrag, Pflichtenstatus und tatsächlich bestätigter Anspruch eindeutig getrennt?

**Anlass:** Opus Prämie bleibt neben Düngerverstoß, fehlendem Antrag oder ausgeschlossen-Flag positiv. Luna rate ist €/ha und keine Gesamtzahlung; viele Allgemein-/Historienhelfer sind in compliance nicht konsumiert.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 2: „es gibt keine Mindestteilnahmefläche.“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 4: „Wenn keine Mahd erfolgt, kann“.

Original `sources/oepul/originals/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf`, PDF-Seite 4: „auch keine Prämie gewährt werden.“.

