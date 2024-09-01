import SwiftUI

public struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""

    public init() {}

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
        .alert("Error", isPresented: self.$authViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(self.authViewModel.errorMessage)
        }
    }

    private func login() async {
        await self.authViewModel.login(email: self.email, password: self.password)
    }
}
