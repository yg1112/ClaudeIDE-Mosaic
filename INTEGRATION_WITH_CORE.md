# Mosaic 与 ClaudeIDE-Core 的集成

**如何让所有 Agent 在需要 UI 时自动调用 Mosaic**

---

## 🎯 问题陈述

**你想实现的效果**：

当后端 Agent 接到用户的指令需要写 UI 时：
1. ❌ **不要**直接写代码（丑且不符合用户偏好）
2. ✅ **必须**先调用 Mosaic 咨询设计
3. ✅ Mosaic 会去网上搜索，找到可用的组件/设计
4. ✅ 问用户是否满意
5. ✅ 满意则实施，不满意则 Fallback：
   - Level 1: 高保真还原网上找到的设计参考
   - Level 2: (Rare) 原创设计但严格遵循规范

---

## ✅ 解决方案：双层架构

### 架构设计

```
┌─────────────────────────────────────────┐
│     ClaudeIDE-Core (系统级)              │
│                                         │
│  定义: "何时调用 Mosaic"                 │
│  触发条件、例外情况、强制规则             │
│                                         │
│  文件: UI_DESIGN_PROTOCOL.md            │
│       AGENT_BOOTSTRAP.md (引用)         │
│       .claude/instructions.md (引用)    │
└─────────────────────────────────────────┘
              ↓ 调用
┌─────────────────────────────────────────┐
│     Mosaic (专家级)                      │
│                                         │
│  定义: "被调用后如何工作"                 │
│  问诊流程、搜索策略、Fallback 处理        │
│                                         │
│  文件: .claude/skills/mosaic.md         │
│       SYSTEM_PROMPT.md                  │
└─────────────────────────────────────────┘
```

### 为什么要分两层？

**ClaudeIDE-Core（系统级）**：
- 给**所有 Agent** 看的规则
- 定义"什么时候必须调用 Mosaic"
- 定义例外情况（什么时候可以不调用）
- 确保一致性：不管是什么项目，UI 工作都遵循同样流程

**Mosaic（专家级）**：
- 给 **Mosaic 自己**看的工作手册
- 定义详细的问诊流程
- 定义搜索策略和资源评估
- 定义 Fallback 处理（找不到资源时怎么办）
- 确保专业性：Mosaic 知道如何做好设计咨询

---

## 📁 已创建/更新的文件

### ClaudeIDE-Core 系统级配置

#### 1. `UI_DESIGN_PROTOCOL.md`（全新，3000+ 行）

**路径**: `/Users/yukungao/github/ClaudeIDE-Core/UI_DESIGN_PROTOCOL.md`

**内容概要**：

```markdown
## 核心规则
- Rule 0: UI 工作必须先咨询 Mosaic
- 触发条件详解
- 完整工作流程（4 个阶段）

## Fallback 策略
- Level 1: 找到设计参考但没代码
- Level 2: 完全找不到参考（Rare Case）

## 禁止行为
- 不要直接写代码
- 不要硬编码颜色/字体/间距
- 不要跳过 Mosaic

## 实际案例
- 新项目添加登录界面
- 修改现有按钮颜色
- Mosaic 找不到满意资源时的处理
```

#### 2. `.claude/instructions.md`（已更新）

**变更**：

```diff
### 行为准则
- **不要直接写代码** - 先提 2-3 种方案,说明权衡
- **UI 必须先设计** - 用 ASCII 画布局,用户确认后再写代码
+ **UI 必须先咨询 Mosaic** - 涉及 UI 时调用 `/mosaic`，详见 `/UI_DESIGN_PROTOCOL.md`
- **主动提出更好方案** - 即使用户没问

+ | **UI 设计协议** | `/UI_DESIGN_PROTOCOL.md` | 何时调用 Mosaic + Fallback 策略 |
```

#### 3. `AGENT_BOOTSTRAP.md`（已更新）

**变更**：

```diff
### 规则 2: UI 必须先设计
- ❌ 错误：直接写 SwiftUI 代码
+ ❌ 错误：直接写 SwiftUI/React 代码
✅ 正确：
-   1. 用 ASCII 画布局原型
-   2. 说明交互逻辑
-   3. 解释设计理由
-   4. 用户确认后再写代码
+   1. 立即调用 Mosaic: "/mosaic"
+   2. Mosaic 会探索项目、问诊偏好、搜索资源
+   3. 等待 Mosaic 生成 Design/ 目录
+   4. 阅读 Design/README.md
+   5. 严格遵循设计系统实现业务逻辑

+ **触发条件**、**例外情况**、**Fallback 策略**
```

---

### Mosaic 专家级配置

#### 4. `.claude/skills/mosaic.md`（已更新）

**新增内容**：

```markdown
### Phase 4: 交付设计包

#### 标准交付（找到了可用资源）
[原有内容]

#### Fallback 交付（找不到现成组件）⭐️ NEW

**Fallback Level 1: 找到设计参考但没代码（L3-L4）**
- 保存参考图片到 Design/Reference/
- 生成详细设计规范 (DECISIONS.md)
- 生成实现任务清单 (IMPLEMENTATION_TASKS.md)
- 告知后端 Agent 高保真还原

**Fallback Level 2: 完全找不到满意资源（Rare）**
- 深度设计咨询
- 定义完整设计规范
- 用 ASCII 画组件原型
- 严格的实现指导

**Fallback 交付检查清单**
- 设计规范文档
- 实现指导
- 后端 Agent 指令
```

---

## 🔄 完整工作流程示例

### 场景：用户在一个新项目中说"帮我做一个登录界面"

#### Step 1: Agent 识别 UI 任务

```
用户: "帮我做一个登录界面"

Agent 读取: ClaudeIDE-Core/.claude/instructions.md
触发规则: "UI 必须先咨询 Mosaic"

Agent 回应:
"我注意到这是一个 UI 设计任务。
根据 UI Design Protocol，我需要先咨询 Mosaic（设计总监）。

Mosaic 会：
1. 探索你的项目
2. 询问你的审美偏好
3. 在网上搜索匹配的登录界面设计
4. 提供 2-3 套方案供你选择
5. 生成完整的设计包

我现在调用 Mosaic，好吗？"
```

---

#### Step 2: 调用 Mosaic

```
Agent: "/mosaic"

Mosaic 被激活，读取 .claude/skills/mosaic.md
开始执行 5 个阶段的工作流程...
```

---

#### Step 3: Mosaic 工作（Phase 0-4）

**Phase 0: 项目探索**
```
Mosaic:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 项目探索

我快速浏览了你的项目，发现几个关键点：

📊 项目类型：iOS/macOS 生产力应用
🎯 核心功能：任务管理、日历集成
👥 推测用户：专业人士、需要高效工作流

💡 我注意到几个设计机会：
1. 登录界面需要简洁专业
2. 可以考虑支持 Face ID / Touch ID
3. 需要与主界面风格一致

这些推断准确吗？
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Phase 1: 问诊**
```
Mosaic:
🎨 问诊 (1/7)

我看到你的项目是生产力应用，通常这类工具有两种设计方向...
[详细问诊流程]

用户: "我喜欢 Linear 和 Things 3 的设计"

Mosaic: "好的，让我快速研究一下这些 App..."
[WebSearch 搜索 Linear 和 Things 3 的设计分析]

Mosaic: "我明白了！你喜欢的这两个 App 有这些共同点：
- 简洁现代的设计
- 大量留白
- 柔和的配色
- 精致的细节
💡 所以你喜欢'精致简约'的设计风格，对吗？"
```

**Phase 2: 采购**
```
Mosaic:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🔍 Mosaic 正在为你采购资源...

📦 从预置库中找到 2 个匹配资源...
🌐 正在 GitHub 搜索 "swiftui login minimal elegant"...
🎨 正在 Figma Community 搜索 "login screen design system"...
📱 正在 Mobbin 查找 Linear 和 Things 3 的登录界面...

✅ 找到 15 个优质资源
   - 8 个可直接使用 (L1)
   - 3 个需要配置 (L2)
   - 4 个参考设计 (L3-L4)

正在生成方案...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**Phase 3: 方案生成**
```
Mosaic:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 为你准备了 3 套方案

【方案 A】极简套装
深色背景 + 柔和白色 + 微妙阴影
核心库：VComponents (L1) + 自定义配色

【方案 B】系统原生
跟随系统主题 + SF Symbols + Apple 风格
核心库：SwiftUI 原生组件

【方案 C】精致套装（推荐）
浅色柔和 + 圆角卡片 + 细腻动效
参考：Things 3 登录界面（Mobbin）
核心库：VComponents + Pow + 高保真还原

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

请选择：输入 A/B/C，或描述你想要的组合
```

用户选择后...

---

#### Step 4a: 标准交付（选择了方案 A 或 B）

```
Mosaic:
✅ 好的，我选择方案 A。正在生成设计包...

[在项目中创建 Design/ 目录]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Mosaic 交付完成！

已在你的项目中创建 Design/ 目录：

📁 Design/
├── README.md          ← 先看这个！
├── Foundation/        ← 主题配置（颜色、字体、间距）
├── Components/        ← 登录相关组件
│   ├── Buttons/
│   ├── Inputs/
│   └── Auth/
│       ├── LoginCard.swift
│       ├── SocialLoginButtons.swift
│       └── BiometricButton.swift
├── UIState/          ← 登录状态管理
└── DECISIONS.md      ← 设计决策记录

下一步：
阅读 Design/README.md，了解如何使用这些组件。
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

后端 Agent 接手：
```
Agent:
"Mosaic 已经生成了完整的设计系统。
我现在根据 Design/README.md 实现登录界面的业务逻辑。"

[Agent 读取 Design/README.md]
[使用 Design/Components/Auth/ 中的组件]
[连接登录 API]
[完成]
```

---

#### Step 4b: Fallback 交付（选择了方案 C）

```
用户: "我选 C"

Mosaic:
"好的，方案 C 需要高保真还原 Things 3 的登录界面。
我在 Mobbin 找到了参考设计，但没有直接可用的 SwiftUI 代码。

我会：
1. 保存参考图到 Design/Reference/
2. 从参考图提取设计规范
3. 生成 Theme.swift（颜色、字体、间距）
4. 创建实现任务清单

然后交给后端 Agent 高保真还原。"

[Mosaic 生成 Fallback 交付包]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 设计交付（Fallback 模式）

我已经为你生成了设计规范，但由于没有直接可用的 SwiftUI 代码，
需要后端 Agent 来高保真还原。

📁 已生成的文件：
- Design/Reference/things3-login.png - 参考设计
- Design/DECISIONS.md - 详细设计规范
- Design/Foundation/Theme.swift - 提取的设计变量
- Design/IMPLEMENTATION_TASKS.md - 实现任务清单

⚠️ 重要要求：
1. 严格按照 Design/Reference/things3-login.png 高保真还原
2. 所有颜色、字体、间距使用 Theme.swift 中的变量
3. 实现每个组件前，先用 ASCII 画原型让用户确认
4. 不要自己发挥，严格遵循设计规范

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

后端 Agent 接手：
```
Agent:
"收到 Mosaic 的 Fallback 交付。
我会按照 Design/Reference/things3-login.png 高保真还原。

在实现前，让我先用 ASCII 画一个布局原型：

┌─────────────────────────────────────┐
│                                     │
│         [Logo]                      │
│                                     │
│      Welcome to Things              │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Email                      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Password                   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │      Sign In                │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────── or ───────────         │
│                                     │
│  [Sign in with Apple]               │
│                                     │
└─────────────────────────────────────┘

这个布局对吗？"

[用户确认]

Agent:
"好的，我开始实现，所有样式使用 Theme.swift 中的变量。"

[高保真还原]
```

---

## 🎯 关键点总结

### 1. Agent 的行为被系统级规则约束

```
任何 Agent 在任何项目中，只要涉及 UI：
  ↓
读取 ClaudeIDE-Core/.claude/instructions.md
  ↓
触发规则："UI 必须先咨询 Mosaic"
  ↓
调用 /mosaic
  ↓
Mosaic 接管 UI 设计工作
  ↓
Agent 根据 Design/ 实现业务逻辑
```

### 2. Mosaic 有完整的 Fallback 策略

```
Mosaic 搜索资源:
  ├─ 找到可用组件 (L1-L2)
  │    ↓
  │  生成标准设计包
  │    ↓
  │  Agent 直接使用
  │
  ├─ 找到设计参考但没代码 (L3-L4)
  │    ↓
  │  Fallback Level 1
  │    ↓
  │  保存参考图 + 详细规范 + 实现任务
  │    ↓
  │  Agent 高保真还原
  │
  └─ 完全找不到参考 (Rare)
       ↓
     Fallback Level 2
       ↓
     深度咨询 + ASCII 原型 + 严格规范
       ↓
     Agent 原创实现但遵循规范
```

### 3. 前后端完全解耦

```
Mosaic 职责:
  - 探索项目
  - 问诊偏好
  - 搜索资源
  - 生成设计系统

Agent 职责:
  - 实现业务逻辑
  - 连接 API
  - 处理错误
  - 遵循设计系统
```

---

## 📊 效果预期

### Before（没有这套系统）

```
用户: "做一个登录界面"

Agent: "好的"
[直接写 SwiftUI 代码]
[硬编码颜色: .blue, .gray]
[用系统默认字体]
[简陋的布局]

用户: "太丑了，改一下"
[反复修改 4-5 次]
[前后端耦合，改颜色要动业务逻辑]
```

### After（有了这套系统）

```
用户: "做一个登录界面"

Agent: "这是 UI 任务，我调用 Mosaic"

Mosaic:
[探索项目]
[问诊偏好]
[搜索 GitHub, Figma, Mobbin]
[提供 3 套方案]

用户: "我选 C"

Mosaic:
[生成完整设计包 OR Fallback 规范]

Agent:
[遵循设计系统实现]
[前后端解耦，改颜色只改 Theme.swift]
[一次成功，用户满意]
```

---

## 🚀 如何使用

### 在新项目中

1. **确保 ClaudeIDE-Core 已配置**
   ```bash
   # 检查文件是否存在
   ls /Users/yukungao/github/ClaudeIDE-Core/UI_DESIGN_PROTOCOL.md
   ls /Users/yukungao/github/ClaudeIDE-Core/.claude/instructions.md
   ```

2. **Agent 会自动读取规则**
   - 每次会话开始时，Agent 读取 `AGENT_BOOTSTRAP.md`
   - 看到"UI 必须先咨询 Mosaic"的规则
   - 涉及 UI 时自动触发

3. **你只需要正常提需求**
   ```
   "帮我做一个登录界面"
   "设计一个 Dashboard"
   "给设置页面加个主题切换"
   ```

4. **Agent 会自动调用 Mosaic**
   - 不需要你手动输入 `/mosaic`
   - Agent 识别到 UI 任务后会主动调用

---

### 在现有项目中

如果项目已经有 `Design/` 目录：

```
Agent 行为:
  检查 Design/ 是否存在
    ├─ 存在 且 包含所需组件
    │    ↓
    │  直接使用 Design/Components/
    │  不调用 Mosaic
    │
    └─ 存在 但 缺少组件
         ↓
       询问用户:
       "需要添加新组件，
        让 Mosaic 设计 OR 我遵循现有风格实现？"
```

---

## 🔧 维护和更新

### 添加新的触发条件

编辑 `ClaudeIDE-Core/UI_DESIGN_PROTOCOL.md`：

```yaml
UI_TASK_TRIGGERS:
  - 用户说: "设计界面"、"做个 UI"、"写个页面"
  + - 用户说: "美化一下"、"让界面好看点"  # 新增
```

### 更新 Mosaic 的搜索策略

编辑 `Mosaic/RESOURCES.md` 添加新资源平台

编辑 `Mosaic/SYSTEM_PROMPT.md` 更新搜索流程

### 添加新的 Fallback Level

编辑 `Mosaic/.claude/skills/mosaic.md`：

```yaml
Fallback Level 3: 用户提供自己的设计稿
  - 保存用户的设计稿
  - 生成实现规范
  - ...
```

---

## 📚 相关文档索引

### ClaudeIDE-Core

- **主配置**: `/Users/yukungao/github/ClaudeIDE-Core/.claude/instructions.md`
- **Bootstrap**: `/Users/yukungao/github/ClaudeIDE-Core/AGENT_BOOTSTRAP.md`
- **UI Protocol**: `/Users/yukungao/github/ClaudeIDE-Core/UI_DESIGN_PROTOCOL.md` ⭐️

### Mosaic

- **Skill 定义**: `/Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md` ⭐️
- **System Prompt**: `/Users/yukungao/github/ClaudeIDE-Mosaic/SYSTEM_PROMPT.md`
- **资源索引**: `/Users/yukungao/github/ClaudeIDE-Mosaic/RESOURCES.md`
- **使用教程**: `/Users/yukungao/github/ClaudeIDE-Mosaic/USAGE.md`

---

**系统版本**:
- ClaudeIDE-Core: v2.1
- Mosaic: v2.0
- 集成版本: v1.0

**创建日期**: 2026-01-18
**最后更新**: 2026-01-18
