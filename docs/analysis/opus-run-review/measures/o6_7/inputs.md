# o6_7 – Eingabevertrag und tatsächliche App-Projektion

Geprüft wurde ausschließlich der ursprüngliche Opus-Run `v2-o6_7-opus-5.5-high-20260925` am Candidate-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Sein natives Ziel ist **`data.o6_7.decision`**. Dieser Beitrag sammelt Befunde in Issue #112 / PR #111, verändert keine historischen Regeln, Profile, Quellen oder App-Funktionen und erteilt keine fachliche Freigabe.

[inputs.json](inputs.json) enthält alle 25 tatsächlichen Profilvorschläge mit 88 neuen Blättern, Typen, Einheiten, Bedeutungen, Defaults, Lesestellen und Ergebniswirkungen. Es enthält außerdem sieben Befunde und 57 neue öffentliche Eingabeprobes mit unveränderten nativen Beobachtungen. Der tatsächlich ausgeführte App-Adapter und dessen anschließender nativer Lauf sind separat gespeichert. Studienreferenzfälle, private Fälle, Experten-/GM-Urteile, manuelle Anpassungstests und Modell-Selbsttests wurden nicht als Sollantworten verwendet.

## Quellen, Namespace und gelesener Code

Das neue Original `o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf` wurde auf allen elf Seiten vollständig gelesen: jährlicher Vertrag und Mindestteilnahme, Haupt-/Zwischenfrüchte und ausgeschlossene Bestände, gesamte Ausgangsfläche, Tageszählung und sämtliche Lücken, Naturschutz-Selbstbegrünung und Flächenhinzunahmen, alle Beispiele, Ersteinstieg, Anlage-/Mischungs-/Winterhärte-/Dauerregeln, N/PSM, Pflege und Nutzung, mechanische Beseitigung, ganzjährige Aufzeichnungen, Beantragung und Umstieg, Ausstieg und Erosionsschutzfolgen, Prämienband, Aktualisierungen und Unverbindlichkeitshinweis. SHA256: `ec88c013768e73337a093aa3bf6241470462ad1aba26f79fd52f71137ac0aa8f`.

Das Paket enthält acht Originalquellen. Die sieben gemeinsamen Dateien – SRL, Anhänge, allgemeine Teilnahmebedingungen und vier Mitteilungen – sind identisch mit den bereits vollständig gelesenen Fassungen der vorigen Audits. Alle acht Hashes wurden erneut geprüft. Die zugeordneten aktuellen Belegstellen und ihr Anwendungsumfang wurden gezielt erneut gelesen. Alle 84 unterschiedlichen Zitate der Profilvorschläge und sämtliche zusätzlichen Finding-/Probe-Zitate sind nach ausschließlicher Leerraumnormalisierung auf den angegebenen Originalseiten auffindbar.

Eine GSP-AV ist diesem Run nicht beigefügt. Verweise in gelieferten Quellen bleiben eine Korpusgrenze; die GSP-AV eines anderen Runs wird hier weder als bereitgestellte Quelle noch als ungebundenes zusätzliches Sollwertorakel benutzt. Ebenso enthält das Paket keinen tatsächlichen regionalen NAPV-Endkalender. Diese Grenzen sind keine automatisch behaupteten Abweichungen von gelieferten Originalen.

Alle neun Produktionsmodule wurden vollständig gelesen: `lib`, `main`, `eligibility`, `catch_crop`, `greening`, `records`, `general`, `exit` und `premium`. Die vollständigen Rohannahmen erläutern die historische Modellierung und offenen Auslegungen, liefern aber keine unabhängigen Quellen-Sollwerte.

Die Struktur unterscheidet sich von den vorigen Runs: Die Policy verwendet `package o6_7` und Unterpakete, die statischen Dateien liegen unverändert unter `workspace/data/oepul/o6_7` und werden als `data.oepul.o6_7.*` gelesen. Geladen werden die ursprünglichen vollständigen Verzeichnisse `workspace/policy` und `workspace/data`. Es erfolgt keine Namespace-, Daten- oder Typumformung.

## Vollständiger Vorschlagsabgleich

Der Katalog enthält tatsächlich 25 Vorschläge mit 88 ausschließlich neuen Blättern. Bestehende Canonical-Typen werden nicht geändert. 84 Blätter werden gelesen; vier bleiben vollständig ungelesen. 29 gelesene Blätter wirken ausschließlich in sichtbaren Befunden und nicht als Prämiengate. Kein Vorschlagsblatt bleibt lediglich in einem getrennten ungenutzten Helfer.

| Nr. | Vorschlag | Blätter | Gelesen | Nur Befund |
|---:|---|---:|---:|---:|
| 1 | `farm.applicant` | 5 | 5 | 1 |
| 2 | `farm.oepul.first_participation_year` | 1 | 1 | 0 |
| 3 | `farm.oepul.participations` | 3 | 3 | 0 |
| 4 | `farm.oepul.control_refused` | 1 | 1 | 0 |
| 5 | `farm.oepul.control_refusal_force_majeure` | 1 | 1 | 0 |
| 6 | `farm.oepul.o6_7` | 11 | 8 | 4 |
| 7 | `land.protected_cultivation_area_ha` | 1 | 1 | 0 |
| 8 | `land.parcels[].usage_category` | 1 | 1 | 0 |
| 9 | `land.parcels[].oepul_codes` | 1 | 1 | 0 |
| 10 | `land.parcels[].oepul_measures` | 1 | 1 | 0 |
| 11 | `land.parcels[].op_measure_codes` | 1 | 1 | 0 |
| 12 | `land.parcels[].national_park` | 1 | 1 | 0 |
| 13 | `land.parcels[].is_in_austria` | 1 | 1 | 0 |
| 14 | `land.parcels[].area_type_code` | 1 | 1 | 0 |
| 15 | `land.parcels[].gloez8_npf_variant` | 1 | 1 | 0 |
| 16 | `land.parcels[].harvested_share` | 1 | 1 | 0 |
| 17 | `land.parcels[].no_harvestable_crop_due_to_drought` | 1 | 1 | 0 |
| 18 | `land.parcels[].force_majeure_recognised` | 1 | 1 | 0 |
| 19 | `land.parcels[].federal_state` | 1 | 1 | 0 |
| 20 | `land.parcels[].district` | 1 | 1 | 0 |
| 21 | `land.parcels[].acquisition` | 2 | 2 | 0 |
| 22 | `land.parcels[].gi_periods` | 2 | 2 | 0 |
| 23 | `land.parcels[].transfer` | 2 | 2 | 0 |
| 24 | `land.parcels[].es_acker_mulch_direct_strip_till` | 1 | 1 | 1 |
| 25 | `land.parcels[].greening` | 45 | 44 | 23 |

Vollständig ungelesen sind die drei Vertragsfelder `takeover_date`, `self_report_submitted`, `revision_consent_refused` und `greening.segments[].crop_name`. Eine katalogisierte Übernahme-, Selbstanzeige- oder Revisionsregel wird dadurch nicht ausführbar. Der ungelesene Kulturtext kann auch keine Getreide-, Sorten- oder Mischungsanteilsklassifikation beweisen.

Die 29 ausschließlich als Befund wirkenden Blätter verteilen sich wie folgt:

| Gruppe | Blätter | Ergebnisgrenze |
|---|---:|---|
| Antragsteller: eigener Name und eigene Rechnung | 1 | Sichtbare Verletzung; Regel fehlt im Vertragsgate der Prämie |
| Historisches Erlöschen, Wiedereinstiegsflag, neuer Antrag, Wechselantragsdatum | 4 | Sichtbare Vertrags-/Wechselbefunde, kein unmittelbares Prämiengate |
| ES-Option des Schlages und Doppelnutzungs-Feldfutterflag | 2 | Sichtbarer Kombinationsbefund |
| Vier Ereignisaufzeichnungen und Ganzjahresflag | 5 | Sichtbare Aufzeichnungsbefunde |
| Sichtbarkeit der Mischungspartner und Saatgutbeleg | 2 | Sichtbarer Belegbefund |
| Beseitigungsmethode, vollständiges Abfrosten, Folgesaatdatum, N-Datumsliste, NAPV-Ende, kombinierte N-Düngung, PSM-Datumsliste | 7 | Sichtbare Bewirtschaftungsbefunde; kein eigenständig berechneter finanzieller Kürzungssatz |
| Operationsdatum, Bodennähe, vollständiges Abfrosten, Deckung, Nachwuchs, Vollfläche, Problempflanze und Beleg | 8 | Sichtbare Bewirtschaftungsbefunde |

Damit wird das Lesen eines Feldes von seiner tatsächlichen Wirkung unterschieden. Die Deckungs-/Zwischenfruchtgültigkeit ist wiederum selbst Teil der Hauptausgabe, auch wenn sie keine automatische Geldkürzung festlegt.

## Tatsächliche Lesestellen und vorhandene Canonical-Pfade

Der vollständige Abgleich enthält 260 kontextbezogene Lesestellen. Er verfolgt direkte Referenzen, `object.get`, Abschnittsparameter `s`, den Wrapper `e.seg`, Operationen `op`, `mixture(s)`, Teilnahmeobjekte, Region, Erwerb und GI-Zeiträume. Die vier dynamischen Record-Schlüssel werden aus der tatsächlich konsumierten `record_events`-Tabelle aufgelöst: Ernte Hauptfrucht, Saat Zwischenfrucht, Umbruch Zwischenfrucht und Saat Folge-Hauptfrucht.

Variablennamen werden nach Kontext aufgelöst. `m` ist in manchen Teilnahmefunktionen ein Inputdatensatz, in anderen Blöcken eine statische Tabellenzeile. Die normalisierten Zwischenwerte `s.end` und `s.key` der Deckungsrechnung sind keine zusätzlichen Rohfelder `end` oder `key`; die Originalfelder heißen `end_date` und `segment_id`. Es bleiben keine nicht verwalteten zusätzlichen Eingabepfade.

Zusätzlich werden neun skalare vorhandene Pfade und ein tatsächlicher Objektcontainer gelesen: Betriebsjahr, Bezirk und Bundesland, aggregierte Ackerfläche, Gesamtfläche, Parzellen-ID/-fläche/-Nutzung, das betriebliche Aufzeichnungsflag sowie `farm.region` als Container. Ein erhaltener Region-Container bedeutet nicht, dass auch seine Gebietsfelder erhalten sind. Die exakten Typen, Einheiten und Verbraucher stehen im JSON.

Die tatsächliche Ackerschlagsumme hat Vorrang vor `land.arable_area_ha`, sobald überhaupt Ackerschläge vorhanden sind. Aggregat und Einzelschläge sind nicht beliebig austauschbar. `area_ha` und Betriebsfläche sind Hektar; `harvested_share`, `cereal_maize_share` und `frost_killed_share` sind Brüche zwischen 0 und 1. Die öffentliche Beteiligung verwendet dagegen Prozentpunkte zwischen 0 und 100. Der tatsächliche Prämiensatz hat die Einheit Euro pro Hektar. Keine dieser Größen wird stillschweigend in eine andere Einheit umgedeutet.

Das vorhandene `operations.cover_crop` mit nur einem Saatdatum sowie die undatierten PSM-/N-Kurzfelder werden überhaupt nicht gelesen. Sie können weder Vorjahreskulturen noch eine ganzjährige Abfolge aus Hauptfrüchten, Zwischenfrüchten, Lücken und Bewirtschaftungsereignissen ersetzen. Die neuen datierten Ereignisse besitzen tatsächliche Verbraucher.

## Identitäts- und Zeitvertrag

Abschnittsschlüssel werden als `parcel_id/segment_id` gebildet. Fehlt `segment_id`, verwendet der Code den Arrayindex. Die eigene Probe belegt diesen nativen Fallback als Engineering-Verhalten; sie gibt ihn nicht als gesetzlichen Ereignisidentitätsstandard aus. Eindeutigkeit, mögliche Kollisionen bei wiederholten IDs oder Trennzeichen und fachlich korrekte Ereignisidentität müssen vorgelagert gesichert werden. Ein explizites null im String-ID-Feld ist Schema-Stress, keine zulässige alternative Abschnittsidentität.

Vorjahresabschnitte müssen ausdrücklich geliefert werden. Ein vorhandener aktueller Kulturtext erzeugt keine historische Winterbegrünung. `is_undersown=true` wählt das Erntedatum der Hauptfrucht als effektiven Beginn; die zeitliche Übereinstimmung mit einem anderen Segment wird nicht automatisch hergeleitet. Fehlende Teilnahmejahre werden auf das Bewertungsjahr gesetzt, ein explizites nullable null dagegen nicht. Diese Unterschiede sind im Feldledger dokumentiert.

Die Quellenkontrollen sind vollständige bekannte öffentliche hypothetische Verläufe. Fehlende optionale Abmelde-, Erlöschens-, Wechsel- und Erwerbsfelder bedeuten in diesen Kontrollen ausdrücklich, dass kein solches Ereignis vorlag. Sie wurden nicht nachträglich entfernt, um einen fehlgeschlagenen Null-Lauf zu reparieren. Die gesonderten Missing-/Null-Probes prüfen jeweils einen bezeichneten unbekannten Sachverhalt.

## Verbesserte Verbraucher und verbleibende Beleggrenzen

Die Mischungsvoraussetzung wird tatsächlich positiv geprüft: Fehlende frühe Partner- oder Familienzahlen werden 0 und verhindern die Anrechnung. Für eine späte Mischung wird ein fehlender Abfrostanteil konservativ 1. Eine nullable unbekannte Beseitigungsmethode ist kein Mitglied der tatsächlich konsumierten Methodenliste und führt bei beendetem Abschnitt zu einem mechanischen Beseitigungsbefund. Positive Saatgut- und Problempflanzenbelege werden in ihren jeweiligen Ausnahmezweigen verlangt. Ein zulässiger unbekannter Prämiensatz fällt sicher auf die garantierten 70 Euro pro Hektar zurück.

Die zusätzlichen Felder für tatsächliche landwirtschaftliche Tätigkeit sowie eigenen Namen/eigene Rechnung sind vorhanden und werden konsumiert. Sie dürfen nicht mit fehlenden Feldern anderer Runs verwechselt werden. Gleichwohl prüfen die Verbraucher überwiegend nur bekanntes `false`; fehlende Belege können passieren. Das Eigenkonto-Feld liefert zudem nur einen Befund, weil sein Regelcode nicht im Prämien-Vertragsgate steht.

Vier dynamische Ereignisaufzeichnungen und das Ganzjahresflag verwenden `object.get(..., true)` und nur `== false`. Fehlende Aufzeichnungen können dadurch ohne Meldung bleiben. Die eigenen erwarteten Meldungen für unbekannte Belege formulieren einen gewünschten positiven Aufgabenvertrag, keine Tatsachenbehauptung tatsächlich fehlender historischer Aufzeichnungen und keine erfundene Geldstrafe.

Fehlende Flächendeckung kann ebenso den reinen Negativcheck umgehen. Fehlender Getreide-/Maisanteil wird günstig 0; der Kulturtext wird zur Prüfung nicht genutzt. `proper_sowing` dient nur den Erleichterungen 2026. Bei bekanntem `false` im gewöhnlichen Jahr fehlt bereits der allgemeine katalogisierte Verpflichtungsbefund. Die betreffende Quellenprobe verlangt nur einen Verpflichtungsbericht, keine automatische Nullprämie oder Abwertung eines unbekannten Saatmangels.

Bei fehlendem vollständigem NAT-Wiederbegrünungsdatum kann die 50-Tage-Rechnung ausfallen und der Abschnitt trotzdem als Hauptfrucht zählen. Das ist eine Nachweisgrenze; daraus wird kein tatsächlich verspäteter Aufwuchs behauptet. Der NAPV-Endtermin ist ausdrücklich extern. Ein Fallback auf Umbruchdatum oder einen künftigen Sentinel liefert keinen belegten rechtlichen Endkalender.

Die Deckungsrechnung, die Gründe nicht anrechenbarer Zwischenfrüchte und die Bewirtschaftungsbefunde sind tatsächlich in der Hauptentscheidung sichtbar. Viele flächenbezogene Ausschlüsse – OP, Kombinationen, Nationalpark, Flächentyp, Ernte und Weitergabe – sowie Kontrollverweigerung und Modulation verändern auch die Prämie. Inhaltliche Verstöße und `coverage_ok=false` weisen dagegen gemäß offener Rohannahme 15 keinen automatischen finanziellen Sanktionssatz zu. Der gesonderte Sanktionshelfer ist nicht mit einer bewerteten Eingabe und der Prämie verbunden. Die fachliche Bewertung der bekannten Zeit-/Management-/Sanktionsfälle liegt bei den Begleitbeiträgen.

## Nullable Laufzeitfehler und Schema-Stress

Die 57 Probes liefern 40 definierte Antworten und 17 unverändert dokumentierte strikte Laufzeitfehler. Vierzehn Fehlerfälle verwenden ausdrücklich zulässige nullable Werte aus dreizehn eindeutigen neuen Blättern. `end_date` wurde in zwei Rollen geprüft; es sind deshalb keine vierzehn verschiedenen Felder.

| Nullable Eingabe | Rolle | Beobachteter Pfad |
|---|---|---|
| `application_date` | Maßnahmenantrag | Hauptentscheidung |
| `first_contract_year` | Erstes Vertragsjahr | Hauptentscheidung |
| `withdrawal_date` | Abmeldung | Hauptentscheidung |
| `contract_lapsed_year` | Historisches Erlöschen | Hauptentscheidung |
| `switch_to_6_application_date` | Wechselantrag | Hauptentscheidung |
| `segments[].end_date` | Hauptfrucht | Hauptentscheidung |
| Dasselbe `end_date` | Zwischenfrucht | Hauptentscheidung |
| `undersown_host_harvest_date` | Untersaat | Hauptentscheidung |
| `following_main_crop_sowing_date` | PSM nach nichtmechanischem Ende | Hauptentscheidung |
| `nitrate_ban_end_date` | Datierte Mineral-N-Anwendung | Hauptentscheidung |
| `tillage_date` | NAT-Selbstbegrünung | Hauptentscheidung |
| `full_regreening_date` | NAT-Selbstbegrünung | Hauptentscheidung |
| `acquisition.acquired_date` | Unbegrünte Flächenhinzunahme | Hauptentscheidung |
| `gi_periods[].end_date` | GI-Zeitraum | Hauptentscheidung |

Alle vierzehn erreichen die Hauptentscheidung. Es wird hier weder ein bestehender Canonical-Nullable-Fehler noch ein ausschließlich getrennter Nullable-Helferfehler gezählt. Die konkreten Fehler umfassen Subtraktion, `substring` und Datumsparsing. Fehlende Enddaten und ausdrücklich erlaubtes null sind nativ nicht gleich: Die Rohannahmen beschreiben offene Abschnitte ohne Enddatum, während null an verschiedenen Parsern scheitert.

Drei weitere Fehler liegen außerhalb des Schemas: null im nichtnullable Abschnittsbeginn und Operationsdatum scheitert im Hauptpfad; null im nichtnullable Getreideanteil scheitert bei separat abgefragter Zwischenfruchtgültigkeit an der Subtraktion. Dieser dritte Lauf wird nicht als beobachteter Hauptpfadlauf ausgegeben. Null in Records-, Deckungs- und Operationsbooleans ist in diesem Run ebenfalls Schema-Stress, anders als die ausdrücklich nullable Ereignisflags des vorigen Runs.

Sichere `status_equals`-Erwartungen prüfen technische Diagnosefähigkeit. Keine Quelle schreibt einen OPA-Verfügbarkeitsstatus oder einen bestimmten Betrag für unbekannte Daten vor. Fachliches `false`, natives `undefined`, ein Unbekanntbefund und ein Laufzeitabbruch bleiben verschiedene Zustände. Fehlerzahlen und fehlgeschlagene Assertions sind keine Genauigkeitsquote.

Native `violations` sind Objekte mit `rule_id`; nur darauf werden Regel-Matcher angewandt, einschließlich tatsächlich leerer Antworten. Die Maps `catch_crops_not_counted` und `no_premium_parcels` enthalten dagegen Stringgründe, die Requalifizierungsausgabe String-IDs. Sie werden nicht als Regelobjekte gematcht. Die positive Hauptkontrolle prüft die vollständig leere Befundliste ausdrücklich mit `equals`.

## Tatsächliche App-Projektion

`adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` tatsächlich ausgeführt. Alle 25 Vorschlagspfade sind im synthetischen Eingang vorhanden. `CursorWrapper.execute` hätte jeden SQL-Aufruf sofort abgebrochen; es gab keinen Datenbankaufruf. Eingang, Ausgang, drei Codehashes und Pfadvergleiche stehen im JSON.

Nach der Projektion bleiben **0 von 25** neuen nativen Vorschlagspfaden und **7 von 10** zusätzlich gelesenen vorhandenen Pfaden. Das sind sechs skalare Pfade und der Region-Container. Feldaufzeichnungen, Bezirk und Bundesland fehlen am exakten nativen Pfad. Ein erhaltener Container ist keine erhaltene Gebietsinformation; ähnlich benannte App-Strukturen sind keine genehmigten nativen Aliase.

Der anschließende native Lauf mit genau diesem Projektionsausgang ist definiert: `access_ok=true`, `measure_valid=true`, `coverage_ok=false`, 365 Verstoßstage und trotzdem ein ungekürzter Rohbetrag von **210 Euro für 3 Hektar**. Dies ist eine konkrete Integrations- und Ergebnisgrenze. Der künstlich fehlenden Chronologie wird kein tatsächlich ganzjährig kahler Betrieb unterstellt; aus der Beobachtung folgt auch kein hier erfundener rechtlich zwingender Vollkürzungssatz. Der Run liefert ohne umgesetzten Eingabevertrag einen positiven Betrag neben einem erheblichen ungeklärten Befund. Ein anderer produktiver App-Regelpfad wird damit nicht bewertet oder verändert.

Die 57 eigenen Probes bestehen aus vier bekannten Quellenkomponenten, 20 gewünschten Nachweisanforderungen, 17 Eingabe-/Verfügbarkeitsdiagnosen und 16 ausdrücklich schemawidrigen Stressfällen. Der zusätzliche Projektionslauf ist kein 58. unabhängiger Quellen-/Referenzfall. Alle Läufe verwenden die unveränderte, per Repository-Prüfsumme gebundene OPA 1.18.2, strikte Builtin-Fehler, zehn Sekunden Auswertungslimit und gesperrte Netzwerk-/Zufalls-/Jetztzeit-Builtins. Es gibt keine Runtime-Reparatur, Ersatzlaufzeit oder Änderung historischer Artefakte. Kontrollkomponenten können sich mit Begleitbeiträgen überschneiden; daraus wird keine unabhängige gemeinsame Genauigkeitsstichprobe. Es gab keine neue Modellabfrage, Promotion, Branchanlage oder Commit.
