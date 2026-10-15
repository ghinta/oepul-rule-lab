# Unabhängige Qualitätskontrolle: roher Heuwirtschafts-Run (o6_3)

Stand 15.10.2026. In der geprüften endgültigen Dossierfassung bleibt keine
wesentliche Unstimmigkeit offen. **Die native App-Aufnahme des historischen
Kandidaten bleibt blockiert.** Diese Kontrolle ist keine Expertenabnahme,
Regelreparatur oder Freigabe einer manuellen Studienadaptation.

Alle 158 öffentlichen Entwicklungsfälle mit 166 Komponentenprüfungen wurden
unabhängig bytegenau reproduziert: 151 definierte Ausgaben, sieben Laufzeitfehler,
keine undefinierte Ausgabe. 129 Erwartungen treffen zu, 37 nicht. Die gezielte
Auswahl enthält verwandte Quellen-, Nachweis-, Interface- und Stressfälle;
sie ergibt keine Modellgenauigkeitsquote.

Das vollständige sechsseitige Maßnahmenmerkblatt, alle sieben nativen
Produktionsmodule und die historischen Annahmen wurden unabhängig gelesen.
Ausgewählte gemeinsame Originalstellen wurden erneut geprüft; eine zweite
vollständige Lektüre aller gemeinsamen Rechtsquellen oder fachliche Abnahme
aller Tabellenzeilen wird nicht behauptet. GSP-/MOG-Details fehlen im Paket.
Studienreferenzfälle, GM-Prüfurteile und manuelle Adaptationstests wurden weder
gelesen noch als Sollwerte übernommen. Die technische BIO-Namensraumkontrolle
verwendet eine eingefrorene native Ausgabe und fügt keinen Quellenfall hinzu.

Die Identitäts- und Abdeckungskontrollen stimmen: 74 historische Regelkennungen,
85 erhaltene Bewertungen einschließlich elf Überschneidungen, alle 34
Vorschlagspfade als Multimenge und 35 Tabellenpointer in 13 Datendateien.
Alle 385 gespeicherten Prüfzeilen/-schlüssel sind typisiert gleich. Die Matrix
speichert 134 Nichtleerzellen; 286 Leerpaare sind implizit. Das Parameterobjekt
hat 18 direkte Schlüssel und 34 aufgefaltete Skalarwerte. Die 32 Teilbefunde
sind keine 32 unabhängigen Fehlerursachen. Eine zusätzliche Quellenpflicht ist
außerhalb des historischen Katalogs getrennt dokumentiert.

Alle 201 geprüften Codebereiche liegen in den gebundenen Originaldateien;
51 ausdrücklich zitierte Codezeilen stimmen. Die Wortlautkontrolle findet
1.278 dokumentgebundene Zitatvorkommen an 500 unterschiedlichen Kombinationen
aus Quelle, Seite und Zitat. Drei wiederholte Treffer benötigen nur den
nachgeprüften Leerraum vor einem Komma auf SRL-Seite 22. Sieben wiederholte
Zusammenfassungszitate sind durch Unterbelege abgedeckt. Ein Wortlauttreffer
bestätigt keine fachliche Schlussfolgerung oder Quellenhierarchie.

Vor der endgültigen Bindung wurde ein Vergleichsfehler korrigiert: Die
Erstjahres- und Folgejahreskontrolle liefern Stringlisten, die jetzt ausdrücklich
auf Gleichheit geprüft werden. Ein Matcher für Regelobjekte war dafür ungeeignet.
Dadurch werden aus den vorläufigen 128/38 die korrekten 129/37 Prüfungen.
Eingaben, Queries und fachliche Erwartungen bleiben unverändert; dies ist kein
zusätzlicher Modellfehler. Der vollständige Replay wurde danach erneut ausgeführt.

Wichtige Aussagegrenzen bleiben erhalten:

- Fünf Fehler entstehen bei ausdrücklich erlaubten Nullable-Zahlen: vier in der
  Hauptentscheidung, einer im getrennten Cap-Helfer. Zwei weitere betreffen
  schemawidrige Array-/Ganzzahl-Nullwerte. Das eigene `average_count` stellt
  Bruchteil-Jahresmittel dagegen tatsächlich besser dar als im Vorgängerrun.
- Das Quellenbeispiel ergibt korrekt 11 ha und 1.603,80 Euro. Die abgeschlossene
  Vorjahresschnitt-Probe isoliert die fehlende Jahresbindung; sie erfindet keine
  automatische Sanktion für einen beliebigen Bewirtschaftungsfehler.
- VF-, Acker-DIV- und Cap-Befunde prüfen konkrete Verbraucher. Der Cap-Hinweis
  verwendet den Rohsatz vor der Modulation. Der Betrag „nach Modulation“ wird
  zugleich nicht als versprochene endgültige Auszahlung umgedeutet.
- Vollfläche, Abtransport, eindeutige Grünfütterungstage für alle Tiere,
  Artenzuordnung und Anerkennungsumfang benötigen Belege. Fehlende Angaben
  beweisen keine tatsächlich verbotene Handlung.
- Kontrollausnahme und Übernahme enthalten ausdrücklich kontextabhängige
  Interface-Diagnosen; die Behördenbeendigung in P18 ist als tatsächliche
  Szenarioannahme benannt. Ein globales Anerkennungsflag allein beweist diese
  Tatsachen nicht. `contract_established` bleibt ein Erstjahresindikator.
- Der allgemeine Mindestgrößenhelfer ist vom stärkeren 2-ha-Heuwirtschaftszugang
  getrennt. Unbezahlte, weiterhin gebundene Fläche ist kein tatsächlicher Abgang.
- Die gesonderte App-Projektionsausführung zählt nicht als 159. Quellenfall.
  Der Durchlauf eines bestehenden Tierartfeldes beweist keine neue API-Freigabe.
  Die exakten numerischen Binary-Abweichungen sind ebenfalls keine pauschalen
  Modellfehler oder ein Nachweis für alle 26 Runs.

Befehl, Ergebnis- und Dateihashes, konkrete Quellenkontrollen und Grenzen stehen
in [quality.json](quality.json). Der Sammlungsabschluss bestätigt Abdeckung und
erzeugt weder Expertenfreigabe noch App-Promotion. Historische Regeln, Quellen,
Canonical-Profil, Runtime-Pin und produktive App blieben unverändert.
