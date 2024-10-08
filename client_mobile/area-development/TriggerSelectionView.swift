import SwiftUI
import Alamofire

struct TriggerSelectionView: View {
    var subService: SubService
    var actionFormData: FormData
    var action: Action
    @State private var triggers: [Trigger] = []
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 0, y: 12)
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity, minHeight: 380)

                VStack {
                    ZStack {
                        Text("Choose a Trigger")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                            .frame(maxWidth: .infinity, alignment: .center)

                        HStack {
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Image(systemName: "arrowtriangle.left.fill")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.primary)
                            }
                            .padding(.leading, 20)

                            Spacer()
                        }
                    }
                    .padding(.top, 40)
                    .navigationBarHidden(true)

                    if let url = URL(string: subService.icon_url) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                        .padding(.top, 20)
                    }

                    Text(subService.description)
                        .font(.body)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        .multilineTextAlignment(.center)
                }
            }

            Spacer().frame(height: 25)

            ScrollView {
                if isLoading {
                    LoadingView()
                } else {
                    LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
                        ForEach(triggers) { trigger in
                            NavigationLink(destination: TriggerFormView(trigger: trigger, actionFormData: actionFormData, action: action)) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.yellow)
                                    .shadow(radius: 2)
                                    .frame(height: 70)
                                    .overlay(
                                        Text(trigger.name)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 35)
                }
            }

            Spacer()
        }
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchTriggers(serviceId: subService.service_id, subServiceId: subService.id)
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
    var metadata: TriggerMetadata?
    var created_at: String
    var updated_at: String

    var metadataFields: [TriggerMetadataField] {
        return metadata?.fields ?? []
    }

    enum CodingKeys: String, CodingKey {
        case id
        case sub_service_id
        case name
        case type
        case icon_url
        case metadata
        case created_at
        case updated_at
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        sub_service_id = try container.decode(Int.self, forKey: .sub_service_id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        icon_url = try container.decode(String.self, forKey: .icon_url)
        created_at = try container.decode(String.self, forKey: .created_at)
        updated_at = try container.decode(String.self, forKey: .updated_at)

        if let metadataDict = try? container.decode(TriggerMetadata.self, forKey: .metadata) {
            metadata = metadataDict
        } else if let _ = try? container.decode([TriggerMetadataField].self, forKey: .metadata) {
            metadata = nil
        } else {
            metadata = nil
        }
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

