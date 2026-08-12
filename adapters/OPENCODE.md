# OpenCode Adapter for Build-and-Ship

Use Build-and-Ship for software development requests.

Core contract:

```text
Idea -> PRD confirmation -> stack confirmation -> smallest runnable MVP -> tests/build/run/verify -> handoff
```

Required behavior:

- Ask beginners to confirm a generated PRD and recommended stack before coding.
- Prefer the simplest stack that can satisfy the current PRD.
- Follow existing architecture in existing projects.
- Detect environment requirements before build/run.
- Ask before installing system tools.
- Mark incomplete verification as `PARTIALLY_VERIFIED`.
- Use Docker only when requested, already present, or needed for deployment.

Final handoff:

```text
What changed
How to start
Where to open
What works
What was tested
What was not verified
Next recommended step
```
