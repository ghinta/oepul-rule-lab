# o6_20: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_20-CURRENT_ANNUAL_CONTRACT_HOST_CATEGORY_REENTRY_APPROVAL

Welche heutigen bestätigten Jahresverträge und Kategorien, Personen-, MFA-, Antrags-, Ausstiegs- und Übernahmeereignisse gelten? Einstieg letztmals 2027, 150-Tage-Option noch 2028; jährliche Verlängerung, Erlöschen und tatsächliche behördliche Wiederaufnahme trennen. Host-Jahr/Stichtag statt alter oder geplanter Teilnahme.

**Anlass:** Luna application_valid wird nicht in eligible verwendet. Opus betrachtet einen Altstart als ausreichende Fortsetzung; spätes Wiederersuchen wird schon aus zwei Bools akzeptiert, ohne Behördenanerkennung. Keine heutige Vertragsquelle vorhanden.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 1: „erlischt der Vertrag“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 8: „Förderjahr 2027“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 9: „fristgerechte Anerkennung“.

## o6_20-ACTUAL_CLOSED_CATEGORY_IDS_AGE_SEX_BREED_AND_ALIASES

Welche Tier-/Ohrmarken-/UELN-Identitäten, tatsächlichen Geburtsdaten, Geschlechter, Rassen und Alterswechsel bestätigen die sieben Kategorien und elf RGVE-Klassen? Equiden-Kategorie versus vier Beilagenunterklassen trennen. Luna male_cattle_half_plus ist kein pauschaler 0,6-RGVE-Status; Zwergrinder benötigen Rassenbeleg. Neue species-Enums/Roots erst nach Fachfreigabe mappen.

**Anlass:** Luna beschreibt zehn Unterkategorien und globale Werte. Opus prüft Klassenkompatibilität, nicht tatsächliches Alter/Geschlecht/Rasse; birth_date kann fehlen oder in der Zukunft liegen. Ähnliche Codes sind keine Aliase.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 3: „Männliche Rinder“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 10: „Ohrmarke“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 14: „Zwergrinder“.

## o6_20-FULL_CURRENT_REGISTER_STRUCTURE_CHANGE_AND_UNIQUE_TIERS

Welche vollständigen Rinderdatenbank-/VIS-/AMA-Snapshots mit Herkunft, Versionsdatum, Tieridentität und Heimbetrieb erlauben die Prüfung aller Tiere einer beantragten Kategorie? Unterjährlichen Strukturwechsel mit tatsächlichem Wirkungsdatum und Tier-/Betriebsjoin erfassen; Kopien und ungeklärte Halterzugehörigkeit dürfen den Bestand nicht vergrößern.

**Anlass:** Opus summiert doppelte Tiere, lässt fehlende Meldungs- und Haltungsbools gelten und vertraut frei gelieferter Kategorie. Luna hat keine Einzeltier-/Strukturhistorie. Keine echten Registerdaten verfügbar.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 2: „Betriebsstrukturwechsels“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 8: „Plausibilität“.

## o6_20-CATEGORY_PRESENCE_UNION_VERSUS_EACH_ANIMAL_ACTUAL_GRAZING

Welche tatsächlichen Tagesunionen belegen Kategorie-Mindestanwesenheit, Ersatzketten und Weidepflicht jedes Tieres? Weibliche Rinder dürfen nur beim selben konkreten Tier über beide beantragten Kategorien verbunden werden. 120/150 Tage und erst danach hinzukommende Tiere getrennt prüfen; kein bloßes Summieren von überlappenden Aufenthalten.

**Anlass:** Beide Runs nutzen voraggregierte Weidetage. Opus female_cattle_combined_single_animal_days und min_days_reached_date haben keinen tatsächlichen Tier-/Ereignisnachweis; category presence und ganze Kategoriepflicht bleiben getrennte offene Verträge.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 2: „ein konkretes Tier“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 3: „allen Tieren“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 6: „ab diesem Zeitpunkt“.

## o6_20-ACTUAL_WINDOW_AS_OF_INTERRUPTION_BIRTH_AND_PLANNED_EVENTS

Welche echten datierten Heim-/Alm-/Gemeinschaftsweideereignisse und tierbezogenen Unterbrechungen bilden die Weidetage vom 01.04. bis 31.10.? Zukunft und ungültige oder negative Aufenthalte abweisen. Ablammung/Abkitzung ohne Einzeltierdokumentation braucht zusätzlichen Stalltageabzug und Gruppennachweis; negative Zusatz-Stalltage sind ungültig. Offenes Jahresfenster nicht als abgeschlossen bestätigen.

**Anlass:** Luna weide_period_valid-Bool bestätigt Chronologie. Opus berechnet Bestandszeit, keine tatsächliche Weidetagesunion; der Rest bis 31.10. wird ohne Stichtagsgrenze einbezogen. Freie Zusatz-Stalltage und Tagezahlen können Pflichten umgehen.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 4: „130 (120 + 10)“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 5: „zählen nicht“.

## o6_20-ACTUAL_RGVE214_FULL_ANIMALS_NO_FREE_OVERRIDE

Welche tatsächliche gesamte beantragte Tierbasis wird über 214 Tage im Weidefenster gemittelt? RGVE für Rinder/Schafe/Ziegen zeitanteilig, Equiden/Neuweltkamele nach bestätigter tatsächlicher Beilagenstückzahl. Zugang/Abgang/Alters-/Strukturwechsel und Meldungszeitbezug belegen. Dürfen geprüfte Behördenaggregate statt Rohereignissen verwendet werden, mit welchem Nachweis?

**Anlass:** Luna vertraut average_rgve. Opus average_rgve ersetzt jede Rohberechnung und kann ohne Tiere Aufnahme/Zahlung auslösen. fehlendes compliant_count entspricht applied_count; negative coupled_rgve erhöht den Basisbetrag.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 1: „im Durchschnitt“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 12: „214 Tage“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 13: „205/214“.

## o6_20-DATED_REPORTS_SEVEN_DAYS_EAR_TAG_CORRECTION_AUTHORITY

Welche tatsächlichen Antrags-/Zu-/Abgangs-/Kenntnis-/Korrekturmeldungen erfüllen jeweilige Fristen? Schafe/Ziegen binnen sieben Tagen; bei verspätetem Zugang frühestens Meldedatum minus sieben. Meldung vor Ereignis nicht als bestätigten erfolgten Zugang werten. Rinderabmeldung unmittelbar und Ohrmarkenbezug; Alterswechsel/Verkaufsausnahmen getrennt. Deadline 15.04., 2023/2028 17.04. und Jahrestagbezug bestätigen.

**Anlass:** Opus reported_in_time akzeptiert negative Datumsdifferenz. Fehlendes Individual-Antragsdatum fällt aus; Inputfehler können trotz Zahlung stehenbleiben. Luna Meldeflags sind keine tatsächlichen Meldedaten.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 5: „unmittelbar“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 6: „7 Tagen“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 10: „17. April“.

## o6_20-ALM_TEMPORARY_STAY_DEPARTURE_DELETION_AND_COUNT_REPLACEMENT

Welche tatsächlichen befristeten Alm-/Zins-/Gemeinschaftsaufenthalte erhalten den Heimbetriebsanspruch? Abgang, Löschung und Tod/Verkauf auseinanderhalten; ausschließliche Alpung braucht auch Heimbetriebsantrag. Equiden/Neuweltkamele: echte Ersatztiere, rechtzeitig beantragte maximale Stückzahl, tatsächliche Korrektur und keine spätere Ausweitung.

**Anlass:** Luna generische Ersatz-/Meldeflags. Opus Exclusions sind vorhanden, aber voraggregierte Zahl überschreibt Ausschlüsse; keine vollständige tatsächliche Ersatzkette und keine bestätigte Beilagenstückzahl.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 6: „keinen Abgang“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 7: „Gelöschte Tiere“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 11: „keine Ausweitungen“.

## o6_20-DAILY_DIARY_REAL_GROUP_LOCATION_AND_FULL_CONTENT

Welche tatsächlichen tagaktuellen Aufzeichnungen mit Tiergruppe, allen zugeordneten Feldstücken/Weideorten, Perioden und Hinderungsgründen belegen die gesamte Weide? Zulässige alle-Gruppenvermerke bleiben an echte vollständige Tier-/Schlagbasis gebunden. Alternative Aufzeichnungsformate benötigen dieselben Inhalte.

**Anlass:** Luna diary_complete und Opus sechs Bools sind keine tatsächlichen Inhalte. Bei Opus kann eine fehlende Datenbank als missing_inputs stehen, der Vertrag und Betrag bleiben dennoch positiv.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 4: „tagaktuell“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 5: „notwendigen Angaben“.

## o6_20-ACTUAL_FEED_SUBSTANTIAL_DAY_WATER_SHELTER_NO_FIXED_HOURS

Welche tatsächlichen Futter-/Tages-/Tränke-/Unterstellnachweise bestätigen überwiegende Beweidung und wesentlichen Teil des Tages, auch nachts? Keine frei erfundene Mindeststundenzahl. Gruppenwechselbeispiel und gesamte Dauer einbeziehen. Fehlende Belege bleiben ungeklärt; Behördenfeststellungen von automatischer Förderung trennen.

**Anlass:** App weide_hours_per_day erlaubt noch keine fachliche Schwelle. Opus fehlende Pflichtbools default=true; im Dürrekontext wird teilweise der Verstoß zu einem Prüfhinweis. Ganzjahrespflichtverletzung stoppt Auszahlung nicht vollständig.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 3: „Nacht“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 4: „wesentlichen Teil“.

## o6_20-DROUGHT_ACTUAL_CURRENT_AUTHORITY_SCOPE_AND_PAYMENT

Welche aktuelle behördliche Anerkennung mit Datum, konkreter Pflicht, Tier-/Kategorie-/Betriebsbezug und tatsächlichem Dürreschaden gilt? Der Maihinweis verlangt Berücksichtigung bei Kontrollen, keine pauschale Aufhebung. Antrag und Anerkennung unterscheiden; heutige Empfehlung versus geplante Nachholung als begründete Notiz.

**Anlass:** Luna erzeugt aus fehlendem control_note_acknowledged einen zusätzlichen Verstoß. Opus force_majeure-Bool unterdrückt Weidetagsverstöße, die Prämienberechnung fordert die Tage trotzdem. Dokument-/Jahres-/Scopes fehlen.

Original `sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html`, HTML-Artikel: „Grundfutterbedarf“.

## o6_20-RATES_BANDS_COUPLED_SUPPORT_AND_O6_21_SOURCE_CONFLICT

Welche amtliche aktuelle Auszahlung innerhalb der Bänder 40–60 und 16–24 €/RGVE wird verwendet? Garantieband nicht als bestimmten Satz ausgeben. Tatsächliche gekoppelte Almstützung halbiert laut Merkblatt die Basis, SRL sagt Prämie: gilt dies auch für 150-Tage-Zuschlag? SRL21 nennt beim Weideverweis selbst (21), Originalfehler fachlich bestätigen; tatsächliche Tieridentität für beide Maßnahmen verwenden.

**Anlass:** Opus implementiert nur Halbierung der Basis als offene Lesart. Luna gibt Bänder/Faktoren ohne konkreten Betrag und nutzt coupled_alpine_support_claimed nicht. Kein stilles Korrigieren der SRL-ID.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 12: „Basisprämie“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 85: „die Prämie“.

## o6_20-UNKNOWN_THEORETICAL_PAYMENT_VIOLATIONS_MODULATION_SANCTION

Wie werden ungeklärte Daten, theoretisches Band, bestätigte Aufnahme und amtliche Zahlung/Sanktion getrennt? Fehlende Pflichtdaten und einzelne no_premium-Feststellungen nicht als zahlbar bestätigen. Modulation, unter 50 €, tatsächliche Dopplungsförderung und jährlicher Ausschluss brauchen geprüfte Tatsachen.

**Anlass:** Opus missing_inputs, VIS-/Inputfehler, whole_year/no_premium und same_service_funded_elsewhere blockieren die Kategorienbeträge nicht vollständig. Sanktionstage ist amtlicher Input, keine automatisch erratene Stufe. Alle Freigaben bleiben offen.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 12: „Garantiert“.

Original `sources/oepul/originals/o6_20_tierwohl_weide_2025_10.pdf`, PDF-Seite 12: „beantragten Tiere“.
