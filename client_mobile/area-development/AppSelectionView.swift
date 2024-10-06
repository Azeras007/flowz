import SwiftUI
import Alamofire

struct AppSelectionView: View {
    @State private var subServices: [SubService] = []
    @State private var selectedApps: [Int: Bool] = [:]
    @Binding var isAppSelection: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            Text("Select your favorite sub-services")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.top, 40)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                ForEach(subServices) { subService in
                    AppIconView(appName: subService.name, iconURL: subService.icon_url, isSelected: selectedApps[subService.id] ?? false)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                toggleSelection(for: subService)
                            }
                        }
                }
                ForEach(0..<2) { _ in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 80, height: 80)
                }
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            HStack {
                Button(action: {
                    
                }) {
                    Text("Skip")
                        .foregroundColor(.white)
                        .underline()
                }
                .padding(.leading, 20)
                
                Spacer()
                
                Button(action: {
                    saveSelectedApps()
                    isAppSelection = true
                }) {
                    Text("Finish setup")
                        .padding()
                        .frame(width: 150)
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.trailing, 20)
            }
            .padding(.bottom, 30)
        }
        .background(Color(.systemGray6).opacity(0.95))
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            fetchSubServices()
            loadSelectedApps()
        }
    }
    
    private func fetchSubServices() {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        // Fetch sub-services using Alamofire
        AF.request("https://area-development.tech/api/sub-services", headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Raw sub-services JSON: \(value)")
                if let data = response.data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(SubServiceResponse.self, from: data)
                        self.subServices = decodedResponse.data
                    } catch {
                        print("Decoding error: \(error)")
                    }
                }
            case .failure(let error):
                print("Error fetching sub-services: \(error)")
            }
        }
    }
    
    private func toggleSelection(for subService: SubService) {
        if selectedApps[subService.id] == true {
            selectedApps[subService.id] = false
            unfavoriteSubService(subService.id)
        } else {
            selectedApps[subService.id] = true
            favoriteSubService(subService.id)
        }
    }

    private func favoriteSubService(_ subServiceId: Int) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request("https://area-development.tech/api/sub-services/\(subServiceId)/favorite", method: .post, headers: headers).response { response in
            switch response.result {
            case .success:
                print("Sub-service marked as favorite: \(subServiceId)")
            case .failure(let error):
                print("Error marking sub-service as favorite: \(error)")
            }
        }
    }
    
    private func unfavoriteSubService(_ subServiceId: Int) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        AF.request("https://area-development.tech/api/sub-services/\(subServiceId)/unfavorite", method: .delete, headers: headers).response { response in
            switch response.result {
            case .success:
                print("Sub-service unfavorited: \(subServiceId)")
            case .failure(let error):
                print("Error unfavoriting sub-service: \(error)")
            }
        }
    }
    
    private func saveSelectedApps() {
        let selectedAppIds = selectedApps.filter { $0.value }.map { $0.key }
        UserDefaults.standard.set(selectedAppIds, forKey: "selectedApps")
        print("Selected apps saved: \(selectedAppIds)")
    }
    
    private func loadSelectedApps() {
        if let savedApps = UserDefaults.standard.array(forKey: "selectedApps") as? [Int] {
            for appId in savedApps {
                selectedApps[appId] = true
            }
        }
    }
}

struct AppIconView: View {
    var appName: String
    var iconURL: String
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.gray.opacity(0.3))
                .frame(width: isSelected ? 90 : 80, height: isSelected ? 90 : 80) // Enlarge if selected
            
            AsyncImage(url: URL(string: iconURL)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(8)
            } placeholder: {
                ZStack {
                    Color.gray.opacity(0.3)
                    Image(systemName: "photo")
                        .foregroundColor(.white)
                }
                .frame(width: 50, height: 50)
            }
        }
        .animation(.easeInOut(duration: 0.2)) // Animation for enlargement effect
    }
}

struct SubServiceResponse: Decodable {
    let data: [SubService]
}

struct SubService: Identifiable, Decodable {
    var id: Int
    var name: String
    var icon_url: String
}
