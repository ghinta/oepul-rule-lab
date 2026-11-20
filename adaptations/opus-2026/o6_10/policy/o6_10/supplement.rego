# o6_10 – Optionaler Zuschlag Einsatz von Organismen oder Pheromonen (Code EOP)
package oepul.o6_10

# O610-APP-EOP-CODE: Beantragung über Code EOP am Schlag, keine gesonderte Beantragung bis 31.12.
eop_parcels := [p | some p in vfh_parcels; params.eop_supplement_parcel_code in parcel_codes(p)]

eop_requested if count(eop_parcels) > 0

# O610-EOP-NO-OP-PO: keine Teilnahme an einem operationellen Programm mit Abgeltung von Organismen/Pheromonen
po := object.get(input, ["farm", "oepul", "producer_organisation"], {})

po_blocks_eop if {
	object.get(po, "is_member", false) == true
	object.get(po, "operational_programme_compensates_organisms_or_pheromones", false) == true
}

# O610-EOP-REQ-USE + O610-EOP-REPLACE-PSM: auf zumindest einem Schlag anrechenbarer Einsatz
creditable_use(p) if {
	u := object.get(p, ["operations", "organisms_pheromones"], {})
	object.get(u, "used", false) == true
	object.get(u, "per_register_application_rates", false) == true
	object.get(u, "replaces_psm_application", false) == true
}

eop_use_fulfilled if {
	some p in vfh_parcels
	creditable_use(p)
}

eop_rejections contains {
	"rule_id": "O610-EOP-NO-OP-PO",
	"reason": "Mitglied einer Erzeugerorganisation mit operationellem Programm, das Organismen oder Pheromone abgilt: Zuschlag nicht möglich",
} if {
	eop_requested
	po_blocks_eop
}

eop_rejections contains {
	"rule_id": "O610-EOP-REQ-USE",
	"reason": "Kein anrechenbarer Einsatz von Organismen oder Pheromonen gemäß Aufwandsmengen im Pflanzenschutzmittelregister, der einen Pflanzenschutzmitteleinsatz ersetzt",
} if {
	eop_requested
	not eop_use_fulfilled
}

default eop_supplement_granted := false

eop_supplement_granted if {
	eop_requested
	contract_valid
	count(eop_rejections) == 0
}

# O610-EOP-RECORDS
eop_record_items := {i | some i in object.get(input, ["documentation", "o6_10_organisms_pheromones_record_items"], [])}

missing_eop_record_items contains r.item if {
	eop_requested
	some r in data.o6_10.record_requirements.organisms_pheromones_records
	not r.item in eop_record_items
}

farm_obligation_violations contains {
	"rule_id": "O610-EOP-RECORDS",
	"reason": sprintf("Schlagbezogene Aufzeichnungen zu Organismen/Pheromonen unvollständig, es fehlen: %v", [sort(missing_eop_record_items)]),
} if {
	count(missing_eop_record_items) > 0
}

# O610-PREM-EOP-REDUCTION: Kürzung um 50 % bei Teilnahme an 12 oder 1B
eop_reduction_applies if {
	some m in rates.supplement_reduction.triggering_measures
	m in participating_measures
}

default eop_reduction_factor := 1

eop_reduction_factor := (100 - rates.supplement_reduction.reduction_percent) / 100 if eop_reduction_applies
