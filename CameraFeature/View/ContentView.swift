import SwiftUI
import Photos

struct ContentView: View {
    @State private var viewModel = GalleryViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            TabView(selection: $viewModel.currentIndex) {
                ForEach(Array(viewModel.assets.enumerated()), id: \.offset) { index, asset in
                    GalleryPageView(image: viewModel.fullImages[asset.localIdentifier])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .task(id: viewModel.currentIndex) {
                guard viewModel.assets.indices.contains(viewModel.currentIndex) else { return }
                await viewModel.loadImage(for: viewModel.assets[viewModel.currentIndex])
            }
        }
        .safeAreaInset(edge: .bottom) {
            thumbnailStrip
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .font(.title2.weight(.medium))
                }
            }
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(viewModel.headerTitle)
                        .font(.headline)
                    Text(viewModel.headerSubtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                Button(action: {}) { Image(systemName: "square.and.arrow.up") }
                Spacer()
                HStack () {
                    Button(action: {}) { Image(systemName: "heart") }
                    Button(action: {}) { Image(systemName: "info.circle") }
                    Button(action: {}) { Image(systemName: "line.3.horizontal") }
                }
                Spacer()
                Button(action: {}) { Image(systemName: "trash") }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarBackground(.hidden, for: .bottomBar)
        .toolbarColorScheme(.dark, for: .navigationBar, .bottomBar)
        .tint(.white)
        .task {
            await viewModel.load()
            for asset in viewModel.assets {
                await viewModel.loadThumbnail(for: asset)
            }
        }
    }

    var thumbnailStrip: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 2) {
                    ForEach(Array(viewModel.assets.enumerated()), id: \.offset) { index, asset in
                        ThumbnailView(image: viewModel.thumbnails[asset.localIdentifier], isSelected: index == viewModel.currentIndex)
                            .id(index)
                            .onTapGesture {
                                withAnimation { viewModel.currentIndex = index }
                            }
                    }
                }
                .padding(.horizontal, 25)
            }
            .frame(height: 60)
            .onChange(of: viewModel.currentIndex) { _, newValue in
                withAnimation { proxy.scrollTo(newValue, anchor: .center) }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
