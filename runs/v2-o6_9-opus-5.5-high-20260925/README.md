# Draft: `o6_9` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_9` (Bodennahe Ausbringung flüssiger Wirtschaftsdünger und Gülleseparation). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_9-opus-5.5-high-20260925`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 28 min, 83 Turns; laut Claude Code
  652.587 Output-Tokens (davon 132.875 Thinking),
  Listenpreis-Äquivalent 31,10 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Start bei 54 %, letzte Messung
  51 % Restlimit; kein Abbruch
- Maßnahmenspezifische Quelle: `o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 96 |
| Quellenbelege | 222 |
| Coverage-Einträge / offene Einträge | 145 / 0 |
| Vorgeschlagene Profil-Blattpfade | 63 in 26 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 9 / 0 |
| Datendateien / Datentabellen | 8 / 37 |
| Rego-Dateien / Zeilen | 9 / 1407 |
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

- Drei Generatorversuche: Nach dem ersten scheiterten die Grounding-Gates, nach
  dem zweiten blieb eine falsche Zeilenzahl im Dateninventar; der dritte
  behob sie.
- Informationsblatt und SRL ordnen den Rohprotein-Durchschnittswert 157 g
  unterschiedlichen Schweine-Gewichtsgruppen zu (A-01); die Abweichung ist
  dokumentiert.
- Die Kombinationszeile 9 in Anhang L wurde aus dem Textextrakt rekonstruiert,
  weil die PDF-Seite nicht gerendert werden konnte; die symmetrische Spalte
  stützt das Ergebnis (A-14).
- Offene fachliche Fragen laut `workspace/notes/assumptions.md`: zulässige
  Wasseranteile, Ausbringung betriebsfremder Gülle, Umgang mit fehlenden
  Nachweisen, Übernahmefälle sowie die Zuordnung der Kürzung bei mehreren
  Verfahren über 50 m³/ha.
- Die 60 selbst erzeugten Tests sind keine Golden-, Hidden- oder
  Domainexpert:innen-Tests und decken nicht alle Regeln und Ausnahmen ab.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.

