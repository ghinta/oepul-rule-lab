# o6_5: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_5-luna-high-20261002`

# Fachliche Annahmen und offene Punkte

- Die Maßnahmenblätter sind als ausführliche AMA-Aufbereitung gekennzeichnet; die rechtlich verbindliche Grundlage ist die Sonderrichtlinie. Widersprüche wurden zugunsten der Sonderrichtlinie beziehungsweise des ausdrücklich späteren 2026-Hinweises behandelt.
- Die 2026-Ausnahme wird für `input.year == 2026` als Haltedatum 31.08. modelliert. Tierbewegungsmeldungen für Nicht-Rinder bleiben bis 31.12. relevant; eine Nachbesetzungsmeldung nach 31.08. wird nicht verlangt. Die genaue fachliche Abgrenzung, ob eine Nachbesetzung nach dem verkürzten Haltungszeitraum überhaupt noch verlangt wird, ist im Hinweis sprachlich nicht weiter ausdifferenziert und bleibt als offene Auslegungsfrage dokumentiert.
- Datumsarithmetik wird in der Rego-Schnittstelle als bereits berechnetes Feld `days_until_replacement` beziehungsweise `reported_within_days` erwartet. Das vermeidet eine nicht durch die Quellen belegte Kalenderarithmetik im Regelwerk.
- Der 2026-Hinweis spricht von Tierbewegungsmeldungen bis Jahresende, während das Maßnahmenblatt die 7-Tage-Abgangsmeldung an die vorgeschriebene Haltedauer knüpft. Die ausführbare Regel erhält deshalb für Nicht-Rinder eine Meldung bei dokumentiertem Abgang bis zum Jahresende und führt die 7-Tage-Frist als eigenes Prüffeld.
- Die Prämienfunktion leitet Prämienstufe und GEP-Zuschlag aus der Rassenliste ab. Für Rinder wird der Zuschlag Milchleistungskontrolle nur bei `milk_control == true` addiert; die Datentabelle enthält wegen der Jahrgangsstaffelung die veröffentlichten 2023- und ab-2024-Sätze.
- `data/o6_5_tables.json` ist als flache JSON-Datei unter `data/` geladen; daher referenziert Rego `data.breeds` und `data.premiums_eur_per_animal`, nicht einen zusätzlichen Dateinamen-Namespace.
- Das Canonical Farm Profile enthält keine Einzeltiere. Die vier Änderungen in `rules/profile_changes.json` sind deshalb Discover-Vorschläge und keine behaupteten Bestandswerte.


## opus: `v2-o6_5-opus-5.5-high-20260925`

# Annahmen und offene Fragen – o6_5 „Erhaltung gefährdeter Nutztierrassen“

Run: `v2-o6_5-opus-5.5-high-20260925` · Modus: `discover`

Quellen: Informationsblatt o6_5 (Stand Oktober 2025), Allgemeine Teilnahmebedingungen
(Stand April 2026), Sonderrichtlinie ÖPUL 2023 inkl. Anhänge (Stand 2024-0.489.174),
vier AMA-Hinweise 2026. Rechtsverbindlich sind die Sonderrichtlinie und ihre Anhänge;
bei Abweichungen gilt die Sonderrichtlinie vor dem Informationsblatt (O6_5-GEN-LEGAL-BASIS).

## Eingabemodell

- **A-01 Profilerweiterungen.** Das Canonical Farm Profile kennt keine Einzeltiere,
  keine Angaben zur förderwerbenden Person und keine Vertrags- bzw. Antragsdaten. In
  `rules/profile_changes.json` werden deshalb vorgeschlagen:
  `livestock.endangered_breed_animals`, `farm.applicant`, `oepul_participation`,
  `land.protected_cultivation_area_ha`, `documentation.inspection_refused`,
  `documentation.inspection_refusal_force_majeure` und `documentation.vis_reports_complete`.
  Die Rego-Regeln lesen genau diese Pfade.
- **A-02 Antragsjahr.** `farm.year` ist das Antrags- bzw. Förderjahr.
- **A-03 Fehlende Eingaben.** Fehlen tierbezogene Pflichtangaben (z. B. `on_farm_from`,
  Geburtsdaten, Bestätigung der Zuchtorganisation), gilt die jeweilige Voraussetzung als
  nicht erfüllt. Das ist konservativ; das Tier erscheint dann mit der passenden Regel-ID
  in `failures`.

## Auslegungen der Tieranforderungen

- **A-04 Bezugsdatum für Ersatztiere.** Laut SRL 2.5 müssen Ersatztiere „alle
  Förderverpflichtungen zum Zeitpunkt der Nachbesetzung“ erfüllen. Geprüft wird daher
  zum späteren der beiden Zeitpunkte: Stichtag 01.04. bzw. 31.05. oder Nachbesetzungsdatum
  (`requirement_ref_ns`).
- **A-05 „Mindestens jeder 2. Wurf reinrassig“.** Ausgelegt als: Anteil reinrassiger Würfe
  mindestens 50 % aller Würfe (`litters_purebred >= 0,5 * litters_total`). Eine strengere
  Lesart („keine zwei aufeinanderfolgenden nicht reinrassigen Würfe“) ist möglich, lässt
  sich mit den vorhandenen Eingaben aber nicht abbilden. **Offen.**
- **A-06 Abfohlintervall 3,5 Jahre.** Geprüft wird, ob zum 31.05. des Antragsjahres
  (bzw. zum Nachbesetzungsdatum) höchstens 42 Monate seit der letzten Abfohlung vergangen
  sind. Fehlt `last_foaling_date`, wird `first_offspring_date` verwendet.
- **A-07 Altersgrenzen.** Monatsarithmetik mit `time.add_date`; eine Geburt am selben
  Kalendertag gilt als erreichtes Alter. „Älter als 5 Jahre“ beim Hengst ist strikt
  auszulegen (> 5 Jahre).
- **A-08 Jährlicher Zuchteinsatz.** Die Ausnahme „im Jahr der Zulassung zur Zucht“ wird
  über `breeding_approval_year == farm.year` abgebildet. Für Zuchthengste verlangt die
  Tabelle keinen jährlichen Zuchteinsatz, nur einen regelmäßigen sowie den Nachweis eines
  Nachkommen ab 5 Jahren.
- **A-09 Zuchtbuch/Herdebuch.** Das Informationsblatt spricht von „Zuchtbuch“, die SRL beim
  Hengst von „Herdebuch“. Beide Begriffe werden gleichgesetzt.

## Haltedauer, Abgang, Nachbesetzung

- **A-10 Abgang am letzten Tag.** Ein Abgang am letzten Tag der Haltedauer (31.12. bzw.
  2026: 31.08.) zählt als Abgang innerhalb der Haltedauer, weil die Haltung „bis
  einschließlich“ dieses Tages verlangt ist.
- **A-11 Fünf-Wochen-Frist.** Die Frist beträgt 35 Kalendertage ab dem Abgangstag.
  Das Beispiel im Informationsblatt (20.12.2023 → 24.01.2024) bestätigt diese Rechnung;
  es ist als Test hinterlegt.
- **A-12 Rinder nach dem 30.09.** „Nach dem 30. September“ heißt ab 01.10. Als Weitergabe
  gelten `departure.reason` `sale` oder `transfer`. Eine Nachbesetzung ist dann nicht nötig,
  sofern das Tier vor dem 01.01. des Folgejahres weder exportiert noch geschlachtet wird
  noch verendet.
- **A-13 Nachbesetzungsketten.** Ausgewertet wird bis zur zweiten Ebene
  (beantragtes Tier → Ersatztier → Ersatztier des Ersatztiers). Längere Ketten sind
  wegen des Rekursionsverbots in Rego nicht abgebildet. **Offen/technisch.**
- **A-14 Geringere Prämie bei Nachbesetzung.** Das Informationsblatt nennt zwei Fälle
  (weiblich → männlich, mit MLK → ohne MLK). Umgesetzt ist allgemein das Minimum aus den
  Prämien des beantragten Tieres und der herangezogenen Ersatztiere. Bei gleicher Rasse
  unterscheiden sich die Prämien nur nach Kategorie und MLK. Diese Lösung deckt daher die
  genannten Fälle ab und zahlt in den übrigen Fällen nie mehr als für das beantragte Tier.
  **Auslegung.**
- **A-15 Weitergabe ohne Vorabmeldung.** Die Grenzen 6 Monate (Zuchtstation) bzw. 3 Monate
  (männliche Tiere) werden als Haltebedingung geprüft; Überschreitung heißt, das Tier ist
  nicht förderbar. Fehlt nur die Vorabmeldung, wird ein Befund ausgegeben
  (`O6_5-REP-PRIOR-TRANSFER-REPORT`), die Förderbarkeit bleibt aber erhalten. Die SRL
  („Vor der Weitergabe hat eine Meldung … zu erfolgen“) lässt auch die strengere Lesart zu.
  **Offen.**
- **A-16 Kurzaufenthalte bis 10 Tage.** Geprüft wird `end_date - start_date <= 10`
  (Kalendertage laut SRL, „Tage“ laut Informationsblatt). Der Aufenthalt muss belegt sein
  (`documented`). Längere Aufenthalte bei Leistungsprüfungen, Tierzucht- oder
  Sportveranstaltungen sind keine zulässige Weitergabe.
- **A-17 Verspätete Meldungen.** Abgangs- und Nachbesetzungsmeldungen nach mehr als 7 Tagen
  erzeugen Befunde (`findings`). Laut Informationsblatt „kann“ das bei Vor-Ort-Kontrollen zu
  Beanstandungen führen; die Höhe einer allfälligen Sanktion ist in den Quellen nicht
  quantifiziert.
- **A-18 Zinsweide/Fremdweide.** Das Informationsblatt nennt „Zinsweiden“, die SRL
  „Fremdweiden“. Beides wird im Typ `alpine_or_common_pasture` zusammengefasst.

## Dürre 2026

- **A-19 Haltedauer 2026.** Die Festlegung „Haltedauer bis einschließlich 31. August“ steht
  in `data/o6_5/general.json#/year_specific_overrides`. Daraus folgt, dass bei Abgang ab
  01.09.2026 weder eine Nachbesetzung noch eine Nachbesetzungsmeldung nötig ist. Abgänge
  sind aber weiterhin bis Jahresende zu melden.
- **A-20 Höhere Gewalt (Trockenheit).** Der allgemeine Hinweis zu Ansuchen auf höhere Gewalt
  (Notice 22.05.2026) ist nur als Verfahrensregel erfasst; eine Anerkennung lässt sich
  nicht automatisiert ableiten.
- **A-21 Nicht enthaltener Hinweis.** Der Teaser „Meldeverpflichtungen zu tierbezogenen
  ÖPUL-Maßnahmen“ (02.09.2026) erscheint nur als Kurztext in der Seitenleiste; der
  vollständige Hinweis ist nicht im Quellpaket. Der Teaser stützt lediglich
  O6_5-REP-DEPARTURE-7-DAYS.

## Allgemeine Bedingungen und Prämienberechnung

- **A-22 Prämienperiode.** Für 2023 gelten die Sätze „2023“, ab 2024 die Sätze
  „ab 2024“ (SRL: gültig ab 01.01.2024). Für 2025–2028 gelten mangels abweichender
  Quellen die Sätze „ab 2024“.
- **A-23 Betriebsmindestgröße.** Sie wird nur im ersten ÖPUL-Teilnahmejahr
  (`oepul_participation.first_oepul_year == farm.year`) geprüft. `land.total_area_ha`
  dient als Näherung für die Summe der anrechenbaren Flächen (Acker, Grünland, Dauerkulturen,
  Wein, Almweide, GA, K20, Landschaftselemente usw.).
- **A-24 Modulation.** Der Faktor wird aus `land.total_area_ha` gewichtet berechnet
  (Beispiel 220 ha → 99,09 %) und auf die o6_5-Prämie angewandt. Die Reihenfolge der
  Mehrfachkürzungen (inhaltliche Kürzung vor Modulation) ist multiplikativ umgesetzt.
- **A-25 Kürzungsstufe.** Die Einstufung eines Verstoßes (Schwere, Ausmaß, Dauer,
  Häufigkeit) nimmt die AMA vor. Sie ist Eingabe (`content_violation_stage`) und wird nicht
  aus den Befunden abgeleitet. Ab 2027 wird „warning“ als 1 % Einbehalt gerechnet.
  Ausschluss gilt ab zwei 100-%-Kürzungen im Vertragszeitraum.
- **A-26 Kleinbetrag ≤ 50 €.** Die SRL-Regel („kann abgesehen werden“) bezieht sich auf den
  gesamten Auszahlungsbetrag. Rego setzt nur ein Kennzeichen (`payout_may_be_waived`) für
  den o6_5-Anteil; ob die AMA davon Gebrauch macht, bleibt eine Ermessensfrage.
- **A-27 Förderobergrenzen je Hektar.** Sie gelten für flächenbezogene Zahlungen und werden
  auf die Tierprämie nicht angewandt (O6_5-GEN-AREA-CAPS-NOT-APPLICABLE).
- **A-28 Gebietskörperschaften.** o6_5 steht nicht auf der Liste der Ausnahme-Maßnahmen;
  der Ausschluss gilt daher uneingeschränkt. Eine Beteiligung von genau 25 % ist zulässig,
  erst „mehr als 25 %“ schließt aus.
- **A-29 Abmeldung.** Eine Abmeldung im Förderjahr oder davor bedeutet: keine Prämie für
  dieses Jahr. Eine Abmeldung im Folgejahr lässt das Förderjahr unberührt, beendet aber die
  automatische Verlängerung. Eine Abmeldung nach Ankündigung einer Vor-Ort-Kontrolle wird
  als unwirksam behandelt (Befund O6_5-GEN-EXIT-UNTIL-INSPECTION).
- **A-30 Wiedereinstieg nach Erlöschen.** Möglich über einen neuen Maßnahmenantrag bis
  31.12. des Vorjahres oder über Korrektur plus schriftliches Ersuchen. Die Genehmigung des
  Ersuchens durch die AMA wird unterstellt, sobald beides vorliegt.
- **A-31 GEP-Zuschlag.** Der Zuschlag wird gewährt, wenn die Rasse in Anhang D als „ja“
  (besonderes GEP) gekennzeichnet ist. Ob der Zuchtverband das Programm im jeweiligen Jahr
  tatsächlich umsetzt, ist nicht als Eingabe modelliert. **Offen.**
- **A-32 Bestätigung der Zuchtorganisation ohne Datum.** Status `confirmed` ohne Datum gilt
  als fristgerecht.
- **A-33 Rundung.** Prämien werden je Tier und in Summe auf Cent gerundet.

## Artefakt-Konventionen

- **A-34 Pfade.** `source_path`, `artifact_path` sowie die Pfade in
  `rules/data_inventory.json` beginnen mit `workspace/` und sind damit vom Run-Verzeichnis
  aus auflösbar.
- **A-35 Rassenliste.** Die Namen der Tierzuchtorganisationen folgen Anhang D der SRL. Das
  Informationsblatt kürzt teils ab, z. B. „Rinderzucht Steiermark eG“ statt „eGen“ oder
  „Salzburger Landesverband Schafe und Ziegen“.

## Offene fachliche Fragen (für die spätere Bewertung)

1. Lesart „mindestens jeder 2. Wurf reinrassig“ (A-05).
2. Führt eine fehlende Vorabmeldung einer Weitergabe zum Verlust der Förderbarkeit (A-15)?
3. Gilt die Nachbesetzungspflicht für Rinder mit derselben 5-Wochen-Frist? (Die SRL
   formuliert allgemein; umgesetzt ist sie für alle Tierarten.)
4. Maßgebliche Fläche für die Betriebsmindestgröße bei reinen Tierhaltungsbetrieben (A-23).
5. Umgang mit mehrstufigen Nachbesetzungsketten über zwei Ebenen hinaus (A-13).

