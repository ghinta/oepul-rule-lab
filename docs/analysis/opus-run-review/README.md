# Opus-Runs einzeln prüfen

Stand 16.10.2026. Die bisherige technische
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

Aktuell: **26 Einzelprüfungen abgeschlossen und blockiert, keine ausständig;
keine Expertenfreigabe und keine App-Promotion aus dieser Runde.**

Die [gemeinsame Befundmatrix](cross-run-matrix.md) führt jetzt alle 26 Dossiers
in acht Problemfamilien zusammen. [Sechs konkrete Lösungspakete](work-packages.md)
mit Abhängigkeiten, Fallbelegen und Abschlusskriterien stehen für die gemeinsame
Priorisierung bereit; Umsetzung und fachliche Abnahme folgen getrennt.
Die [maschinenlesbare Matrix](cross-run-matrix.json) und ihre
[Dateibindungen](cross-run-matrix-provenance.json) halten die Nachweise fest.

| Reihenfolge | Run / Maßnahme | Status |
|---|---|---|
| 1 | [o6_1a – UBB](../opus-o6-1a-audit-20261015/README.md) | Quellen-, Regeln-, Tabellen- und Eingabeprüfung dokumentiert; konkrete Fehler, Übernahme blockiert. |
| 2 | [o6_1b – Biologische Wirtschaftsweise](measures/o6_1b/README.md) | Alle 200 Regeln, 92 Tabellen, 89 Eingabevorschläge und 107 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 3 | [o6_1c – Nichtproduktive Ackerflächen und Agroforststreifen](measures/o6_1c/README.md) | Alle 97 Regeln, 22 Tabellen, 16 Vorschläge und 109 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 4 | [o6_2 – Einschränkung ertragssteigernder Betriebsmittel](measures/o6_2/README.md) | Alle 82 Regeln, 28 Tabellen, 26 Vorschläge und 157 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 5 | [o6_3 – Heuwirtschaft](measures/o6_3/README.md) | Alle 74 Regeln, 35 Tabellen, 34 Vorschläge und 158 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 6 | [o6_4 – Bewirtschaftung von Bergmähdern](measures/o6_4/README.md) | Alle 90 Regeln, 31 Tabellen, 13 Vorschläge und 185 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 7 | [o6_5 – Erhaltung gefährdeter Nutztierrassen](measures/o6_5/README.md) | Alle 97 Regeln, 13 Tabellen, sieben Vorschläge und 233 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 8 | [o6_6 – Zwischenfruchtanbau](measures/o6_6/README.md) | Alle 111 Regeln, 32 Tabellen, 47 Vorschläge und 391 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 9 | [o6_7 – System Immergrün](measures/o6_7/README.md) | Alle 107 Regeln, 58 Tabellen, 25 Vorschläge und 318 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 10 | [o6_8 – Erosionsschutz Acker](measures/o6_8/README.md) | Alle 114 Regeln, 30 Tabellen, 23 Vorschläge und 313 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 11 | [o6_9 – Bodennahe Ausbringung und Gülleseparation](measures/o6_9/README.md) | Alle 89 Regeln, 29 Tabellen, 25 Vorschläge und 335 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 12 | [o6_10 – Erosionsschutz Wein, Obst und Hopfen](measures/o6_10/README.md) | Alle 91 Regeln, 38 Tabellen, 20 Vorschläge und 373 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 13 | [o6_11 – Herbizidverzicht Wein, Obst und Hopfen](measures/o6_11/README.md) | Alle 76 Regeln, 30 Tabellen, zehn Vorschläge und 413 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 14 | [o6_12 – Insektizidverzicht Wein, Obst und Hopfen](measures/o6_12/README.md) | Alle 94 Regeln, 32 Tabellen, 24 Vorschläge und 508 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 15 | [o6_13 – Einsatz von Nützlingen im geschützten Anbau](measures/o6_13/README.md) | Alle 80 Regeln, 31 Tabellen, 23 Vorschläge und 430 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 16 | [o6_14 – Almbewirtschaftung](measures/o6_14/README.md) | Alle 126 Regeln, 27 Tabellen, vier Vorschläge und 618 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 17 | [o6_15 – Tierwohl Behirtung](measures/o6_15/README.md) | Alle 95 Regeln, 20 Tabellen, sieben Vorschläge und 601 Entwicklungsfälle geprüft; Übernahme blockiert. |
| 18 | [o6_16 – Vorbeugender Grundwasserschutz Acker](measures/o6_16/README.md) | Alle 98 Regeln, 33 Tabellen, 34 Vorschläge und 358 Entwicklungsfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle nach Limitfortsetzung, keine zusätzliche unabhängige Person behauptet. |
| 19 | [o6_17 – Humuserhalt und Bodenschutz auf umbruchsfähigem Grünland](measures/o6_17/README.md) | Alle 133 Regeln, 37 Tabellen, 38 Vorschläge und 326 Entwicklungsfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle, keine zusätzliche unabhängige Person behauptet. |
| 20 | [o6_18 – Naturschutz](measures/o6_18/README.md) | Alle 125 Regeln, 30 Tabellen, 30 Vorschläge/112 Blätter und 529 Entwicklungs-/Technikfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle und erhaltene eigene Fehlkonstruktionen ausdrücklich abgegrenzt. |
| 21 | [o6_19 – Ergebnisorientierte Bewirtschaftung](measures/o6_19/README.md) | Alle 102 Regeln, 28 Tabellen, 94 Vorschläge/97 Blätter und 372 Entwicklungs-/Technikfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle; gewünschter Positivnachweis, tatsächliche Sachverhalte und Strukturstress getrennt. |
| 22 | [o6_20 – Tierwohl Weide](measures/o6_20/README.md) | Alle 97 Regeln, 23 Tabellen, sechs Vorschläge/93 Blätter und 262 Entwicklungs-/Technikfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle; aktuelle Tatsachen, Positivnachweis, Doppelrepräsentation und Strukturstress getrennt. |
| 23 | [o6_21 – Tierwohl Stallhaltung Rinder](measures/o6_21/README.md) | Alle 95 Regeln, 36 Tabellen, neun Vorschläge/128 Blätter und 326 Entwicklungs-/Technikfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle; bekannte Mindestfläche, Fristenden, gültige Nullwerte und qualifizierte Jahresscopes getrennt. |
| 24 | [o6_22 – Tierwohl Schweinehaltung](measures/o6_22/README.md) | Alle 125 Regeln, 35 Tabellen, 17 Vorschläge/118 Blätter und 350 Entwicklungs-/Technikfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle; Betragskomponenten, Nachweise und qualifizierte Quellenfragen getrennt. |
| 25 | [o6_23 – Natura 2000 und andere Schutzgebiete](measures/o6_23/README.md) | Alle 88 Regeln, 20 Tabellen, neun Vorschläge/46 Blätter und 300 Entwicklungs-/Technikfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle; genehmigte Übernahme, Positivnachweise und qualifizierte Cap-/Vorschussverträge getrennt. |
| 26 | [o6_24 – Wasserrahmenrichtlinie](measures/o6_24/README.md) | Alle 95 Regeln, 32 Tabellen, elf Vorschläge/119 Blätter und 537 Entwicklungs-/Technikfälle geprüft; Übernahme blockiert. Eigene Gegenkontrolle; zwei eigene falsche Sollvergleiche sowie zeitlich gemischte 2023-Vorlage ausdrücklich abgegrenzt. |

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

[Eigene Einheitenkorrektur vom 16.10.2026](unit-label-erratum-20261016.md):
Sechs Beschriftungen in vier älteren Eingabeledgern wurden berichtigt; alle
951 Fälle vollständig wiederholt. Eingaben, Sollwerte und native Ergebnisse
bleiben identisch. Alte und neue Abschlussbindungen sind dokumentiert.
