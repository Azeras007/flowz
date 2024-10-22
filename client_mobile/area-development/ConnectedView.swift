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
    @Binding var isUserLoggedIn: Bool
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @State private var connectedServices: [Service_2] = []
    @State private var disconnectedServices: [Service_2] = []
    @State private var userServicesStatus: [ServiceStatus] = []
    @State private var isLoading = true
    @State private var showSafari: Bool = false
    @State private var authURL: URL?
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            Text("Connected Services")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 10)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(connectedServices, id: \.id) { service in
                                    VStack {
                                        Image(systemName: service.iconUrl) // Placeholder, remplacez-le par l'icône du service
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .padding(.bottom, 10)
                                        
                                        Text(service.name)
                                            .font(.headline)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        
                                        Button(action: {
                                            unlinkService(service)
                                        }) {
                                            Text("Unlink")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 10)
                                                .background(Color.red)
                                                .cornerRadius(10)
                                        }
                                    }
                                    .padding()
                                    .background(Color.green.opacity(0.2))
                                    .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)

                            Text("Disconnected Services")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 20)

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                ForEach(disconnectedServices, id: \.id) { service in
                                    VStack {
                                        Image(systemName: service.iconUrl) // Placeholder, remplacez-le par l'icône du service
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                            .padding(.bottom, 10)
                                        
                                        Text(service.name)
                                            .font(.headline)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.8)
                                        
                                        Button(action: {
                                            linkService(service)
                                        }) {
                                            Text("Connect")
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 10)
                                                .background(Color.blue)
                                                .cornerRadius(10)
                                        }
                                    }
                                    .padding()
                                    .background(Color.red.opacity(0.2))
                                    .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 90)
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
            
            VStack {
                Spacer()
                
                CustomNavBar(selectedTab: $selectedTab, isPresentingCreateView: $isPresentingCreateView)
            }
            .padding(.bottom, 0)
        }
        .background(
            (colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 28/255) : Color(red: 242/255, green: 242/255, blue: 242/255))
                .edgesIgnoringSafeArea(.all)
        )
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
    
    private func unlinkService(_ service: Service_2) {
        let token = KeychainHelper.getToken() ?? ""
        let url = "https://area-development.tech/api/accounts/unlink/\(service.id)"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request(url, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                DispatchQueue.main.async {
                    print(response)
                    if let index = connectedServices.firstIndex(where: { $0.id == service.id }) {
                        var disconnectedService = connectedServices.remove(at: index)
                        disconnectedService.isConnected = false
                        disconnectedServices.append(disconnectedService)
                    }
                }
                print("Successfully unlinked from service: \(service.name)")
                
            case .failure(let error):
                print("Failed to unlink service: \(error)")
            }
        }
    }
}
