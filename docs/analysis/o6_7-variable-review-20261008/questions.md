# o6_7: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_7-PROFILE_ROOT_PARTICIPATION_AND_CONFLICT

Welcher einzelne verbindliche Maßnahmen-/Vertragsdatensatz gilt mit MFA-Code, Anerkennungs-/Wirksamkeitsdatum und aktuellem Host-Jahr/Snapshot? Luna farm.oepul und measure.o6_7 nicht stillschweigend überlagern. Wie werden Widerspruch, fehlende Teilnahme und o6_6/o6_7-Ausschluss behandelt?

**Anlass:** Luna ohne measure.o6_7 ignoriert farm.oepul-Teilnahme, mit leerem Wrapper wird sie erkannt. Opus kann ohne eigenen Maßnahmen-/Bewerberdatensatz measure_valid und positive Prämie liefern.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 9: „Eine gleichzeitige Teilnahme des Betriebes“.

## o6_7-COMPLETE_ALL_ARABLE_DAILY_DENOMINATOR

Welche vollständige MFA-/Schlagliste, eindeutige IDs, Flächen- und Eigentums-/Bewirtschaftungsstände gelten täglich für die 85%-Prüfung? Sämtliche Ackerflächen einschließlich Grünbrache, Sonstige, geschütztem Anbau, NAT/EBW/K20 einbeziehen. Erlaubte Mess-/Rundungspräzision und Ursächlichkeit einer unbegrünten Hinzunahme nach 15.10. bestätigen, keine unvollständige Liste als vollständigen Betrieb behandeln.

**Anlass:** Opus bevorzugt Summe der gelieferten Schläge gegenüber land.arable_area_ha; 2 ha aus einem 100-ha-Aggregat werden alleinige Basis. Jede spät erworbene unbegrünte Fläche wird ausgeschlossen, ohne Ursächlichkeit zu prüfen. App prüft nur eine undatierte Aggregatquote.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 3: „zählen sämtliche Ackerflächen zur“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 3: „und dadurch die Auflage“.

## o6_7-CHRONOLOGY_FULL_GAP_AND_AS_OF

Welcher belegte Kulturverlauf einschließlich Vorjahr, aktueller Teilernte, Untersaat-Ernte, Haupt-/Zwischenfrucht und NAT-Wiederbegrünung wird benötigt? Nach Fristüberschreitung gesamten betroffenen Lückenzeitraum berücksichtigen; bei offenem Jahresende unbekannt/provisorisch ausweisen. Wie werden negative/überlappende/fehlende Ereignisse und noch zukünftige Abschnitte getrennt?

**Anlass:** Opus korrekt bestätigter 40-Tage-Lücke gegenüber am Jahresende nur Tage nach einer 50-Tage-Kulanz als unbegrünt; Jahresende wird ohne as_of komplett bewertet. Feste Luna-Tagesnummern 288/263/304 verschieben Kalendergrenzen in Schaltjahren.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 3: „zählen diese in dem betroffenen Zeitraum als unbegrünt.“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 4: „in den 40 Tagen zur unbegrünten Fläche“.

## o6_7-SHORT_CATCH_CROP_AND_RECLASSIFICATION

Wie wird eine Zwischenfrucht unter 42 Tagen mit gesamten Bodenlücken davor/danach behandelt? Bitte gesondert bestätigen, ob auch bei unter 50 Tagen Hauptfrucht-zu-Hauptfrucht die nicht anrechenbare Zwischenfrucht und offenen Tage vollständig unbegrünt sind. MFA-Anmeldung macht eine Kultur zur Hauptfrucht, tatsächlichen Drusch/Doppelnutzung nicht nur umbenennen; Zug-um-Zug und frühe Umbruchfälle belegen.

**Anlass:** Opus entfernt die ungültige 41-Tage-Zwischenfrucht, schließt danach die Lücke zwischen Hauptfrüchten bei <=50 Tagen vollständig. Der Originalbeispieltext beschreibt alle Zwischen-/offenen Tage als unbegrünt.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 5: „zählen sowohl die 41 Tage Zwischenfrucht als“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 8: „sondern um eine Hauptfrucht.“.

## o6_7-MIXTURE_WINTER_HARDINESS_AND_PRECONTRACT

Welche belegten tatsächlichen Partner/Familien, Anteile und aktuellen Saatgut-/Grünschnittroggensorten gelten? 3 Partner/2 Familien bis 20.9., späte winterharte Reinsaat, vor 2025 ausschließlich winterhart und ab 2025 abfrostende Komponenten <50%; SRL/MB-Lesart und Mischung vor Ersteinstieg bestätigen. Keine Modellbools/Kataloge ohne Herkunft; Prozent 0–100 vs. Verhältnis 0–1 explizit unterscheiden.

**Anlass:** Luna hat vor 2025 keine Winterhärteprüfung. Viele vorgeschlagene Mischungseigenschaften werden nicht konsumiert; Opus hat Defaults und nimmt frühe/späte Vorvertragsmischung als Alternative an.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 5: „ausschließlich“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 5: „unter 50 %“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 4: „Die Mischungspartner müssen jedoch bereits“.

## o6_7-NAPV_AUTHORITY_END_AND_DATED_N

Welches aktuelle kultur-/regions-/jahrbezogene NAPV-Enddatum im Folgejahr wird aus einer verbindlichen Quelle abgeleitet? Alle mineralischen N-Ereignisse inkl. Saatdüngung datieren; nicht vom Umbruchdatum oder globaler Jahresmenge auf Verbot/Erfüllung schließen. Fehlendes Enddatum bleibt offen.

**Anlass:** Opus fehlendes NAPV-Enddatum nimmt Umbruchdatum als Ersatz; N am Folgetag wird nicht verletzt. Luna konsumiert globale mineral_n_kg_per_ha statt vorgeschlagener datierter Perioden.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 5: „gemäß Nitrat-Aktionsprogramm-Verordnung im“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 5: „Folgejahr. Auch eine kombinierte Düngung“.

## o6_7-CARE_MECHANICAL_REMOVAL_AND_EVENT_EFFECT

Welche datierten Pflege-/Walz-/Beseitigungsereignisse mit Regrowth, Frost, Boden-/Flächeneffekt und Beleg verändern den tatsächlichen Begrünungsabschnitt? Anlagetag einschließen. SRL/MB-Walzspannung und Bedeutung unmittelbar bestätigen; keine selbst erfundene 1-Tages-Frist. Bodennaher Schnitt ohne Nachwuchs beendet die Begrünung und startet 30-Tage-Frist.

**Anlass:** Opus in_period schließt den Anlagetag aus; Messerwalze dort bleibt ungemeldet. Regrowth-Verlust erzeugt Verstoß, ändert aber nicht tägliche Begrünung. reconsolidation maximal 1 Tag ist Modellannahme.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 6: „Ebenso dürfen Messerwalzen nicht eingesetzt werden“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 7: „ab der Ernte als begrünungsfreier Zeitraum.“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 6: „unmittelbar nach der Anlage“.

## o6_7-PSM_POST_REMOVAL_AND_FOLLOWING_MAIN_CROP

Wie werden vollständige datierte PSM-Anwendungen und tatsächlich mechanische Beseitigung/Folgesaat belegt? Auf Zwischenfrüchten ab Anlage bis Umbruch; ohne mechanische Beseitigung erst nach Folgesaat. Fehlende Folgesaat darf die Prüfung nicht überspringen. Drusch/Feldfutter/MFA-Status und tatsächliche Hauptfrucht nicht über globale Flags ersetzen.

**Anlass:** Luna globales psm_used führt zu zeitlich unspezifischem Verstoß. Opus Vergleich nach nichtmechanischem Ende wird bei fehlendem following_main_crop_sowing_date undefiniert.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 6: „erst nach der Saat der Folgekultur zulässig.“.

## o6_7-DROUGHT_PARCEL_PROOF_AND_RETAINED_DEADLINES

Welche aktuellen datierten schlagbezogenen Dürre-/Ansaat-/Aufgangs-/Ausfallgetreide- und vorausschauenden Bewirtschaftungsbelege gelten für 2026? 30/50-Tage-Erleichterung von weiterhin geltenden 42 Tagen/Mischungs-/Anlagefristen trennen; tatsächlichen frühestmöglichen Nachholtermin noch im aktuellen Antragsjahr belegen. Nicht aus einem globalen Ausnahmeflag die ganze betriebliche Jahresquote freistellen. Ernteausnahme mit Dürregebiet, Kulturzeitraum und nicht erntbarem Bestand separat bestätigen.

**Anlass:** Luna ordnungsgemäße Anlage/fehlender Aufgang lässt cover_share_percent=0 passieren, ohne betroffene Schlagbasis. Opus verwendet schlag-/segmentbezogene Ausnahmen, aber die Ernteausnahme prüft keinen üblichen Spätsommer-/Herbsterntezeitraum. Aktuelle Meldungen bleiben erforderlicher Beleg, nicht generelle Jahresfreigabe.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 2: „Grundsätzlich sind alle Maßnahmen zu ergreifen“.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „zum frühestmöglichen Zeitpunkt noch im aktuellen Antragsjahr“.

Original `sources/oepul/notices/2026/2026-08-12__duerre-2026-erleichterungen-in-der-oepul-foerderungsabwicklung.html`, HTML-Artikel: „Auch die Mindestanlagedauer (42 Tage)“.

## o6_7-COMPLETE_RECORDS_AND_ACTUAL_HISTORY

Wie werden laufende schlagbezogene Termine und Nachweise für ganze Ackerfläche und 1.1.–31.12. erfasst, mit aktuellem Datenstand und noch offenen zukünftigen Ereignissen? Ein fehlendes Aufzeichnungsobjekt/ein DEFAULT true ist keine Bestätigung. Beantragung Hauptfrucht/Zweitkultur und echte Ernte-/Umbruch-/Saatereignisse mit Version/Experten- oder Betreiber-Snapshot verbinden.

**Anlass:** Luna dokumentierte o6_7_field_records-Flags werden nicht direkt konsumiert. Opus Aufzeichnungsdefaults true und nicht vorhandenes globales field_records_complete lösen keinen fehlenden Datenstatus aus.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 9: „unabhängig von den 85 %“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 9: „durchgängig bis zum 31. Dezember“.

## o6_7-WITHDRAWAL_REENTRY_SWITCH_AND_NEXT_YEAR_ES

Welche datierte Abmeldung/Vertragserlöschung, wirksame Neu-/Umstiegsbeantragung und Folgejahres-ES-Acker-Sperre gelten? Echte Rückkehr nach Ausstieg oder fehlendem MFA benötigt Antrag. Aktuellen Vertragsstand vor positiver Gültigkeit prüfen; keine automatische Folgejahresfreigabe aus alter Teilnahme.

**Anlass:** Opus Abmeldung nur im Bewertungsjahr sperrt measure_valid; Vorjahresabmeldung nicht. Reentry-Verstöße bleiben außerhalb Prämiengate; Modellnotiz prüft ES-Sperre im selben Jahr, Original spricht vom Folgejahr.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 10: „Es ist ein neuer fristgerechter Maßnahmenantrag“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 10: „im Folgejahr nicht mehr teilgenommen werden.“.

## o6_7-PAYMENT_BASE_APPROVED_RATE_AND_OPEN_STATUS

Wie werden tägliche Begrünungsbasis, prämienfähige Fläche und theoretisches 70–90-Euro-Band mit behördlich bestätigtem Satz/Modulation/Sanktion unterschieden? Grünbrache/DIV-Prämienlesart, NAT/EBW/K20-/Anhang-L-Kombination, OP/NP/Fremdland, 2024-NPF und aktuelle Quellen bestätigen. Fehlende/beeinträchtigte Daten dürfen keine vollständige Empfehlung/gesicherte Auszahlung erzeugen.

**Anlass:** Opus measure_valid/premium bleiben bei eigenen-Rechnung-Verstoß und daily coverage fail positiv; nicht als automatische Sanktion uminterpretieren. Ohne bestätigt jährlichen Satz Mindestbetrag, auch bei ungültigem geliefertem Satz; Grünbrache-Ausschluss ist offen dokumentierte Modelllesart.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 10: „Garantiert ist dabei“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 3: „NAT“.

Original `sources/oepul/originals/o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf`, PDF-Seite 10: „Variante 1 NPF bis Variante 6 NPF“.
