import SwiftUI
import Photos

enum GalleryState {
    case idle, loading, loaded, denied
}


@Observable
class GalleryViewModel {
    var assets: [PHAsset] = []
    var loadedCount: Int = 0
    var state: GalleryState = .idle
    var fullImages: [String: UIImage] = [:]
    var thumbnails: [String: UIImage] = [:]

    private let pageSize: Int = 50
    private let prefetchThreshold: Int = 10

    func load() async {
        state = .loading
        let current = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        switch current {
        case .authorized, .limited:
            fetchAssets()
        case .notDetermined:
            let result = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            if result == .authorized || result == .limited {
                fetchAssets()
            } else {
                state = .denied
            }
        default:
            state = .denied
        }
    }

    private func fetchAssets() {
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let result = PHAsset.fetchAssets(with: .image, options: options)
        var fetched: [PHAsset] = []
        result.enumerateObjects { asset, _, _ in fetched.append(asset) }
        assets = fetched
        loadedCount = min(pageSize, fetched.count)
        state = .loaded
    }

    func prefetchNextPageIfNeeded(currentIndex: Int) {
        guard state == .loaded else { return }
        guard loadedCount < assets.count else { return }
        if currentIndex >= loadedCount - prefetchThreshold {
            loadedCount = min(loadedCount + pageSize, assets.count)
        }
    }
    func loadImage(for asset: PHAsset) async {
        let id = asset.localIdentifier
        if fullImages[id] != nil { return }          // cache hit, skip
        let image = await withCheckedContinuation { (continuation: CheckedContinuation<UIImage?, Never>) in
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.isSynchronous = false
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) { data, _, _, _ in
                guard let data, let image = UIImage(data: data) else {
                    continuation.resume(returning: nil); return
                }
                continuation.resume(returning: image)
            }
        }
        fullImages[id] = image
    }

    func loadThumbnail(for asset: PHAsset) async {
        let id = asset.localIdentifier
        if thumbnails[id] != nil { return }
        let image = await withCheckedContinuation { (continuation: CheckedContinuation<UIImage?, Never>) in
            let options = PHImageRequestOptions()
            options.deliveryMode = .fastFormat
            options.isNetworkAccessAllowed = true
            PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 80, height: 100), contentMode: .aspectFill, options: options) { image, _ in
                continuation.resume(returning: image)
            }
        }
        thumbnails[id] = image
    }
    
    var currentIndex: Int = 0

    var currentAsset: PHAsset? {
        guard assets.indices.contains(currentIndex) else { return nil }
        return assets[currentIndex]
    }

    var isDenied: Bool { state == .denied }

    var headerTitle: String {
        guard let date = currentAsset?.creationDate else { return "Photo" }
        return date.formatted(.dateTime.weekday(.wide).day().month())
    }

    var headerSubtitle: String {
        guard let date = currentAsset?.creationDate else { return "" }
        return date.formatted(.dateTime.hour().minute())
    }
}
