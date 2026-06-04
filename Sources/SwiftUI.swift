//
//  SwiftUI.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate>
//
//  Created by Liam on 2024/3/11.
//  Copyright © 2024 Liam. All rights reserved.
//

#if canImport(SwiftUI)
import SwiftUI
import UIKit

// MARK: - SwiftUI ViewModifier

@available(iOS 14.0, tvOS 14.0, visionOS 1.0, *)
extension BlankSlate {
    /// A SwiftUI view that displays an empty state overlay when `isEmpty` is true.
    ///
    /// Wraps content in a `ZStack` and conditionally shows an empty state view with a fade transition.
    ///
    /// ## Example
    /// ```swift
    /// BlankSlate.EmptyStateView(isEmpty: items.isEmpty) {
    ///     List(items) { item in ItemRow(item: item) }
    /// } empty: {
    ///     Text("No items found")
    /// }
    /// ```
    public struct EmptyStateView<Content: SwiftUI.View, Empty: SwiftUI.View>: SwiftUI.View {
        private let isEmpty: Bool
        private let content: Content
        private let emptyView: Empty

        /// Creates an empty state view.
        /// - Parameters:
        ///   - isEmpty: Whether to show the empty state overlay.
        ///   - content: The main content view.
        ///   - empty: The empty state view shown when `isEmpty` is `true`.
        public init(isEmpty: Bool, @ViewBuilder content: () -> Content, @ViewBuilder empty: () -> Empty) {
            self.isEmpty = isEmpty
            self.content = content()
            self.emptyView = empty()
        }

        public var body: some SwiftUI.View {
            ZStack {
                content
                if isEmpty {
                    emptyView
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: isEmpty)
        }
    }

    /// A standard empty state SwiftUI view with image, title, detail, and retry button.
    ///
    /// Provides a pre-built layout matching common empty state patterns. All elements are optional
    /// except the title.
    ///
    /// ## Example
    /// ```swift
    /// BlankSlate.StandardEmptyView(
    ///     image: Image(systemName: "tray"),
    ///     title: "No Messages",
    ///     detail: "Your inbox is empty.",
    ///     buttonTitle: "Refresh",
    ///     onRetry: { loadMessages() }
    /// )
    /// ```
    public struct StandardEmptyView: SwiftUI.View {
        private let image: Image?
        private let title: String
        private let detail: String?
        private let buttonTitle: String?
        private let onRetry: (() -> Void)?

        /// Creates a standard empty state view.
        /// - Parameters:
        ///   - image: An optional SwiftUI `Image` to display at the top.
        ///   - title: The main title text (required).
        ///   - detail: Optional descriptive text below the title.
        ///   - buttonTitle: Optional button label. The button is only shown when both this and `onRetry` are provided.
        ///   - onRetry: Optional closure invoked when the button is tapped.
        public init(
            image: Image? = nil,
            title: String,
            detail: String? = nil,
            buttonTitle: String? = nil,
            onRetry: (() -> Void)? = nil
        ) {
            self.image = image
            self.title = title
            self.detail = detail
            self.buttonTitle = buttonTitle
            self.onRetry = onRetry
        }

        public var body: some SwiftUI.View {
            VStack(spacing: 16) {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 120, maxHeight: 120)
                        .foregroundColor(.secondary)
                        .accessibilityHidden(true)
                }

                Text(title)
                    .font(.title2.weight(.medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                if let detail {
                    Text(detail)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }

                if let buttonTitle, let onRetry {
                    Button(action: onRetry) {
                        Text(buttonTitle)
                            .font(.body.weight(.semibold))
                    }
                    .padding(.top, 8)
                }
            }
            .padding(32)
            .accessibilityElement(children: .contain)
        }
    }
}

// MARK: - View Extension

@available(iOS 14.0, tvOS 14.0, visionOS 1.0, *)
extension SwiftUI.View {
    /// Adds an empty state overlay when the condition is true.
    ///
    /// ```swift
    /// List(items) { item in ItemRow(item: item) }
    ///     .blankSlate(isEmpty: items.isEmpty) {
    ///         Text("No items")
    ///     }
    /// ```
    /// - Parameters:
    ///   - isEmpty: Whether to show the empty state.
    ///   - empty: A view builder for the empty state content.
    /// - Returns: A view with conditional empty state overlay.
    public func blankSlate<Empty: SwiftUI.View>(isEmpty: Bool, @ViewBuilder empty: () -> Empty) -> some SwiftUI.View {
        BlankSlate.EmptyStateView(isEmpty: isEmpty, content: { self }, empty: empty)
    }

    /// Adds a standard empty state overlay with pre-built layout when the condition is true.
    ///
    /// A convenience that uses ``BlankSlate/StandardEmptyView`` internally.
    /// ```swift
    /// List(items) { item in ItemRow(item: item) }
    ///     .blankSlate(isEmpty: items.isEmpty, title: "No Data", detail: "Pull to refresh")
    /// ```
    /// - Parameters:
    ///   - isEmpty: Whether to show the empty state.
    ///   - image: An optional image to display.
    ///   - title: The title text.
    ///   - detail: Optional detail text.
    ///   - buttonTitle: Optional button title.
    ///   - onRetry: Optional retry action.
    /// - Returns: A view with conditional standard empty state overlay.
    public func blankSlate(
        isEmpty: Bool,
        image: Image? = nil,
        title: String,
        detail: String? = nil,
        buttonTitle: String? = nil,
        onRetry: (() -> Void)? = nil
    ) -> some SwiftUI.View {
        blankSlate(isEmpty: isEmpty) {
            BlankSlate.StandardEmptyView(
                image: image,
                title: title,
                detail: detail,
                buttonTitle: buttonTitle,
                onRetry: onRetry
            )
        }
    }
}
#endif
