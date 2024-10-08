import SwiftUI

struct CustomNavBar: View {
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
                .edgesIgnoringSafeArea(.bottom)

            HStack {
                Button(action: {
                    selectedTab = "grid"
                }) {
                    Image(systemName: "circle.hexagongrid")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedTab == "grid" ? .yellow : .primary)
                }

                Spacer()

                NavBarItem(icon: "bolt", selectedTab: $selectedTab, currentTab: "bolt")

                Spacer()

                // Central button
                Button(action: {
                    isPresentingCreateView.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.yellow)
                        .shadow(radius: 3)
                }
                .offset(y: -20)
                .zIndex(1)

                Spacer()

                NavBarItem(icon: "plus.square.on.square", selectedTab: $selectedTab, currentTab: "plus")

                Spacer()

                Button(action: {
                    selectedTab = "profile"
                }) {
                    Image(systemName: "person")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedTab == "profile" ? .yellow : .primary)
                }
            }
            .padding(.horizontal, 40)
        }
        .frame(height: 60)
        .padding(.bottom, 5)
    }
}

struct NavBarItem: View {
    var icon: String
    @Binding var selectedTab: String
    var currentTab: String

    var body: some View {
        Button(action: {
            selectedTab = currentTab
        }) {
            Image(systemName: icon)
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(selectedTab == currentTab ? Color.yellow : Color.primary)
        }
    }
}
