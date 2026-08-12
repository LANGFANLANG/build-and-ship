# Beginner Guide

Use this when the user is new, vague, or starting from an idea.

Primary target: AI coding beginners who may only have a product idea and do not know PRD writing, stack selection, project structure, environment setup, testing, or delivery. The agent must turn the idea into a concrete path toward a runnable program.

## Required Output

Before coding, produce:

```text
1. PRD draft
2. Recommended tech stack
3. Project structure draft
4. Phased task list
5. User confirmation points
```

## Example

For "I want to build a todo app":

```yaml
beginner_guide:
  prd_draft:
    goal: Build a locally runnable todo app
    users:
      - Personal user
    core_features:
      - Create todo
      - List todos
      - Mark todo complete
      - Delete todo
    out_of_scope:
      - Team collaboration
      - Cloud sync
      - Admin dashboard

  recommended_stack:
    option: Vue3 + Vite + LocalStorage
    reason: Few dependencies, fast feedback, good first runnable app

  project_structure:
    - src/App.vue
    - src/components/TodoForm.vue
    - src/components/TodoList.vue
    - src/stores/todos.ts

  phased_tasks:
    - Start empty app
    - Add create/list flow
    - Add complete/delete flow
    - Add persistence
    - Build and browser-smoke-test

  user_confirmations:
    - Confirm or edit PRD
    - Confirm or edit tech stack
    - Confirm smallest runnable version first
```

Goal: remove the blank page. Do not overwhelm the user with enterprise architecture.

## Beginner Contract

For beginner idea-to-app requests, the first response should make the next step obvious:

```text
Here is my understanding of your idea.
Here is a small PRD you can edit.
Here is the recommended stack and why.
Here is the smallest runnable version we will build first.
Here is what I need you to confirm before I create files.
```

Do not ask the beginner to invent technical details from scratch. Offer a default and let them accept or edit it.
