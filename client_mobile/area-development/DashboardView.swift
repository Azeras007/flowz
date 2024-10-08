import SwiftUI

struct DashboardView: View {
    @Binding var isUserLoggedIn: Bool
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @State private var recommendedApps: [String] = []

    var body: some View {
        ZStack {
            VStack {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.primary)
                    .padding(.top, 20)

                Spacer().frame(height: 20)

                VStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color(hue: 20 / 360, saturation: 5.9 / 100, brightness: 90 / 100), lineWidth: 2)
                        .background(Color.clear)
                        .shadow(radius: 2)
                        .frame(height: 200)
                        .overlay(
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Activité récentes :")
                                    .font(.headline)
                                    .foregroundColor(Color.primary)
                                    .padding(.top, 30)
                                    .padding(.leading, 30)

                                Spacer()

                                HStack {
                                    Spacer()
                                    Button(action: {
                                    }) {
                                        Image(systemName: "arrow.forward.square.fill")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .foregroundColor(Color.yellow)
                                    }
                                    .padding(.trailing, 20)
                                    .padding(.bottom, 20)
                                }
                            },
                            alignment: .topLeading
                        )
                        .padding(.top, 10)

                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color(hue: 20 / 360, saturation: 5.9 / 100, brightness: 90 / 100), lineWidth: 1)
                        .background(Color.clear)
                        .shadow(radius: 2)
                        .frame(height: 200)
                        .overlay(
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Notifications :")
                                    .font(.headline)
                                    .foregroundColor(Color.primary)
                                    .padding(.top, 30)
                                    .padding(.leading, 30)
                                Spacer()
                            },
                            alignment: .topLeading
                        )
                        .padding(.top, 10)
                }
                .padding()

                Spacer()
            }
            .background(Color(UIColor.systemBackground).edgesIgnoringSafeArea(.all))

            VStack {
                Spacer()

                CustomNavBar(selectedTab: $selectedTab, isPresentingCreateView: $isPresentingCreateView)
            }
        }
    }
}
