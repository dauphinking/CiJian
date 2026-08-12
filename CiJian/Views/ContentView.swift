import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    @State private var showSplash = true

    var body: some View {
        ZStack {
            if showSplash {
                SplashView {
                    withAnimation(.easeOut(duration: 0.6)) {
                        showSplash = false
                    }
                }
                .transition(.opacity)
            } else {
                mainTabView
                    .transition(.opacity)
            }
        }
    }

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("首页", systemImage: "circle.grid.2x2")
                }
                .tag(0)

            CaptureView()
                .tabItem {
                    Label("鉴定", systemImage: "camera.viewfinder")
                }
                .tag(1)

            KnowledgeView()
                .tabItem {
                    Label("知识", systemImage: "book")
                }
                .tag(2)

            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person")
                }
                .tag(3)
        }
        .tint(CJ.Colors.gold)
    }
}

#Preview {
    ContentView()
        .environmentObject(AppState())
}
