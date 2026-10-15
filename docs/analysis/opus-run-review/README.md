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

Aktuell: **4 Einzelprüfungen abgeschlossen und blockiert, 22 ausständig;
keine Expertenfreigabe und keine App-Promotion aus dieser Runde.**

| Reihenfolge | Run / Maßnahme | Status |
|---|---|---|
| 1 | [o6_1a – UBB](../opus-o6-1a-audit-20261015/README.md) | Quellen-, Regeln-, Tabellen- und Eingabeprüfung dokumentiert; konkrete Fehler, Übernahme blockiert. |
| 2 | [o6_1b – Biologische Wirtschaftsweise](measures/o6_1b/README.md) | Alle 200 Regeln, 92 Tabellen, 89 Eingabevorschläge und 107 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 3 | [o6_1c – Nichtproduktive Ackerflächen und Agroforststreifen](measures/o6_1c/README.md) | Alle 97 Regeln, 22 Tabellen, 16 Vorschläge und 109 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 4 | [o6_2 – Einschränkung ertragssteigernder Betriebsmittel](measures/o6_2/README.md) | Alle 82 Regeln, 28 Tabellen, 26 Vorschläge und 157 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 5 | o6_3 – Heuwirtschaft | Einzelprüfung in Bearbeitung. |
| 6–26 | o6_4 bis o6_24, aufsteigend | Jeweilige Einzelprüfung ausständig. |

[queue.json](queue.json) bindet für jede der 26 Positionen die exakte Run-ID und
den Kandidatencommit. Bestehende Quellenreviews manueller Adaptationen oder
öffentlicher Studienaufgaben ersetzen keine Prüfung dieser nativen Roh-Runs.

Jeder Einzelbericht soll Originalquellen und Versionskonflikte, alle katalogisierten
Regeln und ergänzende Quellpflichten, vollständige Tabellen, reale Eingabe-/
Ausgabeform, vorhandene App-Abbildung sowie eigens aus Quellen abgeleitete
Gegen- und Grenzfälle zeigen. Fehlende Nachweise, Fehler, Nullwerte und offene
Auslegungen bleiben getrennt sichtbar. Private Studienreferenzen werden nicht
eingesehen; historische Runs, Quellen und Canonical-Profile bleiben unverändert.

Quellen, die erst in anderen Run-Paketen enthalten sind, werden dem ursprünglichen
Run nicht nachträglich als bereitgestellter Eingabekorpus zugerechnet. Für eine
spätere App-Aufnahme relevante zusätzliche Rechtsstände bleiben als Quellen-
oder Paketlücke mit ausdrücklichem Verweis sichtbar. Quellengetreue Extraktion
und aktuelle fachliche Verwendbarkeit sind getrennte Prüffragen.
