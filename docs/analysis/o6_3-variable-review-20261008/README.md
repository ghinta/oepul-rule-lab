# o6_3: individuelle Luna-/Opus-Aufnahmeprüfung und Adaptationsvergleich

**Fachliche Aufnahme offen.** Dieser Slice ergänzt die bestehende
[Heuwirtschaft-Vertragsprüfung](../o6_3-variable-contract-20261007/README.md),
ersetzt sie nicht und schließt keinen ihrer acht Promotionsblocker.

| Historischer Run | Vorschläge | Neue / geänderte Blattwerte | Katalogregeln |
| --- | --- | --- | --- |
| Luna `v2-o6_3-luna-high-20261001` | 23 | 30 / 0 | 29 |
| Opus `v2-o6_3-opus-5.5-high-20260930` | 34 | 65 / 1 | 74 |

Der [vollständige Diff](../all-measure-variable-review-20261008/o6_3/diff.md)
und `leaf-review.json` erfassen **96 modellbezogene Blätter** in neun Sachgruppen.
Opus erweitert auch den bestehenden `species`-Enum um Wild/Neuweltkamele;
diese Schemaänderung wird nicht automatisch übernommen. **107** von Vorschlägen
referenzierte Fundstellen wurden direkt gegen Original-PDF-Seite/HTML und
Quellhash geprüft. Keine normative Freigabe aller 103 Katalogregeln.

Das Maßnahmenblatt Oktober 2025 (alle sechs Seiten), SRL PDF-Seite 50 und
Anhang A/PDF-Seite 3 wurden einschließlich Tabellen und Ausnahmen abgeglichen;
Anhang L/PDF-Seite 103 und die bereits geprüften 2026-Mitteilungen bleiben
im jeweiligen Scope berücksichtigt. App-DecisionTrace und beide Runs verwenden
das identische Maßnahmen-PDF mit Hash
`50349d5f574a60c20d156f8bad2217d5807bdb9c2aa231133353214fe71354c5`.
Spätere amtliche Fassungen und angekündigte neue Opus-Revisionen sind damit
nicht als geprüft behauptet.

[Pfad-/Entitätsvergleich](path-review.md) und [elf technische Proben](policy-findings.md)
trennen Rohmodelle, bestehende Lab-Adaptation und App am gepinnten Commit
`5296108f5756ef1463c25a49d93d4a346e9b5e9c`. Die Adaptation hat bereits einen
strengeren Vertrag und 20 RGVE-Kategorien, ist aber kein voll integrierter
App-Recommender. Technisch vorhandene RGVE-Kohorten in der App werden vom
aktuellen Maßnahmenadapter nicht projiziert. o6_3 bleibt im geprüften App-Stand
Category C, selbst bei gefüllten Mahd-/Bewirtschaftungsereignissen.

Acht [präzisierte Expertenfragen](questions.md) ergänzen die fünf vorläufigen
o6_3-Fragen. Die acht bestehenden IDs `GROUP_IDENTITY`, `COUNT_BASIS`,
`GREEN_FEEDING_HISTORY`, `RECOGNITION_TIME`, `GENERAL_FUNDING`, `ANNUAL_EVIDENCE`,
`SOURCE_CURRENTNESS`, `OPUS_REVISION` bleiben unverändert
`open_before_full_recommendation`. Die strukturelle Backend-Arbeit aus #137
ist kein Beweis für vollständige fachliche Klärung oder Adapter-Konsum.

Mögliche Synergie: Tier-/Schlagereignisse, Quellen-/Jahreskontext und datierte
Anerkennungen gemeinsam erfassen. o6_2 braucht jährliche Tierhalterstufen;
o6_3 benötigt zusätzlich historische Erstjahreszugangsnachweise und saisonale
Grünfütterung. Unterschiedliche RGVE-Kategorienschlüssel zwischen Runs müssen
explizit bestätigt gemappt werden, obwohl ihre Tabellen dieselben Tiere nennen.

Keine neue Policy-Implementierung, kein neuer Modelllauf, keine App-/Thesis-/
Quellen-/Run-Änderung und kein Merge. Vollständiger Helper-Konsum, Rechtsfreigabe,
reale Snapshots und unabhängige Golden-/App-End-to-End-Tests bleiben offen.

```bash
python tools/review_individual_measure.py --measure o6_3 --opa-bin /path/to/opa
python tools/review_individual_measure.py --measure o6_3 --app-root /path/to/oepul-recommender
```
