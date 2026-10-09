# Block 4: Mittel, Futter, Düngung und Bewirtschaftung

Stand 08.10.2026 · gezielter Quellen-/App-Abgleich nach den Einzelprüfungen ·
App-Pin `5296108f5756ef1463c25a49d93d4a346e9b5e9c` · historische Quellenbasis
`7a296d28cb5b92e2758c5a3889c929ea1db60fe5`.

Die App erfasst bisher einzelne Mengen, Bools und einfache Ereignislisten.
Für die Maßnahmen fehlen verknüpfte Produkte, Chargen, Rationen, Kulturketten,
Flächen-/Tiergruppenbezüge sowie Einheiten und Zeiträume. Die generische
Maßnahmenprüfung bleibt auch bei ausgefüllten vorhandenen Eingaben vorsichtig
`missing_data`. Neue Felder allein liefern deshalb noch keine fachlich
bestätigte Empfehlung: Erfassung, Adapter und konkrete Regelprüfung müssen
denselben bestätigten Vertrag verwenden.

Dieser Bericht ergänzt die [Einzelprüfungen mit vollständigen historischen
Variablendiffs](../sequential-variable-reviews-20261008/README.md).
Neue Canonical-Pfade, Modellaliase und fachliche Aufnahme bleiben offen.
Die gemeinsamen Belege bauen auf den geprüften Flächen-/Tieridentitäten auf;
ihre Berechnung bleibt maßnahmenspezifisch.

## Vorher / benötigte Ergänzung

| Heutiger geprüfter App-Pfad | Tatsächlicher Umfang | Benötigte Ergänzung |
| --- | --- | --- |
| `land.parcels[].operations.psm_used` | Generischer Einsatz-Bool, ohne Produkt-/Wirkungsklasse oder Beizungsscope. | Produkt-/Wirkstoff-/Organismus-ID und gültige Zulassung, Anwendung/Kultur/Teilfläche/Datum; Verbots- und Ausnahmeart je Maßnahme. |
| `oepul.shared.parcels[].psm_applications` | Datum, Produktname, dimensionslose Menge. | Menge samt Einheit/Dosierungsbasis, tatsächliche behandelte Fläche, Produkt-/Indikations-/Versionsbezug und Beleg. |
| Betriebsaggregat `nitrogen_input_kg_per_ha` und `nutrient_balance_complete` | Dokumentierbare Werte; kein allgemeiner fachlicher Bilanz-/Kulturkettennachweis. | Eigener Tierhaltungsanfall, tatsächlich ausgebrachter N und jahreswirksamer N mit unterschiedlichen Verlust-/Faktor-/Flächenscopes. Bestätigte Aggregate bleiben zulässig. |
| Schlag-`fertilizer.mineral_n_kg_per_ha` / `organic_n_kg_per_ha` | Im Blueprint/Adapter, ohne registrierten Editor oder normative Bilanzprüfung. | Tatsächliche Anwendungen, Materialherkunft/Analyse, Bewässerung, Vorfrucht/Kultur/Entzug, Nmin und vollständiger Zeitraum. N=0 belegt keinen Verzicht auf jede Düngung. |
| AMA-Ausbringungsmengen und `species_groups[].manure` | Mengen je Verfahren erhalten; Typ/volumenstärkstes Verfahren an erster Tiergruppe, im allgemeinen Adapter wieder entfernt. | Betriebscharge und tatsächliche Schlag-Ausbringung mit Verfahren/Gerät/Menge/Datum verknüpfen; Separation, Transport und Einarbeitung getrennt. |
| o6_3-Futter-Bools / allgemeine Tierereignisse | Eigene Heuwirtschaftsfakten, keine Rations-/Chargenprüfung für Schweine. | Futterprodukt, Charge/Lager, Rezeptversion, Tier-/Gewichts-/Fütterungsphase, Menge, Proteinwert und Trockenmassebasis. |
| Rohdaten für Sorte/Begrünung und MS/DS-Proxies | Keine vollständige tatsächliche Saatmischung oder Saat-/Bearbeitungsfolge. | Arten-/Sorten-/Familien-/Losnachweis, Mengenanteil mit Einheit, tatsächliche Aussaat und beobachteter Bestand separat. |
| Schnittdaten und `management_events` | Datum beziehungsweise freier Typ/Datum. | Mahd, letzter Abtransport, Pflege, Mulchen, Walzen, Striegeln, Nutzung, Umbruch und Ernte als getrennte Ereignisse mit Wirkungsfläche und Reihenfolge. |
| Nützlings-/geschützter-Anbau-Collections | Arten-/Datumsangaben und lose Anbauflags; kein vollständig verknüpfter Anwendungsscope. | Produkt/Organismus oder Pheromonverfahren, reale Anbaufläche, Einsatzmenge/-frequenz und Mittelbezug getrennt prüfen. |
| Generischer Collection-Editor / Auto-Generator | Editor schreibt Szenario-Endpunkt; Generator speichert Arbeitskopie/EvaluationRun. | Aktuelle Belege und typisierte neue Objekte in der Oberfläche anbinden; eigener dokumentierter Auto-Farm-Snapshot bleibt umzusetzen. |

[app-paths.json](app-paths.json) dokumentiert 32 Istbeobachtungen, 61 verifizierte
Code-/Registry-Verweise und 22 Dateihashes am aktuellen App-Pin. Ein
Blueprintpfad, ein importierter Rohwert und ein von der Regel konsumierter
Wert sind unterschiedliche Implementierungsstände.

Die Collection-API kennt `unknown`, `confirmed_empty` und `has_entries`.
Die generische Policy behandelt eine leere Liste weiterhin als fehlend;
die native o6_3-Schnittprüfung hat einen eigenen Leer-Scope. Dokumentierte
Nichtanwendung muss im passenden Regelvertrag als Leerbefund auswertbar werden.

## Wiederverwendbare Fakten, getrennte Scopes

| Gemeinsame Erfassung | Unterschied, der erhalten bleiben muss |
| --- | --- |
| Produkt, Wirkstoff/Organismus, Anwendung, Indikation und Zulassungsfassung | BIO-Ausnahme für DIV/NPA/2/Bergmahd/Alm gegenüber engerem Verbissschutz bei AFS/Hecken. Herbizidverzicht11 kennt keine allgemeine BIO-Ausnahme. Fahrgassen10, Begrünung6/7, BAW8 und AG16 haben eigene Verbotsfenster. |
| Herkunft, Eingang/Lager/Verbrauch, Transport und tatsächliche Mengen | Kauf/Lagerung belegt keine Anwendung. Eigen-/Fremdmaterial, zulässige Biogas-Rücknahme und Almherkunft benötigen ihre eigene Materialflusskette. |
| Tierhaltungs-N, Analyse/Faktor und Flächeninventar | o6_2: eigener N-Anfall nach Stall-/Lagerverlusten und Almabzug je österreichischer LN; Abnahmevertrag senkt diesen Wert nicht. o6_24: jahreswirksame Ausbringung je Kultur/Düngeklasse. o6_16: tatsächliche Kulturketten und Überschussübertrag. |
| Güllecharge, Separation und schlagbezogene Ausbringung | Ausgangsstoffe/Wasser, eigene tatsächlich separierte Rindergülle, Verfahren/Geräte und düngungswürdige Fläche getrennt; Kalenderjahressumme ersetzt kein vollständiges Anwendungsjournal. |
| Rezept/Rationsversion, Tierphase, Protein-/Trockenmassewert und Nachweis | o6_9/16: Rohprotein bei 88 % TM, Durchschnitt ODER vollständige Phasen. Hersteller-/Literaturwerte sind laut Quelle zulässig. Gewichtung und 32-/50-kg-Quellenabweichung bleiben offen. |
| Futtermittelcharge, Ursprung und tatsächliche Verfügbarkeit | o6_22: GVO-/Europa-Herkunft, alle Tierarten, Volljahr einschließlich Altvorräten; Europa ist nicht nur EU. Protein-Futtermittelklassifikation ist keine 88-%-TM-Schweinerationsprüfung. |
| Material, Rolle und Ort | Futter, Einstreu, Beschäftigungsmaterial und Wasser sind unterschiedliche Zwecke. Keine neue Rohprotein-/GVO-Pflicht für Rinder21 aus der Schweinequelle ableiten. |
| Festmist, Miete, Zusatzmaterial, Anlage-/Wende-/Abgabe-/Ausbringungsbeleg | Zuschläge21/22 beziehen sämtlichen Festmist aller Tierarten ein. Zwei Wendungen oder belegte wendefreie Alternative, ausreichende Beimengung und NAPV getrennt; 50:50 ist ein Beispiel. |
| Art/Sorte/Familie, Saatgutlos, Mischung und Feldbeobachtung | Saatgut-Gewichtsanteil, Pflanzenbestand und Flächendeckung sind verschiedene Größen. Synonyme/Sorten sind keine zusätzlichen Mischungspartner. Saat und rechtliches Anlagedatum können verschieden sein. |
| Datierte Bewirtschaftung auf konkreter Fläche | DIVNFZ beginnt nach Bewirtschaftungsabschluss. Abtransport ist bei Bergmahd nötig, bei anderen Pflegepflichten nicht; Walzen/Striegeln/Umbruch wirken je Maßnahme unterschiedlich. Immergrün braucht Tageschronologie, nicht nur Jahresquote. |
| Pheromonfalle/EOP/Nützling, Bezug und Einsatz | Arten-/Produkt-/Gebiets-/Perioden-/Mengenregeln sowie tatsächliche Installation/Kontrolle/Entfernung bleiben eigenständig. EOP ist keine pauschale Insektizid-Ausnahme. |
| Bodenprobe, Bewässerung, Kultur-/Erntekette und Aufzeichnung | Probenort/-zeit, Analyseparameter, Labor und Nmin unterscheiden sich von angewendeten Düngermengen. Tatsächliches Ereignis, Aufzeichnungsdatum, Planung und abgeschlossene Jahresbilanz getrennt. |

Die [Scopematrix](scope-matrix.json) bindet jede Teilprüfung an Originalbelege,
bereits bestehende Fachfrage-IDs und deren unveränderten offenen Status.
Die vollständigen aktuellen Register-/Rechts-/Faktorversionen und tatsächlichen
Betriebsbelege sind vor fachlicher Aufnahme noch zu bestätigen.

## Quellen- und Eingabevertrag als Kandidat

- **Identität und Beziehungen:** Betrieb/Teilbetrieb, Schlag/Feldstück/Teilfläche,
  Tiergruppe, Produkt/Charge/Rezept/Miete/Probe und tatsächlicher Vorgang mit
  stabiler interner ID. Beziehungen müssen sich auf den gewählten Snapshot
  beziehen; ein freier Name oder dieselbe Arrayposition ersetzt keinen Join.
- **Menge und Bewertung:** Zahl mit Einheit, Mengenbasis, Materialrolle,
  Referenzfläche/-tierbestand, Zeitraum und Methode. Brutto-N, Verlustabzug,
  jahreswirksamer N, m³ Gülle, Protein/TM und Prozentanteile bleiben getrennt.
  Keine Umrechnung aus einem Namen oder unbekannten Faktor erraten.
- **Zeit und Abdeckung:** tatsächliches Ereignis, Erfassung/Meldung, Proben-/
  Analysedatum, Normgültigkeit und Vertrags-/Kulturjahr getrennt. Historische
  Vorräte/Vorfrucht/Vertragsbelege können aktuell relevant sein. Fehlende
  Ereignisse sind nicht Null; eine bestätigte Nichtanwendung gehört zu einem
  benannten vollständigen Scope und Zeitraum. Zukunftsplanung belegt keine
  aktuelle Erfüllung.
- **Bestätigte Herkunft:** AMA-Baseline plus dokumentierte Experten-/
  Betreiberwerte, sichtbares Delta und ausgewählter Snapshot. Diese Werte
  gehen AMA vor; die bloße Abweichung blockiert sie nicht. Bestätigte Aggregate
  bleiben verwendbar, soweit ihr Scope die betreffende Frage beantwortet.
  Faktenvorrang ersetzt keine versionierte Zulassungs- oder Normquelle.
- **Auto:** Werte im eigenen Snapshot, Quelle `auto` und `dokumentiert`;
  ursprüngliche Baseline und reale Nachweis-/Zulassungsherkunft nachvollziehbar
  halten. Der bestehende EvaluationRun ist noch kein solcher Farm-Snapshot.

Die notwendige Erfassung für eine nachvollziehbare App-Bewertung ist keine
neu erfundene gesetzliche Aufzeichnungspflicht. Beispielsweise ist die
verpflichtende Dokumentation der DIVNFZ-Bewirtschaftungsabschlusstermine laut
Merkblatt seit 2025 entfallen; die fachliche Zeitregel besteht weiterhin.

## Aktuelle Ergänzungen und nächste Umsetzung

Gezielt online geprüft wurden die AMA-Hinweise zur Aufzeichnung vom 25.08.2026,
zur Weinausnahme vom 12.06.2026 sowie die aktuelle BAES-Registerbeschreibung.
Links, kurze Belege und Versionsgrenzen stehen in [evidence.json](evidence.json).
Die BAES-Beschreibung zeigt auch eine geänderte EPPO-Codierung bei gleichbleibendem
Anwendungsumfang: Produkt-/Kulturidentität braucht eine datierte Quellenfassung.
Damit ist kein allgemeiner Alias zwischen Modell- und App-Pfaden freigegeben.

Die gezielte Vertiefung betrifft 24 Maßnahmen in 13 gemeinsamen Themen.
355 unterschiedliche wörtliche lokale Fundstellen sind geprüft; acht exakt
gleiche Quelle-/Seite-/Zitatbelege der Teilprüfungen wurden zusammengeführt.
Dies ist keine vollständige aktuelle Regel- oder Katalogaufnahme und keine
fachliche Qualitätsmessung der Modelle.

1. [Restfragen](questions.md) im Sammelissue #140 bündeln. Vollständige aktuelle
   Quellen-/Kategorien-/Methodenverträge und echte Betriebs-Snapshots bestätigen.
2. In kleinen App-PRs Quellen-/Einheiten-/Datumsrollen und gemeinsame typisierte
   Objekte vorbereiten, danach Editor und verlustfreie Projektion anbinden.
3. Bestätigte Maßnahmenscopes einzeln auswerten; erlaubte Aggregate und
   Nichtanwendung korrekt konsumieren. Zusätzliche Eingaben allein dürfen keine
   scheinbare fachliche Fertigstellung der generischen Prüfung erzeugen.
4. Unabhängige Integrationsfälle bewerten: BIO-Ausnahmen, Chargen-/Flächenjoin,
   fehlend vs dokumentiert leer, Verlust-/Wirksamkeitsbasis, Rationsalternative,
   Volljahr/Altvorräte, tatsächliche Ereignisfolge und einzelne Teilflächen.

Der Bericht ist eine geprüfte Vorbereitung. Keine neue Policy-/App-Funktion,
fachliche Aliasfreigabe oder Golden-Sollentscheidung ist erfolgt.
[Draft #103](https://github.com/ghinta/oepul-rule-lab/pull/103) bleibt offen;
UBB bleibt in [Draft #102](https://github.com/ghinta/oepul-rule-lab/pull/102).
