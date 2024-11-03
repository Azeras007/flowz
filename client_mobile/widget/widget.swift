import WidgetKit
import SwiftUI

let appGroupID = "group.flowz"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), totalAutomations: 0, activeAutomations: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let stats = loadAutomationStats()
        let entry = SimpleEntry(date: Date(), totalAutomations: stats.total, activeAutomations: stats.active)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let stats = loadAutomationStats()
        let entry = SimpleEntry(date: Date(), totalAutomations: stats.total, activeAutomations: stats.active)
        let timeline = Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(300)))
        completion(timeline)
    }

    func loadAutomationStats() -> (total: Int, active: Int) {
        let userDefaults = UserDefaults(suiteName: appGroupID)
        let totalAutomations = userDefaults?.integer(forKey: "totalAutomations") ?? 0
        let activeAutomations = userDefaults?.integer(forKey: "activeAutomations") ?? 0
        return (totalAutomations, activeAutomations)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let totalAutomations: Int
    let activeAutomations: Int
}

struct widgetEntryView: View {
    var entry: Provider.Entry
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            if entry.totalAutomations == 0 {
                VStack {
                    Text("Create your first AREA")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding()
                    Link(destination: URL(string: "area-development://createView")!) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                    }
                }
                .padding()
            } else {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Automations")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(entry.totalAutomations)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(numberColor)

                        Text("Active Automations")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(entry.activeAutomations)")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(numberColor)
                    }
                    Spacer()

                    Link(destination: URL(string: "area-development://createView")!) {
                        Image(imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 90, height: 90)
                    }
                }
                .padding()
            }
        }
        .containerBackground(backgroundColor, for: .widget)
    }

    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 34 / 255, green: 34 / 255, blue: 34 / 255) : Color.white
    }

    private var numberColor: Color {
        colorScheme == .dark ? Color.white : Color.primary
    }

    private var imageName: String {
        colorScheme == .dark ? "logoDark" : "logo"
    }
}

struct widget: Widget {
    let kind: String = "widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Automations Widget")
        .description("Shows your automation stats and allows quick creation.")
        .supportedFamilies([.systemMedium])
    }
}

struct widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            widgetEntryView(entry: SimpleEntry(date: Date(), totalAutomations: 5, activeAutomations: 3))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, .light)

            widgetEntryView(entry: SimpleEntry(date: Date(), totalAutomations: 5, activeAutomations: 3))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.colorScheme, .dark)
        }
    }
}
