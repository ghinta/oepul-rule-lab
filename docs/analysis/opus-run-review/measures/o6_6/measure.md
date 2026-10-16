# o6_6 – Zwischenfruchtanbau: Varianten und Bewirtschaftung

Geprüft wurde ausschließlich der rohe historische Opus-Run `v2-o6_6-opus-5.5-high-20260925` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieser Maßnahmenteil enthält **60 historische Katalogbewertungen, 55 Quellenabschnitte, vier abgegrenzte Befunde sowie 129 frische öffentliche Quellen- und Grenzfälle**. Alle 129 OPA-Aufrufe liefern mit Exitcode 0 einen definierten Wert: **126 Erwartungen erfüllt, drei unerfüllt**.

Zwei Gegenfälle zeigen fehlerhafte lokale Bewirtschaftungsdiagnosen. Ein weiterer zeigt eine fehlende verpflichtende Streichungsdiagnose bei einem bereits anderweitig gesperrten Schlag. Der vierte Befund beschreibt die eingeschränkte Aussagekraft eines regionalen Ernteausnahme-Helfers. Diese Befunde werden nicht mit einer automatisch feststehenden Kürzung oder einer tatsächlichen behördlichen Auszahlung gleichgesetzt.

Das neue Merkblatt wurde auf allen 14 Seiten vollständig gelesen, einschließlich sämtlicher Tabellenzellen, Varianten, Sorten- und Artenlisten, Beispiele, Seitenfortsetzungen, Änderungshinweise und des Schlussdisclaimers. Vollständig gelesen wurden auch `parcel.rego` (392 Zeilen), `notices_2026.rego` (44), die Helfer und tatsächlichen Verbraucher sowie alle ursprünglichen Annahmen. Die acht Manifestquellen bestimmen die Bewertung. Sieben gemeinsame Quellen sind per identischem Hash an die frühere vollständige Lektüre gebunden; die einschlägigen vollständigen SRL-Seiten und beide gelieferten August-Haupttexte wurden erneut gelesen. **GSP-AV ist nicht im Quellenpaket dieses Runs enthalten.**

Studienlabels, Referenzantworten, GM-Urteile, originale Selbsttests und manuelle Adaptationstest-Sollwerte wurden nicht als Orakel verwendet. Historische Policies, Profil und Quellen bleiben unverändert. Zusätzliche synthetische Katalogregeln wurden nicht eingefügt; fehlende Bedingungen sind bestehenden historischen IDs oder ausdrücklich benannten Nachbarteilen zugeordnet.

## Eingefrorene Bindung

Die vollständigen Eingaben, Queries, Sollwerte, Beobachtungen, Regeltexte und Fundstellen stehen in [measure.json](/workspace/scratch/opus-o6-1a-source-audit/docs/analysis/opus-run-review/measures/o6_6/measure.json). SHA-256: `c08a5046ce15e83ebf97e41be3bd0851e3786db3869ca4caf7b3ee5e18132581`. Alle **524 Beleg-Vorkommen** wurden nach Unicode-/Leerraumnormalisierung gegen die genaue Originalseite bzw. HTML-Datei gefunden. Alle Codezeilen liegen in den unveränderten Originalmodulen.

Die Proben laden mit `/tmp/issue-51-review-opa` jeweils die vollständigen nativen Verzeichnisse `workspace/policy` und `workspace/data`. Policy-Paket: `data.oepul.o6_6`; Datenpaket: `data.o6_6`. Es gibt keine Dateiabflachung, Typkonvertierung oder Zahlennormalisierung. Alle Erwartungen verwenden `equals` auf expliziten numerischen 0/1-Abfragen; Regelobjekte und Stringarrays werden nicht verwechselt. Die Zahlen werden nicht als JSON-Booleans umgedeutet.

Eine regionale Probenkontrolle belegt nur den geprüften Teil der Ausnahmeregel. Eine Probe zum unmittelbaren Anwalzen verwendet ausdrücklich die native Vorrangentscheidung zugunsten des späteren Merkblatts; der Widerspruch zum strengeren gelieferten SRL-Wortlaut bleibt offen.

| Vollständig gelesenes Modul | Zeilen | SHA-256 |
| --- | ---: | --- |
| `parcel.rego` | 392 | `7ea5b448be83560aa0894df4de2b50b24c71fba5a4e97a58bdb4fb610673711f` |
| `notices_2026.rego` | 44 | `5df8e6ee24d0cb2799c249901a37f9cf6c44356c658026f28984cf63e90f7993` |
| `helpers.rego` | 82 | `cf1327d98b3cca15ced431ddbab2f004fa172aee8838f11b10fa64944ff0b3dd` |
| `farm.rego` | 180 | `1fcb859fb615786a9107bfa065ad8ddc44339e1d209ad2c225323980c4278db3` |
| `premium.rego` | 198 | `aba948a5fa418ef629a69bc2cbb92aa1b4b9095593041eeb8e21e354312e3cb8` |

| Gebundene Quelle | Lektürebindung | SHA-256 |
| --- | --- | --- |
| [20241011_srl_oepul_2023.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| [20241011_srl_oepul_2023_anhaenge.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| [2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| [2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| [2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| [2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| [o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf) | Neu: alle 14 Seiten vollständig | `298b93938d7f7f4f5756d53a66414ff371bbcb1e27c147b874a43515af5bea26` |
| [o6_allgemeine_teilnahmebedingungen_2026_04.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Quellenhygiene: Ein lokaler August-HTML-Glob erfasste zusätzlich versehentlich den öffentlichen Hinweis vom 25. August zum Grundwasserschutz. Diese Kontextlektüre ist im Leselog vermerkt. Sie gehört nicht zum achtteiligen Korpus dieses Runs und begründet weder einen Befund noch einen Sollwert oder einen rückwirkenden Extraktionsvorwurf.

## Befunde

### O6_6-MEASURE-01: Frühe Pflegemahd erhält die nur für Häckseln formulierte Problempflanzen-Ausnahme

Vor dem regulären Pflegetermin erlaubt die Quelle bei vier genannten Problempflanzen ausdrücklich ein nicht bodennahes Häckseln. Der tatsächliche Aufrufer verwendet dieselbe Ausnahme aber auch für `care_mowing`. Bei positiv belegter Notwendigkeit, aufbewahrten Unterlagen und erhaltenem Bewuchs/Nachwachsen meldet eine frühe Pflegemahd deshalb keinen lokalen Datumsverstoß: Ist 0, Soll 1. Der passende Häcksel-Kontrollfall wird richtig akzeptiert; bodennahes Häckseln erhält die Ausnahme nicht. Eine konkrete Geldkürzung wird daraus nicht abgeleitet.

Einordnung: `source_coverage_or_semantics`; Familie `EVENT_SEMANTICS`. Code: `parcel.rego:216–232`.

Merkblatt S. 4:

> Bei Auftreten von Stechapfel, Kleeseide, Geflecktem Schierling und Ragweed kann – um die Ausbreitung einzudämmen – ein nicht-bodennahes Häckseln auch schon vor den oben genannten Terminen erfolgen.

Merkblatt S. 4:

> Entsprechende Unterlagen zum Nachweis der Notwendigkeit (z. B. Fotos) sind am Betrieb aufzubewahren.

Merkblatt S. 4:

> Während des Begrünungszeitraums ist ein dem Pflanzenbestand angepasstes Häckseln oder eine Pflegemahd (Mahd ohne Abtransport) möglich:

Merkblatt S. 4:

> bei den Varianten 2 bis 6 ab 1. November

Proben: `o6_6-problem-weed-chopping-allowed`, `o6_6-problem-weed-mowing-not-the-exception`, `o6_6-problem-weed-ground-level-not-the-exception`.

### O6_6-MEASURE-02: V7-Beeinträchtigungsregel läuft über das Ende des Begrünungszeitraums hinaus

Der reguläre V7-Zeitraum endet am 31. Januar des Folgejahres. In den gezielt konsistent angelegten Frühjahrsfällen steht die Begleitsaat tatsächlich noch bis zum 20. Februar; eine Herbizidanwendung erfolgt am 15. Februar. Ihre Beeinträchtigung darf nach Ende des verpflichtenden Begrünungszeitraums nicht als fortdauernder V7-Verstoß behandelt werden. Der erste Herbizidzweig ist korrekt eingegrenzt, der zweite prüft `impairs_companion_crop` ohne Zeitraumfilter: Ist 1, Soll 0. Dies ist eine falsche lokale Verpflichtungsdiagnose; über sonstiges Pflanzenschutzrecht oder eine Sanktion wird damit nicht entschieden.

Einordnung: `source_coverage_or_semantics`; Familie `TEMPORAL_SCOPE`. Code: `parcel.rego:309–324`.

Merkblatt S. 10:

> Ein Herbizideinsatz nach dem Vierblattstadium des Rapses bis zum Ende des Begrünungszeitraumes ist nicht zulässig. Wird ein Herbizideinsatz bis zum Vierblattstadium des Rapses durchgeführt, darf dadurch die Begleitsaat nicht beeinträchtigt werden.

Merkblatt S. 10:

> Der Begrünungszeitraum endet am 31. Jänner des Folgejahres.

Proben: `o6_6-v7-herbicide-stage-day-impaired`, `o6_6-v7-herbicide-after-stage`, `o6_6-v7-herbicide-after-end-unimpaired`, `o6_6-v7-herbicide-after-end-impaired`.

### O6_6-MEASURE-03: Pflicht zur Streichung bei anschließender Hauptfruchtnutzung fehlt im Hinweis

Der vollständig bekannte Fall enthält eine tatsächliche Hauptfruchternte im Frühjahr und die entsprechende Haupt-/Doppelnutzungsdeklaration im nächsten MFA. Die Quelle verlangt dafür die Streichung der Begrünungsvariante. `variant_withdrawal_required` prüft jedoch nur fehlende oder verspätete Anlage und gibt keinen entsprechenden Hinweis: Ist 0, Soll 1. Die Fläche ist bereits durch `NOT-MAIN-CROP-NEXT-MFA` unzulässig; der Befund betrifft die zusätzliche verpflichtende Verfahrensdiagnose, keinen nachgewiesenen falschen positiven Prämienbetrag.

Einordnung: `source_procedural_coverage`; Familie `EVENT_SEMANTICS`. Code: `notices_2026.rego:32–44`, `parcel.rego:129–133`.

Merkblatt S. 11:

> Ebenso hat eine Streichung einer beantragten Begrünungsvariante zu erfolgen, falls diese im darauffolgenden Frühjahr als Hauptkultur geerntet wird und im nächsten Mehrfachantrag z. B. als Doppelnutzung „Kleegras/Silomais“ aufscheinen soll.

Merkblatt S. 11:

> Streichungen bzw. Reduzierungen von Begrünungsvarianten sind umgehend vorzunehmen, sobald sich herausstellt, dass auf einem beantragten Begrünungsschlag die Bedingungen (z. B. zeitgerechte Anlage) nicht erfüllt werden können.

Merkblatt S. 2:

> Aus der Zwischenfruchtbegrünung darf im darauffolgenden Frühjahr keine Hauptfrucht hervorgehen.

Proben: `o6_6-withdraw-main-crop-next-mfa`, `o6_6-withdraw-known-late-establishment`.

### O6_6-MEASURE-04: Regionaler Ernteausnahme-Helfer prüft die sachlichen Voraussetzungen nicht

Die Bezirksliste ist vollständig und wird tatsächlich verwendet. Die Quelle verlangt zusätzlich eine üblicherweise erst im Spätsommer/Herbst geerntete Kultur und einen wegen der Dürre fehlenden erntbaren Bestand. Der Helfer liest lediglich Jahr und Gebiet; sein Verbraucher unterdrückt nur einen Hinweis. Seine Aussage ist daher eine regionale Teilprüfung. Die sieben Quellenkontrollen setzen die weiteren Sachvoraussetzungen ausdrücklich voraus und prüfen allein Gebiet/Jahr; sie beweisen keinen vollständigen behördlichen Ausnahmetatbestand oder einen fehlerhaften Auszahlungsbetrag.

Einordnung: `source_component_coverage_boundary`; Familie `EXTERNAL_DEPENDENCY`. Code: `notices_2026.rego:20–29`, `farm.rego:173–180`.

Hinweis 2026-08-05:

> Die Ernte und das Verbringen des Erntegutes auf zumindest 85 % des Schlages muss daher nicht erfolgen, wenn auf Grund der Dürre kein erntbarer Bestand vorliegt.

Hinweis 2026-08-05:

> Diese Ausnahmeregelung gilt für Ackerkulturen, die üblicherweise erst im Spätsommer oder Herbst geerntet werden

Hinweis 2026-08-12:

> Die in unserer Internetmeldung vom 5. August 2026 ausgewiesene Gebietskulisse wird im Bundesland Steiermark um die Bezirke Graz, Graz-Umgebung, Hartberg-Fürstenfeld, Leibnitz, Südoststeiermark und Weiz erweitert.

Proben: `o6_6-harvest-region-burgenland`, `o6_6-harvest-region-noe-listed`, `o6_6-harvest-region-ooe-listed`, `o6_6-harvest-region-vienna`, `o6_6-harvest-region-stmk-added`, `o6_6-harvest-region-unlisted-region`, `o6_6-harvest-region-other-year`.

## Korrekte Umsetzungen und erhaltene Grenzen

Die tatsächlichen Verbraucher berücksichtigen alle sieben Anlagetermine und die festen aktuellen bzw. Folgejahres-Endtermine. Die Berechnung für V1 ab 2025 verwendet 70 Kalendertage und den 15. September; Root prüft die beiden veröffentlichten Beispiele eigenständig. Bei Untersaaten zählt tatsächlich die Hauptfruchternte statt des früheren Aussaatdatums.

Datierte N-/PSM-/Bodenbearbeitungsereignisse werden eingegrenzt. Eine kombinierte mineralische N-Gabe am Anlagetag bleibt verboten, erlaubte Futternutzung beendet den Zeitraum nicht. V7 behält das N-Verbot und lässt andere, ausdrücklich als für Raps zugelassen vorausgesetzte PSM zu. V6 weist auch kleine unzulässige Mischungspartner zurück und verbraucht den Nachbausaatgut-Nachweis. Saatgutnachweis, Mischungs-/Familienminima und die strikte Grenze „unter 10 %“ werden tatsächlich geprüft.

Die nationale 2026-Flächendeckungsausnahme wird nicht mit der gesonderten Bezirkskulisse für die Erntepflicht verwechselt. Bekanntermaßen nicht ordnungsgemäß angelegte Bestände erhalten daraus keine Freigabe. V1-Befahrungsverbot einschließlich Endtag und das reine Überqueren werden getrennt behandelt. Das 2024-NPF-Verbot wird nicht pauschal auf andere Jahre übertragen.

Offen bleiben die nativ dokumentierten Vorrang-/Auslegungsentscheidungen zum Walzen, zum erweiterten Methodenverzeichnis, zum Herbst-/Winterhärtebegriff der V1-Folgekultur und zum vertauschten V1/V2-Reihenfolgehinweis vom 5. August. Die unveränderte SRL enthält bereits die neue V1-Zeile ab 2025; ein alter SRL-Datumsstand wird nicht erfunden. Vollständiges Abfrosten von Pflanzen und lediglich gefrorener Boden werden fachlich getrennt. Für die strittige Walzen-Lesart wurde kein unbedingtes negatives Rechtsoracle erzeugt.

Die Tabelle mit insektenblütigen Beispielen und die stichtagsbezogenen Roggensortenlisten sind nicht automatisch abschließende Rechtstaxonomien. Tables besitzt deren Verbrauchergrenzen sowie den eigenständigen PSM-Methoden-Bypass. Root besitzt den bekannten Vorjahres-Ansaatfall; Inputs besitzt fehlende/null Nachweise, Typ-/Datumstress und App-Projektion; General besitzt Betrieb, Verwaltung und Prämienverbraucher. Fehlende Tatsachen werden als Eingabe-/Nachweisanforderung behandelt, nicht als bereits bewiesener Sachverstoß.

## Historische Regelabdeckung

60 echte IDs: **28 umgesetzt, 26 teilweise, drei externe Evidenz, drei offene Auslegungen**. Jede Zeile ist vollständig und einzeln in JSON begründet. „Umgesetzt“ bezeichnet den tatsächlichen Verbraucher unter seinem dokumentierten Tatsachenvertrag; es bestätigt keine realen Nachweise und keine behördliche Freigabe.

| Historische ID | Bewertung | Tatsächlicher Code | Quellen |
| --- | --- | --- | --- |
| `O6_6-ARABLE-ONLY` | umgesetzt | `parcel.rego:15–18` | Merkblatt S. 2 |
| `O6_6-DEF-ACTIVE-ESTABLISHMENT` | teilweise | `parcel.rego:28–36`, `helpers.rego:37–41` | Merkblatt S. 2 |
| `O6_6-DEF-FOLLOWING-MAIN-CROP` | teilweise | `parcel.rego:135–138`, `parcel.rego:389–392` | Merkblatt S. 2 |
| `O6_6-NOT-MAIN-CROP-NEXT-MFA` | umgesetzt | `parcel.rego:129–133` | Merkblatt S. 2, Merkblatt S. 3 |
| `O6_6-UNDERSOWING-DATE` | umgesetzt | `helpers.rego:37–41`, `parcel.rego:28–31` | Merkblatt S. 2, Merkblatt S. 3 |
| `O6_6-UNDERSOWING-CONDITIONS` | teilweise | `parcel.rego:60–81`, `parcel.rego:129–133`, `parcel.rego:328–356` | Merkblatt S. 3 |
| `O6_6-UNDERSOWING-EROSION` | umgesetzt | `helpers.rego:21–41`, `parcel.rego:60–81` | Merkblatt S. 3 |
| `O6_6-PROPER-ESTABLISHMENT` | teilweise | `notices_2026.rego:7–17`, `parcel.rego:60–64` | Merkblatt S. 2, Merkblatt S. 3, Hinweis 2026-08-05 |
| `O6_6-FULL-COVERAGE` | teilweise | `parcel.rego:60–64`, `notices_2026.rego:7–10` | Merkblatt S. 3, Hinweis 2026-08-05 |
| `O6_6-INADMISSIBLE-VOLUNTEER-SELF-GREENING` | umgesetzt | `parcel.rego:38–41` | Merkblatt S. 2 |
| `O6_6-INADMISSIBLE-CEREAL-MAIZE` | teilweise | `parcel.rego:43–58`, `helpers.rego:71–73`, `notices_2026.rego:13–17` | Merkblatt S. 2, Hinweis 2026-08-05 |
| `O6_6-VARIANT-VALID` | umgesetzt | `parcel.rego:10–13`, `helpers.rego:21–34` | Merkblatt S. 2 |
| `O6_6-SEED-PROOF` | umgesetzt | `parcel.rego:66–70` | Merkblatt S. 2 |
| `O6_6-WINTER-HARDINESS` | teilweise | `parcel.rego:99–104`, `parcel.rego:345–356` | Merkblatt S. 3, Merkblatt S. 9, Merkblatt S. 6 |
| `O6_6-NO-MINERAL-N` | umgesetzt | `parcel.rego:147–152`, `helpers.rego:58–62` | Merkblatt S. 3, Merkblatt S. 10 |
| `O6_6-ALLOWED-FERTILIZERS` | externe Evidenz | `parcel.rego:147–152`, `parcel.rego:282–292` | Merkblatt S. 3, Merkblatt S. 8, Merkblatt S. 9 |
| `O6_6-NO-PSM` | umgesetzt | `parcel.rego:154–160` | Merkblatt S. 3 |
| `O6_6-PSM-AFTER-NONMECH` | teilweise | `parcel.rego:162–182`, `parcel.rego:345–356` | Merkblatt S. 4, Merkblatt S. 6 |
| `O6_6-NO-TILLAGE` | umgesetzt | `parcel.rego:184–189` | Merkblatt S. 4 |
| `O6_6-DEEP-LOOSENING-STRIP-TILL` | teilweise | `parcel.rego:191–204` | Merkblatt S. 5 |
| `O6_6-ADDITIONAL-SOWING` | teilweise | `parcel.rego:206–212` | Merkblatt S. 5 |
| `O6_6-TILLAGE-OUTSIDE-PERIOD` | umgesetzt | `helpers.rego:58–62`, `parcel.rego:184–197` | Merkblatt S. 5 |
| `O6_6-CARE-DATES` | teilweise | `parcel.rego:214–232` | Merkblatt S. 4 |
| `O6_6-CARE-CONDITIONS` | teilweise | `parcel.rego:234–244` | Merkblatt S. 4 |
| `O6_6-PROBLEM-WEEDS` | teilweise | `parcel.rego:216–232` | Merkblatt S. 4 |
| `O6_6-ROLLING` | Auslegung offen | `parcel.rego:254–270` | Merkblatt S. 4, Merkblatt S. 5, SRL S. 54 |
| `O6_6-GROUND-CHOPPING-FROST` | umgesetzt | `parcel.rego:246–252` | Merkblatt S. 4 |
| `O6_6-USE` | teilweise | `parcel.rego:272–278` | Merkblatt S. 5 |
| `O6_6-NO-THRESHING` | umgesetzt | `parcel.rego:140–143` | Merkblatt S. 5 |
| `O6_6-MECH-REMOVAL` | teilweise | `parcel.rego:333–356` | Merkblatt S. 5, Merkblatt S. 6 |
| `O6_6-MECH-REMOVAL-FROST-ONLY` | teilweise | `parcel.rego:162–167`, `parcel.rego:345–356` | Merkblatt S. 6 |
| `O6_6-INPUTS-AFTER-PERIOD` | umgesetzt | `helpers.rego:58–62`, `parcel.rego:147–189` | Merkblatt S. 6, Merkblatt S. 4 |
| `O6_6-SOWING-DEADLINE` | umgesetzt | `parcel.rego:28–31`, `helpers.rego:27–41` | Merkblatt S. 8, Merkblatt S. 7, Merkblatt S. 9, Merkblatt S. 10 |
| `O6_6-PERIOD-END` | umgesetzt | `helpers.rego:44–53`, `parcel.rego:328–331` | Merkblatt S. 8, Merkblatt S. 7, Merkblatt S. 9, Merkblatt S. 10 |
| `O6_6-V1-PERIOD-70-DAYS` | umgesetzt | `helpers.rego:48–53` | Merkblatt S. 8 |
| `O6_6-MIXING-PARTNERS` | teilweise | `parcel.rego:72–76` | Merkblatt S. 8, Merkblatt S. 7, Merkblatt S. 9, Merkblatt S. 10 |
| `O6_6-PLANT-FAMILIES` | teilweise | `parcel.rego:78–81` | Merkblatt S. 8, Merkblatt S. 7, Merkblatt S. 10 |
| `O6_6-V1-INSECT-POLLINATED` | teilweise | `parcel.rego:83–91` | Merkblatt S. 8 |
| `O6_6-V1-NON-INSECT-SHARE` | umgesetzt | `parcel.rego:93–97` | Merkblatt S. 8 |
| `O6_6-V1-DRIVING-BAN` | umgesetzt | `parcel.rego:282–292` | Merkblatt S. 8, Merkblatt S. 9 |
| `O6_6-V1-FOLLOW-UP-CROP` | Auslegung offen | `parcel.rego:294–305` | Merkblatt S. 9 |
| `O6_6-V6-SPECIES` | umgesetzt | `parcel.rego:99–104` | Merkblatt S. 9 |
| `O6_6-V6-GREEN-RYE-VARIETIES` | teilweise | `parcel.rego:106–113` | Merkblatt S. 9 |
| `O6_6-V6-FARM-SAVED-SEED` | umgesetzt | `parcel.rego:115–120` | Merkblatt S. 9 |
| `O6_6-V6-NOT-MAIN-CROP` | umgesetzt | `parcel.rego:129–143` | Merkblatt S. 9, Merkblatt S. 10 |
| `O6_6-V7-WINTER-RAPE` | teilweise | `parcel.rego:122–126`, `parcel.rego:72–81` | Merkblatt S. 10 |
| `O6_6-V7-HERBICIDE` | teilweise | `parcel.rego:309–324` | Merkblatt S. 10 |
| `O6_6-V7-OTHER-PSM` | externe Evidenz | `parcel.rego:154–160` | Merkblatt S. 10 |
| `O6_6-V7-NO-MECH-REQUIREMENT` | umgesetzt | `parcel.rego:338–343` | Merkblatt S. 5, Merkblatt S. 10 |
| `O6_6-VARIANT-APPLICATION-DEADLINE` | umgesetzt | `premium.rego:54–59` | Merkblatt S. 11 |
| `O6_6-NO-LATE-CHANGES` | teilweise | `premium.rego:54–59` | Merkblatt S. 11 |
| `O6_6-WITHDRAW-VARIANT` | teilweise | `notices_2026.rego:32–44`, `premium.rego:61–65`, `parcel.rego:129–133` | Merkblatt S. 11, Hinweis 2026-08-05 |
| `O6_6-NPF-2024` | umgesetzt | `parcel.rego:20–24` | Merkblatt S. 13 |
| `O6_6-SRL-COMBINATION-TABLE` | teilweise | `parcel.rego:366–374` | SRL-Anhänge S. 103 |
| `O6_6-SRL-GW-OOE-NO-V3` | umgesetzt | `parcel.rego:359–364` | SRL S. 75 |
| `O6_6-SRL-GW-ACCESS` | externe Evidenz | `helpers.rego:75–75` | SRL S. 74, SRL S. 75 |
| `O6_6-N2026-COVERAGE` | umgesetzt | `notices_2026.rego:7–17`, `parcel.rego:43–64` | Hinweis 2026-08-05 |
| `O6_6-N2026-V1-V2-DEADLINES` | Auslegung offen | `parcel.rego:28–31`, `notices_2026.rego:32–44` | Merkblatt S. 8, Merkblatt S. 7, Hinweis 2026-08-05 |
| `O6_6-N2026-HARVEST-WAIVER` | teilweise | `notices_2026.rego:20–29`, `farm.rego:173–180` | Hinweis 2026-08-05, Hinweis 2026-08-12 |
| `O6_6-N2026-UNDERSOWING-EROSION` | umgesetzt | `notices_2026.rego:7–10`, `parcel.rego:60–81` | Hinweis 2026-08-12, Hinweis 2026-08-05, Merkblatt S. 3 |

## Vollständige Abschnittsprüfung

Alle 14 neuen Seiten und ihre Fortsetzungen sind erfasst. Mit „im zuständigen Teil geprüft“ bezeichnete Abschnitte wurden hier ebenfalls vollständig gelesen; die primäre Auswertung liegt beim ausdrücklich genannten Nachbarteil. 55 Abschnittszeilen dokumentieren auch die einschlägigen wiederverwendeten Quellen.

| Abschnitt | Seiten | Inhalt | Status |
| --- | --- | --- | --- |
| `MB1-scope-goals` | 1 | 1–2 Overview and goals | im zuständigen Teil geprüft |
| `MB1-contract` | 1 | 3.1 Annual commitment, actual cover period, automatic extension and lapse | im zuständigen Teil geprüft |
| `MB2-min-arable` | 2 | 3.2 Annual 1.50 ha arable minimum | im zuständigen Teil geprüft |
| `MB2-land` | 2 | 3.3 Arable land | geprüft |
| `MB2-active` | 2 | 4.1 Actual intermediate crop, active establishment, next-main crop and year | teilweise |
| `MB2-undersowing` | 2 | 4.1 Harvest substitutes for undersowing establishment date | geprüft |
| `MB2-proper` | 2 | 4.1 All proper-establishment techniques | teilweise |
| `MB2-disallowed` | 2 | 4.2 Volunteer, self-greening, cereal/maize share and V6 exception | geprüft |
| `MB2-variant-seedproof` | 2 | 5.1 Declared variant, active full cover and conditional invoice/label proof | geprüft |
| `MB3-cover-hardiness` | 3 | 5.1 Full cover, free variants, hardy/frost mixtures and V6 qualification | teilweise |
| `MB3-undersowing` | 3 | 5.2 Every undersowing condition and Erosionsschutz relationship | teilweise |
| `MB3-n` | 3 | 5.3 MineralN, simultaneous application, lawful N-free/organic inputs | geprüft |
| `MB3-psm` | 3 | 5.4 All PSM including slug bait; V7 exception | geprüft |
| `MB4-nonmech` | 4 | 5.4 PSM only after following sowing absent mechanical removal | teilweise |
| `MB4-tillage` | 4 | 5.5 Plant-killing tillage and knife-roller prohibition | geprüft |
| `MB4-care` | 4 | 5.5 Care dates, expected regrowth, erosion/nitrate effect and maintained cover | teilweise |
| `MB4-weeds` | 4 | 5.5 Four problem plants, non-ground-level chopping and kept evidence | teilweise |
| `MB4-rolling` | 4 | 5.5 Immediate seedbed reconsolidation and later rolling dates | Auslegung offen |
| `MB4-5-frost` | 4–5 | 5.5 Fully frost-killed chopping and following rolling sentence | Auslegung offen |
| `MB5-additional` | 5 | 5.5 Additional winter-hardy seed through drill coulters and allowed harrowing-in | teilweise |
| `MB5-strip-deep` | 5 | 5.5 Preserved-cover strip/deep loosening, no full-surface strip tillage | geprüft |
| `MB5-outside` | 5 | 5.5 Outside-period tillage and other-measure qualification | geprüft |
| `MB5-use` | 5 | 5.6 Forage/grazing permission, regrowth, continued period and no threshing | teilweise |
| `MB5-6-mechanical` | 5–6 | 5.7 Every allowed and excluded mechanical-removal route | teilweise |
| `MB6-inputs-after` | 6 | 5.7 No earlyPSM/N/tillage from early frost/mechanical effects | geprüft |
| `MB6-7-variant-table` | 6–7 | 5.8 Complete 8 year-specific table rows for 7 variants | geprüft |
| `MB8-v1-dates` | 8 | 5.8.1 V1 dates, day-count convention and both worked examples | geprüft |
| `MB8-v1-insect` | 8 | 5.8.1 Insect pollination, complete illustrative list and under 10% addition | teilweise |
| `MB8-9-v1-driving` | 8–9 | 5.8.1 Inclusive driving ban, crossing exception and autumn follow-up | Auslegung offen |
| `MB9-v2-v5` | 9 | 5.8.2 V2–5 repetition and hardy/frost mixtures | geprüft |
| `MB9-v6` | 9 | 5.8.3 Deadline, exact crop list, no small outside partner | geprüft |
| `MB9-v6-varieties` | 9 | 5.8.3 Four Austrian,19 EU varieties; savedseed evidence | teilweise |
| `MB9-10-v6-main` | 9–10 | 5.8.3 No next MFA main crop; rye/millet explanatory example | geprüft |
| `MB10-v7` | 10 | 5.8.4 Whole companion-sowing, herbicide, otherPSM, N and end clauses | teilweise |
| `MB10-application` | 10 | 6 Measure application, final 2027 entry and mutually exclusive Immergrün | im zuständigen Teil geprüft |
| `MB11-switch-erosion` | 11 | 6 Bidirectional switch and follow-up erosion variants | im zuständigen Teil geprüft |
| `MB11-app-changes` | 11 | 6 Both variantapplication deadlines, corrections, no grace/late changes | teilweise |
| `MB11-withdrawal` | 11 | 6 Immediate deletion/reduction and next MFAspringmaincrop case | teilweise |
| `MB11-12-transfer` | 11–12 | 6 Successor compliance, applicant liability and laterImmergrünlease | im zuständigen Teil geprüft |
| `MB12-lapse` | 12 | 6 Warning:1.50 ha/no appliedcover, lapse and new application | im zuständigen Teil geprüft |
| `MB12-exit` | 12 | 7 Full annual exit procedure and next-year cover obligations | im zuständigen Teil geprüft |
| `MB12-13-premium` | 12–13 | 8 All 7 premium bands, fund dependency and guaranteed minimum | im zuständigen Teil geprüft |
| `MB13-npf` | 13 | 8 2024 NPF nonfundability | geprüft |
| `MB13-updates` | 13 | 9 All revision bullets and impressum | Kontext |
| `MB14-impressum` | 14 | Impressum and nonbinding-disclaimer | Kontext |
| `SRL54` | 54 | 2.6 Definitions and all management obligations | teilweise |
| `SRL55` | 55 | 2.6 Complete variant table | geprüft |
| `SRL56` | 56 | 2.6 Complete premiumband table | im zuständigen Teil geprüft |
| `SRL74-75` | 74–75 | 2.16 Groundwater relationship, access, follow-up exceptions and OÖV3 ban | teilweise |
| `ANNEXL` | 103 | Complete combination row 6 and actual consumer | teilweise |
| `NOTICE0805` | HTML | All current August 5 main content: coverage, deadlines and conditional harvestregion | teilweise |
| `NOTICE0812` | HTML | All current August 12 main content, added harvest districts and undersowing | geprüft |
| `NOTICE-2026-05-22` | HTML | Full exact-hash earlier supplied main-content reading reused | im zuständigen Teil geprüft |
| `NOTICE-2026-06-12` | HTML | Full exact-hash earlier supplied main-content reading reused | im zuständigen Teil geprüft |
| `ATB-complete-shared` | 1–25 | General legal/admission/land/payment conditions | im zuständigen Teil geprüft |

## Öffentliche Entwicklungsproben

Alle 129 Zeilen sind neue, aus den aktuellen Originalquellen ausgewählte Prüfungen. Alle Queries und Sollwerte bleiben unverändert im eingefrorenen JSON. Die Tabelle zeigt numerische lokale Diagnosen: 1 = der abgefragte Tatbestand/Verstoß ist vorhanden, 0 = nicht vorhanden. Bei Gebietskontrollen steht 1 nur für den regionalen Bestandteil. Ein solcher Zahlenwert ist kein vollständiger Förderbescheid.

| Fall-ID | Soll | Ist | Ergebnis |
| --- | ---: | ---: | --- |
| `o6_6-sowing-v1-exact` | 0 | 0 | erfüllt |
| `o6_6-sowing-v1-next-day` | 1 | 1 | erfüllt |
| `o6_6-sowing-v2-exact` | 0 | 0 | erfüllt |
| `o6_6-sowing-v2-next-day` | 1 | 1 | erfüllt |
| `o6_6-sowing-v3-exact` | 0 | 0 | erfüllt |
| `o6_6-sowing-v3-next-day` | 1 | 1 | erfüllt |
| `o6_6-sowing-v4-exact` | 0 | 0 | erfüllt |
| `o6_6-sowing-v4-next-day` | 1 | 1 | erfüllt |
| `o6_6-sowing-v5-exact` | 0 | 0 | erfüllt |
| `o6_6-sowing-v5-next-day` | 1 | 1 | erfüllt |
| `o6_6-sowing-v6-exact` | 0 | 0 | erfüllt |
| `o6_6-sowing-v6-next-day` | 1 | 1 | erfüllt |
| `o6_6-sowing-v7-exact` | 0 | 0 | erfüllt |
| `o6_6-sowing-v7-next-day` | 1 | 1 | erfüllt |
| `o6_6-termination-v2-previous-day` | 1 | 1 | erfüllt |
| `o6_6-termination-v2-exact` | 0 | 0 | erfüllt |
| `o6_6-termination-v3-previous-day` | 1 | 1 | erfüllt |
| `o6_6-termination-v3-exact` | 0 | 0 | erfüllt |
| `o6_6-termination-v4-previous-day` | 1 | 1 | erfüllt |
| `o6_6-termination-v4-exact` | 0 | 0 | erfüllt |
| `o6_6-termination-v5-previous-day` | 1 | 1 | erfüllt |
| `o6_6-termination-v5-exact` | 0 | 0 | erfüllt |
| `o6_6-termination-v6-previous-day` | 1 | 1 | erfüllt |
| `o6_6-termination-v6-exact` | 0 | 0 | erfüllt |
| `o6_6-termination-v7-previous-day` | 1 | 1 | erfüllt |
| `o6_6-termination-v7-exact` | 0 | 0 | erfüllt |
| `o6_6-undersowing-harvest-08-05` | 0 | 0 | erfüllt |
| `o6_6-undersowing-harvest-08-06` | 1 | 1 | erfüllt |
| `o6_6-input-mineral_n_fertilization-before` | 0 | 0 | erfüllt |
| `o6_6-input-mineral_n_fertilization-establishment` | 1 | 1 | erfüllt |
| `o6_6-input-mineral_n_fertilization-last-protected` | 1 | 1 | erfüllt |
| `o6_6-input-mineral_n_fertilization-earliest-break` | 0 | 0 | erfüllt |
| `o6_6-input-psm_application-before` | 0 | 0 | erfüllt |
| `o6_6-input-psm_application-establishment` | 1 | 1 | erfüllt |
| `o6_6-input-psm_application-last-protected` | 1 | 1 | erfüllt |
| `o6_6-input-psm_application-earliest-break` | 0 | 0 | erfüllt |
| `o6_6-input-tillage-before` | 0 | 0 | erfüllt |
| `o6_6-input-tillage-establishment` | 1 | 1 | erfüllt |
| `o6_6-input-tillage-last-protected` | 1 | 1 | erfüllt |
| `o6_6-input-tillage-earliest-break` | 0 | 0 | erfüllt |
| `o6_6-allowed-fertilizer-mineral_basic_fertilization_without_n` | 0 | 0 | erfüllt |
| `o6_6-allowed-fertilizer-farm_manure_application` | 0 | 0 | erfüllt |
| `o6_6-allowed-fertilizer-secondary_raw_material_application` | 0 | 0 | erfüllt |
| `o6_6-deep-preserved` | 0 | 0 | erfüllt |
| `o6_6-deep-destroyed` | 1 | 1 | erfüllt |
| `o6_6-strip-preserved` | 0 | 0 | erfüllt |
| `o6_6-strip-full-surface` | 1 | 1 | erfüllt |
| `o6_6-additional-sowing-true` | 0 | 0 | erfüllt |
| `o6_6-additional-sowing-false` | 1 | 1 | erfüllt |
| `o6_6-harrowing-additional-crops` | 0 | 0 | erfüllt |
| `o6_6-care-v3-10-31` | 1 | 1 | erfüllt |
| `o6_6-care-v3-11-01` | 0 | 0 | erfüllt |
| `o6_6-care-v1-09-14` | 1 | 1 | erfüllt |
| `o6_6-care-v1-09-15` | 0 | 0 | erfüllt |
| `o6_6-problem-weed-chopping-allowed` | 0 | 0 | erfüllt |
| `o6_6-problem-weed-mowing-not-the-exception` | 1 | 0 | unerfüllt; oben abgegrenzt |
| `o6_6-problem-weed-ground-level-not-the-exception` | 1 | 1 | erfüllt |
| `o6_6-care-condition-preserved` | 0 | 0 | erfüllt |
| `o6_6-care-condition-coverage-lost` | 1 | 1 | erfüllt |
| `o6_6-care-condition-no-regrowth` | 1 | 1 | erfüllt |
| `o6_6-ground-chopping-frost-true` | 0 | 0 | erfüllt |
| `o6_6-ground-chopping-frost-false` | 1 | 1 | erfüllt |
| `o6_6-rolling-seedbed-immediate` | 0 | 0 | erfüllt |
| `o6_6-rolling-before-care` | 1 | 1 | erfüllt |
| `o6_6-rolling-at-care` | 0 | 0 | erfüllt |
| `o6_6-use-use_mowing_removal-true` | 0 | 0 | erfüllt |
| `o6_6-use-use_mowing_removal-false` | 1 | 1 | erfüllt |
| `o6_6-use-grazing-true` | 0 | 0 | erfüllt |
| `o6_6-use-grazing-false` | 1 | 1 | erfüllt |
| `o6_6-forage-use-does-not-end-period` | 1 | 1 | erfüllt |
| `o6_6-actual-cover-crop-threshed-after-minimum-period` | 1 | 1 | erfüllt |
| `o6_6-v1-noninsect-share-9.99` | 0 | 0 | erfüllt |
| `o6_6-v1-noninsect-share-10` | 1 | 1 | erfüllt |
| `o6_6-partners-exact` | 0 | 0 | erfüllt |
| `o6_6-partners-one-less` | 1 | 1 | erfüllt |
| `o6_6-families-exact` | 0 | 0 | erfüllt |
| `o6_6-families-one-less` | 1 | 1 | erfüllt |
| `o6_6-v1-driving-last-banned` | 1 | 1 | erfüllt |
| `o6_6-v1-driving-first-free` | 0 | 0 | erfüllt |
| `o6_6-v1-driving-crossing-only` | 0 | 0 | erfüllt |
| `o6_6-v1-driving-2024-09-30` | 1 | 1 | erfüllt |
| `o6_6-v1-driving-2024-10-01` | 0 | 0 | erfüllt |
| `o6_6-seed-proof-true` | 0 | 0 | erfüllt |
| `o6_6-seed-proof-false` | 1 | 1 | erfüllt |
| `o6_6-coverage-ordinary-no-coverage` | 1 | 1 | erfüllt |
| `o6_6-coverage-drought-proper` | 0 | 0 | erfüllt |
| `o6_6-coverage-drought-improper` | 1 | 1 | erfüllt |
| `o6_6-cereal-share-fifty` | 0 | 0 | erfüllt |
| `o6_6-cereal-share-above-fifty` | 1 | 1 | erfüllt |
| `o6_6-cereal-share-drought-volunteer` | 0 | 0 | erfüllt |
| `o6_6-cereal-share-drought-nonvolunteer` | 1 | 1 | erfüllt |
| `o6_6-cereal-share-ordinary-volunteer` | 1 | 1 | erfüllt |
| `o6_6-solely-volunteer-stand` | 1 | 1 | erfüllt |
| `o6_6-v6-pure-allowed-crop` | 0 | 0 | erfüllt |
| `o6_6-v6-small-senf-addition` | 1 | 1 | erfüllt |
| `o6_6-v6-farm-saved-proof-true` | 0 | 0 | erfüllt |
| `o6_6-v6-farm-saved-proof-false` | 1 | 1 | erfüllt |
| `o6_6-v7-herbicide-stage-day-unimpaired` | 0 | 0 | erfüllt |
| `o6_6-v7-herbicide-stage-day-impaired` | 1 | 1 | erfüllt |
| `o6_6-v7-herbicide-after-stage` | 1 | 1 | erfüllt |
| `o6_6-v7-herbicide-after-end-unimpaired` | 0 | 0 | erfüllt |
| `o6_6-v7-herbicide-after-end-impaired` | 0 | 1 | unerfüllt; oben abgegrenzt |
| `o6_6-v7-approved-other-psm` | 0 | 0 | erfüllt |
| `o6_6-v7-mineral-n-still-banned` | 1 | 1 | erfüllt |
| `o6_6-mechanical-plough` | 0 | 0 | erfüllt |
| `o6_6-mechanical-harrowing` | 1 | 1 | erfüllt |
| `o6_6-mechanical-autumn_topping` | 1 | 1 | erfüllt |
| `o6_6-v7-no-mechanical-duty` | 0 | 0 | erfüllt |
| `o6_6-psm-nonmechanical-before-following-sowing` | 1 | 1 | erfüllt |
| `o6_6-psm-nonmechanical-after-following-sowing` | 0 | 0 | erfüllt |
| `o6_6-application-v1-08-31` | 0 | 0 | erfüllt |
| `o6_6-application-v1-09-01` | 1 | 1 | erfüllt |
| `o6_6-application-v7-09-30` | 0 | 0 | erfüllt |
| `o6_6-application-v7-10-01` | 1 | 1 | erfüllt |
| `o6_6-withdraw-main-crop-next-mfa` | 1 | 0 | unerfüllt; oben abgegrenzt |
| `o6_6-withdraw-known-late-establishment` | 1 | 1 | erfüllt |
| `o6_6-npf-year-2024` | 1 | 1 | erfüllt |
| `o6_6-npf-year-2025` | 0 | 0 | erfüllt |
| `o6_6-groundwater-v3-both` | 1 | 1 | erfüllt |
| `o6_6-groundwater-v3-outside-area` | 0 | 0 | erfüllt |
| `o6_6-groundwater-v3-without-measure16` | 0 | 0 | erfüllt |
| `o6_6-harvest-region-burgenland` | 1 | 1 | erfüllt |
| `o6_6-harvest-region-noe-listed` | 1 | 1 | erfüllt |
| `o6_6-harvest-region-ooe-listed` | 1 | 1 | erfüllt |
| `o6_6-harvest-region-vienna` | 1 | 1 | erfüllt |
| `o6_6-harvest-region-stmk-added` | 1 | 1 | erfüllt |
| `o6_6-harvest-region-unlisted-region` | 0 | 0 | erfüllt |
| `o6_6-harvest-region-other-year` | 0 | 0 | erfüllt |
| `o6_6-drought-undersowing-erosion` | 0 | 0 | erfüllt |

Dieses Dossier schließt den Maßnahmenteil von Run 8/26 ab. Die gemeinsame Sammlung, das gesamte Replay und der unabhängige Schluss-QC liegen bei Root. Es wurden keine historischen oder produktiven Regeln repariert und keine weiteren Runs begonnen.

## Metadatenkorrektur vom 15. Oktober 2026

Der Abschnitt `ATB-complete-shared` enthielt versehentlich `page_end: 25`. Das gebundene Original hat 21 PDF-Seiten; der Eintrag ist auf 21 korrigiert. Wörtliche Belege, Eingaben, Queries und Sollwerte bleiben unverändert. Die gemeinsame Sammlung und alle 391 Fälle werden für die neuen Hashbindungen erneut reproduziert; dies ändert kein fachliches Urteil.
