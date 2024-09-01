import AppCore
import SwiftUI

@main
struct YeBlogApp: App {
    let appCore: AppCore

    init() {
        let baseURL = URL(string: "http://127.0.0.1:8080")!
        self.appCore = AppCore(baseURL: baseURL)
    }

    var body: some Scene {
        WindowGroup {
            self.appCore.makeRootView()
        }
    }
}
