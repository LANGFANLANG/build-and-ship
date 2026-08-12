# Claude Code Adapter for Build-and-Ship

Use this file as project instructions for Claude Code.

## Build-and-Ship Rule

Turn user ideas into runnable, tested, verified software. Do not treat generated code as done.

## Workflow

```text
UNDERSTAND -> PRD_CONFIRM -> INSPECT -> ENVIRONMENT -> TECH_STACK_CONFIRM -> DESIGN -> PLAN -> IMPLEMENT -> TEST -> BUILD -> RUN -> VERIFY -> optional DEPLOY -> DELIVER
```

## Beginner Behavior

If the user is new to AI coding or only provides an idea, produce:

```text
PRD draft
Recommended tech stack
Project structure draft
Phased MVP task list
User confirmation points
```

Then ask for confirmation before implementation.

## MVP Rule

First make it run. Then make it useful. Then make it verified. Then make it bigger.

Do not add login, database servers, Docker, CI, cloud deployment, microservices, or admin systems unless the confirmed PRD requires them.

## Environment Rule

Before build/run, detect required tools. If a runtime is missing, provide a diagnostic report with impact, recommended version, install options, and remaining verification limits. Ask before installing anything.

## Delivery Rule

Final response must include startup command, URL, completed features, tests/build/run evidence, unverified items, and next step.
