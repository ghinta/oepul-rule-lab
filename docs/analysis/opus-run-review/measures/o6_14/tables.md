# o6_14 – Tabellen, Listen und tatsächliche Verbraucher

Die Tabellenprüfung ist für den gemeinsamen Lauf und die unabhängige QA vorbereitet. Sie betrifft ausschließlich `v2-o6_14-opus-5.5-high-20260926` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Es wurden keine nativen Regeln, Daten, Originale, Canonical-Felder oder App-Dateien geändert.

Das neue Maßnahmenblatt wurde persönlich auf allen **16 Seiten** vollständig gelesen, einschließlich aller Tabellen, Beispiele, Fußnoten, Aktualisierungen und Impressum. Ebenfalls vollständig gelesen wurden alle acht Module mit **1.377 Zeilen**, die **17 nummerierten Rohannahmen samt übrigen Notizen** und alle **vier vollständigen Profilvorschlagsbäume**. Sieben gemeinsame Originale werden mit identischen Hashes und belegter früherer Volllektüre wiederverwendet; die aktuellen ganzen Anhänge A (PDF 3) und E (PDF 10), SRL 69–72/87 und der Almabschnitt der Mitteilung vom 22. Mai wurden frisch zurückgelesen. **GSP-AV und NAPV sind nicht bereitgestellt.**

## Tatsächliches Inventar

Alle 47 Bindungen stimmen mit den unveränderlichen Dateien überein. Vier Datendateien enthalten 27 Inventarpointer und 147 direkte Einträge; sämtliche 147 deklarierten Zeilen stimmen. Insgesamt wurden 576 native Skalarblätter gelesen. Fünf davon liegen außerhalb der Inventarcontainer und besitzen alle echte direkte Feldverweise. Einträge und Skalarblätter sind unterschiedliche Zähleinheiten, keine Zahl eindeutiger Rechtsnormen.

| Datei | Pointer | Einträge |
|---|---|---:|
| `combinations.json` | `/combinations/annex_l_row_14` | 20 |
| `combinations.json` | `/combinations/supplement_exclusions` | 1 |
| `combinations.json` | `/combinations/takeover_only_in_individual_cases` | 1 |
| `combinations.json` | `/combinations/related_measure_effects` | 2 |
| `premium_rates.json` | `/premium_rates/base_rates_eur_per_ha` | 6 |
| `premium_rates.json` | `/premium_rates/nature_conservation_base_rates_eur_per_ha` | 3 |
| `premium_rates.json` | `/premium_rates/nature_conservation_measure_codes` | 9 |
| `premium_rates.json` | `/premium_rates/modulation_tiers` | 4 |
| `premium_rates.json` | `/premium_rates/area_payment_caps_eur_per_ha` | 9 |
| `premium_rates.json` | `/premium_rates/grazing_plan_supplement` | 3 |
| `procedure.json` | `/procedure/contract_periods` | 3 |
| `procedure.json` | `/procedure/last_entry` | 3 |
| `procedure.json` | `/procedure/annual_deadlines` | 8 |
| `procedure.json` | `/procedure/reporting_windows` | 5 |
| `procedure.json` | `/procedure/psm_codes` | 2 |
| `procedure.json` | `/procedure/national_parks` | 5 |
| `procedure.json` | `/procedure/eligible_applicant_types` | 4 |
| `procedure.json` | `/procedure/sanction_stages` | 9 |
| `procedure.json` | `/procedure/multiple_reduction_order` | 11 |
| `procedure.json` | `/procedure/nature_conservation_course` | 3 |
| `procedure.json` | `/procedure/grazing_plan_course` | 2 |
| `procedure.json` | `/procedure/minimum_participation_first_year` | 2 |
| `procedure.json` | `/procedure/minimum_farm_size_first_oepul_year` | 2 |
| `procedure.json` | `/procedure/area_reduction_tolerance` | 3 |
| `rgve_key.json` | `/rgve_key/categories` | 18 |
| `rgve_key.json` | `/rgve_key/dwarf_cattle_breeds` | 4 |
| `rgve_key.json` | `/rgve_key/eligible_species` | 5 |

Jeder tatsächliche Wert einschließlich Unterfeldern, Bezeichnungen, Einheiten, Nullwerten, Jahresgrenzen und Qualifikationen ist mit Quellen und aktuellen Verbrauchern im JSON erfasst. Die fünf übrigen Metadaten sind 100 m² je Einzelbaum, 1 ha je RGVE, 50 € Bagatellgrenze, 75 % höchster Vorschuss und der Altersstichtag 1. Juli. Gespeicherte Labels und Qualifikationen werden jeweils von den tatsächlich ausgewählten Feldern getrennt beschrieben.

## Quellenvergleich und Verbraucher

Die eigene Kombinationstabellendatei enthält nur die **20 leeren Gegenmaßnahmen der 14-Zeile**. Die Diagonale wird separat behandelt. Die gesamte eigene Zeile und Spalte 14 sowie alle vier Fußnoten wurden im Originalbild Anhang L 103 frisch angesehen: keine positive Paarung, kein eigener Header- oder Zellenfußnotenbefund. Für die übrige Originalmatrix ist die unabhängige Transkription aus o6_8 mit ihrem unveränderten Hash gebunden: 21 Codes, 134 positive Koordinaten/Marker/Fußnotentupel, 286 leere Offdiagonalpaare und 21 getrennte Diagonalen. Eine vollständige native 134-Zellenmatrix dieses Runs oder eine frische zweite Rekonstruktion aller fremden Zellen wird nicht behauptet. Die eine NATA/AWP-Unvereinbarkeit gilt beidseitig; die Übernahmeausnahme des jährlichen AWP-Zuschlags nennt genau Auflösung, Teilung und Zusammenführung.

Alle **18 RGVE-Klassentupel**, **vier Zwergrinderrassen** und **fünf Tiergruppen** samt Meldekanal und Einzeltier-/Stückrolle stimmen mit den Originalen überein. Die allgemeine Anhang-A-Tabelle enthält zusätzliche Schweine-/Wildtierzeilen; sie werden durch die maßnahmenspezifischen fünf Tiergruppen nicht zu fehlenden eigenen Klassen. Altersstichtag ist 1. Juli. Kleine Equiden erfordern sowohl die Höhen- als auch die Gewichtsgrenze; große Equiden überschreiten mindestens eine. Der native Größenklasseninput bleibt vorgelagert, keine eigenständige Messung. Positive Klasseninputs sind abstrakte bekannte Komponenten, keine erfundenen Tierregistereinträge. Tatsächliche Aufenthaltstage, meldebedingt anrechenbare Tage, Tierprämie, Besatz und Belegungstage je Alm haben verschiedene Rollen. Die Quelle unterscheidet Rinder 14 Tage von anderen Tiergruppen 7 Tage; Auftrieb zählt, Abtrieb nicht.

Alle **sechs Erschließungstarife** (40/60/80€ im Jahr 2023,43,2/64,8/86,4 € ab 2024), **drei NATA-Grundtarife** (5 € im Jahr 2023,5,4 € im Jahr 2024,10 € ab 2025) und **neun Anhang-E-Tupel** wurden vollständig geprüft. NAW1/2/3 vergüten 2,2/8,6/27 €, NAD1/2/3 2,2/4,3/10,8 €, NAB1/2/3 4,3/16,2/43,2 € ab 2024. Die Anteilsklassen lauten über 1 bis 5 %, über 5 bis 20 % und über 20 %. Die native Obergrenze 100 % stellt den physisch möglichen Flächenanteil dar. Die Originalfußnote zu Einzelbäumen lautet 100 m²; Unicode² bleibt erhalten. Die eigenständige Anteilsfunktion wird vom tatsächlichen Auszahlungszweig nicht aufgerufen: Dieser summiert erklärte Codes. Code und Tarif ersetzen weder Projektbestätigung noch tatsächliche Anteile, Maßnahmenpläne oder örtliche Voraussetzungen. Für 2023 wird kein unbelegter Codepreis erfunden.

Erschließungsstufen werden bei vergleichbaren Auftriebszeiträumen anhand der Alptage kombiniert; das wirkliche Originalbeispiel 3.750/4.800 ergibt Stufe 2. Bei nicht vergleichbaren Zeiträumen entscheidet die Einheit mit längerem Auftrieb, unabhängig von der Fläche. Der AWP-Zuschlag gilt ab 2025 für die ersten 20 ha **je Alm** mit 20 €/ha; der 1 ha/RGVE-Deckel und die eigenen Plan-/Kurs-/Folgejahrespflichten bleiben separate Voraussetzungen. AWP ist jährlich, die Basis- und NATA-Verpflichtungen beginnen 2023/24/25 und laufen sechs/fünf/vier Jahre bis 2028.

Die acht Fristzeilen trennen Flächen-/NATA-Angaben, Auftriebsliste/Übernahme, letzten tatsächlichen prämienfähigen Auftrieb, Planerstellung, Kurs und Antrag. Die ausdrücklich bereitgestellten Ausnahmejahre 2023/2028 sind in den entsprechenden April-/Juli-Zeilen separat geprüft; eine nicht bereitgestellte GSP-Feiertagsnorm wird nicht ergänzt. PSMBIO und PSMCS sind laut aktuellem MB nur bis 2025 anzugeben, ab 2026 entfällt diese Melderegel. Produktzulassung wird dadurch nicht bewiesen. Drei echte ausgeschlossene Nationalparks stehen neben den technischen Rollen `none` und `other`; weitere Park-/Einschränkungsqualifikationen bleiben vorgelagerte Sachverhalte. Die Mindestteilnahme 3 ha/3 RGVE ist betriebsbezogen im ersten Verpflichtungsjahr; die allgemeine Erstteilnahme 0,5 ha geschützter Anbau oder 1,5 ha Landwirtschaft ist eine andere Grenze.

Alle vier Modulationsbänder wurden wörtlich gebunden und frisch geprüft. Die korrekte Bandfunktion bestätigt nicht die operative Basis: Native summiert Einzelalmminima, während MB 13 das Minimum über den ganzen Betrieb beschreibt. Die materielle MAIN-Gegenprobe liegt im Allgemeinteil (PREM005). RohannahmeA-07s angebliches 230-ha/250-RGVE-Beispiel steht nicht im vollständig gelesenen aktuellen Maßnahmenblatt. Das tatsächlich vorhandene 250-ha-Beispiel ergibt 98 %; ein 230-ha-Sollwert wird nicht übernommen.

Die elf Kürzungsschritte werden exportiert und über einen Indexhelper bereitgestellt; das ist kein vollständiger Kürzungsmotor. Die neun Stufenzeilen bestehen aus der jahresgeteilten Warnung, sechs Prozentstufen und einer technischen Ausschluss-ID. `premium_total` liegt vor Inhaltskürzungen; eine Behördenstufe wird nicht aus Sachverhalten erfunden. Die Fremdtarife 194,4/162 € aus Maßnahme 21 gelten ab 2024. Deren Originalqualifikation betrifft tatsächlich für die Almprämie beantragte Tiere, während der native Bezug bloße Almaufenthalte heranzieht. Allgemeine Flächentoleranz und eigene jährliche Almflächenflexibilität werden getrennt gehalten. Die Dürremitteilung vom 22. Mai nennt ausgefallene Wasserversorgung als möglichen Einzelfall höherer Gewalt; ein eingereichter Antrag ist keine behördliche Anerkennung und keine automatische 60-Tage-Ausnahme.

## Frische Proben und ein echter RGVE-Befund

Alle **37 öffentlichen Quellenproben** wurden vollständig isoliert im tatsächlichen nativen Paket ausgeführt. Alle sind definiert; **34 Erwartungen sind erfüllt, drei nicht**. Die Proben prüfen vollständige Arrays/Tupel oder konkrete numerische/Boolesche Komponenten. Sie benutzen keine Stringarray-Regel-ID-Matcher. Wo eine Query sortiert, stammt die erwartete Reihenfolge aus extern deterministisch sortierten Originalmitgliedern. Historische Selbsttests, Modelloutputs, Studienfälle und private/expertische Fälle liefern keine Erwartungen.

Die drei Gegenproben behalten `rgve_category_id: null`:18 bekannte Klassen,22 Werte an elf Alterskanten und vier Zwergrassen. Native liefert jedes Mal `[]`, weil der direkte Kategoriepfad `null` zurückgibt und der `not`-Fallback dadurch nicht läuft. Alter und Größenklasse sind diagnostisch korrekt. Dies ist ein echter Verbraucherfehler bei einem ausdrücklich zulässigen Nullwert. Es handelt sich um dieselbe Null-RGVE-Familie wie die bis zur Hauptentscheidung belegten Domainfälle, keine zusätzliche unabhängige Fehlerfamilie.

Drei **zusätzliche**, getrennte Kontrollen lassen nur den optionalen Kategorieschlüssel fehlen. Dieselben bekannten Klassen, Queries und aus Quellen festgelegten Erwartungen bestehen dort vollständig. Die ursprünglichen Nullinputs und Sollwerte wurden nicht verändert. Die Erweiterung ist samt vorigem Teilehash dokumentiert; der übrige diagnostische Blick auf Alter/Größe/Kategorie ist kein zusätzlicher Quellenoracle. Es gab keine Input-, Query- oder Sollwertkorrektur. Drei reine Codeankerdarstellungen verloren führende Tabs, damit ihr gespeicherter Text dem strikten zeilenweisen Belegvergleich entspricht; das ist mit dem vorigen Teilehash vermerkt.

Die Typ-/Enumprüfung umfasst alle vorhandenen Felder in 37 Proben: **840 Skalarwerte,209 Objekte,186 Arrays**, darunter 95 ausdrücklich getrennt deklarierte Helperargumente. Es gibt **186 Enumvorkommen**, davon 180 eindeutige String-/Null-Tokens und **sechs Vorkommen mit offener numerischer Primitive**. Betroffen sind die beiden Deskriptoren `alms[].access_level` und `alms[].access_units[].access_level`: Die offizielle Grammatik legt `enum(1|2|3)` nicht auf JSON-Zahl oder String fest. Die nativen Zahlen sind als Komponenten-Konvention benannt. Es erfolgt keine Konvertierung und keine behauptete autoritative String-/Zahlfehlerbewertung. Die übrige Prüfung meldet keine Fehler. Sie bescheinigt weder Abwesenheitsvollständigkeit noch reale Registrierung, Genehmigung oder Tatsachenrichtigkeit.

## Bindung und Abschluss

Der isolierte Lauf verwendet OPA 1.18.2, SHA `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`, die tatsächlichen gebundenen Policy-/Datenverzeichnisse und einen erfolgreichen strikten Paketcheck. Netzfreigabe ist leer; `http.send`, `net.lookup_ip_addr`, `time.now_ns`, `uuid.rfc4122`, `rand.intn` und `opa.runtime` sind gesperrt. Evalgrenze 10 s, Prozessgrenze 20 s. Alle37 Fälle wurden im finalen vollständigen Replay in 4,310 s ausgeführt; langsamster Fall 0,166 s, keine Runtimefehler oder undefinierten Abfragen.

Der abschließende wörtliche Belegscan prüft 923 Zitatvorkommen mit 102 eindeutigen Quell-/Seiten-/Zitatbindungen und 60 Codeanker ohne Fehler. Er erlaubt nur Whitespace-/Soft-Hyphen-Normalisierung und nutzt, wenn erforderlich, die Layoutextraktion derselben Originalseite; keine Satzzeichenumschreibung oder Unicode-NFKC. Alle 47 Bindungshashes, 576 tatsächlichen Skalarwerte, 147 Zeilenwerte, fünf übrigen Metadaten und der wiederverwendete Matrixquellhash stimmen.

Die Probeprojektion aus `case_id`, `input`, `query` und `expectations` ist SHA `6ac128478b12154925b9176e544f638480d7a11e7b6bbb88dc2e5cf21db40b18`. Sie bleibt nach dem vollständigen Replay unverändert; spätere JSON-Ergänzungen dokumentieren nur Prüfung und Bindung. Tabellen-JSON-Freeze: `ec6aa1ca67095f0a20a0dd684835b33907ebefdffa037f77249feff565de24ee`. Gemeinsamer Root-Replay und unabhängige QA folgen. Dies ist eine öffentliche Quellen-/Verbraucherprüfung, keine private Genauigkeitsmessung und keine fachliche Expertenfreigabe.

Enge Navigationsrevision: Der Modulations-MAIN-Gegenfall ist dem Allgemeinteil (PREM005) zugeordnet. Die vorigen JSON-/MD-Freezehashes sind im JSON-Revisionsbeleg erhalten. Alle37 Inputs, Queries, Erwartungen und dokumentierten Ergebnisse bleiben unverändert; die Domainzuordnung der Null-RGVE-Familie bleibt bestehen.
