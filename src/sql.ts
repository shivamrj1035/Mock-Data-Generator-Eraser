import type { GenerationResult, TableRow, TableSchema } from "./types.js";

function sqlType(rawType: string): string {
  switch (rawType.toLowerCase()) {
    case "uuid":
      return "UUID";
    case "string":
    case "text":
    case "varchar":
      return "TEXT";
    case "timestamp":
    case "datetime":
      return "TIMESTAMP";
    case "date":
      return "DATE";
    case "boolean":
    case "bool":
      return "BOOLEAN";
    case "number":
    case "integer":
    case "int":
      return "INTEGER";
    default:
      return "TEXT";
  }
}

function escapeIdentifier(identifier: string): string {
  return `"${identifier.replaceAll('"', '""')}"`;
}

function escapeLiteral(value: TableRow[string]): string {
  if (value === null) return "NULL";
  if (typeof value === "number") return `${value}`;
  if (typeof value === "boolean") return value ? "TRUE" : "FALSE";
  return `'${String(value).replaceAll("'", "''")}'`;
}

function buildCreateTable(table: TableSchema): string {
  const lines: string[] = [];

  for (const column of table.columns) {
    const parts = [escapeIdentifier(column.name), sqlType(column.rawType)];
    if (column.isPrimaryKey) parts.push("NOT NULL");
    if (column.isUnique && !column.isPrimaryKey) parts.push("UNIQUE");
    lines.push(`  ${parts.join(" ")}`);
  }

  const primaryKeys = table.columns.filter((column) => column.isPrimaryKey);
  if (primaryKeys.length > 0) {
    lines.push(`  PRIMARY KEY (${primaryKeys.map((column) => escapeIdentifier(column.name)).join(", ")})`);
  }

  return `CREATE TABLE IF NOT EXISTS ${escapeIdentifier(table.name)} (\n${lines.join(",\n")}\n);`;
}

function buildForeignKeys(table: TableSchema): string[] {
  return table.columns
    .filter((column) => column.references)
    .map((column) => {
      const ref = column.references!;
      return `ALTER TABLE ${escapeIdentifier(table.name)} ADD CONSTRAINT ${escapeIdentifier(`fk_${table.name}_${column.name}`)} FOREIGN KEY (${escapeIdentifier(column.name)}) REFERENCES ${escapeIdentifier(ref.table)} (${escapeIdentifier(ref.column)});`;
    });
}

function buildInsert(table: TableSchema, rows: TableRow[]): string {
  if (rows.length === 0) return "";

  const columns = table.columns.map((column) => column.name);
  const primaryKeys = table.columns.filter((column) => column.isPrimaryKey).map((column) => column.name);
  const nonPrimaryColumns = columns.filter((column) => !primaryKeys.includes(column));

  const valuesSql = rows
    .map((row) => `(${columns.map((column) => escapeLiteral(row[column])).join(", ")})`)
    .join(",\n");

  const onConflict =
    primaryKeys.length === 0
      ? ""
      : nonPrimaryColumns.length === 0
        ? `\nON CONFLICT (${primaryKeys.map(escapeIdentifier).join(", ")}) DO NOTHING`
        : `\nON CONFLICT (${primaryKeys.map(escapeIdentifier).join(", ")}) DO UPDATE SET ${nonPrimaryColumns
            .map((column) => `${escapeIdentifier(column)} = EXCLUDED.${escapeIdentifier(column)}`)
            .join(", ")}`;

  return `INSERT INTO ${escapeIdentifier(table.name)} (${columns.map(escapeIdentifier).join(", ")})\nVALUES\n${valuesSql}${onConflict};`;
}

export function generateSql(result: GenerationResult): string {
  const createTables = result.orderedTables.map(buildCreateTable).join("\n\n");
  const foreignKeys = result.orderedTables.flatMap(buildForeignKeys).join("\n");
  const inserts = result.orderedTables
    .map((table) => buildInsert(table, result.tables[table.name]?.rows ?? []))
    .filter(Boolean)
    .join("\n\n");

  return [createTables, foreignKeys, inserts].filter(Boolean).join("\n\n");
}
