import Domain
import SwiftUI

public struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingLogoutAlert = false

    public init(viewModel: ProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                self.profileHeader
                self.actionsSection
            }
            .padding()
        }
        .navigationTitle("Profile")
        .background(Color(.systemGroupedBackground))
        .task {
            await self.viewModel.fetchProfile()
        }
        .sheet(isPresented: self.$showingImagePicker) {
            ImagePicker(image: self.$inputImage)
        }
        .onChange(of: self.inputImage) {
            guard let inputImage else { return }
            Task {
                await self.viewModel.uploadAvatar(inputImage)
            }
        }
        .alert("Error", isPresented: .constant(self.viewModel.errorMessage != nil)) {
            Button("OK", role: .cancel) {
                self.viewModel.errorMessage = nil
            }
        } message: {
            Text(self.viewModel.errorMessage ?? "")
        }
        .alert("Logout", isPresented: self.$showingLogoutAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Logout", role: .destructive) {
                Task {
                    await self.viewModel.logout()
                }
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
        .overlay(Group {
            if self.viewModel.isLoading {
                Color.black.opacity(0.4)
                    .overlay(
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                    )
                    .ignoresSafeArea()
            }
        })
    }

    private var profileHeader: some View {
        VStack(spacing: 0) {
            if let user = viewModel.user {
                HStack(spacing: 8) {
                    self.avatarView(for: user)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(user.username)
                            .font(.title2)
                            .fontWeight(.bold)

                        Text(user.email)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)

                self.avatarActionButtons
            }
        }
    }

    private func avatarView(for user: User) -> some View {
        Group {
            if let avatarURL = user.avatarUrl {
                AsyncImage(url: avatarURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 80, height: 80)
        .clipShape(Circle())
    }

    private var avatarActionButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                self.showingImagePicker = true
            }) {
                Text("Change Avatar")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if self.viewModel.user?.avatarUrl != nil {
                Button("Remove Avatar") {
                    Task {
                        await self.viewModel.removeAvatar()
                    }
                }
                .foregroundColor(.red)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.red, lineWidth: 1)
                )
            }
        }
        .padding(.top, 12)
    }

    private var actionsSection: some View {
        Button(action: {
            self.showingLogoutAlert = true
        }) {
            Text("Logout")
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(14)
                .background(Color(.systemBackground))
                .clipShape(Capsule())
                .contentShape(Capsule())
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_: UIImagePickerController, context _: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(
            _: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let uiImage = info[.originalImage] as? UIImage {
                self.parent.image = uiImage
            }
            self.parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
