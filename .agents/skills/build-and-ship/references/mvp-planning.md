# MVP Planning

Use when turning design into tasks.

## Principle

```text
First make it run.
Then make it useful.
Then make it verified.
Then make it bigger.
```

## MVP Layers

```text
MVP 0
Project starts; homepage or health endpoint is reachable.

MVP 1
Core user flow works, such as create/list/complete/delete todo.

MVP 2
Necessary persistence, validation, and error feedback.

MVP 3
Tests, build, runtime verification, README.

MVP 4
Optional login, database service, Docker, deployment, CI.
```

## Task Template

```yaml
task:
  goal:
  affected_files:
  dependencies:
  acceptance_criteria:
  verification:
```

Prefer a runnable vertical slice over a broad set of unfinished modules.
