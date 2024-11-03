import SwiftUI

struct StatisticsView: View {
    var totalAutomations: Int
    var activeAutomations: Int
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
        VStack {
            header
            statisticsContent
        }
    }

    private var header: some View {
        HStack {
            iconCircle(imageName: "chart.bar.horizontal.page")
                .padding(.leading, 20)
                .padding(.top, 20)

            Text("My Statistics")
                .font(.title2)
                .foregroundColor(Color.primary)
                .padding(.leading, 10)
                .padding(.top, 20)

            Spacer()
        }
    }

    private var statisticsContent: some View {
        VStack {
            HStack {
                Text("Total: \(totalAutomations) | Active: \(activeAutomations)")
                    .font(.subheadline)
                    .foregroundColor(Color.secondary)
                    .padding(.leading, 20)

                Spacer()

                Text("\(percentage)%")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.primary)
                    .padding(.trailing, 20)
            }
            .padding(.top, 25)

            progressBar
        }
    }

    private var progressBar: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(progressBarBackground)
                .frame(height: 20)

            RoundedRectangle(cornerRadius: 12)
                .fill(Color.yellow)
                .frame(width: progressBarWidth, height: 20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 5)
    }

    private var progressBarBackground: Color {
        colorScheme == .dark
            ? Color(red: 100 / 255, green: 100 / 255, blue: 100 / 255)
            : Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
    }

    private var progressBarWidth: CGFloat {
        let width = UIScreen.main.bounds.width * 0.8
        let ratio = totalAutomations > 0 ? CGFloat(activeAutomations) / CGFloat(totalAutomations) : 0
        return width * ratio
    }

    private var percentage: Int {
        totalAutomations > 0 ? Int((Double(activeAutomations) / Double(totalAutomations)) * 100) : 0
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
