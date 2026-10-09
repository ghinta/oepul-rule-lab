# Original-, Policy- und App-Befunde

## Vollständiger Original-/Tabellenvergleich

Jährlicher Vertrag mit Verlängerung, gleichzeitige Teilnahme o6_14, mindestens 3 RGVE
jedes Jahr. Vollständige Behirtung jeder beantragten Kategorie: Milchkühe/sonstige
Rinder/Schafe/Ziegen/Equiden/Neuweltkamele. 60 Tage je Tier über Almen, zusätzlich
60 Kalendertage Bestoßung je Alm; Auftrieb zählt, Abtrieb nicht. Tatsächliche tägliche
Betreuung statt bloßer Nachschau; Unterkunft erforderlich, tatsächliche Nächtigung
nicht generell. Tiere und Almdefinition haben eigenen Scope, Heimland ist keine Alm.

1. Juli Alters-/Kalbestichtag; Milchkühe mindestens zwei Jahre und einmal abgekalbt,
Milchschafe/-ziegen mindestens ein Jahr, 45 Milchtage. Auftrieb bis 15. Juli,
Meldung 14 Tage Rinder/7 übrige, höchstens diese rückwirkende Gutschrift;
Abtrieb tatsächliches Ereignis/7- oder 14-Tage-Fenster. Milchkennzeichen binnen
14/7 Tagen und Schafe/Ziegen spätestens 15. Juli; bei fehlender Abkalbung/45 Tagen
korrigieren. Pferde/Kamele geplanten Abtrieb nur bei Übereinstimmung nicht nachmelden.
Listen 15. Juli, 17. Juli in 2023/2028; das ersetzt nicht den echten Auftriebstermin.
Wiedereinstiegsersuchen ist als Ersuchen dokumentiert, keine eigene Genehmigungsfiktion.

Hirte nur eine Alm/Jahr, höchstens 50 RGVE; erhöhte erste 20 je 50er-Block.
Hund: gültiges Österreichzentrum-Zertifikat, Versicherung, autonome Tag-/Nachtarbeit,
gesamte Alpungsdauer/mindestens 60 Tage auf einer Alm; eine Alm je Hund, max fünf.
40+40 Tage reichen nicht, 65+65 geben nur eine Hundprämie. Letzter Einstieg 2027,
Hundezuschlag 2028. Abmeldung von Kategorien/Hund/ganzer Maßnahme getrennt.

Jahresraten 2023 75/25 und Milch140/100, Hund700; ab2024 81/27 und151,2/108,
Hund756; ab2025 Hund1200. 18 measure-RGVE-Zeilen korrekt abgleichen, allgemeiner
Anhang A hat 23 Zeilen mit Schweine-GVE ohne Alm-RGVE. Luna zerlegt kombinierte
Wild-/Kamelzeilen und enthält zusätzliche Kategorien; diese sind keine neuen Almarten.
Opus Tabellenvergleich bestätigt relevante Werte, keine vollständige Rechtsableitung.
[Tabellen-/Originalbeispielaudit](original-tables-example-audit.json) gepinnt.

Beispiel1: 95 RGVE, davon40 Milch, zwei Hirten: Basis4725+Milch5184=9909.
Beispiel2: AlmA48RGVE(32Milch), AlmB52RGVE(15,5Milch)/Kapazität50+Hund.
Original nennt für B 20×81+30×27=2295, rechnerisch2430; gedrucktes Total12534,6,
aus den gedruckten Multiplikationen12669,6. Fachfrage, kein Golden-Oracle aus Modell.
Allgemeines Modulationsbeispiel230ha/250RGVE nennt98,66 statt Formel98,69565→98,70.
Modulation von gesamtem Alm-Besatz, nicht nur behirteten Tieren, getrennt vom Heimgebiet;
Minimum Gesamtsummen gegenüber Summe Einzelminima wie14 offen bestätigen.
SRL-Landeszuschlag40€/RGVE erhöhte Milchblöcke nur echte regionale Gewährung,
Meldung15.Mai und rechtzeitige Mittel; zwei Booleans sind kein Nachweis.
Dürre-Mitteilung22.Mai erlaubt Ansuchen, keine allgemeine60-Tage-Ausnahme.

## Historische Luna-OPA und statische Lücken

Namespace opul.o6_15, kein Gesamt-decision/eligible. Leere Landliste bestätigt care/
accommodation automatisch. Gruppe mit Alter1/keiner Abkalbung/falscher Vollständigkeit,
aber freien gve3/milk45/Tagen ergibt696,6. Verspäteter Antrag, o6_14=false oder
aktueller Ausstieg ändern den Betrag nicht. Sechs Hunde ohne Zertifikat geben7896,6
inklusive7200 Hundezuschlag. 95gve ohne Hirten ergeben3645 statt Kapazitäts-/Blocklogik.
Eigene deadline_days999 bestätigen Meldung. Nichtbehirtete Heimschweine machen
participation false, theoretischer Betrag bleibt696,6. Milchalter-, Kategorie-,
Hunde-, Personen-, echte Aufenthalts-/Meldehelper sind nicht am Betrag verbunden.

## Historische Opus-OPA und statische Lücken

Gültige Basis: echte61Tage, drei RGVE,243. Fehlender Zahlungsantrag meldet Befund,
aber eligible=true/payable243. Altstart1900 ohne früheren Antrag und verspätetes
Wiedereinstiegsersuchen ohne Anerkennungsbeleg werden akzeptiert. Vorjahres2025-
Aufenthalte zählen2026 identisch; Host1.Juni zählt bereits zukünftigen Augustabtrieb.
Fehlendes Auftriebsmeldedatum gibt volle61Tage. Schaf mit override cattle_2y_plus
wird3RGVE statt0,45; fremde Kategorie überschreibt Art. Zusätzliche unbehirtete
Tiere derselben Kategorie melden Verstoß, lassen eligible/payable243 bestehen.

Fehlendes Milchkennzeichendatum gilt timely und bringt453,6 Zuschlag/696,6 gesamt;
verspätetes Kennzeichen dagegen nur Basis243 trotz Verstoß. Zwei Almen mit gleicher
Tier-/Hirten-ID und ohne Gesamtdauer:6RGVE doppelt, lexikalisch A behält Hirten/prämie,
Z verliert sie. Diese Auswahl ist keine bestätigte Fachregel. Zwei Vollkürzungen
werden in einem Helper erkannt, payable243 bleibt. Betreuungfalse macht Alm falsch
und Betrag0, farm eligible bleibttrue. Hundezuschlag ohne Antragsdatum bringt1200.

Beispiel1 ergibt9909 aus gezielt gruppiertem Testinput; keine echte vollständige
Tier-/Hirten-/Registerevidenz und keine Bestätigung des widersprüchlichen Beispiel2.
Missing is_herded/in_austria wird günstig true; freie Gesamttage/stocking_days/stocked_rgve,
fehlender Art-/Alters-/Datumjoin und gemischte home/current-year-Verträge bleiben.
Milchpriorisierung und erste-Alm-Auswahl sind Modellannahmen. Landeszuschlag2bools,
Kontroll-/Sanktions-/force-majeure-Helper unvollständig konsumiert. Weitere Beträge
sind theoretische Beobachtungen, keine frei erfundenen Sanktionen oder Freigaben.

## Gepinnte App

API/Catalog/Policy verwenden Almfläche und aggregate behirtung_days ohne Tiere,
Hirten, Hunde oder bestätigte o6_14-Teilnahme. Auch Nullwerte beseitigen fehlende
Schlüssel, führen aber weiter nur technische Category C missing_data, keine eligible-
Entscheidung. 26 Proben bestätigen historische Ausführung; 81 wörtliche Zitate keine
vollständige normative Ableitung. Gegenwartsdaten und vollständige Helper-Bindung fehlen.
