# Type-Safe Builder Pattern

## Contents
- Core technique (generic ID capture + intersection accumulation)
- Implementation pattern
- Query builder example
- Configuration builder with required fields
- Pitfalls

## Core Technique

Each method returns a new generic instantiation with **extended** type information:

```typescript
new DbSeeder()
  .addUser("matt", { name: "Matt" })    // → DbSeeder<{ users: Record<"matt", User>; posts: {} }>
  .addPost("post1", { title: "Hello" }) // → DbSeeder<{ users: Record<"matt", User>; posts: Record<"post1", Post> }>
  .transact();
```

**Key ingredients:**
1. **Generic ID capture**: `<Id extends string>` infers literal types like `"matt"`, not `string`
2. **Intersection accumulation**: `TDatabase & { users: Record<Id, User> }` adds without losing
3. **Cast in terminal methods**: `this.users as TDatabase["users"]` bridges runtime to compile-time

## Implementation

```typescript
interface DbShape {
  users: Record<string, User>;
  posts: Record<string, Post>;
}

class DbSeeder<TDatabase extends DbShape> {
  public users: DbShape["users"] = {};
  public posts: DbShape["posts"] = {};

  addUser = <Id extends string>(
    id: Id, user: Omit<User, "id">
  ): DbSeeder<TDatabase & { users: TDatabase["users"] & Record<Id, User> }> => {
    this.users[id] = { ...user, id };
    return this;
  };

  addPost = <Id extends string>(
    id: Id, post: Omit<Post, "id">
  ): DbSeeder<TDatabase & { posts: TDatabase["posts"] & Record<Id, Post> }> => {
    this.posts[id] = { ...post, id };
    return this;
  };

  transact = async () => ({
    users: this.users as TDatabase["users"],
    posts: this.posts as TDatabase["posts"],
  });
}
```

## Query Builder (Enforce Required Steps)

Use `this:` parameter to require `.from()` before `.build()`:

```typescript
class QueryBuilder<TState extends { table: string | null }> {
  private state: TState;
  private constructor(state: TState) { this.state = state; }
  static create() { return new QueryBuilder({ table: null, columns: [] as string[], where: null as string | null }); }

  from<T extends string>(table: T): QueryBuilder<TState & { table: T }> {
    return new QueryBuilder({ ...this.state, table });
  }

  select<C extends string[]>(...columns: C) {
    return new QueryBuilder({ ...this.state, columns });
  }

  build(this: QueryBuilder<TState & { table: string }>): string {
    const cols = (this.state as any).columns?.length ? (this.state as any).columns.join(", ") : "*";
    return `SELECT ${cols} FROM ${this.state.table}`;
  }
}

QueryBuilder.create().from("users").select("id", "name").build(); // OK
QueryBuilder.create().select("id").build(); // Type error — .from() required
```

## Configuration Builder (Required Fields Gate)

```typescript
class ConfigBuilder<TSet extends Partial<Record<"host" | "port", true>>> {
  private config: Partial<{ host: string; port: number; ssl: boolean }> = {};

  host(v: string): ConfigBuilder<TSet & { host: true }> { this.config.host = v; return this as any; }
  port(v: number): ConfigBuilder<TSet & { port: true }> { this.config.port = v; return this as any; }
  ssl(v: boolean) { this.config.ssl = v; return this; }

  build(this: ConfigBuilder<{ host: true; port: true }>) { return this.config as Required<typeof this.config>; }
}

new ConfigBuilder().host("localhost").port(3000).build(); // OK
new ConfigBuilder().host("localhost").build(); // Type error — port missing
```

## Pitfalls

### Forgetting the generic constraint

```typescript
// BAD — TDatabase could be anything
class DbSeeder<TDatabase> { /* Cannot access TDatabase["users"] */ }

// GOOD
class DbSeeder<TDatabase extends DbShape> { /* Safe access */ }
```

### Returning `this` instead of new type

```typescript
// BAD — same type, loses accumulated info
addUser(id: string): this { return this; }

// GOOD — new generic instantiation
addUser<Id extends string>(id: Id): DbSeeder<TDatabase & { users: Record<Id, User> }> { return this; }
```

### Not casting in terminal methods

Runtime `this.users` is `Record<string, User>`, not `TDatabase["users"]`. Cast in the final method.
