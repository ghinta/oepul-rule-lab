const REPOSITORY = "https://github.com/ghinta/oepul-rule-lab";

const MODEL_META = [
  { id: "claude-opus-5-5", label: "Claude Opus 5.5", provider: "Claude", published: true },
  { id: "gpt-5.6-terra", label: "GPT-5.6 Terra", provider: "Codex", published: true },
  { id: "gpt-5.6-sol", label: "GPT-5.6 Sol", provider: "Codex", published: false, note: "Kein finalisiertes Run-Artefakt auf origin/main." },
  { id: "gpt-6-astra", label: "GPT-6 Astra", provider: "Codex", published: false, note: "Kein finalisiertes Run-Artefakt auf origin/main." },
  { id: "gpt-5.6-luna", label: "GPT-5.6 Luna", provider: "Codex", published: true },
  { id: "gpt-5.5", label: "GPT-5.5", provider: "Codex", published: true },
];

const RAW_RUNS = [["o6_1a","claude-opus-5-5","high","v2-o6_1a-opus-5.5-high-20260929","o6_1a_ubb_2026_04.pdf",166,418,141,143,67,190,true],["o6_1a","gpt-5.5","high","v2-o6_1a-gpt55-20260918","o6_1a_ubb_2026_04.pdf",41,54,40,7,34,53,true],["o6_1a","gpt-5.6-terra","high","v2-o6_1a-terra-20260920","o6_1a_ubb_2026_04.pdf",38,44,34,8,1,29,true],["o6_1b","claude-opus-5-5","high","v2-o6_1b-opus-5.5-high-20260925","o6_1b_biologische_wirtschaftsweise_2026_04.pdf",200,588,239,111,89,192,true],["o6_1b","gpt-5.6-terra","high","v2-o6_1b-terra-20260925","o6_1b_biologische_wirtschaftsweise_2026_04.pdf",36,40,38,4,11,30,true],["o6_1c","claude-opus-5-5","high","v2-o6_1c-opus-5.5-high-20260925","o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf",97,258,179,74,11,88,true],["o6_1c","gpt-5.6-terra","high","v2-o6_1c-terra-20260926","o6_1c_nichtproduktive_ackerflaechen_und_agroforststreifen_2025_10.pdf",32,14,22,4,3,43,true],["o6_2","gpt-5.6-terra","high","v2-o6_2-terra-20260921","o6_2_einschraenkung_ertragssteig_betriebsmittel_2026_04.pdf",29,25,41,3,3,39,true],["o6_3","gpt-5.6-terra","high","v2-o6_3-terra-high-20260925","o6_3_heuwirtschaft_2025_10.pdf",31,41,46,5,6,28,true],["o6_4","claude-opus-5-5","high","v2-o6_4-opus-5.5-high-20260925","o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf",74,162,134,57,21,46,true],["o6_4","gpt-5.6-terra","high","v2-o6_4-terra-high-20260925","o6_4_bewirtschaftung_von_bergmaehdern_2025_10.pdf",20,31,26,3,8,34,true],["o6_5","claude-opus-5-5","high","v2-o6_5-opus-5.5-high-20260925","o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf",97,189,143,93,7,62,true],["o6_5","gpt-5.6-terra","high","v2-o6_5-terra-20260926","o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf",26,17,30,3,5,32,true],["o6_6","claude-opus-5-5","high","v2-o6_6-opus-5.5-high-20260925","o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf",111,290,154,101,47,72,true],["o6_6","gpt-5.6-terra","high","v2-o6_6-terra-20260926","o6_6_begruenung_ackerflaechen_zwischenfruchtanbau_2025_10.pdf",32,25,32,3,1,40,true],["o6_7","claude-opus-5-5","high","v2-o6_7-opus-5.5-high-20260925","o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf",107,265,161,106,25,88,true],["o6_7","gpt-5.6-terra","high","v2-o6_7-terra-20260926","o6_7_begruenung_ackerflaechen_system_immergruen_2025_10.pdf",34,20,31,4,10,50,true],["o6_8","gpt-5.6-terra","high","v2-o6_8-terra-high-retry-20260924","o6_8_erosionsschutz_acker_2026_04.pdf",26,24,32,6,2,35,true],["o6_9","claude-opus-5-5","high","v2-o6_9-opus-5.5-high-20260925","o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf",96,222,145,60,26,63,true],["o6_9","gpt-5.6-terra","high","v2-o6_9-terra-high-20260925","o6_9_ausbringung_fluessiger_wirtschaftsduenger_guelleseparation_2026_06.pdf",25,19,53,4,1,28,true],["o6_10","claude-opus-5-5","high","v2-o6_10-opus-5.5-high-20260925","o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf",91,191,126,56,20,62,true],["o6_10","gpt-5.6-terra","high","v2-o6_10-terra-20260927","o6_10_erosionsschutz_wein_obst_hopfen_2025_10.pdf",31,27,38,5,2,40,true],["o6_11","gpt-5.6-luna","high","v2-o6_11-luna-20260920","o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf",26,36,38,7,9,32,true],["o6_11","gpt-5.6-terra","high","v2-o6_11-terra-20260927","o6_11_herbizidverzicht_wein_obst_hopfen_2026_04.pdf",23,19,39,2,5,36,true],["o6_12","claude-opus-5-5","high","v2-o6_12-opus-5.5-high-20260926","o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf",91,190,178,68,17,83,true],["o6_12","gpt-5.6-terra","high","v2-o6_12-terra-20260928","o6_12_insektizidverzicht_wein_obst_hopfen_2026_04.pdf",34,40,44,5,10,34,true],["o6_13","claude-opus-5-5","high","v2-o6_13-opus-5.5-high-20260926","o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf",80,169,137,77,23,76,true],["o6_13","gpt-5.6-terra","high","v2-o6_13-terra-20260928","o6_13_einsatz_von_nuetzlingen_im_geschuetzten_anbau_2025_10.pdf",26,26,39,4,7,38,true],["o6_14","claude-opus-5-5","high","v2-o6_14-opus-5.5-high-20260926","o6_14_almbewirtschaftung_2026_04.pdf",126,311,121,122,4,136,true],["o6_14","gpt-5.6-terra","high","v2-o6_14-terra-20260928","o6_14_almbewirtschaftung_2026_04.pdf",30,22,28,3,3,52,true],["o6_15","claude-opus-5-5","high","v2-o6_15-opus-5.5-high-20260926","o6_15_tierwohl-behirtung_2026_04.pdf",95,201,132,64,7,93,true],["o6_15","gpt-5.6-terra","high","v2-o6_15-terra-20260928","o6_15_tierwohl-behirtung_2026_04.pdf",25,24,23,5,2,50,true],["o6_16","gpt-5.6-terra","high","v2-o6_16-terra-20260919","o6_16_vorbeugender_grundwasserschutz_acker_2026_04.pdf",34,30,40,9,1,94,true],["o6_17","gpt-5.6-terra","high","v2-o6_17-terra-high-20260925","o6_17_humuserhalt_und_bodenschutz_auf_umbruchsfaehigem-gruenland_2025_10.pdf",28,31,46,4,3,53,true],["o6_18","claude-opus-5-5","high","v2-o6_18-opus-5.5-high-20260927","o6_18_naturschutz_2025_10.pdf",125,321,115,96,30,112,true],["o6_18","gpt-5.6-terra","high","v2-o6_18-terra-retry-20260929","o6_18_naturschutz_2025_10.pdf",25,19,23,7,1,20,true],["o6_19","claude-opus-5-5","high","v2-o6_19-opus-5.5-high-20260927","o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf",102,199,151,76,94,97,true],["o6_19","gpt-5.6-terra","high","v2-o6_19-terra-20260929","o6_19_ergebnisorientierte_bewirtschaftung_2025_10.pdf",30,31,52,5,4,43,true],["o6_20","claude-opus-5-5","high","v2-o6_20-opus-5.5-high-20260928","o6_20_tierwohl_weide_2025_10.pdf",97,196,216,61,6,92,true],["o6_20","gpt-5.6-terra","high","v2-o6_20-terra-20260929","o6_20_tierwohl_weide_2025_10.pdf",32,23,20,4,1,52,true],["o6_21","claude-opus-5-5","high","v2-o6_21-opus-5.5-high-20260928","o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf",124,241,137,75,11,115,true],["o6_21","gpt-5.6-terra","high","v2-o6_21-terra-20260929","o6_21_tierwohl-stallhaltung_rinder_2025_10.pdf",17,18,24,4,3,33,true],["o6_22","claude-opus-5-5","high","v2-o6_22-opus-5.5-high-20260928","o6_22_tierwohl-schweinehaltung_2025_10.pdf",126,272,167,84,40,90,true],["o6_22","gpt-5.6-terra","high","v2-o6_22-terra-20260929","o6_22_tierwohl-schweinehaltung_2025_10.pdf",24,22,61,4,1,47,true],["o6_23","claude-opus-5-5","high","v2-o6_23-opus-5.5-high-20260928","o6_23_natura2000-landwirtschaft_2025_10.pdf",88,182,140,60,9,46,true],["o6_23","gpt-5.6-terra","high","20260930T002730Z__o6_23__gpt-5.6-terra","o6_23_natura2000-landwirtschaft_2025_10.pdf",22,25,27,7,7,20,true],["o6_24","claude-opus-5-5","high","v2-o6_24-opus-5.5-high-20260928","o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf",62,140,179,62,22,46,true],["o6_24","gpt-5.6-terra","high","20260930T004645Z__o6_24__gpt-5.6-terra","o6_24_wasserrahmenrichtlinie-landwirtschaft_2025_10.pdf",21,25,44,4,3,24,true]];

RAW_RUNS.push(["o6_5","gpt-5.6-luna","high","v2-o6_5-luna-high-20261002","o6_5_erhaltung_gefaehrdeter_nutztierrassen_2025_10.pdf",55,29,31,10,2,50,true]);

const [measure, model, effort, dir, sourceSheet, rules, references, coverage, tests, proposals, profilePathsAdded, valid] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
const labelFor = (id) => MODEL_META.find((item) => item.id === id)?.label ?? id;
const sum = (items, index) => items.reduce((total, item) => total + item[index], 0);
const formatter = new Intl.NumberFormat("de-AT");
const html = (value) => String(value).replace(/[&<>'"]/g, (character) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", "'": "&#39;", '"': "&quot;" }[character]));

const kpis = document.querySelector("#kpis");
const modelGrid = document.querySelector("#model-grid");
const modelFilter = document.querySelector("#model-filter");
const query = document.querySelector("#query");
const table = document.querySelector("#run-table");
const filterState = document.querySelector("#filter-state");

function renderKpis(items) {
  const values = [
    [items.length, "finalisierte Runs"],
    [new Set(items.map((item) => item[measure])).size, "abgedeckte Maßnahmen"],
    [sum(items, rules), "strukturierte Regeln"],
    [sum(items, references), "Quellenreferenzen"],
    [sum(items, proposals), "Profilvorschläge"],
  ];
  kpis.innerHTML = values.map(([value, label]) => `<article class="kpi"><strong>${formatter.format(value)}</strong><span>${label}</span></article>`).join("");
}

function renderModelCards() {
  modelGrid.innerHTML = MODEL_META.map((meta) => {
    const items = RAW_RUNS.filter((item) => item[model] === meta.id);
    const measures = new Set(items.map((item) => item[measure])).size;
    if (!meta.published) {
      return `<article class="model-card" data-published="false"><div><div class="model-name">${html(meta.label)}</div><div class="model-provider">${html(meta.provider)}</div></div><p class="model-note">${html(meta.note)}</p></article>`;
    }
    return `<article class="model-card" data-published="true"><div><div class="model-name">${html(meta.label)}</div><div class="model-provider">${html(meta.provider)} · high</div></div><div><div class="model-stat"><strong>${formatter.format(items.length)}</strong><span>finalisierte Runs</span></div><div class="model-row"><span>${formatter.format(measures)} Maßnahmen</span><span>${formatter.format(sum(items, rules))} Regeln</span><span>${formatter.format(sum(items, proposals))} Vorschläge</span></div></div></article>`;
  }).join("");
}

function artifactLinks(run) {
  const root = `${REPOSITORY}/tree/main/runs/${encodeURIComponent(run[dir])}`;
  const proposal = `${REPOSITORY}/blob/main/runs/${encodeURIComponent(run[dir])}/workspace/rules/profile_changes.json`;
  return `<a class="artifact" href="${root}" target="_blank" rel="noreferrer">Run ↗</a><a class="sr-only" href="${proposal}" target="_blank" rel="noreferrer">Profilvorschläge für ${html(run[measure])}</a>`;
}

function renderTable() {
  const selected = modelFilter.value;
  const text = query.value.trim().toLowerCase();
  const items = RAW_RUNS.filter((item) => (selected === "all" || item[model] === selected) && `${item[measure]} ${item[sourceSheet]} ${labelFor(item[model])}`.toLowerCase().includes(text));
  renderKpis(items);
  filterState.textContent = `${formatter.format(items.length)} von ${formatter.format(RAW_RUNS.length)} Runs sichtbar`;
  if (!items.length) {
    table.innerHTML = '<tr><td class="empty" colspan="10">Keine finalisierten Runs für diesen Filter.</td></tr>';
    return;
  }
  table.innerHTML = items.map((item) => `<tr><td class="measure" data-label="Maßnahme">${html(item[measure])}</td><td data-label="Modell"><span class="model-tag">${html(labelFor(item[model]))}</span></td><td class="source-sheet" data-label="Maßnahmenblatt">${html(item[sourceSheet])}</td><td data-label="Regeln">${formatter.format(item[rules])}</td><td data-label="Referenzen">${formatter.format(item[references])}</td><td data-label="Coverage">${formatter.format(item[coverage])}</td><td data-label="Tests">${formatter.format(item[tests])}</td><td data-label="Profilvorschläge"><a href="${REPOSITORY}/blob/main/runs/${encodeURIComponent(item[dir])}/workspace/rules/profile_changes.json" target="_blank" rel="noreferrer">${formatter.format(item[proposals])}</a></td><td data-label="Gates">${item[valid] ? '<span class="gate">gültig</span>' : '<span class="gate">prüfen</span>'}</td><td data-label="Artefakt">${artifactLinks(item)}</td></tr>`).join("");
}

function initFilters() {
  const available = MODEL_META.filter((meta) => RAW_RUNS.some((item) => item[model] === meta.id));
  modelFilter.innerHTML = [`<option value="all">Alle Modelle</option>`, ...available.map((meta) => `<option value="${meta.id}">${html(meta.label)}</option>`)].join("");
  modelFilter.value = "all";
  modelFilter.addEventListener("change", renderTable);
  query.addEventListener("input", renderTable);
}

renderModelCards();
initFilters();
renderTable();
