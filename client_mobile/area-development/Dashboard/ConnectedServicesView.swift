import SwiftUI

struct ConnectedServicesView: View {
    var connectedServicesCount: Int
    var disconnectedServicesCount: Int
    var totalServices: Int
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(backgroundColor)
            .overlay(borderOverlay)
            .shadow(radius: 1)
            .frame(height: 200)
            .overlay(contentOverlay, alignment: .topLeading)
            .padding(.top, 10)
    }

    private var backgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 28 / 255, green: 28 / 255, blue: 28 / 255)
            : Color.white
    }

    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 12)
            .stroke(Color.white, lineWidth: 1)
            .opacity(colorScheme == .dark ? 1 : 0)
    }

    private var contentOverlay: some View {
        HStack {
            VStack(alignment: .leading) {
                header
                serviceStatistics
            }
            .padding(.leading, 20)
            Spacer()
            pieChart
                .padding(.trailing, 20)
        }
    }

    private var header: some View {
        HStack {
            iconCircle(imageName: "link")
                .padding(.top, 20)

            Text("Available Services")
                .font(.title2)
                .foregroundColor(Color.primary)
                .padding(.leading, 10)
                .padding(.top, 20)

            Spacer()
        }
    }

    private var serviceStatistics: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Connectés : \(connectedServicesCount)")
                .font(.subheadline)
                .foregroundColor(Color.secondary)

            Text("Non connectés : \(disconnectedServicesCount)")
                .font(.subheadline)
                .foregroundColor(Color.secondary)
        }
        .padding(.top, 10)
    }

    private var pieChart: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .foregroundColor(progressBarBackground)

                Circle()
                    .trim(from: 0.0, to: chartRatio)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.yellow)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.easeInOut(duration: 1.0), value: chartRatio)

                Text("\(percentage)%")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.primary)
            }
            .frame(width: 100, height: 100)
            .padding(.top, 10)
        }
    }

    private var chartRatio: CGFloat {
        totalServices > 0 ? CGFloat(connectedServicesCount) / CGFloat(totalServices) : 0
    }

    private var percentage: Int {
        totalServices > 0 ? Int((Double(connectedServicesCount) / Double(totalServices)) * 100) : 0
    }

    private var progressBarBackground: Color {
        colorScheme == .dark
            ? Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255)
            : Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
    }

    private func iconCircle(imageName: String) -> some View {
        ZStack {
            Circle()
                .fill(circleBackgroundColor)
                .frame(width: 40, height: 40)

            Image(systemName: imageName)
                .foregroundColor(circleForegroundColor)
                .font(.system(size: 20))
        }
    }

    private var circleBackgroundColor: Color {
        colorScheme == .dark
            ? Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255)
            : Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
    }

    private var circleForegroundColor: Color {
        colorScheme == .dark
            ? Color.white
            : Color.black
    }
}
