# Draft: `o6_19` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_19` (Ergebnisorientierte Bewirtschaftung). Er liefert einen quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_19-terra-20260929`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Ergebnisorientierte Bewirtschaftung, Ausgabe Oktober 2025; im versionierten Quellenbestand liegt keine Ausgabe 2026 vor
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April 2026, Sonderrichtlinie ÖPUL 2023 samt Anhang A sowie amtliche Hinweise aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 30 |
| Quellenbelege | 31 |
| Coverage-Einträge | 52 |
| Vorgeschlagene Profil-Blattpfade | 43 in 4 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 14 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Rego-Dateien / Zeilen | 2 / 175 |
| Generierte OPA-Tests | 5 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Indikatorauswahl und Parameter aus Anhang K sind schlag- und projektbestätigungsspezifisch; sie werden als Eingaben modelliert, statt Werte zu erfinden. Parameter- und Artenlisten bleiben fachlich offen.
- Die Lärchenwiese in leichter Erschwernisklasse ist in der Quelle mit Schrägstrich angegeben und im Datensatz daher nicht berechenbar dargestellt.
- EBBA-Umstände erfordern Anhang I, NAT-Handbuch und Gebietskulissen. Zeitgebundene Dürre-Hinweise aus 2026 sind Ausnahmen, nicht dauerhafte Anspruchsgrundlagen.
- Die fünf OPA-Tests sind generierte Techniktests, keine fachlichen Golden- oder Hidden-Tests und keine vollständige Abdeckung aller Fristen und Ausnahmen.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-, Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht; ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten festgehalten.
