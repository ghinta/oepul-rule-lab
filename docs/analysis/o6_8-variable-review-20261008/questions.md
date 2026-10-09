# o6_8: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_8-CONFIRMED_CONTRACT_HOST_YEAR_AND_INPUT_ROOT

Welche bestätigte Vertrags-/Antrags-/Zahlungsantrags-/Ausstiegshistorie samt aktuellem Host-Jahr/Snapshot und eindeutigem Codepfad wird aufgenommen? 2023/24/25-Beginn bis Ende 2028, letzter Einstieg 2025; keine heutigen Daten als zukünftiges Jahr prüfen. Luna application_codes-Objekte vs. konsumierte Strings, Opus oepul_o6_8-Codes explizit adaptieren, keine Aliasannahme.

**Anlass:** Luna braucht keinen eigenen o6_8-Vertrag. Opus fehlender Antrag/Bewerber oder explizit fehlender Zahlungsantrag/alter Ausstieg sperrt den berechneten Betrag nicht; Ausstiegs-/Antragshelper bleiben unverbunden.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 1: „läuft bis 31. Dezember 2028.“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 5: „Der letzte Einstieg in die Maßnahme ist mit dem Förderjahr 2025 möglich“.

## o6_8-MFA_CROPS_PROCEDURE_FLAGS_AND_SOURCE_VERSION

Welche offiziellen MFA-Kulturnamen werden je Verfahren/Jahr verwendet? Nur-MS-Kartoffeln, neue US-Kulturen ab 2025 und Kleegras nur Altbestand als getrennte Eigenschaften behandeln; Schreibweisen Ackerbohnen/Erbsengemenge vs. Ackerbohnen-Erbsengemenge und Sonnenblume/Sonnenblumen bestätigen. SRL-Sudangrasabweichung und App-Merkblatt Oktober 2025 gegenüber Run-April 2026 entscheiden.

**Anlass:** Luna akzeptiert echte Frühkartoffeln bei MS nicht, DS mit künstlichem Namen Frühkartoffeln (nur MS) dagegen schon. US ab-2025-Suffix/BAW-Altbestandhinweis bleiben Laufzeitstrings ohne eigene Jahres-/Verfahrensprüfung.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 9: „Kartoffeln können im Anbauverfahren nur mittels Mulchsaat (MS) angebaut werden.“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 11: „Kleegras (für Neueinsaaten nicht möglich)“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 11: „Kapitel 3.2: Ergänzung von Sudangras“.

## o6_8-PRECEDING_CATCH_CROP_AND_SWITCH_HISTORY

Welche tatsächliche vorangehende Begrünung mit Jahr, Schlag, Variante, Pflichtenerfüllung und Vertragswechsel belegt MS/DS-Zugang? ÖPUL-2015 nur 2023, NPF2024-Begrünung für MFA2025, überjährige Immergrün-Zwischenfrucht und Wechseljahr trennen. Ein bloßer scheme/variant/overwintering-Flag ist keine anrechenbare historische Begrünung.

**Anlass:** Luna berücksichtigt vorgeschlagene Vorfrucht-/Überwinterungsdaten nicht. Opus prüft Tabellen-/Vertragsflags, jedoch keine tatsächlichen Zeitpunkte oder erfüllte Vorbegrünung; Wechsel aus Immergrün braucht datierte Wirksamkeit.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 2: „Varianten 2, 4, 5 und 6“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 7: „Vertrag für die“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 7: „mit Jahresende“.

## o6_8-ACTUAL_TILLAGE_DATES_AND_METHODS

Welche datierten echten Bodenbearbeitungs-/Saatereignisse samt Mulch-/Streifen-/Schlitz-/Tiefenlockerungsbelegen bilden MS/DS/Strip-Till ab? Maximal vier Wochen ab erster Bearbeitung, keine negativen/fehlenden Zeitintervalle. Fehlende Methode/Schlitzdrill/Deckungsreste nicht als bestätigtes Verfahren defaulten; Geräteverfügbarkeit belegt keine Anwendung.

**Anlass:** Luna konsumiert die vorgeschlagenen Verfahrensmerkmale kaum. Opus Defaults plant_mulch_on_surface/slot_seeding=true und fehlende Termine überspringen Prüfungen; negative Saat-vor-Bearbeitung-Differenz wird nicht beanstandet. App Gerät/Bodenbedeckung genügt.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 3: „maximal 4“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 3: „Schlitzverfahren“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 2: „Eine wendende und tief mischende Bodenbearbeitung ist nicht zulässig.“.

## o6_8-POTATO_RIDGES_DATED_MAINTENANCE_AND_EXCEPTION

Welche tatsächlichen Anhäufungsabstände, Leger-/Fräserdaten, Krautminderung und Erhalt-/Erneuerungsbelege gelten? Saatkartoffel-Ausnahme jede vierte Reihe benötigt dokumentierte Erforderlichkeit; Fahrgassen gesondert. Was bedeutet zeitnah ohne erfundene Zahl?

**Anlass:** Luna AH mit fehlenden bzw. explizit fehlerhaften Abstand-/Erhaltsdaten bleibt compliant. Opus einzelne falsche AH-Bools prüfbar, fehlende Merkmale lösen jedoch keine offene Datenlage aus.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 3: „maximal 2 m“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 3: „in jeder 4.“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 3: „zeitnah nach dem Legen“.

## o6_8-BAW_GIS_QUARTER_VERSUS_CAP_AND_KG

Welche aktuelle GIS-Layer-/Geometrie-/KG-Version und genaue bestätigte BAW-Teilfläche werden verwendet? Führt weniger als 25% des Schlages zur Ablehnung oder nur zu höchstens vierfacher Pfad-Prämienfläche? SRL teilweise vs. MB Viertel verbindlich entscheiden; GIS-Anteil und ha dürfen sich nicht widersprechen. Anhang-F-KG ist notwendig, aber allein kein Nachweis des konkreten Eintragspfades.

**Anlass:** Beide Modelle wählen MB-Sperre ohne Fachfreigabe. Luna baw_eligible ist nicht Teil compliant. Opus fehlende KG/Pfadfläche/Anteil kann gesamte Fläche prämienfähig werden; gelieferter Anteil kann widersprüchliche Pfad-ha übersteuern. 1952 KG-Zeilen sind in beiden Runs vollständig belegt.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 59: „zumindest teilweise“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 3: „zu einem Viertel“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 7: „maximal eine Fläche von“.

## o6_8-BAW_PART_AREAS_MINIMUM_DIV_AND_EXCLUSIONS

Welche Teilflächen zählen zur 0,10-ha-Mindestteilnahme, zur BAW-Prämie und UBB/BIO-DIV-Anrechnung? GLÖZ4-Puffer, GLÖZ8-NPF bis 2024, 2020-Grünland, LSE-only-Kombination und maximal 4xPfad getrennt. Negative/überlappende Teilflächen ausschließen, Reihenfolge/Identitäten verbindlich definieren; nicht nur ganze Schlaggröße addieren.

**Anlass:** Opus Mindestteilnahme summiert gesamte verfahrenskonforme Schlagfläche, BAW-Prämie nutzt andere gekappte/abgezogene Basis. Negativer GLÖZ4-Abzug erhöht Prämienfläche über die Schlagfläche. Luna kennt keine differenzierte Prämien-/DIV-Anrechnung.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 8: „auf dem betroffenen Flächenteil“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 7: „mit den Codes BAW und DIV“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 2: „zumindest 0,10 ha“.

## o6_8-BAW_DATED_ESTABLISHMENT_TRANSFER_AND_INPUT_BAN

Welche bestätigten Anlage-/Erstdeklarations-/Altbestands-/Übernahme-/Umbruchdaten und datierten Düngungs-/PSM-Ereignisse werden benötigt? Lagegenaue Übernahme übernimmt echtes Vorbewirtschafter-Anlagejahr; Altbestand kann >50% Leguminosen haben, Neueinsaat nicht. Verbot ab 1.1. Erstdeklaration bis Umbruch/anderer Deklaration, keine globale jährliche N-/PSM-Menge als Ersatz.

**Anlass:** Luna historische Pflege-/Umbruch-/Leguminosen-/PSM-Vorschläge unzureichend konsumiert. Opus Anlagejahr/Boolflags ohne Datums-/Nachweisbindung; globale Düngerfelder erfassen Verbotszeitraum nicht vollständig.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 4: „lagegenau weitergeführt“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 4: „bis zum Umbruch oder bis zur anderweitigen Deklaration“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 4: „auch über 50 % liegen.“.

## o6_8-BAW_TWO_YEAR_CARE_AS_OF_AND_DIV_SCOPE

Welche datierte Pflegehistorie belegt mindestens eine Mahd/Häckseln jedes zweite Jahr, mit heutigem Stichtag und noch möglicher laufender Jahrespflege? Beweidung/Drusch bleiben untersagt, Befahren/Abtransport erlaubt. 2026-DIV-Nutzungsausnahmen dürfen BAW-Pflichten nicht automatisch ändern.

**Anlass:** Opus Notiz behauptet Prüfung erst am Jahresende; Rego hat keinen as_of-Gate und beanstandet im Oktober fehlende nächste Pflege. Luna ignoriert die vorgeschlagenen BAW-Pflege-/Weide-/Druschdaten.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 4: „mindestens 1 x jedes zweite Jahr“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 4: „Beweidung und Drusch sind nicht erlaubt.“.

## o6_8-US_CALENDAR_WINTER_BEAN_AND_EVENT_EVIDENCE

Welche tatsächlichen Hauptkultur-/Untersaat-/Ernteereignisse, Partner-/Saatgutbelege, Erhalt/mitgeerntet, Bodenbearbeitungs-/Herbizidtermine gelten? Acht Wochen/max30.6.; Winterackerbohne vergleichbarer Sommer-Anbauzeitraum/max30.4. – nicht acht Wochen ab Herbstsaat annehmen. Datumsjahr mit aktuellem Antragsjahr verbinden; geköpft vs. verwertet unterscheiden.

**Anlass:** Opus verwendet Winter-Herbstsaat als Acht-Wochen-Start; Frühjahrssaat wird dadurch beanstandet. Fehlende US-Daten erlauben 81 Euro, Zukunftssaat im Folgejahr wird im aktuellen Jahr gewertet. Luna Datum/Partner/Erhalt/Herbizidflags ohne wirksame Prüfung.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 4: „in einem vergleichbaren Zeitraum wie“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 4: „spätestens jedoch am 30.“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 5: „Wird sie mitgeerntet“.

## o6_8-DROUGHT_US_PROOF_VERSUS_OTHER_OBLIGATIONS

Welche datierten Belege bestätigen ordnungsgemäße Untersaat mit vorgegebenen Partnern für automatische 2026-Flächendeckungsausnahme? Gilt diese auch für ausreichenden Feldaufgang, und mit welcher Quelle? Keine Frist-/Herbizid-/Erhaltsfreistellung. Ernteausnahme gesondert mit Gebiet, üblichem Spätsommer-/Herbstkulturzeitraum und tatsächlichem Dürregrund; individuelle Anerkennung braucht Scope/Datum.

**Anlass:** Opus properly_established:null gilt !=false und aktiviert Ausnahme bei drei Partnern; Ausweitung auf Feldaufgang ist unbestätigte Modelllesart. Luna Erntewaiver prüft weder ausdrücklichen Dürregrund noch Kulturzeitraum; Ausnahmen werden nicht an Gesamtcompliance gebunden.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „wenn eine ordnungsgemäße Anlage der Untersaat mit den vorgegebenen Mischungspartnern erfolgt ist.“.

## o6_8-CODE_COMBINATION_PAYMENT_PRIORITY_AND_GENERAL_GATES

Welche Prämienwirkung haben MS/DS/AH-Konflikt, weitere Codepaare, US-BIO-Zuschlag, Wien-Humusoption und Anhang-L-Fußnoten? Keine selbst gewählte Nullprämie/Priorität. Aktuelle behördliche Kürzung, Gesamtflächenmodulation/Obergrenze, OPEROA-Mapping und Vertrags-/Zahlungszustand bestätigen; offene Daten als offen ausgeben.

**Anlass:** Opus setzt bei MS/DS/AH beide Zahlungen auf null, meldet MS+DS nur und addiert beide Beträge. Fehlender Zahlungsantrag und vorzeitiger Ausstieg werden als Helper berechnet, sperren Prämie aber nicht. Luna BAW erlaubt ganze UBB/BIO-Maßnahme statt nur LSE-Ausnahme.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 8: „prämienfähige Kombination“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 8: „keine Prämie für Mulchsaat“.

Original `sources/oepul/originals/o6_8_erosionsschutz_acker_2026_04.pdf`, PDF-Seite 8: „Abgeltung der“.
