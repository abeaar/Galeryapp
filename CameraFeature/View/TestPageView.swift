//import SwiftUI
//
//struct TestPageView: View {
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        ZStack {
//            // Static photo stand-in — NO TabView, so taps reach the controls.
//            Image("IMG_2035")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//                // --- TOP BAR ---
//                HStack {
//                    Button(action: { dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .frame(width: 44, height: 44)
//                            .font(.title2.weight(.medium))
//                    }
//                    .buttonStyle(.plain)
//                    .accessibilityLabel("Back")
//                    .glassEffect(.regular.interactive(), in: Circle())
//
//                    Spacer()
//
//                    VStack(spacing: 2) {
//                        Text("Test Page")
//                            .font(.headline)
//                            .foregroundStyle(.white)
//                            .padding(.horizontal, 30)
//                        Text("Navigation demo")
//                            .font(.caption)
//                            .foregroundStyle(.white.secondary)
//                    }
//                    .frame(width: 200, height: 44)
//                    .glassEffect(.regular.interactive(), in: Capsule())
//
//                    Spacer()
//
//                    Button(action: {}) {
//                        Image(systemName: "ellipsis")
//                            .frame(width: 44, height: 44)
//                    }
//                    .buttonStyle(.plain)
//                    .accessibilityLabel("More")
//                    .glassEffect(.regular.interactive(), in: Capsule())
//                }
//                .padding(.horizontal, 25)
//
//                Spacer()
//
//                // --- BOTTOM AREA ---
//                VStack {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 2) {
//                            ForEach(0..<15, id: \.self) { _ in
//                                RoundedRectangle(cornerRadius: 3)
//                                    .fill(Color.gray.opacity(0.6))
//                                    .frame(width: 30, height: 40)
//                            }
//                        }
//                        .padding(.horizontal, 25)
//                    }
//                    .frame(height: 60)
//
//                    // Action toolbar
//                    HStack {
//                        Button(action: {}) {
//                            Image(systemName: "square.and.arrow.up")
//                                .font(.title2.weight(.medium))
//                        }
//                        .frame(width: 44, height: 44)
//                        .buttonStyle(.plain)
//                        .glassEffect(.regular.interactive(), in: Circle())
//
//                        Spacer()
//                        HStack(spacing: 40) {
//                            Button(action: {}) { Image(systemName: "heart") }
//                                .buttonStyle(.plain)
//                            Button(action: {}) { Image(systemName: "info.circle") }
//                                .buttonStyle(.plain)
//                            Button(action: {}) { Image(systemName: "line.3.horizontal") }
//                                .buttonStyle(.plain)
//                        }
//                        .font(.title2.weight(.medium))
//                        .padding(.horizontal, 15)
//                        .frame(height: 44)
//                        .glassEffect(.regular.interactive(), in: Capsule())
//
//                        Spacer()
//
//                        Button(action: {}) {
//                            Image(systemName: "trash")
//                                .frame(width: 44, height: 44)
//                        }
//                        .buttonStyle(.plain)
//                        .font(.title2.weight(.medium))
//                        .glassEffect(.regular.interactive(), in: Circle())
//                    }
//                    .padding(.horizontal, 25)
//                }
//            }
//            .foregroundStyle(.white)
//        }
//        .navigationBarBackButtonHidden(true)
//        .toolbar(.hidden, for: .navigationBar)
//    }
//}
//
//#Preview {
//    NavigationStack {
//        TestPageView()
//    }
//}
