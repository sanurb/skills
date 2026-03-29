# Relationship Patterns

Evans Blue Book Ch.14, Vernon IDDD Ch.3. Use exactly one per context pair.

| Pattern | Direction | Definition | Use when |
|---------|-----------|------------|----------|
| **Partnership** | Symmetric | Two teams coordinate planning and evolution together. Failure in one blocks the other. | Both teams succeed or fail together; tight coordination is accepted. |
| **Shared Kernel** | Symmetric | Two contexts share a small, explicitly agreed subset of the model. Changes require both teams. | Small overlap is cheaper to share than to translate. |
| **Customer-Supplier** | Upstream → Downstream | Upstream supplies what downstream needs. Downstream has influence over upstream priorities. | Downstream can negotiate; upstream is responsive. |
| **Conformist** | Upstream → Downstream | Downstream adopts upstream's model as-is. No translation, no negotiation. | Upstream won't adapt; downstream accepts the cost. |
| **Anticorruption Layer** | Upstream → Downstream | Downstream translates upstream's model into its own via an isolation layer. | Upstream model is foreign or hostile; downstream must protect its language. |
| **Open Host Service** | Upstream → Downstream(s) | Upstream exposes a well-defined protocol for any consumer. | Multiple downstream consumers; upstream publishes a stable API. |
| **Published Language** | Upstream → Downstream(s) | A shared, documented interchange format (often paired with Open Host Service). | Data exchange needs a standard format (JSON schema, Protobuf, events). |
| **Separate Ways** | None | Contexts have no integration. Each solves overlapping problems independently. | Integration cost exceeds duplication cost. |
| **Big Ball of Mud** | None | No clear boundaries. Used to label existing legacy, never to prescribe. | Describing a legacy system that has no discernible context boundaries. |
