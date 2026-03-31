export type ScalarType =
  | "uuid"
  | "string"
  | "timestamp"
  | "date"
  | "boolean"
  | "number"
  | "unknown";

export interface ForeignKeyRef {
  table: string;
  column: string;
}

export interface ColumnSchema {
  name: string;
  rawType: string;
  type: ScalarType;
  modifiers: string[];
  isPrimaryKey: boolean;
  isUnique: boolean;
  comment?: string;
  enumValues?: string[];
  references?: ForeignKeyRef;
}

export interface TableSchema {
  name: string;
  metadata?: string;
  columns: ColumnSchema[];
}

export interface SchemaModel {
  tables: TableSchema[];
}

export type TableRow = Record<string, string | number | boolean | null>;

export interface GeneratedTableData {
  table: TableSchema;
  rows: TableRow[];
}

export interface GenerationResult {
  schema: SchemaModel;
  tables: Record<string, GeneratedTableData>;
  orderedTables: TableSchema[];
}

export type LocaleProfile = "global" | "india" | "us";

export interface GeneratorOptions {
  projectName: string;
  defaultRowsPerTable: number;
  maxRowsPerTable: number;
  tableCounts: Record<string, number>;
  columnOverrides: Record<string, Record<string, string>>;
  outputDir: string;
  localeProfile: LocaleProfile;
  region?: string;
  seed?: number;
}

export interface GenerateProjectResult {
  projectDir: string;
  sqlPath: string;
  workbookPath: string;
  summaryPath: string;
  result: GenerationResult;
}
