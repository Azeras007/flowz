import SwiftUI

struct MainView: View {
    @Binding var isUserLoggedIn: Bool
    @State private var selectedTab: String = "grid"
    @State private var isPresentingCreateView: Bool = false

    var body: some View {
        ZStack {
            if selectedTab == "grid" {
                DashboardView(
                    isUserLoggedIn: $isUserLoggedIn,
                    selectedTab: $selectedTab,
                    isPresentingCreateView: $isPresentingCreateView
                )
            } else if selectedTab == "profile" {
                ProfileView(
                    isUserLoggedIn: $isUserLoggedIn,
                    selectedTab: $selectedTab,
                    isPresentingCreateView: $isPresentingCreateView
                )
            } else {
                DashboardView(
                    isUserLoggedIn: $isUserLoggedIn,
                    selectedTab: $selectedTab,
                    isPresentingCreateView: $isPresentingCreateView
                )
            }
        }
        .fullScreenCover(isPresented: $isPresentingCreateView) {
            CreateView()
        }
    }
}
