import { faker } from "@faker-js/faker";
import { getLocaleContext } from "./locales.js";
import { buildGenerationOrder, clampRowCount } from "./planner.js";
import type {
  ColumnSchema,
  GenerationResult,
  GeneratorOptions,
  SchemaModel,
  TableRow,
  TableSchema,
} from "./types.js";

function makeUniqueTracker() {
  return new Map<string, Set<string>>();
}

function getPrimaryKeyColumns(table: TableSchema): ColumnSchema[] {
  return table.columns.filter((column) => column.isPrimaryKey);
}

function inferGenderValue(sourceRow: TableRow): string | undefined {
  const value = sourceRow.gender;
  return typeof value === "string" ? value.toLowerCase() : undefined;
}

function setInferredGenderIfMissing(table: TableSchema, partialRow: TableRow): string | undefined {
  const hasGenderColumn = table.columns.some((column) => column.name === "gender");
  if (!hasGenderColumn) return inferGenderValue(partialRow);

  const existing = inferGenderValue(partialRow);
  if (existing) return existing;

  const generatedGender = faker.helpers.arrayElement(["male", "female"]);
  partialRow.gender = generatedGender;
  return generatedGender;
}

function pickFromEnum(column: ColumnSchema): string | undefined {
  if (!column.enumValues || column.enumValues.length === 0) return undefined;
  return faker.helpers.arrayElement(column.enumValues);
}

function slugifyPart(value: string): string {
  return value
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "")
    .slice(0, 20);
}

function toSqlTimestamp(date: Date): string {
  return date.toISOString().slice(0, 19).replace("T", " ");
}

function generateStringValue(
  table: TableSchema,
  column: ColumnSchema,
  rowIndex: number,
  partialRow: TableRow,
  options: GeneratorOptions,
): string {
  const enumValue = pickFromEnum(column);
  if (enumValue) return enumValue;

  const lowerName = column.name.toLowerCase();
  const locale = getLocaleContext(options.localeProfile, options.region);

  if (lowerName === "email") return faker.internet.exampleEmail();
  if (lowerName === "phone") return `${locale.phoneCountryCode}${faker.string.numeric(10)}`;
  if (lowerName === "password_hash") return faker.string.alphanumeric(60);
  if (lowerName.includes("first_name")) {
    const gender = setInferredGenderIfMissing(table, partialRow);
    return gender === "female"
      ? faker.helpers.arrayElement(locale.firstNamesFemale)
      : faker.helpers.arrayElement(locale.firstNamesMale);
  }
  if (lowerName.includes("last_name")) return faker.helpers.arrayElement(locale.lastNames);
  if (lowerName === "gender") return faker.helpers.arrayElement(["male", "female"]);
  if (lowerName === "name") {
    if (table.name === "kutumb") {
      const baseName = faker.helpers.arrayElement(locale.lastNames);
      return `${baseName} ${locale.familyNameSuffix}`;
    }
    if (table.name === "categories") {
      const regionLabel = locale.region ?? faker.helpers.arrayElement(locale.regions);
      return faker.helpers.arrayElement([`${regionLabel} Region`, `${faker.helpers.arrayElement(locale.cities)} City`, "Central Branch", "Family Branch"]);
    }
    if (table.name === "roles") return faker.helpers.arrayElement(["SUPER_ADMIN", "KUTUMB_ADMIN", "CATEGORY_ADMIN", "MEMBER"]);
    return faker.person.fullName();
  }
  if (lowerName.includes("origin_place") || lowerName.includes("native_place")) return faker.helpers.arrayElement(locale.cities);
  if (lowerName.includes("current_city")) return faker.helpers.arrayElement(locale.cities);
  if (lowerName.includes("company")) return faker.helpers.arrayElement(locale.companies);
  if (lowerName.includes("profession")) return faker.helpers.arrayElement(["Engineer", "Teacher", "Business Owner", "Doctor", "Designer", "Accountant"]);
  if (lowerName.includes("education")) return faker.helpers.arrayElement(locale.educationOptions);
  if (lowerName.includes("status")) return faker.helpers.arrayElement(["ACTIVE", "INACTIVE", "PENDING"]);
  if (lowerName.includes("description")) return faker.lorem.sentence();
  if (lowerName.includes("field_name")) return faker.helpers.arrayElement(["phone", "dob", "education", "profession", "current_city"]);
  if (lowerName.includes("visibility")) return faker.helpers.arrayElement(["PUBLIC", "FAMILY", "CUSTOM"]);
  if (lowerName.includes("access_type")) return faker.helpers.arrayElement(["VIEW", "EDIT"]);
  if (lowerName.includes("key_type")) return faker.helpers.arrayElement(["PHONE", "EMAIL", "NAME_DOB_HASH"]);
  if (lowerName.includes("key_value")) return faker.string.alphanumeric(20);
  if (lowerName.includes("relation_type")) {
    if (table.name === "relationships") return faker.helpers.arrayElement(["father", "mother", "spouse", "child", "sibling"]);
    return faker.helpers.arrayElement(["SELF", "SPOUSE", "PARENT", "CHILD"]);
  }
  if (lowerName.includes("scope_type")) return faker.helpers.arrayElement(["GLOBAL", "KUTUMB", "CATEGORY"]);
  if (lowerName.includes("marital_status")) return faker.helpers.arrayElement(["single", "married", "widowed"]);
  if (lowerName === "type") return faker.helpers.arrayElement(["REGION", "CITY", "SUBGROUP", "FAMILY_BRANCH"]);

  return `${table.name}_${column.name}_${rowIndex + 1}`;
}

function parseOverrideValue(column: ColumnSchema, rawValue: string): TableRow[string] {
  const value = rawValue.trim();
  if (value.toLowerCase() === "null") return null;

  switch (column.type) {
    case "boolean":
      return ["true", "1", "yes"].includes(value.toLowerCase());
    case "number": {
      const parsed = Number(value);
      return Number.isFinite(parsed) ? parsed : 0;
    }
    default:
      return value;
  }
}

function generateNumberValue(column: ColumnSchema): number {
  if (column.name.toLowerCase() === "level") return faker.number.int({ min: 1, max: 4 });
  if (column.name.toLowerCase() === "max_depth") return faker.number.int({ min: 1, max: 4 });
  return faker.number.int({ min: 1, max: 9999 });
}

function generateBaseValue(
  table: TableSchema,
  column: ColumnSchema,
  rowIndex: number,
  partialRow: TableRow,
  options: GeneratorOptions,
): TableRow[string] {
  switch (column.type) {
    case "uuid":
      return crypto.randomUUID();
    case "string":
      return generateStringValue(table, column, rowIndex, partialRow, options);
    case "timestamp":
      return toSqlTimestamp(faker.date.past({ years: 5 }));
    case "date":
      if (column.name.toLowerCase().includes("dob")) return faker.date.birthdate({ min: 18, max: 90, mode: "age" }).toISOString().slice(0, 10);
      return faker.date.past({ years: 15 }).toISOString().slice(0, 10);
    case "boolean":
      return faker.datatype.boolean();
    case "number":
      return generateNumberValue(column);
    default:
      return faker.lorem.word();
  }
}

function ensureUnique(
  table: TableSchema,
  column: ColumnSchema,
  valueFactory: () => TableRow[string],
  uniqueTracker: Map<string, Set<string>>,
): TableRow[string] {
  const key = `${table.name}.${column.name}`;
  const usedValues = uniqueTracker.get(key) ?? new Set<string>();
  uniqueTracker.set(key, usedValues);

  let attempts = 0;
  while (attempts < 50) {
    const value = valueFactory();
    const fingerprint = String(value);
    if (!usedValues.has(fingerprint)) {
      usedValues.add(fingerprint);
      return value;
    }
    attempts += 1;
  }

  const fallback = `${column.name}_${crypto.randomUUID()}`;
  usedValues.add(fallback);
  return fallback;
}

function reserveUniqueValue(
  table: TableSchema,
  column: ColumnSchema,
  proposedValue: string,
  uniqueTracker: Map<string, Set<string>>,
): string {
  const key = `${table.name}.${column.name}`;
  const usedValues = uniqueTracker.get(key) ?? new Set<string>();
  uniqueTracker.set(key, usedValues);

  if (!usedValues.has(proposedValue)) {
    usedValues.add(proposedValue);
    return proposedValue;
  }

  let suffix = 2;
  while (usedValues.has(`${proposedValue}${suffix}`)) {
    suffix += 1;
  }

  const uniqueValue = `${proposedValue}${suffix}`;
  usedValues.add(uniqueValue);
  return uniqueValue;
}

function pickReferencedValue(
  referencedRows: TableRow[],
  referencedColumnName: string,
  uniqueReferenceTracker: Map<string, number>,
  trackerKey: string,
  requireUnique: boolean,
): TableRow[string] | null {
  if (referencedRows.length === 0) return null;
  if (requireUnique) {
    const nextIndex = uniqueReferenceTracker.get(trackerKey) ?? 0;
    if (nextIndex < referencedRows.length) {
      uniqueReferenceTracker.set(trackerKey, nextIndex + 1);
      return referencedRows[nextIndex]?.[referencedColumnName] ?? null;
    }
  }
  const row = faker.helpers.arrayElement(referencedRows);
  return row[referencedColumnName] ?? null;
}

function deriveEmailValue(
  table: TableSchema,
  row: TableRow,
  options: GeneratorOptions,
  uniqueTracker: Map<string, Set<string>>,
  emailOverridden: boolean,
): void {
  const emailColumn = table.columns.find((column) => column.name.toLowerCase() === "email");
  if (!emailColumn) return;
  if (emailOverridden) return;

  const domain = options.localeProfile === "india" ? "example.in" : options.localeProfile === "us" ? "example.us" : "example.com";
  const firstName = typeof row.first_name === "string" ? slugifyPart(row.first_name) : "";
  const lastName = typeof row.last_name === "string" ? slugifyPart(row.last_name) : "";
  const dobYear = typeof row.dob === "string" ? row.dob.slice(2, 4) : "";
  const nameValue = typeof row.name === "string" ? slugifyPart(row.name) : "";
  const localPart = [firstName, lastName].filter(Boolean).join(".") || nameValue || faker.internet.username().toLowerCase();
  const email = `${localPart}${dobYear ? `.${dobYear}` : ""}@${domain}`;
  const finalValue = reserveUniqueValue(table, emailColumn, email, uniqueTracker);
  row[emailColumn.name] = finalValue;
}

function applyPostProcessing(table: TableSchema, rows: TableRow[], generatedTables: Map<string, TableRow[]>): void {
  if (table.name === "categories") {
    for (let index = 0; index < rows.length; index += 1) {
      const row = rows[index];
      const priorRows = rows.slice(0, index);
      if ("level" in row && typeof row.level === "number") {
        row.level = priorRows.length === 0 ? 1 : faker.number.int({ min: 1, max: 4 });
      }
      if ("parent_id" in row) {
        row.parent_id = priorRows.length === 0 ? null : faker.helpers.maybe(() => faker.helpers.arrayElement(priorRows).id as string, { probability: 0.7 }) ?? null;
      }
    }
  }

  if (table.name === "relationships") {
    const members = generatedTables.get("members") ?? [];
    for (const row of rows) {
      const memberIds = members.map((member) => member.id).filter((id): id is string => typeof id === "string");
      if (memberIds.length >= 2) {
        const memberId = faker.helpers.arrayElement(memberIds);
        let relatedMemberId = faker.helpers.arrayElement(memberIds);
        while (relatedMemberId === memberId && memberIds.length > 1) {
          relatedMemberId = faker.helpers.arrayElement(memberIds);
        }
        row.member_id = memberId;
        row.related_member_id = relatedMemberId;
      }
    }
  }

  if (table.name === "marriages") {
    const members = generatedTables.get("members") ?? [];
    const maleMembers = members.filter((member) => String(member.gender).toLowerCase() === "male");
    const femaleMembers = members.filter((member) => String(member.gender).toLowerCase() === "female");

    for (const row of rows) {
      if (maleMembers.length > 0) {
        row.husband_member_id = faker.helpers.arrayElement(maleMembers).id ?? row.husband_member_id;
      }
      if (femaleMembers.length > 0) {
        row.wife_member_id = faker.helpers.arrayElement(femaleMembers).id ?? row.wife_member_id;
      }
      if (row.husband_member_id === row.wife_member_id && femaleMembers.length > 1) {
        row.wife_member_id = faker.helpers.arrayElement(femaleMembers.filter((member) => member.id !== row.husband_member_id)).id ?? row.wife_member_id;
      }
    }
  }
}

export function generateMockData(schema: SchemaModel, options: GeneratorOptions): GenerationResult {
  if (typeof options.seed === "number") {
    faker.seed(options.seed);
  }

  const orderedTables = buildGenerationOrder(schema);
  const tableRows = new Map<string, TableRow[]>();
  const uniqueTracker = makeUniqueTracker();
  const uniqueReferenceTracker = new Map<string, number>();

  for (const table of orderedTables) {
    const desiredCount = clampRowCount(
      options.tableCounts[table.name] ?? options.defaultRowsPerTable,
      options.maxRowsPerTable,
    );

    const rows: TableRow[] = [];
    const tableOverrides = options.columnOverrides[table.name] ?? {};

    for (let rowIndex = 0; rowIndex < desiredCount; rowIndex += 1) {
      const row: TableRow = {};
      let emailOverridden = false;

      for (const column of table.columns) {
        const overrideValue = tableOverrides[column.name];
        if (typeof overrideValue === "string" && overrideValue.trim() !== "") {
          row[column.name] = parseOverrideValue(column, overrideValue);
          if (column.name.toLowerCase() === "email") {
            emailOverridden = true;
          }
          continue;
        }

        if (column.references && column.references.table !== table.name) {
          const referencedRows = tableRows.get(column.references.table) ?? [];
          row[column.name] = pickReferencedValue(
            referencedRows,
            column.references.column,
            uniqueReferenceTracker,
            `${table.name}.${column.name}`,
            column.isPrimaryKey || column.isUnique,
          );
          continue;
        }

        const factory = () => generateBaseValue(table, column, rowIndex, row, options);
        const isUniqueColumn = column.isUnique || column.isPrimaryKey;
        row[column.name] = isUniqueColumn ? ensureUnique(table, column, factory, uniqueTracker) : factory();
      }

      deriveEmailValue(table, row, options, uniqueTracker, emailOverridden);
      rows.push(row);
    }

    applyPostProcessing(table, rows, tableRows);
    tableRows.set(table.name, rows);
  }

  const tables = Object.fromEntries(
    orderedTables.map((table) => [table.name, { table, rows: tableRows.get(table.name) ?? [] }]),
  );

  return {
    schema,
    tables,
    orderedTables,
  };
}

export function getPrimaryKeyValues(table: TableSchema, row: TableRow): TableRow[string][] {
  return getPrimaryKeyColumns(table).map((column) => row[column.name]);
}
