import SwiftUI
import AppCore

@main
struct YeBlogApp: App {
    let appCore: AppCore

    init() {
        let baseURL = URL(string: "https://5cj816p8-8080.euw.devtunnels.ms/")!
        self.appCore = AppCore(baseURL: baseURL)
    }

    var body: some Scene {
        WindowGroup {
            appCore.makeRootView()
        }
    }
}
