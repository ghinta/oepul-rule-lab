# Einzelprüfung 23/26: Tierwohl Stallhaltung Rinder

Run `v2-o6_21-opus-5.5-high-20261004`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. **Quellenprüfung abgeschlossen; App-Übernahme blockiert.** Root hat selbst gegengeprüft. Keine unabhängige zweite Person, GM-/Domainexpertenabnahme oder Promotion wird behauptet.

Weiterhin eine Sammlung in [Issue 112](https://github.com/ghinta/oepul-rule-lab/issues/112), Branch `codex/opus-o6-1a-source-audit` und [PR 111](https://github.com/ghinta/oepul-rule-lab/pull/111). Historische Regeln, Daten, Quellen, Canonical und App bleiben unverändert. Gemeinsame Lösungen werden erst nach 26 Einzelprüfungen diskutiert.

95/95 Regeln mit 97 Einzelurteilen, 36/36 Tabellenzeiger, neun Vorschläge mit 128 Blättern geprüft. 326 öffentliche Entwicklungs-/Technikfälle: 670 typisierte Vergleiche, 621 erfüllt, 49 abweichend; 310 definierte Ausgaben, 16 Laufzeitfehler. Keine Genauigkeitsquote. Jede Abweichung ist in [quality.json](quality.json) nach echtem Sachverhalt, gewünschtem Positivnachweis, bedingtem Caller-Scope, Identitätskonflikt oder Formstress getrennt.

| Prüfteil | Fälle | Vergleiche | erfüllt | abweichend |
|---|---: |---: |---: |---: |
| [core](core.json) | 3 | 51 | 51 | 0 |
| [general](general.json) | 91 | 204 | 177 | 27 |
| [measure](measure.json) | 85 | 184 | 178 | 6 |
| [tables](tables.json) | 75 | 150 | 150 | 0 |
| [inputs](inputs.json) | 72 | 81 | 65 | 16 |

Alle 51 Kern- und 150 Tabellenvergleiche bestehen. Zwei erwachsene männliche Ganzjahres-RGVE ergeben 388,8 €, mit rechtmäßigem individuellem Weideüberlapp 324 €. Tatsächliche ganzjährige Mischkompostierung ergibt 432 € einschließlich 43,2 € Zuschlag. Positive Antrags-/Kontroll-/Mindest-/AMA-Geldgates funktionieren.

Befunde: bekannte Mindestfläche bei unbekanntem Gewicht wird übersprungen, Meldefristen verlieren die GSP-Wochenendverlängerung, falsche Heim-/Alm-Modulation, 13 gültige Nullkontext-Abbrüche bei sieben Blättern, 12 Positivnachweisabweichungen, uneinheitliche Tieridentitätsaggregate und 0/128 neue Felder in echter App-Aufbereitung. Momentaufnahme/Ganzjahr, Krankheits-Intervallschnitt und allgemeine Kompostlagerpflichten bleiben qualifizierte Integrations-/Scopefragen. Gedruckte 500 kg-Überschneidung, Wendefrei 2023 und amtliche Rundung wurden nicht mit erfundenem eindeutigen Gold aufgelöst.

Quellenpaket 11 Originale: neues Merkblatt vollständig 12 Seiten, neuer 2 September-Artikel ganz; neun exakt gleiche allgemeine Originale mit früherer vollständiger Lektüre und frischen relevanten Abschnitten wiederverwendet. GSP/NAPV sind hier tatsächlich bereitgestellt und werden früheren Paketen nicht nachträglich zugeschrieben. Alle neun Module/1.481 Zeilen und 5.939 Bytes Annahmen gelesen.

| Original | SHA256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `gsp-av-fassung-vom-28012026.pdf` | `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10` |
| `napv-fassung-vom-28-10-2024.pdf` | `6bec588cc818a8e6620f9abda47c4de0489e4cc65bdd20466595722ac0e0fc92` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `2026-09-02__meldeverpflichtungen-zu-tierbezogenen-oepul-massnahmen.html` | `1a7d53bd3f5cb57c108d12f9a1daef1f05003ca3fc8db68ae49e4c23c404b200` |
| `o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf` | `a55a5f75a87705af5629727c3c3556c4ce5ec7b3e7745fd83eb1e7d81123aedd` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle 326 Fälle wurden nach finalen Metadaten vollständig ausgeführt und exakt wiederholt; OPA 1.18.2 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8` bleibt unverändert. Ursprüngliche Namespaces data.o6_21 und data.oepul.o6_21 bleiben getrennt; Netz/Uhr/Zufall/Runtime sind gesperrt. Separate App-Projektion zählt nicht als Quellenfall. 14 Abschlussartefakte sind gebunden. Drei Einzelprüfungen 22–24 und die gemeinsame Befundmatrix stehen aus.
