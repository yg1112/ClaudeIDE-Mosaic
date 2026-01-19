# Mosaic 快速开始

**5 分钟让其他项目可以使用 Mosaic**

---

## 🚀 方法 1：本地 Skill（立即可用）

在 Mosaic 项目中已经创建了 `.claude/skills/mosaic.md`。

### 在同一台机器的其他项目中使用：

```bash
# 在你的项目目录下，对 Claude Code 说：
/mosaic
```

或

```
帮我设计这个项目的UI
```

Claude Code 会自动找到并加载 Mosaic skill。

---

## 🌍 方法 2：配置全局 Skill（推荐）

让所有项目都能访问 Mosaic：

### 步骤：

1. 编辑全局配置文件：
```bash
nano ~/.claude.json
```

2. 添加 Mosaic skill 路径：
```json
{
  "skills": {
    "mosaic": "/Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md"
  }
}
```

3. 保存并退出

4. 在任何项目中使用：
```bash
/mosaic
```

---

## 📦 方法 3：复制到项目中

将 Mosaic skill 复制到你的项目：

```bash
cd 你的项目
mkdir -p .claude/skills
cp /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md .claude/skills/
```

之后在该项目中可以使用：
```bash
/mosaic
```

---

## 🔗 方法 4：直接引用路径

在任何项目中，对 Claude Code 说：

```
请阅读 /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md 并开始 Mosaic 问诊
```

或

```
请阅读 /Users/yukungao/github/ClaudeIDE-Mosaic/SUMMON.md，帮我完成这个项目的UI设计
```

---

## ✅ 验证是否成功

在任何项目中输入：

```
/mosaic
```

如果看到以下输出，说明成功：

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🎨 Mosaic 问诊 (1/5)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

你希望用户打开这个软件时的第一感觉是什么？
...
```

---

## 📚 下一步

- 查看 [USAGE.md](./USAGE.md) 了解详细使用教程
- 查看 [SYSTEM_PROMPT.md](./SYSTEM_PROMPT.md) 了解 Mosaic 的工作流程
- 查看 [SPEC.md](./SPEC.md) 了解架构设计

---

## ❓ 常见问题

### Q: 为什么输入 /mosaic 没反应？

A: 尝试以下方法：
1. 确认 skill 文件存在：`ls .claude/skills/mosaic.md`
2. 使用完整路径调用
3. 重启 Claude Code

### Q: 可以在团队中共享 Mosaic 吗？

A: 可以！有两种方式：
1. **Git 仓库共享**：将 Mosaic 项目推送到 Git，团队成员 clone
2. **配置共享路径**：团队使用统一的 Mosaic 路径配置

### Q: Mosaic 会修改我的项目吗？

A: 不会修改现有文件。只会创建新的 `Design/` 目录。

---

**现在就试试：`/mosaic`**
