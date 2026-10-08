# Konkrete technische Befunde

## Kalenderjahr, Vertrag und App

Das Original trennt Vertragsantrag vor Beginn (31.12.), MFA-Mengen des aktuellen
Kalenderjahres (30.11.) und tatsächlich ausgeführte Vorgänge. Die Fütterungsalternative
benötigt ausdrücklich keine bodennahe Ausbringung oder Separation. Vor Ende einer
laufenden Frist dürfen unbekannte Mengen nicht still als endgültiger Jahresausfall gelten.

Luna sperrt fortgeführte Teilnahme im Jahr 2028, ignoriert withdrawal_date und
quantity_requested_by_november_30 und verwendet stattdessen ein Dezemberflag.
Fehlende Records/Deadline verhindern eligible=true nicht. Selbst measure=other und
participation.application_m3=0 ergeben 11 Euro; negative requested_m3 ergibt −11 Euro.

Opus akzeptiert für 2026 eine Deklaration von 2025 und einen Ausbringungsvorgang von
2027 (recorded=20 m³, Betrag=22 Euro). Nullmenge wird im Oktober zu null und sofortigem
Vertragserlöschen. Programmendjahr in Daten verhindert gültigen Altvertrag/22 Euro für
2029 nicht. Kontrollfall: eine echte Abmeldung 2025 sperrt Vertrag/Betrag 2026 korrekt.

Die gepinnte App-Basis nutzt Category-C-Proxys ohne normativen Zugang.
Offener Draft #131 dagegen meldet eine undatierte positive 1-m³-Menge ohne Vertrag
bereits eligible. Sein API-Builder gibt nur Mengen und Präsenz weiter, keine
Fütterungsteilnahme. Ein zusätzlich geliefertes pig_feeding_participating=true
wird nicht konsumiert und ersetzt keinen freigegebenen Pfad: bei Nullmenge missing_data.
App #133 Frage 1 zur aktuellen Null-/offenen Menge bleibt ausdrücklich offen;
eine künftige Startmöglichkeit gehört nach Nutzerauftrag in eine begründete Notiz.

## Tatsächliche Mengen, Charge und Fläche

Opus berechnet 22 Euro für deklarierte 20 m³ ohne aufgezeichnete Ausbringung und
30 Euro für deklarierte Separation, obwohl sämtliche Records Fremdrindergülle sind
(recorded=0). Bei ausgeschlossener Biogascharge gilt ebenfalls recorded=0, aber 22 Euro.
Das sind theoretische Rechenausgaben, keine bestätigten Ansprüche. Die genaue
behördliche Kürzung wird nicht selbst erfunden.

23 Biogaslabels enthalten Bedingungen (unbedenklich/kein Tiermehl, ungebeizt,
extraktionsmittelfrei, keine Speiseöle/Großküche/Gastronomie), die Rego nicht konsumiert.
Globale Chargenflags können unterschiedliche Vorgänge vermischen. Fehlender mechanischer
Separationsbeleg gilt bei Opus true. records_groupable wird zwar definiert, aber beim
Gruppenrecord nicht genutzt; addierte Fläche ersetzt keine identische Kultur/Menge je ha.

N-Bedarf fehlt oder ist null: Opus zählt die Fläche dennoch als düngungswürdig.
Teilweise vorhandene Parzellenlisten ersetzen die aggregierte Fütterungs-Prämienbasis.
Luna getrennte 1-ha-Zugangsbasis und 100-ha-Prämienbasis ergeben 5.411 Euro, ohne
Konsistenzprüfung. Es bleiben verschiedene Scopes: gesamte Ackerfläche für den
GVE-Zugang, düngungswürdige Fläche für 50 m³, Prämienfläche der Fütterung und
Rinderdatenbank/Jahresbasis für 20 m³.

## Alle Tiere, Rationen und Nachweise

MB S. 5 wurde als Bild geprüft: die zusammengeführte 157-g-Zelle gilt für drei
Mast-/ungedeckte-Jungsauen-Phasen; gedeckte Jungsauen ab 50 kg stehen in der
125-g-Zeile. Luna behauptete eine leere Jungsauenzeile, Opus eine Beschränkung der
157-g-Zelle auf 32–60 kg. Beide Lesarten sind durch das Original widerlegt.
Die tatsächliche SRL-/MB-Abweichung 50/32 kg bei ungedeckten Jungsauen bleibt offen.

Luna ignoriert Rohprotein=999 und explizit falsche average_limit_met/phase_limit_met;
globale Compliance-/Proofbooleans genügen. Opus akzeptiert eine einzelne passende
32–60-kg-Phase trotz fehlender Rezeptur, technischer Plausibilität und ungültiger
Proteinquelle (eligible=true, 54 Euro). Eine passende Durchschnittsration maskiert eine
weitere 999-g-Ration. Rationen sind nicht an Tiere/Zeiträume gebunden.
Ein pig-Gruppe mit cattle_ge_2y und aktueller animal_count=1 ergibt 1 Schweine-GVE und
erfüllten Zugang; Kategorie/Tierart und Jahresdurchschnitt fehlen.

[22 exakte Beobachtungen](policy-probes.json) prüfen technische Reproduzierbarkeit,
keine gewünschte Fachentscheidung oder normativen Gesamtkonsum.
