# o6_8 – Eingabevertrag und tatsächliche App-Projektion

Geprüft wurde ausschließlich der ursprüngliche Opus-Run `v2-o6_8-opus-5.5-high-20261001` am Candidate-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Das native Ziel ist `data.oepul.o6_8.decision`, die statischen Tabellen liegen unverändert unter `data.o6_8.*`. Dieser Beitrag sammelt Befunde in Issue #112 / PR #111. Er verändert keine historischen Regeln, Profile, Quellen oder App-Funktionen und erteilt keine Produkt- oder Fachfreigabe.

[inputs.json](inputs.json) enthält alle 23 tatsächlichen Vorschläge: 22 Ergänzungen mit 93 neuen Blättern und eine Änderung des vorhandenen `operations.tillage_type`-Enums. Die insgesamt 94 Blätter sind mit Typen, Einheiten, Bedeutungen, Defaults, Lesestellen und Ergebniswirkungen erfasst. Sieben Befunde und 65 neue öffentliche Eingabeprobes stehen mit unveränderten nativen Beobachtungen im JSON. Der tatsächliche App-Projektionslauf und seine native Folgeauswertung sind separat gespeichert. Studienreferenzfälle, private Fälle, Experten-/GM-Urteile, manuelle Anpassungstests und Modell-Selbsttests wurden nicht als Sollantworten verwendet.

## Quellen und Code

Das neue Original `o6_8_erosionsschutz_acker_2026_04.pdf` wurde auf allen zwölf Seiten vollständig gelesen: mehrjähriger Vertrag und jährliches Minimum, differenzierte Kombination, Vorbegrünung und historische Übergänge, Definitionen von MS/DS/Strip-Till, sämtliche AH-, BAW- und US-Bedingungen, Weitergabe und Umwandlung, alle Antrags- und Codespezifika, DIV/NPF, alle historischen Prämien und Kombinationen, sämtliche Kulturlisten einschließlich Jahres- und Neueinsaatqualifikatoren, Aktualisierungen und Unverbindlichkeitshinweis.

SHA256 des neuen Originals: `3ac0d16ddd039ad87fc3364e98ce46ff23a21966f71a7c00efa3130e21490693`.

Das Paket enthält acht Originalquellen. Die sieben gemeinsamen Dateien sind identisch mit den bereits vollständig gelesenen Fassungen. Alle acht Hashes wurden erneut geprüft; die aktuell zugeordneten Belege und ihr Anwendungsumfang wurden gezielt erneut gelesen. Alle 72 verschiedenen Zitate der Profilvorschläge sowie alle zusätzlichen Finding-/Probe-Belege sind nach ausschließlicher Leerraumnormalisierung auf den angegebenen Originalseiten auffindbar. Eine GSP-AV ist diesem Run nicht beigefügt und wird weder rückwirkend gutgeschrieben noch als ungebundenes zusätzliches Sollwertorakel verwendet.

Alle zehn Produktionsmodule wurden vollständig gelesen: `common`, `crops`, `ms_ds`, `ah`, `baw`, `us`, `notices_2026`, `general`, `cross_measures` und `premium`. Die vollständigen Rohannahmen erläutern offene Fachauslegungen und den historischen Modellvertrag; sie ersetzen keine unabhängige Quelle.

## Vollständiger Vorschlagsabgleich

93 der 94 Blätter werden gelesen. Ein neues Blatt bleibt ungelesen; sechs gelesene Blätter wirken nur in getrennten Helfern. Ein weiteres erzeugt ausschließlich die in der Hauptausgabe sichtbare Obergrenzendiagnose.

| Nr. | Aktion | Vorschlag | Blätter | Gelesen | Nur Helfer |
|---:|---|---|---:|---:|---:|
| 1 | add | `farm.oepul.participating_measures` | 1 | 1 | 0 |
| 2 | add | `farm.oepul.options` | 1 | 1 | 0 |
| 3 | add | `farm.oepul.first_participation_year` | 1 | 1 | 0 |
| 4 | add | `farm.oepul.applicant` | 3 | 3 | 0 |
| 5 | add | `farm.oepul.o6_8` | 8 | 7 | 5 |
| 6 | add | `land.protected_cultivation_area_ha` | 1 | 1 | 0 |
| 7 | add | `land.parcels[].oepul_o6_8.codes` | 1 | 1 | 0 |
| 8 | add | `land.parcels[].oepul_o6_8.crop_usage_type` | 1 | 1 | 0 |
| 9 | add | `land.parcels[].oepul_o6_8.main_crop_sowing_date` | 1 | 1 | 0 |
| 10 | add | `land.parcels[].oepul_o6_8.location` | 6 | 6 | 0 |
| 11 | add | `land.parcels[].oepul_o6_8.preceding_catch_crop` | 3 | 3 | 0 |
| 12 | add | `land.parcels[].oepul_o6_8.tillage` | 10 | 10 | 0 |
| 13 | add | `land.parcels[].oepul_o6_8.potato_ridges` | 7 | 7 | 0 |
| 14 | add | `land.parcels[].oepul_o6_8.baw` | 22 | 22 | 0 |
| 15 | add | `land.parcels[].oepul_o6_8.undersowing` | 15 | 15 | 1 |
| 16 | add | `land.parcels[].oepul_o6_8.harvest` | 6 | 6 | 0 |
| 17 | add | `land.parcels[].oepul_o6_8.op_codes` | 1 | 1 | 0 |
| 18 | add | `land.parcels[].oepul_o6_8.trial_area_vf` | 1 | 1 | 0 |
| 19 | add | `land.parcels[].oepul_o6_8.public_funding_overlap` | 1 | 1 | 0 |
| 20 | add | `land.parcels[].oepul_o6_8.transferred_without_continuation` | 1 | 1 | 0 |
| 21 | add | `land.parcels[].oepul_o6_8.other_measures_on_parcel` | 1 | 1 | 0 |
| 22 | add | `land.parcels[].oepul_o6_8.other_area_payments_eur_per_ha` | 1 | 1 | 0 |
| 23 | change | `land.parcels[].operations.tillage_type` | 1 | 1 | 0 |

`previous_year_measure_area_ha` wird überhaupt nicht gelesen. Die generischen Flächenabgangsfunktionen verwenden ausdrückliche Funktionsparameter, nicht dieses vorgeschlagene Feld.

Nur getrennte Helfer lesen `exit_year`, `exit_reason`, `payment_application_submitted`, `late_payment_application_within_one_year`, `farm_handover_to_successor` und `undersowing.main_crop_harvest_date`. Die daraus berechneten Rückzahlungs-, Zahlungsantrags-, Übergabe- und möglichen Folgebegrünungsergebnisse werden von der Hauptentscheidung nicht konsumiert. Das vorhandene `slope_percent` wird ebenfalls nur in den getrennten UBB/BIO-Basisprämienfunktionen verwendet.

`other_area_payments_eur_per_ha` erzeugt dagegen das sichtbare `area_cap_exceeded`. Eine Aufteilung oder Kappung der Beträge ist damit nicht umgesetzt; die offene Rohannahme zur Aufteilung bleibt erhalten. Trotzdem muss das Feld für einen vollständigen Parzellenergebnis-Datensatz auswertbar sein: Ein zulässiges null kann die ganze Hauptentscheidung abbrechen.

## Reale Lesestellen, Typen und Einheiten

Der Abgleich enthält 131 kontextbezogene Lesestellen. Vier generische Feldhelfer werden bis zu den tatsächlich erreichbaren Schlüsseln aufgelöst: `ah_check` mit sieben, `baw_field` mit zwanzig, `us_field` mit fünfzehn und `harvest_field` mit fünf Schlüsseln. Zusammen sind das 47 dynamisch aufgelöste Schlüssel. Die vollständigen Literal- und geschlossenen Schleifen-Aufrufstellen bleiben je Blatt mit Datei, Zeile und Code erhalten. Aufrufbelege werden nicht zusätzlich als mehrfacher Laufzeit-Lesezugriff gezählt.

Direkte Referenzen, `object.get`, die Objektfunktionen für Vorbegrünung, Bodenbearbeitung, AH, BAW und US sowie die echten Variablenaliase werden berücksichtigt. Statische Tabellenzeilen sind keine Eingabealiase. Es bleiben keine nicht verwalteten zusätzlichen Eingabepfade.

Wichtig ist die neue Lage des Antragstellerobjekts: **`farm.oepul.applicant`**, nicht das in anderen Runs vorgeschlagene `farm.applicant`. Der Prüfbericht genehmigt keinen Alias zwischen diesen Pfaden oder zu anders aufgebauten App-Objekten.

Zwölf zusätzliche vorhandene Canonical-Pfade werden gelesen: Bezirk, Bundesland, Bewertungsjahr, Parzellenfläche/-nutzung/-ID, aktueller Kulturname, undatierte PSM-/mineralische N-/organische N-Kurzwerte, Hangneigung und Gesamtbetriebsfläche. Ihre exakten Typen und Verwendungsumfänge stehen einzeln im JSON. Das geänderte `operations.tillage_type` ist bereits im Vorschlagsledger enthalten und wird nicht nochmals als zusätzlicher vorhandener Pfad gezählt.

Ernteanteil, Leguminosenanteil und öffentliche Beteiligung sind **Prozentpunkte von 0 bis 100**. Der GIS-Pfadanteil ist ein **Bruch von 0 bis 1**. Parzellen-/Pfad-/Ausschlussflächen sind Hektar, AH-Abstände Meter, andere Flächenzahlungen Euro pro Hektar. Die Bodenbearbeitungs- und Saatdaten bezeichnen jeweils konkrete verschiedene Ereignisse. Einheiten und Bezugsgrößen werden nicht aus ähnlich benannten früheren Feldern übernommen.

Die neue Schlagnutzungsart wird tatsächlich verwendet; fehlt sie oder ist sie null, fällt `usage(p)` auf das vorhandene `crop.crop_name` zurück. Die Originalschreibweisen unterscheiden sich teils bewusst zwischen Verfahren, etwa `Sonnenblume` und `Sonnenblumen`. Die vorhandenen Legacy-N-/PSM-Werte werden bei BAW tatsächlich als undatierte Kurzwege konsumiert. Sie liefern keine vollständige Ereignisgeschichte zwischen Ersterklärung und Umbruch; die bekannten Fachgegenfälle dazu liegen beim Domainbeitrag.

## Geändertes Enum und echter DS-Selektor

Der 23. Vorschlag ergänzt `strip_till` im bereits vorhandenen Enum `operations.tillage_type`. Der native Verbraucher dieses Pfads prüft aber weiterhin nur `== "plough"` als wendende Bearbeitung. Der neue Enumwert wählt keine Strip-Till-Definitionsprüfung aus.

Dafür ist das neue `oepul_o6_8.tillage.ds_method` zuständig. Fehlt dieser Selektor, lautet sein Default `direct_seeding`. Ein ausdrücklich erlaubtes null trifft weder den Direct-Seeding- noch den Strip-Till-Zweig. Ein unbekannter nicht-null Token verhält sich ähnlich, liegt aber außerhalb des vorgeschlagenen Enums. Der eigene Konstruktionsprobe bestätigt den beobachtbaren Default; er erklärt keinen Namensalias zur rechtlich richtigen Verfahrensklassifikation.

Pfadpräsenz, Enum-Erweiterung, tatsächlicher Selektor und fachlich belegtes Verfahren sind damit getrennte Fragen. Eine reine Erweiterung des Canonical-Enums wäre kein ausreichender App-Adapter.

## Positive Baselines und Nachweisprobes

Die vollständige MS-Quellenkontrolle enthält einen gültigen Vertrag ab 2025 mit Antrag vom 31. Dezember 2024, zulässige Person, Lage, Codes und Ernte, bekannte geeignete Vorbegrünung ZWF-Variante 4, erste Bodenbearbeitung am 15. März und Hauptsaat am 1. April. Sie ist definiert und befundfrei, bestätigt den MS-Code und berechnet 54 Euro für einen Hektar.

Zusätzliche positive Komponenten für DS, AH, US und BAW sind ebenfalls definiert und ausdrücklich befundfrei. Nicht anwendbare MS-Bodenbearbeitungs-/Vorfruchtdaten wurden aus diesen Komponenten entfernt. Auf dem dauerhaften BAW-Schlag wird insbesondere keine aktuelle Bodenbearbeitung oder jährliche Hauptsaat suggeriert. Die BAW-Lage ist **KG 31001, Bocksdorf, Burgenland/Güssing**. `Bgld Bocksdorf Bocksdorf 31001` wurde im Original-Anhang F Seite 12 überprüft. Der hypothetische Schlag hat einen Hektar mit bekannten 0,25 Hektar GIS-Pfadüberlappung; das ist keine private GIS-Beobachtung.

Die Baselines sind vollständige bekannte hypothetische Verläufe. Abwesende optionale negative Ereignisse bedeuten dort nachgewiesen kein solches Ereignis. Sie sind keine nachträglich vorgenommenen Nullreparaturen. Die folgenden Missing-/Null-Fälle verändern jeweils gezielt den benannten Nachweis und behalten die bekannten übrigen Tatsachen bei.

Echte positive Verbraucher werden anerkannt: Eine nichtleere Antragstellerstruktur verlangt tatsächlich erlaubte Rechtsform und aktiven Landwirt exakt true. Geeignete Vorbegrünung und positiver Erhalt bei bekannter Tiefenlockerung werden ebenfalls verlangt. US-Datumsvergleiche und der Vertragsbeginn besitzen sichere Null-Guards. Diese Verbesserungen werden nicht mit früheren günstigen Negativchecks gleichgesetzt.

Gleichwohl umgehen ganze fehlende oder leere Antragstellerobjekte die Verletzung über `count(applicant)>0`. Fehlend/null im Antragsdatum kann bei aktivem Vertrag den Fristnachweis auslassen. MS-Mulch, DS-Schlitzverfahren, zahlreiche AH-Fakten und US-Anlage-/Erhaltungsnachweise verwenden günstige Defaults, reine Negativchecks oder Nichtnull-Guards. Ein unbekannter Wert kann damit ohne positiven fachlichen Nachweis passieren.

Für die Ausnahme 2026 wird zwar die vorgeschriebene Partnerzahl verlangt, `properly_established` aber über `!= false` ausgewertet. Fehlend und erlaubtes null können deshalb bei bekannt fehlender Flächendeckung eine Ausnahme begründen, obwohl ihr positiver Voraussetzungshinweis offen ist. Die entsprechenden Probes prüfen einen gewünschten Nachweisvertrag; unbekannt wird nicht als tatsächlich unsachgemäße Anlage ausgegeben.

Eine in Anhang F gelistete KG ist kein positiver Nachweis eines konkreten GIS-Eintragspfads. Sind beide erlaubten Überlappungswerte unbekannt, können Viertelprüfung und Kappung ausfallen. Ein angegebener Anteil überschreibt außerdem die aus Fläche und Schlaggröße berechnete Quote ohne Konsistenzabgleich. Die Gegenprobe verlangt positive Pfadevidenz; sie behauptet keinen tatsächlich fehlenden Pfad, keine ausgedachte Nullfläche und keinen erfundenen Kürzungsbetrag.

Bekannte Zeit-, Kultur-, Gebiets- und Übergangsgrenzen sowie Management-Auslegungen liegen bei den Begleitbeiträgen. Die eigene bekannte Mulch-false-Probe verlangt nur das zugehörige Quellen-Regelobjekt. Aus einem Managementbefund wird hier kein automatisch rechtlich vorgeschriebener Nullbetrag oder fester Sanktionsgrad abgeleitet. Dass der native Code viele solche Befunde tatsächlich über `code_compliant` mit dem Betrag verbindet, ist eine getrennt dokumentierte Implementierungsbeobachtung.

## Zulässiges null, fehlend und Schema-Stress

Die 65 Probes liefern 52 definierte Antworten und 13 unverändert dokumentierte strikte Laufzeitfehler. Zehn Fehlerfälle enthalten ausdrücklich zulässiges null auf neun eindeutigen neuen Blättern. Hauptsaatdatum wird in zwei unterschiedlichen Abfragekontexten getestet. Fünf Fehler erreichen die Hauptentscheidung, fünf ausschließlich separat abgefragte Helfer:

| Explizite nullable Eingabe | Kontext | Beobachteter Pfad |
|---|---|---|
| `tillage.first_tillage_date` | MS-Differenz | Hauptentscheidung |
| `main_crop_sowing_date` | MS-Differenz | Hauptentscheidung |
| `baw.gloez4_buffer_area_ha` | Flächenabzug | Hauptentscheidung |
| `baw.gloez8_fallow_area_ha` | Anwendbares Jahr 2024 | Hauptentscheidung |
| `other_area_payments_eur_per_ha` | Erforderliche Cap-Diagnose | Hauptentscheidung |
| `application_submitted_date` | Direkter Aufruf `application_timely` | Separater Helfer |
| `contract_start_year` | Direkter Aufruf `application_timely` | Separater Helfer |
| `undersowing.sowing_date` | `us_calendar_deadline` | Separater Helfer |
| Dasselbe `main_crop_sowing_date` | `us_latest_by_main_crop` | Separater Helfer |
| `undersowing.main_crop_harvest_date` | Mögliche Folgebegrünung | Separater Helfer |

Zusätzlich fehlt in einer MS-Probe das Hauptsaatdatum. Der native Default macht daraus null und die Hauptentscheidung bricht ab. Dieser Fall ist kein elfter expliziter Nullwert. Eine fehlende direkte `first_tillage_date`-Referenz verhält sich anders und kann die Vergleichsregel unterdrücken. Dieselben US-Daten bleiben im Hauptpfad durch Guards sicher auswertbar; ein Fehler ihres getrennten Helfers wird nicht als Hauptpfadfehler ausgegeben.

Zwei weitere Abbrüche sind ausdrücklich Schema-Stress: null statt des nichtnullable Antragstellerobjekts scheitert an `count`, ein String statt der nullable numerischen GLÖZ-4-Fläche an Addition. Ein unbekannter DS-Enumtoken, null im nichtnullable Aktivitätsboolean und String statt US-Partnerzahl sind ebenfalls Schema-Stress, werden aber nicht mit gültigen nullable Fehlern vermischt.

Der BAW-Nullfall ohne bekannten Umbruch bleibt dagegen sicher auswertbar. Ein fehlender oder null Vertragsbeginn führt im Hauptpfad zu inaktivem Vertrag. Diese sicheren Fälle verhindern eine pauschale Behauptung, jeder erlaubte Nullwert müsse abstürzen.

Technische `status_equals`-Erwartungen verlangen sichere Diagnosefähigkeit. Keine Quelle schreibt einen OPA-Verfügbarkeitsstatus oder einen bestimmten Zahlbetrag für unbekannte Daten vor. Fachliches false, fehlende Evidenz, natives undefined und Laufzeitfehler bleiben verschiedene Zustände. Die Fehler- und Assertionzahlen sind keine fachliche Genauigkeitsquote.

Nur das echte `violations`-Objektarray wird über `rule_id` gematcht. Verfahrenscodes, Ausschlussgründe und `farm_access_failures` sind Strings bzw. Stringarrays und verwenden `equals`. Alle fünf positiven Kontrollen prüfen ihre leeren Befundlisten ausdrücklich; ein leerer Rückgabewert besteht keine erwartete Regelmeldung durch einen falschen Matcher.

## Tatsächliche App-Projektion

`adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` tatsächlich ausgeführt. Alle 23 Vorschlagspfade sind im synthetischen Eingang vorhanden. `CursorWrapper.execute` hätte jeden SQL-Aufruf sofort abgebrochen; es gab keinen Datenbankaufruf. Eingang, Ausgang, drei Codehashes und vollständige Pfadvergleiche stehen im JSON.

Erhalten werden **0 von 22 neuen Pfaden und 0 von 1 geändertem vorhandenem Pfad**, insgesamt **0 von 23** Vorschlagspfaden. Beim geänderten Enum wurde ausdrücklich `strip_till` eingegeben. Im Ausgang wird nicht bloß ein anderer Wert gesetzt: Der gesamte exakte `operations.tillage_type`-Pfad fehlt. Dies ist im gesonderten Wertevergleich dokumentiert.

Von zwölf zusätzlich gelesenen vorhandenen Pfaden bleiben neun erhalten. Bezirk, Bundesland und der exakte `crop.crop_name`-Pfad fehlen. Gleichnamige oder ähnlich benannte andere App-Felder sind keine genehmigten fachlichen Aliase.

Der getrennte native Lauf mit genau dem Projektionsausgang ist definiert: `contract_active=false`, `farm_access_ok=false`, Teilnahmefläche 0, leere Parzellenresultate und Brutto-/Nettobetrag 0. Der sichtbare Hauptbefund betrifft das jährliche 0,10-Hektar-Minimum. Diese verfügbare Ablehnung ist keine umgesetzte Roh-Run-Integration, keine Produktfreigabe und keine Bewertung eines anderen produktiven App-Regelpfads. Sie wird nicht als 66. unabhängiger Quellen-/Referenzfall gezählt.

Die 65 eigenen Probes bestehen aus sechs bekannten Quellenkomponenten, 42 gewünschten Nachweisanforderungen, zwölf Eingabe-/Verfügbarkeitsdiagnosen und fünf ausdrücklich schemawidrigen Stressfällen. Alle Läufe verwenden die unveränderte, per Repository-Prüfsumme gebundene OPA 1.18.2, strikte Builtin-Fehler, zehn Sekunden Auswertungslimit und gesperrte Netzwerk-/Zufalls-/Jetztzeit-Builtins. Historische Policy- und Datenverzeichnisse werden ohne Typ-, Namespace- oder Datenumformung geladen. Es gibt keine Runtime-Reparatur, Ersatzlaufzeit, neue Modellabfrage, Promotion, Branchanlage oder Commit. Kontrollkomponenten dürfen sich mit Begleitbeiträgen überschneiden; daraus wird keine gemeinsame unabhängige Genauigkeitsstichprobe.
