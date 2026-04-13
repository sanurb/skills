# OpenCollection Spec Summary

Condensed from https://spec.opencollection.com/ (`v1.0.0`). Use this as the minimum schema mental model when generating `etc/http/`.

## Collection Root

`opencollection.yml` is the collection root. In practice, keep these top-level keys:

```yml
opencollection: 1.0.0
info:
  name: Example API
runtime:
  scripts: []
docs:
  content: |-
    Markdown docs
  type: text/markdown
bundled: false
extensions: {}
```

## Items

The spec supports item types for:

- HTTP request
- GraphQL request
- gRPC request
- WebSocket request
- Folder
- Script

This skill scaffolds HTTP + folder items because that matches the reference collection.

## HTTP Request Shape

Each request file should use OpenCollection YAML with these common sections:

```yml
info:
  name: Get Resource
  type: http
  seq: 1
  tags:
    - regression
    - read-only

http:
  method: GET
  url: "{{baseUrl}}/v1/resources/{{resourceId}}"
  headers: []
  auth: inherit

runtime:
  assertions: []
  scripts: []

settings:
  encodeUrl: true
  timeout: 5000

docs: |-
  # Human-readable request docs
```

## Folder Shape

Folders are also OpenCollection YAML items:

```yml
info:
  name: Billing
  type: folder

docs: |-
  # Billing
```

Folder-level auth overrides are valid and useful for slices like `observability/`.

## Environments

The reference uses Bruno environment JSON files under `environments/`:

```json
{
  "info": {
    "type": "bruno-environment",
    "name": "local"
  },
  "variables": [
    {
      "name": "baseUrl",
      "value": "http://localhost:3000",
      "type": "text",
      "enabled": true,
      "secret": false
    }
  ]
}
```

Keep secrets out of committed JSON. Use `{{process.env.NAME}}` for secret variables.

## Auth

The spec has built-in auth models including none, bearer, basic, apiKey, and OAuth 2.0.

Use these rules:

- Collection-level auth for the common default
- Folder-level auth only for real slice-wide overrides
- Request-level `auth: inherit` unless the request truly differs

## Variables

The spec supports variable interpolation. The reference pattern is:

- environment JSON defines stable per-env variables (`baseUrl`, `resourceId`)
- `.env` provides secrets
- environment JSON references secrets through `{{process.env.BEARER_TOKEN}}`
- collection/request YAML consumes `{{baseUrl}}`, `{{resourceId}}`, `{{bearerToken}}`

## Scripts and Lifecycle

The spec supports scripts and runtime lifecycle hooks.

Use collection-level runtime scripts for shared setup, for example:

```yml
runtime:
  scripts:
    - type: before-request
      code: bru.setVar("correlationId", bru.interpolate("{{$randomUUID}}"));
```

Put reusable JS helpers in `etc/http/lib.js` and import them from request test scripts.

## What the Spec Does NOT Decide

The spec gives the file schema. It does **not** decide:

- your domain folder names
- your tag taxonomy
- your secret naming scheme
- your contract assertions

That is repo architecture. Keep it explicit in `ARCHITECTURE.md`.
