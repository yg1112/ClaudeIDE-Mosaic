import SwiftUI

// MARK: - App Theme
/// Reso2 设计系统主题定义
/// 由 Mosaic 生成 - 专业深色主题
///
/// 使用方法:
/// ```swift
/// Text("Hello")
///     .foregroundColor(AppTheme.Colors.textPrimary)
///     .padding(AppTheme.Spacing.medium)
///     .font(AppTheme.Typography.body)
/// ```

public enum AppTheme {

    // MARK: - Colors
    public enum Colors {
        // MARK: Primary Colors
        /// 主题色 - 紫蓝色（用于主要操作、强调元素）
        public static let primary = Color(hex: "5E6AD2")

        /// 主题色 - Hover 状态
        public static let primaryHover = Color(hex: "4E5AC2")

        /// 主题色 - Pressed 状态
        public static let primaryPressed = Color(hex: "3E4AB2")

        // MARK: Background Colors
        /// 主背景色 - 深灰黑
        public static let background = Color(hex: "0A0A0B")

        /// 次背景色 / 卡片背景 - 深灰
        public static let surface = Color(hex: "1A1A1E")

        /// 浮层背景 - 稍浅的深灰
        public static let elevated = Color(hex: "24242A")

        // MARK: Text Colors
        /// 主要文字颜色 - 白色
        public static let textPrimary = Color.white

        /// 次要文字颜色 - 灰色
        public static let textSecondary = Color(hex: "9CA3AF")

        /// 禁用文字颜色 - 暗灰色
        public static let textDisabled = Color(hex: "6B7280")

        /// 占位符文字颜色 - 更暗的灰色
        public static let textPlaceholder = Color(hex: "4B5563")

        // MARK: Status Colors
        /// 成功状态 - 绿色
        public static let success = Color(hex: "10B981")

        /// 警告状态 - 橙色
        public static let warning = Color(hex: "F59E0B")

        /// 错误状态 - 红色
        public static let error = Color(hex: "EF4444")

        /// 信息状态 - 蓝色
        public static let info = Color(hex: "3B82F6")

        // MARK: Semantic Colors
        /// 边框颜色
        public static let border = Color(hex: "2A2A32")

        /// 分隔线颜色
        public static let divider = Color(hex: "1F1F25")

        /// 选中状态背景
        public static let selected = Color(hex: "2C2C34")

        /// Hover 状态背景
        public static let hover = Color(hex: "212127")

        // MARK: Special Colors
        /// 录音指示器（红色）
        public static let recording = Color(hex: "DC2626")

        /// 处理中指示器（紫蓝色动画）
        public static let processing = primary

        /// 完成指示器（绿色）
        public static let completed = success
    }

    // MARK: - Spacing
    public enum Spacing {
        /// 4pt
        public static let xs: CGFloat = 4

        /// 8pt
        public static let small: CGFloat = 8

        /// 12pt
        public static let mediumSmall: CGFloat = 12

        /// 16pt
        public static let medium: CGFloat = 16

        /// 20pt
        public static let mediumLarge: CGFloat = 20

        /// 24pt
        public static let large: CGFloat = 24

        /// 32pt
        public static let xl: CGFloat = 32

        /// 48pt
        public static let xxl: CGFloat = 48
    }

    // MARK: - Typography
    public enum Typography {
        // MARK: Titles
        /// 大标题 - SF Pro Display Bold 28pt
        public static let title = Font.system(size: 28, weight: .bold, design: .default)

        /// 标题 - SF Pro Text Bold 22pt
        public static let headline = Font.system(size: 22, weight: .bold, design: .default)

        /// 副标题 - SF Pro Text Semibold 18pt
        public static let subheadline = Font.system(size: 18, weight: .semibold, design: .default)

        // MARK: Body Text
        /// 正文 - SF Pro Text Regular 14pt
        public static let body = Font.system(size: 14, weight: .regular, design: .default)

        /// 正文 (加粗) - SF Pro Text Semibold 14pt
        public static let bodyBold = Font.system(size: 14, weight: .semibold, design: .default)

        /// 小正文 - SF Pro Text Regular 13pt
        public static let bodySmall = Font.system(size: 13, weight: .regular, design: .default)

        // MARK: Caption
        /// 说明文字 - SF Pro Text Regular 12pt
        public static let caption = Font.system(size: 12, weight: .regular, design: .default)

        /// 说明文字 (加粗) - SF Pro Text Semibold 12pt
        public static let captionBold = Font.system(size: 12, weight: .semibold, design: .default)

        /// 小说明文字 - SF Pro Text Regular 11pt
        public static let captionSmall = Font.system(size: 11, weight: .regular, design: .default)

        // MARK: Special
        /// 代码/等宽字体 - SF Mono Regular 13pt
        /// 用于显示转录结果、文件路径等
        public static let code = Font.system(size: 13, weight: .regular, design: .monospaced)

        /// 按钮文字 - SF Pro Text Semibold 14pt
        public static let button = Font.system(size: 14, weight: .semibold, design: .default)

        /// 小按钮文字 - SF Pro Text Semibold 12pt
        public static let buttonSmall = Font.system(size: 12, weight: .semibold, design: .default)
    }

    // MARK: - Corner Radius
    public enum CornerRadius {
        /// 小圆角 - 4pt
        public static let small: CGFloat = 4

        /// 中圆角 - 8pt
        public static let medium: CGFloat = 8

        /// 大圆角 - 12pt
        public static let large: CGFloat = 12

        /// 超大圆角 - 16pt
        public static let xl: CGFloat = 16

        /// 全圆角 - 999pt (用于药丸形状)
        public static let full: CGFloat = 999
    }

    // MARK: - Shadow
    public enum Shadow {
        /// 小阴影 - 卡片
        public static let small = {
            return AnyView(
                EmptyView().shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
            )
        }

        /// 中阴影 - 浮层
        public static let medium = {
            return AnyView(
                EmptyView().shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
        }

        /// 大阴影 - 模态窗口
        public static let large = {
            return AnyView(
                EmptyView().shadow(color: Color.black.opacity(0.25), radius: 16, x: 0, y: 8)
            )
        }
    }

    // MARK: - Animation
    public enum Animation {
        /// 快速动画 - 0.2s
        public static let fast = SwiftUI.Animation.easeInOut(duration: 0.2)

        /// 标准动画 - 0.3s
        public static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)

        /// 慢速动画 - 0.5s
        public static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)

        /// 弹簧动画
        public static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
    }

    // MARK: - Icon Sizes
    public enum IconSize {
        /// 小图标 - 16pt
        public static let small: CGFloat = 16

        /// 中图标 - 20pt
        public static let medium: CGFloat = 20

        /// 大图标 - 24pt
        public static let large: CGFloat = 24

        /// 超大图标 - 32pt
        public static let xl: CGFloat = 32
    }
}

// MARK: - Color Extension
extension Color {
    /// 从 Hex 字符串创建 Color
    /// - Parameter hex: Hex 颜色代码（如 "5E6AD2"）
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Preview
#if DEBUG
struct ThemePreview: View {
    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // 颜色预览
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Colors")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                HStack(spacing: AppTheme.Spacing.small) {
                    colorSwatch(AppTheme.Colors.primary, "Primary")
                    colorSwatch(AppTheme.Colors.success, "Success")
                    colorSwatch(AppTheme.Colors.warning, "Warning")
                    colorSwatch(AppTheme.Colors.error, "Error")
                }
            }

            // 文字预览
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Typography")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                Text("Title - SF Pro Display Bold 28pt")
                    .font(AppTheme.Typography.title)
                Text("Headline - SF Pro Text Bold 22pt")
                    .font(AppTheme.Typography.headline)
                Text("Body - SF Pro Text Regular 14pt")
                    .font(AppTheme.Typography.body)
                Text("Caption - SF Pro Text Regular 12pt")
                    .font(AppTheme.Typography.caption)
                Text("Code - SF Mono Regular 13pt")
                    .font(AppTheme.Typography.code)
            }
            .foregroundColor(AppTheme.Colors.textPrimary)

            // 间距预览
            VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
                Text("Spacing")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.textPrimary)

                HStack(spacing: 0) {
                    spacingSwatch(AppTheme.Spacing.xs, "XS")
                    spacingSwatch(AppTheme.Spacing.small, "S")
                    spacingSwatch(AppTheme.Spacing.medium, "M")
                    spacingSwatch(AppTheme.Spacing.large, "L")
                    spacingSwatch(AppTheme.Spacing.xl, "XL")
                }
            }
        }
        .padding(AppTheme.Spacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
    }

    private func colorSwatch(_ color: Color, _ label: String) -> some View {
        VStack(spacing: AppTheme.Spacing.xs) {
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                .fill(color)
                .frame(width: 60, height: 60)

            Text(label)
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }

    private func spacingSwatch(_ spacing: CGFloat, _ label: String) -> some View {
        VStack(spacing: 2) {
            RoundedRectangle(cornerRadius: 2)
                .fill(AppTheme.Colors.primary)
                .frame(width: spacing, height: 20)

            Text(label)
                .font(AppTheme.Typography.captionSmall)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(.trailing, AppTheme.Spacing.small)
    }
}

struct ThemePreview_Previews: PreviewProvider {
    static var previews: some View {
        ThemePreview()
    }
}
#endif
