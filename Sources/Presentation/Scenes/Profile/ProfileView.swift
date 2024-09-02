import SwiftUI

public struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?

    public init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        List {
            Section {
                if let user = viewModel.user {
                    HStack {
                        Spacer()
                        VStack {
                            if let avatarURL = user.avatarUrl {
                                AsyncImage(url: avatarURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.gray)
                            }

                            Button("Change Avatar") {
                                self.showingImagePicker = true
                            }
                            .padding(.top, 8)

                            if user.avatarUrl != nil {
                                Button("Remove Avatar") {
                                    Task {
                                        await self.viewModel.removeAvatar()
                                    }
                                }
                                .foregroundColor(.red)
                                .padding(.top, 4)
                            }
                        }
                        Spacer()
                    }
                    .padding()

                    HStack {
                        Text("Username")
                        Spacer()
                        Text(user.username)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Email")
                        Spacer()
                        Text(user.email)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationTitle("Profile")
        .onAppear {
            Task {
                await self.viewModel.fetchProfile()
            }
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
