# o6_2: Entität, Einheit, Zeitbezug und tatsächliche App-Pfade

Diese Tabelle indexiert die 128 Blätter, ersetzt keine fachliche Aufnahme.
Alle vorher/nachher-Werte bleiben im vollständigen Diff; `leaf-review.json`
ordnet jeden Blattpfad zu. Ein Helper-Zugriff ist noch kein vollständiger
Nachweis der Wirkung im App-Ergebnisvertrag.

| Gruppe / Blätter | Luna | Opus | App und offene Zuordnung |
| --- | --- | --- | --- |
| `participation` / 30 | `program.o6_2`, `program.o6_1a/o6_1b`, `farm.measures[]` | `farm.oepul.o6_2`, `participating_measures[]`, Antragsteller, BIO-Kulturbereich, Kontrolle/Übernahme | App-Auswahl ersetzt keinen Antrag. Adapter übernimmt weder `program` noch `farm.oepul`/`farm.measures`. Luna liest `program`, seine parallele Maßnahmenliste nicht. Opus nutzt amtliche Nummern `1A/1B/2` statt App-IDs. Vertragseinstieg, aktuelles Jahr und Erst-ÖPUL-Jahr trennen; BIO-Teilbetrieb ist kein Schlag-Kulturbereich. MB S. 1–2, 5. |
| `year_region` / 16 | Root `year`, `application_year`, `region.*`, Schlag-Dürreflags | `farm.year`, Schlag-Bundesland/-Bezirk mit `farm.region`-Fallback | Luna liest `application_year` und Root-Region, Root-`year` nicht. App übernimmt nur `farm.year` und `farm.region.is_protected_area`, keine Gebietskulisse/Dürredetails. Ein gemeinsamer Kontext benötigt as_of, Quellenfassung und Nachweise je Schlag. Notices 05./12.08.2026. |
| `livestock_basis` / 6 | `farm.forage_area_ha`, vorgeschlagener `category_code`, vorhandene `category/animal_count` | `rgve_key_id`, `held_in_austria`, vorgeschlagene `count_method` | Luna liest `category`, nicht `category_code`; Opus liest `count_method` nicht. App kopiert species_groups, konsumiert in o6_2 aber keinen Tierbestand. RGVE-Kohorten können nach Scopeprüfung wiederverwendet werden. Futterfläche aus beantragtem Hauptkultur-Grünland/Ackerfutter einschließlich NAT/Bergmähdern; Zweitkultur ausnehmen. MB S. 2, 6–7; Anhang A. |
| `nitrogen_balance` / 4 | fertiger `farm.compliance.livestock_n_kg_per_ha` | absolute kg nach Stall/Lager minus Alm-/Gemeinschaftsweide-N, geteilt durch Flächensumme | App `land.aggregate.nitrogen_input_kg_per_ha` ist N-Einsatz, kein nachgewiesener Tierhaltungsanfall. kg pro Kalenderjahr, ha österreichische LN und kg/ha unterscheiden; keine Abnahmeverträge verrechnen. Opus setzt fehlende Mengen auf 0. MB S. 3. |
| `fertilization` / 6 | externes N-Aggregat und `operations.fertilizer.source` | Liste `operations.fertilizer.inputs[]` mit Produkt, Herkunft, N, Rücknahme | App-Parzellen behalten N-Aggregate, verlieren neue Inputliste und Herkunft. Luna prüft externes N==0; erlaubte externe Wirtschaftsdünger benötigen eigene Klassifikation. Produktliste, Zulassung, Menge und Zeitraum belegen; Biogas-Rücknahme-Boolean beweist keine entsprechende Menge. MB S. 2–3. |
| `psm` / 7 | `bio_allowed`, `individual_plant_treatment`, `broad_application`, `seed_treatment` | `application_mode`, `organic_approved_only`, Produktname | App konsumiert in o6_2 nur `operations.psm_used`; die vorhandene shared-PSM-Collection wird hier nicht gelesen. Luna liest `broad_application` nicht und kann negative Parcels aus der Comprehension verlieren. BIO-Wirkstoffzulassung, Beizung, Haupt-/Zweitkultur und Codierungsjahr nicht auf ein Boolean reduzieren. MB S. 3–4. |
| `supply_inventory` / 15 | `farm.input_inventory[]`, globaler Dokumentationsflag | `farm.oepul.operating_supplies[]` mit Kauf/Lagerung/Herkunft/anderen Kulturen | Luna liest die Inventarblätter nicht; ein Dokumentationsflag ersetzt die verbotenen Käufe/Lagerungen nicht. App transportiert keine dieser Listen. Aufnahme benötigt datierte Produktmengen, Herkunft und belegte Ausnahme für andere Kulturen. MB S. 4. |
| `training` / 15 | aggregierte Stunden, Anbieter, Datum, Doppelzählung, Ausscheidedatum, BIO-/UBB-Stunden | `farm.oepul.trainings[]` mit Teilnehmerrolle, Datum, Thema und Anrechnung | App transportiert keine Schulungsliste. Luna liest Ausscheiden und biodiversity_hours nicht; Opus fasst Kurse zusammen, prüft ohne Datenstichtag schon 2025. Individuelle Kurs-/Personen-/Betriebsbelege wiederverwenden, o6_2 und UBB-Anrechnung getrennt. MB S. 4–5. |
| `payment_history` / 12 | Zahlungsbestandteile, Vorjahres-/aktuelle Maßnahmenfläche, Zahlungen pro ha | Sanktionsstufe, Vorjahres-/2025-Basis, Zugang/Abgang, andere Zahlungen | App hat keinen o6_2-Zahlungsvertrag. Mehrjähriger Flächenverlauf nicht aus current-year-Schlägen erfinden; behördliche Sanktionsstufe ist keine vom Tool aus einem Verstoß abgeleitete Zahl. Modulation anteilig; Zugangskürzungszuordnung bei Opus unbestätigt. MB S. 6; ATB S. 14–19. |
| `land_scope` / 17 | Einzelcode, Zweitkultur, Pflanzgutqualität, Ernteausfall | Code-/Maßnahmenlisten, Hauptkultur, GA/NPF, Nationalpark, Mahd/Beweidung/Ernte und Weitergabe | Laufende Verpflichtung gilt auch für nicht prämienfähige Kulturen; Prämienfläche ist eine andere Menge. `parcels[0]` reicht nicht für einen gesamtbetrieblichen Nachweis. Feldstück-/Schlag-IDs, Haupt-/Zweitkultur und zeitlich gültige amtliche Codes bestätigen; OPUBB/OPBIO nicht pauschal als OP behandeln. MB S. 2–6. |

## App-Schnittstelle

o6_2 liest drei Platzhalter: Schlag-`operations.psm_used`,
`land.aggregate.nitrogen_input_kg_per_ha` und
`documentation.nutrient_balance_complete`. Die Policy verwendet den gemeinsamen
Category-C-Helper und liefert auch bei vorhandenen Werten `missing_data` mit
`category_c_conservative_missing_data`. Zwei Scalar-Registryfelder und ein
Wildcard-PSM-Pfad ergeben keine vollständige Förderprüfung.

Raw-AMA-Aggregat kann als Fallback für den N-Einsatz transportiert werden;
das ist kein fachlicher Alias für Tierhaltungs-N nach Verlusten. Neue Run-Felder
werden vom aktuellen Adapter überwiegend verworfen. App-Wrapper
`{measure_id,payload}` und DecisionTrace-Ergebnisvertrag müssen separat umgesetzt
werden; beide historischen Policies erwarten ungekapselten Input.
