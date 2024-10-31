import SwiftUI
import Alamofire

struct Service: Identifiable {
    var id = UUID()
    var name: String
    var isConnected: Bool
}

struct DashboardView: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @State private var areas: [Area] = []
    @State private var connectedServices: [Service] = []
    @State private var disconnectedServices: [Service] = []
    @State private var totalServices: Int = 0
    @State private var isLoading = true
    @Environment(\.colorScheme) var colorScheme 

    var totalAutomations: Int {
        return areas.count
    }

    var activeAutomations: Int {
        return areas.filter { $0.status }.count
    }

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.primary)
                        .padding(.top, 20)

                    Spacer().frame(height: 20)

                    VStack(alignment: .leading) {
                        StatisticsView(totalAutomations: totalAutomations, activeAutomations: activeAutomations)

                        ConnectedServicesView(
                            connectedServicesCount: connectedServices.count,
                            disconnectedServicesCount: disconnectedServices.count,
                            totalServices: totalServices
                        )
                    }
                    .padding()

                    Spacer()
                }
                .background(
                    backgroundColor.edgesIgnoringSafeArea(.all)
                )

                VStack {
                    Spacer()

                    CustomNavBar(selectedTab: $selectedTab, isPresentingCreateView: $isPresentingCreateView)
                }
            }
            .onAppear {
                fetchAreas()
                fetchConnectedServices()
            }
            .sheet(isPresented: $isPresentingCreateView) {
                CreateView(isPresentingCreateView: $isPresentingCreateView)
            }
        }
    }

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 28 / 255, green: 28 / 255, blue: 28 / 255)
            : Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
    }

    func fetchAreas() {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let url = "https://area-development.tech/api/areas"

        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response JSON Areas: \(value)")
                if let data = response.data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(AreaResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.areas = decodedResponse.data
                            self.isLoading = false
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

    func fetchConnectedServices() {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let url = "https://area-development.tech/api/user"

        AF.request(url, headers: headers).responseJSON { response in
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
}
