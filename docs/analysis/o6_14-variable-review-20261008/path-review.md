# Vorher-/Nachher-Verträge o6_14

Lab-Basis 7a296d28cb5b92e2758c5a3889c929ea1db60fe5; App 5296108f5756ef1463c25a49d93d4a346e9b5e9c.
Runs v2-o6_14-luna-high-20261004 / v2-o6_14-opus-5.5-high-20260926.
[Alle 208 Blätter mit vorher/nachher](leaf-review.json) und [vollständiger gepinnter Diff](../all-measure-variable-review-20261008/o6_14/variable-diff.json).
Jedes Blatt bleibt not_approved / open_before_app_admission.

| Gruppe / Blätter | Bisher → Luna → Opus | Evidenzvertrag und offene Entscheidung |
| --- | --- | --- |
| NATA/Projekt/Kurs 38 | keine ausreichende Projektbasis → land.alpine_pastures[].naturschutz.* → alpine_farming.nature_conservation_supplement und alms[].nature_conservation/plots | Landesprojekt-ID, Version, alle Feldstücke, verortete Pflichten, tatsächliche Codes/Anteile, NATA-Datum; Person/Anbieter/Kursbestätigung und Ersatzhistorie. |
| Almweideplan/Kurs 36 | fehlend → per Alm almweideplan → Betriebsoption grazing_plan_supplement plus je-Alm grazing_plan | Jahresvertrag/Erstjahr, Kursdatum/Person, echte Planversion/Jahresprüfung/alle Almen/Teilflächenkommunikation, belegte erhöhte Intensität und gesonderte Listenbeantragung. |
| Tier/RGVE/Aufenthalte 31 | Heimgruppen/GVE/Weideaggregate → livestock.alpine_movements[].gve/alpung_days/dates → alpine_farming.animals[].birth_date/category_id/count/stays[] | Ohrmarke/Tier/Heimbetrieb/Alm, 1.-Juli-Kategorie, Einzeltiere gegenüber Stückgruppen, tatsächliche überlappungsfreie Aufenthalte und Meldebelege; host.as_of statt beliebiger Jahreswerte. |
| Almgeometrie/Besatz 27 | alpine_pasture_area_ha → alpine_pastures[].area_ha/stocking_records → alms[].alm_pasture_area_ha/foreign relief/plots | vollständige GIS-/Futterflächenbasis und Bewirtschaftungseinheit, 60 Tage pro Alm getrennt vom Tier, anteilige RGVE, jährlicher Auslandsnachweis nur Besatzentlastung. |
| Futter/PSM/Düngung 26 | unverbundene Aggregate → feed_practices/alm_inputs → feeding/fertilisation/plant_protection plus Plot-Codes | Produkt-/Wirkstoff-/Registerversion/Datum/Fläche, tatsächliche Herkunft und Verfütterung, Heuwirtschaft-Eigen-/Fremdalm; Mist-/Gülle-/Feststoffscope, Codepflicht endet 2026. |
| Vertrag/Person/Geschichte 22 | preferences/farm → contract_start_year/first_participation_bool → alpine_farming.measure/exit/takeover plus farm.applicant/oepul | bestätigter aktueller mehrjähriger Vertrag bis 2028, Antrag/Übernahme/Almbewirtschafter, erstes ÖPUL-Jahr und erstes Maßnahmenjahr verschieden, Zahlungs-/Ausstiegshistorie. |
| Ausnahme/Status/Sanktion 11 | unzureichend → preferences_constraints.oepul_2026_drought_force_majeure → alpine_farming.circumstance/control/sanction_history | Antrag und behördliche Anerkennung getrennt; datierte Entscheidung je Pflicht/Tier/Alm, theoretischer Betrag vor Kürzung gegenüber heutiger Empfehlung. |
| Antrag/Meldung 10 | fehlend → documentation.oepul_* und oepul_reports Gesamtzahlen → konkrete Listen-/Tieraufenthalts-/NATA-/Meldedaten | tatsächliches MFA/Listenjahr, Eingangsdatum, 7/14-Tage-Gutschrift, Verkauf/Heimbetriebswechsel, Pflicht/zulässige Listenbefreiung und Korrekturstand. |
| Erschließung 7 | fehlend → access_stage → access_level/access_units/alp_days/drive_period_days/comparable | Infrastruktur/Wirtschaftszentrum 50 m, getrennte Teilflächen und aus echten Aufenthalten hergeleitete RGVE-Tage/Zeiträume; Vergleichbarkeit/Rundung/Gleichstand fachlich offen. |

Die App übernimmt land.alpine_pasture_area_ha und species_groups mit gve und
housing.pasture.weide_days_per_year. Die Policies brauchen tatsächliche Alm- und
Tierereignisse. land.alpine_pastures/livestock.alpine_movements und alpine_farming.*
sind nicht als Aliase freigegeben. RGVE, Zeitraum, Tieridentität und Anteil auf jeder
Alm können nicht durch Umbenennen der bisherigen Aggregatfelder erzeugt werden.
