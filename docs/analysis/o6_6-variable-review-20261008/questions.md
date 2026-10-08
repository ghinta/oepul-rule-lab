# o6_6: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_6-PARCEL_VERSUS_GLOBAL_PROFILE

Wie werden Maßnahmen-/Vertrags-/Schlagidentität und tatsächlicher Antragsbestand erfasst? Luna o6_6-Wurzel enthält globale Flächen/Variante und eine kaum konsumierte eigene parcels-Liste, Opus verwendet land.parcels[].operations.cover_crop. Pro Schlag/Jahr beantragte Variante mit Host-Jahres-/Snapshotkontext verbinden; beide Pfadsets nicht pauschal zusammenführen.

**Anlass:** App Flächen-/Bodenbedeckungsproxy liefert eligible ohne Variante/Saat/Vertrag. Luna leeres o6_6-Profil liefert eligible trotz profile_missing.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 2: „schlagbezogen beantragten“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 2: „zumindest 1,50 ha Ackerfläche“.

## o6_6-VARIANT_CALENDAR_AND_PERIOD_ENDPOINT

Welche bestätigten Jahres-/Datumsregeln gelten für alle sieben Varianten samt Untersaat-Erntedatum und Grenzen am frühesten Umbruchtag? Variante 1 ab 2025: tatsächliche 70 Kalendertage und mindestens 15.9.; V3 endet im Anlagejahr, V2/4/5/6/7 im Folgejahr. Bitte halboffene Verbotsintervalle/Tagzählung bestätigen statt vorab eingegebener Dauer vertrauen.

**Anlass:** Luna vertraut days_between_sowing_and_break und akzeptiert falsche 70-Tage-Angabe. Opus leitet Daten ab, setzt aber die offene Lesart [Anlage,Ende) als Regel voraus.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 8: „Der Tag der Anlage der“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 8: „Der Tag des Umbruchs“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 9: „21. März des Folgejahres“.

## o6_6-MIXTURE_SPECIES_SEED_AND_CURRENT_CATALOGUE

Welche belegte Arten-/Familien-/Bestandsanteils-/Saatgutliste gilt pro Schlag? Luna Mischungspartnerobjekte vs. konsumierte Namensstrings, Anteil 0–1 vs. Opus Prozent 0–100, Mungo/Ramtillkraut/Schwarzsamen und andere Synonyme explizit mappen; nicht als mehrere Partner zählen. Aktuellen Saatgut-/EU-Katalog für V6 mit Sortenbeleg/Nachbau einbinden, historische Beispielsorten nicht als abschließende Liste behandeln.

**Anlass:** Luna vorgeschlagene mixture_crops-Objekte sind für variant_6_crops_valid unzulässig, erlaubter String funktioniert. Opus feste 4 AT/19 EU-Sorten schließen spätere Zulassungen aus; Beispielarten/exakte Namen beweisen biologische Eigenschaften nicht.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 9: „Zum Erstellungszeitpunkt“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 9: „Nachbausaatgut“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 8: „Mungo/Ramtillkraut/Schwarzsamen“.

## o6_6-DATED_MANAGEMENT_AND_SRL_MB_CONFLICT

Welche vollständig datierten Mahd-/Pflege-/Walz-/Bodenbearbeitungsereignisse gelten mit Abtransport, Regrowth, Flächendeckung, Frost und Problempflanzenbelegen? SRL verbietet Walzen V2–6 bis 31.10.; MB erlaubt sofortiges Anwalzen/Frostwalzen. Bitte verbindliche Rechtsgrundlage/Version bestätigen. Messerwalze nicht mit Frostwalze oder bodennahem Häckseln gleichsetzen.

**Anlass:** Opus übernimmt MB-Ausnahmen gegenüber SRL ohne bestätigte Fachfreigabe. Luna after_frost:true lässt Messerwalze passieren; maintenance_date und viele Nachweise werden nicht konsumiert.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 54: „Walzen bei“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 54: „bis einschließlich 31.10. verboten.“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 4: „Messerwalzen“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 4: „Ein Anwalzen“.

## o6_6-PSM_N_AND_FOUR_LEAF_STAGE

Welche Produkt-/Wirkstoff-/Datums-/Vollständigkeitsbelege gelten im tatsächlichen Begrünungszeitraum einschließlich Aussaatdüngung? V7: Raps-Vierblattstadium und Begleitsaatbeeinträchtigung belegen; andere zugelassene Rapsmittel nicht aus globalem psm-Flag ableiten. Nach Periodenende verlangt PSM je nach Fall mechanische Beseitigung oder Saat der Folgekultur.

**Anlass:** Luna globales psm_after_follow_crop_sowing:true unterdrückt PSM-Verletzung ohne Datum. Opus fehlendes Vierblattdatum erscheint als missing_inputs neben positiver Prämie.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 3: „Auch eine kombinierte“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 4: „erst nach der Saat der Folgekultur“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 10: „Vierblattstadium“.

## o6_6-MECHANICAL_REMOVAL_AND_FUTURE_MAIN_CROP

Wie werden tatsächliche Beseitigungsmethode/Datum, Frost-/Komponentenbeleg und folgende aktiv angelegte Hauptkultur mit MFA-Zuordnung erfasst? SRL Häckseln/Einarbeiten vs. erweitertes MB-Verfahren verbindlich klären. Variante-1-Herbstfolge und Folgejahres-MFA vor ihrer Frist nicht als bereits erfüllte/final fehlende Tatsachen ausgeben; Zukunft nur begründete Notiz.

**Anlass:** Opus kann bei fehlendem Umbruch/Verfahren/Folgefrucht positive Prämie neben missing_inputs liefern. mechanically_removed_before prüft Tabellenflag, aber nicht jede variant-/Frostbedingung wie mechanical_method_ok.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 5: „mechanisch“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 6: „ausschließlich“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 9: „Hauptkultur im Herbst“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 9: „nachfolgenden Mehrfachantrag“.

## o6_6-DROUGHT_COVER_AND_VOLUNTEER_SCOPE

Welche datierten Belege zeigen ordnungsgemäße Anlage und dürrebedingt fehlenden Aufgang bzw. Ausfallgetreide über 50 % im Jahr 2026? Die bundesweite Ausnahme ersetzt keine Frist-/Mischungs-/Saatverpflichtung; von regionalem Ernteverzicht und individueller Anerkennung trennen. Die vertauschte V1/V2-Terminreihenfolge im Meldungstext fachlich bestätigen.

**Anlass:** Luna volunteer_grain_share/proper_installation ändern den Deckungshelfer, beseitigen INVALID_CROP_MIX jedoch nicht. Beide Modelle enthalten eigenständige Auslegungen zur Mitteilung und müssen gegen aktuelle amtliche Fassung geprüft werden.

Original `sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html`, HTML-Artikel: „wenn eine ordnungsgemäße Begrünungsanlage erfolgt ist“.

Original `sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html`, HTML-Artikel: „Ausfallgetreide“.

Original `sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html`, HTML-Artikel: „keine Meldung erstattet werden“.

## o6_6-HARVEST_REGIONAL_CAUSE_AND_OP_SCOPE

Wie werden Dürregebiet, Bezirk, nicht erntbarer Bestand und übliche Spätsommer-/Herbsternte für die 85%-Ernteausnahme nachgewiesen? o6_6 kann bei nicht geerntetem Hauptfruchtschlag mit maßnahmenbezogenem OP-Code fortbestehen. Nicht globales OP oder eine Gebietszugehörigkeit als alleinige automatische Freistellung verwenden.

**Anlass:** Opus harvest_obligation_waived_2026 prüft nur Gebiet, keinen tatsächlichen Dürre-/Erntegrund oder Kulturzeitraum. Luna HARVEST_85 kann o6_6 ablehnen, obwohl ATB den maßnahmenbezogenen OP-Fall gesondert behandeln.

Original `sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html`, HTML-Artikel: „wenn auf Grund der Dürre kein erntbarer Bestand vorliegt.“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 2: „aktiv angelegte Hauptfrucht“.

## o6_6-CONTRACT_SWITCH_TRANSFER_AND_CONTINUATION

Welche datierten Antrags-/Umstiegs-/Abmeldungs-/Flächenweitergabebelege und Nachfolgerpflichten gelten? Keine gleichzeitige o6_6/o6_7-Teilnahme. Bei überjähriger V2/4/5/6/7 bis Periodenende weiterprüfen; bestimmte Verpachtungen V2/4/5/6 nach 31.12. an Immergrün zählen fortgeführt. Contract-/Measurecodes mit historischen MFA-Codes verbindlich mappen.

**Anlass:** Opus NO-O6_7 wird als farm_violation gemeldet, steht aber nicht in farm_blocking_rule_ids; Prämie bleibt positiv. Fehlender Maßnahmen-/Bewerberdatensatz erzeugt nicht automatisch einen offenen Vertragsstatus.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 10: „Eine gleichzeitige Teilnahme“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 12: „Ende des Begrünungszeitraums“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 11: „nach dem 31. Dezember“.

## o6_6-PAYMENT_BAND_UNKNOWN_GATES_AND_AUTHORITY

Wie werden nur theoretisches Prämienband, offene Nachweise, ineligible/obligation-Lesart, behördliche Kürzung und bestätigte Auszahlung getrennt? Mindestbetrag ist bei erfüllten Förderbedingungen garantiert, nicht bei unbekannten Daten. Aktuelle Quellversionen, Erstjahr-/Flächenbasis, Kombination/OP/NP und extern bestätigte Sanktionen nötig; nicht selbst aus raw violations eine Sanktion erfinden.

**Anlass:** Opus missing_inputs sperren Prämie nicht, unvollständige Mischung kann creditable bleiben; severity ist eigene Modellentscheidung. Luna profile_missing ist nur informativ, eligible=true bei leeren Daten. App positive Bodenbedeckung ist keine vollständige Förderprüfung.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 13: „Prämienbänder“.

Original `sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf`, PDF-Seite 13: „Garantiert ist dabei der angegebene Mindestbetrag.“.
