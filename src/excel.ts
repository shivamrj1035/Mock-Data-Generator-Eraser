import ExcelJS from "exceljs";
import type { GenerationResult } from "./types.js";

export async function writeWorkbook(result: GenerationResult, outputPath: string): Promise<void> {
  const workbook = new ExcelJS.Workbook();
  workbook.creator = "mock-data-from-eraser-code";
  workbook.created = new Date();

  for (const table of result.orderedTables) {
    const worksheet = workbook.addWorksheet(table.name);
    worksheet.columns = table.columns.map((column) => ({
      header: column.name,
      key: column.name,
      width: Math.max(column.name.length + 4, 18),
    }));

    for (const row of result.tables[table.name]?.rows ?? []) {
      worksheet.addRow(row);
    }

    worksheet.getRow(1).font = { bold: true };
    worksheet.views = [{ state: "frozen", ySplit: 1 }];
  }

  await workbook.xlsx.writeFile(outputPath);
}
