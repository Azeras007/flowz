import SwiftUI
import AuthenticationServices
import Alamofire
import SafariServices

struct Service_2 {
    let id: Int
    let name: String
    let iconUrl: String
    var isConnected: Bool
}

struct ServiceStatus {
    let name: String
    var isConnected: Bool
}

struct ConnectedView: View {
    @State private var connectedServices: [Service_2] = []
    @State private var disconnectedServices: [Service_2] = []
    @State private var userServicesStatus: [ServiceStatus] = []
    @State private var isLoading = true
    @State private var showSafari: Bool = false
    @State private var authURL: URL?
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else {
                Text("Connected Services")
                ForEach(connectedServices, id: \.id) { service in
                    Button(action: {
                        linkService(service)
                    }) {
                        HStack {
                            Text(service.name)
                            Spacer()
                            Text("Connected")
                        }
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                }
                
                Text("Disconnected Services")
                ForEach(disconnectedServices, id: \.id) { service in
                    Button(action: {
                        linkService(service)
                    }) {
                        HStack {
                            Text(service.name)
                            Spacer()
                            Text("Connect")
                        }
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                    }
                }
            }
        }
        .onAppear {
            fetchUserConnectionTokens()
        }
        .sheet(isPresented: $showSafari, onDismiss: {
            authURL = nil
            showSafari = false
        }) {
            if let url = authURL {
                SafariView(url: url)
                    .onAppear {
                        print("Opening Safari with URL: \(url)")
                    }
            }
        }
    }

    private func fetchUserConnectionTokens() {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let url = "https://area-development.tech/api/user"
        
        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let data = response.data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let userDict = json["user"] as? [String: Any] {
                            
                            var services: [ServiceStatus] = []
                            for (key, value) in userDict {
                                if key.hasPrefix("has_") && key.hasSuffix("_token") {
                                    let serviceName = key
                                        .replacingOccurrences(of: "has_", with: "")
                                        .replacingOccurrences(of: "_token", with: "")
                                        .replacingOccurrences(of: "_", with: " ")
                                        .capitalized
                                    
                                    let isConnected = (value as? Int == 1) || (Int(value as? String ?? "") == 1)
                                    services.append(ServiceStatus(name: serviceName, isConnected: isConnected))
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.userServicesStatus = services
                                self.fetchAvailableServices()
                            }
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
    
    private func fetchAvailableServices() {
        let url = "https://area-development.tech/api/services"
        
        AF.request(url).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let data = response.data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let servicesData = json["data"] as? [[String: Any]] {
                            
                            var availableServices: [Service_2] = []
                            
                            for service in servicesData {
                                if let canAuth = service["can_auth"] as? Int, canAuth == 1,
                                   let serviceName = service["name"] as? String,
                                   let serviceId = service["id"] as? Int,
                                   let iconUrl = service["icon_url"] as? String {
                                    
                                    let isConnected = userServicesStatus.first { $0.name == serviceName }?.isConnected ?? false
                                    
                                    availableServices.append(Service_2(id: serviceId, name: serviceName, iconUrl: iconUrl, isConnected: isConnected))
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.connectedServices = availableServices.filter { $0.isConnected }
                                self.disconnectedServices = availableServices.filter { !$0.isConnected }
                                self.isLoading = false
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Failed to fetch services: \(error)")
                self.isLoading = false
            }
        }
    }
    
    private func linkService(_ service: Service_2) {
        let token = KeychainHelper.getToken() ?? ""
        authURL = URL(string: "https://area-development.tech/api/accounts/link/\(service.id)?redirect_url=areadevelopment://auth&token=\(token)")
        if authURL != nil {
            showSafari.toggle()
        }
    }
    
}

