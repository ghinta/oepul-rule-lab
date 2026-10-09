# Restfragen für Domainexperten und Umsetzung

Die Quellenprüfung begrenzt die folgenden Entscheidungen. Keine bestehende
Frage wird geschlossen oder beantwortet; IDs und Status sind in
[scope-matrix.json](scope-matrix.json) an die ursprünglichen Dossiers gebunden.
Die Fragen gehen in [App-Sammelissue #140](https://github.com/ghinta/oepul-recommender/issues/140).

## 1. Identität, Kategorie und vollständiger Bestand

- Welche konkreten Register-/Tierlisten-/Gruppenbelege bestätigen Kategorie,
  Zeitraum und Vollständigkeit, einschließlich unterjährigem Betriebswechsel?
  Wo reicht eine dokumentierte Gruppe oder ein Aggregat, wo ist die einzelne
  Kennung für die Entscheidung erforderlich? Keine allgemeine Schweine-
  Ohrmarkenpflicht voraussetzen.
- Wie sind belegte Teilgruppen disjunkt und vollständig, auch ohne amtliche
  Einzel-ID-Liste? Welcher tatsächliche Bestand/Zeitraum wird von einer
  Betreiber-/Expertenkorrektur ersetzt? Die Korrektur gilt vor AMA; deren
  Abweichung ist kein eigenständiger Ablehnungsgrund.
- Welche vollständigen Art-/Alters-/Rassen-/Größenklassen und datierten
  Faktorversionen gelten je Maßnahme? Unklare 32/50/85/500 kg-Grenzen nicht aus
  ähnlichen Feldnamen oder aus einer anderen Tabelle übernehmen.

Bestehende IDs: `o6_1b-RGVE_STOCK_BASIS`, `o6_2-RGVE_FODDER_BASIS`,
`o6_3-RGVE_COHORTS_AND_FIRST_YEAR`, `GROUP_IDENTITY`, `COUNT_BASIS`,
`o6_9-ANNUAL_PIG_GVE_CATTLE_DATABASE_AND_CATEGORIES`,
`o6_20-FULL_CURRENT_REGISTER_STRUCTURE_CHANGE_AND_UNIQUE_TIERS`,
`o6_21-FOUR_CATEGORY_ENUMS_REAL_SEX_AGE_AND_UNIQUE_TIERS`,
`o6_22-THREE_CATEGORIES_TEN_TIERLIST_ROWS_ALIASES_AND_BOUNDARIES`.

## 2. Unterjähriger Belegstand und Jahresabschluss

Welche bestätigte Abdeckung, Kategorie und Methode liefert ein Bestand heute?
Was kann bereits abschließend festgestellt werden, was bleibt eine laufende
Jahrespflicht? Der heutige o6_3-Vertrag verlangt01.01.–as_of; er ist nicht ohne
Fachentscheidung die Jahres-/214 Tage-/Kalenderbasis anderer Maßnahmen.
Wie werden veraltende Tagesbelege aktualisiert und sichtbar gehalten, ohne
fehlende spätere Tage als Null oder eine Zukunftsprognose als Tatsache zu setzen?
Welche damaligen Belege bestätigen das konkrete Vertrags-Erstjahr?

Bestehende IDs: `ANNUAL_EVIDENCE`, `o6_3-RGVE_COHORTS_AND_FIRST_YEAR`,
`o6_3-GREEN_FEEDING_METHOD_AND_HISTORY`, `GREEN_FEEDING_HISTORY`,
`o6_20-ACTUAL_RGVE214_FULL_ANIMALS_NO_FREE_OVERRIDE`,
`o6_21-CURRENT_YEAR_REGISTER_SOURCE_SNAPSHOT_AND_ASOF`,
`o6_22-CURRENT_SNAPSHOT_YEAR_VIS_AND_COMPLETE_REGISTER`.

## 3. Rassenförderung und Ersatzplätze

Welche reale Kennung, Zuchtfolge, Geburts-/Kategorieinformation und
Bestätigung bindet jedes Tier an seinen Förderplatz? Wie werden komplette
Ersatzketten, Unterbrechungen, Prämienklasse und dokumentierte Zuchteinsätze
nachgewiesen? Die Hinweise 2026 präzisieren das Halteende und die entfallende
Ersatzmeldung nach 31.08.; daraus folgt kein Wegfall weiterer Zuchtnachweise.

Bestehende IDs: `o6_5-INDIVIDUAL_IDENTITY_AND_CATEGORY`,
`o6_5-BREEDING_SEQUENCE_AND_REPLACEMENT_DATE`, `o6_5-COMPLETE_REPLACEMENT_GRAPH`,
`o6_5-DROUGHT_2026_HOLDING_AND_REPORT_SCOPE`.

## 4. Aufenthalte, Weide und Meldungen

Welche echten Belege verbinden Tier/Gruppe mit Heimatbetrieb, Alm und
Weideeinheit sowie Ereignis-/Meldedatum? Wie werden Unterbrechungen,
gleichzeitige/aufeinanderfolgende Aufenthalte und verspätete Meldungen im
jeweiligen Scope angerechnet? Welche Projektparameter/Tagesgrenzen gelten
für NAT-Jahres- gegenüber gleichzeitigem Besatz? Tieraufenthalt, Almbestockung,
Kategorieanwesenheit und Weidetage dürfen nicht dieselbe Union verwenden.
Bei Behirtung sind sämtliche tatsächlich aufgetriebenen Tiere einer Kategorie,
Milch-/Kalbungs-/Herderbelege und Zuordnung getrennt nachzuweisen.

Bestehende IDs: `o6_14-ACTUAL_STAYS_INTERRUPTION_UNION_YEAR_AND_AS_OF`,
`o6_14-ANIMAL_IDS_AGE_JULY1_RGVE_KEY_AND_COUNTS`,
`o6_15-COMPLETE_HERDED_CATEGORY_ALL_REAL_ANIMALS`,
`o6_15-ACTUAL_DATED_TIER_STAYS_ALM_CALENDAR_UNION_AND_AS_OF`,
`o6_15-JULY1_RGVE_MILK_AGE_CALVING_QUANTITY_AND_SPECIES_IDS`,
`o6_15-HERDER_IDS_SINGLE_ALM_BLOCKS_CAPACITY_MILK_ALLOCATION`,
`o6_18-GRAZING_IDS_DATED_UNION_RGVE_VS_GVE_LIMITS_AND_DIARY`,
`o6_18-VISIBLE_GRAZING_UNIT_COMPLETE_ALL_PROJECT_SCOPES`,
`o6_20-CATEGORY_PRESENCE_UNION_VERSUS_EACH_ANIMAL_ACTUAL_GRAZING`,
`o6_20-ALM_TEMPORARY_STAY_DEPARTURE_DELETION_AND_COUNT_REPLACEMENT`.

## 5. Tatsächliche Boxen, Gewichte und Pflichtverletzungen

Welche Box-/Koppel-/Gruppenzuordnungen, Gewichte und verfügbaren Flächen
belegen die Haltung einschließlich nicht geförderter Mitbewohner?
Welche homogenen Gruppennachweise sind zulässig; welche Ausnahmen/Bau-/
Belegungszeiträume gelten konkret? Kein pauschaler Kategorie-Durchschnitt.
Wie werden echter Verkauf, tatsächliche Abmeldung und Pflichtverletzung
getrennt geführt, einschließlich Ganzjahreswirkung oder Durchschnittskorrektur?

Bestehende IDs: `o6_21-ACTUAL_WEIGHT_SPACE_ALL_OCCUPANTS_AND500_BOUNDARY`,
`o6_21-ACTUAL_PER_TIER_REDUCED_RATE_OVERLAP_AND_SOURCE21`,
`o6_22-FULL_YEAR_ALL_CATEGORY_HISTORY_AND_IMMEDIATE_DEREGISTRATION`,
`o6_22-ACTUAL_PEN_ALL_OCCUPANTS_WEIGHT_SPACE_AND_BEDDING`,
`o6_22-UNDocked_CATEGORY_ALL_PARTICIPANTS_FULLYEAR_SCOPE`.

## 6. Produktentscheidung: neue Tierobjekte

Auto-Wertänderungen in einem eigenen dokumentierten Snapshot sind bestätigt,
einschließlich der Werte belegter Tiergruppen. Offen ist nur die Erzeugung
neuer individueller Tieridentitäten und der Umgang mit fehlenden
Einzeltierinventaren. Die Freigabe neuer Flächen entscheidet dies nicht.
Bei späterer Tierneuanlage braucht es sichtbaren Anlegeursprung und
eine klare Unterscheidung zu importierter/amtlich bestätigter Identität.
Diese Produktfrage wird gesammelt; es wird keine Zustimmung angenommen.

## 7. Technische Vorbereitung und Quellenbeschaffung

Keine zusätzliche Fachantwort nötig, um die Ist-Lücken prüfbar vorzubereiten:
Raw-Datenverlust, IDs/Datumsrollen/Herkunft, fachliche Wertebereiche,
current_fact-Editor und Snapshotauswahl. Die spätere Berechnung benötigt die
bestätigten vollständigen Quellen-/Kategorien-/Zeitscopes. Vollständige aktuelle
SRL-/Anhang-Tierabschnitte und reale Betriebs-/Register-Snapshots fehlen noch.
App #133 bleibt mit seinen eigenständigen o6_9/o6_16-Entscheidungen offen.
