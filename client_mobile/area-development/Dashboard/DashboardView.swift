import SwiftUI
import Foundation

struct Service: Identifiable {
    var id = UUID()
    var name: String
    var isConnected: Bool
}

struct DashboardView: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @StateObject private var viewModel = DashboardViewModel()
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text(viewModel.userName.isEmpty ? "Hello" : "Hello,\n\(viewModel.userName)")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(Color.primary)
                        .padding(.top, 50)

                    Spacer().frame(height: 20)

                    VStack(alignment: .leading) {
                        StatisticsView(
                            totalAutomations: viewModel.totalAutomations,
                            activeAutomations: viewModel.activeAutomations
                        )

                        ConnectedServicesView(
                            connectedServicesCount: viewModel.connectedServices.count,
                            disconnectedServicesCount: viewModel.disconnectedServices.count,
                            totalServices: viewModel.totalServices
                        )
                    }
                    .padding()

                    Spacer()
                }
                .background(
                    backgroundColor.edgesIgnoringSafeArea(.all)
                )

                VStack {
                    Spacer()

                    CustomNavBar(
                        selectedTab: $selectedTab,
                        isPresentingCreateView: $isPresentingCreateView
                    )
                }
            }
            .sheet(isPresented: $isPresentingCreateView) {
                CreateView(isPresentingCreateView: $isPresentingCreateView)
            }
        }
    }

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 28 / 255, green: 28 / 255, blue: 28 / 255)
            : Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
    }
}
