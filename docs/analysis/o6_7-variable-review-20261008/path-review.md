# Vorher/nachher – alle Pfade bleiben Aufnahmevorschläge

Das historische Canonical Profile enthält keines der 148 neu vorgeschlagenen
Blätter. [leaf-review.json](leaf-review.json) erhält für jedes Blatt Herkunft,
Vorher/nachher, Vorschlagsreferenzen und offenen Aufnahmezustand ohne Aliasfreigabe.

| Gruppe | Blätter | Vorher → Vorschlag; offene Semantik |
| --- | --- | --- |
| Teilnahme | 32 | Fehlend → Luna `farm.oepul` plus `measure.o6_7`, Opus eigenes o6_7-/participations-Objekt. Root-Überlagerung, aktueller Vertrag, Anträge/Ausstieg und Pflichtcodes entscheiden. |
| Mischung/Saat | 25 | Fehlend → Partner-/Familien-/Winterhärte-/MFA-Kulturbelege; Prozent vs. Verhältnis, Sorten-/Anteilshistorie, frühe/späte/vorvertragliche Mischung unterscheiden. |
| Allgemeines/Prämie | 18 | Fehlend → Fläche/Codes/Lage/Ernte/ES-Zustand. Prämienbasis ist nicht täglicher Deckungsnenner; aktuelle Anerkennung und Rate statt modellinterner Defaults. |
| Chronologie | 18 | Fehlend → Luna Dauer/Tageszahlen/Gap-Aggregate, Opus datierte Abschnitte. Echte Saat-/Ernte-/Umbruchdaten einschließlich Vorjahr, ID/Vollständigkeit und heutige vs. zukünftige Ereignisse nötig. |
| Management | 18 | Fehlend → Pflege/Nutzung/Abtransport/Frost/PSM/Beseitigungsereignisse. Wirkung auf tatsächliches Abschnittsende nicht durch einen bloßen Verstoß ersetzen. |
| Dürre | 14 | Fehlend → globale Luna-Flags bzw. schlag-/segmentbezogene Opus-Gründe. Rechtsfolge/2026/Gebiet/Pflicht/Nachholung separat belegen. |
| Aufzeichnungen/MFA | 10 | Fehlend → Datums-/Ganzjahres-/Ganzflächen-/Saatgutbelege. Fehlende Dokumentation ist nicht true; laufendes Jahr nicht als abgeschlossen behandeln. |
| Tägliche Schlagbasis | 7 | Fehlend → Quote, Hinzunahme/GI, Nutzung, geschützter Anbau. Vollständige MFA-Summe, NAT/EBW/K20 und kausale Spätzugangsregel bestätigen. |
| NAPV/mineralisches N | 6 | Fehlend → datierte Anwendungen plus verbindliches Folgejahres-Verbotsende. Kein Ersatz durch Umbruchdatum oder globale Jahresmenge. |

App-Pfade aus `ama_additional.land.fsl.aggregate.begruenungsflaeche_ha` werden
in `payload.land.aggregate.begruenungsflaeche_ha` übernommen; die App kennt
hier weder täglichen Verlauf noch belastbare Vollständigkeit. Die gebundene
Originalfundstelle des Katalogs ist korrekt zur 85%-Aussage, der Laufzeitproxy
prüft deren gesamte Zeitbedingung jedoch nicht. Exakte App-Code-Pins stehen
in [app-code-evidence.json](app-code-evidence.json).
