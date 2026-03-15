# Testing Patterns

Testing strategies for Clean Architecture + DDD + Hexagonal systems.

## Unit Tests

### Domain Layer Tests

Test business logic in isolation. **No mocks needed** — domain has no dependencies.

```typescript
describe('Order', () => {
  describe('create', () => {
    it('creates order with draft status', () => {
      const order = Order.create(CustomerId.from('cust-123'));

      expect(order.status).toBe(OrderStatus.Draft);
      expect(order.items).toHaveLength(0);
    });

    it('emits OrderCreated event', () => {
      const order = Order.create(CustomerId.from('cust-123'));

      expect(order.domainEvents).toHaveLength(1);
      expect(order.domainEvents[0]).toBeInstanceOf(OrderCreated);
    });
  });

  describe('addItem', () => {
    it('adds item to order', () => {
      const order = createDraftOrder();

      order.addItem(ProductId.from('prod-123'), Quantity.create(2), Money.create(10, 'USD'));

      expect(order.items).toHaveLength(1);
    });

    it('throws when order is cancelled', () => {
      const order = createCancelledOrder();

      expect(() => {
        order.addItem(ProductId.from('prod-123'), Quantity.create(1), Money.create(10, 'USD'));
      }).toThrow(InvalidOrderStateError);
    });
  });

  describe('total', () => {
    it('calculates total from all items', () => {
      const order = createDraftOrder();
      order.addItem(ProductId.from('p1'), Quantity.create(2), Money.create(10, 'USD'));
      order.addItem(ProductId.from('p2'), Quantity.create(1), Money.create(25, 'USD'));

      expect(order.total.amount).toBe(45);
    });
  });
});
```

### Value Object Tests

```typescript
describe('Money', () => {
  it('adds two money values with same currency', () => {
    const result = Money.create(10, 'USD').add(Money.create(20, 'USD'));
    expect(result.amount).toBe(30);
  });

  it('throws for different currencies', () => {
    expect(() => Money.create(10, 'USD').add(Money.create(10, 'EUR'))).toThrow(CurrencyMismatchError);
  });

  it('equals money with same amount and currency', () => {
    expect(Money.create(10, 'USD').equals(Money.create(10, 'USD'))).toBe(true);
  });
});
```

### Application Layer Tests

Test use cases with mocked ports.

```typescript
describe('PlaceOrderHandler', () => {
  let handler: PlaceOrderHandler;
  let orderRepo: MockOrderRepository;
  let productRepo: MockProductRepository;
  let eventPublisher: MockEventPublisher;

  beforeEach(() => {
    orderRepo = new MockOrderRepository();
    productRepo = new MockProductRepository();
    eventPublisher = new MockEventPublisher();
    handler = new PlaceOrderHandler(orderRepo, productRepo, eventPublisher);
  });

  it('creates order with items and saves', async () => {
    productRepo.addProduct(createTestProduct('prod-1', 10.00));

    const orderId = await handler.handle({
      customerId: 'cust-123',
      items: [{ productId: 'prod-1', quantity: 2 }],
    });

    const saved = await orderRepo.findById(OrderId.from(orderId));
    expect(saved).not.toBeNull();
    expect(saved!.items).toHaveLength(1);
  });

  it('publishes domain events', async () => {
    productRepo.addProduct(createTestProduct('prod-1', 10.00));

    await handler.handle({
      customerId: 'cust-123',
      items: [{ productId: 'prod-1', quantity: 1 }],
    });

    expect(eventPublisher.publishedEvents[0]).toBeInstanceOf(OrderCreated);
  });

  it('throws when product not found', async () => {
    await expect(handler.handle({
      customerId: 'cust-123',
      items: [{ productId: 'nonexistent', quantity: 1 }],
    })).rejects.toThrow(ProductNotFoundError);
  });
});
```

**Mock pattern:** Implement the port interface with in-memory storage. Add helper methods like `simulateErrorOnSave()` for failure scenarios.

---

## Integration Tests

Test adapters with real infrastructure.

```typescript
describe('PostgresOrderRepository', () => {
  let pool: Pool;
  let repository: PostgresOrderRepository;

  beforeAll(async () => {
    pool = new Pool({ connectionString: process.env.TEST_DATABASE_URL });
    repository = new PostgresOrderRepository(pool);
  });

  beforeEach(async () => {
    await pool.query('TRUNCATE orders, order_items CASCADE');
  });

  afterAll(async () => { await pool.end(); });

  it('persists and retrieves order', async () => {
    const order = Order.create(CustomerId.from('cust-123'));
    order.addItem(ProductId.from('prod-1'), Quantity.create(2), Money.create(10, 'USD'));

    await repository.save(order);
    const retrieved = await repository.findById(order.id);

    expect(retrieved).not.toBeNull();
    expect(retrieved!.items).toHaveLength(1);
    expect(retrieved!.items[0].quantity.value).toBe(2);
  });

  it('returns null for nonexistent order', async () => {
    const result = await repository.findById(OrderId.from('nonexistent'));
    expect(result).toBeNull();
  });
});
```

---

## Architecture Tests

Verify dependency rules are followed.

```typescript
import { filesOfProject } from 'ts-arch';

describe('Architecture', () => {
  it('domain should not depend on infrastructure', async () => {
    const rule = filesOfProject()
      .inFolder('domain')
      .shouldNot()
      .dependOnFiles()
      .inFolder('infrastructure');

    await expect(rule).toPassAsync();
  });

  it('application should not depend on infrastructure', async () => {
    const rule = filesOfProject()
      .inFolder('application')
      .shouldNot()
      .dependOnFiles()
      .inFolder('infrastructure');

    await expect(rule).toPassAsync();
  });

  it('domain should have no external framework dependencies', async () => {
    const rule = filesOfProject()
      .inFolder('domain')
      .shouldNot()
      .dependOnFiles()
      .matchingPattern('node_modules/(express|pg|axios|typeorm)/');

    await expect(rule).toPassAsync();
  });
});
```

---

## Test Fixtures (Builder Pattern)

```typescript
export class OrderBuilder {
  private customerId = CustomerId.from('default-customer');
  private items: Array<{ productId: ProductId; quantity: Quantity; price: Money }> = [];
  private status: 'draft' | 'confirmed' = 'draft';

  withCustomer(id: string): this { this.customerId = CustomerId.from(id); return this; }
  withItem(productId: string, qty: number, price: number): this {
    this.items.push({ productId: ProductId.from(productId), quantity: Quantity.create(qty), price: Money.create(price, 'USD') });
    return this;
  }
  confirmed(): this { this.status = 'confirmed'; return this; }

  build(): Order {
    const order = Order.create(this.customerId);
    for (const item of this.items) order.addItem(item.productId, item.quantity, item.price);
    if (this.status === 'confirmed') { order.setShippingAddress(new AddressBuilder().build()); order.confirm(); }
    order.clearEvents();
    return order;
  }
}
```

---

## Key Principles

1. **Test behavior, not implementation** — focus on what, not how
2. **Domain tests need no mocks** — domain layer is pure
3. **Mock at port boundaries** — application tests mock driven ports
4. **Integration tests use real infra** — test actual database, message broker
5. **Test business rules in domain** — not in application or infrastructure
