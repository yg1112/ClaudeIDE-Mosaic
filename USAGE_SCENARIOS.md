# 🎯 Mosaic 使用场景

**Agent 自动调用 vs 用户手动调用**

---

## 场景 1: Agent 自动调用（推荐）

### 触发条件

用户说任何与 UI 相关的指令，Agent 会自动检测并调用 Mosaic：

```
✅ 触发 Agent 自动调用的关键词：
- "做个界面"
- "设计一个页面"
- "我需要一个登录页面"
- "帮我写前端"
- "创建用户管理界面"
- "添加一个按钮"
- "修改这个页面的样式"
```

### 工作流程

```
1. 用户: "帮我做一个任务管理界面"

2. Agent (自动检测到 UI 工作):
   - 读取 ClaudeIDE-Core/UI_DESIGN_PROTOCOL.md
   - 发现需要调用 Mosaic

3. Agent (自动调用 Mosaic):
   "请读取 /Users/yukungao/github/ClaudeIDE-Mosaic/SYSTEM_PROMPT.md
    然后为这个项目提供设计服务"

4. Mosaic 开始工作:
   Phase 0: 探索项目
   Phase 1: 问诊审美偏好
   Phase 2: 搜索 UI 资源
   Phase 3: 生成方案
   Phase 4: 交付 Design/ 目录
   Phase 5: 记录日志

5. Mosaic 完成后:
   "✅ 已生成 Design/ 目录，请阅读 Design/README.md"

6. Agent 继续:
   - 读取 Design/README.md
   - 按照设计系统实现业务逻辑
   - 使用 Design/Components/ 中的组件
   - 遵循 Design/Foundation/Theme.swift 的样式
```

### 示例对话

```
用户: "我想做一个电商网站的商品列表页面"

Agent:
我检测到这是一个 UI 设计任务，让我先调用 Mosaic
为你生成设计方案...

[Agent 自动读取 Mosaic SYSTEM_PROMPT.md]

Mosaic:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 项目探索
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

我快速浏览了你的项目，发现几个关键点：
📊 项目类型：电商网站
🎯 核心功能：商品展示、购物车、支付
👥 推测用户：消费者

💡 我注意到几个设计机会：
1. 商品列表需要清晰的卡片布局
2. 购物车入口需要醒目
3. 需要优秀的图片展示效果

这些推断准确吗？
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

[然后 Mosaic 继续问诊、采购、生成方案...]
```

---

## 场景 2: 用户手动调用

### 使用时机

当你想**主动**使用 Mosaic，而不是等 Agent 检测：

```
✅ 适合手动调用的场景：
- 项目初期，想先设计 UI
- 重新设计现有界面
- 单独咨询设计建议
- 想看看 Mosaic 能提供什么方案
```

### 调用方式

#### 方式 1: Skill 命令（最简单）

```
/mosaic
```

#### 方式 2: 自然语言

```
使用 Mosaic 为这个项目设计 UI
@mosaic 帮我设计前端
请 Mosaic 给我一套设计方案
```

#### 方式 3: 明确路径

```
请读取 /Users/yukungao/github/ClaudeIDE-Mosaic/SYSTEM_PROMPT.md
然后开始 Mosaic 问诊流程
```

### 示例对话

```
用户: "/mosaic"

Mosaic (直接开始):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 项目探索
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

让我先探索一下你的项目...

[Mosaic 开始 5 阶段流程]
```

---

## 场景 3: 混合使用

### Agent 调用 + 用户干预

```
1. 用户: "做个用户管理页面"

2. Agent: (自动调用 Mosaic)

3. Mosaic: "我找到了 3 套方案，你选哪个？"
   [方案 A] [方案 B] [方案 C]

4. 用户: "等等，我想要更深色的主题"

5. Mosaic: "好的，让我重新搜索深色主题的资源..."

6. [Mosaic 重新生成方案]

7. 用户: "选方案 A"

8. Mosaic: "✅ 已生成 Design/ 目录"

9. Agent: (继续实现业务逻辑)
```

---

## 场景对比

| 场景 | Agent 自动调用 | 用户手动调用 |
|------|---------------|--------------|
| **触发方式** | 用户说 UI 相关指令 | 用户主动 `/mosaic` |
| **优点** | 自动化，无需记忆命令 | 更精确控制 |
| **适用** | 开发过程中 | 项目初期或重新设计 |
| **示例** | "做个登录页" | `/mosaic` |

---

## 实战案例

### 案例 1: 新项目从零开始

```
场景: 你刚创建了一个新的 macOS App 项目

推荐: 用户手动调用

步骤:
1. cd /path/to/new/project
2. 安装 Mosaic skill
3. 输入 "/mosaic"
4. Mosaic 问诊 → 生成 Design/
5. 告诉 Agent: "按照 Design/README.md 实现功能"
```

### 案例 2: 现有项目添加新功能

```
场景: 项目已有后端，现在要添加设置页面

推荐: Agent 自动调用

步骤:
1. 直接对 Agent 说: "帮我做一个设置页面"
2. Agent 自动调用 Mosaic
3. Mosaic 生成设计
4. Agent 继续实现
```

### 案例 3: 只想看设计方案

```
场景: 你还不确定要做什么，想先看看设计可能性

推荐: 用户手动调用

步骤:
1. 输入 "/mosaic"
2. Mosaic 问诊并展示方案
3. 你可以选择保留或放弃
4. 不会立即开始实现
```

### 案例 4: 紧急修改样式

```
场景: 已有 UI，但想快速改变主题色

推荐: 直接告诉 Agent（跳过 Mosaic）

步骤:
用户: "把主色调从蓝色改成绿色，不需要 Mosaic"
Agent: (直接修改 Theme.swift)
```

---

## 配置建议

### 在 ClaudeIDE-Core 中（Agent 行为）

确保 `UI_DESIGN_PROTOCOL.md` 已配置：

```yaml
触发 Mosaic 的条件:
  - 关键词: ["界面", "UI", "页面", "前端", "组件"]
  - 动作: ["做", "设计", "创建", "添加", "修改"]
  - 组合: "做 + 界面" = 触发 Mosaic

跳过 Mosaic 的情况:
  - 用户明确说 "不要 UI"
  - 用户说 "只写后端"
  - 用户说 "跳过 Mosaic"
```

### 在每个项目中（用户调用）

安装 Mosaic skill：

```bash
# 方式 1: 符号链接（推荐）
ln -s /path/to/mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md

# 方式 2: 运行安装脚本
/path/to/mosaic/install-to-project.sh
```

---

## 调试和验证

### 验证 Agent 自动调用

```
测试: 对 Agent 说 "做个登录页面"

期望行为:
✅ Agent 应该说 "我检测到这是 UI 工作，让我调用 Mosaic..."
✅ Mosaic 应该开始项目探索
✅ Mosaic 应该问诊用户偏好

如果没有:
❌ 检查 ClaudeIDE-Core/UI_DESIGN_PROTOCOL.md 是否存在
❌ 检查 .claude/instructions.md 是否引用了协议
❌ 重启 Claude Code
```

### 验证用户手动调用

```
测试: 输入 "/mo" 或 "/mosaic"

期望行为:
✅ 应该在自动补全中看到 /mosaic
✅ 执行后 Mosaic 应该开始工作

如果没有:
❌ 检查 .claude/skills/mosaic.md 是否存在
❌ 运行安装脚本
❌ 重启 Claude Code
```

---

## 最佳实践

### ✅ DO (推荐做法)

```
1. 新项目: 先手动调用 /mosaic 生成设计系统
2. 开发中: 让 Agent 自动调用 Mosaic
3. 重大改版: 手动调用 /mosaic 重新设计
4. 小调整: 直接告诉 Agent，跳过 Mosaic
```

### ❌ DON'T (不推荐)

```
1. 不要在没有安装 skill 的情况下期待 /mosaic 工作
2. 不要在 Agent 已经调用 Mosaic 时重复调用
3. 不要跳过 Mosaic 然后让 Agent 自己写 UI
4. 不要在 Mosaic 完成前打断流程
```

---

## 总结

```yaml
两种调用机制:
  Agent 自动调用:
    - 由 ClaudeIDE-Core 的 UI_DESIGN_PROTOCOL.md 控制
    - 检测 UI 相关指令时自动触发
    - 适合开发过程中使用
    - 无需记忆命令

  用户手动调用:
    - 通过 /mosaic 或自然语言
    - 需要在项目中安装 skill
    - 适合项目初期或主动咨询
    - 更精确的控制

推荐:
  - 两种方式都配置好
  - Agent 负责自动化
  - 用户保留主动权
  - 根据场景选择使用
```

---

**现在你可以**:
1. 在项目中说 "做个 XX 页面"（Agent 自动调用）
2. 或者输入 `/mosaic`（用户手动调用）
3. 或者直接说 "使用 Mosaic 设计 UI"（明确调用）

**查看完整文档**:
- 安装指南: `INSTALL.md`
- 使用教程: `USAGE.md`
- 快速开始: `QUICK_START.md`
