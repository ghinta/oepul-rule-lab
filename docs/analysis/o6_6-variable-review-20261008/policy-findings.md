# o6_6: 18 technische Beobachtungen

OPA 1.18.2 mit strict-builtin-errors; originale historische Policies/Data
unverändert. Vollständige Eingaben/Queries/Ausgaben in `policy-probes.json`.
Kein fachlicher Golden-Korpus und keine automatisch festgelegte Sanktion.

| Probe | Beobachtung |
| --- | --- |
| LUNA_EMPTY_MEASURE_PROFILE | Leeres Input: eligible:true, zwölf profile_missing, keine violations. |
| LUNA_FALSE_SEVENTY_DAY_INPUT | 10.8.–15.9. mit behaupteten 70 Tagen: date_valid:true/eligible:true, tatsächliche Dauer kürzer. |
| LUNA_V6_PROPOSED_OBJECT_LIST / LUNA_V6_POLICY_STRING_LIST | Vorgeschlagene Wintererbse-Objektliste scheitert; Liste mit Wintererbse-Namensstring hat keine violations. Schemakonsum passt nicht zum Vorschlag. |
| LUNA_KNIFE_ROLLER_WITH_FROST_FLAG | knife_roller_used:true/after_frost:true verhindert Messerwalzen-Verletzung. Quelle unterscheidet diese Maßnahme von zulässigem Frostwalzen/Häckseln. |
| LUNA_DROUGHT_VOLUNTEER_MIX_STILL_FAILS | Ordnungsgemäße Anlage, Ausfallgetreide 70 %, fehlende Deckung 2026: Deckungshelfer entschuldigt, INVALID_CROP_MIX bleibt. |
| LUNA_UNDATED_PSM_AFTER_FOLLOWING_FLAG | psm_applied:true/psm_after_follow_crop_sowing:true: keine Verletzung, keine datierte Anwendung/Zeitraumprüfung. |
| OPUS_MISSING_MIX_REMOVAL_AND_FOLLOWING | Nur V3/Saatdatum: 108 Euro, keine violations, fehlende Umbruch-/Folgefruchtinfos. Mischungs-/Deckungsnachweise fehlen ohne eigene Unknown-Ausgabe. |
| OPUS_NO_APPLICANT_OR_MEASURE_RECORD | Bewerber und farm.oepul fehlen: keine farm_violations, weiterhin 108 Euro. |
| OPUS_SIMULTANEOUS_IMMERGRUEN | Gleichzeitige Maßnahme 7 erzeugt NO-O6_7, weiterhin 108 Euro; Regel fehlt im blocking-Set. |
| OPUS_FROST_ROLLING_MB_EXCEPTION | Frostwalzen mit Deckung am 1.10. ohne Verletzung; MB-Lesart umgesetzt, SRL-Frage offen. |
| OPUS_V7_MISSING_FOUR_LEAF_WITH_PREMIUM | Herbizid, Vierblattdatum fehlt: missing_inputs neben 81 Euro. |
| OPUS_N_ON_PERIOD_END_DATE / OPUS_N_ONE_DAY_BEFORE_PERIOD_END | N-Düngung am 15.11. keine Verletzung; am 14.11. obligation-Verletzung, 108 Euro ohne externen Sanktionseintrag bleiben. Halb-offene Intervallauslegung bestätigen. |
| OPUS_SOURCE_V1_EXAMPLE_2026-08-10 / OPUS_SOURCE_V1_EXAMPLE_2026-07-07 | Amtliche Beispiele korrekt: frühester Umbruch 19.10. bzw. 15.9. Kein frei eingegebener Tagesabstand. |
| OPUS_REGIONAL_WAIVER_WITHOUT_CROP_OR_CAUSE | Wien genügt für harvest_obligation_waived_2026:true, auch ohne nicht-erntbaren Dürrebestand/Kulturerntezeit. |
| APP_SOIL_COVER_PROXY_WITHOUT_VARIANT | 2 ha Acker, soil_cover:true ohne Begrünungsflächenwert/Variante/Antrag/Saat: eligible/phase1_proxy_signal_detected. |

Luna o6_6-Wurzel hat keine vollständige Schlagentscheidung und ignoriert
viele entdeckte Felder, einschließlich doppelter nested-Dürreangaben.
Opus berechnet flächenbezogene Prämienbänder aus tatsächlich ausgewählten
Varianten, trennt aber unknown nur für drei Einzelfragen; missing_inputs sind
kein Auszahlungsgate. farm_premium_eligible blockiert nicht alle gemeldeten
farm_violations, Kombinationen blockieren den Betrag ebenfalls nicht.
Ein obligation-Befund verlangt bestätigte behördliche Rechtsfolge; positive
Beträge nicht als ungeprüfte Förderfähigkeit darstellen.

Zukünftige Umbruch-/Folgefruchtdaten in diesen synthetischen Proben sind bewusst
Testwerte, keine tatsächlich abgeschlossenen Ereignisse. Policies prüfen
as_of und Evidenzvollständigkeit nicht vollständig. Im aktuellen Tool dürfen
solche Planwerte keine als erfüllt dargestellte Jahresentscheidung erzeugen.

Die Originaltabellen aller Varianten und Prämienbänder sowie die 4 AT/19 EU-
Sorten wurden abgeglichen. Sortenstand ist historisch, nicht normative Freigabe
aktueller Zulassungen. Pflege-/Beseitigungsverfahren und Walzausnahmen bleiben
im Sammelissue; kein Vollständigkeitsclaim zu 178 Katalogregeln/allen Helpers.
