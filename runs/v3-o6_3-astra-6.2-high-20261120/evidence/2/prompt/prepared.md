# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_3`

Modus: `discover`
Run-ID: `v3-o6_3-astra-6.2-high-20261120`

Arbeite ausschließlich im aktuellen Run-Workspace. Lies `AGENTS.md`, danach das
Canonical Farm Profile und anschließend die folgenden Quellen. Lies das
Maßnahmenblatt, die allgemeinen Teilnahmebedingungen und die 2026-Hinweise
vollständig. Durchsuche die Rechtsgrundlagen und Anhänge systematisch nach der
Maßnahme und lies alle gefundenen Abschnitte samt Definitionen, Tabellen,
Fußnoten und Querverweisen vollständig:

- sources/20241011_srl_oepul_2023.pdf (seitenmarkierter Text: sources/20241011_srl_oepul_2023.txt)
- sources/20241011_srl_oepul_2023_anhaenge.pdf (seitenmarkierter Text: sources/20241011_srl_oepul_2023_anhaenge.txt)
- sources/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html
- sources/2026-06-12__vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich.html
- sources/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html
- sources/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html
- sources/o6_3_heuwirtschaft_2025_10.pdf (seitenmarkierter Text: sources/o6_3_heuwirtschaft_2025_10.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_3` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v3-o6_3-astra-6.2-high-20261120`;
   `source_path` und `artifact_path` beginnen mit
   `workspace/`, damit sie vom Run-Verzeichnis aus auflösbar sind. Ermittle die
   tatsächlichen SHA-256-Werte der kopierten Quellen. `evidence_text` ist ein
   kurzer wörtlicher Ausschnitt, der auf der angegebenen PDF-Seite bzw. in der
   HTML-Quelle tatsächlich vorkommt; eine Paraphrase ist hier unzulässig.
4. Implementiere ausführbare Rego-v1-Regeln unter `policy/` und aussagekräftige
   Tests unter `tests/`. Überführe umfangreiche Tabellen und geschlossene Listen
   vollständig nach `data/` und verwende sie aus Rego; fasse sie nicht nur
   beschreibend zusammen.
5. Ändere `canonical_farm_profile.json` niemals direkt. Lies
   `contracts/profile-changes-v1.schema.json` und schreibe benötigte Ergänzungen,
   Änderungen oder Löschungen nach `rules/profile_changes.json`. Jeder Vorschlag
   benötigt verknüpfte Regel- und Quellenbeleg-IDs. Verwende für `value_after`
   exakt die Struktur-Notation des Canonical Farm Profile: insbesondere ein
   JSON-Array mit repräsentativem Objekt statt des Strings `array<object>`. Im
   Modus `conform` muss das Array `changes` leer bleiben.
6. Führe OPA-Formatierung, Strict-Compile-Check und Tests wiederholt aus und
   repariere technische Fehler. Dokumentiere verbleibende fachliche
   Mehrdeutigkeiten in `notes/assumptions.md`.
7. Lies `contracts/coverage-ledger-v1.schema.json` und dokumentiere jeden
   geprüften Abschnitt, Absatz, jede Tabelle und Fußnote in
   `rules/coverage.json`: entweder mit Regel-IDs oder als `not_rule` bzw.
   `unresolved` samt Begründung. Maßnahmenblatt, allgemeine Bedingungen und
   2026-Hinweise werden vollständig geprüft; bei Rechtsgrundlagen darfst du
   gezielte Abschnitte mit begründetem `targeted_sections`-Scope verwenden.
8. Lies `contracts/data-inventory-v1.schema.json` und inventarisiere jede Datei
   unter `data/` in `rules/data_inventory.json`. Erfasse Tabellen über
   JSON-Pointer, Zeilenzahl und Quellenbeleg-IDs. Gibt es keine Datendateien,
   bleibt `artifacts` leer.
9. Validiere vor Abschluss alle fünf JSON-Ausgaben nochmals Feld für Feld gegen
   die mitgelieferten Schemas; ähnliche oder ältere Formate gelten als Fehler.

Lasse Regeln nicht allein wegen eines unvollständigen Ausgangsprofils weg. Ziel
ist zunächst maximale, quellengebundene und technisch lauffähige Extraktion;
eine unabhängige fachliche Bewertung findet später statt.


## Separater Korrekturversuch mit Validatorfeedback
Prüfe die folgenden Befunde im vorhandenen Workspace. Erhalte belegte Inhalte und korrigiere die Rückweisungsgründe anhand der Quellen und Daten.

Die deterministische Rule-Lab-Finalisierung (`finalize`) hat den bisherigen Stand abgelehnt. Behebe alle folgenden Fehler, ohne die Anforderungen aus `AGENTS.md` und den Schemas aufzuweichen:

- [coverage] sources.0.items.101: Value error, only rules disposition may contain rule_ids
- [coverage] sources.4.items.48: Value error, only rules disposition may contain rule_ids
- [coverage] sources.6.items.23: Value error, only rules disposition may contain rule_ids
- [cross_references] rules absent from coverage ledger: ['o6_3.abgabe', 'o6_3.abgang', 'o6_3.abgang.toleranz', 'o6_3.abgang.verfuegung', 'o6_3.abmeldung', 'o6_3.ackerbindung', 'o6_3.ackerfutter', 'o6_3.antrag', 'o6_3.ausschluss.mfa', 'o6_3.ausschluss.nutzung', 'o6_3.ausstieg', 'o6_3.bagatelle', 'o6_3.basis', 'o6_3.begruenung.duerre', 'o6_3.begruenung.korrektur', 'o6_3.bescheid', 'o6_3.betrieb.folge', 'o6_3.betriebsgroesse', 'o6_3.betriebskombi', 'o6_3.betriebsuebertragung', 'o6_3.bewirtschaftung.acker', 'o6_3.bewirtschaftung.ausnahme', 'o6_3.bewirtschaftung.berg', 'o6_3.bewirtschaftung.dauer', 'o6_3.bewirtschaftung.gruen', 'o6_3.bewirtschaftung.ruhe', 'o6_3.div.acker', 'o6_3.div.acker2026', 'o6_3.div.anteil', 'o6_3.div.drittnutzung', 'o6_3.div.gruen', 'o6_3.div.gruen2026', 'o6_3.div.kontrolle', 'o6_3.div.phaenologie', 'o6_3.div.ruhe2026', 'o6_3.div.varianten', 'o6_3.div.wechsel', 'o6_3.duerre.antrag', 'o6_3.duerre.ernte', 'o6_3.ebw.heutrocknung', 'o6_3.einjahresliste', 'o6_3.einstieg.flaeche', 'o6_3.einstieg.tiere', 'o6_3.equiden', 'o6_3.festlegung', 'o6_3.flaechenbetrag', 'o6_3.folge.flaeche', 'o6_3.folge.tiere', 'o6_3.futterflaeche', 'o6_3.ga', 'o6_3.gemuese', 'o6_3.genehmigung', 'o6_3.getreide', 'o6_3.gewalt', 'o6_3.gruenbindung', 'o6_3.gruenfuetterung', 'o6_3.gruenmais', 'o6_3.gve.schwein', 'o6_3.heulage', 'o6_3.immergruen', 'o6_3.inland', 'o6_3.jahresbindung', 'o6_3.k20', 'o6_3.kombifeld', 'o6_3.kombination', 'o6_3.kondition', 'o6_3.kontrolle', 'o6_3.kontrolle.auskunft', 'o6_3.kontrolle.bewertung', 'o6_3.kontrolle.nachreichung', 'o6_3.kontrolle.verhindert', 'o6_3.kontrolle.vertretung', 'o6_3.kontrolle.zutritt', 'o6_3.kontrollfrist', 'o6_3.korrektur', 'o6_3.kreiseln', 'o6_3.kuerzungsfolge', 'o6_3.lagerung', 'o6_3.laufzeit', 'o6_3.lf', 'o6_3.matrix', 'o6_3.matrix.fn1', 'o6_3.matrix.fn2', 'o6_3.matrix.fn3', 'o6_3.matrix.fn4', 'o6_3.modulation', 'o6_3.nachfrist', 'o6_3.nat.freigabe', 'o6_3.nat.gm01', 'o6_3.nat.gm02', 'o6_3.nat.projekt', 'o6_3.nationalpark', 'o6_3.natura.freigabe', 'o6_3.nebenprodukt', 'o6_3.nutztierrasse', 'o6_3.obergrenze', 'o6_3.obst', 'o6_3.oeffentlich', 'o6_3.op', 'o6_3.op.ausgleich', 'o6_3.op.dauer', 'o6_3.op.ernte', 'o6_3.op.fremd', 'o6_3.op.leistung', 'o6_3.op.obst', 'o6_3.opbio', 'o6_3.option.antrag', 'o6_3.option.besitz', 'o6_3.option.einsatz', 'o6_3.option.frist', 'o6_3.option.geraet', 'o6_3.option.jahr', 'o6_3.person', 'o6_3.person.vereinigung', 'o6_3.praemienflaeche', 'o6_3.rebzikade.anordnung', 'o6_3.rebzikade.ausstieg', 'o6_3.rechtsrahmen', 'o6_3.reduktion.zinsen', 'o6_3.revision', 'o6_3.rgve', 'o6_3.rgve.dam_oder_zuchtwild.12', 'o6_3.rgve.equide_gross.0', 'o6_3.rgve.equide_gross.36', 'o6_3.rgve.equide_gross.6', 'o6_3.rgve.equide_klein.0', 'o6_3.rgve.equide_klein.36', 'o6_3.rgve.equide_klein.6', 'o6_3.rgve.neuweltkamel.12', 'o6_3.rgve.rind.0', 'o6_3.rgve.rind.24', 'o6_3.rgve.rind.6', 'o6_3.rgve.rotwild.12', 'o6_3.rgve.schaf.0', 'o6_3.rgve.schaf.12', 'o6_3.rgve.wild_kamel_jung.0', 'o6_3.rgve.ziege.0', 'o6_3.rgve.ziege.12', 'o6_3.rgve.zwergrind.0', 'o6_3.rgve.zwergrind.24', 'o6_3.rgve.zwergrind.6', 'o6_3.sanktion.2027', 'o6_3.sanktion.ausschluss', 'o6_3.sanktion.grund', 'o6_3.sanktion.stufe', 'o6_3.satz.basis', 'o6_3.satz.null', 'o6_3.satz.option', 'o6_3.selbstanzeige', 'o6_3.silage.bereitung', 'o6_3.silage.fuetterung', 'o6_3.silage.pressen', 'o6_3.teilzahlung', 'o6_3.tier.bestand', 'o6_3.tier.inland', 'o6_3.tier.wechsel', 'o6_3.tierstatus', 'o6_3.ubbschaden', 'o6_3.uebernahme', 'o6_3.uebernahme.ausweitung', 'o6_3.uebernahme.einzelfall', 'o6_3.umstand.dauer', 'o6_3.umstand.temp', 'o6_3.umwandlung', 'o6_3.umwidmung', 'o6_3.untersaat', 'o6_3.verlaengerung', 'o6_3.versuch', 'o6_3.wiedereinstieg', 'o6_3.wild', 'o6_3.zahlung', 'o6_3.zahlungsantrag', 'o6_3.zugang.alt', 'o6_3.zugang.einjaehrig', 'o6_3.zugang.folge', 'o6_3.zugang.gruen', 'o6_3.zweitkultur', 'o6_3.zwerg']
- [data] row_count mismatch for workspace/data/heuwirtschaft.json/heutabellen/kombinationen: expected 21, got 441
- [data] row_count mismatch for workspace/data/heuwirtschaft.json/heutabellen/nat_kapitelkombination: expected 8, got 64
- [profile_application] Rego uses paths absent from proposed profile: ['input.documentation.oepul_verfahren.art', 'input.documentation.oepul_verfahren.eigenverwendung', 'input.documentation.oepul_verfahren.rasche_verbringung']
