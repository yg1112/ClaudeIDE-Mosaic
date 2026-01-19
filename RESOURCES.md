# Mosaic 资源索引

> **此文件是 Mosaic 的"采购清单"，记录了经过筛选的高质量 UI 资源。**
> 
> Agent 在采购阶段应优先从此列表中选择，而非盲目搜索。

---

## SwiftUI 组件库

### 基础组件库

| 名称 | 链接 | 风格标签 | 覆盖组件 | Level |
|------|------|---------|---------|-------|
| **VComponents** | github.com/VakhoKontridze/VComponents | minimal, modern | Button, TextField, Toggle, Slider, etc. | L1 |
| **SwiftUIX** | github.com/SwiftUIX/SwiftUIX | native-extend | 补全SwiftUI缺失的组件 | L1 |
| **CodeEditUI** | github.com/CodeEditApp/CodeEdit | native, ide-style | Sidebar, Tabs, Breadcrumb | L2 |

### 动效库

| 名称 | 链接 | 特点 | 适用场景 | Level |
|------|------|------|---------|-------|
| **Pow** | github.com/EmergeTools/Pow | 高质量转场和状态动效 | 任何需要polish的App | L1 |
| **Lottie** | github.com/airbnb/lottie-ios | 复杂动画播放 | 引导页、空状态 | L1 |

### 反馈组件

| 名称 | 链接 | 特点 | Level |
|------|------|------|-------|
| **PopupView** | github.com/exyte/PopupView | Toast、Sheet、Popup | L1 |
| **AlertToast** | github.com/elai950/AlertToast | 系统风格Toast | L1 |
| **ConfettiSwiftUI** | github.com/simibac/ConfettiSwiftUI | 庆祝效果 | L1 |

### 图表库

| 名称 | 链接 | 风格 | Level |
|------|------|------|-------|
| **Swift Charts** | Apple 官方 | native | L1 |
| **SwiftUICharts** | github.com/AppPear/ChartView | modern, gradient | L1 |
| **Charts** | github.com/danielgindi/Charts | feature-rich | L2 |

### 列表与布局

| 名称 | 链接 | 特点 | Level |
|------|------|------|-------|
| **SwiftUI-Introspect** | github.com/siteline/SwiftUI-Introspect | 底层UIKit访问 | L2 |
| **WaterfallGrid** | github.com/paololeonardi/WaterfallGrid | 瀑布流布局 | L1 |
| **CollectionViewPagingLayout** | github.com/nicklockwood/iCarousel | 卡片轮播 | L2 |

---

## 设计灵感与市场平台

> **这些平台用于灵感搜索和参考，具有网络搜索能力时可实时查询**

### 灵感搜索平台

| 平台 | 链接 | 特点 | 使用场景 | Level |
|------|------|------|---------|-------|
| **Mobbin** | mobbin.com | 真实App截图库，按流程分类 | 寻找成熟App的交互方案 | L4 |
| **Figma Community** | figma.com/community | 社区模板、插件、设计系统 | 寻找可直接使用的设计系统 | L3 |
| **UI8** | ui8.net | 付费/免费设计素材市场 | 高质量完整设计系统 | L3-L4 |
| **Dribbble** | dribbble.com | 设计师作品展示 | 视觉风格参考 | L4 |
| **Behance** | behance.net | Adobe设计社区 | 完整案例研究 | L4 |

### GitHub 搜索策略

当需要搜索特定风格的组件时，使用以下搜索模式：

```
# 搜索深色主题组件
"swiftui dark theme" stars:>100 pushed:>2024-01-01

# 搜索动效库
"swiftui animation" OR "swiftui transition" stars:>200

# 搜索特定组件
"swiftui toast" OR "swiftui alert" stars:>50

# 搜索设计系统
"swiftui design system" OR "swiftui theme" stars:>100
```

### 搜索优先级

```yaml
search_priority:
  1. RESOURCES.md 中的预置资源（最快，已验证）
  2. GitHub 搜索（实时，需验证可用性）
  3. Figma Community（需转译，设计完整）
  4. Mobbin + UI8（灵感参考，需复刻）
  5. Dribbble + Behance（视觉灵感，需完全重建）
```

---

## 风格参考库

### 按风格分类

#### 🌙 Dark Mode / 高级感
- **Linear App** - 标杆级深色主题，紫色点缀
- **Raycast** - 命令行风格，极简
- **Arc Browser** - 创新侧边栏设计

#### ☀️ Light Mode / 清爽感
- **Notion** - 大留白，友好
- **Bear** - 极简写作风
- **Things 3** - 精致细节

#### 🎨 Bold / 前卫感
- **Discord** - 游戏感，霓虹色
- **Spotify** - 黑绿撞色
- **Figma** - 设计工具感

#### 🍎 Native / 系统融合
- **Apple Notes** - 纯原生
- **Xcode** - 开发工具
- **Finder** - 系统级

---

## 图标系统

### 推荐方案

| 方案 | 来源 | 适用场景 | 使用方式 |
|------|------|---------|---------|
| **SF Symbols 5** | Apple | 所有Apple平台 | 内置，无需安装 |
| **Phosphor Icons** | phosphoricons.com | 需要更多风格 | Swift Package |
| **Lucide** | lucide.dev | Web风格 | 需转译为SwiftUI |

### SF Symbols 使用规范
```swift
// 基础用法
Image(systemName: "folder.fill")

// 带动效（iOS 17+）
Image(systemName: "checkmark.circle")
    .symbolEffect(.bounce, value: isComplete)

// 多色渲染
Image(systemName: "externaldrive.fill.badge.checkmark")
    .symbolRenderingMode(.multicolor)
```

---

## 色彩系统模板

### Dark Mode 推荐色板

```swift
// Linear 风格
struct LinearDarkTheme {
    static let background = Color(hex: "#0A0A0B")
    static let surface = Color(hex: "#141415")
    static let surfaceHover = Color(hex: "#1F1F21")
    static let primary = Color(hex: "#5E6AD2")     // Linear 紫
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#8A8F98")
    static let border = Color.white.opacity(0.08)
}

// Raycast 风格
struct RaycastDarkTheme {
    static let background = Color(hex: "#1A1A1A")
    static let surface = Color(hex: "#2A2A2A")
    static let primary = Color(hex: "#FF6363")     // Raycast 红
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "#999999")
}
```

### Light Mode 推荐色板

```swift
// Notion 风格
struct NotionLightTheme {
    static let background = Color.white
    static let surface = Color(hex: "#F7F6F3")
    static let primary = Color(hex: "#2F80ED")
    static let textPrimary = Color(hex: "#37352F")
    static let textSecondary = Color(hex: "#6B6B6B")
    static let border = Color(hex: "#E9E9E7")
}
```

---

## 字体系统模板

### macOS 推荐

```swift
struct TypographySystem {
    // 使用 SF Pro（系统默认）
    static let displayLarge = Font.system(size: 34, weight: .bold)
    static let titleLarge = Font.system(size: 22, weight: .bold)
    static let titleMedium = Font.system(size: 17, weight: .semibold)
    static let body = Font.system(size: 14, weight: .regular)
    static let caption = Font.system(size: 12, weight: .regular)
    
    // 代码/数据用等宽
    static let mono = Font.system(size: 13, weight: .regular, design: .monospaced)
    
    // 想要更友好的感觉用圆体
    static let friendly = Font.system(size: 14, weight: .medium, design: .rounded)
}
```

---

## 间距系统模板

### 8pt Grid System

```swift
struct SpacingSystem {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}
```

### 圆角规范

```swift
struct RadiusSystem {
    static let none: CGFloat = 0
    static let sm: CGFloat = 4      // 小按钮、标签
    static let md: CGFloat = 8      // 卡片、输入框
    static let lg: CGFloat = 12     // 大卡片、弹窗
    static let xl: CGFloat = 16     // 模态框
    static let full: CGFloat = 9999 // 胶囊按钮
}
```

---

## 动效规范

### 时长标准

| 场景 | 时长 | 曲线 |
|------|------|------|
| 按钮点击反馈 | 0.1s | easeOut |
| 状态切换 | 0.2s | easeInOut |
| 页面转场 | 0.3s | spring |
| 复杂动画 | 0.4-0.6s | spring |

### SwiftUI 动画预设

```swift
struct AnimationPresets {
    static let instant = Animation.easeOut(duration: 0.1)
    static let fast = Animation.easeOut(duration: 0.15)
    static let normal = Animation.easeInOut(duration: 0.25)
    static let slow = Animation.easeInOut(duration: 0.4)
    static let spring = Animation.spring(response: 0.3, dampingFraction: 0.7)
    static let bouncy = Animation.spring(response: 0.4, dampingFraction: 0.6)
}
```

---

## 待扩充区域

### TODO: Web 平台资源
- [ ] React 组件库索引
- [ ] Tailwind 预设
- [ ] shadcn/ui 组件

### TODO: 更多风格参考
- [ ] 金融类 App
- [ ] 医疗健康类
- [ ] 游戏类

---

*最后更新：2026-01-18*
*维护者：Mosaic CDO Agent*
