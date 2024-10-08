import SwiftUI
import Alamofire

struct AreaListView: View {
    @State private var areas: [Area] = []
    @State private var isLoading = true

    var body: some View {
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
                    LazyVStack(spacing: 20) {
                        ForEach(areas) { area in
                            HStack {
                                NavigationLink(destination: AreaLogsView(areaId: area.id)) {
                                    AreaItemView(area: area)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    activateTrigger(areaId: area.id)
                                }) {
                                    Text("⚡")
                                        .font(.largeTitle)
                                        .foregroundColor(.yellow)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                Button(action: {
                                    deleteArea(areaId: area.id)
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            
            Spacer()
        }
        .onAppear {
            fetchAreas()
        }
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
    
    func deleteArea(areaId: Int) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        let url = "https://area-development.tech/api/areas/\(areaId)/delete"

        AF.request(url, method: .post, headers: headers).responseJSON { response in
            switch response.result {
            case .success:
                print("Area deleted successfully")
                DispatchQueue.main.async {
                    self.areas.removeAll { $0.id == areaId }
                }
            case .failure(let error):
                print("Failed to delete area: \(error)")
                if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                    print("Raw server response: \(rawString)")
                }
            }
        }
    }

    func activateTrigger(areaId: Int) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        let url = "https://area-development.tech/api/areas/\(areaId)/trigger"
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("Trigger activated successfully for area \(areaId): \(data)")
            case .failure(let error):
                print("Failed to activate trigger: \(error)")
                if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                    print("Raw server response: \(rawString)")
                }
            }
        }
    }
}

struct AreaItemView: View {
    var area: Area
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(area.name)
                .font(.headline)
                .fontWeight(.bold)
            Text("Created: \(area.created_at)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct AreaResponse: Decodable {
    var data: [Area]
    var meta: Meta
    var links: Links
}

struct Area: Identifiable, Decodable {
    var id: Int
    var name: String
    var listener_id: Int
    var action_id: Int
    var status: Bool
    var created_at: String
}

struct Meta: Decodable {
    var current_page: Int
    var from: Int?
    var last_page: Int
    var per_page: Int
    var to: Int
    var total: Int
}

struct Links: Decodable {
    var first: String
    var last: String
    var next: String?
    var prev: String?
}

struct LogResponse: Decodable {
    var current_page: Int
    var data: [Log]
    var first_page_url: String
    var from: Int?
    var last_page: Int
    var last_page_url: String
    var next_page_url: String?
    var path: String
    var per_page: Int
    var prev_page_url: String?
    var to: Int?
    var total: Int
}

struct Log: Identifiable, Decodable {
    var id: Int
    var area_id: Int
    var status: String
    var triggered_by: String
    var response: String
    var created_at: String
}
