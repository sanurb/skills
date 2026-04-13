# Templates

Generic starter templates for a Bruno/OpenCollection `etc/http/` tree.

## `opencollection.yml`

```yml
opencollection: 1.0.0
info:
  name: PROJECT_NAME API Collection

auth:
  type: bearer
  bearer:
    token: "{{bearerToken}}"

runtime:
  scripts:
    - type: before-request
      code: bru.setVar("correlationId", bru.interpolate("{{$randomUUID}}"));

docs:
  content: |-
    # PROJECT_NAME API Collection
    Domain-first HTTP collection organized by bounded context.
  type: text/markdown
bundled: false
extensions: {}
```

## Environment JSON

Use the same shape for `local.json`, `staging.json`, and `production.json`.

```json
{
  "info": { "type": "bruno-environment", "name": "local" },
  "variables": [
    { "name": "baseUrl", "value": "http://localhost:3000", "type": "text", "enabled": true, "secret": false },
    { "name": "resourceId", "value": "replace-me", "type": "text", "enabled": true, "secret": false },
    { "name": "bearerToken", "value": "{{process.env.BEARER_TOKEN}}", "type": "text", "enabled": true, "secret": true }
  ]
}
```

## `.env.sample`

```dotenv
BEARER_TOKEN=replace-me
```

## `.gitignore`

```gitignore
.env
.bruno/
```

## `lib.js`

```js
function assertProblemDetails(body) {
  expect(body).to.have.property("type");
  expect(body.type).to.be.a("string");
  expect(body).to.have.property("title");
  expect(body.title).to.be.a("string");
  expect(body).to.have.property("status");
  expect(body.status).to.be.a("number");
}

function assertJsonContentType(headers) {
  expect(headers["content-type"]).to.be.a("string").and.to.include("json");
}

module.exports = { assertProblemDetails, assertJsonContentType };
```

## `observability/folder.yml`

```yml
info:
  name: Observability
  type: folder

auth:
  type: none

docs: |-
  # Observability
  Unauthenticated platform probes such as liveness and readiness.
```

## `observability/liveness.yml`

```yml
info:
  name: Liveness Probe
  type: http
  seq: 1
  tags: [smoke, regression, platform]

http:
  method: GET
  url: "{{baseUrl}}/healthz"
  headers:
    - name: Accept
      value: application/json
  auth: inherit

runtime:
  assertions:
    - expression: res.status
      operator: eq
      value: "200"

settings:
  encodeUrl: true
  timeout: 2000

docs: |-
  # Liveness Probe
  **GET** `/healthz`
```

## `domain-context/folder.yml`

```yml
info:
  name: Domain Context
  type: folder

docs: |-
  # Domain Context
  Replace this placeholder with a real bounded context.
```

## `domain-context/get-resource.yml`

```yml
info:
  name: Get Resource
  type: http
  seq: 1
  tags: [regression, read-only]

http:
  method: GET
  url: "{{baseUrl}}/v1/resources/{{resourceId}}"
  headers:
    - name: Accept
      value: application/json, application/problem+json
    - name: correlation-id
      value: "{{correlationId}}"
  auth: inherit

runtime:
  scripts:
    - type: tests
      code: |-
        const { assertProblemDetails, assertJsonContentType } = require("../lib.js");
        test("response is JSON", function() { assertJsonContentType(res.headers); });
        if (res.status >= 400) {
          test("error follows problem details", function() { assertProblemDetails(res.body); });
        }

settings:
  encodeUrl: true
  timeout: 5000

docs: |-
  # Get Resource
  **GET** `/v1/resources/:resourceId`
```

## Brownfield Rule

Create only missing root files. If real domain folders already exist, keep them and do not add a placeholder `domain-context/` folder.
