# Einzelprüfung 24/26: Tierwohl Schweinehaltung

Run `v2-o6_22-opus-5.5-high-20261004` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. **Quellenprüfung abgeschlossen; App-Übernahme blockiert.** Root hat selbst gegengeprüft. Keine unabhängige zweite Person, GM-/Domainexpertenabnahme oder Promotion wird behauptet.

Sammlung weiterhin in [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112), Branch `codex/opus-o6-1a-source-audit` und [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Historische Regeln, Daten, Quellen, Canonical und App bleiben unverändert. Gemeinsame Lösungen folgen nach dem vollständigen Durchgang.

125/125 Regeln mit 127 Einzelurteilen, 35/35 Tabellenzeiger und 17 Vorschläge mit 118 Blättern sind geprüft. 350 öffentliche Entwicklungs-/Technikfälle ergeben 691 typisierte Vergleiche: 648 erfüllt, 43 abweichend; 344 definierte Ausgaben und sechs Laufzeitfehler. Keine Genauigkeitsquote. Jede Abweichung ist in [quality.json](quality.json) einzeln klassifiziert.

| Prüfteil | Fälle | Vergleiche | erfüllt | abweichend |
|---|---:|---:|---:|---:|
| [core](core.json) | 3 | 21 | 21 | 0 |
| [general](general.json) | 63 | 134 | 122 | 12 |
| [measure](measure.json) | 117 | 282 | 269 | 13 |
| [tables](tables.json) | 71 | 142 | 142 | 0 |
| [inputs](inputs.json) | 96 | 112 | 94 | 18 |

Alle 21 Kern- und 142 Tabellenvergleiche bestehen: acht tatsächliche Mastschweine im Jahresdurchschnitt ergeben 168,48 €, mit drei rechtmäßig erfüllten Zuschlägen 531,36 €. Die tatsächlichen Zugangs-, Mindestteilnahme-, gewöhnlichen Abmelde- und Mengenabzugsgates funktionieren. Separate AMA-Rechenhelfer werden ebenfalls gewürdigt.

Befunde: korrekt diagnostizierte bekannte Tier-/Zuschlagseignung wird nicht in die entsprechenden Betragskomponenten übernommen; unberechtigte Unkupiert-Diagnose wegen vollständig ausgeschlossener konventioneller Gruppe; fehlende Arbeitstagverschiebung für Melde-/Tierlistenfristen; Heim-/Alm-Basis; vier gültige Null-Abbrüche; Null-TGD-Start als positiver Nachweis; doppelte Gruppenmengen und fehlende App-Übergabe. Negative Compliance und berechneter Teilbetrag werden ausdrücklich von realer Förderfreigabe getrennt. 16 gewünschte Positivnachweise, ein zusätzlich qualifizierter Einkaufsnachweis und offene Futter-/Kompost-/Korrekturscopes werden separat geführt.

Quellenpaket: elf Originale, neues Merkblatt vollständig 17 Seiten; zehn hashidentische allgemeine Originale mit dokumentierter früherer vollständiger Lektüre und frischen relevanten Abschnitten wiederverwendet. Alle sieben Module/1.438 Zeilen, 10.004 Bytes Annahmen, 125 vollständige Katalogeinträge, 17 vollständige Vorschläge und sechs Datendateien gelesen. GSP/NAPV wurden tatsächlich geliefert.

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
| `o6_22_tierwohl-schweinehaltung_2025_10.pdf` | `4289367636a3e4041cad162f1dd21ac72dfe48f030ad027e12d8b0ca9b834896` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle 350 Fälle nach finalen Metadaten vollständig ausgeführt und exakt wiederholt; OPA 1.18.2 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8` unverändert. Ursprüngliche Namespaces data.o6_22 und data.oepul.o6_22 bleiben getrennt; Netz/Uhr/Zufall/Runtime gesperrt. Die beiden technischen App-Kontexte zählen nicht als zusätzliche Quellenfälle. 14 Abschlussartefakte sind gebunden. Zwei Einzelprüfungen o6_23/o6_24 und die gemeinsame Befundmatrix stehen aus.
