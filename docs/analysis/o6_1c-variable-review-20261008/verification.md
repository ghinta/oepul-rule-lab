# Verification

Lokale Prüfung am 08.10.2026, App-Bezug fest auf
`5296108f5756ef1463c25a49d93d4a346e9b5e9c`:

- 150 modellbezogene Blattpfade gegen die unveränderten Vorher-/Nachher-Diffs geprüft.
- 97 zitierte Originalfundstellen mit Seite, wörtlichem Text und SHA-256 geprüft.
- App-Codeauszüge und unveränderte Policy-Kopie gegen `git show` geprüft.
- Lunas 20 direkte Blattzugriffe und 42 nicht gelesene Blätter reproduziert;
  vollständiger Opus-Helper-Konsum bleibt ausdrücklich offen.
- Zehn erforderliche Expertenfrage-IDs, offene Zustände, fehlende Antworten und
  Abdeckung aller acht Sachgruppen gesichert.
- 13 OPA-Beobachtungen mit synthetischen Inputs reproduziert, darunter zwei
  aktuelle App-Policy-Proben. Beobachtungen sind keine Golden-Erwartungen.
- 108 Repository-Tests bestanden, einschließlich sechs neuer Testmethoden für
  diesen Slice mit Lösch-/Status-/Alias-/Beleg-/Zugriff-Negativfällen.
- 11 Validator-Regressionstests bestanden. Heuwirtschaft-Contract weiterhin mit
  acht offenen Blockern; OPA 1.18.2 Format/strikte Kompilierung/Tests sowie 3/3
  direkte Adaptations-Guards bestanden.
- Vorinventar der 26 Maßnahmen/52 Runs/129 vorläufigen Fragegruppen unverändert
  reproduzierbar; `git diff --check` bestanden.

Die Checks sichern Herkunft, Beobachtungen und offene Aufnahmeentscheidungen.
Sie ersetzen keine vollständige Rechts-/Klauselprüfung, keine Fachantworten,
keine realen Betriebssnapshots und keine App-End-to-End- oder unabhängigen
Golden Tests. Historische Quellen und Runs wurden nicht verändert. Die weiteren
23 Maßnahmen sind weiterhin einzeln ausstehend. CI für den veröffentlichten
Commit wird zusätzlich in PR #103 dokumentiert.
