import SwiftUI

struct ToggleButtonStyle: ButtonStyle {
    var isActive: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(isActive ? Color.yellow : Color.gray)
            .cornerRadius(10)
            .shadow(color: .black.opacity(configuration.isPressed ? 0.2 : 0.4),
                    radius: configuration.isPressed ? 2 : 4,
                    x: 0,
                    y: configuration.isPressed ? 1 : 2)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
