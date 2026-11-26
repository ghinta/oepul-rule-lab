# Auftrag: vollständige ÖPUL-Regelgewinnung für `o6_1b`

Modus: `discover`
Run-ID: `v3-o6_1b-astra-6.2-high-20261120`

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
- sources/o6_1b_biologische_wirtschaftsweise_2026_04.pdf (seitenmarkierter Text: sources/o6_1b_biologische_wirtschaftsweise_2026_04.txt)
- sources/o6_allgemeine_teilnahmebedingungen_2026_04.pdf (seitenmarkierter Text: sources/o6_allgemeine_teilnahmebedingungen_2026_04.txt)

## Ergebnis

1. Extrahiere möglichst jede normative, berechnungsrelevante oder
   entscheidungsrelevante Aussage einschließlich Voraussetzungen, Schwellen,
   Ausnahmen, Fristen, Optionen, Kombinationsbedingungen und Folgen.
2. Schreibe den vollständigen strukturierten Regelkatalog nach
   `rules/rules.json`. Lies davor
   `contracts/rules-catalog-v2.schema.json` vollständig und halte dieses Schema
   exakt ein: `contract_version` = `rules-catalog-v2.0.0`, `measure` =
   `o6_1b` und das Array `rules`.
   Jede Regel benötigt mindestens eine stabile ID,
   Regelart, normalisierte Aussage, Bedingungen, Ergebnis und Quellenbeleg mit
   Dokument, Seite und Abschnitt.
3. Schreibe Quellenbelege zusätzlich nach `rules/citations.json`. Lies davor
   `contracts/source-references-v2.schema.json` vollständig und halte dieses
   Schema exakt ein. Verwende als `run_id` exakt `v3-o6_1b-astra-6.2-high-20261120`;
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

- [coverage] sources.0.items.146: Value error, only rules disposition may contain rule_ids
- [coverage] sources.0.items.256: Value error, only rules disposition may contain rule_ids
- [coverage] sources.0.items.73: Value error, only rules disposition may contain rule_ids
- [coverage] sources.0.items.83: Value error, only rules disposition may contain rule_ids
- [coverage] sources.2.items.90: Value error, only rules disposition may contain rule_ids
- [coverage] sources.6.items.10: Value error, only rules disposition may contain rule_ids
- [cross_references] rules absent from coverage ledger: ['BIO-AGAnlage', 'BIO-AGGebiet', 'BIO-AGPflege', 'BIO-Abgangstoleranz', 'BIO-AckerDIV', 'BIO-AckerDIVMFA', 'BIO-Ackerbasis', 'BIO-Ackerweide', 'BIO-Ackerzahl', 'BIO-Aktiv', 'BIO-AltDIV', 'BIO-Altbrache', 'BIO-AltgrasFolge', 'BIO-Anbaudiversitaet', 'BIO-AnerkennungMFA', 'BIO-ArtenA', 'BIO-ArtenG', 'BIO-Artenreich', 'BIO-ArtenreichAntrag', 'BIO-Auskunft', 'BIO-AusnahmeMindestpflege', 'BIO-AusschlussFlaeche', 'BIO-Ausstiegsfolge', 'BIO-Ausstiegsfrist', 'BIO-BAWGebiet', 'BIO-BAWKomb', 'BIO-BHG', 'BIO-BHGMFA', 'BIO-BefahrenA', 'BIO-BegruenungDuerreregel', 'BIO-BegruenungTerminOffen', 'BIO-BegruenungVorbeantragung', 'BIO-Bergmahd', 'BIO-Beseitigung', 'BIO-Bestandszeit', 'BIO-Betriebswechsel', 'BIO-BienenMFA', 'BIO-BienenSektor', 'BIO-Bienenmischung', 'BIO-BindungDIV', 'BIO-BioKennzeichnung', 'BIO-BioVO', 'BIO-BracheDIV', 'BIO-BracheDeckel', 'BIO-DIVAGF', 'BIO-DIVKomb', 'BIO-DIVNFZ', 'BIO-DIVRSA', 'BIO-DIVRSG', 'BIO-DIVSZ', 'BIO-DIVSZPflege', 'BIO-DIVUebernahme', 'BIO-DichteA', 'BIO-DichteG', 'BIO-DritteNutzung', 'BIO-DritteProjekt', 'BIO-DuengerA', 'BIO-EBWBrache', 'BIO-EBWEinstufung', 'BIO-EBWIndikatoren', 'BIO-EBWKomb', 'BIO-EbwGruen', 'BIO-Eigenbedarf', 'BIO-Einfluss', 'BIO-Einheiten', 'BIO-Einstieg', 'BIO-Equiden', 'BIO-EquidenMFA', 'BIO-Equidenklasse', 'BIO-Ernte85', 'BIO-ErnteDauer', 'BIO-ErnteGruen', 'BIO-ErnteMeldung', 'BIO-Ernteduerreregion', 'BIO-ErnteduerreregionST', 'BIO-Erosion', 'BIO-EtikettA', 'BIO-FeldA', 'BIO-FeldG', 'BIO-Feldgemuese', 'BIO-Flaechenabgang', 'BIO-Flaechendefinition', 'BIO-FortsetzungA', 'BIO-FortsetzungG', 'BIO-FreiwilligA', 'BIO-FreiwilligG', 'BIO-Fremdpraemie', 'BIO-Fremdverschulden', 'BIO-Fremdweide', 'BIO-Futterbasis', 'BIO-Futterliste', 'BIO-GLOEZLSE', 'BIO-GWAKomb', 'BIO-Gebiet', 'BIO-Gebietskoerperschaft', 'BIO-GefaehrdeteRasseDuerreregel', 'BIO-Gemueseliste', 'BIO-Gesamtbetrieb', 'BIO-Getreideliste', 'BIO-GetrennteMittel', 'BIO-GewaltMeldung', 'BIO-GloezDIV', 'BIO-GloezPunkt', 'BIO-GruenDIV', 'BIO-GruenDIVMFA', 'BIO-GruenlandErsatz', 'BIO-Gruenlanderhalt', 'BIO-Gruenlandzahl', 'BIO-Gruenvarianten', 'BIO-Hauptkultur', 'BIO-HeckeDIV', 'BIO-HeckeMFA', 'BIO-HeckenGIS', 'BIO-Heckenlage', 'BIO-Heckenmittel', 'BIO-Heckenpflege', 'BIO-Heuwirtschaft', 'BIO-Humuszugang', 'BIO-ImmergruenSpaetsaat', 'BIO-Jahresbindung', 'BIO-Jahresoption', 'BIO-Jahresstatus', 'BIO-Karte2026', 'BIO-KennartenBeleg', 'BIO-KennartenErhebung', 'BIO-KennartenStreifen', 'BIO-Kennartenliste', 'BIO-Kleinbetrag', 'BIO-Kofinanzierung', 'BIO-Komb1C', 'BIO-KombBetrieb', 'BIO-KombKorrektur', 'BIO-KombPraemie', 'BIO-Kombmatrix', 'BIO-Kondition', 'BIO-Kontrollbelege', 'BIO-Kontrolle', 'BIO-Kontrollvertrag', 'BIO-KreislaufA', 'BIO-KreislaufG', 'BIO-Kuerzungsfolge', 'BIO-Kuerzungsgruende', 'BIO-KulturMFA', 'BIO-Kulturausnahmen', 'BIO-Kulturgruppen', 'BIO-Kulturrang', 'BIO-Kulturschwelle', 'BIO-Kursabgang', 'BIO-Kursanbieter', 'BIO-Kursbeleg', 'BIO-Kursstunden', 'BIO-LSEMFA', 'BIO-Lagegenau', 'BIO-Landesstelle', 'BIO-Leguminosenmix', 'BIO-MaiAckerNormal', 'BIO-MaiGruenNormal', 'BIO-MatrixF1', 'BIO-MatrixF2', 'BIO-MatrixF3', 'BIO-MatrixF4', 'BIO-MehrDIVa', 'BIO-MehrDIVg', 'BIO-Mindestgroesse', 'BIO-Ministerium', 'BIO-Mischkultur', 'BIO-Mitteilung', 'BIO-Modulation', 'BIO-Mohnstreifen', 'BIO-Monitoring', 'BIO-MonitoringDaten', 'BIO-MonitoringProgramme', 'BIO-MonitoringUebernahme', 'BIO-Monitoringantrag', 'BIO-Monitorstelle', 'BIO-N2Auflage', 'BIO-N2Komb', 'BIO-NATKomb', 'BIO-NFZBeginn', 'BIO-NFZBeleg', 'BIO-NFZZweitnutzung', 'BIO-NPF', 'BIO-NatGruen', 'BIO-Nationalpark', 'BIO-NaturaGruen', 'BIO-OP', 'BIO-OPDauer', 'BIO-OPErnte', 'BIO-OPObst', 'BIO-Obergrenzen', 'BIO-Obstliste', 'BIO-Obstmaterial', 'BIO-OekotypA', 'BIO-Optionsfrist', 'BIO-Organismen', 'BIO-PSM2026', 'BIO-PSMCodes', 'BIO-PSMKorrektur', 'BIO-PZR', 'BIO-PZRBeleg', 'BIO-PZRFrist', 'BIO-PZRMFA', 'BIO-PZRUmbruch', 'BIO-PZRVeg', 'BIO-Pflege2024', 'BIO-Pflege2025', 'BIO-Phaenologie', 'BIO-Problempflanzen', 'BIO-ProjektPhaenologie', 'BIO-ProjektSA01', 'BIO-Projektmatrix', 'BIO-Projekttermine2026', 'BIO-ProjektvorrangA', 'BIO-PunktLSE', 'BIO-RGVE', 'BIO-RSAlt', 'BIO-RSBrache', 'BIO-RSFeldfutter', 'BIO-RSGDuenger', 'BIO-RSGNutzung', 'BIO-RebzikadeAnordnung', 'BIO-RebzikadeAusstieg', 'BIO-RebzikadeMeldung', 'BIO-Rechtsform', 'BIO-Rechtsrahmen', 'BIO-Reinigung', 'BIO-ReinigungRSAlt', 'BIO-ReinigungZaehlt', 'BIO-Revision', 'BIO-Rinderzeit', 'BIO-SLK', 'BIO-SLKDeckel', 'BIO-SLKMFA', 'BIO-SLKUntersaat', 'BIO-SaatUmbruch', 'BIO-SaatstaerkeA', 'BIO-SaatstaerkeG', 'BIO-SaatterminG', 'BIO-Sanierung', 'BIO-Sanktion2027', 'BIO-Sanktionen', 'BIO-Sanktionsrecht', 'BIO-Satz-acker_basis', 'BIO-Satz-acker_bonitaet', 'BIO-Satz-acker_dichte', 'BIO-Satz-acker_mehr_div', 'BIO-Satz-acker_rs_brache', 'BIO-Satz-acker_rs_futter', 'BIO-Satz-altgras', 'BIO-Satz-bhg', 'BIO-Satz-biodiversitaetsmonitoring', 'BIO-Satz-brut', 'BIO-Satz-fallen', 'BIO-Satz-feldfutter', 'BIO-Satz-gemuese', 'BIO-Satz-gross_trappe', 'BIO-Satz-gruen_basis_hoch', 'BIO-Satz-gruen_basis_mittel', 'BIO-Satz-gruen_basis_ohne', 'BIO-Satz-gruen_bonitaet', 'BIO-Satz-gruen_dichte', 'BIO-Satz-gruen_mehr_div', 'BIO-Satz-gruen_rs', 'BIO-Satz-hecke', 'BIO-Satz-kreislauf_acker_mit', 'BIO-Satz-kreislauf_acker_ohne', 'BIO-Satz-kreislauf_gruen', 'BIO-Satz-kreuzbluetler', 'BIO-Satz-leguminosen', 'BIO-Satz-nuss', 'BIO-Satz-phaenoflex', 'BIO-Satz-punkt_lse', 'BIO-Satz-schnittzeit', 'BIO-Satz-slk_a', 'BIO-Satz-slk_b', 'BIO-Satz-sonnenblume', 'BIO-Satz-steil', 'BIO-Satz-streuobst', 'BIO-Satz-transaktion', 'BIO-Satz-volk_1', 'BIO-Satz-volk_2', 'BIO-Satz-wein_obst_hopfen', 'BIO-Satzstand', 'BIO-Solidarhaftung', 'BIO-SonstigeSpezial', 'BIO-Sortenliste', 'BIO-Spezialausnahmen', 'BIO-Spritzschaden', 'BIO-Steil', 'BIO-SteilTopup', 'BIO-Stilllegung', 'BIO-Streuobst', 'BIO-Strukturwechsel', 'BIO-TA01', 'BIO-Teilcode', 'BIO-Teiltierhaltung', 'BIO-Teiltrennung', 'BIO-Tierort', 'BIO-Tierstatus', 'BIO-Tierzukauf', 'BIO-TirolTermin', 'BIO-Transaktion', 'BIO-TrappeBegruenung', 'BIO-TrockenA', 'BIO-TrockenG', 'BIO-TrockenKontrolle', 'BIO-TrockenNFZ', 'BIO-Uebernahmefrist', 'BIO-Uebernahmeumfang', 'BIO-Ueberschneidung', 'BIO-UmstandDauer', 'BIO-UmstandTemp', 'BIO-Umwandlung', 'BIO-UntersaatBonus', 'BIO-UntersaatDuerreregel', 'BIO-UntersaatVerfahren', 'BIO-Variantenwechsel', 'BIO-Vereinigung', 'BIO-Vergleichsschlag', 'BIO-Verlaengerung', 'BIO-Versuchsflaeche', 'BIO-Vertrag', 'BIO-Vertragsbindung', 'BIO-Vertragsschluss', 'BIO-Vertretung', 'BIO-Verweigerung', 'BIO-Vorjahresantrag', 'BIO-Vorjahresumbruch', 'BIO-WBDeckel', 'BIO-WBMFA', 'BIO-WasserDIV', 'BIO-Wechsel', 'BIO-Wiedereinstieg', 'BIO-WildRGVE', 'BIO-Wildbrut', 'BIO-WildbrutErnte', 'BIO-Wirtschaftsvolk', 'BIO-Zahlung', 'BIO-Zahlungsantrag', 'BIO-ZehnHaSRL', 'BIO-Zerstoerung', 'BIO-ZugangBetrieb', 'BIO-Zugangsfolge', 'BIO-Zugangstoleranz', 'BIO-Zweitkultur', 'BIO-Zwergrassen']
- [evidence] Q-A-4898-4905: evidence_text not found on cited page/source
- [evidence] Q-A-4908-4915: evidence_text not found on cited page/source
- [evidence] Q-A-5200-5213: evidence_text not found on cited page/source
- [evidence] Q-A-557-564: evidence_text not found on cited page/source
- [evidence] Q-A-5827-5848: evidence_text not found on cited page/source
- [evidence] Q-A-5905-5911: evidence_text not found on cited page/source
- [evidence] Q-A-6433-6491: evidence_text not found on cited page/source
- [evidence] Q-A-6495-6497: evidence_text not found on cited page/source
- [evidence] Q-B-427-430: evidence_text not found on cited page/source
- [evidence] Q-B-705-710: evidence_text not found on cited page/source
- [evidence] Q-S-927-930: evidence_text not found on cited page/source
- [profile_application] Rego uses paths absent from proposed profile: ['input.land.oepul.arable_area_ha', 'input.land.oepul.grassland_area_ha', 'input.land.oepul.oepul', 'input.land.oepul.parcels', 'input.livestock.oepul.area_ha', 'input.livestock.oepul.botanical_species', 'input.livestock.oepul.use']


## Budgetfreigabe für v3-o6_1b-astra-6.2-high-20261120 (Rule Lab #115, 20.11.2026)
Für diesen Auftrag ersetzt das Wochenfenster (10080 Minuten) das Fünf-Stunden-Fenster in der kopierten AGENTS.md. Der Runner hat vor dem Start 57.0 % Restbudget gemessen. Start ab 50 %, Stopp bei höchstens 5 %. Der Runner überwacht das Budget. Führe den Auftrag ohne erneute Budgetrückfrage aus.
Setze auf dem vorhandenen Workspace auf und prüfe zuerst die bisherigen Ausgaben.
