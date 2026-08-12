import SwiftUI

struct ResultView: View {
    let result: AppraisalResult
    let image: UIImage
    var onReset: () -> Void

    @State private var showSeal = false
    @State private var showScores = false
    @State private var showNotes = false

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                imageHeader
                titleCard
                scoresCard
                notesCard
                summaryCard
                actionsSection
                disclaimer
            }
            .padding(.bottom, 32)
        }
        .background(CJ.Colors.ink)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3)) {
                showSeal = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.5)) {
                showScores = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.8)) {
                showNotes = true
            }
        }
    }

    // MARK: - Image Header

    private var imageHeader: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(height: 240)
                .clipped()
                .overlay(
                    LinearGradient(
                        colors: [.clear, CJ.Colors.ink.opacity(0.8)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                )

            // Seal stamp overlay
            SealStampView(score: result.overall, size: 80)
                .scaleEffect(showSeal ? 1 : 1.5)
                .opacity(showSeal ? 1 : 0)
                .padding(16)
        }
    }

    // MARK: - Title Card

    private var titleCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            EyebrowLabel(text: "NO. \(reportNumber)")

            Text(result.name)
                .font(.system(size: 20, weight: .regular, design: .serif))
                .foregroundColor(CJ.Colors.ivory)
                .tracking(2)

            HStack(spacing: 8) {
                TagView(text: result.dynasty)
                TagView(text: result.type, color: CJ.Colors.celadon)
                TagView(
                    text: CJ.Colors.scoreVerdict(result.overall),
                    color: CJ.Colors.scoreColor(result.overall)
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(CJ.Layout.cardPadding)
        .padding(.horizontal, 4)
    }

    // MARK: - Scores Card

    private var scoresCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            EyebrowLabel(text: "分项评估")

            ForEach(Array(result.dimensionScores.enumerated()), id: \.element.key) { index, dim in
                ScoreBarView(
                    label: dim.label,
                    icon: dim.icon,
                    score: dim.score,
                    note: nil
                )
                .opacity(showScores ? 1 : 0)
                .offset(y: showScores ? 0 : 10)
                .animation(.easeOut(duration: 0.4).delay(Double(index) * 0.1), value: showScores)
            }
        }
        .padding(CJ.Layout.cardPadding)
        .cardStyle()
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.bottom, 12)
    }

    // MARK: - Notes Card

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            EyebrowLabel(text: "专家意见")

            ForEach(result.dimensionScores, id: \.key) { dim in
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(dim.icon) \(dim.label)")
                        .font(CJ.Fonts.serifBody(12))
                        .foregroundColor(CJ.Colors.gold)

                    Text(dim.note)
                        .font(.system(size: 12))
                        .foregroundColor(CJ.Colors.ivoryMuted)
                        .lineSpacing(4)
                }
            }
        }
        .padding(CJ.Layout.cardPadding)
        .cardStyle()
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.bottom, 12)
        .opacity(showNotes ? 1 : 0)
    }

    // MARK: - Summary Card

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Text("◆")
                    .foregroundColor(CJ.Colors.sealRed)
                    .font(.system(size: 10))
                Text("综合鉴定")
                    .font(CJ.Fonts.serifBody(12))
                    .foregroundColor(CJ.Colors.sealRed)
            }

            Text(result.summary)
                .font(CJ.Fonts.serifBody(14))
                .foregroundColor(CJ.Colors.ivory)
                .lineSpacing(6)
        }
        .padding(CJ.Layout.cardPadding)
        .cardStyle()
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.bottom, 16)
        .opacity(showNotes ? 1 : 0)
    }

    // MARK: - Actions

    private var actionsSection: some View {
        VStack(spacing: 10) {
            // Share button
            ShareLink(
                item: shareText,
                subject: Text("瓷鉴鉴定报告"),
                message: Text(shareText)
            ) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                    Text("分享报告")
                }
                .font(CJ.Fonts.serifBody(14))
                .foregroundColor(CJ.Colors.gold)
                .tracking(2)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(CJ.Colors.gold.opacity(0.3), lineWidth: 1)
                )
            }

            // Reset button
            Button(action: onReset) {
                Text("重新鉴定")
                    .font(CJ.Fonts.serifBody(14))
                    .foregroundColor(CJ.Colors.ink)
                    .tracking(3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(CJ.Colors.gold)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.bottom, 16)
    }

    // MARK: - Disclaimer

    private var disclaimer: some View {
        Text("※ 本鉴定结果由 AI 辅助生成，仅供参考。实物鉴定请咨询专业机构。")
            .font(.system(size: 10))
            .foregroundColor(CJ.Colors.textMuted)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 32)
    }

    // MARK: - Helpers

    private var reportNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return "\(formatter.string(from: Date()))-001"
    }

    private var shareText: String {
        """
        【瓷鉴 AI 鉴定报告】
        器物：\(result.name)
        年代：\(result.dynasty)
        器型：\(result.type)
        综合可信度：\(result.overall)%（\(CJ.Colors.scoreVerdict(result.overall))）

        分项评分：
        ⏳ 年代判断：\(result.eraScore)%
        ✦ 釉色工艺：\(result.glazeScore)%
        ◎ 器型特征：\(result.shapeScore)%
        ❋ 纹饰风格：\(result.patternScore)%
        印 底款特征：\(result.bottomScore)%
        ◈ 老化痕迹：\(result.wearScore)%

        鉴定意见：\(result.summary)

        — 瓷鉴 App · BIDITECH 碧帝数据科技
        """
    }
}

#Preview {
    ResultView(
        result: .mock,
        image: UIImage(systemName: "photo")!,
        onReset: {}
    )
}
