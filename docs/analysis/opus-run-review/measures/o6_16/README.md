# Einzelprüfung 18/26: Vorbeugender Grundwasserschutz – Acker

Run `v2-o6_16-opus-5.5-high-20261003`, unveränderter Kandidat `e009eed4a83ff076b26eba33ac433ac2b0642621`. **Quellenprüfung abgeschlossen, Übernahme blockiert.** Keine fachliche oder private Expertenabnahme und keine App-Promotion. Dieser Block wurde nach dem Limit durch Root fortgesetzt; eine zusätzliche unabhängige zweite Person wird für diesen Abschluss nicht behauptet.

Gesammelt im vorhandenen [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112), Branch codex/opus-o6-1a-source-audit und [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111). Historische Policy, Daten, Selbsttests, Quellen und Canonical bleiben unverändert. Die gemeinsame Lösungssuche folgt erst nach allen 26 Einzelprüfungen.

98/98 katalogisierte Regeln sind einzeln beurteilt, 34/34 Profilvorschläge mit 142 Blättern und 33/33 Tabellenzeiger geprüft. 358 öffentliche Entwicklungsfälle ergeben 678 typisierte Prüfungen: 647 erfüllt, 31 nicht erfüllt. Native Statuswerte: `{'defined': 351, 'undefined': 1, 'runtime_error': 6}`. Gezielte Entwicklungsfälle und zusammenhängende Fehlerfamilien sind keine unabhängige Genauigkeitsmessung.

| Prüfteil | Fälle | Prüfungen | erfüllt | nicht erfüllt |
|---|---:|---:|---:|---:|
| [Positivkontrollen](core.json) | 3 | 59 | 59 | 0 |
| [Allgemeine Bedingungen](general.json) | 71 | 158 | 148 | 10 |
| [Fachbedingungen/Optionen](measure.json) | 138 | 286 | 277 | 9 |
| [Tabellen/Quellenrechnung](tables.json) | 25 | 50 | 48 | 2 |
| [Eingaben/App](inputs.json) | 121 | 125 | 115 | 10 |

## Konkrete Blocker

- Nach bekanntem Ausstieg, endgültigem Ausschluss oder außerhalb der Vertragslaufzeit bleiben jeweils 1.140,54 € positiv. Die Hilfsregeln erkennen den Zustand, der Geldzweig nutzt ihn nicht.
- Zwei bekannte, nicht prämienfähige AG-Nationalpark-Hektar erhalten 1.080 € AG-Prämie. Die normale Komponente berücksichtigt den Ausschluss bereits.
- Körnermais/Silomais verlieren bei zehn Hektar je 216 € PSM-Zuschlag und erzeugen bei bekanntem verbotenem Wirkstoffeinsatz keine entsprechende Meldung. Mais funktioniert in den Gegenkontrollen.
- Der separate Fristhelfer berücksichtigt die Verschiebung eines Sonntag-Fristendes auf den nächsten Arbeitstag nicht. Eine eigene zuvor falsche Sollvorgabe wurde mit Verweis auf § 5/§ 6 korrigiert; die nativen Ausgaben bleiben gleich.
- Sechs formal zulässige null-Konstellationen brechen die native Hauptauswertung ab. Ein Weizen-Helfer bleibt durch die Zahlenschreibweise 14 statt 14.0 undefiniert. Einfache technische Kontrollen grenzen dieses Problem ein.
- Fehlende Antrags-/Antragsteller- und Proteinbelege können weiterhin positive Ergebnisse ermöglichen. Diese Fälle prüfen ausdrücklich GMs gewünschten Positivnachweisvertrag und beweisen keinen tatsächlich begangenen Verstoß.
- Reale aktuelle Anträge, Belege, Kulturfolgen, Kontrollentscheidungen und gemeinsame Kombinations-/Zahlungskappung sind nur teilweise abgebildet. Probenidentität und Zeitkonsistenz werden nicht ausreichend geprüft. Der vorhandene App-Adapter erhält keinen der 142 zusätzlichen nativen Pfade.

Der Quellenkonflikt zur PSM-Angabe ab 2026 bleibt offen: Merkblatt 04/2026 gegen die tatsächlich gelieferte GSP-AV §34. Ebenso bleiben ältere KG-Kulisse, Eberzuordnung, einzelne Fütterungskategorien, OÖ-Finanzierung und Projektvorgaben sichtbar. Diese offenen Punkte werden nicht in erfundene eindeutige Zulassungen umgewandelt.

## Was stimmt und was die Prüfung umfasst

Die Positivkontrollen für konventionell 2025/2026 sowie Bio 2026 berechnen 1.140,54 € bzw. 870,27 € korrekt. 10,01 ha prüfen dabei die Begrenzung des Bildungszuschlags auf zehn Hektar. Für 2025 wird die noch unbekannte MFA-2026-Basis nicht erfunden: Die vom Run ausgegebene aktuelle Flächenvorschau ist ausdrücklich kein feststehender zukünftiger Probenbedarf. Ein ursprünglich übergreifendes, bereits erfülltes Soll wurde bei der eigenen Gegenkontrolle entfernt und mit altem Hash dokumentiert; keine Eingabe oder native Ausgabe wurde dafür geändert.

Die geschlossenen Listen, alle 1.566 KG-Zeilen, 420 Kombinationszellen und 270 NAPV-Gitterfelder stimmen im dokumentierten Abgleich. Viele korrekte Grenzprüfungen und Rechenhelfer werden gutgeschrieben. Statische Vollständigkeit und Hilfsfunktionsergebnisse sind jedoch keine vollständige Beihilfeentscheidung.

Gelesen wurden das vollständige neue 17-seitige Merkblatt einschließlich Aktualisierungen und Impressum, der vollständige neue Hinweis 25.08.2026, sämtliche elf Module mit 1.702 Zeilen, alle acht Rohannahmenabschnitte und alle 34 Vorschläge. Neun byteidentische gemeinsame Originale verwenden die früher dokumentierte vollständige Lektüre; die aktuellen Verbraucherklauseln, NAPV-Tabellen sowie Anhang-A-/G-/L-Abgleiche sind frisch geprüft. GSP 94 Seiten und NAPV 42 Seiten sind in diesem Paket tatsächlich enthalten. Quellen aus anderen Paketen werden nicht nachträglich als geliefert angerechnet.

Details: [allgemeine Bedingungen](general.md), [Fachprüfung](measure.md), [Tabellen](tables.md), [Eingaben und App](inputs.md), [Ausführungen](observations.json), [Sammlungsprovenienz](collection-provenance.json), [eigene Gegenkontrolle](quality.md). Die JSON-Teile enthalten sämtliche Einzelurteile, Sollwerte, Eingaben, Quellen und transparente Korrekturreceipts. Keine Modell-Selbsttests, manuellen Anpassungstests, privaten Referenzen oder GM-/Experten-Fallurteile wurden als Quelle dieser normativen Sollwerte benutzt; die gewünschte Positivnachweiskonvention ist ausdrücklich markiert.

## Bindung und Fortsetzung

OPA 1.18.2, SHA `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`. Originale Policy-/Datenverzeichnisse werden mit den tatsächlichen Namespaces geladen; strikter Check, gesperrte Netzwerk-/Zufalls-/Laufzeitbuiltins, 10 s OPA-/20 s Prozessgrenze. Die wiederholte Gesamtausführung und 14 Artefaktbindungen werden in quality.json festgehalten. Wiederholbarkeit ist keine zweite fachliche Abnahme.

| Tatsächlich geliefertes Original | SHA-256 |
|---|---|
| `20241011_srl_oepul_2023.pdf` | `b9b8daabcde20d6dd3dfa58987aee5c481d8993fe4b6c752fe778bc9468d4798` |
| `20241011_srl_oepul_2023_anhaenge.pdf` | `1f608a5a43f1f93df5f8fd542233b37d312d11fd5d0fa5164d3bd8d4b60a119a` |
| `gsp-av-fassung-vom-28012026.pdf` | `d01dd8024d9575da1ec094506744c3aa7b43d1f8f17552a6aab62f422a755c10` |
| `napv-fassung-vom-28-10-2024.pdf` | `6bec588cc818a8e6620f9abda47c4de0489e4cc65bdd20466595722ac0e0fc92` |
| `2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html` | `337f679255d85af31a4d55039b448420158e0647fd3f279153c0d67f4ec3e4b8` |
| `2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html` | `be5ae0458262511e840119e8e654f2b1331f510da87fe97506e38d49cb19bed4` |
| `2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html` | `6766adb41b9ae176b9aafb1db390f67bd25cbfcc9ce249012bbfc0d7b60acca4` |
| `2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html` | `661072233da37d1ac62aba860e36173e83c98c85119bc6170c0a27dd7d7e435c` |
| `2026-08-25__aufzeichnungsverpflichtungen-bei-der-oepul-massnahme-vorbeugender-grundwasserschutz-acker.html` | `057b469f5dde7c48b88ca4ea57ac2df9d869109f5c84b7af9d888064cf2aa223` |
| `o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf` | `c23af2c778b023db57103318d3d81351d317409fad536e7b098adab5afa925c0` |
| `o6_allgemeine_teilnahmebedingungen_2026_04.pdf` | `89ad678a94ad109f6ba92563be4650dd0d36a6f3599506a187b56b1398dca120` |

Der nächste Run ist o6_17. Er wird erst nach gesichertem Abschluss dieses Dossiers begonnen. Die gemeinsame Befund-/Synergiematrix folgt nach dem 26. Run. Dieser Abschluss gibt keinen Merge zur App, keinen Produktivrelease und keine Datenbankänderung frei.
