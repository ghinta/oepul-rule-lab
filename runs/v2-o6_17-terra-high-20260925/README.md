# Draft: `o6_17` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_17` (Humuserhalt und Bodenschutz auf
umbruchsfähigem Grünland). Er liefert einen quellengebundenen, ausführbaren
Regelkandidaten. Die technische Validierung belegt weder fachliche
Vollständigkeit noch Rechtsverbindlichkeit oder eine passende Empfehlung für
einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_17-terra-high-20260925`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Limit-Guard: Start bei 88 %, Abschluss bei 73 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Stand Oktober 2025
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 28 |
| Quellenbelege | 31 |
| Coverage-Einträge / offene Einträge | 46 / 0 |
| Vorgeschlagene Profil-Blattpfade | 53 in drei Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 20 / 0 |
| Datendateien / Datentabellen | 1 / 4 |
| Rego-Dateien / Zeilen | 2 / 251 |
| Generierte OPA-Tests | 4 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Schlag-, Antrags-, Kontroll-, Tier- und Bodenprobendaten fehlen im Canonical
  Farm Profile. Sie werden nur als Discover-Vorschlag ergänzt.
- Die AGL-Zuteilung oberhalb der förderfähigen Höchstfläche erfordert eine
  AMA-konforme Flächenzuordnung; die Rego-Regel bildet keine behördliche
  Priorisierung nach.
- Die vier selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
