# Draft: `o6_17` mit `claude-opus-5-5`

Status: **DRAFT – technisch finalisierter Discover-Kandidat, nicht fachlich freigegeben**

Dieser Run untersucht die Maßnahme `o6_17` (Humuserhalt und Bodenschutz auf umbruchsfähigem Grünland). Er liefert einen
quellengebundenen, ausführbaren Regelkandidaten. Die technische Validierung
belegt weder fachliche Vollständigkeit noch Rechtsverbindlichkeit oder eine
passende Empfehlung für einen konkreten Betrieb.

## Lauf

- Run-ID: `v2-o6_17-opus-5.5-high-20261002`
- Modus: `discover`
- Modell: `claude-opus-5-5` (Anthropic), Effort `high`, Adapter `claude-cli`
- Laufzeit: 34 min, 84 Turns; laut Claude Code
  733.701 Output-Tokens (davon 163.122 Thinking),
  Listenpreis-Äquivalent 39,87 USD
- Versuche: 3 (Fortsetzung derselben Sitzung mit dem Fehlerbericht von `finalize`, siehe `resumed_attempts` in `run.json`); Laufzeit und Tokens sind aufsummiert
- Limit-Guard: Versuch 1 wurde bei 2 % Restlimit kontrolliert beendet und
  nach dem Limit-Reset fortgesetzt. Versuch 2 bestand `finalize` wegen
  ungenutzter Quellenbelege und zweier nicht auffindbarer Zitate nicht;
  Versuch 3 behob das, startete bei 66 % und endete bei 64 % Restlimit
- Maßnahmenspezifische Quelle: `o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf`
- Weitere lokale, versionierte Quellen: Allgemeine Teilnahmebedingungen April
  2026, Sonderrichtlinie ÖPUL 2023 samt Anhängen und vier amtliche Hinweise
  aus 2026
- Technische Referenz: OPA `1.18.2`, lokal im Run-Workspace bereitgestellt

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 118 |
| Quellenbelege | 303 |
| Coverage-Einträge / offene Einträge | 133 / 1 |
| Vorgeschlagene Profil-Blattpfade | 68 in 37 Discover-Vorschlägen |
| Von Rego verwendete Eingabepfade / unbekannt | 2 / 0 |
| Datendateien / Datentabellen | 8 / 33 |
| Rego-Dateien / Zeilen | 10 / 1860 |
| Generierte OPA-Tests | 112 |
| OPA Formatierung / Strict-Compile / Tests | bestanden / bestanden / bestanden |
| Grounding-, Vertrags-, Cross-Link- und Belegprüfung | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die Kennzahl „verwendete Eingabepfade“ erfasst nur direkte `input.`-Zugriffe.
Zugriffe über Funktionsparameter oder lokale Variablen zählen nicht; die
tatsächlich benötigten Pfade sind in `rules/profile_changes.json` und den
Regelbedingungen belegt. Mit den Terra-Runs ist die Kennzahl daher nur
eingeschränkt vergleichbar.

## Offene fachliche Punkte

- Der Generator brauchte drei Anläufe: Versuch 1 endete am Limit-Guard,
  Versuch 2 scheiterte an acht keiner Regel zugeordneten Belegen und zwei
  nicht auffindbaren Zitaten, Versuch 3 bestand alle Gates.
- Ein Coverage-Eintrag bleibt `unresolved`: SRL 1.12.1.2 verweist für
  Flächen- und Tierabweichungen auf §§ 42–47 GSP-AV, die nicht im
  Quellpaket liegen. Auch höhere Gewalt (§ 6 GSP-AV) ist nur katalogisiert.
- Widersprüche zwischen Merkblatt und SRL wurden nach der SRL aufgelöst:
  Hangneigung ab 18 % wird nur für artenreiches Grünland (AGL) gefördert,
  die Grünlandzahl-Stufen folgen den SRL-Intervallen (`< 20`, `>= 20 und < 30`
  usw.), und die drei Weiterbildungsthemen sind nur katalogisiert, nicht
  als harte Bedingung umgesetzt.
- Auslegungsbedürftig laut `workspace/notes/assumptions.md` u. a.: die
  AGL-Obergrenze („jedenfalls aber 2,00 ha“) als Maximum mit proportionaler
  Kürzung, keine Kürzung des AGL-Zuschlags durch die
  Flächenzugangsbeschränkung ab 2026, Vorrang anderer Maßnahmen bei nicht
  kombinierbaren Schlägen laut Anhang L, die Bezugsfläche für den
  Grünlandanteil von 40 % sowie der nicht genannte maßnahmenbezogene OP-Code.
- Die Überschreitung der Flächenzahlungsobergrenze wird nur gemeldet; die
  Sanktionsstufe bleibt eine AMA-Bewertung und wird als Eingabe erwartet.
- Die Hinweise 2026 enthalten keine Erleichterungen für o6_17.

Die veröffentlichten Dateien enthalten die prüfbaren Regel-, Beleg-, Profil-,
Daten-, Test- und Validierungsartefakte. Rohlogs, kopierte Quellen und die
OPA-Binary bleiben aus Größen- und Reproduzierbarkeitsgründen unveröffentlicht;
ihre Identitäten und Prüfsummen sind in `run.json` und den Artefakten
festgehalten.
