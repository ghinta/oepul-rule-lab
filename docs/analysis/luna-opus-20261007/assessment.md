# Luna–Opus: Entwicklungsbasis nach Finalisierung von o6_3

Stand: 7. Oktober 2026. Gebundener Lab-Hauptstand:
`84482b59264c04e3f645460ebe15f6b64b3b85ef` (PRs #95 und #96 gemergt).
Die Opus-Überarbeitungen vom angekündigten 8. Oktober sind hier noch nicht
enthalten. Dies ist eine explorative Integrationsbewertung.

## Gesamter Bestand

Je Maßnahme wird der letzte finalisierte Luna-/Opus-Kandidat des gebundenen
Standes betrachtet. Es gibt jetzt 26 vollständige Paare. Ausgangsprofil-Hash
und die im Coverage-Artefakt gebundenen Quelldateien/-hashes stimmen in allen
Paaren überein. Adapter, Generierungszeitpunkt, Reparaturen und Feedback sind
nicht kontrolliert. Gleiche Quellenbindung beweist keine gleiche Abdeckung.

| Kennzahl | Luna 5.6 | Opus 5.5 |
| --- | ---: | ---: |
| Strukturierte Regeldatensätze | 1.098 | 2.750 |
| Generierte Tests laut Run-Metriken | 209 | 2.182 |
| Regeln ohne deklarierte Rego-Symbole | 445 | 327 |

Opus hat insgesamt etwa 2,50-mal so viele Regeldatensätze. UBB und Bio liegen
bei etwa 4,49 bzw. 4,65. Aufteilung, dokumentarische Aussagen und allgemeine
Bedingungen beeinflussen diese Zahlen; sie sind kein Korrektheitsscore.
Die vollständige Auswahl, Quellenbindungen und Artefakthashes stehen in
`comparison.json`, die Kennzahlen je Maßnahme in `comparison.csv`.

## Heuwirtschaft: sieben sichtbare Entwicklungsfälle

Kandidaten: Luna `v2-o6_3-luna-high-20261001` (29 Regeln, 5 generierte Tests)
und Opus `v2-o6_3-opus-5.5-high-20260930` (74 Regeln, 45 generierte Tests).
OPA 1.18.2 wertete unveränderte Regeln und Tabellen mit synthetischen
Modelleingaben aus. Quellenklauseln bestimmen die Sollbeobachtung; die
Fallauswahl entstand nach Einsicht in die Artefakte. Das sind sichtbare
Entwicklungsfälle, keine unabhängigen Golden-/Held-out-Tests. Daraus wird
kein modellübergreifender Erfolgsprozentsatz berechnet.

Die Ergebnisfelder der Kandidaten sind verschieden. `eligible` bei Luna
und `access_met` bei Opus werden ausdrücklich nicht als gleichwertige
vollständige Förderentscheidung gezählt. Der Fallvergleich betrachtet
jeweils die konkrete Quellenklausel, RGVE oder Prämie.

| Fall und Sollbeobachtung | Luna | Opus | Integrationsfolge |
| --- | --- | --- | --- |
| Merkblatt-Beispiel: 5 RGVE / 13 ha, Prämie für 11 ha | 1.603,80 EUR | 1.603,80 EUR | Gemeinsamer positiver Entwicklungsfall; Luna übernimmt vorbereitete Prämienflächenflags. |
| Folgejahr ohne Tiere: keine neue Erstjahresschwelle, aktuelle Prämie 0 | `first_year_access=false`, Erstjahresverstoß, Prämie 0 | Kein Zugangsausfall, Prämie 0 | Bei Luna historischen Zugang und aktuellen Prämiensatz trennen. |
| Erstjahr, 4 adulte Neuweltkamele auf 2 ha: 0,60 RGVE = 0,30/ha | 0 RGVE, Zugang verneint | 0,60 RGVE, Zugang erfüllt | Nicht erreichbare Tierkategorien im Luna-Mapping reparieren. |
| Erstjahr, 1 kleiner adulter Equide auf 2 ha: 0,50 RGVE = 0,25/ha | 1 RGVE, Zugang bejaht | 0,50 RGVE, Zugang verneint | Größe/Kategorie eindeutig erfassen; Luna ordnet `horses` pauschal großen Equiden zu. |
| Jahr 2030 bei Vertrag ab 2024, Vertragsende 2028 | `eligible=true`, 291,60 EUR | Prämie 0, Satz undefiniert | Aktuelles Prüfjahr und Vertragsgrenzen explizit prüfen; undefinierte Werte behandeln. |
| Silagelagerung unbekannt | Kein Verstoß, `eligible=false`, rechnerische Prämie 291,60 EUR | Kein Verstoß, rechnerische Prämie 291,60 EUR | Beide brauchen den dreistufigen Missing-Data-Vertrag; eine rechnerische Prämie ist keine bestätigte Förderfähigkeit. |
| Dürregebiet 2026, ungemähtes Kleegras | Allgemeines `drought_exception_applies=true`; keine eigenständige Mindestbewirtschaftungsprüfung | Kein solcher Automatismus; Bewirtschaftungsverstoß | Ausnahmeklauseln nach Flächenart und betroffener Pflicht begrenzen. |

Im letzten Fall ist der Luna-Prämienflächenflag ausdrücklich `false`, damit
keine fehlende Mahd durch einen unzutreffenden vorgeschalteten Flag verdeckt
wird. Beide Kandidaten geben dort eine Prämie von 0 aus. Der Unterschied
betrifft die behauptete Anwendbarkeit der Ausnahme und die eigene
Bewirtschaftungsprüfung, nicht einen nachgewiesenen Prämienunterschied.

### Quellen und Codebezug

- Merkblatt `o6_3_heuwirtschaft_2025_10.pdf`: S. 1/Kap. 3.1
  Vertragsende; S. 2/Kap. 3.3–4 Erstjahreszugang und Tierhaltereigenschaft;
  S. 3/Kap. 5.3 Silagelagerung; S. 4/Kap. 7 Tierbesatz in Folgejahren;
  S. 5/Kap. 7 Beispiel und Kap. 8 kleine Equiden; S. 6/Kap. 8 Neuweltkamele.
- SRL `20241011_srl_oepul_2023.pdf`, PDF-S. 11, 1.6.3.1:
  Ackererntepflicht ausdrücklich „ausgenommen Ackerfutterflächen“;
  1.6.3.3 regelt Grünland-/Ackerfutterbewirtschaftung gesondert.
  Der Hinweis vom 05.08.2026 beschreibt eine Erleichterung der
  Ackererntepflicht. Eine Übertragung auf die getrennte Ackerfutterpflicht
  ist dadurch nicht belegt und muss vor Promotion geklärt werden.
- Luna `workspace/policy/o6_3_heuwirtschaft.rego`: `first_year_access`
  verwendet aktuellen `tierholding(input)` trotz vorhandener historischer
  RGVE-Angaben; `rgve_animal` hat nur drei Zuordnungen; `eligible` prüft
  kein Vertragsende; `drought_exception_applies` prüft nur `land_use=arable`.
- Opus `workspace/policy/o6_3/`: `eligibility.rego` trennt das Erstjahr;
  `livestock.rego` verwendet Kategorien; `premium.rego` begrenzt das
  Vertragsjahr; `obligations.rego` verwendet bei mehreren fehlenden
  Fakten günstige Defaults. Das ist keine ausreichende Unbekannt-Semantik.

Die detaillierten Inputs, Outputs und ausführbaren Policy-/Datenhashes
stehen in `o6_3-probes.json`. Der zusätzliche `small_equid`-Hinweis im
Luna-Fall wird vom Kandidaten nicht konsumiert; seine vorhandene
Tierarten-/Kategoriezuordnung kann kleine adulte Equiden nicht unterscheiden.
Das ist eine dokumentierte Mapping-Grenze, kein gemeinsames Eingabeschema.

### Weitere offene Opus-Annahmen

Opus setzt „überwiegender Teil“ als mindestens 92 Tage um und addiert Tage
am Heimbetrieb und Gemeinschaftsweide/Alm. Aus den hier geprüften Quellen
folgt keine ausdrückliche Bestätigung dieser Erfassungs-/Zählweise.
Außerdem unterdrückt ein einzelnes `force_majeure.recognised=true` pauschal
alle inhaltlichen Verstöße. Anerkennung, betroffene Verpflichtung, Fläche
und Zeitraum brauchen einen fachlich begrenzten Vertrag. Diese Punkte
sind Review-Aufträge; sie wurden nicht als sieben weitere bestandene oder
fehlgeschlagene Quellenfälle gezählt.

## Entscheidung für die Implementierung

Der vereinbarte Weg **Luna-Slice → Quellen-/Opus-Deltas → gezielter
Sol-Review** bleibt möglich. Heuwirtschaft darf mit dem jetzigen Luna-Code
erst nach den belegten Reparaturen und dem Eingabe-/Zeitvertrag integriert
werden. Opus liefert für die vier geprüften Quellenaspekte die bessere
Vorlage; seine Defaults und offenen Annahmen werden dabei nicht übernommen.

Die unmittelbaren Integrationsaufträge sind:

Die belegten Reparaturen und offenen Fachfragen sind in
[Issue #97](https://github.com/ghinta/oepul-rule-lab/issues/97) gebündelt.

1. Aktuelles Förderjahr, Vertragszeitraum und aktuelle/historische Fakten
   im gemeinsamen P1-Vertrag festlegen.
2. Erstjahresnachweis von der aktuellen RGVE-/Prämienberechnung trennen.
3. RGVE-Kategorie, Größen-/Altersklasse und Durchschnittsbestand samt
   Runtime-Mapping definieren; unbekannte Kategorien als Datenlücke zeigen.
4. Silage-/Mahd-/Ausnahmeangaben über Registry, Dependency und OPA
   durchgängig konsumieren; unbekannt, Nein und bestätigte leere Mengen trennen.
5. Dürre- und höhere-Gewalt-Scope fachlich klären; alle Adaptationen mit
   Quellen und Kandidatenherkunft im Maßnahmen-PR dokumentieren.

UBB/o6_8/o6_9/o6_16 benötigen weiterhin den geplanten klauselspezifischen
Vergleich für die erste Tranche. Dieser Review behauptet keine vollständige
semantische Abnahme aller 26 Maßnahmen. Nach den Opus-Überarbeitungen
werden betroffene Artefakte neu gebunden und Deltas erneut geprüft.
