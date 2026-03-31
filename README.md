# Mock Data Generator From Eraser Code

Generate relational mock data from Eraser-style schema text and export:

- an Excel workbook with one sheet per table
- a PostgreSQL-flavored SQL file with `CREATE TABLE`, foreign keys, and upsertable inserts
- a JSON summary of generated row counts

## Requirements

- Node.js 20+
- npm 10+

## Install

```bash
npm install
```

## Web App

Build and start the server:

```bash
npm run build
node dist/server.js
```

Then open:

```text
http://localhost:3000
```

The page lets you:

- paste Eraser schema text
- enter the project name
- choose default and per-table row counts
- set fixed values for any table column
- select `global`, `india`, or `us`
- optionally set a region/state
- generate and download Excel and SQL files

## Generate From CLI

Build first:

```bash
npm run build
```

Then run:

```bash
node dist/cli.js \
  --schema-file examples/family-schema.eraser \
  --project-name family-demo \
  --rows 20 \
  --locale india \
  --region Gujarat \
  --table-row users=50 \
  --table-row members=120
```

Generated files are written to:

```text
output/<project-name>/
```

## Run API Server

```bash
npm run server
```

### POST `/generate`

```json
{
  "schema": "users {\\n  id uuid pk\\n}",
  "projectName": "demo-project",
  "defaultRowsPerTable": 20,
  "localeProfile": "india",
  "region": "Gujarat",
  "tableCounts": {
    "users": 40
  },
  "outputDir": "output"
}
```

## Commands

```bash
npm run build
npm test
npm run server
```
