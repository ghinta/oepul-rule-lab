# o6_1b – Eingaben, Fehlend-Verhalten und App-Vertrag

Geprüft ist ausschließlich `v2-o6_1b-opus-5.5-high-20260925` aus dem unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dies ist die Eingabevertragsprüfung des zweiten Runs in der gemeinsamen Sammlung [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) / [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Sie enthält Befunde und öffentliche Entwicklungsproben. Sie ändert keine Policy und erteilt keine Förderfreigabe.

Das originale BIO-Informationsblatt April 2026 wurde vollständig gelesen: **51 Seiten**, einschließlich Sorten-/Artenlisten, Prämientabellen, Beispielen und Änderungsverzeichnis. Alle elf produktiven Rego-Module wurden für den Eingabevertrag durchgesehen. Die sieben weiteren Quellen sind per SHA-256 identisch mit der vorangegangenen UBB-Prüfung; ihre vollständige Prüfung bleibt im gemeinsamen Quellenprotokoll gebunden. In diesem Teil wurden die BIO-relevanten Proposal-Zitate gezielt am Original nachgeschlagen. Alle **182** verschiedenen zugeordneten Belege sind bei reiner Leerraumnormalisierung auffindbar. Ein Wortlauttreffer allein bestätigt keine fachliche Schlussfolgerung.

## Vollständigkeit

Der vollständige maschinenlesbare Nachweis steht in [inputs.json](inputs.json). Er enthält alle **89 Vorschläge** mit **192 neuen Blattpfaden**, vorgeschlagenen Typen, Einheiten, bedingter Erforderlichkeit, Quellenbelegen, exakten Lesestellen und Default-/Null-Verhalten. Es gibt keine Canonical-Ersetzung.

Der historische statische Scanner meldete nur `input.farm.year` und keine unbekannten Pfade. Die manuelle Prüfung mit aufgelösten `object.get`-Empfängern und den beiden dynamischen `flag`-Schleifen findet **425 deklarierte Lesestellen**. **191** vorgeschlagene Blätter werden im Code gelesen; `land.multi_use_hedges[].field_piece_id` wird nicht gelesen. Dazu kommen **14 bereits vorhandene Canonical-Blattpfade**. Nach Prüfung der lokalen Variablen und Daten-/Input-Unterscheidung bleibt kein nicht verwalteter Blattpfad.

Gelesen bedeutet hier eine deklarierte Lesestelle. Bei acht Eingaben führen die damit berechneten Helfer nicht in das Hauptresultat oder seine Prämienberechnung: Zahlungsobergrenze am Schlag, 2025-Flächenreferenz, Herkunft/Datum eines Maßnahmenwechsels, Ausstiegsdatum/-grund, Sanktionsstufe und Zahl vollständiger Kürzungen. Diese acht Felder sind im JSON ausdrücklich als `helper_only_not_consumed_in_result` markiert.

## Reproduzierte Befunde

Die **44 Eingabeproben** speichern jeweils den vollständigen öffentlichen Input, die native Query, Erwartungen und Quellenbelege. Der generische gemeinsame Runner kann sie erneut ausführen. Erwartungen sind einzeln getrennt nach Quellenkomponente, gewünschtem positivem Nachweis und Robustheit bei ausdrücklich nullable Eingaben. Nicht erfüllte Erwartungen werden als konkrete Befunde gesammelt; sie bilden keinen Genauigkeitswert.

| Bereich | Beobachtung am unveränderten Run | Bedeutung |
|---|---|---|
| Antrag und Vertrag | Der vollständige kleine Kontrollbetrieb ist compliant. Entfernen bzw. null setzen von Vertragsbeginn, Antragsdatum oder Kontrollvertragsende lässt `compliant=true`. Auch 2029 kann compliant sein. 2022 ist das vollständige Resultat wegen fehlender Jahresraten undefiniert. | Die native Complianceflagge ist kein positiver Nachweis der Teilnahmeberechtigung. Der gewünschte Nachweisvertrag muss separat gelten. |
| Feldstückidentität | Zwei Schläge von je 3 ha bilden ein 6-ha-Feldstück ohne DIV; weitere 4 ha enthalten ausreichend DIV für die 7%-Betriebspflicht. Mit vollständiger Feldstückliste kommt O61B-DA-004; ohne Liste verschwindet der Verstoß und compliant wird true. | Schlagreferenzen allein reichen dem Run nicht. Inventar und Joins brauchen eigene Vollständigkeitsprüfung. Die fehlende Variante beweist die reale Gruppierung selbst nicht; dies ist ein gepaarter Informationsverlustfall. |
| Nullable Zahlen und Daten | `slope_percent=null` erfüllt den DIVRS-Standortvergleich `<18`; ein unbekannter Nichtinsektenanteil `null` erfüllt `<=10`. Dagegen verursachen `phenology_shift_days=null`, ein nullable GLÖZ-Flächenanteil und `first_declared_year=null` bei vorhandenem Umbruchdatum Laufzeitfehler. | Gültige nullable Profilformen können günstige Freigaben oder technische Abbrüche erzeugen. Null ist weder ein fehlender Schlüssel noch die Zahl 0. |
| DIVNFZ | Quellenbeispiel: Mahd 22. Juni, Ballenabtransport 24. Juni → nächste Tätigkeit frühestens 27. August. Fehlt das Abschlussdatum, berechnet der Run 25. August aus dem Mähdatum. | Beginn und Abschluss einer Nutzung sind unterschiedliche Ereignisse. Ein unbekannter Abschluss darf kein günstiges, präzises Datum erzeugen. |
| Ansaat | Bei bekannter Neuansaat überspringt ein fehlendes/null Acker-Ansaatdatum den Fristverstoß. Der Grünland-Helfer akzeptiert im Jahr 2026 sogar `2027-05-01` als rechtzeitige Aussaat. | Fehlend-Behandlung unterscheidet sich je Zweig. Ein bloßer Monat/Tag-Vergleich reicht für den Kalenderjahresbezug nicht. |
| Kulturidentität | Der deutsche Schlüssel Weizen wird als Getreide geprüft. Ein explizites `crop.species=Triticum aestivum` umgeht die deutsche Zuordnung und entfernt den 75%-Getreideverstoß. | Freie botanische Strings brauchen einen belegten kontrollierten Schlüsselvertrag. Dieses Audit führt keinen Alias ein. |
| Positive Eigenschaften | Fehlende LSE-Verfügungsgewalt oder ganzjährige Erhaltung verhindern die LSE-Eignung nicht. `is_grafted=null` lässt im Walnussbeispiel die Prämie von 810 EUR stehen; false entfernt sie. | Günstige Defaults und unbekannte Fakten dürfen keine bestätigten Nachweise ersetzen. |
| Nutzungshistorie | Bei abgeschlossenem Jahr und keiner aktuellen Pflege erzeugt `used_previous_year=false` den Zweijahrespflegeverstoß. null entfernt ihn und kann compliant=true ergeben. | Die erlaubte nullable Form unterscheidet sich fachlich von einer belegten Vorjahresnutzung. |
| PSM-Jahreswechsel | Bekannter PSM-Einsatz ohne Meldecode erzeugt 2025 den Codierungsverstoß, 2026 nicht. | Dieser Quellenwechsel wird in der isolierten Melderegel korrekt erkannt. Das bestätigt keine vollständige Einhaltung der Bio-Verordnung. |

Weitere Grenzen stehen im Befund-Ledger: Die Quelle verlangt biologische Tierhaltung ausdrücklich unabhängig vom Zertifikat; `is_certified_organic` erfasst diese Pflichten nicht vollständig. RGVE müssen beim Altersklassenwechsel zeitanteilig berechnet werden; im vorhandenen Vertrag steht nur eine ganzzahlige `animal_count`, ohne eigenständigen Durchschnitts-/Zeitgewichtspfad. Positive Prämien einschließlich der 400-EUR-Transaktionspauschale bleiben Diagnosen einzelner Formeln und keine bestätigten Auszahlungen.

## App-Abbildung

Der aktuelle App-Adapter wurde erneut mit einem öffentlichen synthetischen BIO-Payload ausgeführt. Jeder Datenbankzugriff war durch eine sofort fehlschlagende `CursorWrapper.execute`-Sperre verboten; es erfolgte kein solcher Zugriff. Vorher/Nachher-Payload und Hashes der App-Quelldateien stehen im JSON unter `app_projection`.

**Keiner der 89 nativen Vorschlagspfade wird in die tatsächliche OPA-Projektion übernommen.** Die App behält unter Bio-Zertifizierung nur `is_certified`; sie projiziert weder Registrierungs-/Kontrollvertragsdetails noch `oepul.o6_1b`, Antragstellerdaten, native Code-Listen, Feldstückinventar oder erweiterte Tiergruppenmerkmale. Auch in einen Canonical-Payload hineingeschriebene native Fakten werden bei dieser Projektion entfernt.

| Vorhandene App-Information | Für diesen Run zusätzlich erforderlich |
|---|---|
| Schlag-ID und flache Parzellenprojektion | Vollständiges Feldstückinventar mit stabilen Schlüsseln, verlässlicher Gruppierung und Flächenanteilen. |
| raw_label, Biodiversitätsproxy, Betriebsaggregate | Exakte Schlagnutzungsart, native `oepul_codes[]`, Mäh-/Bergmähderabgrenzung und kontrollierte Kulturidentität. |
| PSM-Flag, Schnittdaten, N-Mengen | Native Nutzungsereignisse mit `removed`, Anfang/Abschluss, Dünge-/Befahrungsereignisse und konkrete Ausnahmennachweise. |
| Allgemeine Bio-Zertifizierung und GVE/Tierzahl | Behördliche Registrierung, lückenloser Kontrollvertrag, tatsächliche Biohaltung sowie genaue und zeitanteilige RGVE-Kategorien. |
| oepul.shared und vorhandene Produktverträge anderer Maßnahmen | Der getrennte native Vertrag für `oepul.applicant`, `participating_measures`, `area_changes` und `o6_1b`. |

Gleiche Wörter oder ähnliche Bezeichnungen begründen keine freigegebenen Aliase. Einheiten unterscheiden sich selbst zwischen den Opus-Runs: BIO verwendet `public_body_share_percent` in Prozent 0..100, UBB hatte `public_body_share` als Bruchteil 0..1. Der BIO-Übernahmeanteil `extension_share` ist wiederum ein Bruchteil 0..1.

## Alle 89 Vorschläge

Die Tabelle belegt die Bearbeitung aller Vorschläge. Typen, Einheiten, Quellen und konkrete Null-/Defaultwirkungen pro Blatt stehen im JSON. Für alle Zeilen gilt: keine freigegebene Abbildung in den gegenwärtigen App-Vertrag.

| # | Vorschlag | Gelesene Blätter / gesamt | Kontext |
|---:|---|---:|---|
| 1 | `farm.certifications.organic.registered_with_food_authority` | 1 / 1 | Bio-Zertifizierung |
| 2 | `farm.certifications.organic.control_contract_start_date` | 1 / 1 | Bio-Kontrollvertrag |
| 3 | `farm.certifications.organic.control_contract_end_date` | 1 / 1 | Bio-Kontrollvertrag |
| 4 | `farm.certifications.organic.control_body_change_without_gap` | 1 / 1 | nur Kontrollstellenwechsel |
| 5 | `land.field_pieces` | 6 / 6 | Feldstückspflicht und LSE-Deckel |
| 6 | `land.parcels[].field_piece_id` | 1 / 1 | Schlag-Feldstück-Zuordnung |
| 7 | `land.parcels[].schlagnutzungsart` | 1 / 1 | MFA-Schlagnutzungsart |
| 8 | `land.parcels[].oepul_codes` | 1 / 1 | Schlag-Codes |
| 9 | `land.parcels[].is_mown` | 1 / 1 | gemähtes Grünland, Steilprämie |
| 10 | `land.parcels[].is_bergmaehder` | 1 / 1 | Bergmähder-Abgrenzung |
| 11 | `land.parcels[].ackerzahl` | 1 / 1 | DIV-Ackerzahlzuschlag |
| 12 | `land.parcels[].gruenlandzahl` | 1 / 1 | DIV-Grünlandzahl/DIVRS-Standort |
| 13 | `land.parcels[].national_park` | 1 / 1 | Nationalpark-Prämienausschluss |
| 14 | `land.parcels[].in_austria` | 1 / 1 | Flächenlage |
| 15 | `land.parcels[].species_rich_grassland_o6_17` | 1 / 1 | Kreislauf Grünland |
| 16 | `land.parcels[].oepul_area_payment_eur_per_ha` | 1 / 1 | schlagbezogene Förderobergrenze |
| 17 | `land.parcels[].federal_state` | 1 / 1 | 2026-Ernteausnahme |
| 18 | `land.parcels[].district` | 1 / 1 | 2026-Ernteausnahme |
| 19 | `land.parcels[].crop.species` | 1 / 1 | Anbaudiversifizierung |
| 20 | `land.parcels[].crop.second_crop_name` | 1 / 1 | förderwürdige/Kreislauf-Kulturen |
| 21 | `land.parcels[].crop.mixture_main_component` | 1 / 1 | Mischkultur-Hauptanteil |
| 22 | `land.parcels[].crop.cereal_share_percent` | 1 / 1 | Getreidegemenge |
| 23 | `land.parcels[].crop.variety` | 1 / 1 | SLK |
| 24 | `land.parcels[].crop.is_variety_pure` | 1 / 1 | SLK-Sortenreinheit |
| 25 | `land.parcels[].crop.poppy_strip_cultivation` | 1 / 1 | traditioneller SLK-Mohnstreifen |
| 26 | `land.parcels[].crop.seed_documented` | 1 / 1 | SLK-Nachweis |
| 27 | `land.parcels[].crop.multi_year` | 1 / 1 | SLK-Mehrjährigkeit |
| 28 | `land.parcels[].crop.first_year_of_use` | 1 / 1 | nur mehrjährige SLK |
| 29 | `land.parcels[].crop.summer_cereal` | 1 / 1 | WB-Sommergetreide |
| 30 | `land.parcels[].crop.is_grafted` | 1 / 1 | Obstanlagen |
| 31 | `land.parcels[].crop.late_harvest_crop` | 1 / 1 | 2026-Ernteausnahme |
| 32 | `land.parcels[].crop.autochthonous_seed_production` | 1 / 1 | BHG-Saatgutproduktion |
| 33 | `land.parcels[].crop.seed_harvest_year` | 1 / 1 | BHG-Samenernte |
| 34 | `land.parcels[].crop.additional_text` | 1 / 1 | BHG-Sammelschlagnutzungsarten |
| 35 | `land.parcels[].operations.use_events` | 5 / 5 | Bewirtschaftungsereignisse |
| 36 | `land.parcels[].operations.fertilizer_applications` | 2 / 2 | Düngeereignisse |
| 37 | `land.parcels[].operations.driving_events` | 2 / 2 | Befahrungsereignisse |
| 38 | `land.parcels[].operations.prohibited_uses` | 1 / 1 | Acker-DIV-Nutzungsverbote |
| 39 | `land.parcels[].operations.harvested_share_percent` | 1 / 1 | 85%-Ernte |
| 40 | `land.parcels[].operations.annual_full_use_done` | 1 / 1 | Mindestnutzung Grünland/Ackerfutter |
| 41 | `land.parcels[].operations.no_harvestable_stand_due_to_drought` | 1 / 1 | Dürreernte2026 |
| 42 | `land.parcels[].operations.erosion_reducing_method` | 1 / 1 | Erosionsschutz |
| 43 | `land.parcels[].operations.mulch_direct_striptill` | 1 / 1 | Erosionsschutz Zusatzkombination |
| 44 | `land.parcels[].operations.sowing_date` | 1 / 1 | WB-Anbaufrist |
| 45 | `land.parcels[].operations.row_spacing_cm` | 1 / 1 | WB-Reihenabstand |
| 46 | `land.parcels[].operations.undersown` | 1 / 1 | WB-Untersaatverbot |
| 47 | `land.parcels[].operations.psm_application_dates` | 1 / 1 | WB-PSM-Sperrzeit |
| 48 | `land.parcels[].operations.mechanical_weeding_dates` | 1 / 1 | WB-mechanische Beikrautregulierung |
| 49 | `land.parcels[].operations.sugar_beet_previous_year` | 1 / 1 | PZR auf Vorjahres-Zuckerrüben |
| 50 | `land.parcels[].operations.pheromone_traps` | 7 / 7 | PZR |
| 51 | `land.parcels[].constraints.biodiversity_area.first_declared_year` | 1 / 1 | DIV-Historie |
| 52 | `land.parcels[].constraints.biodiversity_area.previous_year_code` | 1 / 1 | DIVAGF-Folgejahr |
| 53 | `land.parcels[].constraints.biodiversity_area.is_new_sowing` | 1 / 1 | DIV-Neuansaat |
| 54 | `land.parcels[].constraints.biodiversity_area.sowing_date` | 1 / 1 | DIV-Ansaatdatum |
| 55 | `land.parcels[].constraints.biodiversity_area.sowing_exempt_existing` | 1 / 1 | DIV-Ansaat-Ausnahme |
| 56 | `land.parcels[].constraints.biodiversity_area.seed_mixture` | 11 / 11 | DIV-Saatgutmischung |
| 57 | `land.parcels[].constraints.biodiversity_area.divrs_variant` | 1 / 1 | Acker-DIVRS-Variante |
| 58 | `land.parcels[].constraints.biodiversity_area.divrs_interrupted` | 1 / 1 | DIVRS-Historie |
| 59 | `land.parcels[].constraints.biodiversity_area.break_date` | 1 / 1 | DIV-Umbruch |
| 60 | `land.parcels[].constraints.biodiversity_area.followed_by_winter_crop_or_catch_crop` | 1 / 1 | früherer DIV-Umbruch |
| 61 | `land.parcels[].constraints.biodiversity_area.loss_of_control` | 1 / 1 | DIV-Verfügungsverlust |
| 62 | `land.parcels[].constraints.biodiversity_area.converted_to_grassland` | 1 / 1 | DIV-Umwandlung Grünland |
| 63 | `land.parcels[].constraints.biodiversity_area.nat_auflagen` | 1 / 1 | NAT/N2/Monitoring |
| 64 | `land.parcels[].constraints.biodiversity_area.nat_area_used` | 1 / 1 | NAT-Acker-Anrechnung |
| 65 | `land.parcels[].constraints.biodiversity_area.ebw_fallow` | 1 / 1 | EBW-Acker-Anrechnung |
| 66 | `land.parcels[].constraints.biodiversity_area.ebw_habitat_creditable` | 1 / 1 | EBW-Grünland-Anrechnung |
| 67 | `land.parcels[].constraints.biodiversity_area.care_rules_6_1_4_2_met` | 1 / 1 | BAW/AG-DIV-Pflege |
| 68 | `land.parcels[].constraints.biodiversity_area.gloez4_buffer_strip` | 1 / 1 | GLÖZ4-DIV-Pufferstreifen |
| 69 | `land.parcels[].constraints.biodiversity_area.gloez8_fallow` | 1 / 1 | GLÖZ8-DIV-Stilllegung |
| 70 | `land.parcels[].constraints.biodiversity_area.invasive_species_present` | 1 / 1 | invasive Pflanzen |
| 71 | `land.parcels[].constraints.biodiversity_area.removal_implement` | 1 / 1 | DIV-Beseitigung |
| 72 | `land.parcels[].constraints.biodiversity_area.used_previous_year` | 1 / 1 | DIV-Pflegezweijahresfolge |
| 73 | `land.parcels[].constraints.biodiversity_area.year_complete` | 1 / 1 | DIV-Jahresvollständigkeit |
| 74 | `land.parcels[].constraints.biodiversity_area.comparable_second_cut_date` | 1 / 1 | DIVSZ-Vergleich |
| 75 | `land.parcels[].constraints.biodiversity_area.phenology_shift_days` | 1 / 1 | DIVSZ-Phänologie |
| 76 | `land.parcels[].constraints.biodiversity_area.first_use_completed_date` | 1 / 1 | DIVNFZ-Ruhezeit |
| 77 | `land.parcels[].constraints.biodiversity_area.variant_changes` | 3 / 3 | DIV-Variantenwechsel |
| 78 | `land.point_landscape_elements` | 16 / 16 | Punkt-LSE |
| 79 | `land.multi_use_hedges` | 14 / 15 | Mehrnutzenhecken |
| 80 | `livestock.species_groups[].rgve_key` | 1 / 1 | RGVE-Schlüssel |
| 81 | `livestock.species_groups[].is_certified_organic` | 1 / 1 | Nutztier-Biohaltung |
| 82 | `livestock.species_groups[].is_conventional` | 1 / 1 | konventionelle Equiden |
| 83 | `livestock.species_groups[].own_use` | 1 / 1 | Eigenbedarfsausnahme |
| 84 | `livestock.species_groups[].kept_in_austria` | 1 / 1 | Tierhaltung Inland |
| 85 | `oepul.applicant` | 5 / 5 | förderwerbende Person |
| 86 | `oepul.first_participation_year` | 1 / 1 | Betriebsmindestgröße |
| 87 | `oepul.participating_measures` | 1 / 1 | Maßnahmenkombinationen |
| 88 | `oepul.area_changes` | 5 / 5 | Flächenbewegungen |
| 89 | `oepul.o6_1b` | 38 / 38 | BIO-Maßnahmenvertrag |

Canonical Farm Profile, Originalquellen, historische Run-Artefakte und App bleiben unverändert. Es wurden keine Modellaufrufe gestartet, keine privaten Referenzfälle gelesen und keine Sollwerte aus Modell-Selbsttests übernommen. Die Befunde werden im gemeinsamen Issue und PR gesammelt; dieser Auditteil startet keine Reparatur oder Promotion.

Einheiten-Erratum vom 16.10.2026 (eigene Protokollbeschriftung): land.parcels[].oepul_area_payment_eur_per_ha: EUR/ha; land.parcels[].operations.pheromone_traps.traps_per_ha: traps/ha. Eingaben, Queries, Quellenbelege, Sollwerte und sämtliche nativen Ausgaben/Status/Checks bleiben exakt gleich. Alle Fälle wurden vollständig neu ausgeführt und exakt wiederholt. Alte und neue Hashbindungen stehen im [gemeinsamen Erratum](../../unit-label-erratum-20261016.json). Die Ergänzung ist Roots eigene Gegenkontrolle; sie behauptet keine neue Experten- oder unabhängige Personenabnahme.
