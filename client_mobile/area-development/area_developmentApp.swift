import SwiftUI
import AuthenticationServices
import SafariServices

@main
struct AreaDevelopmentApp: App {
    @State private var isUserLoggedIn: Bool = false
    @State private var isLoginorRegister: Bool = false
    @State private var isAppSelection: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isUserLoggedIn {
                if isLoginorRegister || isAppSelection{
                    DashboardView()
                } else {
                    AppSelectionView(isAppSelection: $isAppSelection)
                    
                }
            } else {
                if isLoginorRegister {
                    LoginView(isUserLoggedIn: $isUserLoggedIn, isLoginorRegister: $isLoginorRegister)
                        .onOpenURL { url in
                            print("Received URL: \(url)")
                            handleAuthCallback(url: url)
                        }
                } else {
                    RegisterView(isUserLoggedIn: $isUserLoggedIn, isLoginorRegister: $isLoginorRegister)
                        .onOpenURL { url in
                            handleAuthCallback(url: url)
                        }
                }
            }
        }
    }
    
    private func handleAuthCallback(url: URL) {
        guard let token = extractAuthorizationToken(from: url) else {
            print("Failed to retrieve token.")
            return
        }
        
        let isFirstTime = extractIsRegistered(from: url)
        
        print("Authorization token received: \(token)")
        print("isLoginorRegister: \(String(describing: isFirstTime))")
        
        if let registered = isFirstTime, registered == "true" {
            isLoginorRegister = false
        } else {
            isLoginorRegister = true
        }
        
        if !token.isEmpty {
            KeychainHelper.saveToken(token)
            isUserLoggedIn = true
        }
    }
    
    private func extractAuthorizationToken(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "token" })?.value
    }
    
    private func extractIsRegistered(from url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { $0.name == "registred" })?.value
    }
}
