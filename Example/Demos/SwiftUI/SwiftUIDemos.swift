//
//  SwiftUIDemos.swift
//  BlankSlate Example
//
//  Demonstrates all SwiftUI APIs:
//    EmptyStateView, StandardEmptyView,
//    .blankSlate(isEmpty:empty:), .blankSlate(isEmpty:image:title:detail:buttonTitle:onRetry:)
//

import SwiftUI
import BlankSlate

// MARK: - Main Navigation

@available(iOS 16.0, *)
struct SwiftUIDemosView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("EmptyStateView") {
                    NavigationLink("Custom Empty View") {
                        EmptyStateViewDemo()
                    }
                }
                Section("StandardEmptyView") {
                    NavigationLink("Standard Layout") {
                        StandardEmptyViewDemo()
                    }
                }
                Section(".blankSlate() View Modifier") {
                    NavigationLink("Custom Content Modifier") {
                        ViewModifierCustomDemo()
                    }
                    NavigationLink("Standard Convenience Modifier") {
                        ViewModifierStandardDemo()
                    }
                }
            }
            .navigationTitle("SwiftUI Demos")
        }
    }
}

// Fallback for iOS 14-15
@available(iOS 14.0, *)
struct SwiftUIDemosViewCompat: View {
    var body: some View {
        if #available(iOS 16.0, *) {
            SwiftUIDemosView()
        } else {
            Text("Requires iOS 16+ for NavigationStack demo")
        }
    }
}

// MARK: - Demo 1: EmptyStateView

@available(iOS 14.0, *)
struct EmptyStateViewDemo: View {
    @State private var items: [String] = []

    var body: some View {
        BlankSlate.EmptyStateView(isEmpty: items.isEmpty) {
            List(items, id: \.self) { item in
                Text(item)
            }
        } empty: {
            VStack(spacing: 16) {
                Image(systemName: "star.slash")
                    .font(.system(size: 48))
                    .foregroundColor(.orange)
                Text("No Favorites")
                    .font(.title2.weight(.semibold))
                Text("Items you favorite will appear here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Button("Add Sample Items") {
                    withAnimation {
                        items = ["Star 1", "Star 2", "Star 3"]
                    }
                }
                .padding(.top, 4)
            }
        }
        .navigationTitle("EmptyStateView")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(items.isEmpty ? "Add" : "Clear") {
                    withAnimation {
                        if items.isEmpty {
                            items = ["Star 1", "Star 2", "Star 3"]
                        } else {
                            items.removeAll()
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Demo 2: StandardEmptyView

@available(iOS 14.0, *)
struct StandardEmptyViewDemo: View {
    @State private var items: [String] = []
    @State private var isLoading = false

    var body: some View {
        ZStack {
            if isLoading {
                ProgressView("Loading...")
            } else if items.isEmpty {
                // Direct usage of StandardEmptyView
                BlankSlate.StandardEmptyView(
                    image: Image(systemName: "doc.text.magnifyingglass"),
                    title: "No Documents",
                    detail: "Your documents will appear here once synced.",
                    buttonTitle: "Sync Now",
                    onRetry: { loadItems() }
                )
            } else {
                List(items, id: \.self) { item in
                    Label(item, systemImage: "doc.fill")
                }
            }
        }
        .navigationTitle("StandardEmptyView")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Reset") {
                    items.removeAll()
                }
            }
        }
    }

    private func loadItems() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            items = ["Document A.pdf", "Report Q4.xlsx", "Notes.txt"]
            isLoading = false
        }
    }
}

// MARK: - Demo 3: .blankSlate(isEmpty:empty:) modifier

@available(iOS 14.0, *)
struct ViewModifierCustomDemo: View {
    @State private var messages: [String] = []

    var body: some View {
        List(messages, id: \.self) { message in
            Text(message)
        }
        .blankSlate(isEmpty: messages.isEmpty) {
            // Custom empty content via the modifier
            VStack(spacing: 20) {
                Image(systemName: "bubble.left.and.bubble.right")
                    .font(.system(size: 56))
                    .foregroundColor(.blue.opacity(0.6))
                Text("No Messages")
                    .font(.title3.weight(.medium))
                Text("Start a conversation to see messages here.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                Button("Generate Messages") {
                    withAnimation {
                        messages = ["Hello!", "How are you?", "Great to hear!"]
                    }
                }
            }
            .padding()
        }
        .navigationTitle(".blankSlate(empty:)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear") {
                    withAnimation { messages.removeAll() }
                }
            }
        }
    }
}

// MARK: - Demo 4: .blankSlate(isEmpty:image:title:detail:buttonTitle:onRetry:) modifier

@available(iOS 14.0, *)
struct ViewModifierStandardDemo: View {
    @State private var photos: [String] = []

    var body: some View {
        List(photos, id: \.self) { photo in
            Label(photo, systemImage: "photo")
        }
        .blankSlate(
            isEmpty: photos.isEmpty,
            image: Image(systemName: "photo.on.rectangle.angled"),
            title: "No Photos",
            detail: "Your photo library is empty. Take some photos or import from camera roll.",
            buttonTitle: "Import Photos",
            onRetry: {
                withAnimation {
                    photos = ["Sunset.jpg", "Mountains.png", "Beach.heic", "City.jpg"]
                }
            }
        )
        .navigationTitle(".blankSlate(title:...)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Clear") {
                    withAnimation { photos.removeAll() }
                }
            }
        }
    }
}
