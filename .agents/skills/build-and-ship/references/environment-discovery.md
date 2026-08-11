# Environment Discovery

Use when checking whether the machine can test, build, run, or deploy the project.

## Check

```text
OS
Git
Node
npm / pnpm / yarn
Java / JDK
Maven / Gradle
Python
pip / uv
Docker
Docker Compose
Database clients
Ports
```

## Diagnostic Report

When something is missing, output:

```text
Environment diagnostic

Missing: JDK 21

Impact: This Spring Boot project needs JDK 21 to compile, test, and run the backend.

Recommended: Temurin JDK 21 LTS

Install options:
1. User installs manually
2. User allows the agent to try automatic installation/configuration

If not installed:
Implementation can continue, but Build, Run, and Runtime Verification cannot be completed.

User confirmation needed:
May I try to install JDK 21?
```

Base the report on actual command/script evidence. Do not mark a tool missing unless the command check failed or the project explicitly requires a tool that cannot be found.

## Status Labels

```text
REQUIRED_BLOCKER
Cannot continue the next critical gate without this.

REQUIRED_FOR_VERIFICATION
Can implement, but cannot fully build/run/verify.

OPTIONAL
Only affects optional capability such as Docker deployment.
```

Never silently install system software. Never fake verification.
