# Tabellenprüfung des einzelnen Opus-Runs o6_1a

Stand 15.10.2026. Gebunden an `v2-o6_1a-opus-5.5-high-20260929` im unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Diese Prüfung betrifft ausschließlich UBB. Sie ist eine öffentliche Entwicklungsprüfung und keine fachliche Freigabe oder Goldreferenz.

Alle acht Daten-Dateien und sämtliche **53 Datentabellen** wurden inhaltlich gelesen und gegen die unten genannten Originalstellen geprüft. Das Ergebnis unterscheidet absichtlich zwischen korrekt abgelegten Quelldaten und ihrer tatsächlichen Auswertung. Die 30 Prämienkomponenten mit insgesamt 60 Jahresstaffeln, 85 Sortenzeilen, 74 Acker- und 68 Grünland-Artenzeilen, 23 RGVE/GVE-Zeilen sowie alle 41 Dürre-Gebietseinträge wurden vollständig verglichen. Dabei wurde keine ausgelassene Prämienstaffel oder ausgelassene UBB-Sortentabellenzeile festgestellt. Das genügt noch nicht zur Übernahme des Runs.

Die Einzelbindungen, Datei-Hashes, Tabellen-Hashes, unveränderten Wertebereiche, genaue Verbraucherdateien/Zeilen sowie Quellenzitate stehen in [tables-review.json](tables-review.json). Zitate geben Originalschreibweisen wieder; typografische Abstände/Zeilenumbrüche können zwischen PDF-Extraktoren variieren.

## Gelesene Originalquellen

Das UBB-Informationsblatt (46 Seiten) und die allgemeinen Teilnahmebedingungen (21 Seiten) wurden vollständig einschließlich Aktualisierungen gelesen. Der Anhang wurde im Tabellen-Team auf allen **103 Seiten** zur Relevanz gelesen: Hauptprüfer Seiten 1–44 und 103, ergänzender Quellenleser Seiten 45–102. Zusätzlich wurden die Karten auf Seiten 11/38/39 und die vollständige Kombinationstabelle auf Seite 103 aus dem PDF gerendert und visuell betrachtet. Die A/B/C/L-Tabellen sowie auf UBB verweisende NAT-/EBW-Bestimmungen wurden fachlich gegen diesen Run verglichen. Die vollständige Lektüre fremder Gebiets-/Rassen-/Prämienzeilen bedeutet keine fachliche Prüfung anderer Maßnahmen-Policies.

Alle vier bereitgestellten HTML-Hauptartikel wurden gelesen. Für diese Tabellenprüfung wurden aus der Sonderrichtlinie zusätzlich Seiten 17–18 unmittelbar überprüft (Obergrenzen, Modulation, Landes-Top-up); der vollständige Sonderrichtlinien-Lesedurchgang liegt im begleitenden Quellen-Audit.

## Belegte Probleme in den Tabellenverbrauchern

1. **Artenlisten werden nicht ausgewertet (TABLE-F01).** Keine Rego-Regel referenziert die gespeicherten 142 Artenzeilen oder die Tabelle der Saatgutmischungsanforderungen. Die DIVRS-Prüfungen akzeptieren lediglich übergebene Zähler `regional_list_species` und `regional_list_families`. Eine übergebene Artenliste wird damit nicht auf Listenzugehörigkeit, eindeutige Taxa und Familien geprüft. Diese Zähler müssten ausdrücklich als extern verifizierte Nachweise deklariert werden; die App darf daraus keinen ausgeführten Artencheck ableiten. Quelle: UBB Seiten 13/19, Mindestanlage gemäß Artenliste Kapitel 14.
2. **Sorte ist nicht an die Kultur gebunden (TABLE-F02).** `arable_supplements.variety_row` sucht nur nach Sortenname und Jahr. Die Kultur aus derselben Tabellenzeile wird nicht mit dem Schlag verglichen. So kann eine Mais-Sorte auch auf einem als Weizen deklarierten Schlag einen SLK-B-Satz erzeugen. Quelle: UBB Seite 24 und vollständige Kultur/Sorte/Prämienstufe-Tabelle Seiten 36–37.
3. **Offene Sortengruppen werden als feste Namen behandelt (TABLE-F03).** Sieben Einträge lauten ausdrücklich „alle Herkünfte und Sorten“. Der exakte Stringvergleich erkennt keine konkreten Sortennamen innerhalb dieser offenen Gruppen; nur der ausgeschriebene Tabellen-Überschriftentext trifft. Das betrifft unter anderem Einkorn, Emmer, Nackthafer und Stoppelrübe. Quelle: UBB Seiten 36–37, Anhang B Seite 4.
4. **Singular/Plural verändert den Erosionsausschluss (TABLE-F04).** `Ackerbohne`/`Sonnenblume` sind in der Zuschlagstabelle als Singular hinterlegt, `Ackerbohnen`/`Sonnenblumen` im Erosionsausschluss als Plural. Beide Verbraucher vergleichen Namen exakt. Damit hängen Förderbetrag und Ausschluss von einer rein sprachlichen Variante derselben Kultur ab. Beide Varianten sind auf UBB Seite 33 belegt; erforderlich ist ein gemeinsamer überprüfter Kulturbezeichner.
5. **Umgekehrte Monitoringpflicht fehlt (TABLE-F05).** Die vier Monitoringprogramme sind korrekt abgelegt. Die Auswertung prüft jedoch nur ausdrücklich übergebene Monitoring-Einträge. Anhang I Seite 68 verlangt bei GL06/GL15/GL25 den UBB/BIO-Zuschlag „Schnittzeit nach Phänologie“, Seite 75 bei TA01 „Beobachtung der Großtrappe“. Bei fehlendem Monitoring-Eintrag fehlt die entsprechende positive Kombinationsprüfung. Die unabhängige Ausführung gehört zum separaten Probe-Protokoll.

## Quellenabweichungen und externe Entscheidungen

- **Artenidentität:** Das UBB-Blatt enthält 74 Ackerzeilen, Anhang C 73. UBB Seite 39 führt „Rauer Löwenzahn — Leontodon hispidus subsp. hispidus (s. lat.)“ zusätzlich zum Wiesen-Leuenzahn mit überlappender wissenschaftlicher Bezeichnung auf. Eine zusätzliche Tabellenzeile ist damit noch keine zweifelsfrei zusätzliche biologische Art. UBB Seite 44 schreibt `Plantago lanceolate`, Anhang C Seite 8 `Plantago lanceolata`. Der historische Datensatz kopiert die UBB-Schreibweise; diese Abweichung ist kein Beweis für eine Modellhalluzination und wurde nicht still geändert.
- **EBW-Anrechnung:** UBB Seite 15 verweist für zulässige Lebensraum/Nutzungs-Kombinationen auf ein separates EBW-Informationsblatt. Anhang K Seiten 91–102 enthält diese UBB-Anrechnungsmatrix nicht. Der native boolesche Wert `ebw_habitat_type_eligible` ist daher eine externe Vorentscheidung; der Run belegt keinen selbst ausgeführten vollständigen EBW-Listencheck.
- **Beispiele sind keine geschlossenen Listen:** Insektenblütige Pflanzen werden ausdrücklich „beispielsweise“, mechanische Geräte „wie“ genannt. Diese Tabellen sind als Beispiele richtig angelegt. Dagegen sind BHG-Kulturen und die UBB-anrechenbaren NAT-/Natura-Kürzel ausdrücklich geschlossen.
- **Metadaten sind keine Eingabewerte:** `Corn-Cob-Mix` ist eine abgeleitete Mais-Bezeichnung; `registered_partnership` benötigt eine eindeutige Bedeutung als im Firmenbuch eingetragene Personengesellschaft. Zwei BHG-Gruppeneinträge sind beschreibende Querverweise statt Pflanzennamen. Solche Beschriftungen dürfen ohne überprüfte Abbildung nicht als biologische Identifikatoren in die App übernommen werden.

## Vollständige Tabellenübersicht

`verwendet` bedeutet, dass mindestens eine historische Rego-Datei den Datentabellenschlüssel referenziert. Es bedeutet weder, dass jede Zeile tatsächlich erreichbar ist, noch dass alle Eingaben fachlich geprüft sind.

| Datei | Tabelle ohne Präfix `o6_1a_` | Einträge oberster Ebene | Rego verwendet |
|---|---|---:|---|
| codes_and_land_use.json | `mfa_codes` | 23 | nein |
| codes_and_land_use.json | `arable_div_schlagnutzungsarten` | 3 | ja |
| codes_and_land_use.json | `grassland_div_schlagnutzungsarten` | 4 | ja |
| codes_and_land_use.json | `mown_grassland_schlagnutzungsarten` | 4 | ja |
| codes_and_land_use.json | `steep_slope_schlagnutzungsarten` | 4 | ja |
| codes_and_land_use.json | `pzr_schlagnutzungsarten` | 2 | ja |
| codes_and_land_use.json | `bhg_generic_schlagnutzungsarten` | 3 | ja |
| codes_and_land_use.json | `div_credit_other_measure_codes_arable` | 4 | ja |
| codes_and_land_use.json | `div_credit_other_measure_codes_grassland` | 3 | ja |
| codes_and_land_use.json | `no_premium_codes` | 3 | ja |
| codes_and_land_use.json | `naturschutz_grassland_cut_date_conditions` | 32 | ja |
| codes_and_land_use.json | `natura2000_grassland_cut_date_conditions` | 6 | ja |
| codes_and_land_use.json | `naturschutz_arable_set_aside_conditions` | 1 | ja |
| codes_and_land_use.json | `monitoring_programs` | 4 | ja |
| codes_and_land_use.json | `contract_periods` | 3 | ja |
| codes_and_land_use.json | `measure_conversions` | 1 | nein |
| crop_lists.json | `cereals` | 11 | ja |
| crop_lists.json | `not_cereals` | 8 | nein |
| crop_lists.json | `maize` | 5 | ja |
| crop_lists.json | `arable_forage` | 7 | ja |
| crop_lists.json | `diversification_exempt_from_2025` | 2 | ja |
| crop_lists.json | `bhg_crops` | 53 | ja |
| crop_lists.json | `foerderwuerdige_kulturen` | 5 | ja |
| crop_lists.json | `streuobst_species` | 15 | ja |
| crop_lists.json | `insect_pollinated_examples` | 33 | nein |
| crop_lists.json | `erosion_prone_crops` | 8 | ja |
| crop_lists.json | `azr_permitted_follow_crops_2023` | 3 | nein |
| crop_lists.json | `invasive_species_early_cut` | 4 | nein |
| crop_lists.json | `mechanical_removal_tools` | 5 | nein |
| general_conditions.json | `combination_1a` | 20 | ja |
| general_conditions.json | `lse_only_parcel_codes` | 4 | ja |
| general_conditions.json | `modulation_brackets` | 4 | ja |
| general_conditions.json | `payment_caps_eur_per_ha` | 4 | ja |
| general_conditions.json | `sanction_levels` | 9 | ja |
| general_conditions.json | `area_reduction_tolerance` | 3 | ja |
| general_conditions.json | `area_increase_limit` | 4 | ja |
| general_conditions.json | `minimum_farm_size` | 2 | ja |
| general_conditions.json | `takeover_deadlines` | 3 | ja |
| general_conditions.json | `national_parks_no_premium` | 2 | ja |
| general_conditions.json | `eligible_applicant_types` | 4 | nein |
| general_conditions.json | `applicant_limits` | 1 | ja |
| notices_2026.json | `drought_2026_harvest_exemption_districts` | 41 | ja |
| notices_2026.json | `drought_2026_parameters` | 7 | ja |
| notices_2026.json | `grassland_div_variant_changes_after_april_15` | 4 | ja |
| premium_rates.json | `premium_rates` | 30 | ja |
| premium_rates.json | `premium_limits` | 16 | ja |
| rare_varieties.json | `rare_crop_varieties` | 85 | ja |
| rare_varieties.json | `rare_crop_striped_exception_varieties` | 2 | ja |
| regional_seed_species.json | `regional_seed_species_arable` | 74 | nein |
| regional_seed_species.json | `regional_seed_species_grassland` | 68 | nein |
| regional_seed_species.json | `regional_seed_requirements` | 11 | nein |
| rgve_key.json | `rgve_key` | 23 | ja |
| rgve_key.json | `livestock_thresholds` | 2 | ja |

Bei Objekten bezeichnet die Eintragszahl die direkten Schlüssel, bei Arrays die Zeilen. Sie ist keine alternative historische Validator-Metrik (der Validator zählt einige verschachtelte Objekte anders). Keine exakten Dubletten innerhalb der 53 Container festgestellt. Semantische Überschneidungen und offene Gruppen sind separat dokumentiert.

Historische Daten, Regeln, Selbsttests und Quellen blieben unverändert. Aus dieser Tabellenprüfung allein folgt keine Freigabe zur Maßnahmenübernahme oder Zahlungsentscheidung.
