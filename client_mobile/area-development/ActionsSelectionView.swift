import SwiftUI
import Alamofire

struct ActionsSelectionView: View {
    var serviceId: Int
    var subServiceId: Int
    @State private var actions: [Action] = []
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            Text("Choose an action")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            ScrollView {
                if isLoading {
                    ProgressView("Loading actions...")
                        .padding(.top, 20)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(actions) { action in
                            NavigationLink(destination: ActionFormView(action: action)) {
                                ActionItemView(action: action)
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
            fetchActions(serviceId: serviceId, subServiceId: subServiceId)
        }
    }
    
    func fetchActions(serviceId: Int, subServiceId: Int) {
        let token = KeychainHelper.getToken() ?? ""
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)"
        ]
        
        let url = "https://area-development.tech/api/services/\(serviceId)/sub-services/\(subServiceId)/actions"
        AF.request(url, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response JSON TRIGGER: \(value)")
                if let data = response.data {
                    do {
                        let decodedResponse = try JSONDecoder().decode([Action].self, from: data)
                        DispatchQueue.main.async {
                            self.actions = decodedResponse
                            self.isLoading = false
                        }
                    } catch {
                        print("Error decoding actions: \(error)")
                        self.isLoading = false
                    }
                }
            case .failure(let error):
                print("Failed to fetch actions: \(error)")
                self.isLoading = false
            }
        }
    }
}

struct ActionItemView: View {
    var action: Action
    
    var body: some View {
        VStack {
            if let url = URL(string: action.icon_url) {
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
            
            Text(action.name)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            ForEach(action.metadata.fields, id: \.name) { field in
                VStack(alignment: .leading) {
                    Text("\(field.label): \(field.type)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}

struct Action: Identifiable, Decodable {
    var id: Int
    var sub_service_id: Int
    var name: String
    var type: String
    var icon_url: String
    var metadata: Metadata
    var created_at: String
    var updated_at: String
}

struct Metadata: Decodable {
    var fields: [MetadataField]
}

struct MetadataField: Decodable {
    var name: String
    var type: String
    var label: String
    var required: Bool
}
