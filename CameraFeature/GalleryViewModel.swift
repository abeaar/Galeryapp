import SwiftUI
import PhotosUI

@MainActor
class GalleryViewModel: Observable {
    var selectedItem: PhotosPickerItem? {
        didSet {
            Task { await loadImage() }
        }
    }
    
    var selectedImage: UIImage?
    var isLoading = false
    
    private func loadImage() async {
        guard let item = selectedItem else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        // Load the image data from the picker
        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {
            self.selectedImage = uiImage
        }
    }
}
