# Draft: `o6_1a` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run erzeugt einen quellengebundenen, ausführbaren Regelkandidaten für
`o6_1a` (Umweltgerechte und biodiversitätsfördernde Bewirtschaftung). Er ist
kein Nachweis fachlicher Vollständigkeit, Rechtsverbindlichkeit oder einer
geeigneten Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_1a-terra-20260920`
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
| Strukturierte Regeln | 38 |
| Quellenbelege | 44 |
| Coverage-Einträge / offene Einträge | 34 / 0 |
| Vorgeschlagene Profil-Blattpfade | 29 unter einem `ubb`-Objekt |
| Von Rego verwendete Eingabepfade / unbekannt | 15 / 0 |
| Datendateien / Datentabellen | 1 / 5 |
| Seltene Kulturpflanzen | 85 |
| Regionale Acker- / Grünlandarten | 73 / 68 |
| RGVE-Faktoren | 23 vollständig, 9 vereinfachte Faktoren |
| Rego-Dateien / Zeilen | 2 / 201 |
| Generierte OPA-Tests | 8 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Reparaturhistorie

Der erste Generatorversuch erzeugte technisch testbaren Rego-Code, bestand
aber die unabhängige Grounding-Prüfung nicht: sechs Belegtexte waren wegen
Zeilen- oder Silbentrennungen auf der zitierten Seite nicht exakt auffindbar;
drei Belege waren noch keiner Regel zugeordnet. Der Rohlog dieses Versuchs ist
als `raw/*.attempt-1.*` erhalten.

Der zweite Terra-Versuch erhielt nur diese deterministischen Gate-Fehler. Er
ersetzte die Auszüge durch zusammenhängende, seitengebundene Zitate, verknüpfte
die drei Belege regelbasiert und korrigierte zwei beim Nachtest entdeckte
Datennamespace-Zugriffe in Rego. Erst danach bestanden die unabhängige
Grounding-Prüfung und die Finalisierung mit OPA.

## Nicht ersetzte Prüfungen und Risiken

- Ein im Modell-Sandbox gestarteter Zusatzcheck über das nicht installierte
  Python-Paket `jsonschema` war nicht ausführbar. Das ist transparent im
  Rohlog sichtbar; die maßgebliche Rule-Lab-Validierung verwendet die
  eingecheckten Pydantic-Verträge und bestand vollständig.
- Die acht selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle 38 Regeln und Ausnahmen ab.
- Der Discover-Profilvorschlag ist ein Kandidat für Review, kein eingefrorenes
  Canonical Farm Profile.
- Der vorhandene GPT-5.5-Run darf für einen späteren Vergleich herangezogen
  werden, ist aber keine normative Quelle und keine fachliche Referenz.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-,
Profil-, Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen
und die OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen
unveröffentlicht; ihre Identitäten und Prüfsummen sind in `run.json` und den
Artefakten festgehalten.
