# Mosaic 日志系统

**追踪 Mosaic 的使用情况和推荐质量**

---

## 📋 目的

日志系统用于：

1. ✅ **验证 Agent 调用**：确认 Agent 真的使用了 Mosaic
2. ✅ **追踪推荐质量**：了解哪些资源被采纳，哪些被删除
3. ✅ **发现优化机会**：如果多次迭代才找到满意方案，说明需要改进
4. ✅ **积累知识**：记录成功案例和失败教训
5. ✅ **分析趋势**：了解用户偏好和常见需求

---

## 📁 目录结构

```
logs/
├── README.md                    # 你在这里
├── LOG_TEMPLATE.md              # 日志模板
├── analyze_logs.py              # 日志分析工具
├── sessions/                    # 每次会话的日志
│   ├── EXAMPLE-20260118-project-login-ui.md    # 示例日志
│   ├── 20260118-143022-awesome-app.md          # 实际日志
│   ├── 20260119-092015-another-project.md
│   └── {session_id}/                           # 附件目录
│       ├── screenshots/
│       ├── references/
│       └── code/
└── analysis/                    # 分析报告
    ├── monthly-2026-01.md
    ├── quality-report.md
    └── resources-ranking.md
```

---

## 📝 如何创建日志

### Mosaic Agent 的职责

**每次完成 Phase 4（交付）后，Mosaic 必须**：

1. 复制 `LOG_TEMPLATE.md`
2. 按照模板填写所有字段
3. 保存到 `logs/sessions/{session_id}.md`
4. 告知用户日志已创建

### 日志命名规范

```
格式: YYYYMMDD-HHMMSS-{project_name}.md

示例:
- 20260118-143022-awesome-app.md
- 20260120-091530-login-redesign.md
- 20260125-160045-dashboard-ui.md
```

### 必填字段

```yaml
必须填写（完成时）:
  - 基本信息（全部）
  - 项目信息（全部）
  - Phase 0-4 的所有字段
  - 质量指标 - 推荐质量自评
  - 用户反馈 - 初步反馈

事后填写（1周后）:
  - 用户反馈 - 最终采纳情况
  - 改进建议（基于最终结果）
```

---

## 📊 日志分析

### 手动分析

查看 `sessions/` 目录下的所有日志，关注：

```yaml
推荐质量指标:
  - final_adoption.status = adopted → 成功
  - final_adoption.status = rejected → 失败，需要分析原因

  - modifications_requested.count → 迭代次数
    * 0-1: 很好
    * 2-3: 可以接受
    * 4+: 需要改进问诊流程

  - adopted_resources[].kept_in_final = no → 资源被删除
    * 如果某个资源经常被删除，说明质量有问题

  - user_satisfaction.rating
    * 8-10: 优秀
    * 5-7: 一般
    * 1-4: 差，需要改进
```

### 自动分析（使用脚本）

```bash
cd /Users/yukungao/github/ClaudeIDE-Mosaic/logs

# 生成月度报告
python analyze_logs.py --monthly 2026-01

# 生成质量报告
python analyze_logs.py --quality

# 资源排名
python analyze_logs.py --resources

# 查看所有未填写最终反馈的日志
python analyze_logs.py --pending-feedback
```

---

## 🔍 分析工具使用

### 1. 月度报告

```bash
python analyze_logs.py --monthly 2026-01
```

**输出**：`analysis/monthly-2026-01.md`

包含：
- 总会话数
- 平台分布（macOS / iOS / Web）
- 推荐质量统计
- 用户满意度平均分
- 常见需求分析

---

### 2. 质量报告

```bash
python analyze_logs.py --quality
```

**输出**：`analysis/quality-report.md`

包含：
- 成功率（adopted / total）
- 平均迭代次数
- 常见被删除的资源（需要改进）
- Fallback 使用频率

---

### 3. 资源排名

```bash
python analyze_logs.py --resources
```

**输出**：`analysis/resources-ranking.md`

包含：
- 最常推荐的资源
- 最高采纳率的资源
- 最常被删除的资源（警告）
- 新发现的高质量资源

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

## 🛠️ 维护流程

### 每次会话后（Mosaic 负责）

1. ✅ 填写完整日志（除"最终采纳情况"外）
2. ✅ 保存到 `logs/sessions/{session_id}.md`
3. ✅ 如有附件（截图、参考设计），保存到对应目录
4. ✅ 告知用户日志位置

---

### 每周复盘（你负责）

1. ✅ 检查上周的日志
2. ✅ 填写"最终采纳情况"（如果项目已完成）
3. ✅ 运行 `python analyze_logs.py --quality`
4. ✅ 查看是否有需要改进的地方

---

### 每月总结（你负责）

1. ✅ 运行 `python analyze_logs.py --monthly {YYYY-MM}`
2. ✅ 阅读月度报告
3. ✅ 识别趋势和问题
4. ✅ 更新 RESOURCES.md（移除低质量资源，添加新发现）
5. ✅ 更新搜索策略（如果需要）

---

## 📊 示例分析场景

### 场景 1: 发现低质量资源

```
你查看 analysis/resources-ranking.md，发现：

资源: "OldUIKit"
推荐次数: 5
采纳次数: 1
被删除次数: 4
删除原因:
  - "性能差"（2次）
  - "文档不全"（1次）
  - "样式过时"（1次）

行动:
1. 从 RESOURCES.md 中移除 "OldUIKit"
2. 在下次搜索时不再推荐
3. 记录到改进建议中
```

---

### 场景 2: 发现新的优质资源

```
你查看最近 3 个日志，发现：

资源: "NewAwesomeKit"（通过 GitHub 搜索发现）
推荐次数: 3
采纳次数: 3
用户满意度: 9, 10, 9
用户反馈: "非常好用"、"完美符合需求"

行动:
1. 将 "NewAwesomeKit" 添加到 RESOURCES.md
2. 下次遇到类似项目，优先推荐
```

---

### 场景 3: 发现问诊问题

```
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

### 场景 4: 发现搜索盲点

```
你发现某类项目经常进入 Fallback L2：

项目类型: "数据可视化"
Fallback L2 次数: 4/5（80%）

分析:
- RESOURCES.md 中缺少数据可视化相关资源
- GitHub 搜索策略对这类项目不够有效

行动:
1. 研究数据可视化领域的高质量资源
2. 添加到 RESOURCES.md
3. 更新搜索策略，针对数据可视化的特定关键词
```

---

## 🔧 日志模板字段说明

### 关键字段解释

```yaml
session_id:
  格式: YYYYMMDD-HHMMSS-{project_name}
  用途: 唯一标识一次会话

delivery_mode:
  standard: 找到了可直接使用的资源
  fallback_L1: 找到了参考设计但没代码
  fallback_L2: 完全没找到参考，原创设计

user_selection.choice:
  A / B / C: 选择了某个方案
  mix: 混搭多个方案

final_adoption.status:
  adopted: 完全采纳，项目在使用
  partially_adopted: 部分采纳，删除了一些资源
  rejected: 完全拒绝，重新设计
  unknown: 不知道（项目还没完成或无法追踪）

quality_metrics.match_score:
  user_preference: 1-10，与用户审美的匹配度
  project_suitability: 1-10，与项目类型的适配度
```

---

## 📝 填写示例

### 好的日志（完整且有用）

```yaml
# ✅ 详细记录了搜索过程
github_search:
  executed: yes
  queries:
    - query: "swiftui dark theme login stars:>100"
      results_count: 24
      top_results:
        - name: "SwiftUIAuthKit"
          url: "github.com/example/SwiftUIAuthKit"
          stars: 342
          level: L1
          selected: yes

# ✅ 详细记录了用户反馈
final_adoption:
  status: partially_adopted
  adopted_resources:
    - resource: "VComponents"
      kept_in_final: yes
      reason: ""
    - resource: "Pow"
      kept_in_final: no
      reason: "用户觉得动效太多，移除了"

# ✅ 提出了改进建议
insights:
  what_could_improve:
    - "应该在推荐 Pow 时提醒用户可能的性能开销"
```

### 不好的日志（信息不足）

```yaml
# ❌ 缺少搜索细节
github_search:
  executed: yes
  queries: []  # 没有记录查询

# ❌ 最终反馈没填
final_adoption:
  status: unknown

# ❌ 没有改进建议
insights:
  what_could_improve: []
```

---

## 🎯 使用建议

### 对于 Mosaic Agent

1. **每次完成后立即记录**
   - 不要拖延，趁记忆清晰时填写
   - 尤其是搜索过程和决策原因

2. **详细记录搜索过程**
   - 记录所有搜索查询，即使没找到结果
   - 这有助于改进搜索策略

3. **诚实评价推荐质量**
   - quality_metrics.resource_quality 要客观
   - 不要都标记为 "high"

4. **主动提出改进建议**
   - 每次会话结束，思考哪里可以做得更好
   - 记录到 insights 中

---

### 对于你（用户）

1. **定期查看日志**
   - 每周看一次，了解 Mosaic 的表现
   - 填写"最终采纳情况"

2. **运行分析工具**
   - 每月运行一次分析
   - 查看趋势和问题

3. **根据分析结果优化**
   - 移除低质量资源
   - 添加新发现的资源
   - 改进问诊流程
   - 调整搜索策略

4. **保持日志的价值**
   - 日志不是负担，是改进的依据
   - 定期复盘比事后追溯更有效

---

## 🔗 相关文档

- **日志模板**: `LOG_TEMPLATE.md`
- **示例日志**: `sessions/EXAMPLE-20260118-project-login-ui.md`
- **分析工具**: `analyze_logs.py`
- **Mosaic 规范**: `../SYSTEM_PROMPT.md`

---

## 📞 问题反馈

如果发现日志模板需要改进，或者分析工具缺少某些功能，请：

1. 在日志中记录到 `insights.what_could_improve`
2. 每月总结时收集这些建议
3. 更新模板或工具

---

**日志系统版本**: v1.0
**创建日期**: 2026-01-18
**最后更新**: 2026-01-18
