import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            LottieView(filename: "loading")
                .frame(width: 250, height: 250)
            Spacer()
        }
        .background(Color.white.ignoresSafeArea())
    }
}
