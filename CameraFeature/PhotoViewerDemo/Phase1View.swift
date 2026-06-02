import SwiftUI

// PHASE 1 — Plain UI
// Goal: lay out the photo-viewer screen with a placeholder image and put ALL
// the controls in the navigation toolbar (top + bottom bars), not floating buttons.
// No data, no view model, no swiping yet — just the static layout.

struct Phase1View: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                // Placeholder image (a bundled asset stands in for a real photo).
                Image("IMG_2035")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .ignoresSafeArea(edges: .top)
            }
            // --- All controls live in the navigation toolbar ---
            .toolbar {
                // Top-left: back
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                    }
                }
                // Top-center: date / time
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Text("Saturday, 30 May")
                            .font(.headline)
                        Text("17.34")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                // Top-right: more
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "ellipsis")
                    }
                }
                // Bottom bar: action row
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {}) { Image(systemName: "square.and.arrow.up") }
                    Spacer()
                    Button(action: {}) { Image(systemName: "heart") }
                    Spacer()
                    Button(action: {}) { Image(systemName: "info.circle") }
                    Spacer()
                    Button(action: {}) { Image(systemName: "slider.horizontal.3") }
                    Spacer()
                    Button(action: {}) { Image(systemName: "trash") }
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarBackground(.hidden, for: .bottomBar)
            .toolbarColorScheme(.dark, for: .navigationBar, .bottomBar)
            .tint(.white)
        }
    }
}

#Preview {
    Phase1View()
}
