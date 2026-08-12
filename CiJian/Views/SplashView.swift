import SwiftUI

struct SplashView: View {
    var onStart: () -> Void

    @State private var logoOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var buttonOpacity: Double = 0

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [CJ.Colors.ink, Color(hex: "0D0D18")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Logo seal
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(CJ.Colors.gold, lineWidth: 2)
                        .frame(width: 80, height: 80)

                    RoundedRectangle(cornerRadius: 5)
                        .stroke(CJ.Colors.gold.opacity(0.3), lineWidth: 1)
                        .frame(width: 66, height: 66)

                    Text("鉴")
                        .font(.system(size: 32, weight: .light, design: .serif))
                        .foregroundColor(CJ.Colors.gold)
                }
                .opacity(logoOpacity)
                .padding(.bottom, 28)

                // Title
                Text("瓷 鉴")
                    .font(.system(size: 30, weight: .light, design: .serif))
                    .foregroundColor(CJ.Colors.ivory)
                    .tracking(12)
                    .opacity(logoOpacity)
                    .offset(y: titleOffset)

                GoldDivider()
                    .padding(.vertical, 18)
                    .opacity(logoOpacity)

                Text("BIDITECH · 碧帝数据科技")
                    .font(CJ.Fonts.serifBody(11))
                    .foregroundColor(CJ.Colors.textMuted)
                    .tracking(4)
                    .opacity(logoOpacity)

                Text("古陶瓷 AI 智能鉴定")
                    .font(CJ.Fonts.serifBody(11))
                    .foregroundColor(CJ.Colors.textMuted)
                    .tracking(2)
                    .padding(.top, 6)
                    .opacity(logoOpacity)

                Spacer()

                // Start button
                Button(action: onStart) {
                    Text("开始鉴定")
                        .font(CJ.Fonts.serifBody(15))
                        .foregroundColor(CJ.Colors.ink)
                        .tracking(4)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(CJ.Colors.gold)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 48)
                .opacity(buttonOpacity)

                Text("v1.0.0 · 上海碧帝数据科技有限公司")
                    .font(.system(size: 10))
                    .foregroundColor(CJ.Colors.textMuted)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                    .opacity(buttonOpacity)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                logoOpacity = 1
                titleOffset = 0
            }
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                buttonOpacity = 1
            }
        }
    }
}

#Preview {
    SplashView(onStart: {})
}
