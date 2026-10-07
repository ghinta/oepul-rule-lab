# Heuwirtschaft: Quellenreview und Variablenvertrag

Stand: 07.10.2026, Schritt 1 von [App-Issue #136](https://github.com/ghinta/oepul-recommender/issues/136),
fachliche Klammer [Lab-Issue #97](https://github.com/ghinta/oepul-rule-lab/issues/97).
Lab-Basis: `0760684b5029d65feeca984bf627a3c6269a9955` (PR #99).
App-Basis: `14e5422b9977f78eb2f7edfb99313e4aac39f9a7` (PR #135).

## Ergebnis und Entscheidung

Die gebundene Adaptation hat 46 typisierte Eingabepfade, 17 dokumentierte
Regel-/Berechnungsgruppen und alle 20 RGVE-Kategorien. Quellen, Typen,
Regelkonsum und bestehende App-Registries sind pfadweise verbunden.
Der Vertragsentwurf ist eine Implementierungsgrundlage, keine App-Promotion.
Die regelbezogenen offenen Punkte bleiben in `source-review.json` sichtbar.

Vier registrierte Eingaben können wiederverwendet werden: Schlagfläche,
Nutzungsart, Tierzahl und Mahddaten. Davon konsumiert die heutige o6_3-Policy
nur Mahddaten. Zusätzlich konsumiert sie Bewirtschaftungsereignisse; diese
sind kein fertiger Ersatz für die neuen vollflächigen Bewirtschaftungsnachweise.
Der App-PR #135 löst Zeit-/Snapshot-/Szenariotrennung, nicht diese Datenlücken.

Der native Lab-Kandidat liest `input.farm/land/livestock/exceptions/context`.
Die aktuelle App-Policy liest dagegen `input.payload` und erhält den
vertrauenswürdigen Kontext separat als `input.evaluation_context`. Der neue
Maßnahmenadapter muss diese Formen ausdrücklich übersetzen: ausschließlich
`current_year`, `snapshot_year`, `as_of` in den strikten Lab-`context` kopieren,
die benötigten geprüften effektiven Betriebsfelder an die nativen Zielpfade
binden und Snapshot-ID/Digest sowie Quellen im App-Provenienzvertrag behalten.
Den alten Category-C-Präsenzcheck nicht als neue Förderentscheidung weiterführen.
Das Mapping ist hier definiert, noch nicht implementiert.

`purpose`/`app.evidence_purpose` in der Variablenmatrix unterscheiden Host-/
Identitätswerte und `current_fact`; sie führen keinen neuen DB-Purpose ein.
Historische Erstjahresbelege werden als aktuelle, snapshotgebundene Deklaration
erfasst und tragen `evidence_time_role: historical_first_year` sowie ihr echtes
Nachweisjahr. Vertragsbeginn darf nicht aus dem frühesten Beginn irgendeiner
anderen Maßnahme abgeleitet werden.

**Die maßgebliche neue Strukturfrage ist die Tiergruppenidentität:** Die App
fasst heute Tiere nach Art zusammen und verwendet die Art als Gruppen-ID.
Die 20 RGVE-Kategorien brauchen getrennte Alters-/Rassen-/Größenkohorten.
Eine Artgruppe mit einer Kategorie zu überschreiben würde belegte Information
verlieren. Der nächste Backend-PR muss stabile Kohorten und die Weiterführung
der vorhandenen IDs/Provenienz planen. Vorhandenes `gve` ist kein RGVE-Nachweis.

## Quellenprüfung

Das Heuwirtschaft-Merkblatt (6 Seiten) und die allgemeinen Bedingungen
(21 Seiten) wurden einschließlich Tabellen, Ausnahmen und Aktualisierungen
gelesen. Im SRL-Dokument wurden der relevante allgemeine Teil, die
Heuwirtschaft-Regel auf PDF-Seite 50 und der RGVE-Schlüssel samt Fußnoten
in Anhang A/PDF-Seite 3 abgeglichen. Die Dürre-Mitteilungen vom 05.08. und
12.08.2026 wurden im jeweiligen Anwendungsscope geprüft. Das ist keine
Vollständigkeitsprüfung aller Maßnahmen oder aller 103 Anhangseiten.

46 Belegstellen mit PDF-Seite/Abschnitt/wörtlichem Zitat stehen in
`citations.json`. Die 20 Koeffizienten werden zusätzlich gegen die vollständigen
Quellentabellen-Blöcke geprüft. Die Sätze 135/155 EUR für 2023 und 145,8/167,4
EUR ab 2024 sowie die 0-EUR-Stufe bleiben normative Daten, keine Betriebsfelder.
SRL und Anhänge sind rechtlich maßgeblich; Merkblätter sind erläuternd und
rechtlich unverbindlich. Ein Hash beweist die Dokumentidentität, nicht die
Abwesenheit späterer Rechtsänderungen. Quellenaktualität bleibt ein Gate.

| Regelgruppe | Quellen und Review-Ergebnis |
| --- | --- |
| CURRENT_BASIS | Technischer Hostvertrag aus App #135; kein Fördergesetz. |
| CONTRACT / COMBINATION | Merkblatt 3.1/3.2/6: Beginn 2023–2025, Ende 2028; zeitgleiche UBB/BIO/BIO-Teilbetrieb-Kombination. Gültigkeit ist durch Vertrags-/Antragsunterlagen zu belegen. |
| FIRST_YEAR_AREA / FIRST_YEAR_RGVE | Merkblatt 3.3/3.4/4: 2 ha und 0,30 RGVE/ha im Erstjahr. Folgejahre brauchen datierte Erstjahresbelege, nicht heutige RGVE als Ersatz. |
| CURRENT_RGVE | Merkblatt 8 und Anhang A: alle Kategorien, kleine Equiden mit 0,50 statt 1,00; Zwerg-Rassen und Wildhaltungs-Fußnote beachten. Taggenauer Rinderdatenbank-Durchschnitt, sonst Stichtags-/eingereichte Durchschnittstierliste. |
| FORAGE_AREA | Gesamte beantragte Grünland-/Ackerfutterfläche, einschließlich Ackerweide; Zweitkultur ausschließen. Prämienausschluss allein verkleinert den Nenner nicht. |
| PREMIUM_AREA / PREMIUM_RATE | Gemähte Mähwiesen/Mähweiden und geeignete Ackerfutterflächen. Ackerweide ist Nennerfläche, keine Prämienfläche. Allgemeine Flächenausschlüsse/Kombinationen/Zugang und Abrechnung fehlen im Slice. |
| SILAGE / FERMENTATION / STORAGE | Merkblatt 5.1/5.3: gesamter Betrieb, alle Tierarten, Gebäude und Altvorräte; Nebenprodukte/Heulage nicht pauschal als zulässig behandeln. |
| GREEN_FEEDING | Merkblatt 5.2: überwiegender Teil 01.04.–30.09. für alle Raufutterverzehrer; Gemeinschaftsweide/Alm anrechenbar. Keine quellenbestätigte 92-Tage- oder Additionsmethode. |
| HAY_TRANSFER | Merkblatt 5.4: nur trockenes Heu an Dritte. Auch kein Grünfutter zwischen zwei Heuwirtschaftsbetrieben. Vollständige bestätigte Nichtabgabe kann die Bedingung erfüllen; fehlende Daten nicht. |
| MOWER_CONDITIONER | Merkblatt 5.5: bei gültiger Jahresoption weder Einsatz auf irgendeiner Betriebsfläche noch entsprechendes Gerät am Betrieb. |
| MINIMUM_MANAGEMENT | SRL 1.6.3.3: vollflächige Mahd UND Abfuhr oder Beweidung. Einzelnes Schnittdatum reicht nicht. Bergmähder und spezielle Ausnahmen brauchen gesonderten Vertrag. |
| RECOGNITION | SRL 1.7.4.1 verweist auf § 6 GSP-AV: betroffene Pflicht, Fläche, Zeit und Rechtsfolge sind fachlich zu prüfen; kein globaler Dürre-/Anerkennungs-Wahrheitswert. |

## Vor voller Empfehlung offene Punkte

1. **GROUP_IDENTITY:** stabile RGVE-Kohorten statt einer einzigen Artgruppe.
2. **COUNT_BASIS:** Zahl plus Bezugsjahr, Stichtag/Zeitraum, Quelle und tatsächlicher
   Durchschnittstierlistenstatus. Ein optionaler Durchschnittswert allein genügt nicht.
3. **GREEN_FEEDING_HISTORY:** heutiger Nullbestand beweist keinen Nullbestand
   in der vergangenen Vegetationsperiode. Saisonhistorie und Ermittlungsmethode fehlen.
4. **RECOGNITION_TIME:** Kandidat verlangt derzeit, dass `as_of` innerhalb des
   Anerkennungszeitraums liegt. Ein früherer betroffener Vorfall kann dadurch nicht
   zur Rechtsfolgenprüfung gelangen. Vorfalls-/Pflichtzeitraum gesondert modellieren.
5. **GENERAL_FUNDING:** Antragsteller-/Flächenfähigkeit, OP-Codes, Kombinationen,
   Flächenzugang, Bergmähder, Modulation/Obergrenzen/Sanktionen fehlen ganz oder
   teilweise. Integrationsvertrag oder ausdrücklicher Blocker vor Gesamtfreigabe.
6. **ANNUAL_EVIDENCE:** Beobachtungsstand ist keine abgeschlossene Jahrespflicht
   oder finale Jahresdurchschnittszahl. Offene Pflichten/Zeiträume anzeigen; Zukunft
   nur als getrennte begründete Notiz behandeln.
7. **SOURCE_CURRENTNESS:** Anwendbarkeit des gebundenen Dokumentstands vor
   Promotion überprüfen; keine automatische Aktualitätsbehauptung aus Jahreszahl.
8. **OPUS_REVISION:** angekündigte Vervollständigung am 08.10.2026 steht aus.
   Der gebundene September-Run ist nur eine Referenz. Neue Revisionen später
   mit Hash binden und relevante Deltas prüfen.

Die ersten sechs Punkte erfordern konkrete Daten-/Adapter-/Fachentscheidungen,
nicht weitere frei erfundene Defaults. Geplante zusätzliche Nachweismetadaten
stehen in `variables.json` unter `proposed_evidence_extensions`. Sie werden vom
aktuellen strikten Lab-Schema noch nicht akzeptiert. Dieser PR verändert weder
Kandidatenregeln noch App-Speicher oder Canonical Farm Profile.

## Entwicklungsfälle und methodische Grenze

Die sieben bekannten Quellenfälle sind mit dem Adaptationsvertrag erneut
ausgeführt: Merkblatt-Beispiel, Folgejahr ohne Tiere, Neuweltkamel-Grenzwert,
kleiner adulter Equide, Vertragsende, unbekannte Silagelagerung und Ackerfutter
ohne Mindestbewirtschaftung. Die ausdrücklich simulierte Prüfung 2030 und der
Jahresendfall sind Entwicklungsinputs, keine aktuell freigegebenen Empfehlungen.

Drei weitere Beobachtungen reproduzieren verbleibende Risiken:

| Beobachtung am gebundenen Kandidaten | Konsequenz für die Integration |
| --- | --- |
| Aktuell keine Tiere + Grünfütterung unbekannt ergibt Slice-`eligible`/0 EUR. | Saisonhistorie nicht bewiesen; nicht als bestätigte Jahreserfüllung ausgeben. |
| Durchschnittszahl ohne Listen-/Periodenbeleg wird bevorzugt und ergibt Slice-`eligible`. | Der Adapter muss Zahl und maßgeblichen Nachweis zusammen validieren. |
| Anerkennung Mai–Juni bei Prüfung im Oktober erreicht keine Ausnahme-Rechtsfolgenprüfung. | Belegter Vorfall und Anerkennung dürfen nicht allein am heutigen Datum verloren gehen. |

`development-probes.json` enthält zehn synthetische Inputs und die beobachteten
Outputs. Die problematischen Outputs werden **nicht** als normative Sollwerte
freigegeben. Die Tests reproduzieren die Review-Aussagen; sie behaupten keine
Korrektheit der offenen Rechtsfolgen. Historische Runs bleiben unverändert.
Keine Golden-/Held-out-Tests, Modellrangliste oder unabhängige Qualitätsquote.

## Weiterarbeit nach Merge dieses PRs

App-Schritt 2 aus #136 nutzt die Matrix als Vertragsentwurf, behebt die genannten
Struktur-/Datenflusslücken und bindet nur belegte Klauseln an. Offene fachliche
oder allgemeine Förderfragen liefern gesonderte Blocker. Schritt 3 verbindet
Oberfläche, DecisionTrace und persistierte Runs. #97/#136 bleiben offen.

Dateien: `baseline.json` (Artefakt-/Quellenbindung), `app-inventory.json`
(versionierte App-Referenz), `source-review.json` (Regeln, Tabellen, Blocker),
`variables.json`/`variables.md` (vollständiger Vertrag), `citations.json`,
`development-probes.json`, `verification.md` und kurze `reasons.md`.
