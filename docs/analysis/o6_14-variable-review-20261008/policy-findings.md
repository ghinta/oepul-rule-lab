# Original-/Ausführungsbefunde o6_14

## Vollständiger Originalvergleich

MB 1–16/SRL 69–71: Almbewirtschafter beantragt; im ersten Maßnahmenjahr insgesamt
3 ha/3 RGVE, Folgejahre darunter möglich. Mehrjähriger Vertrag 2023–2025 bis 2028;
NATA eigener Projekt-/Vertragsbezug, AWP einjährig ab 2025 bis Einstieg 2028.
Alle Almweideflächen betroffen; Kataster/Almgebiet, nicht vom Heimgut bewirtschaftet,
sichtbare Grenze/Bewirtschaftungsunterschied. Erschließung Zentrum 50 m bzw. Flächen;
vergleichbare Zeiten mitteln, bei stark verschiedenen Zeiten längere Auftriebsdauer,
Flächengröße kein Gewicht. Originalbeispiel 3.750/4.800 RGVE-Tage ergibt Stufe 2.

60 Tage je Tier über mehrere Almen, getrennt davon 60 Bestoßungstage je Alm, auch
hintereinander/mit Unterbrechungen; Auftrieb zählt, Abtrieb nicht. Auftriebsmeldung
7 bzw. Rinder 14 Tage und höchstens diese Rückgutschrift; Abgang 7/14 Tage ab tatsächlichem
Abtrieb. Tiere grundsätzlich Tag/Nacht anwesend, begrenzte Stall-/Melkausnahme. Nur
zulässige Arten, 1. Juli Altersschlüssel; nach Stichtag geborene Tiere nicht für Maximalbesatz.
Besatz pro Alm anteilig, 2,0 / NATA 1,5 / begründeter gesondert beantragter AWP 2,4;
ausländische angrenzende Flächen nur mit jährlichem Nachweis zur Entlastung.

Natürliche Futtergrundlage erforderlich, Ausgleichsfutter statt Grundfutterzufütterung;
ab 2025 almeigene Silage vollständig auf jeweiliger Alm. Eigenalm + Heuwirtschaft
verbietet Erzeugen/Füttern/Lagern, fremde Alm anders. PSM-/Düngung nur Biozulässiges;
almfremde Gülle/Jauche/Klärschlamm/separierte Feststoffe verboten, Heimbetriebsmist erlaubt.
PSM-MFA-Codes nur bis 2025, ab 2026 Verzicht-/Produktpflicht bleibt.

NATA: alle Feldstücke/Projektbedingungen, sensible Habitate, Drainagen/Tränken und
4-h-Kurs ab 2022 bis 31.12.2025; Person, keine Doppelanrechnung, Ersatz bei Weggang
bis Frist. AWP: 4 h ab 1.10.2024 bis 15. Juli erstes Jahr, jährlicher Plan 15. Juli,
Folgejahrprüfung dokumentieren, alle Almen/Teilflächen bewerten/Lenkung kommunizieren.
Projektbestätigung nach Anhang E benötigt verortete tatsächliche Bedingungen.

Feldliste/NATA 15.4., Listen 15.7. mit 17.-Ausnahmen 2023/2028; tatsächlicher
Tierauftrieb für Auszahlung 15.7. ohne diese Ausnahmedaten. Liste nur bei Rindern/
Stufe 1 ohne Behirtung/erhöhte AWP verzichtbar. Separate Kennzeichnungsregister bleiben.
Prämie je Alm höchstens min(Almha, RGVE); getrennte Zusatzprämien. Modulation MB 13:
Minimum aus RGVE-/Flächensummen des gesamten Betriebs, getrennt vom Heimgut;
Opus verwendet Summe der Einzelalm-Minima. Diese unterschiedlichen Basen offen vorlegen.

## Tabellen und Fußnoten

Original 18 RGVE-Zeilen, sechs Grundprämienwerte (2023 40/60/80; ab2024 43,2/64,8/86,4),
NATA 5/5,4/10, AWP 20 €/ha erste 20 ha je Alm stimmen numerisch in Tabellen.
Luna enthält zusätzlich sechs Wild-/Schweinekategorien aus allgemeinem Anhang A,
Artenprüfung schließt diese Tiere aus; keine zulässigen Alm-RGVE daraus folgern.
Beide Tabellen erfassen neun Anhang-E-Sätze korrekt: NAW 2,2/8,6/27;
NAD 2,2/4,3/10,8; NAB 4,3/16,2/43,2 ab 2024; Anteile über1–5, über5–20, über20%,
Einzelgehölz 100 m². Luna enthält keine Anteil-/Jahresbindung; Opus Tabellen korrekt,
Code-/Anteil-/Projektjoin nicht vollständig. Zeile/Spalte 14 in Anhang L visuell
leer, relevante Opus-Zeile stimmt; tierbezogene 15/20/21 stehen nicht in dieser Matrix.
Keine Vollmatrix- oder gesamte Rechtsfreigabe.

## Reproduzierte historische Luna-Beobachtungen

- Behauptete 60 alpung_days reichen bei tatsächlichen zehn Tagen und ohne Antrag
  für eligible=true. Vertrags-/Antrags-/Listenhelper nicht an eligible gebunden;
  ungültiger Vertragsbeginn 2026 und Jahr 2029 ändern eligible nicht.
- Fehlende Inlands-/Futterflags werden in negativen Regeln übersprungen statt unknown;
  freie gve=5 ohne 1.-Juli-/Tiernachweis wird akzeptiert.
- Zwei 30-Tage-Teile derselben Tier-ID werden einzeln als zu kurz abgelehnt;
  pro Alm summiert die Policy Tier-Tage statt Kalenderunion. Kein echter Anteil-/Meldungsjoin.
- Eigene Silage 2024 wird akzeptiert; Heuwirtschaft-Eigenalmbezug fehlt.
- Bei AWP strong_intensity=true ohne Grund entsteht kein definierter Grenzwert;
  3 RGVE/ha bleibt eligible=true. Ohne Kurs-/Person-/Planversion/Erstellungsdatum kann
  die boolesche Planbeschreibung ebenfalls die echte Evidenz nicht bestätigen.
- data.o6_14.rates fehlt bei vollständigem historischem policy+data-Loader,
  data.rates vorhanden: premium_base bleibt leer, premium_base_total=0. Das sind
  tatsächlich reproduzierte Ergebnisse, keine plausible reparierte Prämie. Datenwurzel
  muss in späterer Adaptation repariert werden; historischer Run bleibt unverändert.
- Statische weitere Bindungslücken: annual_review/course.completed_by ungenutzt;
  NATA-Codes global über alle Almen gesammelt; NATA/AWP-Zuschläge nicht in Basissumme.
  contract_years hat zwei konkurrierende Definitionen bei gültigem Start plus AWP;
  diese nicht angefragte Hilfsregel wurde nicht als erfolgreiches Laufzeitverhalten gewertet.

## Reproduzierte historische Opus-Beobachtungen

- Mit gültigem Antrag, Almdefinition und echten 61 Aufenthaltstagen 1 RGVE/43,2 €;
  fehlende aktive Person/PSM-/Futter-/Feldlistendaten bleiben ohne Verletzung.
- Aufenthalte 2025 zählen 2026 identisch; am Host-Stichtag 1.6. werden tatsächliche
  Abtriebsdaten August schon mitgezählt. year/as_of schneidet keine Tier-/Almzeitbasis.
- Doppelte 31-Tage-Stays desselben Tiers ergeben 62 Tier-Tage. Alm-Union bleibt
  korrekt 31, dort Prämie0/Verstoß; dadurch ist die Tierlogik nicht ebenfalls korrekt.
- Schaf mit override cattle_ge_2y wird 1 statt passendem0,15RGVE und43,2€ gerechnet.
  count kann auch bei einzeltierbezogenen Rindern beliebig mehrere Tiere darstellen.
- Rind-Auftrieb1.6./Meldung25.6. wird korrekt ab11.6. (51 Tage bis1.8.) gutgeschrieben,
  Prämie0; verspäteter Abtrieb dagegen Verletzung bei unverändert43,2€ vor Kürzung.
- payment_claim_missing, alter freiwilliger Ausstieg, Kontrollverweigerung und zweimalige
  Vollkürzung ändern access/premium_total nicht; getrennte Helper werden nicht konsumiert.
- Heuwirtschaft ID o6_3 wird nicht erkannt; String heuwirtschaft löst bei Eigenalm
  Silage-Verletzungen aus. Auch diese Verletzungen lassen theoretische43,2€ stehen.
- Dürre-Ansuchen ohne Genehmigung wird als recognised geführt. Quelle22.5. erlaubt
  ein Ansuchen, keine automatische Anerkennung/60-Tage-Ausnahme.
- Zweimal NAW1 mit jeweils99%Betroffenheit und ohne Kurs ergibt NATA14,4€ plusBasis;
  Kursverstoß gemeldet, duplicate-Code-/Anteilprüfung fehlt. Projektflag ist keine Auflage.
- Plan.created_date2025 mit annual_review=true reicht 2026 für20€AWP; ob alter Plan
  plus echte Jahresprüfung die jährliche Erstellung abdeckt, bleibt Expertenfrage.
- Mehralmprobe: A150ha/60RGVE, B100ha/200RGVE; zulässige Besatzwerte. Opus
  Modulationsbasis160ha/Faktor1; Originalwortlaut nennt min(Summeha250,SummeRGVE260)=250.
  Keine eigene fachliche Entscheidung über diese Differenz; amtliche Basis bestätigen.
- non_organic_psm_used=true meldet Verletzung, berechnet weiter43,2€ vor inhaltlicher
  Kürzung. Theoretischer Betrag allein bestätigt keine aktuelle Empfehlung.
- Weitere statische Gaps: gleiche betriebliche Option für sämtliche Almen, unknown
  Geburt/Rasse/Größe/Kategorie kann Werte verschwinden lassen; access_times_comparable/
  Rundung/Gleichstand unbestätigt, Kombination/Cap/AWP-Abmeldung unverbunden.

## Tatsächlicher App-Pin

App5296108 prüft dauerhaft3ha/3GVE, maximalen Weidetagwert und GesamtGVE/Almha<=2.
Heimgruppen ohne tatsächlichen Almaufenthalt geben eligible. 2ha im späteren
Maßnahmenjahr wird immer abgelehnt; 1GVE mit60Tagen plus4GVE mit0Tagen ergibteligible
für5GVE. Keine Einzelalm-/Jahres-/Melde-/1.Juli-/Projekt-/Almbewirtschafterbindung.
Katalog verwendet MB Oktober2025; Lab April2026 klärt die zwei60-Tage-Bedingungen
und MFA-PSM-Codeende. API/Adapterpfade genau gepinnt, keine App-Änderung.

26 Proben = technische historische Beobachtungen, keine Golden-Fachantworten.
90 wörtlich auffindbare Fundstellen bestätigen keine vollständige normative Ableitung.
Echte aktuelle Tierregister-/GIS-/Projekt-/Experten-/Betriebssnapshots bleiben erforderlich.
