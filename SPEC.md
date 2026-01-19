# Design Guide - 项目规范文档 v2.0

> **项目定位**：一个端到端的"审美工程化系统"——将用户模糊的视觉偏好转化为可直接集成的前端资源，通过中间层架构确保前后端解耦、可维护、可调试。

---

## 一、核心问题

独立开发者面临的困境：
- 用户不懂设计语言，无法描述"我要什么样的UI"
- 与AI协作时，口述审美极其低效，反复试错成本高
- 即使找到喜欢的样式，也不知道如何落地到代码
- **更深层的问题**：前后端耦合太紧，一改就崩，debug困难

**类比**：装修时，用户不需要懂"大理石"和"花岗岩"的区别，只需要说"我喜欢冷淡高级的感觉"，然后设计总监去市场采购合适的材料——**而且这个设计总监还要确保水电工和瓦工能对接上，不会出现"插座位置和家具冲突"的问题**。

---

## 二、系统角色定义

### Chief Design Officer (CDO) Agent

**它是什么**：
- 连接"用户抽象审美"与"工程落地"的桥梁
- 不自己绘制UI，而是去全球开源市场采购现成组件
- **能直接与前端/后端Agent对话**，用工程语言交付
- **负责定义中间层**，确保前后端解耦
- 最终交付的不只是"设计稿"，而是**可集成、可验收的工程包**

**它不是什么**：
- 不是设计师（不做原创设计）
- 不是前端工程师（不写底层实现）
- 不是让用户回答技术问题的问卷系统

**关键能力**：
- 如果采购的资源不能直接用 → 指挥一个Agent做"高保真转译"
- 如果前后端接口不清晰 → 主动定义UIState中间层
- 如果集成出问题 → 按验收标准定位问题环节

---

## 三、工作流程（The CDO Loop）

```
┌─────────────────────────────────────────────────────────────────┐
│  Phase 1: 问诊 (Consultation)                                    │
│  ───────────────────────────                                    │
│  目标：用非技术语言理解用户的审美偏好                              │
│  输出：用户画像 + 风格标签                                        │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 2: 采购 (Sourcing)                                        │
│  ───────────────────────────                                    │
│  目标：基于风格标签，在全球开源市场搜索匹配的UI资源                  │
│  输出：3套候选方案（每套包含具体的库/组件/参考图）                   │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 3: 选型 (Selection)                                       │
│  ───────────────────────────                                    │
│  目标：展示方案，让用户做选择题（而非填空题）                        │
│  输出：用户确认的最终方案                                         │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│  Phase 4: 交付 (Handoff)                                         │
│  ───────────────────────────                                    │
│  目标：生成标准化的"施工包"                                       │
│  输出：Theme文件 + 依赖清单 + 组件映射表 + 参考截图                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 四、核心架构：UIState 中间层

> **这是整个系统最关键的设计决策**：在后端Model和前端View之间，插入一个UIState中间层。

### 为什么需要中间层？

**问题场景**：
- 后端某个函数改了名字 → 所有调用这个函数的UI都要改
- 前端想换一个动画库 → 担心会影响数据绑定
- Debug时不知道问题出在后端逻辑还是前端渲染

**解决方案**：UIState作为"合同"，两边都只跟合同对话

```
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│   后端 Model     │ ──→ │   UIState层     │ ──→ │   前端 View      │
│   (业务逻辑)     │      │   (状态合同)    │      │   (视觉呈现)     │
└─────────────────┘      └─────────────────┘      └─────────────────┘
        │                        │                        │
   可以随意重构            保持接口稳定             可以随意换皮
   只要输出符合合同         定义"什么数据"           只要消费合同数据
                          "什么时机"
                          "什么状态"
```

### UIState 的职责

1. **定义屏幕/场景**：App有哪些"幕"（Screen）
2. **定义每幕的状态**：每个场景可能处于什么状态（loading/success/error/empty）
3. **定义数据契约**：每个状态需要什么数据来渲染
4. **定义转场触发**：什么条件触发从A幕到B幕

### UIState 数据结构定义

```swift
// ═══════════════════════════════════════════════════════════════
// UIState.swift - 中间层定义文件
// CDO Agent 生成，前后端都必须遵守此合同
// ═══════════════════════════════════════════════════════════════

// MARK: - 场景枚举（App有哪些"幕"）
enum AppScreen: String, CaseIterable {
    case onboarding      // 新手引导
    case home            // 主页
    case detail          // 详情页
    case settings        // 设置页
    // ... CDO根据产品需求定义
}

// MARK: - 通用状态（每个场景都可能有的状态）
enum LoadingState<T> {
    case idle                    // 初始态
    case loading                 // 加载中
    case success(T)              // 成功，附带数据
    case error(UIErrorState)     // 失败，附带错误信息
    case empty                   // 成功但无数据
}

// MARK: - 错误状态（统一错误展示）
struct UIErrorState {
    let code: String             // 错误码，用于debug
    let userMessage: String      // 给用户看的友好提示
    let retryAction: (() -> Void)?  // 重试按钮的回调
}

// MARK: - 具体场景的UIState示例
struct HomeScreenState {
    var dataList: LoadingState<[DataItem]>
    var userProfile: UserProfileState
    var activeModal: ModalType?   // 当前弹窗
}

struct UserProfileState {
    var avatarURL: URL?
    var displayName: String
    var notificationBadge: Int    // 通知红点数字
}

enum ModalType {
    case confirmDialog(title: String, message: String, onConfirm: () -> Void)
    case toast(message: String, style: ToastStyle)
    case fullScreenLoading(message: String)
}

// MARK: - 转场事件（什么触发场景切换）
enum NavigationEvent {
    case userTappedItem(id: String)      // 用户点击列表项 → 跳转详情
    case userRequestedSettings           // 用户点击设置 → 跳转设置页
    case sessionExpired                  // 登录过期 → 跳转登录页
    // ... 根据产品流程定义
}
```

### 前后端如何与中间层对接

**后端（Model层）的职责**：
```swift
// 后端只负责：接收事件 → 处理业务逻辑 → 更新UIState
class HomeViewModel {
    @Published var state: HomeScreenState
    
    func handleEvent(_ event: UserEvent) {
        switch event {
        case .refresh:
            state.dataList = .loading
            // 调用业务逻辑...
            // 最终更新：state.dataList = .success(data)
        }
    }
}
// ✅ 后端可以随意重构内部实现，只要最终输出的state符合UIState定义
```

**前端（View层）的职责**：
```swift
// 前端只负责：读取UIState → 渲染对应视觉
struct HomeScreen: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        switch viewModel.state.dataList {
        case .loading:
            LoadingSpinner()  // 用CDO指定的加载组件
        case .success(let items):
            DataListView(items: items)  // 用CDO指定的列表组件
        case .error(let error):
            ErrorView(state: error)  // 用CDO指定的错误组件
        case .empty:
            EmptyStateView()  // 用CDO指定的空状态组件
        case .idle:
            EmptyView()
        }
    }
}
// ✅ 前端可以随意换组件/动画，只要它消费的是UIState里的数据
```

### CDO Agent 在中间层的职责

CDO负责定义并交付：

1. **场景清单**：这个App有哪些Screen
2. **状态枚举**：每个Screen有哪些状态
3. **数据契约**：每个状态需要什么字段
4. **组件映射**：每个状态用什么UI组件来渲染

```yaml
# CDO 交付的 UIState 映射表
screens:
  home:
    states:
      loading:
        component: "SkeletonLoader"
        source: "从Pow库调用"
      success:
        component: "DataListView"  
        source: "自定义组件，参照Linear列表风格"
        data_required: ["items: [DataItem]", "lastUpdated: Date"]
      error:
        component: "ErrorCard"
        source: "VComponents库"
        data_required: ["errorState: UIErrorState"]
      empty:
        component: "EmptyIllustration"
        source: "从Figma导出的插画 + 文案"
```

---

## 五、组件落地协议

> **核心原则**：采购回来的东西，必须能装上去。如果不能直接装，CDO要指挥转译。

### 资源可用性分级

| 级别 | 定义 | CDO行动 |
|------|------|---------|
| **L1: 即插即用** | Swift Package，直接import使用 | 写入Dependencies.md，完成 |
| **L2: 需配置** | 需要初始化/主题配置才能用 | 提供配置代码模板 |
| **L3: 需转译** | 是React/Web组件或Figma设计稿 | 指挥转译Agent做SwiftUI复刻 |
| **L4: 仅参考** | 只是截图/灵感图 | 指挥转译Agent做像素级还原 |

### L3/L4 转译协议

当采购的资源不能直接用时，CDO需要生成转译指令：

```yaml
# 转译任务单
translation_task:
  source:
    type: "figma_design"  # 或 react_component / screenshot
    url: "https://figma.com/file/xxx"
    screenshot: "references/toast-design.png"
    
  target:
    language: "SwiftUI"
    filename: "CustomToast.swift"
    
  specifications:
    # 从源文件提取的关键参数
    dimensions:
      width: "fill_parent"
      height: "auto"
      padding: "16px"
      corner_radius: "12px"
    colors:
      background: "#1A1A1A"
      text: "#FFFFFF"
      accent: "#7C3AED"
    typography:
      font: "SF Pro"
      size: "14px"
      weight: "medium"
    animation:
      enter: "slide_from_top, 0.3s, ease_out"
      exit: "fade_out, 0.2s"
      
  acceptance_criteria:
    - "视觉还原度 > 95%（肉眼看不出区别）"
    - "支持深色/浅色模式切换"
    - "动画流畅度 60fps"
    - "能正确消费UIState.ModalType.toast数据"
```

### 转译Agent的工作流程

```
CDO发现需要转译的资源
        ↓
生成转译任务单（包含所有视觉参数）
        ↓
转译Agent接收任务
        ↓
生成SwiftUI代码
        ↓
CDO验收（见验收标准）
        ↓
通过 → 加入组件库
失败 → 返回具体问题，迭代
```

---

## 六、UI组件与场景映射表

> **这张表是CDO交给后端Agent的"施工图"**：什么场景用什么组件

### 映射表结构

```yaml
# ComponentSceneMapping.yaml
# CDO生成，后端Agent必须遵守

global_components:
  # 全局通用组件，所有场景都可能用到
  loading_spinner:
    component: "PulseLoader"
    source: "Pow库"
    usage: "任何loading状态"
    props: ["size: .medium", "color: AppTheme.Colors.primary"]
    
  error_card:
    component: "VAlert"
    source: "VComponents库"
    usage: "任何error状态"
    props: ["state: .error", "title: error.userMessage"]
    
  toast:
    component: "PopupView"
    source: "PopupView库"
    usage: "UIState.activeModal == .toast时"
    props: ["type: .toast", "position: .top"]

screens:
  home:
    layout: "NavigationSplitView"  # 整体布局容器
    
    regions:
      sidebar:
        component: "SidebarView"
        source: "CodeEditUI库"
        binds_to: "state.sidebarItems"
        
      main_content:
        when_loading:
          component: "SkeletonList"
          source: "自定义转译组件"
        when_success:
          component: "DataGrid"
          source: "自定义转译组件，参照Linear"
          binds_to: "state.dataList.successValue"
        when_empty:
          component: "EmptyState"
          source: "自定义，含插画"
        when_error:
          component: "global.error_card"
          
      floating:
        # 浮动层（弹窗、toast等）
        component: "根据state.activeModal动态渲染"
        
  detail:
    layout: "ScrollView"
    regions:
      header:
        component: "HeroHeader"
        source: "自定义转译"
        binds_to: "state.item.headerInfo"
      # ... 更多区域定义
```

### 后端Agent如何使用这张表

```swift
// 后端Agent看到映射表后，应该这样写代码：

struct HomeScreen: View {
    @StateObject var viewModel: HomeViewModel
    
    var body: some View {
        // 1. 使用映射表指定的布局容器
        NavigationSplitView {
            // 2. sidebar区域 → 使用CodeEditUI的SidebarView
            SidebarView(items: viewModel.state.sidebarItems)
        } detail: {
            // 3. main_content区域 → 根据状态切换组件
            mainContentView
        }
        // 4. floating层 → 根据activeModal渲染
        .overlay { modalOverlay }
    }
    
    @ViewBuilder
    var mainContentView: some View {
        switch viewModel.state.dataList {
        case .loading:
            SkeletonList()  // 映射表指定的loading组件
        case .success(let items):
            DataGrid(items: items)  // 映射表指定的success组件
        case .empty:
            EmptyState()  // 映射表指定的empty组件
        case .error(let error):
            VAlert(state: .error, title: error.userMessage)  // 全局error组件
        case .idle:
            EmptyView()
        }
    }
}
```

---

## 七、验收标准与调试协议

> **End-to-End的成功定义**：不是"图片fetch回来了"，而是"用户能正常使用这个功能"

### 分层验收标准

#### Layer 1: 资源层验收
```yaml
resource_acceptance:
  criteria:
    - "Swift Package能成功resolve（无依赖冲突）"
    - "图片资源能正确加载（格式兼容、尺寸合适）"
    - "字体资源已正确注册到Info.plist"
  
  test_method:
    - "运行 swift package resolve，无错误"
    - "在Preview中渲染Image(资源名)，图片显示正常"
    
  failure_action:
    - "记录具体错误信息"
    - "检查是否需要降级版本或寻找替代库"
```

#### Layer 2: 组件层验收
```yaml
component_acceptance:
  criteria:
    - "组件在SwiftUI Preview中能正确渲染"
    - "组件支持传入的所有props"
    - "组件在深色/浅色模式下都正常显示"
    - "动画流畅度达到60fps"
    
  test_method:
    - "每个组件必须有对应的Preview"
    - "Preview必须覆盖所有状态变体"
    
  preview_template: |
    #Preview("ComponentName - All States") {
        VStack(spacing: 20) {
            ComponentName(state: .default)
            ComponentName(state: .loading)
            ComponentName(state: .error)
            ComponentName(state: .disabled)
        }
        .padding()
        .background(Color(.systemBackground))
    }
    
  failure_action:
    - "截图当前渲染结果"
    - "对比参考图，标注差异点"
    - "生成修复任务单"
```

#### Layer 3: 集成层验收
```yaml
integration_acceptance:
  criteria:
    - "组件能正确绑定UIState数据"
    - "状态变化时UI能正确响应"
    - "用户交互能正确触发事件"
    
  test_method:
    - "在真实ViewModel下测试，而非Mock数据"
    - "手动触发所有状态转换，观察UI响应"
    
  test_scenarios:
    - name: "Loading → Success转换"
      steps:
        - "设置state.dataList = .loading"
        - "验证显示SkeletonList"
        - "设置state.dataList = .success(mockData)"
        - "验证SkeletonList消失，DataGrid显示"
        - "验证DataGrid内容与mockData一致"
        
    - name: "用户点击触发导航"
      steps:
        - "点击列表项"
        - "验证NavigationEvent.userTappedItem被发送"
        - "验证跳转到详情页"
        - "验证详情页收到正确的itemId"
        
  failure_action:
    - "记录失败的场景和步骤"
    - "检查UIState定义是否完整"
    - "检查组件绑定是否正确"
```

#### Layer 4: 端到端验收
```yaml
e2e_acceptance:
  criteria:
    - "用户能完成核心任务流程"
    - "视觉呈现符合设计预期"
    - "性能指标达标（启动时间、滚动流畅度）"
    
  test_method:
    - "模拟真实用户操作完整流程"
    - "截图/录屏与设计稿对比"
    
  checklist:
    visual:
      - "颜色与Theme定义一致"
      - "间距与Spacing定义一致"
      - "字体层级正确"
      - "图标正确使用SF Symbols"
    functional:
      - "所有按钮可点击"
      - "所有输入框可输入"
      - "所有状态转换正常"
    performance:
      - "列表滚动60fps"
      - "转场动画无卡顿"
```

### 调试协议

当出现问题时，按此流程定位：

```
问题发生
    ↓
Step 1: 确定问题层级
    ├─ 资源加载失败？ → Layer 1问题
    ├─ 组件渲染异常？ → Layer 2问题
    ├─ 状态不同步？   → Layer 3问题
    └─ 流程走不通？   → Layer 4问题
    ↓
Step 2: 隔离测试
    ├─ Layer 1: 单独import包，检查依赖
    ├─ Layer 2: 在Preview中用硬编码数据测试
    ├─ Layer 3: 打印UIState变化日志
    └─ Layer 4: 录屏回放，定位卡住的环节
    ↓
Step 3: 生成修复任务
    - 明确问题描述
    - 附上截图/日志
    - 指定预期行为
    - 分配给对应Agent
```

### 日志规范

为了便于调试，UIState变化应该有日志：

```swift
// 在ViewModel中添加状态变化日志
class HomeViewModel: ObservableObject {
    @Published var state: HomeScreenState {
        didSet {
            #if DEBUG
            print("📊 [UIState] HomeScreen.dataList: \(oldValue.dataList) → \(state.dataList)")
            #endif
        }
    }
}
```

---

## 八、模块详细设计

### Module 1: 问诊引擎 (Consultation Engine)

**设计原则**：
- 用户只回答"感受题"，不回答"技术题"
- 问题数量控制在5个以内
- 每个问题都有具象化的参照物

**问题维度框架**：

| 维度 | 用户看到的问题 | 背后映射的技术参数 |
|------|--------------|------------------|
| 情绪氛围 | "你希望用户打开软件时的第一感觉是？" | 色温、对比度、留白比例 |
| 信息密度 | "你的软件更像报纸还是杂志？" | 字号层级、间距系统、组件密度 |
| 品牌个性 | "你希望它'隐身'融入系统，还是有强烈的独特感？" | 是否使用系统原生控件 |
| 参照对标 | "说出2-3个你觉得好看的App" | 直接作为采购搜索关键词 |
| 目标用户 | "你的用户每天用什么工具工作？" | 决定风格熟悉度方向 |

**输出格式**：
```yaml
user_profile:
  vibe: "cold-professional"  # 冷静专业 / 温暖亲切 / 前卫大胆
  density: "high"            # 高密度 / 中等 / 大留白
  personality: "branded"     # 系统融入 / 轻度品牌 / 强品牌
  references: ["Linear", "Raycast", "Arc"]
  target_users: "developers and data scientists"
  
derived_tags: ["dark-mode", "minimal", "tool-first", "keyboard-centric"]
```

---

### Module 2: 映射层 (Taste-to-Token Mapper)

**核心功能**：将"感受词"翻译成"设计参数"

**映射表结构**：

```yaml
# 感受词 → 设计参数映射
taste_mappings:
  "高级感":
    colors: "低饱和度、黑白灰为主、点缀色克制"
    typography: "细字重、大字号标题、充足行高"
    spacing: "大留白、元素间距宽松"
    effects: "微妙阴影、无描边或细描边"
    
  "科技感":
    colors: "深色背景、霓虹点缀、渐变光效"
    typography: "等宽字体、中等字重"
    spacing: "紧凑但有序"
    effects: "发光、毛玻璃、动态渐变"
    
  "亲切感":
    colors: "暖色调、柔和饱和度"
    typography: "圆体、适中字重"
    spacing: "舒适间距"
    effects: "圆角、柔和阴影、插画元素"
    
  "专业工具感":
    colors: "中性色、功能性配色"
    typography: "易读性优先、清晰层级"
    spacing: "信息密集但有组织"
    effects: "扁平、最小装饰"
```

**扩展要求**：此映射表应支持持续扩充，每个新的用户案例都可以丰富这个知识库。

---

### Module 3: 采购引擎 (Sourcing Engine)

**搜索域（按优先级排序）**：

1. **GitHub** - 开源UI库/组件库
   - 搜索关键词模板：`{技术栈} + {风格标签} + UI`
   - 筛选标准：Star > 500，最近6个月有更新
   
2. **Swift Package Index** - 针对Apple生态
   - 专门的SwiftUI组件搜索
   
3. **Figma Community** - 设计稿参考
   - 用于获取视觉参照图，指导"像素级复刻"
   
4. **Mobbin / Dribbble** - 成品截图库
   - 用于"我要像这个App一样"的场景

**采购条目数据结构**：

```yaml
sourced_item:
  name: "VComponents"
  type: "component-library"
  source: "https://github.com/VakhoKontworker/VComponents"
  tech_stack: "SwiftUI"
  style_tags: ["minimal", "dark-mode", "modern"]
  last_updated: "2024-12-01"
  stars: 1200
  install_command: "swift package add VComponents"
  preview_images: ["url1", "url2"]
  covers_components: ["Button", "TextField", "Card", "Toast"]
  notes: "类似Vercel设计风格，适合SaaS应用"
```

---

### Module 4: 方案生成器 (Proposal Generator)

**每套方案必须包含**：

```yaml
proposal:
  name: "方案A：极光套装 (The Aurora Pack)"
  style_summary: "深色底、紫色微光、丝滑动效——像Linear的高级质感"
  
  components:
    base_ui_library:
      name: "VComponents"
      source: "github_url"
      reason: "提供完整的基础控件，风格现代"
      
    animation_library:
      name: "Pow"
      source: "github_url"  
      reason: "处理状态变更的微动效"
      
    icon_system:
      name: "SF Symbols 5.0"
      usage: "Multicolor模式，配合深色主题"
      
    chart_library:
      name: "SwiftUICharts"
      source: "github_url"
      reason: "支持渐变曲线，视觉效果好"
      
  visual_references:
    - "Linear App侧边栏截图"
    - "Arc浏览器标签页截图"
    
  estimated_integration_effort: "中等 - 需要配置主题色"
```

**方案数量**：始终提供3套差异化方案，覆盖不同风格倾向。

---

### Module 5: 交付包生成器 (Handoff Package Generator)

**最终交付物结构**：

```
/design-handoff/
├── README.md                        # 施工总览，给人类和Agent看
│
├── 01-Foundation/                   # 基础层
│   ├── Theme.swift                  # 设计变量（颜色、字体、间距）
│   ├── Dependencies.md              # 依赖清单 + 安装命令
│   └── Assets/                      # 静态资源（图片、图标、字体）
│
├── 02-UIState/                      # 中间层
│   ├── UIState.swift                # 状态定义（场景、状态枚举、数据契约）
│   ├── NavigationEvents.swift       # 导航事件定义
│   └── StateFlowDiagram.md          # 状态流转图（Mermaid格式）
│
├── 03-Components/                   # 组件层
│   ├── ComponentMapping.md          # 组件使用规范
│   ├── GlobalComponents/            # 全局通用组件
│   │   ├── LoadingSpinner.swift
│   │   ├── ErrorCard.swift
│   │   └── Toast.swift
│   └── ScreenComponents/            # 场景专用组件
│       ├── Home/
│       └── Detail/
│
├── 04-Integration/                  # 集成层
│   ├── ScreenTemplates/             # 每个场景的View模板
│   │   ├── HomeScreen.swift
│   │   └── DetailScreen.swift
│   └── WiringGuide.md               # 前后端对接指南
│
├── 05-Testing/                      # 验收层
│   ├── AcceptanceCriteria.md        # 验收标准
│   ├── TestScenarios.yaml           # 测试场景
│   └── VisualReferences/            # 视觉参考图
│       ├── home-loading.png
│       ├── home-success.png
│       └── home-error.png
│
└── 06-Prompts/                      # Agent指令层
    ├── FOR_BACKEND_AGENT.md         # 给后端Agent的完整指令
    ├── FOR_FRONTEND_AGENT.md        # 给前端/转译Agent的指令
    └── FOR_DEBUG_AGENT.md           # 出问题时的调试指令
```

**关键文件内容模板**：

#### Theme.swift
```swift
// ═══════════════════════════════════════════════════════════════
// Theme.swift - 设计基础变量
// Design Guide 自动生成 | 方案：{方案名称}
// ⚠️ 此文件由CDO管理，后端Agent禁止直接修改
// ═══════════════════════════════════════════════════════════════

import SwiftUI

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        static let background = Color(hex: "#0A0A0A")
        static let surface = Color(hex: "#1A1A1A")
        static let surfaceElevated = Color(hex: "#2A2A2A")
        static let primary = Color(hex: "#7C3AED")
        static let primaryHover = Color(hex: "#9333EA")
        static let success = Color(hex: "#22C55E")
        static let warning = Color(hex: "#F59E0B")
        static let error = Color(hex: "#EF4444")
        static let textPrimary = Color.white
        static let textSecondary = Color.white.opacity(0.6)
        static let textTertiary = Color.white.opacity(0.4)
        static let border = Color.white.opacity(0.1)
    }
    
    // MARK: - Typography
    struct Typography {
        static let displayLarge = Font.system(size: 36, weight: .bold)
        static let titleLarge = Font.system(size: 28, weight: .bold)
        static let titleMedium = Font.system(size: 20, weight: .semibold)
        static let titleSmall = Font.system(size: 16, weight: .semibold)
        static let bodyLarge = Font.system(size: 16, weight: .regular)
        static let body = Font.system(size: 14, weight: .regular)
        static let bodySmall = Font.system(size: 12, weight: .regular)
        static let caption = Font.system(size: 11, weight: .regular)
        static let mono = Font.system(size: 13, weight: .regular, design: .monospaced)
    }
    
    // MARK: - Spacing (8pt grid system)
    struct Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
    }
    
    // MARK: - Radius
    struct Radius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
        static let full: CGFloat = 9999
    }
    
    // MARK: - Effects
    struct Effects {
        static let shadowSmall = Shadow(color: .black.opacity(0.1), radius: 2, y: 1)
        static let shadowMedium = Shadow(color: .black.opacity(0.15), radius: 8, y: 4)
        static let shadowLarge = Shadow(color: .black.opacity(0.2), radius: 16, y: 8)
        static let blur: Material = .ultraThinMaterial
    }
    
    // MARK: - Animation
    struct Animation {
        static let fast = SwiftUI.Animation.easeOut(duration: 0.15)
        static let normal = SwiftUI.Animation.easeInOut(duration: 0.25)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.4)
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
}

// MARK: - Helpers
struct Shadow {
    let color: Color
    let radius: CGFloat
    let y: CGFloat
}

extension Color {
    init(hex: String) {
        // 标准hex转Color实现
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
```

#### FOR_BACKEND_AGENT.md
```markdown
# 后端Agent施工指令

## 你的角色
你是负责实现业务逻辑的后端Agent。UI相关的所有决策已由CDO完成，你只需要：
1. 实现ViewModel，更新UIState
2. 调用CDO指定的组件
3. 遵守本文档的规范

## 禁止行为 ❌
- 自行设计UI样式（颜色、间距、圆角等）
- 使用系统默认控件后自行美化
- 修改Theme.swift中的任何值
- 在UIState之外传递UI数据

## 必须行为 ✅
- 所有颜色使用 `AppTheme.Colors.xxx`
- 所有间距使用 `AppTheme.Spacing.xxx`
- 所有组件按 `ComponentMapping.md` 调用
- 状态变化通过 `UIState` 传递

## 工作流程
1. 阅读 `02-UIState/UIState.swift` 了解状态定义
2. 阅读 `03-Components/ComponentMapping.md` 了解组件用法
3. 参考 `04-Integration/ScreenTemplates/` 中的模板开始开发
4. 遇到问题查阅 `05-Testing/AcceptanceCriteria.md`

## 状态更新示例
// 正确做法
func loadData() {
    state.dataList = .loading  // UI自动显示loading组件
    
    Task {
        do {
            let data = try await api.fetchData()
            state.dataList = .success(data)  // UI自动切换到列表
        } catch {
            state.dataList = .error(UIErrorState(
                code: "FETCH_FAILED",
                userMessage: "加载失败，请重试",
                retryAction: { [weak self] in self?.loadData() }
            ))  // UI自动显示错误卡片
        }
    }
}
```

---

## 九、技术架构总览

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              用户 (CEO角色)                                  │
│                         只做选择题，不做技术决策                              │
└─────────────────────────────────────────────────────────────────────────────┘
                                     ↕ 自然语言
┌─────────────────────────────────────────────────────────────────────────────┐
│                           CDO Agent (本系统)                                 │
│  ┌───────────┐   ┌───────────┐   ┌───────────┐   ┌───────────┐             │
│  │  问诊引擎  │ → │  映射层   │ → │  采购引擎  │ → │ 方案生成器 │             │
│  └───────────┘   └───────────┘   └───────────┘   └───────────┘             │
│        ↓                               ↓                ↓                   │
│  ┌───────────┐         ┌─────────────────────┐   ┌───────────┐             │
│  │ UIState   │         │ 外部资源             │   │ 交付包    │             │
│  │ 中间层定义 │         │ (GitHub/Figma/etc)  │   │ 生成器    │             │
│  └───────────┘         └─────────────────────┘   └───────────┘             │
│                                                        ↓                    │
│                              ┌─────────────────────────────────┐           │
│                              │        完整工程交付包            │           │
│                              │  Theme + UIState + Components   │           │
│                              │  + Mapping + Tests + Prompts    │           │
│                              └─────────────────────────────────┘           │
└─────────────────────────────────────────────────────────────────────────────┘
                                     ↓ 结构化交付包
        ┌────────────────────────────┼────────────────────────────┐
        ↓                            ↓                            ↓
┌───────────────┐          ┌───────────────┐          ┌───────────────┐
│  转译 Agent    │          │  后端 Agent   │          │  调试 Agent   │
│  (L3/L4资源    │          │  (业务逻辑    │          │  (问题定位    │
│   高保真复刻)  │          │   ViewModel)  │          │   修复迭代)   │
└───────────────┘          └───────────────┘          └───────────────┘
        │                            │                            │
        └────────────────────────────┼────────────────────────────┘
                                     ↓
                          ┌─────────────────────┐
                          │    最终产品 App     │
                          │  (可验收、可维护)   │
                          └─────────────────────┘
```

### 数据流详解

```
用户偏好（自然语言）
    ↓ Phase 1: 问诊
风格标签 + 用户画像
    ↓ Phase 2: 映射
设计参数（技术语言）
    ↓ Phase 3: 采购
候选资源列表
    ↓ Phase 4: 选型
确认的资源组合
    ↓ Phase 5: 交付
    ├─→ Theme.swift（设计变量）
    ├─→ UIState.swift（状态合同）
    ├─→ Components/（组件代码）
    ├─→ Mapping（使用规范）
    └─→ Tests（验收标准）
    ↓ 后端Agent开发
    ↓ 验收测试
最终可用的App
```

---

## 十、完整验收清单

### 项目级验收（Design Guide系统本身）

| 验收项 | 标准 | 检验方法 |
|--------|------|---------|
| 问诊效率 | 用户在5个问题内完成偏好表达 | 计时测试 |
| 方案真实性 | 每套方案的资源链接都真实可用 | 点击验证 |
| Theme可用性 | 生成的Theme.swift可直接编译 | Xcode编译 |
| UIState完整性 | 覆盖App所有场景和状态 | Checklist对照 |
| 组件覆盖率 | Mapping覆盖80%以上常见UI | 场景枚举 |
| Agent可执行 | 后端Agent无需再问视觉问题 | 实际测试 |

### 单次交付验收（每个具体项目）

```yaml
acceptance_checklist:
  foundation:
    - [ ] Theme.swift 编译通过
    - [ ] 所有依赖包 resolve 成功
    - [ ] 静态资源加载正常
    
  ui_state:
    - [ ] 所有Screen枚举已定义
    - [ ] 所有LoadingState已覆盖
    - [ ] 导航事件完整
    - [ ] 状态流转图与代码一致
    
  components:
    - [ ] 所有组件有Preview
    - [ ] Preview覆盖所有状态变体
    - [ ] 深色/浅色模式正常
    - [ ] 动画60fps
    
  integration:
    - [ ] 每个Screen模板可运行
    - [ ] 状态绑定正确
    - [ ] 交互触发正确
    
  visual:
    - [ ] 与参考图对比，还原度>95%
    - [ ] 间距符合Theme定义
    - [ ] 颜色符合Theme定义
```

---

## 十一、实现形态选项

### Option A: System Prompt 模式（最快落地）

将本文档转化为一个可激活的 System Prompt，用户在 Claude/ChatGPT 中发送即可启动工作流。

**优点**：零开发成本，立即可用
**缺点**：依赖模型的联网搜索能力，交付包需要手动复制

**适合场景**：个人开发者快速验证

### Option B: MCP Server 模式（可扩展）

将CDO Agent做成一个MCP服务：
- 暴露 `/consult` 接口：启动问诊流程
- 暴露 `/source` 接口：搜索资源
- 暴露 `/generate` 接口：生成交付包
- 暴露 `/query` 接口：让后端Agent查询"这个场景用什么组件"

**优点**：可被其他Agent调用，支持持久化项目配置，可增量更新
**缺点**：需要开发MCP服务器

**适合场景**：团队协作，多项目复用

### Option C: CLI工具模式（工程化）

做成命令行工具：
```bash
# 初始化项目
design-guide init --project MyApp --platform ios

# 启动问诊（交互式）
design-guide consult

# 生成交付包
design-guide generate --output ./design-handoff

# 验证集成
design-guide verify --project ./MyApp.xcodeproj
```

**优点**：可集成到CI/CD，版本控制友好
**缺点**：需要更多开发工作

**适合场景**：成熟的开发流程

---

## 十二、下一步行动

### 立即可做（Day 1）
1. **[ ] 编写激活Prompt**：基于本文档生成可直接使用的System Prompt
2. **[ ] 测试问诊流程**：用3个不同风格需求验证问诊引擎

### 短期（Week 1）
3. **[ ] 构建资源索引**：建立按风格标签分类的优质开源UI库清单
4. **[ ] 扩充映射表**：收集更多"感受词→设计参数"的映射关系
5. **[ ] 编写转译Prompt**：给转译Agent的标准化指令

### 中期（Month 1）
6. **[ ] 完整端到端测试**：用一个真实项目跑完整流程
7. **[ ] 收集反馈迭代**：优化问诊问题、补充映射、完善验收标准
8. **[ ] 考虑MCP化**：如果流程稳定，开始MCP Server开发

---

## 附录A：术语表

| 术语 | 定义 |
|------|------|
| CDO Agent | Chief Design Officer Agent，本系统的核心角色 |
| UIState | 中间层状态定义，连接后端逻辑和前端表现 |
| 转译 | 将非原生资源（如React组件、Figma设计稿）转换为目标平台代码 |
| 交付包 | CDO输出的完整工程资料，包含Theme、UIState、Components等 |
| L1-L4 | 资源可用性分级，L1最易用，L4需要完整转译 |

## 附录B：风格标签词典（待扩充）

```yaml
style_tags:
  mood:
    - cold-professional    # 冷静专业
    - warm-friendly        # 温暖亲切  
    - bold-experimental    # 前卫大胆
    - calm-minimal         # 平静极简
    
  density:
    - high-density         # 高密度信息
    - balanced             # 平衡
    - spacious             # 大留白
    
  personality:
    - native-blend         # 融入系统
    - light-brand          # 轻度品牌
    - strong-brand         # 强品牌感
    
  aesthetic:
    - glassmorphism        # 毛玻璃
    - neubrutalism         # 新粗野主义
    - neumorphism          # 新拟态
    - flat                 # 扁平
    - skeuomorphism        # 拟物
    
  color:
    - dark-mode            # 深色主题
    - light-mode           # 浅色主题
    - high-contrast        # 高对比
    - muted                # 柔和色调
    - vibrant              # 鲜艳色彩
```

---

*文档版本：v2.0*  
*最后更新：2026-01-18*  
*主要变更：增加UIState中间层架构、组件落地协议、分层验收标准、调试协议*
