#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$PWD}"
HTTP_DIR="$ROOT/etc/http"
ENV_DIR="$HTTP_DIR/environments"
OBS_DIR="$HTTP_DIR/observability"
DOMAIN_DIR="$HTTP_DIR/domain-context"
PROJECT_NAME="$(basename "$ROOT")"
COLLECTION_NAME="$PROJECT_NAME API Collection"

mkdir -p "$HTTP_DIR" "$ENV_DIR"

write_if_missing() {
  local path="$1"
  if [[ -e "$path" ]]; then
    return 0
  fi
  mkdir -p "$(dirname "$path")"
  cat > "$path"
}

has_real_domain_folders() {
  local entry name
  shopt -s nullglob
  for entry in "$HTTP_DIR"/*/; do
    [[ -d "$entry" ]] || continue
    name="$(basename "$entry")"
    case "$name" in
      environments|observability|domain-context)
        ;;
      *)
        return 0
        ;;
    esac
  done
  return 1
}

write_if_missing "$HTTP_DIR/opencollection.yml" <<EOF
opencollection: 1.0.0

info:
  name: $COLLECTION_NAME

auth:
  type: bearer
  bearer:
    token: "{{bearerToken}}"

runtime:
  scripts:
    - type: before-request
      code: bru.setVar("correlationId", bru.interpolate("{{\$randomUUID}}"));

docs:
  content: |-
    # $COLLECTION_NAME

    Domain-first HTTP collection organized by bounded context.

    ## Starter layout

    - \`observability/\` for health and platform probes
    - domain folders for real business capabilities
    - \`environments/*.json\` for non-secret variables
    - \`.env\` for secrets
  type: text/markdown
bundled: false
extensions: {}
EOF

write_if_missing "$HTTP_DIR/.env.sample" <<'EOF'
# Copy to .env and fill with real values. Never commit .env.
BEARER_TOKEN=replace-me
EOF

write_if_missing "$HTTP_DIR/.gitignore" <<'EOF'
# Secrets
.env

# Bruno cache
.bruno/
EOF

write_if_missing "$HTTP_DIR/lib.js" <<'EOF'
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

module.exports = {
  assertProblemDetails,
  assertJsonContentType,
};
EOF

write_if_missing "$HTTP_DIR/ARCHITECTURE.md" <<'EOF'
# HTTP Collection Architecture

## Structural Rules

1. Top-level folders represent business capabilities, never HTTP verbs.
2. `opencollection.yml` is the collection root; request and folder files use `.yml`.
3. `environments/*.json` store non-secret variables.
4. `.env` stores secrets and stays gitignored.
5. `lib.js` holds shared assertions and reusable test helpers.
6. Every request has tags and `docs:`.
EOF

write_if_missing "$ENV_DIR/local.json" <<'EOF'
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
    },
    {
      "name": "resourceId",
      "value": "replace-me",
      "type": "text",
      "enabled": true,
      "secret": false
    },
    {
      "name": "bearerToken",
      "value": "{{process.env.BEARER_TOKEN}}",
      "type": "text",
      "enabled": true,
      "secret": true
    }
  ]
}
EOF

write_if_missing "$ENV_DIR/staging.json" <<'EOF'
{
  "info": {
    "type": "bruno-environment",
    "name": "staging"
  },
  "variables": [
    {
      "name": "baseUrl",
      "value": "https://staging.example.com",
      "type": "text",
      "enabled": true,
      "secret": false
    },
    {
      "name": "resourceId",
      "value": "replace-me",
      "type": "text",
      "enabled": true,
      "secret": false
    },
    {
      "name": "bearerToken",
      "value": "{{process.env.BEARER_TOKEN}}",
      "type": "text",
      "enabled": true,
      "secret": true
    }
  ]
}
EOF

write_if_missing "$ENV_DIR/production.json" <<'EOF'
{
  "info": {
    "type": "bruno-environment",
    "name": "production"
  },
  "variables": [
    {
      "name": "baseUrl",
      "value": "https://api.example.com",
      "type": "text",
      "enabled": true,
      "secret": false
    },
    {
      "name": "resourceId",
      "value": "replace-me",
      "type": "text",
      "enabled": true,
      "secret": false
    },
    {
      "name": "bearerToken",
      "value": "{{process.env.BEARER_TOKEN}}",
      "type": "text",
      "enabled": true,
      "secret": true
    }
  ]
}
EOF

write_if_missing "$OBS_DIR/folder.yml" <<'EOF'
info:
  name: Observability
  type: folder

auth:
  type: none

docs: |-
  # Observability

  Unauthenticated platform probes such as liveness and readiness.
EOF

write_if_missing "$OBS_DIR/liveness.yml" <<'EOF'
info:
  name: Liveness Probe
  type: http
  seq: 1
  tags:
    - smoke
    - regression
    - platform

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
EOF

if ! has_real_domain_folders; then
  write_if_missing "$DOMAIN_DIR/folder.yml" <<'EOF'
info:
  name: Domain Context
  type: folder

docs: |-
  # Domain Context

  Replace this placeholder with a real bounded context.
EOF

  write_if_missing "$DOMAIN_DIR/get-resource.yml" <<'EOF'
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

        test("response is JSON", function() {
          assertJsonContentType(res.headers);
        });

        if (res.status >= 400) {
          test("error follows problem details", function() {
            assertProblemDetails(res.body);
          });
        }

settings:
  encodeUrl: true
  timeout: 5000

docs: |-
  # Get Resource

  **GET** `/v1/resources/:resourceId`
EOF
fi

echo "Scaffolded $HTTP_DIR"
