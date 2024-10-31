import SwiftUI

struct ActionFormView: View {
    @State private var formData: [String: String] = [:]
    @State private var activeField: String? = nil
    @State private var gotoConfirmation = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @Binding var isPresentingCreateView: Bool

    var trigger = KeychainHelper.getTrigger()
    
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
                ForEach(KeychainHelper.getAction()!.metadata.fields, id: \.name) { field in
                    if field.type == "text" {
                        TextField(field.label, text: Binding(
                            get: { formData[field.name] ?? "" },
                            set: {
                                formData[field.name] = $0
                                activeField = field.name
                            }
                        ))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
                
                if let canReturn = trigger?.can_return, !canReturn.isEmpty {
                    Section {
                        ForEach(canReturn, id: \.self) { variable in
                            Button(action: {
                                updateActiveFieldWithVariable(variable: variable)
                            }) {
                                Text("Use \(variable)")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)

            Button(action: {
                saveFormData()
                gotoConfirmation = true
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

            NavigationLink(destination: ConfirmationCreateAreaView(isPresentingCreateView: $isPresentingCreateView), isActive: $gotoConfirmation) {
                EmptyView()
            }

            Spacer()
        }
        .padding()
    }

    func updateActiveFieldWithVariable(variable: String) {
        if let activeField = activeField {
            let currentText = formData[activeField] ?? ""
            formData[activeField] = "\(currentText) $(\(variable))"
        }
    }
    
    func saveFormData() {
        let formDatasaved = FormData(fields: formData)
        KeychainHelper.deleteSavedFormDataAction()
        KeychainHelper.savedFormDataAction(formDatasaved)
        print("Form data saved: \(KeychainHelper.getSavedFormDataAction())")
    }
}
