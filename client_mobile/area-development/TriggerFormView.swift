import SwiftUI

struct TriggerFormData {
    var fields: [String: String]
}

struct TriggerFormView: View {
    var trigger: Trigger
    var actionFormData: FormData
    var action: Action
    @State private var formData: [String: String] = [:]
    @State private var savedFormData: TriggerFormData?
    @State private var name: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Remplissez les champs pour \(trigger.name)")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Form {
                TextField("Name de l'Area", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if (!trigger.metadataFields.isEmpty) {
                    ForEach(trigger.metadataFields, id: \.name) { field in
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
                createArea(name: name, trigger: trigger, action: action,actionFormData: actionFormData, triggerFormData: savedFormData)
                DashboardView()
            }) {
                Text("Submit")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
    }
    
    func saveFormData() {
        savedFormData = TriggerFormData(fields: formData)
        print("Trigger form data saved: \(savedFormData?.fields ?? [:])")
    }
}
