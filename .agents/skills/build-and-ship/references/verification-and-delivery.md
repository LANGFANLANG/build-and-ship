# Verification and Delivery

Use for test/build/run/verify and final reporting.

## Verification Ladder

```text
Test
  -> Build
  -> Run
  -> Process check
  -> Port check
  -> HTTP or functional smoke test
```

Examples:

```text
Node/Vue/React: npm test, npm run build, npm run dev
Spring Boot: mvn test, mvn clean package, mvn spring-boot:run
Python: pytest, python -m compileall ., uvicorn app.main:app
```

## Final Report

```text
BUILD & SHIP REPORT

Requirement confirmation:
PRD:
Tech stack:
Environment:

What changed:

How to start:

Where to open:

What works:

What was tested:

What was not verified:

Docker:

Next recommended step:
```

Use `DELIVERED` only when required gates passed. Use `PARTIALLY_VERIFIED` with clear reasons when something could not be run.
