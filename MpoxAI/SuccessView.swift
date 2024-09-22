import SwiftUI
import CoreML
import UIKit

struct SuccessView: View {
    var selectedImage: UIImage
    @State private var predictionResult: String = "Processing..."
    
    var body: some View {
        VStack {
            Text("Success!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Image(uiImage: selectedImage)
                .resizable()
                .scaledToFit()
                .frame(height: 300)
                .padding()
            Text(predictionResult)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
        .navigationBarTitle("Success", displayMode: .inline)
        .onAppear {
            performInference()
        }
    }
    
    private func performInference() {
        let configuration = MLModelConfiguration()
        configuration.computeUnits = .cpuOnly
        
        guard let model = try? mpox_model_fp32(configuration: configuration) else {
            predictionResult = "Failed to load the model."
            return
        }
        
        do {
            // Prepare the image for input
            guard let multiArray = try prepareImageForModel(image: selectedImage) else {
                predictionResult = "Failed to prepare image for model."
                return
            }
            
            let input = mpox_model_fp32Input(input_1: multiArray)
            
            // Perform the prediction
            let output = try model.prediction(input: input)
            predictionResult = "Prediction: \(output.Identity)" // Adjust based on your model's output key
        } catch {
            predictionResult = "Failed to prepare image or make prediction: \(error)"
        }
    }
    
    private func prepareImageForModel(image: UIImage) throws -> MLMultiArray? {
        // Resize the image to match the model's input dimensions (300x300)
        guard let resizedImage = image.resize(to: CGSize(width: 300, height: 300)) else {
            print("Image resizing failed")
            throw ImagePreprocessingError.resizeFailed
        }
        
        // Convert the resized image to MLMultiArray in channel-last format
        guard let multiArray = resizedImage.toMLMultiArrayChannelLast() else {
            print("MLMultiArray creation failed")
            throw ImagePreprocessingError.multiArrayCreationFailed
        }
        
        return multiArray
    }
}

// Error handling for image preprocessing
enum ImagePreprocessingError: Error {
    case resizeFailed
    case multiArrayCreationFailed
}

// UIImage extension to handle resizing and conversion to MLMultiArray (channel-last)
extension UIImage {
    
    // Resize the UIImage to the target size
    func resize(to targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    // Convert the image into an MLMultiArray (RGB format) in channel-last order [1, 300, 300, 3]
    func toMLMultiArrayChannelLast() -> MLMultiArray? {
        guard let cgImage = self.cgImage else {
            print("Failed to get CGImage")
            return nil
        }
        
        let width = 300
        let height = 300
        let channels = 3 // RGB
        
        guard let data = cgImage.dataProvider?.data, let rawData = CFDataGetBytePtr(data) else {
            print("Failed to get pixel data from image")
            return nil
        }
        
        // Create an MLMultiArray with shape [1, 300, 300, 3]
        guard let mlArray = try? MLMultiArray(shape: [1, NSNumber(value: height), NSNumber(value: width), NSNumber(value: channels)], dataType: .float32) else {
            print("Failed to create MLMultiArray")
            return nil
        }
        
        let bufferPointer = mlArray.dataPointer.bindMemory(to: Float32.self, capacity: channels * height * width)
        
        // Handle BGRA data from the CGImage and map it to MLMultiArray (RGB order)
        var pixelIndex = 0
        for y in 0..<height {
            for x in 0..<width {
                let index = (y * cgImage.bytesPerRow) + (x * 4)
                let b = Float32(rawData[index]) / 255.0
                let g = Float32(rawData[index + 1]) / 255.0
                let r = Float32(rawData[index + 2]) / 255.0
                
                bufferPointer[pixelIndex * 3] = r
                bufferPointer[pixelIndex * 3 + 1] = g
                bufferPointer[pixelIndex * 3 + 2] = b
                
                pixelIndex += 1
            }
        }
        
        return mlArray
    }
}
