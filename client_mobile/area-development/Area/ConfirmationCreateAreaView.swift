import SwiftUI

struct ConfirmationCreateAreaView: View{
    @State private var nameArea = ""
    @State private var isUserLoggedIn: Bool = true
    @State private var navigateToMainView = false
    
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
                    navigateToMainView = true
                }) {
                    Text("Cancel")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
                
                Button(action: {
                    createArea()
                    print("reussi")
                    navigateToMainView = true
                }) {
                    Text("Create")
                        .padding()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
            NavigationLink(destination: MainView(isUserLoggedIn: $isUserLoggedIn), isActive: $navigateToMainView) {
                EmptyView()
            }
        }
    }
}
