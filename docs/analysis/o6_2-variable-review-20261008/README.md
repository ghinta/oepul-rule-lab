# o6_2: Einschränkung ertragssteigernder Betriebsmittel

Individuelle Aufnahmeprüfung nach UBB, BIO und NPA/AFS. **Fachliche Aufnahme
offen, keine App-Promotion.** Beide finalisierten historischen Runs bleiben
unverändert. Der vollständige [Vorher-/Nachher-Diff](../all-measure-variable-review-20261008/o6_2/diff.md)
enthält alle Originalwerte, Vorschlags-, Regel- und Quellen-IDs.

| Grundlage | Luna 5.6 | Opus 5.5 |
| --- | --- | --- |
| Run | `v2-o6_2-luna-high-20260930` | `v2-o6_2-opus-5.5-high-20260930` |
| Änderungsanträge / neue Blattpfade | 23 / 56 | 26 / 72 |
| Geänderte / entfernte Blattwerte | 0 / 0 | 0 / 0 |
| Katalogregeln | 39 | 82 |

Alle **128 modellbezogenen Blätter** werden in zehn Sachgruppen in
`leaf-review.json` erfasst. Keine gemeinsame neue Pfadschreibweise, keine
automatische semantische Gleichsetzung. Typnotationen sind keine Defaults.

Das Maßnahmenblatt April 2026 wurde auf allen acht Seiten einschließlich
Prämientabelle, RGVE-Tabelle und Änderungen gelesen; dazu SRL PDF-Seiten 48–49,
Anhang A PDF-Seite 3, Kombinationstabelle Anhang L PDF-Seite 103 und die vier
bereitgestellten 2026-Mitteilungen. Bereits geprüfte gemeinsame ATB-Definitionen
bleiben an den unveränderten April-2026-Quellhash gebunden. **149** von Vorschlägen
referenzierte Fundstellen wurden maschinell direkt gegen Original-PDF-Seiten
oder HTML samt Quellhash geprüft. Das bestätigt Auffindbarkeit, keine vollständige
normative Freigabe aller 121 Katalogregeln oder jeder Tabellenzelle.

Der App-Bezug bleibt Commit `5296108f5756ef1463c25a49d93d4a346e9b5e9c`.
Die App referenziert im DecisionTrace noch Oktober 2025 mit Hash
`4ead94a73f858465fb3e12be8045b644c81b3179afd8fdcaa3093fdac594627a`;
beide Runs April 2026 mit Hash
`019bab30ef890a76918a9041268fa3d299ba2d9395d61810e1ce5ce9e00e4e1c`.
April 2026 nennt insbesondere den Wegfall der PSM-Codierung ab 2026.
Neue amtliche Veröffentlichungen nach diesem Quellenpaket sind nicht geprüft.

[Pfad-/Scopevergleich](path-review.md) und [13 reproduzierte OPA-Proben](policy-findings.md)
belegen erhebliche Integrationslücken. Die App bleibt selbst bei gefüllten
Platzhalter-Eingaben konservativ `missing_data`; eine vollständige o6_2-Prüfung
existiert dort noch nicht. Historische Policy-Ausgaben sind Beobachtungen, keine
Golden-Sollwerte. Vollständiger Helper-/Alias-Konsum bleibt offen.

Acht [Expertenfragen](questions.md) präzisieren die fünf vorläufigen o6_2-Fragen
im Sammelissue #140. Bestehende IDs bleiben offen. Aktuelles Jahr, Datenstand,
Betreiber-/Expertenbelege, unknown und confirmed-empty müssen explizit sein.
Eine Neuaufnahme 2026 ist aus dem vorliegenden Blatt nicht ableitbar; laufender
Vertrag oder zulässige Übernahme benötigen tatsächliche Nachweise.

Mögliche Wiederverwendung: RGVE-Kohorten aus #137, Kurs-/Personenbelege aus
UBB/BIO und datierte Mittel-/Anwendungsereignisse aus NPA/AFS. Gemeinsame
Erfassung bedeutet keine gemeinsame Berechnungsbasis oder gleiche Zulässigkeit.
Keine Fachantwort, App-, Thesis-, Quellen- oder Run-Änderung; kein Merge.

```bash
python tools/review_individual_measure.py --measure o6_2 --opa-bin /path/to/opa
python tools/review_individual_measure.py --measure o6_2 --app-root /path/to/oepul-recommender
```
