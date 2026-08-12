import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState

    private let collectionItems: [(emoji: String, score: Int)] = [
        ("🏺", 92), ("🍵", 78), ("🫖", 95),
        ("🍶", 38), ("🏺", 88), ("🍵", 71),
    ]

    private let menuItems = [
        ("clock.arrow.circlepath", "鉴定记录"),
        ("person.2", "专家咨询"),
        ("bookmark", "知识收藏"),
        ("gearshape", "设置"),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    profileHeader
                    collectionGrid
                    menuList
                }
            }
            .background(CJ.Colors.ink)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("我的")
                        .font(.system(size: 16, weight: .light, design: .serif))
                        .foregroundColor(CJ.Colors.ivory)
                        .tracking(3)
                }
            }
        }
    }

    // MARK: - Profile Header

    private var profileHeader: some View {
        VStack(spacing: 10) {
            AvatarView(name: "金", size: 56)

            Text("金碧辉")
                .font(.system(size: 17, weight: .regular, design: .serif))
                .foregroundColor(CJ.Colors.ivory)
                .tracking(2)

            Text("资深藏家 · 已鉴定 48 件")
                .font(.system(size: 11))
                .foregroundColor(CJ.Colors.textMuted)

            HStack(spacing: 32) {
                statItem(value: "48", label: "鉴定")
                statItem(value: "12", label: "收藏")
                statItem(value: "3", label: "专家复核")
            }
            .padding(.top, 6)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottom) {
            Divider().overlay(CJ.Colors.border)
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(CJ.Fonts.mono(17))
                .foregroundColor(CJ.Colors.ivory)
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(CJ.Colors.textMuted)
        }
    }

    // MARK: - Collection Grid

    private var collectionGrid: some View {
        VStack(spacing: 0) {
            SectionHeader(title: "我的藏品", trailing: "管理 →")
                .padding(.horizontal, CJ.Layout.screenPadding)
                .padding(.top, 16)
                .padding(.bottom, 10)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(Array(collectionItems.enumerated()), id: \.offset) { _, item in
                    ZStack(alignment: .bottomTrailing) {
                        Text(item.emoji)
                            .font(.system(size: 28))
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(CJ.Colors.card)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(CJ.Colors.border, lineWidth: 1)
                            )

                        Text("\(item.score)%")
                            .font(CJ.Fonts.mono(9))
                            .foregroundColor(CJ.Colors.scoreColor(item.score))
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(CJ.Colors.scoreColor(item.score).opacity(0.15))
                            .cornerRadius(3)
                            .padding(5)
                    }
                }
            }
            .padding(.horizontal, CJ.Layout.screenPadding)
        }
    }

    // MARK: - Menu List

    private var menuList: some View {
        VStack(spacing: 0) {
            ForEach(menuItems, id: \.1) { icon, title in
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 15))
                        .foregroundColor(CJ.Colors.ivoryMuted)
                        .frame(width: 24)

                    Text(title)
                        .font(.system(size: 15))
                        .foregroundColor(CJ.Colors.ivory)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundColor(CJ.Colors.textMuted)
                }
                .padding(.horizontal, CJ.Layout.screenPadding)
                .padding(.vertical, 14)
                .overlay(alignment: .bottom) {
                    Divider().overlay(CJ.Colors.border)
                        .padding(.leading, 56)
                }
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AppState())
}
