# o6_5: Einzeltier, Förderplatz, Ereignis und Jahresbeleg getrennt

Alle 112 vorgeschlagenen Blattwerte sind unverändert mit Vorher/nachher und
Vorschlags-/Quellen-IDs in `leaf-review.json` gebunden. Gruppen zählen
Blattpfade, keine vollständig abgebildeten rechtlichen Pflichten.

| Gruppe / Blätter | Luna | Opus | tatsächliche App / offene Aufnahme |
| --- | --- | --- | --- |
| `animal_identity` / 11 | `livestock.animals[].animal_id/species/animal_type/breed/purebred` | `livestock.endangered_breed_animals[].animal_id/animal_category/breed/is_purebred/herdbook_registered/identification` | App übernimmt nur species_groups ohne Einzeltiere. Tierart, Geschlecht/Kategorie, Originalrasse und Zucht-/Register-ID müssen konsistent sein. Luna horse/goat/pig vs. Opus horses/goats/pigs; cow vs. kuh. Keine String-Aliase genehmigt. MB S. 1–2, 6, 8–9. |
| `breeding_history` / 27 | breeding_facts mit vorgerechnetem Alter, Stichtagsgeburts-/Wurf-/Abfohlbooleans, Nachkommensjahre | Geburts-/erste Nachwuchs-/letzte Abfohldaten, Wurfzähler, Zulassungsjahr und jährliche Zuchtflags | Datierte tatsächliche Belege nötig. Quote ist keine belegte Wurfsequenz; max(Stichtag,Ersatzdatum) kann erst spätere Erfüllung bei Nachbesetzung erlauben. Hengst/Hengstalter und regelmäßiger vs. jährlicher Zuchteinsatz gesondert. MB S. 2, SRL S. 52. |
| `holding_replacement` / 30 | held_from/to, holding_country; movement_events mit Typ, Datum, selbst berechneter Dauer/Frist, alter/neuer Rasse und Geschlecht | on_farm_from, kept_in_austria, departure, replaces_animal_id, Ersatzdatum und temporary_absences | Tierbewegung, tatsächlicher Zugang, Förderplatz und Ersatzkante getrennt. Luna Ereignishelfer schalten eligibility nicht ab; Opus nur zwei Ersatzebenen und Ersatz-Zugang nicht überprüft. Unterjährige/überjährliche Ketten, Mehrfachkandidaten und konsistente Zeitleiste klären. MB S. 3–5, SRL S. 53, Notice 12.8. |
| `reporting_confirmation` / 15 | application_and_confirmation mit Datum/Jahr/Stichtag/UELN; reported_within_days | breeding_org_confirmation.status/date, applied_in_mfa, replacement_reported_date, equine_database_and_vis_reported, ueln_in_application, Vorabmeldeboolean | Luna vorgeschlagene Bestätigungs-/Antragsliste wird von eligible nicht gelesen. Opus confirmed ohne Datum gilt fristgerecht; zukünftiges Bestätigungsdatum trotz früherem as_of akzeptiert. Meldungsbeleg mit Verantwortlichem, Datum, Originalsystem und Vollständigkeit nötig. Rinderautoermittlung kein Grund für unbekannte Bestände. MB S. 3–6. |
| `premium_programme` / 5 | program_implemented, milk_control sowie ursprüngliche/ersetzende MLK-Flags | milk_recording | Beide berechnen GEP aus Rassenlistenflag, nicht tatsächlichem Verbandsjahresbeleg. Luna listet Steirische Scheckenziege GEP=false statt ja. Sechs Annex-D-Auflagen sind Daten, kein vollständig konsumierter Nachweisvertrag. MB S. 5, 7–9; Annex D S. 9. |
| `participation` / 18 | farm.application_date | farm.applicant; root-oepul_participation mit Einstieg/Abmeldung/Wiedereinstieg/Kontrolle/Übernahme/Erstjahr | App stellt keine Einzeltier-Vertragsentscheidung her. Luna prüft Antrags-/Jahreshelfer separat; Opus übernimmt Wiedereinstiegsgenehmigung implizit aus Korrektur/Ersuchen. Laufender Jahresvertrag, Mindesttier, letzter Neueinstieg und Folgejahr getrennt. MB S. 1, 5–7. |
| `general_payment` / 6 | keine zusätzliche vollständige allgemeine Datenstruktur | documentation.inspection_refused/force_majeure/vis_reports_complete, protected_cultivation_area_ha, AMA-Kürzungsstufe und volle Kürzungen | Externe anerkannte Sanktion nicht aus Modellbefunden ableiten; Kontrollanerkennung belegen. Null/fehlende Fläche und unbekanntes Erstjahr sind keine bestätigte Allgemeinfreigabe. Tierprämie hat keinen flächenbezogenen ha-Deckel. ATB, SRL Allgemeinteil. |

Die Gruppenzuordnung ist ein Reviewindex; z. B. Bewerberdaten stehen in
participation, obwohl sie allgemeine Förderbedingungen betreffen. Es wird
kein neuer fachlicher Inputvertrag daraus erzeugt. Gepinnte App-API-/Policy-/
DecisionTrace-Auszüge in `app-code-evidence.json` belegen ausschließlich den
Artgruppen-Proxy. Positive Tierzahl ist kein Beweis eines förderbaren Tieres.
