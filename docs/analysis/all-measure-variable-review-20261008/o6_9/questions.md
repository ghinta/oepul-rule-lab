# o6_9: offene Fachentscheidungen

Alle Antworten und App-Zuordnungen bleiben offen. Die Zitate sind Modellnotizen bzw. Prüfbeobachtungen, keine bestätigte Fachauslegung.

### o6_9-INPUT_CONTRACT

Welche der im Diff einzeln gelisteten Eingaben werden fachlich benötigt und aufgenommen? Für jede: verbindlicher Name, Betrieb/Schlag/Tier/Gruppe/Projekt, Einheit, Zeitbezug, Herkunft/Nachweis und Abgrenzung zu bestehenden App-Feldern. Luna- und Opus-Strukturen sind alternative Vorschläge; keine automatische Umbenennung.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_9-luna-high-20261002/workspace/rules/profile_changes.json:8–11`

```text
      "path": "measure",
      "value_after": "string",
      "rationale": "Die ausführbare Maßnahmenschnittstelle benötigt die ausgewählte Maßnahme; das Canonical Farm Profile enthält dafür kein Feld.",
      "rule_ids": [
```

Ursprung: `runs/v2-o6_9-opus-5.5-high-20260925/workspace/rules/profile_changes.json:8–11`

```text
      "path": "oepul_applications",
      "value_before": null,
      "value_after": [
        {
```

### o6_9-PROTEIN

Welche Rohprotein-Grenze gilt für gedeckte und ungedeckte Jungsauen sowie für Phasen- und Mastdurchschnitt? Luna lässt einen Wert offen, Opus ordnet 125 g zu; Bezug zu App #133.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_9-opus-5.5-high-20260925/workspace/notes/assumptions.md:12–17`

```text
- **A-01 Rohproteintabelle: Informationsblatt vs. SRL.** Die SRL (2.9 lit. a) ordnet den Durchschnittswert
  157 g der Gruppe „Jung- und Mastschweine ab 32 kg bis Mastende sowie Jungsauen nicht gedeckt ab 50 kg“ zu.
  Das Informationsblatt druckt 157 g in der Zeile „32 bis 60 kg“ und nennt nicht gedeckte Jungsauen „ab 32 kg“.
  Umgesetzt ist die SRL-Lesart: 157 g gelten als Durchschnitt über die ganze Mast (`fattening_average`),
  170/155/150 g als Phasengrenzen je Gewichtsklasse. Gedeckte Jungsauen ab 50 kg sind wie im Informationsblatt
  den tragenden Zuchtsauen (125 g) zugeordnet. In der SRL steht bei ihnen kein eigener Wert.
```

### o6_9-MANURE_DEFINITION

Welche Biogas-Ausgangsstoffliste gilt und was bedeutet geringer/unvermeidlicher Wasseranteil? Darf betriebsfremde Gülle bodennah ausgebracht werden?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_9-opus-5.5-high-20260925/workspace/notes/assumptions.md:71–75`

```text
1. **Wasseranteile.** Wie viel sind ein „geringer Anteil“ Regenwasser bzw. ein „unvermeidlicher Anteil“
   Stallwaschwasser? Die Quellen nennen keine Schwelle. Die Regel ist nur als Daten und Katalogeintrag erfasst.
2. **Betriebsfremde Gülle.** Darf zugekaufte Gülle oder Biogasgülle aus fremden Anlagen bodennah ausgebracht
   werden? Die Quellen schränken die Herkunft nur für die Separierung ein, daher prüft die Policy die Herkunft
   bei der Ausbringung nicht.
```

### o6_9-NITROGEN_NEED

Wie werden tatsächlicher N-Düngebedarf und Leguminosen-Reinbestand nachgewiesen? Ein fehlender Wert darf keine bestätigte Bedarfsaussage ergeben.

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_9-opus-5.5-high-20260925/workspace/notes/assumptions.md:27–34`

```text
- **A-05 Düngungswürdige Fläche.** Ob ein Stickstoffdüngebedarf nach NAPV besteht, ist als Eingabe
  `has_n_fertilization_need` vorgesehen. Fehlt der Wert, wird ein Bedarf angenommen, weil die NAPV-Tabellen
  keine Quelle dieses Runs sind. Fehlt `is_pure_legume_stand`, gilt `crop_category == "legume"`
  vorsichtshalber als Reinbestand.
- **A-06 Ackerfläche für die Fütterung.** Die Schwelle von 1,00 GVE/ha bezieht sich auf die gesamte Ackerfläche
  ohne Abzüge (`land.arable_area_ha`). Die Prämie von 54 €/ha wird dagegen nur für prämienfähige Ackerschläge
  berechnet: keine Nationalpark-Flächen, kein Code OP, Ernteverpflichtung erfüllt.
  Ackerfutterflächen zählen als Ackerflächen.
```

### o6_9-VOLUME_EVIDENCE

Wie wird die 50-m³/ha-Grenze auf Verfahren verteilt, und welche Menge zählt: beantragt, ausgebracht, separiert oder nachgewiesen? Welche Folgen haben fehlende Rechnungen/Zertifikate?

Status: `open_before_app_admission` · Antwort: offen.

Ursprung: `runs/v2-o6_9-opus-5.5-high-20260925/workspace/notes/assumptions.md:22–26`

```text
- **A-03 Obergrenze 50 m³/ha bei mehreren Verfahren.** Die Quellen sagen nicht, welchem Verfahren die Kürzung
  zugeordnet wird. Umgesetzt ist eine anteilige Kürzung aller drei Verfahren (`slurry_scale`).
- **A-04 Grundlage der Prämie.** Laut SRL wird die Prämie nach der im MFA beantragten Menge gewährt.
  Übersteigt die beantragte Menge die förderfähig aufgezeichnete Menge, meldet die Policy einen Verstoß.
  Die konkrete Kürzung nach §§ 42–47 GSP-AV ist nicht modelliert, weil diese Normen nicht in den Quellen enthalten sind.
```
