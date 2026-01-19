import SwiftUI

// MARK: - Main Window
/// Reso2 主窗口布局
/// 采用三栏布局：侧边栏 + 主内容 + 详情面板（可选）
///
/// 使用示例:
/// ```swift
/// @main
/// struct Reso2App: App {
///     @StateObject private var appState = AppState()
///
///     var body: some Scene {
///         WindowGroup {
///             MainWindow()
///                 .environmentObject(appState)
///         }
///         .windowStyle(.hiddenTitleBar)
///     }
/// }
/// ```

public struct MainWindow: View {
    @EnvironmentObject var appState: AppState

    public var body: some View {
        NavigationSplitView(
            columnVisibility: .constant(.all),
            sidebar: {
                Sidebar()
            },
            content: {
                ContentView()
            },
            detail: {
                DetailPanel()
            }
        )
        .frame(minWidth: 900, minHeight: 600)
        .background(AppTheme.Colors.background)
        .overlay(alignment: .top) {
            // Toast 通知
            if let toast = appState.toastMessage {
                ToastView(message: toast)
                    .padding(.top, AppTheme.Spacing.medium)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}

// MARK: - Sidebar
struct Sidebar: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        List(selection: $appState.currentView) {
            // 转录
            NavigationLink(value: MainView.transcribe) {
                Label("转录", systemImage: "mic.fill")
            }

            // 历史
            NavigationLink(value: MainView.history) {
                Label("历史", systemImage: "clock.fill")
                    .badge(appState.history.count)
            }

            // 设置
            NavigationLink(value: MainView.settings) {
                Label("设置", systemImage: "gearshape.fill")
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Reso2")
    }
}

// MARK: - Content View
struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            switch appState.currentView {
            case .transcribe:
                TranscribeView()
            case .history:
                HistoryView()
            case .settings:
                SettingsView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.Colors.background)
    }
}

// MARK: - Detail Panel
struct DetailPanel: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
            // 标题
            Text("详情")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Divider()
                .background(AppTheme.Colors.divider)

            // 模型状态
            StatusSection()

            Spacer()
        }
        .padding(AppTheme.Spacing.medium)
        .frame(minWidth: 250)
        .background(AppTheme.Colors.surface)
    }
}

// MARK: - Status Section
struct StatusSection: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("模型状态")
                .font(AppTheme.Typography.captionBold)
                .foregroundColor(AppTheme.Colors.textSecondary)

            // Whisper 状态
            StatusRow(
                icon: "waveform",
                label: "Whisper V3",
                isReady: appState.modelStatus.whisperReady
            )

            // QWEN 状态
            StatusRow(
                icon: "sparkles",
                label: "QWEN 2.5",
                isReady: appState.modelStatus.qwenReady
            )
        }
    }
}

// MARK: - Status Row
struct StatusRow: View {
    let icon: String
    let label: String
    let isReady: Bool

    var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Image(systemName: icon)
                .font(.system(size: AppTheme.IconSize.small))
                .foregroundColor(AppTheme.Colors.textSecondary)

            Text(label)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Spacer()

            Circle()
                .fill(isReady ? AppTheme.Colors.success : AppTheme.Colors.textDisabled)
                .frame(width: 8, height: 8)
        }
        .padding(.vertical, AppTheme.Spacing.xs)
    }
}

// MARK: - Toast View
struct ToastView: View {
    let message: ToastMessage

    var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Image(systemName: message.type.icon)
                .foregroundColor(message.type.color)

            Text(message.message)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.textPrimary)
        }
        .padding(AppTheme.Spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .fill(AppTheme.Colors.elevated)
                .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Placeholder Views
// These are placeholder implementations
// Backend agent should implement with actual business logic

struct TranscribeView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedStyle: PolishStyle = .professional

    var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // 如果有当前任务，显示进度
            if let task = appState.currentTask {
                TranscriptionProgressSection(task: task)
            } else {
                // 否则显示文件拖拽区
                FileDropZone(
                    acceptedTypes: [.audio],
                    onDrop: { urls in
                        guard let url = urls.first else { return }
                        appState.startTranscription(audioURL: url, style: selectedStyle)
                    }
                )

                // 风格选择
                StyleSelector(selectedStyle: $selectedStyle)
                    .padding(.horizontal, AppTheme.Spacing.large)
            }
        }
        .padding(AppTheme.Spacing.large)
    }
}

struct TranscriptionProgressSection: View {
    let task: TranscriptionTask

    var body: some View {
        VStack(spacing: AppTheme.Spacing.medium) {
            Text(task.stage.description)
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.textPrimary)

            ProgressView(value: task.progress)
                .progressViewStyle(.linear)
                .tint(AppTheme.Colors.primary)
        }
        .padding(AppTheme.Spacing.large)
    }
}

struct StyleSelector: View {
    @Binding var selectedStyle: PolishStyle

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text("润色风格")
                .font(AppTheme.Typography.captionBold)
                .foregroundColor(AppTheme.Colors.textSecondary)

            Picker("", selection: $selectedStyle) {
                ForEach(PolishStyle.allCases) { style in
                    Text(style.rawValue).tag(style)
                }
            }
            .pickerStyle(.segmented)
        }
    }
}

struct HistoryView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        ScrollView {
            LazyVStack(spacing: AppTheme.Spacing.medium) {
                ForEach(appState.history) { record in
                    HistoryCard(record: record)
                }
            }
            .padding(AppTheme.Spacing.large)
        }
    }
}

struct HistoryCard: View {
    let record: TranscriptionRecord

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.small) {
            Text(record.fileName)
                .font(AppTheme.Typography.bodyBold)
                .foregroundColor(AppTheme.Colors.textPrimary)

            Text(record.timestamp.formatted())
                .font(AppTheme.Typography.caption)
                .foregroundColor(AppTheme.Colors.textSecondary)
        }
        .padding(AppTheme.Spacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.Colors.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

struct SettingsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Form {
            Section("模型配置") {
                Picker("QWEN 模型大小", selection: $appState.settings.qwenModelSize) {
                    Text("1.5B (快速)").tag("1.5B")
                    Text("3B (推荐)").tag("3B")
                    Text("7B (最佳质量)").tag("7B")
                }
            }

            Section("默认设置") {
                Picker("默认润色风格", selection: $appState.settings.defaultPolishStyle) {
                    ForEach(PolishStyle.allCases) { style in
                        Text(style.rawValue).tag(style)
                    }
                }

                Toggle("自动保存结果", isOn: $appState.settings.autoSaveResults)
            }
        }
        .formStyle(.grouped)
        .padding(AppTheme.Spacing.large)
    }
}

// MARK: - Preview
#if DEBUG
struct MainWindow_Previews: PreviewProvider {
    static var previews: some View {
        MainWindow()
            .environmentObject(AppState())
            .frame(width: 1200, height: 800)
    }
}
#endif
