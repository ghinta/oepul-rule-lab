# Draft: `o6_9` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_9` (bodennahe Ausbringung flüssiger
Wirtschaftsdünger und Gülleseparation). Er liefert einen quellengebundenen,
ausführbaren Regelkandidaten. Die technische Validierung belegt weder
fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine passende
Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_9-terra-high-20260925`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Limit-Guard: Start bei 74 %, Abschluss bei 71 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Stand Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 25 |
| Quellenbelege | 19 |
| Coverage-Einträge / offene Einträge | 53 / 0 |
| Vorgeschlagene Profil-Blattpfade | 28 in einem Discover-Vorschlag |
| Von Rego verwendete Eingabepfade / unbekannt | 12 / 0 |
| Datendateien / Datentabellen | 1 / 3 |
| Rego-Dateien / Zeilen | 2 / 207 |
| Generierte OPA-Tests | 4 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Ausbringungs-, Separierungs-, GVE-, Rations-, Nachweis- und
  Kombinationsdaten fehlen im Canonical Farm Profile. Sie werden nur als
  Discover-Vorschlag ergänzt.
- Die Produkt- und Mengenangaben werden auf regelgebundene Datensätze
  abgebildet; betriebliche Nachweise und die konkrete Förderentscheidung
  bleiben separat zu prüfen.
- Die vier selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
