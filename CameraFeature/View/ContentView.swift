import SwiftUI
import Photos

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = GalleryViewModel()
    @GestureState private var dragOffset: CGFloat = 0
    
    private let swipeThreshold: CGFloat = 50
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                content
                    .offset(x: dragOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onEnded { value in
                                handleSwipe(value.translation.width)
                            }
                    )
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.regular))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text ("Challenge 3")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal,30)
                        Text("00:00")
                            .font(.caption)
                            .foregroundStyle(.white.secondary)
                    }
                    .frame(width: 200, height: 44)
                    .glassEffect(.regular.interactive(), in: Capsule())
                }
                
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {} label: {
                        Image(systemName: "ellipsis")
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {} label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {} label: {
                        Image(systemName: "heart")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {} label: {
                        Image(systemName: "info.circle")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {} label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    Button {} label: {
                        Image(systemName: "trash")
                    }
                }
            }
        }.navigationBarBackButtonHidden(true)
            .task {
                await viewModel.load()
            }
            .onChange(of: viewModel.currentAsset?.localIdentifier) { _, newId in
                guard let id = newId,
                      let asset = viewModel.currentAsset else { return }
                if viewModel.fullImages[id] == nil {
                    Task { await viewModel.loadImage(for: asset) }
                }
            }
    }
    
    private func handleSwipe(_ translation: CGFloat) {
        guard !viewModel.assets.isEmpty else { return }
        if translation > swipeThreshold {
            if viewModel.currentIndex > 0 {
                viewModel.currentIndex -= 1
            }
        } else if translation < -swipeThreshold {
            if viewModel.currentIndex < viewModel.assets.count - 1 {
                viewModel.currentIndex += 1
            }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .tint(.white)
        case .denied:
            placeholder(systemImage: "photo.on.rectangle.angled", message: "Photo access denied")
        case .loaded:
            if let asset = viewModel.currentAsset,
               let image = viewModel.fullImages[asset.localIdentifier] {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if viewModel.assets.isEmpty {
                placeholder(systemImage: "photo.on.rectangle.angled", message: "No photos")
            } else {
                ProgressView()
                    .tint(.white)
            }
        }
    }
    
    private func placeholder(systemImage: String, message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 48, weight: .light))
                .foregroundStyle(.white.secondary)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.white.secondary)
        }
    }
}

#Preview {
    ContentView()
}
