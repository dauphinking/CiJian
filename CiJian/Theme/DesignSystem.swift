import SwiftUI

// MARK: - 瓷鉴 Design System

enum CJ {

    // MARK: Colors
    enum Colors {
        static let ink          = Color(hex: "0F0F1A")
        static let dark         = Color(hex: "161625")
        static let card         = Color(hex: "1C1C2E")
        static let gold         = Color(hex: "C9A96E")
        static let goldLight    = Color(hex: "D4B87A")
        static let goldDim      = Color(hex: "C9A96E").opacity(0.12)
        static let ivory        = Color(hex: "F0EBE1")
        static let ivoryMuted   = Color(hex: "A8A295")
        static let sealRed      = Color(hex: "A23020")
        static let celadon      = Color(hex: "7A9E7E")
        static let celadonDim   = Color(hex: "7A9E7E").opacity(0.12)
        static let blue         = Color(hex: "5B7FA6")
        static let text         = Color(hex: "E8E4DC")
        static let textMuted    = Color(hex: "6E6A62")
        static let border       = Color.white.opacity(0.06)

        /// Score-based color
        static func scoreColor(_ score: Int) -> Color {
            if score >= 70 { return celadon }
            if score >= 40 { return gold }
            return sealRed
        }

        /// Score verdict text
        static func scoreVerdict(_ score: Int) -> String {
            if score >= 90 { return "高度可信" }
            if score >= 70 { return "较为可信" }
            if score >= 40 { return "存疑" }
            return "疑伪"
        }
    }

    // MARK: Fonts
    enum Fonts {
        static func display(_ size: CGFloat = 28) -> Font {
            .custom("NotoSerifSC-Light", size: size, relativeTo: .title)
        }
        static func heading(_ size: CGFloat = 18) -> Font {
            .custom("NotoSerifSC-Regular", size: size, relativeTo: .headline)
        }
        static func body(_ size: CGFloat = 14) -> Font {
            .custom("NotoSerifSC-Regular", size: size, relativeTo: .body)
        }
        static func mono(_ size: CGFloat = 13) -> Font {
            .system(size: size, design: .monospaced).weight(.semibold)
        }
        static func label(_ size: CGFloat = 11) -> Font {
            .custom("NotoSerifSC-Regular", size: size, relativeTo: .caption)
        }

        // Fallback fonts (system serif when Noto isn't available)
        static func serifDisplay(_ size: CGFloat = 28) -> Font {
            .system(size: size, design: .serif).weight(.light)
        }
        static func serifHeading(_ size: CGFloat = 18) -> Font {
            .system(size: size, design: .serif)
        }
        static func serifBody(_ size: CGFloat = 14) -> Font {
            .system(size: size, design: .serif)
        }
    }

    // MARK: Layout
    enum Layout {
        static let cornerRadius: CGFloat = 10
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
    }

    // MARK: Appraisal Dimensions
    static let dimensions: [(key: String, label: String, icon: String)] = [
        ("era",     "年代判断", "⏳"),
        ("glaze",   "釉色工艺", "✦"),
        ("shape",   "器型特征", "◎"),
        ("pattern", "纹饰风格", "❋"),
        ("bottom",  "底款特征", "印"),
        ("wear",    "老化痕迹", "◈"),
    ]
}

// MARK: - Color Hex Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - View Extensions

extension View {
    func cardStyle() -> some View {
        self
            .background(CJ.Colors.card)
            .cornerRadius(CJ.Layout.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: CJ.Layout.cornerRadius)
                    .stroke(CJ.Colors.border, lineWidth: 1)
            )
    }

    func goldBorderCard() -> some View {
        self
            .background(CJ.Colors.card)
            .cornerRadius(CJ.Layout.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: CJ.Layout.cornerRadius)
                    .stroke(CJ.Colors.gold.opacity(0.18), lineWidth: 1)
            )
    }
}
