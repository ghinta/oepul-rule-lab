# Block 3: Tierbestände, Identitäten und tatsächliche Ereignisse

Stand 08.10.2026 · gezielter Quellen-/App-Abgleich · App-Pin
`5296108f5756ef1463c25a49d93d4a346e9b5e9c` · historischer Lab-/Quellenpin
`7a296d28cb5b92e2758c5a3889c929ea1db60fe5`.

Die heutige App-Tiergruppe verliert Merkmale, die die Maßnahmen benötigen:
Kategorie und Bestandsmethode, einzelne Identitäten, Betriebszuordnung sowie
datierte Aufenthalte und Meldungen. Die aktuelle o6_3-Kohortenfunktion liefert
eine bessere Backend-Teilgrundlage. Sie ist noch kein allgemeines Tierregister
und kein vollständig verdrahteter Browsereditor. Ein allgemeiner GVE-Wert oder
eine maximale Alpungsdauer kann diese unterschiedlichen Prüfungen nicht tragen.

Dieser Bericht ergänzt die bereits einzeln geprüften Maßnahmen. Die jeweiligen
vollständigen historischen Variablendiffs und offenen Fragen bleiben in den
[Einzeldossiers](../sequential-variable-reviews-20261008/README.md). Die
nachfolgenden Kandidaten beschreiben benötigte Bedeutung; neue Canonical-Pfade,
Kategoriealiase und fachliche Aufnahme sind damit nicht freigegeben.

## Vorher / benötigte Ergänzung

| Heutiger geprüfter App-Pfad | Befund | Benötigte Ergänzung vor maßnahmenspezifischer Nutzung |
| --- | --- | --- |
| `livestock.species_groups[].species`; Legacy-Overlay-ID=species | Eine grobe Artgruppe, Schafe/Ziegen zusammen; native Standardprojektion verwirft Kategorie/weitere IDs. | Stabile interne Bestands-/Kohorten-ID; Tierart und belegte Kategorie getrennt. Amtliche Einzelkennung nur dort, wo Tierart/Maßnahme/Nachweis sie erfordert. |
| `animal_count`, `gve` | AMA-Tierliste bevorzugt Stichtag, fällt auf Durchschnitt zurück, summiert/rundet und verwendet grobe GVE-Faktoren. Kategorie/Teilbetrieb/Belegbasis gehen verloren. | Stichtagsstückzahl oder gebrochenes Mittel mit eigener Kategorie, Einheit, Zeitraum, vollständigem Scope und Beleg; GVE/RGVE-Faktor als gesonderte versionierte Regel. |
| AMA-Raw `D619_23_ST_RINDER`, Einzeltiersätze | Kategorisierte Rinderdurchschnitte sowie Kennungen/Geburten/Bewegungen liegen im Rohmodell, werden von diesem Builder nicht genutzt. | Verlustfreie Zuordnung zu bestätigter Kategorie und Quelle; erst dann berechnen/projizieren. Vorhandensein einer Raw-Spalte bestätigt weder aktuelle Abdeckung noch ihre fachliche Einheit. |
| `livestock.rgve_cohorts` | Eigene stabile Kohorten-ID, Count-Basis/Beleg und Kategorie; `average_count` bleibt dokumentierte Eingabe. Keine Ableitung aus Tierbewegungen. | Bestätigte disjunkte, vollständige Bestände; dokumentiertes Aggregat oder belegte Mitglieder-/Gruppenzuordnung je nötigem Scope. Dieselben Tiere dürfen nicht durch neue Kohorten-IDs mehrfach zählen. |
| o6_3 Durchschnittsprüfung `01.01.–as_of` | Die Belegperiode muss exakt am heutigen Stichtag enden. Dieser Teilstand ist kein abgeschlossenes Jahresmittel; der gestrige Beleg kann heute unverifiziert werden. | Unterjährig beobachtete Abdeckung und Jahresabschluss trennen; Aktualisierungs-/Gültigkeitsvertrag klären. Kein späterer Datenstand darf als heute bekannt vorausgesetzt werden. |
| `oepul.shared.livestock_events` | Nur `event_type`/`event_date` am Betrieb. | Tatsächliche Tier-/Gruppen-/Standortzuordnung, Mengen, Ereignis- und Meldedatum, dokumentierter Status sowie Intervall-/Unterbrechungsbezug. |
| `farm.heuwirtschaft.seasonal_presence` | Datierte dokumentierte Gruppe, aber keine Prüfung gegen Kohorten, keine Aufenthaltsunion/Vollständigkeit. | Nachvollziehbare Beziehungen und maßnahmenspezifische Auswertung der echten Historie. |
| `weide_days_per_year` | Builder schreibt das Maximum vorhandener AMA-Alptage auf die erste Artgruppe. | Konkrete Aufenthalte/Weidebelege; keine Übertragung von Almmaxima auf die Pflicht eines anderen Tiers. |
| `housing.stall.stall_area_m2` | Gruppenwert ohne Box-/Gewichts-/Besatzjoin. | Stall/Box/Koppel mit tatsächlichem Besatz einschließlich nicht geförderter Mitbewohner; passende Gewichtsklasse und nutzbare Fläche. |
| Aktuelle Collection-API / generischer Editor | Backend hat typisierte Kohorten; Browsercatalog liefert für diese Typen keine Itemfelder und verwendet den Szenario-Endpunkt. | Formulare für aktuelle Belege, Herkunft und gewählten Snapshot verdrahten; Auto als dokumentierten eigenen Snapshot separat implementieren. |

Die vollständigen 49 Istpfade, Ableitungen, 16 Lücken und 75 verifizierten
Zeilenbelege stehen in [app-paths.json](app-paths.json), einschließlich
Datei-SHA256 am App-Pin. Der Browserbefund ist ein belegter Integrationsbedarf;
ein produktiver E2E-Durchlauf wurde hier nicht durchgeführt.

## Gemeinsamer Eingabevertrag als Kandidat

Diese technischen Bedeutungen können gemeinsam vorbereitet werden. Die
konkreten Namen, Typen und Regeln werden anschließend je benötigter Variable
in App #139 festgelegt.

- **Identität:** interne Objekt-/Kohorten-ID, erforderliche externe Kennung samt
  Kennungssystem, belegte Tierart/Kategorie und Zuordnung zum Haupt-/Teilbetrieb.
  Eine Ereignis-UUID identifiziert den Beleg; sie ersetzt keine Tieridentität.
  Schweinegruppen und zulässige Stückzahl-/Gruppennachweise bleiben möglich.
- **Bestand:** Stichtag oder Durchschnittsperiode, Stückzahl/Einheit, Herkunft,
  Nachweis, dokumentierte Vollständigkeit/Abdeckung und Bewertungsmethode.
  Eingegebener bestätigter Bestand und aus Bewegungen berechneter Bestand
  müssen unterscheidbar bleiben. Ganzzahlige Tiere und gebrochene Mittel sind
  unterschiedliche Werte; fehlende Zeiträume dürfen nicht als Null zählen.
- **Lebenslauf/Ort:** echte Geburt, Alter/Geschlecht/Rasse, Zu-/Abgang,
  zeitliche Betriebsstruktur, Alm/Weide/Box/Koppel und gegebenenfalls Ersatzplatz.
  Ein temporärer Aufenthalt ist nicht automatisch ein Heimbetriebsabgang.
- **Datumsrollen:** tatsächliches Ereignis, Antrag/Meldung, Dokumentausstellung,
  heutige Erfassung/Beobachtung und fachlicher Gültigkeitszeitraum getrennt.
  Geburt oder historische Vertragsbelege dürfen vor dem aktuellen Jahr liegen.
  Zukünftige Planbewegungen belegen keine heutige Erfüllung. Der heutige
  Belegstand und das aktuelle Auswertungsjahr bleiben maßgeblich.
- **Herkunft:** AMA-Baseline plus explizite Experten-/Betreiberergänzung,
  gewählter Snapshot, Beleg und sichtbares Delta. Die bestätigte Ergänzung gilt
  vor AMA; die bloße Abweichung zu AMA blockiert sie nicht. Dies ersetzt keine
  notwendige Information für eine bestimmte Tier-/Zeitraum-/Platzprüfung.
- **Regelparameter:** gültige Kategorie-/GVE-/RGVE-Tabelle, Altersstichtag,
  Formel, Grenzwert und Ausnahmescope getrennt von den eingegebenen Fakten.
  Ein bestätigtes GVE-/RGVE-Aggregat bleibt ein zulässiger dokumentierter
  Eingabewert; es belegt allein keinen tatsächlichen Einzeltierverlauf oder
  Ganzjahresabschluss. Ein Faktenoverride ändert keine normative Tabelle.

**Auto ist bereits entschieden:** eigener Snapshot, erzeugte Werte mit Quelle
`auto` und `dokumentiert`, bei dessen Auswertung vor AMA. Diese Funktion ist am
geprüften App-Pin noch nicht vorhanden. Die erlaubte Flächenneuanlage begründet
keine Entscheidung, reale oder hypothetische Einzeltiere automatisch anzulegen.
Die dafür nötige Identitäts-/Produktentscheidung wird als offen geführt.
Falls neue Tierobjekte zugelassen werden, muss ihr Anlegeursprung separat von
späteren Wertänderungen sichtbar werden; eine interne ID darf keine amtliche
Kennzeichnung oder Registerbestätigung vortäuschen.

## Rechenbasen je Maßnahme

| Maßnahme | Gemeinsam nutzbare Evidenz | Eigenständiger Prüf-/Rechenscope |
| --- | --- | --- |
| UBB/BIO/o6_2/o6_3 | Kategorien, jährliche Bestandsbelege, Futterflächen | RGVE je Gesamtfutterfläche; BIO-Ausnahmen, Erstjahr und Zuschläge getrennt. NAT-/Bergmahdflächen zählen bei2/3 zur Futterbasis; Ackerfutter als Zweitkultur nicht. |
| o6_5 | Einzelkennung, Rasse/Geburt, Zucht-/Halte-/Ersatzereignisse | Förderplatz und komplette Ersatzkette; datierte Haltedauer-/Meldeausnahme2026 statt globaler Tierzahl. |
| o6_9/o6_16 | Schweineklassen, Jahresmittel, vollständige Futterbelege | Schweine-GVE je gesamtem Acker ohne Abzüge; Rinder-Separation und N-Anfall sind andere Kennzahlen. |
| o6_14/o6_15 | Heimat-/Alm-ID, echte Tier-/Gruppenaufenthalte und Meldungen | Almbestockung und Aufenthalt des konkreten Tiers getrennt;01.07.-Alter, Behirtung, Milch und Zuordnung eigenständig. |
| o6_18 | Tier-/Gruppen-/Weideeinheit, datierte Aufenthalte und Projektparameter | WA01/03 jährliche RGVE, NW05 gleichzeitige GVE, NW06 jährliche GVE. Bestätigte Projektfläche/Parameter erforderlich. |
| o6_19 | Projekt-/Art-/Indikatorbeobachtung | Schutzguttiere sind kein Alias für Nutztierbestand. |
| o6_20 | Kategorie-/Tierbestand und echtes Weidetagebuch | Durchschnitt im 214-Tage-Fenster, Kategorieanwesenheit und 120/150 Weidetage getrennt. |
| o6_21 | Rinderidentität, Kalenderhistorie, tatsächliche Box/Gewichte | Jahres-RGVE; Verkauf zeitanteilig gegenüber möglichem Ganzjahresausschluss bei Pflichtverletzung; Platzbedarf aller Mitbewohner. |
| o6_22 | Tierliste/Durchschnitt, Schweinegruppen, Box/Koppel | Drei Maßnahmenkategorien, zehn Tierlistenklassen und Platzgewichtsklassen getrennt; ganzjährige Pflicht/Abmeldung, keine erfundene allgemeine Einzeltierpflicht. |

[scope-matrix.json](scope-matrix.json) bindet diese Scopes an Originalbelege,
bereits vorhandene offene Frage-IDs und unveränderte Frage-Datei-Hashes. Für UBB
bleibt [Draft #102](https://github.com/ghinta/oepul-rule-lab/pull/102) die
Einzelprüfung; hier wird keine dort nicht vorhandene Tierfrage-ID erfunden.

## Gezielt geprüfte aktuelle Hinweise

Die AMA-Mitteilung vom 30.06.2026 präzisiert Alm-/Tieraufenthalt und
Datumsgrenzen. Die Mitteilung vom 02.09.2026 unterscheidet Weide- und
Kalenderjahresanteile und die geänderte Rassen-Halte-/Ersatzmeldung 2026.
Der Hinweis vom 16.09.2026 präzisiert tatsächliche Abtriebsbestätigungen nach
Tierart. Ihre Links und kurzen Belege stehen in [evidence.json](evidence.json).

Diese Hinweise ergänzen die lokal gepinnte historische Basis. Die aktuellen
SRL-/Anhang-Tierabschnitte und vollständigen Kategorie-/Gewichtstabellen sind
noch nicht vollständig gegen aktuelle Originalbytes geprüft. Diese Lücke
bleibt vor Regelaufnahme sichtbar; die historischen Dossiers werden nicht
als heutige Komplettregelbasis umbenannt.

## Nächste Umsetzung

1. [Präzise Restfragen](questions.md) in Sammelissue #140 mit Domainexperten
   klären; vorhandene Fragen bleiben offen. Vollständige aktuelle Quellen und
   tatsächliche Betriebs-/Registerbelege binden.
2. Die fachlich unabhängigen Grundlagen in kleinen App-PRs vorbereiten:
   Identität/Herkunft/Datumsrollen, typisierte Bestände/Bewegungen und Editor.
   Original-Import, bestätigte Ergänzung und Auto-Snapshot nachvollziehbar halten.
3. Bestätigte Kategorien-/Faktor-/Zeitverträge je Maßnahme anbinden; zuerst
   vorhandene o6_3-Kohorten verlustfrei nutzen. Keine automatische Übernahme
   von Luna-/Opus-Pfadnamen oder Wiederverwendung einer Durchschnittsformel.
4. Unabhängig bewertete Integrationsfälle: Einzelkennung/Kohortendoppelung,
   Arten-/Kategoriegrenzen, Stichtag vs Durchschnitt, aktuelle vs abgeschlossene
   Zeit, temporäre Alpung, Pflichtverstoß vs Verkauf, gemischte Boxen und
   bestätigtes Leer vs fehlend. Reale Test-Snapshots werden dafür noch benötigt.

Der Bericht ist geprüft und technisch vorbereitend. Keine App-Promotion,
Golden-Sollentscheidung oder vollständige fachliche Freigabe ist erfolgt.
[Draft #103](https://github.com/ghinta/oepul-rule-lab/pull/103) bleibt offen.
