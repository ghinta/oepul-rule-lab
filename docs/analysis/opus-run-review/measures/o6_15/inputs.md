# o6_15: Eingabevertrag, Personen-/Tierzeitlinien und App-Projektion

Run `v2-o6_15-opus-5.5-high-20260926`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Öffentliche Entwicklungsanalyse ohne Förderfreigabe, Registerbescheinigung oder Genauigkeitsaussage. Inputs-JSON SHA-256: `c60945abf844932dd320afff02939ec526b9b7b6df8ac8f40fe080f71108ca2b`.

110 frische Fälle enthalten 218 typisierte Einzelprüfungen: 184 erfüllt, 34 nicht erfüllt. 97 native Ergebnisse sind definiert, 13 enden mit Laufzeitfehlern; kein Ergebnis ist undefiniert. Alle 110 Fälle wurden nach den ersten Beobachtungen vollständig erneut abgespielt. Statuswerte, Ausgaben und Fehler sind identisch. Die zusätzliche exakte App-Ausgabe wird separat nativ ausgewertet: definiert, eligible=false, payable_premium_eur=0.

## Gelesene Originale und tatsächlicher Vertrag

Das neue Merkblatt wurde auf allen zehn Seiten vollständig gelesen, einschließlich Definitionen, Fortsetzungen, Ausnahmen, Prämien-/RGVE-Tabellen, Beispielen, Aktualisierungen und Impressum. Originalhash: `b3dc90508e4a9e859aef76a2a6794a7237ad3c89991486339d3c926bf8161189`. Alle sechs produktiven Module mit 1.175 Zeilen sowie alle zwanzig Rohannahmen und offenen Hinweise wurden persönlich vollständig gelesen. Die tatsächliche Hauptabfrage lautet `data.oepul.o6_15.decision`; Originaldaten bleiben im Namespace `data.o6_15`.

Alle acht tatsächlich gelieferten Originalquellen wurden per SHA-256 geprüft. Die sieben gemeinsamen Quellen stimmen bytegenau mit den dokumentierten früheren vollständigen Lektüren überein. Wiederverwendet wird diese Vorlektüre; erneut gelesen wurden die aktuellen ATB-/SRL-Verbraucherklauseln und der Hinweis vom 22. Mai zu fehlender Wasserversorgung auf Almen und zum einzelbetrieblichen Ansuchen. Die aktuelle Klauselliste steht im JSON: ATB-PDF 4/5/15/18/20, SRL-PDF 8/10/18/23/72. Die aktuelle RGVE-Tabelle wurde mit der früher vollständig gelesenen Anhangfassung verglichen. Eine neue vollständige Lektüre aller gemeinsamen PDFs wird nicht behauptet.

Sämtliche 36 tatsächlichen Vorschlagszitate wurden auf der tatsächlichen Originalseite nach ausschließlich Whitespace-Normalisierung bestätigt. Zehn zusätzlich verwendete Originalkomponenten wurden ebenso bestätigt. Die übrigen drei Hinweise liefern keine neue Behirtungs-/Dog-Ausnahme. GSP-AV und NAPV sind in diesem achtteiligen Paket nicht als Originale geliefert; bloße Verweise in Merkblatt/SRL erzeugen keine separat gebundene Rechtsfassung.

Die tatsächlichen Eingaben liegen unter `oepul_participation`, `alpine_farming.herding_application`, `alpine_farming.alms[].animals[]/herders[]/herd_protection_dogs[]`, `farm.applicant`, `documentation` und `land`. Anders als bei 14 sind Tiere hier in der Alm verschachtelt. Die aktuellen Enumwerte heißen unter anderem `association` und `equid`. Es gibt in den tatsächlichen 15-Vorschlägen keinen numerischen Enumdeskriptor; die offene14er-Primitive wird nicht übernommen.

## Vollständige Vorschlags- und Verbraucherprüfung

Die sieben tatsächlichen add-Vorschläge enthalten 93 Blätter: 90 gelesen, drei ungelesen. 231 kontextuelle Lesestellen sind dokumentiert. Zwei dynamische Vorlagen sind auf insgesamt 16 tatsächlich gelistete Schlüssel geschlossen: acht Care- und acht Dog-Anforderungen. Die Vorlagen sind keine geratenen offenen Feldmengen. Zwei weitere tatsächliche Pfade gehören zum unveränderten Canonical; kein unvorgeschlagener nativer Zusatzpfad.

Drei gelesene Blätter wirken ausschließlich in separaten Helfern; acht erreichen MAIN-Meldungen ohne eigenen aktuellen Betragsschalter. 79 gelesene Blätter wirken bedingt auf MAIN-Vertrag, Nachweise, Identität, Mengen oder Betrag. Ein Parserfehler an einem nur meldenden Feld kann trotzdem die gesamte MAIN-Verfügbarkeit abbrechen.

| Nr. | Tatsächlicher Vorschlag | Blätter | gelesen / ungelesen |
|---:|---|---:|---:|
| 1 | `farm.applicant` | 4 | 4 / 0 |
| 2 | `oepul_participation` | 16 | 15 / 1 |
| 3 | `alpine_farming.herding_application` | 6 | 6 / 0 |
| 4 | `alpine_farming.alms` | 64 | 62 / 2 |
| 5 | `land.protected_cultivation_area_ha` | 1 | 1 / 0 |
| 6 | `documentation.on_site_control_refused` | 1 | 1 / 0 |
| 7 | `documentation.control_refusal_force_majeure` | 1 | 1 / 0 |

Jedes Blatt hat im JSON den tatsächlichen Deskriptor, Einheit, Bedeutung, bedingten Tier-/Personen-/Alm-/Jahres-/Ereigniskontext, Missing-/Nullabgrenzung, tatsächliche Defaults, alle Lesestellen, Quellenbelege und konkrete App-Retention. Die folgende vollständige Liste enthält alle 93 Blätter.

| Blatt | Tatsächlicher Deskriptor | Scope | Lesestellen |
|---|---|---|---|
| `farm.applicant.legal_form` | `enum(natural_person\|registered_partnership\|legal_person\|association\|public_body)` | bedingter MAIN-Nachweis/Betrag | contract.rego:203, contract.rego:210 |
| `farm.applicant.public_body_share_percent` | `number\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:213 |
| `farm.applicant.is_active_farmer` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:218 |
| `farm.applicant.is_alm_operator` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:219 |
| `oepul_participation.first_oepul_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:228, contract.rego:231, contract.rego:236 |
| `oepul_participation.measures[].measure_id` | `string` | bedingter MAIN-Nachweis/Betrag | contract.rego:9 |
| `oepul_participation.measures[].participating_in_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:24 |
| `oepul_participation.measures[].contract_start_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:44, contract.rego:49, contract.rego:52, contract.rego:89 |
| `oepul_participation.measures[].application_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:49 |
| `oepul_participation.measures[].deregistered_in_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:101 |
| `oepul_participation.measures[].deregistered_before_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:91 |
| `oepul_participation.measures[].deregistration_date` | `date\|null` | ungelesen | — |
| `oepul_participation.measures[].previous_contract_expired` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:60, contract.rego:66, contract.rego:72, contract.rego:82, contract.rego:90 |
| `oepul_participation.measures[].reapplied_after_expiry` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:61 |
| `oepul_participation.measures[].late_correction_of_previous_measure_application` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:67, contract.rego:73 |
| `oepul_participation.measures[].written_request_to_ama_submitted` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:68, contract.rego:74 |
| `oepul_participation.measures[].full_reductions_in_contract_period` | `int` | nur separater Helfer | decision.rego:194 |
| `oepul_participation.measures[].takeover.is_takeover` | `boolean` | bedingter MAIN-Nachweis/Betrag | decision.rego:38 |
| `oepul_participation.measures[].takeover.reason` | `enum(farm_dissolution\|farm_division\|farm_merger\|other)\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:185 |
| `oepul_participation.measures[].takeover.animals_and_areas_from_same_predecessor` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:186 |
| `alpine_farming.herding_application.payment_application_submission_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | contract.rego:139 |
| `alpine_farming.herding_application.dog_supplement_requested` | `boolean` | bedingter MAIN-Nachweis/Betrag | decision.rego:166, premium.rego:71 |
| `alpine_farming.herding_application.dog_supplement_start_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:149 |
| `alpine_farming.herding_application.dog_supplement_application_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:155, contract.rego:156 |
| `alpine_farming.herding_application.federal_state_top_up_granted` | `boolean` | bedingter MAIN-Nachweis/Betrag | premium.rego:58 |
| `alpine_farming.herding_application.federal_state_top_up_notified_by_may_15` | `boolean` | bedingter MAIN-Nachweis/Betrag | premium.rego:59 |
| `alpine_farming.alms[].alm_id` | `string` | bedingter MAIN-Nachweis/Betrag | alm.rego:75, alm.rego:102, alm.rego:145, decision.rego:46, decision.rego:51, decision.rego:56, decision.rego:61, decision.rego:68, decision.rego:75, decision.rego:82, decision.rego:89, decision.rego:96, decision.rego:103, decision.rego:109, decision.rego:115, decision.rego:121, decision.rego:127, decision.rego:134, decision.rego:140, decision.rego:147, decision.rego:154, decision.rego:203, decision.rego:210, decision.rego:233, premium.rego:83 |
| `alpine_farming.alms[].is_separate_sub_holding` | `boolean` | ungelesen | — |
| `alpine_farming.alms[].in_austria` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:18 |
| `alpine_farming.alms[].cross_border` | `boolean` | ungelesen | — |
| `alpine_farming.alms[].national_park` | `string\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | decision.rego:212 |
| `alpine_farming.alms[].alpine_pasture_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | alm.rego:12, premium.rego:135 |
| `alpine_farming.alms[].in_alm_cadastre_or_alm_area` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:13 |
| `alpine_farming.alms[].managed_from_home_farm` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:14 |
| `alpine_farming.alms[].visible_boundary_to_grassland` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:15 |
| `alpine_farming.alms[].stocking_days` | `int\|null` | bedingter MAIN-Nachweis/Betrag | alm.rego:30 |
| `alpine_farming.alms[].stocked_rgve` | `number\|null` | bedingter MAIN-Nachweis/Betrag | premium.rego:124, premium.rego:131 |
| `alpine_farming.alms[].herder_accommodation_available` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:64 |
| `alpine_farming.alms[].herding_funded_by_other_public_title` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:195 |
| `alpine_farming.alms[].water_supply_failed_due_to_drought` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | decision.rego:206 |
| `alpine_farming.alms[].permanent_circumstance_date` | `date\|null` | nur separater Helfer | decision.rego:224, decision.rego:225, decision.rego:229, decision.rego:235 |
| `alpine_farming.alms[].permanent_circumstance_force_majeure` | `boolean` | nur separater Helfer | decision.rego:230 |
| `alpine_farming.alms[].declared_herder_count` | `int\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | decision.rego:142 |
| `alpine_farming.alms[].care.daily_care` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50, alm.rego:68 |
| `alpine_farming.alms[].care.night_care_when_required` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50 |
| `alpine_farming.alms[].care.herding_substantial_part_of_day` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50 |
| `alpine_farming.alms[].care.sufficient_water_supply` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50 |
| `alpine_farming.alms[].care.animal_care` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50 |
| `alpine_farming.alms[].care.treatment_of_diseases_and_injuries` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50 |
| `alpine_farming.alms[].care.safety_measures` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50 |
| `alpine_farming.alms[].care.site_adapted_grazing_management` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:50 |
| `alpine_farming.alms[].care.inspection_only` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:53 |
| `alpine_farming.alms[].herders[].person_id` | `string` | bedingter MAIN-Nachweis/Betrag | alm.rego:75, alm.rego:93, alm.rego:99, alm.rego:101, alm.rego:105, decision.rego:134 |
| `alpine_farming.alms[].herders[].herds_other_alm` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:94, alm.rego:100 |
| `alpine_farming.alms[].herded_categories[]` | `enum(dairy_cows\|other_cattle\|sheep\|goats\|equids\|new_world_camelids)` | bedingter MAIN-Nachweis/Betrag | alm.rego:121, animals.rego:142 |
| `alpine_farming.alms[].animals[].animal_id` | `string` | MAIN-Meldung, kein eigener aktueller Betragsschalter | alm.rego:114, decision.rego:61, decision.rego:68, decision.rego:75, decision.rego:82, decision.rego:89, decision.rego:96, decision.rego:103, decision.rego:109, decision.rego:115, decision.rego:121, decision.rego:127 |
| `alpine_farming.alms[].animals[].species` | `enum(cattle\|sheep\|goat\|equid\|new_world_camelid\|other)` | bedingter MAIN-Nachweis/Betrag | animals.rego:8, animals.rego:22, animals.rego:55, animals.rego:60, animals.rego:67, animals.rego:87, animals.rego:92, animals.rego:95, animals.rego:98, animals.rego:115, animals.rego:140, animals.rego:149, decision.rego:93, decision.rego:130, lib.rego:55, lib.rego:62, lib.rego:67, lib.rego:71, lib.rego:86, premium.rego:128 |
| `alpine_farming.alms[].animals[].breed` | `string\|null` | bedingter MAIN-Nachweis/Betrag | lib.rego:59 |
| `alpine_farming.alms[].animals[].is_dwarf_breed` | `boolean` | bedingter MAIN-Nachweis/Betrag | lib.rego:57 |
| `alpine_farming.alms[].animals[].equid_large_breed` | `boolean` | bedingter MAIN-Nachweis/Betrag | lib.rego:63, lib.rego:68 |
| `alpine_farming.alms[].animals[].birth_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:86, animals.rego:87, animals.rego:91, lib.rego:89, lib.rego:103 |
| `alpine_farming.alms[].animals[].rgve_category` | `string\|null` | bedingter MAIN-Nachweis/Betrag | lib.rego:97, lib.rego:98, lib.rego:102 |
| `alpine_farming.alms[].animals[].count` | `int` | bedingter MAIN-Nachweis/Betrag | lib.rego:108 |
| `alpine_farming.alms[].animals[].behirtung_category` | `enum(dairy_cows\|other_cattle\|sheep\|goats\|equids\|new_world_camelids)` | bedingter MAIN-Nachweis/Betrag | animals.rego:140, animals.rego:142, animals.rego:168, decision.rego:64 |
| `alpine_farming.alms[].animals[].is_herded` | `boolean` | bedingter MAIN-Nachweis/Betrag | animals.rego:144 |
| `alpine_farming.alms[].animals[].kept_in_austria` | `boolean` | bedingter MAIN-Nachweis/Betrag | animals.rego:146 |
| `alpine_farming.alms[].animals[].ear_tag` | `string\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | decision.rego:131 |
| `alpine_farming.alms[].animals[].first_drive_up_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:48 |
| `alpine_farming.alms[].animals[].drive_up_date` | `date` | bedingter MAIN-Nachweis/Betrag | animals.rego:12, animals.rego:16, animals.rego:22, animals.rego:48, animals.rego:117, decision.rego:219 |
| `alpine_farming.alms[].animals[].drive_down_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:27, animals.rego:28, animals.rego:56, animals.rego:65, animals.rego:67, animals.rego:72 |
| `alpine_farming.alms[].animals[].planned_drive_down_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | animals.rego:56 |
| `alpine_farming.alms[].animals[].report_date_up` | `date\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:13, animals.rego:16, animals.rego:17, animals.rego:21, animals.rego:22 |
| `alpine_farming.alms[].animals[].report_date_down` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | animals.rego:66, animals.rego:67, animals.rego:73 |
| `alpine_farming.alms[].animals[].interruption_days` | `int` | bedingter MAIN-Nachweis/Betrag | animals.rego:29 |
| `alpine_farming.alms[].animals[].total_alpine_days_all_herded_alms` | `int\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:33, animals.rego:34, animals.rego:38 |
| `alpine_farming.alms[].animals[].milked` | `boolean` | bedingter MAIN-Nachweis/Betrag | animals.rego:103, decision.rego:71 |
| `alpine_farming.alms[].animals[].milked_days` | `int\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:104 |
| `alpine_farming.alms[].animals[].calved_by_july_1` | `boolean\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:99 |
| `alpine_farming.alms[].animals[].milked_flag_reported_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | animals.rego:111, animals.rego:114, animals.rego:117, animals.rego:123 |
| `alpine_farming.alms[].herd_protection_dogs[].dog_id` | `string` | bedingter MAIN-Nachweis/Betrag | alm.rego:145, alm.rego:160, alm.rego:163, decision.rego:147 |
| `alpine_farming.alms[].herd_protection_dogs[].certified_herd_protection_dog` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].certificate_available_on_farm` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].liability_insurance` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].present_whole_alpine_period` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].permanent_herd_member` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].day_and_night_with_herd` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].works_without_direct_commands` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].entered_in_auftriebsliste` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:142 |
| `alpine_farming.alms[].herd_protection_dogs[].days_on_this_alm` | `int` | bedingter MAIN-Nachweis/Betrag | alm.rego:158 |
| `alpine_farming.alms[].herd_protection_dogs[].claimed_on_other_alm` | `boolean` | bedingter MAIN-Nachweis/Betrag | alm.rego:159 |
| `land.protected_cultivation_area_ha` | `number\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:237 |
| `documentation.on_site_control_refused` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:247 |
| `documentation.control_refusal_force_majeure` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:248 |

Ungelesen sind `oepul_participation.measures[].deregistration_date`, `alpine_farming.alms[].is_separate_sub_holding` und `alpine_farming.alms[].cross_border`. Die separate Funktion `exit_effective_year(date)` liest ein explizites Argument, nicht das vorgeschlagene Datumsfeld. Aus ungelesenen Flags folgt keine behauptete Registerprüfung oder erfundene neue fachliche Sanktion.

| Weiterer Canonicalpfad | Verwendung | App exakt erhalten |
|---|---|---|
| `farm.year` | aktuelles Förderjahr, Altersstichtag, Raten und Fristen | ja |
| `land.total_area_ha` | erste PROGRAM-Teilnahme, Mindestflächenalternative | ja |

Die drei Helferblätter sind `full_reductions_in_contract_period`, `permanent_circumstance_date` und `permanent_circumstance_force_majeure` unter ihren vollständigen JSON-Pfaden. Ihre Ausschluss-/Umstandsfunktionen sind kein aktueller MAIN-Zahlungsschalter. Acht reine MAIN-Meldungsblätter betreffen jährliches Zahlungsantragsdatum, Nationalpark, Dürre, deklarierte Herderzahl, Tier-ID, Ohrmarke, geplantes Abtriebsdatum und Abtriebsbericht.

`participating_in_year` wird für den tatsächlich geforderten o6_14-Datensatz positiv geprüft. Der eigene o6_15-Wert wird nicht als eigenes aktuelles Teilnahmegate benutzt. Ein generischer Maßnahmenblattname darf diese unterschiedliche Datensatzverwendung nicht verdecken.

## Quellenkomponenten und kohärente technische Basen

Sechs unabhängig zitierte Komponenten prüfen den Basisprämiensatz 2023 = 75 und ab 2024 = 81 EUR/RGVE, den Milchzuschlag 151,20 EUR/RGVE, den Dog-Satz 1200 EUR, die 60-Tage-Datumsdifferenz und Faktor 1,00 für bekannte erwachsene Nicht-Zwergrinder. Alle sechs werden erfüllt. Die Sollzahlen stammen aus Originaltabellen bzw. der ausdrücklich beschriebenen Tageszählung und wurden vor Ausführung festgelegt. Das fehlerhafte zweite Rechenbeispiel des Merkblatts und historische Selbsttests wurden nicht als Gold übernommen.

Die gewöhnliche technische MAIN-Basis enthält eine bekannte österreichische 3 ha-Alm und drei unterschiedliche erwachsene Nicht-Zwergrinder, jeweils count 1. Tierart, tatsächliches Geburtsdatum, bekannte Rasse, Herden-/Länderstatus, tägliche Care, Unterkunft, eine bekannte betreuende Person, Kombination sowie Originalantrag, aktueller Zahlungsantrag und alle Auf-/Abtriebs-/Meldedaten sind explizit positiv angegeben. Auftrieb 1. Juni bis Abtrieb 31. Juli ergibt 60 tatsächliche und angerechnete Tage; der Abtriebstag zählt nicht. Es gibt keine erfundenen zusätzlichen Dog-, Milch-, Übernahme- oder Umstandsereignisse in dieser Basis.

Diese Basis ergibt 225 EUR in 2023 und 243 EUR in 2024/2025. Positive Milchbedingungen für dieselben drei bekannten erwachsenen, bereits abgekalbten Kühe ergeben 696,60 EUR. Bedingte positive Dog-Flags ergeben zusätzlich 1200 EUR, insgesamt 1443 EUR. Alle acht Dog-Anforderungen, 60 Tage auf einer Alm und ein fristgerechter ursprünglicher Dog-Antrag sind im technischen Positivfall angegeben; ein tatsächliches Zertifikat oder ein real zugelassener Hund wird nicht behauptet.

Alle fünf eligible Tiergruppen werden frisch geprüft: drei individuelle Rinder, zwanzig individuell markierte erwachsene Schafe bzw. Ziegen und bekannte homogene Gruppen von drei großen adulten Equiden bzw. zwanzig adulten Neuweltkamelen ergeben jeweils 3 RGVE. Synthetische Identifikatoren sind keine Tierregisterbelege. Der bekannte Schemawert other ist außerhalb der berechtigten Arten und ergibt 0; das ist keine künftig unbekannte biologische Tierart.

Die Mengen bleiben getrennt: tatsächliche/angerechnete aktuelle Aufenthaltsdauer, ganzjährige/almübergreifende Tiergesamtzeit, Alm-Belegungskalendertage, 45 Melktage, 14/7 Tage Meldekredit, RGVE, 50 RGVE je tatsächlicher Person und Dog-Tage auf genau einer Alm. Für Modulation zählt gegebenenfalls mehr aufgetriebener als beantragt behirteter Bestand; supplied stocked_rgve ist keine unabhängige Registerbestätigung. Drei reale Almhektar sind nicht drei Köpfe oder drei Belegungstage.

## Nullable-, Missing-, Identitäts- und Zeitgrenzen

| Tatsächlich beobachtete Fehlerklasse | Anzahl | Abgrenzung |
|---|---:|---|
| Gültiges ausdrückliches Nullable, MAIN | 4 | originale application_date, jährliche payment_application_submission_date, animal.first_drive_up_date, ausgewähltes dog_supplement_start_year |
| Funktionale ID-Konflikte, MAIN | 2 | widersprüchlich gleiche Maßnahmen-ID bzw. Alm-ID, keine primitiven Typfehler |
| Außerhalb des tatsächlichen Schemas, MAIN | 6 | zwei nichtnullable int-null, nichtnullable Updatum-null, ungültiges Kalenderdatum, nichtnullable Almfläche-null und Care-Objekt-null |
| Separater Outside-Helferstress | 1 | explizites exit_effective_year(null), kein gelesener vorgeschlagener Datumspfad und kein MAIN-Nullfehler |
| Undefiniert | 0 | von definiert negativ und Laufzeitabbruch getrennt |

Alle 13 Fehler stehen im JSON einzeln mit genauem Eingabe-/Argumentpfad, Schema-/Nullklasse, Kontext, MAIN-/Helferscope, Query und vollständiger nativer Meldung. Zwölf Fehler erreichen MAIN, einer nur den separaten Exitdatumshelfer. Unter den zwölf absichtlichen Outside-Fällen liegen elf Farm-Eingabewerte außerhalb des Schemas; der zwölfte ist das außerhalb des Farm-Payloads gelegene explizite Funktionsargument-null. Die übrigen Outside-Fälle können definiert negativ oder mit unbeeinflusstem Betrag enden; sie werden nicht zu zusätzlichen Laufzeitfehlern erklärt.

Sichere Fallbacks werden ausdrücklich gutgeschrieben: `rgve_category:null` leitet aus positiv bekannter Art, Alter und Rasse korrekt ab. Optionales Feld absent ist ebenfalls sicher. Geburtsdatum:null mit explizit bekannter gültiger Kategorie bewahrt die Klassifikation. Sind beide Altersbelege:null, bleibt die bekannte Art Rind unverändert; der Faktor ist unbelegt und MAIN ergibt 0. Das ist keine unbekannte Tierart. `stocked_rgve:null` und `total_alpine_days_all_herded_alms:null` leiten sicher aus den bekannten verschachtelten Tieraufzeichnungen ab.

Echte numerische0 wird getrennt geprüft: total days=0 ergibt 0 statt Divisionsabbruch; stocked_rgve=0 bleibt0 und wird nicht zum Nullfallback umgedeutet. Letzterer Wert widerspricht im gezielten Technikfall den bekannten 3 RGVE und ist deshalb ein Aggregat-/Konsistenzfall. declared_herder_count=0 meldet die Diskrepanz, während die eine tatsächliche eindeutige Person weiter die Kapazität bestimmt.

Originalstartjahr:null kann über Rego-Termordnung den Renewalpfad passieren und 243 EUR ergeben. Öffentlicher Anteil missing/null, fehlender Heimmanagement-/Österreich-/Fremdfinanzierungsstatus und fehlendes is_herded/kept_in_austria werden günstig ergänzt. Auftriebsbericht missing/null lässt hier volle bekannte Auftriebsdauer zu. Dog-Antragsdatum missing/null ermöglicht 1200 EUR Zuschlag; Startmissing nutzt currentyear. Diese Fälle dokumentieren den gewünschten positiven Nachweisvertrag. Fehlende Belege sind keine tatsächliche Nichtmeldung, unzulässige Betriebe oder frei gewählte100%-Agrarsanktion.

Funktionierende Gates bleiben sichtbar: fehlende aktive Landwirtschaft bzw. Almbetreiberangabe, fehlender tatsächlicher Care-Nachweis, bekannte Kontrollverweigerung ohne Ausnahme, bekannte aktuelle Deregistrierung und fehlende Kombination sperren ihren jeweiligen aktuellen Betrag. Eine positiv gegebene anwendbare Kontrollausnahme wird honoriert. Ein gültig angegebenes zukünftiges Hauptstartjahr zahlt noch nicht. Für eine bekannte 3 ha-Alternative verursacht ein unbekanntes PROGRAM-Erstjahr oder nullable geschützter Anbau keinen erfundenen Mindestflächenverstoß.

Die Identitäts-/Zeitkontrollen sind eigene technische Familien: Widersprüchlich gleiche Maßnahmen-/Alm-IDs abortieren. Eine vorhandene individuelle Tierzeile mit identischer Tier-ID und identischem Aufenthalt ein zweites Mal eingefügt erhöht dagegen 3 auf 4 RGVE; es gibt keinen vollständigen Tierregisterabgleich. Identische doppelte Herder-/Dog-IDs zählen korrekt nur einmal. Vorjährige Tieraufenthalte können im aktuellen Claim angerechnet werden; negative Unterbrechungstage sind ein gesonderter Bereichsfall. Aus widersprüchlichen Angaben wird kein realer Registerstand gewählt.

## MAIN-Zahlung, Meldung, Rückforderung und Anerkennung

MAIN enthält eine Variable payable_premium_eur; deren numerischer Wert ist keine tatsächliche AMA-Auszahlungsentscheidung. Die acht Meldungsblätter haben keinen eigenen aktuellen Betragsschalter, auch wenn fehlender Zahlungsantrag, Ohrmarke oder Abtriebsbericht fachlich relevant bleiben. Für diese Mängel wird keine unbelegte pauschale 100%-Kürzung erfunden. Vollkürzungshistorie und permanente Umstände arbeiten nur in separaten Helfern; ihre Integration bleibt offen. Tatsächliche Kontroll-/Deregistrierungs-/Kombinations- und Alm-Care-Gates wirken dagegen auf den aktuellen Betrag.

Nach erloschenem Vertrag kann die Kombination aus nachträglicher Korrektur und schriftlichem Ersuchen wieder 243 EUR ermöglichen. Das Merkblatt verlangt ein gesondertes Ersuchen; ein gestelltes Ersuchen ist kein tatsächlicher Anerkennungsbescheid. Der native Helfer reentry_requires_ama_recognition ist nicht in MAIN integriert. Diese Kontrolle verlangt positiven Nachweis, ohne einen schon abgelehnten oder schon genehmigten realen Fall zu behaupten.

## Tatsächliche App-Projektion und Wiederholbarkeit

Die unveränderte reine Funktion adapt_payload_for_measures wurde auf Appcommit `529eadb34c4fdd249fbf739a372d63185b7374a2` mit einem strukturellen Verbund aller sieben tatsächlichen Vorschläge und den weiteren nativen Pfaden ausgeführt. Dieser Verbund ist kein behaupteter realer Betrieb mit allen Ereignissen. CursorWrapper.execute war durch einen sofort abbrechenden SQL-Guard geschützt: 0 Aufrufe. Konkrete vollständige Ein-/Ausgabe, Werte/Typen jedes Pfads und drei App-Dateihashes sind dokumentiert.

Ergebnis: 0/7 Vorschlagswurzeln, 0/93 Vorschlagsblätter und 2/2 weitere Canonicalpfade exakt erhalten. Genau die tatsächliche App-Ausgabe wurde einmal unverändert im Originalrun ausgewertet: definiert, eligible=false, payable_premium_eur=0. Diese Integrationsbeobachtung zählt zusätzlich zu den 110 Entwicklungsfällen. Keine Retentions-, Fehler- oder undefiniert-Zahl aus 14 wurde übernommen.

Die ersten 106 Fälle waren vor ihrer ersten Ausführung vollständig persistiert und typ-/enumgeprüft. Vier gezielte Ergänzungen zu beiden Altersbelegen:null, dem zulässigen count1-Default bei individuellen Rindern, echtem stocked_rgve=0 und deklarierter Herderzahl0 wurden ebenfalls zuerst persistiert und typgeprüft. Die ursprünglichen 106 Inputs, Queries, Erwartungen und Beobachtungen bleiben unverändert. Danach wurden sämtliche 110 Fälle vollständig erneut abgespielt; alle Statuswerte, Ausgaben und Fehler stimmen mit sämtlichen ersten Beobachtungen überein. Keine erwartete Antwort wurde aus den Ergebnissen umgeschrieben.

Finale vorhandene Werte: 14769 Objekt-/Array-/Primitivprüfungen, ausschließlich elf benannte Farm-Schemastresse und kein unbekannter Pfad oder unerwarteter Typfehler. 959 explizite Enumwerte über fünf Pfade enthalten ausschließlich drei benannte Outside-Stresse. Diese Prüfung zertifiziert vorhandene Formen, keine Pflichtfeldvollständigkeit, Identität, Zeitkonsistenz, Register-/Dokumentwahrheit oder vollständige fachliche Genehmigung.

Festes OPA 1.18.2 mit SHA `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`; strikter Check besteht. Originalpolicy-/Datenverzeichnisse werden mit intakten Namespaces geladen; strikte Builtinfehler, 10 s OPA-/20 s Prozesslimit, leere Netzfreigabe und blockierte Netzwerk-/Zeit-/Zufalls-/Runtimebuiltins.

Beim letzten eigenen Quellenabgleich wurden ausschließlich zwei Beleg-Metadaten präzisiert: Die bekannten technischen Ziegen-/Kamelidfälle erhielten ihre tatsächlichen Artzeilen0,15 auf Merkblattseite9 statt nur der Schafzeile mit gleichem Faktor. Zwei zusätzliche Originalzitate wurden wörtlich bestätigt; alle110 Inputs, Queries, Erwartungen und Beobachtungen bleiben unverändert. Vorherige JSON-/MD-Hashes und gemeinsame unveränderte Bindung stehen im transparenten Receipt.

Die Gruppen bleiben getrennt: sechs unabhängige Quellenkomponenten, 56 bedingte technische Kontrollen, 24 gewünschte Positivnachweisgrenzen, zwölf Identitäts-/Zeitkontrollen und zwölf ausdrückliche Outside-Stresse. Dies sind öffentliche gezielte Entwicklungsproben. Familien können mit Core/General/Domain überlappen; keine unabhängigen Genauigkeitsfälle werden daraus konstruiert. Historische Selbsttests, manuelle Anpassungstests, private Referenzen und GM-/Domainexpert:innenurteile dienen nicht als Oracle. Policies, Canonical, Originale, App, gemeinsame Sammler-/Queue-/QC-Dateien und andere Maßnahmenteile wurden nicht geändert.
