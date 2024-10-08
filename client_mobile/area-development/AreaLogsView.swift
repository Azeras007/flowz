import SwiftUI
import Alamofire

struct AreaLogsView: View {
    var areaId: Int
    @State private var logs: [Log] = []
    @State private var isLoading = true
    @State private var currentPage = 1
    @State private var lastPage = 1
    @State private var nextPageUrl: String? = nil

    var body: some View {
        VStack {
            Text("Logs for Area \(areaId)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            if isLoading && logs.isEmpty {
                ProgressView("Loading logs...")
                    .padding(.top, 20)
            } else {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(logs) { log in
                            LogItemView(log: log)
                        }

                        if isLoading {
                            ProgressView("Loading more logs...")
                                .padding(.vertical, 20)
                        } else if currentPage < lastPage {
                            Button(action: {
                                loadMoreLogs()
                            }) {
                                Text("Load more logs")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
            Spacer()
        }
        .onAppear {
            fetchLogs(areaId: areaId, page: currentPage)
        }
    }

    func fetchLogs(areaId: Int, page: Int) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let url = "https://area-development.tech/api/areas/\(areaId)/logs?page=\(page)"
        
        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response JSON Logs: \(value)")
                if let data = response.data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(LogResponse.self, from: data)
                        DispatchQueue.main.async {
                            self.logs.append(contentsOf: decodedResponse.data)
                            self.currentPage = decodedResponse.current_page
                            self.lastPage = decodedResponse.last_page
                            self.nextPageUrl = decodedResponse.next_page_url
                            self.isLoading = false
                        }
                    } catch {
                        print("Error decoding logs: \(error)")
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Failed to fetch logs: \(error)")
                self.isLoading = false
            }
        }
    }

    func loadMoreLogs() {
        guard let nextPageUrl = nextPageUrl else { return }
        isLoading = true
        currentPage += 1
        fetchLogs(areaId: areaId, page: currentPage)
    }
}

struct LogItemView: View {
    var log: Log
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Status: \(log.status)")
                .fontWeight(.bold)
            Text("Triggered by: \(log.triggered_by)")
            Text("Response: \(log.response)")
            Text("Created at: \(log.created_at)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
