# o6_15: offene Fachentscheidungen

Alle Fragen bleiben offen. Bestehende vorläufige IDs im Sammelissue werden weder entfernt noch geschlossen.

## o6_15-CURRENT_CONTRACT_ALM14_COMBINATION_REENTRY_AND_EXIT

Welche bestätigten Jahresverträge, MFA-, Ausstiegs-, Korrektur- und Übernahmeereignisse bestätigen die heutige Teilnahme an o6_15 und gleichzeitig o6_14? Die jährlichen 3 RGVE bei o6_15 vom Erstjahresminimum bei o6_14 trennen. Welche Anerkennung braucht ein verspätetes Wiedereinstiegsersuchen? Maßnahmen-/Hundeeinstieg bis 2027/2028, Verlängerung und aktuelle Hostzeit gesondert prüfen; farm.*, oepul_participation.* und alpine_farming.* bleiben ohne bestätigte Zuordnung.

**Anlass:** Luna verbindet seine Hilfsregeln nicht zu einer Gesamtentscheidung. Opus akzeptiert beliebige alte Vertragsstarts ohne früheren Antrag und behandelt ein spätes Ersuchen als gültigen Wiedereinstieg. Teilnahme an o6_14 gegenüber tatsächlicher Prämie, einschließlich Nationalpark-Fällen, bleibt offen.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 1: „zeitgleich“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 5: „erlischt der Vertrag“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 6: „fristgerechte Anerkennung“.

## o6_15-PERSON_FIRST_OEPUL_FULL_MFA_AND_PAYMENT_PROOF

Welche aktuellen Almbewirtschafter-, Personen-, Verfügungs- und vollständigen Erstjahres-MFA-Nachweise gelten? Zahlungs-/Listenjahr, tatsächliche Hirten, Kategorien und Hunde sowie die 15./17.-Juli-Fristen belegen. Tierauftrieb bis 15. Juli separat prüfen. Wie lautet der Empfehlungsstatus bei fehlendem Zahlungsantrag? App behirtung_days bestätigt keine Dauer je Tier oder Alm.

**Anlass:** Die App erfasst nur Tage und Fläche. Opus meldet fehlenden Zahlungsantrag, lässt eligible und den Betrag positiv; first_oepul_year=0 überspringt unbekannte Erstjahrespflichten.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 1: „vom Almbetrieb“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 4: „gilt als Zahlungsantrag“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 5: „15. Juli aufgetrieben“.

## o6_15-COMPLETE_HERDED_CATEGORY_ALL_REAL_ANIMALS

Welche vollständigen Tier-, MFA-, Ohrmarken-, Kategorie- und Almstände bestätigen die Behirtung aller Tiere jeder beantragten Kategorie? Milchkühe, sonstige Rinder, Schafe, Ziegen, Equiden und Neuweltkamele unterscheiden. Nicht beantragte Heimtierarten sind gesondert zu behandeln. Fehlende Behirtungsdaten sind unbekannt; Gruppen-count und Teilmeldungen bestätigen keine vollständige Kategorie.

**Anlass:** Luna konsumiert herded_category_complete nicht und prüft die Arten sämtlicher Heimgruppen. Opus setzt fehlendes is_herded/kept_in_austria auf true; ein unbehirtetes Tier der beantragten Kategorie meldet einen Verstoß, lässt aber Restbetrag und eligible stehen.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 2: „alle Tiere je“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 5: „einzeltierbezogen“.

## o6_15-ACTUAL_DATED_TIER_STAYS_ALM_CALENDAR_UNION_AND_AS_OF

Welche tatsächlichen überlappungsfreien Aufenthalts-, Behirtungs- und Unterbrechungsereignisse mit Alm-ID gelten im aktuellen Jahr bis host.as_of? 60 Tage je Tier und Kalenderunion je Alm trennen: Auftriebstag zählt, Abtrieb nicht. Weitertrieb anteilig zuordnen. total_alpine_days_all_herded_alms, stocking_days und pro_rata_factor dürfen keinen Nachweis ersetzen. Zukünftiger Abtrieb bleibt eine begründete Notiz.

**Anlass:** Luna nutzt Tageaggregate trotz datierter Vorschläge. Opus begrenzt Aufenthalte nicht auf Jahr oder Host-Stichtag und akzeptiert frei vorgegebene Gesamttage. Eine Tier-ID kann ohne echte Gesamtdauer mehreren Almen voll zugerechnet werden.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 3: „hintereinander“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 3: „Unterbrechungszeiten“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 3: „anteilig“.

## o6_15-ACTUAL_REPORT_DATES_CREDIT_MILK_FLAG_AND_CORRECTIONS

Welche bestätigten 7-/14-Tage-Auftriebs-, Abtriebs- und Korrekturereignisse sowie Listen-/Registerstände gelten? Verspäteter Auftrieb verkürzt die Gutschrift. Milchkennzeichen: 14 Tage für Rinder, 7 für Schafe/Ziegen und dort spätestens 15. Juli. Abkalbung und 45 Milchtage erst nach tatsächlichem Nachweis. Bei Equiden/Kamelen geplanten und tatsächlichen Abtrieb vergleichen; fehlendes Meldezeitdatum bleibt unbekannt.

**Anlass:** Luna akzeptiert selbst gesetzte deadline_days und konsumiert Ohrmarken-, Milchkennzeichen- und Korrekturdaten nicht. Opus gewährt bei fehlendem Auftriebsmeldedatum volle Tage und betrachtet fehlendes Milchkennzeichendatum als fristgerecht.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 5: „maximal 14 Tage“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 5: „danach ist eine Änderung“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 5: „keine Nachmeldung erforderlich“.

## o6_15-JULY1_RGVE_MILK_AGE_CALVING_QUANTITY_AND_SPECIES_IDS

Welche Geburts-, Rassen-, Größen-, Abkalbungs- und Milchereignisse bestätigen die Kategorie am 1. Juli? Stamm-ID und tatsächliche Einzeltierzahl statt fremder RGVE-Kategorie oder freiem gve. 45 Milchtage über behirtete Almen prüfen. goat/goats, equid/equine/equines und camelid/new_world_camelid haben keinen bestätigten Alias. Allgemeine GVE-Zeilen für Schweine/Wild begründen keine Alm-RGVE.

**Anlass:** Lunas Milchalter-/Kalbehelper sind nicht mit dem Betrag verbunden. Opus lässt eine explizite RGVE-Kategorie unabhängig von Tierart/Alter gewinnen und erlaubt beliebige count auch bei Rindern; unbekannte Equidengröße wird zur kleinen Klasse.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 2: „mindestens 45 Tage“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 2: „Am Stichtag 1. Juli“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 8: „RGVE-SCHLÜSSEL“.

## o6_15-HERDER_IDS_SINGLE_ALM_BLOCKS_CAPACITY_MILK_ALLOCATION

Welche tatsächlichen Personen-, Alm-, Jahres-, Listen- und Behirtungszuordnungen bestätigen höchstens 50 RGVE je Hirte und erhöhte erste 20 RGVE je 50er-Block? Wie wird eine unzulässige Mehralmzuordnung behandelt? Keine erste Alm aus lexikalischer ID erfinden. Milchzuordnung und Priorisierung der Blöcke fachlich bestätigen; declared_herder_count mit realen Listenpersonen verknüpfen.

**Anlass:** Luna berechnet global erste 20 RGVE ohne Hirtenkapazität. Opus wählt bei Doppelperson min(alm_id), priorisiert Milchvieh als Modellannahme und meldet count-Abweichung nur als Verstoß. Beispiel 1 ergibt 9.909 Euro, bestätigt aber keine vollständige Methode.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 4: „nicht zulässig“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 7: „maximal 50 RGVE“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 7: „pro 50 RGVE“.

## o6_15-DOG_IDS_CERTIFICATE_INSURANCE_WHOLE_PERIOD_ONE_ALM

Welche Hunde-ID, gültiges Österreichzentrum-Zertifikat, Versicherung, Herdenbindung, Tag-/Nachtanwesenheit, selbstständige Arbeit und Listenbeantragung bestätigen den Zuschlag? Aufenthaltsunion: mindestens 60 Tage auf einer Alm und gesamte Alpungsdauer; derselbe Hund nur eine Alm, höchstens fünf. Antrag und Hundevertrag datieren. present_whole_period/claimed_on_other_alm sind keine Belege.

**Anlass:** Luna bezahlt eine aggregierte Hundezahl trotz fehlendem Zertifikat und count über fünf, weil dog_valid kein Zahlungsgate ist. Opus prüft IDs und Deckel, braucht aber tatsächliche Aufenthalte und behandelt ein fehlendes Zuschlagsantragsdatum als zulässig.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 4: „nur für eine Alm“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 4: „Österreichzentrum Bär, Wolf, Luchs“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 7: „max. 5 Hunde“.

## o6_15-ALM_GIS_DEFINITION_FULL_CARE_ACCOMMODATION_AND_DOMESTIC

Welche GIS-, Kataster-, Feldstück-, Heimbetriebs-, Grenz- und Teilflächenbelege sowie tatsächlichen täglichen Betreuungsnachweise gelten? Wasser, Pflege, Behandlung, Sicherung, Weidelenkung und nötige Nachtversorgung erfassen; reine Nachschau reicht nicht. Geeignete Unterkunft ist erforderlich, tatsächliche Nächtigung nicht immer. Heimparzellen nicht pauschal zu Almen machen; fehlende Lage bleibt unbekannt.

**Anlass:** Luna erfüllt Betreuung/Unterkunft bei leerer Landliste automatisch. Opus verbindet acht Betreuungsgates, setzt aber fehlende Inlands-/Heimbetriebsflags günstig; farm eligible bleibt selbst bei sämtlich gesperrten Almen und Betrag null true.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 2: „nicht vom Heimgut“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 3: „reine Nachschau“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 3: „Nächtigung auf der Alm ist aber nicht“.

## o6_15-ORIGINAL_PREMIUM_EXAMPLE_CONFLICT_ROUNDING_AND_TOPUP

Wie wird das widersprüchliche Originalbeispiel fachlich bestätigt? MB 8 bezeichnet 20×81+30×27 als 2.295, rechnerisch sind es 2.430; Gesamtsumme 12.534,60 gegenüber 12.669,60. Original erhalten, keinen Modellbetrag als Golden-Oracle festlegen. Allgemeines 230-ha/250-RGVE-Beispiel: 98,66 % gegenüber Formel 98,70 %. Landeszuschlag 40 Euro/RGVE: konkretes Land, Gewährung, Meldung bis 15. Mai, rechtzeitige Mittel und Kürzung belegen.

**Anlass:** Opus korrigiert rechnerisch und priorisiert Milchvieh als Annahme. Landeszuschlag beruht auf zwei Booleans ohne Land/Datum. Luna hat keine vollständige Alm-/Hirtenrechnung oder Modulation; korrekte Tarife allein reichen nicht.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 8: „2.295,0“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 8: „12.534,6“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 20: „98,66 %“.

Original `sources/oepul/legal/20241011_srl_oepul_2023.pdf`, PDF-Seite 18: „40 Euro/RGVE“.

## o6_15-MODULATION_SHARED_ALM14_BASIS_AND_OTHER_FUNDING

Welche vollständigen aufgetriebenen RGVE und Almflächen aus o6_14 bilden die Modulation von o6_15, unabhängig von nur behirteten Tieren und getrennt vom Heimgut? Minimum der Gesamtsummen gegenüber Summe der Einzelalm-Minima wie bei o6_14 klären. stocked_rgve braucht Nachweis. Andere öffentliche Behirtungsförderung je Pflicht, Tier, Alm und Jahr prüfen, nicht durch bloßen Programmstring ersetzen.

**Anlass:** Opus akzeptiert stocked_rgve als Override oder verwendet nur erfasste Tiere und die Summe der Einzelalm-Minima. Luna führt seinen Modulationskatalog nicht aus. participating_in_year bestätigt keine aktuelle o6_14-Flächen-/Tierbasis.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 20: „unabhängig von der Anzahl der behirteten RGVE“.

Original `sources/oepul/originals/o6_allgemeine_teilnahmebedingungen_2026_04.pdf`, PDF-Seite 19: „getrennt vom“.

## o6_15-UNKNOWN_VIOLATIONS_AMOUNT_CONTROL_FORCE_MAJEURE_SCOPES

Wie werden unbekannte Pflichtnachweise, amtliche Verstöße, Kontrolle, Sanktionen und Dürreentscheidungen von theoretischem Betrag und aktueller Empfehlung getrennt? Antrag ist keine Genehmigung; keine 60-Tage-Ausnahme erfinden. Vollkürzung und dauerhafte Umstände mit Datum, Pflicht und Alm verknüpfen. Ein positiver Betrag ohne bestätigte Gates begründet keine App-Aufnahme.

**Anlass:** Luna bietet unverbundene Helper im Paket opul statt oepul. Opus konsumiert obligation/deadline/sanction/force-majeure nicht vollständig; payable bleibt trotz fehlendem Zahlungsantrag, falschem Milchkennzeichen oder Teilbehirtung positiv.

Original `sources/oepul/notices/2026/2026-05-22__trockenheitsbedingte-ausnahmeregelungen-fuer-oepul-biodiversitaetsflaechen.html`, HTML-Artikel: „kann auch ein Antrag auf höhere Gewalt gestellt werden“.

Original `sources/oepul/originals/o6_15_tierwohl-behirtung_2026_04.pdf`, PDF-Seite 1: „Verpflichtungs- und Vertragszeitraum“.
