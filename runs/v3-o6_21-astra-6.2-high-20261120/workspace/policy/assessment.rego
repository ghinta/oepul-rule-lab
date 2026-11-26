package oepul.o6_21

import rego.v1

# Independently established findings. A missing scalar has no entry.
assessment["rgve_je_ohrmarke"] := per_animal_rgve if register_valid
assessment["jahresdurchschnitt_rgve"] := annual_rgve
assessment["mindestteilnahme_erreicht"] := minimum_participation_met
assessment["erloschene_kategorien"] := expired_categories if register_valid
assessment["abzumeldende_ohrmarken"] := animal_withdrawal_due if is_array(claim.housing_events)
assessment["fehlende_krankheitsaufzeichnungen"] := medical_records_missing if is_array(claim.housing_events)
assessment["flaechenpruefung_je_abteil"] := pen_space if is_array(claim.pens)
assessment["stallskizze_und_belegungsplan_erforderlich"] := plans_required
assessment["tgd_erforderlich"] := tgd_required
assessment["qplus_erforderlich"] := qplus_required
assessment["tgd_zeitraum"] := membership_status(claim.tgd) if tgd_required
assessment["qplus_zeitraum"] := membership_status(claim.qplus) if qplus_required

assessment["ausstehende_programmnachweise"] := proof_outstanding if {
	is_boolean(tgd_required)
	is_boolean(qplus_required)
}

assessment["fristpruefungen"] := entry_checks
assessment["vertragsfolgen"] := contract_effects if is_object(claim)
assessment["grundtarif_euro_vor_kuerzungen"] := base_amount_eur
assessment["festmistzuschlag_euro_vor_kuerzungen"] := compost_amount_eur
assessment["tarif_euro_nach_flaechenmodulation"] := modulated_tariff_eur

membership_status(p) := "erfüllt" if program_covers_year(p)

else := "nicht erfüllt" if p.recognised == false

else := "nicht erfüllt" if day(p.start) > day(program_start(year))

else := "nicht erfüllt" if day(p.end) < jan(year + 1) - 1

assessment["unzulässig_abgesperrte_abteile"] := restricted_pens if is_array(claim.pens)

assessment["fehlende_belegungsplaene"] := plan_missing if {
	plans_required
	is_array(claim.pens)
	is_array(input.documentation.o6_21_pen_plans)
}
