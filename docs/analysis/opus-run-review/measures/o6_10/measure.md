# o6_10 – Erosionsschutz Wein, Obst und Hopfen: Quellenprüfung

Geprüft wurde ausschließlich der rohe historische Opus-Run `v2-o6_10-opus-5.5-high-20260925` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieser Teil enthält **37 historische Regelbewertungen, 16 Quellenabschnitte, sieben abgegrenzte Befunde und 135 neue öffentliche Entwicklungsproben**. Alle 135 Aufrufe sind bei strikter Builtin-Prüfung definiert. **125 Erwartungen sind erfüllt, zehn abweichend.**

Diese zehn Abweichungen sind **vier konkrete Ereignis-/Fristprüfungen, vier ausdrücklich bedingte Bereichs-/Archivlesarten und zwei nicht im Profil darstellbare Quellenqualifikationen**. Die vier konkreten Prüfungen betreffen drei tatsächliche Eingabefälle: bekannte zerstörende Tiefenlockerung, alleinige Neuauspflanzung und eine abgelaufene Vorjahresrodung mit zwei abgefragten Folgen. Es handelt sich weder um zehn unabhängige bestätigte Regeldefekte noch um einen Genauigkeits- oder Abnahmewert.

Das neue Merkblatt wurde auf **allen sechs Seiten vollständig gelesen**, einschließlich sämtlicher Tabellenzellen, der Hopfentarife am Ende von Seite 6, aller Ausnahmen, Aktualisierungen und des Schlussdisclaimers. Persönlich vollständig gelesen wurden alle **acht tatsächlichen Module mit 1.196 Zeilen** sowie die ganze Annahmendatei mit **20 bezeichneten Annahmen**, Eingabemodell und beiden bewusst nicht abgebildeten Themen.

Die acht Manifestquellen sind an Hash und Bytezahl gebunden. Sieben gemeinsame Originale verwenden die verifiziert identischen früher vollständig gelesenen Teamquellen. Für diesen Teil wurden die aktuellen vollständigen SRL-Seiten 4, 17, 64, 65 und 67, ATB-Seiten 7–8 sowie Anhang L Seite 103 erneut gelesen. Die einschlägigen vollständigen Abschnitte der Meldungen vom 5. August und 12. Juni 2026 wurden nachgelesen. General/Tables besitzen ihre weiteren aktuellen Quellen- und Matrixprüfungen. **Weder GSP-AV noch NAPV sind diesem Run geliefert.** Die Verfügbarkeit im vorherigen Run 9 und neue 2026-GSP-Fristformulierungen werden diesem Paket nicht rückwirkend zugerechnet.

## Bindung und Ausführung

Die vollständigen Bewertungen, Eingaben, Queries, vor Ausführung festgelegten Erwartungen, unveränderten nativen Beobachtungen und wörtlichen Belege stehen in [measure.json](/workspace/scratch/opus-o6-1a-source-audit/docs/analysis/opus-run-review/measures/o6_10/measure.json). Eingefrorener SHA-256: `c0804d9f97a84aab854b005bf41c315239547ff08c69d62fa6bdf5e136a16226`. Gemeinsame Sammlung, unabhängiger abschließender Replay und finale Artefaktbindungen bleiben Root/QA zugeordnet.

Jede Probe lädt `/tmp/issue-51-review-opa` mit `--strict-builtin-errors`, die vollständigen ursprünglichen Verzeichnisse `workspace/policy` und `workspace/data` sowie die native Query unter **`data.oepul.o6_10.*`**. Statische Daten bleiben unter **`data.o6_10.*`**. Dateien/Namespaces werden nicht abgeflacht oder korrigiert; Zahlen und Typen werden nicht normalisiert. Alle Erwartungen verwenden `equals` auf einer ausdrücklich abgefragten Komponente, einem Boolean oder einer Anzahl.

Die neuen Inputs wurden vor dem Einfrieren auf Zweig- und Tatsachenkonsistenz präzisiert. Die übrige bekannte Nicht-VFH-Fläche ist als ein Hektar Dauerwiese ausdrücklich enthalten; physische Gesamtflächen entsprechen der Schlagliste. Drei Veredelungskontrollen verwenden den gespeicherten Namen `Walnuss`, damit sie tatsächlich den Veredelungszweig erreichen. **Der wörtliche Merkblattname `Walnüsse` bleibt ein gültiger freier Quellname; General prüft dessen eigene Namenslücke separat.** Der Konstruktionseingriff macht aus diesem Namen keinen Schemaproblemfall. Zwei vorher nicht erreichte Veredelungsdiagnosen werden danach korrekt 1; Queries und Sollwerte ändern sich nicht. Sonstige abgefragte Beobachtungen bleiben nach vollständiger erneuter Ausführung identisch. Der genaue Nachweis steht unter `pre_freeze_construction_revision`.

Die Feldaufgangs-/Ausfallgetreidefälle enthalten tatsächliche aktuelle Anlageereignisse und einen dazu passenden Einsaatbefund. Der bekannte spätere Verlust enthält eine ausdrücklich physisch zerstörende Julibearbeitung; der chemische Terrassenfall besitzt eine echte Entfernung-/Neuanlagechronologie. Diese vor dem Einfrieren präzisierten Fälle wurden erneut ausgeführt; sämtliche abgefragten Antworten blieben unverändert (`pre_freeze_event_precision`). Keine historische Policy, Eingabe, Quelle oder Profildefinition wurde geändert.

Der begrenzte Enum-Check prüft **3.025 vorhandene Werte** gegen das unveränderte Canonical und die tatsächlichen 20 Run-Vorschläge: keine Abweichung. Er zertifiziert weder Vollständigkeit aller Felder noch jede reale Tatsachenbehauptung. **467 wörtliche Belegvorkommen mit 83 einzigartigen Belegen** sind ohne Literalfehler, unaufgelöste Quelle oder Kompakt-Fallback gefunden. Unicode bleibt erhalten; es gibt keine NFKC-Umwandlung von Quellenzeichen. Alle **69 Codebindungen** sind innerhalb der tatsächlichen Module und an den konkreten nummerierten Verbraucherstellen gegengeprüft.

| Vollständig gelesenes Modul | Zeilen | SHA-256 |
| --- | ---: | --- |
| [access.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/access.rego) | 184 | `e4c5231d94c75d9dc38957120199e8e8aa17bbd09cca1c537f084f54efcbe19d` |
| [administration.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/administration.rego) | 103 | `a255620124b471e4768d7a0735efe4100b441396cf873ff1dc029489a927a721` |
| [decision.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/decision.rego) | 47 | `c50075bda9f2feed95872522f37e8eff7ac8f89904abe9c837eff82aca014c65` |
| [eligibility.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/eligibility.rego) | 156 | `16a4e9600e1977501b87ae3db08b096a33a5258d4e3db6892c960c801c4beafa` |
| [helpers.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/helpers.rego) | 95 | `3f28fdbc01e2cead31925cd94121db4723454df04f764a442bab9a518d71e61d` |
| [obligations.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego) | 343 | `6c173931e79b454f8e7ee5ff424d88e645adc777222b02d01f0e1fa7a7b7fb90` |
| [premium.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/premium.rego) | 190 | `dc8b27cfd8b61735bbcdba04a11dbe24b1fa5a401038d96335ed616dc00c1a8a` |
| [supplement.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego) | 78 | `74f0295ebc9b71f0de6554470129284226c8cdd0c804cf517a6f3c32900dad7e` |

| Gebundene Quelle | Lektüre | SHA-256 |
| --- | --- | --- |
| [20241011_srl_oepul_2023.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023.pdf) | Identischer Hash zur früheren vollständigen Teamlektüre; aktuelle Nachlese nach Zuständigkeit | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| [20241011_srl_oepul_2023_anhaenge.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf) | Identischer Hash zur früheren vollständigen Teamlektüre; aktuelle Nachlese nach Zuständigkeit | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| [2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktuelle Nachlese nach Zuständigkeit | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| [2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktuelle Nachlese nach Zuständigkeit | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| [2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktuelle Nachlese nach Zuständigkeit | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| [2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html) | Identischer Hash zur früheren vollständigen Teamlektüre; aktuelle Nachlese nach Zuständigkeit | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| [o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf) | Neu: alle sechs Seiten vollständig | `cb2988f1292088ee42d90f9e0267e80ecef4ea64de64e601678335e6b1368aec` |
| [o6_allgemeine_teilnahmebedingungen_2026_04.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) | Identischer Hash zur früheren vollständigen Teamlektüre; aktuelle Nachlese nach Zuständigkeit | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

## Befunde

### O610-MEASURE-01: Bekannte zerstörende Tiefenlockerung und alleinige Neuauspflanzung lösen keine Frist aus

Die Ereignisart subsoil_loosening wird auch dann übergangen, wenn destroys_greening=true ausdrücklich die tatsächliche physische Zerstörung belegt. Eine alleinige tatsächliche Neuauspflanzung ist ebenfalls kein Fristauslöser. Die vollständigen Jahreslisten enden am 31. Dezember 2025 und enthalten nach dem bekannten 1.-Mai-Ereignis keine Neuanlage. In beiden Fällen fehlt die lokale 8-Wochen-Diagnose: Ist 0 statt Soll 1. Erhaltende Tiefenlockerung sowie rechtzeitige Neuanlage nach Umbruch/Rodung/sonstiger Bearbeitung haben positive Kontrollen. A06 zu zwei möglichen Ankerereignissen ist hier nicht entscheidend, da der Gegenfall jeweils genau einen tatsächlichen Auslöser enthält. Keine feste Sanktion oder Nullzahlung wird daraus abgeleitet.

Einordnung: `source_temporal_consumer_gap`; Familie `EVENT_SEMANTICS`. Historische IDs: `O610-TILLAGE-ALLOWED`, `O610-TILLAGE-REESTABLISH-8W`.

[obligations.rego:143–173](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:143)

[obligations.rego:183–227](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:183)

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Eine Bodenbearbeitung im Begrünungszeitraum ist nur dann erlaubt, wenn dadurch die Begrünung nicht zerstört wird (z. B. Untergrund- oder Tiefenlockern) oder wenn danach die Neuanlage der Begrünung erfolgt.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Die Neuanlage der Begrünung muss innerhalb von 8 Wochen nach Umbruch der Begrünung bzw. nach einer Rodung/Neuauspflanzung der Dauerkultur erfolgen – jedoch spätestens bis zum 1. Oktober.

Proben: `o6_10-known-destructive-subsoil_loosening-no-reestablishment`, `o6_10-known-destructive-replanting-no-reestablishment`, `o6_10-known-preserving-deep-loosening`.

### O610-MEASURE-02: Eine abgelaufene Vorjahresrodung kann dauerhaft pending bleiben

Im vollständig bekannten abgeschlossenen Kalenderjahr 2026 steht die tatsächliche Rodung vom 16. September 2025. Es wurde weder bis 15. Mai 2026 noch später neu begrünt; es gab tatsächlich keine weiteren Ereignisse. Dies ist keine unbekannte Liste oder laufende April-Auswertung. Nativ macht allein das Fehlen eines Folgejahreseintrags den Fall pending: lokale Fristdiagnose Ist 0 statt Soll 1 und Pending-Anzahl Ist 1 statt Soll 0. Die echte rechtzeitige Neuanlage am 15. Mai sowie die verspätete am 16. Mai werden dagegen richtig unterschieden. Die Vorjahresrodung gehört wegen der echten Folgejahresfrist zum nötigen Vertragsumfang und ist keine beliebige Archivhistorie.

Einordnung: `source_temporal_consumer_gap`; Familie `TEMPORAL_SCOPE`. Historische IDs: `O610-TILLAGE-LATE-CLEARING`.

[obligations.rego:175–181](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:175)

[obligations.rego:196–243](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:196)

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Bei Rodung nach dem 15. September darf die Fläche bis zum folgenden Frühjahr (bis 15. Mai) unbegrünt bleiben.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 1](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Der Verpflichtungs- und Vertragszeitraum der Maßnahme beträgt grundsätzlich ein Kalenderjahr (1. Jänner bis 31. Dezember).

Proben: `o6_10-old-late-clearing-known-complete-nextyear-no-establishment`, `o6_10-old-late-clearing-cannot-remain-pending`, `o6_10-following-year-actual-may15`, `o6_10-following-year-actual-may16`.

### O610-MEASURE-03: Reine Archivhistorie braucht einen ausdrücklich erweiterten Eingabevertrag

Ein ausschließlich 2024 um einen Tag verspäteter, bereits am 27. Juni 2024 abgeschlossener gewöhnlicher Umbruch wird in der ansonsten vollständig erfüllten 2025-Auswertung erneut diagnostiziert. Bei einem ausdrücklich erweiterten Archivvertrag wäre eine zusätzliche 2025-Diagnose unpassend: Ist 1 gegen bedingtes Soll 0. A07 beschreibt aber vorbereitete vollständige Jahresaufzeichnungen, kein beliebig großes Archiv. Dieser Test ist deshalb source_conditional_history_contract und kein unbedingter Modellfehler innerhalb des Jahresvertrags. Er behauptet weder Immunität vor einem eigenständigen 2024-Verfahren noch einen verbindlichen Zahlungsbetrag.

Einordnung: `source_conditional_history_contract`; Familie `TEMPORAL_SCOPE`. Historische IDs: `O610-TILLAGE-REESTABLISH-8W`.

[obligations.rego:216–227](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:216)

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 1](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Der Verpflichtungs- und Vertragszeitraum der Maßnahme beträgt grundsätzlich ein Kalenderjahr (1. Jänner bis 31. Dezember).

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Die Neuanlage der Begrünung muss innerhalb von 8 Wochen nach Umbruch der Begrünung bzw. nach einer Rodung/Neuauspflanzung der Dauerkultur erfolgen – jedoch spätestens bis zum 1. Oktober.

Proben: `o6_10-only-old-resolved-regular-event-not-current-year-breach`.

### O610-MEASURE-04: Die 2026-Ausnahme unterscheidet Ausfallgetreide und späteren Verlust nicht

Der Verbraucher verlangt nur Jahr 2026 und ordnungsgemäße Anlage. Die Meldung qualifiziert fehlenden Feldaufgang beziehungsweise Ausfallgetreide wegen mangelnder Keimbedingungen. Ein später absichtlich mechanisch zerstörter und entnommener Bestand wird nativ trotzdem von der lokalen Deckungsdiagnose befreit. Ebenso fehlen Quellenfelder für die Herkunft des Getreides: Ein tatsächlicher 70-%-Anteil aus bewusst eingesäter Komponente hat dieselben darstellbaren Werte wie qualifiziertes Ausfallgetreide. Die zwei negativen Erwartungen sind source_only_missing_qualifier; sie belegen fehlende Darstellungs-/Verbraucherqualifikationen und verlangen kein magisches Erkennen abwesender Tatsachen. Das gegensätzliche Quellenkontextpaar mit identischen Inputs ist ausdrücklich markiert und kein Genauigkeitsdatensatz. Bekannte andere Pflichten, etwa PSM, werden auch 2026 weiterhin korrekt diagnostiziert.

Einordnung: `source_only_missing_qualifier`; Familie `SOURCE_QUALIFIERS`. Historische IDs: `O610-2026-DROUGHT-GREENING`, `O610-GREEN-ALLYEAR-FULL`, `O610-GREEN-CEREAL-SHARE-50`.

[obligations.rego:14–47](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:14)

[obligations.rego:98–106](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:98)

[2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html – HTML-Meldung](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html)

> Wegen der derzeit vielerorts trockenen Witterungsbedingungen wird heuer keine Beanstandung ausgesprochen werden, wenn eine ordnungsgemäße Begrünungsanlage erfolgt ist, jedoch der Feldaufgang keine Flächendeckung erreicht oder Ausfallgetreide wegen der bisher mangelnden Keimbedingungen die 50 %-Grenze überschreitet.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Eine Nutzung des Begrünungsaufwuchses ist nicht erlaubt. Mähgut muss auf der Fläche verbleiben und darf nicht abtransportiert werden.

Proben: `o6_10-qualified-2026-volunteer-cereal70`, `o6_10-known-sown-not-volunteer-cereal70`, `o6_10-known-later-removal-not-failed-emergence`, `o6_10-drought-does-not-waive-known-PSM`.

### O610-MEASURE-05: Die Terrassenausnahme umfasst nativ auch Pflichten auf vorhandener Begrünung

Echte Terrassen brauchen laut Merkblatt keine Begrünung zu gewährleisten. Die nativen PSM-, Nutzungs- und Entfernungsregeln verwenden sämtlich die gleiche Liste ohne Terrassen. Drei tatsächliche 30-%-Terrassen mit freiwilliger stehender Begrünung liefern daher jeweils keine lokale Diagnose. Die enge bedingte Wortlautlesart der eigenständigen Verbote auf vorhandener Begrünung erwartet jeweils 1 statt Ist 0. Eine behördlich bestätigte umfassende Terrassenausnahme würde diese Erwartungen ändern. Die Fälle bleiben ausdrücklich source_conditional_terrace_scope, offene Bereichslesarten und kein akzeptiertes Rechtsgold. Der positive Fall einer Terrasse ohne Begrünung bestätigt allein die echte Grundausnahme; keine beliebige Nullzahlung wird behauptet.

Einordnung: `source_conditional_terrace_scope`; Familie `TERRACE_SCOPE`. Historische IDs: `O610-GREEN-TERRACE-EXEMPT`, `O610-USE-BAN`, `O610-PSM-BAN-GREENING`, `O610-REMOVAL-MECHANICAL`.

[obligations.rego:6–12](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:6)

[obligations.rego:261–301](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:261)

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 2](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Bei der Bewirtschaftung von Terrassenflächen muss keine Begrünung gewährleistet sein.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Eine Nutzung des Begrünungsaufwuchses ist nicht erlaubt. Mähgut muss auf der Fläche verbleiben und darf nicht abtransportiert werden.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 4](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Auf den Begrünungen in den Fahrgassen ist vom Zeitpunkt der Anlage bis zum Umbruch der Einsatz von Pflanzenschutzmitteln nicht erlaubt.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 4](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Die Beseitigung der Begrünung in den Fahrgassen darf nur mit mechanischen Methoden (z. B. Häckseln oder Einarbeiten) erfolgen.

Proben: `o6_10-actual-terrace-existing-cover-psm_applied_on_greening`, `o6_10-actual-terrace-existing-cover-growth_used_or_removed`, `o6_10-actual-terrace-existing-cover-removal_method`, `o6_10-actual-terrace-needs-no-greening`.

### O610-MEASURE-06: GIS-Herkunft und tatsächliche Einzelaufzeichnungen bleiben vorgelagert

Der numerische Hangwert sowie globale Listen mit fünf Begrünungs- und vier EOP-Inhalten werden tatsächlich verbraucht. Der Verbraucher belegt aber weder die unveränderliche GIS-Herkunft noch richtige Schlagidentitäten, Größen, Produkte, Mengen, Belege oder tatsächliche Ereignisdaten für jeden einzelnen Schlag. Verfahrens-, Winterhärte-, Beweidungs-, Registeraufwands- und Ersatzflags müssen ebenfalls positiv vorgeprüfte Tatsachen sein. Positive Fälle stipulieren diese Belege. Bekannte fehlende Dokumentinhalte sind von bloß unbekannten Auskünften oder vermeintlich bewiesener schlechter Bewirtschaftung getrennt. Inputs besitzt fehlend/null, Typ-/Schemagrenzen und App-Projektion; Core besitzt die finanzielle Wirkung wirklicher Zulassungs-/Verfahrensblocker.

Einordnung: `prepared_evidence_boundary`; Familie `EVIDENCE_CONTRACT`. Historische IDs: `O610-SLOPE-SOURCE`, `O610-REC-GREENING`, `O610-EOP-RECORDS`.

[helpers.rego:44–51](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/helpers.rego:44)

[obligations.rego:330–343](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:330)

[supplement.rego:54–68](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:54)

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 2](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Die Hangneigung wird automatisch ausgewiesen und kann nicht geändert werden.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 3](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Über die betrieblichen Bewirtschaftungsmaßnahmen sind Aufzeichnungen zu führen, die folgende Punkte umfassen müssen: Betrieb, Feldstücksnummer und ‐bezeichnung, Schlaggröße, Datum der Rodung bzw. Neuauspflanzung der Dauerkultur, Datum der Anlage und des Umbruchs der Begrünung.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 4](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Es sind schlagbezogene Aufzeichnungen über Art und Menge der eingesetzten Organismen oder Pheromone, Belege über Zukauf, Grund und Ziel sowie Datum des Einsatzes zu führen.

Proben: `o6_10-actual-complete-equivalent-non-template-records`, `o6_10-actual-qualified-EOP-use`.

### O610-MEASURE-07: Offene ursprüngliche Lesarten werden nicht durch neue Beträge entschieden

A02 (bestehende Kultur gegenüber reiner Selbstbegrünung), A03 (deklarierte Terrasse unter 25 %), A04 (Betrieb gegenüber BIO-Teilbetriebsfläche), A05 (Mindestfläche trotz Prämienausschluss), A06 (Rodung/Neuauspflanzung), A08 (alle codierten Flächen nach einem Einsatz) und A12 (Auswirkung des genehmigten Ausstiegs aus 12) bleiben sichtbar. Die Geldkontrollen behandeln sämtliche codierten bezahlten Schläge tatsächlich und benutzen eindeutige Ganzbetriebsteilnahme. Genehmigter Ausstieg unter A12 hat eine konsistent aktualisierte Teilnehmerliste; verbleibende BIO-Teilnahme halbiert weiterhin. Der ausdrücklich widersprüchliche alte 12-Eintrag prüft nur den nativen Hinweis. Die Wirkung behördlich angeordneter Insektizide auf den tatsächlichen PSM-Ersatz bleibt offen. Auch A09/A10 zu Sanktionen/Kappungszuordnung werden nicht durch zusätzliche willkürliche Maßnahmensanktionen entschieden.

Einordnung: `disclosed_interpretation_boundary`; Familie `INTERPRETATION_BOUNDARY`. Historische IDs: `O610-PREM-EOP-REDUCTION`, `O610-2026-EXIT12-EOP`, `O610-ELIG-TERRACE-SLOPE`.

[supplement.rego:18–28](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:18)

[supplement.rego:70–78](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:70)

[administration.rego:75–82](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/administration.rego:75)

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 6](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Der optionale Zuschlag für den Einsatz von Organismen oder Pheromonen wird im Falle einer Teilnahme des Betriebes an der Maßnahme „Insektizidverzicht Wein, Obst und Hopfen“ oder „Biologische Wirtschaftsweise“ um 50 % reduziert.

[o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf S. 2](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf)

> Bei der Bewirtschaftung von Terrassenflächen muss keine Begrünung gewährleistet sein.

Proben: `o6_10-whole-farm-EOP-reduction-both`, `o6_10-A12-approved-exit-no-BIO`, `o6_10-A12-approved-exit-BIO-remains`, `o6_10-A12-conflicting-stale-list-gets-notice`.

## Beibehaltene richtige Verbraucher und offene Verträge

Alle geeigneten eigenen VFH-Schläge werden geprüft, auch ohne ausgewählten Einzelcode und trotz OP. 0,50 ha, die echte 25-%-Terrassenschwelle, 80/100 cm Stammstreifen und die qualifizierte 60-%-Ausnahme besitzen tatsächlich wirkende Grenzkontrollen. Für Holunder mit besonders breiten Reihen existiert ausdrücklich der gültige Selector `wide_row_spacing`; ein solcher Fall wird nicht absichtlich als `single_row` fehlklassifiziert.

Drei winterharte Mischungspartner beziehungsweise tatsächliche bestehende Begrünung werden verbraucht. Reine organische Bodenbedeckung und reine Selbstbegrünung werden diagnostiziert. Die engen Grünschnittroggenkontrollen behaupten nur den Getreide-Kulturteil: Sie erfinden für eine Reinsaat keine drei Partner und bestätigen keine ganze Betriebszulässigkeit. Der maximale bekannte Jahresanteil wird strikt über 50 % geprüft; Hafer/Sommergerste als tatsächlich geeignete Deckfrucht zur Etablierung einer Dauerbegrünung ist separat qualifiziert.

56 Tage und 1. Oktober, strikt nach 15. September und der inklusive 15. Mai funktionieren für die tatsächlich erfassten Ereignisse. Aktuelle Erneuerungen werden jahresbezogen gezählt; die Initialanlage einer Junganlage wird nicht zur zusätzlichen Erneuerung. Erhaltende Tiefenlockerung wird zugelassen. Bekannte gewöhnliche PSM-, Nutzungs-, mechanische Entfernungs- sowie qualifizierte Schaf-/temporäre Geflügelbedingungen haben Verbraucher.

Der EOP-Zuschlag verlangt echte Codierung, geeigneten eigenen Einsatz, Registeraufwand, PSM-Ersatz, keinen einschlägigen PO-Programmausschluss und einen gültigen Vertrag. Die persönliche Zahlung an das Mitglied ist für den PO-Ausschluss nicht entscheidend. Die positiven Betragsfälle behandeln jeden codierten bezahlten Schlag tatsächlich, um A08 nicht zu entscheiden. Alle drei Kulturgruppen zeigen 135 Euro garantierten Mindestzuschlag und 165 Euro oberes Band bis 2024 sowie 162 Euro ab 2025. Eindeutige Ganzbetriebsteilnahme an 12 oder BIO halbiert einmal; beide Auslöser führen nicht zu 25 %.

Ein tatsächlich genehmigter Ausstieg aus 12 mit konsistent aktualisierter Liste wird nur unter der offengelegten A12-Lesart geprüft; verbleibendes BIO bleibt ein eigener Halbierungsauslöser. Auswirkungen behördlich angeordneter Insektizide auf den PSM-Ersatz bleiben offen. A04, A05, A06, A08 sowie die allgemeinen A09/A10 werden nicht durch künstliche Zahlungs- oder Sanktionsoracles entschieden.

Die 2026-Deckungsausnahme wird für tatsächlich ordnungsgemäße Anlage mit qualifiziert fehlendem Feldaufgang beziehungsweise Ausfallgetreide positiv geprüft; 2025 und bekannte mangelhafte Anlage erhalten sie nicht. Andere bekannte Pflichten, etwa PSM, bleiben wirksam. Eine Acker-Ernteausnahme oder Ackerdistriktliste wird nicht auf Dauerkultur-Erntepflichten übertragen.

Native Zulassungs-/Verfahrensverbesserungen gegenüber anderen Runs bleiben erhalten: tatsächliche Kontrollverweigerung, fehlender Zahlungsantrag und Maßnahmenausschluss blockieren den auszahlbaren Betrag. Behördlich eingestufte `control_findings` steuern eine Kürzung unter A09; bloße Bewirtschaftungsdiagnosen erzeugen keine erfundene automatische Vollsanktion. Root besitzt diese vollständige Geld-/Zulassungsschnittstelle.

## Historische Regelabdeckung

Exakt **37 zugewiesene historische IDs: 18 umgesetzt, 15 teilweise und vier offen**. Jede besitzt die ursprüngliche Katalogaussage, tatsächliche Verbraucherbindungen und Quellenbelege. Umgesetzt bestätigt den Verbraucher innerhalb seines offengelegten Tatsachenvertrags, keine realen Belege oder Behördenfreigabe. Zusätzliche synthetische Katalog-IDs wurden nicht erfunden.

| Historische ID | Bewertung | Tatsächlicher Code |
| --- | --- | --- |
| `O610-MIN-AREA` | partial | [eligibility.rego:34](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/eligibility.rego:34), [access.rego:119](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/access.rego:119) |
| `O610-ELIG-ALL-AREAS` | implemented | [eligibility.rego:34](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/eligibility.rego:34), [obligations.rego:6](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:6) |
| `O610-ELIG-TERRACE-SLOPE` | unresolved | [helpers.rego:74](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/helpers.rego:74) |
| `O610-ELIG-ONLY-VFH` | implemented | [eligibility.rego:31](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/eligibility.rego:31), [helpers.rego:53](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/helpers.rego:53) |
| `O610-SLOPE-SOURCE` | partial | [helpers.rego:44](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/helpers.rego:44) |
| `O610-EOP-NO-OP-PO` | implemented | [supplement.rego:9](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:9), [supplement.rego:46](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:46) |
| `O610-GREEN-ALLYEAR-FULL` | partial | [obligations.rego:6](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:6) |
| `O610-GREEN-ESTABLISHMENT` | implemented | [obligations.rego:50](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:50) |
| `O610-GREEN-TERRACE-EXEMPT` | partial | [obligations.rego:6](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:6), [obligations.rego:261](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:261) |
| `O610-GREEN-OPEN-STRIP` | implemented | [obligations.rego:110](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:110) |
| `O610-GREEN-60PCT-ALT-SYSTEMS` | implemented | [obligations.rego:110](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:110) |
| `O610-GREEN-INVALID-MULCH` | implemented | [obligations.rego:72](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:72) |
| `O610-GREEN-INVALID-SELF` | unresolved | [obligations.rego:72](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:72) |
| `O610-GREEN-INVALID-CEREAL-MAIZE` | implemented | [obligations.rego:88](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:88) |
| `O610-GREEN-CEREAL-SHARE-50` | partial | [obligations.rego:31](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:31), [obligations.rego:98](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:98) |
| `O610-GREEN-NURSE-CROP-EXC` | implemented | [obligations.rego:31](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:31) |
| `O610-TILLAGE-ALLOWED` | partial | [obligations.rego:143](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:143), [obligations.rego:216](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:216) |
| `O610-TILLAGE-RENEWAL-ONCE` | implemented | [obligations.rego:152](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:152), [obligations.rego:245](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:245) |
| `O610-TILLAGE-REESTABLISH-8W` | partial | [obligations.rego:159](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:159), [obligations.rego:216](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:216) |
| `O610-TILLAGE-LATE-CLEARING` | partial | [obligations.rego:175](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:175), [obligations.rego:196](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:196) |
| `O610-TILLAGE-YOUNG-PLANTING` | implemented | [obligations.rego:152](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:152), [obligations.rego:245](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:245) |
| `O610-REC-GREENING` | partial | [obligations.rego:330](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:330) |
| `O610-REC-TEMPLATE` | implemented | [obligations.rego:330](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:330) |
| `O610-USE-BAN` | partial | [obligations.rego:261](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:261) |
| `O610-USE-GRAZING-EXC` | partial | [obligations.rego:270](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:270) |
| `O610-PSM-BAN-GREENING` | partial | [obligations.rego:283](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:283) |
| `O610-REMOVAL-MECHANICAL` | partial | [obligations.rego:292](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:292) |
| `O610-EOP-REQ-USE` | implemented | [supplement.rego:18](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:18), [supplement.rego:46](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:46) |
| `O610-EOP-REPLACE-PSM` | implemented | [supplement.rego:18](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:18) |
| `O610-EOP-RECORDS` | partial | [supplement.rego:54](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:54) |
| `O610-APP-EOP-CODE` | implemented | [supplement.rego:4](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:4), [premium.rego:45](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/premium.rego:45) |
| `O610-FRUIT-GRAFTED` | implemented | [eligibility.rego:124](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/eligibility.rego:124), [obligations.rego:305](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:305) |
| `O610-PREM-EOP-RATE` | implemented | [premium.rego:29](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/premium.rego:29) |
| `O610-PREM-EOP-REDUCTION` | unresolved | [supplement.rego:70](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:70) |
| `O610-PREM-BAND-2023-2024` | implemented | [premium.rego:34](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/premium.rego:34) |
| `O610-2026-DROUGHT-GREENING` | partial | [obligations.rego:14](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:14), [obligations.rego:98](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/obligations.rego:98), [administration.rego:68](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/administration.rego:68) |
| `O610-2026-EXIT12-EOP` | unresolved | [administration.rego:75](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/administration.rego:75), [supplement.rego:70](/workspace/scratch/opus-candidates-source/runs/v2-o6_10-opus-5.5-high-20260925/workspace/policy/o6_10/supplement.rego:70) |

## Neue öffentliche Proben

Das identische Eingabe-/Querypaar `qualified-2026-volunteer-cereal70` und `known-sown-not-volunteer-cereal70` unterscheidet nur den zusätzlich bekannten realen Quellenkontext, für den im Profil ein Feld fehlt. Die gegensätzlichen Erwartungen demonstrieren diese Darstellungsgrenze. **Ein deterministischer Verbraucher kann beide nicht aus denselben Inputs erfüllen.** Das Paar ist ausdrücklich kein Eingabe-Goldvertrag oder versteckter Genauigkeitstest (`source_context_pairs`).

| Fall | Abgegrenzter Vertrag | Soll | Ist | Ergebnis |
| --- | --- | --- | --- | --- |
| `o6_10-minimum-below` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-minimum-exact` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-minimum-above` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-culture-vine` | `source_area_component` | `1` | `1` | erfüllt |
| `o6_10-actual-culture-fruit` | `source_area_component` | `1` | `1` | erfüllt |
| `o6_10-actual-culture-hop` | `source_area_component` | `1` | `1` | erfüllt |
| `o6_10-actual-culture-vine_terrace` | `source_area_component` | `1` | `1` | erfüllt |
| `o6_10-actual-culture-vine_nursery` | `source_area_component` | `0` | `0` | erfüllt |
| `o6_10-actual-culture-tree_nursery` | `source_area_component` | `0` | `0` | erfüllt |
| `o6_10-actual-culture-energy_wood` | `source_area_component` | `0` | `0` | erfüllt |
| `o6_10-actual-culture-palm_catkin` | `source_area_component` | `0` | `0` | erfüllt |
| `o6_10-actual-culture-other_permanent_crop` | `source_area_component` | `0` | `0` | erfüllt |
| `o6_10-terrace-class-below` | `native_disclosed_A03` | `"vine"` | `"vine"` | erfüllt |
| `o6_10-terrace-class-exact` | `source_terrace_component` | `"vine_terrace"` | `"vine_terrace"` | erfüllt |
| `o6_10-terrace-class-above` | `source_terrace_component` | `"vine_terrace"` | `"vine_terrace"` | erfüllt |
| `o6_10-whole-farm-uncoded-second-plot` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-OP-keeps-actual-greening-duty` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-ordinary-annual-coverage-true` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-ordinary-annual-coverage-false` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-sown-winterhardy-partners-2` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-sown-winterhardy-partners-3` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-sown-winterhardy-partners-4` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-retained-established-cover` | `source_prevalidated_A02_boundary` | `0` | `0` | erfüllt |
| `o6_10-actual-no-greening-establishment` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-terrace-needs-no-greening` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-stem-strip-vine-exact` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-stem-strip-vine-above` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-stem-strip-fruit-exact` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-stem-strip-fruit-above` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-stem-strip-hop-exact` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-stem-strip-hop-above` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-qualified-alternative-double_row-exact60` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-qualified-alternative-double_row-below60` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-qualified-alternative-planting_bed-exact60` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-qualified-alternative-planting_bed-below60` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-qualified-alternative-staggered-exact60` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-qualified-alternative-staggered-below60` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-qualified-alternative-wide_row_spacing-exact60` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-qualified-alternative-wide_row_spacing-below60` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-known-invalid-cover-organic_mulch` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-known-invalid-cover-self_greening` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-pure-cereal-rye-exception-false` | `source_culture_predicate_only` | `1` | `1` | erfüllt |
| `o6_10-pure-cereal-rye-exception-true` | `source_culture_predicate_only` | `0` | `0` | erfüllt |
| `o6_10-known-annual-maximum-cereal-49.99` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-known-annual-maximum-cereal-50` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-known-annual-maximum-cereal-50.01` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-qualified-oat-nurse-perennial-establishment` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-known-preserving-deep-loosening` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-break-day56` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-break-day57` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-clearing-day56` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-clearing-day57` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-other_tillage-day56` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-other_tillage-day57` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-latest-oct1` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-after-oct1` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-known-destructive-subsoil_loosening-no-reestablishment` | `source_temporal_consumer_gap` | `1` | `0` | abweichend |
| `o6_10-known-destructive-replanting-no-reestablishment` | `source_temporal_consumer_gap` | `1` | `0` | abweichend |
| `o6_10-disclosed-A06-replanting-anchor` | `native_disclosed_A06` | `0` | `0` | erfüllt |
| `o6_10-actual-current-renewals-1` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-current-renewals-2` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-young-newplanting-one-later-renewal` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-late-clearing-sep15-regular` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-late-clearing-sep16-pending` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-old-late-clearing-known-complete-nextyear-no-establishment` | `source_temporal_consumer_gap` | `1` | `0` | abweichend |
| `o6_10-old-late-clearing-cannot-remain-pending` | `source_temporal_consumer_gap` | `0` | `1` | abweichend |
| `o6_10-following-year-actual-may15` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-following-year-actual-may16` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-only-old-resolved-regular-event-not-current-year-breach` | `source_conditional_history_contract` | `0` | `1` | abweichend |
| `o6_10-actual-cutting-removal-false` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-cutting-removal-true` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-grazing-none` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-grazing-sheep_extensive` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-grazing-poultry_temporary` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-grazing-other` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-standing-greening-psm-false` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-standing-greening-psm-true` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-removal-method-none` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-removal-method-mechanical` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-actual-removal-method-chemical` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-terrace-existing-cover-psm_applied_on_greening` | `source_conditional_terrace_scope` | `1` | `0` | abweichend |
| `o6_10-actual-terrace-existing-cover-growth_used_or_removed` | `source_conditional_terrace_scope` | `1` | `0` | abweichend |
| `o6_10-actual-terrace-existing-cover-removal_method` | `source_conditional_terrace_scope` | `1` | `0` | abweichend |
| `o6_10-known-record-omits-farm` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-known-record-omits-field_piece_number_and_name` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-known-record-omits-plot_size` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-known-record-omits-clearing_replanting_date` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-known-record-omits-greening_establishment_and_break_dates` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-actual-complete-equivalent-non-template-records` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-whole-PO-False-False` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-whole-PO-True-False` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-whole-PO-False-True` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-whole-PO-True-True` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-EOP-fails-used` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-EOP-fails-per_register_application_rates` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-EOP-fails-replaces_psm_application` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-actual-qualified-EOP-use` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-no-EOP-code-no-request` | `source_normative` | `false` | `false` | erfüllt |
| `o6_10-actual-EOP-record-omits-type_and_amount` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-actual-EOP-record-omits-purchase_receipts` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-actual-EOP-record-omits-reason_and_target` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-actual-EOP-record-omits-application_date` | `source_record_content_component` | `1` | `1` | erfüllt |
| `o6_10-known-walnut-grafted-True-OP-False` | `source_normative` | `0` | `0` | erfüllt |
| `o6_10-known-walnut-grafted-False-OP-False` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-known-walnut-grafted-False-OP-True` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-EOP-rate-vine-2023` | `source_nominal_component` | `135` | `135` | erfüllt |
| `o6_10-EOP-rate-max-2023` | `source_nominal_band_component` | `165` | `165` | erfüllt |
| `o6_10-EOP-rate-fruit-2023` | `source_nominal_component` | `135` | `135` | erfüllt |
| `o6_10-EOP-rate-hop-2023` | `source_nominal_component` | `135` | `135` | erfüllt |
| `o6_10-EOP-rate-vine-2024` | `source_nominal_component` | `135` | `135` | erfüllt |
| `o6_10-EOP-rate-max-2024` | `source_nominal_band_component` | `165` | `165` | erfüllt |
| `o6_10-EOP-rate-fruit-2024` | `source_nominal_component` | `135` | `135` | erfüllt |
| `o6_10-EOP-rate-hop-2024` | `source_nominal_component` | `135` | `135` | erfüllt |
| `o6_10-EOP-rate-vine-2025` | `source_nominal_component` | `162` | `162` | erfüllt |
| `o6_10-EOP-rate-max-2025` | `source_nominal_band_component` | `162` | `162` | erfüllt |
| `o6_10-EOP-rate-fruit-2025` | `source_nominal_component` | `162` | `162` | erfüllt |
| `o6_10-EOP-rate-hop-2025` | `source_nominal_component` | `162` | `162` | erfüllt |
| `o6_10-EOP-rate-vine-2026` | `source_nominal_component` | `162` | `162` | erfüllt |
| `o6_10-EOP-rate-max-2026` | `source_nominal_band_component` | `162` | `162` | erfüllt |
| `o6_10-EOP-rate-fruit-2026` | `source_nominal_component` | `162` | `162` | erfüllt |
| `o6_10-EOP-rate-hop-2026` | `source_nominal_component` | `162` | `162` | erfüllt |
| `o6_10-whole-farm-EOP-reduction-none` | `source_unambiguous_wholefarm_component` | `1` | `1` | erfüllt |
| `o6_10-whole-farm-EOP-reduction-12` | `source_unambiguous_wholefarm_component` | `0.5` | `0.5` | erfüllt |
| `o6_10-whole-farm-EOP-reduction-BIO` | `source_unambiguous_wholefarm_component` | `0.5` | `0.5` | erfüllt |
| `o6_10-whole-farm-EOP-reduction-both` | `source_unambiguous_wholefarm_component` | `0.5` | `0.5` | erfüllt |
| `o6_10-actual-failed-emergence-ordinary2025` | `source_qualified_drought_component` | `1` | `1` | erfüllt |
| `o6_10-actual-failed-emergence-qualified2026` | `source_qualified_drought_component` | `0` | `0` | erfüllt |
| `o6_10-actual-failed-emergence-not-properly-established` | `source_qualified_drought_component` | `1` | `1` | erfüllt |
| `o6_10-qualified-2026-volunteer-cereal70` | `source_qualified_drought_component` | `0` | `0` | erfüllt |
| `o6_10-known-sown-not-volunteer-cereal70` | `source_only_missing_qualifier` | `1` | `0` | abweichend |
| `o6_10-known-later-removal-not-failed-emergence` | `source_only_missing_qualifier` | `1` | `0` | abweichend |
| `o6_10-drought-does-not-waive-known-PSM` | `source_normative` | `1` | `1` | erfüllt |
| `o6_10-A12-approved-exit-no-BIO` | `native_disclosed_A12` | `1` | `1` | erfüllt |
| `o6_10-A12-approved-exit-BIO-remains` | `native_disclosed_A12` | `0.5` | `0.5` | erfüllt |
| `o6_10-A12-conflicting-stale-list-gets-notice` | `native_disclosed_A12_input_consistency` | `1` | `1` | erfüllt |

Diese gezielten öffentlichen Entwicklungsproben verwenden keine GM-/Studienreferenzlabels, historischen Selbsttests oder manuellen Adaptations-Sollwerte. Sie ersetzen keine spätere gemeinsame Fachabnahme. Es wurden keine Policies repariert und keine Ergebnisse für App oder Server promoviert.
