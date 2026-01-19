# 组件代码模板库

> **当 Mosaic 需要生成组件时，从此库中选择并定制**

---

## 基础组件

### PrimaryButton.swift

```swift
import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: {
            guard !isLoading && !isDisabled else { return }
            action()
        }) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                Text(title)
                    .font(AppTheme.Typography.body)
                    .fontWeight(.medium)
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(buttonBackground)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.Radius.md)
        }
        .buttonStyle(.plain)
        .opacity(isDisabled ? 0.5 : 1)
        .onHover { hovering in
            withAnimation(AppTheme.Animation.fast) {
                isHovered = hovering
            }
        }
    }
    
    private var buttonBackground: Color {
        if isDisabled {
            return AppTheme.Colors.primary.opacity(0.5)
        }
        return isHovered ? AppTheme.Colors.primaryHover : AppTheme.Colors.primary
    }
}

#Preview("Primary Button States") {
    VStack(spacing: 16) {
        PrimaryButton(title: "Default", action: {})
        PrimaryButton(title: "Loading", action: {}, isLoading: true)
        PrimaryButton(title: "Disabled", action: {}, isDisabled: true)
    }
    .padding()
    .background(AppTheme.Colors.background)
}
```

### SecondaryButton.swift

```swift
import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    var icon: String? = nil
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                }
                Text(title)
                    .font(AppTheme.Typography.body)
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(isHovered ? AppTheme.Colors.surface : Color.clear)
            .foregroundColor(AppTheme.Colors.textSecondary)
            .cornerRadius(AppTheme.Radius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.sm)
                    .stroke(AppTheme.Colors.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(AppTheme.Animation.fast) {
                isHovered = hovering
            }
        }
    }
}

#Preview("Secondary Button") {
    HStack {
        SecondaryButton(title: "Cancel", action: {})
        SecondaryButton(title: "Settings", action: {}, icon: "gear")
    }
    .padding()
    .background(AppTheme.Colors.background)
}
```

---

## 输入组件

### AppTextField.swift

```swift
import SwiftUI

struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String? = nil
    var isSecure: Bool = false
    var errorMessage: String? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            HStack(spacing: AppTheme.Spacing.sm) {
                if let icon {
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
                
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $text)
                    } else {
                        TextField(placeholder, text: $text)
                    }
                }
                .textFieldStyle(.plain)
                .font(AppTheme.Typography.body)
                .focused($isFocused)
            }
            .padding(AppTheme.Spacing.md)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.md)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                    .stroke(borderColor, lineWidth: 1)
            )
            
            if let error = errorMessage {
                Text(error)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.error)
            }
        }
    }
    
    private var borderColor: Color {
        if errorMessage != nil {
            return AppTheme.Colors.error
        }
        return isFocused ? AppTheme.Colors.primary : AppTheme.Colors.border
    }
}

#Preview("TextField States") {
    VStack(spacing: 16) {
        AppTextField(placeholder: "Email", text: .constant(""), icon: "envelope")
        AppTextField(placeholder: "Password", text: .constant(""), icon: "lock", isSecure: true)
        AppTextField(placeholder: "With Error", text: .constant("invalid"), errorMessage: "Invalid input")
    }
    .padding()
    .background(AppTheme.Colors.background)
}
```

### SearchBar.swift

```swift
import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search..."
    var onSubmit: (() -> Void)? = nil
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppTheme.Colors.textTertiary)
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(AppTheme.Typography.body)
                .focused($isFocused)
                .onSubmit { onSubmit?() }
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(AppTheme.Spacing.sm)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Radius.md)
    }
}

#Preview("Search Bar") {
    VStack {
        SearchBar(text: .constant(""))
        SearchBar(text: .constant("query"))
    }
    .padding()
    .background(AppTheme.Colors.background)
}
```

---

## 卡片组件

### InfoCard.swift

```swift
import SwiftUI

struct InfoCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = AppTheme.Spacing.md
    
    init(padding: CGFloat = AppTheme.Spacing.md, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.lg)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.Radius.lg)
                    .stroke(AppTheme.Colors.border, lineWidth: 1)
            )
    }
}

#Preview("Info Card") {
    InfoCard {
        VStack(alignment: .leading, spacing: 8) {
            Text("Card Title")
                .font(AppTheme.Typography.titleSmall)
            Text("Card description goes here")
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}
```

---

## 反馈组件

### LoadingSpinner.swift

```swift
import SwiftUI

struct LoadingSpinner: View {
    var size: SpinnerSize = .medium
    var color: Color = AppTheme.Colors.primary
    
    enum SpinnerSize {
        case small, medium, large
        
        var dimension: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 24
            case .large: return 40
            }
        }
    }
    
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
            .scaleEffect(size.dimension / 24)
    }
}

// 全屏加载
struct FullScreenLoading: View {
    var message: String? = nil
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: AppTheme.Spacing.md) {
                LoadingSpinner(size: .large)
                if let message {
                    Text(message)
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.textPrimary)
                }
            }
            .padding(AppTheme.Spacing.xl)
            .background(AppTheme.Colors.surface)
            .cornerRadius(AppTheme.Radius.lg)
        }
    }
}

#Preview("Loading States") {
    VStack(spacing: 32) {
        HStack(spacing: 32) {
            LoadingSpinner(size: .small)
            LoadingSpinner(size: .medium)
            LoadingSpinner(size: .large)
        }
    }
    .padding()
    .background(AppTheme.Colors.background)
}
```

### Toast.swift

```swift
import SwiftUI

enum ToastStyle {
    case success
    case error
    case warning
    case info
    
    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .success: return AppTheme.Colors.success
        case .error: return AppTheme.Colors.error
        case .warning: return AppTheme.Colors.warning
        case .info: return AppTheme.Colors.primary
        }
    }
}

struct Toast: View {
    let message: String
    let style: ToastStyle
    var onDismiss: (() -> Void)? = nil
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: style.icon)
                .foregroundColor(style.color)
            
            Text(message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textPrimary)
            
            Spacer()
            
            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .foregroundColor(AppTheme.Colors.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(AppTheme.Spacing.md)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.Radius.md)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.Radius.md)
                .stroke(style.color.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

// Toast 管理器
struct ToastContainer: View {
    @Binding var toast: ToastData?
    
    var body: some View {
        VStack {
            if let toast {
                Toast(message: toast.message, style: toast.style) {
                    withAnimation {
                        self.toast = nil
                    }
                }
                .transition(.move(edge: .top).combined(with: .opacity))
                .padding(.horizontal, AppTheme.Spacing.md)
            }
            Spacer()
        }
    }
}

struct ToastData: Equatable {
    let message: String
    let style: ToastStyle
    
    static func == (lhs: ToastData, rhs: ToastData) -> Bool {
        lhs.message == rhs.message
    }
}

#Preview("Toast Styles") {
    VStack(spacing: 16) {
        Toast(message: "Success message", style: .success)
        Toast(message: "Error message", style: .error)
        Toast(message: "Warning message", style: .warning)
        Toast(message: "Info message", style: .info)
    }
    .padding()
    .background(AppTheme.Colors.background)
}
```

### ErrorView.swift

```swift
import SwiftUI

struct ErrorView: View {
    let title: String
    let message: String
    var retryAction: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 48))
                .foregroundColor(AppTheme.Colors.error)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(AppTheme.Typography.titleMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text(message)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let retryAction {
                PrimaryButton(title: "Retry", action: retryAction)
                    .frame(width: 120)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

#Preview("Error View") {
    ErrorView(
        title: "Something went wrong",
        message: "We couldn't load the data. Please try again.",
        retryAction: {}
    )
    .background(AppTheme.Colors.background)
}
```

### EmptyState.swift

```swift
import SwiftUI

struct EmptyState: View {
    let icon: String
    let title: String
    let message: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundColor(AppTheme.Colors.textTertiary)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text(title)
                    .font(AppTheme.Typography.titleMedium)
                    .foregroundColor(AppTheme.Colors.textPrimary)
                
                Text(message)
                    .font(AppTheme.Typography.body)
                    .foregroundColor(AppTheme.Colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let actionTitle, let action {
                PrimaryButton(title: actionTitle, action: action)
                    .frame(width: 160)
            }
        }
        .padding(AppTheme.Spacing.xl)
    }
}

#Preview("Empty State") {
    EmptyState(
        icon: "tray",
        title: "No items yet",
        message: "Create your first item to get started.",
        actionTitle: "Create Item",
        action: {}
    )
    .background(AppTheme.Colors.background)
}
```

---

## 导航组件

### SidebarItem.swift

```swift
import SwiftUI

struct SidebarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    var badge: Int? = nil
    var action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.sm) {
                Image(systemName: icon)
                    .frame(width: 20)
                
                Text(title)
                    .font(AppTheme.Typography.body)
                
                Spacer()
                
                if let badge, badge > 0 {
                    Text("\(badge)")
                        .font(AppTheme.Typography.caption)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(AppTheme.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(AppTheme.Radius.full)
                }
            }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(AppTheme.Radius.sm)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private var backgroundColor: Color {
        if isSelected {
            return AppTheme.Colors.primary.opacity(0.15)
        }
        return isHovered ? AppTheme.Colors.surface : Color.clear
    }
    
    private var foregroundColor: Color {
        isSelected ? AppTheme.Colors.primary : AppTheme.Colors.textSecondary
    }
}

#Preview("Sidebar Items") {
    VStack(alignment: .leading, spacing: 4) {
        SidebarItem(icon: "house", title: "Home", isSelected: true, action: {})
        SidebarItem(icon: "folder", title: "Projects", isSelected: false, badge: 3, action: {})
        SidebarItem(icon: "gear", title: "Settings", isSelected: false, action: {})
    }
    .padding()
    .frame(width: 200)
    .background(AppTheme.Colors.background)
}
```

---

## 使用说明

1. **选择组件**：根据项目需要从上面选择组件
2. **定制主题**：将 `AppTheme` 替换为实际生成的主题
3. **添加 Preview**：每个组件都应有完整的 Preview 覆盖所有状态
4. **保持一致**：所有组件使用相同的主题变量

---

*组件库会持续扩充*
