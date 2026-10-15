# o6_4 – Eingabevertrag und tatsächliche App-Projektion

Geprüft wurde ausschließlich der ursprüngliche Opus-Run `v2-o6_4-opus-5.5-high-20261009` am Candidate-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Sein natives Ziel ist `data.oepul.o6_4.decision`. Dieser Beitrag sammelt Befunde in Issue #112 / PR #111. Er verändert keine Regeln, Profile, Quellen oder Produktfunktionen und erteilt keine fachliche Freigabe.

[inputs.json](inputs.json) enthält den vollständigen Abgleich aller 13 Vorschläge mit 69 neuen Blättern, Einheiten, Typen, Bedeutungen, Defaults und Lesestellen; außerdem sieben Befunde und 50 neue öffentliche Eingabeprobes mit 50 nativen Beobachtungen. Ein zusätzlicher tatsächlicher App-Projektionslauf ist getrennt dokumentiert. Studienreferenzfälle, private Fälle, Experten-/GM-Urteile, manuelle Anpassungstests und Modell-Selbsttests wurden nicht als Sollantworten verwendet.

## Quellen und gelesener Code

Das neue Original `o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf` wurde vollständig gelesen: vier Seiten mit Vertragszeiträumen, Bergmahddefinition einschließlich Almbetriebsausnahme, fehlender Kombinations-/Gesamtteilnahme-/Mindestteilnahmepflicht, Mahd und Nachweide, Dünger-/PSM-Ausnahmen, Beantragung und Umstieg, allen BM-Codes und Beispielen, Prämientabelle, Aktualisierungen und Unverbindlichkeitshinweis. SHA256: `5c41df92f32e30cadf861474f4b51e3af9b8c74fe2b4494020bc876bc2ae149e`.

Das Paket enthält neun Quellen. Sieben gemeinsame Dateien werden nach vollständiger Vorlektüre in den bisherigen Audits wiederverwendet. Die zusätzlich bereitgestellte GSP-AV ist identisch mit der bereits für o6_1c vollständig gelesenen Fassung vom 28.01.2026: SHA256 `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10`. Sie ist hier tatsächlich geliefert und gebunden; eine frühere Korpuslücke wird nicht übertragen. Gezielt erneut gelesen wurden insbesondere GSP-AV Seiten 10/11 (§§ 5/6), 19 (§ 25), 30 (§ 46) und 31 (§ 48) sowie die zugeordneten gemeinsamen Belegstellen.

Alle neun Dateien wurden erneut gegen ihre Hashes geprüft. Die 49 unterschiedlichen Originalzitate sämtlicher Profilvorschläge sind nach ausschließlicher Leerraumnormalisierung auffindbar. Auch alle zusätzlichen Finding-/Probe-Belege wurden an den angegebenen Originalseiten geprüft. Die Gegenkontrollen verwenden die vollständigen jeweiligen Abschnitte; etwa stehen PSM-Verbot und Bio-Ausnahme auf den aufeinanderfolgenden Seiten 2 und 3 des Maßnahmenblatts.

Alle sechs Produktionsmodule wurden vollständig gelesen: `common`, `eligibility`, `obligations`, `administration`, `premium` und `decision`. Rohannahmen wurden als Erklärung des historischen Aufgabenvertrags gelesen, nicht als unabhängige Quellen-Sollantworten.

## Vollständiger Vorschlagsabgleich

Alle 69 Blätter sind neu; vorhandene Canonical-Typen werden nicht verändert. 67 Blätter werden im ausführbaren Code gelesen, zwei überhaupt nicht. Sieben gelesene Blätter bleiben auf getrennte Helfer beschränkt.

| Nr. | Vorschlag | Blätter | Gelesen | Wirkung und Grenze |
|---:|---|---:|---:|---|
| 1 | `farm.is_alm_operation` | 1 | 1 | Befreit nur die Höhenrelation zum Heimbetrieb |
| 2 | `farm.applicant` | 5 | 5 | Rechtsform, Beteiligung, Aktivität, eigener Name/Rechnung und Verfügungsgewalt |
| 3 | `land.protected_cultivation_area_ha` | 1 | 1 | Allgemeines Erstjahres-Betriebsminimum |
| 4 | `land.parcels[].mountain_meadow` | 8 | 8 | Teilnahme, Definition, deklarierter BM-Code und bestätigte Mähjahre |
| 5 | `land.parcels[].operations.mowing_events` | 5 | 5 | Datum, Vollfläche, Abtransport, Häckseln und tatsächliches Hauptverfahren |
| 6 | `land.parcels[].operations.grazing_events` | 2 | 1 | Nur Beginn wird geprüft, Ende bleibt ungelesen |
| 7 | `land.parcels[].operations.fertilizer_applications` | 3 | 3 | Datum, Düngerart und Bedarfsgerechtigkeit |
| 8 | `land.parcels[].operations.psm_applications` | 3 | 3 | Datum, diagnostisches Produkt und Bio-Wirkstoffbeleg |
| 9 | `land.parcels[].oepul` | 7 | 7 | Flächenprämienkombination, Codes, Park, Ausschlussgründe und punktförmige LSE |
| 10 | `oepul.first_participation_year` | 1 | 1 | Allgemeines erstes ÖPUL-Jahr |
| 11 | `oepul.participating_measures` | 1 | 1 | Betriebliche 1A/1B-Teilnahme für LSE-Abgeltung |
| 12 | `oepul.force_majeure_claims` | 6 | 5 | Parzellenbindung, Datums-/Belegprüfung; Kategorie bleibt ungelesen |
| 13 | `oepul.o6_4` | 26 | 26 | Vertrag, Umstieg/Ausstieg, Flächen, Übernahme, Feststellungen und Zahlung |

Die tatsächlichen Hauptpfade liegen hier unter **top-level `oepul`**. Sie sind weder `farm.oepul` der vorigen Runs noch die App-Struktur `oepul.measures`. Ebenso sind die verschiedenen Flächen-/Betriebsmaßnahmencodes und BM-Codes keine austauschbaren Namensvarianten. Das JSON genehmigt keine solchen Aliase.

Der historische Scanner findet nur `input.farm.year`. Der vollständige Abgleich enthält 124 kontextbezogene Lesestellen. Zwei dynamische Schlüsselvorlagen werden auf vier Definitionsfelder bzw. zwei Vertragsfelder erweitert. Der generische `events_in_year(e.date)`-Leser wird zu seinen drei tatsächlichen Eingabearrays Mahd, Dünger und PSM zurückverfolgt. Ein allgemeiner Date-Helfer erzeugt dabei keine erfundenen unabhängigen Eingabefelder. Es bleiben keine zusätzlichen nicht verwalteten Eingabepfade.

Vollständig ungelesen sind:

- `land.parcels[].operations.grazing_events[].end_date`
- `oepul.force_majeure_claims[].category`

Nur getrennte Helfer verwenden die vier Übernahmefelder, `declared_area_ha`, `determined_area_ha` und `payment_claim_overdue_more_than_one_year`. Die Ergebnisse `takeover_failures`, `over_declaration_sanction_ha` und `payment_claim_obligation_ended` werden in der Hauptentscheidung bzw. im Nettobetrag nicht konsumiert. Das ist von den hier tatsächlich verrechneten bewerteten inhaltlichen Feststellungen, der Modulation, der Zahlungsobergrenze und der Zugangskürzung zu unterscheiden.

## Vorhandene Canonical-Pfade und Arrays

Sechs vorhandene Pfade werden zusätzlich gelesen: Auswertungsjahr, Betriebsfläche, Parzellen-ID, Parzellenfläche, mineralischer N und das PSM-Kurzflag. Ihre Typen, Einheiten, Beobachtungsperioden und Identitätsgrenzen sind im JSON einzeln erläutert.

Das vorhandene `operations.cutting_dates`-Array wird dagegen überhaupt nicht gelesen. Es kann die neuen Mähereignisse mit Vollflächen-/Abtransport-/Methodennachweis nicht ersetzen. Ebenso genügt ein erhaltenes `land_use=grassland` nicht zur neuen Bergmahddefinition oder Teilnahmebestätigung.

Arraycontainer und Blätter bleiben getrennt: `full_mowing_years` ist eine Liste von Integer-Kalenderjahren; der ausgefaltete Pfad `full_mowing_years[]` beschreibt jeweils ein solches Jahr. `parcel_ids[]`, `codes[]` und Maßnahmencodes sind Strings, keine Objekte mit `rule_id`. Probes vergleichen String-Arrays mit `equals`. `contains_rule`/`excludes_rule` werden ausschließlich auf dem Objektarray `violations` verwendet.

`parcel_id` muss stabil und eindeutig sein. Der native Run baut damit seine Parzellendictionaries und verknüpft Umstieg sowie höhere Gewalt über exakte IDs. Unterschiedliche Objekte unter derselben ID können kollidieren. Das ist eine vorgelagerte Integritätsanforderung; hier wird weder ein zusätzlicher Duplicate-ID-Quellenfall noch ein angeblich gesetzlich vorgeschriebener OPA-Fehlerstatus erfunden.

## Bedeutende Verbesserungen und verbleibende Nachweise

Vier Angaben zur Bergmahddefinition und beide Vertragsdaten besitzen jetzt ausdrückliche Missinglisten. Fehlend oder zulässiges `null` verhindert die positive Bestätigung. Die Almbetriebsausnahme ist dabei berücksichtigt: Die fehlende Relation zum Heimbetrieb sperrt einen positiv angegebenen Almbetrieb nicht; der Höhenanteil über 1.200 m bleibt erforderlich. Eine unmittelbare Nachbarschaft bleibt quellenentsprechend ein Warnhinweis, kein automatischer Ausschluss.

Mähereignisse müssen Vollfläche und Abtransport positiv bestätigen. Mahd, Dünger und PSM besitzen aktuelle Jahresfilter. Eigener Name/Rechnung und Verfügungsgewalt sind als zusätzliche Antragstellerfelder tatsächlich vorhanden. PSM-Diagnosen bleiben auch bei fehlendem bzw. erlaubtem `null`-Produkttext erhalten. Höhere Gewalt wird an konkrete Parzellen-IDs gebunden. Die Übernahmefrist nutzt das Jahr des Ereignisses. Diese Verbesserungen werden ausdrücklich anerkannt.

Die neue Missinglogik ersetzt allerdings keine Typprüfung: Ein nicht-null falscher Typ wie `share_above_1200m_percent="100"` oder Boolean `false` kann sowohl den Null-Missingcheck als auch den numerischen Negativcheck umgehen. Ebenso kann ein falscher String in einem Definitionsboolean eine positive Bestätigung durchlassen. Diese Fälle sind ausschließlich Schema-Stress, keine gültigen Geografie- oder Farmfälle.

Für Festmist ist `demand_based:boolean|null` vorgeschlagen. Fehlend wird zu `true`; das ausdrücklich erlaubte `null` ist nicht `false`. Beides kann den Bedarfsgerechtigkeitsnachweis umgehen. Bekannte `true`/`false` sind getrennte Quellenkomponenten, während unbekannte Zustände die gewünschte positive Nachweisregel prüfen. Aus Unbekanntheit wird keine tatsächliche Überdüngung behauptet.

Beim Bio-PSM-Beleg ist fehlend konservativ `false` und wird beanstandet. Ein schemawidriges explizites `null` umgeht dagegen den reinen `== false`-Test. Auch dieser Typstress wird von einem gültigen Quellenfall getrennt. Vorhandene Produktnamen oder Antragscodes beweisen keine Wirkstoffzulässigkeit.

Wenn Mähereignisse oder ihre tatsächliche Methode fehlen, kann die Codeableitung ausfallen. Der Run kann dann auf einen beantragten BM3-Code zurückfallen und weiterhin eine positive Prämie ausgeben. Eine bekannte vollständige leere Mähliste ist davon verschieden. Die entsprechenden Probes verlangen einen positiven Nachweis vor einer Zahlungsbestätigung; sie erfinden weder ein anderes tatsächlich verwendetes Verfahren noch einen rechtlichen Sanktionssatz. Die fachliche Auslegung von tatsächlicher, aber nicht qualifizierender Mahd und BM0 bleibt beim Quellenbeitrag und den ausdrücklich offenen Rohannahmen.

Die Ursache einer höheren-Gewalt-Meldung bleibt im Feld `category` ungelesen. Die GSP-AV nennt beispielhafte offene Fälle; daraus wird hier kein erfundenes geschlossenes Kategorien-Gate abgeleitet. Belegte Betroffenheit und Anerkennungsumfang müssen fachlich geklärt werden. Die native Entschuldigung umfasst weiterhin alle Verstöße auf einer genannten Parzelle. Ebenso beschreibt ein allein gelesenes Beweidungsbeginndatum kein vollständiges mehrjähriges Intervall; dessen fachliche Gegenfälle liegen im Domainbeitrag.

## Null- und Laufzeitdiagnostik

Die 50 Eingabeprobes liefern 43 definierte Antworten und sieben unverändert dokumentierte strikte Laufzeitfehler. Dies sind Verfügbarkeitsbeobachtungen, keine fachliche Erfolgsquote.

| Gültigkeit des Eingabetyps | Zustand | Native Beobachtung |
|---|---|---|
| Erlaubtes `number|null` | `area_2025_ha=null` | Multiplikation scheitert nach 2025 in der Hauptentscheidung |
| Erlaubtes `number|null` | `declared_area_ha=null` | Subtraktion scheitert nur im getrennten Übererklärungshelfer |
| Erlaubtes `number|null` | `determined_area_ha=null` | Subtraktion scheitert nur in demselben getrennten Helfer |
| Außerhalb nicht-nullable `date` | Mahddatum `null` | `substring` scheitert im Jahresleser |
| Außerhalb nicht-nullable `date` | Düngerdatum `null` | Derselbe generische Fehler |
| Außerhalb nicht-nullable `date` | PSM-Datum `null` | Derselbe generische Fehler |
| Außerhalb nicht-nullable `date` | `contract_start_date=null` | Fehler trotz vorhandener Vertrags-Missingliste |

Damit gibt es drei Fehler mit ausdrücklich gültigen nullable Eingaben und vier mit ungültigen Datumswerten. Ein fehlendes Feld kann sich erneut anders verhalten: Eine fehlende Basis 2025 lässt den Zugangshilfswert undefiniert und den Faktor auf 1 zurückfallen; explizites erlaubtes `null` erreicht dagegen die Multiplikation. Die gewünschten sicheren Diagnosen erfinden keine tatsächliche Basisfläche oder konkrete Rückzahlung für unbekannte Werte.

## Tatsächliche App-Projektion

`adapt_payload_for_measures` wurde tatsächlich auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` ausgeführt. Alle 13 Vorschlagspfade sind im synthetischen Eingang vorhanden. `CursorWrapper.execute` hätte jeden SQL-Aufruf unmittelbar abgebrochen; es gab keinen Datenbankaufruf. Eingang, Ausgang, drei Codehashes und der Pfadvergleich stehen im JSON.

Nach der Projektion bleiben **0 von 13** neuen nativen Vorschlagspfaden und **6 von 6** zusätzlich gelesenen vorhandenen Pfaden. Die App-Struktur `oepul.shared`/`oepul.measures` ist nicht der native Maßnahmeneingang `oepul.o6_4`. Strukturierte Bergmahd-/Ereignisbelege gehen ebenso verloren. Die erhaltenen Kurzfelder ersetzen sie fachlich nicht.

Ein gesonderter nativer Lauf mit genau dem projizierten Payload liefert diesmal eine definierte Antwort: `contract_active=false`, beide fehlenden Vertragsangaben, leere Parzellen und Netto 0. Gegenüber o6_3 ist diese Ausgabe-Verfügbarkeit eine Verbesserung. Sie bedeutet keine brauchbare Integration des Roh-Runs, keine Freigabe von Feldaliasen und keine Bewertung eines davon verschiedenen produktiven App-Regelpfads. Dieser eine Kompatibilitätslauf wird nicht als 51. Quellen-/Referenzfall gezählt.

## Auswertungskonvention

Die 50 Probes bestehen aus sieben bekannten Quellenkomponenten, 20 gewünschten Anforderungen an positive Nachweise, drei Eingabe-/Diagnoserobustheitsfällen und 20 ausdrücklich außerhalb des Schemas liegenden Stressfällen. Positive Nachweisanforderungen behaupten keine tatsächlichen Verstöße unbekannter Sachverhalte. Eine Quelle schreibt keinen OPA-Verfügbarkeitsstatus vor; `status_equals` prüft hier technische Diagnosefähigkeit. Native `undefined`, ein fachliches Boolean `false` und ein Laufzeitfehler bleiben verschiedene Zustände.

Alle Läufe verwenden die unveränderte, über Repository-Prüfsumme gebundene OPA 1.18.2, strikte Builtin-Fehler, zehn Sekunden Evaluationslimit und gesperrte Netzwerk-/Zufalls-/Jetztzeit-Builtins. Geladen werden die historischen Verzeichnisse `workspace/policy` und `workspace/data` mit der ursprünglichen Wurzel `oepul_data`. Es gibt keine Datenumformung, alternative Laufzeit, historischen Fix oder daraus erzeugte Quellenwahrheit. Eigene und allgemeine/Domain-/Tabellenbeiträge können sich diagnostisch überschneiden; ihre Fallzahlen bilden keine unabhängige Genauigkeitsstichprobe. Es gab keine neue Modellabfrage, Promotion, Branchanlage oder Commit.
