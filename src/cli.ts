import { readFile } from "node:fs/promises";
import path from "node:path";
import { stdin as input, stdout as output } from "node:process";
import { Command } from "commander";
import { createInterface } from "node:readline/promises";
import { z } from "zod";
import { generateProject } from "./project.js";
import type { GeneratorOptions, LocaleProfile } from "./types.js";

const DEFAULT_ROWS_PER_TABLE = 20;
const MAX_ROWS_PER_TABLE = 500;

const argsSchema = z.object({
  schemaFile: z.string().min(1),
  projectName: z.string().min(1),
  outputDir: z.string().min(1),
  rows: z.number().int().min(0).max(MAX_ROWS_PER_TABLE),
  tableRows: z.array(z.string()),
  localeProfile: z.enum(["global", "india", "us"]),
  region: z.string().optional(),
});

function parseTableRows(entries: string[]): Record<string, number> {
  const counts: Record<string, number> = {};

  for (const entry of entries) {
    const [table, rawCount] = entry.split("=");
    if (!table || !rawCount) {
      throw new Error(`Invalid --table-row value "${entry}". Expected table=count.`);
    }

    const parsedCount = Number(rawCount);
    if (!Number.isFinite(parsedCount) || parsedCount < 0 || parsedCount > MAX_ROWS_PER_TABLE) {
      throw new Error(`Invalid row count for table "${table}". Use 0-${MAX_ROWS_PER_TABLE}.`);
    }

    counts[table] = Math.floor(parsedCount);
  }

  return counts;
}

async function promptIfMissing(options: {
  schemaFile?: string;
  projectName?: string;
  rows?: number;
}): Promise<{ schemaFile: string; projectName: string; rows: number }> {
  const rl = createInterface({ input, output });

  try {
    const schemaFile = options.schemaFile?.trim() || (await rl.question("Schema file path: ")).trim();
    const projectName = options.projectName?.trim() || (await rl.question("Project name: ")).trim();
    const rowsInput = options.rows ?? Number((await rl.question(`Default rows per table (${DEFAULT_ROWS_PER_TABLE}): `)).trim() || DEFAULT_ROWS_PER_TABLE);

    return {
      schemaFile,
      projectName,
      rows: rowsInput,
    };
  } finally {
    rl.close();
  }
}

async function main(): Promise<void> {
  const program = new Command();

  program
    .name("mock-data-generator")
    .description("Generate mock relational data, Excel workbooks, and SQL from Eraser schema text.")
    .option("-s, --schema-file <path>", "Path to the Eraser schema file")
    .option("-p, --project-name <name>", "Project name for the output folder")
    .option("-o, --output-dir <path>", "Output directory", path.resolve(process.cwd(), "output"))
    .option("-r, --rows <count>", "Default rows per table", String(DEFAULT_ROWS_PER_TABLE))
    .option("-l, --locale <profile>", "Locale profile: global, india, us", "global")
    .option("--region <name>", "Optional region or state name")
    .option("-t, --table-row <table=count>", "Specific row count override per table", (value, previous: string[]) => [...previous, value], []);

  program.parse(process.argv);
  const rawOptions = program.opts();
  const prompted = await promptIfMissing({
    schemaFile: rawOptions.schemaFile,
    projectName: rawOptions.projectName,
    rows: rawOptions.rows ? Number(rawOptions.rows) : undefined,
  });

  const validated = argsSchema.parse({
    schemaFile: prompted.schemaFile,
    projectName: prompted.projectName,
    outputDir: rawOptions.outputDir,
    rows: prompted.rows,
    tableRows: rawOptions.tableRow,
    localeProfile: rawOptions.locale as LocaleProfile,
    region: rawOptions.region,
  });

  const schemaText = await readFile(path.resolve(validated.schemaFile), "utf8");
  const generatorOptions: GeneratorOptions = {
    projectName: validated.projectName,
    defaultRowsPerTable: validated.rows,
    maxRowsPerTable: MAX_ROWS_PER_TABLE,
    tableCounts: parseTableRows(validated.tableRows),
    columnOverrides: {},
    outputDir: path.resolve(validated.outputDir),
    localeProfile: validated.localeProfile,
    region: validated.region,
  };

  const project = await generateProject(schemaText, generatorOptions);

  output.write(`Generated project in ${project.projectDir}\n`);
  output.write(`Workbook: ${project.workbookPath}\n`);
  output.write(`SQL: ${project.sqlPath}\n`);
  output.write(`Summary: ${project.summaryPath}\n`);
}

main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  process.stderr.write(`${message}\n`);
  process.exitCode = 1;
});
