# o6_3 – Eingabevertrag und tatsächliche App-Projektion

Geprüft wurde ausschließlich der ursprüngliche Opus-Run `v2-o6_3-opus-5.5-high-20260930` am Candidate-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Das native Ziel ist `data.o6_3.decision`. Dieser Beitrag sammelt Befunde in Issue #112 / PR #111; er verändert keine Regeln, Quellen, Profile oder App-Funktionen und erteilt keine Freigabe.

[inputs.json](inputs.json) enthält den vollständigen Abgleich aller 34 Vorschläge, 66 ausgefaltete Blätter, genaue Typen, Einheiten, Bedeutungen, Defaults und Lesestellen; außerdem sieben Befunde und 45 neu erstellte öffentliche Eingabeprobes mit 45 nativen Beobachtungen. Ein zusätzlicher Lauf auf der tatsächlichen App-Projektion ist getrennt erfasst. Es wurden keine privaten oder öffentlichen Studienreferenzfälle, GM-Urteile, Tests manueller Anpassungen oder Modell-Selbsttests als Sollantworten verwendet.

## Vollständig gelesene Quellen und Produktionsmodule

Das neue Original `o6_3_heuwirtschaft_2025_10.pdf` hat sechs Seiten und wurde vollständig gelesen: Vertrags- und Optionstabelle, Kombination, Mindestfläche und Tierhaltereigenschaft, Herstellungs-/Fütterungs-/Lagerungsverbote und Ausnahmen, Grünfütterung, Mähgutabgabe, Mähaufbereiteroption, Beantragung, Prämientabelle und Beispiel, vollständiger RGVE-Schlüssel, Aktualisierungen und Unverbindlichkeitshinweis. SHA256: `50349d5f574a60c20d156f8bad2217d5807bdb9c2aa231133353214fe71354c5`.

Sieben gemeinsame Quelldateien stimmen in ihren Hashes mit den vorangegangenen Audits überein. Ihre vollständige Vorlektüre wird wiederverwendet; alle 82 unterschiedlichen Belege der Eingabevorschläge wurden hier auf den Originalseiten bzw. im Hinweis mit dem jeweiligen Kontext nachgelesen. Alle 82 Zitate sind nach ausschließlicher Leerraumnormalisierung auffindbar. Ebenso wurden sämtliche zusätzlichen Finding-/Probe-Zitate geprüft. Für den Zahlungsantrag wird SRL Seite 22 § 1.10.5.3 verwendet; für aktive Landwirtschaft SRL Seite 8 § 1.4. Beide sind von der Maßnahmenantragsfrist und von der bloßen Rechtsformliste zu unterscheiden.

Alle acht Quellhashes sind erneut geprüft. Die GSP-AV gehört nicht zu diesem Rohpaket; aus später bekannten Rechtsquellen wird keine ungebundene Sollantwort abgeleitet. Die Prüfung betrifft sieben Produktionsmodule vollständig: `common`, `eligibility`, `livestock`, `obligations`, `general`, `premium` und `decision`.

## Vollständiger Vorschlagsabgleich

Es gibt 65 neue Blätter und eine vorgeschlagene Änderung des vorhandenen `species`-Enums, insgesamt 66. Von diesen werden 65 gelesen. Die einzige ungelesene vorgeschlagene Variable ist gerade das geänderte `livestock.species_groups[].species`. Drei gelesene Blätter wirken ausschließlich in getrennten Helfern; vier weitere Übernahmefelder erscheinen diagnostisch in `decision`, ohne den Zahlungszweig zu sperren.

| Nr. | Vorschlag | Blätter | Gelesen | Bedeutung / Grenze |
|---:|---|---:|---:|---|
| 1 | `farm.applicant` | 4 | 4 | Rechtsform, Körperschaft, Anteil und aktive Landwirtschaft |
| 2 | `farm.oepul.first_participation_year` | 1 | 1 | Erstes ÖPUL-Jahr für Betriebsminimum |
| 3 | `farm.oepul.participating_measures` | 1 | 1 | Exakte native Maßnahmenschlüssel |
| 4 | `farm.oepul.control_refused` | 1 | 1 | Kontrollverweigerung als Zahlungsblock |
| 5 | `farm.oepul.force_majeure` | 3 | 3 | Anerkennung wirkt; Ursache/Nichteinhaltbarkeit nur Claim-Helfer |
| 6 | `farm.oepul.o6_3.contract_start_year` | 1 | 1 | Kalenderjahr, zulässiges `null` und Jahresbezug |
| 7 | `farm.oepul.o6_3.measure_application_date` | 1 | 1 | Historischer Maßnahmenantrag; Prüfung nur im ersten Vertragsjahr |
| 8 | `farm.oepul.o6_3.option_no_mower_conditioner` | 2 | 2 | Beantragung und Kreuz in MFA-Angaben |
| 9 | `farm.oepul.o6_3.exit` | 3 | 3 | Austritt, Jahr und anerkannte Rückforderungsbefreiung |
| 10 | `farm.oepul.o6_3.payment_application_submitted` | 1 | 1 | Nur genau `false` verhindert Zahlung |
| 11 | `farm.oepul.o6_3.payment_application_missing_over_one_year` | 1 | 1 | Rückforderung, ohne eigenen Zahlungsblock |
| 12 | `farm.oepul.o6_3.hundred_percent_reductions_in_contract_period` | 1 | 1 | Anzahl vollständiger Kürzungen |
| 13 | `farm.oepul.o6_3.takeover` | 4 | 4 | Ausgegebene Übernahmeprobleme ohne Prämiengate |
| 14 | `farm.oepul.o6_3.area_change` | 5 | 5 | Verpflichtungsfläche, Zugangsbasis und befreite Abgänge in ha |
| 15 | `farm.feeding` | 13 | 13 | Verzichtsflags, Produktverfahren und Grünfütterungstage |
| 16 | `farm.forage_transfers` | 4 | 4 | Form, Empfänger und Hinweise auf Silageverwendung |
| 17 | `farm.machinery` | 2 | 2 | Vorhandensein und Verwendung von Mähaufbereitern |
| 18 | `land.protected_cultivation_area_ha` | 1 | 1 | Geschützter Anbau für Betriebsminimum |
| 19 | `land.parcels[].located_in_austria` | 1 | 1 | Lage; fehlend wird `true` |
| 20 | `land.parcels[].grassland_type` | 1 | 1 | Grünland-Untertyp für Mindest- und Prämienfläche |
| 21 | `land.parcels[].crop.forage_crop_type` | 1 | 1 | Native Ackerfutterkategorie |
| 22 | `land.parcels[].crop.is_second_crop` | 1 | 1 | Zweitkultur schließt Prämie und Futterzählung aus |
| 23 | `land.parcels[].operations.grazed` | 1 | 1 | Beweidung für Mindestbewirtschaftung |
| 24 | `land.parcels[].operations.mown_previous_year` | 1 | 1 | Vorjahresmahd bei Bergmähdern |
| 25 | `land.parcels[].enrolled_measures` | 1 | 1 | Einzelflächenkombination und separater Cap-Helfer |
| 26 | `land.parcels[].oepul_codes` | 1 | 1 | OP-Ausschluss; kein allgemeiner Beleg für Antrag oder Erfüllung |
| 27 | `land.parcels[].op_measures` | 1 | 1 | Maßnahmenbezogene OP-Wirkung, kein erfundener offizieller Codename |
| 28 | `land.parcels[].national_park` | 2 | 2 | Parkname plus tatsächlich vorhandenes Auflagenfeld |
| 29 | `land.parcels[].non_eligible_area_type` | 1 | 1 | Klassifizierter Ausschlussgrund |
| 30 | `land.parcels[].other_capped_oepul_payments_eur_per_ha` | 1 | 1 | Nur separater Obergrenzenhelfer |
| 31 | `livestock.species_groups[].rgve_category` | 1 | 1 | Exakte Kategorie statt Ableitung aus Tierart |
| 32 | `livestock.species_groups[].average_count` | 1 | 1 | Neuer `number|null`-Wert für vorgeprüfte Bestandsmittel |
| 33 | `livestock.species_groups[].kept_in_austria` | 1 | 1 | Haltungsort; fehlend wird `true` |
| 34 | `livestock.species_groups[].species` | 1 | 0 | Bestehendes Enum um `deer`/`new_world_camelids` erweitert |

Die 107 kontextbezogenen Lesestellen umfassen zwölf konkrete Aufrufe von `flag(obj,key)`. Deren Standardwert `false` wird auf die tatsächlichen Empfänger `feeding`, `machinery` bzw. Transferobjekte übertragen. Der historische Scanner meldet nur `input.farm.year`; er erfasst diese dynamischen, `object.get`- und Aliaszugriffe nicht. Daten-Tabellenvariablen wie `f.id` werden dabei nicht fälschlich als Futtereingaben gewertet. Nach diesem Abgleich bleiben keine zusätzlichen nicht verwalteten Eingabepfade.

`force_majeure.cause` und `.obligations_not_maintainable` werden nur für Claim-/Kanalhelfer gelesen. `other_capped_oepul_payments_eur_per_ha` wirkt nur in `cap_exceeded_parcels`. Alle drei Helferwirkungen fehlen im Hauptobjekt bzw. in der ausgegebenen Prämienzahl. Übernahmeprobleme werden dagegen in `decision.takeover_issues` angezeigt, ohne einen Zahlungsblock auszulösen.

## Sieben vorhandene Canonical-Pfade

Zusätzlich liest der Run Auswertungsjahr, Betriebsfläche, Parzellen-ID, Parzellenfläche, `land_use`, Schnittdaten und `animal_count`. Typ, Einheit, Zeitbezug, Identitätsgrenzen und tatsächliche App-Erhaltung sind für jeden Pfad im JSON erfasst.

Die Annotation unterscheidet Arraycontainer und Arrayelement ausdrücklich: Der tatsächlich gelesene Pfad `operations.cutting_dates` hat den Typ `["date"]`. Ein hypothetischer Blattpfad `cutting_dates[]` hätte dagegen den skalaren Elementtyp `date`. Native `is_mown` prüft nur die Zahl der Einträge, keine aktuelle Jahresbindung, Vollflächigkeit oder Entfernung des Mähguts. Die dazugehörigen fachlichen Jahresfälle gehören zum Quellenbeitrag; hier wird nur das explizite `null` als außerhalb des bestehenden nicht-nullable Arrays geprüft.

Die neue Variable `average_count:number|null` verbessert die Darstellung gegenüber o6_2: Ein echtes gebrochenes Jahresmittel ist jetzt im vorgeschlagenen Vertrag ausdrückbar. Ein entsprechender positiver Quellenfall gehört zum allgemeinen Audit. Hier zeigen die vier Fallbackdiagnosen: Nur ein numerischer Wert erhält Vorrang; fehlend, `null`, Boolean oder String fallen auf `animal_count` zurück. Die beiden letzten Werte liegen außerhalb des vorgeschlagenen Typs. Ein unveränderter aktueller Ganzzahlbestand ist dadurch nicht automatisch als jahresgemittelter Bestand belegt.

`rgve_category` wird nicht mit `species`, Alter, Größe oder Rasse gegengeprüft. Fehlende, `null` oder unbekannte Kategorien fallen aus der Summe, ohne einen sichtbaren Zuordnungshinweis zu erzeugen. Die absichtlich inkonsistente Kombination `species=pigs` mit einer Rinderkategorie wird als Robustheitsfall geprüft. Dessen gewünschte Ablehnung als undefinierte Klassifikation ist eine technische Repräsentation und kein gesetzlich vorgeschriebener OPA-Status.

## Nullzustände und strikte Laufzeit

Von 45 fokussierten Eingabeprobes liefern 38 eine definierte Antwort und sieben einen unverändert aufgezeichneten strikten Laufzeitfehler. Diese Verfügbarkeitsbeobachtung ist keine fachliche Erfolgsquote.

| Gültigkeit des Eingabetyps | Zustand | Native Auswirkung |
|---|---|---|
| Vorgeschlagenes `number|null` | Aktuelle Grünland-Verpflichtungsfläche `null` | Subtraktion scheitert in der Hauptentscheidung |
| Vorgeschlagenes `number|null` | Befreiter Verlust der Verfügungsgewalt `null` | Addition scheitert in der Hauptentscheidung |
| Vorgeschlagenes `number|null` | Befreite erlaubte Umwandlung `null` | Addition scheitert in der Hauptentscheidung |
| Vorgeschlagenes `number|null` | Vorjahres-Grünlandfläche `null` | Multiplikation scheitert trotz lokaler Typwache |
| Vorgeschlagenes `number|null` | Andere gedeckelte Zahlungen `null` | Addition scheitert nur im getrennten Cap-Helfer |
| Außerhalb des vorhandenen Datumsarrays | `cutting_dates=null` | `count` scheitert |
| Außerhalb des vorgeschlagenen `int` | Grünfütterungstage `null` | Addition scheitert |

Der Vorjahresfall ist besonders relevant: `relevant_decrease_ha` besitzt zwar eine `is_number`-Wache. Der äußere Vergleich kann trotzdem `allowed_decrease_ha(previous_year_grassland_ha)` aufrufen und mit `null` multiplizieren. Die fünf zulässigen `null`-Fälle werden deshalb von den zwei nicht schemakonformen Typstressfehlern getrennt. Die verlangte sichere Diagnose erfindet weder eine tatsächliche Flächenveränderung noch einen konkreten Rückzahlungsbetrag.

Weitere Unterschiede zwischen fehlend, `null` und `false` sind ohne Laufzeitfehler sichtbar. Fehlende Antragstellerangaben werden günstig ersetzt. Bei Silageverzichtsflags wirkt fehlend wie `false`; das ist kein nachgewiesener Verzicht. Fehlender Zahlungsantrag wird `true`, und selbst `null` blockiert nicht, weil nur genau `false` als Block definiert ist. Im späteren Vertragsjahr werden fehlende historische Antragsdaten nicht positiv verlangt. Eine `null`-Basisfläche 2025 lässt die Zugangsbeschränkung aus und belässt im Diagnosefall alle 10 ha als förderfähig.

Für diese unbekannten Sachverhalte formulieren die Probes die gewünschte positive Nachweisanforderung. Sie behaupten keine tatsächlich verspätete Antragstellung, Silagefütterung oder unterlassene Zahlungsvoraussetzung und leiten daraus keine automatische gesetzliche Sanktion ab.

Ein eigener Stressfall zeigt einen Darstellungsfehler: Bei bekanntem `fermentation_in_production=true` hängt der erzeugte Verstoß zusätzlich von `f.name` im Detailtext ab. Fehlt der vorgeschriebene Anzeigename, verschwindet die ganze Verstoßzeile. Das ist als ungültige erforderliche Eingabe markiert; es wird nicht als gewöhnlicher gültiger Farmfall oder Genauigkeitsfehler gezählt. Der erlaubte Zustand `feed_id=null` ist hiervon unabhängig.

## Tatsächliche aktuelle App-Projektion

Der pure Adapter `adapt_payload_for_measures` wurde tatsächlich auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` ausgeführt. Alle 34 vorgeschlagenen Pfade sind im synthetischen Eingang vorhanden. `CursorWrapper.execute` hätte jeden SQL-Aufruf unmittelbar abgebrochen; es gab keinen Datenbankaufruf. Eingang, Ausgang, Codehashes und Pfadvergleich stehen vollständig im JSON.

Erhalten bleibt **1 von 34** Vorschlagspfaden: das bereits vorhandene `species`-Feld. Alle **33 neuen** Vorschlagspfade fehlen nach der Projektion. Die sieben zusätzlich gelesenen bestehenden Canonical-Pfade bleiben vorhanden. Das Kopieren des neuen synthetischen Strings `deer` zeigt nur dieses Adapterverhalten; es beweist keine Annahme neuer Enumwerte durch API, Export oder unverändertes Canonical-Schema. Native Rego liest `species` ohnehin nicht.

Die App-Projektion entfernt insbesondere `farm.applicant`, `farm.oepul`, `farm.feeding`, die nativen Flächenuntertypen und die neue RGVE-Kategorie. Vorhandene Flächen-, Schnitt- und Tierzahlwerte ersetzen diese Belege nicht. Ein anschließender Lauf mit genau diesem projizierten Payload bricht nativ bei `general.rego:24` ab: Die fehlende Vorjahresfläche wird `null` und erreicht die Multiplikation. Dieser eine Kompatibilitätslauf ist separat gespeichert und wird nicht als zusätzlicher Quellen-/Referenzfall gezählt.

## Auswertungskonvention und Grenzen

Die 45 Probes unterscheiden sieben bekannte Quellenkomponenten, 14 gewünschte Anforderungen an positive Nachweise, elf Eingabe-/Diagnoserobustheitsfälle und 13 ausdrücklich außerhalb des Schemas liegende Stressfälle. Native `undefined`, ein fachliches Boolean `false` und ein vollständiger Laufzeitfehler sind verschiedene Zustände. Eine Quelle schreibt keinen OPA-Verfügbarkeitsstatus vor. `status_equals` dient hier der technischen Diagnose oder einer ausdrücklich gekennzeichneten gewünschten Ablehnung widersprüchlicher Eingaben.

Parkauflagen sind in diesem Roh-Run tatsächlich über `national_park.has_relevant_management_restrictions` modelliert und gelesen; ein Fehlfeldbefund aus o6_2 wird nicht übernommen. Ebenso wird die neue Möglichkeit gebrochener Bestandsmittel ausdrücklich anerkannt. Externe Herstellungsverfahren, vollständige Tiergruppenerfassung und einzelfallbezogene Anerkennung höherer Gewalt bleiben fachlich vorgelagerte Belege. Der vorhandene globale Anerkennungsflag löscht sämtliche inhaltlichen Verstöße; sein tatsächlicher zulässiger Umfang ist nicht durch das Boolean selbst bewiesen.

Alle Läufe verwenden die unveränderte, über Repository-Prüfsumme gebundene OPA 1.18.2, strikte Builtin-Fehler, zehn Sekunden Evaluationslimit und gesperrte Netzwerk-/Zufalls-/Jetztzeit-Builtins. Geladen werden die historischen Verzeichnisse `workspace/policy` und `workspace/data` einschließlich der Unterstruktur `data/o6_3`; keine flach umgebaute Datenwurzel und kein anderer Laufzeit-Pin. Separate numerische Pin-/Laufzeitfragen bleiben von diesen Eingabebefunden getrennt. Fälle verschiedener Auditbeiträge können sich diagnostisch überschneiden und ergeben keine unabhängige Genauigkeitsstichprobe. Es gab keine Produktänderung, neue Modellabfrage, Promotion, Branchanlage oder Commit.
