# o6_4: technische Beobachtungen unveränderter Policies

OPA 1.18.2, lokale Auswertung mit strict-builtin-errors. Eingaben, Queries und
vollständige tatsächliche Ausgaben sind in `policy-probes.json` reproduzierbar.
Diese synthetischen Fälle sind keine fachlich bestätigten Golden-Tests.

| Probe | Tatsächliche Beobachtung / Bedeutung |
| --- | --- |
| LUNA_TWO_EMPTY_MOWING_YEARS | Leere Mahdhistorie, BM0: compliant. Es fehlt die Zweijahres-Mindestmahdprüfung. |
| LUNA_PREVIOUS_YEAR_ALLOWED_GRAZING | Zulässiger Beginn 16.8.2025 wird bei Jahr 2026 als zu früh markiert. Jahrfilter fehlt. |
| LUNA_FARM_BM3_WITH_PARCEL_TRACTOR | Betriebs-BM3 mit Schlag-BM1 und Traktor: compliant, Satz 972 €/ha. Nicht mit Gesamtzahlung verwechseln. |
| LUNA_HEIGHT_SHARE_1 / LUNA_HEIGHT_SHARE_1.0002 | Bei 2 ha Schlag ist genau 50 % nicht eligible, 50,01 % eligible. compliance in beiden Fällen compliant; sie ist kein Gesamt-Zugangsstatus. |
| OPUS_PREVIOUS_CUT_WITHOUT_FULL_REMOVAL | Vorjahresschnitt ohne Vollflächen-/Abtransportnachweis verhindert MOW-001. |
| OPUS_INCOMPLETE_CURRENT_YEAR | Derselbe Fall ohne Vorjahresschnitt meldet bereits bei Prüfstichtag 1.6.2026 MOW-001; as_of wird ignoriert. |
| OPUS_BM3_WITHOUT_METHOD_EVIDENCE | method fehlt, dennoch 972 Euro bei einem Hektar und keine violation. |
| OPUS_NO_MEASURE_RECORD_WITH_PREMIUM | contract_valid:false/no_measure_record neben 972 Euro. |
| OPUS_AFTER_CONTRACT_END | Jahr 2029: contract_valid:true und 972 Euro. Tarifobergrenze ist null, Vertragsende nicht gebunden. |
| OPUS_PREMIUM_WITH_FORBIDDEN_LIME | Expliziter Kalkdüngerverstoß neben 972 Euro. Kein bestätigter Zahlungsanspruch. |
| OPUS_PREVIOUS_YEAR_GRAZING_FILTER | Vorjahres-Nachweide korrekt aus aktuellen violations gefiltert. |
| APP_FILLED_MOWING_AND_CODES | Schnittdatum und BM3 vorhanden, dennoch Category C/missing_data; keine failed_conditions und keine missing_keys. |

Luna package `o6_4` hat separate eligibility_findings und Allgemeinhelfer,
compliance konsumiert aber nur violations/missing_data. Zwei fehlende
Höheninformationen sind kein vollständiger Datenvertrag. Opus package
`oepul.o6_4` meldet eligibility, application, violations, Kombination und
excluded_from_measure getrennt, premium_parcel_reason bindet davon nur einen
Teil. Antrags-/Vertrags-/Ausschluss-/Dünger-/Kombinationsausgaben schalten den
Betrag nicht automatisch ab. Nicht eigenständig eine behördliche Sanktion
implementieren: zunächst Zahlungsbegriff und Rechtsfolge fachlich bestätigen.

Kein vollständiger Nachweis des Konsums aller Hilfsregeln, keine Freigabe aller
98 Katalogregeln und keine Behauptung aktueller amtlicher Quellen außerhalb der
gepinnten Fassung. Die Vor-Ort-Kontrolle/Belege und GIS-Herkunft ersetzen Modelle
nicht durch plausibel wirkende Flags.
