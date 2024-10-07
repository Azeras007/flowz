import SwiftUI

struct SubServicesTriggerView: View {
    var actionFormData: FormData
    @State private var searchText = ""
    @State private var subServices: [SubService] = []
    @State private var isLoading = true

    
    var filteredServices: [SubService] {
        if searchText.isEmpty {
            return subServices
        } else {
            return subServices.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            Text("Choose a Sub-Service")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            ScrollView {
                if isLoading {
                    ProgressView("Loading sub-services...")
                        .padding(.top, 20)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredServices) { subService in
                            NavigationLink(destination: TriggerSelectionView(serviceId: subService.service_id, subServiceId: subService.id, actionFormData: actionFormData)) {
                                ServiceItemView(serviceName: subService.name)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            
            Spacer()
        }
        .onAppear {
            AppSelectionView.fetchSubServices { fetchedSubServices in
                self.subServices = fetchedSubServices
                self.isLoading = false
            }
        }
    }
}
