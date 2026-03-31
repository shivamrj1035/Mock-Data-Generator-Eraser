export const htmlPage = `<!doctype html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Mock Data Generator</title>
  <style>
    :root {
      --bg: #f4efe6;
      --surface: rgba(255, 251, 245, 0.9);
      --surface-strong: #fffaf2;
      --ink: #1d2430;
      --muted: #667085;
      --line: #d8ccb6;
      --accent: #0f766e;
      --accent-soft: rgba(15, 118, 110, 0.12);
      --warn: #b45309;
      --shadow: 0 22px 60px rgba(64, 44, 12, 0.08);
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      font-family: Georgia, "Times New Roman", serif;
      color: var(--ink);
      background:
        radial-gradient(circle at 0% 0%, rgba(180, 83, 9, 0.14), transparent 26%),
        radial-gradient(circle at 100% 0%, rgba(15, 118, 110, 0.18), transparent 24%),
        linear-gradient(180deg, #faf6ef 0%, var(--bg) 100%);
      min-height: 100vh;
    }
    .shell {
      max-width: 1320px;
      margin: 0 auto;
      padding: 28px 18px 44px;
    }
    .hero {
      display: grid;
      grid-template-columns: 1.2fr 0.8fr;
      gap: 22px;
      margin-bottom: 22px;
    }
    .panel {
      background: var(--surface);
      border: 1px solid var(--line);
      border-radius: 24px;
      box-shadow: var(--shadow);
      backdrop-filter: blur(12px);
    }
    .hero-main, .hero-side, .form-panel, .table-panel {
      padding: 24px;
    }
    h1 {
      margin: 0 0 10px;
      font-size: clamp(2.4rem, 5vw, 4.8rem);
      line-height: 0.92;
      letter-spacing: -0.05em;
    }
    h2, h3 {
      margin: 0;
      font-size: 1.2rem;
    }
    p { margin: 0; line-height: 1.55; }
    .subtle { color: var(--muted); }
    .hero-side {
      display: grid;
      gap: 18px;
      align-content: space-between;
      background: linear-gradient(135deg, rgba(15, 118, 110, 0.08), rgba(180, 83, 9, 0.08));
    }
    .chips {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      margin-top: 16px;
    }
    .chip {
      border-radius: 999px;
      padding: 8px 12px;
      border: 1px solid var(--line);
      background: rgba(255,255,255,0.7);
      font-size: 0.92rem;
    }
    .workspace {
      display: grid;
      grid-template-columns: minmax(0, 1.2fr) minmax(340px, 0.8fr);
      gap: 22px;
      align-items: start;
    }
    .stack { display: grid; gap: 18px; }
    .section {
      padding: 20px;
      border: 1px solid var(--line);
      border-radius: 20px;
      background: rgba(255,255,255,0.52);
    }
    .section-head {
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 12px;
      margin-bottom: 14px;
    }
    .section-head small { color: var(--muted); }
    .row-2, .row-3 {
      display: grid;
      gap: 14px;
    }
    .row-2 { grid-template-columns: repeat(2, 1fr); }
    .row-3 { grid-template-columns: repeat(3, 1fr); }
    label {
      display: block;
      font-size: 0.94rem;
    }
    .label-text {
      display: block;
      margin-bottom: 7px;
      color: var(--muted);
    }
    input, select, textarea, button {
      width: 100%;
      border-radius: 14px;
      border: 1px solid var(--line);
      background: rgba(255,255,255,0.92);
      color: var(--ink);
      font: inherit;
      padding: 12px 14px;
    }
    textarea {
      min-height: 420px;
      resize: vertical;
      font-family: "Courier New", monospace;
      font-size: 0.92rem;
      line-height: 1.46;
    }
    button {
      cursor: pointer;
      width: auto;
      min-width: 160px;
    }
    .action-row {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
      margin-top: 18px;
    }
    .primary {
      background: var(--accent);
      color: white;
      border-color: var(--accent);
    }
    .secondary {
      background: transparent;
      color: var(--warn);
      border-color: var(--warn);
    }
    .table-panel {
      position: sticky;
      top: 18px;
      display: grid;
      gap: 18px;
    }
    .table-list {
      display: grid;
      gap: 12px;
      max-height: 620px;
      overflow: auto;
      padding-right: 4px;
    }
    .table-card {
      border: 1px solid var(--line);
      border-radius: 18px;
      background: rgba(255,255,255,0.64);
      overflow: hidden;
    }
    .table-top {
      padding: 14px 16px;
      display: grid;
      gap: 12px;
      border-bottom: 1px solid rgba(216, 204, 182, 0.7);
    }
    .table-head {
      display: flex;
      justify-content: space-between;
      gap: 12px;
      align-items: start;
    }
    .count-input {
      width: 96px;
      text-align: center;
      font-weight: 600;
    }
    details { padding: 0 16px 14px; }
    summary {
      cursor: pointer;
      padding: 12px 0;
      color: var(--accent);
      font-weight: 600;
    }
    .override-grid {
      display: grid;
      gap: 10px;
    }
    .override-row {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 10px;
      align-items: center;
    }
    .override-row code {
      color: var(--muted);
      font-size: 0.92rem;
    }
    .status {
      display: none;
      padding: 12px 14px;
      border-radius: 14px;
      background: var(--accent-soft);
      color: #115e59;
    }
    .status.error {
      background: rgba(185, 28, 28, 0.08);
      color: #991b1b;
    }
    .downloads {
      border: 1px solid var(--line);
      border-radius: 18px;
      padding: 16px;
      background: rgba(255,255,255,0.6);
    }
    .link-row {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-top: 12px;
    }
    .link-row a {
      text-decoration: none;
      border-radius: 999px;
      padding: 10px 14px;
      border: 1px solid var(--line);
      color: var(--accent);
      background: rgba(255,255,255,0.86);
    }
    .helper {
      margin-top: 10px;
      font-size: 0.9rem;
      color: var(--muted);
    }
    @media (max-width: 980px) {
      .hero, .workspace, .row-2, .row-3, .override-row { grid-template-columns: 1fr; }
      .table-panel { position: static; }
      textarea { min-height: 300px; }
    }
  </style>
</head>
<body>
  <div class="shell">
    <section class="hero">
      <div class="panel hero-main">
        <h1>Mock Data Generator</h1>
        <p class="subtle">Paste Eraser schema, choose locale and row controls, add optional column-level fixed values, and generate Excel + SQL from one structured page.</p>
        <div class="chips">
          <span class="chip">Structured UI</span>
          <span class="chip">Per-Table Counts</span>
          <span class="chip">Per-Column Fixed Values</span>
          <span class="chip">India / US / Global</span>
        </div>
      </div>
      <div class="panel hero-side">
        <div>
          <h3>Column override example</h3>
          <p class="subtle">Open the <strong>Column Overrides</strong> section for <code>members</code> and set <code>last_name</code> to <code>Jayswal</code>. Every generated member row will use that last name.</p>
        </div>
        <p class="subtle">Email generation now uses <code>first_name</code>, <code>last_name</code>, and <code>dob</code> when those fields exist in the same table.</p>
      </div>
    </section>

    <section class="workspace">
      <div class="panel form-panel">
        <div class="stack">
          <section class="section">
            <div class="section-head">
              <h2>Project Setup</h2>
              <small>Core generation settings</small>
            </div>
            <div class="row-2">
              <label>
                <span class="label-text">Project Name</span>
                <input id="projectName" value="family-demo" />
              </label>
              <label>
                <span class="label-text">Default Rows Per Table</span>
                <input id="defaultRows" type="number" min="0" max="500" value="20" />
              </label>
            </div>
            <div class="row-2">
              <label>
                <span class="label-text">Locale Profile</span>
                <select id="localeProfile">
                  <option value="global">Global</option>
                  <option value="india">India</option>
                  <option value="us">US</option>
                </select>
              </label>
              <label>
                <span class="label-text">Region / State</span>
                <input id="region" placeholder="Gujarat, Maharashtra, Texas" />
              </label>
            </div>
          </section>

          <section class="section">
            <div class="section-head">
              <h2>Schema Input</h2>
              <small>Paste Eraser code here</small>
            </div>
            <label>
              <span class="label-text">Eraser Schema</span>
              <textarea id="schema"></textarea>
            </label>
            <div class="helper">Use <code>Inspect Tables</code> first to build row-count and column-override controls from your schema.</div>
            <div class="action-row">
              <button class="secondary" id="inspectBtn" type="button">Inspect Tables</button>
              <button class="primary" id="generateBtn" type="button">Generate Files</button>
            </div>
            <div class="status" id="status"></div>
          </section>
        </div>
      </div>

      <aside class="panel table-panel">
        <section>
          <div class="section-head">
            <h2>Table Controls</h2>
            <small>Counts and fixed values</small>
          </div>
          <div id="tableList" class="table-list"></div>
        </section>

        <section class="downloads">
          <div class="section-head" style="margin-bottom:10px">
            <h2>Downloads</h2>
            <small>Generated files</small>
          </div>
          <div id="resultSummary" class="subtle">No generation yet.</div>
          <div id="resultLinks" class="link-row"></div>
        </section>
      </aside>
    </section>
  </div>

  <script>
    const schemaEl = document.getElementById("schema");
    const tableList = document.getElementById("tableList");
    const statusEl = document.getElementById("status");
    const resultLinks = document.getElementById("resultLinks");
    const resultSummary = document.getElementById("resultSummary");

    const defaultSchema = \`users [icon: user, color: blue] {
  id uuid pk
  email string unique
  phone string
  password_hash string
  status string
  created_at timestamp
}

members [icon: users, color: green] {
  id uuid pk
  first_name string
  last_name string
  gender string
  dob date
  is_alive boolean
  created_by_user_id uuid
  is_claimed boolean
  primary_kutumb_id uuid
  created_at timestamp
}

kutumb [icon: home, color: purple] {
  id uuid pk
  name string
  origin_place string
  description string
  created_at timestamp
}

users.id < members.created_by_user_id
kutumb.id < members.primary_kutumb_id\`;

    schemaEl.value = defaultSchema;

    function setStatus(message, isError = false) {
      statusEl.style.display = message ? "block" : "none";
      statusEl.textContent = message;
      statusEl.className = isError ? "status error" : "status";
    }

    function renderTables(tables) {
      tableList.innerHTML = "";
      if (!tables.length) {
        tableList.innerHTML = '<div class="subtle">No tables loaded yet.</div>';
        return;
      }

      for (const table of tables) {
        const columnRows = table.columns.map((column) => \`
          <label class="override-row">
            <code>\${column.name} : \${column.type}</code>
            <input data-override-table="\${table.name}" data-override-column="\${column.name}" placeholder="Leave empty for generated value" />
          </label>
        \`).join("");

        const node = document.createElement("article");
        node.className = "table-card";
        node.innerHTML = \`
          <div class="table-top">
            <div class="table-head">
              <div>
                <strong>\${table.name}</strong><br />
                <span class="subtle">\${table.columns.length} columns</span>
              </div>
              <input class="count-input" type="number" min="0" max="500" placeholder="default" data-table-count="\${table.name}" />
            </div>
          </div>
          <details>
            <summary>Column Overrides</summary>
            <div class="override-grid">\${columnRows}</div>
          </details>
        \`;
        tableList.appendChild(node);
      }
    }

    function collectTableCounts() {
      const counts = {};
      for (const input of document.querySelectorAll("[data-table-count]")) {
        const value = input.value.trim();
        if (!value) continue;
        counts[input.dataset.tableCount] = Number(value);
      }
      return counts;
    }

    function collectColumnOverrides() {
      const overrides = {};
      for (const input of document.querySelectorAll("[data-override-table]")) {
        const value = input.value.trim();
        if (!value) continue;
        const table = input.dataset.overrideTable;
        const column = input.dataset.overrideColumn;
        if (!overrides[table]) overrides[table] = {};
        overrides[table][column] = value;
      }
      return overrides;
    }

    async function inspectSchema() {
      setStatus("Inspecting schema...");
      resultLinks.innerHTML = "";
      const response = await fetch("/inspect-schema", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ schema: schemaEl.value })
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error?.formErrors?.join(", ") || "Failed to inspect schema.");
      renderTables(data.tables);
      setStatus(\`Loaded \${data.tables.length} tables. You can now set row counts or fixed column values.\`);
    }

    async function generateFiles() {
      setStatus("Generating workbook and SQL...");
      resultLinks.innerHTML = "";

      const payload = {
        schema: schemaEl.value,
        projectName: document.getElementById("projectName").value.trim(),
        defaultRowsPerTable: Number(document.getElementById("defaultRows").value),
        localeProfile: document.getElementById("localeProfile").value,
        region: document.getElementById("region").value.trim() || undefined,
        tableCounts: collectTableCounts(),
        columnOverrides: collectColumnOverrides(),
        outputDir: "output"
      };

      const response = await fetch("/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload)
      });
      const data = await response.json();
      if (!response.ok) throw new Error(data.error?.formErrors?.join(", ") || "Generation failed.");

      resultSummary.textContent = \`Generated \${data.tables.length} tables in \${data.projectDir}\`;
      resultLinks.innerHTML = \`
        <a href="\${data.workbookDownload}" target="_blank" rel="noreferrer">Download Excel</a>
        <a href="\${data.sqlDownload}" target="_blank" rel="noreferrer">Download SQL</a>
      \`;
      setStatus("Generation completed.");
    }

    document.getElementById("inspectBtn").addEventListener("click", () => {
      inspectSchema().catch((error) => setStatus(error.message, true));
    });

    document.getElementById("generateBtn").addEventListener("click", () => {
      generateFiles().catch((error) => setStatus(error.message, true));
    });

    inspectSchema().catch((error) => setStatus(error.message, true));
  </script>
</body>
</html>`;
