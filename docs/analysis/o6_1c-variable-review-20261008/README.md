# o6_1c: individuelle Aufnahmeprüfung für NPA und Agroforststreifen

Status: Quellen-/Pfadvergleich und technische Befunde dokumentiert;
**fachliche Aufnahme offen, keine App-Promotion**. Dieser Slice behandelt nur
o6_1c. Nach UBB, BIO und diesem Slice bleiben 23 Maßnahmen einzeln ausstehend.
Die vorhandene o6_3-Adaptation bleibt davon getrennt und hat offene Fachblocker.

## Vorher / nachher

| Grundlage | Luna 5.6 | Opus 5.5 |
| --- | --- | --- |
| Run | `v2-o6_1c-luna-high-20260930` | `v2-o6_1c-opus-5.5-high-20260925` |
| Änderungsanträge | 58 | 11 |
| Neue Blattpfade | 62 | 88 |
| Geänderte/entfernte Blattwerte | 0 / 0 | 0 / 0 |
| Von Anträgen referenzierte Originalfundstellen | 36 | 61 |

Beide Runs sind finalisiert und verwenden die unveränderte gemeinsame Baseline
mit SHA-256 `768688efd4ef3fd21bf7007d40532dfde77f0699401373371f2dfae75f848792`.
Der vollständige [Diff](../all-measure-variable-review-20261008/o6_1c/diff.md)
zeigt alle Werte vorher/nachher. Die ursprünglichen Anträge, Regel-IDs und
Quellenreferenzen bleiben im dortigen JSON erhalten.
[leaf-review.json](leaf-review.json) erfasst alle **150 modellbezogenen Blätter**
in acht Sachgruppen. Zwei Pfade haben dieselbe Schreibweise; keine semantische
Gleichheit und kein Alias sind dadurch freigegeben. Beispiel-/Typnotationen
werden nicht zu Defaults für fehlende Tatsachen.

## Quellen und tatsächliche Verwendung

Das Maßnahmenblatt Oktober 2025 wurde auf allen fünf Seiten gelesen; dazu der
vollständige 1C-Abschnitt der SRL, die Kombinationstabelle und die einschlägigen
allgemeinen Teilnahme-/Flächen-/Antrags-/Zahlungsabschnitte. Alle **97** von den
Vorschlägen referenzierten Zitate wurden direkt gegen Original-PDF-Seiten bzw.
HTML-Text samt Quellhash geprüft. Alle sind auffindbar. Das ist eine
Fundstellenprüfung, keine vollständige normative Freigabe aller 143 Run-Regeln.

Der [Pfadvergleich](path-review.md) stellt Entität, Einheit, zeitlichen Scope,
Modellstrukturen und tatsächliche App-Projektion gegenüber. App-Grundlage ist
Commit `5296108f5756ef1463c25a49d93d4a346e9b5e9c` nach #137. Codeauszüge und
Hashes stehen in `app-code-evidence.json`; `app-policy.rego` ist eine unveränderte
Quellkopie für reproduzierbare App-Policy-Proben, keine integrierte Adaptation.
Der App-DecisionTrace und beide Runs referenzieren dasselbe Maßnahmen-PDF mit
Hash `ec55abec48b67941fbf8a73b7b2d052dea8ec7f2ad26655cf90220c15ab39a9a`.
Das beweist keinen Abgleich mit später veröffentlichten amtlichen Fassungen.

Lunas einziges Policy-Modul liest 20 der 62 vorgeschlagenen Blätter; für die
anderen 42 gibt es dort keinen Zugriff. Die Fundstellen sind einzeln erfasst.
Ein Katalogeintrag oder Profilvorschlag ist somit kein Umsetzungsnachweis.
Opus verwendet lokale Helper/Aliase; sein vollständiger Konsumnachweis bleibt
offen. Der bisherige Scanner meldet nur fünf Pfade; elf Katalogbedingungen
besitzen keine `input_paths`-Deklaration. Eine vollständig validierte
Consumption-/App-Promotion wird daraus nicht abgeleitet.

## Ergebnis und offene Entscheidungen

**Keine direkte Übernahme der historischen Policies in die App.**
[Dreizehn OPA-Proben](policy-findings.md), einschließlich zweier Proben der
aktuellen App-Policy, belegen konkrete Integrationsrisiken. Unter anderem:
Luna-`eligible` trotz eigener Verletzungsmeldungen, unerkannte Arten einer
gelisteten Gattung, fehlender Baumabstand ohne Opus-Definitionsfehler,
Pflegeprüfung ohne Jahresabschluss und ein positives Prämienband trotz
bekannter Düngung. Ein Prämienband ist keine bestätigte Auszahlung.

Die App verwendet nur eine Phase-1-Prüfung mit Ackerfläche und zwei Schlagflags.
Sie konsumiert keine NPA-Pflegeereignisse oder eigenständige AFS-Collection.
Ein positives Kennzeichnungsflag ist keine umfassende Förderprüfung. Ein AFS
als Element außerhalb der Acker-Schlagliste wird von dieser Logik nicht erkannt.

Zehn [präzisierte Expertenfragen](questions.md) konkretisieren die bisherigen
fünf vorläufigen o6_1c-Fragen im Sammelissue #140. Originale Frage-IDs bleiben
erhalten und offen. Kategorie-/Vertragsnachweise, Streifen-/Feldstücksidentität,
Teilflächen, Pflegehistorie, Mittelzulassung, GSP-AV, Codes und Kombinationen
werden weder durch Namensähnlichkeit noch durch fehlende Eingaben entschieden.

## Nächster Implementierungsschritt nach Klärung

Bestätigte Fachdefinition → zugelassener Pfad mit Scope/Einheit/Zeitbezug →
aktueller Snapshot samt datierten Betreiber-/Expertenbelegen → verlustfreie
Projektion → tatsächlicher Regelzugriff und Ergebnisvertrag → unabhängige
Grenzfall-/Integrationstests. Antrag für ein Folgejahr ist gegebenenfalls eine
begründete zukünftige Möglichkeit; aktuelle Förderfähigkeit bleibt an das
aktuelle Antragsjahr und den tatsächlichen Datenstand gebunden.

Nicht erledigt: vollständige Klausel-/Tabellenfreigabe, vollständiger Opus-
Helper-Konsum, unabhängige Golden Tests, reale Betriebssnapshots und App-End-to-
End-Implementierung. Technische Proben benutzen synthetische Daten und erzeugen
keinen neuen Modelllauf. Quellen, Baseline, Run-Dateien, App und Thesis bleiben
unverändert. PR #103 bleibt Draft/offen, kein Merge.

```bash
python tools/review_o6_1c_variable_review.py
python tools/review_o6_1c_variable_review.py --opa-bin /path/to/opa
python tools/review_o6_1c_variable_review.py --app-root /path/to/oepul-recommender
python -m unittest discover -s tests -p test_o6_1c_variable_review.py -v
```
