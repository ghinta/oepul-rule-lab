# Draft: `o6_8` mit `gpt-5.6-terra`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_8` (Erosionsschutz Acker). Er liefert
einen quellengebundenen, ausführbaren Regelkandidaten. Weder technische
Validierung noch die Anzahl der Regeln belegen fachliche Vollständigkeit,
Rechtsverbindlichkeit oder eine passende Empfehlung für einen konkreten
Betrieb.

## Lauf

- Run-ID: `v2-o6_8-terra-high-retry-20260924`
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: AMA-Informationsblatt Stand April 2026
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 26 |
| Quellenbelege | 24 |
| Coverage-Einträge / offene Einträge | 32 / 0 |
| Vorgeschlagene Profil-Blattpfade | 35 in zwei Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 4 / 0 |
| Datendateien / Datentabellen | 2 / 4 |
| Rego-Dateien / Zeilen | 2 / 212 |
| Generierte OPA-Tests | 6 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

## Offene fachliche Punkte

- Die Flächenkulisse aus Anhang F ordnet Katastralgemeinden zu, nicht einzelne
  Schläge oder konkrete Flächenanteile. `erosion_path_share` und der
  Eintragspfad bleiben daher betriebliche Eingaben.
- Der Canonical Farm Profile enthält keine Schlagcodes, Katastralgemeinden,
  Antragsdaten, Begrünungsvorgeschichte oder Durchführungssachverhalte. Diese
  Informationen werden nur als Discover-Vorschläge ergänzt.
- Die Prämienobergrenze und Modulation sind im Katalog erfasst, aber nicht in
  die Rego-Bruttoprämie eingerechnet: Angaben zu gleichzeitig beantragten
  Maßnahmen, LSE und der obergrenzenrelevanten Prämienbasis fehlen.
- Die Dürre-Ausnahme 2026 für Untersaaten betrifft nur die Flächendeckung;
  Anlage, Mischungspartner, Frist und übrige Auflagen bleiben prüfbar.
- Die sechs selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
