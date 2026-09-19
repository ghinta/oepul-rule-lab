# Draft: `o6_16` mit `gpt-5.6-terra`

Status: **DRAFT – technisch validierter Kandidat, nicht fachlich freigegeben**

Dieser Lauf untersucht, ob ein Discover-Agent bei einer bisher wegen fehlender
Eingaben weitgehend geparkten Maßnahme mehr quellengebundene Regeln und
Profilvariablen erschließen kann. Regelanzahl und technische Tests sind keine
Behauptung fachlicher Vollständigkeit oder Rechtsverbindlichkeit.

## Lauf

- Run-ID: `v2-o6_16-terra-20260919`
- Maßnahme: `o6_16` – Vorbeugender Grundwasserschutz – Acker
- Modus: `discover`
- Modell: `gpt-5.6-terra`, Reasoning `high`
- Maßnahmenspezifische Quelle: Stand April 2026
- Weitere Quellen: Allgemeine Teilnahmebedingungen April 2026,
  Sonderrichtlinie samt Anhängen und vier amtliche Hinweise für 2026
- Technische Referenz: OPA `1.18.2`

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 34 |
| Davon mit explizitem Rego-Symbol | 21 |
| Quellenbelege | 30 |
| Coverage-Einträge | 40 |
| Vorgeschlagene Profil-Blattpfade | 94 |
| Davon im repräsentativen Parcel-Objekt | 47 |
| Von Rego direkt verwendete Eingabepfade | 21 |
| Unbekannte Rego-Eingabepfade | 0 |
| Datentabellen | 4 |
| Datendatei | 210.643 Bytes |
| Generierte OPA-Tests | 9 |
| OPA Formatierung | bestanden |
| OPA Strict-Compile | bestanden |
| OPA Tests | 9/9 bestanden |
| Grounding-Verträge und Crosslinks | bestanden, keine Fehler |
| Canonical Farm Profile direkt verändert | nein |

Die 94 Blattpfade sind in einem einzigen nicht überlappenden
`add oepul.o6_16`-Blueprint gebündelt. Die Zahl der Vorschlagsobjekte ist daher
nicht mit der Anzahl entdeckter Variablen gleichzusetzen. Erfasst wurden unter
anderem Teilnahme und Vertragsfristen, Flächenhistorie, betriebliche
Düngeplanung und -bilanz, Weiterbildung, Gewässerschutzkonzept, Bodenproben,
Wiener Humusoption, Schweinefütterung, Cultan sowie detaillierte Schlagattribute
für N-Saldo, Wirkstoffe, Sperrzeiträume und AG-Flächen.

## Vollständige Daten statt Textverkürzung

Die erzeugte Datendatei enthält:

- 1.566 Einträge der Anhang-G-Gebietskulisse mit KG-Nummer, Bundesland,
  Quellseite und Tabellenrohtext,
- Rohprotein-Grenzen für die Schweinefütterungsoption,
- Prämiensätze und
- die 2026-Dürre-Ausnahmekulisse.

Die Katastralgemeinden werden über die stabile KG-Nummer ausgewertet. Die
Textextraktion trennt politische Gemeinde und Katastralgemeinde nicht in jeder
Zeile zuverlässig; diese verbleibende Einschränkung ist ausdrücklich im Run
dokumentiert.

## Vergleich mit dem bisherigen Stand

Das bestehende Rule-Gap-Audit führte `o6_16` als `C / park`, mit keiner
fachlichen Abdeckung und fehlenden N-/Nährstoffbilanzdaten. Der ältere
GPT-5.5-Zero-Shot-Lauf auf dem Merkblatt Stand Oktober 2025 enthielt zehn
Required-Input-Pfade, zehn eindeutige Regel-/Fehlercodes und fünf Tests. Er
verwendete mehrere vorbewertete Fakten, etwa
`soil_samples.requirement_met`, und enthielt keine vollständige ausführbare
Anhang-G-Gebietsliste.

Der Terra-Lauf ist mit 34 strukturierten Regeln, 94 neuen Profil-Blattpfaden,
vier Datentabellen und neun Tests deutlich breiter. Das ist jedoch **kein
isolierter Modellvergleich**: Neben dem Modell unterscheiden sich Quelle
(April 2026 statt Oktober 2025), Experimentvertrag, Discover-Profilpolitik und
Grounding-Validator. Für einen belastbaren Modellvergleich muss dieselbe
Maßnahme anschließend mit einem zweiten Modell im identischen v2-Setup laufen.

## Reparaturhistorie

Der Run benötigte fünf getrennt protokollierte Versuche:

1. Abbruch durch das gemeinsame Nutzungslimit während eines zunächst parallel
   gestarteten Mehrmaßnahmenversuchs.
2. Vollständige Terra-Extraktion.
3. Reparatur der deterministisch gefundenen Beleg-, Profil- und
   Dateninventarfehler; danach bestand Grounding vollständig.
4. Reparatur einer Python-artigen, in Rego v1 ungültigen Inline-Bedingung.
5. Korrektur der OPA-Datenpfade vom nicht vorhandenen Dateinamens-Namespace auf
   die tatsächlich geladenen `data.*`-Rootfelder.

Die letzte Host-Abnahme bestand Grounding, Formatierung, Strict-Compile und
alle neun Tests.

## Offene Risiken

- Neun selbst erzeugte Tests decken 34 Regeln und zahlreiche Grenzfälle nicht
  ausreichend ab.
- 13 Katalogregeln sind noch nicht explizit mit einem Rego-Symbol verknüpft.
- Externe Rechtsstände, auf die das Merkblatt verweist, wurden nicht erfunden;
  insbesondere bleibt der Zulassungsstatus einzelner Wirkstoffe ein externer
  Parameter.
- Die 94 Profilpfade sind ein wertvoller Discover-Kandidat, aber noch kein
  freigegebenes Canonical Farm Profile.
- Domainexpert:innen- und unabhängige Golden-/Negativtests stehen aus.

Die vollständigen Laufartefakte bleiben bewusst unter `runs/` und werden wegen
Rohlogs und duplizierter Quellen nicht eingecheckt. Dieser Draft hält die
prüfbaren Kennzahlen, Einschränkungen und Reparaturhistorie fest; Quellen,
Verträge, Modellkonfiguration und Validator sind versioniert.
