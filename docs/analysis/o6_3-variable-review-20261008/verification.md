# Verification

- 96 Blattpfade (30 Luna, 65 neue und ein geänderter Opus-Blattwert) mit allen
  vorher/nachher-Werten und offenen semantischen Aufnahmezuständen geprüft.
- 107 von Vorschlägen referenzierte Fundstellen direkt gegen Originaltext,
  PDF-Seite bzw. HTML und Quellhash geprüft; acht zusätzliche offene Fachfragen.
- App-Codeauszüge gegen Commit `5296108f5756ef1463c25a49d93d4a346e9b5e9c`;
  vorhandene Adaptations-/Schema-/Vertrags-/Entwicklungsproben-Dateien unverändert
  mit Hash gebunden. Alle acht bestehenden Promotionsblocker weiterhin offen.
- Elf zusätzliche synthetische Rohmodell-/App-OPA-Proben reproduziert;
  bestehende Adaptationsproben werden durch die vorhandene Suite geprüft.
- Gemeinsame Integritäts-/Negativtests prüfen jetzt o6_2 und o6_3 separat;
  wörtlicher Originalbeleg mit absichtlich falscher PDF-Seite wird abgelehnt.
- Gesamte Repository-Suite: 114 Tests bestanden. Vorinventar unverändert;
  `git diff --check` sauber. GitHub-CI wird am veröffentlichten Commit geprüft.

Keine vollständige normative Freigabe, kein vollständiger Helper-Konsum,
keine realen Betriebssnapshots, keine unabhängigen Golden-/App-End-to-End-Tests,
keine App-Aufnahme. Nach diesem Slice sind 21 weitere Maßnahmen einzeln offen.
