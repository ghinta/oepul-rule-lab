# ÖPUL Discover Run: o6_24 — Wasserrahmenrichtlinie Landwirtschaft

Technisch finalisierter, fachlich weiterhin als Entwurf zu behandelnder
Discover-Run. Er wurde ausschließlich aus den versionierten lokalen amtlichen
Quellen erstellt.

## Run

- Run-ID: `20260930T004645Z__o6_24__gpt-5.6-terra`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahme: `o6_24` — Wasserrahmenrichtlinie Landwirtschaft
- maßgebliches Merkblatt: Stand Oktober 2025

## Ergebnis und Gates

- 21 strukturierte Regeln, 25 Quellenbelege und 44 Coverage-Einträge
- 3 Discover-Vorschläge für fehlende Profilinformationen
- 1 Datentabelle, 2 Rego-Dateien und 4 generierte Tests
- Grounding-, Cross-Link-, Evidence-, Coverage- und Profil-Gates bestanden
- technische OPA-Prüfung bestanden: Formatierung, Strict-Compile und 4/4
  Rego-Tests
- unabhängige Repository-Test-Suite bestanden: 39 Tests

## Dokumentierte Restunsicherheiten

- Die verbindlichen stickstoffbezogenen Grenzwerte liegen in der nicht
  bereitgestellten steirischen Grundwasserschutzverordnung. Die Policy erwartet
  daher den je Schlag belegten Grenzwert als Eingabe und erfindet keine Tabelle.
- Bezirksnamen in den Dürre-Daten sind ASCII-normalisiert und müssen bei der
  produktiven Eingabe entsprechend normalisiert werden.
- Maßnahmenspezifische Dürre-Ausnahmen werden nur modelliert, soweit sie die
  WRRL oder die allgemeine Acker-Erntepflicht tatsächlich betreffen.

Die veröffentlichten Artefakte enthalten die finalen Regeln, Daten, Tests,
Belege, Annahmen und Validierungsergebnisse. Rohlogs, lokale Quellenkopien,
die OPA-Binary sowie der temporäre Usage-Checkpoint sind nicht Teil des
Commits.
