# Mosaic v2.1 - 日志系统发布

**发布日期**: 2026-01-18

---

## 📝 核心新功能：会话日志系统

### 为什么需要日志系统？

当 Mosaic 被其他项目调用时，我们需要：
1. **验证调用**：确认 Agent 真的使用了 Mosaic，而不是自己写 UI
2. **追踪质量**：了解哪些资源被采纳，哪些被删除
3. **发现优化机会**：如果多次迭代才找到满意方案，说明需要改进
4. **积累知识**：记录成功案例和失败教训

---

## 🎯 主要更新内容

### 1. 新增 Phase 5：日志记录（强制要求）

**Mosaic 现在有 5 个阶段**：
```
Phase 0: 项目探索 (Discovery)
    ↓
Phase 1: 问诊 (Consultation)
    ↓
Phase 2: 采购 (Sourcing)
    ↓
Phase 3: 方案生成 (Proposal)
    ↓
Phase 4: 交付 (Handoff)
    ↓
Phase 5: 日志记录 (Logging) ← 新增！
```

**每次完成 Phase 4 交付后，Mosaic 必须立即创建日志。**

---

### 2. 完整的日志结构

```
logs/
├── README.md                    # 日志系统文档（220+ 行）
├── LOG_TEMPLATE.md              # 日志模板（366 行）
├── analyze_logs.py              # 日志分析工具（388 行）
├── sessions/                    # 会话日志目录
│   ├── EXAMPLE-20260118-project-login-ui.md    # 示例日志（414 行）
│   └── YYYYMMDD-HHMMSS-{project_name}.md       # 实际日志
└── analysis/                    # 分析报告目录
    ├── .gitkeep
    ├── monthly-YYYY-MM.md       # 月度报告（自动生成）
    ├── quality-report.md        # 质量报告（自动生成）
    └── resources-ranking.md     # 资源排名（自动生成）
```

---

### 3. 日志模板详解

**必填字段**（完成时填写）：
```yaml
基本信息:
  - session_id: YYYYMMDD-HHMMSS-{project_name}
  - date, time, mosaic_version

项目信息:
  - repository, project_name, platform
  - project_type, complexity

Phase 0-4 记录:
  - 项目探索推断结果
  - 用户画像和审美偏好
  - 采购过程（所有搜索查询和结果）
  - 提供的方案和用户选择
  - 交付模式和生成的文件

质量指标:
  - 资源质量评分
  - 与用户偏好的匹配度
  - 与项目的适配度
  - 预估实现时间

用户反馈 - 初步:
  - 是否满意方案
  - 修改请求次数和内容
```

**事后填写**（1周后）：
```yaml
用户反馈 - 最终采纳情况:
  - status: adopted / partially_adopted / rejected / unknown
  - adopted_resources: 哪些资源被保留，哪些被删除
  - user_satisfaction: 1-10 评分
  - issues_encountered: 遇到的问题和解决方案

改进建议:
  - what_worked_well: 做得好的地方
  - what_could_improve: 可以改进的地方
  - new_resources_discovered: 是否发现新资源
  - search_strategy_notes: 搜索策略观察
```

---

### 4. 强大的分析工具

**`analyze_logs.py`** 提供 4 种分析功能：

#### 4.1 月度报告
```bash
python analyze_logs.py --monthly 2026-01
```

生成：
- 总会话数
- 平台分布（macOS / iOS / Web）
- 项目复杂度分布
- 交付模式统计
- 用户满意度平均分
- 常见参考 App Top 10

#### 4.2 质量报告
```bash
python analyze_logs.py --quality
```

生成：
- 成功率统计（adopted / partially_adopted / rejected）
- 平均迭代次数
- Fallback 使用频率（警告高频使用 Fallback L2）
- 常被删除的资源 Top 10（建议移除）

**质量评价标准**：
```yaml
优秀：
  - 成功率 > 80%
  - 平均迭代次数 < 2
  - 用户满意度 > 8
  - Fallback L2 使用率 < 5%

良好：
  - 成功率 60-80%
  - 平均迭代次数 2-3
  - 用户满意度 6-8
  - Fallback L2 使用率 5-15%

需要改进：
  - 成功率 < 60%
  - 平均迭代次数 > 3
  - 用户满意度 < 6
  - Fallback L2 使用率 > 15%
```

#### 4.3 资源排名
```bash
python analyze_logs.py --resources
```

生成：
- 最常推荐的资源 Top 20
- 每个资源的：
  - 推荐次数
  - 采纳次数
  - 被删除次数
  - 采纳率（%）
  - 质量评价（✅ 高质量 / ⚠️ 中等 / ❌ 低质量）
  - 删除原因汇总
- 新发现的高质量资源（建议添加到 RESOURCES.md）

#### 4.4 待反馈日志
```bash
python analyze_logs.py --pending-feedback
```

列出所有未填写"最终采纳情况"的日志文件。

---

### 5. 更新的核心文件

#### 5.1 `SYSTEM_PROMPT.md`
- 新增 **Phase 5: 日志记录** 完整章节
- 详细的日志创建流程
- 日志内容重点说明
- 告知用户的标准格式
- 为什么需要日志的解释
- 日志事后维护指南
- 质量标准检查清单新增"已创建日志"

#### 5.2 `.claude/skills/mosaic.md`
- 新增 **Phase 5: 日志记录（强制要求）** 章节
- logging_requirement 说明
- 日志目的总结
- 质量检查清单新增"已创建日志"
- 工作流程总览更新为 5 个阶段

#### 5.3 `README.md`
- 工作原理新增 **5. 日志记录** 章节
- 文件结构新增 `logs/` 目录说明
- 版本历史新增 **v2.1** 发布说明

---

## 📊 使用示例

### 场景 1: 发现低质量资源

```markdown
你查看 analysis/resources-ranking.md，发现：

资源: "OldUIKit"
推荐次数: 5
采纳次数: 1
被删除次数: 4
采纳率: 20%
删除原因:
  - "性能差"（2次）
  - "文档不全"（1次）
  - "样式过时"（1次）

行动:
1. 从 RESOURCES.md 中移除 "OldUIKit"
2. 在下次搜索时不再推荐
```

### 场景 2: 发现新的优质资源

```markdown
你查看最近 3 个日志，发现：

资源: "NewAwesomeKit"（通过 GitHub 搜索发现）
推荐次数: 3
采纳次数: 3
采纳率: 100%
用户满意度: 9, 10, 9
用户反馈: "非常好用"、"完美符合需求"

行动:
1. 将 "NewAwesomeKit" 添加到 RESOURCES.md
2. 下次遇到类似项目，优先推荐
```

### 场景 3: 发现问诊问题

```markdown
你发现连续 5 个日志显示：

modifications_requested.count = 4, 5, 3, 4, 4
平均迭代次数: 4

分析:
- Phase 1 问诊阶段可能问题不够深入
- 用户在看到方案后才发现自己真正想要的

行动:
1. 更新 SYSTEM_PROMPT.md 的问诊流程
2. 添加更多追问问题
3. 在方案展示前先用 ASCII 画原型确认
```

---

## 🔧 维护流程

### 每次会话后（Mosaic 自动执行）
1. ✅ 填写完整日志（除"最终采纳情况"外）
2. ✅ 保存到 `logs/sessions/{session_id}.md`
3. ✅ 如有附件（截图、参考设计），保存到对应目录
4. ✅ 告知用户日志位置

### 每周复盘（用户负责）
1. ✅ 检查上周的日志
2. ✅ 填写"最终采纳情况"（如果项目已完成）
3. ✅ 运行 `python analyze_logs.py --quality`
4. ✅ 查看是否有需要改进的地方

### 每月总结（用户负责）
1. ✅ 运行 `python analyze_logs.py --monthly {YYYY-MM}`
2. ✅ 阅读月度报告
3. ✅ 识别趋势和问题
4. ✅ 更新 RESOURCES.md（移除低质量资源，添加新发现）
5. ✅ 更新搜索策略（如果需要）

---

## 📈 关键指标

### 成功指标

```yaml
优秀（需要保持）:
  - 成功率 > 80%
  - 平均迭代次数 < 2
  - 用户满意度 > 8
  - Fallback L2 使用率 < 5%

良好（可接受）:
  - 成功率 60-80%
  - 平均迭代次数 2-3
  - 用户满意度 6-8
  - Fallback L2 使用率 5-15%

需要改进:
  - 成功率 < 60%
  - 平均迭代次数 > 3
  - 用户满意度 < 6
  - Fallback L2 使用率 > 15%
```

### 警告信号

```yaml
如果出现以下情况，需要优化:
  1. 某个资源在 3 次以上会话中被推荐，但都被删除
     → 从 RESOURCES.md 中移除

  2. 某类项目（如"数据可视化"）经常进入 Fallback L2
     → 需要补充这类资源

  3. 某个搜索查询经常找不到结果
     → 需要调整搜索策略

  4. 用户经常纠正 Phase 0 的推断
     → 需要改进项目探索算法

  5. 迭代次数持续增加
     → 需要改进问诊流程，问更准确的问题
```

---

## 🎯 设计哲学

日志系统的设计遵循以下原则：

1. **透明性**：所有推荐过程都有记录，可追溯
2. **可验证性**：可以验证 Agent 是否真的调用了 Mosaic
3. **持续改进**：通过数据分析发现优化机会
4. **知识积累**：成功案例和失败教训都有价值
5. **用户导向**：最终评价来自真实使用反馈

---

## 📝 文件清单

### 新增文件
- `logs/README.md` - 日志系统完整文档（485 行）
- `logs/LOG_TEMPLATE.md` - 日志模板（366 行）
- `logs/analyze_logs.py` - Python 分析工具（388 行）
- `logs/sessions/EXAMPLE-20260118-project-login-ui.md` - 示例日志（414 行）
- `logs/analysis/.gitkeep` - 分析报告目录占位符
- `CHANGELOG_v2.1.md` - 本文件

### 更新文件
- `SYSTEM_PROMPT.md` - 新增 Phase 5，更新质量标准
- `.claude/skills/mosaic.md` - 新增 Phase 5，更新检查清单
- `README.md` - 新增日志系统介绍，更新文件结构和版本历史

---

## 🚀 下一步

1. **开始使用**：每次 Mosaic 完成交付后，会自动创建日志
2. **事后填写**：1周后填写"最终采纳情况"
3. **定期分析**：每月运行分析工具，查看报告
4. **持续优化**：根据分析结果改进 RESOURCES.md 和搜索策略

---

## 💡 未来展望

日志系统为未来的改进提供了数据基础：

- **智能推荐**：基于历史数据，为类似项目推荐更精准的资源
- **自动优化**：分析工具可以自动建议移除低质量资源
- **趋势预测**：识别设计趋势和用户偏好变化
- **成功案例库**：将高评分案例作为未来参考

---

**Mosaic v2.1 - 让设计推荐更透明、更可靠、更智能**

*创建日期*: 2026-01-18
*作者*: Mosaic Development Team
