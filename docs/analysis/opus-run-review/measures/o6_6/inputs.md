# o6_6 – Eingabevertrag und tatsächliche App-Projektion

Geprüft wurde ausschließlich der ursprüngliche Opus-Run `v2-o6_6-opus-5.5-high-20260925` am Candidate-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Sein natives Ziel ist `data.oepul.o6_6.decision`. Dieser Beitrag sammelt Befunde in Issue #112 / PR #111 und verändert weder historische Regeln/Profile/Quellen noch App-Funktionen. Er erteilt keine fachliche Freigabe.

[inputs.json](inputs.json) enthält alle 47 tatsächlichen Profilvorschläge mit 72 neuen Blättern, Typen, Einheiten, Bedeutungen, Defaults, Lesestellen und Ergebniswirkungen. Sieben Befunde und 58 neue öffentliche Eingabeprobes sind mit unveränderten nativen Beobachtungen gespeichert. Der tatsächliche App-Projektionslauf und dessen native Auswertung stehen separat. Studienreferenzfälle, private Fälle, Experten-/GM-Urteile, manuelle Anpassungstests und Modell-Selbsttests wurden nicht als Sollantworten verwendet.

## Quellen und vollständig gelesener Code

Das Original `o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf` wurde auf allen 14 Seiten vollständig gelesen: Vertrags- und jährliche Mindestteilnahme, Zwischenfruchtdefinition und ausgeschlossene Bestände, aktive Anlage und Untersaaten, N/PSM, sämtliche Pflege-/Bodenbearbeitungs-/Nutzungs-/Beseitigungsausnahmen, alle sieben Varianten und ihre historischen Zeilen, beide veröffentlichten 70-Tage-Beispiele, Beispielarten und Roggensorten, Raps-Vierblattregel, Beantragungs-/Variantenfristen, Umstieg, Weitergabe, Abmeldung, alle Prämienbänder, Aktualisierungen und Unverbindlichkeitshinweis. SHA256: `298b93938d7f7f4f5756d53a66414ff371bbcb1e27c147b874a43515af5bea26`.

Das Paket enthält acht Quellen. Die sieben gemeinsamen Dateien – SRL, Anhänge, allgemeine Teilnahmebedingungen und vier Originalmitteilungen – sind mit den bereits vollständig gelesenen Fassungen identisch. Alle acht Dateien wurden erneut gegen die Run-Hashes geprüft. Die zugeordneten gemeinsamen Belegstellen und ihr aktueller Anwendungsumfang wurden gezielt erneut gelesen. Alle 88 verschiedenen Zitate der Profilvorschläge sind nach ausschließlicher Leerraumnormalisierung auf den angegebenen Originalseiten auffindbar. Auch alle zusätzlichen Finding-/Probe-Belege wurden so geprüft.

Eine GSP-AV ist in diesem Paket nicht bereitgestellt. Ihre Verweise in gelieferten Quellen werden als Grenze des Quellenpakets erfasst; die im vorigen Run tatsächlich gelieferte GSP-AV wird hier nicht als bereitgestellte Quelle oder zusätzliches ungebundenes Sollwertorakel ausgegeben. Das ist von einer Abweichung gegenüber tatsächlich gelieferten Quellen zu unterscheiden.

Alle fünf Produktionsmodule wurden vollständig gelesen: `helpers`, `farm`, `parcel`, `premium` und `notices_2026`. Die vollständigen Rohannahmen erläutern den historischen Aufgabenvertrag und seine offenen SRL-/Merkblatt-Auslegungen; sie liefern keine unabhängigen Quellen-Sollantworten.

## Vollständiger Vorschlagsabgleich

Der Katalog hat tatsächlich 47 Vorschläge mit 72 ausschließlich neuen Blättern. Bestehende Canonical-Typen werden nicht verändert. 71 Blätter werden gelesen; eines bleibt völlig ungelesen. Fünf gelesene Blätter wirken nur in getrennten Helfern oder Hinweisen, ein weiteres nur auf ausgegebene Kombinationskonflikte.

| Nr. | Vorschlag | Blätter | Gelesen | Ergebnisgrenze |
|---:|---|---:|---:|---|
| 1 | `farm.applicant` | 3 | 3 | Bedingte Hauptentscheidung |
| 2 | `farm.oepul.first_participation_year` | 1 | 1 | Bedingte Hauptentscheidung |
| 3 | `farm.oepul.measures` | 4 | 4 | Bedingte Hauptentscheidung |
| 4 | `farm.oepul.inspection_announced_on` | 1 | 1 | Bedingte Hauptentscheidung |
| 5 | `farm.oepul.content_violation_level` | 1 | 1 | Bedingte Hauptentscheidung |
| 6 | `land.protected_cultivation_area_ha` | 1 | 1 | Bedingte Hauptentscheidung |
| 7 | `land.parcels[].is_in_austria` | 1 | 1 | Bedingte Hauptentscheidung |
| 8 | `land.parcels[].eligibility_category` | 1 | 1 | Bedingte Hauptentscheidung |
| 9 | `land.parcels[].oepul_codes` | 1 | 1 | Bedingte Hauptentscheidung |
| 10 | `land.parcels[].oepul_measures` | 1 | 1 | Nur Kombinationsdiagnose in decision |
| 11 | `land.parcels[].national_park` | 1 | 1 | Bedingte Hauptentscheidung |
| 12 | `land.parcels[].national_park_relevant_restrictions` | 1 | 1 | Bedingte Hauptentscheidung |
| 13 | `land.parcels[].public_funding_overlap` | 1 | 1 | Bedingte Hauptentscheidung |
| 14 | `land.parcels[].constraints.groundwater_protection_area_ooe` | 1 | 1 | Bedingte Hauptentscheidung |
| 15 | `land.parcels[].transfer` | 3 | 3 | Bedingte Hauptentscheidung |
| 16 | `land.parcels[].special_circumstance` | 3 | 3 | Nur getrennter Helfer/Hinweis |
| 17 | `land.parcels[].operations.main_crop_harvest_share_percent` | 1 | 1 | Nur getrennter Helfer/Hinweis |
| 18 | `land.parcels[].operations.cover_crop.variant` | 1 | 1 | Bedingte Hauptentscheidung |
| 19 | `land.parcels[].operations.cover_crop.variant_applied_on` | 1 | 1 | Bedingte Hauptentscheidung |
| 20 | `land.parcels[].operations.cover_crop.variant_withdrawn` | 1 | 1 | Bedingte Hauptentscheidung |
| 21 | `land.parcels[].operations.cover_crop.is_npf_gloez8` | 1 | 1 | Bedingte Hauptentscheidung |
| 22 | `land.parcels[].operations.cover_crop.establishment` | 1 | 1 | Bedingte Hauptentscheidung |
| 23 | `land.parcels[].operations.cover_crop.preceding_main_crop_harvest_date` | 1 | 1 | Bedingte Hauptentscheidung |
| 24 | `land.parcels[].operations.cover_crop.mixture_partner_count` | 1 | 1 | Bedingte Hauptentscheidung |
| 25 | `land.parcels[].operations.cover_crop.plant_family_count` | 1 | 1 | Bedingte Hauptentscheidung |
| 26 | `land.parcels[].operations.cover_crop.insect_pollinated_partner_count` | 1 | 1 | Bedingte Hauptentscheidung |
| 27 | `land.parcels[].operations.cover_crop.non_insect_pollinated_share_percent` | 1 | 1 | Bedingte Hauptentscheidung |
| 28 | `land.parcels[].operations.cover_crop.species` | 1 | 1 | Bedingte Hauptentscheidung |
| 29 | `land.parcels[].operations.cover_crop.green_rye_varieties` | 1 | 1 | Bedingte Hauptentscheidung |
| 30 | `land.parcels[].operations.cover_crop.farm_saved_seed_used` | 1 | 1 | Bedingte Hauptentscheidung |
| 31 | `land.parcels[].operations.cover_crop.farm_saved_seed_proof` | 1 | 1 | Bedingte Hauptentscheidung |
| 32 | `land.parcels[].operations.cover_crop.partners_visible_in_field` | 1 | 1 | Bedingte Hauptentscheidung |
| 33 | `land.parcels[].operations.cover_crop.seed_proof_available` | 1 | 1 | Bedingte Hauptentscheidung |
| 34 | `land.parcels[].operations.cover_crop.cereal_maize_share_percent` | 1 | 1 | Bedingte Hauptentscheidung |
| 35 | `land.parcels[].operations.cover_crop.cereal_share_from_volunteer` | 1 | 1 | Bedingte Hauptentscheidung |
| 36 | `land.parcels[].operations.cover_crop.only_volunteer_or_self_seeded` | 1 | 1 | Bedingte Hauptentscheidung |
| 37 | `land.parcels[].operations.cover_crop.full_coverage_achieved` | 1 | 1 | Bedingte Hauptentscheidung |
| 38 | `land.parcels[].operations.cover_crop.properly_established` | 1 | 1 | Bedingte Hauptentscheidung |
| 39 | `land.parcels[].operations.cover_crop.winter_hardiness` | 1 | 1 | Bedingte Hauptentscheidung |
| 40 | `land.parcels[].operations.cover_crop.termination_date` | 1 | 1 | Bedingte Hauptentscheidung |
| 41 | `land.parcels[].operations.cover_crop.termination_method` | 1 | 1 | Bedingte Hauptentscheidung |
| 42 | `land.parcels[].operations.cover_crop.declared_as_main_crop_next_mfa` | 1 | 1 | Bedingte Hauptentscheidung |
| 43 | `land.parcels[].operations.cover_crop.rape_four_leaf_stage_date` | 1 | 1 | Bedingte Hauptentscheidung |
| 44 | `land.parcels[].operations.cover_crop.problem_weeds` | 1 | 1 | Bedingte Hauptentscheidung |
| 45 | `land.parcels[].operations.cover_crop.problem_weed_evidence_kept` | 1 | 1 | Bedingte Hauptentscheidung |
| 46 | `land.parcels[].operations.cover_crop.events` | 13 | 13 | Bedingte Hauptentscheidung |
| 47 | `land.parcels[].operations.cover_crop.following_main_crop` | 5 | 4 | Folgekultur-Name ungelesen; Saatmethode nur Helfer |

Vollständig ungelesen ist `following_main_crop.crop_name`. Das ist nicht das vorhandene `land.parcels[].crop.crop_name`, das für Winterraps bei Variante 7 tatsächlich verwendet wird. Nur getrennte Helfer verwenden die drei `special_circumstance`-Blätter, `following_main_crop.sowing_method` und `operations.main_crop_harvest_share_percent`: `permanent_circumstance_premium_possible`, `erosion_protection_followup_eligible` und `advice` fehlen in der Hauptentscheidung und verändern deren Beträge nicht. `oepul_measures[]` speist dagegen die sichtbaren `combination_conflicts`; diese sperren gemäß offener Rohannahme 15 die Prämie nicht automatisch.

## Tatsächliche Pfade, Arrays und Identitäten

Der vollständige Abgleich enthält 193 kontextbezogene Lesestellen. Er verfolgt direkte Referenzen, `object.get`, `cc(p)`, das ausgewählte `o6_6_measure`, Ereignisparameter `e`, Folgekultur `f`, Weitergabe `t` und besondere Umstände `sc`. Statische Tabellenvariablen werden nicht als Eingaben ausgegeben. Das dynamische `parcel_premium(p, field)` liest die zwei tatsächlichen Min-/Max-Spalten einer Datentabelle; `list_items(name)` liest statische Artenlisten. Beides erzeugt keine unbekannten dynamischen Eingabeschlüssel. Es bleiben keine nicht verwalteten zusätzlichen Eingabepfade.

Zehn vorhandene Canonical-Pfade werden zusätzlich gelesen: Jahr, Bundesland, Bezirk, Ackerfläche, Gesamtfläche, Parzellen-ID/-fläche/-Nutzung, aktueller Hauptkulturname und bestehendes Begrünungs-Saatdatum. Ihre exakten Typen, Einheiten, Zeit- und Identitätsumfänge stehen einzeln im JSON. Bundesland und Bezirk dienen ausschließlich dem getrennten Ernteverpflichtungs-/Hinweisweg, nicht der Hauptentscheidung.

Die nativen Maßnahmendaten liegen unter `farm.oepul.measures`; Code `6` wählt den Maßnahmenvertrag aus. Das ist nicht die App-Struktur `oepul.shared`/`oepul.measures`. Die Schlagteilnahme entsteht durch eine numerische `cover_crop.variant`, nicht durch das vorhandene `cover_crop.is_used`. Ein erlaubtes `variant=null` wird aus `cover_parcels` ausgeschlossen und kann zum Erlöschen führen. Ein ungültiges nichtganzzahliges Variantentoken ist kein regulärer Quellenfall.

Die alten undatierten Kurzfelder `operations.psm_used` und `fertilizer.mineral_n_kg_per_ha` werden bewusst nicht gelesen. Sie könnten kein Ereignis innerhalb des Begrünungszeitraums beweisen. Die neuen datierten Ereignisse haben dagegen tatsächliche Verbraucher. Ereignisdatum, Anlagedatum, Umbruchdatum, Variantenantrag und Maßnahmenantrag sind verschiedene Ereignisse; sie werden nicht über ähnlich klingende Namen gleichgesetzt.

`parcel_id` muss stabil und eindeutig sein. Sie bindet Dictionaries sowie Verstöße und Blockaden; ein Maßnahmenobjekt pro fachlich gemeintem Vertrag muss ebenso eindeutig sein. Diese Integritätsverträge werden dokumentiert, ohne zusätzliche Duplicate-/Missing-ID-Quellenfälle oder einen angeblich gesetzlich vorgeschriebenen OPA-Fehlerstatus zu erfinden. Ein nicht vorhandener Weitergabevorgang ist außerdem etwas anderes als ein vorhandenes, unvollständig bekanntes `transfer`-Objekt: Bei letzterem verlangt der Code grundsätzlich positive Nachfolgererfüllung oder die konkret belegte Immergrün-Ausnahme.

`species[]`, `green_rye_varieties[]`, `problem_weeds[]`, `oepul_codes[]` und `oepul_measures[]` sind Stringelemente ihrer Arrays. `events[]` und `measures[]` sind wiederholte Datensätze. Im Ergebnis sind die schlagbezogenen `violations` und `premium_blocks` Stringarrays; die unmittelbaren `parcel_violations`, `farm_violations`, `premium_blocks` und `missing_inputs` enthalten dagegen Objekte. Der einzige eigene `contains_rule`-Matcher verwendet ausschließlich das unmittelbare `parcel_violations`-Objektarray mit `rule_id`; dessen tatsächliche leere Antwort wird ausdrücklich geprüft und besteht die erwartete Regel nicht. Stringarrays verwenden `equals`.

## Tatsächlich verbesserte Verbraucher

Als `ineligible` klassifizierte Schlagverstöße und tatsächliche Prämienblockaden gehen in `creditable` ein. Die betriebliche Prämienfreigabe wird bei den Einzelbeträgen geprüft. Extern bewertete Kürzungsstufe, Ausschluss und Modulation verändern beide Haupt-Prämienbänder. Die Bandbreite wird nicht in einen angeblich allgemein garantierten Höchstbetrag umgedeutet. Eine pauschale Übertragung früherer Befunde, wonach Tabellen oder Diagnosen überhaupt keine Beträge beeinflussten, wäre hier falsch.

Gebietskörperschaften sind für diese Maßnahme quellenentsprechend ausgenommen; der entsprechende Verbraucher ist vorhanden. Frühere Beteiligungs-Ausschlüsse anderer Maßnahmen werden nicht übertragen. Bei bedingten Bewirtschaftungsausnahmen gibt es ebenfalls echte positive Gates: Vollständiges Abfrosten ist für bodennahes Häckseln positiv nötig, `crossing_only=true` begründet die Befahrungs-Ausnahme, und die Frost-Walz-Ausnahme verlangt positive Frost-/Deckungsangaben. Für bekannte Verpflichtungsverstöße wird keine selbst erfundene feste finanzielle Sanktion ausgerechnet; die bewertete AMA-Stufe bleibt eine externe Eingabe.

## Verbleibende Nachweis- und Bedeutungsgrenzen

Fehlende direkte Angaben können günstiger als ausdrücklich erlaubtes `null` oder bekanntes `false` sein. Fehlende Partner-/Familienzahlen unterdrücken die `<`-Prüfung. Zulässiges `null` sortiert in Rego dagegen unter Zahlen und erzeugt einen Unterschreitungsbefund. Dies ist keine Ermittlung einer tatsächlichen Anzahl und kein positiver Beleg. Fehlend/null bei Flächendeckung umgeht `== false`; fehlende aktive Folgekultur wird durch `object.get` sogar `true`. Eine fehlende Folgekultur oder ein fehlender Umbruch kann zwar `missing_inputs` erzeugen, ohne die Prämie zu sperren.

`properly_established` wird nur als positiver Beleg für Ausnahmen 2026 konsumiert. Bei bekanntem `false` in 2025 fehlt der bereits katalogisierte allgemeine Verpflichtungsbefund. Die entsprechende bekannte Quellenprobe verlangt **nur einen Verpflichtungsbericht**, keine automatische Nichtanrechnung oder bezifferte Prämienkürzung. Fehlende/null Varianten dieses Feldes prüfen dagegen den gewünschten positiven Nachweis vor einer Freigabe. Das ist von der Tatsachenbehauptung eines realen physischen Mangels zu unterscheiden.

Bei Pflege/Nutzung, Tiefenlockerung und zusätzlicher Einsaat lösen vielfach nur bekannte negative Fakten eine Verpflichtungsdiagnose aus. Fehlende/nullable Deckungs-, Nachwuchs-, Erhaltungs- oder Säscharbelege können ohne Befund passieren. Die gewünschten Probe-Regelmeldungen für unbekannte Fakten formulieren einen positiven Aufgabenvertrag; sie behaupten keine tatsächlich zerstörten Pflanzen. Ebenso werden fehlende Standort-/Aktivitäts-/Antragsbelege nicht als tatsächliche Auslandsfläche, Inaktivität oder Fristüberschreitung ausgegeben.

Für Variante 6 werden gelieferte Arten- und Sortennamen tatsächlich geprüft; fehlende oder leere Artenlisten liefern aber keinen positiven Zulässigkeitsnachweis trotz unabhängig gesetzter Partnerzahl. Ein ausdrücklich null gesetztes Array ist dagegen Schema-Stress. Für Variante 1 kann der Code einen expliziten insektenblütigen Count nutzen oder eindeutige exakte Namen in der beispielhaften Liste zählen. Die Beispielarten sind keine geschlossene biologische Gesamtliste. `plant_family_count` ist im Rohvorschlag generisch mit Variante-2-Beleg definiert. Variante 1 verlangt die Familien der qualifizierenden insektenblütigen Partner, nicht beliebiger zusätzlicher Gräser. Diese Zählmengenbindung wird nativ nicht abgeleitet oder abgesichert. Ohne geklärten Eingabevertrag wird daraus kein künstlicher normaler Quellengegenfall konstruiert.

Die SRL-/Merkblatt-Auslegungen zu Walzen, Beseitigung und Zeitintervallen sowie bekannte Management-/Arten-/Sortenfälle liegen bei den Begleitbeiträgen. Dieser Beitrag übernimmt deren Sollwerte nicht und vermischt sie nicht mit fehlenden Belegen oder ungültigen Typen.

## Nullable Laufzeitfehler mit zwei getrennten Zählachsen

Die 58 eigenen Probes liefern 45 definierte Antworten und 13 unverändert dokumentierte strikte Laufzeitfehler. Zwölf betreffen ausdrücklich zulässige nullable Werte. Die Herkunft der Eingabe und der erreichte Ausgabepfad sind zwei unabhängige Achsen:

| Nullable Eingabe | Herkunft | Betroffener Pfad |
|---|---|---|
| `termination_date` | Neuer Vorschlag | Hauptentscheidung |
| `variant_applied_on` | Neuer Vorschlag | Hauptentscheidung |
| `sowing_date` | Bereits bestehendes Canonical-Feld | Hauptentscheidung |
| Maßnahmen-`applied_on` | Neuer Vorschlag | Hauptentscheidung |
| Maßnahmen-`contract_start_year` | Neuer Vorschlag | Hauptentscheidung |
| Maßnahmen-`withdrawal_date` | Neuer Vorschlag | Hauptentscheidung |
| `inspection_announced_on` bei datiertem Ausstieg | Neuer Vorschlag | Hauptentscheidung |
| `preceding_main_crop_harvest_date` bei Untersaat | Neuer Vorschlag | Hauptentscheidung |
| `following_main_crop.sowing_date` bei Variante 1 | Neuer Vorschlag | Hauptentscheidung |
| `rape_four_leaf_stage_date` bei Variante-7-Herbizid | Neuer Vorschlag | Hauptentscheidung |
| `transfer.transferred_on` bei Immergrün-Ausnahme | Neuer Vorschlag | Hauptentscheidung |
| `special_circumstance.occurred_on` | Neuer Vorschlag | Nur separat abgefragter Permanenz-Helfer |

Das ergibt **elf neue Vorschlagsfelder plus ein Canonical-Feld** und zugleich **elf Hauptpfadfehler plus einen Helferfehler**. `contract_start_year=null` scheitert an der Subtraktion; die anderen genannten nullable Werte am ungeschützten Datumsparser. Diese zwölf sind nicht außerhalb des vorgeschlagenen bzw. bestehenden nullable Typs. Der zusätzliche dreizehnte Fehler entsteht durch `events[].date=null`, verletzt dessen nichtnullable Datumstyp und bleibt ausdrücklich separater Schema-Stress.

Ein fehlendes Feld verhält sich erneut anders: Fehlende Antrags-/Beginn-/Varianten-/Umbruchdaten können ihre Negativprüfung unterdrücken und Beträge belassen. Das bedeutet nicht, dass jede fehlende Angabe immer freigibt; beispielsweise fehlt ohne Saatdatum die aktive Anlage. Jeder Probe enthält seinen konkreten vollständigen Eingang und Pfad.

Sichere `status_equals`-Erwartungen sind technische Verfügbarkeitsanforderungen. Eine Quelle schreibt keinen OPA-Status und keinen bestimmten Zahlbetrag für unbekannte Daten vor. `undefined`, fachliches `false`, eine sichtbare Unbekanntdiagnose und Laufzeitabbruch bleiben unterschiedliche Zustände. Fehlerzahlen und fehlgeschlagene Assertions bilden keine fachliche Erfolgsquote.

## Tatsächliche App-Projektion

`adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` tatsächlich ausgeführt. Alle 47 Vorschlagspfade sind im synthetischen Eingang vorhanden. `CursorWrapper.execute` hätte jeden SQL-Aufruf unmittelbar abgebrochen; es gab keinen Datenbankaufruf. Eingang, Ausgang, drei Codehashes und sämtliche Pfadvergleiche stehen im JSON.

Nach der Projektion bleiben **0 von 47** neuen nativen Vorschlagspfaden und **6 von 10** zusätzlich gelesenen vorhandenen Pfaden. Verloren gehen auch die exakten vorhandenen Pfade für Bundesland, Bezirk, aktuellen Hauptkulturnamen und Begrünungs-Saatdatum. Anders benannte App-Felder werden nicht als gleichwertige native Pfade behandelt.

Der separate native Lauf mit genau dem projizierten Payload liefert eine definierte Antwort: Ackerflächenminimum `true`, Vertrag erlischt `true`, betriebliche Prämienfreigabe `false`, leere Schlagresultate und Netto 0. Das ist eine verfügbare Ablehnung ohne die benötigten Begrünungsdaten, keine implementierte Roh-Run-Integration, keine Feldaliasfreigabe und keine Bewertung eines anderen produktiven App-Regelpfads. Dieser zusätzliche Kompatibilitätslauf ist kein 59. unabhängiger Quellen-/Referenzfall.

Die 58 Probes verteilen sich auf fünf bekannte Quellenkomponenten, 32 gewünschte positive Nachweisanforderungen, 13 Eingabe-/Verfügbarkeitsdiagnosen und acht ausdrücklich schemawidrige Stressfälle. Alle nativen Läufe verwenden die unveränderte, über Repository-Prüfsumme gebundene OPA 1.18.2, strikte Builtin-Fehler, zehn Sekunden Evaluationslimit und gesperrte Netzwerk-/Zufalls-/Jetztzeit-Builtins. Geladen werden die historischen Verzeichnisse `workspace/policy` und `workspace/data` mit unveränderter Wurzel `data.o6_6`. Es gibt keine Daten-/Typumformung, alternative Laufzeit oder historischen Fix. Eigene und Begleitprobes können Kontrollkomponenten teilen; daraus wird keine gemeinsame unabhängige Genauigkeitsstichprobe. Es gab keine neue Modellabfrage, Promotion, Branchanlage oder Commit.
