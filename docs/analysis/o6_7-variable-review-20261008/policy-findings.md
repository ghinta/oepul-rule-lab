# Reproduzierbare Policy-Beobachtungen

Alle Proben laufen auf unveränderten historischen Policies/Daten und dem
fest gebundenen App-Policy-Pin. Ausgaben zeigen Verhalten; sie definieren keine
fachliche Sollregel und keine automatische AMA-Sanktion.

- Luna: `farm.oepul.participating:true` ohne `measure.o6_7` ergibt eligible=false;
  leerer Wrapper ergibt eligible=true ohne Quote/Aufzeichnungen/Antrag.
- Luna: globaler Dürre-/Aufgangsflag erlaubt cover_share_percent=0;
  ein Schlagbeleg darf nicht beliebige andere Flächen/Jahreslücken freistellen.
- Luna: 15.10.2024 (Tag 289) wird als zu spät beanstandet. Eine späte nicht
  winterharte Anlage 2024 passiert; die vor-2025-Regel fehlt.
- Luna konsumiert globale mineral_n_kg_per_ha und psm_used, nicht die
  vorgeschlagenen Anwendungsperioden; echte zeitliche Begründung fehlt.
- Opus: ein gelieferter 2-ha-Schlag zu 100 ha aggregierter Ackerfläche ersetzt
  den vollständigen Nenner durch 2 ha; coverage=true, measure_valid=true, 140 Euro.
- Opus: fehlender Maßnahmen-/Bewerber-/Aufzeichnungsdatensatz oder Vorjahres-
  abmeldung ergeben weiterhin positive Maßnahmengültigkeit/140 Euro.
  Expliziter eigenes-Rechnung-Verstoß blockiert die Prämie ebenfalls nicht.
- Opus: offener Ernteabschluss am 1.10. ohne Folgefrucht zählt am Jahresende
  erst ab 20.11. als unbegrünt (42 Tage), statt gesamten bereits überschrittenen
  Zeitraum zu behandeln. Aktuelles as_of wird dabei nicht berücksichtigt.
- Opus: ungültige 41-Tage-Zwischenfrucht zwischen Hauptfrüchten wird entfernt;
  verbleibende <=50-Tage-Lücke zählt durchgehend als begrünt. Original MB S. 5
  nennt auch 41 Tage Zwischenfrucht und offene Tage davor/danach als unbegrünt.
  Bestätigung der konkreten kurzen Hauptfrucht-zu-Hauptfrucht-Konstellation offen.
- Gegenprobe: belegte 40-Tage-Hauptfrucht→Zwischenfrucht-Lücke wird vollständig
  mit 40 unbegrünten Tagen erfasst; das ist eine konkrete richtige Beobachtung.
- Opus: mineralisches N am Tag nach Umbruch ohne NAPV-Enddatum wird nicht
  beanstandet; die Quelle verlangt Verbot bis NAPV-Ende im Folgejahr.
- Opus: Messerwalze am Anlagetag bleibt unbeanstandet, am Folgetag Verstoß.
  Bodennaher Futterschnitt ohne Regrowth erzeugt Verstoß, daily coverage bleibt
  true/0 unbegrünte Tage, obwohl MB S. 7 ab Ernte begrünungsfreie Periode nennt.
- App: 2 ha Acker/2 ha undatierte Begrünungsfläche => eligible ohne Jahresverlauf.

Weitere offene Modelllesarten: 1 Tag als „unmittelbar“, SRL/MB-Walzspannung,
vorvertragliche Mischungen, Grünbrache/DIV-Prämie, spätes Flächenplus ohne
Ursächlichkeitsprüfung, Folgejahres-ES-Sperre. Nicht allein durch zusätzliche
Variablen beheben. Seed-/Care-/MFA-/Anhang-L-Helper vollständig zu konsumieren
ist gesonderte spätere Implementierungsarbeit.
