# Prüfung und offene Grenzen

- 95 Repository-Tests bestanden, einschließlich sechs neuer Regressionen gegen
  fehlende Modelle/Blattpfade, veränderte Quellenbindung, ungefragte Promotion
  und verschwundene oder stillschweigend geschlossene Fragen.
- 11 OPA-Validator-Tests bestanden.
- Read-only Dossier-Check reproduziert 81 Luna-/67 Opus-Anträge sowie
  91 neue Luna-/190 neue und einen geänderten Opus-Blattpfad.
- App-Schema-/Registry-/Dependency-Kopie und Code-Hashes gegen den gepinnten
  App-Commit nach #137 geprüft; keine realen Betriebswerte kopiert.
- Beide zitierten Pheromon-Belege sind auf den exakten PDF-Seiten auffindbar;
  PDF-Versionen stimmen mit den ursprünglichen Opus-Quellenhashes überein.
- Historische Run-/Baseline-/Regel-/Tabellen-/Testdateien sind hashgebunden
  und unverändert. `git diff --check` bestanden.

CI führt den Dossier-Check zusätzlich zu den bestehenden Repository-, Validator-,
o6_3-Dossier- und OPA-Gates aus. Der exakte Remote-Stand steht im Entwurf-PR.

Keine App-Variablen aufgenommen, keine Aliasregeln freigegeben und keine
vollständige o6_1a-Consumption-/Quellen-/Förderfähigkeitsabnahme. Die leere
Opus-Pfadanalyse trotz direkter Eingabezugriffe bleibt ein technischer Blocker.
Alle Modellannahmen bleiben unbestätigt. Antworten auf Feldstücksidentität und
Pheromon-Aufbewahrung stehen aus. Diese Fragen blockieren abhängige
Aufnahmeentscheidungen; o6_1b beginnt nach Abschluss oder explizitem
Zurückstellen dieses Maßnahmenslices.
