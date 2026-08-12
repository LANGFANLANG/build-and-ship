# Build-and-Ship Coding Skill

Build-and-Ship 是一套面向 Coding Agent 的端到端软件开发 Skill。它的目标不是让 Agent 多写代码，而是让 Agent 按可靠流程把一个想法、PRD、功能需求、Bug 或部署任务推进到可运行、可测试、可验证、可交付的状态。

核心原则：

```text
代码写完不等于任务完成。
任务完成 = 需求确认 + 技术栈确认 + 实现 + 测试 + 构建 + 运行 + 验证 + 明确交付。
```

## 适合谁

- AI coding 新手：只有一个产品想法，也希望在 Agent 帮助下做出一个能运行的程序。
- 新手开发者：不知道如何写 PRD、选技术栈、搭项目结构、配置环境、测试和交付。
- 使用 Codex、Claude Code、Cursor、OpenCode、Gemini CLI 等 Coding Agent 的用户。
- 希望 Agent 不只是写代码，还能主动做需求确认、环境诊断、测试、运行验证和交付报告的用户。

## 它解决什么问题

- 用户只说一句模糊需求，Agent 直接开始乱写代码。
- 没有确认 PRD，做到一半才发现需求理解错了。
- 技术栈没有确认，新手不知道为什么选这个方案。
- Java、Python、Node、Docker 等环境缺失时，只报错不给下一步。
- 项目没有真实启动过，却说“应该能运行”。
- 交付时没有说明怎么启动、访问哪里、哪些功能已验证。

## 核心流程

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

其中：

- `PRD_CONFIRM`：用户确认需求文档，不合适可以手动修改。
- `TECH_STACK_CONFIRM`：用户确认技术栈，也可以使用推荐默认技术栈。
- `ENVIRONMENT`：检查本机是否有 Java、Python、Node、Docker 等必要环境。
- `DELIVER`：最终必须给出具体交付说明，而不是一句“完成了”。

## 当前目录结构

```text
.agents/
└── skills/
    └── build-and-ship/
        ├── SKILL.md
        ├── agents/
        │   └── openai.yaml
        ├── references/
        │   ├── beginner-guide.md
        │   ├── prd-confirmation.md
        │   ├── project-discovery.md
        │   ├── environment-discovery.md
        │   ├── tech-stack-and-patterns.md
        │   ├── mvp-planning.md
        │   ├── verification-and-delivery.md
        │   └── docker.md
        └── scripts/
            ├── detect_project.ps1
            ├── detect_environment.ps1
            ├── wait_for_http.ps1
            └── collect_evidence.ps1

docs/
└── build-and-ship-coding-skill-design.md
```

## 在 Codex 中使用

如果你在当前项目中使用 Codex，Skill 已经放在：

```text
.agents/skills/build-and-ship/
```

可以这样触发：

```text
使用 build-and-ship 帮我开发一个待办应用
```

或者：

```text
用 build-and-ship 按流程完成这个项目，从 PRD 到运行验证
```

如果要让所有 Codex 项目都能使用，可以把目录复制到全局技能目录：

```text
C:\Users\<你的用户名>\.codex\skills\build-and-ship
```

## 在其他 Coding Agent 中使用

Build-and-Ship 的流程设计是平台无关的，但自动发现机制主要兼容 Codex 的 `.agents/skills` 结构。

仓库提供了适配模板：

```text
adapters/
├── AGENTS.md
├── CLAUDE.md
├── GEMINI.md
├── CURSOR.md
├── OPENCODE.md
└── .cursorrules
```

其他 Agent 可以这样使用：

| Agent | 推荐方式 |
|---|---|
| Claude Code | 复制 `adapters/CLAUDE.md` 到目标项目根目录 |
| Cursor | 复制 `adapters/.cursorrules` 或 `adapters/CURSOR.md` 到目标项目规则 |
| OpenCode | 复制 `adapters/OPENCODE.md` 到 OpenCode 的 agent instructions |
| Gemini CLI | 复制 `adapters/GEMINI.md` 到目标项目根目录 |
| 通用 Agent | 复制 `adapters/AGENTS.md` 到目标项目根目录 |
| 其他 Agent | 复制 `SKILL.md` + 需要的 `references/` 内容到对应的系统提示或项目说明 |

脚本提供 PowerShell 和 Python 两套入口。PowerShell 适合 Windows，Python 适合 Windows/macOS/Linux。

## 新手示例

用户输入：

```text
我要做一个待办应用，帮我开始开发。
```

Build-and-Ship 应先输出：

```text
1. PRD 草案
2. 推荐技术栈
3. 项目结构草案
4. 分阶段任务清单
5. 每一步需要用户确认的内容
```

示例推荐：

```text
PRD:
做一个本地可运行的个人待办应用。

推荐技术栈:
Vue3 + Vite + TypeScript + LocalStorage

最小可运行版本:
新增待办、展示列表、标记完成、删除待办、本地持久化。

需要用户确认:
PRD 是否符合预期？
是否采用推荐技术栈？
是否先做最小可运行版本？
```

## 环境诊断示例

如果缺少运行环境，Agent 不应该只说“没装 Java”，而应该输出：

```text
缺少：JDK 21

影响：当前项目使用 Spring Boot，需要 JDK 才能编译、测试和运行后端。

推荐：Temurin JDK 21 LTS

安装方式：
1. 用户手动安装
2. 允许 Agent 尝试自动安装和配置

如果暂不安装：
可以继续完成代码编辑和文档整理，但无法完成 Build、Run、Runtime Verification。

需要用户确认：
是否允许我尝试自动安装 JDK 21？
```

## 脚本说明

在 Windows PowerShell 中可以运行：

```powershell
powershell -ExecutionPolicy Bypass -File .agents\skills\build-and-ship\scripts\detect_project.ps1
```

检测环境和端口：

```powershell
powershell -ExecutionPolicy Bypass -File .agents\skills\build-and-ship\scripts\detect_environment.ps1 -Ports 5173,8080
```

等待 HTTP 服务可访问：

```powershell
powershell -ExecutionPolicy Bypass -File .agents\skills\build-and-ship\scripts\wait_for_http.ps1 -Url http://localhost:5173
```

生成轻量验证报告：

```powershell
powershell -ExecutionPolicy Bypass -File .agents\skills\build-and-ship\scripts\collect_evidence.ps1
```

跨平台 Python 入口：

```bash
python .agents/skills/build-and-ship/scripts/detect_project.py
python .agents/skills/build-and-ship/scripts/detect_environment.py --ports 5173,8080
python .agents/skills/build-and-ship/scripts/wait_for_http.py http://localhost:5173
```

## 最终交付报告应包含

```text
What changed
How to start
Where to open
What works
What was tested
What was not verified
Next recommended step
```

这样新手拿到结果后，能知道怎么启动、访问哪个地址、哪些功能已经完成、哪些测试通过、哪些还没验证、下一步应该做什么。

## 当前状态

- Skill 结构已创建。
- Codex `quick_validate.py` 校验通过。
- PowerShell 环境检测脚本已验证可运行。
- Python 跨平台检测脚本已补充。
- 已提供 Claude Code、Cursor、Gemini CLI、OpenCode 和通用 Agent 适配模板。
- 已做过一轮子代理压力测试，确认 Skill 会引导 PRD、技术栈、MVP、环境诊断和交付说明。

## 后续建议

- 增加 Bash 版脚本，进一步提升 macOS 和 Linux 体验。
- 增加几个完整示例项目路线，例如纯前端待办、Spring Boot CRUD、FastAPI API。
- 将 Skill 复制到全局 `.codex/skills` 后进行真实项目试用。
