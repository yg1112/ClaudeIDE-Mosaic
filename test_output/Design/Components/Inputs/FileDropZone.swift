import SwiftUI
import UniformTypeIdentifiers

// MARK: - File Drop Zone
/// 文件拖拽区域组件
/// 支持拖拽音频文件到应用中
///
/// 使用示例:
/// ```swift
/// FileDropZone(
///     acceptedTypes: [.audio],
///     onDrop: { urls in
///         // 处理音频文件
///         handleAudioFiles(urls)
///     }
/// )
/// ```

public struct FileDropZone: View {
    // MARK: - Properties

    /// 接受的文件类型
    let acceptedTypes: [UTType]

    /// 文件拖入回调
    let onDrop: ([URL]) -> Void

    /// 拖拽状态
    @State private var isDragging = false

    // MARK: - Body

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            // 图标
            Image(systemName: isDragging ? "arrow.down.circle.fill" : "arrow.down.doc.fill")
                .font(.system(size: 48))
                .foregroundColor(isDragging ? AppTheme.Colors.primary : AppTheme.Colors.textSecondary)
                .animation(AppTheme.Animation.spring, value: isDragging)

            // 提示文字
            VStack(spacing: AppTheme.Spacing.small) {
                Text(isDragging ? "松开以添加文件" : "拖拽音频文件到此处")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(
                        isDragging ? AppTheme.Colors.textPrimary : AppTheme.Colors.textSecondary
                    )

                Text("支持 .wav, .m4a, .mp3, .aac, .flac")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textPlaceholder)
            }

            // 或者按钮
            HStack(spacing: AppTheme.Spacing.small) {
                Rectangle()
                    .fill(AppTheme.Colors.divider)
                    .frame(width: 40, height: 1)

                Text("或者")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.textSecondary)

                Rectangle()
                    .fill(AppTheme.Colors.divider)
                    .frame(width: 40, height: 1)
            }

            // 选择文件按钮
            Button(action: {
                selectFile()
            }) {
                HStack(spacing: AppTheme.Spacing.small) {
                    Image(systemName: "folder")
                        .font(.system(size: AppTheme.IconSize.small))

                    Text("选择文件")
                        .font(AppTheme.Typography.button)
                }
                .foregroundColor(AppTheme.Colors.textPrimary)
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.vertical, AppTheme.Spacing.small)
                .background(AppTheme.Colors.surface)
                .cornerRadius(AppTheme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.Colors.border, lineWidth: 1)
                )
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(AppTheme.Spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                .fill(isDragging ? AppTheme.Colors.surface : AppTheme.Colors.background)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                        .strokeBorder(
                            isDragging ? AppTheme.Colors.primary : AppTheme.Colors.border,
                            style: StrokeStyle(lineWidth: 2, dash: [8, 4])
                        )
                )
        )
        .animation(AppTheme.Animation.fast, value: isDragging)
        .onDrop(of: acceptedTypes, isTargeted: $isDragging) { providers in
            handleDrop(providers: providers)
            return true
        }
    }

    // MARK: - Private Methods

    /// 处理文件拖拽
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        var urls: [URL] = []

        let group = DispatchGroup()

        for provider in providers {
            group.enter()
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                defer { group.leave() }

                guard let data = item as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil) else {
                    return
                }

                // 验证文件类型
                if isAudioFile(url) {
                    urls.append(url)
                }
            }
        }

        group.notify(queue: .main) {
            if !urls.isEmpty {
                onDrop(urls)
            }
        }

        return true
    }

    /// 选择文件
    private func selectFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.audio]
        panel.message = "选择音频文件"

        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            onDrop([url])
        }
    }

    /// 检查是否为音频文件
    private func isAudioFile(_ url: URL) -> Bool {
        let audioExtensions = ["wav", "m4a", "mp3", "aac", "flac", "mp4", "aiff"]
        return audioExtensions.contains(url.pathExtension.lowercased())
    }
}

// MARK: - Preview
#if DEBUG
struct FileDropZone_Previews: PreviewProvider {
    static var previews: some View {
        FileDropZone(
            acceptedTypes: [.audio],
            onDrop: { urls in
                print("Dropped files: \(urls)")
            }
        )
        .frame(height: 300)
        .padding()
        .background(AppTheme.Colors.background)
    }
}
#endif
