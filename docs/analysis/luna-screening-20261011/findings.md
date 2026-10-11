# Befunde für die nächste Entscheidung

Alle 26 Kandidaten kompilieren isoliert. Von 78 synthetischen Entwicklungsfällen
liefern 76 einen nativen Wert; zwei liefern keinen Wert. Das ist eine technische
Bestandsaufnahme, keine Genauigkeitsquote. Vollständige Ergebnisse und Grenzen
stehen in [README.md](README.md), [Vorschau](index.html) und [method.md](method.md).

| Beobachtung | Konkrete Entwicklungsfälle | Folge für eine begrenzte App-Anbindung |
|---|---|---|
| Gesamte Query wird undefiniert | [o6_8 variation](results/o6_8.json), [o6_17 missing_fact](results/o6_17.json) | Fehlende Ausgabe als Diagnose anzeigen; weder Zustimmung noch Ablehnung daraus erzeugen. |
| Positives Teilurteil steht neben Verstoß | [o6_9 missing_fact](results/o6_9.json), [o6_11 variation](results/o6_11.json), [o6_17 variation](results/o6_17.json) | Teilurteile, Umfang und Verstöße getrennt darstellen; `eligible` nicht allein als Freigabe nutzen. |
| Fehlender Fakt lässt positives Urteil stehen | [o6_6](results/o6_6.json), [o6_7](results/o6_7.json), [o6_12](results/o6_12.json), [o6_14](results/o6_14.json), [o6_16](results/o6_16.json), [o6_19](results/o6_19.json), [o6_23](results/o6_23.json), [o6_24](results/o6_24.json): jeweils missing_fact | Datenvollständigkeit separat prüfen. Die Beobachtung legt noch kein fachliches Sollurteil für jeden fehlenden Fakt fest. |
| Ablehnung ohne passenden Fehlendaten-Grund | [o6_3 missing_fact](results/o6_3.json): `eligible=false`, `violations=[]` | Fehlende Eingabe und belegte Nichterfüllung unterscheidbar halten. |
| Prämienarithmetik läuft bei Verstößen weiter | [o6_3 variation](results/o6_3.json): 1.674 Euro; [o6_11 variation](results/o6_11.json): 162 Euro; [o6_15 variation](results/o6_15.json): 243 Euro; [o6_21 variation](results/o6_21.json): 972 Euro | Beträge als native Rechenwerte kennzeichnen; sie sind keine bewilligten Zahlbeträge. |
| Fehlender Fakt ändert unbemerkt die Rate | [o6_10 missing_fact](results/o6_10.json): fehlende Hangneigung, 324 → 216 Euro | Keine stillschweigende fachliche Ergänzung aus Standardwerten ableiten. |
| Datenreferenz liefert leere Prämienmap | [o6_14 baseline](results/o6_14.json): `premium_base={}` | Namespace-/Datentabellenanbindung vor einer Prämienanzeige klären. |
| Native Ausgabe ist nur ein Boolean | [o6_1b](results/o6_1b.json), [o6_22](results/o6_22.json) | Fehlende Begründungs-/Gesamtentscheidung ausdrücklich als Integrationslücke führen. |

Für die Thesis lohnt als nächster Schritt die Auswahl einiger fachlich relevanter
Regeln mit unterschiedlichen Formen: Grenzwert, zeitlicher Tatbestand, Liste bzw.
Zuordnung, Aggregation und Ausnahme. Die Katalogtypen und offenen Abhängigkeiten
aller 26 Maßnahmen bleiben in der Matrix sichtbar. Diese Auswahl wird nicht aus
einer Rangfolge der besten Luna-Ausgaben abgeleitet. Erst anschließend entstehen
unabhängige Referenzfälle und bestätigte Sollurteile für den kontrollierten Versuch.

Der vollständige App-Ausbau ist dafür nicht nötig. Bereits die dokumentierten
Ausgabelücken erklären, warum einheitliche Förderaussagen aus den heutigen
Kandidaten noch nicht belastbar sind. Die nächste Modellphase ist getrennt in
[Opus #107](https://github.com/ghinta/oepul-rule-lab/issues/107) erfasst.
