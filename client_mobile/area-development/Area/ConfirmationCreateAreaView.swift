import SwiftUI

struct ConfirmationCreateAreaView: View {
    @State private var nameArea = ""
    @Environment(\.dismiss) var dismiss
    @Binding var isPresentingCreateView: Bool

    var body: some View {
        VStack {
            Form {
                TextField("Name", text: $nameArea)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onChange(of: nameArea) { newValue in
                        KeychainHelper.saveNameArea(newValue)
                    }
            }

            Spacer()

            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: {
                    createArea()
                    print("Successfully created AREA")
                    isPresentingCreateView = false
                }) {
                    Text("Create")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
