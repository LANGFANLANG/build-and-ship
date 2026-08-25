# Build-and-Ship Coding Skill 总体设计方案

> 目标：让现有 Coding Agent 从用户的一个想法、需求或 Bug 出发，完成需求理解、项目分析、方案设计、代码开发、测试、构建、运行验证，并在需要时支持 Docker 部署。
>
> 核心原则：**“代码写完”不等于“任务完成”，必须尽可能提供可验证的运行结果。Docker 是可选能力，而不是强制要求。**

---

## 1. 项目定位

### 1.1 项目名称

**Build-and-Ship Coding Skill**

### 1.2 项目定义

Build-and-Ship 是一套面向 Coding Agent 的通用软件工程 Skill。

它不替代 Codex、Claude Code、Cursor、OpenCode、Gemini CLI 等 Coding Agent，而是给这些 Agent 提供一套统一的软件开发、验证和交付流程。

用户只需要描述：

- 一个产品想法
- 一个功能需求
- 一个 Bug
- 一个已有项目的修改需求
- 一个部署需求

Coding Agent 加载该 Skill 后，应当尽可能推进到真正可运行、可验证的状态。

总体流程：

```text
用户想法 / 需求
      ↓
需求理解
      ↓
PRD 确认
      ↓
项目分析
      ↓
环境分析
      ↓
技术栈确认
      ↓
架构方案设计与 Markdown 输出
      ↓
用户架构审查与批准
      ↓
任务拆分
      ↓
代码开发
      ↓
测试
      ↓
错误修复
      ↓
项目构建
      ↓
本地运行
      ↓
功能验证
      ↓
是否需要 Docker？
   ┌──┴──┐
   │     │
   否    是
   │     ↓
   │  Docker 化
   │     ↓
   │  Docker Build
   │     ↓
   │  容器运行验证
   │     │
   └─────┘
      ↓
最终交付
```

---

# 2. 核心目标

Build-and-Ship 希望解决 Coding Agent 常见的几个问题：

1. 用户只给一句模糊需求，Agent 不知道如何推进。
2. Agent 过早开始写代码，没有先理解项目。
3. 一次修改大量文件，缺少任务拆分。
4. 写完代码以后不测试。
5. 测试失败以后直接把问题丢给用户。
6. 项目没有真实启动过，却说“应该能运行”。
7. 不同技术栈没有统一开发流程。
8. 不同 Coding Agent 执行结果差异过大。
9. Docker、部署、CI 等能力无法按需接入。
10. 最终没有统一的交付报告和验证证据。

Build-and-Ship 的核心价值不是：

> 帮模型生成更多代码。

而是：

> **让 Coding Agent 按一套可靠的软件工程流程，把一个需求尽可能推进到可运行、可验证、可交付。**

---

# 3. 核心原则

## 3.1 代码完成不等于任务完成

以下情况不能直接判断任务完成：

```text
代码已经写好了
```

```text
从代码来看应该可以运行
```

```text
理论上没有问题
```

```text
Dockerfile 已经生成
```

优先要求 Agent 获取真实验证结果：

```text
实现完成
+
测试通过
+
Build 成功
+
应用实际启动
+
核心功能验证
```

如果用户要求 Docker，则进一步要求：

```text
Docker Build
+
Docker Run
+
Docker Runtime Verify
```

---

## 3.2 Docker 是可选能力

Docker 不属于所有任务的强制 Gate。

以下情况下应该进入 Docker 流程：

### 用户明确要求

例如：

```text
帮我写完以后用 Docker 部署。
```

### 项目已经使用 Docker

例如项目中已经存在：

```text
Dockerfile
compose.yaml
docker-compose.yml
```

则 Agent 应优先保持现有部署方式可用。

### 用户要求完整部署方案

例如：

```text
给我一个可以部署到服务器的版本。
```

### 多服务项目适合 Docker Compose

例如：

```text
Vue
+
Spring Boot
+
MySQL
+
Redis
```

此时可以建议 Docker，但仍然不能未经用户要求就把 Docker 设为唯一完成条件。

---

## 3.3 默认完成标准

默认情况下：

```text
Requirement      PASS
Project Inspect  PASS
Design           PASS
Implementation   PASS
Test             PASS
Build            PASS
Runtime          PASS
Verification     PASS
```

则可进入：

```text
DELIVERED
```

如果当前任务不具备本地运行条件，应明确说明：

```text
PARTIALLY_VERIFIED
```

并给出未验证原因。

---

# 4. 总体架构

```text
                    Coding Agent
                         │
       Codex / Claude / Cursor / OpenCode / Gemini
                         │
                         ▼
                Build-and-Ship Skill
                         │
          ┌──────────────┼───────────────┐
          │              │               │
          ▼              ▼               ▼
      Workflow       References        Scripts
          │              │               │
          │              │               │
          │         Java / Python      Detect
          │         Node / Vue         Verify
          │         React / Docker     Health
          │              │             Build
          │              │
          └──────────────┼───────────────┘
                         ▼
                    User Project
                         │
                         ▼
                 Working Software
```

Skill 本身负责“工程方法”。

Coding Agent 负责：

- 理解
- 判断
- 设计
- 编程
- Debug

Scripts 负责：

- 检测
- 验证
- 重复性操作
- 确定性执行

References 负责：

- 不同技术栈规则
- Docker 规则
- 测试规范
- 部署规范

---

# 5. Skill 目录设计

推荐采用：

```text
.agents/
└── skills/
    └── build-and-ship/
        │
        ├── SKILL.md
        │
        ├── references/
        │   ├── workflow.md
        │   ├── requirement-analysis.md
        │   ├── project-discovery.md
        │   ├── architecture-design.md
        │   ├── task-planning.md
        │   ├── implementation.md
        │   ├── testing.md
        │   ├── verification.md
        │   ├── debugging.md
        │   ├── docker.md
        │   ├── security.md
        │   │
        │   ├── stacks/
        │   │   ├── java-springboot.md
        │   │   ├── python-fastapi.md
        │   │   ├── node.md
        │   │   ├── vue.md
        │   │   └── react.md
        │   │
        │   └── databases/
        │       ├── mysql.md
        │       ├── postgres.md
        │       ├── redis.md
        │       └── mongodb.md
        │
        ├── scripts/
        │   ├── detect_project.py
        │   ├── detect_environment.py
        │   ├── detect_ports.py
        │   ├── wait_for_port.py
        │   ├── wait_for_http.py
        │   ├── run_checks.py
        │   ├── docker_verify.py
        │   └── collect_evidence.py
        │
        └── assets/
            ├── docker/
            ├── compose/
            ├── github-actions/
            └── templates/
```

---

# 6. SKILL.md 的职责

`SKILL.md` 不应该变成几千行的技术百科。

它只定义：

- 什么时候触发
- 总体开发流程
- 每个 Gate 的完成条件
- 什么情况下读取哪个 Reference
- 什么情况下执行哪个 Script
- 什么情况下允许声明任务完成

核心流程：

```text
UNDERSTAND
    ↓
INSPECT
    ↓
DESIGN
    ↓
PLAN
    ↓
IMPLEMENT
    ↓
TEST
    ↓
BUILD
    ↓
RUN
    ↓
VERIFY
    ↓
OPTIONAL DEPLOYMENT
    ↓
DELIVER
```

---

# 7. 阶段一：需求理解 Understand

## 7.1 输入类型

用户请求可能属于：

```text
NEW_PROJECT
FEATURE
BUG_FIX
REFACTOR
DEPLOYMENT
MIGRATION
RESEARCH_AND_IMPLEMENT
```

Agent 首先进行分类。

---

## 7.2 需求结构化

例如用户：

> 做一个个人 AI 待办助手。

内部转化为：

```yaml
type: new-project

goal:
  build a personal AI todo assistant

core_features:
  - todo CRUD
  - natural language task creation
  - task status management

constraints:
  - simple architecture
  - runnable locally

optional:
  docker: false
```

---

## 7.3 Acceptance Criteria

需求阶段必须定义“怎样算完成”。

例如：

```yaml
acceptance_criteria:
  - project starts successfully
  - user can create todo
  - user can list todos
  - user can complete todo
  - automated tests pass
  - frontend or API is reachable
```

后续所有验证围绕 Acceptance Criteria 展开。

---

## 7.4 PRD 需求文档确认

对于新项目、较大功能、重构、迁移、部署方案等非简单任务，Agent 在进入技术设计和代码实现之前，必须先把用户的原始描述整理成一份可确认的 PRD 需求文档。

PRD 至少包含：

```text
项目目标
用户角色
核心功能
非目标 / 暂不做范围
业务流程
页面或接口范围
数据范围
验收标准
约束条件
开放问题
```

确认规则：

```text
Agent 输出 PRD 草案
      ↓
用户确认是否符合预期
      ↓
用户可手动修改、补充或删减需求
      ↓
Agent 根据用户反馈更新 PRD
      ↓
PRD_CONFIRMED 后才能进入后续设计和实现
```

如果用户明确表示“按你的理解直接做”“不用确认 PRD”，则 Agent 可以将当前 PRD 草案标记为：

```text
PRD_CONFIRMED_BY_USER_DEFAULT
```

但最终交付报告中仍应记录本次实现依据的 PRD 摘要，避免需求边界不清。

---

## 7.5 新手引导模板

当用户是新手，或者用户只给出一句较宽泛的想法时，Agent 不应直接进入代码实现，而应主动生成一份新手可读的引导模板。

例如用户说：

> 我要做一个待办应用。

Agent 应自动输出：

```text
1. PRD 草案
2. 推荐技术栈
3. 项目结构草案
4. 分阶段任务清单
5. 每一步需要用户确认的内容
```

推荐格式：

```yaml
beginner_guide:
  prd_draft:
    goal: 做一个可本地运行的待办应用
    users:
      - 普通个人用户
    core_features:
      - 新增待办
      - 查看待办列表
      - 标记完成
      - 删除待办
    out_of_scope:
      - 多用户权限
      - 团队协作
      - 云端部署

  recommended_stack:
    option: Vue3 + Vite + LocalStorage
    reason: 依赖少，启动快，适合新手先完成可运行版本

  project_structure:
    - src/components/TodoForm.vue
    - src/components/TodoList.vue
    - src/stores/todos.ts
    - src/App.vue

  phased_tasks:
    - 初始化项目并启动空页面
    - 实现本地新增和展示
    - 实现完成和删除
    - 加入本地持久化
    - 执行构建和浏览器验证

  user_confirmations:
    - 确认 PRD 是否符合预期
    - 确认是否采用推荐技术栈
    - 确认是否先做最小可运行版本
```

新手引导的目标不是一次性设计完整系统，而是帮助用户跨过空白页，先得到一条清晰、可执行、可验证的路线。

---

# 8. 阶段二：项目发现 Inspect

这是已有项目最重要的阶段之一。

Agent 在修改代码之前，应优先分析现有工程。

## 8.1 项目文件扫描

关注：

```text
README.md
AGENTS.md
CLAUDE.md
GEMINI.md

.git

package.json
pnpm-lock.yaml
yarn.lock

pom.xml
build.gradle

requirements.txt
pyproject.toml

Dockerfile
compose.yaml
docker-compose.yml

.env.example

src/
test/
tests/
```

---

## 8.2 判断项目类型

输出例如：

```json
{
  "projectType": "fullstack",
  "frontend": {
    "framework": "vue",
    "build": "vite",
    "packageManager": "npm"
  },
  "backend": {
    "language": "java",
    "framework": "spring-boot",
    "build": "maven"
  },
  "database": "mysql",
  "docker": false
}
```

---

## 8.3 Existing Project 原则

已有项目必须：

> **Follow Existing Architecture**

例如现有项目：

```text
Spring Boot
MyBatis-Plus
MySQL
```

不要因为 Agent 更喜欢 JPA 就大规模更换框架。

除非用户明确要求重构。

---

# 9. 阶段三：环境发现 Environment Discovery

项目分析以后检查运行环境。

可能包括：

```text
OS
Git

Node
npm
pnpm

Java
Maven
Gradle

Python
pip
uv

Docker
Docker Compose

Database

Ports
```

输出：

```yaml
environment:
  os: windows

  node:
    installed: true
    version: 22

  java:
    installed: true
    version: 21

  docker:
    installed: true
    running: false

  ports:
    5173: available
    8080: available
```

注意：

Docker 未安装不能阻塞普通 Coding 任务。

只有 Docker 属于当前 Acceptance Criteria 时才阻塞 Docker 验证。

---

## 9.1 缺失系统环境处理

如果当前任务需要某个系统级运行环境，但本机没有安装，例如：

```text
Java / JDK
Maven
Gradle
Node.js
npm / pnpm / yarn
Python
pip / uv
Docker
Database Client
```

Agent 必须明确告诉用户：

```text
缺少什么
为什么当前任务需要它
会影响哪个 Gate
推荐安装版本
可选安装方式
如果不安装还能验证到哪一步
```

默认处理策略：

```text
检测缺失环境
      ↓
判断是否为当前任务必需
      ↓
如果非必需：记录为 N/A 或 PARTIALLY_VERIFIED 原因
      ↓
如果必需：提示用户安装或授权自动安装
```

自动安装规则：

```text
Agent 可以尝试自动安装和配置缺失环境
```

但必须满足：

```text
先说明将安装的软件、版本、来源和影响范围
获得用户确认或执行权限
优先使用官方安装方式或系统包管理器
安装后重新检测版本
安装后继续执行原 Gate
```

不允许静默安装系统级软件，也不允许为了绕过环境问题而伪造验证结果。

---

## 9.1.1 环境诊断报告与下一步动作

环境检测完成后，如果发现缺失项，Agent 应输出面向新手的诊断报告。

推荐模板：

```text
环境诊断报告

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

对于多个缺失项，应按阻塞程度排序：

```text
REQUIRED_BLOCKER
当前任务必须安装，否则不能继续关键 Gate。

REQUIRED_FOR_VERIFICATION
可以继续实现，但无法完成构建、运行或验证。

OPTIONAL
仅影响可选能力，例如 Docker 部署。
```

报告必须给出明确下一步，而不是只输出错误。

---

## 9.2 环境缺失状态

环境缺失时的状态应清晰区分：

```text
ENV_MISSING_OPTIONAL
```

表示缺失项不是当前验收标准必需项，任务可以继续。

```text
ENV_MISSING_REQUIRED
```

表示缺失项是当前测试、构建、运行或部署所必需，必须安装、配置或由用户提供替代环境后才能完整验证。

如果用户暂时不安装，Agent 可以继续完成不依赖该环境的工作，但最终状态只能是：

```text
PARTIALLY_VERIFIED
```

并在报告中写明缺失环境和未执行的验证步骤。

---

# 10. 阶段四：架构方案设计与审查 Architecture Design and Review

## 10.1 新项目

新项目应完成基本架构设计。

至少考虑：

```text
Frontend
Backend
Database
Authentication
API
Storage
External Services
Deployment
```

但是遵循：

> **YAGNI：只设计当前需求真正需要的部分。**

不要用户要 Todo，就自动加入：

```text
Kafka
Kubernetes
Elasticsearch
微服务
```

---

## 10.2 已有项目

已有项目重点设计：

```text
修改哪些模块

增加哪些模块

数据模型是否变化

API 是否变化

有没有兼容性风险

如何测试

如何回滚
```

---

## 10.3 技术栈确认

对于新项目或需要新增主要模块的任务，Agent 在进入实现前必须给出技术栈建议，并让用户确认。

技术栈建议至少包含：

```text
Frontend
Backend
Database
Package Manager
Build Tool
Test Framework
Runtime
Optional Deployment
```

推荐输出格式：

```yaml
recommended_stack:
  frontend: Vue3 + Vite
  backend: Spring Boot
  database: MySQL
  package_manager: npm / Maven
  test: Vitest / JUnit
  deployment: Docker Compose optional

reason:
  - matches current requirement
  - easy to run locally
  - V1 supported by Build-and-Ship
```

确认规则：

```text
Agent 输出推荐技术栈
      ↓
用户选择确认、修改或使用默认推荐
      ↓
TECH_STACK_CONFIRMED 后进入架构设计；技术栈确认不等于架构批准
```

如果用户明确表示“默认就行”“用你推荐的”，则可以继续使用推荐技术栈，并记录为：

```text
TECH_STACK_CONFIRMED_BY_DEFAULT
```

已有项目优先遵循现有技术栈，不要求用户重复确认；但如果需要引入新的主框架、数据库、中间件、部署方式或语言运行时，必须再次确认。

---

## 10.4 标准项目范式

为了降低新手从零开始的难度，Build-and-Ship V1 应内置若干标准项目范式。Agent 应根据需求复杂度、用户经验和运行环境选择最简单可行的范式，并在技术栈确认阶段展示给用户。

V1 推荐内置：

```text
FRONTEND_ONLY_TOOL
纯前端小工具，适合计算器、生成器、表单工具、单页小游戏等。

FRONTEND_LOCAL_STORAGE
Vue / React + LocalStorage，适合待办、记账、笔记、清单类 MVP。

FULLSTACK_CRUD
前后端分离 CRUD，适合需要 API、数据库和基础后台管理的应用。

SPRING_BOOT_MYSQL
Spring Boot + MySQL，适合 Java 学习、企业后台、管理系统。

FASTAPI_SQLITE_POSTGRES
FastAPI + SQLite / PostgreSQL，适合 Python API、AI 工具、轻量服务。
```

范式选择规则：

```text
能纯前端完成 → 不引入后端

能 LocalStorage 完成 → 不引入数据库服务

需要多人、多设备或持久服务 → 再引入后端和数据库

用户指定 Java 生态 → 优先 Spring Boot + MySQL

用户指定 Python / AI 工具 → 优先 FastAPI + SQLite，后续再升级 PostgreSQL
```

每个范式应提供：

```text
适用场景
默认技术栈
项目结构
初始化命令
开发命令
测试命令
构建命令
运行验证方式
常见失败处理
是否适合 Docker
```

新手默认优先选择最轻量、依赖最少、最快能跑起来的范式。

## 10.5 架构 Markdown 与审查门槛

新项目，以及会改变主要模块、服务边界、公共 API、数据模型、认证授权、外部集成、部署拓扑、迁移方案或跨领域质量属性的工作，必须生成：

```text
docs/architecture/YYYY-MM-DD-<topic>.md
```

架构阶段使用独立状态：

```text
DESIGN_REQUIRED
      ↓
生成架构 Markdown
      ↓
DESIGN_IN_REVIEW
      ↓
用户阅读、编辑并明确批准
      ↓
DESIGN_APPROVED
      ↓
PLAN → IMPLEMENT
```

文档至少按适用性覆盖：目标和非目标、现有系统、约束、2–3 个候选方案、推荐决策、组件边界、数据与接口、安全、可靠性、迁移、回滚、部署、验证策略、风险与开放问题。

候选方案应优先来自成熟且常用的设计：

```text
应用结构：简单分层 / 模块化单体 / 局部六边形或整洁架构 / 微服务
Web：SPA + API / 服务端渲染全栈 / BFF
数据：关系数据库 / 文档数据库 / 缓存 / Transactional Outbox
集成：同步 REST / 进程内领域事件 / 异步队列 / Outbox + Broker
身份：安全 Cookie Session / OIDC-OAuth / 有明确生命周期的 Token
部署：单体或托管平台 / Container-Compose / 有充分依据时的编排平台
```

每次只比较最相关的 2–3 个候选，并推荐满足当前需求的最简单成熟方案。普通新业务系统默认优先模块化单体与关系数据库，不为“未来可能扩展”自动引入微服务、消息队列、缓存、搜索引擎或 Kubernetes。

PRD 或技术栈确认不等于架构批准。“使用默认方案”“不要问”“直接开发”等在文档产生前给出的指令不能批准一份用户尚未看到的架构文档。Agent 交付文档后必须停止，不得提前规划实现任务或修改生产代码。

文案、样式、局部 Bug 修复等不产生架构决策的改动可以标记 `DESIGN_NA`，并简要说明原因。实施中若服务边界、公共接口、数据所有权、安全边界、主要依赖、部署、迁移或回滚方案发生实质变化，必须更新架构文档并重新进入审查。

---

# 11. 阶段五：任务规划 Plan

设计以后，不要一次性修改整个项目。

拆成可验证任务：

```text
Task 1
基础结构

Task 2
数据库模型

Task 3
Service

Task 4
API

Task 5
Frontend

Task 6
Integration

Task 7
Test

Task 8
Runtime Verification
```

每一个 Task 包含：

```yaml
task:
  goal:

  affected_files:

  dependencies:

  acceptance_criteria:

  verification:
```

---

## 11.1 最小可运行优先

对于新手和新项目，默认规划原则是：

> **先跑起来一个最小版本，再逐步加功能。**

Agent 不应在第一阶段就默认加入完整权限系统、复杂数据库设计、Docker、CI、云部署、微服务或后台管理体系，除非它们属于当前 PRD 的必要验收标准。

推荐分层：

```text
MVP 0
项目能启动，首页或基础接口可访问

MVP 1
核心主流程可用，例如 Todo 的新增、列表、完成、删除

MVP 2
加入必要的数据持久化、表单校验、错误提示

MVP 3
补充测试、构建、运行验证和 README

MVP 4
按需加入登录、数据库、Docker、部署、CI 等能力
```

任务规划时应优先保证：

```text
第一阶段可运行
第二阶段可使用
第三阶段可验证
第四阶段再增强
```

如果用户要求完整系统，Agent 仍应先交付一个可运行的纵向切片，再继续扩展模块，而不是长时间停留在不可运行的大量代码生成阶段。

---

# 12. 阶段六：实现 Implement

推荐采用小步实现：

```text
Requirement
    ↓
Test / Verification Definition
    ↓
Implementation
    ↓
Verify
    ↓
Next Feature
```

推荐遵循：

```text
RED
 ↓
GREEN
 ↓
REFACTOR
```

对于适合自动测试的功能优先 TDD。

对于：

- 配置文件
- UI 原型
- 自动生成代码

可以根据场景调整。

---

# 13. 阶段七：Testing

测试可以分为四级。

## 13.1 Unit Test

适合：

```text
Service
Domain Logic
Utility
Validation
```

---

## 13.2 Integration Test

适合：

```text
Controller
Repository
Database
API
```

---

## 13.3 Frontend Test

适合：

```text
Component
State
API Client
Critical UI Logic
```

---

## 13.4 Smoke Test

重点验证用户真正需要的关键链路。

例如 Todo：

```text
Create Todo
     ↓
List Todo
     ↓
Complete Todo
     ↓
Delete Todo
```

---

# 14. 阶段八：Build

项目必须尽量真实执行构建。

例如：

### Spring Boot

```bash
mvn clean package
```

### Node / Vue / React

```bash
npm run build
```

### Python

Python 项目不一定有传统 Build，可以执行：

```bash
pytest
```

以及：

```bash
python -m compileall .
```

或者项目自己的检查命令。

---

## 14.1 Build Failure Loop

```text
Build
 ↓
Fail
 ↓
Read Error
 ↓
Root Cause
 ↓
Fix
 ↓
Build Again
```

禁止：

```text
Build 失败，但代码应该没问题。
```

---

# 15. 阶段九：本地运行 Run

Build 之后尽量真实启动应用。

### Spring Boot

```bash
mvn spring-boot:run
```

或：

```bash
java -jar app.jar
```

### Vue

```bash
npm run dev
```

### FastAPI

```bash
uvicorn app.main:app
```

---

# 16. 阶段十：Runtime Verification

进程存在不代表应用正常。

至少进行：

```text
Process Check
      ↓
Port Check
      ↓
HTTP / Functional Check
```

例如：

```text
Backend Process
      ✓

Port 8080
      ✓

GET /health
200 OK
      ✓
```

才可确认：

```text
RUNTIME_VERIFIED
```

---

# 17. Runtime Smoke Test

如果是 API 项目，应验证核心 API。

例如：

```text
POST /api/todos
      ↓
GET /api/todos
      ↓
PUT /api/todos/{id}
```

如果存在认证：

```text
Register
   ↓
Login
   ↓
Token
   ↓
Protected API
```

如果是 Web：

```text
HTTP /
   ↓
Frontend Responds
   ↓
Critical API Responds
```

---

# 18. 阶段十一：Docker 决策

本地验证通过后判断：

```text
Docker 是否属于当前任务？
```

判断条件：

```text
用户是否明确要求 Docker？
        │
        ├─ YES → Docker Flow
        │
        └─ NO
             │
项目是否已经使用 Docker？
        │
        ├─ YES → 验证 Docker 不被破坏
        │
        └─ NO
             │
是否属于部署任务？
        │
        ├─ YES → 可以进入 Docker/部署设计
        │
        └─ NO → Skip Docker
```

---

# 19. Docker Flow（可选）

Docker Flow 包含：

```text
Analyze Services
      ↓
Dockerfile
      ↓
Compose（如果需要）
      ↓
Environment Variables
      ↓
Docker Build
      ↓
Docker Run
      ↓
Health Check
      ↓
Application Verify
```

---

# 20. Dockerfile 设计

推荐多阶段构建。

### Java

```text
Maven Build Stage
       ↓
JRE Runtime Stage
```

### Vue

```text
Node Build Stage
       ↓
Nginx Runtime
```

### FastAPI

使用轻量 Python Runtime。

---

# 21. Docker Compose

多服务时使用：

```text
compose.yaml
```

例如：

```text
frontend
backend
mysql
redis
```

处理：

```text
Network
Ports
Environment
Volumes
depends_on
Healthcheck
```

---

# 22. Docker 环境变量

禁止 Secret 硬编码进代码。

推荐：

```text
.env
.env.example
```

例如：

```env
MYSQL_DATABASE=app
MYSQL_USER=app
MYSQL_PASSWORD=CHANGE_ME
JWT_SECRET=CHANGE_ME
```

`.env` 应加入：

```text
.gitignore
```

---

# 23. Docker Verification

如果 Docker 属于 Acceptance Criteria，则必须执行真实验证。

例如：

```bash
docker compose build
```

然后：

```bash
docker compose up -d
```

再：

```bash
docker compose ps
```

最后 HTTP 验证：

```text
GET /
GET /health
```

---

# 24. Debug Loop

任何阶段出现错误都进入统一 Debug Loop：

```text
Execute
   ↓
Fail
   ↓
Collect Evidence
   ↓
Classify Error
   ↓
Find Root Cause
   ↓
Fix
   ↓
Retry
```

---

# 25. Error Classification

错误可以统一分为：

```text
DEPENDENCY
COMPILATION
TEST
RUNTIME
PORT
DATABASE
NETWORK
DOCKER
CONFIG
PERMISSION
ENVIRONMENT
UNKNOWN
```

不同错误加载不同 Reference。

例如：

```text
DOCKER
  ↓
references/docker.md
```

---

# 26. 环境自动修复

Agent 应尽可能处理可安全自动修复的问题。

例如：

```text
Port 8080 occupied
```

流程：

```text
检查占用者
    ↓
是不是当前项目遗留进程？
   ┌──┴──┐
   是    否
   ↓     ↓
停止   不随意 Kill
旧进程   ↓
   │   切换可用端口
   └─────┘
       ↓
重新运行
```

---

# 27. 不允许自动执行的高风险操作

例如：

```text
删除生产数据库

清空未知 Docker Volume

强制覆盖用户未提交代码

git reset --hard

自动 push main

泄露 Secret

停止与项目无关的系统进程
```

这些操作必须遵循安全策略。

---

# 28. Verification Evidence

建议将所有验证结果结构化保存。

例如：

```yaml
verification:

  tests:
    command: mvn test
    status: passed
    total: 42

  build:
    command: mvn clean package
    status: passed

  runtime:
    port: 8080
    status: running

  health:
    url: http://localhost:8080/health
    status: 200

  docker:
    required: false
```

如果使用 Docker：

```yaml
docker:
  required: true
  build: passed
  runtime: passed
  health: passed
```

---

# 29. Scripts 设计

Agent 擅长推理。

Script 擅长确定性执行。

因此建议提供以下脚本。

---

## 29.1 detect_project.py

负责：

```text
识别语言

识别框架

识别构建工具

识别包管理器

识别数据库

识别 Docker
```

---

## 29.2 detect_environment.py

检测：

```text
Git
Node
Java
Maven
Python
Docker
```

---

## 29.3 detect_ports.py

检测：

```text
端口是否被占用

占用进程
```

---

## 29.4 wait_for_port.py

避免固定：

```text
sleep 30
```

改成：

```text
等待端口真正 Ready
```

---

## 29.5 wait_for_http.py

例如：

```bash
python wait_for_http.py http://localhost:8080/health
```

返回：

```text
PASS
```

或者：

```text
FAIL
```

---

## 29.6 run_checks.py

统一运行：

```text
Lint

Test

Type Check

Build
```

根据项目类型动态决定命令。

---

## 29.7 docker_verify.py

仅 Docker Flow 使用。

检测：

```text
Docker Daemon

Compose

Container

Health

HTTP
```

---

## 29.8 collect_evidence.py

生成：

```text
build-and-ship-report.json
```

保存：

```text
执行命令
返回码
测试结果
构建结果
端口
URL
Docker 状态
```

---

# 30. 状态机设计

建议使用：

```text
RECEIVED
   ↓
UNDERSTANDING
   ↓
PRD_CONFIRMING
   ↓
INSPECTING
   ↓
ENVIRONMENT_CHECKING
   ↓
STACK_CONFIRMING
   ↓
DESIGNING
   ↓
DESIGN_IN_REVIEW
   ↓
PLANNING
   ↓
IMPLEMENTING
   ↓
TESTING
   ↓
BUILDING
   ↓
RUNNING
   ↓
VERIFYING
   ↓
DOCKERIZING（optional）
   ↓
DEPLOYMENT_VERIFYING（optional）
   ↓
DELIVERED
```

异常时：

```text
DEBUGGING
```

修复后返回原 Gate。

---

# 31. 完成状态设计

建议不要只有一个 Done。

设计为：

## DELIVERED

核心需求已经：

```text
Implemented
Tested
Built
Run
Verified
```

Docker 如果不是任务要求，可以不存在。

---

## PARTIALLY_VERIFIED

例如：

```text
代码完成
测试通过
Build 通过
```

但由于：

```text
缺数据库
缺外部 API Key
缺硬件
运行环境不可用
```

无法完成完整 Runtime Verify。

必须明确告诉用户缺失什么。

---

## BLOCKED

存在无法继续推进的问题。

必须输出：

```text
Blocked Stage

Root Cause

Evidence

Attempted Fixes

Required User Action
```

---

# 32. Completion Contract

默认任务：

```text
Requirement            PASS
PRD Confirmation       PASS / N/A
Project Understanding  PASS
Environment            PASS / PARTIAL
Tech Stack             PASS / EXISTING
Architecture           APPROVED / N/A
Implementation         PASS
Test                   PASS
Build                  PASS
Runtime                PASS
Verification           PASS
```

即可：

```text
DELIVERED
```

如果当前项目不需要 Build，则对应 Gate 可以标记：

```text
N/A
```

如果 Docker 不需要：

```text
Docker: N/A
```

如果 Docker 被要求：

```text
Docker Build      PASS
Docker Runtime    PASS
Docker Verify     PASS
```

才可完成 Docker Acceptance Criteria。

---

# 33. 最终交付报告

统一输出：

```text
BUILD & SHIP REPORT
```

建议包含：

## Requirement Confirmation

```text
PRD: Confirmed / Confirmed by default / N/A

Tech Stack: Confirmed / Existing stack followed

Environment: Ready / Partially ready / Missing required runtime
```

## Beginner Handoff

```text
How to start:
npm run dev

Open:
http://localhost:5173

What works:
- Create todo
- List todos
- Complete todo
- Delete todo

What was verified:
- Build passed
- App started locally
- Main page reachable
- Core todo flow manually verified

What was not verified:
- Docker deployment was not requested
- Multi-user login is out of current scope

Next recommended step:
Add LocalStorage persistence, then rerun build and browser smoke test.
```

## Implemented

```text
✓ Login

✓ Todo CRUD

✓ AI Task Creation
```

## Tests

```text
Frontend: 18 passed

Backend: 42 passed
```

## Build

```text
npm run build
PASS

mvn clean package
PASS
```

## Runtime

```text
Frontend:
http://localhost:5173

Backend:
http://localhost:8080
```

## Verification

```text
GET /health      200

POST /api/todos  PASS

GET /api/todos   PASS
```

## Docker

如果未要求：

```text
Docker: Not requested
```

如果完成：

```text
docker compose build
PASS

docker compose up -d
PASS

backend healthy
frontend healthy
```

---

# 34. README 自动维护

如果项目缺少基本运行说明，应补充 README。

至少包含：

```text
Project Introduction

Tech Stack

Requirements

Install

Local Development

Environment Variables

Test

Build

Run

Docker Deployment（如果支持）

Common Commands

Beginner Next Steps

Troubleshooting
```

---

# 35. V1 推荐支持技术栈

第一版控制范围。

## Frontend

```text
Vue3
React
Vite
Node.js
```

## Backend

```text
Spring Boot
FastAPI
Node.js
```

## Database

```text
MySQL
PostgreSQL
Redis
```

## Optional Deployment

```text
Docker
Docker Compose
```

---

# 36. 技术栈适配机制

核心 Workflow 不应该绑定语言。

例如统一动作：

```text
BUILD
```

Spring Boot Reference：

```bash
mvn clean package
```

Node Reference：

```bash
npm run build
```

Python Reference：

```bash
pytest
```

以后扩展 Go：

```text
references/stacks/go.md
```

而不需要重写整个 Skill。

---

# 37. Agent 适配设计

第一版不建议写：

```text
CodexAdapter

ClaudeAdapter

CursorAdapter

GeminiAdapter
```

核心 Skill 优先采用：

```text
.agents/skills/build-and-ship/
```

提供平台无关能力。

对于具体 Agent，只增加薄适配层。

例如：

```text
AGENTS.md
CLAUDE.md
GEMINI.md
```

告诉对应 Agent：

```text
在软件开发任务中加载并遵循 build-and-ship。
```

---

# 38. V1 功能范围

V1 应实现：

```text
Requirement Analysis

PRD Confirmation

Beginner Guide Template

Project Discovery

Environment Detection

Environment Diagnostic Report

Architecture Design

Architecture Review Gate

Tech Stack Confirmation

Standard Project Patterns

Task Planning

Minimal Runnable MVP Planning

Implementation Workflow

Testing Workflow

Build Verification

Runtime Verification

Smoke Test

Debug Loop

Completion Contract

Final Report

Beginner Handoff Report
```

Docker V1：

```text
Docker Detection

Dockerfile Guidance

Docker Compose Guidance

Docker Build Verification

Docker Runtime Verification
```

但：

> **Docker Flow 只在任务需要时启动。**

---

# 39. V2 路线

增加：

```text
Git Worktree

Code Review

Automated Commit

CI

GitHub Actions

Gitee CI
```

---

# 40. V3 路线

增加：

```text
GitHub PR

CI Failure Repair

SSH Deployment

Linux Server

Nginx

Systemd
```

---

# 41. V4 路线

增加：

```text
Kubernetes

Vercel

Cloudflare

AWS

Aliyun

Tencent Cloud
```

---

# 42. V5 多 Agent

后续可拆成：

```text
Project Manager Agent

Architecture Agent

Frontend Agent

Backend Agent

Test Agent

Reviewer Agent

DevOps Agent
```

但第一版不建议直接多 Agent 化。

优先让：

> **一个 Coding Agent + 一套强 Workflow**

真正稳定运行。

---

# 43. 推荐的核心 Gate

最终建议 Build-and-Ship V1 固定以下 Gate：

```text
G1  UNDERSTAND
G2  PRD_CONFIRM
G3  INSPECT
G4  ENVIRONMENT
G5  TECH_STACK_CONFIRM
G6  ARCHITECTURE_DESIGN
G7  ARCHITECTURE_REVIEW
G8  PLAN
G9  IMPLEMENT
G10 TEST
G11 BUILD
G12 RUN
G13 VERIFY
G14 DEPLOY (OPTIONAL)
G15 DELIVER
```

其中：

```text
DEPLOY
```

是条件 Gate。

触发条件包括：

```text
用户要求部署

用户要求 Docker

现有项目需要保持 Docker 可用

任务本身属于部署任务
```

---

# 44. 最终产品理念

Build-and-Ship 不应该只是：

```text
一个很长的 Prompt
```

而应该是：

```text
Coding Workflow
+
Skill Protocol
+
Technology References
+
Deterministic Scripts
+
Verification System
```

最终关系：

```text
                Build-and-Ship
                      │
      ┌───────────────┼───────────────┐
      │               │               │
    Codex          Claude          OpenCode
      │               │               │
      └───────────────┼───────────────┘
                      │
                      ▼
                 User Project
                      │
                      ▼
               Working Software
                      │
              ┌───────┴───────┐
              │               │
          Local Run      Docker / Deploy
                         （按需）
```

最终核心原则：

> **用户需要的不是一堆生成出来的代码，而是尽可能真正完成、测试过、跑起来并且有验证证据的软件。**

Docker 是重要能力，但它属于：

> **Optional Deployment Capability**

而不是所有 Coding 任务的强制完成条件。

---

# 45. 一句话定义

**Build-and-Ship 是一套可适配不同 Coding Agent 的端到端软件开发 Skill，让 Agent 能够从用户需求出发，完成理解、设计、编码、测试、构建、运行和验证，并在需要时继续完成 Docker 和部署工作。**
