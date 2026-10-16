# Opus-Einzelprüfung 1/26: UBB (o6_1a)

Stand 15.10.2026. **Der historische UBB-Run ist nach der Quellen- und
Implementierungsprüfung für eine fachliche App-Übernahme gesperrt.** Es wurden
konkrete Rechen-, Zeit-, Ereignis- und Eingabevertragsfehler reproduziert.
Die bisherige Sichtung aller 26 Runs war eine technische Diagnose mit
Berichtsauswertung und ausgewählten Code-Stichproben. Sie war keine vollständige
fachliche Einzelprüfung aller Runs. Diese neue Prüfrunde beginnt ausschließlich
mit UBB; [25 weitere Einzelprüfungen stehen aus](../opus-run-review/README.md).

Geprüfter Run: `v2-o6_1a-opus-5.5-high-20260929`, unverändert am Commit
`e009eed4a83ff076b26eba33ac433ac2b0642621`. Prüfer sind Codex und seine
Teilprüfungen. **GM und Domainexpert:innen haben dieses Audit nicht abgenommen.**
Die Quellen-, Profil-, Prompt- und Run-Artefakte sind unverändert; kein neues
Modell wurde ausgeführt. Die App stellt weiterhin die separat gebundene
historische Diagnose bereit. Dieser Bericht ändert weder deren Rohdaten noch
die produktiven Regeln.

## Was für diesen einen Run geprüft wurde

| Gegenstand | Umfang und Nachweis |
|---|---|
| Originalquellen | Alle acht SHA-256-Werte mit `run.json` abgeglichen; [binding.json](binding.json) bindet Quellen und sämtliche veröffentlichten Run-Artefakte. |
| Maßnahmenblatt | Alle 46 PDF-Seiten einschließlich Tabellen, Beispielen, Fußnoten und Aktualisierungen gelesen. |
| Allgemeine Teilnahmebedingungen | Alle 21 Seiten gelesen; sämtliche 33 historischen Coverage-Abschnitte eigenständig beurteilt. |
| Sonderrichtlinie | Alle 94 Seiten im extrahierten Text auf UBB-Bezüge gelesen, 59 Seiten vertieft gegen die UBB-Regeln geprüft. Andere Maßnahmen bleiben Kontext. |
| Anhänge | Alle 103 Seiten im Tabellen-Team auf Relevanz gelesen, UBB-bezogene Tabellen und Verweise fachlich abgeglichen; Kombinationstabelle und ausgewählte Karten zusätzlich visuell geprüft. |
| Hinweise 2026 | Alle vier Hauptartikel einschließlich Ausnahmen und Anwendungsbereichen vollständig gelesen. Der Rebzikadenhinweis betrifft Maßnahme 12. |
| Regelcode | Alle 13 produktiven Rego-Module gelesen. Alle 166 Katalogregeln einzeln beurteilt: [Regelmatrix](rule-matrix.csv), [vollständiger Ledger](rule-review.json). Die sechs Modelltestdateien liefern keine unabhängigen Sollwerte. |
| Daten | Alle acht JSON-Dateien und 53 Tabellencontainer gegen Quellen geprüft; 374 Einzelzeilenbindungen für lange Listen. 42 Tabellen werden referenziert, elf nicht. |
| Eingabevertrag | Alle 67 Vorschläge mit 190 neuen und einem geänderten Blattpfad abgeglichen; 189 vorgeschlagene Blätter werden gelesen, zwei bleiben ungenutzt. Zehn bereits vorhandene Blattpfade kommen hinzu. |
| App-Abbildung | Den tatsächlichen Adapter am App-Quellstand `529eadb34c4fdd249fbf739a372d63185b7374a2` mit gesperrtem Datenbankzugriff ausgeführt. Die 67 vorgeschlagenen Pfade fehlen in dessen OPA-Projektion. |
| Quellenzitate | Alle 418 historischen Zitatstellen sowie die Belege des Haupt-Fallsatzes auf der angegebenen Originalseite/im HTML gefunden. Ein Wortlauttreffer bestätigt die Begründung einer Regel noch nicht. |

Die Seitenlektüre ist auf mehrere Teilprüfungen **innerhalb dieses Runs** verteilt.
Die genauen Lesebereiche, Grenzen, Codezeilen und Quellenbelege stehen in den
vier Teilberichten. Die Katalogabdeckung ist keine Behauptung, dass der
historische Katalog bereits alle rechtlichen Pflichten vollständig enthält.

## Konkrete Befunde am unveränderten Kandidaten

Die Fallkennungen beziehen sich auf [development-probes.json](development-probes.json);
die vollständigen nativen Ausgaben stehen in [observations.json](observations.json).
Soll-Aussagen betreffen jeweils die ausdrücklich genannte Einzelbedingung.
Einige prüfen den verlangten positiven Nachweisvertrag für die App; diese sind
von unmittelbar aus der Quelle folgenden Rechen-/Terminfehlern gekennzeichnet.

| Befund | Reproduzierte Beobachtung | Wirkung / Originalbeleg |
|---|---|---|
| Vertrags- und Nachweisgates | Fehlender oder `null` Vertragsbeginn/Antrag lässt `access_conditions_met=true`; auch 2022 und 2029 bestehen den Flag. | `contract_active` wird im Ergebnis nicht verwendet. Vertrag endet 2028; Quellen UBB S.3/29. Fehlender Nachweis darf keine App-Freigabe liefern. |
| Ungesteuerter Betrag | `payment_application_submitted=false` ändert `premium.net` nicht. | SRL S.22 schließt die Zahlung aus. Der native Betrag ist höchstens eine theoretische Komponentenrechnung, keine bestätigte Auszahlung. |
| Auslandsflächen | 1,5 ha inländischer Weizen + 10 ha ausdrücklich ausländischer Klee ergeben 11,5 ha Acker, zusätzliche DIV-Pflichten und 298,08 EUR FWK-Zuschlag. | ATB S.9 schließt Ausland auch aus Begrenzungen und Förderung aus. Der Basismodulfilter erreicht nicht alle Zuschläge. |
| Sortenzuordnung | 1,5 ha als Weizen mit Mais-Sorte „Gailtaler Weißmais“ ergeben 405 EUR SLK. Eine benannte Einkornsorte wird hingegen nicht erkannt. | UBB S.24/36–37: Kultur/Sorte zusammen prüfen und offene Gruppen „alle Herkünfte und Sorten“ erhalten. |
| Erosionsausschluss | Identischer Anbau auf 12 % Hang erhält bei `Ackerbohne` 127,50 EUR Basismodulprämie, bei `Ackerbohnen` 0 EUR. | Beide Schreibweisen stehen auf UBB S.33. Gemeinsame fachliche Kulturidentität fehlt. |
| RGVE-Nullwert | `average_count:null` führt bei vorhandener Futterfläche zu `eval_type_error` in `livestock.rego:16`. | Der Profilvorschlag erlaubt `number|null`; fehlend, null und echte Nullmenge müssen getrennt behandelt werden. |
| DIVRS-Nutzungszählung | Abtransportierter Reinigungsschnitt + zwei reguläre Mahden erzeugen keinen DIVRS-Verstoß und behalten den Zuschlag. | UBB S.19 zählt den abtransportierten Reinigungsschnitt als Nutzung; höchstens zwei sind zulässig. |
| Dürre-DIVSZ | OPUBB-Fläche mit Mahd am 2.7. besteht die Terminprüfung, obwohl kein zweiter Vergleichsschnitt belegt ist. | Hinweis 22.5.2026 verlangt ausdrücklich die zweite Mahd vergleichbarer Schläge. Keine Prämie bedeutet keine allgemeine Bewirtschaftungsausnahme. |
| DIVNFZ | Erste Mahd mit Abtransport, zweite ohne Abtransport: kein entsprechender Verstoß. | UBB S.17 verlangt Abtransport oder Beweidung beider Aufwüchse. |
| Ende des DIV-Verbots | Düngung am 1.10. nach erlaubtem Umbruch am 15.9. erzeugt weiter `UBB-DIVA-BM-001`. | UBB S.12 beendet das Verbot mit Umbruch/anderweitiger Deklaration. |
| Invasive Pflanzen | Ältere DIV mit ausdrücklich angenommenem Ragweed-Befall >25 % und vorhandenen Nachweisen verlieren die Frühmahd-Ausnahme. | UBB S.12 begrenzt nur zusätzliche Nutzungen auf die zweijährige Mindestanlagedauer; native Schnittstelle prüft Pflanzenidentität/Nachweise zudem nicht selbst. |
| WB-Ernte | Nach angegebenem Drusch am 30.5. wird Ganzpflanzenernte am 5.6. akzeptiert. | UBB S.26 erlaubt Ganzpflanzenernte erst nach 30.6.; das frühere Ende des Befahrungsfensters hebt diese Grenze nicht auf. |
| WB-Nulltermin | `threshing_date:null` blendet sogar eine bekannte PSM-Anwendung am 20.3. aus. | Der Vergleich mit `null` deaktiviert das ganze Verbotsfenster. Ein bereits bekannter Verstoß verschwindet. |

Weitere Eingabeprobleme sind mit eigenen Laufzeitbelegen dokumentiert:
`slope_percent:null` erfüllt den DIVRS-Vergleich `<18` durch Rego-Typordnung;
unbekannte öffentliche Beteiligung kann die 25-%-Prüfung passieren;
fehlender Ernteanteil wird zu 100 %. Ohne botanische Normalisierung werden
Winter-/Sommerformen getrennt oder Getreide überhaupt nicht als solches erkannt.
Fehlende Feldstückschlüssel ersetzen Feldstücke durch Schläge. Der gepaarte Fall
belegt Informationsverlust; aus dem verbleibenden JSON allein ist dann keine
bestimmte Feldstückverletzung mehr beweisbar. Die App muss die Lücke blockieren.

Die vollständigen Artenlisten sind vorhanden, werden aber nicht für einen
Arten-/Familienabgleich verwendet. Übergebene Zähler und Vorentscheidungen
brauchen belegte vorgelagerte Prüfungen. Ebenso fehlen Teile der Förderwerber-,
Vollflächigkeits-, OP-Verfahrens- und Rechtsfolgenprüfung. Die umgekehrte
Monitoringpflicht aus NAT-Auflagen ist im Quellen-/Tabellenledger dokumentiert.

## Kontrollfälle und Grenzen der Aussage

Der Hauptsatz enthält **43 öffentliche Entwicklungsfälle mit 55 einzelnen
Erwartungen**, darunter passende Gegenfälle: fristgerechter/verspäteter Antrag,
2-ha-Schwelle, 7-%-Grenze, Vertragsjahr 2028, passende SLK-Kultur, zulässige
Zahl von DIVRS-Nutzungen, spätere WB-Ernte, RGVE bei fehlend/0/positiv und die
25-%-Beteiligungsgrenze. 42 Abfragen liefern einen Wert; eine bricht mit dem
genannten RGVE-Nullfehler ab. 27 Erwartungen werden erfüllt und 28 nicht.
Diese gezielt ausgewählten Fehler-/Grenzfälle sind **keine Genauigkeitsquote**.

Zusätzlich enthält der allgemeine Teil 35 separat aus Quellen abgeleitete
numerische Grenzproben, die alle das erwartete Einzelergebnis liefern, und acht
Gesamtszenarien. Der Eingabeteil enthält 42 Vertragsproben, der Maßnahmenteil
fünf weitere Gegenbeispiele. Diese Sätze überschneiden sich inhaltlich und
werden deshalb nicht zu einer vermeintlichen Zahl unabhängiger Fälle addiert.
Kein privater Studienfall und kein Modell-Selbsttest liefert hier ein Label.

Quellenkonflikte bleiben ausdrücklich offen: „unter/bis 10 ha“, Fallen bis
30.9. gegenüber Ende der Vegetationsperiode, mögliche Überschneidung von
Artennamen, Priorisierung am LSE-Deckel sowie Auslegung einzelner
Prämien-/Hinweisformulierungen. Die Quellen von 2024 und Erläuterungen/Hinweise
von 2026 sind unterschiedliche Fassungen; die Bindung ihrer Hashes ersetzt
keine Aktualitätsprüfung vor einer späteren Promotion. Es wird weder ein
pauschaler Vorrang eines älteren Texts noch eine stillschweigende Korrektur
der historischen Regeln behauptet.

## Prüfspuren und Reproduktion

- [Regelmatrix](rule-matrix.csv) / [166-Regeln-Ledger](rule-review.json)
- [Maßnahmen- und Hinweisprüfung](measure-review.md), [JSON](measure-review.json)
- [Allgemeiner und rechtlicher Teil](general-review.md), [JSON](general-review.json)
- [53 Tabellen](tables-review.md), [JSON mit Einzelzeilen](tables-review.json)
- [67 Profilvorschläge und reale App-Abbildung](input-review.md), [JSON](input-review.json)
- [Quellen-/Artefaktbindung](binding.json), [Wortlautprüfung](source-check.json)
- [Unabhängige Qualitätskontrolle mit erneut ausgeführten Teilproben](quality-review.md), [JSON](quality-review.json)
- [Änderungsgrund](reasons.md), [Verifikation](verification.md)

Aus dem Repository, mit separatem Checkout des gebundenen Kandidaten:

```bash
python docs/analysis/opus-o6-1a-audit-20261015/replay.py \
  --candidate-root /path/to/e009eed-checkout --opa /path/to/opa-1.18.2 --verify
python docs/analysis/opus-o6-1a-audit-20261015/check_sources.py \
  --candidate-root /path/to/e009eed-checkout --verify
```

Der erste Befehl benötigt nur Python-Standardbibliothek und die per
Repository-Prüfsumme verifizierte OPA-Binary. Er lädt ausschließlich 13 native
Policy-Module und acht Datendateien, kompiliert streng, verwendet
`--strict-builtin-errors`, begrenzt die Laufzeit und sperrt Netzwerk-, Zufalls-
und aktuelle Zeitfunktionen. CI wiederholt die beobachteten Ergebnisse
bytegenau. Erfolgreicher Replay bedeutet, dass auch die **Fehlbefunde**
reproduzierbar sind; er erklärt die Policy nicht für korrekt.

Die zusätzliche Wortlautprüfung verwendet `pypdf` (hier 6.10.0) und weist
kompakte Typografie-Normalisierung gesondert aus. Ein Treffer auf einer
Tabellenüberschrift bestätigt keine einzelnen Tabellenwerte. Dafür sind die
inhaltlichen Einzelbindungen und Teilprüfungen erforderlich.

Vor einer App-Übernahme sind die reproduzierten Fehler in einer **separaten
manuellen Adaptation** zu beheben, der konkrete Nachweis-/Typ-/Identitätsvertrag
zu implementieren und die Rechtsfolgen mit Domainexpert:innen abzunehmen.
Der aktuelle historische Diagnosebereich kann bereits zur Sichtung verwendet
werden. Er ist keine Förderempfehlung; die übrigen Runs bleiben in ihrer
Einzelprüfung offen.
