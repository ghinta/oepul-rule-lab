# Prüfung der Vorabrecherche

Basis ist Lab-Commit `c5ea6e963de593767127fdea43b357b1ea112211`.
Alle 418 bestehenden Fragen und acht o6_3-Blocker bleiben offen/unbeantwortet;
31 Originaldateien einschließlich Agenda-/Frage-/Blockerdaten bleiben bytegleich.
Die vorherige Agenda-README erhält genau einen prüfbaren Recherchelink.

Die [Integritätsprüfung](validate.py) kontrolliert zehn Familien mit 30 Vorschlägen,
echte bestehende Frage-/Blocker-/Restscope-Referenzen, Belege, Quellenmetadaten,
Zitatgrenzen einschließlich Spiegel desselben Werks und ausdrücklich vorläufige
Prüffälle. Ein Metadatenhash wird nicht als Hash der Original-PDFbytes ausgegeben.
Sieben negative Mutationen dürfen keine stillschweigende Freigabe ermöglichen.

```bash
python docs/analysis/domain-expert-research-20261009/validate.py --self-test
python docs/analysis/domain-expert-agenda-20261009/validate.py --self-test
```

Der lokale Bericht steht in [verification.json](verification.json).
Die [unabhängige Evidenzprüfung](independent-review.json) prüft zusätzlich
wesentliche Auslegungen gegen amtliche Originalabschnitte und kennzeichnet
verbleibende Grenzen. CI für den neuen Commit wird im bestehenden Draft #103
und Sammelissue #140 verlinkt.

Diese Prüfung bestätigt Dokumentintegrität und nachvollziehbare Vorarbeit.
Sie bewertet keine reale Betriebsakte, Modellqualität oder neue App-E2E-Funktion.
Die 85 Fälle sind Vorschläge zur fachlichen Bewertung und wurden nicht als
App-Golden-Tests ausgeführt. Eine vollständige aktuelle Norm-/Tabellenaufnahme
oder verbindliche Expertenantwort wird ausdrücklich nicht behauptet.
