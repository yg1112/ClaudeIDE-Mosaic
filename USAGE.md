# Mosaic 使用指南

**如何在任何项目中调用 Mosaic 设计总监**

---

## 🚀 快速开始

### 方法 1：使用 Skill 命令（推荐）

在任何项目中，直接在 Claude Code 中输入：

```bash
/mosaic
```

Mosaic 会自动开始问诊流程。

### 方法 2：自然语言调用

在任何项目中对 Claude Code 说：

```
帮我设计这个项目的UI
我需要一套前端组件
@mosaic 帮我做前端
设计一下这个项目的界面
```

### 方法 3：明确路径调用

```
请阅读 /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md，帮我完成这个项目的UI设计。
```

---

## 📋 使用流程

### Step 1: 召唤 Mosaic

在你的项目目录下，输入 `/mosaic` 或说"帮我设计UI"

### Step 2: 回答问题（2-3分钟）

Mosaic 会问你 3-5 个简单问题，例如：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 问诊 (1/5)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

你希望用户打开这个软件时的第一感觉是什么？

  [1] 冷静、专业、高效（像 VS Code、Linear）
  [2] 温暖、友好、亲切（像 Notion、Slack）
  [3] 前卫、酷炫、独特（像 Arc、Discord）
  [4] 简洁、干净、无干扰（像 Apple Notes、Bear）

请输入数字或直接描述：
```

**你只需要用自然语言回答，不需要懂任何设计术语。**

### Step 3: 选择方案（1分钟）

Mosaic 会展示 2-3 套方案：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 为你准备了 3 套方案
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

【方案 A】极光套装
深色底 + 紫色微光 + 丝滑动效
像 Linear 的高级质感
核心库：VComponents + Pow

【方案 B】原生套装
跟随系统主题 + Apple 原生控件
简洁可靠，零学习成本
核心库：SwiftUI 原生

【方案 C】玻璃套装
毛玻璃材质 + 浅色系 + 微妙动效
像 macOS 系统应用的感觉
核心库：VComponents + VisualEffectView

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

请选择：输入 A/B/C，或描述你想要的组合
（例如："A的颜色 + B的按钮风格"）
```

### Step 4: 获得交付包（自动）

Mosaic 会在你的项目中创建完整的 `Design/` 目录：

```
你的项目/
├── ... (你原有的代码)
└── Design/                      # ← Mosaic 创建的
    ├── README.md                # 使用说明
    ├── DECISIONS.md             # 设计决策记录
    ├── Foundation/
    │   ├── Theme.swift         # 颜色、字体、间距
    │   ├── Dependencies.md     # 依赖安装命令
    │   └── Assets.xcassets/    # 图片资源
    ├── UIState/
    │   ├── AppState.swift
    │   ├── ScreenStates.swift
    │   └── Navigation.swift
    ├── Components/
    │   ├── Buttons/
    │   ├── Inputs/
    │   ├── Cards/
    │   ├── Feedback/
    │   └── index.swift
    ├── Screens/
    │   ├── _ScreenTemplate.swift
    │   └── Examples/
    └── Tests/
        ├── ComponentPreviews.swift
        └── AcceptanceCriteria.md
```

---

## 💡 使用示例

### 示例 1：新项目需要UI

```
你: /mosaic

Mosaic: 🎨 Mosaic 问诊开始...
        你希望用户打开这个软件时的第一感觉是什么？
        [选项...]

你: 1  （选择"冷静、专业、高效"）

Mosaic: 你的软件信息量大吗？更像报纸还是杂志？
        [选项...]

你: 报纸型，我要展示很多数据

Mosaic: 说出 2-3 个你觉得好看的 App

你: Linear, Raycast

Mosaic: [采购中... 找到匹配的组件库]
        [生成 3 套方案]
        [展示方案]

你: 我选 A

Mosaic: ✅ 交付完成！已创建 Design/ 目录
```

### 示例 2：已有项目需要换皮

```
你: 我有个 Swift 项目，想换一套更现代的UI，@mosaic

Mosaic: 🎨 开始问诊...
        [问诊流程]

你: [回答问题]

Mosaic: [生成方案并交付]
```

### 示例 3：混搭方案

```
Mosaic: [展示方案 A、B、C]

你: 我要 A 的深色配色 + B 的按钮风格 + C 的动效

Mosaic: 好的，我会混搭这些元素...
        [生成混搭方案并交付]
```

---

## 📂 交付后如何使用

### 1. 查看使用说明

```bash
cat Design/README.md
```

里面包含：
- 如何安装依赖
- 如何导入设计系统
- 组件使用示例
- 给后端 Agent 的指令

### 2. 安装依赖

```bash
# 查看依赖清单
cat Design/Foundation/Dependencies.md

# 按照说明安装
# 例如：通过 Swift Package Manager 添加依赖
```

### 3. 在代码中使用

```swift
import Design

// 使用主题变量
Text("Hello")
    .foregroundColor(AppTheme.Colors.primary)
    .font(AppTheme.Typography.body)

// 使用封装好的组件
PrimaryButton(title: "提交", action: {
    // 你的逻辑
})

// 使用 UIState 中间层
@StateObject var appState = AppState()
```

### 4. 告诉后端 Agent

```
请阅读 Design/README.md，按照里面的规范实现UI。
所有颜色用 AppTheme.Colors.xxx
所有组件用 Design/Components/ 里的
状态管理遵循 UIState/ 的定义
```

---

## 🔧 调整和迭代

### 修改颜色

```
Mosaic，把主色调改成蓝色
```

Mosaic 会更新 `Design/Foundation/Theme.swift`

### 换一套按钮风格

```
Mosaic，我不喜欢这个按钮，换成更扁平的风格
```

Mosaic 会更新 `Design/Components/Buttons/`

### 添加新组件

```
Mosaic，我还需要一个评分组件（五星评分那种）
```

Mosaic 会搜索或生成新组件，加入 `Design/Components/`

---

## 🌍 在其他项目中使用（跨项目）

### 方法 1：配置全局 Skill（推荐）

将 Mosaic 作为全局 skill，在任何项目中都可用：

```bash
# 在你的 ~/.claude.json 中添加
{
  "skills": {
    "mosaic": "/Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md"
  }
}
```

之后在任何项目中都可以直接：
```
/mosaic
```

### 方法 2：复制 Skill 文件

将 Mosaic skill 复制到你的项目中：

```bash
cd 你的项目
mkdir -p .claude/skills
cp /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md .claude/skills/
```

### 方法 3：使用绝对路径

```
请阅读 /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md
```

---

## ❓ 常见问题

### Q: Mosaic 支持什么平台？
A: 目前主要支持：
- macOS 桌面应用 (SwiftUI)
- iOS 移动应用 (SwiftUI)
- Web 支持正在扩展中

### Q: 如果我不喜欢生成的设计怎么办？
A: 直接告诉 Mosaic：
```
换一套按钮风格
把主色改成蓝色
我想要更简洁的风格
```

### Q: Mosaic 会覆盖我现有的代码吗？
A: **不会**。Mosaic 只会创建 `Design/` 目录，不会修改你的其他文件。

### Q: 后端 Agent 怎么知道用什么组件？
A: 交付的 `Design/README.md` 包含完整的使用规范。告诉后端 Agent：
```
请按照 Design/README.md 规范开发
```

### Q: 可以在现有项目中使用吗？
A: 当然！Mosaic 会创建独立的 `Design/` 目录，你可以：
- 直接使用新的设计系统
- 逐步迁移现有组件
- 与现有代码共存

### Q: 依赖的开源库有问题怎么办？
A: Mosaic 会：
1. 优先选择稳定的、活跃维护的库
2. 在 `Design/DECISIONS.md` 中记录为什么选择这些库
3. 如果库有问题，告诉 Mosaic，它会帮你换一个

---

## 📊 完整示例：从零到交付

```bash
# 1. 在你的项目目录下
cd ~/my-awesome-app

# 2. 召唤 Mosaic
/mosaic

# 3. 回答问题（假设）
你: 1  # 冷静专业
你: 报纸型
你: Linear, Raycast
你: 开发者工具
你: macOS

# 4. 选择方案
你: A

# 5. 获得交付包
✅ Design/ 目录已创建

# 6. 查看说明
cat Design/README.md

# 7. 安装依赖（如需要）
# 按照 Design/Foundation/Dependencies.md 的说明

# 8. 开始使用
# 在你的代码中 import Design
```

---

## 🎯 最佳实践

1. **问诊阶段要诚实**
   - 告诉 Mosaic 你真实的审美偏好
   - 不要试图用技术术语描述

2. **多看方案对比**
   - Mosaic 会给出多个方案，仔细对比
   - 可以混搭不同方案的优点

3. **及时反馈**
   - 如果不满意，立即告诉 Mosaic
   - 迭代比一开始就完美更高效

4. **保留 DECISIONS.md**
   - 记录了为什么这样设计
   - 团队协作时很有用

5. **遵循交付规范**
   - 使用 AppTheme 变量，不要硬编码颜色
   - 使用封装好的组件，不要重新造轮子

---

## 🔗 相关文档

- **SYSTEM_PROMPT.md** - Mosaic 的完整工作流程
- **SPEC.md** - 架构和技术规范
- **RESOURCES.md** - 预置资源库
- **TASTE_MAPPING.md** - 感受词映射表
- **COMPONENTS.md** - 组件代码模板

---

## 📝 版本历史

- **v1.0** (2026-01-18)
  - 初始版本
  - 支持 Claude Code Skill 调用
  - 完整的 CDO 工作流
  - SwiftUI 资源索引

---

**现在就试试：在你的项目中输入 `/mosaic`！**
