import SwiftUI

struct ImageSelectionView: View {
    @StateObject private var viewModel = CameraViewModel() // Use @StateObject for viewModel

    var body: some View {
        NavigationView {
            ScrollView { // Wrap the entire content in a ScrollView
                VStack {
                    Text("Select an Image")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)

                    // Buttons to choose photo source
                    VStack(spacing: 20) {
                        Button(action: {
                            viewModel.showCamera = true
                        }) {
                            Text("Take Photo")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            viewModel.showPhotoLibrary = true
                        }) {
                            Text("Upload Photo")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()

                    // Display selected image and options if an image is selected
                    if let image = viewModel.selectedImage {
                        VStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                                .padding()

                            HStack(spacing: 20) {
                                NavigationLink(destination: SuccessView(selectedImage: image)) {
                                    Text("Proceed")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }

                                Button(action: {
                                    viewModel.selectedImage = nil // Clear image
                                }) {
                                    Text("Back")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.gray)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            .padding()
                        }
                        .padding(.bottom, 20) // Add padding at the bottom
                    }
                }
                .padding()
            }
            .navigationTitle("Image Selection")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showCamera) {
                ImagePicker(sourceType: .camera, selectedImage: $viewModel.selectedImage, isPresenting: $viewModel.showCamera)
            }
            .sheet(isPresented: $viewModel.showPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary, selectedImage: $viewModel.selectedImage, isPresenting: $viewModel.showPhotoLibrary)
            }
        }
    }
}

struct ImageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSelectionView()
    }
}
