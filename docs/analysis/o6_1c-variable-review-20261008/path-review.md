# o6_1c: Entität, Pfade und Aufnahmebedarf

Die Tabelle indexiert alle 150 Blätter in `leaf-review.json`. Die vollständigen
Werte vorher/nachher und Antrags-/Regel-/Quellen-IDs stehen im verlinkten
Vorinventar-Diff. Hier genannte Zielstrukturen sind Vergleichskandidaten;
**keine Umbenennung, fachliche Gleichsetzung oder App-Aufnahme ist freigegeben**.

| Gruppe / Blätter | Luna | Opus | Tatsächliche App-Verwendung und Aufnahmebedarf |
| --- | --- | --- | --- |
| `participation` / 34 | `measure.*`: ID, Antrag, Kalendervertrag, Abmeldung/Teilnahmeflags; `farm.applicant.*` | `farm.oepul.measure_participations[]` mit Kategorie, Antrag, Einstiegsjahr, Abmeldung; Antragsteller/Kontrollen/Übernahmen | App-Auswahl `measure_id` ist keine amtliche Antragstellung. Adapter übernimmt `farm.year`, aber weder `measure` noch `farm.applicant/farm.oepul`. Pro Kategorie NPA/AFS getrennte Vertrags-/Antragsnachweise nötig. Ein fehlender MFA-Nachweis darf nicht wie Opus auf `true` gesetzt werden; fehlendes Erstteilnahmejahr ist nicht aktuelles Jahr. MB S. 1, 4; ATB S. 4–5, 12–15, 17–18. |
| `npa_identity` / 4 | `land.parcels[].measure_category`, `measure_code` | `land.parcels[].oepul_codes[]`, `schlagnutzungsart` | App konsumiert `land_use`, `is_nonproductive_area`, `is_agroforestry_strip`. Raw-AMA-Proxy erkennt auch „Brache“/„Biodivers“, nicht ausdrücklich nur amtlich beantragte NPA. `is_nonproductive_area:true` ersetzt keinen NPA-Code. Prüfen: bestätigte Schlagidentität, Grünbrache-Nutzung, jährlicher Kategorieantrag und wirksame Codierung. MB S. 4. |
| `npa_management` / 30 | Aussaat/Umbruch/Folgekultur, aggregierte Pflegezahlen, Entfernen/Nutzen/Beweiden, betriebliche Frühschnitt-ha | `npa.maintenance_events[]` mit Datum, Art und Biomasseverbleib; Erstdeklarationsjahr, Vorjahrespflege, Umbruch/Folgekultur | App kennt `cutting_dates` und einfache `oepul.shared.parcels[].management_events`, aber keine o6_1c-Collection-Dependency. Datum allein belegt weder Pflegeart noch Biomasseverbleib, Teilflächen oder Vollständigkeit. Vorjahres-/Jahresabschluss und zulässigen Reinigungsschnitt gesondert belegen; aktuelles Jahr darf nicht aus fehlender Historie entstehen. MB S. 2–3; SRL S. 46. |
| `npa_inputs` / 3 | `npa.psm_active_ingredients[]` vorgeschlagen, aber nicht gelesen; Policy verwirft jedes `operations.psm_used:true` | `npa.any_fertilization`, `psm_only_bio_active_substances` plus vorhandene N-Werte | Keine dieser BIO-Zulassungs-/Gesamtdüngungsangaben wird von o6_1c konsumiert. N = 0 beweist keine fehlende P-/K-/Kalk- oder sonstige Düngung. PSM-Anwendung und zugelassene Wirkstoffe unterscheiden, jeweils Zeitraum ab Erstdeklaration bis Umbruch/anderer Deklaration. MB S. 3; SRL S. 46. |
| `afs_identity_geometry` / 20 | `land.parcels[].agroforestry.*`: Breite, Dichte, Abstand, Anlagejahr/-datum, vorhandener Streifen, Randlage | Eigenständige `land.agroforestry_strips[]`: ID, Fläche ha, Länge m, Baumzahl, mittlere Breite, maximaler Abstand, direkte Ackerangrenzung, Anlagejahr | App hat keine AFS-Collection und verliert beide Objektstrukturen im Adapter. Landschaftselement nicht einfach als Ackerschlag ausgeben. Streifen-/Feldstücksidentität, Geometrieherkunft, Baum-/Strauchabgrenzung und Datumsnachweis bestätigen. Dichte pro 100 Laufmeter nicht mit Baumabstand gleichsetzen. Fehlender Abstand ≠ 0 m. MB S. 2–4; SRL S. 46–47. |
| `afs_species` / 9 | Baumobjekte und gesonderte natürliche Anflug-Arten | `species[]` mit wissenschaftlichem Namen, Anzahl, Herkunft | Kein o6_1c-Artenvertrag. Luna prüft exakte Namen, Opus zusätzlich Gattungen. Amtlichen Taxon-/Artnamen, vollständige Erfassung gepflanzter und angeflogener Gehölze und Negativliste bestätigen. Leere/unbekannte Liste ist kein Nachweis, dass keine verbotenen Arten vorkommen. Sträucher sind erlaubt, zählen aber nicht automatisch als Bäume in der Dichte. MB S. 2; SRL S. 46; Spezialkulturdefinition GSP-AV fehlt als Quelle. |
| `afs_care_inputs` / 18 | Pflege-/Verbissschutz-/Stütz-/Grün-/Nutzungsflags sowie Entnahme/Nachpflanzung | `care.*`, krautige Nutzung, Mittelverwendung/Zulassung, Entnahme-/Nachpflanzdatum | Keine AFS-Projektion. Pflanzpfahl nach Pflanzung und bedarfsgerechter Schnitt benötigen situationsbezogene Evidenz, keinen stets geltenden pauschalen Boolean. Bestehender Streifen, Neuanlage und Entnahme/Nachpflanzung trennen. Pflege ohne Abtransport ist nicht Nutzung; Bio-Verbissschutz ist gesondert zulässige Ausnahme. MB S. 3; SRL S. 47. |
| `area_codes_combination` / 32 | Länder-/Spezialkultur-/GLÖZ-Flags, Kombinationen, anderweitige Verpflichtung/Prämie, Weitergabe, UBB/BIO-Flags | Statusobjekte, GLÖZ-4-Teilfläche ha, ÖPUL-/Prämiencodes, `feldstuecke[]`, zusätzliche LSE-/geschützte Flächen | App führt ÖPUL-Codes unter `oepul.shared.parcels[]`, Feldstücksdaten als Display; kein o6_1c-Konsum. GLÖZ-4-Boolean verliert Teilfläche. 4-%-Prämiengrenze, 50-%-Frühschnittfläche und AFS-0,15-ha-Anrechnung sind verschiedene Größen. Betrieblicher NPA-Ausschluss, Einzelflächen-Prämienkombination und AFS-Anrechnung getrennt behandeln. Flächenbasis für Erstjahresminimum/Modulation ohne Doppelzählung klären; OP-Codes nicht aus beliebigen Präfixen ableiten. MB S. 4–5; ATB S. 5, 7–9, 19; Anhang L S. 103. |

## Vorhandene App-Dependencies

Eine skalare Dependency: `land.arable_area_ha`. Drei Schlag-Dependencies:
`land_use`, `is_nonproductive_area`, `is_agroforestry_strip`. Keine o6_1c-
Tier-/Collection-Dependencies. Der aktuelle Adapter transportiert nur
normalisierte Schlagfelder; zusätzliche `npa`-/`agroforestry`-/`farm.oepul`-
Strukturen und `land.agroforestry_strips` verschwinden.

Die App erwartet `{measure_id, payload: adapted_payload}` und
`data.oepul.measure_decision`. Luna verwendet ungekapselten Input unter
`policy.o6_1c`, Opus unter `oepul.o6_1c`; beide besitzen andere Ergebnistypen.
Ein neuer Adapter muss auch Ergebnis-/DecisionTrace-/Evidenzverträge abdecken.
Das aktuell konsumierte Flag ist technisch wirksam, seine Änderung entscheidet
aber nur den vorhandenen eingeschränkten Phase-1-Vertrag.

## Gleiche Namen, verschiedene Prüfung

`farm.applicant.is_active_farmer` ist in beiden Vorschlägen gleich geschrieben,
wird von Luna aber nicht gelesen. `land.parcels[].npa.sowing_date` ist ebenfalls
gleich: Lunas Helper prüft ein Datum ohne Einschränkung auf Neuanlage;
Opus begrenzt die Aussaatprüfung auf Neuansaat im ersten Deklarationsjahr.
Auch bei diesen beiden Namen ist kein verlustfreier semantischer Alias belegt.
