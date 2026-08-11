# Tech Stack and Standard Patterns

Use for new projects or new major modules.

## Confirm Stack

Recommend a stack, then ask the user to confirm, edit, or use the default:

```yaml
recommended_stack:
  frontend:
  backend:
  database:
  package_manager:
  build_tool:
  test_framework:
  runtime:
  optional_deployment:
reason:
  - fits current requirement
  - runnable locally
  - supported by Build-and-Ship V1
```

If the user accepts the default:

```text
TECH_STACK_CONFIRMED_BY_DEFAULT
```

## Built-In Patterns

```text
FRONTEND_ONLY_TOOL
Pure frontend utility: calculator, generator, form tool, small game.

FRONTEND_LOCAL_STORAGE
Vue/React + LocalStorage: todo, notes, checklist, personal tracker MVP.

FULLSTACK_CRUD
Frontend + backend API + database: admin tools, records, multi-device persistence.

SPRING_BOOT_MYSQL
Java backend with MySQL: enterprise-style management systems.

FASTAPI_SQLITE_POSTGRES
Python API with SQLite/PostgreSQL: AI tools, lightweight services.
```

## Selection Rules

```text
Can be pure frontend -> do not add backend.
Can use LocalStorage -> do not add database service.
Needs multi-device/users/service persistence -> add backend and database.
User requests Java -> prefer Spring Boot + MySQL.
User requests Python or AI tooling -> prefer FastAPI + SQLite first, PostgreSQL later.
```

Choose the lightest stack that can satisfy the confirmed PRD.
