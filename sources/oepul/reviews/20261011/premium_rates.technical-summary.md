# Technische Extraktion des ÖPUL-Prämienworkbooks vom 11.10.2026

Die Datei `premium_rates.extraction.json` ist eine vollständige, wortgetreue
technische Extraktion des frisch archivierten BMLUK-Originals. Sie bestätigt
weder aktuelle fachliche Anwendbarkeit einzelner Sätze noch fachliche Abnahme
oder rechtliche Vollständigkeit.

Original: `OEPUL_Praemiensaetze_ha_ab_2024_final_und_ab_2025.xlsx`

Offizielle URL:
<https://www.bmluk.gv.at/dam/jcr:67b453b5-a56e-423d-ba95-342521be6f53/OEPUL_Praemiensaetze_ha_ab_2024_final_und_ab_2025.xlsx>

Archivpfad:
`sources/oepul/supplemental/premium_rates/2750d4f96ef0007c05ba0bfbcdee08f6a46418bea3c038de33bd07e9ec39ad02/OEPUL_Praemiensaetze_ha_ab_2024_final_und_ab_2025.xlsx`

Originalumfang: 95.793 Bytes. SHA-256:
`2750d4f96ef0007c05ba0bfbcdee08f6a46418bea3c038de33bd07e9ec39ad02`.

Die Extraktion entstand aus den ZIP/XML-Strukturen des Originals, bevor die
unabhängig erstellte Soll-Inventarliste gelesen wurde. `openpyxl` diente nur
zum Gegenprüfen und Auflösen gemeinsam gespeicherter Formeln.

| Arbeitsblatt | Zustand | Gespeicherte nichtleere Zellen | Verbundbereiche | Formeln | Explizit gespeicherte leere Zellen |
| --- | --- | ---: | ---: | ---: | ---: |
| OEPUL_Prämiensätze ab 2024-25 | sichtbar | 677 | 95 | 125 | 856 |
| Prämiensätze_Naturschutz_Alm | sichtbar | 45 | 4 | 9 | 75 |
| Prämiensätze_Naturschutz | sichtbar | 741 | 27 | 152 | 664 |
| Prämiensätze_EBW | sichtbar | 526 | 26 | 0 | 163 |
| ÖPUL_2015_Prämiensätze | verborgen | 303 | 57 | 0 | 313 |
| ÖPUL_2007_Prämiensätze | verborgen | 341 | 5 | 0 | 5.654 |
| Summe | 6 Blätter | 2.633 | 214 | 286 | 7.725 |

Die 2.847 Inventarpositionen umfassen jede gespeicherte nichtleere Zelle und
jeden Verbundbereich. Alle 286 Formeln behalten sowohl die aufgelöste Formel
als auch den unveränderten gespeicherten Ergebniswert und ihre ursprünglichen
XML-Attribute. Es erfolgte keine Neuberechnung.

Erhalten sind alle wörtlichen Einheiten, Grenzen, Prozentsätze, Bedingungen,
Datums- und Jahresbeschriftungen, Codes und Platzhalter; auch Leerzeichen,
Zeilenumbrüche und geschützte Leerzeichen bleiben erhalten. Leere Koordinaten
werden über vollständige Leerbereichslisten und zusätzlich über Läufe aller
explizit gespeicherten Leerzellen dokumentiert. Sie bedeuten weder Null noch
automatische Fortgeltung eines früheren Satzes.

Alle 14 Hinweiszellen wurden zusätzlich als Hinweise erfasst:

- `OEPUL_Prämiensätze ab 2024-25!A216:A218`: auf drei Zellen verteilte Fußnote zu Öko-Regelungen und garantierten Mindestbeträgen.
- `Prämiensätze_EBW!S27:S28`: redaktionelle Hinweise zur Anpassung der Obergrenze und Korrektur der Prämienberechnung.
- `ÖPUL_2015_Prämiensätze!A132,D133`: Standhinweis und Quellenangabe.
- `ÖPUL_2007_Prämiensätze!A179:A184,E185`: Fußnoten einschließlich Fortsetzungszelle und Quellenangabe.

Kopf- und Fußzeilen, Zeilen- und Spaltenstruktur, Druckbereiche,
Verbundbereiche, bedingte Formatierungen und die originalen Styles sind
zusätzlich im Extraktionsartefakt erhalten. Binäre Druckereinstellungen
wurden nicht interpretiert; das archivierte Original enthält ihre Bytes.

Die technische Prüfung gegen das archivierte Original bestätigte alle
Zellkoordinaten, Text- und Zahlenwerte, Formeln und gespeicherten Ergebnisse,
Verbundbereiche, expliziten Leerzellen, Leerbereiche, Hinweiswerte und Styles.
Der anschließende Abgleich mit der unabhängig erstellten Soll-Inventarliste
`premium_rates.inventory.json` bestätigte identische Mengen aller 2.847
Positionen und 14 Hinweise. Auch die 580 leeren Koordinaten ihrer begrenzten
Prämienraster stimmen mit dem Original-XML und der vollständigen
Leerbereichsextraktion überein. Dieser technische Abgleich ist keine
fachliche Abnahme.

Für die fachliche Prüfung sind insbesondere folgende gespeicherte
Besonderheiten sichtbar gehalten:

- Auf dem verborgenen Blatt `ÖPUL_2015_Prämiensätze` liegen 16 nichtleere Zellen unter Verbundbereichen. Eine ausschließliche Auswertung über `openpyxl` würde diese Werte verlieren; die XML-Extraktion bewahrt sie mit Verbundzuordnung.
- Das verborgene Blatt `ÖPUL_2007_Prämiensätze` enthält zusätzlich `IJ51`, `IK51`, `IN51` und `IO51` weit außerhalb seines Druckbereichs. Diese Originalwerte bleiben erfasst.
- `OEPUL_Prämiensätze ab 2024-25!E160,E170` und `Prämiensätze_Naturschutz!E171` enthalten Formeln mit leeren Referenzzellen und dem gespeicherten Ergebnis `0`. Diese gespeicherten Formelergebnisse werden nicht als fachlich bestätigte Prämiensätze interpretiert.
- Historische Blätter, Jahreskolonnen und Hinweise wurden vollständig aufgenommen; die Auswahl aktuell geltender Prämien erfordert gesonderte fachliche Prüfung.
