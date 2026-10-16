# o6_5 – Tierförderung, Haltedauer und Prämien: Quellenprüfung

Geprüft wurde ausschließlich der rohe historische Opus-Run `v2-o6_5-opus-5.5-high-20260925` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Der Maßnahmenteil umfasst **54 historische Katalogregeln, 41 Quellenabschnitte, sechs abgegrenzte Befunde und 48 frische öffentliche Entwicklungsproben**. Alle 48 OPA-Aufrufe endeten mit Exitcode 0. 42 Fälle erfüllen sämtliche Erwartungen; sechs Fälle zeigen jeweils eine unerfüllte Erwartung. Von insgesamt 54 Einzel-Erwartungen sind damit 48 erfüllt.

Vier Befunde betreffen konkrete zeitliche bzw. ereignisbezogene Quellenabdeckung. Ein weiterer betrifft ausschließlich die lokale Folgeprüfung einer Stuten-Abfohlfrist bei widersprüchlicher Sammelbestätigung. Der sechste prüft die App-Aufnahme widersprüchlicher Zeitangaben. Diese letzten beiden Fälle belegen keine unzulässige behördliche Auszahlung.

Das zehnseitige Originalmerkblatt wurde vollständig einschließlich aller Tabellen, Beispiele, Hinweise und Änderungen gelesen. `eligibility.rego`, `holding.rego` und `premium.rego` wurden vollständig mit allen Hilfsregeln und Verbrauchern geprüft; `common.rego`, `decision.rego` und `participation.rego` dienten zusätzlich dem Schnittstellenabgleich. Die sieben gemeinsamen Quellen wurden anhand identischer SHA-256-Werte an die frühere vollständige Lektüre gebunden. Einschlägige Klauseln wurden erneut gelesen, insbesondere SRL S. 52–53, ATB und der Tierabschnitt des Hinweises vom 12. August 2026. **GSP-AV gehört nicht zu den acht gelieferten Quellen dieses Runs** und wird ihm nicht rückwirkend als bereitgestellte Rechtsquelle zugerechnet.

Es wurden keine Studienfälle, Referenzlabels, GM-Antworten oder Sollwerte einer manuellen Adaptation verwendet. Historische Policies, Daten, Quellen und Profil wurden nicht verändert. Zusätzliche synthetische Katalog-IDs wurden nicht erfunden; `additional_source_rules` ist leer. Bereits vorhandene Regeln und die angrenzenden Dossiers tragen die festgestellten Quellenpflichten und externen Nachweise.

## Bindung und Reproduzierbarkeit

Die eingefrorene maschinenlesbare Fassung ist [measure.json](/workspace/scratch/opus-o6-1a-source-audit/docs/analysis/opus-run-review/measures/o6_5/measure.json). SHA-256: `a5e2fe6cf0e1f184bec692d6d9a18e788df6945e42bb04467850bf711f2fd4c6`. Sie enthält jede Bewertung, den Original-Katalogtext, tatsächliche Codezeilen, wörtliche Belege sowie vollständige Probe-Eingaben, Queries, Erwartungen und beobachtete OPA-Ausgaben. Alle **264 Beleg-Vorkommen** wurden nach Unicode-/Leerraumnormalisierung gegen die genaue Originalseite oder HTML-Datei gefunden; alle genannten Codezeilen liegen innerhalb des unveränderten Originalmoduls.

Für jede Probe wurden mit `/tmp/issue-51-review-opa` die unveränderten Originalverzeichnisse `workspace/policy` und `workspace/data` gemeinsam geladen. Der native Paketpfad ist `data.oepul.o6_5`, der Datenpfad `data.o6_5`. Eingaben, native Zahlen und Ergebnisse wurden nicht nachträglich normalisiert. Die Fehlermengen enthalten Tupel bzw. Strings; deshalb verwenden alle Erwartungen `equals` mit expliziten Zählabfragen, keine Matcher für `rule_id`-Objekte. Numerische Zählwerte 0/1 werden nicht als JSON-Booleans umgedeutet.

| Vollständig geprüftes Modul | Zeilen | SHA-256 |
| --- | ---: | --- |
| `eligibility.rego` | 254 | `bbc7b06320a088c509595b2f3fe27febea10f3aca668f4b0816e549572fcac2b` |
| `holding.rego` | 109 | `46caf65184fd6a33d17629a46113762ef5000cbd31157e58f91d2aa48c8ea16d` |
| `premium.rego` | 98 | `e272a048f0051f9f301bb9c60bb06da646b802d6676d202b0bb09a18d73d2073` |

| Gelieferte Quelle | Lektürebindung | SHA-256 |
| --- | --- | --- |
| [20241011_srl_oepul_2023.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023.pdf) | Identischer Hash zur früheren vollständigen Lektüre; einschlägiger Abgleich | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| [20241011_srl_oepul_2023_anhaenge.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf) | Identischer Hash zur früheren vollständigen Lektüre; einschlägiger Abgleich | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| [2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html) | Identischer Hash zur früheren vollständigen Lektüre; einschlägiger Abgleich | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| [2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html) | Identischer Hash zur früheren vollständigen Lektüre; einschlägiger Abgleich | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| [2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html) | Identischer Hash zur früheren vollständigen Lektüre; einschlägiger Abgleich | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| [2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html) | Identischer Hash zur früheren vollständigen Lektüre; einschlägiger Abgleich | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| [o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf) | Neu: alle 10 Seiten vollständig | `3a6df7cf48c357caa5fade68751bdbdb719e7d7ac7a7374cc4049dd7b50f152b` |
| [o6_allgemeine_teilnahmebedingungen_2026_04.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) | Identischer Hash zur früheren vollständigen Lektüre; einschlägiger Abgleich | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

## Befunde mit Quellenbindung

Die folgenden Sollwerte sind unabhängig aus den Originalquellen abgeleitete lokale Prüfziele. Ein nominaler Tierbetrag und `payout_eur` sind getrennte Rechenschritte; beide bleiben Modellberechnungen, keine Zahlungsanordnung. Aus einem beliebigen inhaltlichen oder meldebezogenen Verstoß wird keine automatische Kürzung um 100 % abgeleitet.

### O6_5-MEASURE-01: Ersatzhengst erreicht das Mindestalter erst nach der tatsächlichen Nachbesetzung

Ein am 15. April 2025 tatsächlich nachbesetzter Hengst wird erst am 31. Mai zwei Jahre alt. Die Quelle verlangt die Fördervoraussetzungen bereits zum tatsächlichen Ersatzzeitpunkt. `requirement_ref_ns` verwendet dagegen das Maximum aus Ersatzdatum und regulärem Stichtag. Die lokale Mindestalterprüfung meldet deshalb keinen Fehler (Ist 0, Soll 1). Der gleich alte Kontrollfall mit zweitem Geburtstag am 15. April wird richtig akzeptiert. Eine allgemeine Bestätigung kann mit den detaillierten Altersfakten kollidieren; daraus wird hier kein finaler Zahlungsanspruch abgeleitet.

Einordnung: `source_coverage_or_semantics`; Familie `TEMPORAL_SCOPE`; Code: `common.rego:68–74`, `eligibility.rego:125–137`.

SRL S. 52:

> Tiere zur Nachbesetzung (Ersatztiere) sind Tiere, die alle Förderverpflichtungen zum Zeitpunkt der Nachbesetzung erfüllen.

Merkblatt S. 4:

> Die nachbesetzten Tiere müssen ab dem Zeitpunkt der Nachbesetzung alle Förderverpflichtungen erfüllen.

Merkblatt S. 2:

> Zuchthengst bis spätestens am 31.05. des Teilnahmejahres 2 Jahre alt

Proben: `o6_5-replacement-stallion-too-young-at-replacement`, `o6_5-replacement-stallion-two-years-at-replacement`.

### O6_5-MEASURE-02: Januar-Nachbesetzung verliert die Ausnahme für das tatsächliche Zulassungsjahr

Der ursprüngliche Platz gehört zu 2025; der Ersatz-Eber wird innerhalb von 35 Tagen am 26. Januar 2026 tatsächlich eingesetzt, ist genau sechs Monate alt und 2026 zur Zucht zugelassen. Die Ausnahme vom jährlichen Zuchteinsatz bezieht sich nach der hier ausdrücklich verwendeten Ersatzzeitpunkt-Lesart auf sein tatsächliches Zulassungsjahr. Der native Verbraucher vergleicht weiter mit `farm.year = 2025` und verwirft das Tier lokal (Ist 0, Soll 1). Der Altersbezug wird bereits auf das spätere Ersatzdatum verschoben, der Zulassungsbezug nicht. Dies ist getrennt von der verkürzten Haltedauer eines Antrags für 2026.

Einordnung: `source_coverage_or_semantics`; Familie `TEMPORAL_SCOPE`; Code: `eligibility.rego:114–122`, `holding.rego:28–35`.

SRL S. 52:

> Tiere zur Nachbesetzung (Ersatztiere) sind Tiere, die alle Förderverpflichtungen zum Zeitpunkt der Nachbesetzung erfüllen.

Merkblatt S. 4:

> Die Frist gilt auch über den 31. Dezember eines Teilnahmejahres hinaus.

Merkblatt S. 2:

> jährlicher Zuchteinsatz im Rahmen des Zuchtprogramms, ausgenommen im Jahr der Zulassung zur Zucht;

Proben: `o6_5-replacement-next-year-breeding-approval`.

### O6_5-MEASURE-03: Dritte rechtzeitige Nachbesetzung kann den ursprünglichen Förderplatz nicht erhalten

Auf das Original folgen drei tatsächlich eingesetzte, jeweils förderfähige Tiere derselben Rasse, jedes einen Tag nach dem Vorgängerabgang. Nur das letzte bleibt bis zum Ende der Haltedauer. Die Quelle enthält keine Begrenzung auf zwei aufeinanderfolgende Ersatztierwechsel. Die nativ offengelegte technische Grenze A13 berücksichtigt nur zwei Ebenen: Mit zwei Ersatzwechseln bleibt ein Förderplatz erhalten, mit drei ist die Anzahl fälschlich 0 statt 1.

Einordnung: `source_coverage_or_semantics`; Familie `EVENT_SEMANTICS`; Code: `holding.rego:40–66`, `holding.rego:77–87`.

Merkblatt S. 4:

> Innerhalb von 5 Wochen müssen abgegangene Pferde, Schafe, Ziegen oder Schweine mit förderbaren Tieren der gleichen Rasse (Ersatztiere) nachbesetzt werden.

Merkblatt S. 4:

> förderbaren Tieren der gleichen Rasse (Ersatztiere) nachbesetzt werden.

SRL S. 52:

> Tiere zur Nachbesetzung (Ersatztiere) sind Tiere, die alle Förderverpflichtungen zum Zeitpunkt der Nachbesetzung erfüllen.

Proben: `o6_5-replacement-chain-2`, `o6_5-replacement-chain-3`.

### O6_5-MEASURE-04: Vollständig vorjährige Abwesenheit wird in die aktuelle Haltedauer einbezogen

Ein langer, 2024 vollständig abgeschlossener Zuchtstationsaufenthalt sperrt ein ansonsten im Jahr 2025 korrekt gehaltenes Tier. Die Weitergaberegel gilt während der jeweiligen Haltedauer; die Implementierung prüft jedoch alle gespeicherten Abwesenheiten ohne zeitlichen Überschneidungsfilter (lokale Fehlerzahl Ist 1, Soll 0). Die positiven aktuellen Kontrollen bleiben korrekt: sechs Kalendermonate zulässig, ein zusätzlicher Tag unzulässig. Über einen gesonderten Vorjahresverstoß oder dessen Sanktion wird keine Aussage getroffen.

Einordnung: `source_coverage_or_semantics`; Familie `TEMPORAL_SCOPE`; Code: `eligibility.rego:204–240`.

SRL S. 53:

> Weitergabe von Tieren während der Haltedauer ist nur zulässig als vorübergehender

Merkblatt S. 5:

> Die Weitergabe von Tieren während der Haltedauer ist bei einem vorübergehenden Aufenthalt der Tiere auf einer Zuchtstation für Züchtungszwecke maximal 6 Monate zulässig.

Proben: `o6_5-absence-six-months`, `o6_5-absence-six-months-one-day`, `o6_5-absence-entirely-previous-year`.

### O6_5-MEASURE-05: Fortlaufende Abfohlfrist erhält nach dem 31. Mai keine lokale Folgeprüfung

Für einen ausdrücklich abgeschlossenen Jahresfall ist die letzte Abfohlung bis 31. Dezember 2025 bekannt: 15. Dezember 2021. Nach dem 15. Juni 2025 erfolgt keine weitere Abfohlung. Die separate Frist von 3,5 Jahren ist damit im beobachteten Jahr verstrichen; die native A06-Stichtagsauslegung prüft aber nur den 31. Mai und meldet keinen lokalen Folgefehler (Ist 0, Soll 1). Der zugleich gesetzte Sammelstatus `confirmed` widerspricht den abgeschlossenen Detailfakten und muss fachlich geklärt werden. Der Fall belegt eine fehlende lokale Intervallabdeckung, keine bereits bewiesene unzulässige Gesamtzahlung. Ein noch offener zukünftiger Termin wird nicht als versäumt behandelt.

Einordnung: `source_local_obligation_coverage`; Familie `TEMPORAL_SCOPE`; Code: `eligibility.rego:73–87`.

Merkblatt S. 2:

> weitere Abfohlung spätestens innerhalb von 3,5 Jahren nach der letzten Abfohlung

Merkblatt S. 1:

> Kalenderjahr (1. Jänner bis 31. Dezember).

ATB S. 10:

> Förderfähig sind nur Flächen, Tiere oder andere Einheiten, für die während der gesamten

Proben: `o6_5-mare-foaling-deadline-later-in-completed-year`.

### O6_5-MEASURE-06: Widersprüchliche tatsächliche Ankunft und behauptete Nachbesetzung bleiben ungeklärt

Ein Ersatzdatum am 15. Mai und ein ausdrücklich erst am 1. Juli erfolgter tatsächlicher Zugang widersprechen einander. Der native Verbraucher übernimmt das Ersatzdatum und überspringt die ursprüngliche Ankunftsprüfung für Ersatztiere; er weist einen Förderplatz aus. Die aktuelle App-Aufnahme sollte bis zur Auflösung des Widerspruchs keine positive Entscheidung zulassen (diagnostischer Sollwert 0). Das ist ein gesonderter Eingabe-/Nachweiskonsistenzfall, kein normales Rechtsoracle, das willkürlich eine der Angaben zur Wahrheit erklärt. Ein bereits früher gehaltener, bisher nicht beantragter Ersatz darf den Förderplatz erst später übernehmen: Der entsprechende Kontrollfall wird richtig akzeptiert; Gleichheit der Daten wird nicht verlangt.

Einordnung: `app_input_consistency_contract`; Familie `EVENT_SEMANTICS`; Code: `eligibility.rego:188–201`, `holding.rego:28–35`.

Merkblatt S. 4:

> Die nachbesetzten Tiere müssen ab dem Zeitpunkt der Nachbesetzung alle Förderverpflichtungen erfüllen.

SRL S. 52:

> Tiere zur Nachbesetzung (Ersatztiere) sind Tiere, die alle Förderverpflichtungen zum Zeitpunkt der Nachbesetzung erfüllen.

Proben: `o6_5-replacement-arrival-inconsistent-evidence`, `o6_5-replacement-earlier-arrival-valid-control`.

## Korrekte Umsetzungen und verbleibende Auslegungsgrenzen

Positiv bestätigt sind die tatsächliche Verknüpfung von Kategorie und Rassen-Tierart, die ausdrücklich verlangten Reinrassigkeits-/Zuchtbuch-/Programm-/Inlandsmerkmale, die normalen Alters- und Erstabfohlgrenzen sowie die strikte Schwelle „älter als fünf Jahre“. Die 2026-Verkürzung wird tatsächlich bis einschließlich 31. August verbraucht; sie hebt die gesonderten Tierbewegungsmeldungen bis Jahresende nicht auf. Nachbesetzungen erzeugen keinen zweiten beantragten Förderplatz.

Die expliziten Prämienbeispiele für weiblich → männlich und Milchleistungskontrolle → ohne Milchleistungskontrolle funktionieren. Eine vorausgesetzte behördliche Kürzungsstufe und die Betriebsgrößenmodulation werden tatsächlich in der Rechnung verwendet: Beim Kontrollfall mit 220 ha bleiben 218 gewichtete Hektar; 64,80 Euro ergeben nach vorgegebener 50-%-Kürzung und Modulation 32,11 Euro. Die Verwarnungskontrolle wirkt 2026 mit 0 %, 2027 mit 1 %. Der 50-Euro-Fall bleibt ein Ermessenshinweis und wird nicht automatisch auf null gesetzt. Flächenbezogene Hektarobergrenzen werden zutreffend nicht auf eine Tierprämie angewandt.

Offen bzw. extern bleiben insbesondere die Reihenfolge gegenüber bloßer 50-%-Quote bei „mindestens jeder zweite Wurf“ (A05), die Verallgemeinerung des niedrigeren Ersatz-Prämienbetrags auf alle Wechselrichtungen (A14), die konkrete Folgenbewertung verspäteter Meldungen (A15/A17), die Zählkonvention für kurze Aufenthalte (A16), die administrative Schwerefeststellung (A25) und tatsächliche Sonderprogramm-/Bestätigungsnachweise (A31/A32). Diese Grenzen werden nicht durch erfundene negative Sollwerte geschlossen. Tabellen prüft den eigenständigen GEP-Umsetzungsbefund und die konditionalen Anhang-D-Pflichten; Inputs prüft fehlende/null Nachweise; General prüft Teilnahme- und Meldeverfahren; Root prüft Identitäten und Gesamtentscheidung.

## Vollständiger Maßnahmen-Regelledger

54 echte historische IDs: **30 umgesetzt, 20 teilweise, zwei externe Evidenz, zwei offene Auslegungen**. „Umgesetzt“ bewertet den beschriebenen Verbraucher innerhalb seines dokumentierten Eingabevertrags, nicht die tatsächliche Existenz eines Nachweisdokuments. Die Einzelbegründung und die wörtlichen Belege jeder Zeile stehen unverändert in JSON.

| Historische Katalog-ID | Bewertung | Tatsächlicher Code | Originalquellen |
| --- | --- | --- | --- |
| `O6_5-SCOPE-PREMIUM-PER-ANIMAL` | umgesetzt | `holding.rego:73–109`, `premium.rego:38–43` | Merkblatt S. 1 |
| `O6_5-DEF-STICHTAG` | teilweise | `eligibility.rego:51–152`, `common.rego:68–74` | SRL S. 52, Merkblatt S. 4 |
| `O6_5-DEF-GEP` | externe Evidenz | `premium.rego:25–28` | Merkblatt S. 5 |
| `O6_5-DEF-PASTURE-NOT-DEPARTURE` | umgesetzt | `eligibility.rego:213–217` | Merkblatt S. 4 |
| `O6_5-ELIG-UNKNOWN-CATEGORY` | umgesetzt | `eligibility.rego:9–12` | Merkblatt S. 2, Merkblatt S. 7 |
| `O6_5-ELIG-BREED-LIST` | umgesetzt | `eligibility.rego:15–23` | Merkblatt S. 2 |
| `O6_5-ELIG-PUREBRED-HERDBOOK` | umgesetzt | `eligibility.rego:27–36` | Merkblatt S. 2 |
| `O6_5-ELIG-REGULAR-BREEDING` | umgesetzt | `eligibility.rego:39–42` | Merkblatt S. 2 |
| `O6_5-ELIG-FEMALE-PUREBRED-MATING` | teilweise | `eligibility.rego:45–49` | Merkblatt S. 2 |
| `O6_5-ELIG-FIRST-BIRTH-STICHTAG` | umgesetzt | `eligibility.rego:51–64` | Merkblatt S. 2, SRL S. 52 |
| `O6_5-ELIG-MARE-FOALING` | umgesetzt | `eligibility.rego:66–70` | Merkblatt S. 2 |
| `O6_5-ELIG-MARE-REFOALING` | teilweise | `eligibility.rego:73–87` | Merkblatt S. 2, Merkblatt S. 1, ATB S. 10 |
| `O6_5-ELIG-SOW-PUREBRED-FARROWING` | umgesetzt | `eligibility.rego:90–94` | Merkblatt S. 2 |
| `O6_5-ELIG-SOW-LITTER-SHARE` | Auslegung offen | `eligibility.rego:97–111` | Merkblatt S. 2 |
| `O6_5-ELIG-MALE-ANNUAL-BREEDING` | teilweise | `eligibility.rego:114–122` | Merkblatt S. 2, SRL S. 52 |
| `O6_5-ELIG-MALE-MIN-AGE` | umgesetzt | `eligibility.rego:125–137` | Merkblatt S. 2, SRL S. 52 |
| `O6_5-ELIG-STALLION-MIN-AGE` | teilweise | `eligibility.rego:125–137`, `common.rego:68–74` | Merkblatt S. 2, SRL S. 52 |
| `O6_5-ELIG-STALLION-OFFSPRING` | umgesetzt | `eligibility.rego:141–152` | Merkblatt S. 2 |
| `O6_5-GEN-ANIMALS-IN-AUSTRIA` | umgesetzt | `eligibility.rego:155–158` | ATB S. 9 |
| `O6_5-OBL-HOLDING-PERIOD` | teilweise | `eligibility.rego:188–201`, `holding.rego:9–14`, `holding.rego:28–66` | Merkblatt S. 3, Merkblatt S. 4 |
| `O6_5-OBL-BREEDING-ORG-CONFIRMATION` | teilweise | `eligibility.rego:161–176` | Merkblatt S. 3 |
| `O6_5-OBL-CONFIRMATION-SCOPE` | externe Evidenz | `eligibility.rego:161–176`, `premium.rego:30–34` | Merkblatt S. 3 |
| `O6_5-OBL-REPLACEMENT-5-WEEKS` | teilweise | `holding.rego:26–87` | Merkblatt S. 4, SRL S. 52 |
| `O6_5-OBL-TRANSFER-LIMITS` | teilweise | `eligibility.rego:204–240` | SRL S. 53, Merkblatt S. 5 |
| `O6_5-OBL-TRANSFER-BREEDING-STATION-6M` | umgesetzt | `eligibility.rego:219–223` | Merkblatt S. 5 |
| `O6_5-OBL-TRANSFER-MALE-BREEDING-3M` | umgesetzt | `eligibility.rego:226–231` | Merkblatt S. 5 |
| `O6_5-OBL-SHORT-ABSENCE-10-DAYS` | teilweise | `eligibility.rego:234–240` | Merkblatt S. 5 |
| `O6_5-OBL-CATTLE-TRANSFER-AFTER-0930` | umgesetzt | `holding.rego:9–24` | Merkblatt S. 5, Hinweis 2026-08-12 |
| `O6_5-REP-REPLACEMENT-7-DAYS` | teilweise | `holding.rego:28–38` | Merkblatt S. 4 |
| `O6_5-REP-PRIOR-TRANSFER-REPORT` | teilweise | `eligibility.rego:204–240` | SRL S. 53 |
| `O6_5-PREM-RATES` | umgesetzt | `premium.rego:9–23`, `eligibility.rego:243–247` | Merkblatt S. 7, Merkblatt S. 8 |
| `O6_5-PREM-RATES-PERIOD` | umgesetzt | `premium.rego:9–17` | Merkblatt S. 7 |
| `O6_5-PREM-STAGE-ASSIGNMENT` | umgesetzt | `premium.rego:20–23`, `eligibility.rego:15–23` | Merkblatt S. 8 |
| `O6_5-PREM-GEP-SURCHARGE` | teilweise | `premium.rego:25–28` | Merkblatt S. 5 |
| `O6_5-PREM-MLK-SURCHARGE` | umgesetzt | `premium.rego:30–34`, `holding.rego:100–102` | Merkblatt S. 7, Merkblatt S. 3, Merkblatt S. 4 |
| `O6_5-PREM-SURCHARGES-AUTOMATIC` | teilweise | `premium.rego:25–39` | Merkblatt S. 6, Merkblatt S. 5 |
| `O6_5-PREM-REPLACEMENT-LOWER-PREMIUM` | Auslegung offen | `holding.rego:77–102` | Merkblatt S. 4 |
| `O6_5-PREM-TOTAL` | umgesetzt | `holding.rego:73–109`, `premium.rego:41–43` | Merkblatt S. 1 |
| `O6_5-MIN-PARTICIPATION` | umgesetzt | `holding.rego:104–109` | Merkblatt S. 1 |
| `O6_5-CON-ONE-YEAR` | teilweise | `holding.rego:9–14`, `eligibility.rego:73–87` | Merkblatt S. 1, Merkblatt S. 3 |
| `O6_5-APP-INDIVIDUAL-MFA` | umgesetzt | `eligibility.rego:179–184` | Merkblatt S. 6 |
| `O6_5-APP-NO-ADVANCE-REPLACEMENT` | teilweise | `holding.rego:73–75` | Merkblatt S. 6 |
| `O6_5-APP-CATTLE-AUTO` | umgesetzt | `eligibility.rego:179–184` | Merkblatt S. 6 |
| `O6_5-GEN-ACCESS-NONCOMPLIANCE-NO-CONTRACT` | umgesetzt | `premium.rego:84–88` | SRL S. 24 |
| `O6_5-GEN-ANNUAL-PREMIUM` | umgesetzt | `premium.rego:41–43`, `premium.rego:84–98` | SRL S. 16 |
| `O6_5-GEN-PAYMENT-TIMING` | teilweise | `premium.rego:95–98` | SRL S. 22 |
| `O6_5-GEN-SMALL-AMOUNT` | umgesetzt | `premium.rego:90–93` | SRL S. 22 |
| `O6_5-GEN-MODULATION` | umgesetzt | `premium.rego:67–82` | ATB S. 19 |
| `O6_5-GEN-SANCTION-STAGES` | teilweise | `premium.rego:45–82` | ATB S. 18 |
| `O6_5-GEN-SANCTION-2027-RETENTION` | umgesetzt | `premium.rego:59–66` | ATB S. 18 |
| `O6_5-GEN-EXCLUSION-TWO-100` | teilweise | `premium.rego:51–66` | ATB S. 18 |
| `O6_5-GEN-MULTIPLE-REDUCTION-ORDER` | teilweise | `premium.rego:80–88` | SRL S. 25 |
| `O6_5-GEN-AREA-CAPS-NOT-APPLICABLE` | umgesetzt | `premium.rego:38–88` | ATB S. 19, Merkblatt S. 1 |
| `O6_5-2026-HOLDING-PERIOD-AUG31` | umgesetzt | `common.rego:42–56`, `holding.rego:9–14` | Hinweis 2026-08-12 |

## Quellenabschnitte und Vollständigkeit

Alle Seiten des neuen Merkblatts sind erfasst. Reine Informations-/Änderungshinweise werden als Kontext bezeichnet; angrenzende Zuständigkeit wird ausdrücklich angegeben. Ein Quellenabschnitt kann mehrere Katalogregeln enthalten. Die vollständige Quellenmatrix umfasst 41 Zeilen.

| Abschnitt | Seiten | Prüfung/Abdeckung | Status |
| --- | --- | --- | --- |
| `MB1-scope` | 1 | 1 overview/2 goal | geprüft |
| `MB1-contract` | 1 | 3.1 annual contract/renewal/lapse | im zuständigen Teil geprüft |
| `MB1-minimum` | 1 | 3.2 one eligible animal yearly | geprüft |
| `MB2-breed` | 2 | 3.3 breed/purebred/program conditions | geprüft |
| `MB2-female` | 2 | Female regular use/purebred mating | teilweise |
| `MB2-firstbirth` | 2 | Cow/ewe/goat 1 April first birth | geprüft |
| `MB2-mare` | 2 | Mare first foal/subsequent 3.5 year interval | teilweise |
| `MB2-sow` | 2 | Sow first purebred litter/every second litter | Auslegung offen |
| `MB2-male` | 2 | Male regular/annual use/approval exception/ages | teilweise |
| `MB2-stallion` | 2 | Stallion 2 years/older than 5/live offspring 2 years | teilweise |
| `MB3-holding` | 3 | 4.1 holding 1 April–31 December inclusive | teilweise |
| `MB3-VIS` | 3 | 4.2 VIS/equine identification/database/responsibility | im zuständigen Teil geprüft |
| `MB3-confirm` | 3 | 4.3 responsible organization/deadline/scope/milk/eAMA | teilweise |
| `MB3-4-depart` | 3 | 4.4 departure report 7 days/correction | im zuständigen Teil geprüft |
| `MB4-pasture` | 4 | 4.4 temporary pasture/control/not departure | geprüft |
| `MB4-replacement` | 4 | 4.5 same breed 5 weeks/beyond year/conditions from replacement | teilweise |
| `MB4-replacement-report` | 4 | 4.5 report 7 days/database/example | im zuständigen Teil geprüft |
| `MB4-lower` | 4 | 4.5 lower premium examples | Auslegung offen |
| `MB5-transfers` | 5 | 4.6 station 6 months/male breeding 3 months/prior report | teilweise |
| `MB5-short` | 5 | 4.6 documented 10 day absence/open examples | teilweise |
| `MB5-cattle` | 5 | 4.6 after 30 September/no export/death/slaughter/receiver/database | geprüft |
| `MB5-GEP` | 5 | 4.7 special program/Annex D/actual implementation | teilweise |
| `MB5-6-application` | 6 | 5 application/last entry/individual/MFA/UELN/no advance/cattle/automatic/lapse | im zuständigen Teil geprüft |
| `MB6-7-exit` | 7 | 6 exit/full-year/deregistration warning | im zuständigen Teil geprüft |
| `MB7-rates` | 7 | 7 complete cattle/horse/sheep/goat rate rows | geprüft |
| `MB8-pigrates` | 8 | 7 pig rates/assignment | geprüft |
| `MB8-breeds` | 8 | 8 cattle 9/horse 1 breed rows | im zuständigen Teil geprüft |
| `MB9-breeds` | 9 | 8 sheep 8/goat 7/pig 2 breed rows | im zuständigen Teil geprüft |
| `MB10-update` | 10 | 9 updates/impressum/disclaimer | Kontext |
| `SRL52` | 52 | 2.5 full definitions/category table/access | teilweise |
| `SRL53` | 53 | 2.5 all obligations/rate table | teilweise |
| `AT9` | 9 | Austrian animal holding | geprüft |
| `AT10` | 10 | Full commitment-period conditions | teilweise |
| `AT18` | 18 | Sanctions/warning/payment | teilweise |
| `AT19` | 19 | Farm modulation/area-payment caps | geprüft |
| `SRL22` | 22 | Payment/advance/minimum | teilweise |
| `SRL25` | 25 | Reduction order | teilweise |
| `NOTICE0812` | HTML | 2026 animal holding 31 August/movement reports/year-end | geprüft |
| `NOTICE-2026-05-22` | HTML | Prior full main-content reading reused by exact hash. No unrelated biodiversity/arable/cicada exception is invented for animal eligibility. General peer covers applicable general force-majeure procedure; missing September 2 full notice is not synthesized from a teaser. | im zuständigen Teil geprüft |
| `NOTICE-2026-06-12` | HTML | Prior full main-content reading reused by exact hash. No unrelated biodiversity/arable/cicada exception is invented for animal eligibility. General peer covers applicable general force-majeure procedure; missing September 2 full notice is not synthesized from a teaser. | im zuständigen Teil geprüft |
| `NOTICE-2026-08-05` | HTML | Prior full main-content reading reused by exact hash. No unrelated biodiversity/arable/cicada exception is invented for animal eligibility. General peer covers applicable general force-majeure procedure; missing September 2 full notice is not synthesized from a teaser. | im zuständigen Teil geprüft |

## Frische Entwicklungsproben

Jede Zeile hat genau einen OPA-Aufruf. Zusammengesetzte Betragskontrollen enthalten mehrere Erwartungen. Alle Erwartungen verwenden `equals`; Quellenbelege und Interpretationsgrenzen sind an jede Probe gebunden. Die 42 vollständig erfüllten Fälle enthalten positive und negative Quellenkontrollen. Die sechs unerfüllten Zeilen sind die oben beschriebenen diagnostischen Gegenfälle.

| Fall-ID | Erwartung(en) | Beobachtung | Ergebnis |
| --- | --- | --- | --- |
| `o6_5-age-zuchtstier-exact` | `$ = 0` | `0` | erfüllt |
| `o6_5-age-zuchtstier-one-day-young` | `$ = 1` | `1` | erfüllt |
| `o6_5-age-zuchtwidder-exact` | `$ = 0` | `0` | erfüllt |
| `o6_5-age-zuchtwidder-one-day-young` | `$ = 1` | `1` | erfüllt |
| `o6_5-age-zuchtbock-exact` | `$ = 0` | `0` | erfüllt |
| `o6_5-age-zuchtbock-one-day-young` | `$ = 1` | `1` | erfüllt |
| `o6_5-age-zuchteber-exact` | `$ = 0` | `0` | erfüllt |
| `o6_5-age-zuchteber-one-day-young` | `$ = 1` | `1` | erfüllt |
| `o6_5-age-zuchthengst-exact` | `$ = 0` | `0` | erfüllt |
| `o6_5-age-zuchthengst-one-day-young` | `$ = 1` | `1` | erfüllt |
| `o6_5-first-birth-mutterziege-04-01` | `$ = 0` | `0` | erfüllt |
| `o6_5-first-birth-mutterziege-04-02` | `$ = 1` | `1` | erfüllt |
| `o6_5-first-birth-stute-05-31` | `$ = 0` | `0` | erfüllt |
| `o6_5-first-birth-stute-06-01` | `$ = 1` | `1` | erfüllt |
| `o6_5-stallion-exactly-five` | `$ = 0` | `0` | erfüllt |
| `o6_5-stallion-older-without-offspring` | `$ = 1` | `1` | erfüllt |
| `o6_5-stallion-older-with-offspring` | `$ = 0` | `0` | erfüllt |
| `o6_5-annual-breeding-approval-2025` | `$ = 0` | `0` | erfüllt |
| `o6_5-annual-breeding-approval-2024` | `$ = 1` | `1` | erfüllt |
| `o6_5-sow-litter-4-of-four` | `$ = 0` | `0` | erfüllt |
| `o6_5-sow-litter-1-of-four` | `$ = 1` | `1` | erfüllt |
| `o6_5-replacement-stallion-too-young-at-replacement` | `$ = 1` | `0` | unerfüllt; oben abgegrenzt |
| `o6_5-replacement-stallion-two-years-at-replacement` | `$ = 0` | `0` | erfüllt |
| `o6_5-replacement-next-year-breeding-approval` | `$ = 1` | `0` | unerfüllt; oben abgegrenzt |
| `o6_5-mare-foaling-deadline-later-in-completed-year` | `$ = 1` | `0` | unerfüllt; oben abgegrenzt |
| `o6_5-absence-six-months` | `$ = 0` | `0` | erfüllt |
| `o6_5-absence-six-months-one-day` | `$ = 1` | `1` | erfüllt |
| `o6_5-absence-entirely-previous-year` | `$ = 0` | `1` | unerfüllt; oben abgegrenzt |
| `o6_5-holding-end-2025-12-31` | `$ = 0` | `0` | erfüllt |
| `o6_5-holding-end-2026-01-01` | `$ = 1` | `1` | erfüllt |
| `o6_5-holding-end-2026-08-31` | `$ = 0` | `0` | erfüllt |
| `o6_5-holding-end-2026-09-01` | `$ = 1` | `1` | erfüllt |
| `o6_5-cattle-transfer-09-30-false` | `$ = 0` | `0` | erfüllt |
| `o6_5-cattle-transfer-10-01-false` | `$ = 1` | `1` | erfüllt |
| `o6_5-cattle-transfer-10-01-true` | `$ = 0` | `0` | erfüllt |
| `o6_5-replacement-window-2026-01-26` | `$ = 1` | `1` | erfüllt |
| `o6_5-replacement-window-2026-01-27` | `$ = 0` | `0` | erfüllt |
| `o6_5-replacement-chain-2` | `$ = 1` | `1` | erfüllt |
| `o6_5-replacement-chain-3` | `$ = 1` | `0` | unerfüllt; oben abgegrenzt |
| `o6_5-replacement-arrival-inconsistent-evidence` | `$ = 0` | `1` | unerfüllt; oben abgegrenzt |
| `o6_5-replacement-lower-premium-milk-to-no-milk` | `$ = 248.4` | `248.4` | erfüllt |
| `o6_5-replacement-lower-premium-female-to-male` | `$ = 248.4` | `248.4` | erfüllt |
| `o6_5-warning-2026` | `reduction = 0, payout = 64.8` | `{"payout": 64.8, "reduction": 0}` | erfüllt |
| `o6_5-warning-2027` | `reduction = 1, payout = 64.15` | `{"payout": 64.15, "reduction": 1}` | erfüllt |
| `o6_5-sanction-before-modulation-control` | `raw = 64.8, modulated_equivalent_ha = 218, payout = 32.11` | `{"modulated_equivalent_ha": 218, "payout": 32.11, "raw": 64.8}` | erfüllt |
| `o6_5-two-full-reductions-control` | `reduction = 100, payout = 0` | `{"payout": 0, "reduction": 100}` | erfüllt |
| `o6_5-fifty-euro-discretion-control` | `payout = 50, waiver_count = 1` | `{"payout": 50, "waiver_count": 1}` | erfüllt |
| `o6_5-replacement-earlier-arrival-valid-control` | `$ = 1` | `1` | erfüllt |

Nicht enthalten sind Aussagen über die Qualität der noch nicht geprüften Opus-Runs. Dieser Teil ist eine abgeschlossene Audit-Sammlung für o6_5; Integration, Gesamt-Replay und unabhängiger Schluss-QC liegen bei Root. Es wurden keine fachlichen Policies repariert.
