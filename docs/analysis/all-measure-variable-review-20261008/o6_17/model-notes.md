# o6_17: unveränderte Modellnotizen

Sämtliche Modellannahmen sind unbestätigt. Auch nicht einzeln priorisierte Auslegungen müssen vor Übernahme geprüft werden.

## luna: `v2-o6_17-luna-high-20261005`

# Fachliche Annahmen und offene Fragen

- Die Informationsblätter kennzeichnen den juristischen Status selbst als rechtlich unverbindlich. Der Regelkatalog priorisiert deshalb die deckungsgleichen Aussagen aus Sonderrichtlinie und Anhängen, nutzt das Maßnahmenblatt aber als ausführliche operative Darstellung.
- Die Formulierung zur Hangneigung ist zweistufig: Die Grundmaßnahme bleibt auf Grünland unter 18 % begrenzt; ab 2025 wird die Erweiterung auf mindestens 18 % nur für artenreiches Grünland als Zuschlag angesetzt. Das ist in Rego als getrennte `base_eligible_parcels`- und `bonus_eligible_parcels`-Logik modelliert.
- Für den AGL-Flächenhöchstwert wird `max(2 ha, Prozentsatz des gemähten Grünlands)` verwendet. Die Quellen formulieren „maximal ... jedenfalls aber 2,00 ha“; die konkrete Anrechnung bei sehr kleinen Betrieben bleibt eine fachliche Auslegungsfrage.
- Das Canonical Farm Profile enthält weder Antrags-/Vertragsdaten noch schlagbezogene Grünlandzahl, GLÖZ-2/4/9-Kennzeichen, AGL-Nutzungsvarianten, Kennartenabschnitte, Bodenproben oder Bildungsnachweise. Diese Variablen werden im discover-Modus als Profiländerungsvorschläge erfasst und nicht in das Canonical Profile geschrieben.
- Für `observed_kennarten` wird entsprechend dem Arbeitsauftrag ein Array mit repräsentativen Objekten vorgeschlagen (`{"name":"string"}`). Die Rego-Regel erwartet deshalb Objekte und prüft deren Namen gegen die geschlossene Kennarten-Datenliste.
- Die Rego-Ausgabe bildet die ausführbaren Kernentscheidungen und Berechnungen ab. Nicht jede Nachweis- oder Verfahrenspflicht ist als automatische Ja/Nein-Zulassung implementierbar; solche Pflichten bleiben im Regelkatalog und in den vorgeschlagenen Profilfeldern explizit.
- Die vier 2026-HTML-Hinweise wurden vollständig geprüft. Sie betreffen jeweils andere Maßnahmen bzw. Acker-, Wein-, Naturschutz- oder Tierhaltungsfälle und ändern keine o6_17-Regel; sie sind im Coverage-Ledger als `not_rule` dokumentiert.
- Die Grounding-Korrektur verwendet für die Weiterbildung die Textstelle auf Seite 4 (Bindung an die geschulte Person) und für die Kennartendokumentation die Fortsetzung auf Seite 9 (Aufzeichnungsvorlage/Skizze). Die vier HTML-Hinweise bleiben ausschließlich als Coverage-`not_rule` erhalten und werden nicht als Quellenbelege einer o6_17-Regel verwendet.
- Die Profil-Ergänzungen sind als einzelne Blattpfade modelliert, damit keine Container-Änderungen überlappen. Für die Hangneigung bleibt die kanonische Parzellenangabe maßgeblich; `oepul.o6_17.slope_percent` ist zusätzlich ein repräsentativer, maßnahmenbezogener Eingabewert für die Zuschlagsberechnung.


## opus: `v2-o6_17-opus-5.5-high-20261002`

# o6_17 – Annahmen und offene Fragen

Run: `v2-o6_17-opus-5.5-high-20261002`, Modus `discover`.

## Fachliche Mehrdeutigkeiten

1. **Hangneigung ab 18 % ab 2025 (Merkblatt Kap. 1).** Im Merkblatt steht pauschal, dass ab 2025
   „auch eine Hangneigung ab 18 % gefördert“ wird. Laut SRL 2.17 („Art der Unterstützung“) und der
   Prämientabelle gilt das nur für artenreiche Grünlandflächen (AGL 162 €/ha). Die Grundprämie bleibt
   daher auf < 18 % beschränkt (`O617-SCOPE-BASE-SLOPE`).
2. **Grenze Grünlandzahl 20.** Das Merkblatt schreibt „bis 20“ und „ab 20 bis unter 30“, die Zahl 20
   fällt also in beide Stufen. Verwendet werden die SRL-Intervalle `< 20`, `>= 20 und < 30`, `>= 30 und < 40`
   und `>= 40`. Bei Widerspruch geht die SRL vor (`GEN-LEGAL-HIERARCHY`).
3. **AGL-Obergrenze „jedenfalls aber 2,00 ha“.** Umgesetzt als `max(Anteil × gemähtes Grünland; 2,00 ha)`.
   Gemähtes Grünland umfasst alle gemähten Grünland-Schlagnutzungsarten ohne Bergmähder.
   Übersteigt die AGL-fähige Fläche die Obergrenze, wird proportional über alle Schläge gekürzt.
   Welche Schläge die AMA tatsächlich vorrangig berücksichtigt, ist nicht geregelt.
4. **Flächenzugang ab 2026.** Obergrenze = Fläche 2025 + max(50 % × Fläche 2025; 5 ha). Die Kürzung
   wird proportional auf die Grundprämie angewendet. Ob auch der AGL-Zuschlag betroffen ist, bleibt offen:
   AGL ist ein einjähriger Zuschlag und unterliegt nach Allg. Bedingungen 7.2 vermutlich nicht der
   Beschränkung. Er wird hier nicht gekürzt.
5. **Kombination auf der Einzelfläche (Anhang L).** Ist ein o6_17-Schlag zugleich in einer laut
   Anhang L nicht kombinierbaren Maßnahme (z. B. Naturschutz o6_18), wird die o6_17-Prämie auf diesem
   Schlag nicht gewährt. Die Quelle regelt nur „prämienmäßig nicht kombinierbar“, nicht aber, welche
   Maßnahme vorgeht. Der Konflikt wird zusätzlich in `combination_conflicts` gemeldet.
   Unabhängig davon zählen Naturschutzflächen zur Futterfläche und zur Bodenproben-Basis (Merkblatt 4 und 6.5).
6. **Grünlandanteil 40 %.** Als „landwirtschaftliche Nutzfläche ohne Almweideflächen“ wird
   `land.total_area_ha − land.alpine_pasture_area_ha` verwendet. Ob `total_area_ha` im Profil Almflächen
   enthält, ist nicht festgelegt.
7. **Futterfläche.** Alle Grünlandschläge außer „Sonstige Grünlandflächen“ und Grünlandbrachen sowie
   die Ackerfutter-Schlagnutzungsarten. Almweideflächen (`land_use = alpine_pasture`) zählen nicht dazu.
8. **Schlagnutzungsart „weide“.** Das ist ein Sammelcode für nicht gemähte Weideflächen und wird in den
   Quellen nicht namentlich geführt (Annahme).
9. **Weiterbildung und Bodenproben – Prüfzeitpunkt.** Eine Verletzung wird ab dem Antragsjahr 2025
   gemeldet, weil die Frist am 31.12.2025 endet. Eine Person, die *vor* dem 31.12.2025 ausscheidet,
   macht ihre Kurse unanrechenbar.
   Die SRL verlangt, dass die drei Themen „jedenfalls Inhalt“ der Kurse sind; das Merkblatt nennt sie nur
   „mögliche Themen“. Die Themenprüfung ist daher nur im Katalog erfasst (`O617-OBL-TRAINING-TOPICS`) und
   nicht als harte Rego-Bedingung umgesetzt.
10. **Bodenproben-Basis.** Bevorzugt wird der Profilwert `soil_sample_base_mfa2025_grassland_lt18_ha`
    (MFA 2025) verwendet. Fehlt er, wird die Basis nur im Antragsjahr 2025 aus den Schlägen berechnet.
11. **Umbruchsausnahme DIVRS.** Sie gilt, wenn der Schlag den Code `DIVRS` trägt und der Betrieb an UBB
    oder BIO teilnimmt. Die Detailauflagen der Neueinsaat (Saatgutmischung, 15.05.) werden in o6_1a/o6_1b geprüft.
12. **Aufschüttungen.** Bis 300 m² gelten sie als geringfügig. Darüber sind sie nur mit vorab eingeholter
    landesrechtlicher Bewilligung zulässig; ohne Bewilligung wird ein unzulässiger Umbruch angenommen.
13. **Maßnahmenbezogener OP-Code.** Der konkrete Code für o6_17 ist in den Quellen nicht genannt. Er ist
    daher als boolesches Feld `o6_17_op_code` modelliert.
14. **Flächenzahlungsobergrenze.** Die Überschreitung wird nur gemeldet
    (`parcel_area_payment_cap_exceeded`). Wie die Kürzung auf die Maßnahmen verteilt wird, regeln die
    Quellen nicht.
15. **Kennartenliste.** Merkblatt und Anhang H weichen bei der Familienzuordnung ab: Ehrenpreis ist im
    Merkblatt ein Wegerich-, im Anhang ein Löwenmaulgewächs. Taubenkropf-Leimkraut steht im Anhang H
    layoutbedingt im Block der Schmetterlingsblütler. Beide Zuordnungen sind in den Daten erfasst; für die
    Zählung ist das ohne Bedeutung.
    Schreibweise „Karthäuser-Nelke“ (Merkblatt) vs. „Kartäuser-Nelke“ (Anhang H).
16. **Mindestbewirtschaftung.** Als „Mahd erfolgt“ gilt mindestens ein Eintrag in
    `operations.cutting_dates`. Ob die Mahd vollflächig war und das Mähgut verbracht wurde, ist nicht im
    Profil abbildbar.

## Nicht abbildbare bzw. offene Punkte

- SRL 1.12.1.2 verweist für Flächen- und Tierabweichungen auf §§ 42–47 GSP-AV, die nicht im Quellpaket
  liegen (Coverage `unresolved`).
- Höhere Gewalt (§ 6 GSP-AV) ist nur als Katalogregel erfasst; Fristen und Nachweise der GSP-AV fehlen.
- Die Sanktionsstufen sind als Tabelle und Funktion `sanction_share` abgebildet. Die Zuordnung eines
  konkreten Verstoßes zu einer Stufe (Schwere, Ausmaß, Dauer, Häufigkeit) erfolgt durch die AMA und wird
  nicht automatisiert.
- Die 2026-Hinweise enthalten keine o6_17-spezifischen Erleichterungen (`N2026-NO-O617-RELIEF`).

## Technische Hinweise

- Daten liegen unter `data/o6_17/*.json` und werden von OPA unter `data.o6_17.<key>` gemergt; jede Datei
  hat genau einen eindeutigen Top-Level-Schlüssel.
- Ein Schreibversuch für ein Hilfsskript nach `/tmp` wurde von der Berechtigungsprüfung abgelehnt. Die
  Generierung lief deshalb über Python per stdin direkt in die erlaubten Ausgabedateien.
