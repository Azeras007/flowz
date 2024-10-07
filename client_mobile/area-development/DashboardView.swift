import SwiftUI

struct DashboardView: View {
    @State private var recommendedApps: [String] = []
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    NavigationLink(destination: CreateView()) {
                        Text("New Area")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.yellow)
                            .cornerRadius(8)
                            .padding(.top, 20)
                    }
                }
                .padding(.horizontal)

                Spacer().frame(height: 20)
                
                VStack(alignment: .leading) {
                    Text("Recommandé pour vous :")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 15) {
                        ForEach(recommendedApps, id: \.self) { app in
                            AppIconViewReco(appName: app)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(12)
                }
                .padding()
                
                Spacer()
                
                HStack {
                    NavBarItem(icon: "square.grid.2x2", text: "Dashboard")
                    Spacer()
                    NavBarItem(icon: "slider.horizontal.3", text: "Services")
                    Spacer()
                    NavBarItem(icon: "person.circle", text: "Profile")
                }
                .padding()
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
                .padding(.horizontal)
            }
            .background(Color(.systemBlue).edgesIgnoringSafeArea(.all))
            .onAppear {
                loadRecommendedApps()
            }
        }
    }
    
    private func loadRecommendedApps() {
        if let savedApps = UserDefaults.standard.array(forKey: "selectedApps") as? [String] {
            recommendedApps = savedApps
        }
    }
}

struct AppIconViewReco: View {
    var appName: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.4))
                .frame(width: 50, height: 50)
            
            Image(systemName: appName)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
        }
    }
}

struct NavBarItem: View {
    var icon: String
    var text: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}
