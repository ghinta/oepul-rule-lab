# Warum

Die in #99 reparierten Luna-Regeln sind noch nicht mit der App verdrahtet.
Vor neuen Eingabefeldern braucht jedes Feld einen Quellen-, Zeit-, Identitäts-
und Verbrauchsvertrag. #135 liefert die aktuelle Faktenbasis, aber keine
RGVE-Kohorten oder maßnahmenspezifischen Nachweise.

# Entscheidung

46 Eingabepfade des vorhandenen Pydantic-Vertrags werden vollständig auf
17 Regelgruppen, 46 Quellenbelege und den App-Stand nach #135 abgebildet.
Vier vorhandene registrierte Felder werden zur Wiederverwendung ausgewiesen;
Registrierung und tatsächlicher o6_3-Verbrauch werden getrennt geprüft.
Normative Tabellen bleiben Daten und keine editierbaren Betriebsvariablen.

Tierkohorten, autoritative Durchschnitts-/Stichtagsbasis, Saisonhistorie und
Vorfallszeitraum brauchen Ergänzungen im nächsten Integrationsschritt.
Ungeklärte Rechtsfolgen und allgemeine Förderbedingungen bleiben Blocker.
Der vollständige Entwurf kann vor den angekündigten Opus-Revisionen reviewed
werden; deren Gegenprüfung bleibt ausdrücklich ausstehend.

# Prüfumfang und Grenzen

Hashbindung, Input-Schema-Vollständigkeit, Quellenzitate, alle 20 RGVE-Werte,
Registry-/Dependency-Zuordnung und zehn sichtbare Entwicklungsbeobachtungen
werden geprüft. Eine fehlerhafte Review-Aussage soll in CI auffallen.
Regeln, App, historische Runs, Quellen und Thesis werden nicht geändert.
Refs: Lab #97, App #136. Quellenreview ist keine Förder- oder Golden-Freigabe.
