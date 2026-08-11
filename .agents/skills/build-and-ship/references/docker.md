# Docker

Use only when Docker is requested, already present in the project, or needed for deployment.

## Decision

```text
User requested Docker -> Docker Flow
Project already has Dockerfile/compose -> keep Docker working
Deployment task needs containers -> propose Docker
Otherwise -> Docker: N/A
```

## Flow

```text
Analyze services
  -> Dockerfile
  -> Compose if needed
  -> Environment variables
  -> Docker build
  -> Docker run
  -> Health check
  -> Application verification
```

## Verification

```bash
docker compose build
docker compose up -d
docker compose ps
```

Then verify HTTP endpoints or core user flows.

Do not hard-code secrets. Prefer `.env.example`; keep `.env` ignored.
