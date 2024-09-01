import SwiftUI

public struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    public var body: some View {
        Form {
            Section(header: Text("Register")) {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: $password)
            }

            Button(action: register) {
                Text("Register")
            }
            .disabled(username.isEmpty || email.isEmpty || password.isEmpty)
        }
        .navigationTitle("Register")
        .alert("Error", isPresented: $authViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(authViewModel.errorMessage)
        }
    }

    private func register() {
        authViewModel.register(username: username, email: email, password: password)
    }
}
