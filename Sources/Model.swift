//
//  Model.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate\>
//
//  Created by Liam on 2021/12/20.
//

import UIKit

extension BlankSlate {
    /// Data loading status used to drive the empty state display.
    ///
    /// Set this on a view via `view.bs.dataLoadStatus` to indicate the current state of data loading.
    /// The ``BlankSlate/DataSource`` can then return different content based on the status.
    public enum DataLoadStatus: Sendable {
        /// Data is currently loading. Typically used to show a loading indicator.
        case loading
        /// Data loaded successfully. The empty state shows when item count is 0.
        case success
        /// Data loading failed. Typically used to show an error message with a retry button.
        case failure
    }

    /// Type of empty data set element.
    ///
    /// Each element can have its own ``BlankSlate/Layout`` configuration for individual control
    /// over spacing and sizing.
    public enum Element: CaseIterable, Sendable {
        /// Image view element, displayed at the top.
        case image
        /// Title label element, displayed below the image.
        case title
        /// Detail label element, displayed below the title.
        case detail
        /// Button control element, displayed below the detail.
        case button
        /// Custom view element. When provided via `customView(forBlankSlate:)`,
        /// all other elements (image, title, detail, button) are ignored.
        case custom
    }

    /// Layout constraints for a single ``Element`` within the empty dataset.
    ///
    /// Controls padding and optional fixed height for each element individually.
    ///
    /// ## Example
    /// ```swift
    /// func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout {
    ///     switch element {
    ///     case .image: return .init(edgeInsets: .init(top: 0, left: 0, bottom: 20, right: 0))
    ///     default: return .init()
    ///     }
    /// }
    /// ```
    public struct Layout: Sendable {
        /// Padding around the edges of the element.
        ///
        /// - `top`: Space above the element (or space between this element and the previous one).
        /// - `left`: Left margin from the content view's leading edge.
        /// - `right`: Right margin from the content view's trailing edge.
        /// - `bottom`: Only effective for `custom` and `button` elements (the last element in the stack).
        public var edgeInsets: UIEdgeInsets
        /// The fixed height of the element. When `nil`, the element uses its intrinsic content size.
        public var height: CGFloat?

        /// Initialize Layout with custom edge insets and optional height.
        /// - Parameters:
        ///   - edgeInsets: Padding around the edges of the element. Default is `UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16)`.
        ///   - height: Fixed height for the element, or `nil` for adaptive height. Default is `nil`.
        public init(edgeInsets: UIEdgeInsets = .zero, height: CGFloat? = nil) {
            self.edgeInsets = edgeInsets
            self.height = height
        }

        /// Mutate this layout in-place using a closure, returning the modified value.
        ///
        /// ```swift
        /// var layout = BlankSlate.Layout()
        /// layout.with { $0.edgeInsets.top = 20 }
        /// ```
        /// - Parameter populator: A closure that receives `self` as an `inout` parameter.
        /// - Returns: The modified layout value.
        @discardableResult
        public mutating func with(_ populator: (inout Self) -> Void) -> Self {
            populator(&self)
            return self
        }
    }

    /// The vertical alignment of content within the BlankSlateView's bounds.
    ///
    /// Controls where the content stack (image, title, detail, button) is positioned vertically.
    /// Each case accepts an optional offset for fine-tuning.
    ///
    /// ## Example
    /// ```swift
    /// func alignment(forBlankSlate view: UIView) -> BlankSlate.Alignment {
    ///     .center(.offset(y: -50)) // 50 points above center
    /// }
    /// ```
    public enum Alignment: Sendable {
        /// Aligns the content vertically in the center of the BlankSlateView (the default).
        /// - Parameter offset: A point offset for horizontal and vertical adjustment. Default is `.zero`.
        case center(_ offset: CGPoint = .zero)
        /// Aligns the content vertically at the top of the BlankSlateView.
        /// - Parameter offset: A point offset for horizontal and vertical adjustment. Default is `.zero`.
        case top(_ offset: CGPoint = .zero)
        /// Aligns the content vertically at the bottom of the BlankSlateView.
        /// - Parameter offset: A point offset for horizontal and vertical adjustment. Default is `.zero`.
        case bottom(_ offset: CGPoint = .zero)
    }

    /// Transition animation style when showing the empty dataset.
    ///
    /// Specify a transition via `transition(forBlankSlate:)` to animate the blank slate's appearance.
    /// Falls back to `.none` by default.
    ///
    /// ## Example
    /// ```swift
    /// func transition(forBlankSlate view: UIView) -> BlankSlate.Transition {
    ///     .fadeIn(duration: 0.3)
    /// }
    /// ```
    public enum Transition: Sendable {
        /// No animation. The blank slate appears instantly.
        case none
        /// Fade in with the given duration.
        case fadeIn(duration: TimeInterval)
        /// Slide up from 40pt below with the given duration.
        case slideUp(duration: TimeInterval)
        /// Slide down from 40pt above with the given duration.
        case slideDown(duration: TimeInterval)
        /// Scale from 80% to full size with the given duration.
        case scale(duration: TimeInterval)
        /// Bounce in from 50% scale with spring damping with the given duration.
        case bounce(duration: TimeInterval)
    }
}

extension CGPoint {
    /// Creates a point with an offset, primarily for use with ``BlankSlate/Alignment``.
    ///
    /// ```swift
    /// .center(.offset(y: -40)) // 40pt above center
    /// .top(.offset(y: 20, x: 10)) // 20pt below top, 10pt to the right
    /// ```
    /// - Parameters:
    ///   - y: Vertical offset. Positive moves down.
    ///   - x: Horizontal offset. Positive moves right. Default is `0.0`.
    /// - Returns: A `CGPoint` with the specified offsets.
    public static func offset(y: CGFloat, x: CGFloat = 0.0) -> CGPoint {
        .init(x: x, y: y)
    }
}
