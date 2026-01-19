import SwiftUI
import Combine

// MARK: - App State
/// Reso2 全局应用状态
/// 使用 @StateObject 在 App 层创建，通过 @EnvironmentObject 注入到视图树
///
/// 示例:
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
///     }
/// }
/// ```

public class AppState: ObservableObject {
    // MARK: - Published Properties

    /// 当前选中的视图
    @Published var currentView: MainView = .transcribe

    /// 当前处理的任务
    @Published var currentTask: TranscriptionTask?

    /// 历史记录
    @Published var history: [TranscriptionRecord] = []

    /// 应用设置
    @Published var settings: AppSettings = AppSettings()

    /// 模型状态
    @Published var modelStatus: ModelStatus = ModelStatus()

    /// UI 状态
    @Published var showingSidebar: Bool = true
    @Published var showingDetailPanel: Bool = true

    /// Toast 消息
    @Published var toastMessage: ToastMessage?

    // MARK: - Initialization

    public init() {
        loadHistory()
        checkModelStatus()
    }

    // MARK: - Public Methods

    /// 开始新的转录任务
    public func startTranscription(audioURL: URL, style: PolishStyle) {
        let task = TranscriptionTask(
            id: UUID(),
            audioURL: audioURL,
            polishStyle: style,
            startTime: Date(),
            status: .preparing
        )

        currentTask = task
        currentView = .transcribe
    }

    /// 更新任务进度
    public func updateTaskProgress(_ progress: Double, stage: TranscriptionStage) {
        guard var task = currentTask else { return }

        task.progress = progress
        task.stage = stage

        currentTask = task
    }

    /// 完成任务
    public func completeTask(
        originalText: String,
        polishedText: String
    ) {
        guard var task = currentTask else { return }

        task.status = .completed
        task.originalText = originalText
        task.polishedText = polishedText
        task.endTime = Date()

        // 保存到历史记录
        let record = TranscriptionRecord(from: task)
        history.insert(record, at: 0)
        saveHistory()

        // 显示成功消息
        showToast("转录完成", type: .success)
    }

    /// 任务失败
    public func failTask(error: Error) {
        guard var task = currentTask else { return }

        task.status = .failed
        task.error = error
        task.endTime = Date()

        currentTask = task

        // 显示错误消息
        showToast("转录失败: \(error.localizedDescription)", type: .error)
    }

    /// 显示 Toast 消息
    public func showToast(_ message: String, type: ToastType = .info) {
        toastMessage = ToastMessage(message: message, type: type)

        // 3秒后自动清除
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.toastMessage = nil
        }
    }

    /// 切换视图
    public func navigate(to view: MainView) {
        currentView = view
    }

    /// 删除历史记录
    public func deleteRecord(_ record: TranscriptionRecord) {
        history.removeAll { $0.id == record.id }
        saveHistory()
    }

    /// 清空所有历史记录
    public func clearHistory() {
        history.removeAll()
        saveHistory()
    }

    // MARK: - Private Methods

    private func loadHistory() {
        // TODO: 从 UserDefaults 或文件加载历史记录
        // let data = UserDefaults.standard.data(forKey: "history")
        // self.history = try? JSONDecoder().decode([TranscriptionRecord].self, from: data)
    }

    private func saveHistory() {
        // TODO: 保存历史记录到 UserDefaults 或文件
        // let data = try? JSONEncoder().encode(history)
        // UserDefaults.standard.set(data, forKey: "history")
    }

    private func checkModelStatus() {
        // TODO: 检查模型是否已下载和配置
        // modelStatus.whisperReady = WhisperModelManager.isModelReady()
        // modelStatus.qwenReady = QwenModelManager.isModelReady()
    }
}

// MARK: - Supporting Types

/// 主视图类型
public enum MainView {
    case transcribe  // 转录
    case history     // 历史
    case settings    // 设置
}

/// 转录任务
public struct TranscriptionTask: Identifiable {
    public let id: UUID
    public let audioURL: URL
    public let polishStyle: PolishStyle
    public let startTime: Date

    public var status: TaskStatus = .preparing
    public var stage: TranscriptionStage = .preparing
    public var progress: Double = 0

    public var originalText: String?
    public var polishedText: String?
    public var endTime: Date?
    public var error: Error?

    /// 任务持续时间
    public var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
}

/// 任务状态
public enum TaskStatus {
    case preparing      // 准备中
    case transcribing   // 转写中
    case polishing      // 润色中
    case completed      // 已完成
    case failed         // 失败
}

/// 转录阶段
public enum TranscriptionStage {
    case preparing           // 准备：加载模型
    case transcribing        // 转写：Whisper 处理
    case polishing           // 润色：QWEN 处理
    case completed           // 完成

    public var description: String {
        switch self {
        case .preparing:
            return "正在准备..."
        case .transcribing:
            return "正在转写音频..."
        case .polishing:
            return "正在润色文本..."
        case .completed:
            return "处理完成"
        }
    }
}

/// 润色风格
public enum PolishStyle: String, CaseIterable, Identifiable {
    case professional = "专业"
    case casual = "随意"
    case formal = "正式"
    case academic = "学术"
    case creative = "创意"
    case concise = "简洁"

    public var id: String { rawValue }

    public var description: String {
        switch self {
        case .professional:
            return "专业且得体，适合商务场合"
        case .casual:
            return "轻松随意，适合日常对话"
        case .formal:
            return "正式庄重，适合官方文件"
        case .academic:
            return "学术严谨，适合论文报告"
        case .creative:
            return "富有创意，适合内容创作"
        case .concise:
            return "简洁明了，去除冗余"
        }
    }
}

/// 历史记录
public struct TranscriptionRecord: Identifiable, Codable {
    public let id: UUID
    public let fileName: String
    public let fileURL: URL
    public let polishStyle: String
    public let timestamp: Date
    public let duration: TimeInterval
    public let originalText: String
    public let polishedText: String

    public init(from task: TranscriptionTask) {
        self.id = task.id
        self.fileName = task.audioURL.lastPathComponent
        self.fileURL = task.audioURL
        self.polishStyle = task.polishStyle.rawValue
        self.timestamp = task.startTime
        self.duration = task.duration ?? 0
        self.originalText = task.originalText ?? ""
        self.polishedText = task.polishedText ?? ""
    }
}

/// 应用设置
public struct AppSettings: Codable {
    public var qwenModelSize: String = "3B"
    public var defaultPolishStyle: PolishStyle = .professional
    public var temperature: Float = 0.3
    public var autoSaveResults: Bool = true
    public var savePath: String = "~/Documents/Reso2"
}

/// 模型状态
public struct ModelStatus {
    public var whisperReady: Bool = false
    public var qwenReady: Bool = false

    public var allReady: Bool {
        whisperReady && qwenReady
    }
}

/// Toast 消息
public struct ToastMessage: Identifiable {
    public let id = UUID()
    public let message: String
    public let type: ToastType
}

/// Toast 类型
public enum ToastType {
    case success
    case error
    case warning
    case info

    public var color: Color {
        switch self {
        case .success:
            return AppTheme.Colors.success
        case .error:
            return AppTheme.Colors.error
        case .warning:
            return AppTheme.Colors.warning
        case .info:
            return AppTheme.Colors.info
        }
    }

    public var icon: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .info:
            return "info.circle.fill"
        }
    }
}
