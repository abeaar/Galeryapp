import SwiftUI
import Photos

struct ContentView: View {
    @State private var viewModel = GalleryViewModel()
    @State private var currentIndex = 0

    var body: some View {
        // ZStack: Handles depth
        ZStack {
            Color.black.ignoresSafeArea()

            // --- PHOTO LAYER ---
            switch viewModel.state {
            case .idle, .loading:
                ProgressView().tint(.white)

            case .denied:
                VStack(spacing: 16) {
                    Image(systemName: "photo.slash")
                        .font(.system(size: 48))
                        .foregroundStyle(.white.secondary)
                    Text("Photo access is required")
                        .font(.headline)
                        .foregroundStyle(.white)
                    Button("Open Settings") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }

            case .loaded:
                if viewModel.assets.isEmpty {
                    Text("No photos found")
                        .foregroundStyle(.white.secondary)
                } else {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(viewModel.assets.enumerated()), id: \.offset) { index, asset in
                            GalleryPageView(asset: asset)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .ignoresSafeArea()
                }
            }

            // --- UI LAYER (floats on top) ---
            if viewModel.state == .loaded && !viewModel.assets.isEmpty {
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
                            Text(headerTitle)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 30)
                            Text(headerSubtitle)
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
                        ScrollViewReader { proxy in
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 2) {
                                    ForEach(Array(viewModel.assets.enumerated()), id: \.offset) { index, asset in
                                        ThumbnailView(asset: asset, isSelected: index == currentIndex)
                                            .id(index)
                                            .onTapGesture {
                                                withAnimation { currentIndex = index }
                                            }
                                    }
                                }
                                .padding(.horizontal, 25)
                            }
                            .frame(height: 60)
                            .onChange(of: currentIndex) { _, newValue in
                                withAnimation { proxy.scrollTo(newValue, anchor: .center) }
                            }
                        }

                        // Action Toolbar
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title2.weight(.medium))
                            }
                            .frame(width: 52, height: 52)
                            .buttonStyle(.plain)
                            .glassEffect(.regular.interactive(), in: Circle())

                            Spacer()
                            HStack(spacing: 40) {
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

                            Button(action: {}) {
                                Image(systemName: "trash")
                                    .frame(width: 52, height: 52)
                            }
                            .buttonStyle(.plain)
                            .font(.title2.weight(.medium))
                            .glassEffect(.regular.interactive(), in: Circle())
                        }
                        .padding(.horizontal, 25)
                    }
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private var currentAsset: PHAsset? {
        guard viewModel.assets.indices.contains(currentIndex) else { return nil }
        return viewModel.assets[currentIndex]
    }

    private var headerTitle: String {
        guard let date = currentAsset?.creationDate else { return "Photo" }
        return date.formatted(.dateTime.weekday(.wide).day().month())
    }

    private var headerSubtitle: String {
        guard let date = currentAsset?.creationDate else { return "" }
        return date.formatted(.dateTime.hour().minute())
    }
}

private struct GalleryPageView: View {
    let asset: PHAsset
    @State private var image: UIImage?

    var body: some View {
        GeometryReader { geo in
            Group {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    Color.clear
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .task {
            image = await loadImage()
        }
    }

    private func loadImage() async -> UIImage? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false

            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
                guard let data, let image = UIImage(data: data) else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: image)
            }
        }
    }
}

private struct ThumbnailView: View {
    let asset: PHAsset
    let isSelected: Bool
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.gray
            }
        }
        .frame(width: isSelected ? 38 : 30, height: isSelected ? 48 : 40)
        .clipShape(RoundedRectangle(cornerRadius: 3))
        .overlay(
            isSelected
                ? RoundedRectangle(cornerRadius: 3).stroke(Color.white, lineWidth: 2)
                : nil
        )
        .task {
            image = await loadThumbnail()
        }
    }

    private func loadThumbnail() async -> UIImage? {
        await withCheckedContinuation { continuation in
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isNetworkAccessAllowed = true

            PHImageManager.default().requestImage(
                for: asset,
                targetSize: CGSize(width: 80, height: 100),
                contentMode: .aspectFill,
                options: options
            ) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
}

#Preview {
    ContentView()
}
