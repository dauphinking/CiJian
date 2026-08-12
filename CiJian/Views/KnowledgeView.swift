import SwiftUI

struct KnowledgeView: View {
    @State private var selectedCategory = 0
    private let categories = ["窑口图鉴", "朝代特征", "釉色辞典", "纹饰图谱", "鉴定口诀"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    categoryPicker
                    dailyFeature
                    kilnList
                }
            }
            .background(CJ.Colors.ink)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("瓷器知识库")
                        .font(.system(size: 16, weight: .light, design: .serif))
                        .foregroundColor(CJ.Colors.ivory)
                        .tracking(3)
                }
            }
        }
    }

    // MARK: - Category Picker

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, cat in
                    Button(action: { selectedCategory = index }) {
                        Text(cat)
                            .font(CJ.Fonts.serifBody(12))
                            .foregroundColor(selectedCategory == index ? CJ.Colors.gold : CJ.Colors.ivoryMuted)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 7)
                            .background(selectedCategory == index ? CJ.Colors.goldDim : CJ.Colors.card)
                            .cornerRadius(18)
                            .overlay(
                                RoundedRectangle(cornerRadius: 18)
                                    .stroke(
                                        selectedCategory == index ? CJ.Colors.gold.opacity(0.18) : CJ.Colors.border,
                                        lineWidth: 1
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, CJ.Layout.screenPadding)
            .padding(.vertical, 12)
        }
    }

    // MARK: - Daily Feature

    private var dailyFeature: some View {
        VStack(alignment: .leading, spacing: 8) {
            EyebrowLabel(text: "每日一鉴")

            Text("如何辨别苏麻离青")
                .font(CJ.Fonts.serifHeading(16))
                .foregroundColor(CJ.Colors.ivory)

            Text("苏麻离青（苏勃泥青）是元末明初青花瓷使用的进口钴料，特征为发色浓艳、有铁锈斑、晕散自然…")
                .font(.system(size: 12))
                .foregroundColor(CJ.Colors.ivoryMuted)
                .lineSpacing(4)
                .lineLimit(3)

            Text("阅读全文 →")
                .font(.system(size: 11))
                .foregroundColor(CJ.Colors.gold)
        }
        .padding(CJ.Layout.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [CJ.Colors.card, Color(hex: "1A2030")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(CJ.Colors.gold.opacity(0.18), lineWidth: 1)
        )
        .overlay(alignment: .bottomTrailing) {
            Text("鉴")
                .font(.system(size: 72, weight: .light, design: .serif))
                .foregroundColor(CJ.Colors.gold.opacity(0.04))
                .offset(x: -8, y: 8)
        }
        .clipped()
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.bottom, 16)
    }

    // MARK: - Kiln List

    private var kilnList: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("名窑图鉴")
                .font(CJ.Fonts.serifBody(12))
                .foregroundColor(CJ.Colors.ivoryMuted)
                .tracking(3)
                .padding(.horizontal, CJ.Layout.screenPadding)
                .padding(.bottom, 8)

            ForEach(KilnInfo.samples) { kiln in
                kilnRow(kiln)
            }
        }
    }

    private func kilnRow(_ kiln: KilnInfo) -> some View {
        HStack(spacing: 12) {
            Text(kiln.emoji)
                .font(.system(size: 22))
                .frame(width: 44, height: 44)
                .background(CJ.Colors.card)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(CJ.Colors.border, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(kiln.name)
                    .font(CJ.Fonts.serifBody(14))
                    .foregroundColor(CJ.Colors.ivory)

                HStack(spacing: 6) {
                    Text("\(kiln.era) · \(kiln.location)")
                        .font(.system(size: 10))
                        .foregroundColor(CJ.Colors.textMuted)

                    TagView(text: kiln.tag, color: CJ.Colors.celadon, fontSize: 9)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 11))
                .foregroundColor(CJ.Colors.textMuted)
        }
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.vertical, 11)
        .overlay(alignment: .bottom) {
            Divider().overlay(CJ.Colors.border)
                .padding(.leading, 76)
        }
    }
}

#Preview {
    KnowledgeView()
}
