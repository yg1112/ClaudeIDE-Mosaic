# 🎨 Mosaic

**一个住在文件夹里的设计总监 Agent**

[![GitHub](https://img.shields.io/badge/GitHub-ClaudeIDE--Mosaic-blue?logo=github)](https://github.com/yg1112/ClaudeIDE-Mosaic)
[![Tests](https://img.shields.io/badge/tests-21%20passed-brightgreen)](./logs/TEST_SUMMARY.md)
[![Python](https://img.shields.io/badge/python-3.9%2B-blue?logo=python)](https://www.python.org/)
[![License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)
[![Version](https://img.shields.io/badge/version-v2.1-orange)](./CHANGELOG_v2.1.md)

---

## 这是什么？

Mosaic 是一个可被任何 Claude IDE 项目调用的**设计服务**。当你在开发一个项目需要UI时，只需让 Agent 读取 Mosaic，它就会：

1. 问你几个简单问题（关于审美偏好，不问技术）
2. 去全球开源市场采购UI组件
3. 生成一套完整的前端交付包，直接放到你的项目里
4. 后端 Agent 可以直接使用，不再讨论UI细节

---

## 如何使用

### 方法 1：使用 Skill 命令（推荐⚡️）

Mosaic 现在支持作为 Claude Code Skill 使用！在任何项目中直接输入：

```bash
/mosaic
```

### 方法 2：自然语言调用

```
帮我设计这个项目的UI
我需要一套前端组件
@mosaic 帮我做前端
```

### 方法 3：明确路径调用

```
请阅读 /path/to/mosaic/SUMMON.md，帮我完成这个项目的UI设计。
```

**详细使用教程请查看 [USAGE.md](./USAGE.md)**

### Mosaic 会做什么

```
你的项目/
├── ... (你原有的代码)
└── Design/                      # ← Mosaic 创建的
    ├── README.md                # 使用说明
    ├── Foundation/              # 主题配置
    │   └── Theme.swift
    ├── Components/              # UI组件
    ├── UIState/                 # 中间层定义
    └── Screens/                 # 页面模板
```

---

## 文件结构说明

```
mosaic/
├── README.md           # 你正在看的文件
├── USAGE.md           # 详细使用教程
├── QUICK_START.md     # 5分钟快速开始
├── CONTRIBUTING.md    # 资源贡献指南
├── SUMMON.md          # 其他项目调用 Mosaic 的入口
├── SYSTEM_PROMPT.md   # CDO Agent 的完整行为定义（v2.1）
├── SPEC.md            # 详细的项目规范（架构、协议、验收标准）
├── RESOURCES.md       # 预置的高质量 UI 资源索引（v2.0 新增平台）
├── TASTE_MAPPING.md   # 感受词 → 设计参数 的映射表
├── COMPONENTS.md      # 常用组件的代码模板
├── .claude/
│   └── skills/
│       └── mosaic.md  # Claude Code Skill 定义（v2.1）
└── logs/              # 日志系统（v2.1 新增）
    ├── README.md              # 日志系统文档
    ├── LOG_TEMPLATE.md        # 日志模板
    ├── analyze_logs.py        # 日志分析工具
    ├── sessions/              # 会话日志
    │   └── EXAMPLE-*.md       # 示例日志
    └── analysis/              # 分析报告
```

---

## 工作原理（v2.0 升级）

### 0. 项目探索 (Discovery) 🆕
**在开始问诊前，Mosaic 会先深入了解你的项目：**
- 使用 Glob/Grep 工具查看项目结构和代码
- 识别项目类型、复杂度、核心功能
- 推断目标用户和使用场景
- 发现设计机会，提出专业建议
- **与你确认推断是否准确**

### 1. 问诊 (Consultation) 🚀
**不是机械问卷，而是设计咨询对话：**
- 基于项目探索结果，问深度问题
- 每个问题后给出专业见解和建议
- 当你提到参考 App，**立即使用 WebSearch 搜索分析**
- 帮你想到你没想到的地方
- 互动讨论，而不是问完就走

### 2. 采购 (Sourcing) 🌐
**具有实时网络搜索能力：**
- 优先查阅 `RESOURCES.md` 中的预置资源（已验证）
- **使用 WebSearch 在 GitHub 实时搜索** 高质量组件库
- **搜索设计平台**：Figma Community, Mobbin, UI8
- **使用 WebFetch 获取资源详情和文档**
- 智能评估资源可用性（L1-L4）

### 3. 选型 (Selection)
展示 2-3 套差异化方案，你只需要做选择题：
- "我选方案 A"
- 或 "我要 A 的颜色 + B 的按钮"

### 4. 交付 (Handoff)
在你的项目中生成完整的 `Design/` 目录，包含：
- Theme.swift（颜色、字体、间距）
- UIState/（中间层状态定义）
- Components/（所有UI组件）
- README.md（使用说明）
- DECISIONS.md（设计决策记录）

### 5. 日志记录 (Logging) 📝
**每次会话后自动创建日志，追踪推荐质量：**
- 记录所有搜索过程和推荐的资源
- 追踪哪些资源被采纳/删除
- 分析推荐质量和迭代次数
- 发现优化机会和新资源
- 验证 Agent 是否真的调用了 Mosaic

详见 [logs/README.md](./logs/README.md)

---

## 核心设计理念

### 用户只做 CEO，不做设计师
- 不问"要不要毛玻璃"
- 只问"你喜欢什么感觉的App"

### 采购优先，不造轮子
- 能用开源库就不自己写
- 市面上没有才转译/自制

### 中间层解耦
- 后端 Model → UIState → 前端 View
- 改后端不影响UI，换UI不影响数据

### 端到端可验收
- 生成的代码可直接编译
- 每个组件有 Preview
- 有明确的验收标准

---

## 扩展 Mosaic

### 贡献新资源

发现了优秀的 UI 组件库或设计平台？欢迎贡献！

查看详细指南：**[CONTRIBUTING.md](./CONTRIBUTING.md)**

快速方法：
1. 编辑 `RESOURCES.md`，添加新资源到对应部分
2. 参考现有格式，填写名称、链接、特点、Level
3. 提交更改

**你提供的资源（已添加✅）**：
- Mobbin - UI & UX 设计灵感平台
- Figma Community - 社区模板和插件
- UI8 - 设计师市场

### 扩充感受词映射
编辑 `TASTE_MAPPING.md`，添加新的"用户怎么说 → 技术怎么做"的映射。

### 添加组件模板
在 `COMPONENTS.md` 中添加新的组件代码模板。

---

## FAQ

### Q: Mosaic 支持什么平台？
A: 目前主要针对 **macOS/iOS (SwiftUI)**，Web 支持正在扩展中。

### Q: 如果我不喜欢生成的设计怎么办？
A: 直接告诉 Agent "换一套按钮风格" 或 "把主色改成蓝色"，Mosaic 会迭代。

### Q: 后端 Agent 怎么知道用什么组件？
A: 每次交付都会生成 `Design/README.md`，里面有完整的使用规范。告诉后端 Agent "按照 Design/README.md 开发"即可。

### Q: Mosaic 会覆盖我现有的代码吗？
A: 不会。Mosaic 只会创建 `Design/` 目录，不会修改你的其他文件。

### Q: 如何测试日志系统？
A: 运行单元测试：
```bash
cd logs/
./run_tests.sh
# 或
python test_analyze_logs.py
```
详见 [logs/TEST_README.md](./logs/TEST_README.md)

---

## 测试

日志系统包含完整的单元测试套件：

- **21 个单元测试** 覆盖所有核心功能
- **测试覆盖率** > 85%
- **CI/CD 集成** 自动运行测试（GitHub Actions）

运行测试：
```bash
cd logs/
./run_tests.sh
```

查看详细测试文档：[logs/TEST_README.md](./logs/TEST_README.md)

---

## 版本历史

- **v2.1** (2026-01-18): 📝 日志系统 - 质量追踪与持续改进
  - 📊 **会话日志系统** - 自动记录每次会话的完整信息
  - 🔍 **推荐质量追踪** - 追踪哪些资源被采纳/删除
  - 📈 **数据分析工具** - Python 脚本生成月度报告、质量报告、资源排名
  - ✅ **验证机制** - 确认 Agent 真的调用了 Mosaic
  - 💡 **优化发现** - 通过日志分析发现改进机会
  - 📁 **完整日志结构** - 模板、示例、分析工具一应俱全

- **v2.0** (2026-01-18): 🚀 重大升级 - 智能化与互动性
  - ✨ **新增 Phase 0：项目探索** - 先理解项目再问诊
  - 🤖 **增强问诊流程** - 深度互动，提供专业见解
  - 🌐 **网络搜索能力** - 实时搜索 GitHub, Figma, Mobbin, UI8
  - 💡 **项目感知** - 基于代码库提出针对性建议
  - 📚 **新增资源平台** - Mobbin, Figma Community, UI8
  - 📖 **贡献指南** - CONTRIBUTING.md 教你如何添加新资源
  - 🔍 **GitHub 搜索策略** - 智能搜索高质量组件库

- **v1.1** (2026-01-18): 添加 Claude Code Skill 支持
  - 创建 `.claude/skills/mosaic.md` Skill 文件
  - 添加详细的 USAGE.md 使用教程
  - 支持 `/mosaic` 命令快速调用

- **v1.0** (2026-01-18): 初始版本
  - 完整的 CDO 工作流
  - SwiftUI 资源索引
  - 组件模板库
  - UIState 中间层架构

---

*Mosaic - 让每个独立开发者都能拥有自己的设计总监*
