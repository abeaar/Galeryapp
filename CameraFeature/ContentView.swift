import SwiftUI

struct ContentView: View {
    var body: some View {
        // ZStack: Handles depth
        ZStack {
            // 1. The Base Layer defines the absolute, unmovable size of the screen.
            Color.black.ignoresSafeArea()

                .overlay(
                    Image("IMG_2035").resizable().aspectRatio(contentMode: .fit)
                    
                )
                .clipped()
            
            // 4. The UI Layer floats safely on top
            VStack(spacing: 0) {
                
                // --- TOP BAR ---
                GlassEffectContainer(spacing: 16) {
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.left")
                                .frame(width: 52, height: 52)
                                .font(.title3.weight(.semibold))
                                .glassEffect(.regular.interactive(), in: Circle())

                        }
                        .buttonStyle(.plain)
                        .pressAnimation()
                        .accessibilityLabel("Back")
                        
                        
                        Spacer()
                    
                        VStack(spacing: 2) {
                            Text("Today")
                                .font(.headline)
                                .foregroundStyle(.white)
                            Text("14.22")
                                .font(.caption)
                                .foregroundStyle(.white.secondary)
                        }
                        .frame(width: 150, height: 52)
                        .glassEffect(.regular.interactive(), in: Capsule())
                        .pressAnimation()

                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: {}) {
                                Image(systemName: "photo.badge.plus")
                                    .frame(width: 28, height: 28)
                            }
                            .buttonStyle(.plain)
                            .pressAnimation()
                            .accessibilityLabel("Add Photo")
                            
                            Button(action: {}) {
                                Image(systemName: "ellipsis")
                                    .frame(width: 28, height: 28)
                            }
                            .buttonStyle(.plain)
                            .pressAnimation()
                            .accessibilityLabel("More")
                        }
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .frame(height: 52)
                        .glassEffect(.regular.interactive(), in: Capsule())
                    }
                }
                .foregroundStyle(.white)
                .padding(.horizontal)
                .padding(.top, 10)
                
                Spacer() // Keeps the toolbars pinned to the top and bottom
                
                // --- BOTTOM AREA ---
                VStack(spacing: 15) {
                    // Thumbnail Strip
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 2) {
                            ForEach(0..<15, id: \.self) { _ in
                                Rectangle().fill(Color.gray).frame(width: 30, height: 40)
                            }
                        }
                    }
                    .frame(height: 40)
                    
                    // Action Toolbar
                    HStack {
                        Button(action: {}) { Image(systemName: "square.and.arrow.up")                   .frame(width: 52, height: 52)
                                .font(.title3.weight(.semibold))
                                .glassEffect(.regular.interactive(), in: Circle())
                                .buttonStyle(.plain)
                        }
                        
                        Spacer()
                        HStack (spacing: 20) {
                            Button(action: {}) { Image(systemName: "heart") }
                                .buttonStyle(.plain)
                            Button(action: {}) { Image(systemName: "info.circle") }
                                .buttonStyle(.plain)
                            Button(action: {}) { Image(systemName: "line.3.horizontal") }
                                .buttonStyle(.plain)
                        }
                        .font(.title.weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 18)
                        .frame(height: 52)
                        .glassEffect(.regular.interactive(), in: Capsule())
                        
                        Spacer()
                        
                        Button(action: {}) { Image(systemName: "trash")
                            .frame(width: 52, height: 52)}
                            .buttonStyle(.plain)
                            .font(.title3.weight(.semibold))
                            .glassEffect(.regular.interactive(), in: Circle())
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .padding(.top, 10)
            }
        }
    }
}

private struct PressAnimationModifier: ViewModifier {
    @GestureState private var isPressed = false

    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? 0.92 : 1)
            .opacity(isPressed ? 0.78 : 1)
            .animation(.smooth(duration: 0.18), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
            )
    }
}

private extension View {
    func pressAnimation() -> some View {
        modifier(PressAnimationModifier())
    }
}

#Preview {
    ContentView()
}
