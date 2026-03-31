import { describe, expect, it } from "vitest";
import { generateMockData } from "./generator.js";
import { parseSchema } from "./schema.js";

const schemaText = `
users {
  id uuid pk
  email string unique
}

members {
  id uuid pk
  created_by_user_id uuid
}

users.id < members.created_by_user_id
`;

describe("schema and generator", () => {
  it("parses tables and relations", () => {
    const schema = parseSchema(schemaText);
    expect(schema.tables).toHaveLength(2);
    expect(schema.tables[1]?.columns[1]?.references?.table).toBe("users");
  });

  it("generates referenced values from parent tables", () => {
    const schema = parseSchema(schemaText);
    const result = generateMockData(schema, {
      projectName: "test",
      defaultRowsPerTable: 5,
      maxRowsPerTable: 500,
      tableCounts: {},
      columnOverrides: {},
      outputDir: "output",
      localeProfile: "global",
    });

    const userIds = new Set(result.tables.users.rows.map((row) => row.id));
    for (const row of result.tables.members.rows) {
      expect(userIds.has(row.created_by_user_id)).toBe(true);
    }
  });

  it("keeps referenced primary keys unique when the child primary key is also a foreign key", () => {
    const profileSchema = parseSchema(`
members {
  id uuid pk
}

member_profiles {
  member_id uuid pk
}

members.id < member_profiles.member_id
`);

    const result = generateMockData(profileSchema, {
      projectName: "test",
      defaultRowsPerTable: 5,
      maxRowsPerTable: 500,
      tableCounts: {},
      columnOverrides: {},
      outputDir: "output",
      localeProfile: "global",
    });

    const memberProfileIds = result.tables.member_profiles.rows.map((row) => row.member_id);
    expect(new Set(memberProfileIds).size).toBe(memberProfileIds.length);
  });

  it("uses locale-specific data when india profile is selected", () => {
    const localeSchema = parseSchema(`
members {
  id uuid pk
  first_name string
  last_name string
}
`);

    const result = generateMockData(localeSchema, {
      projectName: "india-test",
      defaultRowsPerTable: 3,
      maxRowsPerTable: 500,
      tableCounts: {},
      columnOverrides: {},
      outputDir: "output",
      localeProfile: "india",
      region: "Gujarat",
      seed: 42,
    });

    const firstNames = result.tables.members.rows.map((row) => row.first_name);
    expect(firstNames.every((name) => ["Arjun", "Rahul", "Vikram", "Kunal", "Dhruv", "Yash", "Priya", "Ananya", "Kavya", "Sneha", "Riya", "Ishita"].includes(String(name)))).toBe(true);
  });

  it("applies fixed column overrides and derives email from names and dob", () => {
    const schemaWithEmail = parseSchema(`
members {
  id uuid pk
  first_name string
  last_name string
  dob date
  email string unique
}
`);

    const result = generateMockData(schemaWithEmail, {
      projectName: "override-test",
      defaultRowsPerTable: 2,
      maxRowsPerTable: 500,
      tableCounts: {},
      columnOverrides: {
        members: {
          first_name: "Amit",
          last_name: "Jayswal",
          dob: "1990-05-14",
        },
      },
      outputDir: "output",
      localeProfile: "india",
    });

    const emails = result.tables.members.rows.map((row) => String(row.email));
    expect(result.tables.members.rows.every((row) => row.last_name === "Jayswal")).toBe(true);
    expect(emails[0]).toContain("amit.jayswal.90@");
    expect(new Set(emails).size).toBe(emails.length);
  });
});
