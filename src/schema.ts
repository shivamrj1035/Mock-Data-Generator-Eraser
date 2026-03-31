import type { ColumnSchema, ScalarType, SchemaModel, TableSchema } from "./types.js";

const TABLE_HEADER_REGEX = /^([a-zA-Z_][\w]*)\s*(\[[^\]]*])?\s*\{$/;
const RELATION_REGEX = /^([a-zA-Z_][\w]*)\.([a-zA-Z_][\w]*)\s*<\s*([a-zA-Z_][\w]*)\.([a-zA-Z_][\w]*)$/;

function normalizeScalarType(rawType: string): ScalarType {
  const value = rawType.trim().toLowerCase();
  if (value === "uuid") return "uuid";
  if (value === "string" || value === "text" || value === "varchar") return "string";
  if (value === "timestamp" || value === "datetime") return "timestamp";
  if (value === "date") return "date";
  if (value === "boolean" || value === "bool") return "boolean";
  if (value === "number" || value === "integer" || value === "int") return "number";
  return "unknown";
}

function parseEnumValues(comment?: string): string[] | undefined {
  if (!comment) return undefined;
  const cleaned = comment.trim();
  if (!cleaned.includes(",")) return undefined;
  const values = cleaned
    .split(",")
    .map((part) => part.trim())
    .filter(Boolean);
  return values.length > 0 ? values : undefined;
}

function parseColumn(line: string): ColumnSchema {
  const [body, ...commentParts] = line.split("//");
  const comment = commentParts.join("//").trim() || undefined;
  const tokens = body.trim().split(/\s+/).filter(Boolean);

  if (tokens.length < 2) {
    throw new Error(`Invalid column definition: "${line}"`);
  }

  const [name, rawType, ...modifiers] = tokens;
  const normalizedModifiers = modifiers.map((modifier) => modifier.toLowerCase());

  return {
    name,
    rawType,
    type: normalizeScalarType(rawType),
    modifiers,
    isPrimaryKey: normalizedModifiers.includes("pk"),
    isUnique: normalizedModifiers.includes("unique"),
    comment,
    enumValues: parseEnumValues(comment),
  };
}

export function parseSchema(input: string): SchemaModel {
  const tables: TableSchema[] = [];
  const tableMap = new Map<string, TableSchema>();
  const relationLines: Array<{ sourceTable: string; sourceColumn: string; targetTable: string; targetColumn: string }> = [];

  const lines = input
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter((line) => line.length > 0);

  let currentTable: TableSchema | null = null;

  for (const line of lines) {
    if (currentTable) {
      if (line === "}") {
        tables.push(currentTable);
        tableMap.set(currentTable.name, currentTable);
        currentTable = null;
        continue;
      }

      currentTable.columns.push(parseColumn(line));
      continue;
    }

    const tableHeaderMatch = line.match(TABLE_HEADER_REGEX);
    if (tableHeaderMatch) {
      currentTable = {
        name: tableHeaderMatch[1],
        metadata: tableHeaderMatch[2],
        columns: [],
      };
      continue;
    }

    const relationMatch = line.match(RELATION_REGEX);
    if (relationMatch) {
      relationLines.push({
        sourceTable: relationMatch[1],
        sourceColumn: relationMatch[2],
        targetTable: relationMatch[3],
        targetColumn: relationMatch[4],
      });
    }
  }

  if (currentTable) {
    throw new Error(`Unclosed table definition for "${currentTable.name}"`);
  }

  for (const relation of relationLines) {
    const targetTable = tableMap.get(relation.targetTable);
    if (!targetTable) {
      throw new Error(`Relation references unknown table "${relation.targetTable}"`);
    }

    const targetColumn = targetTable.columns.find((column) => column.name === relation.targetColumn);
    if (!targetColumn) {
      throw new Error(`Relation references unknown column "${relation.targetTable}.${relation.targetColumn}"`);
    }

    targetColumn.references = {
      table: relation.sourceTable,
      column: relation.sourceColumn,
    };
  }

  return { tables };
}
