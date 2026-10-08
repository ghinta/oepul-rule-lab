# BIO: nachgewiesene technische Befunde

Alle Proben lesen die historischen Policies unverändert. Eingaben, Queries und
Ausgaben stehen in `policy-probes.json`; `--opa-bin` führt sie erneut aus. Das
beobachtete Ergebnis ist keine gewünschte Förderentscheidung.

| ID / Probe | Beobachtung | Konsequenz vor Integration |
| --- | --- | --- |
| `LUNA_YEAR_FROM_FARM` | Bei `{farm:{year:2027}}` liefert `data.o6_1b.year` **2026**. Policy Zeile 57: `object.get(input, "year", 2026)`. | Aktuelles Antragsjahr explizit durchreichen; keine stillschweigende Jahresvorbelegung. Snapshot-/Quellstand getrennt prüfen. Die Probe benutzt 2027 ausschließlich zur Erkennung des Defaults. |
| `LUNA_FIELD_MISSING`, `LUNA_FIELD_FALSE` | Bei 20 ha Acker liefert `arable_field_biodiversity_valid` sowohl bei fehlendem Flag als auch bei ausdrücklich `false` **true**. Default Zeile 21, Bedingungen Zeilen 133–140. | Feldstücksprüfung hat keine wirksame Negativprüfung. Kein positives Ergebnis aus fehlenden Daten; individuelle Feldstücke und Mindest-DIV-Flächen nachweisen. |
| `LUNA_MONITORING_WITHOUT_INTRO` | Biodiversitätsmonitoring mit `introductory_event_completed:false` wird **true**. Alternative Bedingungen Zeilen 189–213 reichen jeweils für Erfolg. | Allgemeine und programmspezifische Voraussetzungen gemeinsam prüfen; Programmnamen differenzieren. MB S. 24 verlangt die Einführung im ersten Teilnahmejahr. |
| `OPUS_GAP_MISSING`, `OPUS_GAP_FALSE` | Fehlender `control_body_change_without_gap` erzeugt keine ZT-002-Verletzung, `false` schon. Teilnahme-Policy Zeile 66 verwendet Default **true**. | Fehlende Evidenz ist nicht bestätigte Lückenlosigkeit. „Kein Wechsel“ und belegter lückenloser Wechsel explizit unterscheiden. Keine endgültige Förderentscheidung aus dem isolierten Verletzungsset ableiten. |
| `OPUS_DIVNFZ_START_MISSING`, `OPUS_DIVNFZ_START_KNOWN` | Mahd 22.06.2026: ohne Abschlussdatum nächste Nutzung **25.08.**, bei Ballenabtransport/Abschluss 24.06. **27.08.**. Grünland-Policy Zeilen 204–211. | Der Fallback auf Mahddatum nimmt einen unbekannten Abschluss an. MB S. 19–20 nennt ausdrücklich Abtransport/Weidepflege und das Beispiel 27.08. Fehlender Abschluss muss offen bleiben. |

Zusätzlich am Code geprüft: Luna schlägt `installation_delay_days` vor, nutzt
es im Pheromon-Prädikat (Zeilen 215–222) aber nicht. Opus prüft mehr
Pheromonbedingungen (Options-Policy Zeilen 300–312), enthält dort jedoch ebenso
keine Prüfung der Aufbewahrung bis 30. September beziehungsweise Ende der
Vegetationsperiode. Deshalb bedeutet ein vorhandener Profilvorschlag nicht,
dass alle zugehörigen Anforderungen bereits geprüft werden.

Die aktuelle App prüft BIO nur über Zertifikat, relevante Gesamtflächen und eine
7-%-Ackerquote. Bei gemischter Fläche meldet sie eine technische Anrechnungslücke;
bei höchstens 2 ha Acker kann sie ohne Grünland-DIV-Prüfung `eligible` mit
`phase1_baseline_check_passed` liefern. Dies ist ein vorhandener eingeschränkter
Vertrag, keine umfassende rechtliche BIO-Prüfung. Neue Regeln benötigen einen
entsprechend erweiterten fachlichen Ergebnis- und Evidenzvertrag.

Keiner dieser Befunde verändert die Run-Artefakte oder beantwortet offene
Expertenfragen. Reparaturen erfolgen erst in einem eigenen Implementierungsslice
mit Quellenbelegen und geeigneten Grenzfalltests; dessen Ziele dürfen diese
bekannten Fehlprüfungen nicht als Sollverhalten übernehmen.
