import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";
import { writeWorkbook } from "./excel.js";
import { generateMockData } from "./generator.js";
import { parseSchema } from "./schema.js";
import { generateSql } from "./sql.js";
import type { GenerateProjectResult, GeneratorOptions } from "./types.js";

function slugifyProjectName(projectName: string): string {
  return projectName
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "") || "mock-project";
}

export async function generateProject(schemaText: string, options: GeneratorOptions): Promise<GenerateProjectResult> {
  const schema = parseSchema(schemaText);
  const result = generateMockData(schema, options);
  const projectFolderName = slugifyProjectName(options.projectName);
  const projectDir = path.join(options.outputDir, projectFolderName);

  await mkdir(projectDir, { recursive: true });

  const workbookPath = path.join(projectDir, `${projectFolderName}.xlsx`);
  const sqlPath = path.join(projectDir, `${projectFolderName}.sql`);
  const summaryPath = path.join(projectDir, "generation-summary.json");

  await writeWorkbook(result, workbookPath);
  await writeFile(sqlPath, generateSql(result), "utf8");
  await writeFile(
    summaryPath,
    JSON.stringify(
      {
        projectName: options.projectName,
        generatedAt: new Date().toISOString(),
        localeProfile: options.localeProfile,
        region: options.region ?? null,
        columnOverrides: options.columnOverrides,
        tables: result.orderedTables.map((table) => ({
          name: table.name,
          rows: result.tables[table.name]?.rows.length ?? 0,
        })),
      },
      null,
      2,
    ),
    "utf8",
  );

  return {
    projectDir,
    sqlPath,
    workbookPath,
    summaryPath,
    result,
  };
}
