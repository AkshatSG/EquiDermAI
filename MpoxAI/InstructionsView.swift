import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack {
            Text("Instructions")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("Follow these steps to diagnose Mpox effectively:")
                .font(.headline)
                .padding(.top)

            VStack(alignment: .leading, spacing: 10) {
                Text("1. Ensure good lighting conditions for clear images.")
                Text("2. Focus on the affected area and avoid background distractions.")
                Text("3. Take multiple pictures for better accuracy.")
            }
            .font(.body)
            .padding(.top, 20)
            .padding(.horizontal)

            Spacer()

            NavigationLink(destination: ImageSelectionView()) {
                Text("Next")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
            .padding(.horizontal)

            // Disclaimer Section
            Text("Disclaimer: The results may not be very accurate. This application should not be relied upon for primary diagnosis and is only a secondary alternative for individuals.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
                .foregroundColor(.gray)
                .padding(.bottom, 20)
                .padding(.horizontal)

        }
        .padding(.top, 20)
        .navigationTitle("Instructions")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InstructionsView_Previews: PreviewProvider {
    static var previews: some View {
        InstructionsView()
    }
}
