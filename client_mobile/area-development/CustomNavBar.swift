import SwiftUI

struct WavyShape: Shape {
    var waveHeight: CGFloat = 110
    var waveWidthOffset: CGFloat = 55
    var controlPointFactor: CGFloat = 0.9

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 20))
        path.addQuadCurve(
            to: CGPoint(x: 20, y: 0),
            control: CGPoint(x: 0, y: 0)
        )

        path.addLine(to: CGPoint(x: rect.width / 2 - waveWidthOffset, y: 0))

        path.addQuadCurve(
            to: CGPoint(x: rect.width / 2 + waveWidthOffset, y: 0),
            control: CGPoint(x: rect.width / 2, y: waveHeight * controlPointFactor)
        )

        path.addLine(to: CGPoint(x: rect.width - 20, y: 0))

        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: 20),
            control: CGPoint(x: rect.width, y: 0)
        )

        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        path.closeSubpath()

        return path
    }
}

struct CustomNavBar: View {
    @Binding var selectedTab: String
    @Binding var isPresentingCreateView: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack(alignment: .bottom) {
            WavyShape(waveHeight: 110, waveWidthOffset: 55, controlPointFactor: 0.9)
                .fill(colorScheme == .dark ? Color(red: 28/255, green: 28/255, blue: 28/255) : Color(UIColor.systemBackground))
                .overlay(
                    WavyShape(waveHeight: 110, waveWidthOffset: 55, controlPointFactor: 0.9)
                        .stroke(Color.white, lineWidth: 1)
                        .opacity(colorScheme == .dark ? 1 : 0)
                )
                .edgesIgnoringSafeArea(.bottom)

            HStack {
                Button(action: {
                    selectedTab = "grid"
                }) {
                    Image(systemName: "circle.hexagongrid")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedTab == "grid" ? .yellow : Color(red: 133/255, green: 135/255, blue: 145/255))
                }

                Spacer()

                Button(action: {
                    selectedTab = "bolt"
                }) {
                    Image(systemName: "bolt")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedTab == "bolt" ? .yellow : Color(red: 133/255, green: 135/255, blue: 145/255))
                }

                Spacer()

                Button(action: {
                    isPresentingCreateView.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.yellow)
                }
                .offset(y: -35)
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
                        .foregroundColor(selectedTab == "profile" ? .yellow : Color(red: 133/255, green: 135/255, blue: 145/255))
                }
            }
            .padding(.horizontal, 40)
        }
        .frame(height: 80)
        .padding(.bottom, 0)
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
                .foregroundColor(selectedTab == currentTab ? .yellow : Color(red: 133/255, green: 135/255, blue: 145/255))
        }
    }
}
