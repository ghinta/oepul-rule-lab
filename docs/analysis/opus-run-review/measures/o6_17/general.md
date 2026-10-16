# o6_17 – Allgemeine Bedingungen und Zahlungsverknüpfung

89 öffentliche Entwicklungsfälle, 192 typisierte Vergleiche: 170 erfüllt, 22 abweichend. Native Statuswerte: `{'defined': 89}`. Gezielte Kontrollen sind keine Genauigkeitsquote oder Expertenabnahme.

Alle 61 Katalogregeln 73–133 sind einzeln in [general.json](general.json) beurteilt. Das gemeinsame Quellenpaket enthält hier tatsächlich die GSP-AV mit 94 Seiten. Die acht identischen allgemeinen Originale werden mit früherem vollständigem Lesedurchgang und erneut gelesenen aktuellen Abschnitten verwendet. Die vier 2026er Hinweise gewähren keine ausdrückliche Ausnahme für o6_17.

Die bekannten Typ-/Anteil-/Aktivitätsgates, OP/VF und differenzierten Nationalparkregeln funktionieren. Neusiedlersee/Donau-Auen sind immer ausgeschlossen; Kalkalpen ohne relevante Auflagen werden korrekt bezahlt. Ein Einstieg 2026 wird im ersten Jahr abgelehnt. Derselbe bekannte ungültige Beginn oder ein verspäteter ursprünglicher Antrag kann im Folgejahr trotzdem einen positiven Betrag liefern. Das ist ein bedingter Vertrag für ungefilterte Datensätze, keine Behauptung einer tatsächlich legal genehmigten verspäteten Teilnahme. Fehlende Daten werden gesondert nach GMs gewünschtem Positivnachweisvertrag beurteilt.

| Bekannter Sachverhalt | Quellensoll | Native Ausgabe |
|---|---:|---:|
| Tatsächlich wirksame Abmeldung 2026 oder bereits 2025, aktuelles Jahr 2026 | 0 € | 336,96 € |
| AMA hat tatsächlich 25 % für die gesamte Maßnahme ausgesprochen | 252,72 € | 336,96 € |
| AMA hat tatsächlich 100 % ausgesprochen | 0 € | 336,96 € |
| Wirksamer Ausschluss nach zwei früheren 100-%-Entscheidungen | 0 € | 336,96 € |
| Abschließend 9,4 statt 10,4 ha ermittelt, homogener Tarif, keine §45-Ausnahme | Basis 7,9 ha, 255,96 € | Helfer 7,9 ha; Betrag 336,96 € |

Die Ausstiege werden als tatsächlich rechtzeitig erklärt vorausgesetzt und O6_17 aus der aktuellen Teilnahmeliste entfernt. Die Sanktionsstufen stammen aus vorausgesetzten tatsächlichen AMA-Entscheidungen zu fehlenden angeforderten Aufbewahrungsunterlagen; aus einer frisch beobachteten lokalen Verletzung wurde keine willkürliche 100-%-Stufe erfunden. Die separate Übererklärungsrechnung ist in den ursprünglichen Annahmen ausdrücklich offengelegt. Eine funktionierende Hilfsregel ist damit noch keine integrierte Zahlungsverknüpfung.

Stufen, Eskalation („und so fort“), Kumulation, Feststellungsjahr, Modulation, Flächenabgang und Übernahmefristen bestehen die isolierten Kontrollen. Der Flächenzugang mit bekannter Basis 10 ha ergibt bei aktuell 20 ha korrekt 486 € auf 15 ha, mit fünf bereits vorher belegten Zugangshektar 648 € auf 20 ha. Die Schlagobergrenze wird korrekt nach der Modulation angewendet. Der künstlich hohe andere Zahlungsbetrag dieser letzten Rechenkontrolle ist ausdrücklich kein behaupteter zulässiger Begleitmaßnahmenbetrag eines realen Betriebs. Die ≤50-€-Grenze ist Ermessen und wurde nicht als zwingende Nullzahlung umgedeutet.

Die Dreiwochenmeldung ab Sonntag 07.06.2026 ist am Montag 29.06. rechtzeitig: §5 verschiebt Sonntag 28.06. auf den nächsten Arbeitstag; §6 ist nicht ausgenommen. Der reine 21-Kalendertage-Helfer lehnt sie ab. Werktag 21/22 bestehen die Gegenkontrollen. Die bereits im vorherigen Run transparent korrigierte eigene Sollvorgabe wurde hier von Anfang an richtig konstruiert.

Bei genau 3 % (10,3 angemeldet, 10 ermittelt) wirkt zusätzlich ein Präzisionsbefund der ursprünglichen gepinnten Binary: `10.3-10` wird als `0.30000000000000000017`, `0.03*10` als `0.29999999999999999998` serialisiert. Der strikte Vergleich ist dadurch wahr. Acht separate Diagnosekontrollen (nicht zusätzlich als Quellenfälle gezählt) unterscheiden Literalvergleich, vierstellig quantisierte Kontrolle und den tatsächlichen Helfer. Es wird kein Fehler aller OPA-Versionen behauptet. Der Befund bleibt vom früheren 60/17-Vergleich und dem sprintf-Problem in o6_16 getrennt.

Zwei eigene Diagnosequeries verwendeten zunächst das nicht existierende `to_string`; sie wurden auf `json.marshal` korrigiert. Ein eigener zusätzlicher Diagnose-Sollwert für 103/100 hatte zunächst die alternative >2-ha-Grenze übersehen und wurde auf true korrigiert. Originale Diagnosefixtures, Beobachtungen und Hashes sind erhalten. Keiner dieser Fehler wurde Opus zugerechnet; alle 326 regulären Quellenfall-Sollwerte bleiben unverändert.
