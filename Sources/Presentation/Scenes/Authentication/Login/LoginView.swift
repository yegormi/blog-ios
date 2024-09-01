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
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    SecureField("Password", text: $password)
                }

                Button(action: login) {
                    Text("Login")
                }
                .disabled(email.isEmpty || password.isEmpty)

                NavigationLink(destination: RegisterView()) {
                    Text("Don't have an account? Register")
                }
            }
            .navigationTitle("Login")
        }
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authViewModel.errorMessage)
        }
    }

    private func login() {
        authViewModel.login(email: email, password: password)
    }
}
