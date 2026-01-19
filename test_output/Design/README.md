# Reso2 设计系统

> 由 Mosaic 生成于 2026-01-18
> 基于方案：**专业深色主题 - AI 工具风格**

---

## 快速开始

### 1. 安装依赖

所有 UI 组件基于 SwiftUI，无需额外依赖。

```swift
// 在你的 Package.swift 中无需添加额外依赖
// 所有组件使用系统原生 SwiftUI
```

### 2. 导入设计系统

```swift
import Reso2Core  // 你现有的核心库
// 将 Design/ 文件夹添加到你的项目中
```

### 3. 使用组件

```swift
// ❌ 不要这样写：
Text("Processing...")
    .foregroundColor(.blue)
    .padding()

// ✅ 要这样写：
Text("Processing...")
    .foregroundColor(AppTheme.Colors.primary)
    .padding(AppTheme.Spacing.medium)
```

---

## 设计决策

### 为什么选择这套方案？

**基于项目分析**：
- **项目类型**: 专业级 AI 工具（Whisper + QWEN）
- **目标用户**: 开发者、研究人员、内容创作者
- **使用场景**: 长时间使用、需要专注、查看转录结果

**设计方向**：
1. **深色主题** - 减少视觉疲劳，专业工具感
2. **清晰的信息层级** - 转录结果、润色对比需要清晰区分
3. **实时反馈** - 转录和润色进度需要明确展示
4. **高效操作** - 拖拽上传、快捷键支持、批量处理

---

## 给后端 Agent 的指令

### ⚠️ 重要规范

请严格遵守以下规范：

1. **所有颜色使用** `AppTheme.Colors.xxx`
2. **所有间距使用** `AppTheme.Spacing.xxx`
3. **所有字体使用** `AppTheme.Typography.xxx`
4. **所有组件使用** `Design/Components/` 目录下的封装
5. **状态管理遵循** `Design/UIState/` 的定义

### 不要硬编码任何值

```swift
// ❌ 错误示例
.padding(16)
.foregroundColor(.blue)
.font(.system(size: 14))

// ✅ 正确示例
.padding(AppTheme.Spacing.medium)
.foregroundColor(AppTheme.Colors.primary)
.font(AppTheme.Typography.body)
```

---

## 项目结构

```
Design/
├── README.md                    # 你正在看的文件
├── DECISIONS.md                 # 详细设计决策
│
├── Foundation/
│   ├── Theme.swift              # 颜色、字体、间距定义
│   └── Assets.xcassets/         # 图片资源（如需要）
│
├── UIState/
│   ├── AppState.swift           # 全局应用状态
│   ├── TranscriptionState.swift # 转录状态
│   └── NavigationState.swift    # 导航和路由
│
├── Components/
│   ├── Buttons/
│   │   ├── PrimaryButton.swift
│   │   └── IconButton.swift
│   ├── Cards/
│   │   ├── AudioFileCard.swift
│   │   └── ResultCard.swift
│   ├── Feedback/
│   │   ├── ProgressView.swift
│   │   ├── StatusIndicator.swift
│   │   └── Toast.swift
│   ├── Inputs/
│   │   ├── FileDropZone.swift
│   │   └── StyleSelector.swift
│   └── Layout/
│       ├── SidebarItem.swift
│       └── ContentContainer.swift
│
└── Screens/
    ├── MainWindow.swift          # 主窗口布局
    ├── TranscribeView.swift      # 转录主界面
    ├── HistoryView.swift         # 历史记录
    └── SettingsView.swift        # 设置界面
```

---

## 核心组件清单

### 按钮组件

```swift
// Primary Button - 主要操作
PrimaryButton(title: "开始转录", systemImage: "mic.fill") {
    // 操作
}

// Icon Button - 图标按钮
IconButton(systemImage: "gear") {
    // 打开设置
}
```

### 卡片组件

```swift
// Audio File Card - 音频文件卡片
AudioFileCard(
    fileName: "meeting.m4a",
    duration: "15:23",
    fileSize: "45.2 MB",
    status: .ready
)

// Result Card - 结果展示卡片
ResultCard(
    originalText: transcription,
    polishedText: polished,
    style: .professional
)
```

### 反馈组件

```swift
// Progress View - 进度显示
TranscriptionProgressView(
    stage: .transcribing,
    progress: 0.65,
    message: "正在转写音频..."
)

// Status Indicator - 状态指示器
StatusIndicator(
    status: .processing,
    message: "Whisper 模型运行中"
)
```

### 输入组件

```swift
// File Drop Zone - 文件拖拽区域
FileDropZone(
    acceptedTypes: [.audio],
    onDrop: { urls in
        // 处理音频文件
    }
)

// Style Selector - 风格选择器
StyleSelector(
    selectedStyle: $polishStyle,
    availableStyles: PolishStyle.allCases
)
```

---

## 主要界面

### 1. 主窗口 (MainWindow)

```
┌─────────────────────────────────────────────────────┐
│  Reso2                                    ⚙️ 📊 🔔 │
├──────────┬──────────────────────────────────────────┤
│ 🎙️ 转录   │                                          │
│ 📝 历史   │        主内容区域                         │
│ ⚙️ 设置   │        (根据侧边栏切换显示不同视图)       │
│          │                                          │
│          │                                          │
└──────────┴──────────────────────────────────────────┘
```

### 2. 转录界面 (TranscribeView)

```
┌─────────────────────────────────────────────────────┐
│  拖拽音频文件到此处                                  │
│  或点击选择文件                                      │
│                                                     │
│  [拖拽区域 - FileDropZone]                          │
│                                                     │
│  支持: .m4a, .wav, .mp3, .aac                       │
├─────────────────────────────────────────────────────┤
│  润色风格: [专业]  温度: [0.3]                       │
│                                                     │
│  [ 开始处理 ]                                       │
└─────────────────────────────────────────────────────┘
```

### 3. 结果展示

```
┌─────────────────────────────────────────────────────┐
│  原始转录                        | 润色后              │
│  --------------------------------|--------------------│
│  这是原始的                      | 这是经过润色的      │
│  转录文本...                     | 转录文本...        │
│                                 |                    │
│  [复制]  [导出]                  | [复制]  [导出]     │
└─────────────────────────────────────────────────────┘
```

---

## 状态管理

### AppState

全局应用状态，包含：
- 当前视图/导航
- 模型状态（已加载/未加载）
- 系统设置

### TranscriptionState

转录相关状态：
- 当前处理的文件
- 转录进度
- 转录结果
- 润色结果

---

## 主题配置

### 颜色

```swift
AppTheme.Colors.primary      // #5E6AD2 - 紫蓝色（主题色）
AppTheme.Colors.background   // #0A0A0B - 深灰黑（背景）
AppTheme.Colors.surface      // #1A1A1E - 深灰（卡片背景）
AppTheme.Colors.textPrimary  // #FFFFFF - 白色（主要文字）
AppTheme.Colors.textSecondary // #9CA3AF - 灰色（次要文字）
AppTheme.Colors.success      // #10B981 - 绿色（成功状态）
AppTheme.Colors.warning      // #F59E0B - 橙色（警告）
AppTheme.Colors.error        // #EF4444 - 红色（错误）
```

### 间距

```swift
AppTheme.Spacing.xs      // 4pt
AppTheme.Spacing.small   // 8pt
AppTheme.Spacing.medium  // 16pt
AppTheme.Spacing.large   // 24pt
AppTheme.Spacing.xl      // 32pt
```

### 字体

```swift
AppTheme.Typography.title       // SF Pro Display Bold 28pt
AppTheme.Typography.headline    // SF Pro Text Semibold 20pt
AppTheme.Typography.body        // SF Pro Text Regular 14pt
AppTheme.Typography.caption     // SF Pro Text Regular 12pt
AppTheme.Typography.code        // SF Mono Regular 13pt (用于显示转录结果)
```

---

## 实现优先级

### Phase 1: 基础框架（必须）
1. ✅ Theme.swift - 设计变量
2. ✅ AppState.swift - 状态管理
3. ✅ MainWindow.swift - 主窗口布局
4. ✅ Basic Components - 基础组件

### Phase 2: 核心功能（高优先级）
1. ✅ FileDropZone - 文件上传
2. ✅ TranscriptionProgressView - 进度显示
3. ✅ ResultCard - 结果展示
4. ✅ TranscribeView - 转录主界面

### Phase 3: 增强功能（中优先级）
1. ✅ HistoryView - 历史记录
2. ✅ SettingsView - 设置界面
3. ✅ Toast 通知
4. ✅ 快捷键支持

### Phase 4: 优化（低优先级）
1. ⏸️ 动画效果
2. ⏸️ 深色/浅色切换
3. ⏸️ 主题定制
4. ⏸️ 导出格式选项

---

## 验收标准

- [ ] 所有颜色来自 AppTheme.Colors
- [ ] 所有间距来自 AppTheme.Spacing
- [ ] 所有字体来自 AppTheme.Typography
- [ ] 每个组件有 SwiftUI Preview
- [ ] 支持深色模式
- [ ] 响应式布局（支持窗口缩放）
- [ ] 可访问性支持（VoiceOver）
- [ ] 符合 Apple HIG（Human Interface Guidelines）

---

## 示例代码

### 集成到现有代码

```swift
// 在 main.swift 中
import SwiftUI
import Reso2Core

@main
struct Reso2App: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainWindow()
                .environmentObject(appState)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified(showsTitle: true))
    }
}
```

### 使用转录视图

```swift
TranscribeView(
    onProcess: { audioURL, style in
        // 调用你现有的 Reso2Orchestrator
        let orchestrator = Reso2Orchestrator()
        let result = try await orchestrator.processAudio(
            audioPath: audioURL.path,
            polishStyle: style,
            temperature: 0.3
        )
        return result
    }
)
```

---

## 需要帮助？

如需调整设计或遇到问题：
1. 查看 `DECISIONS.md` 了解设计决策
2. 查看各组件的 Preview 了解用法
3. 修改 `Theme.swift` 调整颜色/字体/间距

---

**下一步**: 阅读 `Foundation/Theme.swift` 查看完整的设计变量定义
