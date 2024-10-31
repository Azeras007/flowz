import SwiftUI

struct MainView: View {
    @Binding var isUserLoggedIn: Bool
    @State private var selectedTab: String = "grid"
    @State private var isPresentingCreateView: Bool = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                if selectedTab == "grid" {
                    DashboardView(
                        isUserLoggedIn: $isUserLoggedIn,
                        selectedTab: $selectedTab,
                        isPresentingCreateView: $isPresentingCreateView
                    )
                } else if selectedTab == "bolt" {
                    AreaListView(
                        selectedTab: $selectedTab,
                        isPresentingCreateView: $isPresentingCreateView,
                        navigationPath: $navigationPath
                    )
                } else if selectedTab == "profile" {
                    ProfileView(
                        isUserLoggedIn: $isUserLoggedIn,
                        selectedTab: $selectedTab,
                        isPresentingCreateView: $isPresentingCreateView
                    )
                } else {
                    ConnectedView(
                        isUserLoggedIn: $isUserLoggedIn,
                        selectedTab: $selectedTab,
                        isPresentingCreateView: $isPresentingCreateView
                    )
                }
            }
            .navigationDestination(for: AreaLogsView.self) { areaLogsView in
                areaLogsView
            }
            .fullScreenCover(isPresented: $isPresentingCreateView) {
                CreateView(isPresentingCreateView: $isPresentingCreateView)
            }
        }
    }
}
