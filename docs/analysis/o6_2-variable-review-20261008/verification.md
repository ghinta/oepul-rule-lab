# Verification

- 128 Blattpfade gegen unveränderte Vorher-/Nachher-Diffs geprüft.
- 149 wörtliche Originalfundstellen mit Quellhash und exakter PDF-Seite bzw.
  HTML-Text geprüft; zusätzlich acht erforderliche offene Fachfragen belegt.
- Gepinnte App-Codehashes und Zeilenauszüge gegen Commit
  `5296108f5756ef1463c25a49d93d4a346e9b5e9c` geprüft.
- 13 technische OPA-Beobachtungen mit synthetischen Daten reproduziert.
- Sechs gemeinsame Testmethoden mit maßnahmenbezogenen Negativfällen bestanden:
  Frageverlust/Schließen/Antwort, Blattverlust/Änderung/Alias, Originalbeleg,
  unreviewte Maßnahme und historische Beobachtungen.
- Gesamte Repository-Suite: 114 Tests bestanden; Vorinventar weiterhin
  26 Maßnahmen, 52 Runs und 129 vorläufige offene Fragegruppen.
- `git diff --check` sauber. GitHub-CI wird für den veröffentlichten Commit
  geprüft und im PR dokumentiert; sie enthält auch Validator- und OPA-Checks.

Kein vollständiger Helper-Konsum, keine Rechts-/Klauselfreigabe aller Regeln,
keine realen Betriebssnapshots, keine unabhängigen Golden-/App-End-to-End-Tests
und keine fachliche Aufnahme. Weiterhin 22 einzelne Maßnahmen ausstehend.
