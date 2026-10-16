# Opus: gemeinsame Lösungspakete zur Durchsicht

**Vorschlag: WP1 und WP2 zuerst, danach gemeinsame Zeit-/Identitäts-, Klassifikations- und Berechnungsbausteine.** Die [Befundmatrix](cross-run-matrix.md) ist nach allen 26 Einzelprüfungen vollständig. Diese Pakete beschreiben eine mögliche gemeinsame Umsetzung; sie wurden noch nicht implementiert oder als App-Release freigegeben. Sammlung in [Issue #112](https://github.com/ghinta/oepul-rule-lab/issues/112), bestehendem Branch und [PR #111](https://github.com/ghinta/oepul-rule-lab/pull/111).

Die Verantwortungsaufteilung bleibt: Author und Domainexpert:innen arbeiten an fachlichen Entscheidungen und Abnahme zusammen. Technische Umsetzung und überprüfbare Vorschläge können anschließend vorbereitet werden. Für diese abgeschlossene Prüfung fehlt kein Nutzerinput; die nächsten offenen Entscheidungen betreffen konkrete Umsetzungsverträge und Quellenfragen unten.

## WP1 – App-Daten und Evidenzvertrag

Reihenfolge: zuerst. Voraussetzung: keine.

Konkretes Ergebnis:

- Inventar native Lesepfade → vorhandene App-Daten, neue manuelle Angabe oder externer Nachweis, jeweils mit Quelle und Geltungszeit.
- Versionierte Abbildung bis zum tatsächlichen OPA-Aufruf, einschließlich bestehender verlorener Regionen/Kulturen/Haltung.
- Klare Liste fehlender erforderlicher Angaben für Domainexpert:innen; Datenherkunft mitführen.

Abschlusskriterien:

- Tatsächlichen Payload pro unterstützter Maßnahme prüfen; keine bloßen gleichnamigen UI-/JSON-Felder als Erhaltung ausgeben.
- Bestehende produktive Adaptationen separat regressionsprüfen; historische Roh-Runs und Canonical bleiben im Audit unverändert.

Abgrenzung: Datenquelle und fachliche Erforderlichkeit werden vor dem Hinzufügen von UI-Feldern zugeordnet.

## WP2 – Einheitlicher Status und vollständiger Entscheidungsweg

Reihenfolge: mit WP1. Voraussetzung: WP1.

Konkretes Ergebnis:

- Gemeinsamer Ausgabevertrag für Datenvollständigkeit, aktuellen Vertrag, Zugang, Fläche/Tiere, Auflagen, behördliche Entscheidung und Betrag.
- Freigabe=false bei unbekannter erforderlicher aktiver Voraussetzung; Begründung und Roh-Unbekannt erhalten.
- Normale Anmeldung, genehmigte Übernahme, Wiedereinstieg, Abmeldung/Ausschluss und Rückforderung mit expliziten Quellenparametern.

Abschlusskriterien:

- Tatsächlicher bekannter Ausschluss und fehlender aktueller Claim können nicht durch einen positiven Helfer-/Komponentenbetrag übergangen werden.
- Eine gültige genehmigte Ausnahme darf nicht am gewöhnlichen Neuantragsfeld scheitern.
- Neue Auflagenabweichung bekommt keine erfundene pauschale100%-Behördenstufe.

Abgrenzung: Tool-Freigabe/Schätzung ist kein amtlicher Förderbescheid; Benennung und Umfang müssen zusammenpassen.

## WP3 – Gemeinsame Zeit-, Identitäts- und Umfangsbausteine

Reihenfolge: danach. Voraussetzung: WP1, WP2.

Konkretes Ergebnis:

- Datierte Ereignisse mit Tier-/Schlag-/Vertrags-/Kulturzuordnung; zulässige Jahresaggregate mit Herkunft und Berechnungsmethode.
- Wiederverwendbare Intervallschnitte, Jahresfilter und Fristklassen samt §5-Ausnahmen.
- Stabile physische IDs, Konfliktmeldung statt stiller Mengenverdoppelung, Geografie in Zählern und Nennern.

Abschlusskriterien:

- Vorjahresmahd, überjähriges Weideintervall, Nachbesetzungskette und aktuelle Vertragsgeschichte mit getrennten passenden Quellenregeln prüfen.
- Gleiche physische Fläche oder Tierkopie erzeugt keine weitere Einheit; widersprüchliche Daten werden klar benannt.
- Bereits vorgefilterte Jahresverträge werden unterstützt, ohne eine nicht versprochene Detailhistorie zu erfinden.

Abgrenzung: Ein allgemeiner Jahresschnitt oder Deduplikationsoperator ohne fachliche Episode/Identität reicht nicht.

## WP4 – Belegte Fachidentitäten und gemeinsame Tabellenprüfung

Reihenfolge: danach, mit WP3. Voraussetzung: WP1, WP3.

Konkretes Ergebnis:

- Kultur-/Sorte-/Art-/Kategorie-/Projektcode-Verknüpfungen mit belegten Aliasen; Produktzulassungen an Anwendung und Datum binden.
- Geprüfte Tabellen nach Originalhash/Version gemeinsam bereitstellen; vollständige Daten- und Verbraucherfälle erhalten.
- Geschlossene Mitgliederlisten von offenen Beispielen/Quellgruppen unterscheiden; spezifische Auflagen wie Nmin oder ND tatsächlich ausführen.

Abschlusskriterien:

- Bekannte Körner-/Silomaisidentität, Kultur-Sorte, Paprika-Nmin und Wechselwiese richtig zuordnen.
- Unbekannte Zulassung öffnet keine Ausnahme; Namenähnlichkeit allein ist kein Registerbeleg.
- Verbesserungen und Ausnahmen aus einzelnen Runs erhalten, insbesondere BIO gegenüber Herbizid-/Insektizidverzicht.

Abgrenzung: Die vorhandenen korrekten Listen müssen nicht je Maßnahme neu abgeschrieben werden.

## WP5 – Gemeinsame Betragsrechnung und Numerikvertrag

Reihenfolge: nach Status und Mengenbasis. Voraussetzung: WP2, WP3.

Konkretes Ergebnis:

- Geprüfte Mengenbasis, tatsächliche Stufen, Modulation, Obergrenzen und Rundungszeitpunkt in Quellenreihenfolge.
- Explizite Cap-/Überhangverteilung und Einheitenvertrag für andere Zahlungen; Heim-/Almrollen je Maßnahme.
- Exakte Grenzkontrollen unabhängig von nativer Policy; tatsächliche App-Binary und Build nachweisen.

Abschlusskriterien:

- Almglobalminimum14, Heimgutmodulation, Methodenverteilung9, Cap-Reihenfolge23 und strikte3%-Grenze getrennt bestehen.
- Kein widersprüchliches determined_area überschreibt stillschweigend bekannte lokale Nichteignung.
- Lokale Vorabrundung, interne Rechenreste, Zahlenschlüssel und separater Binary-Vergleich werden nicht als eine Ursache behandelt.

Abgrenzung: Keine pauschale universelle Zuteilung fremder Prämien und kein stiller Austausch historischer Binary/Pins.

## WP6 – Quellenkonflikte und verbleibende Maßnahmendetails

Reihenfolge: gezielt vor Aufnahme der betroffenen Maßnahme. Voraussetzung: WP2.

Konkretes Ergebnis:

- Kurzes Entscheidungsregister mit genauem Quellenpaar, betroffenem Feld/Verbraucher und Auswirkung.
- Fachliche Auflösung weniger offener Punkte mit Author und Domainexpert:innen; vorhandene GM-Konvention bleibt bestehen.
- Erst reparierte gemeinsame Bausteine und verbleibende individuelle Pflichtfälle fachlich abnehmen, dann Aufnahme/Release gesondert planen.

Abschlusskriterien:

- PSM-Angabe2026, Cap-Allokation, gedruckte85/500kg-Überlappung, enumPrimitive14 und konkrete Quellen-/Rundungsfragen explizit entschieden oder Ausgabe entsprechend begrenzt.
- Kein automatischer Expertenstatus aus öffentlichem Entwicklungsreplay oder abgeschlossenem Dossier.

Abgrenzung: Hier werden nur konkrete Prüf- und Lösungsvorschläge gesammelt. Implementierung, Merge und Serverrollout sind nicht Teil dieses Auditabschlusses.

## Wenige gemeinsame Entscheidungen vor der betroffenen Umsetzung

Die folgende Liste ist ein Entscheidungsregister für eine spätere gemeinsame Durchsicht, keine erneute Freigabefrage und kein Hindernis für den abgeschlossenen Prüfbericht. Besonders die bereits festgelegte Fehlend-Regel bleibt unverändert.

| Thema | Konkret zu klären | Bereits geklärt / Grenze | Dossiers |
|---|---|---|---|
| D1 – PSM-Angabe ab 2026 | Aktuellen GSP-§34-Auftrag gegenüber Merkblattentfall und konkret belegten Codes fachlich auflösen. | Unbekannte Zulassung erteilt keine Freigabe; Herb11 besitzt keine Bio-Herb-Ausnahme. | [o6_12](measures/o6_12/README.md), [o6_16](measures/o6_16/README.md) |
| D2 – Verteilung an Förderobergrenzen | Welche tatsächlichen anderen Zahlungen gehen nach welchen Reduktionen ein, und welche Maßnahme trägt den Überhang? | Quellenreihenfolge wird eingehalten; keine unbewiesene universelle WRRL-/N2-zuletzt-Zuteilung. | [o6_4](measures/o6_4/README.md), [o6_10](measures/o6_10/README.md), [o6_23](measures/o6_23/README.md), [o6_24](measures/o6_24/README.md) |
| D3 – Vorverarbeitung und Registerevidenz | Verantwortung und Beleg für Jahresmittel, Geometrie, Registerprodukt und Genehmigungsumfang im neuen App-Vertrag festlegen. | Erforderliche unbekannte Nachweise sperren Freigabe; dieselbe Frage nicht für jeden Run erneut stellen. | [o6_2](measures/o6_2/inputs.md), [o6_13](measures/o6_13/inputs.md), [o6_15](measures/o6_15/inputs.md) |
| D4 – Zahlprimitive und Rundung | Author-Vertrag für enum(1|2|3) und dokumentierte Rundung der gewichteten133,2kg festlegen; rechtliche Rundung nur mit Beleg behaupten. | Keine stille Konvertierung und kein Modellfehler allein wegen offener Primitive. N-Aufnahmekernfälle liegen sicher unter beiden Grenzen. | [o6_14](measures/o6_14/README.md), [o6_24](measures/o6_24/README.md) |
| D5 – Gewichts- und Haltungsgrenzen | Quellüberlappungen bei500kg/85kg und tatsächlich betroffene Ganzjahres-/Krankheits-/Kompostintervalle klären. | Kein beliebiger100%-Sanktionssatz für eine frische Diagnose. | [o6_21](measures/o6_21/README.md), [o6_22](measures/o6_22/README.md) |
| D6 – Frist- und Rechtsfassung | ATB-Literal17April2028 gegenüber GSP-Arbeitstagregel sowie fehlende GWSP-Vor-Juni2026-Fassung vor betroffener aktueller Aufnahme binden. | Normaler31Dezemberantrag ist ausdrücklich von §5-Verlängerung ausgenommen; 2028-Übernahme nach letztem Einstieg nur für mehrjährige Maßnahmen. | [o6_1c](measures/o6_1c/README.md), [o6_9](measures/o6_9/README.md), [o6_24](measures/o6_24/README.md) |
| D7 – Individuelle noch offene fachliche Quellenlesarten | Kurze äußere Lücke, BAW-GIS-Viertelregel, Milchblock-/Betreuungsumfang und gekoppelte Weide-Halbierung nur in den betroffenen Maßnahmen entscheiden. | Keine identische darstellbare Eingabe mit verschiedenen externen Kontexten als unabhängiges deterministisches Gold ausgeben. | [o6_7](measures/o6_7/README.md), [o6_8](measures/o6_8/README.md), [o6_15](measures/o6_15/README.md), [o6_20](measures/o6_20/README.md) |

## Was die spätere Umsetzung erhalten soll

Korrekte Tabellen und vorhandene gemeinsame Fälle bleiben Kontrollanker. Unterschiede wie Kategorie-null in 14 gegenüber 15, Schätzkennzeichnung in 12, einjährige gegenüber mehrjährigen Vertragswegen, ein tatsächlicher Ersatz-Förderplatz in 5 und fachlich unterschiedliche Herb-/Insektizidausnahmen bleiben ausdrücklich modelliert. Gemeinsame Bausteine brauchen Quellenparameter und klare Geltungsbereiche.

Die Umsetzung soll zuerst eine konkrete Auswahl unterstützter Maßnahmen mit verlässlicher Datenherkunft und verständlichen fehlenden Nachweisen ermöglichen. Eine bloße Übernahme aller zusätzlichen JSON-Felder oder das Anzeigen eines positiven Rohbetrags erreicht dieses Ergebnis nicht. Der Scope jeder späteren App-Aufnahme wird mit den jeweils verfügbaren echten Daten und geklärten Quellen festgelegt.

Tests werden an den gemeinsamen Verträgen und konkreten früheren Gegenfällen ausgerichtet. Erfolgreiche Reproduktion eines historischen Fehlers ist kein Bestehen des reparierten Fachsolls. Eigene falsche oder nur bedingte Prüfkonstruktionen bleiben entsprechend markiert. Vor einer behaupteten Freigabe stehen die tatsächliche App-Payload-Abbildung, vollständige Ergebnisbedeutung und fachliche Abnahme.

Neue Einzelbranches oder Implementierungen pro Maßnahme werden durch diesen Plan nicht gestartet. Auch die endgültige Aufteilung späterer Änderungen ist noch keine Entscheidung dieser Sammlung. Serverzugang und manuelle SQL-Schritte übernimmt der Nutzer selbst; dafür werden hier keine Zugangsdaten angefragt.
