# o6_13: Eingabevertrag und tatsächliche App-Projektion

Run `v2-o6_13-opus-5.5-high-20260926`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. Öffentliche Entwicklungsanalyse ohne Förderfreigabe oder Genauigkeitsaussage. Inputs-JSON SHA-256: `059655540e4b3abb8f1e470aef6d3947f3067896de159ccbe3059fdf581ceb52`.

103 frische Proben umfassen 166 typisierte Einzelprüfungen: 135 erfüllt, 31 nicht erfüllt. 97 native Ergebnisse sind definiert; sechs MAIN-Abbrüche betreffen ausdrücklich außerhalb des Schemas liegende Werte. Es gibt keinen beobachteten gültigen Nullable-Abbruch, keinen Identitäts-Laufzeitkonflikt und kein undefiniertes Ergebnis. Neun Abfragen richten sich direkt an sieben Quellenkomponenten und zwei technische Freigabeprädikate. Der zusätzliche exakte App-Ausgang wird separat ausgewertet und ergibt eine definierte negative Entscheidung mit 0 EUR.

## Quellen und vollständiger Lesebereich

Das neue Merkblatt wurde auf allen vier Seiten einschließlich Tabellen, Fortsetzungen und Ausnahmen vollständig gelesen: `0d162ef5c7ae913eb15463f6fb3fb0fd4685b320811022d78cf70e899b9e7ed1`. Alle neun produktiven Module mit 1.136 Zeilen sowie alle 12 nummerierten Annahmen, offenen Fragen und technischen Rohnotizen wurden vollständig gelesen. Die native MAIN-Abfrage ist tatsächlich `data.oepul.o6_13.decision`; statische Daten liegen unter `data.o6_13.measure`, `.general`, `.anhang_l` und `.notices_2026`.

Alle acht gebundenen Originalquellen wurden mit ihrem SHA-256 geprüft. Sieben geteilte Quellen verwenden die dokumentierten vollständigen Vorlektüren bei identischem Hash; ihre aktuellen Verbraucherklauseln wurden erneut geprüft. Hier wurden insbesondere ATB-PDF 4–11,13,14,18,19 sowie SRL-PDF 12,14,22,68 vollständig gelesen. Weitere im JSON genannte gemeinsame Seiten verwenden die persönlichen Lektüren aus 10/11/12 bei gleichem Hash und den aktuellen Zitatabgleich. Alle 59 Profilbelege sind auf der tatsächlichen Seite nach ausschließlich Whitespace-Normalisierung wiedergefunden.

GSP-AV und NAPV sind in diesem Paket als Originale nicht geliefert. Ihre Erwähnung in SRL/Hinweisen erzeugt keine separat gebundene Rechtsfassung. Die Dürrehinweise vom 5./12. August wurden für ihre tatsächliche Ackerfrucht-, Ernte- und Gebietskulisse erneut gelesen; synthetische GA-Kreuzflags beweisen keine Anwendbarkeit im Gewächshaus. Die übrigen beiden Hinweise erhalten keine sachfremde Ausnahme für 13.

## Vollständiger Profilkatalog

23 tatsächliche `add`-Vorschläge umfassen 76 Blätter: 73 gelesen, drei ungelesen. 131 kontextuelle Lesestellen einschließlich vorhandener Canonicalpfade sind erfasst. Acht dynamische Vorlagen werden auf 25 tatsächliche Schlüssel aus Code/Daten geschlossen: Antragsteller 4, frühere Abmeldung/Ausschluss 2, Kontrollfristen 2, Einsatzqualifikation 3, Aufzeichnungsfelder 5, nicht förderfähige Teilflächen 5, Förderüberschneidung 2 und Mindestbewirtschaftung 2. Der Kaufbeleg hat eine eigene direkte true-Prüfung.

Alle elf ausschließlich meldenden Blätter erreichen MAIN: fünf Übernahmefelder und sechs Dokumentationsfelder. Sie haben keinen eigenen aktuellen Betragsschalter. Es gibt kein ausschließlich in separaten Helfern gelesenes Vorschlagsblatt. Die übrigen 62 gelesenen Blätter wirken bedingt auf MAIN-Nachweise, Vertrags-/Flächenzulassung oder Beträge.

| Nr. | Tatsächlicher Vorschlagspfad | Blätter | gelesen / ungelesen |
|---:|---|---:|---:|
| 1 | `farm.applicant` | 7 | 7 / 0 |
| 2 | `farm.oepul.first_participation_year` | 1 | 1 / 0 |
| 3 | `farm.oepul.o6_13` | 19 | 19 / 0 |
| 4 | `land.protected_cultivation_area_ha` | 1 | 1 / 0 |
| 5 | `land.minimum_size_additional_area_ha` | 1 | 1 / 0 |
| 6 | `land.parcels[].oepul_codes` | 1 | 1 / 0 |
| 7 | `land.parcels[].op_measure_codes` | 1 | 1 / 0 |
| 8 | `land.parcels[].other_measures_on_parcel` | 1 | 1 / 0 |
| 9 | `land.parcels[].protected_cultivation` | 13 | 11 / 2 |
| 10 | `land.parcels[].beneficial_organism_applications` | 12 | 11 / 1 |
| 11 | `land.parcels[].records` | 1 | 1 / 0 |
| 12 | `land.parcels[].minimum_management` | 3 | 3 / 0 |
| 13 | `land.parcels[].drought` | 2 | 2 / 0 |
| 14 | `land.parcels[].force_majeure_recognised` | 1 | 1 / 0 |
| 15 | `land.parcels[].area_type` | 1 | 1 / 0 |
| 16 | `land.parcels[].actively_managed` | 1 | 1 / 0 |
| 17 | `land.parcels[].correctly_identified` | 1 | 1 / 0 |
| 18 | `land.parcels[].located_in_austria` | 1 | 1 / 0 |
| 19 | `land.parcels[].national_park` | 1 | 1 / 0 |
| 20 | `land.parcels[].national_park_relevant_restrictions` | 1 | 1 / 0 |
| 21 | `land.parcels[].funding_overlap` | 3 | 3 / 0 |
| 22 | `land.parcels[].transfer` | 2 | 2 / 0 |
| 23 | `land.parcels[].non_compliance_due_to_third_party_fault` | 1 | 1 / 0 |

Jedes der 76 Blätter hat im JSON Typ/Enum, Einheit, Bedeutung, Datum/Jahr/Identität, bedingte Erforderlichkeit, Missing-/Nullabgrenzung, tatsächliche Defaults, alle Lesestellen, Quellenbelege und App-Retention. Es wird keine notwendige optionale Ausführung erfunden, um einen Fehlerpfad zu erreichen.

| Blatt | tatsächlicher Deskriptor | Scope | Lesestellen |
|---|---|---|---|
| `farm.applicant.legal_form` | `enum(natural_person\|registered_partnership\|legal_person\|association_of_persons)` | bedingter MAIN-Nachweis/Betrag | access.rego:17, access.rego:26 |
| `farm.applicant.public_body_share_percent` | `number\|null` | bedingter MAIN-Nachweis/Betrag | access.rego:28 |
| `farm.applicant.is_public_body` | `boolean` | bedingter MAIN-Nachweis/Betrag | access.rego:45 |
| `farm.applicant.is_active_farmer` | `boolean` | bedingter MAIN-Nachweis/Betrag | access.rego:65 |
| `farm.applicant.has_agricultural_activity` | `boolean` | bedingter MAIN-Nachweis/Betrag | access.rego:65 |
| `farm.applicant.farms_in_own_name_and_account` | `boolean` | bedingter MAIN-Nachweis/Betrag | access.rego:65 |
| `farm.applicant.has_control_over_declared_areas` | `boolean` | bedingter MAIN-Nachweis/Betrag | access.rego:65 |
| `farm.oepul.first_participation_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | access.rego:71 |
| `farm.oepul.o6_13.entry_year` | `int\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:24 |
| `farm.oepul.o6_13.measure_application_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:26 |
| `farm.oepul.o6_13.contract_active_previous_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:70, contract.rego:111 |
| `farm.oepul.o6_13.nue_used_previous_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:71, contract.rego:83 |
| `farm.oepul.o6_13.withdrawn_previous_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:72, contract.rego:93 |
| `farm.oepul.o6_13.excluded_from_measure` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:73, contract.rego:93 |
| `farm.oepul.o6_13.mfa_submitted_previous_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | contract.rego:74, contract.rego:102 |
| `farm.oepul.o6_13.member_of_producer_organisation_with_op_covering_organisms` | `boolean` | bedingter MAIN-Nachweis/Betrag | access.rego:105 |
| `farm.oepul.o6_13.withdrawal.declared_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:142 |
| `farm.oepul.o6_13.withdrawal.declared_online_in_mfa` | `boolean\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:160, contract.rego:183 |
| `farm.oepul.o6_13.on_site_check_announced_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:147 |
| `farm.oepul.o6_13.admin_check_result_notified_date` | `date\|null` | bedingter MAIN-Nachweis/Betrag | contract.rego:147 |
| `farm.oepul.o6_13.takeover.request_date` | `date\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | contract.rego:239, contract.rego:264 |
| `farm.oepul.o6_13.takeover.taker_already_participating` | `boolean\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | contract.rego:248 |
| `farm.oepul.o6_13.takeover.taken_over_area_ha` | `number\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | contract.rego:255 |
| `farm.oepul.o6_13.takeover.extension_to_other_areas_ha` | `number\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | contract.rego:257 |
| `farm.oepul.o6_13.takeover.approved_by_ama` | `boolean\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | contract.rego:265 |
| `farm.oepul.o6_13.compliance.sanction_stage` | `enum(none\|warning\|reduction_2\|reduction_5\|reduction_10\|reduction_25\|reduction_50\|reduction_100\|exclusion)` | bedingter MAIN-Nachweis/Betrag | sanctions.rego:6 |
| `farm.oepul.o6_13.compliance.hundred_percent_reductions_in_contract_period` | `int` | bedingter MAIN-Nachweis/Betrag | sanctions.rego:8 |
| `land.protected_cultivation_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | access.rego:75 |
| `land.minimum_size_additional_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | access.rego:81 |
| `land.parcels[].oepul_codes[]` | `string` | bedingter MAIN-Nachweis/Betrag | parcels.rego:7 |
| `land.parcels[].op_measure_codes[]` | `string` | bedingter MAIN-Nachweis/Betrag | parcels.rego:167 |
| `land.parcels[].other_measures_on_parcel[]` | `string` | bedingter MAIN-Nachweis/Betrag | parcels.rego:267 |
| `land.parcels[].protected_cultivation.structure_type` | `enum(fixed_greenhouse\|unfixed_foil_tunnel\|none)` | bedingter MAIN-Nachweis/Betrag | parcels.rego:26, parcels.rego:31 |
| `land.parcels[].protected_cultivation.structure_id` | `string\|null` | ungelesen | — |
| `land.parcels[].protected_cultivation.covering_material` | `enum(glass\|foil\|plastic\|none)\|null` | bedingter MAIN-Nachweis/Betrag | parcels.rego:32 |
| `land.parcels[].protected_cultivation.growing_system` | `enum(grown_soil\|pots\|substrate\|containers\|alternating)` | bedingter MAIN-Nachweis/Betrag | parcels.rego:41, parcels.rego:42, parcels.rego:47, parcels.rego:84, parcels.rego:90, parcels.rego:96 |
| `land.parcels[].protected_cultivation.growing_system_on_april_1` | `enum(grown_soil\|pots\|substrate\|containers)\|null` | bedingter MAIN-Nachweis/Betrag | parcels.rego:48 |
| `land.parcels[].protected_cultivation.field_use_type` | `enum(A\|GA\|other)` | bedingter MAIN-Nachweis/Betrag | parcels.rego:53 |
| `land.parcels[].protected_cultivation.is_other_protected_area` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:110 |
| `land.parcels[].protected_cultivation.sales_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | parcels.rego:59 |
| `land.parcels[].protected_cultivation.display_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | parcels.rego:59 |
| `land.parcels[].protected_cultivation.storage_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | parcels.rego:59 |
| `land.parcels[].protected_cultivation.unused_area_between_structures_ha` | `number` | bedingter MAIN-Nachweis/Betrag | parcels.rego:59 |
| `land.parcels[].protected_cultivation.necessary_path_area_ha` | `number` | ungelesen | — |
| `land.parcels[].protected_cultivation.excess_path_area_ha` | `number` | bedingter MAIN-Nachweis/Betrag | parcels.rego:59 |
| `land.parcels[].beneficial_organism_applications[].date` | `date` | bedingter MAIN-Nachweis/Betrag | obligations.rego:15, obligations.rego:40, obligations.rego:56, obligations.rego:89, obligations.rego:101, obligations.rego:105 |
| `land.parcels[].beneficial_organism_applications[].organism_species` | `string` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:57, obligations.rego:89 |
| `land.parcels[].beneficial_organism_applications[].quantity` | `number` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:89 |
| `land.parcels[].beneficial_organism_applications[].quantity_unit` | `string\|null` | ungelesen | — |
| `land.parcels[].beneficial_organism_applications[].purchase_receipt_available` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:85 |
| `land.parcels[].beneficial_organism_applications[].reason` | `string\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:89 |
| `land.parcels[].beneficial_organism_applications[].target` | `string\|null` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:89 |
| `land.parcels[].beneficial_organism_applications[].listed_in_psm_register` | `boolean` | bedingter MAIN-Nachweis/Betrag | obligations.rego:16, obligations.rego:32 |
| `land.parcels[].beneficial_organism_applications[].applied_at_register_rate` | `boolean` | bedingter MAIN-Nachweis/Betrag | obligations.rego:17, obligations.rego:32 |
| `land.parcels[].beneficial_organism_applications[].replaces_psm_use` | `boolean` | bedingter MAIN-Nachweis/Betrag | obligations.rego:18, obligations.rego:32 |
| `land.parcels[].beneficial_organism_applications[].covers_entire_area` | `boolean` | bedingter MAIN-Nachweis/Betrag | obligations.rego:51 |
| `land.parcels[].beneficial_organism_applications[].use_type` | `enum(plant_protection\|bumblebee_pollination\|other)` | bedingter MAIN-Nachweis/Betrag | obligations.rego:19, obligations.rego:36 |
| `land.parcels[].records.kept_per_parcel` | `boolean` | MAIN-Meldung, kein eigener aktueller Betragsschalter | obligations.rego:115 |
| `land.parcels[].minimum_management.properly_cultivated` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:229 |
| `land.parcels[].minimum_management.annual_care` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:229 |
| `land.parcels[].minimum_management.harvested_share_percent` | `number\|null` | bedingter MAIN-Nachweis/Betrag | parcels.rego:215 |
| `land.parcels[].drought.no_harvestable_crop_due_to_drought` | `boolean` | bedingter MAIN-Nachweis/Betrag | notices_2026.rego:32 |
| `land.parcels[].drought.crop_usually_harvested_late_summer_or_autumn` | `boolean` | bedingter MAIN-Nachweis/Betrag | notices_2026.rego:33 |
| `land.parcels[].force_majeure_recognised` | `boolean` | bedingter MAIN-Nachweis/Betrag | notices_2026.rego:42, parcels.rego:210 |
| `land.parcels[].area_type` | `enum(standard\|energy_wood_short_rotation\|pussy_willow_production\|vine_nursery\|tree_nursery\|not_actively_managed\|other_area\|not_mainly_agricultural\|gloez_landscape_element)` | bedingter MAIN-Nachweis/Betrag | parcels.rego:103, parcels.rego:105 |
| `land.parcels[].actively_managed` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:116 |
| `land.parcels[].correctly_identified` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:122 |
| `land.parcels[].located_in_austria` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:128 |
| `land.parcels[].national_park` | `string\|null` | bedingter MAIN-Nachweis/Betrag | parcels.rego:138, parcels.rego:144, parcels.rego:149, parcels.rego:154 |
| `land.parcels[].national_park_relevant_restrictions` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:151 |
| `land.parcels[].funding_overlap.other_public_funding_same_service` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:182 |
| `land.parcels[].funding_overlap.statutory_or_official_requirement` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:182 |
| `land.parcels[].funding_overlap.official_compensation_area` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:187 |
| `land.parcels[].transfer.transferred_during_year` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:194 |
| `land.parcels[].transfer.successor_continues_same_or_higher_measure` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:195 |
| `land.parcels[].non_compliance_due_to_third_party_fault` | `boolean` | bedingter MAIN-Nachweis/Betrag | parcels.rego:201 |

Ungelesen bleiben `protected_cultivation.structure_id`, `.necessary_path_area_ha` und `beneficial_organism_applications[].quantity_unit` am jeweiligen Schlag. Notwendige Gangflächen bleiben bereits innerhalb der Bruttofläche; das ungenutzte Zusatzfeld ist kein automatischer Fehlbetrag. Menge wird nur auf vorhandene Dokumentation geprüft, ohne Einheiten-/Registerdosisrechnung.

| Weiterer Canonicalpfad | tatsächlicher Scope | App exakt erhalten |
|---|---|---|
| `farm.region.district` | Exact district string used with actual federal state in2026 drought clause; farm location is not independently the plot location. | nein |
| `farm.region.federal_state` | Exact federal-state string, actual named geography; no actual greenhouse/arable applicability proof from string alone. | nein |
| `farm.year` | Integer current year, distinct from original entry/programfirst/priorcontract year. | ja |
| `land.parcels[].area_ha` | Nonnullable physical parcel hectares; protected minimum fallback, deductions and premium. Conflicting sameID rows need reconciliation. | ja |
| `land.parcels[].parcel_id` | Exact parcel identity, used for minimum-count and merged findings; native outputs are arrays and conflicting sameID does not itself cause object-key conflict. | ja |
| `land.total_area_ha` | Under actual rawA06 this is§25area withoutGA; extraGA/K20/LE/hedges/agroforestry are separate and disjoint. No source claim that native modulation accounting is fully legally resolved. | ja |

Es gibt sechs weitere tatsächlich gelesene Canonicalpfade und keinen unvorgeschlagenen nativen Zusatzpfad. Coarse `land_use` sowie Kulturkategorie/-name sind gültig in den technischen Basen angegeben, werden von 13 aber nicht als tatsächliche Verbraucher gutgeschrieben.

## Quellenkomponenten und konditionale technische Basen

Sieben Quellenkomponenten kommen ohne Organismus-/Produktbeleg aus: A-/GA-Prämiensatz für 2023 und 2025, zwei dazugehörige Cap-Komponenten und der physische Nettoflächenabzug von 1,00 auf 0,75 ha. Alle sieben werden erfüllt. Sollwerte stammen aus den Originaltabellen bzw. der Flächenbeschreibung und wurden vor nativer Ausführung persistiert.

Jeder positive vollständige MAIN-Fall benötigt bei 13 einen anrechenbaren Organismeneinsatz. Deshalb sind sämtliche positiven Vollbasen ausdrücklich technische Komponentenrechnungen unter stipulierten positiven Register-, Aufwandsmengen-, PSM-Ersatz- und Vollflächenbelegen. Der synthetische Artenname ist kein tatsächlicher AGES-Register- oder Zulassungsbeleg. Auch gesetzte Kauf-/Aufzeichnungsflags behaupten keine tatsächlich erfolgte Behördenprüfung.

Die konditionalen 1 ha-Basen für gewachsenen Boden/A, Töpfe/GA, Folientunnel/A, tatsächlichen April 1-Wechsel/GA und bekannt vollständige Verlängerung ergeben 2160 EUR; 2023 ergeben sich 2000 EUR. Alle ausgewählten Struktur-, Eindeckungs-, System-, Antrags-, Jahres-, Flächen-, Qualitäts- und Aufzeichnungsoptionen sind explizit vorhanden. Nicht eingetretene Ausstiegs-/Übernahme-/Übertragungsereignisse bleiben in den normalen Basen absent. Reine Kreuzklassifikationen einschließlich Hummelbestäubung und GA-Dürre sind technisch gekennzeichnet.

Raw-Annahme A06 trennt die §25-Fläche ohne GA (`total_area_ha`) von zusätzlichen GA/K20/LE/Hecken/Agroforstflächen (`minimum_size_additional_area_ha`); `protected_cultivation_area_ha` enthält A oder GA. Daher wurden normale reine 1 ha A-Fälle als 1+0/protected1 und reine 1 ha GA-Fälle als 0+1/protected1 konstruiert, jeweils mit korrekter Ackerfläche. Das geschah vor der ersten Persistierung/Ausführung der Proben. Es gab keine nach Beobachtungen angepasste Fallrechnung und keinen angeblichen Gegenfall für die Modulation großer Betriebe.

Die Gruppen bleiben getrennt: sieben Quellenkomponenten, 45 technische Kontrollen, 35 gewünschte Positivnachweisgrenzen und 16 ausdrückliche Schema-Stresse. Eine unbekannte Pflichtangabe ist keine bestätigte verspätete Beantragung, ein falsches Gewächshaus oder eine illegale Anwendung. Die konservative Positivnachweissperre ist ein gewünschter Aufgabenvertrag.

## Native Befunde und gezielt gutgeschriebene Schutzprüfungen

Fehlende bzw. nullable Einstiegsdaten bleiben definiert und verhindern den neuen Vertrag; fehlende relevante Struktur/Eindeckung/Nutzungsart und fehlende oder false Register-/Dosis-/PSM-Ersatz-/Vollflächenbelege sperren in den gezielten Kontrollen. Gegenüber 12 bleiben negative MAIN-Zusammenfassungen hier durch false-Defaults definiert. OP, bekannte operationelle Programmmitgliedschaft und festgesetzte Ausschlusshistorie sperren ebenfalls tatsächlich. Die schon behördlich festgesetzte hypothetische 25%-Stufe rechnet 1620 EUR; aus einem lokalen Befund wird keine frei gewählte 100%-Sanktion gemacht.

Offen bleiben mehrere gewünschte Positivnachweise: fehlende Antragstellergrundlagen, öffentliche Beteiligung, Vorjahres-MFA-/Mitgliedschaftsbeleg, Lage/Identifikation/aktive Bewirtschaftung und Bewirtschaftungsanteile können die konditionale Basis weiterzahlen lassen. Fehlendes Anbausystem oder gültiges April 1=null im ausgewählten Wechselzweig kann die genaue A-/GA-Prüfung umgehen. Fehlender April 1-Schlüssel wird dagegen gesondert erkannt. Die 5 Übernahmefelder sind MAIN-Befunde, kein alternativer Vertragsgrund; unknown AMA-Approval erzeugt keine zusätzliche Warnung. Missing/null Online-Abmeldungsbestätigung kann das separate native Freigabeprädikat true ergeben.

| Befundachse | Anzahl | Einordnung |
|---|---:|---|
| Gültiges Nullable, Laufzeitabbruch | 0 | Kein solcher Abbruch in dieser gezielten Suite; fehlende Nachweise bleiben eine getrennte Achse |
| Konflikt gleicher Identität, Laufzeitabbruch | 0 | Anders als12 sind die Ausgaben Arrays; widersprüchliche gleichnamige Schläge können definiert mehrfach zählen |
| Außerhalb des Schemas, MAIN-Abbruch | 6 | Canonical-Fläche=null; Verkaufsfläche=null; Objekte protected_cultivation, state, applicant, minimum_management=null |
| Undefiniert | 0 | Auch der native App-Ausgang ist definiert negativ; erwartete fehlende Freigabe der zwei Prädikate ist keine beobachtete undefined-Zahl |

Der technische Identitätsfall mit derselben Schlag-ID und widersprüchlichen 1 ha-/0,5 ha-Zeilen zählt beide und ergibt 3240 EUR. Das ist eine Eingabekonsistenzgrenze, kein gewählter tatsächlicher Flächenwert oder fachlicher Vollsanktionsfall. Doppelte identische Anwendungszeilen erhöhen die existentielle Prämie nicht. Negative Teilfläche, 0 ha und 0 Menge sind als Bereichs-/Konsistenzkontrollen deklariert; ihre Ausgaben werden nicht als normale Fördergoldwerte ausgegeben.

Alle sechs Laufzeitfehler sind im JSON mit vollständigem Pfad, ursprünglichem Schema, Container-/Primitivklasse, Query und nativer Fehlermeldung erfasst. Außerhalb liegende Werte müssen nicht abstürzen: unbekannte Sanktionsstufe kann nativ zu 0 Kürzung führen; ein ungültiges Kalenderdatum mit passendem Jahrespräfix kann als Einsatzdatum passieren. Diese Prüfung bescheinigt keine Kalender-/Antragsteller-/Zulassungswahrheit.

## Tatsächliche App-Projektion und vollständiger Replay

Die reine Funktion `adapt_payload_for_measures` wurde unverändert auf Appcommit `529eadb34c4fdd249fbf739a372d63185b7374a2` mit einem strukturellen Verbund aller 23 Vorschläge ausgeführt. Das ist kein behaupteter tatsächlicher Betrieb mit sämtlichen optionalen Ereignissen. `CursorWrapper.execute` wurde durch einen sofort abbrechenden SQL-Guard geschützt: 0 Aufrufe. Vollständiger Eingang/Ausgang, JSON-Typen, Werte und drei Codehashes sind enthalten.

Retention: 0/23 Vorschlagswurzeln, 0/76 Blätter und 4/6 weitere Canonicalpfade. Region geht verloren; Jahr, Schlag-ID, Schlagfläche und Gesamtfläche bleiben exakt erhalten. Keine Aliasnormalisierung oder Retentionszahlen aus 12 werden zugerechnet. Genau der tatsächliche App-Ausgang wurde einmal separat mit dem Originalrun ausgewertet: definiert, eligible=false und net_eur=0. Dieser Integrationsbeleg zählt zusätzlich zu 103 frischen Proben.

Alle 103 persistierten Eingaben und Queries wurden nach dem Typ-/Enumabgleich vollständig erneut ausgeführt. Sämtliche Statuswerte, Ausgaben und Fehler sind mit der ersten Ausführung identisch. Inputs, Queries und Erwartungen wurden nicht nach beobachteten Ergebnissen angepasst; der Replay-Beleg bindet ihre Hashes und die vollständigen Beobachtungen.

OPA 1.18.2 ist auf SHA `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8` fixiert. `opa check --strict` besteht. Tatsächliche Policy-/Datenverzeichnisse werden mit intaktem Namespace geladen, strikte Builtinfehler, 10 s OPA-/20 s Prozesslimit, leere Netzfreigabe und blockierte Netzwerk-/Zeit-/Zufalls-/Runtimebuiltins.

Alle 9109 vorhandenen Objekt-/Array-/Primitivwerte der 103 Proben wurden gegen unverändertes Canonical plus tatsächlich 23 Vorschläge geprüft: ausschließlich 16 benannte Schema-Stresswerte, kein unbekannter Pfad und keine unerwartete Abweichung. 1052 explizite Enumwerte auf 11 Pfaden ergeben ausschließlich drei benannte Stresse: Rechtsform=null, Sanktionsstufe=null und not_a_stage. Vorhandene Werte sind damit geprüft; Pflichtfeldvollständigkeit, Quellenwahrheit, Identität und Tatsachenbescheide werden dadurch nicht zertifiziert.

Historische Modellselbsttests, manuelle Anpassungstests, private Referenzen sowie GM-/Domainexpert:innenurteile wurden nicht als Oracle verwendet. Policies, Quellen, Canonical, App, gemeinsame Sammler-/Queue-/QC-Dateien und andere Maßnahmenteile wurden nicht verändert.
