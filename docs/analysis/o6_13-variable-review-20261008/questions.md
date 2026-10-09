# o6_13: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_13-HOST_CURRENT_CONTRACT_RENEWAL_WITHDRAWAL_AND_TAKEOVER

Welche heutigen bestätigten Vertrags-, MFA-/NUE-, Antrags-, Ausstiegs-, Kontroll- und Übernahmeereignisse bilden den Jahresvertrag ab? Erst-/Wiedereinstieg bis 2027 von Verlängerung 2028 trennen; keine Empfehlung aus frei gewähltem farm.year oder zukünftigen Einsätzen. Antragsdatum/Übernahmegenehmigung/MFA des Vorjahres unbekannt lassen; neue Teilnahme nur als begründete Zukunftsnotiz. Sind farm.measure_application und farm.oepul.o6_13 wirklich derselbe Vertrag?

**Anlass:** Luna ignoriert withdrawal_date und Jahresgeschichte und lehnt Fortsetzung2028 ab. Opus akzeptiert fehlenden Vorjahres-MFA, Übernahmebefunde sind keine Vertragsgates; Jahrespräfix ist kein reales Datum/Host-Zeitfilter.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 1: „Die Maßnahme verlängert sich automatisch“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 3: „kein Nützlingseinsatz (kein Code NUE)“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 4: „im betroffenen Förderjahr nicht mehr gültig“.

## o6_13-APPLICANT_LOCATION_EVIDENCE_AND_UNKNOWN_STATE

Welche bestätigten Person-/Verfügungs-/Lage-/Referenznachweise werden benötigt, und wie bleiben fehlende Pflichtangaben unbekannt? Betriebsregion ist keine Lage sämtlicher Schläge. Referenz-, Nationalpark- und Eigentümer-/Bewirtschafterdaten müssen mit Entitäts- und Gültigkeitsbezug aus den aktuellen Snapshots kommen.

**Anlass:** Opus erzeugt nur bei ausdrücklich false Zugangs-/Lagefehler; fehlende Angaben sind keine positive Bestätigung. Luna prüft nur AT auf Betriebsebene.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 4: „Förderwerbende Personen“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 9: „LAGE DER FLÄCHEN“.

## o6_13-FIRST_OEPUL_YEAR_FULL_MFA_AREA_NOT_NUE_AREA

Wie werden historisches erstes ÖPUL-Jahr und vollständige österreichische MFA-Fläche bestätigt? 0,50ha geschützter Anbau unabhängig von NUE oder alternativ vollständige 1,50ha einschließlich GA/K20/LSE/Hecken/Agroforst. Keine Gleichsetzung mit erstem Maßnahmenjahr oder beantragter NUE-Fläche; Aggregatsumme braucht deduplizierte Flächenbasis.

**Anlass:** Luna prüft zunächst nur NUE-Fläche und blockiert0,4haNUE bei0,6ha tatsächlichem geschütztem Anbau. Opus glaubt frei behauptete geschützte Gesamtfläche/Erstjahr; Überlappung total+additional offen.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 5: „unabhängig von der Beantragung“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 5: „Ab dem zweiten ÖPUL-Teilnahmejahr“.

## o6_13-STRUCTURE_IDS_GEOMETRY_PRODUCTION_AISLES_AND_SUBAREAS

Welche stabile Gewächshaus-/Tunnel-/Schlagidentität und echte Teilflächengeometrie gelten? Verkauf/Schau/Lager/Zwischenflächen ausschließen, notwendige Gangfläche begrenzen und Komponenten überschneidungsfrei belegen. Sind mehrere NUE-Schläge im selben Haus eine Struktur? Container sind explizit zulässig; fehlende oder negative Teilflächen nicht als null/Nullfläche interpretieren.

**Anlass:** Luna kennt Container nicht und hat nur ganze Flächenrolle/aisle_necessary. Opus zählt parcel_id statt structure_id; negative Ausschlusskomponenten erhöhen Prämie, notwendige Gangfläche wird nicht gegen excess_path abgeglichen.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „Flächen mit Containern, Töpfen oder Substratkultur“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „auf das nötige Ausmaß beschränkt“.

## o6_13-APRIL1_MIXED_SYSTEM_EVIDENCE_AND_MFA_CODES

Welche datierten Anbausystem-/Nutzungsartstände und offiziellen MFA-Codes gelten? A/GA und Wechselbetrieb zum1.April mit Beleg; vor Stichtag keine unbekannte Zukunft als feststehend annehmen. classification_medium_april_1, growing_system_on_april_1 und App-parcels sind keine bestätigten Aliase.

**Anlass:** Luna überschreibt auch bei nichtwechselndem System mit1.April-Wert. Opus prüft Wechselstand und positive Behauptungen, tatsächliche datierte Systemänderung fehlt. App projiziert eigene Maßnahmenschläge ohne Join zu land.parcels.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 3: „ist der 1. April für die Einstufung“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 3: „mit dem Code NUE“.

## o6_13-AGES_RATE_PRODUCT_ID_REAL_APPLICATIONS_AND_QUANTITY

Welche Registerversion, Produkt-/Organismus-ID, Kultur-/Zielorganismus-/Gebiets-/Gültigkeitsdaten, tatsächliche Menge+Einheit/Fläche und Datum bestätigen die AGES-Aufwandsmenge und den tatsächlichen PSM-Ersatz? Hummel-Bestäubung ist ausgeschlossen. Mehrere Einsätze als echte Ereignisse behalten, keinen Eintrag zu bloßem Organismusstring oder booleschen Flags reduzieren.

**Anlass:** Luna Einzelobjekt ignoriert Datum/Jahr/Host und boolesche flächendeckende Aussage fehlt. Opus glaubtRegister-/Rate-/Ersatzflags, akzeptiertJahrespräfix mitungültigemDatum und dokumentierte negativeMenge; defaults use_type=plant_protection.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „gemäß“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „Anrechenbar sind nur Anwendungen“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „Hummelvölker“.

## o6_13-FULL_COVERAGE_PER_STRUCTURE_PARCEL_AND_MULTIPLE_USES

Wie ist flächendeckender Einsatz je bezahlter Fläche gegenüber zumindest einem Gewächshaus operational definiert und belegt? Teilflächen/mehrere Anwendungen können zusammenwirken; union mit konkreter Geometrie statt any(covers_entire_area). Ein konformes Haus gibt andere Häuser/Schläge nicht automatisch frei. Keine selbst erfundene Toleranz.

**Anlass:** Luna bezahlt vollständige Fläche ohne Flächendeckungsdaten. Opus verlangt einen einzelnen vollflächigen Einsatz, prüft nicht belegte Kombination mehrerer Teilanwendungen und zählt Schlagnamen alsStrukturen.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 1: „flächendeckend“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „zumindest einem Gewächshaus oder Folientunnel“.

## o6_13-ALL_PARCEL_RECORDS_PURCHASE_LINKS_AND_PAYMENT_STATE

Wie werden Art/Menge/Grund/Ziel/Datum und echte Zukaufsbelege pro Einsatz und Schlag bestätigt, inklusive Einträgen ohne Datum? quantity_unit im Schema braucht fachlichen Vertrag; records.kept_per_parcel/receipt_available sind keine Dokumente. Welche Auswirkung haben unvollständige Aufzeichnungen auf Empfehlungsstatus und theoretischen Betrag gegenüber amtlicher Kürzungsentscheidung?

**Anlass:** Opus meldet Dokumentationsverstöße, bleibt aber eligible und zahlt2160 bei sanction_stage=none; fehlendesDatum wird ausDokumentationsprüfung ausgesiebt, anderer guter Einsatz lässtRestflächegültig. NegativeMenge giltals Feldvorhanden.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „Über Art und Menge“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „Auch andere Aufzeichnungen werden anerkannt“.

## o6_13-PO_PROGRAM_COVERAGE_PARCEL_OTHER_PREMIUM_AND_ANNEX_L

Welche Mitgliedschaft und tatsächliche Organismenabgeltung im operationellen Programm schließen den Betrieb aus, unabhängig von individueller Auszahlung? Vollständige tatsächliche Einzelflächenprämien und Codejahr prüfen. Annahme Mitglied+organism_use_compensated nicht mit Betriebsauszahlung verwechseln. Anhang-L-Zeile/Spalte13 leer; Fußnote2 und MB-Verbot für alle Einzelflächen ohne eigene Alias-/Prioritätsentscheidung aufnehmen.

**Anlass:** LunaFlag organism_use_compensated unklarProgrammvsBetrieb. Opus Maßnahmencode andererTeilnahme ist nichtNachweis tatsächlich andererPrämie; beide brauchenzugehörigeProgramme/Schlagzahlungen stattBool.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 1: „Mitglied einer Erzeugerorganisation“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 2: „der jeweilige Betrieb“.

Original `sources/oepul/originals/o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf`, PDF-Seite 4: „mit keiner anderen Prämie kombinierbar“.

## o6_13-DROUGHT_PARCEL_SCOPE_HARVEST_FUNDING_SANCTIONS

Gilt die2026Acker-Ernteausnahme überhaupt für A-Gewächshauskulturen und fürGA? Expertenscope offen halten, kein stilles Ausführen der Modellannahme. Bezirk am tatsächlichen Schlag, betroffene Kultur, kein erntbarerBestand, Datum und höhereGewalt mitPflichtscope bestätigen. Mindestbewirtschaftung und Modulation/amtlicheSanktion/Zahlung getrennt; Stufe unbekannt nichtnone.

**Anlass:** BeideModelle lassenGAaufBetriebsbezirkDürreflags zu; eigenesOffen-Label imModell stopptdieAusführungnicht. Opus missingharvest/pflegeokay. AllgemeineModulationsstufen stimmen, amtlicheBewertung+aktuelleSnapshots bleibenoffen.

Original `sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html`, HTML-Artikel: „Ernteverpflichtung auf Ackerflächen“.

Original `sources/oepul/notices/2026/2026-08-05__duerre-2026-erleichterungen-bei-oepul-und-bei-der-ausgleichszulage.html`, HTML-Artikel: „Ackerkulturen, die üblicherweise erst im Spätsommer oder Herbst“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 6: „85 % des jeweiligen Schlages“.
