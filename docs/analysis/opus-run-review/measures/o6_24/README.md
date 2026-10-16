# Einzelprüfung 26/26: Wasserrahmenrichtlinie – Landwirtschaft

Run `v2-o6_24-opus-5.5-high-20261003` am unveränderten Kandidaten `e009eed4a83ff076b26eba33ac433ac2b0642621`. **Quellenprüfung abgeschlossen; App-Übernahme blockiert.** Root hat selbst gegengeprüft. Keine unabhängige zweite Person, GM-/Domainexpertenabnahme oder Promotion wird behauptet.

Sammlung in [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112), Branch codex/opus-o6-1a-source-audit und [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Historische Regeln, Daten, Quellen, Canonical und App unverändert.

95/95 Regeln mit 97 Urteilen, 32/32 Tabellenzeiger und elf vollständige Vorschläge mit 119 Blättern geprüft. 537 öffentliche Entwicklungs-/Technikfälle ergeben 1.035 typisierte Vergleiche: 973 erfüllt, 62 abweichend; 523 definiert, 14 Laufzeitfehler, kein undefined. **Zwei Fehlvergleiche sind ein erhaltener eigener falscher >2-ha-Sollfall; ein weiterer 2023-Untercheck ist wegen eigener zeitlich gemischter Vorlage qualifiziert. Keine Genauigkeitsquote oder Modellfehlerzahl aus der Gesamtsumme.** Alle Abweichungen einzeln in [quality.json](quality.json).

| Prüfteil | Fälle | Vergleiche | erfüllt | abweichend |
|---|---:|---:|---:|---:|
| [core](core.json) | 3 | 9 | 9 | 0 |
| [general](general.json) | 92 | 217 | 196 | 21 |
| [measure](measure.json) | 128 | 256 | 251 | 5 |
| [tables](tables.json) | 204 | 408 | 408 | 0 |
| [inputs](inputs.json) | 110 | 145 | 109 | 36 |

Alle neun Kern- und 408 Tabellenvergleiche bestehen. Drei tatsächliche rechtmäßige 2026-Varianten mit zwei Hektar ergeben 108 €. Alle 120 Acker-, 240 Gemüseoriginalwerte und 480 expandierten Klassenwerte sowie 600 tatsächliche Klassenverbraucher stimmen. Gewöhnliche Antrags-/MFA-/Zugangs-/Abmelde-/Kontroll- und Behördenkürzungsgates funktionieren.

Befunde: widersprüchlicher Vertragsstatus bei Mindestfläche; fehlende genehmigte 2026-Übernahmeroute; Helfer-/Fristenden; Heim-/Alm-Basis; echte strikte 3%-Grenze mit internem Rechenrest; qualifizierte Obergrenzenallokation; fehlender Nmin-Befund für Paprika; falscher Wechselwiesenzeitraum; Lücken bei Bucheintragsinhalt und zeitlicher Evidenz; sieben gültige Null-Abbrüche; Identitätskonflikte und fehlende App-Abbildung. Technisch widersprüchliche Aggregate, 20 gewünschte Positivnachweise, Quellenversion und bedingte Jahres-/Rundungsverträge sind ausdrücklich getrennt. Positive Komponenten oder Typformen sind keine tatsächliche Förderfreigabe.

Elf Originale: drei neue vollständig vier/elf/sechs Seiten, acht hashgleiche zuvor vollständig gelesene allgemeine Quellen mit frischen relevanten Abschnitten. GSP geliefert, NAPV und Karten fehlen. Alle zehn Module/1.250 Zeilen, 4.980 Bytes Annahmen, 95 Katalogeinträge, elf Vorschläge und 13 Datendateien vollständig gelesen.

| Original | SHA256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018-fassung-vom-01072026.pdf` | `d96e759017f5d19721c02fec78050fda9914beaa742c9d747e4e366495093338` |
| `grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018_anlage3_2026.pdf` | `a8e3350cc070209213513f1e7711ec71dddb7f842f0c65eb92957bedc0f209d2` |
| `gsp-av-fassung-vom-28012026.pdf` | `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf` | `417e71f8917a932ccd07bd5b5d515e567176b3b203b0a2465ce3d2643fa04510` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Alle 537 Fälle nach finalen Metadaten vollständig geschrieben und exakt wiederholt. OPA 1.18.2 `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8` unverändert; ursprüngliche Namespaces erhalten, Netz/Uhr/Zufall/Runtime gesperrt. 14 Abschlussartefakte gebunden. Damit sind alle 26 Einzelprüfungen abgeschlossen; gemeinsame Befundmatrix und Lösungsvorschläge folgen, keine Implementierung oder automatische Freigabe.
