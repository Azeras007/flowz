import SwiftUI

struct FormData {
    var fields: [String: String]
}

struct ActionFormView: View {
    var action: Action
    @State private var formData: [String: String] = [:]
    @State private var savedFormData: FormData = FormData(fields: [:])
    @State private var shouldNavigate = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title and Back Button
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
                ForEach(action.metadata.fields, id: \.name) { field in
                    if field.type == "text" {
                        TextField(field.label, text: Binding(
                            get: { formData[field.name] ?? "" },
                            set: { formData[field.name] = $0 }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                saveFormData()
                shouldNavigate = true
            }) {
                Text("Submit")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.yellow)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)
            
            NavigationLink(destination: SubServicesTriggerView(actionFormData: savedFormData), isActive: $shouldNavigate) {
                EmptyView()
            }
            
            Spacer()
        }
        .padding()
    }
    
    func saveFormData() {
        savedFormData = FormData(fields: formData)
        print("Form data saved: \(savedFormData.fields)")
    }
}
