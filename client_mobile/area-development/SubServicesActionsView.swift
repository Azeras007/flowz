import SwiftUI

struct SubServicesActionsView: View {
    @State private var searchText = ""
    @State private var services: [SubService] = []
    @State private var isLoading = true

    var filteredServices: [SubService] {
        if searchText.isEmpty {
            return services
        } else {
            return services.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
            VStack {
                Text("Choose a service")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                TextField("search bar", text: $searchText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                ScrollView {
                    if isLoading {
                        ProgressView("Loading sub-services...")
                            .padding(.top, 20)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(filteredServices) { service in
                                NavigationLink(destination: ActionsSelectionView(serviceId: service.service_id, subServiceId: service.id)) {
                                    ServiceItemView(serviceName: service.name)
                                }
                                .buttonStyle(PlainButtonStyle())
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
                AppSelectionView.fetchSubServices { fetchedSubServices in
                    self.services = fetchedSubServices
                    self.isLoading = false
                }
            }
    }
}

struct ServiceItemView: View {
    var serviceName: String

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(height: 100)
                .overlay(
                    Text(serviceName)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                )
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
