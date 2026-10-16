# Einzelprüfung 21/26: Ergebnisorientierte Bewirtschaftung

Run `v2-o6_19-opus-5.5-high-20260927` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. **Quellenprüfung abgeschlossen, Übernahme blockiert.** Root hat selbst gegengeprüft. Eine unabhängige zweite Person, GM-/Domainexpertenfreigabe oder App-Promotion wird nicht behauptet.

Die Sammlung bleibt in [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112), Branch `codex/opus-o6-1a-source-audit` und [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Gemeinsame Lösungen folgen nach allen 26 Einzelprüfungen. Historische Policies, Daten, Quellen, Canonical und App bleiben unverändert.

102/102 Katalogregeln mit 104 Einzelurteilen, 94/94 Vorschläge mit 97 Blättern und 28/28 Tabellenzeiger sind geprüft. 372 öffentliche Entwicklungs-/Technikfälle ergeben 794 typisierte Vergleiche: 748 erfüllt, 46 abweichend. 361 Ausgaben sind definiert, sechs Laufzeitfehler und fünf undefinierte Ausgaben. Die Abweichungen trennen tatsächliche Sachverhalte, gewünschten Positivnachweis, bedingten Caller-Vertrag, Null-/Identitätsprobleme und fünf bewusst schemawidrige Stressfälle. Keine Genauigkeitsquote.

| Prüfteil | Fälle | Vergleiche | erfüllt | abweichend |
|---|---:|---:|---:|---:|
| [core](core.json) | 3 | 69 | 69 | 0 |
| [general](general.json) | 93 | 245 | 212 | 33 |
| [measure](measure.json) | 84 | 168 | 165 | 3 |
| [tables](tables.json) | 115 | 230 | 230 | 0 |
| [inputs](inputs.json) | 77 | 82 | 72 | 10 |

Die vollständigen Positivfälle bestehen 69/69 Vergleiche: 2025/2026 je 2.592 €, mit aktueller Regionaloption 2026 insgesamt 2.862 €. Native Projekt-, Referenz-, Flächen-, Zugangs- und endgültige Ausschlussgates sowie tatsächliche AMA-Sanktionskürzungen funktionieren. Sämtliche 230 Tabellenvergleiche bestehen: 204 Originalpreisfelder, 144 Indikatorvorkommen, 81 Lebensräume sowie die weiteren vollständigen Ziellisten.

Blocker betreffen Geldkomponenten trotz bereits negativer Diagnosen, nicht verbundene anerkannte Rückforderungsbefreiung, falsche Heim-/Alm-Basis, undefiniertes MAIN bei negativem Vertragsbeginn, zwei aktive Nullfelder und die echte App-Projektion. Die positive Geldkomponente allein wird nicht als tatsächliche Freigabe interpretiert. Fehlende Nachweise, kontextspezifischer EBGT17-Text, K20-Sonderfrist und ungeklärte DIV-Quellenvorränge bleiben gesondert sichtbar.

Das Quellenpaket enthält acht Originale. Das neue Merkblatt wurde vollständig auf zehn Seiten, Anhang K auf allen zwölf Seiten 91–102 gelesen; vier Tabellenoriginale zusätzlich visuell. Sieben exakt gleiche allgemeine Originale werden mit früherem vollständigem Lesen und frischen maßgeblichen Abschnitten wiederverwendet. Alle acht Module/1.226 Zeilen, 8.196 Bytes Annahmen, 102 Katalogaussagen, 94 vollständigen Vorschläge und neun Datendateien wurden gelesen. GSP und NAPV wurden nicht bereitgestellt.

| Original | SHA256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf` | `b9e9498435264b70cd3d52ca9e94a36625b66ac16beffbad80e66d19d0d4645b` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle 372 Fälle sind nach den finalen Metadaten vollständig mit unveränderter OPA 1.18.2 (`9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`) ausgeführt und exakt wiederholt. Die ursprünglichen Namespaces `data.oepul_o6_19` und `data.oepul.o6_19` bleiben erhalten. Uhr, Netz, Zufall und Runtime-Auskunft sind gesperrt. Die drei getrennten Helferdiagnosen mit 12/12 erfüllten Vergleichen und der separate App-Aufruf gehören nicht zu den 372 Hauptfällen. [quality.json](quality.json) bindet alle 14 Abschlussartefakte. Die fünf Runs 20–24 und anschließend die gemeinsame Befundmatrix stehen aus.
