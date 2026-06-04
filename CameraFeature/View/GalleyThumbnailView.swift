//import SwiftUI
//import Photos
//
//struct ThumbnailView: View {
//    let image: UIImage?
//    let isSelected: Bool
//    
//    var body: some View {
//        Group {
//            if let image {
//                Image(uiImage: image)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//            } else {
//                Color.gray
//            }
//        }
//        .frame(width: isSelected ? 38 : 30, height: isSelected ? 48 : 40)
//        .clipShape(RoundedRectangle(cornerRadius: 3))
//        .overlay(
//            isSelected
//            ? RoundedRectangle(cornerRadius: 3).stroke(Color.clear)
//            : nil
//        )
//    }
//}
