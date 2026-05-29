import SwiftUI

struct ContentView: View {
    var body: some View {
        // ZStack: Handles depth
        ZStack {
            Color.white.ignoresSafeArea()
                .overlay(
                    Image("IMG_2035").resizable().aspectRatio(contentMode: .fit)
                )
            // 4. The UI Layer floats safely on top
            VStack(spacing: 0) {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .frame(width: 52, height: 52)
                                .font(.title2.weight(.medium))
                            
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Back")
                        .glassEffect(.regular.interactive(), in: Circle())
                        
                        Spacer()
                        
                        VStack(spacing: 2) {
                            Text("Today lorem aks")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal,30)
                            Text("14.22")
                                .font(.caption)
                                .foregroundStyle(.white.secondary)
                        }
                        .frame(width: 200, height: 52)
                        .glassEffect(.regular.interactive(), in: Capsule())
                        
                        Spacer()
                        
                        Button(action: {}) {
                            Image(systemName: "ellipsis")
            
                                .frame(width: 52, height: 52)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("More")
                        .glassEffect(.regular.interactive(), in: Capsule())
                    }
                .padding(.horizontal, 25)
                
                Spacer()
                
                // --- BOTTOM AREA ---
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 2) {
                            ForEach(0..<15, id: \.self) { _ in
                                Rectangle().fill(Color.gray).frame(width: 30, height: 40)
                            }
                        }
                    }
                    .frame(height: 60)

                    // Action Toolbar
                    HStack (){ 
                        Button(action: {}) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title2.weight(.medium))
                        }
                        
                        .frame(width: 52, height: 52)
                        .buttonStyle(.plain)
                        .glassEffect(.regular.interactive(), in: Circle())
                        
                        Spacer()
                        HStack (spacing: 40) {
                            Button(action: {}) { Image(systemName: "heart") }
                                .buttonStyle(.plain)
                            Button(action: {}) { Image(systemName: "info.circle") }
                                .buttonStyle(.plain)
                            Button(action: {}) { Image(systemName: "line.3.horizontal") }
                                .buttonStyle(.plain)
                        }
                        .font(.title2.weight(.medium))
                        .padding(.horizontal, 15)
                        .frame(height: 52)
                        .glassEffect(.regular.interactive(), in: Capsule())
                        
                        Spacer()
                        
                        Button(action: {}) { Image(systemName: "trash")
                                .frame(width: 52, height: 52)
                        }
                        .buttonStyle(.plain)
                        .font(.title2.weight(.medium))
                        .glassEffect(.regular.interactive(), in: Circle())
                    }
                    .padding(.horizontal,25)
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
