import SwiftUI
import Alamofire
import WidgetKit

class DashboardViewModel: ObservableObject {
    @Published var areas: [Area] = []
    @Published var connectedServices: [Service] = []
    @Published var disconnectedServices: [Service] = []
    @Published var totalServices: Int = 0
    @Published var isLoading = true
    @Published var userName: String = ""

    var totalAutomations: Int {
        return areas.count
    }

    var activeAutomations: Int {
        return areas.filter { $0.status }.count
    }

    let appGroupID = "group.flowz"

    init() {
        fetchAreas()
        fetchConnectedServices()
        fetchUserName()
    }

    func fetchAreas() {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let url = "https://area-development.tech/api/areas"

        AF.request(url, headers: headers).responseJSON { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success(let value):
                print("Response JSON Areas: \(value)")
                if let data = response.data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(AreaResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.areas = decodedResponse.data
                            self.isLoading = false
                            self.saveAutomationStats()
                        }
                    } catch {
                        print("Error decoding areas: \(error)")
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Failed to fetch areas: \(error)")
                self.isLoading = false
            }
        }
    }

    func saveAutomationStats() {
        let userDefaults = UserDefaults(suiteName: appGroupID)
        userDefaults?.set(totalAutomations, forKey: "totalAutomations")
        userDefaults?.set(activeAutomations, forKey: "activeAutomations")
        userDefaults?.synchronize()

        // Demande au widget de recharger les données
        WidgetCenter.shared.reloadAllTimelines()
    }

    func fetchConnectedServices() {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let url = "https://area-development.tech/api/user"

        AF.request(url, headers: headers).responseJSON { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success(let value):
                print("Response JSON User: \(value)")
                if let data = response.data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let userDict = json["user"] as? [String: Any] {

                            var services: [Service] = []
                            for (key, value) in userDict {
                                if key.hasPrefix("has_") && key.hasSuffix("_token") {
                                    let serviceName = key
                                        .replacingOccurrences(of: "has_", with: "")
                                        .replacingOccurrences(of: "_token", with: "")
                                        .replacingOccurrences(of: "_", with: " ")
                                        .capitalized

                                    if let isConnected = value as? Int {
                                        services.append(Service(name: serviceName, isConnected: isConnected == 1))
                                    } else if let isConnectedStr = value as? String, let isConnected = Int(isConnectedStr) {
                                        services.append(Service(name: serviceName, isConnected: isConnected == 1))
                                    }
                                }
                            }

                            DispatchQueue.main.async {
                                self.connectedServices = services.filter { $0.isConnected }
                                self.disconnectedServices = services.filter { !$0.isConnected }
                                self.totalServices = services.count
                                self.isLoading = false
                            }
                        } else {
                            print("Invalid JSON structure")
                            self.isLoading = false
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Failed to fetch user data: \(error)")
                self.isLoading = false
            }
        }
    }
    func fetchUserName() {
            let token = KeychainHelper.getToken() ?? ""
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token)"
            ]

            let url = "https://area-development.tech/api/user"

            AF.request(url, headers: headers).responseJSON { [weak self] response in
                guard let self = self else { return }

                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let userDict = json["user"] as? [String: Any],
                               let name = userDict["name"] as? String {
                                DispatchQueue.main.async {
                                    self.userName = name
                                }
                            } else {
                                print("Invalid JSON structure")
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                        }
                    }
                case .failure(let error):
                    print("Failed to fetch user data: \(error)")
                }
            }
        }
}
