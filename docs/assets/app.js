const REPOSITORY = "https://github.com/ghinta/oepul-rule-lab";

const MODEL_META = [
  { id: "claude-opus-5-5", label: "Claude Opus 5.5", provider: "Claude" },
  { id: "gpt-5.6-terra", label: "GPT-5.6 Terra", provider: "Codex" },
  { id: "gpt-5.6-sol", label: "GPT-5.6 Sol", provider: "Codex" },
  { id: "gpt-6-astra", label: "GPT-6 Astra", provider: "Codex" },
  { id: "gpt-5.6-luna", label: "GPT-5.6 Luna", provider: "Codex" },
  { id: "gpt-5.5", label: "GPT-5.5", provider: "Codex" },
];

const [measure, model, effort, dir, sourceSheet, rules, references, coverage, tests, proposals, profilePathsAdded, valid] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11];
const labelFor = (id) => MODEL_META.find((item) => item.id === id)?.label ?? id;
const sum = (items, index) => items.reduce((total, item) => total + item[index], 0);
const formatter = new Intl.NumberFormat("en-GB");
const html = (value) => String(value).replace(/[&<>'"]/g, (character) => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", "'": "&#39;", '"': "&quot;" }[character]));

const kpis = document.querySelector("#kpis");
const modelGrid = document.querySelector("#model-grid");
const modelFilter = document.querySelector("#model-filter");
const query = document.querySelector("#query");
const table = document.querySelector("#run-table");
const filterState = document.querySelector("#filter-state");

function renderKpis(items) {
  const values = [
    [items.length, "finalized runs"],
    [new Set(items.map((item) => item[measure])).size, "measures covered"],
    [sum(items, rules), "structured rules"],
    [sum(items, references), "source citations"],
    [sum(items, proposals), "Profile proposals"],
  ];
  kpis.innerHTML = values.map(([value, label]) => `<article class="kpi"><strong>${formatter.format(value)}</strong><span>${label}</span></article>`).join("");
}

function renderModelCards() {
  modelGrid.innerHTML = MODEL_META.map((meta) => {
    const items = RAW_RUNS.filter((item) => item[model] === meta.id);
    const measures = new Set(items.map((item) => item[measure])).size;
    if (!items.length) {
      return `<article class="model-card" data-published="false"><div><div class="model-name">${html(meta.label)}</div><div class="model-provider">${html(meta.provider)}</div></div><p class="model-note">No finalized run published in this checkout.</p></article>`;
    }
    return `<article class="model-card" data-published="true"><div><div class="model-name">${html(meta.label)}</div><div class="model-provider">${html(meta.provider)} · ${html([...new Set(items.map((item) => item[effort]))].join(", "))}</div></div><div><div class="model-stat"><strong>${formatter.format(items.length)}</strong><span>finalized runs</span></div><div class="model-row"><span>${formatter.format(measures)} measures</span><span>${formatter.format(sum(items, rules))} rules</span><span>${formatter.format(sum(items, proposals))} proposals</span></div></div></article>`;
  }).join("");
}

function artifactLinks(run) {
  const root = `${REPOSITORY}/tree/main/runs/${encodeURIComponent(run[dir])}`;
  const proposal = `${REPOSITORY}/blob/main/runs/${encodeURIComponent(run[dir])}/workspace/rules/profile_changes.json`;
  return `<a class="artifact" href="${root}" target="_blank" rel="noreferrer">Run ↗</a><a class="sr-only" href="${proposal}" target="_blank" rel="noreferrer">Profile proposals for ${html(run[measure])}</a>`;
}

function renderTable() {
  const selected = modelFilter.value;
  const text = query.value.trim().toLowerCase();
  const items = RAW_RUNS.filter((item) => (selected === "all" || item[model] === selected) && `${item[measure]} ${item[sourceSheet]} ${labelFor(item[model])}`.toLowerCase().includes(text));
  renderKpis(items);
  filterState.textContent = `${formatter.format(items.length)} of ${formatter.format(RAW_RUNS.length)} runs shown`;
  if (!items.length) {
    table.innerHTML = '<tr><td class="empty" colspan="10">No finalized runs match this filter.</td></tr>';
    return;
  }
  table.innerHTML = items.map((item) => `<tr><td class="measure" data-label="Measure">${html(item[measure])}</td><td data-label="Model"><span class="model-tag">${html(labelFor(item[model]))}</span></td><td class="source-sheet" data-label="Measure leaflet">${html(item[sourceSheet])}</td><td data-label="Rules">${formatter.format(item[rules])}</td><td data-label="Citations">${formatter.format(item[references])}</td><td data-label="Coverage">${formatter.format(item[coverage])}</td><td data-label="Tests">${formatter.format(item[tests])}</td><td data-label="Profile proposals"><a href="${REPOSITORY}/blob/main/runs/${encodeURIComponent(item[dir])}/workspace/rules/profile_changes.json" target="_blank" rel="noreferrer">${formatter.format(item[proposals])}</a></td><td data-label="Checks">${item[valid] ? '<span class="gate">Passed</span>' : '<span class="gate">Review</span>'}</td><td data-label="Files">${artifactLinks(item)}</td></tr>`).join("");
}

function initFilters() {
  const available = MODEL_META.filter((meta) => RAW_RUNS.some((item) => item[model] === meta.id));
  modelFilter.innerHTML = [`<option value="all">All models</option>`, ...available.map((meta) => `<option value="${meta.id}">${html(meta.label)}</option>`)].join("");
  modelFilter.value = "all";
  modelFilter.addEventListener("change", renderTable);
  query.addEventListener("input", renderTable);
}

renderModelCards();
initFilters();
renderTable();

document.querySelector("#snapshot").textContent = `Run metadata through ${RUN_SNAPSHOT.latestFinalizedAt.slice(0, 10)}`;
document.querySelector("#data-date").textContent = `Latest finalized run: ${RUN_SNAPSHOT.latestFinalizedAt.slice(0, 10)}.`;
