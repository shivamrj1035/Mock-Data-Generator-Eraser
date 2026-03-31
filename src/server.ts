import { createReadStream } from "node:fs";
import { access } from "node:fs/promises";
import path from "node:path";
import Fastify from "fastify";
import { z } from "zod";
import { generateProject } from "./project.js";
import { parseSchema } from "./schema.js";
import { htmlPage } from "./ui.js";

const requestSchema = z.object({
  schema: z.string().min(1),
  projectName: z.string().min(1),
  defaultRowsPerTable: z.number().int().min(0).max(500).default(20),
  tableCounts: z.record(z.string(), z.number().int().min(0).max(500)).default({}),
  columnOverrides: z.record(z.string(), z.record(z.string(), z.string())).default({}),
  outputDir: z.string().min(1).default("output"),
  localeProfile: z.enum(["global", "india", "us"]).default("global"),
  region: z.string().optional(),
  seed: z.number().int().optional(),
});

async function buildServer() {
  const app = Fastify({ logger: true });
  const outputRoot = path.resolve(process.cwd(), "output");

  app.get("/health", async () => ({ ok: true }));

  app.get("/", async (_, reply) => {
    return reply.type("text/html").send(htmlPage);
  });

  app.post("/inspect-schema", async (request, reply) => {
    const parsed = z.object({ schema: z.string().min(1) }).safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const schema = parseSchema(parsed.data.schema);
    return {
      tables: schema.tables.map((table) => ({
        name: table.name,
        columns: table.columns.map((column) => ({
          name: column.name,
          type: column.rawType,
        })),
      })),
    };
  });

  app.post("/generate", async (request, reply) => {
    const parsed = requestSchema.safeParse(request.body);
    if (!parsed.success) {
      return reply.status(400).send({ error: parsed.error.flatten() });
    }

    const project = await generateProject(parsed.data.schema, {
      projectName: parsed.data.projectName,
      defaultRowsPerTable: parsed.data.defaultRowsPerTable,
      maxRowsPerTable: 500,
      tableCounts: parsed.data.tableCounts,
      columnOverrides: parsed.data.columnOverrides,
      outputDir: parsed.data.outputDir,
      localeProfile: parsed.data.localeProfile,
      region: parsed.data.region,
      seed: parsed.data.seed,
    });

    return {
      projectDir: project.projectDir,
      workbookPath: project.workbookPath,
      sqlPath: project.sqlPath,
      summaryPath: project.summaryPath,
      workbookDownload: `/downloads/${path.basename(project.projectDir)}/${path.basename(project.workbookPath)}`,
      sqlDownload: `/downloads/${path.basename(project.projectDir)}/${path.basename(project.sqlPath)}`,
      tables: project.result.orderedTables.map((table) => ({
        name: table.name,
        rows: project.result.tables[table.name]?.rows.length ?? 0,
      })),
    };
  });

  app.get("/downloads/:project/:file", async (request, reply) => {
    const params = z.object({
      project: z.string().min(1),
      file: z.string().min(1),
    }).parse(request.params);

    const safeProject = path.basename(params.project);
    const safeFile = path.basename(params.file);
    const filePath = path.join(outputRoot, safeProject, safeFile);

    await access(filePath);
    const stream = createReadStream(filePath);
    const contentType = safeFile.endsWith(".xlsx")
      ? "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      : "application/sql";

    return reply.type(contentType).send(stream);
  });

  return app;
}

const app = await buildServer();
const port = Number(process.env.PORT || "3000");
await app.listen({ host: "0.0.0.0", port });
