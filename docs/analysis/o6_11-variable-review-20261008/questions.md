# o6_11: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_11-CURRENT_CONTRACT_HOST_YEAR_AND_FIRST_YEAR_HISTORY

Welche bestätigten gültigen Vertrags-/Maßnahmenantrags-/Ausstiegs-/Zahlungs-/Übernahmehistorien mit aktuellem Host-Jahr/Snapshot gelten? Einstieg2023/24/25 bisEnde2028; Mindestfläche nur erstes Verpflichtungsjahr und Betriebsmindestgröße nur erstes ÖPUL-Jahr, historisch nachweisen. App-Quellenstand gegenüber MB April2026 explizit quellenversionieren; keine neue Teilnahme2026 oder Zukunft als heutige Empfehlung.

**Anlass:** Luna macht aktuelle Fläche jedes Jahr zum Zugang, allgemeine Mindestgröße jedes Jahr und ignoriert Vertragsgültigkeit im Eligible/Betrag. Opus prüft aktuelle erste Jahre, nicht deren vollständige Historie; fehlendes Antragsdatum verhindert Prämie nicht.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 1: „mindestens 4 Jahre“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „mit dem Förderjahr 2025 möglich“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „Im ersten Teilnahmejahr“.

## o6_11-MFA_USAGE_TYPES_FULL_AREA_BAN_VERSUS_PREMIUM

Welche vollständigen offiziellen MFA-Kultur-/Nutzungsarten und aktuellen Flächen zählen für Erstzugang, gesamten Herbizidverzicht und Prämie? Schnittweingärten, Rebschulen, Sonstige Wein-/Spezialkultur, Walnuss/Edelkastanie, OP-Flächen trennen. Fehlender Name/Pflanzgut/Pflege/Lage bleibt unbekannt; alle tatsächlichen Verpflichtungsflächen einschließlich prämienloser Flächen belegen.

**Anlass:** Luna Notiz behauptet Ausschluss Walnuss von Ziel, Policy zählt sie; Singular Walnuss erhält Prämie, Plural Walnüsse nicht. Opus fehlende Art/Pflanzgut/Pflege/Lage/Schlagantrag werden teilweise förderfähig defaultet.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „Schnittweingärten zählen“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „Rebschulen zählen“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 4: „Walnüsse“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „nur veredeltes Material“.

## o6_11-AGES_EFFECT_TYPE_PRODUCT_ID_VERSION_AND_APP_PSM

Welcher aktuelle AGES-Registerstand mit stabiler Produktzulassung/ID, Wirkungstyp und Gültigkeitszeit belegt Herbizidstatus? Registerlabel Herbizid gegenüber technischen Strings herbicide/is_herbicide explizit adaptieren; Stamm-/Zaun-/Teilflächenanwendung zählt auf ganzer betroffener Fläche. Allgemeines App-psm_used darf nicht als Herbizidbeweis oder Freigabe dienen.

**Anlass:** Luna nutzt exakt Herbizid oder Bool, Opus exakt herbicide; vorgeschlagene Aliasnamen ohne Register-ID/Version/Produktbindung. Fehlende Wirkungstypen/Arrays wirken wie kein Einsatz. App nutzt Category-C-PSM-Proxys.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „Wirkungstyp“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „Stammbehandlungsmittel“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „entlang des Zaunbereichs“.

## o6_11-DATED_EVENTS_FULL_COMMITMENT_AS_OF_UNKNOWN

Welche tatsächlichen datierten Produkt-/Zonen-/Mengen-/Schlagereignisse mit vollständigen historischen und heutigen Erklärungen werden geprüft? Vergangenes Vertragsereignis versus künftiger Plan und fehlende Ereignisdaten unterscheiden; Kenntnisstand/Snapshotdatum explizit. Luna application_date gegenüber Opus date nicht still aliasieren; kein leeres Array als bewiesener Verzicht.

**Anlass:** Luna ignoriert Einsatzdatum. Opus fehlendes Datum wird aktuelles Jahr; zukünftige2027-Anwendung wird bei2026 bereits Verstoß, weil nur Gesamtvertrag geprüft. Anwendung aus vollständig fehlender Historie wird nicht offen bewertet.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „Im Vertragszeitraum“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „gesamten Schlagfläche“.

## o6_11-FORMIC_ACID_IDENTIFICATION_GENERAL_SCOPE

Wie werden Originalbezeichnungen/Synonyme von Ameisensäure mit autoritativer Wirkstoffidentität und aktuellem Register belegt? Allgemeines Feldproduktionsverbot außerhalb11-Vertrags-/Kulturumfang von maßnahmenspezifischem Herb-Verstoß trennen; Kauf-/Lagerbestände und erlaubte andere Zwecke fachlich prüfen. Keine neue Alias- oder pauschale Lagerverbotsregel aus Modellenglisch allein übernehmen.

**Anlass:** Luna erkennt nur genau Ameisensäure und nur Zielparzelle. Opus alle Synonyme inklusive zusätzlich formic acid, aber Einsatzprüfung an11-Vertrag gebunden; eigenes Kauf-/Lagerverbot behauptet weitergehenden Scope ohne explizite Originalregel.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „Ameisensäure“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „generell in“.

## o6_11-PURCHASE_STORAGE_OTHER_CROP_QUANTITY_AND_PROOF

Welche datierten Produkte, gekauften/gelagerten Mengen/Einheiten, aktuellen Bestände, erlaubten tatsächlichen Zielkulturen und Aufzeichnungen belegen die Ausnahme? Andere Kultur allein belegt keine erlaubte Zulassung. Plausibilität Menge/Fläche/Anwendung und Verbrauchshistorie nachvollziehbar, nicht nur Bool. Alt-/Zukunftskauf, kein heutiger Bestand und aktueller Snapshot getrennt.

**Anlass:** Luna permitted_for_other_crops=true genügt ohne Kultur/Menge/Aufzeichnung. Opus quantity_plausible/records_documented mit passender angebauter crop_category genügt ohne Zulassungsprüfung; purchased_date/in_storage/quantity werden nicht geprüft.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „Kauf und die Lagerung“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „erlaubterweise in anderen Kulturen“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „mittels Aufzeichnungen“.

## o6_11-PSM_MFA_CODES_TO_2025_END_2026_AND_PLANNED_ACTUAL

Welche tatsächlichen flächigen Einsätze, Bio-/chemische Mittel und Codes gelten bis2025? PSMCS kann Bioangabe abdecken, Herbizid PSMCSH gesondert; Bio-Herbizid-Labelkonflikt aus Original eindeutig fachlich entscheiden. Vorausangaben/umgehende Streichung und Nachtragung durch datierte MFA-Snapshots belegen. Ab2026 keine Codes verlangen, echte Anwendungs-/Verzichts-/Inventarevidenz weiter erforderlich.

**Anlass:** Luna coding-helper ohne echte Code-/Änderungsprüfung. Opus Voraus-/Änderungspflicht nur katalogisiert; missing effect_type wird Nicht-Herbizid, Bio/chemische Mischfälle benötigen bestätigte Labels.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „jedenfalls die separate Angabe“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „Ab dem Antragsjahr 2026 entfallen“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 2: „umgehend“.

## o6_11-BIO_PART_FARM_CONVERSION_ACTUAL_TIMELINESS

Welche aktive BIO-Teilbetrieb-/Kulturbereich-/Umstiegs- und Genehmigungshistorie beweist Ausnahme nur Acker/Grünland? Umstieg bis31.12.2025 mit Wirkung im Folgejahr, nicht bloßer Zielstring. Unzulässige oder noch unwirksame Umstiegsabsicht darf Konflikt nicht wegschalten; mehrere Maßnahmeneinträge/IDs eindeutig.

**Anlass:** Luna nutzt andere ID/participation_type als Opus. Opus converted_to_organic prüft nur conversion_target und entfernt BIO-Konflikt auch bei verspätetem oder noch unwirksamem Antrag; erste11-Arrayzeile wird blind ausgewählt.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „Teilbetrieb“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „bis spätestens am 31. Dezember 2025“.

## o6_11-ANNEX_L_MATRIX_FOOTNOTE_AND_FARM_PARCEL_SCOPE

Welche Original-Kombinationsmatrix/Fußnoten werden mit Einzelflächen-/Betriebsscope freigegeben? Die visuell geprüfte Zeile11 erlaubt1A nurLSE sowie2,10,12;1B ist leer. Luna-Daten behaupten1B/LSE, lassen2/12 weg und markieren Selbstdia­gonale x – technischer Tabellenlesefehler, keine fachliche Alternative. Matrix-/BIO-Teilbetriebscopes getrennt; keine Priorität/Nullprämie erfinden.

**Anlass:** Luna extrahierte Kurzmatrix widerspricht sichtbarer Originalzeile und eigener Rohzeile; Opus relevante Zeile stimmt, meldet Kombination aber nicht automatisch prämienwirksam.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 103: „Kombinierbar nur betreffend Abgeltung der Landschaftselemente“.

## o6_11-THEORETICAL_PREMIUM_UNKNOWN_VIOLATIONS_AND_SANCTIONS

Welche bestätigten Zugangspflichten und verletzten Nachweispflichten sperren heutige Empfehlung, welche erlauben nur gekennzeichnete theoretische Prämie? Amtliche Sanktion, Modulation/Gesamtsummenobergrenze, OP-/Nationalpark-/Pflege-Lage und vollständige Historie belegen. Nicht pauschal eigene Kürzung erfinden; Personen-/Kontroll-/Naturereignis-Defaults ersetzen keine Bestätigung.

**Anlass:** Luna eligible/Betrag trotz Herbizid/BIO-Verstoß und allgemeiner Mindestgröße. Opus 270Euro trotz bestätigtem Herbizid/Purchase-Verstoß ohne gelieferte Sanktionsstufe; contract_valid zeigt nachAusstieg oder außerhalbaktuellerVertragsjahre weitertrue.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 4: „270,0“.

Original `sources/oepul/originals/o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf`, PDF-Seite 3: „keine ÖPUL-Prämien“.
