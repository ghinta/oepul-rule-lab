# Variablendiff und fachliche Aufnahme

| Bereich | Vorher: gepinnte App | Luna-Vorschlag / tatsächlicher Operand | Opus-Vorschlag / tatsächlicher Operand | Aufnahmeentscheidung |
| --- | --- | --- | --- | --- |
| Zugang | Category C: incorporation_time_hours / ammonia_reduction_percent; Draft #131 vier MFA-Mengen + Präsenz | measure + participation.*; keine datierte gültige Vertragskette | oepul_applications[] mit separaten measure/n_reduced_pig_feeding-Komponenten | offen: bestätigter Vertrag, aktueller Snapshot, Fütterungsalternative |
| Ausbringung | keine vollständigen Jahresereignisse | land.parcels[].operations.manure_application.* vorgeschlagen, tatsächlich nur application.* + participation.application_m3 | manure_management.applications[] + declared_volumes.* | offen: Kalenderjahr/Identitäten, tatsächliche Menge gegenüber Deklaration |
| Güllebeschaffenheit | kein Chargennachweis | Regen-/Festmist-/Biogasbooleans | Produktlabels + globale Ausschlussliste; Produktbedingungen unverbunden | offen: Chargen, alle Bedingungen und Ursprungsbelege |
| Separation | Draft #131 separated_cattle_slurry ohne Ereigniskette | operations.separation_event.* neben separation.*; separated_m3 gegenüber separated_liquid_m3 | manure_management.separations[]; phases_separated_mechanically default true | offen: tatsächliche eigene Rindergülle, Datum, mechanischer Nachweis |
| Tierbasis | kein geprüfter jährlicher GVE-/Rinderdatenbankpfad | annual_average_gve-Vorschlag gegenüber pig_feeding.gve_pigs_annual_average / calculation.cattle_gve | gve_annual_average, sonst animal_count/GVE-Key oder gve | offen: Jahresdurchschnitt, Kategorie/Tierart, aktuelle Datenbank |
| Fütterung | Draft #131 projiziert nur Mengen/Präsenz, keine Fütterung | Gruppenfeeding/Rohproteinwerte vorgeschlagen; Rego nutzt nur globale all_pigs_compliant/proof_available | pig_feeding.rations[]; all_pigs_covered ohne Tiere-/Periodenverknüpfung | offen: sämtliche Tiere, Phasen, Rezepturen und 88%-TM-Einheit |
| Flächen/Prämie | keine vollständige Fachberechnung | farm.arable_area_ha vs calculation.arable_area_ha; frei gelieferte N-Bedarfs-/Rinderbasis | gesamte Ackerfläche für Zugang; Parzellen für Prämie; fehlender N-Bedarf gilt true | offen: vollständige Fläche, NAPV, Teil-/Gesamtbasis, theoretischer Betrag |

Alle 134 konkreten Blätter mit Original-vorher/nachher: [leaf-review.json](leaf-review.json).
Die bestehende Rohinventur bleibt unverändert. Gleichartige Wörter bedeuten keine
semantische Gleichheit; kein doppelt vorhandener Mengen-/Tierpfad wird automatisch aliasiert.
Draft #131 ist ein zusätzlicher Vergleich, keine Umstellung des Basiscommits.
