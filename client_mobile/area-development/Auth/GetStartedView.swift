import SwiftUI

struct GetStartedView: View {
    @Binding var showLoginOrRegister: Bool
    @Binding var showGetStarted: Bool

    @State private var selectedPage = 0

    var body: some View {
        VStack {
            Spacer()

            TabView(selection: $selectedPage) {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 20)

                    Text("Flowz")
                        .font(.system(size: 50, weight: .bold))
                        .padding(.bottom, 10)

                    Text("Automate your favorite apps!")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                        .multilineTextAlignment(.center)
                }
                .tag(0)

                VStack {
                    Image(systemName: "bolt.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 20)

                    Text("Quick Automation")
                        .font(.system(size: 40, weight: .bold))
                        .padding(.bottom, 10)

                    Text("Set up automations in seconds!")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                        .multilineTextAlignment(.center)
                }
                .tag(1)

                VStack {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.bottom, 20)

                    Text("Customizable Workflows")
                        .font(.system(size: 40, weight: .bold))
                        .padding(.bottom, 10)

                    Text("Personalize your automations.")
                        .font(.title3)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 30)
                        .multilineTextAlignment(.center)
                }
                .tag(2)
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .frame(height: 300)
            .padding(.bottom, 20)

            HStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(selectedPage == index ? Color.yellow : Color.gray)
                        .frame(width: 10, height: 10)
                        .padding(.horizontal, 5)
                }
            }
            .padding(.bottom, 20)

            Spacer()

            Button(action: {
                showLoginOrRegister = true
                showGetStarted = false
            }) {
                Text("Get Started For Free")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 245)
                    .background(Color.yellow)
                    .cornerRadius(90)
            }
            .padding(.bottom, 40)
        }
        .padding()
    }
}
