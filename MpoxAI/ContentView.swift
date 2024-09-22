import SwiftUI

struct ContentView: View {
    @State private var showPrivacyPolicy = false // State variable to control the sheet
    @State private var isAgreedToTerms = false // State variable for the checkbox
    @State private var navigateToInstructions = false // State variable for navigation

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 8) {
                    Spacer()

                    // Header logo with "Beta" label
                    HStack {
                        Image(systemName: "circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                    }
                    
                    // Main title
                    Text("MpoxAI")
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    // Subtitle
                    Text("Diagnose Mpox (Monkeypox) quickly with just a picture. The sooner you diagnose, the more time and opportunities you have for treatment or preventive care.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Spacer()

                    // Features list
                    VStack(alignment: .leading, spacing: 20) {
                        FeatureView(icon: "star.fill", title: "Rapid Diagnosis", description: "Receive a structured diagnosis and detailed confidence scores with a processing time of <1 second.")
                        FeatureView(icon: "wifi", title: "No Internet Required", description: "To make this app accessible to everyone, from diverse regions, no internet access is required to diagnose the rash after installation.")
                        FeatureView(icon: "lock.shield.fill", title: "Complete Privacy", description: "Our AI Model is run locally, and thus, all the processes occur solely on your device. Your photos are used only for diagnosis.")
                    }
                    .padding(.horizontal)

                    // Checkbox for agreeing to terms
                    HStack(alignment: .top) {
                        Toggle(isOn: $isAgreedToTerms) {
                            PolicyText(description: "I agree to the Privacy Policy & Terms of Service")
                                .foregroundColor(.blue)
                                .onTapGesture {
                                    showPrivacyPolicy = true
                                }
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                    .padding()

                    // Buttons
                    VStack(spacing: 20) {
                        Button(action: {
                            navigateToInstructions = true
                        }) {
                            Text("Diagnose")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(isAgreedToTerms ? Color.blue : Color.gray) // Change color based on agreement
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(!isAgreedToTerms) // Disable button if terms are not agreed
                        .background(
                            NavigationLink(destination: InstructionsView(), isActive: $navigateToInstructions) {
                                EmptyView()
                            }
                            .hidden()
                        )

                        
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.vertical, 20)
            }
            .navigationBarHidden(true) // Hide navigation bar on this screen
        }
    }
}

// Custom Checkbox Toggle Style
struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Button(action: {
                configuration.isOn.toggle()
            }) {
                Image(systemName: configuration.isOn ? "checkmark.square" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(configuration.isOn ? .blue : .gray)
            }
            configuration.label
        }
    }
}

struct FeatureView: View {
    var icon: String
    var title: String
    var description: String

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title2)
                .padding(.top, 5)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct PolicyText: View {
    var description: String

    var body: some View {
        HStack(alignment: .top) {
            Text(description)
                .font(.subheadline)
                .foregroundColor(.blue)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct PrivacyPolicyView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("""
                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla.

                        Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem.

                        Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.
                        """)
                        .font(.body)
                        .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Privacy Policy")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
