import SwiftUI
import Alamofire

struct ActionsSelectionView: View {
    var subService: SubService
    @State private var actions: [Action] = []
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
                        Text("Choose an action")
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
                        ForEach(actions) { action in
                            NavigationLink(destination: ActionFormView(action: action)) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.yellow)
                                    .shadow(radius: 2)
                                    .frame(height: 70)
                                    .overlay(
                                        Text(action.name)
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
            fetchActions(serviceId: subService.service_id, subServiceId: subService.id)
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
