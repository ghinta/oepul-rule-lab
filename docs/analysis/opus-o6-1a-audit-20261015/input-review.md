# o6_1a – Eingabevertrag und App-Abbildung

Geprüft wurde ausschließlich `v2-o6_1a-opus-5.5-high-20260929` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Die Ergebnisse sind ein öffentliches Entwicklungs-Audit. Sie sind keine Domainfreigabe, kein Gold-Test und keine Genauigkeitsmessung.

Der vollständige maschinenlesbare Nachweis steht in [input-review.json](input-review.json): alle 67 Profilvorschläge mit 191 effektiven Blattpfaden, deren Typen, Einheiten, Zeitbezug, Geltungsbedingungen, Quellenbelegen, Original-Lesestellen und Defaultverhalten. 190 Pfade werden hinzugefügt, ein bestehender Pfad wird semantisch ersetzt. 189 vorgeschlagene Blätter werden produktiv gelesen, zwei werden nicht gelesen. Zusätzlich liest der Run zehn bereits vorhandene Canonical-Blattpfade.

Ich habe das originale UBB-Informationsblatt April 2026 vollständig gelesen: 46 Seiten einschließlich Beispielen, Tabellen, Fußnoten und Aktualisierungsliste. Die 13 produktiven Rego-Module wurden für diesen Eingabevertrag vollständig durchgesehen. Von 201 verschiedenen Quellenbelegen zu den Vorschlägen sind 189 PDF-Belege auf der genannten Originalseite bei reiner Leerraumnormalisierung auffindbar. Die übrigen zwölf betreffen HTML-Hinweise; sie sind in diesem Teil nicht separat auf Wortlaut geprüft. Wortlauttreffer bestätigen keine fachliche Folgerung; die vollständige Prüfung der übrigen Quellen ist im begleitenden Quellen-Audit getrennt dokumentiert.

## Entscheidung für die App

Der bestehende App-Adapter ist für den nativen Opus-Vertrag nicht ausreichend. Alle 67 vorgeschlagenen Pfade fehlen in seiner tatsächlichen OPA-Projektion. Auch wenn man sie in einen Canonical-Payload hineinschreibt, entfernt `adapt_payload_for_measures` sie. Ein gesonderter, geprüfter Opus-Adapter und eine Validierung der erforderlichen Nachweise sind nötig, bevor dieser Run für Betriebsergebnisse verwendet werden kann.

Der reine Adapter wurde mit öffentlichen synthetischen Daten ausgeführt; jeglicher Datenbankzugriff war dabei durch einen sofort fehlschlagenden `CursorWrapper.execute` gesperrt. Das vollständige Vorher/Nachher-Ergebnis und die SHA-256-Werte der drei App-Quelldateien stehen unter `app_adapter_probe` in der JSON-Datei. Geprüfter App-Quellstand: `529eadb34c4fdd249fbf739a372d63185b7374a2` (PR #157, anschließend in main enthalten).

| Vorhandene App-Daten | Nativer Opus-Bedarf | Folgerung |
|---|---|---|
| Betriebs-Acker-/Grünlandaggregate und aggregierte DIV-Fläche | einzelne Schläge mit land_use, exakter Schlagnutzungsart, Code-Liste, Fläche und Feldstückzuordnung | Aggregate reichen nicht für gemähtes Grünland ohne Bergmähder, Codes oder Feldstückpflichten. |
| parcel_id aus echten AMA-Schlag-/Feldstückbezügen | field_piece_id als gemeinsame Gruppe mehrerer Schläge und LSE | Der zusammengesetzte parcel_id identifiziert einen Schlag. Er ist kein nachgewiesener Ersatz für den Feldstückschlüssel. Feldstückname ist nur Anzeige. |
| raw_label oder crop_name | crop.schlagnutzungsart und kontrollierte Kultur-/Artenschlüssel | Der Adapter projiziert crop.* nicht; bloße Namensähnlichkeit schafft keinen freigegebenen Alias. |
| operations.psm_used, cutting_dates, N kg/ha | datierte PSM-, Nutzungs-, Dünge- und Befahrungsereignisse mit zusätzlichen Eigenschaften | Kein verlustfreier Rückschluss auf Daten, Stoffzulässigkeit, Abtransport, Düngertyp oder Ruhezeitabschluss. |
| species/animal_count/gve je grober Tiergruppe | präzise rgve_category, jahres-/zeitanteiliger average_count, Inlandhaltung | Die App wählt teils zuerst Stichtagszahl und rundet; allgemeine GVE sind nicht unmittelbar die verlangten RGVE. |
| oepul.shared bzw. AMA-Maßnahmenangaben | farm.oepul.measures mit nativen Tokens 1A/1B/… und historische Teilnahme-/Antragsdaten | Pfad und Tokenvertrag unterscheiden sich; kein automatisches Umhängen. |

## Reproduzierte Fehlend-/Null- und Bedeutungsfälle

Die 42 unten gebundenen Eingabevertragsproben sind ein eigener Diagnose-Satz innerhalb der JSON-Datei. Sie ergänzen die Fälle in `development-probes.json`; die Zahlen dürfen wegen inhaltlicher Überschneidung nicht als Zahl unabhängiger fachlicher Tests addiert werden. Es wurden keine erwarteten Antworten aus den Modell-Selbsttests übernommen.

| Probe | Unverändertes natives Ergebnis | Bedeutung |
|---|---|---|
| I01; I02/I03 | Nur year=2026 und measures=[1A] → access_conditions_met=true. Fehlender/null Vertragsbeginn und fehlendes/null Antragsdatum ändern dies nicht. false oder 0 als Start erzeugen dagegen einen Verstoß. | Ein fehlender Nachweis ist keine positive Freigabe. Die aktuelle boolesche Zugangsflagge ist für die App unbrauchbar, wenn sie als bestätigte Teilnahme gelesen wird. |
| I11 | Start 2025 plus fristgerechtes Datum ergibt access=true auch bei Auswertungsjahr 2022 und 2029. | Der berechnete contract_active-Helfer wird nicht als Zugangsgate verwendet. |
| I04 | legal_person ohne public_body_share und mit null besteht den Zugang; 0.30 scheitert, 0.25 besteht. | Fehlend wird zu 0. null passiert den Zahlenvergleich durch Rego-Wertordnung; Speichermaß ist Bruchteil 0..1, nicht Prozent 0..100. |
| I05 | Gleiches 10-ha-Land mit einem 6-ha-Feldstück aus zwei 3-ha-Schlägen: ohne field_piece_id kein UBB-DIVA-FS-001, mit gemeinsamer Kennung Verstoß. Native Prämie jeweils 1109,20 EUR. | Fallback Feldstück=Schlag verschiebt die fachliche Gruppierung und verbirgt die 0,15-ha-Pflicht. |
| I06 | Präzise RGVE-Kategorie plus 1 ha Futterfläche: fehlender average_count fällt auf animal_count zurück; 0 ergibt nicht-tierhaltend und 27 EUR; null bricht in livestock.rego:16 mit Multiplikationsfehler ab. | Der Vorschlag erlaubt ausdrücklich number|null. Vorhandenes null ist kein fehlender Schlüssel und keine Nullmenge. |
| I07 | Fehlende PSM-Liste, canonical psm_used=true und PSM-Ereignis ohne Datum erzeugen keinen UBB-DIVA-BM-002. Ein datiertes Ereignis mit organic_approved_only=false erzeugt den Verstoß; true erzeugt ihn nicht. Native Prämie bleibt in allen Varianten 81,15 EUR. | Positivnachweis gilt nur für ein bereits sichtbares, datiertes Ereignis. Fehlende Datierung kann selbst bekannten unzulässigen Einsatz ausblenden. |
| I08 | Fehlender harvested_share_percent wird als 100 behandelt. null, 0 und 80 erzeugen bei unverändertem Schlag den Ernteverstoß; 100 nicht. | Fehlend wird zu einer günstigen Tatsachenbehauptung. |
| I09 | DIVRS-Standort mit Grünlandzahl 30: fehlende Hangneigung verweigert site_ok; explizit null ergibt site_ok=true, ebenso 0 und 17.9; 18 verweigert. | Der bestehende Canonical-Typ erlaubt number|null; null < 18 benutzt Rego-Typordnung und erfüllt die Bedingung ohne tatsächliche Neigungszahl. |
| I10 | Wintergerste 3 ha + Sommergerste 3 ha + Wechselwiese 4 ha erzeugt ohne normalisierte Art keinen 55-%-Verstoß; mit botanical_species=Gerste entsteht er. Bei 8 ha Weizen verschwindet der 75-%-Getreideverstoß, wenn botanical_species statt Weizen den botanisch korrekten lateinischen Namen Triticum aestivum enthält. | Quelle S.5 zählt Winter-/Sommerform als eine botanische Art. Die Eingabe braucht einen kontrollierten Normalisierungsvertrag; freie botanical_species-Strings reichen nicht. |

Die Laufzeitergebnisse oben sind technische Beobachtungen. Ein positiver Premiumwert trotz anderer Verstöße belegt, dass der rohe Wert keine zugesicherte Auszahlung ist. Dieses Audit berechnet keine hypothetischen Sanktionen und repariert die historische Policy nicht.

## Alle 67 Vorschläge

Die folgende Liste belegt die Vollständigkeit der Bearbeitung. Details pro Blatt, einschließlich der genauen Rego-Zeilen und Quellenzitate, stehen im JSON-Ledger. Für sämtliche Zeilen lautet der derzeitige App-Status: **kein freigegebener nativer Adapter, vorgeschlagener Pfad fehlt in OPA-Projektion**.

| # | Vorgeschlagener Pfad | Blätter gelesen / gesamt | Erforderlicher fachlicher Kontext |
|---:|---|---:|---|
| 1 | `farm.oepul.measures` | 1 / 1 | all UBB access, combinations and supplements |
| 2 | `farm.oepul.bio_teilbetrieb_wein_obst_hopfen` | 1 / 1 | only joint 1A+1B participation |
| 3 | `farm.oepul.applicant_type` | 1 / 1 | applicant eligibility |
| 4 | `farm.oepul.public_body_share` | 1 / 1 | legal_person or association applicant |
| 5 | `farm.oepul.first_oepul_year` | 1 / 1 | minimum farm size only in first ÖPUL year |
| 6 | `farm.oepul.protected_cultivation_area_ha` | 1 / 1 | minimum farm size exemption |
| 7 | `farm.oepul.land_top_up_steilflaechen_granted` | 1 / 1 | optional provincial steep-slope top-up |
| 8 | `farm.oepul.ubb.contract_start_year` | 1 / 1 | contract periods and application deadline |
| 9 | `farm.oepul.ubb.measure_application_date` | 1 / 1 | initial UBB application |
| 10 | `farm.oepul.ubb.conversion_to_bio_date` | 1 / 1 | UBB to organic conversion without repayment helper |
| 11 | `farm.oepul.ubb.exit_before_contract_end` | 1 / 1 | early exit repayment helper |
| 12 | `farm.oepul.ubb.exit_reason` | 1 / 1 | only early exit |
| 13 | `farm.oepul.ubb.payment_application_submitted` | 1 / 1 | yearly payment application |
| 14 | `farm.oepul.ubb.payment_application_overdue_more_than_one_year` | 1 / 1 | only submitted=false |
| 15 | `farm.oepul.ubb.full_reductions_in_contract_period` | 1 / 1 | repeated full sanction reductions |
| 16 | `farm.oepul.ubb.arable_div_invasive_share_percent` | 1 / 1 | invasive-plant arable DIV care exception |
| 17 | `farm.oepul.ubb.takeover` | 5 / 5 | only measure takeover event present |
| 18 | `farm.oepul.ubb.training` | 8 / 8 | mandatory biodiversity training by 2025-12-31 |
| 19 | `farm.oepul.ubb.grassland_conservation` | 4 / 4 | grassland preservation over full contract |
| 20 | `farm.oepul.ubb.area_history` | 6 / 6 | area departure, entry limits |
| 21 | `farm.oepul.ubb.point_landscape_elements` | 18 / 18 | optional landscape-element/fruit-tree premium |
| 22 | `farm.oepul.ubb.monitoring` | 6 / 6 | optional monitoring programs |
| 23 | `land.parcels[].field_piece_id` | 1 / 1 | field-piece duties and landscape-element caps |
| 24 | `land.parcels[].area_kind` | 1 / 1 | area bases and special-element credit |
| 25 | `land.parcels[].codes` | 1 / 1 | all parcel DIV, exclusion and optional categories |
| 26 | `land.parcels[].project_conditions` | 1 / 1 | credit from NAT/N2 and monitoring combinations |
| 27 | `land.parcels[].in_austria` | 1 / 1 | location, farm minimum, premium/modulation |
| 28 | `land.parcels[].national_park` | 1 / 1 | parcel premium exclusion |
| 29 | `land.parcels[].national_park_relevant_restrictions` | 1 / 1 | park not already in blanket exclusion list |
| 30 | `land.parcels[].district` | 1 / 1 | 2026 drought harvest exception |
| 31 | `land.parcels[].total_area_payments_eur_per_ha` | 1 / 1 | perparcel total payment ceiling |
| 32 | `land.parcels[].soil_index` | 2 / 2 | DIV soil-index supplements and regional grass seed |
| 33 | `land.parcels[].crop.schlagnutzungsart` | 1 / 1 | mown grassland scope, crop/variety/option checks |
| 34 | `land.parcels[].crop.botanical_species` | 1 / 1 | arable diversification |
| 35 | `land.parcels[].crop.cereal_share_percent` | 1 / 1 | mixtures cereal share |
| 36 | `land.parcels[].crop.variety` | 1 / 1 | SLK rare-variety lookup |
| 37 | `land.parcels[].crop.pure_variety` | 1 / 1 | SLK purity evidence |
| 38 | `land.parcels[].crop.is_mixture` | 1 / 1 | SLK subordinate undersowing exception |
| 39 | `land.parcels[].crop.undersown_subordinate_not_harvested` | 1 / 1 | SLK underseed exception |
| 40 | `land.parcels[].crop.striped_poppy_varieties_unmixed` | 1 / 1 | traditional SLK Edel-Rot/Edel-Weiß stripes |
| 41 | `land.parcels[].crop.seed_documentation` | 1 / 1 | SLK record proof |
| 42 | `land.parcels[].crop.is_perennial` | 1 / 1 | SLK first-use-year limitation |
| 43 | `land.parcels[].crop.first_use_year` | 1 / 1 | only perennial SLK crop |
| 44 | `land.parcels[].crop.second_crop_name` | 1 / 1 | favourable arable crop second crop |
| 45 | `land.parcels[].crop.fwk_main_component` | 1 / 1 | favourable main/mixture component |
| 46 | `land.parcels[].crop.autochthonous_seed_production` | 1 / 1 | autochthonous wild plant seed-production option |
| 47 | `land.parcels[].crop.seed_harvest_this_year` | 1 / 1 | only autochthonous seed production |
| 48 | `land.parcels[].crop.sugar_beet_previous_year` | 1 / 1 | pheromone option on successor crop |
| 49 | `land.parcels[].crop.erosion_prone_crop` | 1 / 1 | erosion base-premium exclusion |
| 50 | `land.parcels[].operations.use_events` | 4 / 4 | annual use/care/minimum management rules |
| 51 | `land.parcels[].operations.fertilization_events` | 2 / 2 | DIV/WB fertilizer bans and exceptions |
| 52 | `land.parcels[].operations.psm_applications` | 2 / 2 | DIV and WB pesticide checks |
| 53 | `land.parcels[].operations.driving_events` | 2 / 2 | biodiversity and WB driving bans |
| 54 | `land.parcels[].operations.erosion_protection_method` | 1 / 1 | erosion-protection route with measures 8 + optional 6/7 |
| 55 | `land.parcels[].operations.mown_at_least_once` | 1 / 1 | optional steep-slope premium |
| 56 | `land.parcels[].operations.bergmaehder_mown_previous_year` | 1 / 1 | minimum Bergmähder management |
| 57 | `land.parcels[].biodiversity` | 43 / 43 | biodiversity establishment/care/variant/history/exception checks |
| 58 | `land.parcels[].hedge` | 12 / 12 | hedge premium and optional DIV credit |
| 59 | `land.parcels[].wildkraut` | 5 / 5 | WB option |
| 60 | `land.parcels[].pheromone_traps` | 14 / 14 | PZR option |
| 61 | `land.parcels[].harvest` | 4 / 4 | minimum harvest and 2026 drought exception |
| 62 | `land.parcels[].transfer` | 2 / 2 | within-year transfer without continuation |
| 63 | `land.parcels[].compliance` | 2 / 3 | nonfulfilment/OP/self-declaration |
| 64 | `livestock.species_groups[].rgve_category` | 1 / 1 | livestock RGVE conversion |
| 65 | `livestock.species_groups[].average_count` | 1 / 1 | annual RGVE inventory |
| 66 | `livestock.species_groups[].kept_in_austria` | 1 / 1 | eligible domestic RGVE |
| 67 | `land.parcels[].constraints.biodiversity_area.type` | 0 / 1 | proposed canonical type replacement only |

Die zwei nicht gelesenen Blätter sind `land.parcels[].compliance.third_party_fault` und `land.parcels[].constraints.biodiversity_area.type`. Letzteres ist besonders relevant: Vorschlag 67 heißt `add`, ersetzt aber die bereits existierende Dauerklassifikation `annual|multi_year|null` durch Maßnahmencodes `DIV|DIVRS|DIVSZ|DIVNFZ|DIVAGF|null`. Die Ausführung benutzt weiterhin `codes[]`. Eine Canonical-Migration auf dieser Grundlage ist weder nötig noch freigegeben.

Weitere Bedeutungsgrenzen sind im Ledger explizit erhalten: periodengerechte Bestandszahlen und historische Flächen, Datierungs- und Completeness-Vertrag bei unterjährigen Prüfungen, tatsächliche Ernte der vorjährigen Zuckerrübe, amtliche Bestätigungen sowie der Konflikt „Pheromonfallen bis 30. September“ gegenüber „Ende der Vegetationsperiode“. Ein zusammenfassendes Boolean wie `div_conditions_compliant` ersetzt die dokumentierte zugrunde liegende fachliche Prüfung nicht.

## Grenzen und nächster Integrationsschritt

Die historische Canonical-Datei, Quellen und Run-Artefakte wurden nicht verändert. Kein Profilvorschlag und kein Alias wurde allein wegen gleichen Namens akzeptiert. Keine privaten Studienreferenzen wurden gelesen und kein neues Modell ausgeführt.

Vor einem produktiven Adapter sind die Nachweisregeln je Funktionsbereich festzulegen: Pflichtfelder positiv belegen; null/fehlend/false/0 typgerecht trennen; stabile Feldstück-/Schlag-/Tierkategorien und amtliche Codes binden; nur belegbar abbildbare Fakten übernehmen; Lücken als solche anzeigen. Die bereits vereinbarte positive Nachweiskonvention darf dabei nicht rückwirkend als ursprüngliches Verhalten dieses historischen Runs ausgegeben werden.
