---
title: "o6_1a: Variablen vor der App-Aufnahme vergleichen"
status: draft
issue: "https://github.com/ghinta/oepul-rule-lab/issues/101"
parent_issue: "https://github.com/ghinta/oepul-recommender/issues/139"
---

Der o6_3-Pilot ersetzt den Variablenabgleich der übrigen Maßnahmen nicht.
Der Nutzer verlangt eine Maßnahme nach der anderen, einen Vorher-/Nachher-Diff
und sofortige Fragen bei Unsicherheiten. o6_1a beginnt die Reihenfolge.

Das Dossier hält historische Luna-/Opus-Vorschläge getrennt, expandiert ihre
Blattdiffs und stellt die aktuelle App-Deklaration nach #137 daneben. Regel-
und Quellen-IDs sowie Hashes machen die mechanische Erfassung reproduzierbar.
Beispielwerte werden nicht zu Missing-Data-Defaults. Namensähnlichkeit ergibt
keine fachliche Gleichheit und keine automatische Aufnahme.

Lunas Aggregate und Opus' Schlag-/Ereignisobjekte unterscheiden sich strukturell.
Der vorgeschlagene Wechsel annual/multi_year → DIV-Codes ändert eine Dimension.
Feldstücksidentität und Pheromon-Aufbewahrung wurden sofort erfragt und bleiben
offen. Alle vorhandenen Modellannahmen bleiben unbestätigt.

Opus' leerer Input-Pfadbericht ist trotz direkter Eingabezugriffe reproduzierbar.
Die technische Consumption-Lücke wird sichtbar gebunden, nicht durch eine
unvollständige Regex-Liste als geschlossen ausgegeben. Keine Registry-, Policy-,
Snapshot-, historischen Run-, Canonical-Profil- oder Thesis-Änderung.

Regressionschecks schützen vor verschwundenen Diffpfaden, fehlenden Modellen,
geänderten Quellenbindungen und stillschweigender Promotion. CI prüft das
Dossier read-only. Aufnahmeentscheidungen bleiben bis fachlicher und technischer
Klärung offen; dieser Entwurf ist keine vollständige UBB-Förderprüfung.
