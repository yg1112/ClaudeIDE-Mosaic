# Mosaic 工作日志 - 示例

**此为示例日志，展示完整填写后的样子**

---

## 基本信息

```yaml
session_id: 20260118-143022-awesome-app
date: 2026-01-18
time: 14:30:22
mosaic_version: v2.0
```

---

## 项目信息

```yaml
project:
  repository: /Users/dev/github/awesome-app
  project_name: "Awesome Productivity App"
  platform: macOS
  project_type: "生产力工具"
  complexity: medium
```

---

## Phase 0: 项目探索

### 推断结果

```yaml
project_profile:
  inferred_type: "macOS 桌面生产力应用"
  main_features:
    - "任务管理"
    - "日历集成"
    - "笔记功能"
  inferred_users: "专业人士、需要高效工作流的用户"
  inferred_density: medium
  current_ui_state: basic

design_opportunities:
  - "登录界面需要专业简洁的设计"
  - "可以考虑支持 Face ID / Touch ID"
  - "需要与主界面风格保持一致"

user_feedback:
  推断准确性: accurate
  用户纠正: ""
```

---

## Phase 1: 问诊

### 用户画像

```yaml
user_profile:
  mood: "冷静、专业、高效"
  density: "medium"
  reference_apps:
    - "Linear"
    - "Things 3"
  user_context: "专业人士，每天使用 8+ 小时，需要减少视觉疲劳"
  platform: "macOS"
  constraints:
    - "必须支持暗色模式"
    - "不要太花哨的动效"

derived_tags:
  - "minimal"
  - "professional"
  - "dark-mode-first"
  - "elegant"
```

### 参考 App 分析

```yaml
reference_analysis:
  - app: "Linear"
    searched: yes
    search_query: "Linear app design dark theme ui components"
    findings:
      - "深色背景 (#0A0A0B)"
      - "紫色点缀 (#5E6AD2)"
      - "极简布局，大量留白"
      - "快捷键优先设计"

  - app: "Things 3"
    searched: yes
    search_query: "Things 3 design system ui patterns"
    findings:
      - "柔和的浅色为主"
      - "圆角卡片设计"
      - "细腻的阴影和层级"
      - "舒适的视觉节奏"
```

---

## Phase 2: 采购

### 搜索执行记录

```yaml
sourcing_actions:
  preset_resources:
    searched: yes
    matched_count: 3
    resources:
      - name: "VComponents"
        source: "github.com/VakhoKontridze/VComponents"
        level: L1
      - name: "Pow"
        source: "github.com/EmergeTools/Pow"
        level: L1
      - name: "PopupView"
        source: "github.com/exyte/PopupView"
        level: L1

  github_search:
    executed: yes
    queries:
      - query: "swiftui dark theme login components stars:>100"
        results_count: 24
        top_results:
          - name: "SwiftUIAuthKit"
            url: "github.com/example/SwiftUIAuthKit"
            stars: 342
            level: L1
            selected: yes
          - name: "ModernLoginUI"
            url: "github.com/example/ModernLoginUI"
            stars: 189
            level: L2
            selected: no

  figma_search:
    executed: yes
    queries:
      - query: "dark login screen design system"
        findings:
          - title: "Modern Auth UI Kit"
            url: "figma.com/community/file/xxx"
            selected: no

  mobbin_search:
    executed: yes
    apps_searched:
      - "Linear"
      - "Things 3"
    findings:
      - app: "Linear"
        screenshots_saved: yes
        quality: high
      - app: "Things 3"
        screenshots_saved: yes
        quality: high

  ui8_search:
    executed: yes
    findings:
      - title: "Dark Dashboard UI Kit"
        url: "ui8.net/products/xxx"
        quality: medium
        selected: no

  other_sources: []
```

### 资源评估

```yaml
resource_evaluation:
  total_found: 32
  by_level:
    L1: 8
    L2: 5
    L3: 12
    L4: 7

  selected_resources:
    - name: "VComponents"
      source: "github.com/VakhoKontridze/VComponents"
      level: L1
      reason: "现代化设计，支持暗色模式，Swift Package"
    - name: "SwiftUIAuthKit"
      source: "github.com/example/SwiftUIAuthKit"
      level: L1
      reason: "专门的登录组件库，高 stars，活跃维护"
    - name: "Pow"
      source: "github.com/EmergeTools/Pow"
      level: L1
      reason: "高质量动效，提升用户体验"
    - name: "Linear Screenshots"
      source: "Mobbin"
      level: L4
      reason: "作为视觉参考，用户明确喜欢"
```

---

## Phase 3: 方案生成

### 提供的方案

```yaml
proposals:
  - id: A
    name: "极光套装"
    style: "深色主题 + 紫色点缀 + 丝滑动效"
    key_resources:
      - "VComponents (基础组件)"
      - "SwiftUIAuthKit (登录组件)"
      - "Pow (动效)"
    estimated_level: L1

  - id: B
    name: "原生套装"
    style: "系统原生 + 跟随主题 + 零学习成本"
    key_resources:
      - "SwiftUI 原生组件"
      - "SF Symbols"
    estimated_level: L1

  - id: C
    name: "精致套装"
    style: "参考 Things 3 + 柔和浅色 + 细腻阴影"
    key_resources:
      - "VComponents (需要配色调整)"
      - "Things 3 截图参考 (Mobbin)"
    estimated_level: L4

user_selection:
  choice: A
  mix_details: ""
  selection_time: "45"
```

---

## Phase 4: 交付

### 交付模式

```yaml
delivery_mode: standard

standard_delivery:
  generated_files:
    - Design/README.md
    - Design/Foundation/Theme.swift
    - Design/Components/Buttons/PrimaryButton.swift
    - Design/Components/Buttons/SecondaryButton.swift
    - Design/Components/Auth/LoginCard.swift
    - Design/Components/Auth/SocialLoginButtons.swift
    - Design/Components/Auth/BiometricButton.swift
    - Design/UIState/AuthState.swift

  direct_dependencies:
    - name: "VComponents"
      url: "https://github.com/VakhoKontridze/VComponents"
      installation: "Swift Package Manager: github.com/VakhoKontridze/VComponents"
    - name: "SwiftUIAuthKit"
      url: "https://github.com/example/SwiftUIAuthKit"
      installation: "Swift Package Manager: github.com/example/SwiftUIAuthKit"
    - name: "Pow"
      url: "https://github.com/EmergeTools/Pow"
      installation: "Swift Package Manager: github.com/EmergeTools/Pow"

fallback_delivery: null
```

---

## 质量指标

### 推荐质量自评

```yaml
quality_metrics:
  resource_quality:
    rating: high
    reason: "所有资源都是 L1（直接可用），活跃维护，高 stars，文档完整"

  match_score:
    user_preference: 9
    project_suitability: 9

  estimated_implementation_time:
    standard: "2 hours"
    fallback: "N/A"
```

---

## 用户反馈（事后填写）

### 初步反馈

```yaml
initial_feedback:
  satisfied_with_proposals: yes
  comments: "方案 A 完全符合预期，资源质量很高"

  modifications_requested:
    count: 1
    items:
      - "希望主色调紫色稍微淡一点"
```

### 最终采纳情况

```yaml
final_adoption:
  # 此部分在项目完成一周后填写

  status: adopted

  adopted_resources:
    - resource: "VComponents"
      kept_in_final: yes
      reason: ""
    - resource: "SwiftUIAuthKit"
      kept_in_final: yes
      reason: ""
    - resource: "Pow"
      kept_in_final: no
      reason: "用户觉得动效太多，移除了"

  user_satisfaction:
    rating: 9
    feedback: "整体非常满意，只是动效有点多。后端 Agent 实现很顺利。"

  issues_encountered:
    - issue: "Pow 的某个动效在 macOS 上有 bug"
      resolved: yes
      solution: "移除了 Pow，用原生动画替代"
```

---

## 改进建议

### 本次会话的洞察

```yaml
insights:
  what_worked_well:
    - "项目探索阶段的推断非常准确，节省了问诊时间"
    - "WebSearch 找到了高质量的 SwiftUIAuthKit，用户很满意"
    - "Mobbin 的 Linear 截图作为参考很有帮助"

  what_could_improve:
    - "应该在推荐 Pow 时提醒用户可能的性能开销"
    - "可以在方案中提供'精简版'选项（无动效）"

  new_resources_discovered:
    - resource: "SwiftUIAuthKit"
      quality: high
      should_add_to_RESOURCES_md: yes

  search_strategy_notes:
    - "搜索 'swiftui dark theme login' 比 'swiftui login' 更精准"
    - "Mobbin 对于参考 App 的截图质量很高，应该更多使用"
```

---

## 元数据

```yaml
metadata:
  log_created_by: Mosaic Agent
  log_version: 1.0
  conversation_id: "conv_abc123xyz"
  total_time_spent: "18 minutes"

  phases_completion:
    phase_0: completed
    phase_1: completed
    phase_2: completed
    phase_3: completed
    phase_4: completed
```

---

## 附件

```yaml
attachments:
  screenshots:
    - path: "logs/sessions/20260118-143022-awesome-app/screenshots/linear-login.png"
      description: "Linear 登录界面参考"

  reference_designs:
    - path: "logs/sessions/20260118-143022-awesome-app/references/things3-reference.png"
      source: "Mobbin"

  generated_code_samples: []
```

---

**创建时间**: 2026-01-18 14:30:22
**最后更新**: 2026-01-25 10:15:00 (填写最终采纳情况)
