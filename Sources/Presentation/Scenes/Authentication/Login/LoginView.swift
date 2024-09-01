import SwiftUI

public struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Login")) {
                    TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: self.$password)
                }

                Button(action: { Task { await self.login() } }) {
                    Text("Login")
                }
                .disabled(self.email.isEmpty || self.password.isEmpty)

                NavigationLink(destination: RegisterView()) {
                    Text("Don't have an account? Register")
                }
            }
            .navigationTitle("Login")
        }
        .alert("Error", isPresented: self.$viewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(self.viewModel.errorMessage)
        }
    }

    private func login() async {
        await self.viewModel.login(email: self.email, password: self.password)
    }
}
