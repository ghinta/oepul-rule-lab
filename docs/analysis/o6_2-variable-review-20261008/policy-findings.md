# o6_2: technische Beobachtungen vor Integration

13 synthetische Proben, unveränderte historische Policies und die gepinnte
App-Policy. Vollständige Inputs/Queries/Ausgaben in `policy-probes.json`.
Keine Golden-Sollwerte und keine fachliche Gesamtwertung der Modelle.

| Proben | Reproduziertes Ergebnis | Konsequenz für die Aufnahmeprüfung |
| --- | --- | --- |
| `LUNA_FORBIDDEN_PSM` | `all_psm_ok:true` trotz ausdrücklich nicht BIO-zulässiger, nicht einzelpflanzenbezogener Anwendung auf Grünland | Die Comprehension sammelt nur definierte erfolgreiche `parcel_psm_ok`; negative/undefinierte Einträge fehlen. Zusätzlich Default true. Vollständigkeits-/Verletzungsnachweis erforderlich. |
| `LUNA_PIG_GVE_AS_RGVE`, `OPUS_PIGS_EXCLUDED` | Eine Zuchtsau liefert bei Luna 0,5 RGVE und Tierhalterstufe, bei Opus 0 RGVE / nicht-tierhaltend | MB S. 2/7 und Anhang A trennen raufutterverzehrende Tiere von Schweine-GVE. Tabellenwerte benötigen den richtigen Mengen-/Tierartvertrag. |
| `LUNA_MODULATION_220`, `OPUS_MODULATION_220` | Luna 0,9; Opus 0,990909… | ATB S. 19 nennt 220-ha-Beispiel 99,09 %. Luna verwendet den marginalen Stufensatz für die gesamte Fläche. |
| `OPUS_N_MISSING` | Fehlende Tierhaltungs-N-Daten ergeben `n_per_ha:0` | Positive Aussage ohne Kalenderjahres-/Mengen-/Flächennachweis vermeiden; unknown ist nicht null N. |
| `OPUS_TRAINING_BEFORE_DEADLINE` | Datenstand 01.06.2025 erzeugt bereits TRAIN-001-Verstoß | Jahreszahl allein belegt Fälligkeit nicht. Zusätzlich enthält die Meldung `%!f(int=0)` statt einer formatierten Zahl. |
| `OPUS_BIO_SEED_TREATMENT` | BIO-zulässige Beizung erzeugt kein verbotenes-Anwendungs-Prädikat | Offene Auslegung gegenüber „Beizung … daher nicht zulässig“; keine Fachantwort angenommen. |
| `LUNA_SECOND_CROP_RATE`, `OPUS_SECOND_CROP_RATE` | Klee als Zweitkultur: Luna 75,6 €/ha, Opus 64,8 €/ha | Luna liest das vorgeschlagene Zweitkulturfeld nicht. MB S. 6 ordnet Zweitkultur der Ackerprämie und nicht der Futterfläche zu. |
| `OPUS_PSM_CODE_2025`, `OPUS_PSM_CODE_2026` | Fehlendes PSMBIO wird 2025 als Verstoß gemeldet, 2026 nicht | Technisch belegte Jahresunterscheidung; App-Quellenstand und neue fachliche Codierungsfreiheit getrennt von Anwendungserlaubnis behandeln. |
| `APP_COMPLETE_PLACEHOLDERS` | Vollständig gefüllte Platzhalter ergeben `missing_data`, keine fehlenden Keys, Grund `category_c_conservative_missing_data` | App hat keine vollständige o6_2-Regel. Ein ausgefüllter Fragebogen allein ändert diese Grenze nicht. |

Weitere Codebefunde: Luna prüft Fläche/BIO-Ausnahme/Pflanzgut/Dürre/Prämiencap
mehrfach nur anhand `parcels[0]`. Nicht BIO-Teilbetrieb als Ganzes, sondern Kultur
des ersten Schlags steuert eine Kombinationsausnahme. Opus setzt unter anderem
österreichische Lage/Tierhaltung, Antragsteller und Zahlungsantrag positiv vor;
fehlender Erst-ÖPUL-Jahrgang umgeht die Mindestgrößenprüfung. Verletzungen und
behördliche Sanktion werden getrennt ausgegeben; daraus folgt kein automatisch
feststehender Auszahlungsanspruch. Durchschnittliche Zugangskürzung und
BIO-Beizung bleiben unbestätigte Modellannahmen.
