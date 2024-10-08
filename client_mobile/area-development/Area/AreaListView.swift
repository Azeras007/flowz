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
                                NavigationLink(destination: AreaLogsView(area: area)) {
                                    AreaItemView(area: area)
                                }
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
}

struct AreaItemView: View {
    var area: Area
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(area.name)
                .font(.headline)
                .fontWeight(.bold)
            Text("Created: \(formatDate(area.created_at))")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color.white)
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
