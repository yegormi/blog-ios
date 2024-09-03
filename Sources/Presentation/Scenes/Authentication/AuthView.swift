import SwiftUI

public struct AuthView: View {
    @StateObject var viewModel: AuthViewModel
    @State private var isShowingLogin = true
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    public init(viewModel: AuthViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
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
