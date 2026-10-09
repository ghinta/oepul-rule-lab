# Prüfung der Bündelung

Lab-Basis: `b4c56fa55d7e2f9cbfd6ef4180750c672f5facc2`.
App-Pin: `5296108f5756ef1463c25a49d93d4a346e9b5e9c`.
Historische Quellenbasis: `7a296d28cb5b92e2758c5a3889c929ea1db60fe5`.

Die [Integritätsprüfung](validate.py) rekonstruiert die bestehenden Frage-IDs aus
den Originaldateien: genau 289 präzisierte und 129 ursprüngliche, disjunkte IDs.
Alle 418 sind unbeantwortet und `open_before_app_admission`. Die acht fest
erwarteten o6_3-Blocker bleiben `open_before_full_recommendation`; ihre technische
Artefaktfrage wird nicht als fachliche Antwort ausgegeben.

Die Prüfung kontrolliert zehn Familien, bestätigte Produktvorgaben, Quellenhashes,
die tatsächlichen Fragebezüge in den Blockscopes, lokale Dokumentlinks und einen
azyklischen Umsetzungsplan. Sie verwirft sieben Mutationen: verlorene Frage,
entfernte Blocker, veränderter Blockerstatus, erfundene Antwort, verlorene Familie,
entfernte Produktvorgabe und zyklische Abhängigkeit. Der zusätzliche CI-Schritt
verhindert, dass diese Schutzbedingungen unbemerkt entfallen.

```bash
python docs/analysis/domain-expert-agenda-20261009/validate.py --self-test
```

Mit `--app-root /pfad/zum/gepinnten/Appcheckout` werden außerdem die elf
aus dem bestehenden Abgleich übernommenen App-Dateihashes und technischen
Codeanker lokal geprüft. CI benötigt dafür weder App-Checkout noch Netzwerk.
Das [Eingabemanifest](input-manifest.json) schützt 58 bestehende Artefakte:
56 bleiben bytegleich, zwei Navigationsdateien erhalten lediglich den ausdrücklich
prüfbaren Agenda-Einstieg. Alle 27 Originalfrage-/Blockerdateien bleiben bytegleich.

Die [unabhängige Schlussprüfung](independent-review.json) hat zusätzlich Formulierungen, Geltungsbereiche,
Ausnahmen, Herkunft und Umsetzungsvoraussetzungen geprüft; kein materieller Befund bleibt offen. Der maschinenlesbare lokale
Prüfbericht steht in [verification.json](verification.json). Die abschließenden
CI-Ergebnisse werden für den konkreten neuen Commit im bestehenden Draft #103
und Sammelissue #140 verlinkt.

Dies sind Integritäts- und Planungsprüfungen. Die Agenda liefert keine neue
fachliche Freigabe, bewertet keine Modellqualität und behauptet keine neue
App-E2E-Prüfung. App-Code, Thesis, historische Modellläufe und deren Belege wurden
in diesem Konsolidierungsschritt nicht verändert.
