import SwiftUI
import Alamofire
import Foundation

struct AreaLogsView: View, Hashable {
    static func == (lhs: AreaLogsView, rhs: AreaLogsView) -> Bool {
        lhs.area.id == rhs.area.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(area.id)
    }

    @State private var logs: [Log] = []
    @State private var isLoading = true
    @State private var currentPage = 1
    @State private var lastPage = 1
    @State private var nextPageUrl: String? = nil
    @State var area: Area
    
    var body: some View {
        VStack {
            Text("Logs for \(area.name)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            Spacer()
            
            HStack {
                
                Button(action: {
                    area.status.toggle()
                    statusArea(areaId: area.id)
                    fetchAreasID()
                }) {
                    Text(area.status ? "🟢" : "🔴")
                        .font(.largeTitle)
                        .foregroundColor(area.status ? .green : .red)
                }
            
            
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
        Spacer()
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
            fetchAreasID()
            fetchLogs(areaId: area.id, page: currentPage)
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
    fetchLogs(areaId: area.id, page: currentPage)
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

func fetchAreasID() {
    let token = KeychainHelper.getToken() ?? ""
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)"
    ]
    
    let url = "https://area-development.tech/api/areas/\(area.id)"
    
    AF.request(url,method: .get, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let value):
            print("Response JSON Areas: \(value)")
            if let data = response.data {
                do {
                    let decodedResponse = try JSONDecoder().decode(AreaRep.self, from: data)
                    DispatchQueue.main.async {
                        
                        self.area = decodedResponse.data
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

func statusArea(areaId: Int) {
    let token = KeychainHelper.getToken() ?? ""
    let headers: HTTPHeaders = [
        "Authorization": "Bearer \(token)",
        "Accept": "application/json"
    ]
    let url = "https://area-development.tech/api/areas/\(areaId)/status"
    AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
        switch response.result {
        case .success(let data):
            print("Status changed successfully for area \(areaId): \(data)")
        case .failure(let error):
            print("Failed to activate trigger: \(error)")
            if let data = response.data, let rawString = String(data: data, encoding: .utf8) {
                print("Raw server response: \(rawString)")
            }
        }
    }
}

}

struct LogItemView: View {
    var log: Log
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Status: \(log.status)")
                .fontWeight(.bold)
                .foregroundColor(log.status == "success" ? .green : .red)
            Text("Triggered by: \(log.triggered_by)")
                .font(.system(.body, design: .monospaced))
            Text("Response: \(log.response)")
                .font(.system(.body, design: .monospaced))
            Text("Triggered at: \(formatDate(log.created_at))")
                .font(.system(.subheadline, design: .monospaced))
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
