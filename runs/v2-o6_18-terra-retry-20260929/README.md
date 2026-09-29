# Draft: `o6_18` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_18` (Naturschutz). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_18-terra-retry-20260929`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Naturschutz, Ausgabe
  Oktober 2025; im versionierten Quellenbestand liegt keine Ausgabe 2026 vor
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhang A sowie amtliche Hinweise aus
  2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 25 |
| Quellenbelege | 19 |
| Coverage-Einträge | 23 |
| Vorgeschlagene Profil-Blattpfade | 20 in 1 Discover-Vorschlag |
| Von Rego verwendete Eingabepfade / unbekannt | 10 / 0 |
| Datendateien / Datentabellen | 1 / 3 |
| Rego-Dateien / Zeilen | 2 / 132 |
| Generierte OPA-Tests | 7 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die Projektbestätigung und projektbezogene Auflagen werden als betriebliche
  Eingaben modelliert; ihre konkrete räumliche und fachliche Auslegung muss
  fachlich bestätigt werden.
- Der lokale Quellensatz enthält als maßnahmenspezifisches Informationsblatt
  nur den Stand Oktober 2025. Ein späterer amtlicher Stand ist vor einer
  produktiven Nutzung erneut abzugleichen.
- Zeitgebundene Trockenheitshinweise aus 2026 sind als Ausnahmen zu behandeln,
  nicht als dauerhafte Anspruchsgrundlage.
- Die sieben OPA-Tests sind generierte Techniktests, keine fachlichen Golden-
  oder Hidden-Tests und keine vollständige Abdeckung aller Fristen und
  Ausnahmen.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
