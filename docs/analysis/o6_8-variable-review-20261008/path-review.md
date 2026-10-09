# Vorher/nachher und offene Pfadentscheidungen

Alle 139 Vorschlagsblätter sind im Canonical Profile zuvor fehlend.
[leaf-review.json](leaf-review.json) erhält je Modell den vollständigen
Vorher-/Nachher-Bezug und Vorschlags-/Quellverweise mit offener Aufnahme.

| Gruppe | Blätter | Vorschlag und erforderliche Abgrenzung |
| --- | --- | --- |
| Vertrag/Allgemeines | 26 | Luna `farm.oepul.measure_applications`, Opus `participating_measures/o6_8/applicant`; echte Bewilligungs-/Antrags-/Ausstiegs-/Zahlungshistorie mit Host-Jahr und Snapshot. |
| BAW-Historie/Eingriffe | 24 | Fehlend → Anlage-/Erstdeklarations-/Altbestand-/Übernahme-/Umbruch-/Pflege-/Dünger-/PSM-Zustände. Tatsächlich datierte Erfüllung statt Jahresbools/Defaults; Zukunft getrennt. |
| Bearbeitung/Vorbegrünung | 22 | Fehlend → MS/DS/Strip-Till-Methode, Mulch/Streifen/Schlitz/Erhalt, erste Bearbeitung/Folgesaat und historische Vorbegrünung. Vier Wochen, negative Intervalle und Wechseljahr explizit. |
| Untersaat | 22 | Fehlend → Saat-/Hauptkultur-/Ernteereignisse, Partner-/Saatgutbelege, volle/fehlende Deckung, Erhalt/Verwertung/Herbizid/Bearbeitung. Winterackerbohne hat eigenen offenen Fristbezug. |
| BAW-GIS/Teilfläche | 16 | Fehlend → KG/Pfad-ha/Anteil, DIV/GLÖZ/2020-Grünland-/Lagebelege. Historische KG-Tabelle nicht GIS-Geometrie; Mindestteilnahme, Quote und Auszahlung unterschiedliche Flächen. |
| Codes/Kultur/Prämie | 13 | Fehlend → Codes/Lage/Kultur/Kombinationen/OP/weitere Zahlungen. Luna vorgeschlagene Codeobjekte passen nicht zu konsumierten Strings. Code-/Kulturnormalisierung nur bestätigt. |
| Kartoffelanhäufungen | 9 | Fehlend → Abstände/Erzeugung/Krautminderung/Erhalt/Erneuerung/4.-Reihe-Ausnahme. Zeitpunkt/Nachweis statt fehlend=true. |
| Dürre/Ernte | 7 | Fehlend → Anteil, Gebiet, Kultur-Erntezeitraum, Dürregrund/Antrag/Anerkennung. Nicht mit US-Deckungsfreistellung oder beliebiger höherer Gewalt gleichsetzen. |

Luna und Opus haben andere Root-/Maßnahmecode-/Anteilsnotationen: beispielsweise
Leguminosenverhältnis vs. Prozent, `erosion.*` vs. `oepul_o6_8.baw.*`.
Ähnliche Namen belegen weder Einheit noch Zeitraum oder konsumierten Input.

Die App projiziert aggregierte Bodenbedeckung, Bearbeitungsart und Geräteverfügbarkeit
sowie einzelne Schlag-Hangwerte. Fehlende Hangneigung ist im DecisionTrace korrekt
als technische Einschränkung gekennzeichnet; sie ist keine normative Pflicht dieser
Maßnahme. Verfügbare Geräte/Bodenbedeckung genügen aktuell für eligible, ohne
konkreten verfahrens-/jahresbezogenen Beleg. App-Code-/Quellpins in
[app-code-evidence.json](app-code-evidence.json).
