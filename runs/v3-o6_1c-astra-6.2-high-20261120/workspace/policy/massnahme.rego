package oepul.o6_1c

import rego.v1

jahr := input.farm.year if is_number(input.farm.year)
betrieb := input.farm.oepul
werte := data.oepul_1c_tabellen

# Datumsspalten verwenden ISO-Kalendertage. Eine ungültige Angabe belegt keinen Verstoß.
datum(d) if {
	is_string(d)
	regex.match(`^[0-9]{4}-[0-9]{2}-[0-9]{2}$`, d)
	time.parse_rfc3339_ns(concat("", [d, "T00:00:00Z"]))
}

stichtag(y, md) := sprintf("%04d-%s", [y, md])

im_jahr(d) if {
	datum(d)
	startswith(d, sprintf("%04d-", [jahr]))
}

schlaege := [p | some p in input.land.parcels; p.o6_1c.category in {"NPA", "AFS"}]
npa := [p | some p in schlaege; p.o6_1c.category == "NPA"]
afs := [p | some p in schlaege; p.o6_1c.category == "AFS"]

antragsfrist(y) := stichtag(y - 1, "12-31")

einstieg_fristgerecht(c) if {
	is_number(c.entry_year)
	c.entry_year >= 2025
	c.entry_year <= 2027
	datum(c.application_date)
	c.application_date <= antragsfrist(c.entry_year)
}

# Formelle Jahresprüfung je Kategorie, einschließlich Folgeantrag im Jahr 2028.
antrag_jahreskriterien contains c.category if {
	some c in betrieb.contracts
	c.category in {"NPA", "AFS"}
	einstieg_fristgerecht(c)
	jahr >= c.entry_year
	jahr <= 2028
	c.annual_payment_application
	c.uninterrupted
	keine_abmeldung(c)
}

keine_abmeldung(c) if c.withdrawal_date == null

keine_abmeldung(c) if {
	datum(c.withdrawal_date)
	c.withdrawal_date > stichtag(jahr, "12-31")
}

mindestgroesse_erreicht if {
	is_number(betrieb.first_oepul_year)
	jahr > betrieb.first_oepul_year
}

mindestgroesse_erreicht if {
	jahr == betrieb.first_oepul_year
	is_number(betrieb.protected_at_ha)
	betrieb.protected_at_ha >= 0.5
}

mindestgroesse_erreicht if {
	jahr == betrieb.first_oepul_year
	is_number(betrieb.qualifying_at_ha)
	betrieb.qualifying_at_ha >= 1.5
}

beantragte_kategorien contains p.o6_1c.category if {
	jahr >= 2025
	some p in schlaege
}

beantragte_kategorien contains c.category if {
	some c in betrieb.contracts
	c.category in {"NPA", "AFS"}
	jahr >= 2025
	is_number(c.entry_year)
	c.entry_year <= jahr
	keine_abmeldung(c)
}

npa_konflikt contains "o6_1c.ubb" if {
	"NPA" in beantragte_kategorien
	betrieb.ubb
}

npa_konflikt contains "o6_1c.bio" if {
	"NPA" in beantragte_kategorien
	betrieb.bio in {"gesamt", "teilbetrieb_sonstige"}
}

umbruch_ab(folge) := stichtag(jahr, "08-01") if folge in {"Winterung", "Zwischenfrucht"}
umbruch_ab(folge) := stichtag(jahr, "09-15") if folge in {"andere", "keine"}

neusaat(p) if p.o6_1c.establishment in {"Neuansaat", "Umbruch mit Neuansaat"}

reinigung_zulaessig(p, d) if {
	im_jahr(d)
	d in p.operations.cutting_dates
	d in p.o6_1c.weed_cleaning_dates
	p.o6_1c.first_npa_year == jahr
	neusaat(p)
}

pflegedaten(p) := array.concat(p.operations.cutting_dates, p.o6_1c.mulching_dates)

regelpflege(p) := array.concat(
	[d | some d in p.operations.cutting_dates; im_jahr(d); not reinigung_zulaessig(p, d)],
	[d | some d in p.o6_1c.mulching_dates; im_jahr(d)],
) if {
	is_array(p.operations.cutting_dates)
	is_array(p.o6_1c.mulching_dates)
	is_array(p.o6_1c.weed_cleaning_dates)
	is_number(p.o6_1c.first_npa_year)
	is_string(p.o6_1c.establishment)
}

fruehe_pflege(p) if {
	some d in regelpflege(p)
	d < stichtag(jahr, "08-01")
}

pflegeanteil := {"gesamt_ha": gesamt, "frueh_ha": frueh, "ueberschritten": (frueh * 2) > gesamt} if {
	is_array(input.land.parcels)
	every p in npa { is_array(regelpflege(p)); is_number(p.area_ha); p.area_ha > 0}
	gesamt := sum([p.area_ha | some p in npa])
	gesamt > 0
	frueh := sum([p.area_ha | some p in npa; fruehe_pflege(p)])
}

vor_ende(d, ende) if {
	datum(d)
	ende == null
}

vor_ende(d, ende) if {
	datum(ende)
	d <= ende
}

im_npa_verbot(p, d) if {
	datum(d)
	d >= stichtag(p.o6_1c.first_npa_year, "01-01")
	d <= stichtag(jahr, "12-31")
	vor_ende(d, p.o6_1c.break_date)
	vor_ende(d, p.o6_1c.redeclaration_date)
}

# Taxa als botanische Namen, Fertilität nur bei Paulownia erheblich.
negativgehoelz(g) if {
	some row in werte.negativliste
	row.umfang == "Art"
	lower(trim_space(g.taxon)) == lower(row.taxon)
}

negativgehoelz(g) if {
	some row in werte.negativliste
	row.umfang == "Gattung"
	split(lower(trim_space(g.taxon)), " ")[0] == lower(row.taxon)
}

negativgehoelz(g) if {
	some row in werte.negativliste
	row.umfang == "fertile Pflanzen"
	lower(trim_space(g.taxon)) == lower(row.taxon)
	g.fertile
}

nachpflanzung_rechtzeitig(q) if {
	im_jahr(q.replant_date)
	q.replant_date <= stichtag(jahr, "05-15")
	q.replant_date >= q.removal_date
}

# Teilflächen gleicher Bewirtschaftung sind getrennte, disjunkte Einträge.
# Die Anrechnung ist ein Flächenbeitrag, keine Aussage über die Erfüllung des Feldstücks insgesamt.
feldstueck_gutschrift[p.parcel_id] := p.area_ha if {
	some p in afs
	jahr >= 2025
	ubb_oder_bio
	is_number(input.land.arable_area_ha)
	input.land.arable_area_ha >= 10
	is_number(p.o6_1c.assigned_arable_field_ha)
	p.o6_1c.assigned_arable_field_ha > 5
	p.o6_1c.recognised_strip
	p.area_ha > 0
}

ubb_oder_bio if betrieb.ubb
ubb_oder_bio if betrieb.bio in {"gesamt", "teilbetrieb_wein_obst_hopfen", "teilbetrieb_sonstige"}

satz(k) := row if {
	some row in werte.praemien
	row.kategorie == k
}

stufenende(r, ha) := ha if r.bis_ha == null
stufenende(r, _) := r.bis_ha if is_number(r.bis_ha)

modulationsfaktor(ha) := sum([anteil |
	some r in werte.modulation
	obere := stufenende(r, ha)
	anteil := max([0, min([ha, obere]) - r.von_ha]) * r.faktor
]) / ha if {
	is_number(ha)
	ha > 0
}

# Basis ist die festgestellte Fläche nach sonstigen Einzelflächenausschlüssen.
# GLÖZ 4 bezeichnet ausschließlich die Überlappung innerhalb dieser Restfläche.
zahlungssperre(p) if "OP" in p.o6_1c.codes
zahlungssperre(p) if p.o6_1c.measure_specific_op

zahlungssperre(p) if {
	is_string(p.o6_1c.country)
	p.o6_1c.country != "AT"
}

zahlungssperre(p) if p.o6_1c.national_park in {"Neusiedlersee", "Donau-Auen"}
zahlungssperre(p) if p.o6_1c.national_park_conditions
zahlungssperre(p) if p.o6_1c.approved_trial_prevents_compliance
zahlungssperre(p) if p.o6_1c.public_obligation_overlap
zahlungssperre(p) if p.o6_1c.public_compensation_or_infrastructure
zahlungssperre(p) if p.o6_1c.mfa_identification_correct == false
zahlungssperre(p) if p.o6_1c.other_excluded_use
zahlungssperre(p) if p.o6_1c.whole_year_obligations_met == false

netto(p) := 0 if zahlungssperre(p)

netto(p) := basis - p.o6_1c.gloez4_overlap_ha if {
	not zahlungssperre(p)
	p.o6_1c.category == "NPA"
	basis := p.o6_1c.assessed_before_gloez4_ha
	is_number(basis)
	basis >= 0
	is_number(p.area_ha)
	basis <= p.area_ha
	is_number(p.o6_1c.gloez4_overlap_ha)
	p.o6_1c.gloez4_overlap_ha >= 0
	p.o6_1c.gloez4_overlap_ha <= basis
}

netto(p) := basis if {
	not zahlungssperre(p)
	p.o6_1c.category == "AFS"
	basis := p.o6_1c.assessed_before_gloez4_ha
	is_number(basis)
	basis >= 0
	is_number(p.area_ha)
	basis <= p.area_ha
}

praemienrahmen := {"npa_ha": n, "afs_ha": a, "untergrenze_eur": lo, "obergrenze_eur": hi, "modulationsfaktor": f} if {
	jahr >= 2025
	jahr <= 2028
	is_array(input.land.parcels)
	every p in schlaege { is_number(netto(p)) }
	is_number(input.land.arable_area_ha)
	input.land.arable_area_ha >= 0
	ns := satz("NPA")
	asatz := satz("AFS")
	n := min([sum([netto(p) | some p in npa]), input.land.arable_area_ha * ns.max_anteil_acker])
	a := sum([netto(p) | some p in afs])
	f := modulationsfaktor(betrieb.home_modulation_ha)
	lo := ((n * ns.min_eur_ha) + (a * asatz.min_eur_ha)) * f
	hi := ((n * ns.max_eur_ha) + (a * asatz.max_eur_ha)) * f
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_deklaration" if {
	jahr >= 2025
	some p in npa
	p.o6_1c.mfa_use != "Grünbrache"
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_deklaration" if {
	jahr >= 2025
	some p in npa
	is_array(p.o6_1c.codes)
	not "NPA" in p.o6_1c.codes
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_deklaration" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.mfa_use != "LSE Agroforststreifen"
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_anlage" if {
	jahr >= 2025
	some p in npa
	not p.o6_1c.establishment in {"Neuansaat", "Umbruch mit Neuansaat", "Selbstbegrünung", "bestehende Grünbrache", "dauerhaft begrünter Acker"}
	is_string(p.o6_1c.establishment)
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_saat" if {
	jahr >= 2025
	some p in npa
	neusaat(p)
	datum(p.o6_1c.sowing_date)
	p.o6_1c.sowing_date > stichtag(jahr, "05-15")
}

schlagbefunde[p.parcel_id] contains "o6_1c.umbruch" if {
	jahr >= 2025
	some p in npa
	im_jahr(p.o6_1c.break_date)
	p.o6_1c.following_crop in {"andere", "keine"}
	p.o6_1c.break_date < umbruch_ab(p.o6_1c.following_crop)
}

schlagbefunde[p.parcel_id] contains "o6_1c.fruehumbruch" if {
	jahr >= 2025
	some p in npa
	im_jahr(p.o6_1c.break_date)
	p.o6_1c.following_crop in {"Winterung", "Zwischenfrucht"}
	p.o6_1c.break_date < umbruch_ab(p.o6_1c.following_crop)
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_duenger" if {
	jahr >= 2025
	some p in npa
	some d in p.o6_1c.fertilization_dates
	im_npa_verbot(p, d)
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_psm" if {
	jahr >= 2025
	some p in npa
	some e in p.o6_1c.psm_events
	im_npa_verbot(p, e.date)
	e.all_active_organic == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.mechanisch" if {
	jahr >= 2025
	some p in npa
	im_jahr(p.o6_1c.break_date)
	p.o6_1c.removal_method in {"chemisch", "sonstige nichtmechanische Methode"}
}

schlagbefunde[p.parcel_id] contains "o6_1c.pflege_min" if {
	jahr >= 2025
	some p in npa
	is_number(p.o6_1c.first_npa_year)
	p.o6_1c.first_npa_year < jahr
	p.o6_1c.previous_year_care == false
	ds := pflegedaten(p)
	count([d |
		some d in ds
		im_jahr(d)
	]) == 0
}

schlagbefunde[p.parcel_id] contains "o6_1c.pflege_max" if {
	jahr >= 2025
	some p in npa
	count(regelpflege(p)) > 2
}

schlagbefunde[p.parcel_id] contains "o6_1c.reinigung" if {
	jahr >= 2025
	some p in npa
	some d in p.o6_1c.weed_cleaning_dates
	im_jahr(d)
	d in p.operations.cutting_dates
	is_number(p.o6_1c.first_npa_year)
	is_string(p.o6_1c.establishment)
	not reinigung_zulaessig(p, d)
}

schlagbefunde[p.parcel_id] contains "o6_1c.maehgut" if {
	jahr >= 2025
	some p in npa
	p.o6_1c.cuttings_removed
}

schlagbefunde[p.parcel_id] contains "o6_1c.maehgut" if {
	jahr >= 2025
	some p in npa
	p.o6_1c.cuttings_used
}

schlagbefunde[p.parcel_id] contains "o6_1c.weide" if {
	jahr >= 2025
	some p in npa
	p.o6_1c.grazed
}

schlagbefunde[p.parcel_id] contains "o6_1c.nutzung_umbruch" if {
	jahr >= 2025
	some p in npa
	im_jahr(p.o6_1c.break_date)
	some d in p.o6_1c.utilization_dates
	im_jahr(d)
	d >= p.o6_1c.break_date
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_lage" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.adjoins_arable == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_lage" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.woody_stock == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_lage" if {
	jahr >= 2025
	some p in afs
	datum(p.o6_1c.planting_date)
	p.o6_1c.planting_date < "2020-01-01"
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_lage" if {
	jahr >= 2025
	some p in afs
	datum(p.o6_1c.planting_date)
	p.o6_1c.planting_date > stichtag(jahr, "12-31")
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_breite" if {
	jahr >= 2025
	some p in afs
	is_number(p.o6_1c.average_width_m)
	p.o6_1c.average_width_m < 2
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_breite" if {
	jahr >= 2025
	some p in afs
	is_number(p.o6_1c.average_width_m)
	p.o6_1c.average_width_m > 10
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_dichte" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.length_m > 0
	is_number(p.o6_1c.tree_count)
	p.o6_1c.tree_count * 100 < 10 * p.o6_1c.length_m
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_dichte" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.length_m > 0
	is_number(p.o6_1c.tree_count)
	p.o6_1c.tree_count * 100 > 25 * p.o6_1c.length_m
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_abstand" if {
	jahr >= 2025
	some p in afs
	is_number(p.o6_1c.max_tree_gap_m)
	p.o6_1c.max_tree_gap_m > 15
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_spezial" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.special_crop_gsp25_4
}

schlagbefunde[p.parcel_id] contains "o6_1c.negativliste" if {
	jahr >= 2025
	some p in afs
	some g in p.o6_1c.woody_plants
	negativgehoelz(g)
}

schlagbefunde[p.parcel_id] contains "o6_1c.laengsseite" if {
	jahr >= 2025
	some p in afs
	some neighbor in p.o6_1c.long_side_neighbors
	neighbor in {"Wald", "flächiges Landschaftselement"}
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_anlage" if {
	jahr >= 2025
	some p in afs
	im_jahr(p.o6_1c.planting_date)
	p.o6_1c.planting_date > stichtag(jahr, "05-15")
}

schlagbefunde[p.parcel_id] contains "o6_1c.entnahme" if {
	jahr >= 2025
	some p in afs
	some q in p.o6_1c.removals
	im_jahr(q.removal_date)
	q.criteria_maintained == false
	object.keys(q).replant_date
	not nachpflanzung_rechtzeitig(q)
}

schlagbefunde[p.parcel_id] contains "o6_1c.baumpflege" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.stakes_after_planting == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.baumpflege" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.browse_protection == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.baumpflege" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.needed_pruning_done == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.baumpflege" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.establishment_care == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.krautschicht" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.herb_permanently_green == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.krautschicht" if {
	jahr >= 2025
	some p in afs
	p.o6_1c.herb_use in {"Mahd mit Abtransport", "Weide", "sonstige Nutzung"}
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_duenger" if {
	jahr >= 2025
	some p in afs
	some d in p.o6_1c.fertilization_dates
	im_jahr(d)
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_psm" if {
	jahr >= 2025
	some p in afs
	some e in p.o6_1c.psm_events
	im_jahr(e.date)
	e.purpose != "Verbissschutz"
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_psm" if {
	jahr >= 2025
	some p in afs
	some e in p.o6_1c.psm_events
	im_jahr(e.date)
	e.organic_approved == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_psm" if {
	jahr >= 2025
	some p in afs
	some e in p.o6_1c.psm_events
	im_jahr(e.date)
	is_string(e.target)
	not e.target in {"Baum", "Strauch"}
}

schlagbefunde[p.parcel_id] contains "o6_1c.einzelflaeche" if {
	jahr >= 2025
	some p in npa
	some m in p.o6_1c.other_paid_measures
	m != "1C"
}

schlagbefunde[p.parcel_id] contains "o6_1c.anrechnung_npa" if {
	jahr >= 2025
	some p in npa
	p.o6_1c.credited_to_other_obligation
}

schlagbefunde[p.parcel_id] contains "o6_1c.inland" if {
	jahr >= 2025
	some p in schlaege
	is_string(p.o6_1c.country)
	p.o6_1c.country != "AT"
}

schlagbefunde[p.parcel_id] contains "o6_1c.op" if {
	jahr >= 2025
	some p in schlaege
	some code in p.o6_1c.codes
	code == "OP"
}

schlagbefunde[p.parcel_id] contains "o6_1c.nationalpark" if {
	jahr >= 2025
	some p in schlaege
	p.o6_1c.national_park in {"Neusiedlersee", "Donau-Auen"}
}

schlagbefunde[p.parcel_id] contains "o6_1c.nationalpark" if {
	jahr >= 2025
	some p in schlaege
	p.o6_1c.national_park_conditions
}

schlagbefunde[p.parcel_id] contains "o6_1c.versuch" if {
	jahr >= 2025
	some p in schlaege
	p.o6_1c.approved_trial_prevents_compliance
}

schlagbefunde[p.parcel_id] contains "o6_1c.doppelfoerderung" if {
	jahr >= 2025
	some p in schlaege
	p.o6_1c.public_obligation_overlap
}

schlagbefunde[p.parcel_id] contains "o6_1c.ausschluss" if {
	jahr >= 2025
	some p in schlaege
	p.o6_1c.mfa_identification_correct == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.op_dauer" if {
	jahr >= 2025
	some p in schlaege
	p.o6_1c.whole_year_obligations_met == false
}

schlagbefunde[p.parcel_id] contains "o6_1c.matrix" if {
	jahr >= 2025
	some p in schlaege
	some m in p.o6_1c.other_paid_measures
	m != "1C"
	z := kombinationszelle("1C", m)
	z.zeichen == ""
}

# Gutschrift desselben Streifens in den beiden UBB-/BIO-Rechnungen.
div_anrechnung[p.parcel_id] := {
	"feldstueck_id": p.o6_1c.assigned_arable_field_id,
	"beitrag_zu_015_ha": feldstueck_gutschrift[p.parcel_id], "beitrag_zur_sieben_prozent_quote_ha": 0,
} if {
	some p in afs
	is_string(p.o6_1c.assigned_arable_field_id)
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_anlage" if {
	jahr >= 2025
	some p in npa
	is_string(p.land_use)
	p.land_use != "arable"
}

betriebsbefunde contains "o6_1c.einstieg" if {
	some c in betrieb.contracts
	c.category in {"NPA", "AFS"}
	c.entry_year == jahr
	not c.entry_year in {2025, 2026, 2027}
}

betriebsbefunde contains "o6_1c.antrag" if {
	some c in betrieb.contracts
	c.category in {"NPA", "AFS"}
	c.entry_year == jahr
	datum(c.application_date)
	c.application_date > antragsfrist(jahr)
}

# Positivprüfung der Definition gemäß 4.1. Ein fehlender Befund allein reicht dafür nicht aus.
art_bestimmbar(g) if {
	is_string(g.taxon)
	trim_space(g.taxon) != ""
	lower(trim_space(g.taxon)) != "paulownia tomentosa"
}

art_bestimmbar(g) if {
	lower(trim_space(g.taxon)) == "paulownia tomentosa"
	is_boolean(g.fertile)
}

agroforst_definition_erfuellt contains p.parcel_id if {
	some p in afs
	q := p.o6_1c
	jahr >= 2025
	datum(q.planting_date)
	q.planting_date >= "2020-01-01"
	q.planting_date <= stichtag(jahr, "12-31")
	q.adjoins_arable
	q.woody_stock
	q.special_crop_gsp25_4 == false
	is_number(q.average_width_m)
	2 <= q.average_width_m
	q.average_width_m <= 10
	is_number(q.tree_count)
	is_number(q.length_m)
	q.length_m > 0
	q.tree_count * 100 >= 10 * q.length_m
	q.tree_count * 100 <= 25 * q.length_m
	is_number(q.max_tree_gap_m)
	q.max_tree_gap_m >= 0
	q.max_tree_gap_m <= 15
	is_array(q.woody_plants)
	count(q.woody_plants) > 0
	every g in q.woody_plants { art_bestimmbar(g); not negativgehoelz(g)}
	is_array(q.long_side_neighbors)
	not "Wald" in q.long_side_neighbors
	not "flächiges Landschaftselement" in q.long_side_neighbors
}

# Jährliche N-Mengen aus dem Canonical Farm Profile sind für einen positiven Düngebefund ausreichend.
# Eine Menge von null lässt andere Düngegaben offen.
n_duengung_im_jahr(p) if {
	some key in {"mineral_n_kg_per_ha", "organic_n_kg_per_ha"}
	menge := p.operations.fertilizer[key]
	is_number(menge)
	menge > 0
}

schlagbefunde[p.parcel_id] contains "o6_1c.afs_duenger" if {
	jahr >= 2025
	some p in afs
	n_duengung_im_jahr(p)
}

schlagbefunde[p.parcel_id] contains "o6_1c.npa_duenger" if {
	jahr >= 2025
	some p in npa
	im_npa_verbot(p, stichtag(jahr, "12-31"))
	n_duengung_im_jahr(p)
}
