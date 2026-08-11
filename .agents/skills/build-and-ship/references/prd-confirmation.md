# PRD Confirmation

Use for new projects, larger features, refactors, migrations, and deployment work.

## PRD Template

```yaml
prd:
  project_goal:
  users:
  core_features:
  out_of_scope:
  workflows:
  screens_or_apis:
  data:
  acceptance_criteria:
  constraints:
  open_questions:
```

## Confirmation Flow

```text
Draft PRD
  -> Ask user to confirm or edit
  -> Apply feedback
  -> Mark PRD_CONFIRMED
  -> Continue
```

If the user says to proceed with defaults:

```text
PRD_CONFIRMED_BY_USER_DEFAULT
```

Still include the PRD summary in the final report.
