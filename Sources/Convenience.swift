//
//  Convenience.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate>
//
//  Created by Liam on 2024/3/11.
//  Copyright © 2024 Liam. All rights reserved.
//

import UIKit

// MARK: - DataLoadStatus-Driven Configuration

extension BlankSlate {
    /// A simplified configuration that automatically maps ``DataLoadStatus`` to different empty state presentations.
    ///
    /// Use this to quickly configure what content to show for each state (loading, empty, failure)
    /// without implementing the full ``DataSource`` protocol manually.
    ///
    /// ## Example
    /// ```swift
    /// let config = BlankSlate.StatusConfiguration(
    ///     loading: .init(customView: mySpinner),
    ///     empty: .init(title: NSAttributedString(string: "No Items")),
    ///     failure: .init(title: NSAttributedString(string: "Error"), buttonTitle: NSAttributedString(string: "Retry"))
    /// )
    /// ```
    @MainActor
    public struct StatusConfiguration {
        /// Configuration for the loading state.
        public var loading: StateContent
        /// Configuration for the empty (success with no data) state.
        public var empty: StateContent
        /// Configuration for the failure state.
        public var failure: StateContent

        /// Creates a status-driven configuration.
        /// - Parameters:
        ///   - loading: Content shown during loading. Defaults to an activity indicator.
        ///   - empty: Content shown when data is empty. Defaults to a generic "No Data" message.
        ///   - failure: Content shown on failure. Defaults to an error message with a "Retry" button.
        public init(
            loading: StateContent = .init(customView: { let v = UIActivityIndicatorView(style: .large); v.startAnimating(); return v }()),
            empty: StateContent = .init(title: NSAttributedString(string: "No Data", attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .medium), .foregroundColor: UIColor.secondaryLabel])),
            failure: StateContent = .init(
                title: NSAttributedString(string: "Something Went Wrong", attributes: [.font: UIFont.systemFont(ofSize: 22, weight: .medium), .foregroundColor: UIColor.label]),
                detail: NSAttributedString(string: "Please check your connection and try again.", attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.secondaryLabel]),
                buttonTitle: NSAttributedString(string: "Retry", attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .semibold), .foregroundColor: UIColor.systemBlue])
            )
        ) {
            self.loading = loading
            self.empty = empty
            self.failure = failure
        }
    }

    /// Content for a single state in ``StatusConfiguration``.
    ///
    /// Defines what image, title, detail, button, or custom view to display for a given state.
    @MainActor
    public struct StateContent {
        /// An image to display in the empty state.
        public var image: UIImage?
        /// An attributed title string.
        public var title: NSAttributedString?
        /// An attributed detail string.
        public var detail: NSAttributedString?
        /// An attributed button title string. When non-nil, a button is shown.
        public var buttonTitle: NSAttributedString?
        /// A custom view that replaces all default elements when non-nil.
        public var customView: UIView?

        /// Creates state content with optional image, title, detail, button title, and custom view.
        public init(
            image: UIImage? = nil,
            title: NSAttributedString? = nil,
            detail: NSAttributedString? = nil,
            buttonTitle: NSAttributedString? = nil,
            customView: UIView? = nil
        ) {
            self.image = image
            self.title = title
            self.detail = detail
            self.buttonTitle = buttonTitle
            self.customView = customView
        }
    }
}

// MARK: - Status-Driven DataSource

extension BlankSlate {
    /// A built-in data source that uses ``StatusConfiguration`` to automatically display content based on ``DataLoadStatus``.
    ///
    /// This provides a high-level API for common empty state patterns without requiring manual
    /// ``DataSource`` implementation.
    ///
    /// ## Example
    /// ```swift
    /// let sds = BlankSlate.StatusDrivenDataSource(view: tableView)
    /// sds.onRetry = { [weak self] in self?.loadData() }
    /// tableView.bs.reload(with: .loading)
    /// ```
    @MainActor
    public final class StatusDrivenDataSource: NSObject, BlankSlate.DataSource, BlankSlate.Delegate {
        private let configuration: StatusConfiguration
        private weak var view: UIView?

        /// Retry action closure called when the button is tapped.
        public var onRetry: (() -> Void)?

        /// Async retry action called when the button is tapped.
        /// Takes priority over ``onRetry`` when both are set.
        public var onRetryAsync: (@Sendable () async -> Void)?

        /// Tap action closure called when the empty state view (not the button) is tapped.
        public var onTapView: (() -> Void)?

        /// Transition animation for showing the empty state. Default is `.fadeIn(duration: 0.25)`.
        public var transition: BlankSlate.Transition = .fadeIn(duration: 0.25)

        /// Creates a status-driven data source and automatically assigns it to the provided view.
        ///
        /// The data source registers itself as both the `bs.dataSource` and `bs.delegate` on the view.
        /// - Parameters:
        ///   - view: The view to manage. Held weakly to avoid retain cycles.
        ///   - configuration: The status configuration defining content for each state.
        public init(view: UIView, configuration: StatusConfiguration = .init()) {
            self.view = view
            self.configuration = configuration
            super.init()
            view.bs.setDataSourceAndDelegate(self)
        }

        private var currentContent: StateContent {
            switch view?.bs.dataLoadStatus {
            case .loading:  return configuration.loading
            case .failure:  return configuration.failure
            default:        return configuration.empty
            }
        }

        // MARK: - DataSource
        public func image(forBlankSlate view: UIView) -> UIImage? { currentContent.image }
        public func title(forBlankSlate view: UIView) -> NSAttributedString? { currentContent.title }
        public func detail(forBlankSlate view: UIView) -> NSAttributedString? { currentContent.detail }
        public func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? {
            state == .normal ? currentContent.buttonTitle : nil
        }
        public func customView(forBlankSlate view: UIView) -> UIView? { currentContent.customView }
        public func transition(forBlankSlate view: UIView) -> BlankSlate.Transition { transition }

        // MARK: - Delegate
        public func blankSlate(_ view: UIView, didTapButton sender: UIButton) {
            if let onRetryAsync {
                Task { @MainActor in await onRetryAsync() }
            } else {
                onRetry?()
            }
        }

        public func blankSlate(_ view: UIView, didTapView sender: UIView) {
            onTapView?()
        }
    }
}

// MARK: - Retry Closure Extension

@MainActor
extension BlankSlate.Extension where ExtendedViewType: UIView {
    /// Convenience method to reload with a status and perform an async retry action on button tap.
    ///
    /// This is a shorthand that updates the `onRetryAsync` closure on the view's ``BlankSlate/StatusDrivenDataSource``
    /// (if one is assigned) and then triggers a reload.
    /// - Parameters:
    ///   - status: The current data load status.
    ///   - retry: An async closure to execute when the retry button is tapped.
    public func reload(with status: BlankSlate.DataLoadStatus?, retry: @Sendable @escaping () async -> Void) {
        if let statusDS = dataSource as? BlankSlate.StatusDrivenDataSource {
            statusDS.onRetryAsync = retry
        }
        reload(with: status)
    }
}
