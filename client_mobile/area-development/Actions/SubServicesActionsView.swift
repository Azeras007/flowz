import SwiftUI

struct SubServicesActionsView: View {
    @State private var searchText = ""
    @State private var services: [SubService] = []
    @State private var isLoading = true
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var isSearchFocused: Bool
    @Binding var isPresentingCreateView: Bool

    var filteredServices: [SubService] {
        let lowercasedSearchText = searchText.lowercased()
        if lowercasedSearchText.isEmpty {
            return services
        } else {
            return services.filter { service in
                let lowercasedServiceName = service.name.lowercased()
                return lowercasedServiceName.contains(lowercasedSearchText)
            }
        }
    }

    var body: some View {
        VStack {
            ZStack {
                Text("Choose a service")
                    .font(.largeTitle)
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

            TextField("Search for a service...", text: $searchText)
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

                        Text("Try refining your search terms or explore available services.")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                            .padding(.top, 10)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible())], spacing: 20) {
                        ForEach(filteredServices) { service in
                            NavigationLink(destination: ActionsSelectionView(subService: service, isPresentingCreateView: $isPresentingCreateView)) {
                                VStack {
                                    AsyncImage(url: URL(string: service.icon_url)) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        Image(systemName: "questionmark.circle")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                    }

                                    Text(service.name)
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
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }

            Spacer()
        }
        .background(colorScheme == .dark ? Color.black.edgesIgnoringSafeArea(.all) : Color.white.edgesIgnoringSafeArea(.all))
        .onAppear {
            AppSelectionView.fetchSubServices { fetchedSubServices in
                self.services = fetchedSubServices
                self.isLoading = false
            }
        }
    }
}

