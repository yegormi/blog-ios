import AppCore
import SwiftUI

@main
struct YeBlogApp: App {
    let appCore: AppCore

    init() {
        let baseURL = URL(string: "https://5cj816p8-8080.euw.devtunnels.ms/")!
        self.appCore = AppCore(baseURL: baseURL)
    }

    var body: some Scene {
        WindowGroup {
            self.appCore.makeRootView()
        }
    }
}
