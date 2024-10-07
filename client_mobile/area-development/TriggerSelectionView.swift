import SwiftUI
import Alamofire

struct TriggerSelectionView: View {
    var serviceId: Int
    var subServiceId: Int
    var actionFormData: FormData
    @State private var triggers: [Trigger] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            Text("Choose a Trigger")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            ScrollView {
                if isLoading {
                    ProgressView("Loading triggers...")
                        .padding(.top, 20)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(triggers) { trigger in
                            NavigationLink(destination: TriggerFormView(trigger: trigger, actionFormData: actionFormData)) {
                                TriggerItemView(trigger: trigger)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            Spacer()
        }
        .background(Color(.systemBlue).edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchTriggers(serviceId: serviceId, subServiceId: subServiceId)
        }
    }
    
    func fetchTriggers(serviceId: Int, subServiceId: Int) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]

        let url = "https://area-development.tech/api/services/\(serviceId)/sub-services/\(subServiceId)/listeners"
        
        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response JSON: \(value)")
                if let data = response.data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([Trigger].self, from: data)
                        DispatchQueue.main.async {
                            self.triggers = decodedResponse
                            self.isLoading = false
                        }
                    } catch {
                        print("Error decoding: \(error)")
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Error fetching triggers: \(error)")
                self.isLoading = false
            }
        }
    }
}

struct TriggerItemView: View {
    var trigger: Trigger
    
    var body: some View {
        VStack {
            if let url = URL(string: trigger.icon_url) {
                AsyncImage(url: url) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            
            Text(trigger.name)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct Trigger: Identifiable, Decodable {
    var id: Int
    var sub_service_id: Int
    var name: String
    var type: String
    var icon_url: String
    var metadata: TriggerMetadata
    var created_at: String
    var updated_at: String
    
    var metadataFields: [TriggerMetadataField] {
        return metadata.fields
    }
}

struct TriggerMetadata: Decodable {
    var fields: [TriggerMetadataField]
}

struct TriggerMetadataField: Decodable {
    var label: String
    var name: String
    var required: Bool
    var type: String
}
