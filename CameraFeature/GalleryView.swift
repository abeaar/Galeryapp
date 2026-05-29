import SwiftUI
import PhotosUI

struct GalleryView: View {
    @State private var viewModel = GalleryViewModel()
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Spacer()
                
                // Image Display Area
                if viewModel.isLoading {
                    ProgressView("Loading Image...")
                } else if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 5)
                        .padding(.horizontal)
                } else {
                    ContentUnavailableView(
                        "No Photo Selected",
                        systemImage: "photo.on.rectangle.angled",
                        description: Text("Tap the button below to pick a photo from your iOS gallery.")
                    )
                }
                
                Spacer()
                
                // PhotosPicker Button
                PhotosPicker(
                    selection: $viewModel.selectedItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select from Gallery", systemImage: "photo.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .padding(.horizontal, 24)
                }
                .padding(.bottom, 20)
            }
            .navigationTitle("Gallery Test")
        }
    }
}
