# o6_4: vollständiger Blattumfang und fachliche Pfadentscheidung

Alle 89 Vorher/nachher-Werte stehen in `leaf-review.json` und im unveränderten
Vorinventar; diese Tabelle erklärt die sieben Aufnahmegruppen. Kein Blatt erhält
einen fachlichen Alias oder eine App-Freigabe.

| Gruppe / Blätter | Luna | Opus | App / offene Entscheidung |
| --- | --- | --- | --- |
| `geo_identity` / 14 | flache `above_local_settlement_boundary`, `difficult_to_manage`, absolute `elevation_above_1200_area_ha`, Höhenpunkt, Heimbetriebshöhe und parzellenbezogene Alm-Ausnahme | `mountain_meadow.*`, prozentualer Höhenanteil, Heimbetriebshöhe und betriebsweites `is_alpine_farm_operation` | Amtlicher GIS-Layer, identische Schlaggeometrie und lokaler Siedlungs-/Almbeleg nötig. Höhenpunkt ersetzt Fläche nicht. Opus difficult_to_manage fließt nicht in parcel_eligible ein; adjacency ist Hinweis, kein absolutes Ausschlusskriterium. MB S. 2, SRL S. 51. |
| `participation` / 24 | `farm.o6_4` mit eigenem Jahr, Vertrag/Antrag/Umstieg sowie `measure_participation[].measure/participating` | `farm.oepul_participation` mit Bewerber-/Vertrags-/Ausstiegs-/Übernahme-/Umstiegsbelegen und `oepul_measure_participation[].measure_id` | Beide Vertragsstrukturen fehlen in der o6_4-App-Entscheidung. Aktueller Hostkontext und tatsächlicher laufender Vertrag nötig; kein neuer Einstieg 2026. Bewerber-, Vertrags- und aktueller Schlagflächenstatus getrennt. MB S. 1, 3; ATB. |
| `mowing_history` / 11 | `mowing_years[]` mit Jahr, Vollfläche, Verfahren und Abtransport; Mulchflag | `operations.mowing.*`, Vorjahresboolean, zusätzlich bereits vorhandene cutting_dates | Ereignisdatum, Flächenbezug und Abtransport jährlich belegen. Luna zählt nur maximale Mahdzahl; keine mindestens zweijährige Mahd. Opus Vorjahresschnitt genügt unabhängig von Vollfläche/Abtransport; aktueller Jahresabschluss unberücksichtigt. MB S. 2. |
| `grazing` / 4 | jährliche Start-/Endintervalle und Nachweidetyp | einzelne `operations.grazing_dates[]` | Luna liest end_date nicht; vergleicht Vorjahresstart mit aktuellem 16.8. Opus filtert Jahre, belegt aber keine Intervalle/Art. Nachweide erlaubt auch BM0-Jahr; NAT-Dürredatum nicht übertragen. MB S. 2. |
| `substances` / 7 | Anwendungsliste mit material, ursprünglicher Form/Bedarf, Produkt und BIO-Flag | fertilizer.applied_types[] und psm_only_bio_approved_substances | Datum, eigene Herkunft, ursprüngliche Form und Bedarf sowie BIO-Wirkstoffregisterstand fehlen teils. Opus solid_manure-Typ belegt Bedarf nicht; unbekannt ist keine ausdrückliche Nullanwendung. MB S. 2–3. |
| `codes_combination` / 6 | globaler farm.o6_4.code sowie parcel.code; other_measures[].measure_code/component | Schlag-oepul_codes[] und premium_component | Luna Satz aus globalem Code; method und component nicht gelesen. Opus Code/Verfahren nur bei vorhandenem method; positiver Betrag bei fehlendem Verfahren. Punkt-LSE-Ausnahme gegenüber allgemeinem LSE-Enum klären. MB S. 3–4, Anhang L S. 103. |
| `payment_history` / 23 | 2025-/Vorjahres-/Zugangs-/Reduktionsflächen, Conditionality, aktive Bewirtschaftung und Prämienflags | Maßnahmenflächenhistorien, Kürzungen, Nationalpark/Österreich/Nichtförderkategorien, Zahlungen/Übertragung | Theoretischer Satz vs. Betrag vs. bewilligter Anspruch unterscheiden. Keine Maßnahmen-Mindestfläche erfinden, allgemeine Erstteilnahme-LN gesondert. Allgemein-/Flächenhelfer sind nicht vollständig in tatsächliche Ausgabe gebunden. MB S. 2, 4; ATB S. 14–19. |

`app-code-evidence.json` bindet die tatsächlichen App-API-/Adapter-/Policyauszüge
mit vollständigen Dateihashes. App-Policy o6_4_result liest
`payload.land.parcels[].operations.cutting_dates` und
`payload.oepul.shared.parcels[].oepul_codes`; das sind Eingabesignale für die
Category-C-Diagnose und keine vollständige Rohmodellprojektion.
