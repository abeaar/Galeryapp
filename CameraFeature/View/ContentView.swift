import SwiftUI
import Photos

struct ContentView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = GalleryViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                content
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
                        Text(viewModel.headerTitle)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 30)
                        Text(viewModel.headerSubtitle)
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
                loadImage(at: viewModel.currentIndex)
            }
            .onChange(of: viewModel.currentIndex) { _, newIndex in
                viewModel.prefetchNextPageIfNeeded(currentIndex: newIndex)
                loadImage(at: newIndex)
            }
    }

    @ViewBuilder
    private var content: some View {
        @Bindable var viewModel = viewModel
        TabView(selection: $viewModel.currentIndex) {
            ForEach(0..<viewModel.loadedCount, id: \.self) { index in
                GalleryPageView(image: viewModel.fullImages[viewModel.assets[index].localIdentifier])
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .ignoresSafeArea()
    }

    private func loadImage(at index: Int) {
        guard viewModel.assets.indices.contains(index) else { return }
        let asset = viewModel.assets[index]
        if viewModel.fullImages[asset.localIdentifier] == nil {
            Task { await viewModel.loadImage(for: asset) }
        }
    }
}

#Preview {
    ContentView()
}
