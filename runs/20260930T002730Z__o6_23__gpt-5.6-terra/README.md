# ÖPUL Discover Run: o6_23 — Natura-2000 Landwirtschaft

Technisch finalisierter, aber fachlich weiterhin als Entwurf zu behandelnder
Discover-Run. Er wurde ausschließlich aus den versionierten lokalen amtlichen
Quellen erstellt.

## Run

- Run-ID: `20260930T002730Z__o6_23__gpt-5.6-terra`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahme: `o6_23` — Natura-2000 Landwirtschaft
- maßgebliches Merkblatt: Stand Oktober 2025

## Ergebnis und Gates

- 22 strukturierte Regeln, 25 Quellenbelege und 27 Coverage-Einträge
- 7 Discover-Vorschläge für fehlende Profilinformationen
- 2 Datentabellen, 2 Rego-Dateien und 7 generierte Tests
- Grounding-, Cross-Link-, Evidence-, Coverage- und Profil-Gates bestanden
- technische OPA-Prüfung bestanden: Formatierung, Strict-Compile und 4/4
  Rego-Tests
- unabhängige Repository-Test-Suite bestanden: 39 Tests

## Dokumentierte Restunsicherheiten

- Die schlag- und landesspezifische Projektbestätigung bleibt die Quelle für
  konkrete Auflagen und Termine; diese werden als Eingaben geprüft und nicht
  erfunden.
- Zusätzliche Einzelfallauflagen aus Projektbestätigungen bleiben offen.
- Die Dürre-Ausnahme 2026 gilt nur konditional nach Anpassung der zugrunde
  liegenden Landesverordnung.

Die veröffentlichten Artefakte enthalten die finalen Regeln, Daten, Tests,
Belege, Annahmen und Validierungsergebnisse. Rohlogs, lokale Quellenkopien und
die OPA-Binary sind absichtlich nicht Teil des Commits.
