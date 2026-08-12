import SwiftUI

// MARK: - Seal Stamp (鉴定印章)

struct SealStampView: View {
    let score: Int
    let size: CGFloat

    init(score: Int, size: CGFloat = 120) {
        self.score = score
        self.size = size
    }

    private var color: Color { CJ.Colors.scoreColor(score) }
    private var verdict: String { CJ.Colors.scoreVerdict(score) }

    var body: some View {
        ZStack {
            // Outer border
            RoundedRectangle(cornerRadius: size * 0.04)
                .stroke(color, lineWidth: size * 0.025)
                .frame(width: size, height: size)

            // Inner border
            RoundedRectangle(cornerRadius: size * 0.02)
                .stroke(color.opacity(0.4), lineWidth: size * 0.01)
                .frame(width: size * 0.82, height: size * 0.82)

            VStack(spacing: size * 0.02) {
                Text("鉴定")
                    .font(.system(size: size * 0.11, design: .serif))
                    .foregroundColor(color)
                    .tracking(size * 0.04)

                Text("\(score)%")
                    .font(.system(size: size * 0.26, weight: .bold, design: .serif))
                    .foregroundColor(color)

                Text(verdict)
                    .font(.system(size: size * 0.08, design: .serif))
                    .foregroundColor(color.opacity(0.7))
            }
        }
        .rotationEffect(.degrees(-8))
    }
}

// MARK: - Score Bar

struct ScoreBarView: View {
    let label: String
    let icon: String
    let score: Int
    let note: String?
    var showNote: Bool = false

    private var color: Color { CJ.Colors.scoreColor(score) }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(icon) \(label)")
                    .font(CJ.Fonts.serifBody(12))
                    .foregroundColor(CJ.Colors.ivoryMuted)
                    .tracking(1)

                Spacer()

                Text("\(score)%")
                    .font(CJ.Fonts.mono(13))
                    .foregroundColor(color)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.white.opacity(0.06))
                        .frame(height: 4)

                    Capsule()
                        .fill(color)
                        .frame(width: geo.size.width * CGFloat(score) / 100, height: 4)
                        .shadow(color: color.opacity(0.3), radius: 4)
                }
            }
            .frame(height: 4)

            if showNote, let note = note {
                Text(note)
                    .font(.system(size: 11))
                    .foregroundColor(CJ.Colors.textMuted)
                    .lineSpacing(3)
                    .padding(.top, 2)
            }
        }
    }
}

// MARK: - Tag View

struct TagView: View {
    let text: String
    var color: Color = CJ.Colors.gold
    var fontSize: CGFloat = 11

    var body: some View {
        Text(text)
            .font(CJ.Fonts.serifBody(fontSize))
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 3)
            .background(color.opacity(0.12))
            .cornerRadius(3)
    }
}

// MARK: - Section Header

struct SectionHeader: View {
    let title: String
    var trailing: String? = nil
    var onTrailingTap: (() -> Void)? = nil

    var body: some View {
        HStack {
            Text(title)
                .font(CJ.Fonts.serifBody(13))
                .foregroundColor(CJ.Colors.ivory)
                .tracking(3)

            Spacer()

            if let trailing = trailing {
                Button(action: { onTrailingTap?() }) {
                    Text(trailing)
                        .font(.system(size: 11))
                        .foregroundColor(CJ.Colors.gold)
                }
            }
        }
    }
}

// MARK: - Gold Divider

struct GoldDivider: View {
    var width: CGFloat = 40

    var body: some View {
        Rectangle()
            .fill(CJ.Colors.gold)
            .frame(width: width, height: 1)
            .opacity(0.4)
    }
}

// MARK: - Eyebrow Label

struct EyebrowLabel: View {
    let text: String

    var body: some View {
        Text(text)
            .font(CJ.Fonts.serifBody(10))
            .foregroundColor(CJ.Colors.gold)
            .tracking(4)
            .opacity(0.7)
    }
}

// MARK: - Loading Overlay

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: CJ.Colors.gold))
                    .scaleEffect(1.2)

                Text("鉴定中…")
                    .font(CJ.Fonts.serifBody(14))
                    .foregroundColor(CJ.Colors.gold)
                    .tracking(4)
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
    }
}

// MARK: - Avatar View

struct AvatarView: View {
    let name: String
    var size: CGFloat = 32
    var bgColor: Color = CJ.Colors.gold.opacity(0.12)
    var textColor: Color = CJ.Colors.gold

    var body: some View {
        Text(String(name.prefix(1)))
            .font(CJ.Fonts.serifBody(size * 0.4))
            .foregroundColor(textColor)
            .frame(width: size, height: size)
            .background(bgColor)
            .clipShape(Circle())
    }
}

// MARK: - Previews

#Preview("Seal Stamp") {
    ZStack {
        CJ.Colors.ink.ignoresSafeArea()
        VStack(spacing: 30) {
            SealStampView(score: 92)
            SealStampView(score: 55, size: 80)
            SealStampView(score: 25, size: 60)
        }
    }
}

#Preview("Score Bar") {
    ZStack {
        CJ.Colors.ink.ignoresSafeArea()
        VStack(spacing: 16) {
            ScoreBarView(label: "年代判断", icon: "⏳", score: 88, note: "与明永乐特征吻合")
            ScoreBarView(label: "釉色工艺", icon: "✦", score: 55, note: nil)
            ScoreBarView(label: "底款特征", icon: "印", score: 30, note: nil)
        }
        .padding()
    }
}
