import Foundation
import Presentation
import SwiftUI

enum AppScreen: Equatable {
    case splash
    case auth
    case loggedIn
}

@MainActor
public struct AppCore {
    private let container: DIContainer

    public init() {
        let container = AppDIContainer()
        let registrar = DependencyRegistrar(container: container)
        registrar.registerDependencies()
        self.container = container
        AppDIContainer.initialize(container)
    }

    public func makeRootView() -> some View {
        let authViewModel: AuthViewModel = self.container.resolve()
        let articleListViewModel: ArticleListViewModel = self.container.resolve()
        let articleDetailViewModelFactory: ArticleDetailViewModelFactory = self.container.resolve()
        let profileViewModel: ProfileViewModel = self.container.resolve()

        return AppView(
            authViewModel: authViewModel,
            articleListViewModel: articleListViewModel,
            profileViewModel: profileViewModel,
            articleDetailViewModelFactory: articleDetailViewModelFactory
        )
        .environmentObject(self.container.resolve() as ArticleListViewModel)
        .environmentObject(self.container.resolve() as AuthViewModel)
    }
}

public struct AppView: View {
    @StateObject var authViewModel: AuthViewModel
    @StateObject var articleListViewModel: ArticleListViewModel
    @StateObject var profileViewModel: ProfileViewModel
    let articleDetailViewModelFactory: ArticleDetailViewModelFactory

    @State private var currentScreen: AppScreen = .splash

    public init(
        authViewModel: AuthViewModel,
        articleListViewModel: ArticleListViewModel,
        profileViewModel: ProfileViewModel,
        articleDetailViewModelFactory: ArticleDetailViewModelFactory
    ) {
        self._authViewModel = StateObject(wrappedValue: authViewModel)
        self._articleListViewModel = StateObject(wrappedValue: articleListViewModel)
        self._profileViewModel = StateObject(wrappedValue: profileViewModel)
        self.articleDetailViewModelFactory = articleDetailViewModelFactory
    }

    public var body: some View {
        Group {
            switch self.currentScreen {
            case .splash:
                SplashView {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.currentScreen = self.authViewModel.isLoggedIn ? .loggedIn : .auth
                    }
                }
            case .auth:
                AuthView(viewModel: self.authViewModel)
                    .onChange(of: self.authViewModel.isLoggedIn) { isLoggedIn in
                        if isLoggedIn {
                            self.currentScreen = .loggedIn
                        }
                    }
            case .loggedIn:
                LoggedInView(
                    articleListViewModel: self.articleListViewModel,
                    profileViewModel: self.profileViewModel,
                    articleDetailViewModelFactory: self.articleDetailViewModelFactory
                )
                .onChange(of: self.authViewModel.isLoggedIn) { isLoggedIn in
                    if !isLoggedIn {
                        self.currentScreen = .auth
                    }
                }
            }
        }
        .transition(.opacity)
        .animation(.interpolatingSpring(duration: 0.5), value: self.currentScreen)
    }
}

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var isShowingLogin = true
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(self.isShowingLogin ? "Login" : "Register")) {
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: self.$password)
                    if !self.isShowingLogin {
                        TextField("Username", text: self.$username)
                    }
                }

                Button(action: { Task { await self.performAction() } }) {
                    Text(self.isShowingLogin ? "Login" : "Register")
                }
                .disabled(self.email.isEmpty || self.password.isEmpty || (!self.isShowingLogin && self.username.isEmpty))

                Button {
                    withAnimation {
                        self.isShowingLogin.toggle()
                    }
                } label: {
                    Text(self.isShowingLogin ? "Don't have an account? Register" : "Already have an account? Login")
                }
            }
            .navigationTitle(self.isShowingLogin ? "Login" : "Register")
        }
        .alert("Error", isPresented: self.$viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(self.viewModel.errorMessage)
        }
    }

    private func performAction() async {
        if self.isShowingLogin {
            await self.viewModel.login(email: self.email, password: self.password)
        } else {
            await self.viewModel.register(username: self.username, email: self.email, password: self.password)
        }
    }
}

struct SplashView: View {
    let onFinish: () -> Void

    var body: some View {
        Text("Welcome to the App")
            .font(.largeTitle)
            .onAppear(perform: self.onFinish)
    }
}

struct LoggedInView: View {
    @StateObject var articleListViewModel: ArticleListViewModel
    @StateObject var profileViewModel: ProfileViewModel
    let articleDetailViewModelFactory: ArticleDetailViewModelFactory

    var body: some View {
        TabView {
            NavigationView {
                ArticleListView(
                    viewModel: self.articleListViewModel
                ) { article in
                    self.articleDetailViewModelFactory.makeViewModel(for: article)
                }
            }
            .tabItem {
                Label("Articles", systemImage: "list.bullet")
            }

            NavigationView {
                ProfileView(viewModel: self.profileViewModel)
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
        }
    }
}
