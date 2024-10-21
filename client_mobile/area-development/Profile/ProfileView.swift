import SwiftUI
import Alamofire

struct ProfileView: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @State private var isShowingLogoutAlert = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                Spacer()
                
                Button(action: {
                    isShowingLogoutAlert = true
                }) {
                    Text("Sign Out")
                        .padding()
                        .frame(width: 200)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(isPresented: $isShowingLogoutAlert) {
                    Alert(
                        title: Text("Sign Out"),
                        message: Text("Are you sure you want to sign out?"),
                        primaryButton: .destructive(Text("Sign Out")) {
                            signOut()
                        },
                        secondaryButton: .cancel()
                    )
                }
                
                Spacer()
            }
            .padding(.top, 50)
            
            VStack {
                Spacer()
                
                CustomNavBar(selectedTab: $selectedTab, isPresentingCreateView: $isPresentingCreateView)
            }
        }
        .background(
            (colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 28/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private func signOut() {
        KeychainHelper.deleteToken()
        isUserLoggedIn = false
    }
}
