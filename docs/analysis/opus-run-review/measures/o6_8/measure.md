# o6_8 – Erosionsschutz Acker: Verfahren, Übergänge und Prämienkomponenten

Geprüft wurde ausschließlich der rohe historische Opus-Run `v2-o6_8-opus-5.5-high-20261001` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieser Teil enthält **65 historische Regelbewertungen, 55 Quellenabschnitte, fünf abgegrenzte Befunde und 131 neu abgeleitete öffentliche Quellen- und Grenzfälle**. Alle 131 Aufrufe sind bei strikter Builtin-Prüfung mit Exitcode 0 definiert: **128 Erwartungen erfüllt, drei abweichend**.

Die drei Gegenfälle betreffen eine falsche Fristdiagnose bei tatsächlich im Herbst gesäten Winterackerbohnen, einen doppelt zählenden ungenutzten Fallbackhelfer und eine fehlende Diagnose bekannter gleichzeitiger Teilnahme an den Maßnahmen 6 und 7. Zwei weitere Befunde dokumentieren begrenzte Verfahrens-/DIV-Helfer sowie undatierte Pflichtzeit-Aggregate. Diese beiden Grenzen werden ohne erfundene negative Ereignis- oder Zahlungsoracles festgehalten. Lokale Diagnose, Helferwert, nominelle Prämienkomponente und behördliche Auszahlung bleiben getrennt.

Das neue Merkblatt wurde auf **allen zwölf Seiten vollständig gelesen**, einschließlich aller vier Verfahren, jeder Tabellenzelle und Kulturzeile, der beiden 2023-Übergangsbeispiele, des BAW-Beispiels mit 0,10/0,40 ha, sämtlicher Ausnahmen, Änderungshinweise sowie Impressum und Schlussdisclaimer. Vollständig gelesen wurden `ms_ds.rego`, `ah.rego`, `baw.rego`, `us.rego`, `crops.rego`, `common.rego`, `premium.rego` und `cross_measures.rego`. Die relevanten aktuellen `general.rego`-Verbraucher und alle 24 ursprünglichen Annahmen samt Eingabevorschlägen wurden abgeglichen. General besitzt die eigenständige vollständige Bewertung der allgemeinen Regeln und Hinweise.

Die acht Manifestquellen bestimmen die Bewertung. Für sieben gemeinsame Quellen wurden die identischen Hashes zur früheren vollständigen Lektüre überprüft; aktuelle einschlägige SRL-/ATB-/Anhangsklauseln wurden erneut gelesen. **GSP-AV ist diesem Run nicht geliefert.** Sie wird weder rückwirkend als Modellquelle behauptet noch als ungebundenes negatives Oracle verwendet. Studienlabels, Referenzantworten, GM-Urteile, historische Selbsttests und manuelle Adaptationstest-Sollwerte wurden nicht als Orakel benutzt. Historische Policies, Profil und Quellen bleiben unverändert; es wurden keine zusätzlichen synthetischen Katalog-IDs erzeugt.

## Eingefrorene Bindung und Ausführung

Alle vollständigen Bewertungen, Eingaben, Queries, Sollwerte, Beobachtungen und Belege stehen in [measure.json](/workspace/scratch/opus-o6-1a-source-audit/docs/analysis/opus-run-review/measures/o6_8/measure.json). Eingefrorener SHA-256: `a3c94b42fcb5edeb6b94e226dfc742677d5296830d51cb5f1248e84207ea6767`. Sämtliche **496 Belegvorkommen**, **97 Codezeilenspannen** und **51 numerischen PDF-Seitenspannen** wurden gegen die unveränderten Originaldateien überprüft. Jede Quelle ist anhand Hash und Bytezahl gebunden; das neue Merkblatt hat zwölf Seiten, die ATB tatsächlich 21.

Jede Probe lädt mit `/tmp/issue-51-review-opa` und `--strict-builtin-errors` die vollständigen nativen Verzeichnisse `workspace/policy` und `workspace/data`. Die native Gesamtquery lautet **`data.oepul.o6_8.decision`**, die statischen Daten liegen unter **`data.o6_8.*`**. Es gibt keine Dateiabflachung, Namespacekorrektur, Typkonvertierung oder Zahlennormalisierung. Alle Erwartungen verwenden `equals` auf expliziten Zahlen, Booleans oder Strings. Zahlen 0/1 werden nicht als Booleans umgedeutet, String-/Tupelmengen nicht als Arrays aus Regelobjekten behandelt.

Vor dem endgültigen Replay wurden ausschließlich die neu verfassten Entwicklungsinputs auf Tatsachenkonsistenz geprüft. KG 31001 ist gemäß Original-Anhang F Bocksdorf in Burgenland/Güssing; alle BAW-Fälle verwenden diese konsistente Lage und ausdrücklich gültige Erosionspfadgeometrie. Andere Verfahren tragen keine unbenötigte falsche KG-Angabe. Wien-Kontrollen haben keinen fälschlich mitgeführten Amstettner Schlagbezirk. Direktsaat- und Strip-Till-Fakten stimmen mit ihren kanonischen Bearbeitungstypen überein; die Inputs behaupten nur Verfahrensobjekte der tatsächlich gewählten Codes. Dies korrigiert die Konstruktion neuer Fälle vor dem Replay; es verändert keine historischen Inputs oder Policies und normalisiert keine Laufzeitdaten. Keine Query oder Erwartung wurde dadurch geändert.

| Vollständig gelesenes Modul | Zeilen | SHA-256 |
| --- | ---: | --- |
| [ms_ds.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego) | 175 | `699938fe0cfda53272559b7c713c5162596bd2c628b226b044a015c6331ba012` |
| [ah.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ah.rego) | 53 | `c4869c62fc1f83f2ec17a48cf54d2b6b53a3ed70dd12227a2d1b5bad19a42cdd` |
| [baw.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego) | 226 | `ff11eeff6ac33df30e9c6ea68b1703f66e57e9527501c77d0b406d0b8de5fc91` |
| [us.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego) | 98 | `5de9a07e97e95f0f132e52a2005dcc4cd8b9e1cf9088f70fbb37c973ecddebda` |
| [crops.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego) | 73 | `8817bbeb4dc076eba220d21dd01518ba1ef1ec0024e3ceb627888792ab235b14` |
| [common.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/common.rego) | 97 | `75f4f0a3ac1214d548bf65e2f140e53d1694e635b052a0bdcac4670125522092` |
| [premium.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego) | 173 | `8d34ad7671722dfbf4f9e7d453f46f0b45059976b0ce4f180ed30854a7e1bca6` |
| [cross_measures.rego](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/cross_measures.rego) | 53 | `bb1ee1fab82c9c590b8f37011f984b609f73d33170099ea2ff6bce1c70be051b` |

| Gebundene Quelle | Lektürebindung | SHA-256 |
| --- | --- | --- |
| [20241011_srl_oepul_2023.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich (94 Seiten) | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| [20241011_srl_oepul_2023_anhaenge.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich (103 Seiten) | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| [2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| [2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| [2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| [2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html](/workspace/scratch/opus-candidates-source/sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| [o6_8_erosionsschutz_acker_2026_04.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf) | Neu: alle zwölf Seiten vollständig | `3ac0d16ddd039ad87fc3364e98ce46ff23a21966f71a7c00efa3130e21490693` |
| [o6_allgemeine_teilnahmebedingungen_2026_04.pdf](/workspace/scratch/opus-candidates-source/sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) | Identischer Hash zur früheren vollständigen Lektüre; aktueller einschlägiger Abgleich (21 Seiten) | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

## Befunde

### O68-MEASURE-01: Winterackerbohnen werden von der tatsächlichen Herbstsaat statt vom vergleichbaren Sommerfenster aus gemessen

Der tatsächliche Hauptfruchtanbau bleibt der 15. Oktober 2024. Die Untersaat erfolgt tatsächlich am 15. April 2025 und liegt ausdrücklich im fachlich bestätigten vergleichbaren Sommerackerbohnenfenster sowie vor dem 30. April. Der generische 56-Tage-Zweig misst trotzdem vom tatsächlichen Herbsttermin aus und meldet einen Verstoß: Ist 1 statt Soll 0. Es wurde kein künstlicher Hauptfruchtanbau im Frühjahr eingesetzt, um die Prüfung passend zu machen. Die gesonderte Kalenderkontrolle erkennt eine Anlage am 1. Mai dagegen korrekt als verspätet. Der Befund ist eine falsche lokale Fristdiagnose. Ein vollständiger App-Vertrag müsste den vergleichbaren Zeitraum als Fachbefund abbilden; daraus wird kein bestimmter behördlicher Abzug errechnet.

Einordnung: `source_coverage_or_semantics`; Familie `TEMPORAL_SCOPE`. Code: [us.rego:23–46](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:23).

Merkblatt S. 4:

> Beim Anbau von Winterackerbohnen hat die Anlage der Untersaat in einem vergleichbaren Zeitraum wie bei Sommerackerbohnen (8 Wochen nach dem Anbau), spätestens jedoch am 30. April, zu erfolgen.

Merkblatt S. 4:

> Es hat eine aktive Anlage von flächendeckenden Untersaaten mit mindestens 3 Mischungspartnern zwischen den Reihen der Hauptkultur spätestens 8 Wochen nach dem Anbau von Ackerbohne, Kürbis, Mais, Soja, Sonnenblume, Sorghum und Sudangras – spätestens jedoch am 30. Juni – zu erfolgen.

Proben: `o6_8-winter-bean-actual-autumn-legitimate-spring`, `o6_8-winter-bean-april30-calendar-cutoff`.

### O68-MEASURE-02: Fallbackhelfer zählt einen Schlag mit zwei Verfahren doppelt

Der Fall enthält einen tatsächlichen 0,06-ha-Schlag „Frühkartoffeln/Mais“: zunächst Kartoffeln mit Anhäufungen, danach Maisanbau am 10. Juni und Untersaat am 20. Juni. Beide Verfahrensbedingungen sind erfüllt. Die unbenannte Codekombination AH+US wird hierbei **ausdrücklich unter der ursprünglichen nativen Annahme A04** verwendet. Die Quelle benennt MS+US und DS+US; der Fall begründet keine eigenständige neue Genehmigung für AH+US. Innerhalb dieses angenommenen Eingabevertrags zählt der exponierte Fallbackhelfer den Schlag pro Code und gibt 0,12 ha statt 0,06 ha zurück. Die tatsächlich konsumierte Hauptsummierung dedupliziert dagegen bereits korrekt auf 0,06 ha und verfehlt die Mindestfläche. Der Fallbackhelfer fließt nicht in die Gesamtentscheidung ein. Eine falsche positive Schlusszahlung wird nicht behauptet.

Einordnung: `source_helper_component`; Familie `EVENT_SEMANTICS`. Code: [premium.rego:43–48](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:43), [premium.rego:26–35](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:26).

Merkblatt S. 2:

> In jedem Teilnahmejahr muss auf einer Fläche von zumindest 0,10 ha mit einer der unter Kapitel 4 angeführten erosionsmindernden Verfahren an der Maßnahme teilgenommen werden.

Proben: `o6_8-fallback-double-procedure-physical-area`, `o6_8-main-area-deduplicates-double-procedure`.

### O68-MEASURE-03: Bekannte gleichzeitige Teilnahme an 6 und 7 wird nicht diagnostiziert

Der historische Katalog erfasst das ausdrückliche betriebsweite Verbot korrekt. Der ausführende Kombinationscheck prüft lediglich, ob mindestens eine der beiden Nummern in der aktuellen Teilnehmermenge vorkommt. Enthält die Menge nachweislich beide, wird keine Exklusivitätsdiagnose erzeugt: Ist 0 statt Soll 1. Diese neue Probe erwartet ausschließlich die Erkennung der bekannten verbotenen Kombination. Sie setzt weder eine spezielle automatische Sanktion noch einen zwingenden Gesamtbetrag von null voraus. Die fehlende Ausführung wird als Verfahrensabdeckung festgehalten; sie ist nicht mit einer bloß unbekannten Anmeldung verwechselt.

Einordnung: `source_procedural_coverage`; Familie `FOREIGN_SCOPE`. Code: [ms_ds.rego:17–25](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:17).

SRL S. 18:

> Eine gleichzeitige Teilnahme des Betriebes an folgenden Maßnahmen ist nicht möglich:

SRL S. 18:

> „Begrünung von Ackerflächen – Zwischenfrucht“ (6) und „Begrünung von A ckerflächen – System Immergrün“ (7).

Proben: `o6_8-known-both6and7-missing-diagnostic`.

### O68-MEASURE-04: DIV- und Verwaltungshilfen bestätigen jeweils nur einen Teil der Voraussetzungen

Der BAW-DIV-Helfer prüft die Teilnahme an UBB/BIO und die zulässige Schlagnutzung. Die zusätzlich in der SRL verlangten DIV-Pflege-/Nutzungsbedingungen c und d prüft er nicht. Die Transfer- und Umwandlungshelfer geben passende Rollenfolgen beziehungsweise Ziel-/Datumsgrenzen aus, konsumieren aber keinen tatsächlichen Antrags-/Übernahmeverlauf und führen die Restverpflichtungen nicht weiter. Für die Korrektur unmöglicher Kombinationen bis zur Auszahlungsmitteilung fehlen ausführbare Symbole und die erforderlichen Verfahrensdaten vollständig. Positive Helferkontrollen setzen die übrigen Pflichten ausdrücklich als erfüllt voraus und bestätigen nur den begrenzten geprüften Teil. Es wird weder eine vollständig nachgewiesene DIV-Anrechnung noch eine zusätzliche rechtswidrige Biodiversitätszahlung behauptet.

Einordnung: `source_component_coverage_boundary`; Familie `EXTERNAL_DEPENDENCY`. Code: [baw.rego:115–122](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:115), [baw.rego:209–226](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:209), [general.rego:236–240](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego:236).

SRL S. 29:

> Pflege/Nutzungsauflagen gemäß Punkt c und d erfüllt werden.

ATB S. 13:

> Sollten unmögliche Maßnahmenkombinationen beantragt worden sein, sind Korrekturen zur Behebung der unmöglichen Maßnahmenkombinationen bis zum Erhalt der Auszahlungsmitteilung zulässig, sofern keine Beanstandung bei einer Vor-Ort-Kontrolle oder Ähnliches vorliegt. Wichtig ist, dass bis zur Abmeldung alle Förderverpflichtungen eingehalten werden.

SRL S. 29:

> Begrünte Abflusswege in der Maßnahme „Erosionsschutz Acker“ (8) sowie Auswaschungsgefährdete Ackerflächen im Rahmen der Maßnahme „V orbeugender Grundwasserschutz – Acker“ (16) sind anrechenbar, sofern die Pflege/Nutzungsauflagen gemäß Punkt c und d erfüllt werden.

Proben: `o6_8-baw-div-partial-ubb-gruenbrache`, `o6_8-baw-conversion-18-last-day`.

### O68-MEASURE-05: Undatierte Bewirtschaftungsangaben brauchen einen ausdrücklich begrenzten Pflichtzeitraum

Die Quelle begrenzt das BAW-Betriebsmittelverbot auf den Zeitraum ab 1. Jänner des ersten Deklarationsjahres bis zum Umbruch oder zur anderweitigen Deklaration. Für die Untersaat endet das Bodenbearbeitungs-/Herbizidverbot mit der Hauptfruchternte. Die nativen zusammenfassenden Booleans enthalten keine einzelnen Ereignisdaten und keine passende End-/Umdeklarationsprüfung. Ein vorverarbeiteter Befund ausschließlich für den verbotenen Zeitraum funktioniert; ein pauschaler Eintrag über alle nachfolgenden Anwendungen kann erlaubte spätere Maßnahmen nicht unterscheiden. Deshalb wird diese Zeitprojektion als Eingabe-/Nachweisgrenze dokumentiert. Aus einem undatierten oder widersprüchlichen Aggregat wurde kein künstlicher normaler negativer Rechtsfall hergestellt. Die bekannten positiven Ereignis-Gegenkontrollen liegen ausdrücklich innerhalb des verbotenen Zeitraums.

Einordnung: `app_temporal_projection_contract`; Familie `TEMPORAL_SCOPE`. Code: [baw.rego:124–140](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:124), [us.rego:69–78](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:69).

Merkblatt S. 4:

> Der Einsatz von Pflanzenschutzmitteln und Düngemitteln ist vom 1. Jänner des Jahres der ersten Angabe des Schlages als begrünter Abflussweg im Mehrfachantrag bis zum Umbruch oder bis zur anderweitigen Deklaration der Fläche nicht erlaubt.

Merkblatt S. 5:

> Eine Bodenbearbeitung oder ein Herbizideinsatz sind nach der Anlage der Untersaat bis zur Ernte der Hauptkultur nicht erlaubt. Striegeln zählt als Bodenbearbeitung und ist daher nicht gestattet.

Proben: `o6_8-baw-known-restricted-psm_used_since_first_declaration`, `o6_8-us-known-herbicide_after_sowing-breach`.

## Korrekte Umsetzungen und offene Auslegungen

Alle vier Verfahren haben tatsächliche Verbraucher. Die Kulturlisten werden nicht nur gespeichert: Kartoffeln bleiben bei MS, DS wird dafür abgelehnt; neue US-Kulturen werden ab dem jeweiligen Jahr zugelassen, Kleegras als BAW nur als bestehender Bestand. Tables prüft unabhängig alle 73 Kulturzeilen, sämtliche zwölf Tarife, alle 1.952 KG-Zeilen in sechs Feldern und alle 420 Kombinationskoordinaten. Dieser Teil prüft ausgewählte reale Prämienverbraucher zusätzlich zu den ausführlichen physischen und zeitlichen Verfahrensgrenzen.

MS/DS berücksichtigt die passenden Vorfruchtvarianten, ÖPUL-2015 ausschließlich für 2023, GLÖZ-8-NPF ausschließlich für 2025, das tatsächliche Überwintern und die fortbestehende Immergrün-Teilnahme. Der erste Frühling nach einem Wechsel aus Immergrün erhält über diese Vorfrucht keine Freigabe; AH/BAW/US bleibt als Alternative möglich. Ein gültiger vorbereiteter Vorfruchtbefund ersetzt jedoch keine vollständige erneute Ausführung der Maßnahmen 6 oder 7.

Bekanntes Pflügen, wendende/tief mischende Bearbeitung, fehlender Oberflächenmulch und Tiefenlockerung ohne erhaltene Begrünung werden tatsächlich erkannt. Die 28-Tage-Grenze, Direktsaat im Schlitz und sämtliche Strip-Till-Bedingungen haben passende positive/negative Grenzkontrollen. Bei AH werden zwei Meter Abstand, Furche/Fahrgasse, bedingtes Auslassen jeder vierten Saatkartoffelreihe, geeignete Technik, Wirksamkeit und Erhalt bis zur Krautminderung berücksichtigt. Die notwendige Zweck-/Dokumentationsbewertung bleibt ein fachlich vorbereiteter Befund; die OR-Benennung des kombinierten Notwendigkeitsfeldes wird nicht zu einer neuen unabhängigen Erlaubnis ausgedehnt.

BAW berücksichtigt die notwendige KG-Kulisse und den gesonderten tatsächlichen Erosionspfad. Das veröffentlichte 0,10→0,40-ha-Beispiel wird mit einem tatsächlich abgegrenzten 0,40-ha-BAW-Schlag geprüft. Ein insgesamt zu groß mit BAW beantragter Schlag wird nicht heimlich als korrekt abgegrenzte Teilfläche umgedeutet. Die Neueinsaatgrenze 15. Mai, Winterhärte und strikt unter 50 % Leguminosen werden ebenso verbraucht wie die Ausnahme für bestehende Grünbrache-/Feldfutterbestände, der 15. September im zweiten Jahr und das maßgebliche Anlagejahr bei lagegenauer Nachfolge.

Bekannte BAW-Mahd-/Häckselhistorie, Beweidungs-/Druschverbot, Begrünungserhalt, Ausschluss früheren MFA-2020-Grünlands, teilweise GLÖZ-Flächen und NPF bis einschließlich 2024 wirken tatsächlich. Die Hauptsummierung der jährlichen Mindestteilnahme dedupliziert Schläge korrekt. Die GLÖZ-Flächenkontrollen setzen ausdrücklich räumlich getrennte Teilflächen innerhalb der bereits abgegrenzten und gedeckelten BAW-Fläche voraus; aus unbekannter räumlicher Überlappung wird keine unbelegte Abzugsreihenfolge erfunden. Ein einzelnes letztes Pflegejahr kann die vollständige frühere Zweijahreshistorie nicht rekonstruieren.

US kontrolliert die gewöhnlichen 56 Tage und den 30. Juni, mindestens drei Mischungspartner, Anlage zwischen den Reihen, bedingten Saatgutnachweis, Deckung/Feldaufgang und bekannte verbotene Eingriffe. Die tatsächliche Sammlung der Untersaat als Erntegut wird von zulässigem bloßem Köpfen getrennt. Der Übergang zur Zwischenfrucht benutzt die Hauptfruchternte als Datum, bleibt aber ein begrenzter Datumshelfer ohne vollständige Prüfung aller Bedingungen der Maßnahme 6. Aus dem Wortlaut „vor“ gegenüber einem allgemeinen letzten Anlagetag wird hier kein unqualifiziertes neues Grenzoracle konstruiert.

Die richtige Kombination MS+US beziehungsweise DS+US wird in der Komponentenberechnung tatsächlich addiert. AH/BAW/US benötigen keine Teilnahme an 6 oder 7. Die Wien-Option sperrt MS/DS und lässt andere Verfahren unberührt; BAW erhält nur die ausdrücklich zulässigen LSE-Ausnahmen. Die Prämientabelle und der BIO-US-Zuschlag werden wirklich konsumiert. Solche Komponenten sind eine Schätzung für konforme codierte Flächen und keine vollständige Entscheidung über Verwaltungsverfahren, Sanktionen oder tatsächliche Auszahlung.

Vier Auslegungen bleiben sichtbar: BAW-Viertelgrenze gegenüber SRL-Teilflächen/Kappung (A01), der durch die Quelle nicht eindeutig bestimmte Überlebende bei MS/DS+AH und die native Wahl beider Komponenten null (A03), die Sudangras-Erweiterung im späteren Merkblatt gegenüber dem gelieferten SRL-Wortlaut (A02) sowie die Ausdehnung des 2026-Deckungshinweises auf Feldaufgang (A12). Eine allgemeine Berücksichtigung der Dürre bei Kontrollen wird nicht stillschweigend zu einer pauschalen Aufhebung aller Aufgangspflichten. General besitzt die fünf aktuellen Hinweisregeln und ihre konkreten positiven Sachqualifikationen.

Inputs besitzt unbekannte/fehlende/null Nachweise, Datums-/Typstress, Methodenselektoren und App-Projektion. Eine fehlende Tatsache ist keine bereits bewiesene falsche Bewirtschaftung. Die genaue MFA-Schlagnutzungsart bleibt der ausdrücklich dokumentierte Namensvertrag, keine automatische Universal-Namensauflösung. Weitere Fn-4-Qualifikationen einer AG-Fläche aus Maßnahme 16 sind durch einfache SRL-Nummern im anderen Maßnahmenfeld nicht vollständig dargestellt; Tables bindet diese spezielle Vertragsgrenze. Root besitzt Scope, Verfahren und Gesamtberechnung; General genau die zugewiesenen 46 allgemeinen, Querwirkungs- und Hinweis-IDs.

## Historische Regelabdeckung

Exakt 65 zugewiesene historische IDs: **36 umgesetzt, 23 teilweise, vier offene Auslegungen und zwei nur katalogisierte Regeln**. Jede ID besitzt eine eigene ausführliche Bewertung, originale Katalogaussage, tatsächlich geprüfte Codebindung und exakte Quellenbelege in JSON. „Umgesetzt“ bestätigt einen Verbraucher unter seinem offengelegten Tatsachenvertrag, keine realen Belege oder behördliche Freigabe.

| Historische ID | Bewertung | Tatsächlicher Code | Quellen |
| --- | --- | --- | --- |
| `o6_8.combination.ms_ds_requires_catch_crop_measure` | umgesetzt | [ms_ds.rego:6–25](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:6), [premium.rego:70–73](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:70) | Merkblatt S. 2, SRL S. 59, ATB S. 17 |
| `o6_8.combination.ah_baw_us_no_obligation` | umgesetzt | [ms_ds.rego:6–25](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:6), [premium.rego:70–73](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:70) | Merkblatt S. 2 |
| `o6_8.min_participation.area_0_10_ha` | umgesetzt | [premium.rego:26–41](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:26), [premium.rego:52–66](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:52) | Merkblatt S. 2, SRL S. 59, ATB S. 17 |
| `o6_8.min_participation.fallback_ah_baw_us` | teilweise | [premium.rego:43–48](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:43) | Merkblatt S. 6, Merkblatt S. 2 |
| `o6_8.ms_ds.erosion_prone_crops` | umgesetzt | [crops.rego:5–8](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:5), [crops.rego:24–29](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:24), [crops.rego:56–73](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:56) | Merkblatt S. 2, Merkblatt S. 9 |
| `o6_8.ms_ds.preceding_catch_crop` | teilweise | [ms_ds.rego:29–65](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:29) | Merkblatt S. 2, SRL S. 59, SRL S. 55 |
| `o6_8.ms_ds.gloez8_npf_2025` | umgesetzt | [ms_ds.rego:51–65](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:51), [common.rego:70–81](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/common.rego:70) | Merkblatt S. 2 |
| `o6_8.ms_ds.oepul2015_variants_2022` | teilweise | [ms_ds.rego:51–65](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:51) | Merkblatt S. 5 |
| `o6_8.ms_ds.immergruen_2023_start` | teilweise | [ms_ds.rego:35–59](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:35) | Merkblatt S. 6 |
| `o6_8.ms_ds.switch_immergruen_to_zwf` | umgesetzt | [ms_ds.rego:42–65](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:42), [premium.rego:26–48](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:26) | Merkblatt S. 7 |
| `o6_8.ms.definition_flat_non_inverting` | teilweise | [ms_ds.rego:74–101](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:74) | Merkblatt S. 2, SRL S. 59 |
| `o6_8.ms.no_inverting_tillage` | umgesetzt | [ms_ds.rego:74–83](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:74) | Merkblatt S. 2, SRL S. 59 |
| `o6_8.ms.deep_loosening_cover_preserved` | umgesetzt | [ms_ds.rego:91–102](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:91) | Merkblatt S. 2 |
| `o6_8.ms.max_4_weeks_tillage_to_sowing` | umgesetzt | [ms_ds.rego:104–110](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:104) | Merkblatt S. 3, SRL S. 59 |
| `o6_8.ds.definition_direct_seeding` | teilweise | [ms_ds.rego:114–128](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:114) | Merkblatt S. 3, SRL S. 59 |
| `o6_8.ds.definition_strip_till` | umgesetzt | [ms_ds.rego:130–141](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:130) | Merkblatt S. 3, SRL S. 59 |
| `o6_8.ah.ridges_max_2m` | umgesetzt | [ah.rego:9–19](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ah.rego:9) | Merkblatt S. 3 |
| `o6_8.ah.seed_potato_every_4th_row` | teilweise | [ah.rego:21–31](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ah.rego:21) | Merkblatt S. 3 |
| `o6_8.ah.created_by_planter` | umgesetzt | [ah.rego:33–37](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ah.rego:33) | Merkblatt S. 3 |
| `o6_8.ah.distinct_effective_ridges` | umgesetzt | [ah.rego:39–43](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ah.rego:39) | Merkblatt S. 3 |
| `o6_8.ah.maintain_until_haulm_reduction` | umgesetzt | [ah.rego:45–49](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ah.rego:45) | Merkblatt S. 3, SRL S. 59 |
| `o6_8.ah.renewal_permitted` | teilweise | [ah.rego:51–53](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ah.rego:51) | Merkblatt S. 3 |
| `o6_8.baw.anhang_f_area` | teilweise | [baw.rego:10–21](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:10) | SRL S. 59, SRL-Anhänge S. 11, SRL-Anhänge S. 12, SRL-Anhänge S. 37, Merkblatt S. 4 |
| `o6_8.baw.erosion_path_quarter_share` | Auslegung offen | [baw.rego:25–39](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:25) | Merkblatt S. 3, SRL S. 59 |
| `o6_8.baw.max_four_times_erosion_path` | teilweise | [baw.rego:43–64](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:43), [premium.rego:99–105](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:99) | Merkblatt S. 7, Merkblatt S. 8, SRL S. 60 |
| `o6_8.baw.sowing_by_15_may` | umgesetzt | [baw.rego:68–91](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:68) | Merkblatt S. 3, SRL S. 59 |
| `o6_8.baw.existing_stand_without_resowing` | umgesetzt | [baw.rego:68–98](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:68), [crops.rego:17–22](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:17) | Merkblatt S. 4, SRL S. 59 |
| `o6_8.baw.ploughing_earliest_15_sep_year2` | umgesetzt | [baw.rego:102–113](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:102) | Merkblatt S. 4, SRL S. 59 |
| `o6_8.baw.transfer_loss_of_disposal` | teilweise | [baw.rego:115–122](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:115) | Merkblatt S. 4, SRL S. 13 |
| `o6_8.baw.no_psm_no_fertilizer` | teilweise | [baw.rego:124–140](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:124) | Merkblatt S. 4, SRL S. 59 |
| `o6_8.baw.mow_or_mulch_every_second_year` | teilweise | [baw.rego:144–165](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:144) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.baw.no_grazing_no_threshing` | umgesetzt | [baw.rego:167–172](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:167) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.baw.green_cover_maintained` | umgesetzt | [baw.rego:174–178](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:174) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.baw.not_eligible_grassland_2020` | umgesetzt | [baw.rego:182–186](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:182), [premium.rego:10–22](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:10) | Merkblatt S. 8, SRL S. 60 |
| `o6_8.baw.not_eligible_gloez4_gloez8_part` | teilweise | [baw.rego:54–64](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:54), [premium.rego:99–105](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:99) | Merkblatt S. 8, SRL S. 60 |
| `o6_8.baw.gloez8_npf_until_2024` | umgesetzt | [baw.rego:188–191](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:188), [premium.rego:80–80](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:80) | Merkblatt S. 7 |
| `o6_8.baw.counts_as_div_ubb_bio` | teilweise | [baw.rego:209–220](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:209) | Merkblatt S. 7, SRL S. 29 |
| `o6_8.baw.conversion_to_18_19` | teilweise | [baw.rego:222–226](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:222), [general.rego:236–240](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego:236) | Merkblatt S. 7, ATB S. 13, ATB S. 14, SRL S. 15 |
| `o6_8.baw.exempt_min_management` | umgesetzt | [general.rego:106–124](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/general.rego:106) | ATB S. 6, SRL S. 10 |
| `o6_8.us.eligible_main_crops_by_year` | Auslegung offen | [crops.rego:10–15](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:10), [crops.rego:36–40](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:36) | Merkblatt S. 4, Merkblatt S. 10, SRL S. 60 |
| `o6_8.us.min_3_mixture_partners` | teilweise | [us.rego:10–21](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:10) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.us.full_coverage` | umgesetzt | [us.rego:62–67](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:62) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.us.sowing_within_8_weeks_latest_30_june` | teilweise | [us.rego:23–46](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:23) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.us.seed_proof_if_not_visible` | umgesetzt | [us.rego:48–53](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:48) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.us.adequate_emergence` | Auslegung offen | [us.rego:55–60](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:55) | Merkblatt S. 4, SRL S. 60 |
| `o6_8.us.no_tillage_no_herbicide_after_sowing` | teilweise | [us.rego:69–78](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:69) | Merkblatt S. 5, SRL S. 60 |
| `o6_8.us.maintain_until_harvest_not_harvested` | umgesetzt | [us.rego:80–90](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:80) | Merkblatt S. 5, SRL S. 60 |
| `o6_8.us.can_become_catch_crop` | teilweise | [us.rego:92–98](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/us.rego:92) | Merkblatt S. 5, SRL S. 54 |
| `o6_8.combination.ms_us_ds_us_allowed` | umgesetzt | [ms_ds.rego:155–169](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:155), [premium.rego:103–112](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:103) | Merkblatt S. 5 |
| `o6_8.premium.ms_ds_ah_not_combinable` | Auslegung offen | [ms_ds.rego:145–153](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:145), [premium.rego:82–85](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:82) | Merkblatt S. 8, SRL S. 60 |
| `o6_8.premium.vienna_humus_option` | teilweise | [ms_ds.rego:171–175](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:171), [premium.rego:75–78](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:75) | Merkblatt S. 8, SRL S. 60, SRL S. 76, SRL-Anhänge S. 103 |
| `o6_8.premium.baw_no_other_measure` | teilweise | [baw.rego:193–205](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:193), [premium.rego:10–22](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:10) | Merkblatt S. 8, SRL S. 60, SRL-Anhänge S. 103 |
| `o6_8.combination.anhang_l` | teilweise | [cross_measures.rego:6–28](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/cross_measures.rego:6), [ms_ds.rego:171–175](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:171), [baw.rego:193–205](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/baw.rego:193) | SRL S. 18, SRL-Anhänge S. 103, ATB S. 13 |
| `o6_8.combination.correction_until_payment_notice` | nur Katalog | Kein ausführender Verbraucher | ATB S. 13 |
| `o6_8.combination.zwf_immergruen_exclusive` | nur Katalog | [ms_ds.rego:17–20](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/ms_ds.rego:17) | SRL S. 18 |
| `o6_8.premium.rate_ms` | umgesetzt | [premium.rego:93–105](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:93) | Merkblatt S. 8, SRL S. 60, SRL S. 4 |
| `o6_8.premium.rate_ds` | umgesetzt | [premium.rego:93–105](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:93) | Merkblatt S. 8, SRL S. 60, SRL S. 4 |
| `o6_8.premium.rate_ah` | umgesetzt | [premium.rego:93–105](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:93) | Merkblatt S. 8, SRL S. 60, SRL S. 4 |
| `o6_8.premium.rate_baw` | umgesetzt | [premium.rego:93–105](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:93) | Merkblatt S. 8, SRL S. 60, SRL S. 4 |
| `o6_8.premium.rate_us` | umgesetzt | [premium.rego:93–105](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:93) | Merkblatt S. 8, SRL S. 60, SRL S. 4 |
| `o6_8.premium.rate_us_bio_surcharge` | umgesetzt | [premium.rego:107–112](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/premium.rego:107) | Merkblatt S. 8, SRL S. 60 |
| `o6_8.crops.ms_ds_list` | umgesetzt | [crops.rego:5–29](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:5), [crops.rego:48–61](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:48) | Merkblatt S. 9 |
| `o6_8.crops.us_list` | umgesetzt | [crops.rego:10–40](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:10), [crops.rego:48–61](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:48) | Merkblatt S. 10 |
| `o6_8.crops.ah_list` | umgesetzt | [crops.rego:31–34](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:31), [crops.rego:48–61](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:48) | Merkblatt S. 10 |
| `o6_8.crops.baw_list` | umgesetzt | [crops.rego:17–46](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:17), [crops.rego:48–61](/workspace/scratch/opus-candidates-source/runs/v2-o6_8-opus-5.5-high-20261001/workspace/policy/o6_8/crops.rego:48) | Merkblatt S. 11 |

## Quellenabschnitte

Die 55 Abschnittszeilen erfassen alle zwölf neuen Merkblattseiten und die aktuell einschlägigen gemeinsamen Quellen. „Nachbarteil“ bezeichnet einen vollständig gelesenen und ausdrücklich zugewiesenen Bereich. Es wird keine neue vollständige Lektüre identischer Rechts-/Hinweisquellen erfunden. Alte vollständige Lesebindung, aktueller Klauselabgleich und tatsächlich gesonderte Tabellenprüfung bleiben unterscheidbar.

| Abschnitt | Quelle / tatsächliche Seiten | Bewertung | Zugeordnete historische IDs |
| --- | --- | --- | --- |
| `MB1-overview-goals-contract` – Overview, goals and full three-row contract table | Merkblatt S. 1 | Nachbarteil | `o6_8.scope.arable_erosion_reduction`, `o6_8.contract.duration` |
| `MB2-combination` – 3.2 MS/DS obligation and AH/BAW/US exception | Merkblatt S. 2 | gelesen / abgeglichen | `o6_8.combination.ms_ds_requires_catch_crop_measure`, `o6_8.combination.ah_baw_us_no_obligation` |
| `MB2-minimum` – 3.3 Annual 0.10 ha and one or more procedures | Merkblatt S. 2 | gelesen / abgeglichen | `o6_8.min_participation.area_0_10_ha`, `o6_8.min_participation.fallback_ah_baw_us` |
| `MB2-predecessors` – 4.1 Complete current/2015/Immergrün/NPF predecessor paragraph | Merkblatt S. 2 | teilweise | `o6_8.ms_ds.preceding_catch_crop`, `o6_8.ms_ds.gloez8_npf_2025`, `o6_8.ms_ds.oepul2015_variants_2022` |
| `MB2-3-ms` – 4.1 Full mulch definition and 28-day continuation | Merkblatt S. 2–3 | teilweise | `o6_8.ms.definition_flat_non_inverting`, `o6_8.ms.no_inverting_tillage`, `o6_8.ms.deep_loosening_cover_preserved`, `o6_8.ms.max_4_weeks_tillage_to_sowing` |
| `MB3-direct-strip` – 4.1 Direct seeding and Strip-Till complete definitions | Merkblatt S. 3 | gelesen / abgeglichen | `o6_8.ds.definition_direct_seeding`, `o6_8.ds.definition_strip_till` |
| `MB3-AH-distance` – 4.2 Distance and furrows/tramline exception | Merkblatt S. 3 | gelesen / abgeglichen | `o6_8.ah.ridges_max_2m` |
| `MB3-AH-omission` – 4.2 Seed-potato necessity, fourth row and inspection proof | Merkblatt S. 3 | gelesen / abgeglichen | `o6_8.ah.seed_potato_every_4th_row` |
| `MB3-AH-equipment` – 4.2 Planter and prompt ridger exception | Merkblatt S. 3 | gelesen / abgeglichen | `o6_8.ah.created_by_planter` |
| `MB3-AH-effect` – 4.2 Distinct storm-effective ridges | Merkblatt S. 3 | gelesen / abgeglichen | `o6_8.ah.distinct_effective_ridges` |
| `MB3-AH-maintenance` – 4.2 Maintain to haulm reduction and allowed renewal | Merkblatt S. 3 | gelesen / abgeglichen | `o6_8.ah.maintain_until_haulm_reduction`, `o6_8.ah.renewal_permitted` |
| `MB3-baw-geography` – 4.3 Layer, quarter and Annex F reference | Merkblatt S. 3 | Auslegung offen | `o6_8.baw.anhang_f_area`, `o6_8.baw.erosion_path_quarter_share` |
| `MB3-4-baw-establishment` – 4.3 Winter hardiness, under 50%,15 May and retained existing exception | Merkblatt S. 3–4 | gelesen / abgeglichen | `o6_8.baw.sowing_by_15_may`, `o6_8.baw.existing_stand_without_resowing` |
| `MB4-baw-ploughing-transfer` – 4.3 Second-year break and in-place successor/prior-holder transfer | Merkblatt S. 4 | teilweise | `o6_8.baw.ploughing_earliest_15_sep_year2`, `o6_8.baw.transfer_loss_of_disposal` |
| `MB4-baw-inputs` – 4.3 Exact input-ban start/end and reclassification endpoint | Merkblatt S. 4 | teilweise | `o6_8.baw.no_psm_no_fertilizer` |
| `MB4-baw-management` – 4.3 Complete mowing/removal/grazing/threshing/driving/cover list | Merkblatt S. 4 | gelesen / abgeglichen | `o6_8.baw.mow_or_mulch_every_second_year`, `o6_8.baw.no_grazing_no_threshing`, `o6_8.baw.green_cover_maintained` |
| `MB4-gis-note` – Actual GIS legend for geographic layer | Merkblatt S. 4 | externe Evidenz | `o6_8.baw.anhang_f_area` |
| `MB4-us-crops` – 4.4 All eligible crops and extension from 2025 | Merkblatt S. 4 | Auslegung offen | `o6_8.us.eligible_main_crops_by_year` |
| `MB4-us-establishment` – 4.4 Active between-row mixture,56 days,30 June and Winterackerbohnen 30 April | Merkblatt S. 4 | teilweise | `o6_8.us.min_3_mixture_partners`, `o6_8.us.full_coverage`, `o6_8.us.sowing_within_8_weeks_latest_30_june` |
| `MB4-us-proof-emergence` – 4.4 Visibility/seed proof and agronomic emergence effect | Merkblatt S. 4 | gelesen / abgeglichen | `o6_8.us.seed_proof_if_not_visible`, `o6_8.us.adequate_emergence` |
| `MB5-us-management` – 4.4 Tillage, harrowing and herbicide restricted interval | Merkblatt S. 5 | teilweise | `o6_8.us.no_tillage_no_herbicide_after_sowing` |
| `MB5-us-maintenance` – 4.4 Preserve through main harvest, no collection, topping exception | Merkblatt S. 5 | gelesen / abgeglichen | `o6_8.us.maintain_until_harvest_not_harvested` |
| `MB5-us-catch` – Untersaat transition without reseeding and actual main harvest date | Merkblatt S. 5 | teilweise | `o6_8.us.can_become_catch_crop` |
| `MB5-application` – 5 Full deadline/last-entry/code bullets and code list | Merkblatt S. 5 | Nachbarteil | `o6_8.application.deadline_31_dec`, `o6_8.application.last_entry_2025`, `o6_8.application.codes_required` |
| `MB5-code-pairs` – 5 Same-parcel MS+US and DS+US | Merkblatt S. 5 | gelesen / abgeglichen | `o6_8.combination.ms_us_ds_us_allowed` |
| `MB5-6-2015example` – 5 Complete 2022 commitment bullet and published 2023 Direktsaat maize example | Merkblatt S. 5–6 | teilweise | `o6_8.ms_ds.oepul2015_variants_2022` |
| `MB6-immergruen-example` – 5 Complete 1 January start bullet and published 2022→2023 Mulchsaat example | Merkblatt S. 6 | teilweise | `o6_8.ms_ds.immergruen_2023_start` |
| `MB6-fallback` – 5 Fallback when no correct predecessor/following crop | Merkblatt S. 6 | teilweise | `o6_8.min_participation.fallback_ah_baw_us` |
| `MB6-7-switch` – 5 Complete cross-page Immergrün→ZWF switch and minimum fallback | Merkblatt S. 6–7 | gelesen / abgeglichen | `o6_8.ms_ds.switch_immergruen_to_zwf` |
| `MB7-cancel` – 5 Immediate cancellation/reduction once conditions cannot be met | Merkblatt S. 7 | Nachbarteil | `o6_8.application.cancel_codes_immediately` |
| `MB7-path-example` – 5 Fourfold claim limit and full 1 ha/.10 ha/.40 ha example | Merkblatt S. 7 | teilweise | `o6_8.baw.max_four_times_erosion_path` |
| `MB7-conversion` – 5 BAW conversion to 18/19 until 31 December 2025 | Merkblatt S. 7 | teilweise | `o6_8.baw.conversion_to_18_19` |
| `MB7-div` – 5 BAW-DIV usage and dual coding | Merkblatt S. 7 | teilweise | `o6_8.baw.counts_as_div_ubb_bio` |
| `MB7-npf` – 5 NPF/4% credit through 2024 and no ÖPUL premium | Merkblatt S. 7 | gelesen / abgeglichen | `o6_8.baw.gloez8_npf_until_2024` |
| `MB8-rates` – 6 Complete 12 rate cells, all procedure/crop labels and BAW cap | Merkblatt S. 8 | gelesen / abgeglichen | `o6_8.premium.rate_ms`, `o6_8.premium.rate_ds`, `o6_8.premium.rate_ah`, `o6_8.premium.rate_baw`, `o6_8.premium.rate_us`, `o6_8.premium.rate_us_bio_surcharge` |
| `MB8-combinations` – 6 MS/DS+AH prohibition, Wien and BAW/LSE exceptions | Merkblatt S. 8 | teilweise | `o6_8.premium.ms_ds_ah_not_combinable`, `o6_8.premium.vienna_humus_option`, `o6_8.premium.baw_no_other_measure` |
| `MB8-exclusions` – 6 MFA2020 grassland and GLÖZ partial area exclusions | Merkblatt S. 8 | gelesen / abgeglichen | `o6_8.baw.not_eligible_grassland_2020`, `o6_8.baw.not_eligible_gloez4_gloez8_part` |
| `MB9-crops` – 7 All 31 MS/DS rows and potato-only-MS qualifier | Merkblatt S. 9 | gelesen / abgeglichen | `o6_8.crops.ms_ds_list` |
| `MB10-us-crops` – 7 All 27 US rows and each from 2025 qualifier | Merkblatt S. 10 | gelesen / abgeglichen | `o6_8.crops.us_list` |
| `MB10-11-ah` – 7 All 10 AH potato rows across page boundary | Merkblatt S. 10–11 | gelesen / abgeglichen | `o6_8.crops.ah_list` |
| `MB11-baw` – 7 All 5 BAW rows and Kleegras new-sowing exclusion | Merkblatt S. 11 | gelesen / abgeglichen | `o6_8.crops.baw_list` |
| `MB11-12-revisions` – 8 Every revision bullet across five earlier editions | Merkblatt S. 11–12 | Kontext / vollständig gelesen | Kontext / siehe JSON |
| `MB12-imprint` – Full imprint, nonbinding disclaimer and equality statement | Merkblatt S. 12 | Kontext / vollständig gelesen | Kontext / siehe JSON |
| `SRL59-60` – 2.8 Full scope/access, every procedure and complete premium table | SRL S. 59–60 | teilweise | `o6_8.ms_ds.erosion_prone_crops`, `o6_8.ms_ds.preceding_catch_crop`, `o6_8.ms_ds.gloez8_npf_2025`, `o6_8.ms_ds.oepul2015_variants_2022`, `o6_8.ms_ds.immergruen_2023_start`, `o6_8.ms_ds.switch_immergruen_to_zwf`, `o6_8.ms.definition_flat_non_inverting`, `o6_8.ms.no_inverting_tillage`, `o6_8.ms.deep_loosening_cover_preserved`, `o6_8.ms.max_4_weeks_tillage_to_sowing`, `o6_8.ds.definition_direct_seeding`, `o6_8.ds.definition_strip_till`, `o6_8.ah.ridges_max_2m`, `o6_8.ah.seed_potato_every_4th_row`, `o6_8.ah.created_by_planter`, `o6_8.ah.distinct_effective_ridges`, `o6_8.ah.maintain_until_haulm_reduction`, `o6_8.ah.renewal_permitted`, `o6_8.baw.anhang_f_area`, `o6_8.baw.erosion_path_quarter_share`, `o6_8.baw.max_four_times_erosion_path`, `o6_8.baw.sowing_by_15_may`, `o6_8.baw.existing_stand_without_resowing`, `o6_8.baw.ploughing_earliest_15_sep_year2`, `o6_8.baw.transfer_loss_of_disposal`, `o6_8.baw.no_psm_no_fertilizer`, `o6_8.baw.mow_or_mulch_every_second_year`, `o6_8.baw.no_grazing_no_threshing`, `o6_8.baw.green_cover_maintained`, `o6_8.baw.not_eligible_grassland_2020`, `o6_8.baw.not_eligible_gloez4_gloez8_part`, `o6_8.baw.gloez8_npf_until_2024`, `o6_8.baw.counts_as_div_ubb_bio`, `o6_8.baw.conversion_to_18_19`, `o6_8.baw.exempt_min_management`, `o6_8.us.eligible_main_crops_by_year`, `o6_8.us.min_3_mixture_partners`, `o6_8.us.full_coverage`, `o6_8.us.sowing_within_8_weeks_latest_30_june`, `o6_8.us.seed_proof_if_not_visible`, `o6_8.us.adequate_emergence`, `o6_8.us.no_tillage_no_herbicide_after_sowing`, `o6_8.us.maintain_until_harvest_not_harvested`, `o6_8.us.can_become_catch_crop` |
| `SRL18-combination` – Whole-farm 6/7 prohibition and separate parcel combinability | SRL S. 18 | teilweise | `o6_8.combination.anhang_l`, `o6_8.combination.zwf_immergruen_exclusive` |
| `SRL29-30and38` – UBB source-referenced DIV conditions c/d and BAW eligibility | SRL S. 29–30 | teilweise | `o6_8.baw.counts_as_div_ubb_bio` |
| `SRL38-BIO-DIV` – BIO corresponding c/d qualification for BAW-DIV | SRL S. 38 | teilweise | `o6_8.baw.counts_as_div_ubb_bio` |
| `ATB6-minimum-exception` – Specific BAW exception, own procedure duties remain | ATB S. 6 | gelesen / abgeglichen | `o6_8.baw.exempt_min_management` |
| `ATB13-14-combination-workflow` – Correction, retained duties and conversion targets/remainder | ATB S. 13–14 | teilweise | `o6_8.combination.correction_until_payment_notice`, `o6_8.baw.conversion_to_18_19` |
| `ANN-F` – Full shared Annex F by exact hash and current geographic consumers | SRL-Anhänge S. 11–37 | teilweise | `o6_8.baw.anhang_f_area` |
| `ANN-L` – Complete 21×20 matrix and all four footnotes | SRL-Anhänge S. 103 | teilweise | `o6_8.combination.anhang_l` |
| `NOTICE-2026-05-22` – Supplied 2026 notice, prior complete main-content reading by exact hash | Hinweis 2026-05-22 | Nachbarteil | Kontext / siehe JSON |
| `NOTICE-2026-06-12` – Supplied 2026 notice, prior complete main-content reading by exact hash | Hinweis 2026-06-12 | Nachbarteil | Kontext / siehe JSON |
| `NOTICE-2026-08-05` – Supplied 2026 notice, prior complete main-content reading by exact hash | Hinweis 2026-08-05 | Nachbarteil | Kontext / siehe JSON |
| `NOTICE-2026-08-12` – Supplied 2026 notice, prior complete main-content reading by exact hash | Hinweis 2026-08-12 | Nachbarteil | Kontext / siehe JSON |

## Frische öffentliche Quellen- und Grenzfälle

Die 131 vollständigen Inputs/Queries stehen im eingefrorenen JSON. Jede Erwartung wurde aus den gelieferten Quellen und einem ausdrücklich bezeichneten Sach-/Auslegungsrahmen abgeleitet. Ein erfüllter Helfer- oder Komponentenwert bestätigt nur diesen Teil; offene Quellenhierarchien und das AH+US-A04-Szenario bleiben sichtbar. Alle 131 Werte sind strikt definiert, ohne Laufzeitfehler oder Zahl-zu-Boolean-Umdeutung.

| Fall | Prüfrahmen | Soll | Ist | Ergebnis |
| --- | --- | --- | --- | --- |
| `o6_8-ms-requires6or7` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-ds-requires6or7` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-ah-no6or7-component` | nominelle Komponente | `162` | `162` | erfüllt |
| `o6_8-baw-no6or7-component` | nominelle Komponente | `594` | `594` | erfüllt |
| `o6_8-us-no6or7-component` | nominelle Komponente | `81` | `81` | erfüllt |
| `o6_8-minimum-area-0.1` | Quellen-/Grenzfall | `true` | `true` | erfüllt |
| `o6_8-minimum-area-0.09` | Quellen-/Grenzfall | `false` | `false` | erfüllt |
| `o6_8-fallback-double-procedure-physical-area` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `0.06` | `0.12` | **abweichend** |
| `o6_8-main-area-deduplicates-double-procedure` | Quellen-/Grenzfall | `0.06` | `0.06` | erfüllt |
| `o6_8-fallback-us-alone` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-zwf2` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-preceding-zwf3-reject` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-2015-in2023` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-preceding-2015-in2024` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-2015-wrong2` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-npf-in2025` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-preceding-npf-in2024` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-npf-in2026` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-npf-wrong3` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-immergruen2023` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-preceding-immergruen-not-overwintered` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-preceding-switch-after7-ended` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-mulch-absent` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-inverting-known` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-canonical-plough` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-deep-cover-true` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-deep-cover-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ms-tillage-28days` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-ms-tillage-29days` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ds-direct_seeding-full_surface_tillage` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ds-direct_seeding-slot_seeding` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ds-strip_till-strip_only_in_seed_row` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ds-strip_till-cover_residues_retained_between_strips` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ds-strip_till-full_surface_tillage` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-strip-all-known-conditions` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-ah-ridges-2` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-ah-ridges-2.01` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ah-in_furrows_except_tramlines-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ah-created_by_planter_or_prompt_ridger-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ah-distinct_effective_ridges-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ah-maintained_until_haulm_reduction-false` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ah-fourth-row-seed-necessary` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-ah-fourth-row-seed-unnecessary` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ah-fourth-row-ordinary-potato` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-ah-renewal-weed_control` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `1` | `1` | erfüllt |
| `o6_8-ah-renewal-rain_event` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `1` | `1` | erfüllt |
| `o6_8-baw-quarter-exact` | offene Merkblatt-/Vorranglesart | `0` | `0` | erfüllt |
| `o6_8-baw-whole-parcel-below-quarter` | offene Merkblatt-/Vorranglesart | `1` | `1` | erfüllt |
| `o6_8-baw-published-example-correct-declared-subparcel` | Quellen-/Grenzfall | `0.4` | `0.4` | erfüllt |
| `o6_8-baw-oversized-declaration-notice` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-new-may15-under50` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-baw-new-may16` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-new-legume50` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-new-not-hardy` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-kleegras-existing-true` | Kulturkomponente | `0` | `0` | erfüllt |
| `o6_8-baw-kleegras-existing-false` | Kulturkomponente | `1` | `1` | erfüllt |
| `o6_8-baw-retained-over50` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-baw-second-year-09-14` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-second-year-09-15` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-baw-transfer-transferring_holder` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `"loss_of_disposal_no_repayment"` | `"loss_of_disposal_no_repayment"` | erfüllt |
| `o6_8-baw-transfer-successor_continuing_in_place` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `"establishment_year_of_previous_holder_applies"` | `"establishment_year_of_previous_holder_applies"` | erfüllt |
| `o6_8-baw-known-restricted-psm_used_since_first_declaration` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-known-restricted-fertilized_since_first_declaration` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-care-first-year` | abgeschlossene Jahreskomponente | `0` | `0` | erfüllt |
| `o6_8-baw-care-one-year` | abgeschlossene Jahreskomponente | `0` | `0` | erfüllt |
| `o6_8-baw-care-two-year` | abgeschlossene Jahreskomponente | `1` | `1` | erfüllt |
| `o6_8-baw-care-complete-no-care` | abgeschlossene Jahreskomponente | `1` | `1` | erfüllt |
| `o6_8-baw-grazed-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-threshed-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-green_cover_maintained-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-grassland_in_mfa_2020-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-disjoint-gloez-parts-2024` | bekannte getrennte Teilflächen | `0.5` | `0.5` | erfüllt |
| `o6_8-baw-disjoint-gloez-parts-2025` | bekannte getrennte Teilflächen | `0.8` | `0.8` | erfüllt |
| `o6_8-baw-npf-component-2024` | nominelle Komponente | `0` | `0` | erfüllt |
| `o6_8-baw-npf-component-2025` | nominelle Komponente | `594` | `594` | erfüllt |
| `o6_8-baw-div-partial-ubb-gruenbrache` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `0` | `0` | erfüllt |
| `o6_8-baw-div-partial-bio-fodder` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `0` | `0` | erfüllt |
| `o6_8-baw-div-partial-no-ubb-bio` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `1` | `1` | erfüllt |
| `o6_8-baw-conversion-18-last-day` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `1` | `1` | erfüllt |
| `o6_8-baw-conversion-19-last-day` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `1` | `1` | erfüllt |
| `o6_8-baw-conversion-18-too-late` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `0` | `0` | erfüllt |
| `o6_8-baw-conversion-wrong-target` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `0` | `0` | erfüllt |
| `o6_8-baw-specific-minimum-management-exemption` | Quellen-/Grenzfall | `"exempt_baw"` | `"exempt_baw"` | erfüllt |
| `o6_8-us-date-56days` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-us-date-57days` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-date-june30` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-us-date-july1` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-winter-bean-actual-autumn-legitimate-spring` | Quellen-/Grenzfall | `0` | `1` | **abweichend** |
| `o6_8-winter-bean-april30-calendar-cutoff` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-mixture-two` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-mixture-three` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-us-mixture-not-between-rows` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-seed-invisible-no-proof` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-seed-invisible-proof` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-us-seed-visible-no-extra-proof` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-us-known-full_coverage_achieved-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-known-adequate_emergence-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-known-tillage_after_sowing-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-known-harrowing_after_sowing-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-known-herbicide_after_sowing-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-known-maintained_until_main_crop_harvest-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-known-harvested_with_main_crop-breach` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-us-topped-without-crop-collection` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-us-catch-helper-actual-harvest` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `"2025-08-01"` | `"2025-08-01"` | erfüllt |
| `o6_8-us-catch-helper-clear-before-deadline` | begrenzter Helfer / A04 ggf. ausdrücklich offen | `1` | `1` | erfüllt |
| `o6_8-ms-plus-us-nominal-components` | nominelle Komponente | `135` | `135` | erfüllt |
| `o6_8-ds-plus-us-nominal-components` | nominelle Komponente | `167.4` | `167.4` | erfüllt |
| `o6_8-ms-ah-conflict-local` | lokale Kombinationsdiagnose | `1` | `1` | erfüllt |
| `o6_8-wien-option-ms` | nominelle Komponente | `0` | `0` | erfüllt |
| `o6_8-outside-wien` | nominelle Komponente | `54` | `54` | erfüllt |
| `o6_8-wien-no-option` | nominelle Komponente | `54` | `54` | erfüllt |
| `o6_8-wien-ah-unaffected` | nominelle Komponente | `162` | `162` | erfüllt |
| `o6_8-baw-other-measure-1A_LSE` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-baw-other-measure-1B_LSE` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-baw-other-measure-1A` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-baw-other-measure-16` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-matrix-8-2-consumer` | Quellen-/Grenzfall | `0` | `0` | erfüllt |
| `o6_8-matrix-8-18-consumer` | Quellen-/Grenzfall | `1` | `1` | erfüllt |
| `o6_8-known-both6and7-missing-diagnostic` | bekannte Verfahrensdiagnose | `1` | `0` | **abweichend** |
| `o6_8-rate2025-integrated-ms` | nominelle Komponente | `54` | `54` | erfüllt |
| `o6_8-rate2025-integrated-ds` | nominelle Komponente | `86.4` | `86.4` | erfüllt |
| `o6_8-rate2025-integrated-ah` | nominelle Komponente | `162` | `162` | erfüllt |
| `o6_8-rate2025-integrated-baw` | nominelle Komponente | `594` | `594` | erfüllt |
| `o6_8-rate2025-integrated-us` | nominelle Komponente | `81` | `81` | erfüllt |
| `o6_8-us-bio-surcharge-true` | nominelle Komponente | `16.2` | `16.2` | erfüllt |
| `o6_8-us-bio-surcharge-false` | nominelle Komponente | `0` | `0` | erfüllt |
| `o6_8-crop-potato-ms` | Kulturkomponente | `1` | `1` | erfüllt |
| `o6_8-crop-potato-ds` | Kulturkomponente | `0` | `0` | erfüllt |
| `o6_8-crop-maize-ds` | Kulturkomponente | `1` | `1` | erfüllt |
| `o6_8-us-sudangras-leaflet-year-2024` | offene Merkblatt-/Vorranglesart | `0` | `0` | erfüllt |
| `o6_8-us-sudangras-leaflet-year-2025` | offene Merkblatt-/Vorranglesart | `1` | `1` | erfüllt |

**Abschluss dieses Maßnahmenteils:** 131 Fälle und 131 Prüfungen; 131 definierte Werte, 128 erfüllte und drei abweichende Erwartungen. Drei konkrete lokale/Helfergrenzen und zwei nicht überdehnte Quellen-/Projektionsgrenzen sind dokumentiert. Es wurden ausschließlich die beiden eigenen Dossierdateien geschrieben.
