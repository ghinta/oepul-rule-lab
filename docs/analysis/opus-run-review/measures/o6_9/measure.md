# o6_9 – Ausbringung, Separation und Schweinefütterung: Quellenprüfung

Geprüft wurde ausschließlich der rohe historische Opus-Run `v2-o6_9-opus-5.5-high-20261003` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieser Teil enthält **35 historische Regelbewertungen, 56 dokumentierte Quellenabschnitte, sieben abgegrenzte Befunde und 97 neue öffentliche Quellen- und Grenzfälle**. Bei strikter Builtin-Prüfung sind **97 Aufrufe definiert**, **94 Erwartungen erfüllt und 3 abweichend**. Die drei Gegenfälle betreffen nominelle Verfahrenszuordnung, eine konsistente nichtlegume Brache und einen fehlenden NAPV-Baselinehinweis für sonstige Landwirtschaftsflächen.

Das neue Merkblatt wurde auf **allen neun Seiten vollständig gelesen**, einschließlich jeder Tabellenzelle, sämtlicher Beleg-/Gerätebedingungen, des veröffentlichten Vertragsbeispiels, Änderungen und Schlussdisclaimers. Die erstmals in dieser sequenziellen Prüfung vorliegende NAPV wurde auf **allen 42 Seiten vollständig gelesen**, einschließlich sämtlicher Anlagen 1–5, Nährstoff-/Ertragstabellen, Fußnoten und vollständiger KG-Liste. Alle acht tatsächlichen Policy-Module und sämtliche 21 nummerierten ursprünglichen Annahmen sowie Eingabe-/Default-Hinweise wurden vollständig gelesen.

Die sichtbare Originaltabelle auf Merkblatt Seite 5 wurde zusätzlich als Bild kontrolliert. **157 g ist eine verbundene Durchschnittszelle über alle drei Mastphasen.** Die ausführbare Durchschnitt-ODER-Phasenlogik ist richtig; die gegenteilige Beschreibung in A02 beruht auf der linearisierten Darstellung. Offen bleibt die tatsächliche Fassungsgrenze bei ungedeckten Jungsauen: SRL ab 50 kg, späteres Merkblatt ab 32 kg.

Die zehn Manifestquellen sind anhand SHA-256 und Bytezahl gebunden. Acht gemeinsame Quellen werden mit verifiziert identischen Hashes zur früheren vollständigen Teamlektüre wiederverwendet; die aktuellen SRL-Seiten 61–63, Anhang A Seite 3 und ATB Seite 10 wurden für diesen Teil erneut vollständig gelesen. General besitzt die aktuellen allgemeinen, rechtlichen und Hinweisklauseln. Die GSP-AV ist diesem Run tatsächlich geliefert; geänderte 2026-Fristregeln werden nicht rückwirkend als Oracle für 2024/2025 verwendet. Studienlabels, GM-Urteile, historische Selbsttests und manuelle Adaptationstest-Sollwerte wurden nicht benutzt.

## Bindung und Ausführung

Vollständige Bewertungen, Eingaben, Queries, vor Ausführung gesetzte Erwartungen, Beobachtungen und Originalbelege stehen in [measure.json](/workspace/scratch/opus-o6-1a-source-audit/docs/analysis/opus-run-review/measures/o6_9/measure.json). Eingefrorener SHA-256: `38766b92c57b78913d092cf7e6318edac5d14d9f5ff690bc406830aace49b9aa`. Der unabhängige abschließende Gesamtreplay und dessen Artefaktbindungen gehören zur getrennten Qualitätsprüfung.

Jede neue Probe lädt `/tmp/issue-51-review-opa` mit `--strict-builtin-errors` und die vollständigen ursprünglichen Verzeichnisse `workspace/policy` sowie `workspace/data`. Native Gesamtquery: **`data.oepul.o6_9.decision`**, statische Daten: **`data.o6_9.*`**. Dateien und Namespaces werden nicht abgeflacht oder korrigiert; Typen und Zahlen werden nicht normalisiert. Erwartungen prüfen explizite Komponenten, Booleans oder Anzahlen mit `equals`; String-/Zahlmengen werden nicht als Regelobjekte behandelt.

Die positiven Tatsachenverträge sind ausdrücklich eng: aktuelle tatsächliche Ereignisse, eigene passende Flächen, echte Herkunft-/Zusammensetzungs-/Rationsbelege und keine bloß geratenen unbekannten Ausnahmen. Teilweise Rationshelferinputs behaupten keine vollständige Herde oder betriebsweite Förderfreigabe. Fehlend/null, Schema-Stress und die SQL-Projektion gehören zu Inputs. Nominelle Komponenten, lokale Diagnose, NAPV-Baseline und behördliche Auszahlung bleiben getrennt.

Vor dem Einfrieren wurden drei wörtliche Merkblattbelege an 15 Stellen von der durch NFKC entstandenen Schreibweise `m3` auf das tatsächliche `m³` zurückgestellt. Der genaue Vorher-/Nachher-Nachweis steht unter `pre_freeze_quote_revision` in JSON. Eingaben, Queries, Erwartungen und beobachtete Antworten blieben unverändert. Der begrenzte Enum-Check umfasst alle 671 vorhandenen Enum-Werte der 97 Fälle gegen das unveränderte Canonical plus die tatsächlichen Run-Vorschläge: keine Abweichung. Er zertifiziert keine vollständige Schema- oder Tatsachenprüfung.

| Vollständig gelesenes Modul | Zeilen | SHA-256 |
| --- | ---: | --- |
| [application.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego) | 191 | `da9ac7e50a283eea0ed9a0acdc14de1cc3a7b0e28c5814ea41fda63d7ed641f8` |
| [common.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/common.rego) | 59 | `e5598f7e6b1dafffbb0b60ac41d4364a6328625c6d1f28cab9d13a8264ea4b05` |
| [decision.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/decision.rego) | 46 | `1c4cce90e0ee0a517feceb277571e9145d42d5ed5bdb6074e5c5272a1fb9c649` |
| [general.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego) | 320 | `5fedb0ecf9e02164dc0124f06fbb92731ddd2d8489217a97f2711b1e242ca275` |
| [participation.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/participation.rego) | 231 | `0bbcbef214d2d198b2dddffb722b31766ed198af26fb8fcadf10ed4085710040` |
| [pig_feeding.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego) | 151 | `561f49e8065ce16549a2d34c7fe2681c007c830b5f0e33d92dbe074b0a2ecce3` |
| [premium.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego) | 159 | `02cfb1292b4a9daa3121d02184ab4590b4799639aa10838010eec1c5c9480691` |
| [separation.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego) | 78 | `49805d26956cc07c27aefafb07c3a3731ba2ff0e84dc31e3af0916ddadd899a1` |

| Gebundene Quelle | Lektüre | SHA-256 |
| --- | --- | --- |
| [20241011_srl_oepul_2023.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023.pdf) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| [20241011_srl_oepul_2023_anhaenge.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| [gsp-av-fassung-vom-28012026.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/gsp-av-fassung-vom-28012026.pdf) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10` |
| [napv-fassung-vom-28-10-2024.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/napv-fassung-vom-28-10-2024.pdf) | Neu vollständig: 42 Seiten | `6bec588cc818a8e6620f9abda47c4de0489e4cc65bdd20466595722ac0e0fc92` |
| [2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| [2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| [2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| [2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| [o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf) | Neu vollständig: 9 Seiten | `c9319d5997e2803ba313c3cffd949b396903f5581be30c87bd21e159c2626349` |
| [o6_allgemeine_teilnahmebedingungen_2026_04.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) | Identischer Hash zur früheren vollständigen Teamlektüre; aktueller Abgleich nach Zuständigkeit | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

## Befunde

### O69-MEASURE-01: Ausgeschlossene Mengen werden über die bekannten Verfahren verteilt

Tatsächlich wurden 40 m³ förderfähige Gülle vollständig mit Schleppschlauch und 60 m³ vollständig ausgeschlossene Biogasgülle vollständig per Injektion ausgebracht. Die Gesamtmenge von 100 m³ entspricht genau der Grenze von 2 ha × 50 m³; es besteht keine offene Zuordnung bei einer Kappungsüberschreitung. Die förderfähige Gesamtmenge von 40 m³ stimmt. Die proportionale Verteilung über alle ursprünglichen Verfahren ergibt jedoch nominell 58,40 Euro statt 40 × 1,10 = 44,00 Euro. Der korrekt diagnostizierte Ausschluss der Biogasgülle bleibt getrennt. Der Fall behauptet keine tatsächlich rechtswidrige Behördenzahlung.

Einordnung: `source_nominal_component`; Familie `EVENT_SEMANTICS`. Historische IDs: `O69-MB-010`, `O69-MB-042`.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Biogasgülle enthalten ist (z. B. Biogasgülle mit Speiseölresten), scheidet die gesamte Biogasgülle von der Förderfähigkeit aus.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 8](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Die Prämie für die bodennahe Gülleausbringung wird für maximal 50 m³ flüssigen Wirtschaftsdünger und Biogasgülle pro ha düngungswürdiger Acker- und Grünlandfläche gewährt. Die Prämienbegrenzung berechnet sich nach der düngungswürdigen und nicht nach der gedüngten Fläche.

Proben: `o6_9-method-bound-invalid-biogas-amount`, `o6_9-method-bound-invalid-biogas-total-volume-correct`, `o6_9-two-known-valid-method-components`.

### O69-MEASURE-02: Der explizite Nichtleguminosenbefund umgeht auch die Brachekategorie

Ein bekannter Nichtleguminosenbestand auf einer Brache trägt die kanonische Kategorie fallow, den wörtlichen Quellenbegriff Stilllegungen/Grünbrachen als freien Kulturnamen und is_legume_pure_stand=false. Diese Angaben sind konsistent. Die NAPV setzt unabhängig davon 0 kg N-Bedarf fest. Nativ zählen trotzdem 2 ha statt 0 ha als düngungswürdig, weil die ausdrückliche Verneinung eines Leguminosenreinbestandes auf jede ausgeschlossene Kulturkategorie angewendet wird. Mit dem exakt gespeicherten Namen Grünbrache liefert eine Kontrolle bereits korrekt 0 ha. Im Fall wird ausschließlich Gülle separiert; es gibt keine Düngung der Brache und keine daraus abgeleitete rechtswidrige Ausbringungszahlung.

Einordnung: `source_area_component`; Familie `CROP_CLASSIFICATION`. Historische IDs: `O69-MB-044`.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 8](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Die düngungswürdige Fläche berechnet sich aus der Summe der Acker- und Grünlandflächen mit Stickstoffdüngebedarf gemäß der Nitrat-Aktionsprogramm- Verordnung. Leguminosenreinbestände (Sojabohnen, Erbsen, Ackerbohnen, Klee etc.) und Flächen mit gänzlichem Düngeverbot sind keine düngungswürdigen Flächen im Sinne dieser Maßnahme.

[napv-fassung-vom-28-10-2024.pdf S. 12](/workspace/scratch/opus-candidates-source/sources/oepul/legal/napv-fassung-vom-28-10-2024.pdf)

> Stilllegungen/ Grünbrachen 0

Proben: `o6_9-fallow-false-legume-override`, `o6_9-fallow-exact-snapshot-name-correct`.

### O69-MEASURE-03: Für sonstige Landwirtschaftsflächen fehlt der NAPV-Verbotszweig

NAPV § 2 Abs. 3 regelt sonstige Landwirtschaftsflächen unabhängig von der Förderkulisse für die bodennahe Ausbringung in Maßnahme 9. Für eine bekannte betriebseigene Apfelanlage am 15. Oktober erscheint die richtige lokale MB013-Diagnose zur nicht förderfähigen Nutzungsart. Die unabhängig erforderliche NAPV002-Warnung fehlt: Ist 0 statt Soll 1. Erwartet wird ausschließlich dieser Baselinehinweis. Die Obstanlage wird weder zu förderfähigem Ackerland umgedeutet noch mit einer erfundenen festen Sanktion belegt.

Einordnung: `source_only_baseline_warning`; Familie `SOURCE_COVERAGE`. Historische IDs: `O69-NAPV-002`.

[napv-fassung-vom-28-10-2024.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/legal/napv-fassung-vom-28-10-2024.pdf)

> Auf in den Abs. 1 und 2 nicht angeführten landwirtschaftlichen Nutzflächen ist das Ausbringen von leichtlöslichen stickstoffhältigen Düngemitteln vom 15. Oktober bis 15. Februar des Folgejahres verboten. Das Ausbringen von langsam löslichen stickstoffhältigen Düngemitteln ist vom 30. November bis 15. Februar des Folgejahres verboten.

Proben: `o6_9-napv-other-agricultural-land-unconsumed`, `o6_9-other-land-correct-measure-scope-diagnosis`.

### O69-MEASURE-04: Tatsächliche Jahresmengen und Dokumentation benötigen vorbereitete Zeitbezüge

Merkblatt Seite 6 betrifft tatsächlich im jeweiligen Kalenderjahr ausgebrachte beziehungsweise separierte Mengen. Feldvollständigkeit, Reihenfolge der Datensätze und Mengenobergrenzen haben Verbraucher. Die Module filtern die tatsächlichen Ereignisdaten jedoch nicht auf das Förderjahr und rekonstruieren keine Bewirtschaftungshoheit zum Ereigniszeitpunkt. Sie können damit keine vollständige tatsächliche Jahreshistorie belegen. Die neuen positiven Fälle geben aktuelle, tatsächliche Ereignisse ausdrücklich vor. Diese statisch belegte Vertragsgrenze wird ohne aus unbekannter Historie erfundene negative Ereignisse dokumentiert. Die ursprüngliche NAPV-Annahme A12 setzt außerdem pauschal den 16. Oktober an und bildet den möglicherweise früheren Beginn ab Ernte der letzten Hauptfrucht nicht ab.

Einordnung: `source_temporal_coverage`; Familie `TEMPORAL_SCOPE`. Historische IDs: `O69-MB-016`, `O69-MB-023`, `O69-MB-034`, `O69-MB-035`, `O69-NAPV-002`.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 6](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Die im jeweiligen Förderjahr (Kalenderjahr) am Betrieb bodennah ausgebrachte Menge an Gülle, Jauche oder Biogasgülle ist je nach Ausbringungsverfahren (Schleppschlauch, Schleppschuh, Injektion) in m³ in der Beilage „MFA-Angaben“ des Mehrfachantrages zu beantragen.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 6](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Die im jeweiligen Förderjahr (Kalenderjahr) am Betrieb separierte Güllemenge ist in m³ in der Beilage „MFA-Angaben“ des Mehrfachantrages zu beantragen.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Über die bodennah ausgebrachte Menge und Art des flüssigen Wirtschaftsdüngers einschließlich Biogasgülle sowie des Ausbringungszeitpunktes und des Ausbringungsverfahrens sind chronologische, schlagbezogene Aufzeichnungen zu führen.

[napv-fassung-vom-28-10-2024.pdf S. 2](/workspace/scratch/opus-candidates-source/sources/oepul/legal/napv-fassung-vom-28-10-2024.pdf)

> Das Ausbringen von leichtlöslichen stickstoffhältigen Düngemitteln ist ab der Ernte der letzten Hauptfrucht – jedenfalls aber nach dem 15. Oktober – verboten. Abweichend davon ist das Ausbringen dieser Düngemittel bis 31. Oktober zulässig, a) auf Raps, Gerste oder Zwischenfrüchten, sofern der Anbau bis 15. Oktober erfolgt ist, b) auf im Folgejahr zu erntende oder mehrjährige Gemüsekulturen, sofern der Anbau bis 31. August erfolgt ist, c) auf im Folgejahr zu erntende oder mehrjährige Blühkulturen, die zur Saatgutvermehrung oder Heil- und Gewürzpflanzennutzung verwendet werden, sofern der Anbau bis 31. August erfolgt ist, oder d) auf Erdbeeren, sofern der Anbau bis 31. August erfolgt ist. 2. Das Ausbrin gen von langsam löslichen, stickstoffhältigen Düngemitteln ist ab dem 30. November verboten. 3. Der Zeitraum, in dem stickstoffhältige Düngemitteln nicht ausgebracht werden dürfen, endet am 15. Februar des Folgejahres. Abweichend davon ist das Ausbringen von stickstoffhältigen Düngemitteln auf Kulturen mit frühem Stickstoffbedarf wie Durum -Weizen, Raps und Gerste sowie für Kulturen unter Vlies oder Folie ab dem 1. Februar des Folgejahres wieder zulässig.

Proben: `o6_9-actual-current-chronology`, `o6_9-same-events-reversed-list`.

### O69-MEASURE-05: Mehrere Quellenqualifikationen liegen nur als vorbereitete Befunde vor

Verfahrens-, Dünger- und Ausgangsstoffschlüssel, die Übereinstimmung globaler Mengen mit einzelnen Aufzeichnungen, die Herkunft tatsächlich separierter eigener Rindergülle, die vollständige tatsächliche Schweinegruppenliste und die bedingte Hierarchie der Proteinbelege werden nicht unabhängig hergeleitet. Die Quellen verlangen physische Verfahrensmerkmale, Hygiene-/Saatgut-/Öl-/Küchenbedingungen, sämtliche gehaltenen Schweine und zutreffende Analyse-/Literatur-/Herstellerbelege. Die positiven Fälle setzen diese Tatsachen ausdrücklich voraus. Ein vorgeprüfter Befund kann sie abbilden; ein bloßer Schlüssel belegt sie nicht. Widersprüchliche falsche Sammelbefunde sind kein gewöhnliches fachliches Gold. Inputs besitzt fehlende/null Angaben und App-Projektion; Core trennt nominelle Komponenten von der allgemeinen Zulässigkeit.

Einordnung: `prepared_evidence_boundary`; Familie `EVIDENCE_CONTRACT`. Historische IDs: `O69-MB-007`, `O69-MB-009`, `O69-MB-014`, `O69-MB-017`, `O69-MB-021`, `O69-MB-026`, `O69-MB-028`.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 5](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Für die Berechnung der Rohproteingehalte von den Rationen sind die Ergebnisse von Futtermitteluntersuchungen heranzuziehen. Für nicht untersuchte Futtermittel sind Standardwerte für Proteingehalte aus der Fachliteratur und bei Fertigfuttermischungen die Proteingehalte gemäß Angaben des Futtermittelherstellers zu verwenden.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 5](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Bei dieser Maßnahmenkategorie muss bei allen am Betrieb gehaltenen Schweinen eine Fütterung mit folgenden Rohproteingrenzen je Kilogramm der Ration in der Trockenmasse (bei 88 % TM) eingehalten werden:

Proben: `o6_9-ration-valid-prepared-basis-feed_analysis`, `o6_9-ration-valid-prepared-basis-standard_literature_value`, `o6_9-ration-valid-prepared-basis-manufacturer_declaration`.

### O69-MEASURE-06: Jungsauengewicht und spätere Biogaspräzisierungen bleiben versionsabhängig

Die gelieferte SRL Seite 62 ordnet ungedeckte Jungsauen der Mastgruppe ab 50 kg zu; das spätere gelieferte Merkblatt Seite 5 nennt sie ausdrücklich ab 32 kg. Die groben Eingabekategorien besitzen keine unabhängige Gewichts-/Belegungshistorie. Das Merkblatt 2026 ergänzt gegenüber der SRL 2024 außerdem Maisquellwasser und den Ausschluss von Speiseölresten. Diese tatsächlichen Unterschiede gelieferter Fassungen bleiben offen. Dagegen ist der Durchschnitt von 157 g im Originalbild eine über alle drei Mastphasen verbundene Tabellenzelle. Die ursprüngliche A02-Beschreibung der linearisierten Tabelle ist ungenau; die ausführbare Durchschnitt-ODER-Phasenlogik stimmt mit dem sichtbaren Merkblatt überein.

Einordnung: `supplied_source_version_boundary`; Familie `SOURCE_VERSION`. Historische IDs: `O69-SRL-001`, `O69-MB-009`, `O69-MB-027`.

[20241011_srl_oepul_2023.pdf S. 62](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023.pdf)

> a. Jung- und Mastschweinen ab 32 kg bis Mastende sowie Jungsauen nicht gedeckt ab 50 kg

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 5](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Ferkel zwischen 8 und 32 kg max. 166 g

Wörtliche Tierkategorie derselben Originaltabelle:

> Jung- und Mastschweine sowie Jungsauen nicht gedeckt ab 32 bis 60 kg

Proben: `o6_9-fattening-average157-either`, `o6_9-fattening-phases-even-average158`.

### O69-MEASURE-07: Die Zuordnung oberhalb der 50-m³-Grenze ist eine offene Annahme

Für sonst vollständig förderfähige Verfahrensmengen oberhalb der Grenze wählt A03 eine proportionale Zuordnung. Merkblatt Seite 8 und SRL Seite 63 nennen 50 m³ je ha, bestimmen aber keinen eindeutigen Vorrang eines Verfahrens. Hier wird kein verbindlicher anderer Überkappungsbetrag erfunden. Der konkrete Fehler bei eindeutig verfahrensgebundenem ausgeschlossenem Material entsteht bereits ohne Grenzüberschreitung und ist davon getrennt. Der ausdrückliche Förderausschluss von Leguminosenreinbeständen hat einen anderen Zweck als eine gegebenenfalls nach NAPV zulässige Ausnahme von 50/60 kg N; daraus folgt kein automatischer Rechtswiderspruch und kein neues Förderoracle.

Einordnung: `disclosed_interpretation_boundary`; Familie `INTERPRETATION_BOUNDARY`. Historische IDs: `O69-MB-042`, `O69-MB-044`.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 8](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Die Prämie für die bodennahe Gülleausbringung wird für maximal 50 m³ flüssigen Wirtschaftsdünger und Biogasgülle pro ha düngungswürdiger Acker- und Grünlandfläche gewährt. Die Prämienbegrenzung berechnet sich nach der düngungswürdigen und nicht nach der gedüngten Fläche.

[o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf S. 8](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf)

> Die düngungswürdige Fläche berechnet sich aus der Summe der Acker- und Grünlandflächen mit Stickstoffdüngebedarf gemäß der Nitrat-Aktionsprogramm- Verordnung. Leguminosenreinbestände (Sojabohnen, Erbsen, Ackerbohnen, Klee etc.) und Flächen mit gänzlichem Düngeverbot sind keine düngungswürdigen Flächen im Sinne dieser Maßnahme.

Proben: `o6_9-application-cap-100`, `o6_9-application-cap-101`, `o6_9-cap-uses-demand-not-spread-area`, `o6_9-fertilizable-pure-soy`.

## Korrekte Umsetzungen und Grenzen

Die drei Kategorien können einzeln benutzt werden. Die Schweinedichte bezieht sich auf die gesamte Ackerfläche ohne OP-Abzug; bekannte Jahresdurchschnittswerte und passende Anhang-A-Faktoren werden tatsächlich verbraucht. Quellenkonformes geringes/unvermeidliches oder kulturschützendes Wasser wird nicht pauschal ausgeschlossen. Schleppschlauch, Schleppschuh, Injektion sowie die ausdrücklich verbotenen Geräte haben ausführbare Verbraucher. Eine gesamte bekannte unzulässige Biogasmenge wird richtig ausgeschlossen; der Fehler betrifft ihre spätere Verfahrenszuordnung.

Die Separation bleibt von bodennaher Ausbringung unabhängig und darf einen Teil der eigenen Rindergülle betreffen. Bekannt betriebsfremde beziehungsweise Nicht-Rindergülle wird abgezogen; 20 m³ je bekanntem Jahres-Rinder-GVE bilden die Grenze. Die drei positiven Protein-Nachweisgrundlagen, alle vier Nichtmastgrenzen und der echte Durchschnitt-ODER-Phasenweg werden geprüft. Gewichtete Durchschnittsfälle verwenden konsistente tatsächliche Futtergewichte; aus Phasengrenzen wird kein ungewichteter arithmetischer Zwangsdurchschnitt abgeleitet.

Ausgewählte tatsächlich konsumierte Tarife ergeben 11/15/17 Euro für zehn m³ und 108 Euro für zwei Hektar der Schweineoption. Die Ausbringungsgrenze folgt der düngungswürdigen Fläche, nicht der tatsächlich gedüngten Fläche. Tables prüft alle neun Tarifzeilen, sämtliche GVE-/Rations-/Definitionseinträge und den gesamten Kombinationstabellen-Ausschnitt unabhängig.

Die bekannten saisonalen NAPV-Grenzen für Acker, Ackerfutter und Grünland sowie alle vier verbotenen Bodenzustände erzeugen Baselinewarnungen. Die Ausnahmen bis 31. Oktober beziehungsweise ab 1. Februar werden nur als positiv vorgeprüfte Tatsachen verwendet. Die vollständig gelesene NAPV enthält darüber hinaus unter anderem Verteilungs-/Einarbeitungs-/Hangbedingungen, Gewässerabstände, Lagerregeln, Mengen-/Nährstoffberechnungen und weitere Aufzeichnungen. Deren vollständige Ausführung wird hier ausdrücklich nicht behauptet; General und Tables dokumentieren die breitere Quellenabdeckung.

## Historische Regelabdeckung

Exakt 35 zugewiesene historische IDs: **14 umgesetzt, 19 teilweise, 2 offen**. Jede Bewertung hat die originale Katalogaussage, tatsächlich geprüfte Codebindungen und wortlautgebundene Quellen. Umgesetzt heißt jeweils: tatsächlicher Verbraucher innerhalb des offengelegten Tatsachenvertrags; es ist keine reale Beleg- oder Behördenfreigabe.

| Historische ID | Bewertung | Tatsächlicher Code |
| --- | --- | --- |
| `O69-MB-004` | partial | [participation.rego:44](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/participation.rego:44) |
| `O69-MB-005` | implemented | [pig_feeding.rego:12](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:12), [pig_feeding.rego:102](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:102) |
| `O69-MB-006` | partial | [separation.rego:14](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:14), [pig_feeding.rego:12](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:12) |
| `O69-MB-007` | partial | [application.rego:8](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:8), [application.rego:129](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:129) |
| `O69-MB-008` | partial | [application.rego:46](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:46), [application.rego:147](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:147), [premium.rego:43](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:43) |
| `O69-MB-009` | partial | [application.rego:10](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:10) |
| `O69-MB-010` | partial | [application.rego:25](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:25), [premium.rego:43](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:43) |
| `O69-MB-011` | implemented | [application.rego:46](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:46), [application.rego:143](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:143) |
| `O69-MB-013` | implemented | [application.rego:107](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:107), [application.rego:174](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:174) |
| `O69-MB-014` | partial | [application.rego:4](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:4), [application.rego:120](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:120) |
| `O69-MB-015` | implemented | [application.rego:6](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:6), [application.rego:125](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:125) |
| `O69-MB-016` | partial | [application.rego:51](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:51), [application.rego:151](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:151), [general.rego:278](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:278) |
| `O69-MB-017` | partial | [application.rego:72](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:72) |
| `O69-MB-018` | implemented | [application.rego:178](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:178) |
| `O69-MB-019` | implemented | [application.rego:183](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:183), [general.rego:286](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:286) |
| `O69-MB-020` | implemented | [application.rego:138](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:138) |
| `O69-MB-021` | partial | [separation.rego:8](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:8), [separation.rego:41](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:41) |
| `O69-MB-022` | implemented | [separation.rego:6](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:6), [separation.rego:46](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:46), [premium.rego:58](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:58) |
| `O69-MB-023` | partial | [separation.rego:50](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:50), [general.rego:282](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:282) |
| `O69-MB-024` | implemented | [separation.rego:69](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:69) |
| `O69-MB-025` | implemented | [separation.rego:74](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:74), [application.rego:189](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:189), [general.rego:286](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:286) |
| `O69-MB-026` | partial | [pig_feeding.rego:23](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:23), [pig_feeding.rego:68](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:68), [pig_feeding.rego:113](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:113) |
| `O69-MB-027` | implemented | [pig_feeding.rego:41](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:41) |
| `O69-MB-028` | partial | [pig_feeding.rego:75](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:75), [pig_feeding.rego:128](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:128) |
| `O69-MB-029` | implemented | [pig_feeding.rego:62](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:62), [pig_feeding.rego:133](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:133), [general.rego:318](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:318) |
| `O69-MB-034` | partial | [participation.rego:28](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/participation.rego:28), [application.rego:94](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/application.rego:94) |
| `O69-MB-035` | partial | [separation.rego:4](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:4), [separation.rego:50](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:50) |
| `O69-MB-041` | implemented | [premium.rego:4](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:4), [premium.rego:50](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:50) |
| `O69-MB-042` | unresolved | [premium.rego:19](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:19) |
| `O69-MB-043` | partial | [separation.rego:13](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/separation.rego:13), [premium.rego:58](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:58) |
| `O69-MB-044` | partial | [premium.rego:19](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:19) |
| `O69-MB-045` | partial | [pig_feeding.rego:95](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:95), [premium.rego:65](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/premium.rego:65) |
| `O69-SRL-001` | unresolved | [pig_feeding.rego:10](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:10), [pig_feeding.rego:41](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/pig_feeding.rego:41) |
| `O69-NAPV-002` | partial | [general.rego:140](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:140), [general.rego:249](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:249) |
| `O69-NAPV-003` | implemented | [general.rego:196](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:196), [general.rego:253](/workspace/scratch/opus-candidates-source/runs/v2-o6_9-opus-5.5-high-20261003/workspace/policy/o6_9/general.rego:253) |

## Neue Proben

| Fall | Erwartung | Beobachtung | Ergebnis |
| --- | --- | --- | --- |
| `o6_9-minimum-independent-application` | `true` | `true` | erfüllt |
| `o6_9-minimum-independent-separation` | `true` | `true` | erfüllt |
| `o6_9-minimum-independent-pig` | `true` | `true` | erfüllt |
| `o6_9-pig-density-exact1` | `1` | `1` | erfüllt |
| `o6_9-pig-density-all-arable-including-op` | `0` | `0` | erfüllt |
| `o6_9-pig-annual-average-precedes-current-count` | `2.8` | `2.8` | erfüllt |
| `o6_9-cattle-known-table-fallback` | `2` | `2` | erfüllt |
| `o6_9-declared-manure-slurry` | `0` | `0` | erfüllt |
| `o6_9-declared-manure-liquid_manure` | `0` | `0` | erfüllt |
| `o6_9-declared-manure-biogas_slurry` | `0` | `0` | erfüllt |
| `o6_9-declared-manure-solid_manure` | `1` | `1` | erfüllt |
| `o6_9-known-ineligible-volume-rainwater_volume_m3` | `8` | `8` | erfüllt |
| `o6_9-known-ineligible-volume-solid_manure_with_water_volume_m3` | `8` | `8` | erfüllt |
| `o6_9-permitted-water-not-in-ineligible-field` | `10` | `10` | erfüllt |
| `o6_9-biogas-entire-volume-invalid-false` | `0` | `0` | erfüllt |
| `o6_9-biogas-entire-volume-invalid-true` | `10` | `10` | erfüllt |
| `o6_9-method-bound-invalid-biogas-amount` | `44` | `58.4` | abweichend |
| `o6_9-method-bound-invalid-biogas-total-volume-correct` | `40` | `40` | erfüllt |
| `o6_9-two-known-valid-method-components` | `146` | `146` | erfüllt |
| `o6_9-actual-technique-trailing_hose` | `0` | `0` | erfüllt |
| `o6_9-actual-technique-trailing_shoe` | `0` | `0` | erfüllt |
| `o6_9-actual-technique-injection` | `0` | `0` | erfüllt |
| `o6_9-actual-technique-swivel_distributor` | `1` | `1` | erfüllt |
| `o6_9-excluded-device-swivel_distributor` | `1` | `1` | erfüllt |
| `o6_9-excluded-device-impact_plate_on_nozzle_boom` | `1` | `1` | erfüllt |
| `o6_9-actual-current-chronology` | `0` | `0` | erfüllt |
| `o6_9-same-events-reversed-list` | `1` | `1` | erfüllt |
| `o6_9-application-own-land-arable` | `0` | `0` | erfüllt |
| `o6_9-application-own-land-grassland` | `0` | `0` | erfüllt |
| `o6_9-application-own-land-special_crop` | `1` | `1` | erfüllt |
| `o6_9-application-known-external-proof-true` | `0` | `0` | erfüllt |
| `o6_9-application-known-external-proof-false` | `1` | `1` | erfüllt |
| `o6_9-separation-known-external-proof-true` | `0` | `0` | erfüllt |
| `o6_9-separation-known-external-proof-false` | `1` | `1` | erfüllt |
| `o6_9-application-shared-all_suitable` | `0` | `0` | erfüllt |
| `o6_9-application-shared-available_or_controllable` | `1` | `1` | erfüllt |
| `o6_9-application-shared-invoice_issued_to_participants` | `1` | `1` | erfüllt |
| `o6_9-separation-shared-all_suitable` | `0` | `0` | erfüllt |
| `o6_9-separation-shared-available_or_controllable` | `1` | `1` | erfüllt |
| `o6_9-separation-shared-invoice_issued_to_participants` | `1` | `1` | erfüllt |
| `o6_9-separation-volume-all-own` | `20` | `20` | erfüllt |
| `o6_9-separation-volume-external-cattle5` | `15` | `15` | erfüllt |
| `o6_9-separation-volume-noncattle5` | `15` | `15` | erfüllt |
| `o6_9-separation-volume-disjoint-mixed5plus5` | `10` | `10` | erfüllt |
| `o6_9-separation-cap-40` | `40` | `40` | erfüllt |
| `o6_9-separation-cap-41` | `40` | `40` | erfüllt |
| `o6_9-separation-no-low-emission-application-required` | `30` | `30` | erfüllt |
| `o6_9-separation-known-current-record` | `0` | `0` | erfüllt |
| `o6_9-ration-piglet_8_32kg-exact` | `0` | `0` | erfüllt |
| `o6_9-ration-piglet_8_32kg-above` | `1` | `1` | erfüllt |
| `o6_9-ration-sow_gestating_or_gilt_mated_from_50kg-exact` | `0` | `0` | erfüllt |
| `o6_9-ration-sow_gestating_or_gilt_mated_from_50kg-above` | `1` | `1` | erfüllt |
| `o6_9-ration-sow_lactating-exact` | `0` | `0` | erfüllt |
| `o6_9-ration-sow_lactating-above` | `1` | `1` | erfüllt |
| `o6_9-ration-boar_from_50kg-exact` | `0` | `0` | erfüllt |
| `o6_9-ration-boar_from_50kg-above` | `1` | `1` | erfüllt |
| `o6_9-fattening-average157-either` | `1` | `1` | erfüllt |
| `o6_9-fattening-neither` | `0` | `0` | erfüllt |
| `o6_9-fattening-phases-even-average158` | `1` | `1` | erfüllt |
| `o6_9-fattening-true-weighted-average` | `1` | `1` | erfüllt |
| `o6_9-phase-route-known-proof-true` | `0` | `0` | erfüllt |
| `o6_9-phase-route-known-proof-false` | `1` | `1` | erfüllt |
| `o6_9-ration-valid-prepared-basis-feed_analysis` | `0` | `0` | erfüllt |
| `o6_9-ration-valid-prepared-basis-standard_literature_value` | `0` | `0` | erfüllt |
| `o6_9-ration-valid-prepared-basis-manufacturer_declaration` | `0` | `0` | erfüllt |
| `o6_9-ration-valid-prepared-basis-other` | `1` | `1` | erfüllt |
| `o6_9-application-cap-100` | `100` | `100` | erfüllt |
| `o6_9-application-cap-101` | `100` | `100` | erfüllt |
| `o6_9-cap-uses-demand-not-spread-area` | `100` | `100` | erfüllt |
| `o6_9-fertilizable-pure-soy` | `0` | `0` | erfüllt |
| `o6_9-fertilizable-known-mixture` | `2` | `2` | erfüllt |
| `o6_9-fertilizable-wheat` | `2` | `2` | erfüllt |
| `o6_9-fertilizable-full-ban` | `0` | `0` | erfüllt |
| `o6_9-fallow-false-legume-override` | `0` | `2` | abweichend |
| `o6_9-fallow-exact-snapshot-name-correct` | `0` | `0` | erfüllt |
| `o6_9-integrated-rate-trailing_hose` | `11.0` | `11` | erfüllt |
| `o6_9-integrated-rate-trailing_shoe` | `15.0` | `15` | erfüllt |
| `o6_9-integrated-rate-injection` | `17.0` | `17` | erfüllt |
| `o6_9-pig-actual54eur-arable-component` | `108` | `108` | erfüllt |
| `o6_9-napv-arable-latest-ban-start` | `1` | `1` | erfüllt |
| `o6_9-napv-arable-last-ban-day` | `1` | `1` | erfüllt |
| `o6_9-napv-arable-after-ban` | `0` | `0` | erfüllt |
| `o6_9-napv-actual-late-exception-lastday` | `0` | `0` | erfüllt |
| `o6_9-napv-actual-late-exception-after` | `1` | `1` | erfüllt |
| `o6_9-napv-early-last-ban-day` | `1` | `1` | erfüllt |
| `o6_9-napv-early-first-allowed` | `0` | `0` | erfüllt |
| `o6_9-napv-forage-before-ban` | `0` | `0` | erfüllt |
| `o6_9-napv-forage-start` | `1` | `1` | erfüllt |
| `o6_9-napv-grassland-start` | `1` | `1` | erfüllt |
| `o6_9-napv-grassland-no-early-arable-exception` | `1` | `1` | erfüllt |
| `o6_9-napv-known-soil-normal` | `0` | `0` | erfüllt |
| `o6_9-napv-known-soil-frozen` | `1` | `1` | erfüllt |
| `o6_9-napv-known-soil-water_saturated` | `1` | `1` | erfüllt |
| `o6_9-napv-known-soil-flooded` | `1` | `1` | erfüllt |
| `o6_9-napv-known-soil-snow_covered` | `1` | `1` | erfüllt |
| `o6_9-napv-other-agricultural-land-unconsumed` | `1` | `0` | abweichend |
| `o6_9-other-land-correct-measure-scope-diagnosis` | `1` | `1` | erfüllt |

Die Fälle sind öffentliche gezielte Entwicklungsproben. Sie messen weder zurückgehaltene Genauigkeit noch ersetzen sie die spätere Abnahme durch Domainexpert:innen. Historische Policies, Profil und Quellen wurden nicht geändert; keine Maßnahme wurde promoviert oder für den Server freigegeben.
