# o6_1b (BIO): einzelne Variablenprüfung

Status: **Einzelprüfung für die Aufnahmevorbereitung dokumentiert; fachliche
Aufnahme offen.** Keine neue Regel, kein App-Pfad und kein Modell-Default ist
freigegeben. Die übrigen 24 Maßnahmen nach UBB und BIO bleiben einzeln ungeprüft.

Die frühere Meldung, alle Maßnahmen seien abgearbeitet, war zu weitgehend:
[das Vorinventar](../all-measure-variable-review-20261008/README.md) ersetzt diese
Prüfung nicht. Dieser Slice betrifft ausschließlich BIO.

## Gegenstand und Nachweise

| Grundlage | Luna 5.6 | Opus 5.5 |
| --- | --- | --- |
| Run | `v2-o6_1b-luna-high-20260930` | `v2-o6_1b-opus-5.5-high-20260925` |
| Profiländerungsanträge | 95 | 89 |
| Neue Blattpfade | 95 | 192 |
| Geänderte/entfernte Blattwerte | 0 / 0 | 0 / 0 |
| Von Anträgen referenzierte, überprüfte Quellenbelege | 53 | 182 |

Beide Runs verwenden dieselbe unveränderte Baseline. Der vollständige
[Vorher-/Nachher-Diff](../all-measure-variable-review-20261008/o6_1b/diff.md)
und seine Regel-/Quellen-IDs bleiben erhalten. [leaf-review.json](leaf-review.json)
ordnet **alle 287 Blattpfade** den zwölf Sachgruppen des
[Pfadvergleichs](path-review.md) zu. Diese Gruppierung ist ein Index für die
fachliche Prüfung, keine bestätigte Aliasliste und kein zugelassenes App-Schema.

Die 235 modellbezogenen Belege werden mit Hash und PDF-Seite beziehungsweise
HTML-Text direkt gegen die Originaldateien geprüft, nicht lediglich gegen
Modellnotizen. Alle Zitate sind auffindbar. Das beweist die Fundstelle, **nicht**
die korrekte Interpretation oder Vollständigkeit aller 243 extrahierten Regeln.
Für die Befunde werden zusätzlich die betreffenden Quellabschnitte verglichen.

App-Stand ist Commit `5296108f5756ef1463c25a49d93d4a346e9b5e9c` nach #137.
[app-code-evidence.json](app-code-evidence.json) enthält zeilengebundene Auszüge
und vollständige Dateihashes von Adapter, Policy und Evidenzregistries.
Es enthält keine realen Betriebsdaten. Die vorhandene App-Schema-/CSV-Aufnahme
steht weiterhin im Vorinventar; ein registriertes Feld gilt erst nach Prüfung
seiner Projektion und seines Regelzugriffs als verwendet.

## Ergebnis

**Die historischen BIO-Policies eignen sich noch nicht für eine direkte
App-Übernahme.** [policy-findings.md](policy-findings.md) dokumentiert unter anderem
ein hartes Luna-Jahr-Default, eine immer positiv ausfallende Feldstücksprüfung,
umgangene Monitoringvoraussetzungen und einen vorverlegten Opus-DIVNFZ-Termin.
Acht direkte OPA-Proben reproduzieren diese Beobachtungen read-only.

Die App führt derzeit nur eine Phase-1-BIO-Prüfung aus. Ihre Meldung `eligible`
belegt keine vollständig geprüfte BIO-Teilnahme. Sie reicht weder für
Teilbetriebs-/Kontrollvertragsprüfung noch für Management, RGVE, Schulung und
Zuschläge. Zudem referenziert ihr DecisionTrace Oktober 2025, die Runs April 2026.

Elf präzisierte [Expertenfragen](questions.md) bleiben offen. Sie konkretisieren
die fünf vorläufigen BIO-Fragen im Sammelissue #140; die ursprünglichen Fragen
werden dadurch weder gelöscht noch beantwortet. Fachliche Konflikte gehören zu
den Experten; belegte technische Fehlprüfungen können später gezielt repariert
werden, ohne diese Konflikte stillschweigend zu entscheiden.

## Grenzen und Fortsetzung

Nicht erledigt sind eine vollständige normative Klauselprüfung aller Regeln,
vollständiger statischer Helper-/Alias-Konsum, Modellqualitätsbewertung durch
unabhängige Golden Tests und Tests mit realen Betriebssnapshots. Die Proben
verwenden synthetische Daten und sind keine bewerteten Modellläufe.

Vor Umsetzung: Expertenantwort → bestätigte Definition/Einheit/Zeitbasis →
konkreter App-Pfad und Snapshot-/Evidenzherkunft → verlustfreier Adapter →
Regelzugriff → unabhängige Grenzfall- und Integrationsprüfung. Der aktuelle
Antragsjahres-/Datenstand bleibt maßgeblich; zukünftige Empfehlungen werden
gesondert begründet und nicht als aktuelle Förderfähigkeit ausgegeben.

Keine weiteren Maßnahmen werden in diesem Slice als einzeln geprüft markiert.
PR #103 bleibt Draft/offen; ein Merge braucht eine eigene Freigabe.

```bash
python tools/review_o6_1b_variable_review.py
python tools/review_o6_1b_variable_review.py --opa-bin /path/to/opa
python tools/review_o6_1b_variable_review.py --app-root /path/to/oepul-recommender
python -m unittest discover -s tests -p test_o6_1b_variable_review.py -v
```
