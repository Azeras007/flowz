import SwiftUI
import AuthenticationServices
import SafariServices

@main
struct AreaDevelopmentApp: App {
    @State private var isUserLoggedIn: Bool = false
    @State private var isLoginorRegister: Bool = false
    @State private var isAppSelection: Bool = true
    @State private var isLoading: Bool = true

    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            checkAuthentication()
                        }
                    }
            } else {
                if isUserLoggedIn {
                    if isAppSelection {
                        AppSelectionView(isAppSelection: $isAppSelection)
                    } else {
                        MainView(isUserLoggedIn: $isUserLoggedIn)
                    }
                } else {
                    if isLoginorRegister {
                        LoginView(isUserLoggedIn: $isUserLoggedIn, isLoginorRegister: $isLoginorRegister)
                            .onOpenURL { url in
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
    }

    private func checkAuthentication() {
        if let token = KeychainHelper.getToken(), !token.isEmpty {
            isUserLoggedIn = true
            isAppSelection = !hasCompletedAppSelection()
        } else {
            isUserLoggedIn = false
        }
        isLoading = false
    }

    private func hasCompletedAppSelection() -> Bool {
        return UserDefaults.standard.bool(forKey: "hasCompletedAppSelection")
    }

    private func handleAuthCallback(url: URL) {
        guard let token = extractAuthorizationToken(from: url) else {
            print("Failed to retrieve token.")
            return
        }

        let isFirstTime = extractIsRegistered(from: url)

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
