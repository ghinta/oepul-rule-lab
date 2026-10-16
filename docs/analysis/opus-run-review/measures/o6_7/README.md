# Einzelprüfung 9/26: System Immergrün

Der unveränderte Run `v2-o6_7-opus-5.5-high-20260925` bleibt für eine native
App-Aufnahme blockiert. Alle Befunde werden im
[Sammelissue #112](https://github.com/ghinta/oepul-rule-lab/issues/112) und im
bestehenden gemeinsamen Branch gesammelt. Historische Regeln werden nicht
repariert; der Prüfabschluss erteilt keine Expertenfreigabe.

Vollständig gelesen wurden alle elf Seiten des neuen Merkblatts und alle neun
Produktionsmodule samt Rohannahmen. Die sieben gemeinsamen Quellen sind mit
identischem Hash an die vorangegangenen Volllektüren gebunden; aktuelle Klauseln
und Verbraucher wurden erneut abgeglichen. Die GSP-AV gehört nicht zu diesem
achtteiligen historischen Quellpaket. Zusätzliche Rechtsstände werden dem
Kandidaten nicht rückwirkend als bereitgestelltes Eingabepaket zugerechnet.

Die Teilberichte [general.md](general.md), [measure.md](measure.md),
[tables.md](tables.md) und [inputs.md](inputs.md) besitzen jeweils ein JSON-Ledger.
[core.json](core.json) ergänzt die Gesamtentscheidung, die Ackerflächenauswahl
und die veröffentlichten Beispiele. Zusammen sind alle 107 historischen Regel-IDs mit 108 erhaltenen
Bewertungen, alle 25 Profilvorschläge und alle 58 Tabellencontainer abgedeckt.
Die fünf Teile dokumentieren 30 zum Teil überlappende Befundgruppen; daraus
wird keine Zahl unabhängiger Modellfehler abgeleitet.

| Bereich | Quellenvergleich und Abgrenzung |
|---|---|
| Flächenauswahl | Alle bereitgestellten Ackerschläge gehen in die Ausgangsmenge ein; eine bekannte Dauergrünlandfläche wird richtig getrennt. Eine vollständige aktuelle MFA-Sammlung ist Voraussetzung. Bekannte Auslandsfläche wird monetär ausgeschlossen, zählt aber noch zum jährlichen Mindestzugang; die isolierte Inland-/Auslandskontrolle steht im Generalteil. |
| Veröffentlichte Beispiele | Der 40-Tage-Abstand vor einer gültigen 50-Tage-Zwischenfrucht erzeugt genau 40 unbegrünte Tage. Eine 41-Tage-Zwischenfrucht mit jeweils 30 Tagen davor und danach erzeugt 101 unbegrünte Tage. Dieser Außenzeitraum liegt eindeutig über 50 Tagen und entscheidet die offene kurze A02-Auslegung nicht. |
| Ergebnisreichweite | Bei einem betroffenen Hektar von zehn bleiben beide Beispiele unter der betrieblichen 15-Prozent-Grenze. Ein lokaler Lückenbefund im gemeinsamen `violations`-Feld ist deshalb nicht automatisch ein Verstoß gegen die betriebliche 85-Prozent-Auflage. `access_ok` beschreibt außerdem nur die Mindestackerfläche; Vertrags-, Pflicht- und Prämienkomponenten haben eigene Reichweiten. |
| Zeit und Ausnahmen | Ein endgültig zu langer offener Abstand am abgeschlossenen Jahresende wird nur teilweise rückwirkend gezählt. Die Dürre-Ausnahme für 30-/50-Tage-Fristen kann auch die weiterhin gesondert geltende Zug-um-Zug-Erneuerung ausnehmen. Die Einbeziehung des tatsächlichen Anlagetags wird an einer nicht beendenden Pflegehandlung geprüft. |
| Zahlenpräzision | Vor dem Grenzvergleich wird der unbegrünte Anteil gerundet. Bei 150,02 von 1.000,13 Hektar liegt er rechnerisch geringfügig über 15 Prozent, wird aber als genau 15 Prozent verglichen. Das betrifft den lokalen Schwellenverbraucher mit normalen Flächenangaben und bleibt von den separat untersuchten OPA-Laufzeitabweichungen getrennt. |
| Offene Lesarten | Die kurze äußere 50-Tage-Lücke bei einer ungültigen 41-Tage-Zwischenfrucht und widersprüchliche Walzaussagen werden als Auslegungsproben geführt. Deren abweichende Ergebnisse sind keine versteckten eindeutigen Referenzurteile. Der Root-Beispielfall mit 101 Außentagen berührt diese kurze Lücke nicht. |
| Flächenhinzunahmen | Die klare 15./16.-Oktober-Ausnahme und Folgejahrsbindung werden geprüft. Kausalität der Ausnahme und tägliche Besitzmengenzurechnung aus einer aktuellen MFA-Liste bleiben ausdrücklich abgegrenzte Quellen-/Eingabeverträge; es wird keine neue dynamische Nennerformel erfunden. |
| Methodenqualifikation | Die Daten enthalten Frostbedingungen mechanischer Beseitigung. Der Methodenkey allein kann trotzdem die nachgelagerte PSM-Prüfung freigeben. Der Befund betrifft die konkrete Pflichtprüfung; daraus wird keine frei erfundene vollständige Prämienkürzung abgeleitet. |
| Aktuelle Verbesserungen | Die Teilnahmeliste wird nach Jahr gefiltert; der tatsächliche Umfang der gelieferten Ackerschläge wird aggregiert. Die Problempflanzen-Ausnahme ist enger auf Häckseln gebunden. Die regionale Dürre-Ernteausnahme verlangt nun auch einen dürrebedingt nicht erntbaren Bestand; die übliche Erntesaison fehlt weiterhin als Bedingung. Kontrollverweigerung und mehrere tatsächliche Flächenausschlüsse werden von der Zahlung konsumiert. Diese Unterschiede zu früheren Runs bleiben erhalten. |
| Verträge und Verfahren | Eigene Rechnung, Wiederantrag nach Erlöschen und ein historisch wirksamer Ausstieg können trotz vorhandener lokaler Diagnosen im Maßnahmengate unvollständig berücksichtigt werden. Eine genehmigte Übernahme wird als ausdrücklich stipulierter Behörden-Ausnahmeweg geprüft; der fehlende strukturierte Genehmigungspfad ist eine Schnittstellengrenze. |
| Finanzielle Reichweite | Die Modulation ist rechnerisch integriert. Inhaltsstufen und weitere Rechtsfolgen bilden hingegen keinen vollständig ausgeführten Endabrechnungsprozess. Ein gewählter Satz oder der Mindeststandard im Band 70–90 Euro je Hektar ist keine amtliche Endzahlungsfreigabe. Ein Auflagenbefund bestimmt ohne Bewertung nicht selbst eine Kürzungsstufe. |

Alle fünf Datendateien wurden vollständig gelesen: 58 Inventarcontainer mit
448 direkten Einträgen mit Überschneidungen zwischen Eltern- und Unterobjekten;
ohne Doppelzählung sind es 440 Einträge. Die historische Summe 486 zählt im Parameterwurzelobjekt
50 entfaltete Werte statt zwölf direkter Schlüssel, während Untercontainer
bereits separat erfasst sind. Die Differenz von 38 ist kein Nachweis fehlender
Datensätze. Die Matrix speichert diesmal ausdrücklich alle 441 Zellen:
21 Diagonalen sowie 134 positive und 286 leere Offdiagonalzellen.
Kombinationsentscheidungen, eigene Prämienauswahl und fremde Förderung bleiben
getrennt; entsprechende Gegenfälle stipulieren die tatsächlich gewählte andere
fortgeführte Förderung.

## Entwicklungsfälle und Eingabekompatibilität

318 eigenständig abgeleitete Entwicklungsfälle ergeben 367 Prüfungen:
298 sind erfüllt, 69 nicht erfüllt. 301 native Ergebnisse sind definiert;
17 enden in einem Laufzeitfehler. Davon betreffen 14 gemäß Vorschlag erlaubte
Nullwerte auf 13 verschiedenen neuen Blättern, jeweils in der Hauptauswertung.
Drei weitere sind ausdrücklich schemawidrige Stressfälle, darunter ein
getrennter Helferaufruf. Es gibt keine undefinierte Ausgabe in dieser gezielten
Fallmenge. Nicht erfüllte Sollwerte sind keine pauschale Fehler- oder
Genauigkeitsquote: Schnittstellenannahmen, fehlende Nachweise und offene
Auslegungsproben behalten ihre jeweilige Kennzeichnung.

| Teil | Fälle | Prüfungen | Erfüllt | Nicht erfüllt |
|---|---:|---:|---:|---:|
| Kernkontrollen | 3 | 19 | 19 | 0 |
| Allgemeine Regeln | 80 | 80 | 65 | 15 |
| Maßnahme | 98 | 98 | 92 | 6 |
| Tabellen | 80 | 108 | 104 | 4 |
| Eingaben | 57 | 62 | 18 | 44 |

25 Profilvorschläge enthalten 88 neue Blätter. 84 werden gelesen, 29 davon nur
für sichtbare Befunde; kein gelesenes Blatt bleibt auf einen getrennten Helfer
beschränkt. Ungelesen sind Übernahmedatum, Selbstanzeige, Revisionsverweigerung
und der Kulturname im Begrünungsabschnitt. 260 Lesestellen und ein dynamischer
Aufzeichnungsschlüssel mit vier konkreten Feldern wurden geprüft. Hinzu kommen
zehn bestehende Pfade, darunter neun skalare Pfade und der Regionscontainer.

Die tatsächliche App-Projektion wurde mit gesperrtem SQL-Zugriff ausgeführt.
Sie erhält keinen der 25 neuen nativen Vorschlagspfade und sieben der zehn
bestehenden Pfade, darunter sechs skalare Pfade und den Regionscontainer.
Die native Folgeauswertung ist definiert: Zugang und lokale Maßnahmengültigkeit
sind true, die Jahresbegrünung ist false, und die ungekürzte Prämienkomponente
beträgt 210 Euro auf drei Hektar. Das ist eine fehlende positive Eingabebindung;
aus nicht übermittelten Jahresdaten wird kein tatsächlich festgestellter
landwirtschaftlicher Verstoß samt erfundener Nullsanktion abgeleitet. Die
Produktfreigabe dieses Rohvertrags ist damit nicht belegt. Der Integrationslauf
zählt nicht als zusätzlicher Quellenfall und bewertet keine andere produktive
Regeladaption.

```bash
python docs/analysis/opus-run-review/audit_runner.py --measure o6_7 \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/pinned-opa --verify
```

Der native Regelpfad ist diesmal `data.o6_7.decision`, die Originaldaten liegen
unter `data.oepul.o6_7`. Beide ursprünglichen Verzeichnisse werden unverändert
geladen. Die unabhängige Gegenprüfung steht in [quality.md](quality.md).
[Numerische Laufzeitkontrollen](../../runtime-numeric.md), zulässige Nullwerte,
fehlende Nachweise, schemawidriger Stress und offene Quellenauslegung bleiben
getrennt. Es werden keine öffentlichen oder privaten Studienreferenzen,
Expertenantworten oder Sollwerte manueller Adaptationstests als Orakel genutzt.
Originale, Canonical-Profile und produktive App bleiben unverändert. Gemeinsame
Lösungen werden nach allen 26 Einzelprüfungen zusammen durchgesehen.


Nachträgliche Eingabekorrektur der Root-Kernkontrollen: Nicht zulässige
Canonical-Enumwerte wurden durch die erlaubte Nutzung `grassland` ersetzt.
Quellen, Abfragen, fachliche Erwartungen und beabsichtigte Bewirtschaftungsfälle
bleiben gleich. Die konstruierten Eingaben und ihre Hashes sind ausdrücklich
geändert; Sammlung, vollständige Ausführung und unabhängige Qualitätsbindung
werden deshalb erneut hergestellt. Der Qualitätsbericht dokumentiert die
Ausgangsbindung und den Vergleich der tatsächlichen Ausgaben.
