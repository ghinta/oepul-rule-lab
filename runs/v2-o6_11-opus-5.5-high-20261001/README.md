# Draft: `o6_11` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_11` (Herbizidverzicht Wein, Obst und Hopfen). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_11-opus-5.5-high-20261001`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 22 min, 73 Turns; laut Claude Code
  457.163 Output-Tokens (davon 128.021 Thinking),
  Listenpreis-Äquivalent 28,88 USD
- Versuche: 5 (Fortsetzungen derselben Sitzung, siehe `resumed_attempts` in
  `run.json`). Versuch 2 und 4 wurden kurz nach dem Start durch
  Container-Neustarts der Ausführungsumgebung abgebrochen und lieferten kein
  Ergebnis. Laufzeit und Tokens sind über die Versuche mit Ergebnis
  aufsummiert
- Limit-Guard: Versuch 1 wurde bei 3 % Restlimit kontrolliert beendet und
  nach dem Limit-Reset fortgesetzt. Versuch 3 bestand `finalize` wegen eines
  nicht auffindbaren Belegs (REF-AT-13) nicht; Versuch 5 behob das und
  startete bei 77 % Restlimit
- Maßnahmenspezifische Quelle: `o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 76 |
| Quellenbelege | 151 |
| Coverage-Einträge / offene Einträge | 114 / 0 |
| Vorgeschlagene Profil-Blattpfade | 67 in 10 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 1 / 0 |
| Datendateien / Datentabellen | 15 / 30 |
| Rego-Dateien / Zeilen | 7 / 1715 |
| Generierte OPA-Tests | 60 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Der Generator brauchte mehrere Anläufe: Versuch 1 endete am Limit-Guard,
  Versuch 3 scheiterte an einem einzelnen Beleg, Versuch 5 bestand alle Gates.
- Auslegungsbedürftig laut `workspace/notes/assumptions.md` u. a.: ob nicht
  prämienfähige Flächen (sonstige Weinflächen, Walnüsse/Edelkastanien,
  unveredelte Obstanlagen) dem Herbizidverzicht unterliegen, die Zuordnung
  der Kürzung bei Überschreitung der Prämienobergrenze, die Abweichung
  zwischen Merkblatt und SRL bei der 50-%-Ausweitungsgrenze der
  Maßnahmenübernahme (implementiert nach SRL) und dass Schläge ohne
  Maßnahmencodes standardmäßig als für Maßnahme 11 beantragt gelten.
- Nicht berechnet, sondern als Eingabe erwartet: Herbizid-Einstufung laut
  AGES-Register, Plausibilität von Kauf-/Lagermengen, die AMA-Sanktionsstufe
  sowie bereits gekürzte andere Flächenzahlungen für die Obergrenze.
- Anhang L (Kombinationsmatrix) wurde aus PDF-Textkoordinaten rekonstruiert;
  Fehler in für Maßnahme 11 nicht relevanten Zellen sind möglich.
- Keiner der Hinweise 2026 enthält eine Ausnahme für Maßnahme 11; es bleibt
  nur der allgemeine Weg über höhere Gewalt.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
