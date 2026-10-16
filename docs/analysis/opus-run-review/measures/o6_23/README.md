# Einzelprüfung 25/26: Natura 2000 und andere Schutzgebiete

Run `v2-o6_23-opus-5.5-high-20260928` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. **Quellenprüfung abgeschlossen; App-Übernahme blockiert.** Root hat selbst gegengeprüft. Keine unabhängige zweite Person, GM-/Domainexpertenabnahme oder Promotion wird behauptet.

Sammlung in [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112), Branch codex/opus-o6-1a-source-audit und [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Historische Regeln, Daten, Quellen, Canonical und App unverändert. Gemeinsame Lösungen nach dem vollständigen Durchgang.

88/88 Regeln mit 90 Einzelurteilen, 20/20 Tabellenzeiger und neun vollständige Vorschläge mit 46 Blättern geprüft. 300 öffentliche Entwicklungs-/Technikfälle ergeben 605 typisierte Vergleiche: 568 erfüllt, 37 abweichend; 293 definiert, fünf Laufzeitfehler, zweimal undefined. Keine Genauigkeitsquote. Jede Abweichung ist in [quality.json](quality.json) klassifiziert.

| Prüfteil | Fälle | Vergleiche | erfüllt | abweichend |
|---|---:|---:|---:|---:|
| [core](core.json) | 3 | 9 | 9 | 0 |
| [general](general.json) | 70 | 161 | 146 | 15 |
| [measure](measure.json) | 54 | 111 | 110 | 1 |
| [tables](tables.json) | 134 | 268 | 266 | 2 |
| [inputs](inputs.json) | 39 | 56 | 37 | 19 |

Alle neun Kernvergleiche und 266/268 Tabellenvergleiche bestehen. Die beiden Tabellenabweichungen sind dieselbe ungenutzte K20-Zeitmetadatenfrage. Normale unbekannte Einstiegsdaten, aktuelle Behördenstufen, Kontrollverweigerung, öffentliche Antragsteller und Kampagne 2029 sperren MAIN korrekt. Verpflichtungsdiagnosen werden gewürdigt.

Konkrete Befunde: fehlende genehmigte Übernahmeroute in MAIN; zu weiter 2028-Helfer für einjährige Maßnahme; qualifizierte alte/neue Ereigniszuordnung; falsche Heim-/Alm-Modulation; qualifizierte Kürzungs-/Cap-Reihenfolge; ein gültiger nullable Abbruch; Metadatenkopie desselben Schlags verdoppelt Betrag; alle neuen App-Eingaben gehen verloren. 18 gewünschte Positivnachweise und drei bedingte Vorschusshelferkontrollen sind separat geführt. Pflichtdiagnose, tatsächliche Behördenentscheidung und rechnerischer Betrag werden nicht als gleichbedeutend ausgegeben.

Alle fünf Module/755 Zeilen, 5.768 Bytes Annahmen, 88 vollständige Katalogeinträge, neun vollständige Vorschläge und drei Datendateien einschließlich aller Tabellen und Fußnoten gelesen. Acht Originale, sieben exakt hashidentisch früher vollständig gelesen; neues Merkblatt vollständig fünf Seiten, relevante allgemeine Abschnitte frisch vollständig gelesen. GSP/NAPV/September-2-Hinweis hier nicht bereitgestellt.

| Original | SHA256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `o6_23_natura2000-landwirtschaft_2025_10.pdf` | `2566d689d9308b78d392c863839a8688c1cc174d6c7efbe597ddc144e078d151` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle 300 Fälle nach finalen Metadaten vollständig geschrieben und exakt wiederholt. OPA 1.18.2 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8` unverändert; ursprüngliche Namespaces erhalten, Netz/Uhr/Zufall/Runtime gesperrt. 14 Abschlussartefakte sind gebunden. Noch eine Einzelprüfung o6_24 und danach die gemeinsame Befundmatrix.
