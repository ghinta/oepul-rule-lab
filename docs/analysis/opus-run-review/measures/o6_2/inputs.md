# o6_2 – Eingabevertrag und App-Projektion

Geprüft wurde ausschließlich `v2-o6_2-opus-5.5-high-20260930` am eingefrorenen Candidate-Commit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Dieser Teil sammelt Befunde in Issue #112 / PR #111. Er ändert keine Regeln, Profile, Quellen oder App-Funktionen und erteilt keine fachliche Freigabe.

Die maschinenlesbare Ergänzung ist [inputs.json](inputs.json): alle 26 Vorschläge mit 72 ausgefalteten Blättern, genaue Typen, Einheiten, Bedeutungen, Defaults, Lesestellen und Wirkung auf die Ausgabe; außerdem Quellenbelege, App-Ein-/Ausgabe, sieben Befunde und 54 öffentliche Entwicklungsprobes mit 54 unveränderten nativen Beobachtungen. Modell-Selbsttests liefern keine erwarteten Antworten.

## Umfang und Quellenbindung

Das neue Original `o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf` wurde vollständig gelesen: acht Seiten einschließlich Vertragstabelle, Stoffausnahmen, PSM-Codierung und deren Entfall ab 2026, Weiterbildung, Beantragung, Prämientabelle, RGVE-Schlüssel, Aktualisierungen und Unverbindlichkeitshinweis. SHA256: `019bab30ef890a76918a9041268fa3d299ba2d9395d61810e1ce5ce9e00e4e1c`.

Sieben weitere Quelldateien haben exakt dieselben Hashes wie in den vorangegangenen Audits. Deren vollständige Vorlektüre wird wiederverwendet; die 109 unterschiedlichen Belege aller 26 Eingabevorschläge wurden hier an den Originalseiten bzw. Hinweisen mit ihrem jeweiligen Zusammenhang nachgelesen. Alle 109 Belegtexte sind nach ausschließlicher Leerraumnormalisierung auffindbar. Die zusätzliche Probe zum Zahlungsantrag verwendet SRL Seite 22 § 1.10.5.3, nicht die davon verschiedene Maßnahmenantragsfrist. Alle acht Quellhashes sind im JSON erneut gegen die Dateien geprüft.

Die GSP-AV ist in diesem Run nicht bereitgestellt. Die bei o6_1c neu hinzugekommene Rechtsquelle wird weder stillschweigend eingebunden noch als ungebundene Sollantwort verwendet. Externe Rechts-, Register- und Produktklassifikationen bleiben als Paket-/Nachweisgrenzen ausgewiesen.

Alle acht Produktionsmodule wurden vollständig geprüft: `common`, `eligibility`, `contract`, `livestock`, `management`, `obligations`, `premium` und `decision`. Die Tabellen und allgemeinen fachlichen Regeln besitzen eigene Auditbeiträge; dort behandelte Fristen, Dürrekulissen und Prämiengrenzen werden hier nicht nochmals als unabhängige Fälle gezählt.

## Vollständiger Vorschlagsabgleich

Alle 72 Blätter sind neu; es gibt keine vorgeschlagene Änderung eines vorhandenen Typs. 69 Blätter werden im Code gelesen. Sechs dieser gelesenen Blätter wirken ausschließlich in getrennten Helfern. Drei bleiben vollständig ungelesen.

| Nr. | Vorgeschlagener Pfad | Blätter | Gelesen | Bedeutung / Grenze |
|---:|---|---:|---:|---|
| 1 | `farm.oepul` | 40 | 40 | Zugang, Teilnahme, Verfahren, Kurse und Lagerung; fünf Blätter nur in Helfern |
| 2 | `livestock.nitrogen` | 3 | 2 | Kilogramm N im aktuellen Kalenderjahr; Abnahmevertrag bewusst ohne Abzug |
| 3 | `livestock.species_groups[].rgve_key_id` | 1 | 1 | Exakter Tabellenklassifikator; keine Gegenprüfung von Art/Alter/Rasse |
| 4 | `livestock.species_groups[].held_in_austria` | 1 | 1 | Haltungsort; fehlend wird `true` |
| 5 | `livestock.species_groups[].count_method` | 1 | 0 | Vorgeschriebene Bestandsmethode ohne Ausführungswirkung |
| 6 | `land.parcels[].land_use_code` | 1 | 1 | INVEKOS-Code, insbesondere `GA` |
| 7 | `land.parcels[].previous_land_use_code` | 1 | 0 | Vorjahresnutzung wird keiner Umwandlungsprüfung zugeführt |
| 8 | `land.parcels[].is_in_austria` | 1 | 1 | Flächenlage; fehlend wird `true` |
| 9 | `land.parcels[].federal_state` | 1 | 1 | Exakter Dürre-Gebietsname; fehlend nutzt Betriebsregion, `null` nicht |
| 10 | `land.parcels[].district` | 1 | 1 | Exakter Bezirk; dieselbe Fallbackgrenze |
| 11 | `land.parcels[].national_park` | 1 | 1 | Parkklassifikation und Flächenausschluss |
| 12 | `land.parcels[].oepul_codes` | 1 | 1 | PSMBIO/PSMCS/OP/VF; Antragscode ersetzt keinen Produktnachweis |
| 13 | `land.parcels[].parcel_measures` | 1 | 1 | Exakte SRL-Kombinationscodes |
| 14 | `land.parcels[].fruit_quality_planting_material` | 1 | 1 | Obstqualität; fehlend wird `true`, erlaubtes `null` ist nicht `false` |
| 15 | `land.parcels[].other_area_payments_eur_per_ha` | 1 | 1 | Anzurechnende andere, bereits modulierte Zahlungen in €/ha |
| 16 | `land.parcels[].transferred_during_year_without_continuation` | 1 | 1 | Nur Helfer für erforderlichen OP-Code |
| 17 | `land.parcels[].crop.forage_as_second_crop` | 1 | 1 | Prämien-/Futterflächenklassifikation, getrennt vom PSM-Verbot |
| 18 | `land.parcels[].crop.glaez8_npf` | 1 | 1 | Historischer Ausschluss bis 2024 |
| 19 | `land.parcels[].crop.non_eligible_type` | 1 | 1 | Klassifizierter Flächenausschluss |
| 20 | `land.parcels[].crop.usually_harvested_late_summer_or_autumn` | 1 | 1 | Reguläre Kulturerntezeit für Dürreausnahme |
| 21 | `land.parcels[].operations.fertilizer.inputs` | 4 | 4 | Stoff-ID, Herkunft, N-Gehalt und belegte Biogasrücknahme |
| 22 | `land.parcels[].operations.psm_applications` | 3 | 3 | Anwendungsart, positiver Bio-Beleg und diagnostischer Produktname |
| 23 | `land.parcels[].operations.harvested_share_percent` | 1 | 1 | Ernte plus Abtransport als Anteil des aktuellen Schlages |
| 24 | `land.parcels[].operations.mowing_material_removed` | 1 | 1 | Abtransport; fehlend wird `true` |
| 25 | `land.parcels[].operations.full_area_grazing` | 1 | 1 | Vollflächige Jahresbeweidung; nur genau `false` beanstandet |
| 26 | `land.parcels[].operations.no_harvestable_crop_due_to_drought` | 1 | 1 | Belegter dürrebedingter Ernteausfall |

Das JSON bindet für jedes Blatt die konkreten Fundstellen. Es zählt 158 deklarierte, kontextbezogene Lesestellen einschließlich Containerzugriffen. Der historische Scanner meldet lediglich `input.farm.year` und `input.land.total_area_ha`. Die Differenz entsteht vor allem durch `object.get`, lokale Empfänger und den polymorphen Düngerhelfer.

Zwei tatsächlich verwendete Pfade fehlen sowohl im Canonical-Profil als auch in allen Vorschlägen:

- `farm.oepul.operating_supplies[].contains_n`
- `farm.oepul.operating_supplies[].is_return_of_delivered_slurry`

`fertilizer_input_prohibited(s)` ruft für gekaufte/gelagerte Dünger denselben Helfer wie für ausgebrachte Stoffe auf. Dadurch werden dessen beiden Zusatzfelder auch auf Lagerobjekten gelesen. Die Erkennung expandiert nur die tatsächlichen Helfer-Lesestellen bis Zeile 30; ein Ausbringungs-Verstoßkopf mit `i.input_id` wird nicht fälschlich auf Lagerung übertragen. Beide nicht verwalteten Pfade besitzen eigene Laufzeitpaare. Es wird keine Erweiterung des Canonical-Profils vorgenommen.

Die sechs ausschließlich in Helfern verwendeten Blätter sind Vorjahresfläche, Flächenabgang, die drei Übernahmefelder und das Flag für Weitergabe ohne Fortführung. `previous_land_use_code` ist ungelesen; der aufrufbare `conversion_allowed`-Helfer erhält nur explizite Parameter. `manure_offtake_contract_n_kg` ist dagegen fachlich bewusst ungelesen: Das Original verbietet die Berücksichtigung solcher Verträge bei der 170-kg-N-Grenze.

## Vorhandene Canonical-Pfade

14 vorhandene Pfade werden zusätzlich gelesen: Auswertungsjahr und zwei regionale Fallbacks; Gesamtfläche; Parzellen-ID, Fläche, Landnutzung und zwei Kulturfelder; Schnittdaten, PSM-Einsatz und mineralischer N; Tierart und Tierzahl. Das JSON erläutert jeden dieser Pfade mit Typ, Einheit, Zeitbezug, Identität und Ausgabeabhängigkeit.

Besonders relevant ist `animal_count`: Das eingefrorene Profil verlangt weiterhin `int`. Der Run setzt laut seiner Annahme 2 bereits nach Quellenmethode ermittelte Bestände voraus, bei Rindern einen taggenauen Jahresdurchschnitt. Solche Mittelwerte können Bruchteile enthalten. Die vorgeschlagenen Ergänzungen ändern den int-Vertrag nicht. Der native Kontrolllauf mit `0.5` funktioniert rechnerisch, ist aber ausdrücklich außerhalb des bestehenden int-Schemas markiert. Er belegt keinen gültigen Canonical-Farm-Fall und kein Genauigkeitsergebnis.

Der Schlüssel `rgve_key_id` wird nicht mit `species`, Altersklasse, Rasse oder Größenmerkmalen verbunden. Ein widersprüchlicher Datensatz `species=pigs` plus `cattle_ge_2y` wird arithmetisch als Rind gerechnet. Fehlende, `null` oder unbekannte Schlüssel fallen dagegen aus der RGVE-Summe. Der Helfer `unmapped_species_groups` wird in `decision` nicht ausgegeben; `count_method` bleibt ungelesen. Eine App-Abbildung muss diese Klassifikationen nachweisen und ihre Konsistenz prüfen.

## Fehlende Angaben, null und Laufzeit

54 fokussierte Probes ergeben 46 definierte Antworten und acht unveränderte strikte Laufzeitfehler. Dies sind Verfügbarkeits-/Diagnosebeobachtungen, keine Erfolgsquote und kein Maß fachlicher Genauigkeit.

| Gültigkeit des Eingabetyps | Pfad | Native Beobachtung |
|---|---|---|
| Vorgeschlagenes `number|null` | `n_after_stall_storage_losses_kg=null` | `minus`-Fehler, Hauptentscheidung |
| Vorgeschlagenes `number|null` | `n_on_alm_or_community_pasture_kg=null` | `minus`-Fehler, Hauptentscheidung |
| Vorgeschlagenes `number|null` | `new_area_additions_ha=null` | `minus`-Fehler, Hauptentscheidung |
| Vorgeschlagenes `number|null` | `other_area_payments_eur_per_ha=null` | `minus`-Fehler, Hauptentscheidung |
| Vorgeschlagenes `number|null` | `previous_year_committed_area_ha=null` | `mul`-Fehler im getrennten Toleranzhelfer |
| Außerhalb `number|null` | Beide N-Eingänge jeweils `false` | Zwei `minus`-Fehler; getrennte Typstressfälle |
| Außerhalb bestehendem Datumsarray | `cutting_dates=null` | `count`-Fehler; App kann diesen unbekannten Zustand tatsächlich erzeugen |

Die fünf ersten Fehler unterscheiden sich damit von o6_1c: Hier sind die `null`-Werte ausdrücklich erlaubt. Vom fehlenden Eingabefeld unterscheiden sie sich ebenfalls: `object.get` verwendet den Default nur bei Abwesenheit.

Ein fehlender Brutto-N-Eingang wird zu 0 und bei bekanntem Almabzug sogar zu einem negativen Nettoanfall; ein fehlender Almabzug wird zu 0. Das ist kein gemessener N-Wert. Fehlende bzw. `null`-Ernteanteile lassen die 85-%-Prüfung aus. Ohne Mahd kann unbekannte Beweidung die Fläche prämienfähig belassen. Bei bekannten Schnittdaten setzt fehlender Abtransport dessen Erfüllung voraus. Die entsprechenden Sollanforderungen verlangen einen positiven Nachweis; sie behaupten keine tatsächliche unterlassene Mahd, Beweidung oder Ernte.

Fehlende bzw. `null`-Antragsdaten und Vertragsbeginn sperren diesmal die native Vertragsfreigabe. Ein fehlendes `payment_application_submitted` wird dagegen `true`: Im definierten gemischten Kontrollbetrieb bleiben 648 Euro ausgegeben. Ein tatsächlich `false` gemeldeter Zahlungsantrag sperrt die Auszahlung.

Die 2025-Flächenbasis zeigt eine weitere Defaultgrenze. Bei 10 ha echtem Flächenzugang und belegten 0 ha Basis liefert der Helfer 5 ha Überschuss. Fehlt die Basis oder ist sie `null`, bleibt `allowed_area_increase_ha` undefiniert; der `else := 0`-Zweig setzt den Überschuss trotzdem auf 0. Die Unbekannt-Probes verlangen hier eine offene Diagnose anstelle einer positiven numerischen Behauptung. Sie setzen keine erfundene tatsächliche Basisfläche oder konkrete Quellenprämie an.

Für bekannte flächige PSM-Anwendung sowie bekannte externe Biogasrücknahme wird der Ausnahmenachweis bereits positiv verlangt: fehlend/`null`/`false` gibt die Ausnahme nicht frei. Unbekannte Anwendungsarten greifen jedoch in keine Tabellenzeile. Ein verwendeter PSMBIO-Code wird hier weder als Ersatz für einen Wirkstoffnachweis behandelt noch aus seinem Namen auf Zulässigkeit geschlossen.

## Aktuelle App-Projektion

`adapt_payload_for_measures` wurde auf App-Commit `529eadb34c4fdd249fbf739a372d63185b7374a2` tatsächlich ausgeführt. Der synthetische Input enthält alle 26 vorgeschlagenen Pfade. `CursorWrapper.execute` wurde so gesperrt, dass jeder SQL-Aufruf unmittelbar fehlschlägt; es gab keinen Datenbankaufruf. Input, Output, Codehashes und Pfadabgleich sind im JSON enthalten.

Nach der Projektion verbleiben **0 von 26** neuen nativen Vorschlagspfaden und **10 von 14** vorhandenen nativen Pfaden. Entfernt werden auch:

- `farm.region.federal_state` und `farm.region.district`
- `land.parcels[].crop.crop_name` und `.crop_category`

Der Kulturname erscheint als flaches `raw_label`, das der historische o6_2-Code nicht als Kulturpfad liest. Tierart und Tierzahl bleiben erhalten, die neue RGVE-ID, Herkunft und Bestandsmethode dagegen nicht. `farm.oepul` und `livestock.nitrogen` fehlen vollständig. Vorhandene PSM-/Mineral-N-/Schnittwerte allein stellen weder Stofflisten, Zeitperioden noch die erforderlichen positiven Nachweise her. Eine Freigabe von Pfadaliasen wird aus dieser Diagnose nicht abgeleitet.

## Interpretation und Grenzen

Die 54 Probes sind einzeln eingeteilt: 13 bekannte Quellenkomponenten, 19 gewünschte Anforderungen an positive Nachweise, zwölf Eingabe-/Diagnoserobustheitsfälle und zehn ausdrücklich außerhalb des vorgeschlagenen oder bestehenden Schemas liegende Stressfälle. Diese Einteilung gilt pro Fall; gleiche Feldnamen ersetzen keine gemeinsame fachliche Bedeutung.

Native Rego-Prädikate können bei Nichterfüllung undefiniert sein. Das ist von einem fachlichen Boolean `false` und vom Fehlen der gesamten `decision` zu unterscheiden. Boolesche Quellenurteile werden in diesem Teil an expliziten Entscheidungsfeldern bzw. eindeutig klassifizierten Komponenten beurteilt. `status_equals` prüft Laufzeit-/Diagnoseverfügbarkeit oder eine ausdrücklich gewünschte Unbekannt-Behandlung; eine Quelle schreibt keinen OPA-Ausgabestatus vor.

Der Kernbeitrag enthält separat `O62-CORE-arable-without-fodder-output`: Ohne Futterfläche ist `stocking_density_rgve_per_ha` undefiniert, und `object.get({"v": stocking_density_rgve_per_ha}, "v", null)` kann den fehlenden inneren Wert nicht abfangen. Dieser Fall wird unter den hiesigen 54 Probes nicht erneut gezählt. Die fokussierten Eingabeprobes verwenden definierte gemischte bzw. Grünlandkontrollen, damit dieser Ausgabefehler ihre jeweiligen Ziele nicht verdeckt.

Alle Läufe verwenden die unveränderte, per Repository-Prüfsumme gebundene OPA 1.18.2, `--strict-builtin-errors`, zehn Sekunden Evaluationslimit und deaktivierte Netzwerk-/Zufalls-/Jetztzeit-Builtins. Geladen werden die historischen Verzeichnisse `workspace/policy` und `workspace/data`; kein flach umgebautes Datenobjekt. Bekannte separate numerische Pin-/Laufzeitprobleme bleiben von diesen Eingabebefunden getrennt. Weder Laufzeitverhalten noch Modell-Selbsttests erzeugen Quellenwahrheit. Die Fälle sind öffentlich und können sich diagnostisch mit anderen Auditbeiträgen überschneiden; aus ihnen entsteht kein privater Referenzsatz.
