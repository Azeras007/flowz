import SwiftUI

struct SubServicesTriggerView: View {
    @State private var searchText = ""
    @State private var subServices: [SubService] = []
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isSearchFocused: Bool

    var filteredServices: [SubService] {
        let lowercasedSearchText: String = searchText.lowercased()
        if lowercasedSearchText.isEmpty {
            return subServices
        } else {
            return subServices.filter { (service: SubService) -> Bool in
                let lowercasedServiceName: String = service.name.lowercased()
                return lowercasedServiceName.contains(lowercasedSearchText)
            }
        }
    }

    var body: some View {
        VStack {
            ZStack {
                Text("Choose a Sub-Service")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .frame(maxWidth: .infinity, alignment: .center)

                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrowtriangle.left.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    }
                    .padding(.leading, 20)

                    Spacer()
                }
            }
            .padding(.top, 40)
            .navigationBarHidden(true)

            Spacer().frame(height: 25)

            TextField("Search for a sub-service...", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSearchFocused ? Color.yellow : Color.clear, lineWidth: 2)
                )
                .focused($isSearchFocused)
                .padding(.horizontal, 20)

            ScrollView {
                if isLoading {
                    LoadingView()
                } else if filteredServices.isEmpty {
                    VStack {
                        Text("No results found.")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.top, 100)

                        Text("Try refining your search terms or explore available sub-services.")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                        ForEach(filteredServices) { subService in
                            SubServiceGridItem(subService: subService)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }

            Spacer()
        }
        .background(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            fetchSubServices()
        }
    }

    func fetchSubServices() {
        AppSelectionView.fetchSubServices { fetchedSubServices in
            DispatchQueue.main.async {
                self.subServices = fetchedSubServices
                self.isLoading = false
            }
        }
    }
}

struct SubServiceGridItem: View {
    @Environment(\.colorScheme) var colorScheme
    var subService: SubService

    var body: some View {
        NavigationLink(destination: TriggerSelectionView(subService: subService)) {
            VStack {
                AsyncImage(url: URL(string: subService.icon_url)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                } placeholder: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                }

                Text(subService.name)
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                    .padding(.top, 5)
            }
            .frame(width: 130, height: 130)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
