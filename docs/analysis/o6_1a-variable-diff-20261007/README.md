# o6_1a (UBB): erster sequenzieller Variablenabgleich

Auftrag: [App #139](https://github.com/ghinta/oepul-recommender/issues/139),
Maßnahmenslice: [Lab #101](https://github.com/ghinta/oepul-rule-lab/issues/101).
Branch: `codex/issue-139-o6-1a-variable-diff`.

## Vorher / nachher

Der vollständige [Diff](diff.md) zeigt die unveränderte gemeinsame Run-Baseline
gegen die jeweiligen Luna-/Opus-Profilvorschläge. `variable-diff.json` verbindet
jeden geänderten Blattpfad mit seinen Änderungsanträgen, Regel-IDs und originalen
Quellenreferenzen. Die vorhandene App-Schema-/Registry-Deklaration steht daneben.
Ein Vorschlag ist keine beschlossene oder implementierte App-Änderung; numerische,
boolesche und Text-Beispielwerte sind keine zulässigen Defaults bei fehlenden Fakten.

| Modell | Änderungsanträge | Neue Blattpfade | Geänderte Blattpfade |
| --- | ---: | ---: | ---: |
| Luna 5.6, `v2-o6_1a-luna-high-20260930` | 81 | 91 | 0 |
| Opus 5.5, `v2-o6_1a-opus-5.5-high-20260929` | 67 | 190 | 1 |

Die Zahl der Anträge ist weder die Zahl unabhängiger fachlicher Variablen noch
ein Qualitätsmaß. Ein Objekt-Antrag kann mehrere Blattpfade hinzufügen.
Beide Runs sind als Generation 3 finalisiert und verwenden dieselbe Baseline
mit SHA-256 `768688efd4ef3fd21bf7007d40532dfde77f0699401373371f2dfae75f848792`.
Die angekündigte neue Opus-Revision ist nicht Bestandteil dieses Vergleichs.

## App-Grundlage und Grenzen

`app-baseline.json` bindet App-Commit
`5296108f5756ef1463c25a49d93d4a346e9b5e9c` nach #137. Erfasst sind Schema,
skalare/Schlag-/Tierregistries und o6_1a-Dependencies; Code-Hashes binden die
Collections, Adapter und AMA-Ableitung. Die erfassten Deklarationen sind kein
vollständiger Laufzeit-/Snapshot-Inhalt und keine semantische Gleichheitsprüfung.
Die Python-Collection-Registry ist durch Codehash gebunden, nicht vollständig
als CSV- oder Blattinventar exportiert. Reale Betriebswerte werden nicht kopiert.

Die Aufnahme- und Pfadentscheidungen stehen in [path-review.md](path-review.md).
Der komplette ursprüngliche Annahmentext beider Modelle ist im JSON erhalten;
keine dieser Annahmen ist übernommen oder fachlich freigegeben. Quellenreferenzen
sind technisch auflösbar; eine vollständige normative Prüfung aller UBB-Klauseln
ist mit diesem mechanischen Diff noch nicht erledigt.

## Technische Lücke im Consumption-Nachweis

Opus meldet in `artifacts/input-paths.json` null Pfade. Auch der aktuelle
Lab-Extraktor reproduziert null, obwohl `common.rego` unter anderem
`object.get(input, ["farm", "year"], 0)` verwendet. Die Fundstellen stehen
unter `literal_object_get_input_sites`. Diese Zusatzsuche findet nur direkte
Zugriffsstellen, nicht vollständig alle Helper-, Alias- und Array-Blattpfade.
Für beide Modelle bleibt `consumption_review_status: incomplete_static_analysis`.
Eine vollständige Consumption-/Profilvalidierung oder App-Promotion ist damit
ausdrücklich nicht nachgewiesen. Der Scanner wird in diesem Diff-Slice nicht
repariert; die Lücke blockiert die betreffende Aufnahmeentscheidung.

## Reproduzieren

```bash
python tools/review_o6_1a_variable_diff.py
python tools/review_o6_1a_variable_diff.py --app-root /path/to/oepul-recommender
python -m unittest discover -s tests -p test_o6_1a_variable_diff.py -v
```

`--write` erzeugt ausschließlich das Dossier neu. Historische Runs, Baselines,
Quellen, App-Registries und Thesis werden nicht verändert. `source-manifest.json`
bindet alle verwendeten historischen Artefakte, Policy-, Tabellen- und Testdateien
sowie die App-Aufnahme; CI prüft Hashes und reproduzierbare Ausgaben read-only.
Ein erfolgreicher Dossier-Check gibt keine Förderregel oder App-Variable frei.
