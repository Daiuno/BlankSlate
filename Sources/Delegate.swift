//
//  Delegate.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate>
//
//  Created by Liam on 2021/7/9.
//

import UIKit

extension BlankSlate {
    /// The object that acts as the delegate of the empty datasets.
    ///
    /// The delegate receives action callbacks (tap events, lifecycle notifications) and controls
    /// behavior (display permission, scroll permission, touch permission).
    ///
    /// - Note: The delegate is held weakly to avoid retain cycles. All methods are optional
    ///   with sensible defaults provided via protocol extensions.
    ///
    /// ## Example
    /// ```swift
    /// extension MyViewController: BlankSlate.Delegate {
    ///     func blankSlate(_ view: UIView, didTapButton sender: UIButton) {
    ///         // Handle retry
    ///         loadData()
    ///     }
    ///     func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
    ///         true
    ///     }
    /// }
    /// ```
    @MainActor
    public protocol Delegate: AnyObject {
        /// Asks the delegate whether the empty dataset should be forced to display even when items exist.
        ///
        /// Use this when you want to show the empty state regardless of the item count
        /// (e.g., for tutorial overlays or special states).
        /// - Parameter view: The view requesting display permission.
        /// - Returns: `true` to force display, `false` otherwise. Default is `false`.
        func blankSlateShouldBeForcedToDisplay(_ view: UIView) -> Bool

        /// Asks the delegate whether the empty dataset should be rendered and displayed.
        ///
        /// Returning `false` prevents the empty state from showing even when the item count is 0.
        /// Use this to conditionally hide the empty state (e.g., during initial load).
        /// - Parameter view: The view requesting display permission.
        /// - Returns: `true` to allow display, `false` to suppress. Default is `true`.
        func blankSlateShouldDisplay(_ view: UIView) -> Bool

        /// Asks the delegate whether the BlankSlateView should be inserted behind sibling views.
        ///
        /// When the superview has multiple subviews, this controls whether the blank slate
        /// is placed at the back (behind other content) or on top.
        /// - Parameter view: The view requesting insertion behavior.
        /// - Returns: `true` to insert at back, `false` to add on top. Default is `true`.
        func blankSlateShouldBeInsertedAtBack(_ view: UIView) -> Bool

        /// Asks the delegate for touch permission on the blank slate view.
        ///
        /// When `false`, the blank slate will not respond to any touch events.
        /// - Parameter view: The view requesting touch permission.
        /// - Returns: `true` to allow touch interaction, `false` to disable. Default is `true`.
        func blankSlateShouldAllowTouch(_ view: UIView) -> Bool

        /// Asks the delegate for scroll permission while the empty state is displayed.
        ///
        /// Controls whether the underlying scroll view can scroll while the blank slate is visible.
        /// - Parameter scrollView: The scroll view requesting scroll permission.
        /// - Returns: `true` to allow scrolling, `false` to disable. Default is `false`.
        func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool

        /// Asks the delegate whether scrolling should be re-enabled after the empty data set disappears.
        ///
        /// When the blank slate is dismissed (because data has loaded), this controls whether
        /// scrolling is restored.
        /// - Parameter scrollView: The scroll view requesting scroll restoration permission.
        /// - Returns: `true` to re-enable scrolling, `false` to keep disabled. Default is `true`.
        func shouldAllowScrollAfterBlankSlateDisappear(_ scrollView: UIScrollView) -> Bool

        /// Tells the delegate that the empty dataset view was tapped.
        ///
        /// Use this method to handle tap gestures on the blank slate (e.g., to resignFirstResponder
        /// of a textfield or searchBar, or to trigger a reload action).
        /// - Parameters:
        ///   - view: The view containing the blank slate.
        ///   - sender: The view that was tapped by the user.
        func blankSlate(_ view: UIView, didTapView sender: UIView)

        /// Tells the delegate that the action button was tapped.
        ///
        /// Use this to handle retry actions, navigation, or any other button-triggered behavior.
        /// - Parameters:
        ///   - view: The view containing the blank slate.
        ///   - sender: The button that was tapped by the user.
        func blankSlate(_ view: UIView, didTapButton sender: UIButton)

        /// Tells the delegate that the empty data set will appear.
        ///
        /// Called before the blank slate view is configured and displayed.
        /// - Parameter view: The view that will show the blank slate.
        func blankSlateWillAppear(_ view: UIView)

        /// Tells the delegate that the empty data set did appear.
        ///
        /// Called after the blank slate view has been fully configured and added to the view hierarchy.
        /// - Parameter view: The view showing the blank slate.
        func blankSlateDidAppear(_ view: UIView)

        /// Tells the delegate that the empty data set will disappear.
        ///
        /// Called before the blank slate view is removed from the view hierarchy.
        /// - Parameter view: The view that will hide the blank slate.
        func blankSlateWillDisappear(_ view: UIView)

        /// Tells the delegate that the empty data set did disappear.
        ///
        /// Called after the blank slate view has been removed from the view hierarchy.
        /// - Parameter view: The view that hid the blank slate.
        func blankSlateDidDisappear(_ view: UIView)
    }
}

extension BlankSlate.Delegate {
    public func blankSlateShouldBeForcedToDisplay(_ view: UIView) -> Bool { false }
    public func blankSlateShouldDisplay(_ view: UIView) -> Bool { true }

    public func blankSlateShouldBeInsertedAtBack(_ view: UIView) -> Bool { true }

    public func blankSlateShouldAllowTouch(_ view: UIView) -> Bool { true }

    public func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { false }
    public func shouldAllowScrollAfterBlankSlateDisappear(_ scrollView: UIScrollView) -> Bool { true }

    public func blankSlate(_ view: UIView, didTapView sender: UIView) { }
    public func blankSlate(_ view: UIView, didTapButton sender: UIButton) { }

    public func blankSlateWillAppear(_ view: UIView) { }
    public func blankSlateDidAppear(_ view: UIView) { }
    public func blankSlateWillDisappear(_ view: UIView) { }
    public func blankSlateDidDisappear(_ view: UIView) { }
}
