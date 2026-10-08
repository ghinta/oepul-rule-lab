# o6_6: 205 Blattwerte, acht offene Aufnahmegruppen

Der unveränderte Inventardiff und `leaf-review.json` binden jedes Vorher/nachher,
Proposal-/Quellen-ID und offenen Alias-/Aufnahmestatus. Die Gruppen sind ein
Reviewindex, kein genehmigter Inputvertrag. Z. B. Variante-Antragsdatum und
Folgekulturfelder haben zusätzlich Vertrags-/Jahresbezug.

| Gruppe / Blätter | Luna | Opus | App / Aufnahmeentscheidung |
| --- | --- | --- | --- |
| `parcel_scope` / 8 | globale area/arable_area/land_use/has_greened_parcel und eigene o6_6.parcels[] | bestehende land.parcels[] mit cover_crop | Tatsächliche Schlag-/MFA-Identität, Fläche und Maßnahmeantrag nötig. Luna eigene parcels-Liste wird in der ausführbaren Entscheidung nicht pro Schlag ausgewertet. App fragt nur Ackerfläche und aggregierte Bodenbedeckung ab. MB S. 2, 11–12. |
| `participation` / 20 | Antrag/Korrektur/Ausstieg/Immergrün als globale Felder, zusätzliche root-applicant-Angaben | farm.applicant und farm.oepul.measures[].measure_code/applied_on/contract_start_year/withdrawal_date | Codes 6/7 vs. o6_6/o6_7 explizit mappen; keine Umbenennung ohne bestätigten Scope. Opus fehlender Record erzeugt keine Antragsverletzung, simultanes o6_7-Flag bindet Betrag nicht. Aktueller Hostkontext und Einjahres-/überjährige Pflicht getrennt. MB S. 1, 10–12. |
| `variant_calendar` / 9 | application_year, variant, sow/break-date, vorgeschlagene days_between_sowing_and_break | variant, actual establishment/termination/variant_applied_on-Dateiwerte | V3 im selben Jahr, V2/4/5/6/7 im Folgejahr; V1 ab 2025 aus echten Daten >=70 Tage/max15.9. Opus rechnet, Luna vertraut Dauerzahl. Unterjährige Prüfzeit vs. abschließende Nachweise trennen. MB S. 6–10, SRL S. 55. |
| `mixture_seed` / 57 | mixture_crops[]-Objekte mit Name/Familie/Bestäubung, globale Counts/Anteile, Saatgut-/Kulturflags | cover_crop.species[], eigene Sorten, Counts/Prozent/Familien/Winterhärte/Unter-/Folgesaatdetails | Luna Policy erwartet V6-Kulturnamenstrings statt vorgeschlagener Objekte. 0–1-Anteile vs. 0–100-Prozent, Synonyme und tatsächlich verschiedene Partner bestätigen. Feste historische Sorten-/Beispielliste ersetzt keinen aktuellen Katalog. MB S. 2–3, 8–10. |
| `management_events` / 31 | globale PSM/N-, Mahd-/Walz-/Frost-/Bodenbearbeitungs-/Mechanik-/Nachweisflags | datierte cover_crop.events[] mit Typ und Pflege-/Deckungs-/Frost-/Säschardetails | Vollständige Anwendungsliste mit Datums-/Flächen-/Methodennachweis nötig. Frostwalze ist keine Messerwalze. Pflege ohne Abtransport, Nutzung mit Abtransport und endgültige Beseitigung getrennt. SRL/MB-Walz- und Methodenkonflikte offen. MB S. 3–6, SRL S. 54. |
| `following_transfer` / 20 | preceding/following_main_crop, Herbst-/MFA-/Nachfolger-/Übernahmeflags | following_main_crop-Daten und transfer-Nachfolger/Datum/System | Aktive Folgefrucht, tatsächlicher Umbruch, MFA-Antrag und überjährige Nachfolgerpflicht belegen. Geplante Frühjahrssaat oder spätere MFA-Erfassung ist heute kein abgeschlossener Beweis. Spezifische V2/4/5/6-Immergrün-Verpachtungsausnahme bewahren. MB S. 9–12. |
| `drought` / 15 | doppelte globale/nested drought_2026-Region-/Ursachen-/Korrekturfelder, proper_installation | properly_established/cereal_share_from_volunteer; Region bereits farm.region | Policy liest teils globale Werte statt vorgeschlagener nested-Gegenstücke. Bundesweite Deckungs-/Ausfallgetreideausnahme von regionaler 85%-Ernteausnahme mit tatsächlichem Dürrebestand und Kulturerntezeit trennen. Notice 5.8./12.8.2026. |
| `general_payment` / 45 | viele allgemeine/reduktive Flächen-, OP-, Genehmigungs-/Conditionality-/Ernte-/Nachweisflags außerhalb tatsächlicher decision | content_violation_level, Erstteilnahme, NP/Österreich/Codes/Förderüberlappung/special_circumstance | Zahlreiche katalogisierte Allgemeinregeln sind nicht oder nur teilweise konsumiert. Severity ineligible/obligation ist unbestätigte Modellentscheidung. Prämienband kein bewilligter Anspruch; fehlende Daten/AMA-Entscheidung nicht als keine Sanktion interpretieren. ATB, SRL Allgemeinteil, MB S. 12–13. |

Gepinnte `app-code-evidence.json` zeigt tatsächliche API- und Policy-Zugriffe.
App-Maßnahmenadapter verliert neue Kultur-/Sorten-/Event-/Vertrags-/Folge-
Daten; aktuelle agronomische Signale reichen für Phase-1-Proxy, nicht für alle
Förderbedingungen. Gemeinsame Datentypen oder gleicher Name begründen keinen Alias.
