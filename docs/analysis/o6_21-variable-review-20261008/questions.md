# o6_21: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_21-CURRENT_YEAR_REGISTER_SOURCE_SNAPSHOT_AND_ASOF

Welche aktuellen Rinderdatenbank-/AMA- und Expertensnapshots mit Versionsdatum, Tier-/Betriebsidentität, Alter und tatsächlichen Ereignissen gelten? Das aktuelle Jahr und der Datenstichtag müssen verbindlich sein; geplante Abgänge oder Haltungen nur als begründete Zukunftsnotiz. Den in Opus erwähnten, im Paket fehlenden Meldeartikel vom 02.09.2026 zuerst verifizieren.

**Anlass:** Luna verwendet farm.o6_21.year bzw. input.year, nicht farm.year. Opus rechnet ohne Stichtagsgrenze das gesamte Jahr; program_end_year ist ungenutzt. Kein echter Register-/Behördensnapshot vorhanden.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 11: „Daten der Rinderdatenbank“.

## o6_21-REAL_ANNUAL_CONTRACT_AND_AUTHORITY_REENTRY

Welche aktuellen jährlichen Kategorie- und Zuschlagsverträge, tatsächlichen Anträge, Erlöschens-/Ausstiegsereignisse und Behördenanerkennungen belegen Teilnahme? Ein schriftliches Wiederersuchen ist noch keine Anerkennung; zukünftigen Ausstieg nicht als heute bereits erfolgt werten.

**Anlass:** Luna Antrag/Vertragsstatus blockiert eligible und Betrag nicht. Opus akzeptiert verspäteten Antrag aus zwei Bools ohne Anerkennung und Jahresfortsetzung auch nach Programmende.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 1: „Vertragszeitraum“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 9: „31. Dezember“.

## o6_21-FOUR_CATEGORY_ENUMS_REAL_SEX_AGE_AND_UNIQUE_TIERS

Wie werden die vier tatsächlichen Kategorien, Ohrmarken, Geschlecht, Geburt, Zukauf, Alterswechsel und Zwergrindrassen aus dem vollständigen Register zugeordnet? Enum-/Root-Aliase zwischen Luna und Opus erst fachlich bestätigen; doppelte Tieridentitäten und unbekannte Zugehörigkeit dürfen keinen zusätzlichen Bestand erzeugen.

**Anlass:** Luna Kategorien und RGVE sind getrennte freie Aggregate ohne echte Altersberechnung. Opus Tierliste und Belegungsgruppen können auseinanderlaufen; kopierte Ohrmarken erhöhen category_rgve, selbst wenn premium_lines als Set identische Zahlzeilen deduplizieren.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 2: „Männliche Rinder“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 11: „anteilig“.

## o6_21-FULL_YEAR_PROGRAM_PROOF_THRESHOLDS_AND_RECOGNITION

Welche tatsächlichen ganzjährigen anerkannten TGD-/Qplus-Nachweise und Übermittlungsdaten gelten? TGD-Basis über 10 RGVE vor/nach ausgeschlossenen Tieren fachlich klären; 2023 beginnt am 15.04. Qplus-vergleichbar braucht aktuelle Anerkennung, im Merkblatt gibt es derzeit kein anderes Programm.

**Anlass:** Luna globale Bools ohne Volljahres-/Anerkennungsscope. Opus Qplus-/TGD-Verstöße werden ausgegeben, aber measure_payable prüft sie nicht und kann einen positiven Betrag liefern.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 3: „Tiergesundheitsdienst“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 3: „vergleichbares“.

## o6_21-DAIRY_ALM_SEASONAL_DELIVERY_AND_DIRECT_PROCESSING

Welche tatsächlichen Molkerei-/Almmilchlieferungen und reine Direktverarbeitung gelten pro Betrieb/Jahr? Die weibliche Kategorie 6–24 Monate ist bei auch saisonaler Almmilchlieferung ausgeschlossen; anderer weiblicher Kategorievertrag bleibt getrennt.

**Anlass:** Opus differenziert saisonale Almmilch; Luna hat nur einen globalen Milch-Bool. Fehlende Lieferdaten werden bei beiden nicht als unbekannter Zugang behandelt.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 2: „Milchanlieferung“.

## o6_21-REAL_STALL_IDS_HOME_CAPACITY_AND_COMPLETE_JOIN

Welche tatsächlichen Gebäude-/Box-IDs und vollständigen Tierzuordnungen belegen Heimstall, Dach, befestigte/flüssigkeitsdichte Fläche, Entwässerung, dauernden Zugang und Platz auch für Weidetiere? Fehlende oder falsche Referenzen, leere Belegung und unbekannte Baumerkmale bleiben ungeklärt.

**Anlass:** Opus kann mit einem leeren Gebäudeobjekt ohne System/ID und ohne Boxen positive Prämie berechnen; fehlende pen_id erzeugt keinen entsprechenden Tierverstoß. Luna ersetzt Bauteile durch summarische Bools.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 2: „Stall“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 5: „alle Tiere“.

## o6_21-ACTUAL_WEIGHT_SPACE_ALL_OCCUPANTS_AND500_BOUNDARY

Welche datierte tatsächliche maximale Boxbelegung einschließlich nicht geförderter Kühe und Gewichtswechsel gilt? 40 % beziehen sich auf erforderliche Gesamtfläche; Kühe 6/2,4 m². Original bis 500/ab 500 überlappt exakt bei 500 kg: zuständige Auslegung einholen, keine stillschweigende Grenze. Negative/unbekannte Gewichte und Besatz nicht als gültig behandeln.

**Anlass:** Beide Runs wählen exakt 500 kg in der unteren Klasse. Luna fehlendes Gewicht wird 0; Opus fehlende unbekannte occupant.kind lässt sich aus der Summe entfernen. Tier-/Box-Gewichtsscope nicht bewiesen.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 4: „bis 500 kg“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 4: „ab 500 kg“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 5: „12 Mutterkühen“.

## o6_21-BEDDING_OPEN_EXAMPLES_ACTUAL_LEGAL_CUBICLE_EXCEPTION

Welche echten Liegeflächen, 5-%-Perforation, Einstreu und dauernde Trockenheit belegen die Pflichten? Die Materialliste ist offen, kein geschlossenes Enum. Mutterkuh-Liegeboxenausnahme benötigt tatsächliche THVO-/Tierschutzgesetz-Nachweise, alle >6-Monats-Tiere eigene Box sowie Kälberschlupf; freie Erfüllt-Bools reichen nicht.

**Anlass:** Opus fehlende negative Baubools fallen aus; cubicle-Bools ersetzen gesetzliche Details, Kälberschlupf kann fehlen. Luna kein tatsächlicher Liegeboxen-/Kälberschlupfscope.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 4: „frei wählbar“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 5: „Tierschutzgesetz“.

## o6_21-SKETCH_UNTIL2024_VERSUS_ACTUAL_BUILDING_PROOF

Wie wird das Ende von Stallskizze/Belegungsplan ab 2025 vom weiter notwendigen tatsächlichen Flächen-/Haltungsnachweis getrennt? Historische Vermessung und maximal mögliche Belegung bis 2024 beachten, keine tagaktuelle Dokumentpflicht erfinden.

**Anlass:** Beide Runs haben Jahresübergang; Luna fehlendes Jahr 0 erzwingt historischen Plan. Ab 2025 bedeutet keine formale Skizze, nicht Freigabe ohne konkrete Boxfläche.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 6: „Ab dem Antragsjahr 2025“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 6: „tagaktuelle“.

## o6_21-ACTUAL_SINGLE_HOUSING_HEALTH_AND_CALF_EXCEPTION

Welche tatsächlichen tierbezogenen Krankheits-/Verletzungsperioden, Notwendigkeit, Dauer, Einstreu und Dokumente gelten? Maximal 10 Tage Gesundheitsausnahme von eigenständiger Ausnahme für Kälber unter 21 Tagen mit Sozialkontakt trennen; allgemeiner group_housed=false darf zulässige Ausnahme nicht wieder ausschließen.

**Anlass:** Luna lehnt >10 Tage auch bei erlaubter Kälberhaltung ab. Opus erkennt die Einzelhaltungsfunktion, erzeugt aber daneben bei group_housed=false den allgemeinen Gruppenverstoß mit Ganzjahresausschluss.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 6: „maximal 10 Tage“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 6: „unter 21 Tagen“.

## o6_21-IMMEDIATE_EAR_TAG_REPORT_FULLYEAR_EXCLUSION_AND_SALE

Welche tatsächlichen Verstoßbeginn-/Kenntnis-/Meldeereignisse verbinden Ohrmarke und alle beantragten Kategorien? Pflichtverstoß im Kategorienfenster schließt Tier für ganzes Förderjahr aus; tatsächlicher Verkauf/Tod/Schlachtung nur zeitanteilige Bestandsberechnung. Behördliche Abmeldung und Datum nachweisen, nicht nur ein Bool.

**Anlass:** Luna freie Durchschnitts-RGVE bleiben trotz gemeldeter Nichtkonformität zahlbar. Opus breach_start fehlt → Jahresbeginnannahme; keine tatsächliche sofortige Meldedauer oder Registerstichtagsprüfung.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 8: „für beide“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 8: „anteilsmäßig“.

## o6_21-ALL_SPECIES_MANURE_ACTUAL_WINDROW_METHODS_AND_DATES

Welche tatsächlichen Mieten umfassen sämtlichen Festmist aller Tierarten? Zwei wirkliche Umsetzungen mindestens 14 Tage auseinander, vollständige Umsetzung und Geräte-/Fremdrechnungsnachweise. Gemischt/geschichtet erst 2025; nennenswerte Beimengung und Verfahren getrennt, 50:50 ist Beispiel. Gültigkeitsbeginn der zusätzlichen wendefreien Alternative klären.

**Anlass:** Luna gemischte Methode auch 2024 zulässig ohne tatsächliche Pflanzenkomponenten. Opus wenigstens ein Datumpaar und freie Material-/Verfahrensbools, keine tatsächlichen Quellen/Mengen; Alternative from_year=2023 ist Annahme.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 6: „unabhängig von der Tierart“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 7: „Antragsjahr 2025“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 7: „50:50“.

## o6_21-ACTUAL_COMPOST_RECORDS_NAPV_AND_OPTIONAL_PAYMENT_SCOPE

Welche tatsächlichen Anlage-/Umsetz-/Ausbringungs- oder Abgabedokumente und NAPV-Prüfungen gelten? Kompoststall ausgeschlossen. Fehlende/ungültige Zuschlagdaten sollen kein bestätigter Zuschlag sein; klären, ob ausschließlich Zuschlag oder weitere amtliche Sanktion betroffen ist.

**Anlass:** Luna zahlt 21,6 €/RGVE bei angekreuztem Zuschlag trotz Kompostverstoß. Opus blockiert Zuschlag bei erfassten Verstößen, lässt fehlendes napv_compliant aber nicht als unknown stehen.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 7: „Abgabe an Dritte“.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 7: „Kompostställe“.

## o6_21-ACTUAL_PER_TIER_REDUCED_RATE_OVERLAP_AND_SOURCE21

Welche echten tierbezogenen Prämienanträge verbinden Alm14, Weide20 und gekoppelte Almstützung? Original SRL Weide(21) fachlich klären. Reduzierter Satz auf gesamte Tier-Jahres-RGVE oder überlappende Zeit? Almauftrieb allein ist nicht derselbe Nachweis wie tierbezogene Prämienbeantragung.

**Anlass:** Luna reduziert gesamten Betrieb aus einem Bool. Opus reduziert Tier wegen alm_driven ohne bestätigten Prämienantrag; angenommener Ganzjahresscope offen.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 11: „tierbezogener“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 87: „Weide“.

## o6_21-UNKNOWN_PERSON_MISSING_PROOFS_VIOLATIONS_AND_PAYMENT

Welche allgemeinen Voraussetzungen, heutigen Pflichtdaten, Modulation, Kontroll-/Sanktionsentscheidungen und Kleinbetragsregeln müssen vor bestätigter Aufnahme/Zahlung erfüllt sein? Unbekannter Wert, theoretische Jahreshochrechnung, Nachweisverstoß und amtlich zahlbar getrennt ausgeben.

**Anlass:** App bleibt Category C missing_data. Opus positive Prämie trotz fehlendem Heimstall/TGD/Qplus möglich; fehlendes Erstjahr und falscher Personenshare können Prüfung umgehen. Allgemeine Sanktionshelper sind kein durchgängiger Prämienpfad.

Original `sources/oepul/originals/o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf`, PDF-Seite 11: „prämienfähigen“.
