# Vorher/nachher und Evidenzverträge

App-Pin5296108f5756ef1463c25a49d93d4a346e9b5e9c; ReferenzApp#1318d3e44a10c2f225ea89c72249d6df3c23b6cc093.
Runs v2-o6_16-luna-high-20261005 / v2-o6_16-opus-5.5-high-20261002.
[Alle172Blätter mit vorher/nachher](leaf-review.json), [gepinnter Gesamtdiff](../all-measure-variable-review-20261008/o6_16/variable-diff.json).
Jedes Blatt bleibt not_approved / open_before_app_admission.

| Sachgruppe / Blätter | Bisher → Luna / Opus | Nötiger, noch offener Evidenzvertrag |
| --- | --- | --- |
| Vertrag/Person/Kombination/Zahlung24 | allgemeine farm/preferences → measure.* / farm.oepul.o6_16 + participating_measures | bestätigte aktuelle Verträge/Anträge/Ausstieg, Erstjahr, aktive Person und getrennte Optionen |
| AG-Historie/Geometrie/Pflege24 | fehlend → washout-Flags / leaching_option+AG-Code | lagegenaue Erstdeklaration/Übernahme, Ackerzahl, Mischung/Altbestand, echte Inputs/Pflege, GLÖZ-/2020-Teilflächen |
| PSM/OÖ-Ereignisse/Register21 | nitrogen-/PSM-Aggregate → freie Wirkstoffe/OÖFlags / datierte Anwendungen+Bentazon/Fonds | Produkt-ID/Version/Zulassung, Kultur, tatsächlicher Schlag/Datum, N-Menge/Verluste/Sperrfenster/IPM/Mittel |
| Schweine/Jahr/Dichte/Ration21 | species_groups/gve/category → pig_gve_average/feed_categories / GVE-Kategorie+feeding | tatsächlicher Jahresdurchschnitt/gesamter Acker, alle Rationen/Gewichtsphasen/88%TM/Rezept/Technik und o6_9-Vertrag |
| N-Kulturkette/Daten18 | nitrogen_input_kg_per_ha → surplus/following-flags / previous_crop+n_management | vollständige zeitliche Kulturkette, Bedarf/Ernte/Entzug/Vorfrucht/Inputs, Zonen/Schwellen und einzelne Faktorwendung |
| Kurs/Person/Konzept14 | fehlend → education-Flags / training_courses+concept_date | Kurs-/Person-ID, Anbieter, datierter aktueller Nachweis, echte Themen/Stunden, Anrechnung/Ersatz, Konzeptversion |
| MFA2026/Probe/Labor14 | fehlend → soil_samples / benannte Probe-/Parameter-/Methoden-/GIS-Objekte | feste MFA2026-Gebietsfläche, einzigartige Probe-ID/Ort, echte Chronologie/akkreditiertes Labor/alle Parameter |
| Datierte Gesamt-/Schlagaufzeichnungen10 | nutrient_balance_complete → completed-Flags / farm_records+field_records | aktuelle Betriebsplanung28.2./Bilanz31.1.Folgejahr, alle relevanten Ereignisse/14-Tage-Verzögerung/Wiegebelege |
| Wien/Projekt/Bearbeitung10 | fehlend → Farmregion/Projektbool / humus_erosion_vienna+Teilflächen | Projekt-ID/Version/Bestätigung, echte vollständige Vertragsbearbeitung/Anforderungen, Wiener Zusatzkurse/Proben |
| Cultan7 | fehlend → equipment/injection/parcel_ids / CUL+fertilizer_applications | tatsächliche Nagelrad-/Ammoniumdepotgabe, Menge/Produkt/Datum/Schlag, Fremdgerätbeleg oder gleichwertige Unterlage |
| GIS/vollständige Schlagfläche6 | AMA-Aggregate → kg_number/in_groundwater/groundwater_ha / cadastral_community_number | amtliche Layer-/MFA-Version, Grenz-/Teilflächenjoin; größte KG aus #133 weiterhin offen |
| Dürre/Ernte3 | fehlend → keine ausreichende Ereignisbindung / harvest.* | echter Schlagbezirk, Kulturzeit/Anbau/Pflege/Dürregrund, datierter rechtlicher Ausnahmebereich |

Luna flache parcels[].id/kg_number/crop_category und measure/options/records sind
keine Aliase von Opus verschachtelten parcel_id/crop/farm.oepul.*. Alte category
string|null wird zum23Klassen-Enum verengt: Art/Kategorie/GVE und tatsächlicher
Jahresbestand separat bestätigen. Kein Enum oder repräsentativer Demo-Wert ist
amtliche tatsächliche Datenquelle. App-Aggregat N und nutrient_balance_complete
können diese Verträge nicht durch Umbenennung erfüllen.
