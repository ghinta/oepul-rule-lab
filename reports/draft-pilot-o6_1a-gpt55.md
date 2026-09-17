# Draft: Pilot `o6_1a` mit `gpt-5.5`

Status: **DRAFT – technisch reproduzierbarer Kandidat, nicht fachlich freigegeben**

Hinweis: Dieser historische Pilot entstand vor den Grounding-Verträgen v2.
Seine damalige Vertragsprüfung ist deshalb nicht mit der heutigen Prüfung von
wörtlichen Belegen, Coverage, Datentabellen und validierten Profilvorschlägen
gleichzusetzen. Für Modellvergleiche muss die Maßnahme mit den aktuellen
Verträgen neu erzeugt werden.

Dieser Pilot prüft, ob ein Modell aus dem Canonical Farm Profile und den
amtlichen Quellen einen möglichst vollständigen, ausführbaren Regelkandidaten
erzeugen kann. Er ist kein Nachweis fachlicher Vollständigkeit oder
Rechtsverbindlichkeit.

## Lauf

- Run-ID: `pilot2-o6_1a-gpt55`
- Maßnahme: `o6_1a` – Umweltgerechte und biodiversitätsfördernde Bewirtschaftung
- Modus: `discover`
- Modell: `gpt-5.5`, Reasoning `high`
- Quellen: Maßnahmenblatt Stand April 2026, allgemeine
  Teilnahmebedingungen Stand April 2026, Sonderrichtlinie samt Anhängen und
  vier amtliche Hinweise für 2026
- Technische Referenz: OPA `1.18.2`

## Ergebnis

| Signal | Ergebnis |
|---|---:|
| Strukturierte Regeln | 70 |
| Quellenbelege | 63 |
| Rego-Dateien inklusive Tests | 2 / 1.008 Zeilen |
| Erkannte verwendete Profilpfade | 141 |
| Profilpfade hinzugefügt | 194 |
| Profilpfade entfernt | 28 |
| Profilpfade geändert | 5 |
| Ausgelagerte Datendateien | 1 / 27.038 Bytes |
| Generierte OPA-Tests | 7 |
| OPA Strict-Compile | bestanden |
| OPA Tests | 7/7 bestanden |
| Regelkatalog-Vertrag | bestanden |
| Quellenbeleg-Vertrag inkl. Hash-/Pfadprüfung | bestanden |

Die Datendatei enthält unter anderem 20 RGVE-Faktoren, 85 seltene
Kulturpflanzen, 53 Blüh-/Heil-/Gewürzpflanzen, 74 autochthone Ackerarten und 68
autochthone Grünlandarten. Die Streuobstliste ist ebenfalls strukturiert
enthalten. Damit bleiben lange geschlossene Listen ausführbar, statt nur als
Textzusammenfassung im Regelkatalog zu stehen.

## Was der Pilot bereits zeigt

1. Das Ausgangsprofil war für eine breite UBB-Extraktion deutlich zu klein.
   Der Discover-Lauf konnte fehlende Eingaben sichtbar ergänzen, statt Regeln
   wegen fehlender Variablen wegzulassen.
2. Das Modell erzeugte einen großen Regelkandidaten mit Quellenbindung und
   ausführbarem Rego. Ein zunächst vorhandener Rego-Fehler wurde in einer
   Reparaturrunde gefunden und behoben.
3. Ein zweiter Fehler lag nicht in Rego, sondern im Experiment-Framework: Die
   JSON-Ausgaben ähnelten den Verträgen, hielten sie aber nicht exakt ein. Der
   Finalizer prüft deshalb nun nicht mehr nur Zähler, sondern Vertragsfelder,
   Quellenhashes und auflösbare Artefaktpfade.
4. Der erste Eingabepfad-Scanner übersah Zugriffe über `object.get` und meldete
   fälschlich null Pfade. Der Scanner verfolgt nun auch verschachtelte
   `object.get`-, Alias- und Collection-Zugriffe; im Pilot werden 141 Pfade
   erkannt.

## Offene Risiken

- 70 Regeln sind ein Umfangssignal, kein Vollständigkeitsbeweis. Es wurde noch
  kein unabhängiger Absatz-für-Absatz-Abgleich durch eine zweite Extraktion oder
  eine Fachperson durchgeführt.
- Sieben Modelltests decken nur einen kleinen Teil der 70 Regeln und der vielen
  Ausnahmen ab. Sie beweisen technische Ausführbarkeit, nicht fachliche
  Richtigkeit.
- Die große Profiländerung (194 hinzugefügt, 28 entfernt, 5 geändert) ist
  wertvoll für die Entdeckung, aber zu groß für ein sofortiges Einfrieren ohne
  Review. Entfernte und geänderte Pfade müssen besonders geprüft werden.
- Quellenbelege lokalisieren Aussagen, ersetzen aber keine fachliche Prüfung
  von Definitionen, Wechselwirkungen und Prioritäten zwischen Merkblatt,
  Sonderrichtlinie und jahresspezifischen Ausnahmen.
- Der dritte Modellaufruf endete nach erfolgreicher Vertragsumstellung am
  Nutzungslimit. Maßgeblich ist daher nicht sein Exit-Code, sondern die danach
  unabhängig erfolgreiche Finalisierung mit leeren Vertragsfehlerlisten und
  grünem OPA-Lauf.

## Empfehlung vor dem Einfrieren

Den Experimentvertrag jetzt versionieren, aber das entdeckte Farm Profile noch
nicht als fachlich endgültig einfrieren. Als nächstes sollte dieselbe Maßnahme
mit mindestens einem zweiten Modell im identischen `discover`-Setup laufen.
Danach lassen sich Regelmenge, Quellenabdeckung, Profil-Diff, Datenlisten,
Compile-Erfolg und Tests direkt vergleichen. Erst die gemeinsam gestützten
Profiländerungen werden in einen überprüften Profilstand übernommen; darauf
folgen `conform`-Läufe, Hidden Tests und Domainexpert:innen-Tests.

Die vollständigen Pilot-Artefakte bleiben bewusst unter `runs/` und werden
nicht eingecheckt, weil sie Modell-Rohlogs und duplizierte Quellen enthalten.
Dieser Draft hält die prüfbaren Resultate fest; die Quellen, Verträge, Runner
und Reproduktionsschritte sind versioniert.
