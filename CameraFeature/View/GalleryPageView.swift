import SwiftUI
import Photos

import Foundation
struct GalleryPageView: View {
    let image: UIImage?
    
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
    }
}
