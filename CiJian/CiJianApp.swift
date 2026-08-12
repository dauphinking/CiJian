import SwiftUI

@main
struct CiJianApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark)
        }
    }
}

class AppState: ObservableObject {
    @Published var isOnboarded: Bool = UserDefaults.standard.bool(forKey: "isOnboarded")
    @Published var appraisalHistory: [AppraisalRecord] = []

    func completeOnboarding() {
        isOnboarded = true
        UserDefaults.standard.set(true, forKey: "isOnboarded")
    }
}
