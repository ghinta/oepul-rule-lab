# Einzelprüfung 22/26: Tierwohl Weide

Run `v2-o6_20-opus-5.5-high-20260928` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. **Quellenprüfung abgeschlossen, Übernahme blockiert.** Root hat selbst gegengeprüft; keine unabhängige zweite Person, GM-/Domainexpertenfreigabe oder App-Promotion wird behauptet.

Die Sammlung bleibt in [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112), Branch codex/opus-o6-1a-source-audit und [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Historische Policies, Daten, Quellen, Canonical und App bleiben unverändert. Gemeinsame Lösungen folgen nach allen 26 Einzelprüfungen.

97/97 Regeln mit 99 Einzelurteilen, 23/23 Tabellenzeiger und sechs Vorschläge mit 93 Blättern sind geprüft. 262 öffentliche Entwicklungs-/Technikfälle ergeben 613 typisierte Vergleiche: 570 erfüllt, 43 abweichend. 257 Ausgaben sind definiert, drei Laufzeitfehler und zwei undefinierte Ausgaben. 19 abweichende Positivnachweise sind von bekannten tatsächlichen Sachverhalten, bedingten Caller-Verträgen, technischer Doppelrepräsentation und außerhalb der Form liegendem Stress getrennt. Keine Genauigkeitsquote.

| Prüfteil | Fälle | Vergleiche | erfüllt | abweichend |
|---|---:|---:|---:|---:|
| [core](core.json) | 3 | 12 | 12 | 0 |
| [general](general.json) | 69 | 260 | 232 | 28 |
| [measure](measure.json) | 62 | 148 | 146 | 2 |
| [tables](tables.json) | 56 | 112 | 112 | 0 |
| [inputs](inputs.json) | 72 | 81 | 68 | 13 |

Die drei vollständigen Positivfälle bestehen zwölf Vergleiche einschließlich der gesamten MAIN-Objekte: 80–120 € bei 120 Tagen, 112–168 € mit 150-Tage-Option. Alle 112 Tabellenvergleiche bestehen. Tatsächliche Kontroll-, Zugangs-, Mindestteilnahme-, Abmelde- und AMA-Kürzungsgates funktionieren. Die vier Original-Tagebeispiele 205/182/138/104 stimmen.

Blocker sind fehlende Verbindungen von no_premium-Diagnosen und Geld, falsche Heim-/Alm-Basis, Vertragsstatus trotz endgültigem Ausschluss, verschwindende Tageszeitdiagnose bei Dürre, ein aktives nullable Geburts-Stalltagefeld, Doppelrepräsentationen und fehlende App-Abbildung von 92 Ergänzungsblättern. Positive Betragskomponenten allein werden nicht als reale Förderfreigabe ausgegeben. Halbierung bei gekoppelter Stützung und netto/brutto Geburts-Stalltage bleiben offene Auslegungen.

Quellenpaket: acht Originale, neues Merkblatt vollständig 15 Seiten; sieben exakt gleiche allgemeine Originale mit früherer vollständiger Lesedokumentation und frischen maßgeblichen Abschnitten wiederverwendet. Alle zehn Module/1.270 Zeilen, 6.428 Bytes Annahmen, 97 Katalogaussagen, sechs vollständige Vorschläge und fünf Datendateien wurden gelesen. GSP und NAPV gehören diesem Paket nicht an.

| Original | SHA256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `o6_20_tierwohl_weide_2025_10.pdf` | `05333469ebd18f45f83be795e807fe0a0deda1c4585054109394c63789b09f9e` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle 262 Fälle sind nach finalen Metadaten vollständig mit unveränderter OPA 1.18.2 (`9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`) ausgeführt und exakt wiederholt. Ursprüngliche Namespaces data.o6_20 und data.oepul.o6_20 bleiben erhalten; Uhr, Netz, Zufall und Runtime-Auskunft sind gesperrt. Die separate App-Projektion zählt nicht als zusätzlicher Quellenfall. [quality.json](quality.json) bindet 14 Abschlussartefakte. Die vier Einzelprüfungen 21–24 und die gemeinsame Befundmatrix stehen aus.
