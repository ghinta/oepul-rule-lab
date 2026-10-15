# o6_14 – unabhängige Qualitätsgegenprüfung

Der vollständige eigene `audit_runner.py --verify` besteht mit Exit 0. Alle **618 Fälle / 883 Vergleiche** reproduzieren die eingefrorenen Beobachtungen: **807 erfüllt, 76 abweichend; 587 definiert, 31 Laufzeitfehler, 0 undefiniert**. Das öffentliche Prüfdossier ist innerhalb des beschriebenen Umfangs abgeschlossen. Der historische Kandidat bleibt für die native App-Aufnahme blockiert; eine Domainexpert:innen-Freigabe oder Promotion erfolgt damit nicht.

| Teil | Fälle | Vergleiche | Erfüllt | Abweichend |
|---|---:|---:|---:|---:|
| core | 3 | 213 | 213 | 0 |
| general | 161 | 161 | 142 | 19 |
| measure | 318 | 318 | 314 | 4 |
| tables | 37 | 37 | 34 | 3 |
| inputs | 99 | 154 | 104 | 50 |

## Persönliche Lektüre und Quellen

Alle 16 Seiten des neuen Originalmerkblatts, alle acht Module mit 1.377 Zeilen, alle 17 Rohannahmen samt weiteren Notizen und alle vier tatsächlichen Vorschlagsbäume wurden vollständig persönlich gelesen. Sieben identische Originale verwenden dokumentierte frühere Volllektüren mit gleichen Hashes. Frisch vollständig gelesene aktuelle SRL-Seiten: 8, 10, 12, 13, 14, 15, 16, 22, 23, 24, 25, 69, 70, 71, 72, 87; ATB: 14, 15, 18, 19. Anhang A 3, E 10 und die eigene Zeile/Spalte 14 samt Fußnoten in Anhang L 103 wurden frisch gelesen und im Originalbild angesehen. Der ganze aktuelle Artikel vom 22. Mai und alle vier nativen Datendateien wurden gelesen. Alle vier endgültigen Teilberichte und das finale Root-README sind persönlich vollständig gelesen.

GSP-AV und NAPV sind hier nicht als eigene Originale bereitgestellt. Eine zweite vollständige semantische Beurteilung aller 126 Bewertungen oder eine neue Rekonstruktion sämtlicher fremder Matrixzellen wird nicht behauptet. Die eigene statische Quellengegenkontrolle umfasst 19 eng umrissene Prüfungen, darunter alle 18 RGVE-Tupel, sechs Basistarife, drei NATA-Sätze, neun Anhang-E-Tupel, acht Fristzeilen, fünf Meldefenster und die eigenen 20 Matrixzellen. Die native Inventur zählt 576 Skalarblätter. Diese QA-Unterprüfungen sind keine zusätzlichen Quellenfälle.

## Bindungen und vorhandene Eingaben

Alle 126 historischen IDs sind abgedeckt. Vier Vorschlagsbäume, 27 Inventarpointer mit 147 direkten Einträgen und sämtliche 47 historischen Hash-/Größenbindungen stimmen. Alle 618 gesammelten Fälle wurden unabhängig aus den endgültigen Teilen rekonstruiert: Eingaben, Queries, Erwartungen und Szenariometadaten bleiben gleich; nur ausdrücklich deklarierte Ausführungsfelder wurden entfernt und ihre Hashes geprüft.

4282 Originalbelegvorkommen mit 425 eindeutigen Quellen-/Seiten-/Zitatbindungen stimmen nach ausschließlich Whitespace-/Soft-Hyphen-Normalisierung. Drei zusätzliche technische Vertragsbelege stimmen ebenfalls; sie sind keine juristischen Originale. Keine offene Zuordnung, keine Satzzeichenkompaktierung. 4349 PDF-Seitenvorkommen und 32 PDF-Bereiche sind gültig. HTML-Marker 1 bezeichnen ausdrücklich einen ganzen Artikel und werden nicht als PDF-Seiten gezählt. 1122 Codeanker und 610 wörtliche Codezeilen sind gültig. Positionskontrollen ersetzen keine fachliche Lektüre.

Die vorhandenen Werte wurden gegen Canonical und alle tatsächlichen Vorschlagsdeskriptoren geprüft: 5485 Enumvorkommen und 102907 vorhandene Typwerte. Genau die zwölf benannten Typstresse und drei benannten Enumstresse der Inputs bleiben sichtbar; keine weitere unstrittige Abweichung. 20 temporäre Tabellenargumentarrays mit 95 Skalaren sind separat typisiert. Sie erklären keine neuen App-Felder. Alle 136 Blätter wurden unabhängig rekonstruiert: 131 gelesen, fünf ungenutzt. Alle 263 annotierten Lesestellen stimmen an der echten Codezeile; das ist kein zweiter vollständiger Datenflussbeweis.

**Die Primitive von `enum(1|2|3)` bleibt offen.** Genau zwei Pfade sind betroffen: Erschließungsstufe der Alm und ihrer Einheiten. Alle 605 Vorkommen werden separat erhalten; zwei absichtlich ungültige Null-/unknown-Werte gehören zu keiner der beiden Tokenlesarten. Offizielle Shape-Verträge legen Zahl oder String nicht fest. Native numerische Komponenten funktionieren, während lexikalische gewichtete Stufen an der Multiplikation scheitern können. Keine Konvertierung und keine pauschale Typzertifizierung. Fehlende Pflichtwerte, Wertebereiche, Identität, Register- und Quellenwahrheit sind ebenfalls keine Aussage dieser Vorhanden-Prüfung.

## Vollständige native Gegenkontrolle

Alle 161 General-, 318 Domain- und 99 Input-Begleitbeobachtungen stimmen mit der gemeinsamen Sammlung. Bei den 31 Fehlern wird allein der Kandidaten-Dateipräfix auf denselben Bundlepfad abgebildet; vollständige Fehlerobjekte und Zahlen bleiben unverändert.

Sämtliche 883 Erwartungen wurden mit typisierter Gleichheit unabhängig neu berechnet. Null, fehlend, false und numerische 0 bleiben getrennt. 2 tatsächlich definierte Objektmatcher prüfen Arrays aus `rule_id`-Objekten; davon ist ein Matcher leer. 0 Objektmatcher sind wegen nativen Status nicht auswertbar. Keine ungültige Collection wird als Regel-ID-Liste akzeptiert.

Der reservierte zusätzliche Eingabe-Untercheck reproduziert genau 34 bestehende Fälle mit 34 CLI-Aufrufen: alle 31 Fehler und drei definierte MAIN-Sicherheitskontexte. Fehlender Auftriebsbericht bleibt definiert bei 0 Euro; abwesende optionale Kategorie und unbenötigtes nulliges Listendatum einer reinen Stufe-1-Rinderalm bleiben definiert bei jeweils nominal 129,60 Euro. Der vollständige Bericht ist mit allen CLI-Aufrufen, stdout/stderr, tatsächlichen Deskriptoren, Codekontexten und vollständig geparsten Ergebnissen dauerhaft in `quality.json` enthalten. Alle darin enumerierten Inputs, Queries, Status und nativen Objekte wurden nochmals unabhängig gegen Primary geprüft. Bericht-SHA: `126b7ad57c70fcbd0ed6510fd63a315ebe2ddd23254afc3532934ee5a3fae9d6`. Das sind keine zusätzlichen Quellenfälle oder App-/SQL-Prüfungen.

## Fachliche Grenzen und Autorenrevisionen

Die drei Geldkerne ergeben nominal 720 / 777,6 / 777,6 Euro in 2023/2024/2026. Zwölf individuell dargestellte erwachsene Rinder werden aus bekannten Geburt-/Art-/Rassefakten tatsächlich abgeleitet; das optionale Kategorieoverride fehlt. Ein vorhandenes erlaubtes null unterdrückt dagegen bekannte RGVE und die 129,60-Euro-Komponente. Domain, Tabellen und Inputs belegen dieselbe Familie. Der bekannte Schweinefall zeigt eine zweite lokale Alm-Tage-Familie; die Hauptentscheidung bleibt dort korrekt 0. Drei gekoppelte Domain-Gegenchecks sind zwei konkrete Familien. Der vierte Check zu 2,4 RGVE ist nur unter dem offengelegten schwächeren Antragsflagvertrag ein Gegenfall.

Die betriebliche Modulationsgegenprobe gehört zu General PREM005: nativ 200 ha / Faktor 1 / 8.640 Euro gegenüber betriebsbezogen 250 ha / Faktor 0,98 / 8.467,20 Euro. Kleine Root-Kontrollen entscheiden diese A07-Frage nicht. Aktuelle wirksame Teilnahme, ursprüngliche Vertragsbildung, beantragter Zuschlag, tatsächliche physische Aufenthalte und Behördenentscheidung bleiben getrennt. Der Betrag liegt nach A04 vor inhaltlichen Kürzungen; tatsächliche Zugangs-/Flächen-/Kurs-/Plangates werden gewürdigt. Eine freie 100%-Sanktion oder eine automatische höhere-Gewalt-Anerkennung aus einem bloßen Ansuchen wird nicht erfunden.

Die 31 Laufzeitfehler trennen 17 gültige Nullable-MAIN-Fälle, zwei gültige Nullable-Helfer, einen Missing→Null-Default, zwei Identitätskonflikte, acht Outside-Schema-Fälle und einen Fall offener String-/Zahlenprimitive. Ein separater Helferfehler ist keine MAIN-Störung. Keine Fehler- oder Nullstatistik aus dem vorigen Run wird übertragen.

Die Domain-Konstruktionskorrektur an elf aktiven Optionsfixtures mit 78 Lifecycle-/Kurs-/Planblättern bleibt mit Vorher-/Nachherbelegen erhalten. Acht verworfene Entwurfsfehler sind keine Modellbefunde; anschließend wurden alle 318 Fälle vollständig erneut ausgeführt. Zusätzliche Tabellen-ABSENT-Kontrollen lassen die ursprünglichen Null-Gegenproben unverändert. General-Kontext-/Boolquery-Präzisierungen und die Tabellen-Navigationskorrektur sind transparent gebunden. Die sieben weiteren Domainbefunde behalten Evidenz-, Workflow-, Jahres- und Sanktionsgrenzen. Positive Produkte, Projekte, Rollen und Genehmigungen sind ausdrücklich vorbereitete bekannte Tatsachen, keine realen Registerbeweise.

Primary misst an der unveränderten reinen App-Projektion 0/4 Wurzeln, 0/136 Blätter und 2/2 weitere Canonicalpfade bei 0 SQL-Aufrufen. Die exakte projizierte Ausgabe ist nativ definiert negativ mit 0 Euro. QA hat diese eingefrorene Evidenz gelesen; ein eigener Projektorlauf, Server-/DB-Rollout oder Integrationsfreigabe wird nicht behauptet. Öffentliche gezielte Prüfungen sind keine Genauigkeitsquote oder private Expert:innenreferenz.

## Endgültige Artefaktbindung

Alle 14 Artefakte blieben während des vollständigen unabhängigen Replay unverändert. SHA-/Bytewerte stehen in `quality.json`. Root-README: `f48069fba2af2c3f25606c36956a74f6b978ad605478484d79f364da0827cfd9`. Mutable Audit-/Queue-Abschlussfelder und die Qualitätsdateien selbst werden nicht selbstreferenziell gebunden.

Nach dem abgeschlossenen Replay wurde ausschließlich ein finales Newlinebyte des Root-README entfernt, damit die Git-Whitespaceprüfung besteht: 11.241 → 11.240 Bytes. Unabhängig ist exakt Altes = Neues + `0a` anhand beider SHA-256-Werte bewiesen; die alte Replaybindung und die aktuelle Bindung bleiben im JSON erhalten. Die übrigen 13 Artefakte sind SHA-/byteidentisch. Ein erneuter nativer Lauf ist dafür nicht nötig: Der einzige Unterschied betrifft ein narratives Dateiende; alle ausführbaren Fall-, Quellen-, Query-, Erwartungs- und Beobachtungsdateien bleiben unverändert.

OPA 1.18.2: `9903e5125ac281104f2c4b7371d10cc3b74a98933743fcbfc174f9bf0ab20de8`. Vollständiger Verifylog: `b67886598bad6c05100c81441457ad1852982dbcc901e5bab8f36f56829f68c8`. Historische Originale, Policy/Daten, Canonical, Runtime und produktive App bleiben unverändert. Frühere 60 Decimal-/17-Anomalie-Kontrollen sind binärspezifische technische Evidenz, keine 17 Policyfehler oder Aussage über alle 26 Runs/eine Serverbinary.

Qualitäts-JSON SHA-256: `c72250a65bdabd4f8fa0324836c982af6a21745c15701529afff4b57b3b8f07d`.
