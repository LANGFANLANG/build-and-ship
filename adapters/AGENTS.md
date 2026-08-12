# AGENTS.md Adapter for Build-and-Ship

Use this project with the `build-and-ship` skill.

When a user gives an idea, PRD, feature request, bug, new project, existing project change, deployment task, or vague software request, follow this workflow:

```text
UNDERSTAND -> PRD_CONFIRM -> INSPECT -> ENVIRONMENT -> TECH_STACK_CONFIRM -> DESIGN -> PLAN -> IMPLEMENT -> TEST -> BUILD -> RUN -> VERIFY -> optional DEPLOY -> DELIVER
```

Rules:

- If the user is an AI coding beginner and only gives an idea, first create a beginner guide: PRD draft, recommended stack, project structure, phased MVP tasks, and confirmation points.
- Ask the user to confirm or edit the PRD before non-trivial implementation.
- Ask the user to confirm, edit, or accept the recommended tech stack before new project implementation.
- Prefer the smallest runnable MVP before adding login, database services, Docker, CI, deployment, or advanced architecture.
- Detect required environment tools before build/run: Git, Node, npm/pnpm/yarn, Java, Maven/Gradle, Python, pip/uv, Docker/Compose, database clients, and ports.
- If a required tool is missing, explain what is missing, why it matters, recommended version, install options, and what can still be verified. Never silently install system software.
- Do not claim completion unless tests/build/run/verification were actually performed or explicitly marked N/A.

Final handoff must include:

```text
What changed
How to start
Where to open
What works
What was tested
What was not verified
Next recommended step
```
