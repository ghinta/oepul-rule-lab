# o6_16 – Eingabevertrag und tatsächliche App-Projektion

121 öffentliche Entwicklungsfälle mit 125 typisierten Prüfungen: 115 erfüllt, 10 nicht erfüllt. Native Statuswerte: `{'defined': 115, 'runtime_error': 6}`. Das sind gezielte Entwicklungsfälle, keine Genauigkeitsquote oder Expertenabnahme.

Alle 34 add-Vorschläge mit 142 Blättern sind in [inputs.json](inputs.json) vollständig mit tatsächlichen Deskriptoren, Bedeutung, Einheiten, Quellen, Kontext und Verbrauchern dokumentiert. 141 Blätter haben zusammen 186 kontextuelle, qualifizierte Lesestellen. Nur seed_dressing wird nicht gelesen; alle Anwendungseinträge einschließlich gebeizten Saatguts können bereits gemeinsam codierungspflichtig sein, sodass ein ungenutztes Zusatzflag allein noch keinen fachlichen Fehler beweist. Die beiden dynamischen AG-Schlüssel grazing/threshing wurden auf die tatsächliche geschlossene Zweierliste gebunden. Ein gleichnamiges date in einer anderen Variablen gilt nicht als Lesestelle.

Hinzu kommen 15 tatsächlich konsumierte Pfade des unveränderten Canonical. Nicht vorgeschlagene, nicht zum Canonical gehörende zusätzliche Eingabepfade wurden nicht erfunden. In diesem Vertrag gibt es gewöhnliche String-Enums, keine aus früheren Maßnahmen kopierte numerische Enum-Mehrdeutigkeit.

Die Prüfgruppe enthält für alle 58 nullable Vorschlagsblätter jeweils null und fehlend in einem passenden Zweig, insgesamt 116 technische Verfügbarkeitsfälle. Weitere fünf prüfen Probenidentität, Zeitkonsistenz, positiven Protein-Nachweis und den fehlenden Vorbewirtschafter bei bekanntem eigenem AG-Anlagejahr. Das Soll „definiert“ bescheinigt allein die Verfügbarkeit einer Ausgabe, keine fachliche Freigabe oder vollständige Eingabe. Alle vorhandenen Eingabewerte wurden gegen die tatsächlichen Canonical-/Vorschlagsformen geprüft; Pflichtfeldvollständigkeit, Identität, Zeit und Wahrheit sind zusätzliche Fragen.

| Echter Laufzeitfehler bei ausdrücklich nullable Eingabe | Betroffener Pfad |
|---|---|
| `O616-IN-NULLABLE-09-NULL` | `farm.oepul.o6_16.gwa_arable_area_mfa_2026_ha` |
| `O616-IN-NULLABLE-12-NULL` | `farm.oepul.o6_16.area_previous_year_ha` |
| `O616-IN-NULLABLE-13-NULL` | `farm.oepul.o6_16.area_current_year_ha` |
| `O616-IN-NULLABLE-14-NULL` | `farm.oepul.o6_16.area_lost_disposal_right_ha` |
| `O616-IN-NULLABLE-52-NULL` | `livestock.species_groups[].annual_average_count` |
| `O616-IN-AG-NULL-PREVIOUS-HOLDER-OWN-YEAR` | `AG previous_holder_establishment_year=null bei bekanntem eigenem Anlagejahr` |

Eine Bodenprobe dreifach mit derselben Identität wird als drei Proben gezählt. Eine 2027 gezogene, angeblich schon 2025 übermittelte Probe wird ebenfalls angerechnet. Das sind absichtlich ungültige Identitäts-/Zeitkonstellationen mit formal gültigen JSON-Werten, keine drei echten Laborproben. Fehlende relevante Proteingehalte passieren die numerische ≤-Prüfung wegen der Rego-Werttypenordnung. Das ist ein gewünschter Positivnachweis-Gegenfall und kein behaupteter realer Proteinüberschuss.

Ein separater Satz von sieben technischen Kontrollen erklärt den undefinierten Weizen-Helfer aus dem Tabellenblock: 14 wird mit %.1f als `%!f(int=14)` formatiert, 14.0 als `14.0`. Nur der zweite Schlüssel findet den Quellenwert 22,6. Der direkte Vergleich 15==15.0 ist korrekt. Diese Darstellungsempfindlichkeit bleibt getrennt vom bereits dokumentierten 60/17-Befund zu Zahlenvergleichen derselben gepinnten Binary. Kein neuer OPA-Pin und keine Aussage über sämtliche OPA-Versionen.

Die echte App-Funktion adapt_payload_for_measures wurde am gebundenen Commit 529eadb34c4fdd249fbf739a372d63185b7374a2 importiert und auf eine ausdrücklich technische Strukturvereinigung angewandt. Beide SQL-Ausführungswege waren schon vor Django-Setup gesperrt; null SQL-Aufrufe. Alle 34 zusätzlichen Wurzeln und 142 Blätter gehen für diesen nativen Vertrag verloren. Von 15 weiteren Canonical-Pfaden bleiben acht nativ erhalten; beispielsweise liegt der Kulturtext in der App teilweise als raw_label statt unter dem benötigten crop.crop_name vor. Das bedeutet fehlende Roh-Run-Abbildung und bewertet nicht pauschal die vorhandenen anderen App-Funktionen.

Die exakte App-Projektion wurde zusätzlich separat nativ ausgeführt: definiert, Zugang false, Prämie 0, Gebietsfläche/Bildung/Proben jeweils 0. Diese strukturelle Projektion ist kein tatsächlicher Betrieb und erhöht die Quellenfallzahl nicht. Hashes, Eingabe, Ausgabe und SQL-Sperre sind im JSON enthalten. Alle 359 nativen Zitate wurden auf ihren gebundenen Originalseiten gefunden, darunter sämtliche 85 tatsächlichen Vorschlagsbelege; sämtliche 1918 angegebenen Verbraucherbereiche liegen in den tatsächlichen Dateien. Diese Kontrolle bestätigt das wörtliche Vorkommen nach Whitespace-Normalisierung und die Bereichsgrenzen; wörtliches Vorkommen ersetzt keine semantische Abnahme.
