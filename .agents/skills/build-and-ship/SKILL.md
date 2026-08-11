---
name: build-and-ship
description: Use when a user wants to turn an idea, PRD, feature request, bug fix, new project, existing project change, deployment task, Docker task, or vague software request into a runnable, tested, verified, and clearly delivered program.
---

# Build and Ship

## Overview

Build-and-Ship turns software requests into working software by forcing the agent through confirmed requirements, project/environment discovery, smallest runnable implementation, tests, build, runtime verification, and concrete handoff.

Core rule:

```text
Code written is not task done.
Task done means implemented, tested, built, run, verified, and reported.
```

## Required Workflow

Follow these gates in order. Do not skip a confirmation gate unless the user explicitly says to use the default.

```text
G1  UNDERSTAND
G2  PRD_CONFIRM
G3  INSPECT
G4  ENVIRONMENT
G5  TECH_STACK_CONFIRM
G6  DESIGN
G7  PLAN
G8  IMPLEMENT
G9  TEST
G10 BUILD
G11 RUN
G12 VERIFY
G13 DEPLOY optional
G14 DELIVER
```

## Resource Routing

Load only the files needed for the current stage:

| Stage | Read |
|---|---|
| New or vague request | `references/beginner-guide.md`, `references/prd-confirmation.md` |
| Existing project | `references/project-discovery.md` |
| Missing Java/Python/Node/Docker/etc. | `references/environment-discovery.md` |
| New project or major module | `references/tech-stack-and-patterns.md` |
| Planning work | `references/mvp-planning.md` |
| Testing/build/runtime handoff | `references/verification-and-delivery.md` |
| Docker requested or already present | `references/docker.md` |

## Script Routing

Use bundled scripts when deterministic checks are useful:

| Need | Script |
|---|---|
| Detect current project type | `scripts/detect_project.ps1` |
| Detect installed runtimes and ports | `scripts/detect_environment.ps1` |
| Wait for HTTP readiness | `scripts/wait_for_http.ps1` |
| Save a lightweight evidence report | `scripts/collect_evidence.ps1` |

If PowerShell is unavailable, perform equivalent shell-native checks. If Python is missing, report it through the environment diagnostic rather than blocking unrelated work.

## Confirmation Rules

- For non-trivial new work, produce a PRD draft and ask the user to confirm or edit it before implementation.
- For new projects or new major modules, recommend a tech stack and ask the user to confirm, edit, or accept the default.
- If the user says "use your recommendation", mark the gate as confirmed by default and continue.
- For existing projects, follow the existing architecture unless the user explicitly asks for a change.

## Environment Rules

- Detect required tools before build/run: Git, Node, package manager, Java, Maven/Gradle, Python, Docker, database clients, and ports.
- If a required runtime is missing, report what is missing, why it matters, recommended version, install options, and what can still be verified.
- Never silently install system software. Ask before automatic installation or configuration.
- If the user declines installation, continue only with gates that do not require that tool and mark delivery as `PARTIALLY_VERIFIED`.

## Completion Contract

Default delivery requires:

```text
Requirement            PASS
PRD Confirmation       PASS / N/A
Project Understanding  PASS
Environment            PASS / PARTIAL
Tech Stack             PASS / EXISTING
Implementation         PASS
Test                   PASS
Build                  PASS / N/A
Runtime                PASS / N/A
Verification           PASS
Docker                 PASS / N/A
```

Use `DELIVERED` only when the required gates are truly verified. Use `PARTIALLY_VERIFIED` when code exists but an environment, external service, credential, database, hardware, or optional deployment target prevented full verification.

## Final Response Shape

Always include the concrete handoff:

```text
What changed
How to start
Where to open
What works
What was tested
What was not verified
Next recommended step
```

## Common Mistakes

| Mistake | Correction |
|---|---|
| Starts coding from a vague idea | First draft PRD and acceptance criteria |
| Picks a stack silently | Recommend and confirm stack |
| Says "Python is missing" only | Give diagnostic report and next action |
| Builds a large system first | Ship the smallest runnable vertical slice |
| Reports "should work" | Run tests/build/app and provide evidence |
| Makes Docker mandatory | Use Docker only when requested, existing, or deployment requires it |
