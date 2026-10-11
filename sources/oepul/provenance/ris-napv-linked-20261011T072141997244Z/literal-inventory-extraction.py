from pathlib import Path
from copy import deepcopy
from lxml import html
from collections import Counter
import json,sys
sys.path.insert(0,'sources/oepul');import manage_sources as s
root_path=s.REPO_ROOT
expected_path=root_path/'sources/oepul/reviews/20261011/napv.expected.json'
expected=json.loads(expected_path.read_text());html_path=root_path/'sources/oepul/provenance/ris-napv-20261011T071604951641Z/napv-full-20261011.html';doc=html.fromstring(html_path.read_bytes())
expected_hashes=expected['original_source_hashes']
assert s.sha256_file(html_path) in expected_hashes
pdf_path=root_path/'sources/oepul/supplemental/napv/763f19e5bfc8be305dff0eeacc3f905f9d2066f289079b7715756fe9b7f54c5c/napv-full-20261011.pdf'
assert s.sha256_file(pdf_path) in expected_hashes

def visible(node):
 clean=deepcopy(node)
 for d in clean.xpath('.//*[contains(concat(" ",normalize-space(@class)," ")," sr-only ")]'): d.drop_tree()
 return clean

def text(node):return ' '.join(visible(node).text_content().split())
def cell(node):
 n=visible(node)
 return {'tag':n.tag,'text':' '.join(n.text_content().split()),'rowspan':int(n.get('rowspan','1')),'colspan':int(n.get('colspan','1')),'original_blank':not bool(n.text_content().strip()),'inline_superscripts':[' '.join(x.text_content().split()) for x in n.xpath('.//sup')]}
def rows(node):return node.xpath('./tr|./tbody/tr|./thead/tr|./tfoot/tr')
def row(node):return {'cells':[cell(c) for c in node.xpath('./td|./th')],'original_blank':not bool(text(node))}
items=[]
for d in expected['inventory_items']:
 nodes=doc.xpath(d['html_xpath']);assert len(nodes)==1,(d['id'],len(nodes));n=nodes[0]
 k=d['kind']
 if k=='cell':value=cell(n)
 elif k=='row':value=row(n)
 elif k=='table':value={'rows':[row(r) for r in rows(n)]}
 elif k=='image':value={'printed_formula':'N-Menge [kg N/ha] = (NO3-Gehalt [mg/l] / 4,43) * (Bewässerungsmenge [mm] / 100)','transcription_source':'Exact index-linked RIS PDF, printed page16, Anlage3 AbschnittIV; visually read from rendered PDF page.','original_html_image_path':n.get('src'),'printed_units':{'N-Menge':'kg N/ha','NO3-Gehalt':'mg/l','Bewässerungsmenge':'mm'},'rounding_rule':None}
 elif k=='text':
  v=visible(n);value={'text':' '.join(v.text_content().split()),'original_visible_text':v.text_content(),'legal_numbering_context':d.get('legal_numbering_context',[])}
 else:raise AssertionError(k)
 items.append({'id':d['id'],'source_locator':d['source_locator'],'kind':k,'value':value})
notes=[]
for d in expected['inventory_footnotes']:
 nodes=doc.xpath(d['html_xpath']);assert len(nodes)==1;notes.append({'id':d['id'],'source_locator':d['source_locator'],'text':text(nodes[0]),'printed_marker':d.get('printed_marker'),'kind':d['kind']})
assert set(i['id'] for i in items)==set(expected['expected_item_ids'])
assert set(i['id'] for i in notes)==set(expected['expected_footnote_ids'])
assert len(items)==7692 and len(notes)==10
review={'schema_version':1,'scope_id':'napv','artifact_type':'literal_source_inventory_review','reviewed_by':'NAPV source capture and literal inventory reviewer','reviewed_on':'2026-10-11','original_source_hashes':expected_hashes,'inventory_originals':expected['inventory_originals'],'expected_inventory':{'local_path':s.relative_path(expected_path),'sha256':s.sha256_file(expected_path)},'method':'Literal values projected from complete archived dated RIS HTML against an independently established original inventory. Removes only duplicate sr-only accessibility paraphrases. Every original row and physical cell, including blanks, merged rowspan/colspan structure and superscripts, is retained; original numbering context is retained for prose. Formula transcribed from visual printed PDF16. FullPDF/HTML hashes both remain explicit. Counts describe source inventory artifacts, not a count of executable rules or unique normative facts.','items':items,'footnotes':notes,'coverage':{'item_count':len(items),'footnote_or_editorial_note_count':len(notes),'item_kinds':dict(Counter(x['kind'] for x in items)),'missing_expected_ids':[],'extra_ids':[]},'legal_completeness_claimed':False,'intake_ready_claimed':False,'limits':['Original literal inventory coverage is independent from executable interpretation and does not approve source-to-profile factor mappings.','HTML is the actual source for exact cell/text projection; PDF is the dated entire-law original and visual formula source. Their different hashes are not relabeled or omitted.','The current single-index intake contract cannot make HTML-plus-PDF simultaneously current from this captured PDF index; napv remains pending.','Nitrogen-family cross-source scope, annual-effective/excretion basis, TM/FM interpretation and rounding remain unresolved.']}
out=root_path/'sources/oepul/reviews/20261011/napv.review.json';s.preserve(out,s.json_bytes(review))
print(json.dumps({'review_path':s.relative_path(out),'sha256':s.sha256_file(out),'file_size_bytes':out.stat().st_size,'expected_path':s.relative_path(expected_path),'expected_sha256':s.sha256_file(expected_path),'original_source_hashes':expected_hashes,'counts':review['coverage']},ensure_ascii=False,indent=2))
