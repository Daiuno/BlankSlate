//
//  DataSource.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate>
//
//  Created by Liam on 2021/7/9.
//

import UIKit

extension BlankSlate {
    /// The object that acts as the data source of the empty datasets.
    ///
    /// The data source provides all the visual content for the empty state, including images, text,
    /// buttons, layout, and animations. Adopt this protocol to customize what is displayed when
    /// a view has no content.
    ///
    /// - Note: The data source is held weakly to avoid retain cycles. All methods are optional
    ///   with sensible defaults provided via protocol extensions.
    ///
    /// ## Example
    /// ```swift
    /// extension MyViewController: BlankSlate.DataSource {
    ///     func image(forBlankSlate view: UIView) -> UIImage? {
    ///         UIImage(named: "empty_state")
    ///     }
    ///     func title(forBlankSlate view: UIView) -> NSAttributedString? {
    ///         NSAttributedString(string: "No Data Available")
    ///     }
    /// }
    /// ```
    @MainActor
    public protocol DataSource: AnyObject {
        /// Asks the data source for the image of the dataset.
        ///
        /// The image is displayed centered above the title and detail labels.
        ///
        /// - Note: For VoiceOver accessibility, set the image's `accessibilityIdentifier` property
        ///   to a descriptive string — it will be used as the accessibility label for the image view.
        /// - Parameter view: The view requesting the empty dataset image.
        /// - Returns: An image for the empty state, or `nil` for no image. Default is `nil`.
        func image(forBlankSlate view: UIView) -> UIImage?

        /// Asks the data source for the alpha (opacity) of the dataset image.
        ///
        /// - Parameter view: The view requesting the image alpha.
        /// - Returns: A value in [0.0, 1.0] range. Default is `1.0`.
        func imageAlpha(forBlankSlate view: UIView) -> CGFloat

        /// Asks the data source for a tint color of the image dataset.
        ///
        /// When non-nil, the image rendering mode is set to `.alwaysTemplate` and this tint color is applied.
        /// - Parameter view: The view requesting the image tint color.
        /// - Returns: A tint color for the image, or `nil` to use original rendering. Default is `nil`.
        func imageTintColor(forBlankSlate view: UIView) -> UIColor?

        /// Asks the data source for the image animation of the dataset.
        ///
        /// The animation is added to the image view's layer when displayed.
        /// - Parameter view: The view requesting the animation.
        /// - Returns: A `CAAnimation` to apply to the image view, or `nil` for no animation. Default is `nil`.
        func imageAnimation(forBlankSlate view: UIView) -> CAAnimation?

        /// Asks the data source for the title of the dataset.
        ///
        /// The title label is displayed below the image (if any) and above the detail label.
        /// - Parameter view: The view requesting the title.
        /// - Returns: An attributed string for the dataset title, combining font, text color,
        ///   text paragraph style, etc. Default is `nil`.
        func title(forBlankSlate view: UIView) -> NSAttributedString?

        /// Asks the data source for the description of the dataset.
        ///
        /// The detail label is displayed below the title label and above the button.
        /// - Parameter view: The view requesting the detail text.
        /// - Returns: An attributed string for the dataset description text, combining font,
        ///   text color, text paragraph style, etc. Default is `nil`.
        func detail(forBlankSlate view: UIView) -> NSAttributedString?

        /// Asks the data source for the title to be used for the specified button state.
        ///
        /// The button is displayed below all labels. Provide titles for `.normal` and optionally
        /// `.highlighted` states.
        /// - Parameters:
        ///   - view: The view requesting the button title.
        ///   - state: The state that uses the specified title. The possible values are described in `UIControl.State`.
        /// - Returns: An attributed string for the dataset button title. Default is `nil`.
        func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString?

        /// Asks the data source for a background image to be used for the specified button state.
        ///
        /// - Parameters:
        ///   - view: The view requesting the button background image.
        ///   - state: The state that uses the specified image. The values are described in `UIControl.State`.
        /// - Returns: A background image for the button. Default is `nil`.
        func buttonBackgroundImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage?

        /// Asks the data source for the image to be used for the specified button state.
        ///
        /// When a button image is provided (for `.normal` state), it takes priority over `buttonTitle`.
        /// - Parameters:
        ///   - view: The view requesting the button image.
        ///   - state: The state that uses the specified title. The possible values are described in `UIControl.State`.
        /// - Returns: An image for the dataset button imageview. Default is `nil`.
        func buttonImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage?

        /// Asks the data source to configure the button style.
        ///
        /// Use this method to customize the button appearance (e.g., corner radius, border, content insets).
        /// Called after the button has been created and configured with title/image.
        /// - Parameters:
        ///   - view: The view containing the blank slate.
        ///   - button: The button to be configured.
        func blankSlate(_ view: UIView, configure button: UIButton)

        /// Asks the data source for a custom view to be displayed instead of the default views.
        ///
        /// When a non-nil custom view is returned, all other element methods (image, title, detail, button)
        /// are ignored. Use this to show an activity indicator for loading feedback, or for a completely
        /// custom empty data set layout.
        /// - Parameter view: The view requesting the custom view.
        /// - Returns: A custom view to display, or `nil` to use the default elements. Default is `nil`.
        func customView(forBlankSlate view: UIView) -> UIView?

        /// Asks the data source for the layout constraints of a specific ``BlankSlate/Element``.
        ///
        /// Use this to control padding and fixed height for each element individually.
        /// - Parameters:
        ///   - view: The view requesting the layout.
        ///   - element: The element type whose layout is being requested.
        /// - Returns: A ``BlankSlate/Layout`` value with edge insets and optional height. Default is `Layout()`.
        func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout

        /// Asks the data source for the vertical alignment of the content.
        ///
        /// Controls where the content is positioned vertically within the blank slate view.
        /// - Parameter view: The view requesting alignment information.
        /// - Returns: An ``BlankSlate/Alignment`` value. Default is `.center()`.
        func alignment(forBlankSlate view: UIView) -> BlankSlate.Alignment

        /// Asks the data source for the background color of the dataset.
        ///
        /// - Parameter view: The view requesting the background color.
        /// - Returns: A color to be applied to the dataset background view. Default is `.clear`.
        func backgroundColor(forBlankSlate view: UIView) -> UIColor?

        /// Asks the data source for the background gradient of the dataset.
        ///
        /// When provided, the gradient layer is inserted behind all content. It is automatically
        /// sized to fill the blank slate view's bounds.
        /// - Parameter view: The view requesting the background gradient.
        /// - Returns: A `CAGradientLayer` to be applied to the background, or `nil`. Default is `nil`.
        func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer?

        /// Requests the duration of the fade-in animation from the data source when displaying an empty dataset.
        ///
        /// - Parameter view: The view requesting the fade-in duration.
        /// - Returns: The fade-in animation duration in seconds. Default is `0.0` (no animation).
        /// - Important: **Deprecated.** Use ``transition(forBlankSlate:)`` instead for richer animation options.
        ///   This method is only called when `transition(forBlankSlate:)` returns `.none`.
        func fadeInDuration(forBlankSlate view: UIView) -> TimeInterval

        /// Asks the data source for the transition animation when displaying the empty dataset.
        ///
        /// Supports multiple animation styles: fade in, slide up/down, scale, and bounce.
        /// When this returns `.none`, the library falls back to `fadeInDuration(forBlankSlate:)`.
        /// - Parameter view: The view requesting the transition.
        /// - Returns: A ``BlankSlate/Transition`` value. Default is `.none`.
        func transition(forBlankSlate view: UIView) -> BlankSlate.Transition
    }
}

extension BlankSlate.DataSource {
    public func image(forBlankSlate view: UIView) -> UIImage? { nil }
    public func imageAlpha(forBlankSlate view: UIView) -> CGFloat { 1.0 }
    public func imageTintColor(forBlankSlate view: UIView) -> UIColor? { nil }
    public func imageAnimation(forBlankSlate view: UIView) -> CAAnimation? { nil }

    public func title(forBlankSlate view: UIView) -> NSAttributedString? { nil }

    public func detail(forBlankSlate view: UIView) -> NSAttributedString? { nil }

    public func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? { nil }
    public func buttonBackgroundImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage? { nil }
    public func buttonImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage? { nil }
    public func blankSlate(_ view: UIView, configure button: UIButton) { }

    public func customView(forBlankSlate view: UIView) -> UIView? { nil }

    public func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout { .init() }

    public func alignment(forBlankSlate view: UIView) -> BlankSlate.Alignment { .center() }
    public func backgroundColor(forBlankSlate view: UIView) -> UIColor? { .clear }
    public func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer? { nil }
    public func fadeInDuration(forBlankSlate view: UIView) -> TimeInterval { 0.0 }
    public func transition(forBlankSlate view: UIView) -> BlankSlate.Transition { .none }
}
