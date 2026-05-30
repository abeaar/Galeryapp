import SwiftUI
import Photos

enum GalleryState {
    case idle, loading, loaded, denied
}

@MainActor
@Observable
class GalleryViewModel {
    var assets: [PHAsset] = []
    var state: GalleryState = .idle

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
        state = .loaded
    }
}
