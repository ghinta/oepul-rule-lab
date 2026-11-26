# Fachliche Annahmen für o6_19

## Schlagbezogene Entscheidungen

Die Projektbestätigung bestimmt, welcher Indikator mit welchen Parametern und für welchen Schlag verbindlich ist. Anhang K enthält 144 Zuordnungen von Indikatoren zu Lebensräumen, Tiergruppen und Problempflanzen. Wiederkehrende Codes behalten ihren jeweiligen Kontext. So verlangt EBGT17 bei Braunkehlchen in Variante B zusätzlich eine festgelegte Zahl von Sitzwarten. Für freies Feld, qualitative Beobachtung oder kartierungsabhängige Einstufung ist der dokumentierte Fachbefund maßgeblich. Bei Messregeln beziehen sich die Messwerte auf die vereinbarten Arten, Flächen und Beobachtungszeiträume. Fehlende Messwerte ergeben einen offenen Befund, außer eine andere zwingende Teilbedingung ist bereits nachweislich verletzt.

| Fundstelle | Offene Frage und Behandlung |
| --- | --- |
| Maßnahmenblatt 4.3 und 7, SRL 2.1 | Kapitel 7 ordnet 81 Lebensräume den zulässigen Schlagnutzungen zu. Eine Zuordnung einzelner A/B/C-Zustände je Lebensraum fehlt. Für DIVSZ werden der bestätigte anrechenbare Zustand, die Schnittzeitpunktauflage, die passende Nutzung und die beiden MFA-Codes geprüft. |
| Maßnahmenblatt 4.3 und Beispiel S. 5, SRL S. 29, 31, 38 und 39 | Das Beispiel nennt für die 15-a-Regel nur die Feldstückgröße. Für die Auswertung gilt auch die in der SRL genannte Betriebsschwelle von 10 ha Acker bzw. gemähtem Grünland ohne Bergmähder. |
| Maßnahmenblatt 4.2 | Beim Ausscheiden der geschulten Person genau am 31.12.2026 lässt der Wortlaut die Anrechnung offen. Ein weiterer belegter und anrechenbarer Besuch kann die Verpflichtung unabhängig davon erfüllen. Der reguläre Fall ist die Anrechnung auf einen einzigen Betrieb. Die Quelle präzisiert keine Ausnahme von diesem Grundsatz. |
| Anhang K, S. 93, EBGH07 | Der veröffentlichte Eintrag endet in einer Artenaufzählung. Für einen Befund sind der konkrete Projektwortlaut und eine fachliche Beurteilung erforderlich. |
| Anhang K, S. 95–96, EBGT07 und EBGT16 | Bei den Lesesteinmauern steht neben „Länge“ die Einheit „m2“. Die verwiesene Tabelle zum Minimumabstand des Zentrums der Schutzzone ist unter diesem Titel in den bereitgestellten Quellen nicht enthalten. Für beide Indikatoren gilt die konkret bestätigte Anforderung. |

## Prämiensätze und Flächen

- Die Tabellen S. 101–102 von Anhang K enthalten den Flächenbeobachtungszuschlag bereits. Der Schrägstrich in einer Tarifzelle ist als JSON-null erfasst. Der Abruf eines solchen Tarifs bleibt offen. Der allgemeine Geltungsbeginn der vorliegenden Sätze ist 2024. Für 2023 kann der im Projekt bestätigte Basissatz eingegeben werden. Für den Regionalen Naturschutzplan weist das Maßnahmenblatt den historischen Betrag ausdrücklich aus.
- EBBA ist als einmalige, begründete Vergabe je Fläche modelliert. EBBA02 ist ab 2025 die zweite Stufe bei Zustand A. Für den Betrag wird die bestätigte Stufe ausgewählt. Die NAT-Kürzel verweisen auf die fachliche Herkunft der Gründe. Die Vergabe einer eigenen NAT-Prämie folgt daraus nicht.
- Für EBHG01 und EBHG02 folgt die Zuordnung zu Grünland und Acker aus dem Verweis in Anhang K auf die Habitatbewirtschaftung in Anhang I. Neben der bestätigten Vergabe werden Landesmeldung, GIS, Schutzgut, mindestens 50 % Überdeckung und Umsetzung der Habitatindikatoren benötigt.
- Flächenangaben für GLÖZ 4 und 8 beziehen sich auf den beantragten Teil innerhalb der EBW-Referenz. Eine Überlappung wird einmal abgezogen. Die betriebliche Stilllegungsgrenze wird auf die Summe sonst förderfähiger Stilllegung angewendet. Eine Priorisierung einzelner Schläge bei Überschreitung ist nicht vorgegeben.
- Für Zugänge ab 2026 zählt die Ausweitung gegenüber der Fläche 2025. Bereits beanspruchter Zuwachs und gleichartig vorgebundene Zugänge werden getrennt erfasst. Eine jährliche erneute Ausschöpfung der gesamten Grenze würde die Bezugsbasis 2025 aufheben.
- Die Ernteausnahme 2026 richtet sich nach der Lage des Schlages. Der Hinweis vom 12. August erweitert die Gebietskulisse vom 5. August. Auf Acker-DIV mit EBW bleibt die Projektbestätigung maßgeblich. Ein OPUBB- oder OPBIO-Code allein erlaubt keine Abweichung von der EBW-Bewirtschaftung.

## Auswertung

Der Einstiegspunkt für ein Betriebsprofil ist `data.oepul.o6_19.bewertung`. Er liefert schlagbezogene Indikatorbefunde, festgestellte Verstöße und Flächenausschlüsse sowie berechenbare Projektprämiensätze vor Kürzungen. Betriebliche Grenzwerte, Modulationsfaktor, Zugang, Übernahme und Zuschläge sind separat über die im Katalog angegebenen Rego-Symbole abfragbar. Eine leere Verstoßliste sagt bei unvollständigen Eingaben nichts über die vollständige Erfüllung aus.

Behördliche Auswahl, Sanktionsstufe, Nachfrist, höhere Gewalt außerhalb ausdrücklich automatischer Anerkennung und Ermessensentscheidungen benötigen den jeweiligen Nachweis. Die Summe der Zahlungen für die Anwendung der Schlagobergrenze schließt umgelegte Landschaftselemente ein. Die Reihenfolge bei Mehrfachkürzungen folgt SRL 1.12. Die dafür benötigten Eingaben sind in rules/profile_changes.json vorgeschlagen.
