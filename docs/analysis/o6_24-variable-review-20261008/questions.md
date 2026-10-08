# o6_24: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_24-CURRENT_FULL_EXTERNAL_REGULATION_GIS_AND_EXPERT_SNAPSHOT

Welche tatsächlich gültige Fassung des Grundwasserschutzprogramms einschließlich §4/§5 und Anlagen2B/3, welcher aktuelle amtliche GIS-Layer und welche Experten-/Betreibereingaben bilden den heutigen Datenstand? Versions-ID, Gültigkeitsdatum, Gebiet und komplette Kultur-/Klassentabelle/Sperrfristen/Buchanforderungen müssen belegt sein. Das fehlende Dokument zuerst beschaffen und fachlich bestätigen; Beispielwerte und freie Bools ersetzen es nicht.

**Anlass:** Die referenzierte Verordnung fehlt im Run-Quellenpaket. Opus hat nur zwei Winterweichweizen-Beispielwerte, nicht einmal C-Grenzen; keine reale aktuelle Rechts-/GIS-Version ist Bestandteil dieser Proben.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 1: „LGBl Nr. 24/2018“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „Anlage 2B“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „Anlage 3, Punkt 3“.

## o6_24-REAL_PARCEL_IDS_CLASS_GEOMETRY_UNION_AND_LN

Welche eindeutigen Schlag-/Feldstück-/Teilflächen-IDs und Geometrien belegen die WRRL-Kulisse und Düngeklassen? Klassenflächen müssen vollständig, positiv und ohne Überlappung zum tatsächlichen Schlag gehören; höhere getrennte Klassendüngung nur mit separat beantragten Teilschlägen. Gleiche Namen/IDs oder freie Flächenangaben beweisen keine disjunkte Flächenunion.

**Anlass:** Opus gewichtet anhand frei gelieferter Klassenflächen ohne Abgleich zur Schlagfläche. Gleicher Schlag mehrfach im Array verdoppelt die Fläche; IDs werden nur in der Ausgabe dedupliziert.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „separat als“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „vorhandenen Gebietskulisse“.

## o6_24-MINIMUM2HA_VERSUS_ELIGIBLE_FALLOW_PERMIT_AND_OPWRRL

Zählen bewirtschaftete Brachen und Flächen mit erhöhter N-Bewilligung zur jährlichen2-ha-Mindestteilnahme, obwohl sie keine Prämie erhalten? Welche tatsächlichen Bewilligungsakten, MFA-Codes und Nutzungsarten gelten? SRL schließt Brachen ausdrücklich aus; OPWRRL ist im Merkblatt nur für bewilligte erhöhte N-Gaben genannt. Verbindliche Brachencodierung bestätigen, OP nicht ohne Freigabe gleichsetzen.

**Anlass:** Luna zählt nur Flächen ohne erhöhten N-Bescheid zur Mindestfläche und berücksichtigt Brachen nicht. Opus zählt alle Ackerflächen in der Kulisse, auch Brachen/Bewilligungen; nennt OPWRRL auch für Brachen als Auslegung.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 1: „zumindest 2,00 ha“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „OPWRRL“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 93: „Brachflächen“.

## o6_24-ACTUAL_EFFECTIVE_N_FULL_EVENTS_UNITS_FACTORS_AND_ROUNDING

Welche vollständigen tatsächlichen Düngeereignisse, Mengen/Einheiten und jahreswirksamen N-Faktoren gelten? Quelle und Jahr für organischen N bestätigen; fehlender organischer/mineralischer Anteil ist unbekannt. Gewichtetes Beispiel133kg versus Rechenwert133,2kg fachlich entscheiden. Keine beliebigen Eingabegrenzen oder negativen Mengen als zulässiger Nachweis.

**Anlass:** Luna vergleicht zwei freie aggregierte Zahlen. Opus summiert vorhandenen mineralischen/organischen Anteil bereits bei nur einem Wert und akzeptiert freie Klassenlimits; negative Teilflächen können das gewichtete Limit erhöhen.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „jahreswirksamen“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „133 kg“.

## o6_24-ACTUAL_DATED_APPLICATION_EVENTS_LEGAL_WINDOWS_AND_C_CLASS

Welche datierten tatsächlichen Ausbringungen werden gegen verbindliche kultur-/klassenbezogene Sperrfristen geprüft? Nicht zugeordnete Fläche ist C, aber ohne amtliche C-Grenze darf kein Bestehen behauptet werden. Zeitpunkt, Fläche, Art und vollständige Jahresabdeckung statt application_period_compliant-Bool; Zukunft als begründete Notiz.

**Anlass:** Beide Runs erwarten ein Compliance-Bool ohne echte Ereignisse oder Fristentabelle. Luna wertet fehlende N-/Fristdaten als erfüllt; Opus gibt missing_inputs aus, zahlt aber dennoch.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „Düngeklasse C“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „zulässigen Zeiträume“.

## o6_24-FARM_BOOK_ALL_PARCELS_ZERO_N_CONTENT_STORAGE_AND_RETENTION

Umfasst §5 wirklich alle Betriebsschläge, auch außerhalb WRRL oder nicht für24 beantragt, und welche Pflichtinhalte/Datierungen/Aufbewahrung gelten? Null-Düngung benötigt ebenfalls Aufzeichnungen. Tatsächliche Beleg-/Schlag-IDs und Buchvollständigkeit statt Farm-Bool.

**Anlass:** Opus prüft Aufzeichnungsflag nur an für24 beantragten Ackerflächen innerhalb der Kulisse. Ein zusätzlicher nicht beantragter Außenschlag mit records=false wird nicht bemängelt. Fehlende Aufbewahrung wird nicht als missing_input ausgegeben.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „für alle Schläge“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „auch wenn keine Düngung erfolgt“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „am Betrieb“.

## o6_24-CURRENT_ANNUAL_CONTRACT_MFA_PROGRAM_END_EXIT_AND_ASOF

Welche tatsächlichen Maßnahmenanträge, jährlichen MFA-/Verlängerungs-/Abmeldungsdaten, Vertragsbeginn und Programmlaufzeit gelten? Letzter Einstieg2027 ist nicht Ende der Fortsetzung2028. Heute nur heutige Tatsachen prüfen; ein zukünftiger Ausstieg ist bis Wirksamkeit eine begründete Notiz.

**Anlass:** Luna vorgeschlagene Antrags-/Ausstiegsfelder werden nicht konsumiert. Opus zahlt2029 mit altem Vertragsbeginn, behandelt fehlenden aktuellen MFA nur für nächstes Jahr und zukünftige Abmeldung heute als Vertragsverlust.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 1: „ein Kalenderjahr“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „Förderjahr 2027“.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „betroffenen Förderjahr“.

## o6_24-ACTUAL_PERSON_FIRSTYEAR_LOCATION_AND_CONTROL_PROOF

Welche tatsächlichen Nachweise bestätigen förderwerbende Person, aktiven Landwirt, Erstjahr und relevante Betriebsmindestgröße sowie reale österreichische landwirtschaftliche Fläche? Exakte App-/Canonical-Pfade und Behördenherkunft fachlich bestätigen. Fehlendes Erstjahr/Flächenbeleg ist keine positive Erfüllung.

**Anlass:** Opus verlangt echte applicant-Felder, aber fehlendes Erstjahr überspringt Mindestgröße und Standort/Nutzung haben positive Defaults. Luna allgemeine Antragsteller-/Kontrollvoraussetzungen fehlen im Entscheidungsgate.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 1: „TEILNAHMEVORAUSSETZUNGEN“.

## o6_24-ACTUAL_ANNUAL_HARVEST_REMOVAL_AND_FORAGE_FULL_AREA

Welche tatsächlichen jährlich vollständigen Ernte-/Abtransport-/Mahd-/Beweidungsereignisse belegen85% oder volle Ackerfutternutzung? Anteil und Datum müssen zum tatsächlichen Schlag/Jahr passen; bloßer Schnitt aus2010 oder2027 ist kein Nachweis für2026. Ausnahmen benötigen ihren amtlichen Scope.

**Anlass:** Opus fehlender Ernteanteil blockiert Zahlung nicht. Ackerfutter mit einem beliebigen Schnittdatum gilt als genutzt; Vollfläche/Abtransport/Jahresbezug fehlen.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 6: „zumindest 85 %“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 6: „jährlich mindestens einmal“.

## o6_24-DROUGHT_ACTUAL_PARCEL_REGION_CROP_AUTHORITY_AND_EFFECTIVE_DATE

Wie werden die tatsächlich betroffene Schlaglage, passende Spätsommer-/Herbstkultur und nicht erntbarer Bestand gegen den zeitlich gültigen Augusthinweis geprüft? Kein Betriebsstandort als Ersatz für unbekannte Schlaglage; keine Vorwegnahme vor Veröffentlichung/Wirksamkeit. Die allgemeine Ernteausnahme hebt keine WRRL-N-Grenzen/Sperrfristen auf.

**Anlass:** Luna nur Betriebsregion plus Farm-Bool, keine Kulturprüfung. Opus passenderer Kulturscope, jedoch Betriebslage als Default und keine zeitliche Bindung an announced_date; vorAugust-Probe erhält schon Erntefreigabe.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „Steiermark“.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „zumindest 85 % des Schlages“.

## o6_24-ANNEX_L_REAL_PARCEL_COMBINATIONS_CODES_AND_OVERLAP

Welche tatsächlich beantragten Maßnahmen gelten auf genau dieser Fläche? Original-L-Zeile/Spalte24 erlaubt16, nicht23. Fußnote4 bei8/16 bezeichnet deren besondere Zuschläge und darf nicht als pauschaler WRRL-Abschlag gelten. Unbekannte Codes/Aliase nicht ignorieren; tatsächliche gesetzliche/öffentliche Überschneidung belegen.

**Anlass:** Lunas separate allowed-Liste enthält23 und lässt16 aus, obwohl eigene rohe Originalzeile korrekt aussieht; Helper ist außerdem nicht an Entscheidung gebunden. Opus20 direkte Partnerwerte entsprechen Original; unbekannte zusätzliche Codes bleiben ohne Konflikt.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 103: „Kombinationstabelle“.

## o6_24-ACTUAL_MODULATION_CAP_ORDER_OTHER_PAYMENTS_SANCTION_AND_UNKNOWN

Welche tatsächlichen flächenbezogenen anderen Zahlungen, ausgenommene Maßnahmen und Behörden-Sanktionsentscheidungen gelten je Schlag/Jahr? Modulation vor Flächenobergrenze und Zuordnung eines Abschlags fachlich festlegen. Keine proportional erfundene24-Kürzung und kein unbekannt=0 ohne Freigabe; fehlende/violierte Pflichten müssen in Empfehlung und Zahlungsstatus korrekt dargestellt werden.

**Anlass:** Opus meldet N-/Sperrfrist-/Buchverstöße ohne Eingabe einer Sanktion, lässt granted108€ stehen und errechnet Cap-Verhältnis vor Modulation. Luna liefert nur Satz, keinen behördlich freigegebenen Endbetrag. Historische Ausgaben sind keine Golden-Sollwerte.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 4: „54,0 €/ha“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 19: „ohne Einrechnung“.

## o6_24-ACTUAL_TAKEOVER_APPROVAL_CIRCUMSTANCE_YEAR_AND_PAYMENT

Welche echten datierten Übernahme-/AMA-/höhere-Gewalt-/besonderen-Umstände-Nachweise wirken heute auf Vertrag und Auszahlung? Übernahmeprüfungen müssen zur tatsächlichen Fläche/Person passen. Frühere Ereignisse und zukünftige Pläne nicht ohne aktuellen behördlichen Status anwenden.

**Anlass:** Opus takeaway-Failures sind nebenläufig und nicht im Gesamtentscheid: nicht genehmigte späte Übernahme lässt Zahlung stehen. Besonderes Ereignis aus2025 blockiert2026, da nur <=15.April verglichen wird, ohne gleiches Ereignisjahr. Fachliche Sanktion nicht automatisch erfunden.

Original `sources/oepul/originals/o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „gültigen Vertrag“.
