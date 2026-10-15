# o6_1c: Tabellen und tatsächliche Verbraucher

Gebunden an den unveränderten Run `v2-o6_1c-opus-5.5-high-20261009`, Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. Alle fünf Seiten des Originalmerkblatts Oktober 2025 einschließlich Aktualisierungen, alle sieben JSON-Dateien, **alle 22 Inventarcontainer** und ihre verschachtelten Werte wurden gelesen. Die sieben gemeinsamen Quellen stimmen im Hash mit früherer vollständiger Lektüre überein; die jetzigen Tabellenklauseln wurden neu verglichen. Die neue 94-seitige GSP-AV haben der Allgemeinagent und dessen Quellenagent vollständig gelesen; die hier benötigten Seiten 10/11/21/22/23/24/30/31 wurden zusätzlich gelesen. Alle neun nativen Rego-Module wurden vollständig gelesen. Keine historischen Änderungen.

Die 14 Negativlistentaxa, beide Prämienbänder mit allen vier Eurogrenzen, sämtliche Parameter und Programm-Ausnahmelisten wurden gegen die Originale verglichen. Keine fehlende Taxonzeile oder falsch kopierte numerische 1C-Prämie festgestellt. „Fertile Paulownia“ ist im deutschen Datenlabel erhalten; die fachliche Einschränkung wird vom wissenschaftlichen Stringverbraucher nicht ausgedrückt. Merkblatt Oktober 2025, SRL Oktober 2024 und GSP Januar 2026 stimmen bei den einschlägigen Taxa und numerischen 1C-Bändern überein. Spätere Merkblattpräzisierungen werden als solche gekennzeichnet; eine spätere SRL-Fassung wird nicht unterstellt.

Die gesamte Kombinationsmatrix wurde auf der gerenderten Originalseite 103 gelesen und unabhängig transkribiert: **21 Überschriften, 420 eindeutige gerichtete Off-Diagonalzellen, alle vier Fußnoten**, keine fehlenden Paare oder Tokenabweichungen. Die 21 Diagonalfelder sind absichtlich nicht gespeichert. Es gibt 286 leere Zellen, 108 reine `x`, 18 `x1)`, vier `x3)` und vier `a`. Die 1C-Zeile und -Spalte sind vollständig leer. Anders als bei BIO wird die Matrix hier tatsächlich in `npa.rego` für das NPA-Kombinationsverbot verwendet. Die Hilfsabfrage `combination_assessment` liefert zusätzlich Zellfußnoten; sie löst weder Kopfzeilenbedingungen 2/4 noch die bedingte Auszahlung von Fußnote 3 vollständig auf.

## Befunde und Vertragsgrenzen

- **O61C-TABLE-001 · IDENTITY_NORMALIZATION · mittel**: Der Paulownia-Eintrag gilt laut Original für fertile Pflanzen. Das Datenlabel bewahrt diesen Zusatz; der Verbraucher liest nur den wissenschaftlichen Namen. Das vorgeschlagene Stringfeld kann fertil und nachgewiesen steril nicht unterscheiden. Anders geschriebene Namen erfordern zudem einen belegten Vertrag über wissenschaftliche Eingaben. Der Quellenagent prüft die Konsequenzen; ein allgemeiner Zulassungsnachweis für sterile Pflanzen wird daraus nicht abgeleitet.
- **O61C-TABLE-002 · TYPE_NULL · mittel**: `none` steht zusätzlich zu Häckseln/Einarbeiten in der Entfernungsmethodenliste. NPA-006 akzeptiert fehlendes/`none` auch bei ausdrücklich angegebenem Umbruchdatum. Das belegt eine fehlende positive Methoden- und Konsistenzprüfung; eine tatsächliche chemische Beseitigung wird nicht behauptet. Die Eingabeprüfung liefert dazu die abgestimmten Proben.
- **O61C-TABLE-003 · TABLE_CONSUMPTION · mittel**: Die fünf Antragstellerkategorien sind gespeichert, werden aber nicht als positive Typprüfung verwendet. Unbekannte/fehlende Typen erzeugen dadurch keine entsprechende Sperre. Unbekannte Enumwerte werden als Eingabestress außerhalb des vorgeschlagenen Vertrags ausgewiesen; bei garantiert vorgelagerter strenger Typprüfung wäre die Grenze dort zu schließen. Die Gebietskörperschaft ist eine maßnahmenabhängige Ausnahme, keine allgemein zulässige fünfte Kategorie.
- **O61C-TABLE-004 · FOREIGN_SCOPE · niedrig**: Die Matrix ist vollständig korrekt kopiert. Die generische Hilfsabfrage gibt für `x3)` dennoch `premium_deduction=false` neben dem einschränkenden Fußnotentext aus und löst die Kopfzeilenbedingungen 2/4 nicht auf. Das betrifft die Wiederverwendung für andere Matrixmaßnahmen. Die eigene 1C-Zeile bleibt vollständig leer; daraus entsteht kein zusätzlicher 1C-Berechtigungsbefund.
- **O61C-TABLE-005 · EXTERNAL_DEPENDENCY · niedrig**: Die fünf zusätzlichen Fälle höherer Gewalt sind korrekt, aber offen; amtliche Anerkennung, Nachweise und Fristberechnung folgen nicht aus der Tabelle. Die vier Modulationsbänder und die getrennt zu betrachtenden Maßnahmen 14/15 sind ebenfalls korrekt. Der Verbraucher setzt trotzdem eine sachgerecht als Heimfläche gelieferte Flächenbasis voraus. Der Allgemeinagent prüft diese externen Voraussetzungen sowie die gesetzlichen Sanktionen gesondert.

## Vollständiges Inventar

Das JSON enthält **586 direkte Ledgerzeilen** mit unveränderten Werten, konkreten Quellseiten, wörtlichen Belegen und genauen nativen Codezeilen. Sämtliche verschachtelten Werte bleiben erhalten. 658 Belegbindungen wurden gegen die Originaltextseiten verifiziert, ohne Fehlzitat. Die ursprünglichen sieben Datei-Hashes, alle 22 Zeiger und jede gespeicherte Zeile wurden erneut gegen den unveränderten Kandidaten geprüft. Wiederholte Zahlen oder Termine unter verschiedenen Parameterschlüsseln sind keine doppelten Zeilen; die 14 wissenschaftlichen Namen sind auch nach Kleinschreibung eindeutig.

Direkte Referenz bedeutet noch keine vollständige semantische Auswertung. Die Inventarzählung 18/19 für NPA/allgemeine Parameter entfaltet Arraywerte und unterscheidet sich deshalb von 11/17 direkten Objektschlüsseln.

| Container | Direkte Einträge | Inventarzählung | Verbraucher |
|---|---:|---:|---|
| `/premium_rates/rows` | 2 | 2 | direkt referenziert |
| `/modulation/bands` | 4 | 4 | direkt referenziert |
| `/modulation/separately_modulated_measures` | 2 | 2 | nicht referenziert |
| `/agroforest_negative_list/rows` | 14 | 14 | direkt referenziert |
| `/parameters/agroforest` | 8 | 8 | direkt referenziert |
| `/parameters/npa` | 11 | 18 | direkt referenziert |
| `/parameters/application` | 11 | 11 | direkt referenziert |
| `/parameters/general` | 17 | 19 | direkt referenziert |
| `/annex_l_combination/measures` | 21 | 21 | nicht referenziert |
| `/annex_l_combination/cells` | 420 | 420 | direkt referenziert |
| `/annex_l_combination/footnotes` | 4 | 4 | direkt referenziert |
| `/sanction_stages/rows` | 7 | 7 | direkt referenziert |
| `/multiple_reduction_order/rows` | 11 | 11 | direkt referenziert |
| `/public_body_exception_measures/rows` | 5 | 5 | direkt referenziert |
| `/one_year_measures/rows` | 13 | 13 | direkt referenziert |
| `/npa_farm_level_exclusions/rows` | 2 | 2 | direkt referenziert |
| `/minimum_management_exempt_areas/rows` | 6 | 6 | direkt referenziert |
| `/non_eligible_area_types/rows` | 10 | 10 | direkt referenziert |
| `/national_parks/rows` | 3 | 3 | direkt referenziert |
| `/permitted_land_use_conversions/rows` | 5 | 5 | direkt referenziert |
| `/force_majeure_cases/rows` | 5 | 5 | direkt referenziert |
| `/admissible_applicant_types/rows` | 5 | 5 | nicht referenziert |

Die Legende, der Gültigkeitsbeginn der Prämien und drei Sanktions-Metadaten außerhalb der 22 Inventarcontainer sind zusätzlich geprüft. Der Verbraucher des Kürzungsablaufs gibt nur dessen elf Schritte aus; das ist keine vollständige Ausführung der Zahlungskürzungen. Nicht referenzierte Parameter sind zeilenweise bezeichnet: etwa die separat gespeicherte Zwei-Jahres-Pflegefrist, das Jahresende nach Umbruch und die Beispielgeräte. Teilweise sind dieselben Grenzen unmittelbar im Code formuliert; „nicht referenziert“ bedeutet deshalb nicht automatisch „fachlich ausgelassen“.

Die fünf Fälle höherer Gewalt sind ausdrücklich eine **offene Beispielsammlung** nach GSP §6 („insbesondere auch“). Ein nicht bekannter Fallcode ist deshalb allein kein fachlicher Ablehnungsgrund. Beide 0,3-ha-Grenzen und alle Beschreibungen sind erhalten. Tabellenrichtigkeit ersetzt weder amtliche Anerkennung/Nachweise noch die gesetzlich richtige Fristberechnung.

Die 13 öffentlichen Quellproben erfassen alle zwölf uneingeschränkt genannten Arten neben Paulownia sowie ein konkretes Mitglied der gesamten Gattung Ölweiden. Paulownia-Fertilität prüft der Quellenagent gesondert; Entfernungsmethode und unbekannter Antragstellertyp sind mit dem Eingabeagenten abgestimmt. Hier wird keine eigene OPA-Ausführung behauptet. Die zentrale Ausführung verwendet die unveränderten nativen Policies/Daten und dokumentiert den numerischen Fehler der angehefteten Laufzeit getrennt. Kein privater Studienfall, keine Modell-Selbsttests als Sollwert und keine fachliche Freigabe.
