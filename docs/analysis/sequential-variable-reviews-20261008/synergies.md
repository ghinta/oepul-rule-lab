# Belegte Wiederverwendungskandidaten – laufender Stand

Arbeitsnotizen für die gemeinsame Durchsicht nach den Einzelprüfungen.
Dies ist keine abschließende Analyse aller Maßnahmen und keine Aufnahmefreigabe.
Die jeweiligen Fragen im Sammelissue #140 bleiben offen. Zusammengefasst wird
die Erfassung von Evidenz; ihre fachliche Auswertung bleibt maßnahmenbezogen.

| Gemeinsame Grundlage | Betroffene offene Entscheidungen | Unterschied, der erhalten bleiben muss |
| --- | --- | --- |
| RGVE-Kohorten mit stabiler ID und datiertem Bestands-/Alters-/Rassenbeleg; vorhandener App-Backend-Vertrag aus #137 | BIO `RGVE_STOCK_BASIS`, o6_2 `RGVE_FODDER_BASIS`, o6_3 `RGVE_COHORTS_AND_FIRST_YEAR`; bestehende `COUNT_BASIS/GROUP_IDENTITY` | GVE ist kein RGVE. o6_2 klassifiziert jährlich, o6_3 braucht zusätzlich historische Erstjahresnachweise. BIO hat eigene Kategorien-/Ausnahme-/Zuschlagsfragen. Opus-Kuh-Kategorie heißt bei o6_2 `cattle_ge_2y`, bei o6_3 `cattle_2y_plus`; keine automatische String-Gleichsetzung. |
| Datiertes Schlag-/Hauptkultur-/Teilflächeninventar | UBB `FIELD_PIECE_IDENTITY`, BIO `FIELD_DIV_IDENTITY`, NPA/AFS `AFS_ENTITY_IDENTITY/NPA_QUOTA_PART_AREA`, o6_2 `RGVE_FODDER_BASIS/N_CURRENT_CALENDAR_YEAR`, o6_3 `FORAGE_MINIMUM_PREMIUM_SEPARATION` | Schlag ist kein Feldstück oder AFS-Element. Prämienfläche, Quote, Futter-Nenner und österreichische LN sind verschiedene Mengen. o6_2-Zweitkultur erhält Ackerprämie; o6_3-Zweitkultur keine Heuwirtschaftsprämie. |
| Kurs-/Personen-/Betriebsbelege und Anrechnungshistorie | BIO `TRAINING_EVIDENCE`, o6_2 `TRAINING_PERSON_AND_CUTOFF`; UBB-Biodiversitätsverpflichtung | Derselbe Kursdatensatz kann technisch erfasst werden; erlaubte Themen, Fristen, Anbieter, Ausscheiden und Doppelanrechnung sind gesonderte Entscheidungen. o6_2 verlangt zusätzlich zur UBB-Schulung eigene anrechenbare Stunden. |
| Produkt-/Wirkstoff-/Herkunfts-/Anwendungsereignisse mit datierter Zulassungsquelle | NPA/AFS `NPA_BIO_PSM_AND_FERT`, o6_2 `INPUT_ORIGIN_AND_SLURRY_RETURN/PSM_APPLICATION_AND_CODE_YEAR` | NPA verbietet jegliche Düngung; o6_2 unterscheidet betriebsfremdes N und ausdrücklich erlaubte Mittel. AFS-Verbissschutz, NPA-BIO-Wirkstoffe, Kultur-/Beizungsfrage und PSM-Codierungsjahr bleiben getrennt. |
| Vertrauenswürdiger aktueller Jahres-/Snapshot-/Prüfstichtagskontext samt Vollständigkeitsnachweisen | Gemeinsame `SOURCE_VERSION/CURRENT_SNAPSHOT`, BIO `DIVNFZ_COMPLETION/HISTORY_AND_OTHER_OPTIONS`, NPA `NPA_EVENTS_AND_YEAR_END`, o6_2 `N_CURRENT_CALENDAR_YEAR/TRAINING_PERSON_AND_CUTOFF`, o6_3 `GREEN_FEEDING_METHOD_AND_HISTORY` und `ANNUAL_EVIDENCE` | Heutige Beobachtung ist kein Jahresabschluss und heutiger Nullbestand keine Saisonhistorie. Fehlend ist nicht false/0/confirmed-empty. Zukunftsoption nur getrennte begründete Notiz; laufende Förderentscheidung aus aktuellem Jahr und aktuellem Datenstand. |
| Behörden-Anerkennung mit Dokument, Pflicht, Fläche und Vorfallszeitraum | o6_2 `DROUGHT_PROOF_AND_SCOPE`, o6_3 `RECOGNITION_INCIDENT_SCOPE/RECOGNITION_TIME` | Allgemeine Ernteausnahme, anderer Maßnahmen-Dürrecode und individuelle Rechtsfolge nicht gleichsetzen. Ein recognised-Boolean entfernt keine beliebigen Verstöße. Früherer Vorfall bleibt bei späterem as_of nachvollziehbar. |

Belege stehen in den jeweiligen Originalfundstellen und Pfad-/Policy-Dossiers.
Offene gemeinsame Benennung darf die differenzierten fachlichen Scopes nicht
vorwegnehmen. Weitere Zeilen werden erst nach der betreffenden Einzelprüfung
ergänzt.
