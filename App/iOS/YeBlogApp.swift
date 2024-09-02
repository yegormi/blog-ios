import AppCore
import SwiftUI

@main
struct YeBlogApp: App {
    let appCore: AppCore

    init() {
        self.appCore = AppCore()
    }

    var body: some Scene {
        WindowGroup {
            self.appCore.makeRootView()
        }
    }
}
