# Draft: `o6_2` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die bisher als Category-C eingeordnete Maßnahme `o6_2`
(Einschränkung ertragssteigernder Betriebsmittel). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Weder technische Validierung
noch die Anzahl der Regeln belegen fachliche Vollständigkeit,
Rechtsverbindlichkeit oder eine passende Empfehlung für einen konkreten
Betrieb.

## Lauf

- Run-ID: `v2-o6_2-terra-20260921`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Stand April 2026
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt
- Quellpack-Prüfung: 27/27 Kern-PDFs, 2/2 Rechtsgrundlagen und 4/4 Hinweise
  verifiziert; AMA-Indizes zum Prüfzeitpunkt deckungsgleich

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 29 |
| Quellenbelege | 25 |
| Coverage-Einträge / offene Einträge | 41 / 0 |
| Vorgeschlagene Profil-Blattpfade | 39 in drei Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 14 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Prämienstaffel-Einträge | 16 |
| RGVE-Faktoren | 20 |
| Ackerfutter-Kulturen | 7 |
| Rego-Dateien / Zeilen | 2 / 166 |
| Generierte OPA-Tests | 3 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Reparaturhistorie

Der erste Versuch bestand seine modellseitige OPA-Prüfung, scheiterte aber an
der unabhängigen Grounding-Prüfung: Zwei Referenzen waren noch keiner Regel
zugeordnet und zwei Belegtexte waren auf der zitierten Sonderrichtlinienseite
nicht wortwörtlich auffindbar. Der Rohlog ist als `raw/*.attempt-1.*`
erhalten.

Der zweite Terra-Versuch korrigierte diese deterministischen Fehler. Eine
Anhang-L-Referenz ohne zuverlässig herstellbare Regelzuordnung wurde entfernt;
die Ackerfutter-Referenz ist nun mit der Tierhalterklassifikation verknüpft.
Die zwei Sonderrichtlinienbelege wurden durch kurze, seitenlokal auffindbare
Auszüge ersetzt. Erst danach bestanden unabhängiges Grounding und Finalisierung.

## Offene fachliche Punkte

- Die flach aus dem PDF extrahierte Anhang-L-Kombinationstabelle erlaubt keine
  maschinensichere Spaltenzuordnung. Sie wird deshalb nicht als sichere
  fachliche Kombination für Maßnahme `o6_2` ausgeführt. Die unabhängig
  belegbare BIO-Ausnahme bleibt erhalten; die übrigen Matrixbeziehungen sind
  dokumentierter Kontext für eine fachliche Prüfung.
- Die PSM-Ausnahme für ausschließlich nach Verordnung (EU) 2018/848 zulässige
  Wirkstoffe setzt eine externe, belegbare Mittel-/Wirkstoffbewertung voraus.
- Hofdünger-Ausnahmen, Rücknahme von Biogasgülle und Stickstoffanfall erfordern
  Stoffstrom- und Mengenaufzeichnungen, die im Canonical Farm Profile bisher
  nicht vorhanden sind. Die nötigen Felder werden nur als Discover-Vorschläge
  geführt.
- Die drei selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-,
Profil-, Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen
und die OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen
unveröffentlicht; ihre Identitäten und Prüfsummen sind in `run.json` und den
Artefakten festgehalten.
