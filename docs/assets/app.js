"use strict";

const DATA = window.RULELAB_DATA;
const REPOSITORY = DATA.repository;
const OPUS = DATA.comparison.challenger;
const TERRA = DATA.comparison.baseline;
const SVG_NS = "http://www.w3.org/2000/svg";

const numberFormat = new Intl.NumberFormat("de-AT");
const decimalFormat = new Intl.NumberFormat("de-AT", { minimumFractionDigits: 1, maximumFractionDigits: 1 });
const twoDecimals = new Intl.NumberFormat("de-AT", { minimumFractionDigits: 2, maximumFractionDigits: 2 });
const dateFormat = new Intl.DateTimeFormat("de-AT", { day: "numeric", month: "long", year: "numeric", timeZone: "Europe/Vienna" });

const fmt = (value) => (value == null ? "–" : numberFormat.format(value));
const pct = (value) => (value == null || !Number.isFinite(value) ? "–" : `${numberFormat.format(Math.round(value * 100))} %`);
const factor = (a, b) => (b ? `×${decimalFormat.format(a / b)}` : "–");
const sum = (items, key) => items.reduce((total, item) => total + (item[key] || 0), 0);

const MODEL_PROVIDER = { "claude-cli": "Claude Code", "codex-cli": "Codex" };
const SOURCE_LABELS = {
  measure: "Informationsblatt der Maßnahme",
  atb: "Allgemeine Teilnahmebedingungen",
  srl: "Sonderrichtlinie ÖPUL 2023",
  srl_annex: "SRL-Anhänge",
  notice: "Bekanntmachungen 2026",
  other: "Sonstige",
};
const AMA_LABELS = { ja: "ja", teilweise: "teilweise", nein: "nein" };
const AMA_ICONS = { ja: "✓", teilweise: "◐", nein: "✕" };
const CLASS_LABELS = { A: "Zugang und Empfehlung", B: "Bewirtschaftung", C: "Abwicklung" };
const CLASS_SHORT = { A: "Zugang", B: "Bewirt\u00adschaftung", C: "Abwicklung" };

const runs = DATA.runs;
const measureTitle = Object.fromEntries(DATA.measures.map((m) => [m.id, m.title]));
const modelLabel = Object.fromEntries(DATA.models.map((m) => [m.id, m.label]));
const labelFor = (id) => modelLabel[id] || id;
const runsOf = (model) => runs.filter((run) => run.model === model);
const conceptById = Object.fromEntries(DATA.concepts.map((c) => [c.id, c]));

function el(tag, attrs = {}, ...children) {
  const node = document.createElement(tag);
  setAttributes(node, attrs);
  appendChildren(node, children);
  return node;
}

function svg(tag, attrs = {}, ...children) {
  const node = document.createElementNS(SVG_NS, tag);
  setAttributes(node, attrs);
  appendChildren(node, children);
  return node;
}

function setAttributes(node, attrs) {
  for (const [key, value] of Object.entries(attrs)) {
    if (value == null || value === false) continue;
    if (key === "class") node.setAttribute("class", value);
    else if (key === "text") node.textContent = value;
    else if (key.startsWith("on") && typeof value === "function") node.addEventListener(key.slice(2), value);
    else node.setAttribute(key, value === true ? "" : String(value));
  }
}

function appendChildren(node, children) {
  for (const child of children.flat()) {
    if (child == null || child === false) continue;
    node.append(child instanceof Node ? child : document.createTextNode(String(child)));
  }
}

function modelTag(model) {
  const swatchClass = model === OPUS ? "swatch opus" : model === TERRA ? "swatch terra" : null;
  return el("span", { class: "model-tag" }, swatchClass ? el("span", { class: swatchClass, "aria-hidden": "true" }) : null, labelFor(model));
}

function amaBadge(status) {
  return el("span", { class: `ama ${status}` }, el("span", { class: "ama-icon", "aria-hidden": "true" }, AMA_ICONS[status] || "?"), AMA_LABELS[status] || status);
}

function classTag(cls) {
  return el("span", { class: "class-tag", title: CLASS_LABELS[cls] || "" }, cls);
}

function runLink(run, path = "") {
  return `${REPOSITORY}/tree/main/runs/${encodeURIComponent(run.run_id)}${path}`;
}

function blobLink(run, path) {
  return `${REPOSITORY}/blob/main/runs/${encodeURIComponent(run.run_id)}/${path}`;
}

function optionList(select, options, value = "all") {
  select.replaceChildren(...options.map(([optionValue, label]) => el("option", { value: optionValue }, label)));
  select.value = value;
}

function table(columns, rows, emptyText) {
  const head = el("thead", {}, el("tr", {}, columns.map((c) => el("th", { class: c.num ? "num" : null, scope: "col" }, c.label))));
  const body = el("tbody");
  if (!rows.length) {
    body.append(el("tr", {}, el("td", { class: "empty", colspan: columns.length }, emptyText)));
  }
  for (const row of rows) {
    body.append(
      el(
        "tr",
        {},
        columns.map((c) => el("td", { class: [c.num ? "num" : null, c.wide ? "wide" : null, c.cellClass || null].filter(Boolean).join(" ") || null, "data-label": c.label }, c.render(row)))
      )
    );
  }
  return el("table", {}, head, body);
}

/* ---------- Comparison facts ---------- */

const opusRuns = runsOf(OPUS);
const terraRuns = runsOf(TERRA);

function pairTotals() {
  const totals = { terraPages: 0, opusPages: 0, terraPagesIn: 0, opusPagesIn: 0, terraQuotes: 0, opusQuotes: 0, terraQuotesIn: 0, opusQuotesIn: 0 };
  for (const pair of DATA.pairs) {
    const base = runs[pair.baseline];
    const chal = runs[pair.challenger];
    totals.terraPages += pair.baseline_pages;
    totals.opusPages += pair.challenger_pages;
    totals.terraPagesIn += Math.round((pair.baseline_pages_in_challenger || 0) * pair.baseline_pages);
    totals.opusPagesIn += Math.round((pair.challenger_pages_in_baseline || 0) * pair.challenger_pages);
    totals.terraQuotes += base.references;
    totals.opusQuotes += chal.references;
    totals.terraQuotesIn += Math.round((pair.baseline_in_challenger || 0) * base.references);
    totals.opusQuotesIn += Math.round((pair.challenger_in_baseline || 0) * chal.references);
  }
  return totals;
}

const TOTALS = pairTotals();

function share(items, key) {
  const rules = sum(items, "rules");
  return rules ? sum(items, key) / rules : null;
}

function fillFacts() {
  const costs = opusRuns.map((run) => run.generation.cost_usd).filter((v) => v != null);
  const minutes = opusRuns.map((run) => run.generation.api_minutes).filter((v) => v != null);
  const facts = {
    "pages-terra-in-opus": pct(TOTALS.terraPagesIn / TOTALS.terraPages),
    "pages-opus-in-terra": pct(TOTALS.opusPagesIn / TOTALS.opusPages),
    "quotes-terra-in-opus": pct(TOTALS.terraQuotesIn / TOTALS.terraQuotes),
    "rules-factor": factor(sum(opusRuns, "rules"), sum(terraRuns, "rules")),
    "tests-factor": factor(sum(opusRuns, "tests"), sum(terraRuns, "tests")),
    "rego-factor": factor(sum(opusRuns, "rego_lines"), sum(terraRuns, "rego_lines")),
    "exec-opus": pct(share(opusRuns, "rules_with_rego")),
    "exec-terra": pct(share(terraRuns, "rules_with_rego")),
    "english-terra": fmt(terraRuns.filter((run) => run.english_share > 0.5).length),
    "cost-opus": costs.length ? `${fmt(Math.round(costs.reduce((a, b) => a + b, 0)))} USD` : "–",
    "api-opus": minutes.length ? `${fmt(Math.round(minutes.reduce((a, b) => a + b, 0) / 60))} h` : "–",
  };
  for (const node of document.querySelectorAll("[data-fact]")) {
    node.textContent = facts[node.dataset.fact] ?? "–";
  }
}

/* ---------- Overview ---------- */

function renderSnapshot() {
  const measures = new Set(runs.map((run) => run.measure)).size;
  const asOf = DATA.as_of ? dateFormat.format(new Date(DATA.as_of)) : "unbekannt";
  document.querySelector("#snapshot").textContent = `Stand: ${asOf} · ${fmt(runs.length)} Runs · ${fmt(measures)} Maßnahmen`;
  document.querySelector("#footer-state").textContent = `Letzter finalisierter Run: ${asOf}.`;
}

function renderKpis() {
  const values = [
    [runs.length, "finalisierte Runs"],
    [new Set(runs.map((run) => run.measure)).size, "abgedeckte Maßnahmen"],
    [sum(runs, "rules"), "strukturierte Regeln"],
    [sum(runs, "references"), "Quellenreferenzen"],
    [sum(runs, "proposals"), "Profilvorschläge"],
  ];
  document.querySelector("#kpis").replaceChildren(...values.map(([value, label]) => el("article", { class: "kpi" }, el("strong", {}, fmt(value)), el("span", {}, label))));
}

function renderModelCards() {
  const cards = DATA.models.map((model) => {
    const items = runsOf(model.id);
    const adapter = items[0]?.adapter;
    const efforts = [...new Set(items.map((run) => run.effort))].join(", ");
    return el(
      "article",
      { class: "model-card" },
      el("div", {}, el("div", { class: "model-name" }, model.label), el("div", { class: "model-provider" }, `${MODEL_PROVIDER[adapter] || adapter} · ${efforts}`)),
      el(
        "div",
        {},
        el("div", { class: "model-stat" }, el("strong", {}, fmt(items.length)), el("span", {}, items.length === 1 ? "finalisierter Run" : "finalisierte Runs")),
        el("div", { class: "model-row" }, el("span", {}, `${fmt(new Set(items.map((run) => run.measure)).size)} Maßnahmen`), el("span", {}, `${fmt(sum(items, "rules"))} Regeln`), el("span", {}, `${fmt(sum(items, "proposals"))} Vorschläge`))
      )
    );
  });
  document.querySelector("#model-grid").replaceChildren(...cards);
}

/* ---------- Comparison: tiles and meters ---------- */

const PAIR_METRICS = [
  ["rules", "Strukturierte Regeln"],
  ["references", "Quellenreferenzen"],
  ["coverage", "Coverage-Einträge"],
  ["tests", "Generierte Tests"],
  ["rego_lines", "Rego-Zeilen"],
  ["paths_added", "Vorgeschlagene Profilpfade"],
];

function renderPairTiles() {
  const tiles = PAIR_METRICS.map(([key, label]) => {
    const opus = sum(opusRuns, key);
    const terra = sum(terraRuns, key);
    return el(
      "article",
      { class: "pair-tile" },
      el("div", { class: "tile-label" }, label),
      el("div", { class: "tile-value" }, fmt(opus)),
      el("div", { class: "tile-compare" }, `Opus · Terra: ${fmt(terra)}`),
      el("span", { class: "tile-factor" }, factor(opus, terra))
    );
  });
  document.querySelector("#pair-tiles").replaceChildren(...tiles);
}

function meter(title, rows) {
  return el(
    "div",
    { class: "meter" },
    el("div", { class: "meter-title" }, title),
    rows.map(({ label, value, display, series }) =>
      el(
        "div",
        { class: "meter-row" },
        el("span", {}, label),
        el("span", { class: "meter-track", role: "img", "aria-label": `${label}: ${display}` }, el("span", { class: `meter-fill ${series}`, style: `width:${Math.max(0, Math.min(1, value)) * 100}%` })),
        el("span", { class: "meter-value" }, display)
      )
    )
  );
}

function renderMeters() {
  const testsPerRule = (items) => sum(items, "tests") / sum(items, "rules");
  const german = (items) => 1 - items.reduce((t, run) => t + run.english_share * run.rules, 0) / sum(items, "rules");
  const pairRows = (getter, formatter = pct) => [
    { label: "Opus 5.5", value: getter(opusRuns), display: formatter(getter(opusRuns)), series: "opus" },
    { label: "Terra", value: getter(terraRuns), display: formatter(getter(terraRuns)), series: "terra" },
  ];
  document.querySelector("#meters").replaceChildren(
    meter("Regeln mit Rego-Symbol", pairRows((items) => share(items, "rules_with_rego"))),
    meter("Regeln mit Eingabepfaden", pairRows((items) => share(items, "rules_with_inputs"))),
    meter("Generierte Tests je Regel", pairRows(testsPerRule, (v) => twoDecimals.format(v))),
    meter("Regeltexte auf Deutsch", pairRows(german))
  );
  document.querySelector("#overlap-meters").replaceChildren(
    meter("Zitierte Quellseiten", [
      { label: "Terra → Opus", value: TOTALS.terraPagesIn / TOTALS.terraPages, display: pct(TOTALS.terraPagesIn / TOTALS.terraPages), series: "opus" },
      { label: "Opus → Terra", value: TOTALS.opusPagesIn / TOTALS.opusPages, display: pct(TOTALS.opusPagesIn / TOTALS.opusPages), series: "terra" },
    ]),
    meter("Wörtliche Belege", [
      { label: "Terra → Opus", value: TOTALS.terraQuotesIn / TOTALS.terraQuotes, display: pct(TOTALS.terraQuotesIn / TOTALS.terraQuotes), series: "opus" },
      { label: "Opus → Terra", value: TOTALS.opusQuotesIn / TOTALS.opusQuotes, display: pct(TOTALS.opusQuotesIn / TOTALS.opusQuotes), series: "terra" },
    ])
  );
}

/* ---------- Charts ---------- */

function niceStep(max, targetTicks = 4) {
  const raw = max / targetTicks;
  const power = 10 ** Math.floor(Math.log10(raw || 1));
  const candidates = [1, 2, 2.5, 5, 10].map((m) => m * power);
  return candidates.find((step) => raw <= step) || candidates[candidates.length - 1];
}

function niceScale(max, targetTicks = 4) {
  const step = niceStep(max, targetTicks);
  const top = Math.max(step, Math.ceil(max / step) * step);
  const ticks = [];
  for (let value = 0; value <= top + step / 2; value += step) ticks.push(value);
  return { top, ticks };
}

function roundedBar(x0, y, width, height, radius = 4) {
  const w = Math.max(0, width);
  const r = Math.min(radius, w, height / 2);
  if (w <= 0) return "";
  return `M${x0},${y}H${x0 + w - r}Q${x0 + w},${y} ${x0 + w},${y + r}V${y + height - r}Q${x0 + w},${y + height} ${x0 + w - r},${y + height}H${x0}Z`;
}

function attachTooltip(card, tooltip, target, build) {
  const show = (clientX, clientY) => {
    tooltip.replaceChildren(...build());
    tooltip.hidden = false;
    const box = card.getBoundingClientRect();
    const tipWidth = tooltip.offsetWidth;
    const tipHeight = tooltip.offsetHeight;
    let left = clientX - box.left + 14;
    let top = clientY - box.top + 14;
    if (left + tipWidth > box.width - 8) left = clientX - box.left - tipWidth - 14;
    if (left < 8) left = 8;
    if (top + tipHeight > box.height - 8) top = clientY - box.top - tipHeight - 14;
    tooltip.style.left = `${left}px`;
    tooltip.style.top = `${Math.max(8, top)}px`;
  };
  const hide = () => {
    tooltip.hidden = true;
  };
  target.addEventListener("pointermove", (event) => show(event.clientX, event.clientY));
  target.addEventListener("pointerleave", hide);
  target.addEventListener("focus", () => {
    const rect = target.getBoundingClientRect();
    show(rect.left + rect.width * 0.55, rect.top + rect.height);
  });
  target.addEventListener("blur", hide);
}

function tooltipRows(title, rows, note) {
  return [
    el("div", { class: "tt-title" }, title),
    ...rows.map(([series, label, value]) => el("div", { class: "tt-row" }, el("span", { class: `tt-key ${series}` }), el("strong", {}, value), el("span", { class: "muted" }, label))),
    note ? el("div", { class: "tt-note" }, note) : null,
  ];
}

const MEASURE_METRICS = [
  ["rules", "Regeln"],
  ["references", "Quellenreferenzen"],
  ["tests", "Tests"],
  ["paths_added", "Profilpfade"],
  ["rego_lines", "Rego-Zeilen"],
  ["data_tables", "Datentabellen"],
];
let measureMetric = "rules";

function renderMeasureMetricButtons() {
  const group = document.querySelector("#measure-metric");
  group.replaceChildren(
    ...MEASURE_METRICS.map(([key, label]) =>
      el(
        "button",
        {
          type: "button",
          "aria-pressed": key === measureMetric ? "true" : "false",
          onclick: () => {
            measureMetric = key;
            renderMeasureMetricButtons();
            renderMeasureChart();
          },
        },
        label
      )
    )
  );
}

function renderMeasureChart() {
  const container = document.querySelector("#measure-chart");
  const card = document.querySelector("#measure-chart-card");
  const tooltip = document.querySelector("#measure-tooltip");
  const metricLabel = MEASURE_METRICS.find(([key]) => key === measureMetric)[1];
  const rows = DATA.pairs.map((pair) => ({
    measure: pair.measure,
    terra: runs[pair.baseline][measureMetric] || 0,
    opus: runs[pair.challenger][measureMetric] || 0,
  }));
  const width = Math.max(300, Math.floor(container.clientWidth));
  const narrow = width < 560;
  const labelWidth = narrow ? 50 : 64;
  const factorWidth = narrow ? 44 : 60;
  const rowHeight = 26;
  const top = 24;
  const height = top + rows.length * rowHeight + 6;
  const { top: max, ticks } = niceScale(Math.max(...rows.map((r) => Math.max(r.terra, r.opus))), narrow ? 3 : 5);
  const plotWidth = width - labelWidth - factorWidth - 12;
  const x = (value) => labelWidth + (value / max) * plotWidth;

  const root = svg("svg", { class: "chart-svg", viewBox: `0 0 ${width} ${height}`, width, height, role: "group", "aria-label": `${metricLabel} je Maßnahme, Opus 5.5 und Terra` });
  for (const tick of ticks) {
    root.append(svg("line", { class: "gridline", x1: x(tick), x2: x(tick), y1: top - 6, y2: height - 4 }));
    root.append(svg("text", { x: x(tick), y: top - 11, "text-anchor": "middle" }, fmt(tick)));
  }
  root.append(svg("text", { x: width, y: top - 11, "text-anchor": "end" }, "Faktor"));
  rows.forEach((row, index) => {
    const cy = top + index * rowHeight + rowHeight / 2;
    const ratio = row.terra ? row.opus / row.terra : null;
    const group = svg("g", { class: "row", tabindex: "0", role: "img", "aria-label": `${row.measure} ${measureTitle[row.measure] || ""}: Opus ${fmt(row.opus)}, Terra ${fmt(row.terra)}` });
    group.append(
      svg("rect", { class: "hit", x: 0, y: cy - rowHeight / 2 + 1, width, height: rowHeight - 2, rx: 6 }),
      svg("text", { class: "row-label", x: 4, y: cy + 4 }, row.measure),
      svg("line", { class: "track-line", x1: x(Math.min(row.terra, row.opus)), x2: x(Math.max(row.terra, row.opus)), y1: cy, y2: cy }),
      svg("circle", { class: "dot terra", cx: x(row.terra), cy, r: 5 }),
      svg("circle", { class: "dot opus", cx: x(row.opus), cy, r: 5 }),
      svg("text", { class: "value-label", x: width - 2, y: cy + 4, "text-anchor": "end" }, ratio == null ? "–" : `×${decimalFormat.format(ratio)}`)
    );
    attachTooltip(card, tooltip, group, () =>
      tooltipRows(`${row.measure} · ${measureTitle[row.measure] || ""}`, [["opus", "Opus 5.5", fmt(row.opus)], ["terra", "Terra", fmt(row.terra)]], ratio == null ? null : `${metricLabel}: Opus ${factor(row.opus, row.terra)}`)
    );
    root.append(group);
  });
  container.replaceChildren(root);
  document.querySelector("#measure-chart-title").textContent = `${metricLabel} je Maßnahme`;
}

function renderMeasureTable() {
  const rows = DATA.pairs.map((pair) => ({ pair, terra: runs[pair.baseline], opus: runs[pair.challenger] }));
  const columns = [
    { label: "Maßnahme", render: (r) => el("span", { class: "measure", title: measureTitle[r.pair.measure] }, r.pair.measure) },
    { label: "Regeln Opus/Terra", num: true, render: (r) => `${fmt(r.opus.rules)} / ${fmt(r.terra.rules)}` },
    { label: "Referenzen Opus/Terra", num: true, render: (r) => `${fmt(r.opus.references)} / ${fmt(r.terra.references)}` },
    { label: "Tests Opus/Terra", num: true, render: (r) => `${fmt(r.opus.tests)} / ${fmt(r.terra.tests)}` },
    { label: "Pfade Opus/Terra", num: true, render: (r) => `${fmt(r.opus.paths_added)} / ${fmt(r.terra.paths_added)}` },
    { label: "Rego-Zeilen Opus/Terra", num: true, render: (r) => `${fmt(r.opus.rego_lines)} / ${fmt(r.terra.rego_lines)}` },
    { label: "Terra-Seiten bei Opus", num: true, render: (r) => pct(r.pair.baseline_pages_in_challenger) },
    { label: "Terra-Belege bei Opus", num: true, render: (r) => pct(r.pair.baseline_in_challenger) },
  ];
  document.querySelector("#measure-table").replaceChildren(table(columns, rows, "Keine Paare vorhanden."));
}

function renderCategoryChart() {
  const container = document.querySelector("#category-chart");
  const card = document.querySelector("#category-chart-card");
  const tooltip = document.querySelector("#category-tooltip");
  const opusTotal = sum(opusRuns, "rules");
  const terraTotal = sum(terraRuns, "rules");
  const rows = DATA.rule_categories.map((category) => ({
    ...category,
    opus: opusRuns.reduce((t, run) => t + (run.categories[category.id] || 0), 0),
    terra: terraRuns.reduce((t, run) => t + (run.categories[category.id] || 0), 0),
  }));
  const width = Math.max(300, Math.floor(container.clientWidth));
  const narrow = width < 560;
  const valueRoom = 56;
  const barHeight = 10;
  const gap = 2;
  const block = 18 + barHeight * 2 + gap + 14;
  const height = rows.length * block;
  const max = Math.max(...rows.map((r) => Math.max(r.opus, r.terra)));
  const plotWidth = width - valueRoom;
  const w = (value) => (value / max) * plotWidth;
  const root = svg("svg", { class: "chart-svg", viewBox: `0 0 ${width} ${height}`, width, height, role: "group", "aria-label": "Regeln nach Kategorie, Opus 5.5 und Terra" });
  rows.forEach((row, index) => {
    const y0 = index * block;
    const hasPhase = row.phase && row.phase !== "-";
    const title = !hasPhase ? row.label : narrow ? `${row.phase} · ${row.label}` : `${row.label} · Phase ${row.phase}`;
    const group = svg("g", { class: "row", tabindex: "0", role: "img", "aria-label": `${row.label}: Opus ${fmt(row.opus)}, Terra ${fmt(row.terra)}` });
    const yOpus = y0 + 22;
    const yTerra = yOpus + barHeight + gap;
    group.append(
      svg("rect", { class: "hit", x: 0, y: y0 + 2, width, height: block - 6, rx: 6 }),
      svg("text", { class: "row-label", x: 0, y: y0 + 14 }, title),
      svg("line", { class: "baseline", x1: 0.5, x2: 0.5, y1: yOpus - 2, y2: yTerra + barHeight + 2 }),
      svg("path", { class: "bar opus", d: roundedBar(1, yOpus, w(row.opus), barHeight) }),
      svg("path", { class: "bar terra", d: roundedBar(1, yTerra, w(row.terra), barHeight) }),
      svg("text", { class: "value-label", x: w(row.opus) + 6, y: yOpus + barHeight - 1 }, fmt(row.opus)),
      svg("text", { class: "value-label", x: w(row.terra) + 6, y: yTerra + barHeight - 1 }, fmt(row.terra))
    );
    attachTooltip(card, tooltip, group, () =>
      tooltipRows(row.label, [["opus", `Opus 5.5 · ${pct(row.opus / opusTotal)} der Regeln`, fmt(row.opus)], ["terra", `Terra · ${pct(row.terra / terraTotal)} der Regeln`, fmt(row.terra)]], `Opus ${factor(row.opus, row.terra)}`)
    );
    root.append(group);
  });
  container.replaceChildren(root);
}

function renderSourceMix() {
  const totals = (items) => {
    const counts = {};
    for (const run of items) for (const [kind, value] of Object.entries(run.citations_by_source)) counts[kind] = (counts[kind] || 0) + value;
    return counts;
  };
  const opus = totals(opusRuns);
  const terra = totals(terraRuns);
  const opusSum = Object.values(opus).reduce((a, b) => a + b, 0) || 1;
  const terraSum = Object.values(terra).reduce((a, b) => a + b, 0) || 1;
  const kinds = DATA.source_kinds.filter((kind) => (opus[kind] || 0) + (terra[kind] || 0) > 0);
  const columns = [
    { label: "Quelle", render: (kind) => SOURCE_LABELS[kind] || kind, wide: true },
    {
      label: "Anteil Opus · Terra",
      wide: true,
      render: (kind) =>
        el(
          "div",
          { class: "mini-bars" },
          [
            ["opus", (opus[kind] || 0) / opusSum, opus[kind] || 0],
            ["terra", (terra[kind] || 0) / terraSum, terra[kind] || 0],
          ].map(([series, value, count]) =>
            el("div", { class: "mini-bar", title: `${series === "opus" ? "Opus" : "Terra"}: ${fmt(count)} Referenzen` }, el("span", { class: "mini-track" }, el("span", { class: `mini-fill ${series}`, style: `width:${value * 100}%` })), el("span", {}, pct(value)))
          )
        ),
    },
  ];
  document.querySelector("#source-mix").replaceChildren(el("div", { class: "table-wrap stack-table source-mix-table" }, table(columns, kinds, "Keine Referenzen.")));
}

/* ---------- Variables ---------- */

const conceptStats = (() => {
  const stats = {};
  for (const concept of [...DATA.concepts, { id: "other" }]) {
    stats[concept.id] = { measures: {}, paths: {} };
  }
  for (const [runIndex, , , conceptId] of DATA.proposals) {
    const run = runs[runIndex];
    const entry = stats[conceptId] || (stats[conceptId] = { measures: {}, paths: {} });
    (entry.measures[run.model] ||= new Set()).add(run.measure);
    entry.paths[run.model] = (entry.paths[run.model] || 0) + 1;
  }
  return stats;
})();

const measureCount = (conceptId, model) => conceptStats[conceptId]?.measures[model]?.size || 0;
const pathCount = (conceptId, model) => conceptStats[conceptId]?.paths[model] || 0;
const totalMeasures = DATA.measures.length;

function initConceptFilters() {
  optionList(document.querySelector("#concept-class"), [["all", "Alle Klassen"], ...Object.entries(CLASS_LABELS).map(([k, v]) => [k, `${k} · ${v}`])]);
  optionList(document.querySelector("#concept-ama"), [["all", "AMA: alle"], ["ja", "AMA: ja"], ["teilweise", "AMA: teilweise"], ["nein", "AMA: nein"]]);
  const groups = [...new Set(DATA.concepts.map((c) => c.group))];
  optionList(document.querySelector("#concept-group"), [["all", "Alle Gruppen"], ...groups.map((g) => [g, g])]);
  for (const id of ["#concept-class", "#concept-ama", "#concept-group"]) document.querySelector(id).addEventListener("change", renderConceptTable);
}

function renderConceptTable() {
  const cls = document.querySelector("#concept-class").value;
  const ama = document.querySelector("#concept-ama").value;
  const group = document.querySelector("#concept-group").value;
  const rows = DATA.concepts
    .filter((c) => (cls === "all" || c.class === cls) && (ama === "all" || c.ama.status === ama) && (group === "all" || c.group === group))
    .sort((a, b) => measureCount(b.id, OPUS) + measureCount(b.id, TERRA) - (measureCount(a.id, OPUS) + measureCount(a.id, TERRA)));
  const columns = [
    { label: "Konzept", wide: true, render: (c) => el("div", {}, el("strong", {}, c.label), el("div", { class: "type" }, c.id)) },
    { label: "Gruppe", render: (c) => c.group },
    { label: "Klasse", render: (c) => classTag(c.class) },
    {
      label: "Maßnahmen mit Bedarf",
      render: (c) =>
        el(
          "div",
          { class: "mini-bars" },
          [
            ["opus", measureCount(c.id, OPUS)],
            ["terra", measureCount(c.id, TERRA)],
          ].map(([series, count]) => el("div", { class: "mini-bar", title: `${series === "opus" ? "Opus" : "Terra"}: ${count} von ${totalMeasures} Maßnahmen` }, el("span", { class: "mini-track" }, el("span", { class: `mini-fill ${series}`, style: `width:${(count / totalMeasures) * 100}%` })), el("span", {}, `${count}`)))
        ),
    },
    { label: "Pfade Opus/Terra", num: true, render: (c) => `${fmt(pathCount(c.id, OPUS))} / ${fmt(pathCount(c.id, TERRA))}` },
    { label: "AMA", wide: true, render: (c) => el("div", {}, amaBadge(c.ama.status), c.ama.source ? el("div", { class: "small muted ama-detail" }, c.ama.source) : null, c.ama.note ? el("div", { class: "small muted" }, c.ama.note) : null) },
  ];
  document.querySelector("#concept-table").replaceChildren(table(columns, rows, "Kein Konzept für diesen Filter."));
}

let pathPage = 0;
const PATH_PAGE_SIZE = 50;

function initPathFilters() {
  optionList(document.querySelector("#path-model"), [["all", "Alle Modelle"], ...DATA.models.map((m) => [m.id, m.label])]);
  optionList(document.querySelector("#path-measure"), [["all", "Alle Maßnahmen"], ...DATA.measures.map((m) => [m.id, `${m.id} · ${m.title}`])]);
  optionList(document.querySelector("#path-concept"), [["all", "Alle Konzepte"], ...DATA.concepts.map((c) => [c.id, c.label]), ["other", "Nicht zugeordnet"]]);
  for (const id of ["#path-model", "#path-measure", "#path-concept"]) {
    document.querySelector(id).addEventListener("change", () => {
      pathPage = 0;
      renderPathTable();
    });
  }
  document.querySelector("#path-query").addEventListener("input", () => {
    pathPage = 0;
    renderPathTable();
  });
}

function renderPathTable() {
  const model = document.querySelector("#path-model").value;
  const measure = document.querySelector("#path-measure").value;
  const concept = document.querySelector("#path-concept").value;
  const query = document.querySelector("#path-query").value.trim().toLowerCase();
  const rows = DATA.proposals.filter(([runIndex, path, , conceptId]) => {
    const run = runs[runIndex];
    return (model === "all" || run.model === model) && (measure === "all" || run.measure === measure) && (concept === "all" || conceptId === concept) && (!query || path.toLowerCase().includes(query));
  });
  const pages = Math.max(1, Math.ceil(rows.length / PATH_PAGE_SIZE));
  pathPage = Math.min(pathPage, pages - 1);
  const visible = rows.slice(pathPage * PATH_PAGE_SIZE, (pathPage + 1) * PATH_PAGE_SIZE);
  const columns = [
    { label: "Pfad", wide: true, cellClass: "path", render: ([, path, , , kind]) => (kind === "changed" ? `${path} (geändert)` : path) },
    { label: "Typ", wide: true, cellClass: "type", render: ([, , type]) => type },
    { label: "Konzept", render: ([, , , conceptId]) => conceptById[conceptId]?.label || "Nicht zugeordnet" },
    { label: "Maßnahme", render: ([runIndex]) => el("span", { class: "measure" }, runs[runIndex].measure) },
    { label: "Modell", render: ([runIndex]) => modelTag(runs[runIndex].model) },
    { label: "AMA", render: ([, , , conceptId]) => (conceptById[conceptId] ? amaBadge(conceptById[conceptId].ama.status) : "–") },
  ];
  document.querySelector("#path-table").replaceChildren(table(columns, visible, "Keine Pfade für diesen Filter."));
  document.querySelector("#path-state").textContent = `${fmt(rows.length)} von ${fmt(DATA.proposals.length)} Pfaden`;
  const pager = document.querySelector("#path-pager");
  pager.replaceChildren(
    el("button", { type: "button", disabled: pathPage === 0, onclick: () => { pathPage -= 1; renderPathTable(); } }, "Zurück"),
    el("span", {}, `Seite ${fmt(pathPage + 1)} von ${fmt(pages)}`),
    el("button", { type: "button", disabled: pathPage >= pages - 1, onclick: () => { pathPage += 1; renderPathTable(); } }, "Weiter")
  );
}

/* ---------- AMA matrix ---------- */

function renderAmaMatrix() {
  const statuses = ["ja", "teilweise", "nein"];
  const classes = ["A", "B", "C"];
  const head = el("thead", {}, el("tr", {}, el("th", { scope: "col" }, "Klasse"), statuses.map((s) => el("th", { scope: "col" }, amaBadge(s)))));
  const body = el(
    "tbody",
    {},
    classes.map((cls) =>
      el(
        "tr",
        {},
        el("td", { class: "row-head", title: CLASS_LABELS[cls] }, el("strong", {}, cls), el("span", {}, CLASS_SHORT[cls])),
        statuses.map((status) => {
          const concepts = DATA.concepts.filter((c) => c.class === cls && c.ama.status === status);
          const need = concepts.reduce((t, c) => t + measureCount(c.id, OPUS), 0);
          return el("td", { title: concepts.map((c) => c.label).join("\n") }, el("strong", {}, fmt(concepts.length)), el("span", {}, `${fmt(need)} Bedarfe`));
        })
      )
    )
  );
  document.querySelector("#ama-matrix").replaceChildren(el("div", { class: "matrix-wrap" }, el("table", { class: "matrix" }, head, body)));
}

/* ---------- Open items ---------- */

function renderOpenItems() {
  const items = DATA.unresolved.map(([runIndex, source, locator, reason]) => ({ run: runs[runIndex], source, locator, reason }));
  const byModel = (model) => items.filter((item) => item.run.model === model).length;
  document.querySelector("#open-caption").textContent = `${fmt(items.length)} als „unresolved“ markierte Coverage-Einträge (Opus ${fmt(byModel(OPUS))}, Terra ${fmt(byModel(TERRA))}).`;
  document.querySelector("#open-list").replaceChildren(
    ...items.map((item) =>
      el(
        "li",
        {},
        el("div", { class: "issue-head" }, el("span", { class: "measure" }, item.run.measure), modelTag(item.run.model), el("span", { class: "issue-source" }, `${item.source} · ${item.locator}`)),
        el("p", {}, item.reason)
      )
    )
  );
}

/* ---------- Catalog ---------- */

function initCatalog() {
  optionList(document.querySelector("#model-filter"), [["all", "Alle Modelle"], ...DATA.models.map((m) => [m.id, m.label])]);
  document.querySelector("#model-filter").addEventListener("change", renderCatalog);
  document.querySelector("#query").addEventListener("input", renderCatalog);
}

function renderCatalog() {
  const selected = document.querySelector("#model-filter").value;
  const text = document.querySelector("#query").value.trim().toLowerCase();
  const items = runs.filter((run) => (selected === "all" || run.model === selected) && `${run.measure} ${measureTitle[run.measure] || ""} ${run.sheet || ""} ${labelFor(run.model)}`.toLowerCase().includes(text));
  document.querySelector("#filter-state").textContent = `${fmt(items.length)} von ${fmt(runs.length)} Runs sichtbar`;
  const columns = [
    { label: "Maßnahme", render: (run) => el("div", {}, el("span", { class: "measure" }, run.measure), el("div", { class: "small muted" }, measureTitle[run.measure] || "")), wide: true },
    { label: "Modell", render: (run) => modelTag(run.model) },
    { label: "Blatt", render: (run) => el("span", { class: "source-sheet", title: run.sheet || "" }, run.sheet_version || "–") },
    { label: "Regeln", num: true, render: (run) => fmt(run.rules) },
    { label: "Referenzen", num: true, render: (run) => fmt(run.references) },
    { label: "Coverage", num: true, render: (run) => fmt(run.coverage) },
    { label: "Tests", num: true, render: (run) => fmt(run.tests) },
    { label: "Vorschläge", num: true, render: (run) => el("a", { href: blobLink(run, "workspace/rules/profile_changes.json"), target: "_blank", rel: "noreferrer" }, fmt(run.proposals)) },
    { label: "Versuche", num: true, render: (run) => fmt(run.generation.attempts) },
    { label: "Kosten (USD)", num: true, render: (run) => (run.generation.cost_usd == null ? "–" : decimalFormat.format(run.generation.cost_usd)) },
    { label: "Gates", render: (run) => el("span", { class: "gate" }, run.grounding_valid && run.validation_exit_code === 0 ? "gültig" : "prüfen") },
    { label: "Artefakt", render: (run) => el("a", { class: "artifact", href: runLink(run), target: "_blank", rel: "noreferrer" }, "Run ↗") },
  ];
  document.querySelector("#run-table").replaceChildren(table(columns, items, "Keine finalisierten Runs für diesen Filter."));
}

function renderHistory() {
  const history = DATA.history || [];
  const byId = Object.fromEntries(runs.map((run) => [run.run_id, run]));
  document.querySelector("#history-caption").textContent = history.length
    ? `${fmt(history.length)} frühere Runs wurden durch einen neueren Run derselben Maßnahme und desselben Modells ersetzt (z. B. Rerun mit aktualisiertem Quellenpack). Sie zählen in keiner Kennzahl dieser Seite mit.`
    : "Keine ersetzten Runs.";
  const columns = [
    { label: "Maßnahme", render: (item) => el("div", {}, el("span", { class: "measure" }, item.measure), el("div", { class: "small muted" }, measureTitle[item.measure] || "")), wide: true },
    { label: "Modell", render: (item) => modelTag(item.model) },
    { label: "Ersetzter Run", render: (item) => el("a", { class: "artifact", href: runLink(item), target: "_blank", rel: "noreferrer" }, item.run_id) },
    { label: "Regeln", num: true, render: (item) => `${fmt(item.rules)} → ${fmt(byId[item.superseded_by]?.rules)}` },
    { label: "Referenzen", num: true, render: (item) => `${fmt(item.references)} → ${fmt(byId[item.superseded_by]?.references)}` },
    { label: "Offen", num: true, render: (item) => `${fmt(item.unresolved)} → ${fmt(openCount(item.superseded_by))}` },
    { label: "Ersetzt durch", render: (item) => el("a", { class: "artifact", href: runLink(byId[item.superseded_by] || { run_id: item.superseded_by }), target: "_blank", rel: "noreferrer" }, item.superseded_by) },
  ];
  document.querySelector("#history-table").replaceChildren(table(columns, history, "Keine ersetzten Runs."));
}

function openCount(runId) {
  const index = runs.findIndex((run) => run.run_id === runId);
  return DATA.unresolved.filter(([runIndex]) => runIndex === index).length;
}

/* ---------- Boot ---------- */

function renderCharts() {
  renderMeasureChart();
  renderCategoryChart();
}

let lastWidth = 0;
function onResize() {
  const width = document.querySelector("#measure-chart").clientWidth;
  if (Math.abs(width - lastWidth) < 8) return;
  lastWidth = width;
  renderCharts();
}

renderSnapshot();
renderKpis();
renderModelCards();
fillFacts();
renderPairTiles();
renderMeters();
renderMeasureMetricButtons();
renderMeasureTable();
renderSourceMix();
initConceptFilters();
renderConceptTable();
initPathFilters();
renderPathTable();
renderAmaMatrix();
renderOpenItems();
initCatalog();
renderCatalog();
renderHistory();
renderCharts();
lastWidth = document.querySelector("#measure-chart").clientWidth;
let resizeTimer = null;
window.addEventListener("resize", () => {
  clearTimeout(resizeTimer);
  resizeTimer = setTimeout(onResize, 120);
});
