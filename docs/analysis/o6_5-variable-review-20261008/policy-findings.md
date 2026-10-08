# o6_5: 16 unveränderte historische OPA-Beobachtungen

OPA 1.18.2, strict-builtin-errors, sämtliche vollständigen Eingaben/Queries/
Ausgaben in `policy-probes.json`. Keine fachlich freigegebenen Golden-Tests.

| Probe | Beobachtung |
| --- | --- |
| LUNA_NO_ORG_CONFIRMATION | organization_confirmation:false: eligible:true. Der Vorschlag ist nicht im Zugangsentscheid konsumiert. |
| LUNA_STEIRISCHE_GEP_TABLE | Steirische Scheckenziege: 64,8 Euro statt Listenfähigkeit 64,8 + 21,6; special_gep falsch extrahiert. Die tatsächliche Programmumsetzung bleibt separat offen. |
| LUNA_CATEGORY_SPECIES_MISMATCH | Noriker/horse mit cow und calved_by_stichtag:true wird eligible; Art/Kategorie nicht konsistent geprüft. |
| LUNA_BEYOND_PROGRAMME_YEAR | 2029 mit passenden held_from/to: eligible trotz separatem contract_year_valid=false. |
| LUNA_UNREPAIRED_JULY_DEPARTURE | Abgang im Juli, Meldung erst nach 30 Tagen, kein Ersatz; zusammengefasstes held_to=31.8. genügt weiter für eligible. |
| OPUS_FUTURE_CONFIRMATION_BEYOND_AS_OF | confirmed zum 1.2.2027, as_of=8.10.2026: ein Förderplatz und 356,4 Euro. Kein aktueller Evidenzzeitfilter. |
| OPUS_UNDATED_CONFIRMATION | confirmed ohne Datum: ein Förderplatz und 356,4 Euro. |
| OPUS_REENTRY_WITHOUT_AMA_DECISION | Korrektur und schriftliches Ersuchen als Booleans: 356,4 Euro ohne ausdrücklichen AMA-Genehmigungsbeleg. |
| OPUS_NEGATIVE_ABSENCE_INTERVAL | Belegter Aufenthalt 20.7.–1.7.: negative Dauer <= 10, Förderplatz/356,4 Euro erhalten. |
| OPUS_REPLACEMENT_NOT_YET_ON_FARM | Ersatzdatum Juni 2026, tatsächliches on_farm_from Januar 2027: weiterhin ein Förderplatz/356,4 Euro. Ersatz-Zugang wird nicht geprüft. |
| OPUS_REPLACEMENT_FOALS_ONLY_LATER | Ersatzstute am 5.4., erste Abfohlung erst 20.5.: base_ok:true und ein Förderplatz, weil max(Ersatzdatum,31.5.) genutzt wird. SRL verlangt Erfüllung zum Ersatzzeitpunkt; Auslegung klären. |
| OPUS_THREE_REPLACEMENT_LEVELS | Drei jeweils binnen zwei Tagen ersetzte Tiere bis zum endgültigen vierten Tier: Originalförderplatz scheitert an fester Tiefe. |
| OPUS_STEIRISCHE_GEP_WITHOUT_ANNUAL_PROGRAMME | 86,4 Euro aus korrektem Tabellenflag ohne individuellen jährlichen Umsetzungsbeleg. |
| OPUS_BEYOND_PROGRAMME_YEAR | 2029: 356,4 Euro und contract_renews_next_year:true ohne aktuellen Programmjahresgate. |
| APP_GROUP_WITHOUT_INDIVIDUAL_EVIDENCE | cattle/animal_count:1 genügt für eligible/phase1_baseline_check_passed. Kein seltenes reinrassiges förderbares Zuchttier belegt. |
| APP_INDIVIDUAL_ONLY_IS_NOT_PROJECTED | Nur vollständige endangered_breed_animals-Liste ohne species_groups: not_eligible/no_supported_species_group_found. Die Policy erhält keine Einzeltierprojektion. |

Synthetische zukünftige Bestätigungen sind absichtlich eingegebene Testdaten,
keine behaupteten tatsächlichen Verbandsbestätigungen. Sie prüfen, ob die Policy
bekannte Daten und Prüfstichtag trennt. Historische Ausgaben werden als Mängel-/
Auslegungsbeobachtung festgehalten und nicht als erwartetes Produktverhalten festgelegt.

Luna `policy.o6_5.eligible` konsumiert nur Tier-/Haltevoraussetzungen, nicht
Antrags-/Bestätigungs-/Melde-/Nachbesetzungshelfer. premium(animal) ist auch
keine vollständige Auszahlung. Opus `oepul.o6_5.payout_eur` bindet applicant,
contract, Förderplätze und externe Kürzungen stärker, aber reporting.findings
nehmen Förderbarkeit nicht zurück; dafür fehlen bestätigte Rechtsfolgen. Auch
pending Bestätigungen vor Fristablauf sind keine automatisch festgestellten Verstöße.

27 Rassen samt Stufen/GEP und sechs GEP-Auflagen direkt am Original gelesen.
Luna falsches Scheckenziege-Flag wird im historischen Run nicht korrigiert;
ein späterer genehmigter Kandidat benötigt den belegten Tabellenfix und jährliche
Umsetzungsnachweise. Keine Behauptung, alle 152 Katalogregeln oder alle Helper
seien fachlich freigegeben/vollständig konsumiert.
