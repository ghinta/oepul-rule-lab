# o6_23: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_23-CURRENT_FULL_PROJECT_LAND_LAW_GIS_SNAPSHOT_AND_HOST

Welche tatsächlichen aktuellen Landes-/Projekt-/GIS-/MFA-/Expertennachweise bestätigen Gebiet, landwirtschaftlichen Lebensraum, Betrieb und Schlag? Projekt-ID, Behörde, Version, Gültigkeit, Rechtsverordnung, volle Geometrie und alle Auflagen/Parameter statt present/complied-Bools. Nationale Parkausnahme getrennt von aktiv genutzter LN.

**Anlass:** Beide Runs freie Bestätigungsflags; Opus Standort/in_scope/aktiver Landwirt default=true. Kein heutiger echter Landes-/GIS-Snapshot.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „Stelle des Landes“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „INVEKOS-GIS“.

## o6_23-COMPLETE_PARCEL_ID_GEOMETRY_UNIQUE_CODE_MAPPING

Wie werden Schläge, Feldstücke und echte projektbezogene Teilflächen eindeutig verknüpft? Neun N2-Codes sind den Annex-I-GI/GL-Auflagen gleichinhaltlich, aber neue Roots/normierte IDs erst freigeben. Keine überlappenden kopierten Schläge, freie Fläche über LN oder stilles Entfernen unbekannter Zusatzauflagen.

**Anlass:** Luna ein Code je Schlag, unbekannte Schläge fallen vollständig aus. Opus unbekannte Codes werden aus prämienrelevanter Menge gefiltert; fehlender vollständiger Behördencodevertrag bleibt offen.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „je Schlag“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „GL02 bis GL05“.

## o6_23-ACTUAL_ANNUAL_N2_APPLICATION_CONTRACT_AND_EXIT

Welche tatsächlichen N2-MFA-Codes, Anträge, jährlichen Fortsetzungen, Mindestteilnahme mindestens ein wirklich konformer Schlag, Ausstiege und Wiedereinstiege gelten? Letzter Eintritt 2027 ist kein Verbot Fortsetzung2028. Nur heutige Vertragsentscheidung, künftiger Ausstieg als Notiz.

**Anlass:** Luna application_year<=2027 verwechselt Fortsetzung mit Neueinstieg, Ausstieg/auto_extension blockiert compliant nicht. Opus Mindestschlag zählt premium_parcels trotz Bewirtschaftungsverstößen und zukünftige Abmeldung heute wirksam.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „zumindest ein Schlag“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „Förderjahr 2027“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 4: „Folgejahres“.

## o6_23-ACTUAL_GRASSLAND_TYPE_FERTILIZER_ALL_USES_AND_REMOVAL

Welche vollständigen jährlichen tatsächlichen Mäh-/Beweidungs-/Abtransport-/Düngeereignisse belegen Auflagen? Prämie nur Mähwiese/Mähweide ohne Dauer-/Hutweide. GI-Nutzungshäufigkeit: eigenständige Pflicht oder Tarifklassifizierung aus Bescheid? N-freie Düngemittel bleiben Düngung; bloße N-kg-Werte sind kein komplettes Düngeinventar.

**Anlass:** Luna Landnutzungsart grassland genügt und Nutzung/Abtransporthelper unverbunden. Opus zählt Schnittdaten ohne Jahres-/Vollflächenbezug, benutzt false-default Düngeinventar und ignoriert Verstöße im Prämiengate.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 4: „ohne“.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 66: „Düngung ist verboten“.

## o6_23-ACTUAL_ALL_CUT_DATES_CURRENT_YEAR_PARAMETER_AND_ASOF

Welche tatsächlichen Schnitttermine und verbindlichen frühesten Mahdparameter $1 aus Rechtsverordnung/Projekt gelten je Schlag/Jahr? Alle wirklichen Ereignisse, Chronologie und Stichtag prüfen; Verzögerungstage nicht ohne Ausgangstermin auf Kalenderdatum rechnen. Fehlender Parameter unbekannt, Zukunft noch kein Erfüllungsnachweis.

**Anlass:** Luna early-cut-Zweig macht auch vorzeitige erste Mahd zulässig; prüft faktisch nur erstes Arrayelement. Opus prüft alle, aber fremdes Jahr und future Schnitt erfüllen allgemeine Jahresmahd, fehlender Termin lässt Prämie dennoch stehen.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 67: „früheste Mahd am $1“.

## o6_23-DROUGHT_ACTUAL_STATE_ORDINANCE_DATE_SCOPE_NOT_AUG12_GLOBAL

Welche tatsächliche angepasste Landesverordnung mit Wirkdatum, betroffenem Gebiet, Schlag und neuem Termin ist für 2026 gültig? Naturschutz18-Freigabe ab12.08. gilt nicht automatisch23. Maßnahmenspezifische Zukunftsoption von heute vorliegendem Behördenbeleg trennen.

**Anlass:** Luna global zwei Bools ohne neues Datum/Scope überlagern alle Schläge. Opus frei geliefertes earliest_cut_date_state_ordinance_2026 ersetzt Projekttermin ohne Dokument-/Wirksamkeitsprüfung.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „Anpassung der zugrundeliegenden Verordnungen der Länder“.

## o6_23-ANNEX_J_WITHIN_G_UNKNOWN_T_ALIAS_AND_NAT_CODE_SCOPE

Welche tatsächlichen NAT18-/N223-Auflagen gelten auf demselben Schlag und wie werden nicht kombinierbare Kapitel geprüft? Vollständige J-Matrix mit T→A, S-H-Verbot und blanken Diagonalen; mehrere GI/GL-Codes innerhalb G sind durch Kapitelmatrix nicht automatisch erlaubte Summen. Zuständige fachliche Entscheidung statt freie Codes.

**Anlass:** Luna diagonale false/true-Werte statt unbekannt und keine T-Aliasnormierung. Opus G-G-Paare überspringt, daher mehrere mögliche Alternativtarife zugleich summierbar.

Original `sources/oepul/legal/20241011_srl_oepul_2023_anhaenge.pdf`, PDF-Seite 90: „Bewirtschafteter Acker“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „Anhang J“.

## o6_23-PARCEL_PREMIUM_COMBINATIONS_BIO_TB_AND_CONFLICT_AUTHORITY

Welche echten beantragten Prämien auf Einzelfläche sind mit UBB/BIO/Teilbetrieb/2/NAT18/EBW19 kombiniert? Betriebsweite andere Maßnahmen sind kein Konflikt auf diesem Schlag. Unzulässige Kombination: zuständige Maßnahme/Stufe/Betragsfolgen amtlich klären. BIO-Teilbetrieb technische Kennung nicht erraten.

**Anlass:** Luna other_measures farmglobal, eigener erfundener TB-Enum. Opus normalisiert1B_TB und streicht im Konflikt nur23 als Annahme; J/L-Fußnoten und tatsächliche Fläche entscheidend.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 4: „Einzelfläche“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 4: „Teilbetrieb“.

## o6_23-DIVSZ_ACTUAL_ELIGIBLE_AREA_UNION_CREDIT_NO_DOUBLE_AND_DROUGHT

Welche tatsächlichen N2-Schnittzeitflächen mit zusätzlichem DIVSZ bilden anrechenbare 7%-UBB/BIO-Flächenunion? GI-Fläche nicht automatisch anrechenbar; eigene Projektauflagen bleiben trotz DIV-Dürreausnahme verbindlich. Bloß gleicher Name ist kein Dubletten-/Flächenalias.

**Anlass:** Luna DIVSZ-Future/Ausnahmehelper nicht mit N2-Auflagen verknüpft. Opus anrechenbare Fläche vor Bewirtschaftungsverstößen und Vertragsfreigabe berechnet; kopierte GIS-Flächen können doppelt zählen.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „7 %-Biodiversitätsflächen“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 3: „Projektbestätigung“.

## o6_23-ACTUAL_RATE_COMPONENT_CAP_ORDER_OTHER_PAYMENTS_AND_SANCTION

Welche tatsächlich bestätigten Tarifkomponenten und anderen flächenbezogenen Zahlungen werden gemeinsam begrenzt? 18 Sätze für2023/ab2024, 1300/1500-Zeit-/NAT/EBW-Scope. Obergrenze nach Modulation laut SRL, kein automatischer letztrangiger23-Abzug. Unbekanntes sonstiges Geld, negative Beträge/Flächen und gleiche Alternative nicht als gültig behandeln.

**Anlass:** Luna premium_cap_ok nur Anzeige, ignoriert Zahlungs-/Ausstiegsstatus. Opus cap vor Sanktion/Modulation und23-zuerstgekürzt als dokumentierte Annahme; negative otherpayments erhöht Spielraum.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 1: „Teilprämien“.

## o6_23-GENERAL_PERSON_FIRSTYEAR_OP_AUTHORITY_AND_PAYMENT_UNKNOWN

Welche echten allgemeinen Personen-/Erstjahr-/Kontroll-/Konditionalitäts-/Sanktions- und Flächenübergabenachweise sind erforderlich? OPN2 wurde von Opus analog erfunden: amtlichen Code bestätigen. Ungeklärte Daten und theoretischer Betrag sollen keine bestätigte Aufnahme/Zahlung sein.

**Anlass:** App Category C missing_data. Luna allgemeine/Kontrollhelper unverbunden; Opus fehlende Pflichtdaten gelten teilweise neutral erfüllt und project_noncompliance/GI-Düngung/GL-Frühmahd erhalten trotzdem premium_granted.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 2: „Voraussetzung“.

Original `sources/oepul/originals/o6_23_natura2000-landwirtschaft_2025_10.pdf`, PDF-Seite 4: „Prämie“.
