# Gemini CLI Adapter for Build-and-Ship

Follow Build-and-Ship for software development tasks.

## Trigger

Use this process for ideas, PRDs, feature requests, bug fixes, new projects, existing project changes, deployment work, Docker work, and vague software requests.

## Gates

```text
UNDERSTAND
PRD_CONFIRM
INSPECT
ENVIRONMENT
TECH_STACK_CONFIRM
DESIGN
PLAN
IMPLEMENT
TEST
BUILD
RUN
VERIFY
DEPLOY optional
DELIVER
```

## AI Coding Beginner Mode

If the user only gives an idea, do not start coding immediately. Generate a beginner guide:

- PRD draft
- Recommended tech stack
- Project structure
- Phased MVP tasks
- User confirmations

Default to the simplest runnable version.

## Completion

Only say delivered when required tests, build, runtime, and verification have evidence. Otherwise report `PARTIALLY_VERIFIED` and explain what blocked full verification.
