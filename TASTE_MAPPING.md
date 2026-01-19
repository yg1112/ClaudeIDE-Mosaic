# 感受词 → 设计参数 映射表

> **此文件帮助 Mosaic 将用户的自然语言描述翻译成技术参数**

---

## 情绪/氛围映射

### "高级感" / "premium" / "质感"
```yaml
design_params:
  colors:
    saturation: low          # 低饱和度
    palette: "黑白灰为主，点缀色克制"
    accent_usage: "minimal"  # 点缀色使用克制
  typography:
    weight: light-to-regular # 细字重
    title_size: large        # 大标题
    line_height: generous    # 充足行高
  spacing:
    density: spacious        # 大留白
    element_gap: wide        # 元素间距宽松
  effects:
    shadows: subtle          # 微妙阴影
    borders: thin-or-none    # 无描边或细描边
    animations: smooth       # 平滑动效
  recommendations:
    - "Linear 风格色板"
    - "SF Pro Light/Regular"
    - "8pt grid, 偏大间距"
```

### "科技感" / "techy" / "极客" / "cyberpunk"
```yaml
design_params:
  colors:
    background: dark         # 深色背景
    accents: "霓虹色、渐变光效"
    saturation: "点缀色高饱和"
  typography:
    family: monospace-mix    # 混合等宽字体
    weight: medium           # 中等字重
  spacing:
    density: compact-organized # 紧凑但有序
  effects:
    glow: true               # 发光效果
    glassmorphism: optional  # 可选毛玻璃
    gradients: "动态渐变"
  recommendations:
    - "Raycast/Discord 风格"
    - "SF Mono 混合 SF Pro"
    - "深色背景 + 亮色点缀"
```

### "亲切" / "温暖" / "友好"
```yaml
design_params:
  colors:
    temperature: warm        # 暖色调
    saturation: moderate     # 柔和饱和度
  typography:
    design: rounded          # 圆体
    weight: medium           # 适中字重
  spacing:
    density: comfortable     # 舒适间距
  effects:
    corners: rounded         # 大圆角
    shadows: soft            # 柔和阴影
    illustrations: welcome   # 欢迎插画元素
  recommendations:
    - "Notion/Slack 风格"
    - "SF Pro Rounded"
    - "暖色点缀（橙、黄、粉）"
```

### "专业工具感" / "productivity" / "高效"
```yaml
design_params:
  colors:
    palette: neutral         # 中性色
    accent: "功能性配色（成功绿、警告黄、错误红）"
  typography:
    priority: readability    # 易读性优先
    hierarchy: clear         # 清晰层级
  spacing:
    density: information-dense # 信息密集但有组织
  effects:
    style: flat              # 扁平
    decoration: minimal      # 最小装饰
  recommendations:
    - "VS Code/Xcode 风格"
    - "功能优先，装饰其次"
    - "高对比度确保可读性"
```

### "极简" / "minimal" / "简洁"
```yaml
design_params:
  colors:
    palette: "黑白+一个点缀色"
    usage: restrained        # 克制使用
  typography:
    weight: regular          # 标准字重
    sizes: "减少层级，通常2-3级"
  spacing:
    density: spacious        # 大量留白
    content_width: narrow    # 内容区域窄
  effects:
    shadows: none-or-subtle  # 几乎无阴影
    borders: subtle          # 淡边框或无
    animations: minimal      # 最少动效
  recommendations:
    - "Apple Notes/Bear 风格"
    - "去除一切非必要元素"
    - "让内容说话"
```

### "前卫" / "大胆" / "独特"
```yaml
design_params:
  colors:
    contrast: high           # 高对比
    palette: "非常规配色"
    gradients: "大胆渐变"
  typography:
    style: experimental      # 可尝试非标准字体
    sizes: "极端大小对比"
  spacing:
    layout: asymmetric       # 非对称布局可接受
  effects:
    animations: expressive   # 表现力强的动效
    experiments: welcome     # 欢迎实验性效果
  recommendations:
    - "Arc/Discord 风格"
    - "打破常规但保持可用"
    - "用于品牌差异化"
```

---

## 密度映射

### "报纸型" / "高密度" / "数据密集"
```yaml
layout_params:
  grid: 12-16-column         # 多栏布局
  font_size: 12-13px         # 较小字号
  line_height: 1.3-1.4       # 紧凑行高
  spacing:
    element: 4-8px           # 小间距
    section: 16-24px         # 区块间距
  components:
    tables: dense            # 紧凑表格
    lists: compact           # 紧凑列表
  recommendations:
    - "适合仪表盘、数据工具"
    - "需要格外注意可读性"
    - "颜色编码区分区域"
```

### "杂志型" / "低密度" / "大留白"
```yaml
layout_params:
  grid: 1-2-column           # 少栏布局
  font_size: 16-18px         # 较大字号
  line_height: 1.6-1.8       # 宽松行高
  spacing:
    element: 16-24px         # 大间距
    section: 48-64px         # 区块间距
  components:
    cards: large             # 大卡片
    images: hero             # 主视觉突出
  recommendations:
    - "适合内容展示、营销页"
    - "每屏聚焦少量信息"
    - "负空间是设计元素"
```

---

## 参考App → 风格标签映射

| 用户说 | 派生标签 |
|--------|---------|
| Linear | dark-mode, minimal, professional, purple-accent, smooth-animation |
| Raycast | dark-mode, keyboard-centric, command-palette, fast, minimal |
| Arc | experimental, sidebar-nav, colorful, bold, glassmorphism |
| Notion | light-mode, spacious, friendly, content-first, collaborative |
| VS Code | dark-mode, high-density, tool-first, customizable, syntax-colors |
| Discord | dark-mode, gaming, vibrant, community, expressive |
| Slack | friendly, organized, colorful-accents, channel-based |
| Apple Notes | native, minimal, system-integration, light-mode |
| Figma | tool-first, design-centric, collaborative, multi-cursor |
| Things 3 | minimal, task-focused, subtle-animations, premium |
| Bear | minimal, writing-focused, markdown, warm |
| Spotify | dark-mode, album-art, green-accent, playful |

---

## 平台 → 默认规范映射

### macOS
```yaml
defaults:
  font: SF Pro
  min_touch_target: 24x24    # 鼠标操作，可以小一些
  corner_radius: 8-12        # 系统风格圆角
  window_controls: native    # 原生红绿灯按钮
  sidebar: NavigationSplitView
  colors: 
    - 支持 accent color 跟随系统
    - 深浅模式自动切换
```

### iOS
```yaml
defaults:
  font: SF Pro
  min_touch_target: 44x44    # Apple HIG 要求
  corner_radius: 10-16       # iOS 风格圆角
  navigation: NavigationStack
  tab_bar: 底部导航（如果多于3个主要功能）
  colors:
    - 动态颜色适配深浅模式
    - 考虑 accessibility
```

### Web
```yaml
defaults:
  font: Inter / system-ui
  min_click_target: 32x32
  breakpoints: [640, 768, 1024, 1280]
  framework_hint: "Tailwind + shadcn/ui"
```

---

## 快速匹配表

| 用户描述 | 推荐方案 |
|---------|---------|
| "像 Linear 那样高级" | Linear Dark Theme + Pow + VComponents |
| "原生 Mac 风格" | CodeEditUI + SF Symbols + 系统颜色 |
| "简洁清爽" | Notion Light Theme + 大留白 + SF Pro Rounded |
| "科技感十足" | Raycast Dark + 毛玻璃 + 渐变 |
| "温暖友好" | 暖色系 + 圆角 + 插画 + 柔和阴影 |
| "专业数据工具" | 高密度布局 + 功能色 + 紧凑间距 |

---

*此映射表会随着更多用户案例持续扩充*
