# Unabhängige Qualitätskontrolle des UBB-Audits

Stand 15.10.2026. Die geprüfte Fassung enthält keine offene wesentliche
Unstimmigkeit im Replay, in der Katalog-/Tabellenidentität oder in den
gezielt nachgelesenen Quellenbegründungen. **Der historische Kandidat bleibt
für eine App-Übernahme blockiert.** Diese Qualitätskontrolle ist keine
Abnahme durch GM oder Domainexpert:innen.

Die Kontrolle betrifft ausschließlich `v2-o6_1a-opus-5.5-high-20260929` am
Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Sie ist eine
unabhängige Prüfung des Dossiers und ausgewählter Quellenfolgerungen;
sie wiederholt nicht die vollständige semantische Beurteilung aller
Quellseiten, 166 Regeln oder 374 einzelnen Tabellenzeilen.

Der Haupt-Replay wurde unabhängig und bytegenau wiederholt: 43 Fälle,
55 Einzelerwartungen, 42 definierte Abfragen und ein RGVE-Laufzeitfehler.
27 Erwartungen treffen zu, 28 nicht. Diese Zahlen beschreiben gezielte
Entwicklungsproben und ergeben keine Genauigkeitsquote. `false`, numerische
Null und `null` bleiben im Vergleich getrennt; Laufzeitfehler werden nicht
zu fachlichen Entscheidungen umgedeutet.

Auch die gespeicherten Ausgaben der Teilprüfungen wurden unabhängig erneut
ausgeführt: alle 35 allgemeinen Grenzproben, alle 42 Eingabeproben, alle fünf
Maßnahmenproben und alle acht rechtlichen Gesamtszenarien. Beim RGVE-Nullfehler
im Eingabeteil stimmt die fachliche Fehlermeldung einschließlich Modul und
Position überein; nur der absolute historische Dateipfad wird im isolierten
Replay durch den Bundle-Pfad ersetzt. Die Sätze überschneiden sich und werden
nicht zu einer Zahl unabhängiger Fälle addiert.

Direkt in den Originalen nachgelesen wurden insbesondere Kultur und Sorte bei
SLK, offene Sortengruppen und Prämiensätze, die Zählung abtransportierter
Reinigungsschnitte bei DIVRS, die feste WB-Erntegrenze bis 30. Juni, der
Vergleichsschnitt bei der Dürre-Ausnahme, das Ende des DIV-Betriebsmittelverbots,
der Abtransport beider DIVNFZ-Aufwüchse und die invasive Frühmahd auf älteren
DIV-Flächen. Die 21 Belege des Hauptfallsatzes wurden auf der angegebenen
Quellseite bzw. im HTML gefunden. Die separate Wortlautprüfung reproduziert
418 historische Zitatstellen und diese 21 Belege ohne fehlenden Treffer.
Ein Wortlauttreffer allein bestätigt keine fachliche Schlussfolgerung.

Der integrierte Ledger und die CSV enthalten genau die 166 historischen
Regelkennungen, ohne Dubletten oder zusätzliche Kennungen; alle Detailverweise
lassen sich auflösen. Die zuvor fehlende gemeinsame Flächenregel `UBB-GEN-002`
ist ausdrücklich bewertet. Die 53 Tabellenidentitäten entsprechen exakt den
Schlüsseln der acht historischen Datendateien; die Zählung 42 referenziert und
elf nicht referenziert stimmt. Die Bindung erfasst alle veröffentlichten
Dateien dieses historischen Runs.

Im Review wurden ungenaue SLK-Begründungen, fehlende Prämienbelege und der
fehlende 166. Ledger-Eintrag berichtigt. Die Feldstückprobe bei fehlender
Gruppierung ist jetzt ausdrücklich ein Nachweisvertrags- und Informationsverlustfall.
Beim invasiven Befall sind Ragweed und vorhandene Nachweise als Hintergrund des
Szenarios erklärt; die native Schnittstelle überprüft sie nicht selbst.

README und Warteschlange unterscheiden technische Sichtung und Einzelprüfung,
Quellenfehler und den geforderten positiven App-Nachweis sowie Komponentenbetrag
und Auszahlung. Sie weisen eine abgeschlossene, blockierte Einzelprüfung und
25 ausständige aus. Andere Run-Prüfungen, eine Expertenabnahme oder eine
App-Promotion werden daraus nicht abgeleitet.

Dateihashes, Einzelkontrollen und genaue Lesebegrenzungen stehen in
[quality-review.json](quality-review.json). Quellenkonflikte und offene
Rechtsfolgenentscheidungen bleiben im Hauptdossier sichtbar.
