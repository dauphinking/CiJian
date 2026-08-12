import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @Binding var selectedTab: Int

    // Demo data
    private let recentItems: [(name: String, era: String, score: Int, emoji: String)] = [
        ("青花缠枝莲纹梅瓶", "明永乐", 92, "🏺"),
        ("粉彩百花不落地碗", "清乾隆", 78, "🍵"),
        ("钧窑天蓝釉鼓钉三足洗", "北宋", 95, "🫖"),
        ("斗彩鸡缸杯", "明成化", 45, "🍶"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    quickActions
                    recentSection
                }
            }
            .background(CJ.Colors.ink)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 8) {
                        Text("瓷鉴")
                            .font(.system(size: 18, weight: .light, design: .serif))
                            .foregroundColor(CJ.Colors.ivory)
                            .tracking(4)
                        Text("BIDITECH")
                            .font(.system(size: 9))
                            .foregroundColor(CJ.Colors.textMuted)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    AvatarView(name: "金", size: 30)
                }
            }
        }
    }

    // MARK: - Quick Actions

    private var quickActions: some View {
        HStack(spacing: 0) {
            quickActionItem(icon: "camera.viewfinder", label: "拍照鉴定") {
                selectedTab = 1
            }
            quickActionItem(icon: "clock.arrow.circlepath", label: "历史记录") {}
            quickActionItem(icon: "star", label: "收藏夹") {}
            quickActionItem(icon: "book", label: "知识库") {
                selectedTab = 2
            }
        }
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.vertical, 16)
    }

    private func quickActionItem(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(CJ.Colors.gold)
                    .frame(width: 44, height: 44)
                    .background(CJ.Colors.goldDim)
                    .cornerRadius(12)

                Text(label)
                    .font(.system(size: 10))
                    .foregroundColor(CJ.Colors.ivoryMuted)
                    .tracking(1)
            }
            .frame(maxWidth: .infinity)
        }
    }

    // MARK: - Recent Appraisals

    private var recentSection: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "近期鉴定", trailing: "查看全部 →")
                .padding(.horizontal, CJ.Layout.screenPadding)
                .padding(.bottom, 8)

            ForEach(Array(recentItems.enumerated()), id: \.offset) { _, item in
                recentItemRow(item)
            }
        }
    }

    private func recentItemRow(_ item: (name: String, era: String, score: Int, emoji: String)) -> some View {
        HStack(spacing: 14) {
            Text(item.emoji)
                .font(.system(size: 28))
                .frame(width: 56, height: 56)
                .background(CJ.Colors.card)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(CJ.Colors.border, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 5) {
                Text(item.name)
                    .font(CJ.Fonts.serifBody(14))
                    .foregroundColor(CJ.Colors.ivory)

                HStack(spacing: 8) {
                    TagView(text: item.era, fontSize: 10)

                    // Mini bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule().fill(Color.white.opacity(0.06))
                            Capsule()
                                .fill(CJ.Colors.scoreColor(item.score))
                                .frame(width: geo.size.width * CGFloat(item.score) / 100)
                        }
                    }
                    .frame(width: 44, height: 3)

                    Text("\(item.score)%")
                        .font(CJ.Fonts.mono(11))
                        .foregroundColor(CJ.Colors.scoreColor(item.score))
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundColor(CJ.Colors.textMuted)
        }
        .padding(.horizontal, CJ.Layout.screenPadding)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Divider().overlay(CJ.Colors.border)
                .padding(.leading, 88)
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
        .environmentObject(AppState())
}
