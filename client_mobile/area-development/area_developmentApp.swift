import SwiftUI
import UserNotifications
import AuthenticationServices
import SafariServices
import Alamofire

@main
struct AreaDevelopmentApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var isUserLoggedIn: Bool = false
    @State private var isLoginorRegister: Bool = false
    @State private var isAppSelection: Bool = true
    @State private var isLoading: Bool = true
    @State private var selectedAreaInstance: Area?
    @State private var navigateToLogs = false
    @State private var showGetStarted: Bool = true

    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    if showGetStarted {
                        GetStartedView(showLoginOrRegister: $isLoginorRegister, showGetStarted: $showGetStarted)
                            .onAppear {
                                checkAuthentication()
                            }
                    } else {
                        if let selectedArea = selectedAreaInstance {
                            NavigationLink(
                                destination: AreaLogsView(area: selectedArea),
                                isActive: $navigateToLogs
                            ) {
                                EmptyView()
                            }
                        }

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
                                    RegisterView(isUserLoggedIn: $isUserLoggedIn, isLoginorRegister: $isLoginorRegister)
                                        .onOpenURL { url in
                                            handleAuthCallback(url: url)
                                        }
                                } else {
                                    LoginView(isUserLoggedIn: $isUserLoggedIn, isLoginorRegister: $isLoginorRegister)
                                        .onOpenURL { url in
                                            handleAuthCallback(url: url)
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                setupNotifications()
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("AreaNotification"))) { notification in
                if let areaId = notification.userInfo?["area_id"] as? Int {
                    print("Notification received for area ID: \(areaId)")
                    fetchAreaById(areaId: areaId) { area in
                        if let area = area {
                            self.selectedAreaInstance = area
                            self.navigateToLogs = true
                        } else {
                            print("Failed to load the area with id \(areaId)")
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
            showGetStarted = false
        } else {
            isUserLoggedIn = false
            showGetStarted = true
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
            showGetStarted = false
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

    private func setupNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permission not granted.")
            }
        }

        UNUserNotificationCenter.current().delegate = appDelegate
    }
    func fetchAreaById(areaId: Int, completion: @escaping (Area?) -> Void) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let url = "https://area-development.tech/api/areas/\(areaId)"
        
        AF.request(url, method: .get, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response JSON Area: \(value)")
                if let data = response.data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(AreaRep.self, from: data)
                        DispatchQueue.main.async {
                            completion(decodedResponse.data)
                        }
                    } catch {
                        print("Error decoding area: \(error)")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            case .failure(let error):
                print("Failed to fetch area: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
