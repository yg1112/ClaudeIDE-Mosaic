# 🎨 Mosaic - 召唤设计总监

> **给其他项目的 Agent 看的指令**：当用户说"帮我做UI"、"设计前端"、"我需要界面组件"时，阅读此文件。

---

## 如何召唤 Mosaic

在你正在开发的任何项目中，对 Claude IDE 说：

```
请阅读 /path/to/mosaic/SUMMON.md，帮我完成这个项目的UI设计和组件交付。
```

或者更简单：

```
@mosaic 帮我做这个项目的前端
```

---

## Mosaic 是什么

Mosaic 是一个**设计总监 Agent（CDO）**，它会：

1. **问你几个简单问题**（不问技术问题，只问感受）
2. **去全球开源市场采购UI组件**（GitHub、Figma等）
3. **生成一套完整的前端交付包**，直接放到你的项目里
4. **确保后端 Agent 可以直接使用**，不再需要讨论UI细节

---

## 召唤后会发生什么

### Phase 1: 问诊（2-3分钟）
Mosaic 会在 Terminal 里问你 3-5 个问题，例如：
- "你希望用户打开软件的第一感觉是？（冷静专业 / 温暖亲切 / 前卫酷炫）"
- "说出 2-3 个你觉得好看的 App"
- "你的用户主要是什么人？"

**你只需要用自然语言回答，不需要懂任何设计术语。**

### Phase 2: 采购 + 选型（3-5分钟）
Mosaic 会：
- 根据你的回答，在 GitHub/Figma 搜索匹配的开源组件
- 给你展示 2-3 套方案
- 你选一套（或说"我更喜欢A方案的颜色 + B方案的按钮"）

### Phase 3: 交付（自动完成）
Mosaic 会在你的项目目录下创建：

```
你的项目/
├── ... (你原有的代码)
└── Design/                      # Mosaic 交付的设计包
    ├── README.md                # 使用说明（给你和后端Agent看）
    ├── Theme.swift              # 设计变量（颜色、字体、间距）
    ├── UIState.swift            # 中间层状态定义
    ├── Components/              # 所有UI组件
    │   ├── Buttons/
    │   ├── Cards/
    │   ├── Inputs/
    │   └── Feedback/            # Toast、Loading等
    ├── Screens/                 # 页面模板
    └── Assets/                  # 图片、图标等资源
```

---

## 交付后如何使用

### 对于你（产品负责人）
- 查看 `Design/README.md` 了解整体设计决策
- 如果要调整，直接告诉 Agent "把主色调换成蓝色"

### 对于后端 Agent
告诉它：
```
请阅读 Design/README.md，按照里面的规范实现UI。
所有颜色用 AppTheme.Colors.xxx，所有组件用 Design/Components/ 里的。
```

---

## 现在就召唤

如果你准备好了，请说：

**"开始 Mosaic 问诊"**

我会开始问你第一个问题。
