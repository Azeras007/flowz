import SwiftUI
import Alamofire

import SwiftUI
import Alamofire

struct AreaListView: View {
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @Binding var navigationPath: NavigationPath
    @State private var areas: [Area] = []
    @State private var isLoading = true
    @State private var username: String = ""
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            VStack {
                Text("Your Areas")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                if isLoading {
                    ProgressView("Loading areas...")
                        .padding(.top, 20)
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 35) {
                            ForEach(areas) { area in
                                Button(action: {
                                    navigationPath.append(AreaLogsView(area: area))
                                }) {
                                    AreaItemView(area: area, username: username)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            .onAppear {
                fetchAreas()
                fetchUserInfo()
            }

            VStack {
                Spacer()
                CustomNavBar(
                    selectedTab: $selectedTab,
                    isPresentingCreateView: $isPresentingCreateView
                )
            }
        }
        .background(
            (colorScheme == .dark
                ? Color(red: 28/255, green: 28/255, blue: 28/255)
                : Color(red: 242/255, green: 242/255, blue: 242/255)
            )
            .edgesIgnoringSafeArea(.all)
        )
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

    func fetchUserInfo() {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let url = "https://area-development.tech/api/user"
        
        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response JSON User: \(value)")
                if let data = response.data {
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let userDict = json["user"] as? [String: Any],
                           let name = userDict["name"] as? String {
                            DispatchQueue.main.async {
                                self.username = name
                            }
                        }
                    } catch {
                        print("Error parsing user info: \(error)")
                    }
                }
            case .failure(let error):
                print("Failed to fetch user info: \(error)")
            }
        }
    }
}

struct AreaItemView: View {
    var area: Area
    var username: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 20) {
                AsyncImage(url: URL(string: area.listener_sub_service_icon)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                } placeholder: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }

                AsyncImage(url: URL(string: area.action_sub_service_icon)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                } placeholder: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.gray)
                }

                Spacer()
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)

            Text(area.name)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 10)

            Text("Created: \(formatDate(area.created_at))")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)

            Text("by \(username)")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.horizontal, 10)

            Text(area.status ? "Connected" : "Let's connect it!")
                .font(.subheadline)
                .foregroundColor(area.status ? .green : .red)
                .fontWeight(.bold)
                .padding(.horizontal, 10)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 250)
        .background(colorScheme == .dark
            ? Color(red: 38/255, green: 38/255, blue: 38/255)
            : Color.white
        )
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }
}
