# Mosaic 工作日志模板

**每次为项目提供设计服务后，Mosaic 必须创建此日志**

---

## 基本信息

```yaml
session_id: YYYYMMDD-HHMMSS-{project_name}
date: YYYY-MM-DD
time: HH:MM:SS
mosaic_version: v2.0
```

---

## 项目信息

```yaml
project:
  repository: /path/to/repository
  project_name: "{项目名称}"
  platform: macOS / iOS / Web
  project_type: "{从 Phase 0 推断的类型}"
  complexity: simple / medium / complex
```

---

## Phase 0: 项目探索

### 推断结果

```yaml
project_profile:
  inferred_type: "{推断的项目类型}"
  main_features:
    - "{功能 1}"
    - "{功能 2}"
  inferred_users: "{推断的用户群体}"
  inferred_density: high / medium / low
  current_ui_state: none / basic / partial / complete

design_opportunities:
  - "{发现的设计机会 1}"
  - "{发现的设计机会 2}"
  - "{发现的设计机会 3}"

user_feedback:
  推断准确性: accurate / partially_accurate / inaccurate
  用户纠正: "{用户的纠正内容，如无则留空}"
```

---

## Phase 1: 问诊

### 用户画像

```yaml
user_profile:
  mood: "{用户选择的感觉标签}"
  density: "{high / low / medium}"
  reference_apps:
    - "{参考 App 1}"
    - "{参考 App 2}"
  user_context: "{用户描述}"
  platform: "{确认的平台}"
  constraints:
    - "{限制 1，如无则删除此行}"

derived_tags:
  - "{派生的风格标签 1}"
  - "{派生的风格标签 2}"
```

### 参考 App 分析

```yaml
reference_analysis:
  - app: "{App 名称}"
    searched: yes / no
    search_query: "{WebSearch 搜索关键词}"
    findings:
      - "{发现的设计特征 1}"
      - "{发现的设计特征 2}"
```

---

## Phase 2: 采购

### 搜索执行记录

```yaml
sourcing_actions:
  preset_resources:
    searched: yes
    matched_count: {数量}
    resources:
      - name: "{资源名称}"
        source: "{来源 URL}"
        level: L1 / L2 / L3 / L4

  github_search:
    executed: yes / no
    queries:
      - query: "{搜索关键词}"
        results_count: {结果数量}
        top_results:
          - name: "{项目名称}"
            url: "{GitHub URL}"
            stars: {star 数量}
            level: L1 / L2 / L3 / L4
            selected: yes / no

  figma_search:
    executed: yes / no
    queries:
      - query: "{搜索关键词}"
        findings:
          - title: "{设计系统标题}"
            url: "{Figma URL}"
            selected: yes / no

  mobbin_search:
    executed: yes / no
    apps_searched:
      - "{App 名称}"
    findings:
      - app: "{App 名称}"
        screenshots_saved: yes / no
        quality: high / medium / low

  ui8_search:
    executed: yes / no
    findings: []

  other_sources:
    - platform: "{平台名称}"
      findings: []
```

### 资源评估

```yaml
resource_evaluation:
  total_found: {总数}
  by_level:
    L1: {直接可用数量}
    L2: {需要配置数量}
    L3: {需要转译数量}
    L4: {仅参考数量}

  selected_resources:
    - name: "{资源名称}"
      source: "{来源 URL}"
      level: L1 / L2 / L3 / L4
      reason: "{选择原因}"
```

---

## Phase 3: 方案生成

### 提供的方案

```yaml
proposals:
  - id: A
    name: "{方案名称}"
    style: "{风格描述}"
    key_resources:
      - "{核心资源 1}"
      - "{核心资源 2}"
    estimated_level: L1 / L2 / L3 / L4

  - id: B
    name: "{方案名称}"
    style: "{风格描述}"
    key_resources:
      - "{核心资源 1}"
    estimated_level: L1 / L2 / L3 / L4

  - id: C
    name: "{方案名称}"
    style: "{风格描述}"
    key_resources:
      - "{核心资源 1}"
    estimated_level: L1 / L2 / L3 / L4

user_selection:
  choice: A / B / C / mix
  mix_details: "{如果是混搭，说明组合方式}"
  selection_time: "{用户选择所花时间，秒}"
```

---

## Phase 4: 交付

### 交付模式

```yaml
delivery_mode: standard / fallback_L1 / fallback_L2

standard_delivery:  # 如果是 standard
  generated_files:
    - Design/README.md
    - Design/Foundation/Theme.swift
    - Design/Components/{组件列表}
    - Design/UIState/{状态文件}

  direct_dependencies:
    - name: "{依赖名称}"
      url: "{GitHub/npm URL}"
      installation: "{安装命令}"

fallback_delivery:  # 如果是 fallback
  level: L1 / L2
  reason: "{为什么进入 Fallback}"

  reference_materials:
    - type: screenshot / design_file / code_snippet
      source: "{来源}"
      path: "Design/Reference/{文件名}"

  implementation_guidance:
    - Design/DECISIONS.md
    - Design/IMPLEMENTATION_TASKS.md
    - Design/IMPLEMENTATION_GUIDE.md (如果 L2)
```

---

## 质量指标

### 推荐质量自评

```yaml
quality_metrics:
  resource_quality:
    rating: high / medium / low
    reason: "{评价理由}"

  match_score:
    user_preference: 1-10
    project_suitability: 1-10

  estimated_implementation_time:
    standard: "{预估小时数} hours"
    fallback: "{预估小时数} hours"
```

---

## 用户反馈（事后填写）

### 初步反馈

```yaml
initial_feedback:
  satisfied_with_proposals: yes / no / partially
  comments: "{用户的初步评价}"

  modifications_requested:
    count: {修改请求次数}
    items:
      - "{修改 1}"
      - "{修改 2}"
```

### 最终采纳情况

```yaml
final_adoption:
  # 此部分在项目完成后填写

  status: adopted / partially_adopted / rejected / unknown

  adopted_resources:
    - resource: "{资源名称}"
      kept_in_final: yes / no
      reason: "{如果被删除，说明原因}"

  user_satisfaction:
    rating: 1-10
    feedback: "{用户的最终反馈}"

  issues_encountered:
    - issue: "{遇到的问题 1}"
      resolved: yes / no
      solution: "{解决方案}"
```

---

## 改进建议

### 本次会话的洞察

```yaml
insights:
  what_worked_well:
    - "{成功的地方 1}"
    - "{成功的地方 2}"

  what_could_improve:
    - "{可以改进的地方 1}"
    - "{可以改进的地方 2}"

  new_resources_discovered:
    - resource: "{新发现的资源}"
      quality: high / medium / low
      should_add_to_RESOURCES_md: yes / no

  search_strategy_notes:
    - "{搜索策略的观察 1}"
    - "{搜索策略的观察 2}"
```

---

## 元数据

```yaml
metadata:
  log_created_by: Mosaic Agent
  log_version: 1.0
  conversation_id: "{如果有的话}"
  total_time_spent: "{总耗时，分钟}"

  phases_completion:
    phase_0: completed / skipped
    phase_1: completed / skipped
    phase_2: completed / skipped
    phase_3: completed / skipped
    phase_4: completed / skipped
```

---

## 附件

```yaml
attachments:
  screenshots:
    - path: "logs/sessions/{session_id}/screenshots/{文件名}"
      description: "{描述}"

  reference_designs:
    - path: "logs/sessions/{session_id}/references/{文件名}"
      source: "{来源 URL}"

  generated_code_samples:
    - path: "logs/sessions/{session_id}/code/{文件名}"
      component: "{组件名称}"
```

---

**日志文件命名规范**: `YYYYMMDD-HHMMSS-{project_name}.md`

**保存路径**: `/Users/yukungao/github/ClaudeIDE-Mosaic/logs/sessions/`
