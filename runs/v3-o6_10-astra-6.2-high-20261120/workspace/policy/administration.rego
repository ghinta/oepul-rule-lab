package oepul.o6_10

import rego.v1

# Die Prüffolgen nennen nur durch die Eingabe belegte Sachverhalte.
# Bei Ermessensentscheidungen bleibt die konkrete AMA-Entscheidung offen.
administrative_findings contains {"rule_id": "o6_10.refusal", "outcome": "reject_current_year_and_reverse_contracts"} if {
	control := input.farm.oepul.control
	control.onsite_prevented
	control.force_majeure_or_exceptional == false
}

administrative_findings contains {"rule_id": "o6_10.late_evidence", "outcome": "document_missing", "document": e.id} if {
	some e in input.farm.oepul.requested_evidence
	e.received_on == null
	date_ns(input.farm.oepul.as_of) > date_ns(e.effective_due_on)
}

administrative_findings contains {"rule_id": "o6_10.late_evidence", "outcome": "document_late", "document": e.id} if {
	some e in input.farm.oepul.requested_evidence
	date_ns(e.received_on) > date_ns(e.effective_due_on)
}

administrative_findings contains {"rule_id": "o6_10.third_party", "parcel_id": p.parcel_id, "outcome": "retain_and_present_evidence"} if {
	some p in input.land.parcels
	crop_group(p)
	p.oepul.in_at
	"third_party" in p.oepul.op_reasons
	p.oepul.third_party_evidence_available == false
}

administrative_findings contains {"rule_id": "o6_10.trial", "parcel_id": p.parcel_id, "missing": missing} if {
	some p in input.land.parcels
	crop_group(p)
	p.oepul.in_at
	p.oepul.trial_prevents_compliance
	missing := {key | some key in {"written_approval", "trial_type", "area", "location"}; p.oepul.trial_documentation[key] == false}
	count(missing) > 0
}

administrative_findings contains {"rule_id": "o6_10.trial", "parcel_id": p.parcel_id, "outcome": "code_VF_required"} if {
	some p in input.land.parcels
	crop_group(p)
	p.oepul.in_at
	p.oepul.trial_prevents_compliance
	is_array(p.oepul.codes)
	not "VF" in p.oepul.codes
}

administrative_findings contains {"rule_id": "o6_10.transfer", "parcel_id": p.parcel_id, "outcome": "report_and_code_OP"} if {
	some p in input.land.parcels
	crop_group(p)
	p.oepul.in_at
	p.oepul.transferred_during_year
	p.oepul.transferee_continued_to_year_end == false
}

land_issue[f.parcel_id] contains "transfer" if {
	some f in administrative_findings
	f.rule_id == "o6_10.transfer"
}

permanent_payment_review(context) if context.force_majeure_or_exceptional

permanent_payment_review(context) if {
	year_of(context.event_on) == input.farm.year
	context.event_on > sprintf("%d-04-15", [input.farm.year])
}

permanent_payment_review(context) if {
	year_of(context.event_on) == input.farm.year
	date_ns(context.event_on) > date_ns(context.cover_sown_on)
}

reported_circumstance(p, kind) := c if {
	crop_group(p)
	p.oepul.in_at
	c := p.oepul.changed_circumstances
	c.kind == kind
	c.outside_control
	c.reported_as_required
}

circumstance_review contains {"parcel_id": p.parcel_id, "rule_id": "o6_10.permanent", "outcome": "early_termination_without_recovery_may_be_granted"} if {
	some p in input.land.parcels
	c := reported_circumstance(p, "permanent")
	c.compliance_impossible
}

circumstance_review contains {"parcel_id": p.parcel_id, "rule_id": "o6_10.permanent", "outcome": "payment_in_event_year_may_be_granted"} if {
	some p in input.land.parcels
	c := reported_circumstance(p, "permanent")
	year_of(c.event_on) == input.farm.year
	c.compliance_impossible
	permanent_payment_review(c)
}

temporary_basis(c) if c.compliance_impossible
temporary_basis(c) if c.area_relocated

circumstance_review contains {"parcel_id": p.parcel_id, "rule_id": "o6_10.temporary", "outcome": "recovery_may_be_waived"} if {
	some p in input.land.parcels
	c := reported_circumstance(p, "temporary")
	temporary_basis(c)
}

circumstance_review contains {"parcel_id": p.parcel_id, "rule_id": "o6_10.temporary", "outcome": "payment_in_affected_year_may_be_granted"} if {
	some p in input.land.parcels
	c := reported_circumstance(p, "temporary")
	temporary_basis(c)
	true in [object.get(c, "force_majeure_or_exceptional", null), object.get(c, "conditions_met_on_changed_area", null)]
}
