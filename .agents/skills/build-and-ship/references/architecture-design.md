# Architecture Design and Review

Use this reference for new projects and for changes that introduce or alter a major module, service boundary, public API, data model, authentication or authorization boundary, external integration, deployment topology, migration, or cross-cutting quality attribute.

## Architecture Gate

Architecture work has an inspectable artifact and an explicit approval state:

```text
DESIGN_REQUIRED
  -> write docs/architecture/YYYY-MM-DD-<topic>.md
  -> DESIGN_IN_REVIEW
  -> user reviews or edits the document
  -> DESIGN_APPROVED
  -> PLAN
  -> IMPLEMENT
```

After writing the document, give the user a link and a short decision summary, then stop before planning or implementation. Approval must be a response to the produced document. Earlier statements such as "use your recommendation", "use defaults", "do not ask questions", or "just build it" may confirm the PRD or stack, but do not approve a document the user has not seen.

If the user edits the file, read it again before treating it as approved. Record approval in the document. During implementation, a material change to service boundaries, public interfaces, data ownership or schema, security boundaries, major dependencies, deployment topology, migration, or rollback strategy returns the document to `DESIGN_IN_REVIEW`.

Use `DESIGN_NA` for a localized change whose implementation does not make an architectural decision, such as copy, styling, a narrowly scoped bug fix, or an internal refactor that preserves interfaces and data flow. State the reason briefly; do not create ceremony for trivial work.

## Selection Method

Do not present a catalog as though every pattern is required. Select two or three viable candidates, compare them against the confirmed requirements and constraints, recommend one, and explain why the others were not selected.

Prefer the least complex mature design that meets current requirements:

1. Preserve the existing architecture unless the task requires changing it.
2. Prefer a modular monolith before distributed services for a new business application.
3. Prefer a relational database for transactional, strongly related business data.
4. Add asynchronous messaging, caches, search engines, or separate services only when a stated workload or quality attribute justifies them.
5. Separate domain logic from frameworks when the domain or external integrations are complex enough to benefit; do not add abstraction layers mechanically.

## Mature Solution Shortlist

### Application structure

| Candidate | Good fit | Main trade-off |
|---|---|---|
| Simple layered application | Small CRUD products, admin tools, short-lived MVPs | Fast and familiar; boundaries can erode as the domain grows |
| Modular monolith | Most new business systems and teams needing clear module ownership | Strong boundaries without distributed operations; requires module discipline |
| Hexagonal or clean architecture inside selected modules | Rich domain logic, multiple adapters, demanding automated tests | Protects core logic; excessive for thin CRUD |
| Microservices | Independently scaled or deployed domains with mature platform ownership | Organizational and scaling independence at substantial operational cost |

Default: a modular monolith with simple layers inside each module. Use hexagonal boundaries only around meaningful domain or integration complexity. Do not recommend microservices merely for future scale.

### Web delivery

| Candidate | Good fit | Main trade-off |
|---|---|---|
| SPA plus API | Authenticated applications and rich client interaction | Clear separation; more client state and API coordination |
| Server-rendered full-stack application | Content, SEO, fast first render, simpler end-to-end delivery | Tighter frontend/backend coupling |
| Backend for Frontend (BFF) | Multiple client types or aggregation of several backend services | Client-focused API; one more deployable component |

### Data and consistency

| Candidate | Good fit | Main trade-off |
|---|---|---|
| Relational database | Transactions, orders, billing, inventory, permissions | Schema discipline and migrations are required |
| Document database | Aggregate-shaped, flexible documents with limited cross-record transactions | Flexible shape; weaker fit for relational queries and invariants |
| Cache beside a source of truth | Measured read latency or throughput problem | Invalidation, staleness, and operational complexity |
| Transactional outbox | Reliable publication of events after a database transaction | Extra table, relay, idempotency, and monitoring |

Do not use a cache as the source of truth. For payment, inventory, or order workflows, make idempotency and transaction boundaries explicit.

### Integration and communication

| Candidate | Good fit | Main trade-off |
|---|---|---|
| Synchronous HTTP/REST | Immediate response, simple internal or external integration | Runtime coupling and cascading latency |
| Asynchronous queue or event | Background work, retries, load leveling, loose timing | Eventual consistency, duplicate handling, observability |
| In-process domain events | Decoupling modules within one process | Not durable; handlers share process fate |
| Transactional outbox plus broker | Business transaction and durable event publication must agree | Stronger reliability with more infrastructure |

Use in-process events when durability is unnecessary. Use a queue for asynchronous work. Add an outbox when losing a committed business event is unacceptable.

### Identity and deployment

| Candidate | Good fit | Main trade-off |
|---|---|---|
| Server session with secure cookie | Browser-first application under one trust boundary | Server-side/session-store lifecycle |
| OIDC/OAuth through a mature identity provider | SSO, multiple applications, enterprise or social identity | Provider integration and redirect/token complexity |
| Signed access tokens | APIs crossing trust boundaries with clear token lifecycle | Revocation and storage mistakes are easy |
| Single deployable or managed platform | Early product and ordinary business application | Limited independent scaling |
| Containers/Compose | Reproducible multi-service local or server deployment | Image, networking, secret, and health-check operations |

Do not build custom password or token protocols when a mature framework or identity provider fits. Do not add Kubernetes unless deployment scale and operational ownership justify it.

## Common Reference Architectures

Use these as starting points, then tailor them to the confirmed PRD:

```text
Local-first tool
UI -> local state/storage
```

```text
Ordinary business application (default)
Web UI -> modular monolith -> relational database
                         -> optional object storage
```

```text
Transactional system with reliable side effects
Client -> application -> relational database
                         -> outbox -> worker/broker -> notification or external service
```

```text
Integration or AI workload
Client/API -> application -> job queue -> worker -> external model/service
                         -> relational job state + object storage
```

## Required Architecture Document

Create `docs/architecture/` if needed and write one Markdown file using this shape. Keep sections proportional to the task; concise is acceptable, omission of an applicable decision is not.

```markdown
# <Topic> Architecture

Status: DESIGN_IN_REVIEW
Date: YYYY-MM-DD
Scope: <new project or affected modules>
Related PRD: <path or summary>

## Context and goals
- Problem and users
- Goals and non-goals
- Constraints and quality attributes

## Existing system
- Relevant components, dependencies, and conventions
- Current limitations (use N/A for a new project)

## Candidate solutions
| Candidate | Advantages | Disadvantages | Fit |
|---|---|---|---|

## Decision
- Recommended solution and rationale
- Why rejected candidates were not selected
- Assumptions that would change the decision

## Components and boundaries
- Responsibilities and dependencies
- Primary request, event, or job flows

## Data and interfaces
- Ownership, schema changes, transactions, and consistency
- APIs, events, compatibility, and idempotency

## Cross-cutting concerns
- Authentication and authorization
- Security and privacy
- Reliability, error handling, and recovery
- Observability and performance

## Delivery and operations
- Migration and backward compatibility
- Deployment and configuration
- Rollback strategy

## Verification strategy
- Unit, integration, contract, end-to-end, and operational checks as applicable

## Risks and open questions
- Risk, impact, mitigation, and owner/decision needed

## Approval
- Status: DESIGN_IN_REVIEW
- Approved by:
- Approved at:
- Review notes:
```

Diagrams are optional. Add a small Mermaid context, container, component, sequence, or deployment diagram only when it clarifies boundaries or flow better than prose.

## Approval Response

When the document is ready, report:

```text
Architecture document: <path>
Recommended solution: <one sentence>
Key trade-offs: <short list>
Open decisions: <short list or none>
Status: DESIGN_IN_REVIEW
Next action: review/edit the document and explicitly approve it; implementation has not started.
```

## Common Mistakes

| Mistake | Correction |
|---|---|
| Treats stack confirmation as design approval | Architecture approval is separate and follows delivery of the document |
| Uses "just build it" to bypass review | For architecture-required work, stop at `DESIGN_IN_REVIEW` |
| Lists patterns without making a decision | Compare two or three candidates and recommend one against explicit criteria |
| Defaults to microservices or event-driven architecture | Start with a modular monolith and synchronous flow unless requirements justify more |
| Adds every possible section in depth | Keep the document proportional while covering applicable risks |
| Design and implementation diverge silently | Update the document and re-enter review for material changes |

## Red Flags

- Planning implementation tasks before architecture approval
- Editing production code while status is `DESIGN_IN_REVIEW`
- Claiming an unseen document was approved by a prior default instruction
- Choosing infrastructure because it is fashionable rather than required
- Omitting migration, rollback, security, or consistency decisions when they apply

Any red flag means stop and return to the architecture gate.
