import Foundation
import UIKit

// MARK: - Claude API Service

actor ClaudeAPIService {
    static let shared = ClaudeAPIService()

    // ⚠️ Replace with your actual API key or load from Keychain/env
    private var apiKey: String {
        // Try loading from UserDefaults first (set via Settings)
        if let key = UserDefaults.standard.string(forKey: "anthropic_api_key"), !key.isEmpty {
            return key
        }
        // Fallback: set your key here for development
        return "YOUR_API_KEY_HERE"
    }

    private let endpoint = "https://api.anthropic.com/v1/messages"
    private let model = "claude-sonnet-4-6"

    // MARK: - Analyze Ceramic Image

    func analyzeImage(_ image: UIImage) async throws -> AppraisalResult {
        // Compress and encode image
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw APIError.imageProcessingFailed
        }
        let base64 = imageData.base64EncodedString()

        // Build request
        var request = URLRequest(url: URL(string: endpoint)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.timeoutInterval = 60

        let prompt = """
        你是一位资深中国古陶瓷鉴定专家，拥有数十年博物馆及拍卖行经验。请仔细鉴赏这件瓷器/陶器的图片，给出专业鉴定意见。

        请严格按照以下 JSON 格式回复，不要输出任何其他内容、不要用 markdown 代码块包裹：

        {"overall":75,"era_score":80,"era_note":"简短年代判断说明","glaze_score":70,"glaze_note":"釉色工艺说明","shape_score":75,"shape_note":"器型特征说明","pattern_score":72,"pattern_note":"纹饰风格说明","bottom_score":68,"bottom_note":"底款特征说明（如图中不可见则说明）","wear_score":78,"wear_note":"老化痕迹说明","name":"器物名称（如：青花缠枝莲纹梅瓶）","dynasty":"推断年代（如：清康熙）","type":"器型分类（如：梅瓶）","summary":"总体鉴定意见，100字以内"}

        评分标准：90以上=高度可信真品，70-89=较可信，40-69=存疑需进一步鉴定，40以下=疑伪。
        如果图片不是瓷器或陶器，overall 给 0，summary 写"非瓷器/陶器图片"。
        """

        let body: [String: Any] = [
            "model": model,
            "max_tokens": 1024,
            "messages": [
                [
                    "role": "user",
                    "content": [
                        [
                            "type": "image",
                            "source": [
                                "type": "base64",
                                "media_type": "image/jpeg",
                                "data": base64
                            ]
                        ],
                        [
                            "type": "text",
                            "text": prompt
                        ]
                    ]
                ]
            ]
        ]

        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        // Execute
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.networkError
        }

        guard httpResponse.statusCode == 200 else {
            let errorBody = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw APIError.serverError(statusCode: httpResponse.statusCode, message: errorBody)
        }

        // Parse response
        let apiResponse = try JSONDecoder().decode(ClaudeResponse.self, from: data)

        guard let textContent = apiResponse.content.first(where: { $0.type == "text" }),
              let text = textContent.text else {
            throw APIError.emptyResponse
        }

        // Clean and parse JSON
        let cleaned = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let jsonData = cleaned.data(using: .utf8) else {
            throw APIError.parseError
        }

        let result = try JSONDecoder().decode(AppraisalResult.self, from: jsonData)
        return result
    }
}

// MARK: - API Response Models

private struct ClaudeResponse: Codable {
    let content: [ContentBlock]
}

private struct ContentBlock: Codable {
    let type: String
    let text: String?
}

// MARK: - API Errors

enum APIError: LocalizedError {
    case imageProcessingFailed
    case networkError
    case serverError(statusCode: Int, message: String)
    case emptyResponse
    case parseError
    case invalidAPIKey

    var errorDescription: String? {
        switch self {
        case .imageProcessingFailed: return "图片处理失败"
        case .networkError: return "网络连接失败"
        case .serverError(let code, _): return "服务器错误 (\(code))"
        case .emptyResponse: return "未获取到分析结果"
        case .parseError: return "结果解析失败"
        case .invalidAPIKey: return "API 密钥无效，请在设置中配置"
        }
    }
}

// MARK: - API Key Manager

enum APIKeyManager {
    static var currentKey: String {
        get { UserDefaults.standard.string(forKey: "anthropic_api_key") ?? "" }
        set { UserDefaults.standard.set(newValue, forKey: "anthropic_api_key") }
    }

    static var isConfigured: Bool {
        !currentKey.isEmpty && currentKey != "YOUR_API_KEY_HERE"
    }
}
