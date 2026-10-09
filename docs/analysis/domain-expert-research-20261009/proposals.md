# Vorläufige Lösungsvorschläge für die Domainexperten

Quellenbezug bedeutet keine fachliche Aufnahmefreigabe. Pro Vorschlag bleiben konkrete Restfragen und Varianten sichtbar. Ein Verweis auf eine bestehende ID umfasst nur die hier benannte Teilklausel.

## D01

**Fachliche Zeiträume, Datenstand und Nachweisvollständigkeit**

### R-D01-01

Je Fakt beobachteten Datenstand, Ereignisdatum, fachlichen Bezugszeitraum und Nachweis-Fälligkeit getrennt speichern. Das Bewertungsjahr wird dynamisch aus dem vertrauenswürdigen aktuellen Hostjahr bestimmt (Recherchezeitpunkt: 2026); gültige ältere Belege leben im aktuellen ausgewählten Snapshot weiter. Jahrespflichten, einzelne Ereignisfristen und Erstjahr-Basen werden je Klausel ausgewertet.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S003](https://www.ama.at/media/0ajdsv1p/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) · [S005](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/aufzeichnungsverpflichtungen-bei-der-oepul-massnahme-vorbeugender-grundwasserschutz-acker) · [S008](https://www.ama.at/media/cdyhus10/o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf).

Bestehende Teilfragen: `cross_measure-CURRENT_SNAPSHOT`, `o6_21-CURRENT_YEAR_REGISTER_SOURCE_SNAPSHOT_AND_ASOF`, `o6_16-COMPLETE_NAPV_RECORDS_EVENT_DELAYS_SMALL_CROP_SCOPE`

Alternativen:

- Ein einheitlicher Jahresfilter ist einfacher, verliert aber gültige Altbelege und verwechselt Jahresabschluss mit heute beobachtetem Stand.

**Die Experten müssen noch klären:** Welche Tatsachen- und Belegzeiträume gelten je klauselspezifischem Scope, einschließlich nachträglicher Bilanzierung und Übergaben? Technischer Feldvorschlag, keine gesetzlich vorgegebene App-Schemaform.

Folge für die Umsetzung: Zeitrollen im Datenvertrag explizit führen; weder alte Belege löschen noch zukünftige geplante Ereignisse als tatsächlich ausführen. Das Auswertungsjahr wird nicht auf 2026 fest kodiert.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Aktueller Snapshot 2026 enthält einen nachgewiesenen geeigneten GWA-Kurs aus 2024. | Alter des Belegs allein macht ihn nicht unbrauchbar; zur fachlichen Anrechnung passende Zeit- und Scopeklausel prüfen. | Anbieter/Thema/Personenbindung separat prüfen; keine pauschale Freigabe beliebiger Altbelege. |
| Auswertung 09.10.2026; betriebliche GWA-Bilanz 2026 ist noch nicht abgeschlossen. | Ein Bilanzabschluss mit Frist 31.01.2027 ist heute noch nicht fällig; tatsächliche bereits fällige Ereignisdokumentation bleibt unabhängig prüfbar. | Nur diese Bilanzfrist; keine allgemeine Schonfrist für Jahrespflichten. |
| Tatsächliches GWA-Düngeereignis 15.08.2026, keine Dokumentation, vollständiger dokumentierter Ereignisscope am 09.10.2026. | Die eigene 14-Tage-Frist liegt zurück; späterer Jahresabschluss beseitigt die fehlende fristgerechte Ereignisdokumentation nicht. | Ohne Vollständigkeitsbeleg unbekannt; Sanktion oder Zahlungsfolge nicht daraus erfinden. |

### R-D01-02

Faktzustand und Pflichtzustand getrennt führen: nicht bekannt, dokumentiert leer, dokumentiert vorhanden/falsch sowie fällig beziehungsweise noch nicht fällig. Eine Vollständigkeitsangabe benennt Betrieb/Entitäten, Zeitraum, ersetzten Scope, verantwortliche Rolle und Dokumentation. Dokumentierte Experten-/Betreiberwerte einschließlich Aggregate bleiben gemäß Nutzerentscheid maßgeblich vor AMA; eine Feed-Abweichung wird als Herkunftsdifferenz sichtbar.

Einordnung: `needs_expert` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S004](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/oepul-massnahme-vorbeugender-grundwasserschutz-acker-fristen-bis-jahresende-beachten) · [S005](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/aufzeichnungsverpflichtungen-bei-der-oepul-massnahme-vorbeugender-grundwasserschutz-acker).

Bestehende Teilfragen: `cross_measure-UNKNOWN_APPROVAL`, `cross_measure-CURRENT_SNAPSHOT`, `o6_16-TRAINING_REAL_PERSON_IDS_DEADLINE_CONCEPT_SCOPE`

Agenda-Restscopes: `AGENDA-REST-SCOPE_COMPLETENESS`, `AGENDA-REST-SHARED_FACT_RESULT_STATES`.

Annahmen:

- Vorgeschlagenes Status- und Vollständigkeitsmodell ist ein fachlicher Datenvertrag, keine allgemeine amtliche Statusdefinition.

Alternativen:

- Vollständigkeit auf einzelne Inventare/Perioden beschränken; Teilabdeckung liefert nur für diese Teilklausel ein Ergebnis.

**Die Experten müssen noch klären:** Welche Person/Rolle und dokumentierte Methode dürfen für welchen Scope die Vollständigkeit bestätigen, und wann belegt eine leere Angabe tatsächliches Nichtvorliegen? Keine neue amtliche Herkunftssperre.

Folge für die Umsetzung: Null und leere Liste nicht gleichsetzen; vollständige akzeptierte Aggregate mit Beleg-/Scopeverweis zulassen; Feed-Frische als eigene Metainformation.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Dokumentierter Betreiberbeleg bestätigt geeignete abgeschlossene GWA-Schulung 2026; eAMA zeigt noch keine neuen Stunden. | AMA erklärt für diese Kursdaten keine neue Einspielung vor März 2027; leereAMA-Anzeige widerlegt den Kursbeleg nicht. | Tatsächliche Anrechenbarkeit separat; keine amtliche Anerkennung aus Herkunft ableiten. |
| Leere Ereignisliste ohne Abdeckungs- oder Vollständigkeitsangabe. | Unbekannter Verlauf statt automatisch erfülltem Verzicht oder festgestelltem Verstoß. | App-Statusvorschlag benötigt fachliche Bestätigung je Pflicht. |
| Dokumentiertes Expertinnenaggregat beschreibt alle relevanten belegten Kurse der passenden Person/Betriebsperiode, AMA zeigt andere Summe. | Akzeptierter Expertenscope hat gemäß bestätigter Produktentscheidung Vorrang; keine Pflicht zur AMA-identischen Summe oder zu amtlichen Einzelzeilen. | Aggregate müssen gerade die für diese Klausel erforderliche Evidenz tragen; echte Rechtsakte können nicht durch reine Wertsetzung entstehen. |

### R-D01-03

Quellenklauseln mit Version, Originalfundstelle, dokumentiertem Geltungsbeginn und betroffenem Förder-/Ereignisjahr binden. Die aktuell publizierte SRL enthält verschiedene Anwendungsjahre: neue 2027-Leistungen bleiben 2026 Zukunftsnotiz, während die ausdrücklich vorgezogene PSM-Angabenänderung 2026 berücksichtigt wird.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S001](https://www.bmluk.gv.at/themen/landwirtschaft/gemeinsame-agrarpolitik-foerderungen/nationaler-strategieplan/foerderinfo/sonderrichtlinien-2023-2027/agrarumweltprogramm-oepul-ab-2023-inklusive-oekoregelungen.htm) · [S002](https://www.bmluk.gv.at/dam/jcr:af120840-dd49-47a7-b177-d1543a4861a3/01_SRL_OEPUL_2023_ab%202027_clean.pdf).

Bestehende Teilfragen: `cross_measure-SOURCE_VERSION`, `o6_24-CURRENT_FULL_EXTERNAL_REGULATION_GIS_AND_EXPERT_SNAPSHOT`, `o6_11-PSM_MFA_CODES_TO_2025_END_2026_AND_PLANNED_ACTUAL`

Agenda-Restscopes: `AGENDA-REST-CURRENT_COMPLETE_REFERENCE_PACK`.

Annahmen:

- Klauselbasierte technische Versionierung ist ein Umsetzungsvorschlag; der belegte Anwendungsunterschied stammt aus Abschnitt 1.20.

Alternativen:

- Dokumenttitel-/Dateinamensjahr als alleiniger Schalter wäre ungeeignet; alternativ getrennte nachvollziehbare Jahresfassungen mit Klausel-Diff erzeugen.

**Die Experten müssen noch klären:** Bei konkret widersprechender Rechts-/Merkblattklausel verbindliche Lesart bestätigen; Quellenbeschaffung ist technisch möglich, nicht neue Genehmigung der Herkunft von Expertendaten.

Folge für die Umsetzung: Quellenbeschaffung kann parallel starten; Regeln konsumieren nur ihre erforderlichen aktuellen Klauseln. Kein globaler Alle-Quellen-Gate für alle Maßnahmen.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Aktuelle Auswertung 2026, SRLDownloadname enthält ab 2027 und neuen UBB-Bio-Zuschlag. | Zuschlag gehört gemäß Geltungsbeginn noch nicht ins 2026-Erfüllungs-/Prämienergebnis; begründete Zukunftsnotiz möglich. | Andere unveränderte oder früher wirksame Klauseln derselben PDF bleiben getrennt. |
| 2026-Prüfung verlangt bislang historische MFA-PSMCodes als allgemeinen Pflichtbeleg. | Abschnitt 1.20 nennt Ausnahme 2026 zur Angabe; weggefallenen allgemeinen Angabeweg nicht weiter als 2026-Pflicht erzwingen. | Tatsächliche PSM-Verbote, Aufzeichnungen und spezifische Codes anderer Rechtsgründe separat prüfen. |
| Aktuelle WRRL-Verordnung/GIS-Fassung fehlt, einzelne heutige Nachricht verfügbar. | Nachricht belegt ihren Abschnitt, ersetzt aber keine vollständige dafür benötigte Rechts-/GIS-Tabelle. | Keine globale App-Sperre; betroffene unbelegbare Klausel offenlassen. |

Verbleibende Familiengrenzen: Vollständigkeitsbestätigung und gemeinsame Statussemantik sind App-/Domainvertragsvorschläge, keine schon geltende allgemeine Amtsdefinition.; Keine aktuelle vollständige Rechts-/GIS-/Registeraufnahme und keine Beantwortung sämtlicher Frage IDs.; Dokumentierter aktueller Expertinnen-/Betreiberscope einschließlich Aggregate ist akzeptiert; seine Herkunft erzeugt keine amtliche Anerkennung..

## D02

**Flächenidentität, Geometrie und tatsächliche Mengenbasis**

### R-D02-01

Getrennte interne Objekttypen für Feldstück, Schlag, Teilfläche und AFS mit stabiler Kennung, ausdrücklichen datierten Beziehungen und getrennter amtlicher Importkennung verwenden. Bestätigte Neuanlagen bleiben erlaubt und werden in Ansicht, Vergleich und Export sichtbar markiert. Anlageherkunft bleibt erhalten, auch wenn später jemand anderes einen Wert ändert.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S013](https://www.ama.at/media/u04mg4l1/merkblatt_mfa2026_v1_druckversion_endgueltig.pdf) · [S014](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=20012055).

Bestehende Teilfragen: `o6_1a-FIELD_PIECE_IDENTITY`, `o6_1b-FIELD_DIV_IDENTITY`, `o6_1c-AFS_ENTITY_IDENTITY`

Alternativen:

- Nur die aktuelle Beziehung zu speichern wäre einfacher, verliert aber den Nachweis von Teilung, Übergabe und historischer Feldstückzuordnung.
- Eine dokumentierte explizite Beziehung ohne Polygon ist als Eingabe möglich; ihre fachliche Anrechnung bleibt vom benötigten Maßnahmenscope abhängig.

**Die Experten müssen noch klären:** Für grenzüberschreitende AFS-Elemente und Teilungen festlegen, welche konkreten Teilmengen welchem Feldstück anrechenbar zugeordnet werden dürfen. Keine neue Zustimmung zur bereits bestätigten Neuanlage oder Herkunftspräzedenz erforderlich.

Folge für die Umsetzung: Interne IDs und datierte Beziehungen statt freier Aliasstrings; bei Neuanlage bleibt eine unbekannte amtliche Kennung leer. Erstellung und einzelne Werte erhalten getrennte Herkunftsnachweise. Auto erzeugt den bestätigten eigenen dokumentierten Snapshot. Amtliche Anerkennung ist bei Bedarf ein eigener belegter Sachverhalt.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Betreiber legt fehlenden 0,12-ha-AFS an; spätere Breitenkorrektur durch Experten. | Interne ID bleibt stabil; „Neu angelegt – Betreiber“ bleibt sichtbar; die Herkunft des Breitenwerts ist Experte; eine unbekannte amtliche Kennung bleibt leer. | Technischer Sollfall aus bestätigtem Produktvertrag. Die 0,12 ha sind damit nicht automatisch anrechenbar oder amtlich anerkannt. |
| Feldstück F wird geteilt; alter Pflegebeleg bezieht sich auf alte Teilfläche T. | Neue Beziehungen haben Gültigkeitszeiträume; alter Beleg bleibt bei damaliger T-Geometrie. Keine blinde Übertragung auf beide Nachfolger. | Die konkrete fachliche Übertragungsregel ist noch Expertenentscheidung. |

### R-D02-02

Je realer Fläche einen nachvollziehbaren aktuellen Kulissen-/Klassenjoin speichern: gewählte Layerfassung, Zeitraum, betroffene Teilmengen und Beleg. GWA, WRRL und WRRL-N-Klassen behalten eigene Joins. Maßnahmenteilnahmefläche, Prämienfläche und optionale Zuschlagsfläche bleiben getrennt.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S008](https://www.ama.at/media/cdyhus10/o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf) · [S015](https://www.ama.at/media/x3ejaxy2/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf) · [S016](https://www.ama.at/media/y2bpu23y/srl_oepul_2023_anhaenge_20261001.pdf) · [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf).

Bestehende Teilfragen: `o6_16-ORIGINAL_ANNEX_G_GIS_PART_AREAS_KG_HISTORY_AND_APP133`, `o6_16-FIRST_MEASURE_YEAR_MINIMUM_PIG_ONLY_ROUTE_APP133`, `o6_24-REAL_PARCEL_IDS_CLASS_GEOMETRY_UNION_AND_LN`, `o6_24-CURRENT_FULL_EXTERNAL_REGULATION_GIS_AND_EXPERT_SNAPSHOT`, `o6_24-MINIMUM2HA_VERSUS_ELIGIBLE_FALLOW_PERMIT_AND_OPWRRL`

Alternativen:

- Versionierte Polygonschnittberechnung, wenn aktueller Layer und Fläche vorhanden sind.
- Dokumentierter Experten-/Betreiber-Teilflächenwert mit eindeutiger Flächenbeziehung, Bezugsjahr und Grundlage; kein pauschales amtlich-only Inputgate.

**Die Experten müssen noch klären:** Für Grenzfälle bestimmen, welcher lagegenaue oder dokumentierte Mengenbeleg genügt und wie WRRL-Brachen/§4-Z 7-Flächen beim 2-ha-Zugang zählen. GWA-Erstjahr und jährliche WRRL-Prüfung nicht zusammenlegen; Schweinefütterungsoption ist eigener Scope.

Folge für die Umsetzung: App#133 erhält echte scopebezogene Join-Daten; größte KG ist kein Ersatz. Datum des gewählten Snapshots, Wirksamkeitsjahr der Rechts-/GIS-Fassung und tatsächliches Teilnahme-Erstjahr getrennt modellieren. Ein fehlender für den Scope notwendiger Join bleibt unbekannt; vorhandene dokumentierte manuelle Werte werden angenommen und ausgewertet.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Betrieb hat 3 ha Gesamtacker; dokumentierte aktuelle Kulissenanteile 1,2 ha+0,7 ha, übrige 1,1 ha außerhalb. | Gebietsmengenbasis 1,9 ha. GWA-Erstjahr- und WRRL-Jahresminimum sind damit nicht erreicht, unabhängig von der größten KG. | Nur Zugangsmengenfall bei vollständig bestätigter Betriebsbasis; weitere Voraussetzungen bleiben separat. |
| GWA-Betrieb: belegtes Erstjahr 2025 mit 2,1 ha im damaligen gültigen Gebiet; aktueller Snapshot 2026 zeigt 1,5 ha. WRRL-Betrieb 2026 ebenfalls 1,5 ha. | GWA-2-ha-Erstjahresklausel ist durch den historischen Beleg erfüllt; WRRL verlangt für 2026 erneut 2 ha und verfehlt diesen eigenen Mengenfall. | Kein Gesamturteil zu Vertrag, Pflege, Antrag oder Prämie; historischer Beleg und Aktualität des heutigen Snapshots schließen sich nicht aus. |
| WRRL: 3 ha im Gebiet, darin 0,4 ha Brache und 0,3 ha gültig bewilligte §4-Z 7-Fläche. | Zugangskandidat 3 ha und möglicher prämienfähiger Flächenkandidat 2,3 ha werden getrennt ausgewiesen; die Zugangsanrechnung ausgeschlossener Flächen bleibt offen. | 2,3 ha nur geometrischer Netto-Kandidat bei disjunkten Ausschlussmengen; kein bestätigter Zahlbetrag und kein Schluss auf 2-ha-Zulassung. |

### R-D02-03

Ein nachvollziehbares Mengenverzeichnis pro Quote anlegen: reale Flächenidentität, tatsächliche Teilmenge, Gültigkeit und Grund der Anrechnung. Dubletten derselben Identität und geometrische Überlappungen innerhalb derselben Quote werden erkannt. Zulässige Verwendung derselben Fläche in verschiedenen Quoten bleibt möglich.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S013](https://www.ama.at/media/u04mg4l1/merkblatt_mfa2026_v1_druckversion_endgueltig.pdf) · [S006](https://www.ama.at/media/3sud3npb/o6_1a_ubb_2026_04.pdf).

Bestehende Teilfragen: `o6_23-COMPLETE_PARCEL_ID_GEOMETRY_UNIQUE_CODE_MAPPING`, `o6_23-DIVSZ_ACTUAL_ELIGIBLE_AREA_UNION_CREDIT_NO_DOUBLE_AND_DROUGHT`, `o6_19-NET_GEOMETRY_GLOEZ_FALLOW_2025_ACCESS_CAP_ALLOCATION`, `o6_1c-AFS_ENTITY_IDENTITY`

Alternativen:

- Bei vorhandenen Polygonen eindeutige geometrische Vereinigung pro Quote berechnen.
- Bei dokumentierten Aggregaten den erklärten Scope und enthaltene IDs speichern; kein künstliches Polygon und keine frei erfundene Aufteilung erzeugen. Unbekannte Überlappung gezielt ausweisen.

**Die Experten müssen noch klären:** Bestätigen, welche Netto-/Teilflächen in den konkreten Scopes zählen, wie zulässige Aggregate abgegrenzt werden und wann fehlende Überlappungsbelege eine einzelne Quote offenlassen. Keine globale Sperre aller Maßnahmen wegen fehlender Geometrie.

Folge für die Umsetzung: Mengen erhalten scope_id und eigene Belege; Adapter dürfen Objekt-IDs nicht verlieren. Duplikatprüfung und Überlappungserkennung arbeiten vor der Quotensumme; Ergebnisse nennen verwendete Teilflächen.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Dasselbe 0,50-ha Objekt T ist in einer DIV-Quote zweimal referenziert. | In diesem technischen Mengenverzeichnis zählt T einmal 0,50 ha; ein zweiter Verweis schafft keine weitere Fläche. | Design-Sollfall für identische Entität. Rechtlich verschiedene Objekte dürfen nicht allein wegen gleichem Label zusammengelegt werden. |
| Eine bestätigte DIV-Fläche 0,16 ha auf 6-ha Feldstück trägt zum lokalen 0,15-ha Minimum und zum betrieblichen DIV-Zähler bei. | 0,16 ha wird einmal je jeweils eigener zulässiger Quote berücksichtigt. | Voraussetzung: echte DIV-Fläche und sämtliche maßgeblichen Pflege-/Nutzungsbedingungen; gilt nicht als pauschale AFS-DIV-Anrechnung. |

Verbleibende Familiengrenzen: Die drei Vorschläge lösen keine vollständigen Datenverträge aller 26 Maßnahmen. Vor allem geschützter Anbau, Hangklassen, Almsegmente und projektbezogene Habitatgeometrien brauchen eigene Scopes.; Aktuelle individuelleAMA/GIS-Exporte wurden nicht geladen. Kein Vorschlag erklärt interne Auto-/Expert-Neuanlagen zu amtlichen Flächen.; Ein dokumentierter Experte-/Betreiberwert wird vor AMA verwendet; Herkunftabweichung allein ist kein Blocker. Fachliche Voraussetzungen bleiben getrennt..

## D03

**Maßnahmenspezifische Flächenanrechnung und Quoten**

### R-D03-01

AFS-Anrechnung explizit nur für das dem Feldstück zugeordnete lokale Minimum modellieren; betrieblicher DIV-Zähler und reiner DIV-Zuschlag bekommen eigene Mengen. AFS-Nennerbehandlung und Grünland-Ersatzroute beim exakten 10-ha-Grenzwert bleiben offene Varianten.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf) · [S006](https://www.ama.at/media/3sud3npb/o6_1a_ubb_2026_04.pdf) · [S017](https://www.ama.at/media/22ffn51e/o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf).

Bestehende Teilfragen: `o6_1a-DIV_CREDIT`, `o6_1a-BOUNDARIES`, `o6_1b-DIV_TOPUP_SEPARATION`, `o6_1b-EXACT_TEN_HA`, `o6_1c-AFS_ENTITY_IDENTITY`, `o6_1c-COMBINATION_VS_CREDIT`

Alternativen:

- Die bestätigte lokale Anrechnung kann schon als gesonderter Implementierungskandidat vorbereitet werden; der offene betriebliche Nenner wird nicht vorausgefüllt.
- Für die strittige 10-ha-Ersatzroute beide Quellenlesarten mit Herkunft anzeigen, bis die zuständige fachliche Auslegung belegt ist.

**Die Experten müssen noch klären:** AFS-Feldstückzuordnung einschließlich Grenzübertritt/Teilmenge, AFS im betrieblichen 7%-Nenner und tatsächlicher DIV-Zuschlagsnenner bestätigen. Exakte 10,00 ha: SRL „bis 10 ha“ versus MB „unter 10,00 ha“ auflösen; kein stiller Vorrang.

Folge für die Umsetzung: Getrennte Mengen und Kalkulationen für lokales Minimum, betrieblichen DIV-Zähler, reine DIV-Zuschlagsfläche und jeweiligen Nenner. Ein gemeinsames Boolean würde diese Anrechnungskreise vermischen. Die offene Variante bleibt einer konkreten Frage zugeordnet.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Bestätigte Betriebsackerbasis 20 ha; Feldstück 6 ha, gültig zugeordnetes AFS 0,12 ha und echte DIV-Fläche 0,04 ha. | Lokaler Anrechnungskandidat 0,16 ha erreicht 0,15 ha; DIV-Zählerbeitrag aus diesen Objekten 0,04 ha. Die Quelle begründet keinen AFS-Beitrag zum 7%-Zähler. | 20 ha ist hier vorgegebene bestätigte Nennerbasis; AFS-Nennerfrage und übriger Betrieb fehlen. Kein 7%-Gesamturteil oder Goldenfall. |
| Genau 10,00 ha Acker; zusätzliche Grünland-DIV statt Acker-DIV. | Quellenkonflikt muss sichtbar bleiben. Aus dem aktuellen Textpaar folgt kein unabhängig gesichertes Ja/Nein zur Ersatzroute. | Lokales Feldstückminimum und Ersatzroute sind getrennte Klauseln; die 10-ha-Frage bleibt offen. |

### R-D03-02

Für BAW die tatsächliche beantragte BAW-Fläche B und den darin liegenden Erosionspfadanteil P getrennt und belegt erfassen. Viertelprüfung P/B und 4×Flächenkappe 4 P verwenden denselben nachvollziehbaren Scope; Feldstück- oder Betriebs-Pfadfläche darf nicht ungeprüft als P dienen.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S018](https://www.ama.at/media/zz0gd3ce/o6_8_erosionsschutz_acker_2026_04.pdf) · [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf).

Bestehende Teilfragen: `o6_8-BAW_GIS_QUARTER_VERSUS_CAP_AND_KG`, `o6_8-BAW_PART_AREAS_MINIMUM_DIV_AND_EXCLUSIONS`, `o6_8-BAW_THRESHOLD`

Alternativen:

- Aktueller GIS-Schnitt des konkreten BAW-Schlags und des Eintragspfads.
- Dokumentierter Experten-/Betreiberwert für die Schnittfläche dieses Schlags, einschließlich Grundlage; keine Annahme aus KG oder Feldstückgesamtausmaß.

**Die Experten müssen noch klären:** Bestätigen, wie der zugrundeliegende Pfad auf grenzüberschreitenden/überlappenden BAW-Flächen zugeordnet wird und welche Antrags-/Bewertungsfolge übergroße BAW-Codierung hat. Quellen erlauben kein stilles Herabsetzen auf 4 P als generelle Reparatur.

Folge für die Umsetzung: BAW-Geometrie, Schnittfläche, Jahreslayer, Viertelbedingung und Prämienkandidat getrennt anzeigen. BAW+DIV erhält zusätzliche Pflegeprüfung; Prämienkombination bleibt eigener Vertrag.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Feldstück 1 ha; tatsächlich darin beantragte BAW 0,40 ha; vollständiger Pfadanteil innerhalb dieser BAW 0,10 ha. | 0,10/0,40=25%; 4×0,10=0,40 ha. Quellenbasierter Mengenfall passt zur Viertel- und 4×Bedingung. | Nicht 0,10/1 ha rechnen; keine Freigabe aller weiteren Förderbedingungen. |
| BAW 0,40 ha enthält nur 0,05 ha Pfad; übrige 0,05 ha des Feldstückpfads liegen außerhalb BAW. | Scopebezogen nur 0,05 ha: 12,5% und 4 P=0,20 ha. Der zweite Pfadteil darf diese BAW nicht ohne geprüfte Zuordnung erhöhen. | Mathematischer Sollfall unter gewähltem Schnittflächenvertrag; genaue fachliche Pfadzuordnung noch bestätigen. |
| BAW 0,50 ha, tatsächlicher Pfad 0,10 ha. | 4 P beträgt 0,40 ha und Pfadanteil 20%; Übermaß/Quellenbedingungen ausweisen, keine unbemerkte positive Gesamtempfehlung. | Ob Antragskorrektur, Abzug oder weitere Bewertungsfolge eintritt, ist noch fachlich offene Entscheidung. |

### R-D03-03

NPA-Vollbestand, prämienfähige Nettofläche und jahrbezogene Pflegeflächen getrennt erfassen. 4% begrenzen den Prämienflächenkandidaten; sie ersetzen weder die 50%-Pflegebasis noch belegen sie einen Betriebsausschluss. Reinigungsschnitt wird als eigener Eventtyp mit tatsächlicher Neuansaat/Erstbeantragung geführt.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S017](https://www.ama.at/media/22ffn51e/o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf) · [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf).

Bestehende Teilfragen: `o6_1c-NPA_QUOTA_PART_AREA`, `o6_1c-NPA_AREA`, `o6_1c-NPA_EVENTS_AND_YEAR_END`

Alternativen:

- Pflegeereignisse mit konkreten Teilflächen/IDs verbinden; Anteil aus der überlappungsfreien Ereignisfläche im vollständigen NPA-Bestand berechnen.
- Ein dokumentiertes vollständiges Pflegeflächenaggregat ist möglich, sofern Scope/Zeitraum/Überlappung nachvollziehbar sind.

**Die Experten müssen noch klären:** Den vollständigen NPA-Bestand, überlappungsfreie Pflegemengen und GLÖZ 4-Teilflächen bestätigen; insbesondere noch klären, ob Reinigungsschnitt zur zweijährigen Mindestpflege beiträgt. Bei Prämienkappung die konkrete Auswahl/Zuteilung und andere offene Zahlungsgates gesondert festlegen.

Folge für die Umsetzung: Drei Mengen mit eigenen Quellen speichern: vollständiger NPA-Bestand, Netto-Prämienfläche und Pflegefläche. Rechenkandidat für die Prämienfläche ist min(bestätigte Netto-NPA, 0,04 × bestätigte Ackerbasis). Pflegequote aus vollständiger NPA-Basis ermitteln; Reinigungsschnitt als Sonderereignis führen. Ein freies Label ersetzt seine Voraussetzungen nicht.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Bestätigte Ackerbasis 100 ha; vollständiger NPA-Bestand 6 ha, davon 1 ha disjunkte GLÖZ 4-Ausschlussfläche. | Mengenrechnung: Netto Prämienflächenkandidat 5 ha, 4%-Kandidat 4 ha; 50%-Pflegebasis 3 ha. Nicht 2 ha aus der gekappten Prämienfläche ableiten. | Nur Rechenbasis bei geklärter gültiger NPA-Teilnahme; keine Zusage eines Zahlbetrags oder Festlegung der gekürzten Einzelflächen. |
| Neuansaat im ersten Antragsjahr; belegter Reinigungsschnitt vor 1. August; sonstige Pflege unbekannt. | Spezialevent nicht zur Maximalanzahl und 50%-Grenze addieren; zweijährige Mindestpflege nicht allein aufgrund dieses Events als bewiesen markieren. | Quelle lässt die letzte Mindestpflegefrage hier weiter offen; fehlende Pflegehistorie ist keine dokumentiert leere Pflegehistorie. |
| Bestehende ungebrochene Grünbrache, vor 1. August gehäckselt; freies Label Reinigungsschnitt. | Label allein begründet die Erstjahres-Neuansaat-Ausnahme nicht; tatsächliche Entstehung/Geschichte prüfen. | Ob Frühpflege dennoch im freien 50%-Scope zulässig war, hängt von bestätigter Betriebsbasis und anderen Pflegeflächen ab. |

Verbleibende Familiengrenzen: Die drei Vorschläge sind exemplarische Antwortkandidaten und ersetzen nicht alle D03-Aufnahmefragen. Natura/DIVSZ, AG, AGL, Futterfläche und geschützter Anbau behalten ihre maßnahmenbezogenen Quoten.; Amtlich geöffnete Quellen engen Fragen ein; Status/answer der 418 Originalfragen wurden nicht geändert.; Aktuelle vollständige GIS-/Projekt-/Rechtsdatenpakete, sämtliche Sonderfälle und unabhängig bewertete Goldenfälle sind noch abzuschließen..

## D04

**Tiere, Kategorien, Bestands- und Zeitbasis**

### R-D04-01

Jeden Bestandswert mit Einheit, Tierkategorie, Betrieb, Jahr, Zeitbasis und Beleg führen. Kalenderjahresdurchschnitt, 1.-April-Bestand und Weideperioden-RGVE werden eigene Größen. Rinder-Alterswechsel und Betriebswechsel erhalten datierte Teilintervalle. Dokumentierte Experten-/Betreiberaggregate bleiben zulässig und ersetzen AMA-Werte im selben fachlichen Scope; ein Jahresaggregat wird dabei nicht automatisch zum 214-Tage-Aggregat.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S003](https://www.ama.at/media/0ajdsv1p/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) · [S020](https://www.ama.at/media/wymfylme/o6_20_tierwohl_weide_2025_10.pdf).

Bestehende Teilfragen: `cross_measure-RGVE_COUNT_SCOPE`, `o6_3-RGVE_COHORTS_AND_FIRST_YEAR`, `o6_1b-RGVE_STOCK_BASIS`, `o6_2-RGVE_FODDER_BASIS`, `o6_17-ACTUAL_ANNUAL_RGVE_FORAGE_AND_LN_WITHOUT_ALM`, `o6_20-ACTUAL_RGVE214_FULL_ANIMALS_NO_FREE_OVERRIDE`, `o6_22-ACTUAL_APRIL1_VERSUS_CALENDAR_AVERAGE_AND_CORRECTION`, `o6_9-ANNUAL_PIG_GVE_CATTLE_DATABASE_AND_CATEGORIES`

Alternativen:

- Datierte Tier-/Kohortenverläufe mit nachvollziehbarer Ableitung oder dokumentiertes Aggregat mit passender Zeit- und Kategorieabdeckung; keine pauschale Pflicht zu einem Einzeltierregister für sämtliche Maßnahmen.

**Die Experten müssen noch klären:** Je Maßnahme Kategorie-/Faktorversion, Abdeckung, Alterswechsel und zulässige Aggregatbelege bestätigen. Bei laufendem Jahr ist die Darstellung eines noch nicht vollständigen Jahresdurchschnitts zu klären; bereits belegte Daten bleiben auswertbar.

Folge für die Umsetzung: Typisierte Bestandsbasis statt gemeinsamem unbeschriftetem Tierzahl-/RGVE-Feld; keine Umdeutung von Schweine-GVE in raufutterverzehrende RGVE. Der aktuelle Snapshot darf gültige ältere Bewegungsbelege enthalten. Mathematische Plausibilität und Provenienz getrennt prüfen.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Synthetischer Rechenfall für einen vollständig abgeschlossenen Oktobermonat im Vorjahr: Ein weibliches Rind bleibt vom 1. bis 31. Oktober in der Kategorie 0,5 bis unter 2 Jahre; Meldung und Kategorieabdeckung sind als Fallvoraussetzung belegt. | Für die Weideperioden-Mengenbasis ist der Teilbeitrag 31/214 × 0,60 = ungefähr 0,08692 RGVE; ein Kalenderjahreswert ist getrennt zu berechnen. | Nur die Mengenbasis eines abgeschlossenen Fallzeitraums; keine behaupteten künftigen Ist-Daten für Oktober 2026. Weidedauer-/Kategoriepflicht und alle übrigen Voraussetzungen sind separat zu prüfen; kein Gesamt-eligible- oder Zahlungs-Soll. |
| Nicht-Rinderbestand am 1. April und belegter Jahresdurchschnitt unterscheiden sich; ein dokumentierter Expertenwert enthält die Jahresdurchschnittsbasis. | Der Expertenwert gilt für diese Basis vor dem AMA-Wert. Der Stichtagswert wird nicht als identisches Maß ersetzt oder unbeschriftet addiert. | Abdeckung und konkrete Kategorie-/Faktortabelle benötigen fachliche Bestätigung; Aggregat ist nicht allein wegen seiner Herkunft unzulässig. |

### R-D04-02

Aus denselben belegten Aufenthalten zwei getrennte Kalender bilden: tatsächliche Tieraufenthalte über alle Almen und Tage mit Belegung je einzelner Alm. Tatsächliches Datum, Meldedatum und anrechenbarer Beginn bleiben getrennt. Überschneidungen werden je Identität vereinigt; Unterbrechungen werden nicht als Weidetage mitgezählt.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S007](https://www.ama.at/media/sazie2yn/o6_14_almbewirtschaftung_2026_04.pdf).

Bestehende Teilfragen: `o6_14-ACTUAL_STAYS_INTERRUPTION_UNION_YEAR_AND_AS_OF`, `o6_14-ANIMAL_IDS_AGE_JULY1_RGVE_KEY_AND_COUNTS`, `o6_15-ACTUAL_DATED_TIER_STAYS_ALM_CALENDAR_UNION_AND_AS_OF`, `o6_15-JULY1_RGVE_MILK_AGE_CALVING_QUANTITY_AND_SPECIES_IDS`, `o6_14-RGVE_DAYS`, `o6_15-MULTI_ALM`

Alternativen:

- Aufenthaltsjournal für konkrete Tiere bzw. in zulässigem Scope stabile dokumentierte Tiergruppen; die Gruppendarstellung darf keine unbemerkte Doppelzählung oder Zusammenlegung verschiedener Tiere erzeugen.

**Die Experten müssen noch klären:** Der Join von Tier-/Gruppenbelegen über Almen, Kategorie und Meldungen ist zu bestätigen. Die konkrete Zulässigkeit einer Gruppendarstellung hängt vom Tier- und Antragscope ab. Berechnung maximalen Besatzes, Behirtung und Prämienaufteilung separat bestätigen.

Folge für die Umsetzung: Eigene Intervalldienste je Tier-/Almscope; physische Anwesenheit und förderrechtlich anerkannte Tage getrennt. Keine Verrechnung des Kalenderjahres- oder 214-Tage-Nenners mit der 60-Tage-Bedingung.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Tier A belegt dieselbe Alm an 30 Tagen, danach Tier B an weiteren 30 Tagen; keine Überschneidung und keine weiteren Aufenthalte. | Almkalender: 60 belegte Tage. Tierkalender: je 30 Tage; die Tiermindestdauer wird durch die Almkalendersumme nicht bewiesen. | Keine Aussage über Gesamtförderfähigkeit oder Prämie. Weitere Bedingungen, Meldungen und Ausnahmewege bleiben separat. |
| Dasselbe Tier ist 30 Tage auf Alm A und nach einer belegten zehntägigen Unterbrechung 30 Tage auf Alm B; ansonsten keine Almbelegung. | Tierkalender: 60 tatsächliche Aufenthalts-/Weidetage. Almkalender: A und B jeweils 30, die Unterbrechung zählt nicht. | Ob die Tage im konkreten Förderfall anerkannt sind, hängt auch von Meldungen und übrigen Bedingungen ab. |

### R-D04-03

Weidetagebuch als Ereignisjournal mit Kategorie/Gruppe, Ort, tatsächlichen Intervallen und Unterbrechungen erfassen. Die Eingabe 'alle Tiere der Kategorie' oder belegte Geburtsunterbrechungsaggregate zulassen, wo dieAMA-Erleichterung greift. Amtliche Antragsidentität und Tagebuchform sind getrennte Anforderungen. Eine neu angelegte individuelle Tieridentität bleibt bis zur Produktentscheidung ein offener Scope.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S021](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/der-weidezeitraum-bei-der-oepul-massnahme-tierwohl-weide-beginnt-mit-1-april) · [S022](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/meldeverpflichtungen-zu-tierbezogenen-oepul-massnahmen).

Bestehende Teilfragen: `o6_20-DAILY_DIARY_REAL_GROUP_LOCATION_AND_FULL_CONTENT`, `o6_20-CATEGORY_PRESENCE_UNION_VERSUS_EACH_ANIMAL_ACTUAL_GRAZING`, `o6_20-ACTUAL_WINDOW_AS_OF_INTERRUPTION_BIRTH_AND_PLANNED_EVENTS`, `o6_20-ALM_TEMPORARY_STAY_DEPARTURE_DELETION_AND_COUNT_REPLACEMENT`, `o6_20-FULL_CURRENT_REGISTER_STRUCTURE_CHANGE_AND_UNIQUE_TIERS`

Alternativen:

- Vollständige individualisierte Ereignisse oder eine im konkreten Scope belegte Gruppendarstellung; keine universelle Ohrmarkenpflicht für alle Eingaben.
- Fehlende Einzelidentität als offenen Belegscope anzeigen und vorhandene Aggregatprüfung weiterhin ermöglichen.

**Die Experten müssen noch klären:** Belegen, wann eine Gruppe tatsächlich 'alle' und welche individuellen Unterbrechungen sie abdeckt; keine Gruppensummenunion über unterschiedliche Tiere zur individuellen Weideleistung umdeuten. Neue Tierobjekte sind eine separate Produktfrage, nicht erneut eine Frage zu bereits erlaubten Flächenneuanlagen.

Folge für die Umsetzung: Tagebuchmodell trägt Tier- und Gruppenscope; fehlende Scopevollständigkeit ist gezieltes missing_data. Experten-/Betreiber-/Auto-Provenienz und Dokumentation werden übernommen, ohne daraus amtliche Anerkennung zu erfinden.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Kategorie weidet 132 Tage; alle betroffenen Schafe stehen belegbar jeweils höchstens 11 Tage wegen Geburt im Stall, Anzahl und Gründe sind dokumentiert. | Für diesen vereinfachten Unterbrechungsscope bleiben mindestens 121 tatsächliche Weidetage; die fehlende einzeltierbezogene Geburtsdokumentation allein verwirft den zulässigen Aggregatbeleg nicht. | Es sind alle Voraussetzungen der AMA-Erleichterung zu bestätigen; Antragsidentitäten und übrige Auflagen bleiben separat. |
| Schaf/Ziege bleibt unter Verfügungsgewalt des Heimbetriebs und wechselt vorübergehend auf eine Alm. | Tatsächlicher Ortswechsel wird im Tagebuch geführt; daraus allein entsteht kein dauerhafter Heimbetriebsabgang. | Antrag, Almbewegung und etwaige echte Verkaufs-/Abgangsmeldungen weiterhin getrennt; 2026-spezifischer Meldescope. |

Verbleibende Familiengrenzen: Keine vollständige neu erfasste Kategorie-/GVE-/RGVE-Tabelle für alle 26 Maßnahmen; Alters-, Gewicht-, Förderplatz-, Ersatz- und Zuchtprogramme bleiben maßnahmenspezifisch.; Diese Recherche beantwortet nicht alle Stallraum- und Besatzfragen. Insbesondere die gemeinsame 500-kg-Grenze im Rinderstall-Merkblatt/SRL braucht weiterhin eine klare fachliche Lesart.; Einzeltierneuanlage, konkrete Identitätsbrücken und Dokumentvollständigkeit bleiben offen; bestehende bestätigte Aggregate-/Override-/Auto-Vorgaben gelten bereits.; Alle ursprünglichen Fragen und acht o6_3-Blocker bleiben offen; Vorschläge sind keine App-Zulassung und kein Golden-Orakel..

## D05

**Mittel, Futter, Dünger und Nährstoffgrößen**

### R-D05-01

Ein versioniertes N-Ledger mit explizitem Mengenbasis-Typ vorsehen: Tierhaltungsanfall nach Stall-/Lagerverlusten, Materialtransfer, tatsächlich ausgebracht, jahreswirksam, Bewässerung und Kulturübertrag. Jede Umrechnung trägt Ausgangsbasis, Einheit, Ereignisjahr und Faktorquelle. Dokumentierte Expert-/Betreiber-/Auto-Werte bleiben zulässige vorrangige Eingaben; ein unbekannter Umrechnungsfaktor wird sichtbar gehalten. Intern exakte Dezimalwerte erhalten und Anzeigepräzision von fachlicher Vergleichsrundung trennen.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S027](https://www.ama.at/media/hzade4zb/o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf) · [S028](https://ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=Bundesnormen&Gesetzesnummer=20012132) · [S036](https://www.ama.at/media/jlznh1sc/grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018_anlage3_2026.pdf) · [S015](https://www.ama.at/media/x3ejaxy2/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf).

Bestehende Teilfragen: `o6_2-N_CURRENT_CALENDAR_YEAR`, `o6_2-INPUT_ORIGIN_AND_SLURRY_RETURN`, `o6_16-N_ZONE_ACTUAL_MULTI_CROP_CHAIN_CAP_REDUCTION_AND_NMIN`, `o6_24-ACTUAL_EFFECTIVE_N_FULL_EVENTS_UNITS_FACTORS_AND_ROUNDING`

Alternativen:

- Direkte dokumentierte Eingabe eines bereits jahreswirksamen N-Werts mit bezeichnetem Scope.
- Berechnung aus tatsächlichen Mengen und vollständig versionierter Material-/Faktortabelle. Beide Wege können verglichen werden.

**Die Experten müssen noch klären:** Vollständige Faktoren und jeweils zulässige N-Basis bestätigen; WRRL 133-versus 133,2 sowie Randvergleich/Rundung entscheiden. Mengen-/Schlagbasis und Zeitversion vor und ab 08.06.2026 getrennt prüfen. Keine Rundung aus D10 übernehmen.

Folge für die Umsetzung: Keine Wiederverwendung von kg N/ha ohne Basisbezeichnung. Übernommener jahreswirksamer Wert wird nicht nochmals um Ausbringungsverluste reduziert. Düngeabnahme, Rücknahme und Tierhaltungsanfall getrennt projizieren. Teilbefunde bleiben möglich, während der spezifische Grenzfall offen ist.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| {"rinderguelle_n_after_stall_storage_kg": 100, "field_application_loss": 0.13, "annual_effect_factor": 0.7} | 60,9 kg jahreswirksamer N:100×0,87×0,70 nach NAPV § 1 Abs. 2 Z 14; keine Gleichsetzung mit 100 kg Tierhaltungsanfall. | Reines Umrechnungsbeispiel für bezeichnete Basis; keine Aussage zur Zulässigkeit einer tatsächlichen Gabe, Jahressumme oder Tierhaltungsgrenze. |
| {"wrrl_weighted_limit_terms": [{"area_share": "0.70", "limit_kg_n_ha": 144}, {"area_share": "0.30", "limit_kg_n_ha": 108}], "actual_n_kg_ha": "133.1"} | Exakter gewichteter Rechenwert 133,2 ist nachvollziehbar; offizielles Beispiel nennt 133. Der Vergleich muss den unbeantworteten Rundungsrest anzeigen. | Keine Festlegung erfüllt/nicht erfüllt an 133,1, solange die fachliche Rundungs-/Vergleichsregel offen ist. |
| {"expert_documented_annual_effective_n_kg": 60.9, "ama_annual_effective_n_kg": 50, "input_basis": "already_annual_effective"} | Der dokumentierte Expertenwert gilt nach bestätigter Produkteingabepriorität; keine zweite Faktorverrechnung und kein Konfliktblocker allein wegen AMA-Abweichung. | Gültiger Entitäts-/Zeitscope bleibt erforderlich; dieses Beispiel begründet keine amtliche Freigabe oder Zahlung. |

### R-D05-02

Zwei getrennte fachliche Verträge über gemeinsam erfasste Chargen und Rezepte aufbauen: Rohproteinprüfung mit bezeichnetem 88%-TM-Bezug, tatsächlicher Tier-/Gewichts-/Deck-/Säugephase und Rationszeitraum sowie GVO-/Europa-Prüfung des vollständigen Jahresinventars über alle Tierarten. Die originale Analysebasis, Labor-/Hersteller-/Literaturquelle und dokumentierte tatsächliche Fütterung erhalten. Ein Datendesign zur Normalisierung ist noch keine bestätigte fachliche Einheitenauslegung; unbekannte Werte und der aktuelle 32-/50-kg-Konflikt bleiben sichtbar.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S029](https://www.ama.at/media/hnybeza1/o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf) · [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf) · [S030](https://www.ama.at/media/yrcj42ls/o6_22_tierwohl-schweinehaltung_2025_10.pdf).

Bestehende Teilfragen: `o6_9-ALL_RATIONS_WEIGHT_CLASSES_AVERAGING_88DM`, `o6_16-ANNUAL_ALL_PIG_RATIONS_PHASE_COVERAGE_AND_O6_9_EXCLUSION`, `o6_22-GVO_PROTEIN_ALL_SPECIES_STOCKS_EUROPE_AND_REAL_RECIPES`

Alternativen:

- Vollständige Rationsphasen mit jeweiligen Rezeptbelegen; unabhängige Prüfung jeder Phase.
- Durchschnittsroute nur mit fachlich bestätigter Gewichtung, vollständigem Verbrauch/Zeitraum und zulässigen Klassen.

**Die Experten müssen noch klären:** Mittelwertgewichtung, Einheiteninterpretation und Umrechnung der konkreten Analysebasis sowie Jungsauen-32-/50-kg-Grenze klären. Die aktuelle SRL bezeichnet Grenzwerte als je kg Ration in der Trockenmasse (88 % TM), Rezepturen dagegen als je kg FM (88 % TM). Diese Formulierungen werden nicht durch eine ungeprüfte allgemeine Umrechnungsformel vereinheitlicht.

Folge für die Umsetzung: GVO-/Europa-Zuschlag weder aus Rohproteinerfüllung noch aus Schweineantragsliste ableiten. Jahresinventar umfasst Altbestände und andere Tierarten; unvollständige Chargenliste ist kein Volljahresnachweis. Labor-/Literatur-/Herstellerbeleg gleichwertig nach jeweiliger Quellenvorgabe erfassbar.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| {"species": ["pig", "laying_hen"], "pig_feed": "gvo_free_european", "laying_hen_protein_feed": "gvo_overseas", "year_inventory_complete": true} | Der GVO-/Europa-Zuschlag 22 ist unter diesen Tatsachen nicht erfüllt; die gut dokumentierte Schweineration ändert den anderen Tierartbestand nicht. | Nur diese Zuschlagsauflage; keine Aussage zu Basismaßnahme 22 oder Rohprotein 9/16. |
| {"species": "pig", "ungedeckte_jungsau_weight_kg": 40, "recipe_protein_g_per_kg_88dm": 158, "source_set": ["MB9 June 2026", "SRLOct 2026"]} | Den belegten Klassenkonflikt 32/50 kg ausgeben; keine automatische Auswahl zugunsten einer Quelle. | Kein Golden-Soll für diese Klasse vor fachlicher Entscheidung. |
| {"phase": "mast 60_to 90 kg", "actual_recipe_g_per_kg_88dm": 154, "source": "manufacturer", "documented": true, "actual_phase_feeding": true, "analysis_basis_confirmed_match": true} | Bei ausdrücklich als übereinstimmend bestätigter Einheitenbasis liegt 154 unter der belegten 155-g-Grenze der bezeichneten Phase; Herstellerangabe ist eine vorgesehene Nachweisquelle. | Nur diese Phase bei bestätigter Einheit; kein Soll für eine allgemeine 88%-TM-Umrechnung. Übrige Tiere, Jahresdeckung, Technik und Teilnahme bleiben eigenständig. |

### R-D05-03

Produkt-/Zulassungsinstanz und tatsächliche Anwendung getrennt erfassen: Produktkennung oder nachvollziehbar dokumentierte Produktidentität, Version/Gültigkeit, Wirkstoff, Wirkungstyp, Kultur/Indikation, Datum, Menge und behandelte Fläche. BIO-Eignung und konkreter Behördenweg sind zusätzliche, jeweils konkret zugeordnete Belege. Registerfakten dürfen Experten/Betreiber/Auto dokumentiert eingeben; keine Beschränkung auf amtlich importierte Eingaben. Geplante Anwendungen bleiben Plandaten.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S031](https://www.baes.gv.at/zulassung/pflanzenschutzmittel/pflanzenschutzmittelregister/) · [S032](https://www.ama.at/media/zmbeks2v/o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf) · [S037](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich).

Bestehende Teilfragen: `o6_11-AGES_EFFECT_TYPE_PRODUCT_ID_VERSION_AND_APP_PSM`, `o6_12-AGES_BIO_LIST_PRODUCT_ID_VALIDITY_AND_ACTUAL_EVENTS`, `o6_12-AUTHORITY_ORDER_PRODUCT_AREA_DATE_LINK_AND_PROOF`, `o6_16-PSM_PRODUCT_REGISTER_REAUTHORIZATION_CROP_EVENTS_AND_CODE`

Alternativen:

- Versionierter Import von Registerauszügen mit Kulturbaum und historischer Indikation.
- Dokumentierte manuelle Produkt-/Anwendungseingabe mit denselben fachlichen Feldern und nachvollziehbarem Beleg.

**Die Experten müssen noch klären:** Konkrete vollständige Produkt-/BIO-Listen und benötigte Anwendungskriterien je Maßnahme bestätigen; den belegten Weißkrautalias getrennt von nicht belegten Feld-/Kulturaliasen aufnehmen. Insektizid-Anordnung und Ausstieg dürfen nicht aliasiert werden.

Folge für die Umsetzung: Freie psm_used/allowed/is_bio-Bools sind keine alleinige Regelbasis. Adapter muss Wirkungstyp, Kultur und Datum verlustfrei transportieren. Wegfall der MFA-Codierung 2026 löscht keine tatsächliche Anwendung. Dokumentationsweg für spezielle Juni 2026-Anordnung getrennt von älteren allgemeinen Meldepassagen halten.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| {"event_status": "planned", "date": "2026-11-01", "as_of": "2026-10-09", "effect_type": "Insektizid"} | Keine tatsächliche heutige Anwendung ableiten; ggf. Zukunftshinweis mit Begründung. | Keine Bewertung einer bereits eingetretenen anderen Anwendung. |
| {"product_registered": true, "allowed_indication": "apple", "actual_crop": "vine", "documented": true} | Produktzulassung allein bestätigt die konkrete Weinanwendung nicht; Indikationsbezug bleibt entscheidend. | Keine erfundene generelle Unzulässigkeitsliste; echte Ausnahme-/Notfallzulassung muss separat recherchiert werden. |
| {"culture_alias": "BRSOL→BRSOH", "change_date": "2026-01-30", "actual_culture": "Weißkraut"} | Diesen dokumentierten technischen Alias ohne Änderung des Zulassungsumfangs zulassen. | Kein Muster für andere Namens-/Codeabweichungen; Originalwerte und Quellversion erhalten. |

Verbleibende Familiengrenzen: D05 deckt damit gezielte zentrale Eingabeverträge ab, nicht sämtliche Stoff-, Saatgut-, Futter- und Düngerfragen aller 26 Maßnahmen.; Vollständige aktuell fachlich bestätigte Produkt-/BIO-/Material- und N-Tabellen sowie vor 08.06.2026 wirksame WRRL-Anlage 3 fehlen.; Mittelwertgewichtung, 88%-TM-Analysekonvertierung der konkreten Quelle, Jungsauen 32/50 und WRRL-Rundung bleiben explizite Fachfragen..

## D06

**Bewirtschaftungsereignisse, Fristen und tatsächliche Nutzung**

### R-D06-01

Pflege, Mahd, Abtransport, Häckseln, Beweidung und Umbruch als eigene tatsächliche Ereignisse mit Fläche, Methode und Datum speichern. Der jeweilige Pflichtenvertrag bestimmt dann erlaubt/verboten, Vollflächenumfang und Wiederholungszeitraum. NPA-Pflege und Bergmähder-Leistung dürfen nicht durch denselben universellen 'Mahd erledigt'-Wert abgedeckt werden.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S017](https://www.ama.at/media/22ffn51e/o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf) · [S023](https://www.ama.at/media/o0xjv3dr/o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf).

Bestehende Teilfragen: `o6_1c-NPA_CARE`, `o6_1c-NPA_EVENTS_AND_YEAR_END`, `o6_4-MOWING_HISTORY`, `o6_4-TWO_YEAR_FULL_MOWING`, `o6_4-AFTERMATH_YEAR_AND_INTERVALS`, `o6_4-METHOD_AND_ANNUAL_BM_CODE`, `o6_19-ACTUAL_BIENNIAL_CARE_AND_PRIOR_WRITTEN_AMENDMENT`

Alternativen:

- Schlagereignis bei nachweislich vollflächiger Durchführung oder mehrere dokumentierte Teilflächenereignisse mit überprüfter Flächenunion; keine Mehrheitsschwelle erfinden.

**Die Experten müssen noch klären:** Startanker und vollständige Historie der zweijährlichen Pflicht einschließlich Einstieg, Flächenübergang und konkreter Projektauflage bestätigen. Für NPA die 50%-Pflegeaufteilung und Reinigungsschnittabgrenzung bestätigen; für gemischte Bergmähderverfahren keine erfundene Mehrheitsregel setzen.

Folge für die Umsetzung: Maßnahmenspezifische Ereignis-/Fristverträge; gültige Vorjahresbelege bleiben im aktuellen Snapshot nutzbar. Noch offene Pflegefrist erzeugt kein fertiges Erfüllungsergebnis und allein keinen Verstoß; ein bereits vollzogener verbotener Vorgang wird sofort geprüft.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| NPA wird tatsächlich zur Futtergewinnung gemäht, das Mähgut wird abtransportiert; der nächste Pflege-Endtermin liegt noch in der Zukunft. | Der bereits ausgeführte Abtransport/Nutzungsvorgang erfüllt keine zulässige NPA-Pflegemahd und wird als möglicher konkreter Verstoß geprüft; er wird nicht bis Fristende als offen vertagt. | Konkreter Flächen-/Maßnahmen-/Ausnahmescope muss belegt sein; keine automatische Sanktionshöhe. |
| Bergmahd ist 2026 nur auf 70% tatsächlich gemäht und abtransportiert; letztes zulässiges Vollflächenereignis ist im relevanten Zweijahresfenster noch unbekannt. | 70% belegen keine Vollmahd. Die gezielt fehlende Vorjahreshistorie bleibt missing_data; eine geplante Restmahd ist keine tatsächliche Vollleistung. | Frist-/Zweijahresanker und Flächenänderungen müssen fachlich bestätigt werden, bevor ein endgültiger Jahresverstoß abgeleitet wird. |
| Bergmahd wird im bestätigten Nichtmahdjahr erst ab 16. August nachbeweidet. | Die Nachweide ist im betreffenden Datumsscope grundsätzlich erlaubt und ersetzt keine erforderliche Mahd mit Abtransport. | Übrige Maßnahmendetails, Historie und überlagerte Projektauflagen bleiben separat. |

### R-D06-02

Immergrün aus der tatsächlichen Kulturfolge aller Ackerflächen je Kalendertag ableiten: Hauptfrucht, Zwischenfrucht, Lücke, spätere Hauptfrucht und Flächenzugänge. Übergangslücken werden erst bei belegten Folgeereignissen abschließend klassifiziert. Aktuell noch offene Anbaufristen bleiben als laufende Bedingung sichtbar; überschrittene abgeschlossene Lücken verändern die Bewertung des gesamten betroffenen Intervalls.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S024](https://www.ama.at/media/xqna4row/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf).

Bestehende Teilfragen: `o6_7-CHRONOLOGY_FULL_GAP_AND_AS_OF`, `o6_7-COMPLETE_RECORDS_AND_ACTUAL_HISTORY`, `o6_7-SHORT_CATCH_CROP_AND_RECLASSIFICATION`, `o6_7-COMPLETE_ALL_ARABLE_DAILY_DENOMINATOR`, `o6_7-CARE_MECHANICAL_REMOVAL_AND_EVENT_EFFECT`

Alternativen:

- Bei unvollständiger Kulturfolge nur belegte Tagesabschnitte bewerten und offene Abdeckung ausweisen; kein stillschweigend weitergeführter 'aktuell begrünt'-Status für das ganze Jahr.

**Die Experten müssen noch klären:** Die Wirkung einer noch laufenden Lücke auf heutige Darstellung und frühere vorläufige Tagesquoten bestätigen. Kurze nicht anrechenbare Zwischenfrucht samt angrenzenden Lücken, 50-Tage-Hauptfruchtweg und Flächenübergang sind konkrete Restscopes; keine Alias-/Hauptfruchtumdeutung aus einer MFA-Bezeichnung erfinden.

Folge für die Umsetzung: Zeitverlauf mit tatsächlichem Ereignisdatum und Erkenntnisdatum; nach neuem Beleg vergangene Tagesquote nachvollziehbar neu berechnen. Aktuelle Kenntnis endet am Prüfdatum, überjährige Pflichten tragen ihren echten Folgejahrestermin.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Ohne anwendbare Ausnahme wird nach Hauptfruchternte eine Zwischenfrucht erst nach 31 Tagen angelegt; 20% der beurteilten Gesamtackerfläche betreffen diese Lücke, übrige 80% sind durchgehend gültig begrünt. | Das gesamte 31-tägige Lückenintervall ist unbegrünt; 80% reichen dann im betroffenen Zeitabschnitt nicht für die 85%-Bedingung. | Geschlossene Kultur-/Flächenhistorie und Nichtanwendbarkeit der 2026-Erleichterung müssen belegt sein. Kein Zahlungs-/Sanktions-Soll. |
| Belegte winterharte Zwischenfrucht wird am 5. Oktober 2026 angelegt; Snapshot vom 9. Oktober enthält erst wenige belegte Tage und einen geplanten Umbruch im Februar 2027. | 42-Tage-/Erhaltsbedingungen sind noch laufend, die Planung ist kein tatsächlicher Nachweis. Das Datum 15. Februar 2027 bleibt eine überjährige Bindung. | Tagzählungsgrenzen und vollständiger Scope werden separat bestätigt; kein automatisches Gesamt-eligible oder aktueller Verstoß allein wegen noch fehlender künftiger Tage. |

### R-D06-03

Ein gemeinsames Ereignisjournal um jeweils eigene Aufzeichnungs-, Anbau-, Umbruch-, Aufbewahrungs- und Jahresabschlussfristen ergänzen. Jahres- und Ausnahmeversion gehören zum Pflichtenvertrag. Die 2026-Dürre-Erleichterung für Immergrün wird als begründeter Ausnahmescope erfasst, ohne unveränderte Erhaltungs-/Herbstanforderungen zu löschen.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S025](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung) · [S026](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/aufzeichnungsverpflichtungen-im-oepul-2023).

Bestehende Teilfragen: `o6_7-CHRONOLOGY_FULL_GAP_AND_AS_OF`, `o6_7-COMPLETE_RECORDS_AND_ACTUAL_HISTORY`, `o6_16-COMPLETE_NAPV_RECORDS_EVENT_DELAYS_SMALL_CROP_SCOPE`, `o6_16-AUTUMN_REAL_DATES_CROP_BREAKUP_AND_GRENING_JOIN`, `o6_9-ACTUAL_APPLICATION_LOG_GROUPING_AND_EQUIPMENT`, `o6_1a-PHEROMONE_PERIOD`, `o6_1b-PHEROMONE_RETENTION`

Alternativen:

- Belegtes Ausnahmekriterium mit abgegrenzter Wirkung oder gezielt offener Ausnahmescope; eine generelle 'Dürre=true'-Freistellung ist durch die Quelle nicht gedeckt.
- Eigenes Journal oder importierte fachlich gleichwertige Aufzeichnungen mit denselben erforderlichen Angaben und Herkunft; kein App-spezifisches Formular als fachliche Pflicht.

**Die Experten müssen noch klären:** Konkreten Nachweis für vorausschauende Bewirtschaftung und frühestmögliche Nachholung bestätigen. Die Erleichterung nennt verspätete Zwischen-/Hauptfruchtanlage; eine Übertragung auf andere Fristen oder Maßnahmen wird nicht angenommen. Welcher Aufzeichnungsdatumsbeleg die fristgerechte Fertigstellung beweist, bleibt offen.

Folge für die Umsetzung: Ereignisdatum, Erfassungs-/Fertigstellungsdatum, Fristende und Quellenversion getrennt. Current-snapshot-Auswertung kann 2026-Ereignisse mit noch nicht fälligem Bilanzabschluss 31. Januar 2027 führen. Historische Quelle/Ausnahme wird nicht global auf aktuelle Jahre fortgeschrieben.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Immergrün-Anlage erfolgt 2026 später als Grundfrist; Dürre und tatsächlicher Anbau sind dokumentiert, eine frühere agronomisch mögliche Anlage ist jedoch nicht geklärt. | Der gezielte Ausnahmescope bleibt ungeklärt, statt die Grundfrist automatisch auszuschalten. Belegte übrige Ereignisse bleiben prüfbar. | Keine automatisierte Glaubwürdigkeitsentscheidung. Die Domainexperten bestätigen erforderliche Belegstruktur und konkrete Wirkung. |
| 2026-Düngung wurde ausgeführt; Snapshot vom 9. Oktober dokumentiert rechtzeitige Ereignisaufzeichnung, aber noch keine Jahresbilanz 2026. | Die Ereignisaufzeichnung ist getrennt prüfbar. Die bis 31. Januar 2027 offene Bilanzfrist ist am 9. Oktober kein Bilanzverstoß und keine bereits abgeschlossene Bilanz. | Gilt für den konkret belegten Grundwasserschutzscope, nicht pauschal für sämtliche Aufzeichnungsarten. |
| Belegte 2026-Ausnahme wird in einem aktuellen 2027-Snapshot als einzige Grundlage einer späteren Anlage angegeben. | 2026-Jahresbindung verhindert automatische Fortgeltung; es ist die für 2027 einschlägige Grundlage erforderlich. | Keine Aussage, dass 2027 keine eigene Ausnahme existiert; diese wurde hier nicht recherchiert. |

Verbleibende Familiengrenzen: Die konkrete zeitliche Anrechnung kurzer Zwischenfrüchte, 42-/50-Tage-Wechsel, unvollständiger aktueller Lücken und zweijähriger Einstiegssituationen bleibt fachlich zu bestätigen.; Keine universelle Übertragung zwischen NPA, Bergmähdern, BAW, AG, DIV, NAT, EBW oder Natura 2000. Projektauflagen, Methoden und Ausnahmescopes bleiben eigene Verträge.; Vollständige aktuelle Nitrat-/Länder-Verordnungen, alle Begrünungsvarianten, Mischungslisten und aktuelle Quellenpakete wurden hier nicht vollständig erfasst. Die Vorschläge schließen keine dieser Quellenlücken.; Unabhängige Fälle sind diskussionsfähige Prüfideen mit begrenzten Sollgrundlagen, keine bereits fachlich bewerteten Golden-Tests..

## D07

**Projekt-, Rechts-, Anerkennungs- und Ausnahmewirkung**

### R-D07-01

Gemeinsames versioniertes Belegobjekt mit Typ, Ausstellerrolle, Referenz, Wirksamkeit, Entitäts-/Geometriebezug und vollständigen Pflichtinstanzen vorsehen. Maßnahmenspezifische Schemas beschreiben NAT-Auflagen, EBW-Indikatoren/Zusatzindikatoren, optionale NATA-Almauflagen und N 2-Landesrechtsbezug. Derselbe Auflagencode mit anderen Parametern bleibt eine eigene Instanz. Inhaltliche Projektänderung, unveränderte Projektbestätigung und rechtliche Änderung werden getrennt historisiert.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S033](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/informationen-zu-den-oepul-naturschutz-massnahmen) · [S010](https://www.ama.at/media/fkudzkum/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf) · [S007](https://www.ama.at/media/sazie2yn/o6_14_almbewirtschaftung_2026_04.pdf) · [S034](https://www.ama.at/media/kb4f3kbi/o6_23_natura2000-landwirtschaft_2025_10.pdf) · [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf).

Bestehende Teilfragen: `cross_measure-PROJECT_IDENTITY`, `o6_18-PROJECT_ID_VERSION_AUTHORITY_FULL_GEOMETRY_PARAMS_AND_AMENDMENT`, `o6_18-ALL_PROJECT_OPERATION_GATES_ZERO_RATE_CODES_AND_NONBINDING_INFO`, `o6_19-VERSIONED_PROJECT_GIS_INDICATOR_PARAMS_BINDING_AUTHORITY`, `o6_14-NATA_FULL_CONFIRMATION_HABITATS_ANNEX_E_CODES_SCOPE`, `o6_23-CURRENT_FULL_PROJECT_LAND_LAW_GIS_SNAPSHOT_AND_HOST`

Alternativen:

- Typisierte vollständige Projektexporte mit Rohbeleg und verständlichem Einzelinstanzeditor.
- Dokumentierte manuelle Eingabe durch Experte/Betreiber/Auto mit gleichen Pflichtfeldern; spätere Importe ergänzt als Vergleich.

**Die Experten müssen noch klären:** Welche vollständigen tatsächlich zugewiesenen Parameter/Flächen gelten, wer bestätigt die Bindung, und welche individuelle Projektversion ist wirksam? Nicht bestätigte Codemappings und der Zusatzindikatorstatus werden nicht aus Namen erraten.

Folge für die Umsetzung: recorded_by/source bleibt getrennt von issuer/legal_effect. Dokumentierte Experten-/Betreiber-/Auto-Werte haben Eingabevorrang; sie sind damit keine amtliche Ausstellung. Die Eingabeherkunft allein blockiert keinen Wert. Nicht bindende EBW-Zusatzindikatoren werden keine Zulässigkeitsblocker; verbindliche Auflagen mit Null-Euro-Tarif bleiben erhalten.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| {"measure": "EBW", "project_indicator": {"binding": true, "met": true}, "additional_indicator": {"binding": false, "met": false}, "remaining_project_complete": true} | Aus dem nicht erreichten Zusatzindikator allein folgt keine Nichterfüllung; verbindliche Indikatoren bleiben zu prüfen. | Nur die angegebene Auflagenrolle; kein vollständiger Maßnahmen-/Zahlungsbescheid. |
| {"measure": "NATA", "alm": "A", "project_covers": ["A1"], "actual_fieldpieces": ["A1", "A2"]} | Fehlende Auflagen-/Projektdeckung für A 2 sichtbar machen; A 1-Bestätigung nicht automatisch auf A 2 übertragen. | Keine Annahme, dass A 2 verboten ist; zuerst die vollständige individuelle Projektinstanz klären. |
| {"measure": "NAT", "expert_documented_project_parameter": "actual_cut_not_before_2026-09-01", "ama_parameter": "2026-08-15", "both_same_scope": true} | Dokumentierter Expertenwert wird als geltender Eingabestand verwendet und AMA-Abweichung sichtbar; keine alleinige Konfliktsperre. | Sollbeispiel zur bestätigten Eingabepriorität; einzelne Rechtswirkung und Ausnahmescope bleiben getrennte Tatsachen. |

### R-D07-02

WRRL-Wege explizit unterscheiden: Grundroute, bewilligungsfreier +10%-Weg nach § 4 Z 3/Anlage 3 Punkt 2 und tatsächlicher Abweichungsbescheid nach § 4 Z 7. Pro Weg gelten eigene Voraussetzungen, Meldeereignisse, Wirksamkeit und möglicher Prämienausschluss. OPWRRL wird nur an den entsprechenden erhöhten-N-Bescheidweg gekoppelt; keine pauschale Bescheidpflicht für jede Mehrdüngung. Ereignisse vor und ab 08.06.2026 verwenden passende Rechtsversionen.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S035](https://www.ris.bka.gv.at/GeltendeFassung.wxe?Abfrage=LrStmk&Gesetzesnummer=20001423) · [S036](https://www.ama.at/media/jlznh1sc/grundwasserschutzprogramm-graz-bis-bad-radkersburg-2018_anlage3_2026.pdf) · [S015](https://www.ama.at/media/x3ejaxy2/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf).

Bestehende Teilfragen: `o6_24-CURRENT_FULL_EXTERNAL_REGULATION_GIS_AND_EXPERT_SNAPSHOT`, `o6_24-MINIMUM2HA_VERSUS_ELIGIBLE_FALLOW_PERMIT_AND_OPWRRL`, `o6_24-ACTUAL_DATED_APPLICATION_EVENTS_LEGAL_WINDOWS_AND_C_CLASS`, `o6_24-ACTUAL_EFFECTIVE_N_FULL_EVENTS_UNITS_FACTORS_AND_ROUNDING`

Alternativen:

- Der N-Weg kann aus dokumentierten tatsächlichen Bedingungen und dem passenden Rechts-/Projektbeleg abgeleitet werden.
- Direkte dokumentierte Angabe des genutzten Rechtswegs mit Einzelbedingungen und Beleg; fehlende Rechtswegdetails bleiben spezifischer Rest.

**Die Experten müssen noch klären:** Konkrete aktuelle Klassen-/Flächengeometrie, tatsächlich wirksamer Bescheid und Meldebeleg sowie verbleibende Mindestteilnahme-/Prämienflächenfrage bestätigen. Vollständige Tabelle vor 08.06.2026 und N-Rundung fehlen weiterhin.

Folge für die Umsetzung: Getrennte Zweigregeln verhindern eine fiktive Bescheidpflicht für +10 % und eine fiktive Förderfreigabe echter Z 7-Bescheide. Experten/Betreiber/Auto können die bezeichneten tatsächlichen Inhalte dokumentiert erfassen. Quelle des Eingabewerts ist keine amtliche Rechtsrolle.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| {"legal_route": "§ 4Z3", "winter_cover": {"direct_following": true, "winterhardy": true, "no_legumes": true, "unfertilised": true, "same_fieldpiece_area": true, "removed_immediately_before_spring_sowing": true}, "prior_written_notice": true, "winterbarley_special_route": false} | Diese Quelle sieht dafür einen bewilligungsfreien Weg vor; ein fehlender Individualbescheid ist alleine kein Ablehnungsgrund. | Andere N-/Zeit-/Grundpflichten und tatsächliche Datenvollständigkeit bleiben nötig; keine Gesamtförderfreigabe. |
| {"legal_route": "§ 4Z7", "permit_for_increased_n": true, "scope": "§ 4Z1–4", "parcel_in_wrrl_area": true} | Das amtliche Merkblatt verknüpft diese Bewilligungsroute mit Prämienausschluss und OPWRRL; nicht mit der bewilligungsfreien Route gleichsetzen. | Die jährliche 2-ha-Mindestteilnahme bei solchen Flächen bleibt eine eigene offene Frage. |
| {"winterbarley_special_route": true, "application_date": "2026-08-20", "requested_10percent_route": true} | Die aktuelle Anlage 3 schließt die gleichzeitige +10%-Inanspruchnahme im genannten Wintergerstenweg aus. | Kein vollständiges Wintergersten-Soll ohne 30-kg-/6-Tage-/Melde-/Folgefruchtprüfung. |

### R-D07-03

Ein Ausnahmeregister pro Pflicht mit amtlicher Basis, Jahr/Gebiet/Ereignis, Voraussetzungen, Rechtsweg und fortgeltenden Pflichten vorsehen. Öffentliche automatische Ausnahme, geänderte Landesverordnung, schriftliche Projektänderung und individuelle Anerkennung bleiben verschiedene Typen. Nachvollziehbare Nachweise zu tatsächlicher Anlage/Nutzung/Anwendung erfassen; ein undifferenzierter drought_approved/authority_approved-Wert reicht nicht aus.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S025](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung) · [S037](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/vorzeitiger-ausstieg-aus-der-oepul-massnahme-insektizidverzicht-wein-obst-und-hopfen-fuer-weinbaubetriebe-aufgrund-des-befallsdrucks-durch-die-amerikanische-rebzikade-moeglich) · [S033](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/informationen-zu-den-oepul-naturschutz-massnahmen).

Bestehende Teilfragen: `o6_8-DROUGHT_US_PROOF_VERSUS_OTHER_OBLIGATIONS`, `o6_18-DROUGHT_2026_RELEASE_CURRENT_SOURCE_SCOPE_AND_HARVEST_PROOF`, `o6_23-DROUGHT_ACTUAL_STATE_ORDINANCE_DATE_SCOPE_NOT_AUG12_GLOBAL`, `o6_12-AUTHORITY_ORDER_PRODUCT_AREA_DATE_LINK_AND_PROOF`, `o6_12-APPROVED_LEAFHOPPER_EXIT_EVIDENCE_CURRENT_YEAR_AND_FUTURE`

Alternativen:

- Versionierte öffentliche datierte Ausnahmetabelle mit automatischer Scopeprüfung und dokumentierten Betriebsfakten.
- Dokumentierte manuelle Eingabe von Scope und Rechtsweg durch Experte/Betreiber/Auto. Der eigene Auto-Snapshot trägt sichtbare Herkunft und stellt keinen realen Behördenakt aus.

**Die Experten müssen noch klären:** Welche konkrete geänderte N 2-Landesverordnung mit Wirksamkeit, welcher Untersaatnachweis und welche tatsächliche Bekämpfungsanordnung gelten? Gilt die US-Flächendeckungsausnahme auch für Feldaufgang? Für Aussteiger ab einem späteren Jahr die Prämienwirkung des 2026-Wortlauts gesondert klären.

Folge für die Umsetzung: Eine Ausnahme hebt nur benannte Pflichtanteile auf. Das Projekt-PDF kann unverändert bleiben, während eine öffentliche NAT-Ausnahme greift. Bei N 2 keine Naturschutz 18-Freigabe übernehmen. Ein bloßer Ausstiegsantrag ist keine Genehmigung; ein bekannter aktueller Verstoß wird nicht durch Zukunftsplanung überschrieben.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| {"year": 2026, "measure": "o6_8", "undersowing_ordinary_establishment": true, "specified_mix_partners": true, "coverage_failed": true, "individual_approval_document": null} | Die öffentlicheAMA-Route nennt automatische Anerkennung ohne zusätzliche Meldung; kein Individualbescheid für diese Deckungsausnahme verlangen. | Fristen, Herbizidverbot, Erhaltung und Feldaufgangsfrage bleiben getrennt. |
| {"year": 2026, "measure": "NAT", "cut_date": "2026-08-12", "cut_number": 1, "project_cut_date": "2026-09-01", "project_document_unchanged": true} | Der spezifische 2026-NAT-Hinweis erlaubt die Nutzungsfreigabe ohne Projektänderung. | Nur der genannte Nutzungstermin; andere Auflagen und reale Nutzung bleiben zu prüfen. |
| {"year": 2026, "measure": "N2", "cut_date": "2026-08-12", "changed_state_ordinance": "not_known"} | Die N 2-Rechtsänderung bleibt ungeklärt; das NAT-Datum alleine bestätigt keinen N 2-Ausnahmeweg. | Ein fehlender Rechtsbeleg bedeutet Unklarheit, wenn der Wert nicht anderweitig dokumentiert vorliegt, und bedeutet nicht automatisch einen Rechtsverstoß. |
| {"year": 2026, "measure": "o6_12", "actual_chemical_application": true, "authority_order": "explicit_chemical_active_for_target_area", "actual_events_documented": true, "exit_application": false} | Der konkrete Behördenweg des Juni-Hinweises kann einen Verbleib ermöglichen; nicht als Vertragsausstieg verarbeiten. | Konkretes Gebiet, Wirkstoff, Datum sowie explizite Anordnung oder fehlende BIO-Alternative müssen übereinstimmen; keine globale Freigabe. |

Verbleibende Familiengrenzen: Gelesene öffentliche Quellen sind keine konkreten Projekt-/Bescheid-/Landesrechts-/GIS-Datensätze des Betriebs.; Diese Vorschläge klären keine vollständigen Anhang-I/K-Kataloge, NATA-Flächenparametersätze oder N 2-Verordnungen aller Bundesländer.; Anerkennungszeit/Pflichtwirkung, Fachfälle der Haltung/Gesundheit und übergreifende Zahlungs-/Sanktionsfolgen bleiben je Maßnahme im Sammelissue offen..

## D08

**Personen, Kurse, Anträge und tatsächlicher Vertragszustand**

### R-D08-01

Eine gemeinsame Belegstruktur für Veranstaltung, tatsächliche Teilnahme, Person/Betriebsrolle und die konkrete Anrechnung verwenden. Dieselbe Veranstaltung nur einmal erfassen, Anrechnung auf Pflichten ausdrücklich zuordnen. Bei nachgewiesenen aggregierten Experten-/Betreiberangaben denselben Pflichtscope mit Dokumentationsverweis abbilden; kein Zwang zur Herkunft aus AMA-Einzelzeilen.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S004](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/oepul-massnahme-vorbeugender-grundwasserschutz-acker-fristen-bis-jahresende-beachten) · [S006](https://www.ama.at/media/3sud3npb/o6_1a_ubb_2026_04.pdf) · [S008](https://www.ama.at/media/cdyhus10/o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf) · [S010](https://www.ama.at/media/fkudzkum/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf).

Bestehende Teilfragen: `o6_1b-TRAINING_EVIDENCE`, `o6_2-TRAINING_PERSON_AND_CUTOFF`, `o6_14-COURSE_PERSON_PROVIDER_DATES_DOUBLE_CREDIT_REPLACEMENT`, `o6_16-TRAINING_REAL_PERSON_IDS_DEADLINE_CONCEPT_SCOPE`, `o6_17-TRAINING_SUBJECT_PERSON_DATED_PROVIDER_NO_DOUBLE_CREDIT`, `o6_19-TRAINING_REAL_PERSON_EVENT_PROVIDER_DATE_REPLACEMENT`

Alternativen:

- Explizite Zuordnung durch Person/Experten; bei mehreren erlaubten Verteilungen nur Vorschläge anbieten und keine normativ ungeklärte automatische Stundenoptimierung implementieren.

**Die Experten müssen noch klären:** Bei Mehrbetriebs-Ausnahme, modularer Veranstaltung und möglicher Teilstundenaufteilung zulässige konkrete Anrechnung bestätigen. Kurswiederverwendung als Datenobjekt ist keine automatische Doppelanrechnung.

Folge für die Umsetzung: Stabile Ereignis-/Teilnahme-/Anrechnungsidentitäten; Alias-/Dublettenhinweis; belegte Anrechnung gesondert vom AMA-Feedstatus. Individuelle Kursdatensätze oder dokumentierter fachlich gleichwertiger Aggregatscope.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Derselbe dreistündige Besuch wird zweimal mit zwei importierten Namen derselben Veranstaltung erfasst. | Identitätsbezogene Deduplikation; nicht sechs Stunden allein aus zwei Bezeichnungen. | Tatsächliche Identität anhand Datum/Anbieter/Teilnahmebeleg klären; gleiche Kursnamen zu verschiedenen Terminen nicht blind deduplizieren. |
| Ein tatsächlich besuchter Kurs wird vollständig sowohl für HUM als auch für eine weitere Schulungspflicht angesetzt. | Ausdrücklich verbotene Doppelanrechnung nicht automatisch aus mehrfacher Maßnahmenetikettierung erzeugen. | Erlaubte Aufteilung modularer Inhalte nicht behauptet; Expertenentscheidung erforderlich. |
| GWA-Teilnahme 2026 belegt, Bildungsfeed steht auf 2025. | Tatsächlichen geeigneten Kursbeleg aus aktuellem Expertinnen-/Betreibersnapshot berücksichtigen; AMA-Leerstand allein kein fehlender Besuch. | Nicht aus dokumentiertem Besuch eine amtliche Sonderanerkennung ableiten. |

### R-D08-02

Eine versionierte Qualifikationsmatrix je Maßnahme/Option statt einer globalen Bildungsstunden-Zahl aufbauen. Darin Fristtyp, Mindestumfang, frühestes Kursdatum, Themen-/Anbieterbasis, Personenrolle und Ersatzklausel getrennt erfassen. UBB hat einen eigenen recherchierten Kursscope, ohne dafür eine frühere UBB-Kursfrage ID zu erfinden.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S006](https://www.ama.at/media/3sud3npb/o6_1a_ubb_2026_04.pdf) · [S007](https://www.ama.at/media/sazie2yn/o6_14_almbewirtschaftung_2026_04.pdf) · [S008](https://www.ama.at/media/cdyhus10/o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf) · [S009](https://www.ama.at/media/fa2be1dw/o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf) · [S010](https://www.ama.at/media/fkudzkum/o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf) · [S011](https://www.ama.at/fachliche-informationen/oepul/listen) · [S012](https://www.ama.at/media/x0tokvds/oepul2023_liste_anerkannter_bildungsanbieter_2025_10.pdf).

Bestehende Teilfragen: `o6_14-COURSE_PERSON_PROVIDER_DATES_DOUBLE_CREDIT_REPLACEMENT`, `o6_16-TRAINING_REAL_PERSON_IDS_DEADLINE_CONCEPT_SCOPE`, `o6_17-TRAINING_SUBJECT_PERSON_DATED_PROVIDER_NO_DOUBLE_CREDIT`, `o6_19-TRAINING_REAL_PERSON_EVENT_PROVIDER_DATE_REPLACEMENT`, `o6_1b-TRAINING_EVIDENCE`

Agenda-Restscopes: `AGENDA-REST-UBB_PERSON_COURSE_APPLICATION`, `AGENDA-REST-COMPLETE_PROVIDER_RECOGNITION_MATRIX`.

Annahmen:

- Recherchierte Klauseln sind Teilbelege für die Matrix, kein vollständiger freigegebener Vertragskatalog.

Alternativen:

- Pflichten zusätzlich direkt aus genehmigtem Maßnahme-/Optionsvertrag ableiten und Quellenmatrix nur für tatsächlich einschlägige Klauseln konsumieren.

**Die Experten müssen noch klären:** Fachliche Themenanerkennung, historische Anbieter-/Kursanerkennung und spezifische Ersatzfälle bestätigen. HUM-Themenwortlautkonflikt bleibt offen. Anbieter-Matrix muss vollständig zellweise verifiziert werden.

Folge für die Umsetzung: Feste Ende 2025- und Ende 2026-Fristen sowie 15.7 im ersten AWP-Jahr separat berechnen; Anerkennungsnachweise datieren; aktuelle Anbieterliste ist kein rückwirkender Freibrief.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| AWP erstmalig 2026 beantragt, Kurs erst 20.07.2026 besucht. | Erstjahresfrist 15.07.2026 verfehlt; nicht auf allgemeines Ende 2026 verschieben. | Keine pauschale Sanktionshöhe oder Zahlungsfolge daraus ableiten. |
| AWP erstmalig 2025; anrechenbarer Kurs bis 15.07.2025 belegt; Option 2026 fortgeführt. | Erstjahres-Kurs nicht jährlich neu verlangen; eigener jährlicher Plan-/Überprüfungsscope bleibt. | Ersatzwirkung bei späterem Personalwechsel separat klären. |
| GWA 2026 mit 10 Stunden belegt, Wiener Zusatzoption gewählt, keine zusätzlichen passenden 3 Stunden. | Wiener Zusatzpflicht bleibt eigenständig; vorhandene 10 Stunden nicht automatisch für 13 Pflichtstunden ausgeben. | Zum 09.10.2026 Frist noch offen; noch keine pauschale Verletzung. Geeignete Teilzuordnung fachlich bestätigen. |
| EBW-Vernetzungstreffen nur zukünftig gebucht, Auswertung 09.10.2026. | Teilnahme bis 31.12.2026 noch erfüllbar, aber Buchung bestätigt keine bereits tatsächliche Teilnahme. | Keine freie Stundenveranstaltung als Ersatz für eingeladenes Treffen erklären. |

### R-D08-03

Antrag, wirksamen Vertrag, jährliche förderrelevante Angaben, Fortführung, Ausstieg, Übernahme und ausdrücklich erforderliche behördliche Wiederaufnahme als datierte getrennte Vorgänge abbilden. Dabei aktuelle tatsächliche Teilnahme aus gewähltem Snapshot und belegter Historie bestimmen; möglicher 2027-Neueinstieg bleibt begründete Notiz.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S003](https://www.ama.at/media/0ajdsv1p/o6_allgemeine_teilnahmebedingungen_2026_04.pdf).

Bestehende Teilfragen: `o6_1c-CATEGORY_YEAR`, `o6_3-CONTRACT_AND_COMPANION_SCOPE`, `o6_9-CONTRACT_CURRENT_YEAR_SNAPSHOT_AND_ROOT`, `o6_20-CURRENT_ANNUAL_CONTRACT_HOST_CATEGORY_REENTRY_APPROVAL`

Annahmen:

- Datierte Zustandsableitung ist ein Implementierungsmodell, keine zusätzliche gesetzliche Genehmigungspflicht für jede jährliche Standardfortführung.

Alternativen:

- Belegtes Vertragsobjekt mit datierten Zustandsänderungen statt vollständiger Ereignisarchitektur; beide brauchen explizite Jahres- und Optionsbezüge.

**Die Experten müssen noch klären:** Je Maßnahme konkreten Antrag-/Fortführungs-/Exit-/Übernahmeweg und erforderliche Anerkennung bestätigen. Übergabe, Wiederaufnahme und bloße Eingangsbestätigung nicht gleichsetzen.

Folge für die Umsetzung: Keine positive Teilnahme aus fehlendem Bool/Wrapper oder geplantem Antrag ableiten; schriftlichen Akt per Expertinnen-/Betreiberbeleg aufnehmen, ohne Herkunft als Rechtswirkung auszugeben.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Gültige einjährige Maßnahme 2025, keine Abmeldung, tatsächlicher MFA 2026 mit relevanten Einheiten belegt. | Automatische Jahresverlängerung und tatsächliche Fortführungsangaben getrennt berücksichtigen; kein erfundener jährlich neu genehmigter Standardvertrag. | Maßnahmenspezifische Ausnahmen und tatsächliche Förderfähigkeit separat. |
| Abmeldung im laufenden 2026-Jahr belegt, alter Teilnahmebeginn weiter im Profil. | Gegenwärtige Wirksamkeit nicht allein aus altem Startjahr ableiten; allgemein beschriebene Abmeldung betrifft das laufende Förderjahr. | Tatsächlicher Erklärungs- und Ausnahmescope muss belegt sein. |
| Übernahmeantrag eingereicht, Genehmigung im tatsächlich erforderlichen Übernahmescope unbekannt. | Einreichung und AMA-beurteilte Genehmigung sind verschiedene Tatsachen; reiner Antrag belegt keine Genehmigung. | Dokumentierter Experten-/Betreiberbeleg einer realen Genehmigung zulässig; keineAMA-Feed-Herkunftssperre. |

Verbleibende Familiengrenzen: UBB-Kursrestscope hat keine eigene frühere Originalfrage ID; bestehende BIO-ID nur Teil-/Synergieverweis, kein UBB-Ersatz.; Anbieterfassung Oktober 2025 heute live verlinkt, aber vollständige Zellmatrix und Anerkennung zum tatsächlichen früheren Kursdatum noch zu verifizieren.; Mehrbetriebs-Ausnahmen, modulare Stundenanrechnung, HUM-Themenkonflikt und AWP-Personalwechsel bleiben konkret fachlich offen..

## D09

**Kombinationen, Zuschläge und tatsächliche Mehrfachanrechnung**

### R-D09-01

Kombinationsregeln als versionierte fachliche Verträge erfassen: Betriebsverbot, notwendige Begleitmaßnahme, gemeinsame Einzelflächenprämie, einzelne Options-/Komponentenwirkung und NAT-Auflagenkombination getrennt. Für die tatsächliche Prüfung Maßnahme/Option mit realer Fläche oder Teilfläche, Kulturbereich und Verpflichtungsjahr verbinden. Aktuelles Anhang L und J vollständig mit Zellkoordinaten plus sämtlichen Fußnoten aufnehmen; jede Schlussfolgerung erhält den konkreten Scope.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf) · [S016](https://www.ama.at/media/y2bpu23y/srl_oepul_2023_anhaenge_20261001.pdf).

Bestehende Teilfragen: `o6_11-ANNEX_L_MATRIX_FOOTNOTE_AND_FARM_PARCEL_SCOPE`, `o6_12-ANNEX_L_12_AND_EOP_10_REDUCTION_SCOPES`, `o6_18-ANNEX_J_FULL_MATRIX_REQUIRED_AND_EXCLUDED_COMBINATIONS`, `o6_23-ANNEX_J_WITHIN_G_UNKNOWN_T_ALIAS_AND_NAT_CODE_SCOPE`, `o6_24-ANNEX_L_REAL_PARCEL_COMBINATIONS_CODES_AND_OVERLAP`, `o6_1c-COMBINATION_VS_CREDIT`

Alternativen:

- Als erster Slice nur eine bestätigte Kombination vollständig implementieren; die übrigen Paarungen bleiben ausdrücklich unbewertet.

**Die Experten müssen noch klären:** Für jeden aufgenommenen Teilfall bestätigte aktuelle Tabelle, Fußnoten- und Optionswirkung sowie reale Überlappungsbasis freigeben. BIO-Teilbetrieb/NPA/AFS dürfen nicht per Alias gleichgesetzt werden.

Folge für die Umsetzung: Eigene Verträge und Resultatgründe je Scope; leerer/fehlender Matrixeintrag ist keine allgemeine betriebliche Sperre. Erst bestätigte Teilfälle ändern Empfehlungen.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Betrieb hat 20 + 21 als tatsächliche Tierverträge, beide fehlen in L. | L liefert hierzu keine ausreichende Antwort; eigene Tierklauseln prüfen. | Kein automatische Erlaubnis oder Verbot aus der Abwesenheit in der Tabelle. |
| Maßnahme 13 auf dokumentierter Topf-/Substratfläche, weitere Flächenmaßnahme auf derselben Fläche. | L-Fußnote 2 gesondert auswerten und betroffene Einzelflächenprämie prüfen. | Keine pauschale Sperre der übrigen Betriebsflächen. |
| Zwei bestehende NAT-Codes im selben Kapitel G, tatsächliche Projektbestätigung vorhanden. | J-Kapitelmatrix allein erlaubt keine freie Tarifaddition; konkrete Code-/Projektkombination benötigt eigenen bestätigten Vertrag. | Kapitelbezug bestätigt keine innerkapitliche Doppelzahlung. |

### R-D09-02

Gemeinsam nutzbare Fakten einmal mit realer Entität erfassen, Zahlungskomponenten aber nur nach belegter spezifischer Klausel ausschließen oder kürzen. Für Tierprämien tatsächliche tierbezogene Anträge verbinden; bei Kulturzuschlägen reale Schlag-/Saisonidentität und bei Kompost tatsächliche Tierarten-/Mengenbasis. Eine fachliche Anrechnung oder derselbe Nachweis erzeugt weder einen zweiten Zahlungsanspruch noch automatisch ein generelles Zahlungsverbot.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S020](https://www.ama.at/media/wymfylme/o6_20_tierwohl_weide_2025_10.pdf) · [S006](https://www.ama.at/media/3sud3npb/o6_1a_ubb_2026_04.pdf) · [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf).

Bestehende Teilfragen: `o6_20-RATES_BANDS_COUPLED_SUPPORT_AND_O6_21_SOURCE_CONFLICT`, `o6_21-ACTUAL_PER_TIER_REDUCED_RATE_OVERLAP_AND_SOURCE21`, `o6_16-ANNUAL_ALL_PIG_RATIONS_PHASE_COVERAGE_AND_O6_9_EXCLUSION`, `o6_22-ALL_SPECIES_REAL_COMPOST_NAPV_PROOFS_AND_DUPLICATE21`, `o6_1a-DIV_CREDIT`, `cross_measure-PREMIUM_PRIORITY`

Alternativen:

- Konservative Anzeige offener gemeinsamer Zuschläge ohne bezifferte Addition, bis ihre konkrete Doppelzahlungsklausel geklärt ist.

**Die Experten müssen noch klären:** Tier-/Antragjoin, Umfang einer Komponentenkürzung und 21/22-Kompostzuschlagsüberlappung pro echter Fallkonstellation bestätigen. Bei UBB bleibt der allgemeine finanzielle Vertrag ein kenntlicher Restscope, ohne erfundenen früheren Zahlungsfragen-ID.

Folge für die Umsetzung: Komponenten führen eigene scope_ids, beantragte Option und konkrete Ausschlussgrundlage. Vergleichbare Felder/Kurse/Habitate nicht über Namen oder Herkunft deduplizieren.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Dieselben Almtiere in 20, tatsächlicher gekoppelter Antrag nur für Tier A; Tier B auf Gemeinschaftsweide ohne diesen Antrag. | Halbierung der 20-Basis nach passender tatsächlicher Antragstellung; kein Halbieren allein wegen Alm-/Weideflag. | 150-Tage-Zuschlag und tatsächliche Bandrate eigenständig prüfen. |
| Ein UBB-Schlag mit förderwürdiger Haupt- und Zweitkultur. | Für diesen Zuschlag höherer Satz; für die dortige Quote Fläche einmal. | Nicht auf alle anderen Quoten, Zuschläge oder Maßnahmen verallgemeinern. |
| Dokumentierte Kompostfakten für alle Arten, tatsächliche Teilnahme an 21 und 22. | Gemeinsame Erfassung möglich; konkrete Doppelzuschlagswirkung bleibt fachlich offen. | Gemeinsamer Beleg allein erlaubt keine Addition und rechtfertigt kein generelles Verbot. |

### R-D09-03

Aktuelle Kombination gegen tatsächliche Vertrags- und Optionsereignisse im ausgewählten Snapshot auswerten. Einen möglichen Wechsel oder eine Korrektur als begründete Handlung mit Wirksamkeitsdatum darstellen. Der Auto-Snapshot darf alternative dokumentierte Fakten liefern, aber keine amtliche Abmeldung oder Genehmigung erzeugen. Korrekturmöglichkeit benötigt tatsächlichen Stand von Mitteilung und Kontrollbeanstandung.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S003](https://www.ama.at/media/0ajdsv1p/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) · [S040](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/informationen-zu-oepul-mitteilungen).

Bestehende Teilfragen: `o6_19-ACTUAL_COMBINATION_SCOPE_UNKNOWN_VIOLATION_PAYMENT`, `o6_3-CONTRACT_AND_COMPANION_SCOPE`, `o6_7-PROFILE_ROOT_PARTICIPATION_AND_CONFLICT`, `o6_15-CURRENT_CONTRACT_ALM14_COMBINATION_REENTRY_AND_EXIT`, `o6_12-BIO_PART_FARM_SWITCH_APPLICATION_VERSUS_EFFECTIVE_DATE`

Alternativen:

- Bei nicht dokumentiertem Kontroll-/Mitteilungsstand nur den möglichen Korrekturweg erläutern; keine Behauptung eines noch offenen amtlichen Fensters.

**Die Experten müssen noch klären:** Teilfallbezogene Vertrags-/Begleitmaßnahmenwirkung und erforderliche Ereignisbelege bestätigen; Quelle Experten-/Betreiberwissen darf dokumentierte amtliche Vorgänge erfassen.

Folge für die Umsetzung: Boolean Teilnahme nicht als Antrag/aktiven Vertrag/Abmeldung gleichsetzen; aktuelle Bewertung und datierte Zukunftsnotiz getrennt.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Dokumentierter wirksamer Wechsel erst 01.01.2027; Auswertung 2026. | 2026-Verträge bewerten; Wechsel nur begründete Zukunftsnotiz. | Keine heutige Kombination durch geplanten Wechsel fingieren. |
| Unmögliche Kombination, Mitteilung noch nicht erhalten, Kontrollbeanstandung dokumentiert. | Allgemeine Korrekturklausel nicht allein über fehlenden Mitteilungseingang freigeben. | Konkrete Bearbeitungsmöglichkeit von AMA/Experten klären. |
| Eigener Auto-Snapshot mit dokumentierten passenden Agrarfakten; amtliche Vertragsgenehmigung fehlt. | Agrarfakten dürfen AMA-Werte verdrängen; Genehmigung/realer Vertragsakt bleibt nicht dadurch belegt. | Kein Herkunftsgate; tatsächlicher rechtlicher Nachweis bleibt eigener Inhalt. |

Verbleibende Familiengrenzen: Keine gesamte aktuelle Kombinations-/Options-/Projektmatrix freigegeben; historischer Zellenaudit ist keine aktuelle Aufnahme.; Reale Entitäts-/Periodenjoins, optionale 21/22-Kompostwirkung, BIO-Teilbetriebs- und Projekt-Ausnahmen brauchen gezielte Teilantworten..

## D10

**Prämien, Kappung, Modulation, Sanktion und Zahlung**

### R-D10-01

Eine nachvollziehbare Rechenkette mit Jahres-/Artikelzuordnung, tatsächlich bestätigter Menge, Tarifversion und getrennten Berechnungspositionen führen. Bereits belegte Operatorreihenfolge übernehmen: maßnahmenspezifische Kappe vor Modulation, gemeinsame Art.-70/72-Flächenkappe danach. Weitere amtliche Kürzungen bleiben eigene Stufen. Mit Dezimalwerten rechnen und intern Präzision erhalten; normative Geldrundung und Verteilung einer gemeinsamen Kappung erst nach konkreter Fachantwort festlegen.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf) · [S003](https://www.ama.at/media/0ajdsv1p/o6_allgemeine_teilnahmebedingungen_2026_04.pdf) · [S001](https://www.bmluk.gv.at/themen/landwirtschaft/gemeinsame-agrarpolitik-foerderungen/nationaler-strategieplan/foerderinfo/sonderrichtlinien-2023-2027/agrarumweltprogramm-oepul-ab-2023-inklusive-oekoregelungen.htm).

Bestehende Teilfragen: `cross_measure-PREMIUM_PRIORITY`, `o6_23-ACTUAL_RATE_COMPONENT_CAP_ORDER_OTHER_PAYMENTS_AND_SANCTION`, `o6_24-ACTUAL_MODULATION_CAP_ORDER_OTHER_PAYMENTS_SANCTION_AND_UNKNOWN`, `o6_6-PAYMENT_BAND_UNKNOWN_GATES_AND_AUTHORITY`, `o6_7-PAYMENT_BASE_APPROVED_RATE_AND_OPEN_STATUS`, `o6_18-YEAR_RATES_2023_MISSING_GG_K20_NEW_CODES_AND_DUPLICATE_CHARGES`

Alternativen:

- Bis zur Klärung Bruttokomponenten beziehungsweise bestätigtes Mindestband als gekennzeichnete Schätzung zeigen; keine behauptete Nettosumme bei offenen Stufen.

**Die Experten müssen noch klären:** Rundungsstelle/-modus, gemeinsame Kappenverteilung und vollständige aktuelle Tarifquellen für den zuerst aufgenommenen Scope bestätigen; weder 2027-Optionen noch alte Artikelzuordnung nach 2026 übertragen.

Folge für die Umsetzung: Rate/Einheit/Jahr/Quelle je Position, Reihenfolge und Restunsicherheit sichtbar. Vollständigen heutigen Tarifsabgleich gezielt aus SRL/Anhang/Projekt/Landesraten vorbereiten; offizielle BMLUK-XLSX ist ein zusätzlicher noch ungeprüfter Ansatzpunkt.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Rein synthetisch: gewöhnlicher 1-ha-Schlag, 300 ha Heimfläche, zuvor bestätigte 1600 Euro Art.-70/72-Summe, keine weiteren Kürzungen. | Modulationsfaktor 29/30; danach gemeinsame 1300-Euro-Kappe. Umgekehrte Reihenfolge liefert etwa 1256,67 Euro und ist für diesen Operatorvergleich falsch. | Technischer Gegenfall zur Reihenfolge; keine reale zulässige Kombination, keine amtliche Auszahlung, keine Geldrundungsnorm. |
| Maßnahme 10, Tarifjahr 2026. | Artikelzuordnung ab 2025 prüfen; keine Anwendung des bis 2024 gültigen Art.-31-Bandstatus. | Vollständige konkrete Rate und Zugangsvoraussetzungen bleiben separat. |
| Art.-31-Position mit bestätigter Fördermenge, heutiger endgültiger Programmbandrate nicht dokumentiert. | Keine durch Experten-/Auto-Faktsetzung erfundene endgültige nationale Bandrate. | Zulässige Rate oder als Schätzung gekennzeichnete Banddarstellung fachlich bestimmen. |

### R-D10-02

Pflichtbefund und amtlich vergebene Sanktion als getrennte datierte Objekte mit Maßnahmen-/Options-, Pflicht- und Periodenbezug führen. §48 liefert Wiederholungs-/Kumulationslogik; der Basisprozentsatz bleibt bei fehlendem amtlichen Schema unentschieden. Frühere tatsächliche Verstöße und tatsächliche 100-Prozent-Entscheidungen anhand ihrer Belege auswerten, keine Bool-Proxys. Die unterste Stufe ist 2026 eine Verwarnung; 1-Prozent-Einbehalt erst als 2027-Hinweis. Fehlende alte PSM-Codierung allein ist 2026 kein solcher Verstoß; tatsächliche PSM-Nutzung bleibt anhand der jeweiligen Verbotsklausel prüfbar.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S039](https://ris.bka.gv.at/eli/bgbl/ii/2022/403/P48/NOR40247905) · [S019](https://www.ama.at/media/tp2fbtou/srl_oepul_2023_20261001.pdf).

Bestehende Teilfragen: `o6_10-UNKNOWN_VIOLATIONS_THEORETICAL_AMOUNT_AND_PAYMENT`, `o6_11-THEORETICAL_PREMIUM_UNKNOWN_VIOLATIONS_AND_SANCTIONS`, `o6_12-UNKNOWN_APPROVAL_FORCE_MAJEURE_AMOUNT_CAP_AND_SANCTIONS`, `o6_15-UNKNOWN_VIOLATIONS_AMOUNT_CONTROL_FORCE_MAJEURE_SCOPES`, `o6_21-UNKNOWN_PERSON_MISSING_PROOFS_VIOLATIONS_AND_PAYMENT`, `o6_22-UNKNOWN_THEORETICAL_VERSUS_CONFIRMED_PAYMENT_PERSON_SANCTION`

Alternativen:

- Nur belegte amtliche Kürzungsentscheidungen in einer Nettoansicht anwenden; bei unklassifiziertem Befund Rechtsfolge als offen anzeigen statt eine eigene Sanktionstabelle zu erfinden.

**Die Experten müssen noch klären:** Versioniertes amtliches Sanktionsschema beziehungsweise geprüfte konkrete Basisstufen und tatsächliche Bescheid-/Mitteilungsfälle bereitstellen. Umgang mit Aufhebung/Korrektur einer Entscheidung und spezifischen Anerkennungswegen einzeln bestätigen.

Folge für die Umsetzung: Same-obligation und distinct-obligation korrekt trennen; Kontroll-/Feststellungsjahr und tatsächliche vergebene Stufe speichern. Kein 100-Prozent-Ausschluss aus zwei Eingabeflags oder offenen Pflichtangaben.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Zwei eingetragene Verstoßflags, kein tatsächlich vergebener 100-Prozent-Kürzungsbeleg. | Keine Behauptung des §48-Zwei-mal-100-Prozent-Ausschlusses. | Das schließt eine spätere tatsächliche Behördenentscheidung nicht aus. |
| Dritter tatsächlicher Verstoß derselben Pflicht derselben Maßnahme in der Förderperiode, fachlich/amtlich bestätigte Basisstufe 5 Prozent. | Reiner Stufenmechanismus hebt um zwei Stufen auf 25 Prozent; bei verschiedener Pflicht entfällt diese Wiederholungshebung. | Die Eingabe der Basisstufe ist bewusst explizit; keine eigene Klassifikation unbekannter Verstöße und keine bereits erfolgte Auszahlung behauptet. |
| Auswertung 2026, PSM-Code fehlt; dokumentierter tatsächlich verbotener PSM-Einsatz liegt zusätzlich vor. | Fehlende Codierung erzeugt keinen 2026-Pflichtverstoß; tatsächlich verbotenen Einsatz eigenständig nach Maßnahmenklausel bewerten. 2027-Regel nur Notiz. | Tatsächliche Rechtsfolge/Sanktionshöhe und mögliche Behördenausnahme benötigen eigenen Beleg. |

### R-D10-03

Bruttoschätzung, fachlich geprüfte Berechnung, amtliche Festsetzung und tatsächliche Buchung getrennt anzeigen. Berechnungsvorschläge bleiben nachvollziehbare Kandidaten, wenn Modulationsbasis oder gedruckte Beispiele widersprüchlich sind. Für den Mehralmfall zwei ausdrücklich konkurrierende Mengenformeln mit unabhängig dokumentiertem AMA-Abrechnungsfall vergleichen; gedruckte Fehler nicht stillschweigend korrigieren. Heuwirtschaft bleibt indikativer Bruttoslice mit den acht bestehenden offenen Blockern, bis der konkrete allgemeine Zahlungsvertrag geklärt ist.

Einordnung: `design_proposal` – Quellenbefund, vorgeschlagene Umsetzung und offene Auslegung sind zu unterscheiden. Belege: [S040](https://www.ama.at/fachliche-informationen/oepul/aktuelles/2026/informationen-zu-oepul-mitteilungen) · [S007](https://www.ama.at/media/sazie2yn/o6_14_almbewirtschaftung_2026_04.pdf) · [S038](https://www.ama.at/media/2qbfxi0x/o6_15_tierwohl-behirtung_2026_04.pdf) · [S003](https://www.ama.at/media/0ajdsv1p/o6_allgemeine_teilnahmebedingungen_2026_04.pdf).

Bestehende Teilfragen: `o6_14-PREMIUM_PER_ALM_VERSUS_GLOBAL_MODULATION_AND_OTHER_MEASURES`, `o6_15-MODULATION_SHARED_ALM14_BASIS_AND_OTHER_FUNDING`, `o6_15-ORIGINAL_PREMIUM_EXAMPLE_CONFLICT_ROUNDING_AND_TOPUP`, `o6_3-GENERAL_PAYMENT_AND_SOURCE_GATES`, `o6_9-THEORETICAL_AMOUNT_VERSUS_CONFIRMED_RECOMMENDATION`

Alternativen:

- Bei ungelöster Mehralmbasis nur lokale bestätigte Bruttokomponenten und die zwei Rechenvarianten zeigen; keinen scheinbar endgültigen Nettobetrag.

**Die Experten müssen noch klären:** Minimum der betrieblichen Summen versus Summe der örtlichen Minima für gemeinsame Alm/Behirtung-Modulation und monetäre Rundungsregeln bestätigen; gedruckte 135-Euro-/Prozentkonflikte mit realer unabhängiger Abrechnung auflösen. Ein datierter dokumentierter Expert-/Betreiberbeleg kann den amtlichen Fall erfassen.

Folge für die Umsetzung: Eigenes Ergebnislevel, Antragsjahr, Bewertungs-/Mitteilungs-/Buchungsdatum und Herkunft. Auto-Snapshot darf Fakten schätzen, ersetzt keinen amtlichen Zahlungsakt. Unbelegte Sanktion niemals als Zahlung oder als Nullentscheidung ausgeben.

Vorgeschlagene unabhängige Prüffälle:

| Eingabe | Fachliche Sollbegründung | Verbleibende Grenze |
| --- | --- | --- |
| Zwei hypothetische gültige Almen: A 200 ha/50 RGVE, B 100 ha/200 RGVE; übrige Zugangsvoraussetzungen ausdrücklich separat zu prüfen. | Vergleichskandidaten: min(300 ha,250 RGVE)=250 → Faktor 0,98; min(200,50)+min(100,200)=150 → Faktor 1. Keine Variante wird durch diese Recherche normativ ausgewählt. | Bewusst trennscharfer synthetischer Fachentscheidungsfall; kein Golden-Sollwert und keine echte ausgezahlte Prämie. |
| Gedrucktes Behirtungsbeispiel: zweite Alm mit 20×81 +30×27, ausgewiesene Zeile 2295 Euro. | Arithmetik 2430 Euro; Abweichung 135 Euro als Quellenkonflikt erhalten. | Arithmetik ist kein korrigierter amtlicher Sollwert und entscheidet nicht die reale Hirten-/Mengenbasis. |
| Dokumentierte Berechnungsmitteilung für Antragsjahr 2025 und Kontobuchung im Jahr 2026; aktuelle Empfehlung auf 2026-Snapshot. | Zahlungs-/Buchungsjahr getrennt vom Antragsjahr; alte Mitteilung nicht als heutige Erfüllung übertragen. | Reale Eingabefakten vor AMA bleiben erlaubt, ihre Provenienz erzeugt jedoch keine zusätzliche amtliche Festsetzung. |

Verbleibende Familiengrenzen: Komplettes amtliches aktuelles Sanktionsschema wurde durch gezielteAMA/BMLUK/RIS-Suche nicht gefunden; dessen Existenz ist in SRL erwähnt, Inhalte sind damit nicht bewiesen.; Vollständige aktuelle Tarif-/Kombinationsaufnahme, Geldrundung, Kappenverteilung, ungleich verteilte Mehralm-Modulation und gedruckte Konflikte bleiben offen.; Keine echten Betriebsabrechnungen, Festsetzungs-/Buchungsbelege oder unabhängig bewerteten Goldenfälle vorhanden..
