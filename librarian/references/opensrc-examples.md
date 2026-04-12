# opensrc Exploration Examples
Use these patterns for multi-step remote codebase investigation. Reuse them as building blocks, not as canned final answers.
## Workflow: Fetch Once, Reuse `source.name`
```javascript
async () => {
  const [{ source }] = await opensrc.fetch("vercel/ai");
  const sourceName = source.name;
  const [tree, keyFiles] = await Promise.all([
    opensrc.tree(sourceName, { depth: 2 }),
    opensrc.readMany(sourceName, ["package.json", "README.md", "src/index.ts"])
  ]);
  return { sourceName, tree, keyFiles: Object.keys(keyFiles) };
}
```
## Workflow: Compare Multiple Libraries
```javascript
async () => {
  const fetched = await opensrc.fetch(["zod", "valibot", "yup"]);
  const names = fetched.map(({ source }) => source.name);
  const pattern = "string.*validate|validateString";
  return Promise.all(
    names.map(async (name) => {
      const matches = await opensrc.grep(pattern, {
        sources: [name],
        include: "*.ts",
        maxResults: 10
      });
      return {
        name,
        hits: matches.length,
        locations: matches.map((m) => `${m.file}:${m.line}`)
      };
    })
  );
}
```
## Workflow: Grep, Then Read Match Context
```javascript
async () => {
  const matches = await opensrc.grep("export function parse\\(", {
    sources: ["zod"],
    include: "*.ts",
    maxResults: 5
  });
  if (matches.length === 0) return { matches: [] };
  const first = matches[0];
  const content = await opensrc.read(first.source, first.file);
  const lines = content.split("\n");
  return {
    file: first.file,
    line: first.line,
    preview: lines.slice(first.line - 3, first.line + 8).join("\n")
  };
}
```
## Workflow: Search Across All Fetched Sources
```javascript
async () => {
  const inventory = opensrc.list();
  return Promise.all(
    inventory.map(async ({ name, type }) => {
      const matches = await opensrc.grep("throw new|catch \\(|\\.catch\\(", {
        sources: [name],
        include: "*.ts",
        maxResults: 20
      });
      return { name, type, errorPatterns: matches.length };
    })
  );
}
```
## Workflow: AST Search for Structural Patterns
```javascript
async () => {
  const [{ source }] = await opensrc.fetch("lodash");
  const functions = await opensrc.astGrep(
    source.name,
    "function $NAME($$$ARGS) { $$$BODY }",
    { lang: "js", limit: 20 }
  );
  return functions.map((match) => ({
    file: match.file,
    line: match.line,
    name: match.metavars.NAME
  }));
}
```
## Workflow: Compare Exports Across Libraries with AST
```javascript
async () => {
  const fetched = await opensrc.fetch(["zod", "valibot"]);
  return Promise.all(
    fetched.map(async ({ source }) => {
      const matches = await opensrc.astGrep(
        source.name,
        "export const $NAME = $_",
        { glob: "**/*.ts", lang: "ts", limit: 30 }
      );
      return {
        name: source.name,
        exports: matches.map((match) => match.metavars.NAME)
      };
    })
  );
}
```
## Workflow: Map Repository Structure and Entry Points
```javascript
async () => {
  const [{ source }] = await opensrc.fetch("vercel/ai");
  const sourceName = source.name;
  const files = await opensrc.files(sourceName, "**/*.{ts,js}");
  const entryPoints = files
    .map((file) => file.path)
    .filter((path) => path.match(/^(src\/)?(index|main|mod)\.(ts|js)$/) || path.includes("/index.ts"))
    .slice(0, 5);
  const contents = await Promise.all(
    entryPoints.map(async (path) => ({ path, content: await opensrc.read(sourceName, path) }))
  );
  return {
    totalFiles: files.length,
    entryPoints,
    previews: contents.map(({ path, content }) => ({ path, preview: content.slice(0, 300) }))
  };
}
```
## Workflow: Batch Read with Error Filtering
```javascript
async () => {
  const files = await opensrc.readMany("zod", [
    "src/index.ts",
    "src/types.ts",
    "src/ZodError.ts",
    "src/helpers/parseUtil.ts",
    "src/missing.ts"
  ]);
  return Object.entries(files)
    .filter(([, value]) => !value.startsWith("[Error:"))
    .map(([path, content]) => ({ path, lines: content.split("\n").length }));
}
```
## Tool Choice Rule
| Goal | Pattern |
|------|---------|
| Regex or text match | `grep()` |
| Syntax-aware match | `astGrep()` |
| Repo overview | `tree()` then `files()` |
| Targeted file inspection | `read()` or `readMany()` |
| Cross-library comparison | `fetch()` many, then parallel `grep()` or `astGrep()` |
## Exploration Checklist
### Repository Analysis
1. Fetch the target.
2. Capture `source.name`.
3. Read `package.json`, `README.md`, and entry files.
4. Map exported API and internal structure.
5. Cite linked source files in the final answer.
### Library Comparison
1. Fetch all targets together.
2. Search the same pattern in each source.
3. Read the matching implementations.
4. Build a comparison table.
5. Synthesize differences and tradeoffs.
