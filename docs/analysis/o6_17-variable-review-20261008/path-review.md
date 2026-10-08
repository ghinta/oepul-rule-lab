# Vorher/nachher und nötige Belege

Alle 122 Pfade mit exakten Werten vorher/nachher: [leaf-review.json](leaf-review.json).
Ausgangsinventar: [vollständiger Diff](../all-measure-variable-review-20261008/o6_17/variable-diff.json).
App-Pin: `5296108f5756ef1463c25a49d93d4a346e9b5e9c`.

| Gruppe / Blattpfade | Bisher → Luna / Opus | Noch offener Evidenzvertrag |
| --- | --- | --- |
| Vertrag/Person/Kombination/Fläche/Zahlung 34 | allgemeine Farm-/Flächendaten → oepul.o6_17 / farm.oepul.o6_17 | amtlicher Vertrag, aktueller Antrag, Erstjahr, Personen, Übernahme/Exit, getrennte Zahlung |
| Arten/Abschnitt/Jahr/Geometrie 21 | fehlt → o6_17.sections/observed_kennarten / species_rich.survey_sections | tatsächliche jährliche Begehungs-/Abschnitts-ID, Geometrie, regelmäßige Verteilung/Blüte, klare Kennart-ID |
| GIS/Nutzung/Grund-/AGL-Prämie 18 | slope/land_use → globale Score-/Slope-Flags / Schlag-grassland_number, field_use_type, codes | amtliche Schlagversion/Nutzung, Steigung/Grünlandzahl, GLÖZ-Teilflächen, aktueller AGL-Code und Flächenauswahl |
| Kurse/Personen/Anrechnung 18 | fehlt → flache training-Felder / training.courses | eindeutige Kurse/Personen, echte Themen/Stunden/Datum/Anbieter, Anerkennung und Ersatz/Mehrfachanrechnung |
| Bodenproben MFA 2025 14 | fehlt → freie Basis/Anzahl / soil_sample_base und soil_samples | feste amtliche Fläche, einzigartige Probe/Labor, echte Chronologie, Parameter/Methode/GIS/Jahr |
| Umbruch/Ereignis/Bewilligung 9 | fehlt → grassland_break_* / datierte grassland_breaking_events | gesamte Vertragshistorie aller Grünlandflächen, Einzelflächen-ID, Notwendigkeit/Mischung, vorherige Bewilligung |
| Tierbesatz/Futter/LN/Erstjahr 8 | allgemeine Tiere/Fläche → freie Gesamtwerte / RGVE-Kategorien und tatsächlich kodierte Futterparzellen | bestätigter Jahresbestand mit Tiermerkmalen, Haltung, kompletter Futterfläche und Erstjahres-LN ohne Alm |

Kein Pfad ist aufgenommen. Luna `oepul.o6_17` ist kein bestätigter Alias von
Opus `farm.oepul.o6_17`; App `payload.oepul.measures` ist ein weiterer Vertrag.
Lunas freie Kennartnamen und Opus snake_case-IDs benötigen dieselbe fachliche
Gruppenentscheidung, aber unterschiedliche technische Adapter. Boolesche
Dokumentationsfelder ersetzen weder aktuelle Ereignisse noch Expertenbelege.
