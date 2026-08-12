import SwiftUI
import PhotosUI

struct CaptureView: View {
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var capturedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var result: AppraisalResult?
    @State private var errorMessage: String?
    @State private var showCamera = false
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            ZStack {
                CJ.Colors.ink.ignoresSafeArea()

                if let result = result, let image = capturedImage {
                    ResultView(result: result, image: image, onReset: reset)
                } else if capturedImage != nil {
                    // Analyzing state
                    analyzingView
                } else {
                    uploadView
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("鉴定")
                        .font(.system(size: 16, weight: .light, design: .serif))
                        .foregroundColor(CJ.Colors.ivory)
                        .tracking(4)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showSettings = true }) {
                        Image(systemName: "gearshape")
                            .foregroundColor(CJ.Colors.ivoryMuted)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(image: $capturedImage)
            }
            .onChange(of: capturedImage) { _, newImage in
                if newImage != nil {
                    analyzeCurrentImage()
                }
            }
        }
    }

    // MARK: - Upload View

    private var uploadView: some View {
        VStack(spacing: 24) {
            Spacer()

            // Camera button
            Button(action: { showCamera = true }) {
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .stroke(CJ.Colors.gold, lineWidth: 3)
                            .frame(width: 80, height: 80)

                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 30))
                            .foregroundColor(CJ.Colors.gold)
                    }

                    Text("拍照鉴定")
                        .font(CJ.Fonts.serifBody(14))
                        .foregroundColor(CJ.Colors.gold)
                        .tracking(3)
                }
            }

            GoldDivider(width: 60)

            // Photo picker
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                VStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Image(systemName: "photo.on.rectangle")
                            .font(.system(size: 24))
                            .foregroundColor(CJ.Colors.ivoryMuted)

                        Text("从相册选择")
                            .font(CJ.Fonts.serifBody(13))
                            .foregroundColor(CJ.Colors.ivoryMuted)
                            .tracking(2)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(CJ.Colors.gold.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [8, 4]))
                    )

                    Text("支持 JPG / PNG，建议高清正面照")
                        .font(.system(size: 11))
                        .foregroundColor(CJ.Colors.textMuted)
                }
            }
            .padding(.horizontal, CJ.Layout.screenPadding)
            .onChange(of: selectedPhoto) { _, newItem in
                loadPhoto(from: newItem)
            }

            // Tips
            VStack(spacing: 8) {
                Text("拍摄建议")
                    .font(CJ.Fonts.serifBody(11))
                    .foregroundColor(CJ.Colors.gold.opacity(0.6))
                    .tracking(3)

                HStack(spacing: 12) {
                    tipItem("正面")
                    tipItem("底款")
                    tipItem("釉面")
                    tipItem("纹饰")
                }
            }
            .padding(.top, 8)

            Spacer()

            if let error = errorMessage {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "D4756C"))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(CJ.Colors.sealRed.opacity(0.15))
                    .cornerRadius(8)
                    .padding(.horizontal, CJ.Layout.screenPadding)
            }
        }
    }

    private func tipItem(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11))
            .foregroundColor(CJ.Colors.ivoryMuted)
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(Color.white.opacity(0.04))
            .cornerRadius(14)
    }

    // MARK: - Analyzing View

    private var analyzingView: some View {
        ZStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .blur(radius: 20)
                    .overlay(Color.black.opacity(0.6))
            }

            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: CJ.Colors.gold))
                    .scaleEffect(1.5)

                Text("AI 鉴定分析中…")
                    .font(CJ.Fonts.serifBody(16))
                    .foregroundColor(CJ.Colors.gold)
                    .tracking(4)

                Text("正在分析器型、釉色、纹饰等特征")
                    .font(.system(size: 12))
                    .foregroundColor(CJ.Colors.ivoryMuted)
            }
        }
    }

    // MARK: - Actions

    private func loadPhoto(from item: PhotosPickerItem?) {
        guard let item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                capturedImage = uiImage
            }
        }
    }

    private func analyzeCurrentImage() {
        guard let image = capturedImage else { return }
        isAnalyzing = true
        errorMessage = nil

        Task {
            do {
                let apiResult = try await ClaudeAPIService.shared.analyzeImage(image)
                await MainActor.run {
                    result = apiResult
                    isAnalyzing = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isAnalyzing = false
                    capturedImage = nil
                }
            }
        }
    }

    private func reset() {
        capturedImage = nil
        result = nil
        selectedPhoto = nil
        errorMessage = nil
    }
}

// MARK: - Camera View (UIKit wrapper)

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraView
        init(_ parent: CameraView) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
            }
            parent.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// MARK: - Settings View

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var apiKey: String = APIKeyManager.currentKey

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SecureField("sk-ant-...", text: $apiKey)
                        .font(.system(size: 14, design: .monospaced))
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                } header: {
                    Text("Anthropic API Key")
                } footer: {
                    Text("需要 Claude API 密钥才能使用 AI 鉴定功能。密钥仅存储在本地设备。")
                }

                Section {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0").foregroundColor(.secondary)
                    }
                    HStack {
                        Text("开发")
                        Spacer()
                        Text("碧帝数据科技").foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("保存") {
                        APIKeyManager.currentKey = apiKey
                        dismiss()
                    }
                    .foregroundColor(CJ.Colors.gold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("取消") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    CaptureView()
}
