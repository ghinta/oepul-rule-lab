# o6_14: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_14-CURRENT_OPERATOR_CONTRACT_OPTIONS_EXIT_AND_HISTORY

Welche bestätigten Almbewirtschafter-, Vertrags-, Übernahme-, Zahlungs-/Ausstiegs- und Erstjahresnachweise gelten heute? Grundmaßnahme/NATA2023–2025 bisEnde2028 versus einjähriger Almweideplan ab2025. Keine frei behaupteten farm.year/first_year/participation flags; Zukunft nur begründete Notiz. land.alpine_pastures/livestock.alpine_movements und alpine_farming.* haben keinen bestätigten Alias.

**Anlass:** Luna hat Vertrags-/Antragshelper ohne eligible-Gate. Opus valid_contract prüft Start/Antrag, nicht heutigen Zeitraum/Ausstieg/Zahlungsantrag; missingPerson/Kontroll-/Sanktions-/Exit-/Claimhelper unverbunden.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 1: „Almbewirtschafterin oder dem Almbewirtschafter“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 2: „betriebsbezogen“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 11: „bis spätestens am 31. Dezember“.

## o6_14-ANIMAL_IDS_AGE_JULY1_RGVE_KEY_AND_COUNTS

Welche Register-/Ohrmarken-/Tier-/Heimbetriebsidentitäten, Geburtsdaten, Rassen-/Größenklassen und1.Juli-Kategorien gelten? RGVE-Faktoren selbst herleiten/belegen, keine beliebige Kategorie/gve. Einzelrinder/Schafe/Ziegen sind kein frei wählbares count-Kollektiv. Nach1.Juli Geborene nur für Maximalbesatz ausnehmen; Prämie/Artenfilter separat.

**Anlass:** Luna nimmt gve frei entgegen, Tabelle enthält auch sechs nichtteilnahmefähige Kategorien. Opus vertraut rgve_category_id unabhängig von species/Alter undcount; Präsenz standardtrue, tatsächliche Tier-/Registerdaten fehlen.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 14: „Der Altersstichtag“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 12: „einzeltierbezogen“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 5: „Jungtiere, die nach dem 1. Juli geboren wurden“.

## o6_14-ACTUAL_STAYS_INTERRUPTION_UNION_YEAR_AND_AS_OF

Wie werden tatsächliche Aufenthalte mitAlm-/Tier-ID, unterjährigem Heimbetriebswechsel, Unterbrechungen und host.as_of belegt? Aufenthalte im aktuellen Jahr schneiden, jeTier überlappungsfrei vereinen und jeAlm belegte Kalenderunion zählen. Auftriebstag ja, Abtrieb nein; 60Tage proTier über mehrereAlmen versus60Bestoßungstage proAlm getrennt. Zukünftiges/plannedDatum nicht als tatsächlichen Abtrieb verwenden.

**Anlass:** Luna summiert Tier-Tage proAlm und prüft jedes Bewegungsteil separat>=60. Opus Alm-Kalenderunion korrekt, Tiersumme doppeltüberlappte Stays und alleJahre/Zukunft ungeschnitten; Fremdalm-ID-Zeit kann eigenenTiergesamtwert erreichen.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 4: „hintereinander“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 4: „Unterbrechungszeiten“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 4: „Der Auftriebstag zählt“.

## o6_14-DATED_REPORTS_CREDIT_WINDOWS_PAYMENT_AND_WAIVER

Welche datierten bestätigten Meldungen/Listen/Code-/Korrekturstände gelten jeTier/Alm? VerspäteterAuftrieb reduziert anrechenbareTage um7/14Fenster, nicht pauschalganzeTeilnahme. Abtrieb7/14ab tatsächlichemDatum; Equiden/Kamele ggf.passenderPlanabtrieb.15.Juli Tierauftrieb vs17.Juli Listen2023/2028. Ausnahme nurRinder/Stufe1 ohneBehirtung/erhöhteAWP; Schaf-/Ziegenverkauf neuerHeimbetrieb brauchtNeuauftrieb. FehlendeMeldung/Datum bleibt unbekannt.

**Anlass:** Luna Aggregate allerArten statt echteEinzelmeldungen, Datums-/Fristhelper nichtgating. Opus fehlendeFeldliste übersprungen und meldetFrist-/Abtriebsfehler ohneBetragssperre; ReportvorAuftrieb kannZeitgutschrift erlauben.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 5: „nur die Zeit ab 26. Juni“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 11: „Eine Ausnahme gilt hier“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 12: „eine erneute Auftriebsmeldung“.

## o6_14-ALM_GIS_FULL_PLOTS_DOMESTIC_FOREIGN_RELIEF_DENSITY

Welche aktuelle INVEKOS-/Almkataster-/Futterflächen-/Bewirtschafter-/Grenz-/Heimbetriebsbelege und vollständigen Feldstücke bilden jede Alm? 2,0 bzw.NATA1,5 oder begründeteAWP2,4RGVE/ha jeAlm; mindestens60Tage/1.Juli undanteiligeAufenthalte. Auslandsentlastung nurangrenzende tatsächlich bewirtschaftete Fläche mitjährlicherMeldung/Nachweis, niePrämienfläche. MehrereAlmen getrennt, Betriebserstjahr3ha/3RGVEgesamt.

**Anlass:** Luna ignorestocking_records foreignrelief/rgve_per_ha undcopygvejeAlm; fehlende is_in_austria kannViolation überspringen. Opus foreign_area_report_submitted alleinkeinDokument, Schemageometrie/Produktionsjahr/Referenzteilflächen fehlen.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 3: „nicht vom Heimgut aus bewirtschaftet“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 5: „für jede einzelne Alm separat“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 5: „jährlich eine gesonderte Meldung“.

## o6_14-ACCESS_CENTER_UNITS_TIMES_COMPARABILITY_ROUNDING

Welche reale Infrastruktur/Wirtschaftszentrum50m, nichtangrenzendeTeilflächen und tatsächlichen Tier-/RGVE-Auftriebszeiten bestimmen Stufe1/2/3? VergleichbareZeiten vsdominanteAuftriebsdauer fachlich bestätigen, keineeigeneToleranz/Gleichstands-/Rundungsregel. Opus alp_days/drive_period_days müssen ausEreignissen kommen; eineUnitdarf nichtmanuellaccess_level übersteuern.

**Anlass:** Luna nimmt access_stage fertigentgegen. Opus rundetgewichtetesMittel undwähltbeiGleichstand max(level), beidesausBeispielverallgemeinert; comparable undgetrennteZeitaggregate unbewiesen.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 3: „Umkreis von 50 m“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 4: „vergleichbar“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 4: „3.750 Alptage“.

## o6_14-SILAGE_ORIGIN_OWN_FOREIGN_ALM_HAY_PARTICIPATION

Welche tatsächlichenFutter-/Silage-Erzeugungs-/Lager-/Transport-/Verfütterungsbelege und zugehörigenHeuwirtschaft-Verträge gelten? Ab2025almeigeneSilage nuraufjeweiligerAlm; FremdalmAusnahme gegenüberEigenalmmitHeuwirtschaft. Ausgleichsheuistkein pauschalesGrundfutter. GesamtenatürlicheFuttergrundlage/Präsenz/Beweidung bestätigen, keinebloßenVerstoß-Flags.

**Anlass:** Luna erlaubt almeigeneSilage2024undhatkeinenHeuwirtschaft-Join. Opus nutztnichtnormiertes heuwirtschaft statt o6_3, falsch benannteTeilnahmeumgehtVerbot; missingfeeding/präsenzkeinViolation.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 7: „gänzlich auf der“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 7: „Eigenalm“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 7: „Ausgleichsfütterung“.

## o6_14-BIO_PRODUCTS_FERTILISER_ORIGIN_PSM_EVENT_CODE_YEAR

Welche Produkt-ID/Registerversion/Wirkstoffe und echteDüngungs-/PSM-Ereignisse jeAlm/Feldstück/Jahr belegen dieEU2018/848-Zulässigkeit? HerkunftStall/Alm vonGülle/Jauche undsepariertenFeststoffen,Heimbetriebsmist erlaubt; NATAHabitatstrengerScope extra. MFA-PSMBIO/PSMCSendet2026, tatsächlicheAnwendungs-/Düngungsauflagen bleiben. KeineRegel ausunbekanntemBoolableiten.

**Anlass:** BeideModelle ProduktflagsstattRegister/Ereignisse. Luna keineechtePSMCodegeschichte; Opus2025/2026Codehelperkorrekt, aberVerbot undpositivePrämie getrennt.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 8: „Ein separierter“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 8: „Mist muss dabei nicht“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 8: „Ab dem Antragsjahr 2026“.

## o6_14-NATA_FULL_CONFIRMATION_HABITATS_ANNEX_E_CODES_SCOPE

Welche bestätigteLandesprojekt-ID/Version/Gültigkeit/verorteteAuflagen gelten aufallenFeldstücken derkonkretenAlm? NATAcodesundTermin,AnhangEneunCodesmitbetroffenenAnteilen und100m²Einzelgehölzen prüfen; doppelte/generischeCodes nichtaddieren, keinTransfer vonAlmAaufB. Drainagenzustimmung/Habitatdüngung/Tränkenvollständigbelegen; tatsächlicheAuflagen müssen ausProjekt kommen. PrämienscopeundCodekombinationexpertischbestätigen.

**Anlass:** Luna sammeltCodesglobal undberechnetkeinNATAgesamtergebnis. Opus project_requirements_missing okay, DUPNAW1 additiv, betroffenShare99 vsCodeNAW1 wirdnichtabgeglichen; Projekt-/Maßnahmenpflichtverstöße verhindernNATAbetrag nicht.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 8: „auf allen“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 10: „Projektbestätigung Auflagen festgelegt werden“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 10: „Einzelgehölze“.

## o6_14-COURSE_PERSON_PROVIDER_DATES_DOUBLE_CREDIT_REPLACEMENT

Welche tatsächlichgeprüftenKurs-/Person-/Betriebs-/Anbieter-/Inhalts-/Stundenbestätigungen gelten fürNATA4hab2022bis31.12.2025 undAWP4hab1.10.2024bis15.JulierstesZuschlagsjahr? KeineDoppelanrechnung; NATAgeschultePersonAbgangbis31.12.2025fordertNachholung,danach nicht. AWPvorStichtagnochbevorstehendePflicht alsPending kennzeichnen, keineFristvorwegverletzung.

**Anlass:** Luna unknownhours/dateswerden teilsübersprungen, coursestart/person/role/doublecredit fehlen. OpusNATAfehlendenKursbereitsJanuar2025alsViolation,zahltdochNATA; zugehörigeTatsächlichkeitderAWPKurse fehlt.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 9: „Anrechenbar sind Kursbesuche“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 9: „Verlässt die“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 10: „1. Oktober 2024“.

## o6_14-ANNUAL_GRAZING_PLAN_ALL_ALMS_REVIEW_AND_INTENSITY

Welcheechten jährlichenPlan-/Erstellungs-/Veröffentlichungs-/Kommunikations-/Überprüfungsbelege bestätigenBewertungundWeidelenkungjeFeldstück/Teilfläche aufallenAlmen? ErstjahrZuschlagvsFolgejahr; begründeteerhöhteIntensität extraaufAuftriebslistebeantragen. KeinmanuellerBoolGrund. NATAundAWP-Kombinationsscopebetrieb/Almfachlichklären;20haDeckelund1ha/RGVE-Bezugbestätigen.

**Anlass:** Luna ignoredcourse.completed_by/annual_review undunknownstrongreasonkannDensityhelperundefinedlassen. Opusalter2025Plan2026weitergültig,Erst-/VerlängerungsjahrundderegisteredhelpernichtPrämiengate; CombinationglobalohneScopefreigabe.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 10: „des jeweiligen Teilnahmejahres“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 10: „Ab dem zweiten Teilnahmejahr“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 13: „ersten 20 ha je Alm“.

## o6_14-PREMIUM_PER_ALM_VERSUS_GLOBAL_MODULATION_AND_OTHER_MEASURES

WelchevollständigegetrennteHeim-/AlmbetriebsflächeundzugehörigeRGVESummebestätigenModulation? QuelleMB13Minimum ausSummenderRGVE/Almfläche desgesamtenBetriebs gegenüberOpusSummejeAlmmin: ExpertebestätigtunbalancierteMehralmfälle. PrämienflächejeAlm min1ha/RGVE,Stufe/NATA/AWPextra; AnhangL14leer versus tierbezogene15/21nichtidentisch. TatsächlicheMaßnahme21-TierbeantragungvorSatzreduktionnichtjederStay.

**Anlass:** Luna globalmodulationsbasisminsum istandererVertrag alsOpussummin; Opusnotesverweisenunklares230/250Beispiel,nichtOriginalMB13-Beispiele. OtherareaCombinationhelper/21StayProxyunbestätigtundunverbrauchterCap/Sanktion.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 13: „aus der Summe der RGVE“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 13: „für jede Alm separat“.

## o6_14-FORCE_MAJEURE_APPROVAL_SCOPE_UNKNOWN_AMOUNT_AND_SANCTIONS

WelchebestätigtenhöhereGewalt-/Dürre-/Kontroll-/SanktionsentscheidungenmitTier/Alm/Jahr/Pflichtscopegelten? AntragistkeineAnerkennung. RechnerischerBetragvoramtlicherKürzungdarfkeinebestätigteaktuelleEmpfehlungsein;fehlendePerson/Meldung/Beweisnichtdefaultokay. Keineautomatische60Tage-AusnahmeodererfundeneamtlicheKürzung, auchwennAppproxyeligibleist.

**Anlass:** Opusdrought_recognised setztAntragmitAnerkennunggleich; controlrefused/twofullreductions/paymentClaim/exit/violationslassenBruttobetragunberührt. ModellannotiertvorinhaltlichenKürzungen,AppeligiblebrauchtweitereEvidenz.

Original `sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html`, HTML-Artikel: „kann auch ein Antrag auf höhere Gewalt gestellt werden“.

Original `sources/oepul/originals/o6_14_almbewirtschaftung_2026_04.pdf`, PDF-Seite 4: „60 Tagen“.
