import SwiftUI

public struct RegisterView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    public var body: some View {
        Form {
            Section(header: Text("Register")) {
                TextField("Username", text: self.$username)
                TextField("Email", text: self.$email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                SecureField("Password", text: self.$password)
            }

            Button {
                Task { await self.register() }
            } label: {
                Text("Register")
            }
            .disabled(self.username.isEmpty || self.email.isEmpty || self.password.isEmpty)
        }
        .navigationTitle("Register")
        .alert("Error", isPresented: self.$authViewModel.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(self.authViewModel.errorMessage)
        }
    }

    private func register() async {
        await self.authViewModel.register(username: self.username, email: self.email, password: self.password)
    }
}
