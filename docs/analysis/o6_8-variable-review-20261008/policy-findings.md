# Konkrete historische Policy-Beobachtungen

19 Proben auf unveränderten Luna-/Opus-Policies und gepinntem App-Code.
Ausgaben sind Beobachtungen, keine fachlichen Sollregeln oder AMA-Sanktionen.

- Luna AH: 4 m Abstand und nicht erhaltene Anhäufung ergeben compliant=true,
  ohne eigenen o6_8-Vertrag. Ein Grünlandschlag zählt sogar zur Mindestfläche;
  eligible_parcels bleibt dabei leer, Gesamtcompliance trotzdem true.
- Luna vorgeschlagene `application_codes:[{code:AH}]` wird als ungültiger Code
  gemeldet. Bei solchen Verstößen ist Gesamtdecision mangels false-Default
  undefiniert; technische Beobachtung nicht als fachlich beantworteter Status lesen.
- Luna echte Frühkartoffeln/MS wird wegen Name abgelehnt; künstlicher Name
  `Frühkartoffeln (nur MS)` mit DS löst keinen Verstoß aus. Kulturlisten-Suffixe
  sind nicht fachliche Jahres-/Verfahrensbedingungen.
- Luna BAW mit unbekannter KG und Beweidung ergibt compliant=true trotz leerem
  baw_eligible. Viele vorgeschlagene Verfahrens-/Historien-/Dürremerkmale sind
  nicht mit wirksamen Compliance-/Prämienprüfungen verbunden.
- Opus US ohne Saat-/Partner-/Nachweise, Bewerber oder Antragsdatum: access=true,
  81 Euro. Explizit fehlender Zahlungsantrag: no_premium-Helper=true, trotzdem
  81 Euro. Ausstieg 2025: repayment-Helper=true, trotzdem 2026 aktiver Vertrag/81 Euro.
- Opus Winterackerbohne vom 1.10.2025 mit US am 1.4.2026 wird nach Acht-Wochen-
  Herbstsaatuhr beanstandet; MB S. 4 verlangt vergleichbaren Sommerzeitraum/max30.4.
  Dessen fachlicher Startbezug bleibt offen.
- Opus Saat-/US-Ereignisse April/Mai 2027 ergeben im Bewertungsjahr 2026 weiterhin
  81 Euro. Ein negatives MS-Bearbeitungsintervall (-9 Tage) ergibt 54 Euro.
- Opus MS+DS meldet unlisted_code_combinations und addiert 54+86,4=140,4 Euro.
  Die Prämienwirkung weiterer Codepaare und MS/DS/AH-Konflikt ist nicht bestätigt.
- Opus BAW ohne KG/Pfad-/Anlage-/Pflegebelege ergibt 594 Euro auf ganzer Fläche.
  Widersprüchliches Pfadverhältnis 25 % bei 0,1 ha Pfad/1 ha Schlag verhindert
  Viertel-Verstoß und ergibt gekappte 237,60 Euro; Widerspruch nicht geprüft.
- Opus negativer GLÖZ4-Abzug -0,2 ha erhöht 1-ha-Schlag auf 1,2 ha prämienfähig
  (712,80 Euro). Erforderliche fachlich belegte und numerisch konsistente
  Teilflächenverträge dürfen solche Rohdaten nicht zulassen.
- Opus BAW letzte Pflege 2024: im Oktober 2026 bereits Verstoß und 0 Euro,
  obwohl Notiz ausdrücklich Jahresendprüfung behauptet; kein as_of-Gate im Code.
- Opus drei Partner und properly_established:null unterdrücken US-Deckungs- und
  Feldaufgangsverstoß. Nur tatsächliche belegte ordnungsgemäße Anlage erlaubt
  die 2026-Ausnahme; Ausweitung auf Feldaufgang bleibt fachlich offen.
- App 2 ha/Schlaghang 0/Bodenbedeckung=true ergibt eligible ohne Verfahrensnachweis.

Direkter Tabellenabgleich: beide vollständigen 1.952-KG-Listen entsprechen den
Originalzeilen, aber Gemeinde-Spaltentrennung und führende Nullen/amtliche ID-Form
sind nicht freigegeben. Opus erhält Verfahrens-/Jahres-/Altbestandsmerkmale getrennt,
Luna erhält dieselben 73 Kulturzeilen als Strings mit Anmerkungen. Zwölf Prämienzeilen
stimmen mit MB-Tabelle; vollständiger Helper-Konsum und amtliche Auszahlung offen.
