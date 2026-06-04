import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "house.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(.tint)
                Text("Home")
                    .font(.largeTitle.bold())
                // Pushes ContentView onto the navigation stack
                NavigationLink {
                    ContentView()
                } label: {
                    Text("Open Gallery")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.tint, in: RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal, 40)
                }
            }
        }
    }
}
#Preview {
    HomeView()
}
