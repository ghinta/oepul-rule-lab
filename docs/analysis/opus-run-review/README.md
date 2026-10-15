# Opus-Runs einzeln prüfen

Stand 15.10.2026. Die bisherige technische
[Sichtung aller 26 Kandidaten](../opus-screening-20261011/README.md) ist keine
vollständige fachliche Quellenprüfung aller Runs. Dass die Kandidaten
kompilieren oder bestimmte Ausgaben reproduzieren, belegt keine Förderfähigkeit.

Die gesamte Runde wird in [Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112)
und im vorhandenen Branch `codex/opus-o6-1a-source-audit` mit
[PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111) gesammelt.
Der Branchname stammt aus dem ersten UBB-Dossier. Für weitere Maßnahmen
werden keine eigenen Prüfbranches oder Implementierungs-PRs angelegt.
Zunächst werden ausschließlich Befunde erhoben. Nach dem Gesamtdurchgang
werden wiederkehrende Ursachen, Synergien und mögliche gemeinsame Lösungen
zusammen durchgesehen. Regelcode-Reparaturen sind kein Teil dieser Sammlung.

Diese Runde prüft **einen historischen Run nach dem anderen**. Innerhalb eines
Runs können Quelltexte, Tabellen und Eingaben arbeitsteilig geprüft werden.
Erst nach seinem dokumentierten Prüfabschluss wird der nächste Run begonnen.
Der Abschluss kann erhebliche Blocker ergeben und bedeutet keine automatische
App-Übernahme oder Abnahme durch GM/Domainexpert:innen.

Aktuell: **2 Einzelprüfungen abgeschlossen und blockiert, 24 ausständig;
keine Expertenfreigabe und keine App-Promotion aus dieser Runde.**

| Reihenfolge | Run / Maßnahme | Status |
|---|---|---|
| 1 | [o6_1a – UBB](../opus-o6-1a-audit-20261015/README.md) | Quellen-, Regeln-, Tabellen- und Eingabeprüfung dokumentiert; konkrete Fehler, Übernahme blockiert. |
| 2 | [o6_1b – Biologische Wirtschaftsweise](measures/o6_1b/README.md) | Alle 200 Regeln, 92 Tabellen, 89 Eingabevorschläge und 107 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 3 | o6_1c – Nichtproduktive Ackerflächen und Agroforststreifen | Einzelprüfung in Bearbeitung. |
| 4–26 | o6_2 bis o6_24, aufsteigend | Jeweilige Einzelprüfung ausständig. |

[queue.json](queue.json) bindet für jede der 26 Positionen die exakte Run-ID und
den Kandidatencommit. Bestehende Quellenreviews manueller Adaptationen oder
öffentlicher Studienaufgaben ersetzen keine Prüfung dieser nativen Roh-Runs.

Jeder Einzelbericht soll Originalquellen und Versionskonflikte, alle katalogisierten
Regeln und ergänzende Quellpflichten, vollständige Tabellen, reale Eingabe-/
Ausgabeform, vorhandene App-Abbildung sowie eigens aus Quellen abgeleitete
Gegen- und Grenzfälle zeigen. Fehlende Nachweise, Fehler, Nullwerte und offene
Auslegungen bleiben getrennt sichtbar. Private Studienreferenzen werden nicht
eingesehen; historische Runs, Quellen und Canonical-Profile bleiben unverändert.
