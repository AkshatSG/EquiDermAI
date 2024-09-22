import SwiftUI
import UIKit

class CameraViewModel: ObservableObject {
    @Published var isPresentingImagePicker = false
    @Published var selectedImage: UIImage? = nil
    @Published var showCamera = false
    @Published var showPhotoLibrary = false
}
