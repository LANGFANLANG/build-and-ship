# Project Discovery

Use before modifying an existing project.

## Scan

Look for:

```text
README.md
AGENTS.md
CLAUDE.md
GEMINI.md
.git
package.json
pnpm-lock.yaml
yarn.lock
pom.xml
build.gradle
requirements.txt
pyproject.toml
Dockerfile
compose.yaml
docker-compose.yml
.env.example
src/
test/
tests/
```

## Output

```json
{
  "projectType": "fullstack",
  "frontend": {
    "framework": "vue",
    "build": "vite",
    "packageManager": "npm"
  },
  "backend": {
    "language": "java",
    "framework": "spring-boot",
    "build": "maven"
  },
  "database": "mysql",
  "docker": false
}
```

## Existing Project Rule

Follow existing architecture. Do not replace frameworks because of preference. Ask before introducing a major runtime, database, framework, or deployment path.
