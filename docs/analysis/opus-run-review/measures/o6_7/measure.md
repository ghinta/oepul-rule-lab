# o6_7 – System Immergrün: Zwischenfrüchte und tägliche Begrünung

Geprüft wurde ausschließlich der rohe historische Opus-Run `v2-o6_7-opus-5.5-high-20260925` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieser Maßnahmenteil enthält **52 historische Regelbewertungen, 51 Quellenabschnitte, sechs abgegrenzte Befunde und 98 neu abgeleitete öffentliche Quellen- und Grenzfälle**. Alle 98 Aufrufe liefern mit strikt geprüften Builtins und Exitcode 0 einen definierten Wert: **92 Erwartungen erfüllt, sechs nicht erfüllt**.

Vier Gegenfälle betreffen konkrete lokale Grenzen: eine vollständig beobachtete Lücke am Jahresende, die überdehnte Dürreausnahme bei einer Erneuerung, eine durch Rundung verlorene Überschreitung von 15 % und eine Pflegemahd am tatsächlichen Anlagetag. Zwei weitere Gegenfälle bleiben ausdrücklich qualifizierte Auslegungsproben: die Anwendung des 41-Tage-Beispiels auf eine kurze äußere Hauptfruchtlücke und widersprüchliche Aussagen zum Walzen. Die sechs nicht erfüllten Erwartungen werden deshalb nicht pauschal als sechs abschließend bewiesene Rechtsverstöße gewertet. Eine lokale Diagnose oder rechnerische Flächenquote legt auch keine bestimmte Geldsanktion oder behördliche Auszahlung fest.

Das neue Merkblatt wurde **auf allen elf Seiten vollständig gelesen**, einschließlich jeder Tabelle, sämtlicher 40-/41-Tage-Beispiele, Vorvertragswarnungen, Pflege-/Frost-/Methodenbedingungen, Antrags- und Ausstiegsregeln, Änderungshinweise sowie Impressum und Schlussdisclaimer. Vollständig gelesen wurden `catch_crop.rego` und `greening.rego`, die tatsächlichen Helfer und Verbraucher sowie die ursprünglichen 17 Annahmen mit allen offenen Fragen und dem Eingabemodell. Die acht Manifestquellen bestimmen die Bewertung. Sieben gemeinsame Quellen wurden anhand identischer Hashes an frühere vollständige Lektüren gebunden; SRL S. 57–58 wurden erneut vollständig und die einschlägigen Klauseln auf SRL S. 75, ATB S. 3–4 sowie die gelieferten Augusthinweise erneut gelesen. **GSP-AV ist in diesem Run nicht geliefert.**

Studienlabels, Referenzantworten, GM-Urteile, originale Selbsttests und manuelle Adaptationstest-Sollwerte wurden nicht als Orakel benutzt. Historische Policies, Profil und Quellen bleiben unverändert. Zusätzliche synthetische Regel-IDs wurden nicht in die Katalogabdeckung eingefügt; weitere Quellbedingungen sind den tatsächlichen historischen IDs oder ausdrücklich benannten Nachbarteilen zugeordnet.

## Eingefrorene Bindung und Ausführung

Die vollständigen Bewertungen, wortgetreuen Belege, Eingaben, Queries, Erwartungen und beobachteten Werte stehen in [measure.json](/workspace/scratch/opus-o6-1a-source-audit/docs/analysis/opus-run-review/measures/o6_7/measure.json). Eingefrorener SHA-256: `ff078aa685e57509667534f91d22d75426a881d2936e4ceab2552ecf94092cba`. Alle **452 Belegvorkommen** wurden nach Unicode- und Leerraumnormalisierung auf der genauen Originalseite beziehungsweise in der gelieferten HTML-Datei gefunden. Sämtliche Code- und numerischen PDF-Seitenspannen liegen innerhalb der unveränderten Originaldateien; die ATB hat tatsächlich 21 Seiten.

Die Proben laden mit `/tmp/issue-51-review-opa` und `--strict-builtin-errors` jeweils die vollständigen nativen Verzeichnisse `workspace/policy` und `workspace/data`. Ausführende Regelpakete sind **`data.o6_7.*`**, statische Tabellen liegen unter **`data.oepul.o6_7`**. Es gibt keine Dateiabflachung, Namespacekorrektur, Typkonvertierung oder Zahlennormalisierung. Alle 98 Erwartungen verwenden `equals` auf expliziten Zahlen oder Booleans. String-/Tupelmengen werden nicht als Arrays aus Regelobjekten behandelt; numerische 0/1-Werte bleiben Zahlen.

Die neu verfassten Eingaben wurden vor dem Replay auf eine konsistente tatsächliche Chronologie geprüft: Hauptfruchternte und Untersaatbeginn stimmen überein, Haupt-/Zwischenfruchtintervalle überlappen nicht und doppelt hinterlegte Folgesaatdaten stimmen mit dem tatsächlichen Hauptfruchtsegment überein. Das bearbeitet ausschließlich die neu abgeleiteten Entwicklungsfälle. Der ausdrücklich als Eingabekonsistenzdiagnose markierte Bodenbearbeitungsfall ist kein gewöhnliches Rechts- oder Zahlungsoracle. Unbekannte Zukunft wird nicht als nachweislich versäumte Anlage behandelt.

| Vollständig gelesenes Modul | Zeilen | SHA-256 |
| --- | ---: | --- |
| [catch_crop.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego) | 372 | `d8941c1de83192878b262e499ce6758969e9ebc3e151670176ecf731e6e081cd` |
| [greening.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego) | 244 | `100c663f1e306b9cb661db42419244569728ae7b965cad4bc07b2be37dc5e880` |
| [lib.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/lib.rego) | 64 | `16eb9e6e07cd76129e44c36ddd8d75ffee265d8a24b1f7eb07e299d2ad6e0e54` |
| [main.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/main.rego) | 32 | `5da49df786f221c6639f40e9b8c1dcbc57f5b58d610e641707c5906b613b53ef` |
| [eligibility.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/eligibility.rego) | 161 | `88bf46a820ed65116ad75f43ff674238f3445cfa37a201307f59f6649f84d9d8` |
| [premium.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/premium.rego) | 178 | `49ec691cded44e7537f2618723df3882d6781b521be2c6053d435abe3594eecc` |

| Gebundene Quelle | Lektürebindung | SHA-256 |
| --- | --- | --- |
| [20241011_srl_oepul_2023.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich (94 Seiten) | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| [20241011_srl_oepul_2023_anhaenge.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich (103 Seiten) | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| [2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| [2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| [2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| [2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| [o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf) | Neu: alle elf Seiten vollständig | `ec88c013768e73337a093aa3bf6241470462ad1aba26f79fd52f71137ac0aa8f` |
| [o6_allgemeine_teilnahmebedingungen_2026_04.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich (21 Seiten) | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

## Befunde

### O67-MEASURE-01: Abgeschlossene Lücke am Jahresende behält 50 unbegrünte Tage als grün

Für 2025 ist die tatsächliche Hauptfruchternte am 1. September bekannt; die Jahresbeobachtung ist vollständig und bis einschließlich 31. Dezember wurde nachweislich keine weitere Kultur angelegt. Die zulässigen 50 Tage sind endgültig überschritten. Nach der Quellenregel für den gesamten betroffenen Zeitraum sind 122 Tage unbegrünt. Die offengelegte native Annahme A05 beginnt erst nach den ersten 50 Tagen zu zählen und liefert 72. Dies betrifft eine rückblickend abgeschlossene Beobachtung, keine noch unbekannte Folgesaat und keine vorläufige Online-Prognose. Die positive Gegenkontrolle mit tatsächlicher Ernte am 1. Dezember und bekannter Folgesaat am 20. Januar hält die 50-Tage-Grenze korrekt ein.

Einordnung: `source_retrospective_interval_coverage`; Familie `TEMPORAL_SCOPE`. Code: [greening.rego:102–118](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:102).

Merkblatt S. 3:

> Wurden die Maximalzeiträume auf einzelnen Flächen überschritten, zählen diese in dem betroffenen Zeitraum als unbegrünt. Sind zu einem Zeitpunkt im Jahr mehr als 15 % der Ackerfläche unbegrünt, so liegt ein Verstoß vor.

Merkblatt S. 4:

> Der Zeitraum zwischen erster Hauptfrucht und Zwischenfrucht entspricht jedoch nicht den Vorgaben und die Fläche zählt daher in den 40 Tagen zur unbegrünten Fläche und darf das Maximum von 15 % der Gesamtfläche nicht überschreiten.

Merkblatt S. 3:

> Der Tag der Anlage der Hauptfrucht bzw. der Zwischenfrucht zählt bereits als Begrünungstag. Der Tag der Ernte der Hauptfrucht sowie der Tag des Umbruchs der Ackerfutterfläche oder der Zwischenfrucht zählen nicht als Begrünungstag, sondern als unbegrünt.

Proben: `o6_7-completed-terminal-gap-all-days`, `o6_7-closed-cross-year-fifty-day-gap`.

### O67-MEASURE-02: Dürreausnahme lockert auch die nicht erfasste unmittelbare Erneuerung

Zwei ansonsten zulässige Zwischenfrüchte bestehen tatsächlich 45 und 44 Tage. Dazwischen liegen bekannte 17 Tage offener Boden. Ohne Dürreflag wird die fehlende unmittelbare Erneuerung korrekt gemeldet. Mit dem 2026-Flag unterdrückt derselbe Helfer die Diagnose: Ist 0 statt Soll 1. Der Hinweis vom 12. August erweitert die benannten 30-/50-Tage-Anbaufristen und erhält die weiteren Bedingungen; die Erneuerung „Zug um Zug“ gehört nicht zu diesen Fristen. Die positive Kontrolle einer von 30 auf 40 Tage verlängerten regulären Hauptfrucht-Zwischenfrucht-Lücke erhält die Ausnahme korrekt. Für die 17 Tage ist keine strittige tageweise Definition von „unmittelbar“ nötig.

Einordnung: `source_coverage_or_semantics`; Familie `TEMPORAL_SCOPE`. Code: [greening.rego:58–78](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:58).

Merkblatt S. 5:

> Die Abfolge Zwischenfrucht nach Zwischenfrucht ist nur dann zulässig, wenn jeweils die Mindestanlagedauer von 42 Tagen erfüllt wird und wenn der Umbruch der ersten Zwischenfrucht und Anbau der zweiten unmittelbar hintereinander erfolgen (Zug um Zug).

Hinweis 2026-08-12:

> Für das Antragsjahr 2026 können die in der Maßnahme festgelegten Fristen zur spätesten Anlage einer Zwischenfrucht (30 Tage) oder Hauptfrucht (50 Tage) unter Glaubhaftmachung einer vorausschauenden Bewirtschaftung überschritten werden, wenn bodenspezifische, phytosanitäre oder pflanzenbauliche Erfordernisse bei der Anlage nicht gegeben sind.

Hinweis 2026-08-12:

> Auch die Mindestanlagedauer (42 Tage) sowie die weiteren Voraussetzungen der Maßnahme sind einzuhalten.

Proben: `o6_7-renewal2026-without-justification`, `o6_7-renewal2026-drought-does-not-waive-renewal`, `o6_7-drought-main-to-catch40-true`.

### O67-MEASURE-03: Vorzeitige Rundung verdeckt eine tatsächliche Überschreitung von 15 %

Bekannt sind 150,02 ha unbegrünte und 850,11 ha begrünte Fläche, insgesamt 1.000,13 ha. Die exakte unbegrünte Quote 15002/100013 ist größer als 15/100: 15002 × 100 = 1.500.200, gegenüber 100013 × 15 = 1.500.195. Der Verbraucher rundet vor der Grenzprüfung auf sechs Dezimalstellen; daraus werden 0,15 und `coverage_ok=true`, obwohl die Komponentenerwartung `false` ist. Exakt 15 % und deutlich darüber liegende 15,01 % werden richtig behandelt. Der Gegenfall benutzt ausschließlich Flächen mit zwei Nachkommastellen und einen exakten Kreuzvergleich. Er isoliert die Rundungsreihenfolge und wird von nativen OPA-Typ-/Laufzeitfehlern sowie einer amtlichen Flächenermittlung oder Sanktion getrennt.

Einordnung: `source_numeric_threshold_component`; Familie `NUMERIC_PRECISION`. Code: [greening.rego:186–206](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:186).

Merkblatt S. 2:

> Es muss eine flächendeckende Begrünung von mindestens 85 % der Ackerfläche zu jedem Zeitpunkt des gesamten Jahres mit Haupt- oder Zwischenfrüchten vorhanden sein.

Merkblatt S. 3:

> Wurden die Maximalzeiträume auf einzelnen Flächen überschritten, zählen diese in dem betroffenen Zeitraum als unbegrünt. Sind zu einem Zeitpunkt im Jahr mehr als 15 % der Ackerfläche unbegrünt, so liegt ein Verstoß vor.

Proben: `o6_7-coverage-exact15`, `o6_7-coverage-above15`, `o6_7-coverage-two-decimal-ha-rounding`.

### O67-MEASURE-04: Pflegemahd nach tatsächlicher Anlage am selben Tag wird übersprungen

Die Untersaat wird zunächst ausgebracht; die tatsächliche Hauptfruchternte am 1. Oktober eröffnet ihren anrechenbaren Zwischenfruchtzeitraum. Anschließend findet am selben Tag eine nicht bodennahe Pflegemahd statt. Der Bestand bleibt nachweislich flächendeckend und wächst weiter; sein tatsächliches Ende ist erst am 15. Februar. Das Pflegeverbot für überwinternde Zwischenfrüchte gilt von der Anlage bis einschließlich 31. Oktober. `in_period` verwendet jedoch `>` statt `>=` und überspringt den Anlagetag: Ist 0 statt Soll 1. Eine gleichartige Mahd am Folgetag wird richtig gemeldet; am 1. November ist sie zulässig. Damit enthält der Gegenfall weder eine unbekannte Reihenfolge innerhalb desselben Tages noch einen zerstörenden Eingriff mit widersprüchlich späterem Bestandsende. Die eigenen N-/PSM-Zweige prüfen den Anlagetag bereits korrekt inklusiv.

Einordnung: `source_local_event_chronology`; Familie `TEMPORAL_SCOPE`. Code: [catch_crop.rego:167–175](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:167), [catch_crop.rego:301–311](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:301).

Merkblatt S. 5:

> Untersaaten sind als Zwischenfrüchte anrechenbar, sofern die Bedingungen dafür erfüllt werden. Als Anlagezeitpunkt wird der Tag der Ernte der Hauptfrucht angenommen.

Merkblatt S. 6:

> Häckseln, Mahd ohne Abtransport und Walzen ist bei über den Winter bestehenbleibenden Zwischenfrüchten erst nach dem 31. Oktober des jeweiligen Jahres zulässig.

Merkblatt S. 6:

> Während des Begrünungszeitraums ist ein dem Pflanzenbestand angepasstes Häckseln oder eine Pflegemahd (Mahd ohne Abtransport) möglich.

Proben: `o6_7-overwinter-care-effective-establishment-day`, `o6_7-overwinter-care-following-day`, `o6_7-overwinter-care-regular-care-date`.

### O67-MEASURE-05: A02 weicht bei kurzer äußerer Lücke von der wörtlichen 41-Tage-Erklärung ab – offen

Die frische tatsächliche Folge lautet: Hauptfruchternte am 1. August, Zwischenfrucht vom 5. August bis 15. September (41 Tage), nächste Hauptfrucht am 20. September. Der äußere Abstand beträgt genau 50 Tage. Die native Annahme A02 verwirft die ungültige Zwischenfrucht und behandelt die äußere Hauptfruchtlücke als grün; die Ausgabe zählt 0 unbegrünte Tage. Das nicht eingeschränkt formulierte Merkblattbeispiel nennt dagegen sowohl alle 41 Zwischenfruchttage als auch die offenen Tage davor und danach als unbegrünt; seine wörtliche Übertragung ergibt 50. Beide Lesarten bleiben ausdrücklich sichtbar. Die 42-Tage-Kontrolle ist korrekt. Root prüft zusätzlich die veröffentlichten Beispiele mit eindeutig mehr als 50 Tagen äußerem Abstand; deren korrektes Ergebnis entscheidet diese Erweiterung nicht. Der Gegenfall ist eine qualifizierte Auslegungsprobe, kein abschließend adjudiziertes Referenzlabel und keine feststehende Sanktion.

Einordnung: `source_interpretation_conflict`; Familie `EVENT_SEMANTICS`. Code: [catch_crop.rego:125–130](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:125), [greening.rego:25–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:25), [greening.rego:65–90](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:65).

Merkblatt S. 5:

> Da die Zwischenfrucht nicht die Mindestdauer von 42 Tagen erreicht, zählen sowohl die 41 Tage Zwischenfrucht als auch die Tage des offenen Bodens vor und nach der Zwischenfrucht als unbegrünt.

Merkblatt S. 5:

> Die Mindestanlagedauer von Zwischenfrüchten muss 42 Tage betragen.

Merkblatt S. 3:

> Ernte Hauptfrucht – Anbau Hauptfrucht 50 Tage

Proben: `o6_7-short-outer-span-invalid41-literal-example`, `o6_7-short-outer-span-valid42-control`.

### O67-MEASURE-06: Späteres Walzen nicht überwinternder Bestände folgt einer offenen Quellensynthese

Das Merkblatt erlaubt die unmittelbare Rückverfestigung des Saatbetts und untersagt im Anschluss das Walzen für den restlichen Begrünungszeitraum. Eine weitere Passage erlaubt erhaltene flächendeckende Begrünung beim Walzen, beispielsweise bei Frost. Die gelieferte SRL erlaubt Pflege einschließlich Walzen ohne Bodeneingriff und formuliert die ausdrückliche Sperre bis 31. Oktober für überwinternde Zwischenfrüchte. Die native Annahme A09 verbindet diese Aussagen zu einer engeren Sperre. Bei bekannt warmem, frostfreiem späterem Walzen einer nicht überwinternden Zwischenfrucht mit erhaltenem Bewuchs ergibt sich deshalb 0 statt 1 nach strenger Merkblattlesart. Diese Erwartung bleibt ausdrücklich als Auslegungsprobe markiert. Die positiven und negativen Kontrollen legen die verwendete Quellenreihenfolge sowie die native Ein-Tages-Konvention für „unmittelbar“ offen. Aus der Abweichung wird weder ein unbedingter verbindlicher Rechtsverstoß noch ein numerischer Zahlungsabzug abgeleitet.

Einordnung: `source_interpretation_conflict`; Familie `SOURCE_VERSION`. Code: [catch_crop.rego:280–311](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:280).

Merkblatt S. 6:

> Ein Anwalzen des Saatbetts unmittelbar nach der Anlage der Begrünung ist zur Rückverfestigung zulässig. Für den restlichen Begrünungszeitraum ist Walzen nicht erlaubt.

Merkblatt S. 7:

> Walzen – z. B. bei Frost – ist möglich, wenn eine flächendeckende Begrünung erhalten bleibt.

SRL S. 58:

> Zwischenfrüchten von der Anlage bis einschließlich 31.10. verboten.

SRL S. 58:

> Nutzung (Mahd und Abtransport, Beweidung, kein Drusch) und Pflege (z. B. Häckseln und Walzen ohne Bodeneingriff) der Zwischenfrucht ist erlaubt, sofern eine flächendeckende Begrünung erhalten bleibt.

Proben: `o6_7-nonoverwintering-rolling-literal-leaflet`, `o6_7-reconsolidation-same-day-immediate`, `o6_7-reconsolidation-two-days-not-immediate`, `o6_7-rolling-after-care-true`.

## Korrekte Umsetzungen und erhaltene Grenzen

Die tatsächliche Tagesberechnung berücksichtigt geschlossene 30-/30-/50-Tage-Lücken und die unterschiedliche Zählung von Ernte-/Umbruchtag und Anlagetag. Mehrjährige Hauptfrüchte werden bis zum tatsächlichen Umbruch berücksichtigt. Für die 85-%-Basis bleiben sämtliche Ackerflächen maßgeblich, auch wenn eine Fläche selbst keine Maßnahme-7-Prämie erhalten kann; Root prüft dazu die Gesamtausgabe. Die klare Ausnahme für nach dem 15. Oktober unbegrünt übernommene Flächen wird in den 15./16.-Oktober- und Folgejahreskontrollen geprüft. Die tägliche Zuordnung eines vor diesem Stichtag erworbenen MFA-Schlags wird von der gelieferten Merkblattdefinition allein nicht eindeutig aufgelöst. Dafür wird keine erfundene dynamische Nennerformel oder Rückwirkungssanktion vorgegeben.

Bei Untersaaten wirkt die tatsächliche Hauptfruchternte auf Anlagetag, Stichtags-, Mischungs-/Winterhärte- und Mindestdauerprüfung. Die 42-Tage-Grenze, der 20. September, der 15. Oktober, der 15. Februar und die seit 2025 strikte Grenze „unter 50 % abfrostende Anteile“ werden tatsächlich verbraucht. Die normalen 2025-Aufgangsbedingungen und die nationale 2026-Ausnahme werden getrennt; die Dürreausnahme setzt eine ordnungsgemäße Anlage voraus und begünstigt nur den ausdrücklich einschlägigen Ausfallgetreideursprung. Die nationale Deckungsausnahme wird nicht durch die gesonderte Bezirkskulisse für Erntepflichten beschränkt.

Mineralischer Stickstoff und Pflanzenschutzmittel werden schon am tatsächlichen Anlagetag korrekt erfasst. Der konkrete letzte NAPV-Verbotstag ist ein extern bereitgestellter Fachbefund; aus dem Quellenpaket wird kein nicht gelieferter pauschaler Kalenderstichtag erfunden. Futternutzung beendet den Zeitraum nicht und hebt den anschließenden PSM-Schutz nicht auf. Drusch, Bodenbearbeitung, Zusatzsaat, Tiefenlockerung und Strip-Till werden anhand konkreter Ereignisse und ihrer Bedingungen getrennt. Die Problempflanzen-Ausnahme ist gegenüber dem vorherigen Roh-Run verbessert: Sie gilt tatsächlich nur für nicht bodennahes Häckseln, nicht pauschal für Pflegemahd.

Vorvertrags-, Mischungs- und Erstjahresauslegungen bleiben anhand der ursprünglichen Annahmen A06/A07 sichtbar. Tatsächliches vollständiges Abfrosten eines Bestands wird von lediglich gefrorenem Boden unterschieden. Der Beginn einer offenen Phase nach Abfrosten, Niederbrechen, Walzen, bodennaher Mahd oder einem späteren PSM-Einsatz muss mit dem tatsächlichen Segmentende konsistent sein; ein separater App-Konsistenzfall setzt gerade keinen gewöhnlichen Zahlungsanspruch voraus.

Tables besitzt den eigenständigen Befund `O67-TABLE-001`: Der mechanische Methodenhelfer benutzt nur die Schlüsselmitgliedschaft, während Frost-/Komponentenbedingungen erst andere lokale Diagnosen erzeugen. Dadurch kann die nachfolgende PSM-Diagnose trotz einer separat erkannten unzulässigen Methode fehlen. Das wird hier referenziert und nicht doppelt als eigener neuer Befund gezählt. Tables prüft auch sämtliche Kulturdefinitionslisten; die vollständige Speicherung ersetzt deren derzeit fehlenden tatsächlichen Klassifikationsverbraucher nicht. Haupt-/Zwischenfruchtart, Anteile und Sorteneignung bleiben dadurch externe Fachangaben.

General besitzt Teilnahme, Ausstieg, Aufzeichnungen, Doppelnutzung, Verwaltung und finanzielle Verbraucher. Inputs besitzt fehlende/null/false Nachweise, Datums-/Typstress und App-Projektion. Fehlende Tatsachen werden dort als Eingabe- oder Nachweisanforderung behandelt, nicht als bereits bewiesener materieller Verstoß. Root besitzt Scope, `lib`/`main` und Gesamtausgaben. Die drei historischen Regeln zu Hanf-Samenernte, gestaffelter Ernte und Maßnahme-16-Folgepflicht sind hier als katalogisierte, upstream beziehungsweise in einer Nachbarmaßnahme zu erfüllende Grenzen kenntlich gemacht.

## Historische Regelabdeckung

52 tatsächliche historische IDs: **20 umgesetzt, 24 teilweise, drei nur katalogisiert, drei offene Auslegungen und zwei externe Evidenzgrenzen**. Jede ID ist einzeln mit Quelltext, wirklichem Code und Begründung in JSON erfasst. „Umgesetzt“ bestätigt den Verbraucher unter seinen dokumentierten Tatsachenannahmen; es bestätigt weder reale Nachweise noch eine behördliche Freigabe.

| Historische ID | Bewertung | Tatsächlicher Code | Quellen |
| --- | --- | --- | --- |
| `O67-DEF-GREENING-CROPS` | teilweise | [greening.rego:9–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:9), [greening.rego:65–124](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:65) | Merkblatt S. 2, Merkblatt S. 3, Merkblatt S. 5 |
| `O67-DEF-GREEN-FALLOW` | umgesetzt | [greening.rego:9–27](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:9), [greening.rego:174–179](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:174) | Merkblatt S. 2, Merkblatt S. 3 |
| `O67-DEF-MAIN-CROP` | teilweise | [greening.rego:9–27](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:9), [greening.rego:42–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:42) | Merkblatt S. 2, Merkblatt S. 4 |
| `O67-DEF-CATCH-CROP` | teilweise | [catch_crop.rego:11–25](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:11), [catch_crop.rego:72–161](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:72) | Merkblatt S. 2 |
| `O67-PROPER-ESTABLISHMENT` | teilweise | [catch_crop.rego:54–66](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:54), [catch_crop.rego:151–161](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:151) | Merkblatt S. 2, Hinweis 2026-08-05 |
| `O67-DEF-VOLUNTEER-NOT-CATCH` | umgesetzt | [catch_crop.rego:81–84](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:81) | Merkblatt S. 2, Hinweis 2026-08-05 |
| `O67-DEF-CEREAL-MAIZE-50` | teilweise | [catch_crop.rego:63–66](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:63), [catch_crop.rego:86–92](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:86) | Merkblatt S. 2, Hinweis 2026-08-05 |
| `O67-DEF-SELF-GREENING` | teilweise | [greening.rego:9–27](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:9), [greening.rego:65–124](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:65), [greening.rego:145–163](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:145) | Merkblatt S. 2, Merkblatt S. 3 |
| `O67-DEF-OTHER-ARABLE-GI-UNGREENED` | umgesetzt | [greening.rego:127–143](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:127) | Merkblatt S. 2 |
| `O67-COVER-85` | teilweise | [greening.rego:179–216](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:179) | Merkblatt S. 2, Merkblatt S. 3 |
| `O67-GAP-MAX-PERIODS` | teilweise | [greening.rego:15–19](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:15), [greening.rego:58–90](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:58), [greening.rego:102–118](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:102) | Merkblatt S. 3, Merkblatt S. 5, Hinweis 2026-08-12 |
| `O67-GAP-DAY-COUNTING` | teilweise | [greening.rego:65–118](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:65) | Merkblatt S. 3 |
| `O67-GAP-HEMP-SEED-HARVEST` | nur Katalog / externe Zuständigkeit | Kein ausführender Verbraucher | Merkblatt S. 3 |
| `O67-GAP-STAGGERED-HARVEST` | nur Katalog / externe Zuständigkeit | Kein ausführender Verbraucher | Merkblatt S. 3 |
| `O67-COVER-BASE-AREA` | umgesetzt | [greening.rego:174–184](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:174), [lib.rego:47–58](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/lib.rego:47) | Merkblatt S. 2, Merkblatt S. 3 |
| `O67-NAT-SELF-GREENING` | teilweise | [greening.rego:9–27](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:9), [greening.rego:145–163](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:145) | Merkblatt S. 3 |
| `O67-LATE-ACQUISITION` | teilweise | [greening.rego:167–179](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:167) | Merkblatt S. 3 |
| `O67-GAP-EXCEEDED-UNGREENED` | teilweise | [greening.rego:65–90](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:65), [greening.rego:102–118](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:102) | Merkblatt S. 3, Merkblatt S. 4 |
| `O67-MULTIYEAR-MAIN-CROP` | umgesetzt | [greening.rego:9–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:9) | Merkblatt S. 4 |
| `O67-EARLY-BREAK-MAIN-CROP` | umgesetzt | [greening.rego:30–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:30), [greening.rego:65–90](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:65) | Merkblatt S. 4, Merkblatt S. 3 |
| `O67-FIRST-ENTRY` | Auslegung offen | [catch_crop.rego:30–52](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:30), [catch_crop.rego:94–137](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:94) | Merkblatt S. 4, Merkblatt S. 5 |
| `O67-CC-SOWING-DEADLINE` | umgesetzt | [catch_crop.rego:11–17](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:11), [catch_crop.rego:94–99](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:94) | Merkblatt S. 4, Merkblatt S. 5 |
| `O67-CC-MIXTURE-EARLY` | umgesetzt | [catch_crop.rego:27–41](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:27), [catch_crop.rego:101–115](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:101) | Merkblatt S. 4, Merkblatt S. 5 |
| `O67-CC-SEED-PROOF` | umgesetzt | [catch_crop.rego:366–372](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:366) | Merkblatt S. 4 |
| `O67-CC-WINTER-HARDY-LATE` | Auslegung offen | [catch_crop.rego:44–52](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:44), [catch_crop.rego:109–123](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:109) | Merkblatt S. 5, Merkblatt S. 4, SRL S. 57 |
| `O67-CC-EARLIEST-BREAK-FEB15` | umgesetzt | [catch_crop.rego:132–138](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:132) | Merkblatt S. 5 |
| `O67-CC-HARVEST-AFTER-OCT15-MAIN-ONLY` | umgesetzt | [catch_crop.rego:11–17](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:11), [catch_crop.rego:94–99](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:94), [greening.rego:25–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:25) | Merkblatt S. 5 |
| `O67-CC-MIN-DURATION-42` | teilweise | [catch_crop.rego:125–130](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:125), [greening.rego:25–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:25), [greening.rego:65–90](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:65) | Merkblatt S. 5, Merkblatt S. 3 |
| `O67-CC-RENEWAL` | teilweise | [catch_crop.rego:94–130](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:94), [greening.rego:15–19](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:15), [greening.rego:58–78](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:58) | Merkblatt S. 5, Hinweis 2026-08-12 |
| `O67-CC-UNDERSOWN` | umgesetzt | [catch_crop.rego:11–17](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:11), [catch_crop.rego:27–52](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:27) | Merkblatt S. 5 |
| `O67-CC-MINERAL-N-BAN` | teilweise | [catch_crop.rego:177–181](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:177), [catch_crop.rego:208–214](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:208) | Merkblatt S. 5 |
| `O67-CC-COMBINED-FERTILISATION` | umgesetzt | [catch_crop.rego:216–219](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:216) | Merkblatt S. 5, Merkblatt S. 6 |
| `O67-CC-ALLOWED-FERTILISERS` | externe Evidenz | Kein ausführender Verbraucher | Merkblatt S. 6 |
| `O67-CC-PSM-BAN` | umgesetzt | [catch_crop.rego:221–245](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:221) | Merkblatt S. 6 |
| `O67-CC-PSM-AFTER-NON-MECHANICAL` | teilweise | [catch_crop.rego:183–185](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:183), [catch_crop.rego:237–271](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:237) | Merkblatt S. 6, Merkblatt S. 8 |
| `O67-CC-TILLAGE-BAN` | teilweise | [catch_crop.rego:167–175](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:167), [catch_crop.rego:273–278](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:273) | Merkblatt S. 6 |
| `O67-CC-ROLLING` | Auslegung offen | [catch_crop.rego:280–311](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:280) | Merkblatt S. 6, Merkblatt S. 7, SRL S. 58 |
| `O67-CC-CARE-CONDITIONS` | teilweise | [catch_crop.rego:196–198](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:196), [catch_crop.rego:313–329](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:313) | Merkblatt S. 6, Merkblatt S. 7 |
| `O67-CC-CARE-BEFORE-NOV` | teilweise | [catch_crop.rego:167–175](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:167), [catch_crop.rego:301–311](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:301) | Merkblatt S. 6, Merkblatt S. 5 |
| `O67-CC-PROBLEM-WEED-EVIDENCE` | umgesetzt | [catch_crop.rego:187–192](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:187), [catch_crop.rego:301–311](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:301), [catch_crop.rego:352–361](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:352) | Merkblatt S. 7, Merkblatt S. 6 |
| `O67-CC-GROUND-NEAR-CHOPPING` | teilweise | [catch_crop.rego:322–329](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:322), [greening.rego:30–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:30) | Merkblatt S. 7 |
| `O67-CC-HARROWING-IN` | umgesetzt | [catch_crop.rego:273–278](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:273), [catch_crop.rego:183–185](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:183) | Merkblatt S. 7, Merkblatt S. 8 |
| `O67-CC-STRIP-TILL-DEEP-LOOSENING` | teilweise | [catch_crop.rego:331–345](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:331), [catch_crop.rego:167–175](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:167) | Merkblatt S. 7 |
| `O67-CC-NO-RESTRICTION-OUTSIDE-PERIOD` | umgesetzt | [catch_crop.rego:167–175](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:167), [catch_crop.rego:273–278](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:273) | Merkblatt S. 7 |
| `O67-CC-USE` | teilweise | [catch_crop.rego:313–329](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:313), [greening.rego:30–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:30) | Merkblatt S. 7 |
| `O67-CC-NO-THRESHING` | umgesetzt | [catch_crop.rego:20–25](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:20), [catch_crop.rego:140–149](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:140), [catch_crop.rego:347–350](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:347) | Merkblatt S. 8, Merkblatt S. 9 |
| `O67-CC-MECHANICAL-REMOVAL` | teilweise | [catch_crop.rego:183–185](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:183), [catch_crop.rego:247–271](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:247), [greening.rego:30–50](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:30) | Merkblatt S. 8 |
| `O67-CC-NOT-MECHANICAL` | umgesetzt | [catch_crop.rego:183–185](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:183), [catch_crop.rego:247–251](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:247) | Merkblatt S. 8 |
| `O67-GW16-CATCH-CROP-OBLIGATION` | nur Katalog / externe Zuständigkeit | Kein ausführender Verbraucher | SRL S. 75 |
| `O67-DROUGHT-2026-GAP-RELIEF` | teilweise | [greening.rego:58–78](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/greening.rego:58), [catch_crop.rego:94–161](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:94) | Hinweis 2026-08-12, Merkblatt S. 5 |
| `O67-DROUGHT-2026-COVERAGE-RELIEF` | umgesetzt | [catch_crop.rego:54–66](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:54), [catch_crop.rego:86–92](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:86), [catch_crop.rego:151–156](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:151) | Hinweis 2026-08-05, Hinweis 2026-08-12 |
| `O67-GEN-DEFINITIONS-CROP-LISTS` | externe Evidenz | [lib.rego:7–7](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/lib.rego:7), [catch_crop.rego:35–52](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:35), [catch_crop.rego:86–92](/workspace/scratch/opus-candidates-source/runs/v2-o6_7-opus-5.5-high-20260925/workspace/policy/o6_7/catch_crop.rego:86) | ATB S. 3, ATB S. 4 |

## Vollständige Quellenabschnitte

Die 51 Zeilen dokumentieren die komplette neue Merkblattlektüre und den aktuellen Abgleich der einschlägigen geteilten Quellen. „Nachbarteil“ bedeutet fachlich gelesen und ausdrücklich einem anderen Prüfteil zugeordnet; es ist keine stillschweigend übersprungene Pflicht. Revisions-/Impressumstext wird gelesen, ohne daraus zusätzliche materielle Normen zu erfinden. Der komplette wortgetreue Befund und die einzelnen Regelbindungen stehen in JSON.

| Abschnitt | Quelle / tatsächliche Seiten | Bewertung | Zugeordnete historische IDs |
| --- | --- | --- | --- |
| `MB1-overview` – 1–2 Support unit and environmental goals | Merkblatt S. 1 | Nachbarteil | `O67-SCOPE-ARABLE-ALL` |
| `MB1-contract` – 3.1 Annual contract, automatic renewal and lapse | Merkblatt S. 1 | Nachbarteil | `O67-CONTRACT-ONE-YEAR`, `O67-CONTRACT-AUTO-RENEWAL`, `O67-CONTRACT-LAPSE` |
| `MB1-minimum` – 3.2 Annual minimum of 1.50 ha arable land | Merkblatt S. 1 | Nachbarteil | `O67-ACCESS-MIN-ARABLE` |
| `MB2-all-arable` – 3.3 All arable fields carry obligations | Merkblatt S. 2 | gelesen / abgeglichen | `O67-SCOPE-ARABLE-ALL` |
| `MB2-crops` – 4.1 Main crop, catch crop, allowed gaps, fallow and perennial definitions | Merkblatt S. 2 | gelesen / abgeglichen | `O67-DEF-GREENING-CROPS`, `O67-DEF-GREEN-FALLOW`, `O67-DEF-MAIN-CROP` |
| `MB2-catch` – 4.1 Actual active intermediate crop and following main crop | Merkblatt S. 2 | teilweise | `O67-DEF-CATCH-CROP` |
| `MB2-proper` – 4.1 Seedbed, rate, timing, equipment, depth and seed choice | Merkblatt S. 2 | teilweise | `O67-PROPER-ESTABLISHMENT` |
| `MB2-exclusions` – 4.2 Volunteer plants, cereal/maize/rye exception and ordinary self-greening | Merkblatt S. 2 | teilweise | `O67-DEF-VOLUNTEER-NOT-CATCH`, `O67-DEF-CEREAL-MAIZE-50`, `O67-DEF-SELF-GREENING` |
| `MB2-other-GI` – 4.2 Other arable use and duration of GI | Merkblatt S. 2 | gelesen / abgeglichen | `O67-DEF-OTHER-ARABLE-GI-UNGREENED` |
| `MB2-85` – 5.1 Daily 85 percent cover throughout the year | Merkblatt S. 2 | teilweise | `O67-COVER-85` |
| `MB3-gaps-days` – 5.1 All 30/30/50-day gaps and sowing/harvest/break day counting | Merkblatt S. 3 | teilweise | `O67-GAP-MAX-PERIODS`, `O67-GAP-DAY-COUNTING` |
| `MB3-hemp-staggered` – 5.1 Hemp seed harvest and last subparcel harvest | Merkblatt S. 3 | nur Katalog / externe Zuständigkeit | `O67-GAP-HEMP-SEED-HARVEST`, `O67-GAP-STAGGERED-HARVEST` |
| `MB3-base-NAT` – 5.1 Every arable category and conditional NAT self-regrowth within 50 days | Merkblatt S. 3 | teilweise | `O67-COVER-BASE-AREA`, `O67-NAT-SELF-GREENING` |
| `MB3-acquisition` – 5.1 Late acquisition cause and actual next-year cultivation | Merkblatt S. 3 | teilweise | `O67-LATE-ACQUISITION` |
| `MB3-4-exceeded` – 5.1 Whole exceeded interval and complete 40-day example | Merkblatt S. 3–4 | teilweise | `O67-GAP-EXCEEDED-UNGREENED` |
| `MB4-perennial-break` – 5.1 Perennial fodder, last use, early main-crop break and records | Merkblatt S. 4 | gelesen / abgeglichen | `O67-MULTIYEAR-MAIN-CROP`, `O67-EARLY-BREAK-MAIN-CROP` |
| `MB4-first-entry` – First-entry warning: 1 January, prior-autumn date exception and mixture duty | Merkblatt S. 4 | Auslegung offen | `O67-FIRST-ENTRY` |
| `MB4-early-sowing` – 5.2.1 Latest 15 October, early 20 September, 3 partners/2 families and seed proof | Merkblatt S. 4 | gelesen / abgeglichen | `O67-CC-SOWING-DEADLINE`, `O67-CC-MIXTURE-EARLY`, `O67-CC-SEED-PROOF` |
| `MB5-late-sowing` – 5.2.1 Late hardiness, under 50 percent from 2025 and 15 February break | Merkblatt S. 5 | Auslegung offen | `O67-CC-WINTER-HARDY-LATE`, `O67-CC-EARLIEST-BREAK-FEB15` |
| `MB5-afterharvest` – 5.2.1 Harvest after 15 October permits only main-crop restoration | Merkblatt S. 5 | gelesen / abgeglichen | `O67-CC-HARVEST-AFTER-OCT15-MAIN-ONLY` |
| `MB5-duration-renewal` – 5.2.1 Actual 42 days, renewal by 15 October, 42 further days and Zug um Zug | Merkblatt S. 5 | teilweise | `O67-CC-MIN-DURATION-42`, `O67-CC-RENEWAL` |
| `MB5-undersown` – 5.2.1 Actual host harvest and late frost-mixture example | Merkblatt S. 5 | gelesen / abgeglichen | `O67-CC-UNDERSOWN` |
| `MB5-41example` – 5.2.1 Full 41-day example and surrounding bare intervals | Merkblatt S. 5 | Auslegung offen | `O67-CC-MIN-DURATION-42` |
| `MB5-n` – 5.2.2 N ban through the following-year NAPV end and combined sowing fertilization | Merkblatt S. 5 | teilweise | `O67-CC-MINERAL-N-BAN`, `O67-CC-COMBINED-FERTILISATION` |
| `MB6-fertilizers` – 5.2.2 Legally permitted N-free basic fertilizers, manure and secondary materials | Merkblatt S. 6 | externe Evidenz | `O67-CC-ALLOWED-FERTILISERS` |
| `MB6-psm` – 5.2.3 PSM from establishment to actual break and nonmechanical following-sowing condition | Merkblatt S. 6 | teilweise | `O67-CC-PSM-BAN`, `O67-CC-PSM-AFTER-NON-MECHANICAL` |
| `MB6-soil` – 5.2.4 Plant-killing soil work and knife-roller prohibition | Merkblatt S. 6 | teilweise | `O67-CC-TILLAGE-BAN` |
| `MB6-rolling` – 5.2.4 Immediate seedbed rolling and rest-period prohibition | Merkblatt S. 6 | Auslegung offen | `O67-CC-ROLLING` |
| `MB6-care` – 5.2.4 Care effects and overwinter 31 October limit | Merkblatt S. 6 | teilweise | `O67-CC-CARE-CONDITIONS`, `O67-CC-CARE-BEFORE-NOV` |
| `MB7-weeds` – 5.2.4 Four problem weeds, non-ground-near chopping and evidence | Merkblatt S. 7 | gelesen / abgeglichen | `O67-CC-PROBLEM-WEED-EVIDENCE` |
| `MB7-frost` – 5.2.4 Full-frost close chopping, actual end, 30 days to next main and rolling sentence | Merkblatt S. 7 | teilweise | `O67-CC-GROUND-NEAR-CHOPPING`, `O67-CC-ROLLING` |
| `MB7-harrow-strip` – 5.2.4 Harrowing in, preserved strip/deep work and outside-period permission | Merkblatt S. 7 | teilweise | `O67-CC-HARROWING-IN`, `O67-CC-STRIP-TILL-DEEP-LOOSENING`, `O67-CC-NO-RESTRICTION-OUTSIDE-PERIOD` |
| `MB7-use` – 5.2.5 Forage/grazing conditions, continued cover and terminal harvest | Merkblatt S. 7 | teilweise | `O67-CC-USE` |
| `MB8-thresh-fodder` – 5.2.5 No catch threshing and field-fodder MFA reclassification | Merkblatt S. 8 | Nachbarteil | `O67-CC-NO-THRESHING`, `O67-FIELD-FODDER-DOUBLE-USE` |
| `MB8-mechanical` – 5.2.6 Every mechanical method and actual bare-time onset | Merkblatt S. 8 | teilweise | `O67-CC-MECHANICAL-REMOVAL` |
| `MB8-nonmech` – 5.2.6 Harrowing and autumn trimming are not creditable | Merkblatt S. 8 | gelesen / abgeglichen | `O67-CC-NOT-MECHANICAL` |
| `MB8-9-records` – 5.3 All record events, all fields/year and optional template | Merkblatt S. 8–9 | Nachbarteil | `O67-RECORDS`, `O67-RECORDS-TEMPLATE` |
| `MB9-application` – 6 Measure deadline, final entry, MFA main/catch and bidirectional switch | Merkblatt S. 9 | Nachbarteil | `O67-APPLICATION-DEADLINE`, `O67-LAST-ENTRY`, `O67-MFA-MAIN-CROPS`, `O67-MFA-CATCH-CROPS-NOT-DECLARED`, `O67-COMB-NOT-WITH-6`, `O67-SWITCH-TO-6` |
| `MB9-10-erosion` – 6 Overwinter catches support the erosion-protection option | Merkblatt S. 9–10 | Nachbarteil | `O67-COMB-PREREQUISITE-FOR-8-16` |
| `MB10-lapse-exit` – 6–7 Minimum/lapse, new application, exit warning and later erosion exclusion | Merkblatt S. 10 | Nachbarteil | `O67-CONTRACT-LAPSE`, `O67-CONTRACT-LAPSE-REAPPLY`, `O67-EXIT-DURING-YEAR`, `O67-EXIT-ES-ACKER` |
| `MB10-premium` – 8 Single 70–90 band, guaranteed minimum and 2024 NPF exclusion | Merkblatt S. 10 | Nachbarteil | `O67-PREMIUM-RATE`, `O67-PREMIUM-NPF-2024` |
| `MB11-revisions` – 9 All updates, imprint and nonbinding disclaimer | Merkblatt S. 11 | Kontext / vollständig gelesen | Kontext / siehe JSON |
| `SRL57` – 2.7 Complete support, definitions, 85 percent, gaps, records and catch conditions | SRL S. 57 | teilweise | `O67-DEF-GREENING-CROPS`, `O67-COVER-85`, `O67-GAP-MAX-PERIODS`, `O67-CC-MIN-DURATION-42`, `O67-CC-RENEWAL` |
| `SRL58` – 2.7 Complete N/PSM/tillage/care rules and premium table | SRL S. 58 | teilweise | `O67-CC-MINERAL-N-BAN`, `O67-CC-PSM-BAN`, `O67-CC-ROLLING` |
| `SRL75` – 2.16 Other-measure follow-up duty and exact exceptions | SRL S. 75 | nur Katalog / externe Zuständigkeit | `O67-GW16-CATCH-CROP-OBLIGATION` |
| `AT3-4` – Source crop definitions and open group qualifiers | ATB S. 3–4 | externe Evidenz | `O67-GEN-DEFINITIONS-CROP-LISTS` |
| `NOTICE0805` – National 2026 failed-emergence and volunteer-cereal exception | Hinweis 2026-08-05 | gelesen / abgeglichen | `O67-DROUGHT-2026-COVERAGE-RELIEF` |
| `NOTICE0812` – Specific 30/50-day exception and retained cutoffs/42 days | Hinweis 2026-08-12 | teilweise | `O67-DROUGHT-2026-GAP-RELIEF` |
| `NOTICE-2026-05-22` – Other supplied notice, exact-hash previous full reading | Hinweis 2026-05-22 | Nachbarteil | Kontext / siehe JSON |
| `NOTICE-2026-06-12` – Other supplied notice, exact-hash previous full reading | Hinweis 2026-06-12 | Nachbarteil | Kontext / siehe JSON |
| `ANNEX-shared` – Full shared annexes, exact-hash reuse and current table consumers | SRL-Anhänge S. 1–103 | Nachbarteil | `O67-GEN-COMBINATION-ANNEX-L` |

## Frische öffentliche Quellen- und Grenzfälle

Jede Zeile ist ein unabhängig aus dem gebundenen Quelltext abgeleiteter Fall. Die 98 vollständigen Eingaben und Queries sind im eingefrorenen JSON enthalten. „Erfüllt“ bedeutet ausschließlich, dass der beobachtete native Wert die jeweils bezeichnete Erwartung erfüllt. Bei Auslegungsproben bezeichnet ein Unterschied die ausdrücklich offen gehaltene Lesart. Die eine Eingabekonsistenzdiagnose prüft einen lokalen Hinweis; die Rundungsprobe prüft allein die rechnerische 15-%-Komponente. Alle Aufrufe sind strikt definiert; in diesem Teil gibt es keinen Laufzeitfehler und keine Zahl-zu-Boolean-Umdeutung.

| Fall | Prüfrahmen | Soll | Ist | Ergebnis |
| --- | --- | --- | --- | --- |
| `o6_7-main-to-catch-gap-30` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-main-to-catch-gap-31` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-catch-to-main-gap-30` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-catch-to-main-gap-31` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-main-to-main-gap-50` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-main-to-main-gap-51` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-completed-terminal-gap-all-days` | Quellen-/Grenzfall | `122` | `72` | **nicht erfüllt** |
| `o6_7-closed-cross-year-fifty-day-gap` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-short-outer-span-invalid41-literal-example` | offene Beispielauslegung | `50` | `0` | **nicht erfüllt** |
| `o6_7-short-outer-span-valid42-control` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-renewal-gap-0` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-renewal-gap-1` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-renewal2026-without-justification` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-renewal2026-drought-does-not-waive-renewal` | Quellen-/Grenzfall | `1` | `0` | **nicht erfüllt** |
| `o6_7-drought-main-to-catch40-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-drought-main-to-catch40-true` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-nat-completed-regrowth-50` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-nat-completed-regrowth-51` | Quellen-/Grenzfall | `51` | `51` | erfüllt |
| `o6_7-known-other-arable-all-year` | Quellen-/Grenzfall | `365` | `365` | erfüllt |
| `o6_7-gi-two-occupied-days` | Quellen-/Grenzfall | `2` | `2` | erfüllt |
| `o6_7-coverage-exact15` | Quellen-/Grenzfall | `true` | `true` | erfüllt |
| `o6_7-coverage-above15` | Quellen-/Grenzfall | `false` | `false` | erfüllt |
| `o6_7-coverage-two-decimal-ha-rounding` | 15-%-Rechenkomponente | `false` | `true` | **nicht erfüllt** |
| `o6_7-late-acquisition-cutoff-included` | Quellen-/Grenzfall | `20` | `20` | erfüllt |
| `o6_7-late-acquisition-after-cutoff-excluded` | Quellen-/Grenzfall | `10` | `10` | erfüllt |
| `o6_7-late-acquisition-next-year-actually-planted` | Quellen-/Grenzfall | `20` | `20` | erfüllt |
| `o6_7-perennial-until-actual-break` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-latest-sowing-10-15` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-latest-sowing-10-16` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-duration-41` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-duration-42` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-early-mixture-earlyexact` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-early-mixture-partner-short` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-early-mixture-family-short` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-late-hardiness-old-all-hardy` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-late-hardiness-old-one-percent-frost` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-late-hardiness-new49percent` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-late-hardiness-new50percent` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-late-earliest-break-02-14` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-late-earliest-break-02-15` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-undersowing-effective-early` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-undersowing-effective-late-frost` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-pre-contract-clear-mixture-true` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-pre-contract-clear-mixture-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-pre-contract-late-date-exempt` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-seed-proof-true` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-seed-proof-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-volunteer-only-invalid` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-cereal-exact50` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-cereal-over50` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-cereal-approved-green-rye` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-cover-ordinary-failed-emergence` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-cover-drought-proper` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-cover-drought-improper` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-drought-cereal-true` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-drought-cereal-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-mineral-n-before` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-mineral-n-establishment` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-mineral-n-last-authoritative-ban-day` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-mineral-n-after-ban` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-combined-mineral-n-true` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-combined-mineral-n-false` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-psm-before` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-psm-establishment` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-psm-before-break` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-psm-after-actual-break` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-psm-nonmechanical-before-following` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-psm-nonmechanical-after-following` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-overwinter-care-effective-establishment-day` | Quellen-/Grenzfall | `1` | `0` | **nicht erfüllt** |
| `o6_7-overwinter-care-following-day` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-overwinter-care-regular-care-date` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-weed-narrow-chopping-allowed` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-weed-mowing-not-the-exception` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-weed-required-evidence` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-care-preserved` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-care-cover-lost` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-care-no-regrowth` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-grazing-preserved` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-grazing-no-regrowth` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-forage-use-preserves-psm-ban` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-deep-preserved` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-deep-damaged` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-strip-preserved` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-strip-whole-area` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-harrowing-in-is-not-tillage` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-known-interior-tillage-diagnostic` | Eingabekonsistenzdiagnose | `1` | `1` | erfüllt |
| `o6_7-tillage-outside-before` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-tillage-outside-after` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-nonoverwintering-rolling-literal-leaflet` | offene Walzen-/Vorranglesart | `1` | `0` | **nicht erfüllt** |
| `o6_7-reconsolidation-same-day-immediate` | offene Walzen-/Vorranglesart | `0` | `0` | erfüllt |
| `o6_7-reconsolidation-two-days-not-immediate` | offene Walzen-/Vorranglesart | `1` | `1` | erfüllt |
| `o6_7-rolling-after-care-true` | offene Walzen-/Vorranglesart | `0` | `0` | erfüllt |
| `o6_7-rolling-after-care-false` | offene Walzen-/Vorranglesart | `1` | `1` | erfüllt |
| `o6_7-ground-near-before-full-frost` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-full-frost-chopping-actual-end` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_7-explicit-threshed` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-actual-threshing-event` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_7-not-threshed` | Quellen-/Grenzfall | `0` | `0` | erfüllt |

**Abschluss dieses Maßnahmenteils:** 98 Fälle, 98 Prüfungen, 98 definierte Werte, 92 erfüllte und sechs nicht erfüllte Erwartungen. Vier konkrete lokale Grenzen und zwei ausdrücklich offene Auslegungen bleiben getrennt. Die Policies wurden ausschließlich gelesen und ausgeführt; Änderungen und weitere Maßnahmen gehören nicht zu diesem Dossier.
