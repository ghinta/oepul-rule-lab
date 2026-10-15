# Anlass und Änderungsgründe

[Lab #107](https://github.com/ghinta/oepul-rule-lab/issues/107) wurde nach der
abgeschlossenen Luna-Sichtung und dem Opus-Übergabeprotokoll freigegeben.
Die vorgesehenen neuen Opus-Veröffentlichungen sind jetzt verfügbar. Die
Sichtung soll vor dem begrenzten Thesis-Versuch tatsächliche Ausgaben und
Vertrags-/Quellenlücken sichtbar machen.

- Der feste PR-#79-Stand kann in einem separaten Checkout diagnostiziert werden;
  die Diagnose braucht weder dessen Merge noch den neuen Generierungsgate-Branch.
- Auswahl und Herkunft aller 36 Opus-Veröffentlichungen sind gebunden; genau
  26 aktuelle Kandidaten werden untersucht, zehn ersetzte bleiben historisch.
- Die bestehenden Luna-Fakten werden nur durch belegte Vertragszuordnung
  übersetzt. Explizite Lücken schützen vor erfundenen Erfolgsfällen.
- Ein gemeinsamer, begrenzter OPA-Runner lädt pro Run nur native Policy/Daten.
  Die bestehenden Luna-Ausgaben bleiben bytegleich reproduzierbar.
- Die Vergleichsmatrix trennt Quellen, Profil, Prompt, Modell/Adapter, Budget,
  Reparaturgeschichte, technische Statuswerte und offene Referenzarbeit.
- Der Anschluss an App #56 bleibt bei vier Einzelklauseln und unabhängigen
  Referenzen; die Diagnose fordert keinen vollständigen App-Ausbau.

Historische Runs, Quellen, Profile, Modelltests und App-Regeln wurden nicht
geändert. Es wurden keine neuen Modellaufrufe ausgeführt und keine fachlichen
Sollwerte aus selbst generierten Modelltests übernommen.
