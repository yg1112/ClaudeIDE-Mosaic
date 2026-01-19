# 🚀 Mosaic 安装指南

**在任何项目中使用 Mosaic 设计服务**

---

## 为什么需要安装？

Claude Code 的 skills 是**项目级别**的，每个项目都需要单独配置。Mosaic 提供了多种安装方式，让你可以在任何项目中轻松使用设计服务。

---

## 方法 1: 使用安装脚本（推荐⚡️）

### 在目标项目中运行

```bash
# 切换到你的项目目录
cd /path/to/your/project

# 运行 Mosaic 安装脚本
/Users/yukungao/github/ClaudeIDE-Mosaic/install-to-project.sh

# 选择安装方式：
#   [1] 符号链接 (推荐 - 自动同步)
#   [2] 复制文件 (独立版本)
#   [3] 引用文件 (轻量引用)
```

### 或者指定项目路径

```bash
/Users/yukungao/github/ClaudeIDE-Mosaic/install-to-project.sh /path/to/your/project
```

---

## 方法 2: 手动创建符号链接

**优点**: 自动同步更新，Mosaic 更新后所有项目自动获得新功能

```bash
# 在你的项目目录下
cd /path/to/your/project

# 创建 skills 目录
mkdir -p .claude/skills

# 创建符号链接
ln -s /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md
```

---

## 方法 3: 手动复制文件

**优点**: 完全独立，可以自定义修改

```bash
# 在你的项目目录下
cd /path/to/your/project

# 创建 skills 目录
mkdir -p .claude/skills

# 复制 skill 文件
cp /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md
```

**注意**: 需要手动同步更新

---

## 方法 4: 轻量引用文件

**优点**: 最轻量，只是一个指向 Mosaic 的引用

在项目的 `.claude/skills/mosaic.md` 中创建：

```markdown
# Mosaic - AI Design Director

## 使用方法

告诉 Agent：

\`\`\`
请读取 /Users/yukungao/github/ClaudeIDE-Mosaic/SYSTEM_PROMPT.md
然后为这个项目提供设计服务
\`\`\`

**Mosaic 仓库**: `/Users/yukungao/github/ClaudeIDE-Mosaic`
**GitHub**: https://github.com/yg1112/ClaudeIDE-Mosaic
```

---

## 方法 5: 直接调用（无需安装）

**最简单**: 不需要任何安装，直接在对话中调用

在任何项目中，告诉 Agent：

```
请读取 /Users/yukungao/github/ClaudeIDE-Mosaic/SUMMON.md
帮我完成这个项目的 UI 设计
```

或者更直接：

```
请读取 /Users/yukungao/github/ClaudeIDE-Mosaic/SYSTEM_PROMPT.md
然后开始 Mosaic 问诊流程
```

---

## 验证安装

### 检查 skill 是否可用

1. 在 Claude Code 中输入 `/mo` 或 `/ma`
2. 应该看到 `/mosaic` 出现在自动补全列表中
3. 或者直接输入 `/mosaic` 并回车

### 测试调用

```
使用 Mosaic 为这个项目设计 UI
```

如果成功，Mosaic 会开始项目探索并问诊。

---

## 安装方式对比

| 方式 | 优点 | 缺点 | 推荐场景 |
|------|------|------|----------|
| **安装脚本** | 简单快速，3种选项 | 需要运行脚本 | 首次安装 |
| **符号链接** | 自动同步更新 | Linux/Mac only | 长期使用 |
| **复制文件** | 完全独立，可自定义 | 需手动更新 | 特殊定制 |
| **引用文件** | 最轻量 | 需要路径正确 | 快速设置 |
| **直接调用** | 无需安装 | 每次都要指定路径 | 临时使用 |

---

## 多项目管理

### 场景 1: 所有项目使用同一版本

**推荐**: 使用符号链接

```bash
# 在每个项目中
cd project1 && ln -s /path/to/mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md
cd project2 && ln -s /path/to/mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md
```

**优点**: Mosaic 更新一次，所有项目自动更新

### 场景 2: 不同项目需要不同配置

**推荐**: 复制文件并自定义

```bash
# 在每个项目中
cp /path/to/mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md

# 然后自定义每个项目的 mosaic.md
```

### 场景 3: 临时测试项目

**推荐**: 直接调用，无需安装

```
请读取 /path/to/mosaic/SYSTEM_PROMPT.md
```

---

## 更新 Mosaic

### 如果使用符号链接

```bash
cd /Users/yukungao/github/ClaudeIDE-Mosaic
git pull
```

**所有使用符号链接的项目会自动获得更新** ✅

### 如果使用复制文件

```bash
cd /Users/yukungao/github/ClaudeIDE-Mosaic
git pull

# 然后在每个项目中重新复制
cd /path/to/your/project
cp /Users/yukungao/github/ClaudeIDE-Mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md
```

或者重新运行安装脚本：

```bash
/Users/yukungao/github/ClaudeIDE-Mosaic/install-to-project.sh /path/to/your/project
# 选择 [2] 复制文件
```

---

## 卸载 Mosaic

### 删除项目中的 skill

```bash
cd /path/to/your/project
rm .claude/skills/mosaic.md
```

### 删除整个 skills 目录（如果只有 Mosaic）

```bash
rm -rf .claude/skills
```

---

## 常见问题

### Q: 为什么我输入 /mo 看不到 /mosaic？

**A**: 检查以下几点：
1. 确认 `.claude/skills/mosaic.md` 文件存在
2. 重启 Claude Code（有时需要重新加载）
3. 检查文件路径是否正确

### Q: 符号链接在 Windows 上能用吗？

**A**: Windows 需要管理员权限创建符号链接，推荐使用复制文件或引用文件方式。

### Q: 我可以修改 skill 文件吗？

**A**: 可以，如果使用复制文件方式。但注意更新时会被覆盖。

### Q: 多个项目可以共享一个 Mosaic 吗？

**A**: 可以，使用符号链接方式最佳。

### Q: 我想在团队中分享 Mosaic，怎么做？

**A**: 两种方式：
1. **推荐**: 让团队成员 git clone Mosaic 仓库，然后用符号链接
2. 或者在团队项目仓库中直接包含 Mosaic（复制所有文件）

---

## 批量安装脚本

如果你有多个项目需要安装 Mosaic：

```bash
#!/bin/bash
# batch-install.sh

MOSAIC_PATH="/Users/yukungao/github/ClaudeIDE-Mosaic"
PROJECTS=(
    "/path/to/project1"
    "/path/to/project2"
    "/path/to/project3"
)

for project in "${PROJECTS[@]}"; do
    echo "Installing Mosaic to $project..."
    mkdir -p "$project/.claude/skills"
    ln -sf "$MOSAIC_PATH/.claude/skills/mosaic.md" "$project/.claude/skills/mosaic.md"
done

echo "✅ Batch installation complete!"
```

---

## 快速参考

```bash
# 方法 1: 安装脚本
/path/to/mosaic/install-to-project.sh

# 方法 2: 符号链接
ln -s /path/to/mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md

# 方法 3: 复制文件
cp /path/to/mosaic/.claude/skills/mosaic.md .claude/skills/mosaic.md

# 方法 4: 直接调用
# 告诉 Agent: "请读取 /path/to/mosaic/SYSTEM_PROMPT.md"

# 验证
# 在 Claude Code 中输入: /mosaic
```

---

## 获取帮助

- **GitHub Issues**: https://github.com/yg1112/ClaudeIDE-Mosaic/issues
- **文档**: `/Users/yukungao/github/ClaudeIDE-Mosaic/README.md`
- **快速开始**: `/Users/yukungao/github/ClaudeIDE-Mosaic/QUICK_START.md`

---

**现在就开始**: 选择一种方式安装，然后在项目中输入 `/mosaic` 或说 "使用 Mosaic 为这个项目设计 UI"！
