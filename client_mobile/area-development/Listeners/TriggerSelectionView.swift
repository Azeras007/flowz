import SwiftUI
import Alamofire

struct TriggerSelectionView: View {
    @State private var triggers: [Trigger] = []
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    var subService: SubService
    @Binding var isPresentingCreateView: Bool


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
                        ForEach(KeychainHelper.getTriggers()!) { trigger in
                            NavigationLink(destination: TriggerFormView(isPresentingCreateView: $isPresentingCreateView)) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.yellow)
                                    .shadow(radius: 2)
                                    .frame(height: 70)
                                    .overlay(
                                        Text(trigger.name)
                                            .fontWeight(.bold)
                                            .foregroundColor(.black)
                                    )
                            }.onAppear(perform: {
                                KeychainHelper.deleteTrigger()
                                KeychainHelper.saveTrigger(trigger)
                            })
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
                            KeychainHelper.deleteTriggers()
                            KeychainHelper.saveTriggers(decodedResponse)
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
    var trigger: Trigger = KeychainHelper.getTrigger()!

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

