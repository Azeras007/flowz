import SwiftUI

struct FormData {
    var fields: [String: String]
}

struct ActionFormView: View {
    var action: Action
    @State private var formData: [String: String] = [:]
    @State private var savedFormData: FormData = FormData(fields: [:])
    @State private var shouldNavigate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Remplissez les champs pour \(action.name)")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
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
                    .background(Color.blue)
                    .foregroundColor(.white)
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
