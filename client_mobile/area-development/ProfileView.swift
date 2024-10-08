import SwiftUI

struct ProfileView: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @State private var isShowingLogoutAlert = false

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
    }

    private func signOut() {
        KeychainHelper.deleteToken()
        isUserLoggedIn = false
    }
}
