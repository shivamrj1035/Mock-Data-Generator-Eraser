import type { SchemaModel, TableSchema } from "./types.js";

export function clampRowCount(value: number, maxRowsPerTable: number): number {
  if (!Number.isFinite(value)) return 20;
  if (value < 0) return 0;
  return Math.min(Math.floor(value), maxRowsPerTable);
}

export function buildGenerationOrder(schema: SchemaModel): TableSchema[] {
  const tableMap = new Map(schema.tables.map((table) => [table.name, table]));
  const dependencies = new Map<string, Set<string>>();

  for (const table of schema.tables) {
    const refs = new Set<string>();
    for (const column of table.columns) {
      if (column.references && column.references.table !== table.name && tableMap.has(column.references.table)) {
        refs.add(column.references.table);
      }
    }
    dependencies.set(table.name, refs);
  }

  const ordered: TableSchema[] = [];
  const processed = new Set<string>();

  while (ordered.length < schema.tables.length) {
    const ready = schema.tables.filter((table) => {
      if (processed.has(table.name)) return false;
      const refs = dependencies.get(table.name) ?? new Set<string>();
      return [...refs].every((dependency) => processed.has(dependency));
    });

    if (ready.length === 0) {
      for (const table of schema.tables) {
        if (!processed.has(table.name)) {
          ordered.push(table);
          processed.add(table.name);
        }
      }
      break;
    }

    for (const table of ready) {
      ordered.push(table);
      processed.add(table.name);
    }
  }

  return ordered;
}
