# o6_12 – Tabellen, Listen und tatsächliche Verbraucher

Geprüft wird ausschließlich der rohe Run `v2-o6_12-opus-5.5-high-20261009` am unveränderten Kandidatencommit `e009eed4a83ff076b26eba33ac433ac2b0642621`. **11 native Datendateien enthalten 32 Inventarpointer mit tatsächlich 252 direkten Einträgen und einem zusätzlichen Metadatenblatt außerhalb dieser Container.** Fünf deklarierte Containerzählungen weichen davon ab; die Inventarsumme beträgt 272. Sämtliche tatsächlichen Werte einschließlich verschachtelter Felder, Bezeichnungen, Nullwerte, Einheiten, Jahrgänge, Qualifikationen und Fußnoten stehen zeilenweise im JSON.

Das neue Maßnahmenblatt mit vier Seiten wurde vollständig persönlich gelesen, einschließlich Tabellen, Ausnahmen, Aktualisierungen und Impressum. Sämtliche sechs Produktionsmodule mit 1.063 Zeilen und die gesamten Rohnotizen einschließlich aller 17 nummerierten Annahmen wurden gelesen. Acht identische gemeinsame Originale werden mit Hashbindung und dokumentierter früherer Volllektüre wiederverwendet; die aktuellen Klauseln und Verbraucher wurden erneut verglichen. Die GSP-AV mit 94 Seiten ist diesem Paket tatsächlich bereitgestellt. NAPV und der extern verwiesene EU-Artikel 3 werden nicht als zusätzliche bereitgestellte Originale behandelt.

## Tatsächliches Inventar

Die Zahlen summieren direkte Elemente der deklarierten Container. Enthält ein Elterncontainer eine ebenfalls separat inventarisierte Liste, überlappen die Zählbereiche; 252 ist keine Zahl unterschiedlicher atomarer Fakten. Die fünf Differenzen begründen einen Inventarzählbefund, keine erfundenen fachlich fehlenden Tabellenzeilen.

| Datei | Pointer | Tatsächlich | Deklariert |
|---|---|---:|---:|
| `combination_anhang_l.json` | `/combination_anhang_l/cells` | 20 | 20 |
| `combination_anhang_l.json` | `/combination_anhang_l/footnotes` | 4 | 4 |
| `combination_anhang_l.json` | `/combination_anhang_l/legend` | 3 | 3 |
| `contract_periods.json` | `/contract_periods` | 3 | 3 |
| `contract_rules.json` | `/measure_switches` | 1 | 1 |
| `contract_rules.json` | `/takeover_rules` | 7 | 8 |
| `contract_rules.json` | `/area_reduction_tolerance` | 4 | 5 |
| `contract_rules.json` | `/area_reduction_tolerance/allowed_conversions` | 2 | 2 |
| `contract_rules.json` | `/applicant_types` | 5 | 5 |
| `contract_rules.json` | `/public_body_exempt_measures` | 5 | 5 |
| `contract_rules.json` | `/minimum_farm_size_first_year` | 3 | 14 |
| `contract_rules.json` | `/force_majeure_cases` | 6 | 6 |
| `contract_rules.json` | `/force_majeure_rules` | 1 | 1 |
| `fruit_crops.json` | `/fruit_crops` | 35 | 35 |
| `ineligible_areas.json` | `/ineligible_usage_types` | 6 | 6 |
| `ineligible_areas.json` | `/national_park_rules` | 4 | 4 |
| `ineligible_areas.json` | `/no_premium_codes` | 2 | 2 |
| `ineligible_areas.json` | `/op_code_mandatory_cases` | 7 | 7 |
| `measure_parameters.json` | `/measure_parameters` | 18 | 23 |
| `measure_parameters.json` | `/measure_parameters/eligible_crop_categories` | 3 | 3 |
| `measure_parameters.json` | `/measure_parameters/eligible_land_use_codes` | 3 | 3 |
| `notices_2026.json` | `/rebzikade_2026` | 10 | 12 |
| `notices_2026.json` | `/rebzikade_2026/states_with_control_ordinances` | 3 | 3 |
| `notices_2026.json` | `/drought_2026_harvest_districts` | 41 | 41 |
| `payment_parameters.json` | `/modulation_bands` | 4 | 4 |
| `payment_parameters.json` | `/area_payment_caps` | 9 | 9 |
| `payment_parameters.json` | `/payment_rules` | 7 | 7 |
| `premium_rates.json` | `/premium_rates` | 6 | 6 |
| `psm_codes.json` | `/psm_codes` | 3 | 3 |
| `sanction_parameters.json` | `/sanction_levels` | 7 | 7 |
| `sanction_parameters.json` | `/sanction_rules` | 9 | 9 |
| `sanction_parameters.json` | `/reduction_order` | 11 | 11 |

Das einzelne Blatt außerhalb der Container ist die Kennung der eigenen Kombinationstabellenzeile. Es wird nicht direkt gelesen. Auch Metadaten innerhalb der Container wurden geprüft: Die JSON-Zeilen nennen je Container ausgewählte Felder und die übrigen gespeicherten Qualifikationen. Ein nicht gelesener Tabellenwert kann im Code separat hardcodiert sein; fehlende direkte Feldreferenz allein ist deshalb kein fachlicher Gegenfall.

## Kombinationen: eigene Zeile und Originalumfang

Die vollständige, unabhängig am identischen Original erstellte Transkription aus o6_8 bindet 21 Codes, 134 positive Koordinaten, 286 leere Offdiagonalpaare und 21 separat behandelte Diagonalen. **Der aktuelle native Datensatz speichert ausschließlich die eigene Zeile 12 mit 20 Gegenmaßnahmen.** Es wird keine vollständige native 134-Zellenmatrix dieses Runs behauptet.

Die eigene Zeile und alle Headerfußnoten wurden zusätzlich frisch am Originalbild von Anhang L, PDF-Seite 103, angesehen. Vier Partner sind positiv: 1A mit Fußnote 1, 2, 10 mit Fußnote 3 und 11. Die übrigen 16 eigenen Paare sind leer; die eigene Diagonale ist ausgelassen. Der aktive Konflikthelper und der Landschaftselemente-Marker benutzen diese eigenen Zellen. Sortierte Erwartungsmengen werden aus den Originalmitgliedern mit externer deterministischer Sortierung hergestellt.

Die Headerverweise 13→2 und 16→4 stehen in `cell.footnote`, obwohl die eigenen Zellen leer sind. Es sind Headerqualifikationen und keine zusätzlichen positiven Zellfußnoten. Der entsprechende Headerverweis 8→4 fehlt. Vier gespeicherte Fußnotentexte ersetzen diese Zuordnung nicht. Alle drei eigenen Paare bleiben bereits leer; daraus entsteht kein eigener monetärer Gegenoracle. Die engere Modellierungsgrenze bleibt dokumentiert.

1A erlaubt nur die Abgeltung von Landschaftselementen. Die betriebliche BIO-Teilbetriebsausnahme ist eine andere Ebene als eine positive BIO-/12-Kombination auf derselben Weinfläche. Bei 10 betrifft der Abschlag den optionalen Zuschlag für Organismen oder Pheromone: SRL 2.10, Seite 65, verlangt bei Teilnahme an 12 eine Reduktion um 50 %. Der ausgegebene Faktor begründet weder eine allgemeine Halbierung der Maßnahme 10 noch die vollständige Berechtigung zum Zuschlag. Das gespeicherte `premium_discount` wird nicht selbst vom Faktorhelper gelesen.

## Obst, Prämien und betrieblicher Verzicht

Die Originale nennen 31 kurze Grundnamen und drei zusätzliche Kulturen ab 2025: Felsenbirne, Maulbeere und Papau. Der aktuelle Datensatz ergänzt eine technische Sammelposition „Andere Schalenfrüchte“ und enthält damit 35 Zeilen. Diese Sammelposition ist keine zusätzlich individuell benannte Originalkultur. Aronia und verwandte Züchtungen, Brombeere und Kreuzungen sowie Haselnuss und andere Schalenfrüchte sind weiter gefasste Gruppen. Der Namenshelper liest nur den exakten Schlüssel und das Gültigkeitsjahr, nicht die Notizen; die Liste ist kein vollständiger botanischer Arten- oder Kultivarkatalog.

**Walnuss und Edelkastanie sind bei Maßnahme 12 nicht ausdrücklich von der Prämie ausgeschlossen.** Die Beschränkung aus dem Herbizidverzicht der Maßnahme 11 wird nicht importiert. Für bekannte, qualitativ hochwertige und veredelte Anlagen gelten die Obstkriterien und die eigene Obstprämie; unveredelte Bäume und OP-codierte Flächen sind eine andere Rolle. Die sechs Ratenzeilen enthalten für Wein, Obst und Hopfen jeweils 250 €/ha im Jahr 2023 und 270 €/ha ab 2024. Ein gültiger Tarifhelper ist keine vollständige Zahlungsfreigabe.

Der Insektizidverzicht erstreckt sich auf die gesamte Wein-, Obst- und Hopfenfläche des Betriebs und ist von der einzelnen Prämienfähigkeit zu trennen. Schnittweingärten zählen ausdrücklich zur Weinfläche, Rebschulen nicht. Der genaue Ausschluss sonstiger Wein-/Spezialkulturflächen von der Mindestteilnahme sowie die Reichweite der Baumschulausnahme bleiben die benannten nativen Annahmen 8 und 3; sie werden nicht durch einen reinen Datenexport rechtlich entschieden. Positive Bio-Zulässigkeit ist ein eigener Sachverhalt. Ein Code oder das Fehlen eines chemischen Flags beweist keine reale Produktzulassung oder Registerprüfung.

## Vertrags- und allgemeine Tabellenqualifikationen

Die drei Vertragsstarts 2023, 2024 und 2025 ergeben sechs, fünf und vier Jahre bis Ende 2028. Die Antragsfristen liegen jeweils am 31. Dezember des Vorjahres. Mindestfläche von 0,5 ha im ersten Verpflichtungsjahr, Betriebsmindestgröße im ersten allgemeinen ÖPUL-Jahr und jährlich flexible Maßnahmenfläche sind getrennte Bedingungen. Maßnahme 12 bleibt mehrjährig, obwohl ihre Fläche jährlich variieren darf. Die allgemeine Toleranzformel mit 5 %, höchstens 5 ha und jedenfalls 0,5 ha wird deshalb nicht als eigener Rückzahlungsauslöser dieser Maßnahme ausgegeben.

Die April-Termine bei Übernahmen werden als wörtliche ATB-Tabelle geprüft: 15. April, in den Jahren 2023 und 2028 am 17. April. Die davon getrennte Auslegung der GSP-Regel zu Feiertagen wird nicht durch diesen Tabellenvergleich erledigt. Gleiches gilt für positive AMA-Genehmigung, bisherigen Nichtteilnehmerstatus und die 50-%-Erweiterungsgrenze. Mehrere gespeicherte Voraussetzungen werden im aktuellen Code separat hardcodiert oder nur durch Ablehnung eines ausdrücklichen `false` behandelt; das Tabellenflag ist kein Nachweis einer tatsächlichen Genehmigung.

Die fünf Rechtsformzeilen und fünf zeitlich qualifizierten fremden Gebietskörperschaftsausnahmen wurden vollständig verglichen. Die SRL erfasst bestimmenden öffentlichen Einfluss und Einrichtungen weiterer Stufen breiter als eine reine Kapitalgrenze. Die beiden Betriebsmindestgrößen sind richtig; die zwölf enthaltenen Flächencodes werden jedoch nicht aus Einzelflächen aufsummiert. Eine flache Liste ersetzt auch nicht die zeitlichen Bedingungen für K20 und Agroforststreifen.

Sechs Einträge höherer Gewalt bestehen aus einem externen EU-Verweis und fünf ausdrücklich nicht abschließenden nationalen Beispielen. Zwei gespeicherte 0,3-ha-Grenzen werden im nativen reinen `case_id`-Mitgliedschaftshelper nicht gelesen. Weder eine Katalogkennung noch eine passende Meldefrist ist allein eine materielle Anerkennung. Die Liste wird nicht als vollständig geschlossene Menge aller denkbaren Fälle ausgegeben.

## Codes und Hinweise 2026

Alle drei PSM-Codezeilen mit Bezeichnung und Gültigkeit stimmen mit dem Maßnahmenblatt überein. Die gesamte Datentabelle wird jedoch nicht vom Code gelesen; die tatsächlich wirksamen PSM-Codes sind hardcodiert. Der Hauptpfad berücksichtigt die Jahresgrenze 2025, der reine `required_psm_codes`-Helper selbst enthält diese Jahresgrenze nicht.

**Der Konflikt für 2026 bleibt offen:** Das neue Maßnahmenblatt lässt die Codierung entfallen; die tatsächlich bereitgestellte GSP-AV § 34 Abs. 2 Z 12 lit. f nennt weiterhin die Pflanzenschutzmittelangabe für 70-10, und SRL-Seite 25 behandelt sie als Bewirtschaftungsauflage. Der Tabellenfall für 2026 prüft ausdrücklich nur die dokumentierte Implementationskonvention des Maßnahmenblatts. Er ist kein rechtlich aufgelöster Sollfall oder Genauigkeitsbeleg.

Der Rebzikade-Hinweis unterscheidet den rückzahlungsfreien Ausstieg aller Betriebe mit Weinflächen von der Sonderregelung behördlicher Bekämpfung in bestimmten Gebieten dreier Bundesländer. Steiermark, Burgenland und Niederösterreich sind als Verordnungsstaaten korrekt gespeichert; diese Liste begrenzt nicht den bundesweiten Weinbetriebs-Ausstieg. Genehmigung, Antragsjahr 2026 ohne Prämie, Ende ab einzelbetrieblicher Meldung, Bio-Vorrang und Dokumentation am Betrieb bleiben relevante Bedingungen. Eine Übermittlung an die AMA ist laut Hinweis nicht erforderlich. Native Annahmen zu fehlender Genehmigung, Folgejahren sowie Anwendung der 2026-Regeln in anderen Jahren bleiben als solche benannt.

Die Dürre-Gebietsliste umfasst vollständig 41 Zeilen: Burgenland und Wien mit je einer Wildcard, 22 Bezirke Niederösterreichs, elf Oberösterreichs und sechs ab 12. August hinzugekommene steirische Bezirke. Originalschreibweisen und Publikationsdaten stimmen. Der aktuelle Helper liest nur Bundesland und Bezirk; die Gebietsliste allein reicht nicht für die automatische Ernteausnahme. Das Original verlangt eine üblicherweise erst im Spätsommer oder Herbst geerntete Ackerkultur und einen dürrebedingt nicht erntbaren Bestand. Wein-, Obst- und Hopfenflächen werden dadurch nicht automatisch ausgenommen. Farmbezirk und Einzelflächenbezirk bleiben ebenfalls getrennte Sachverhalte.

## Zahlungen, Obergrenzen und Sanktionen

Alle vier Modulationsbänder und neun historischen Obergrenzenzeilen samt Maßnahmeausnahmen wurden geprüft. Der Betriebsfaktor setzt die relevante Heimfläche voraus; Alm und Behirtung sind getrennt zu behandeln. Die gespeicherten Cap-Ausnahmen werden nicht aus den anderen Zahlungen herausgerechnet. Der Caphelper gibt lediglich einen Überschreitungsbetrag aus, keine Verteilung oder bereits in der Schätzung vollzogene Kürzung. Die Quelle bestimmt die Zurechnung nicht; native Annahmen 11 und 12 bleiben offen.

Die sieben Zahlungsparameter enthalten Kann-Bagatellregel, maximale Vorauszahlung, Auszahlungszeitraum, Rückzahlungsfrist und bedingte Wiedereinziehungsgrenzen. Die drei Rückforderungsparameter werden nicht benutzt. Sie ergeben keine automatische Zahlungs- oder Rückzahlungsbefreiung. Die vollständigen elf Kürzungsschritte liegen als unbenutzte Daten vor; die Schätzung verarbeitet nur Flächenprüfung, inhaltliche Kürzung und Modulation.

Sieben amtlich zugeteilte Sanktionsstufen und der Wechsel von Verwarnung zu 1 % ab 2027 stimmen mit der bereitgestellten GSP-AV überein. Wiederholung, Kumulation und Deckelung sind davon zu unterscheiden. Ausschluss nach zweimaliger vollständiger Kürzung ist eine separate Bedingung und keine achte nummerierte Stufe. Die reale Einstufung bleibt eine amtliche Eingabe; ein beliebiger Bewirtschaftungsverstoß führt durch diese Tabellenprüfung nicht automatisch zu 100 %.

## Befunde und öffentliche Entwicklungsprobes

Fünf Gruppen sind dokumentiert: zwei geringe Befunde zu den Inventarzählungen und den Headerfußnoten sowie drei Informationsgruppen zu offenen Obstgruppen, begrenzten Verbrauchern und den sachlichen Qualifikationen der 2026-Hinweise. Es wurden keine nativen Regeln, Daten, Originale, Canonical-Felder oder App-Dateien verändert.

35 frische öffentliche Probes decken sämtliche eigenen Kombinationen, bekannte Obstschlüssel und Jahresgrenzen, qualifizierte Obsttarife, drei Vertragszeilen und vier Start-Lookups, sechs Ratenzeilen, drei Codes, den tatsächlichen 2025/2026-Pfad, Parks, allgemeine Toleranz, sämtliche Modulationsbänder, alle 41 Bezirkszeilen, Hinweisrollen, Übernahmetermine, sechs Beispielkennungen höherer Gewalt, Rechtsform-/Ausnahmekataloge, neun Obergrenzenzeilen und sieben Sanktionsstufen ab. Quellenarrays wurden unabhängig aus den Originalen bzw. der hashgebundenen unabhängigen Originaltranskription gebildet. Historische Selbsttests, tatsächliche Modelloutputs, private Studienfälle oder Expertenurteile liefern keine Erwartungswerte.

Der isolierte Lauf ist mit dem gepinnten Root-OPA, deaktiviertem Netzwerk, blockierten Fähigkeiten, nativen Verzeichniswurzeln, strikter Kompilierung und strikten Builtinfehlern erfolgt. 35 Ergebnisse sind definiert und alle 35 Erwartungen erfüllt. Dies ist eine öffentliche Entwicklungsprüfung mit ausdrücklich begrenzten Helper- und Implementationskonventionen, keine Genauigkeitsmessung oder Domänenexpert:innen-Abnahme.

Der abschließende Census bindet sämtliche elf nativen Datendateihashes, 32 tatsächliche Container mit allen 252 direkten Werten sowie das erneut enumerierte einzelne übrige Metadatenblatt. Die fünf Abweichungen zur deklarierten Summe 272 bleiben ausdrücklich dokumentiert. 1.533 Belegvorkommen mit 98 unterschiedlichen Quellen-/Seiten-/Zitatbindungen und 45 Codeverweise sind ohne offene Fehler geprüft. Der Literalvergleich verwendet ausschließlich Whitespace-Normalisierung gegen Plain- oder Layout-Extraktion derselben hashgebundenen Seite, keine Unicode- oder Satzzeichenumschreibung. Er ersetzt keine Volllektüre.

Alle vorhandenen Typen und expliziten Enumwerte der 35 Inputs wurden gegen das unveränderte Canonical-Profil mit den tatsächlichen Run-Erweiterungen geprüft: 820 skalare Werte, 209 Objekte und 199 Arrays, darunter 79 Enumvorkommen; keine Abweichung. Von den skalaren Werten gehören 216 zu separat deklarierten temporären Helperargumenten. Fehlende Eingaben, vollständige Sachverhalte, reale Produktverfügbarkeit und rechtliche Genehmigung werden dadurch nicht zertifiziert. Seit dem isolierten Vorlauf blieben alle Inputs, Querys und Erwartungen unverändert; ergänzt wurden nur Quellen-/Prüfmetadaten. Die Fallprojektion ist gesondert per SHA-256 gebunden.

**Tabellen-JSON und Markdown sind eingefroren. Der gemeinsame vollständige Root-Replay und die unabhängige QA stehen noch aus.** JSON-SHA256: `56ee3fcc3475fd25823c95f25690cb0bed167f8878a9e18e84e675d346adea3b`.
