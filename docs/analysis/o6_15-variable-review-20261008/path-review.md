# Vorher/nachher und Evidenzverträge

App-Pin 5296108f5756ef1463c25a49d93d4a346e9b5e9c; Lab-Basis 7a296d28cb5b92e2758c5a3889c929ea1db60fe5.
Runs v2-o6_15-luna-high-20261004 / v2-o6_15-opus-5.5-high-20260926.
[153 vollständige Blätter vorher/nachher](leaf-review.json), [gepinnter Inventardiff](../all-measure-variable-review-20261008/o6_15/variable-diff.json).
Jedes Blatt bleibt not_approved / open_before_app_admission.

| Gruppe / Blätter | Bisher → neue Verträge | Offener Evidenzvertrag |
| --- | --- | --- |
| Vertrag/Person/Zahlung 34 | allgemeine farm/preferences → Luna dokumentations-/Teilnahmefelder; Opus oepul_participation und Antrag-/Ausstiegs-/Korrekturhistorie | heutige Jahresentscheidung, bestätigte o6_14-Teilnahme, jährliches 3-RGVE-Minimum, echte MFA/Listen/Antrags-/Übernahmedaten |
| Tier/Kategorie/Aufenthalt/Meldung 30 | species_groups und behirtung_days → Gruppenherding/Bewegungen; Opus alpine_herding.alms[].animals[].stays | vollständige beantragte Tierkategorie, stabile Tier-/Alm-IDs, tatsächliche datierte Aufenthalte/Meldungen und überlappungsfreie Anteile |
| Hund 23 | fehlend → aggregierte Hunde/Flags; Opus IDs/Alm-Zuordnung/Zertifikat/Versicherung | echtes gültiges Zertifikat und Versicherung, Listen-/Zuschlagsvertrag, ganzer Zeitraum auf einer Alm, höchstens fünf |
| Alm/GIS/Bestoßung 20 | alpine_pasture_area_ha → Parzellen-/Almaggregate bzw. alms | Geometrie/Almdefinition, Inlands-/Heimbetriebsbezug, getrennte Almkalenderunion, vollständige Besatzbasis aus o6_14 |
| Betreuung/Unterkunft 18 | fehlend → land.parcels Betreuung; Opus acht Alm-Betreuungsgates | tatsächlich tägliche Pflege/Wasser/Behandlung/Sicherung/Weidelenkung; geeignete Unterkunft, Nächtigung nicht pauschal Pflicht |
| RGVE/Milch 13 | GVE frei → Gruppen-gve/milking; Opus Tierklasse/Geburt/Abkalbung/Milchtage | 1.-Juli-Kategorie, Einzeltierzahl, 45 Milchtage, korrekte zeitgerechte Milchkennzeichen; keine freie fremde Kategorie |
| Ausnahme/Status/Sanktion 8 | unverbundene Flags → Bedingungen/Behörden-/Kontroll-/Sanktionshelper | tatsächliche Entscheidung mit Pflicht/Zeitraum/Alm; unbekannt getrennt von Verstoß und theoretischem Betrag |
| Hirte/Kapazität 7 | fehlend → Person-/Kapazitätsangaben; Opus Hirten-IDs pro Alm | reale Listenperson nur eine Alm, 50-RGVE-Kapazität und erhöhte 20er-Blöcke; keine lexikalische Ersatzentscheidung |

Die App liest nur Almfläche und behirtung_days und führt Category C als missing_data.
Tier-, Alm-, Personen-, Hunde- und Meldeereignisse entstehen nicht durch Pfadumbenennung.
Luna package opul.o6_15 ist zudem nicht die gemeinsame oepul-Namespace.
Keine Aliasfreigabe zwischen den drei Eingabeverträgen.
