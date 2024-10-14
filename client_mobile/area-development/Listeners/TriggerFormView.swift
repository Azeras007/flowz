import SwiftUI

struct TriggerFormView: View {
    @State private var isUserLoggedIn: Bool = true
    @State private var navigateToConfirmation = false
    @State private var formData: [String: String] = [:]
    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ZStack {
                Text("Fill in the fields")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
            }
            .padding(.top, 40)
            .navigationBarHidden(true)
            
            
            Form {
                if (!KeychainHelper.getTrigger()!.metadataFields.isEmpty) {
                    ForEach(KeychainHelper.getTrigger()!.metadataFields, id: \.name) { field in
                        if field.type == "text" || field.type == "string" {
                            TextField(field.label, text: Binding(
                                get: { formData[field.name] ?? "" },
                                set: { formData[field.name] = $0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                saveFormData()
                navigateToConfirmation = true
            }) {
                Text("Submit")
                    .padding()
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            
            NavigationLink(destination: ConfirmationCreateAreaView(), isActive: $navigateToConfirmation) {
                EmptyView()
            }
            Spacer()
        }
        .padding()
    }
    
    func saveFormData() {
        let savedFormData = TriggerFormData(fields: formData)
        KeychainHelper.deleteSavedFormDataAction()
        KeychainHelper.savedFormDataTrigger(savedFormData)
        print("Trigger form data saved: \(KeychainHelper.getSavedFormDataTrigger())")
    }
}
