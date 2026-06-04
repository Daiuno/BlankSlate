//
//  View.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate>
//
//  Created by Liam on 2024/3/9.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

extension BlankSlate {
    /// Internal view class responsible for rendering the empty state UI.
    ///
    /// Manages the layout of image, title, detail, button, and custom view elements
    /// within a content container. Supports Auto Layout–based alignment, accessibility,
    /// tap gesture forwarding, and orientation changes.
    class View: UIView, UIGestureRecognizerDelegate {
        /// Container view that holds all child elements and is centered within self.
        private let contentView: UIView = {
            let contentView = UIView()
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.backgroundColor = .clear
            contentView.isUserInteractionEnabled = true
            return contentView
        }()
        /// Dictionary mapping element types (image, title, detail, button, custom) to their views and layouts.
        private var elements: [Element: ElementView] = [:]

        /// Creates or reuses the image view element with the given layout.
        /// - Parameter layout: Layout configuration (insets, height) for the image view.
        /// - Returns: A configured `UIImageView` ready to have its image set.
        func makeImageView(with layout: Layout) -> UIImageView {
            elements.updateLayout(layout, populator: {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = .clear
                $0.isUserInteractionEnabled = false
                $0.contentMode = .scaleAspectFit
                contentView.addSubview($0)
            }, for: .image)
        }

        /// Creates or reuses the title label element with the given layout.
        /// - Parameter layout: Layout configuration (insets, height) for the title label.
        /// - Returns: A configured `UILabel` for the title text.
        func makeTitleLabel(with layout: Layout) -> UILabel {
            elements.updateLayout(layout, populator: {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = .clear
                $0.font = .systemFont(ofSize: 27.0)
                $0.textColor = UIColor(white: 0.6, alpha: 1.0)
                $0.textAlignment = .center
                $0.lineBreakMode = .byWordWrapping
                $0.numberOfLines = 0
                contentView.addSubview($0)
            }, for: .title)
        }

        /// Creates or reuses the detail label element with the given layout.
        /// - Parameter layout: Layout configuration (insets, height) for the detail label.
        /// - Returns: A configured `UILabel` for the detail text.
        func makeDetailLabel(with layout: Layout) -> UILabel {
            elements.updateLayout(layout, populator: {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = .clear
                $0.font = .systemFont(ofSize: 17.0)
                $0.textColor = UIColor(white: 0.6, alpha: 1.0)
                $0.textAlignment = .center
                $0.lineBreakMode = .byWordWrapping
                $0.numberOfLines = 0
                contentView.addSubview($0)
            }, for: .detail)
        }

        /// Creates or reuses the button element with the given layout.
        /// - Parameter layout: Layout configuration (insets, height) for the button.
        /// - Returns: A configured `UIButton` with tap target already wired.
        func makeButton(with layout: Layout) -> UIButton {
            elements.updateLayout(layout, populator: {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = .clear
                $0.contentHorizontalAlignment = .center
                $0.contentVerticalAlignment = .center
                $0.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
                contentView.addSubview($0)
            }, for: .button)
        }

        /// Sets a custom view as the sole content element, replacing all default elements.
        /// - Parameters:
        ///   - view: The custom view to display.
        ///   - layout: Layout configuration for the custom view.
        func setCustomView(_ view: UIView, layout: Layout) {
            elements.updateLayout(layout, maker: { view }, populator: {
                $0.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(view)
            }, for: .custom)
        }

        private weak var tapGesture: UITapGestureRecognizer?
        /// The vertical alignment of the content within this view.
        var alignment: Alignment = .center()

        /// Closure queried to determine if touch should be allowed.
        var isTouchAllowed: (() -> Bool)?
        /// Closure queried to determine if simultaneous gesture recognition should be allowed.
        var shouldRecognizeSimultaneously: (_ withOther: UIGestureRecognizer, _ of: UIGestureRecognizer) -> Bool = { _, _ in false }
        /// Closure invoked when the content view or button is tapped.
        var didTap: ((_ view: UIView) -> Void)?

        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(contentView)

            let tap = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
            tap.delegate = self
            addGestureRecognizer(tap)
            tapGesture = tap

#if os(iOS)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(updateForCurrentOrientation),
                name: UIDevice.orientationDidChangeNotification,
                object: nil)
#endif
        }

        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        deinit {
#if os(iOS)
            NotificationCenter.default.removeObserver(self)
#endif
#if DEBUG
            print("👍🏻👍🏻👍🏻 BlankSlate.View is released.")
#endif
        }

        override func didMoveToSuperview() {
            updateForCurrentOrientation()
        }

        override func didMoveToWindow() {
            updateForCurrentOrientation()
        }

        /// Recalculates frame when orientation or layout changes.
        /// For scroll views delegates to `syncFrameIfNeeded()`; for plain views uses safe area insets.
        @objc
        private func updateForCurrentOrientation() {
            guard window != nil, let superview else { return }

            guard superview is UIScrollView else {
                frame = CGRect(x: superview.safeAreaInsets.left,
                               y: superview.safeAreaInsets.top,
                               width: superview.bounds.width - superview.safeAreaInsets.left - superview.safeAreaInsets.right,
                               height: superview.bounds.height - superview.safeAreaInsets.top - superview.safeAreaInsets.bottom)
                return
            }

            syncFrameIfNeeded()
            DispatchQueue.main.async { [weak self] in
                self?.syncFrameIfNeeded()
            }
        }

        /// Synchronizes this view's frame to fill the visible area of the parent scroll view,
        /// accounting for content insets and safe area insets.
        private func syncFrameIfNeeded() {
            guard window != nil, let scrollView = superview as? UIScrollView else { return }
            let size = scrollView.bounds.size
            let safeInsets = scrollView.safeAreaInsets
            let isVerticalScroll = scrollView.contentSize.width == scrollView.bounds.width

            var inset = scrollView.contentInset
            inset = UIEdgeInsets(top: safeInsets.top + inset.top,
                                 left: safeInsets.left + inset.left,
                                 bottom: safeInsets.bottom + inset.bottom,
                                 right: safeInsets.right + inset.right)
            frame = CGRect(x: isVerticalScroll ? inset.left : 0.0, y: 0.0,
                           width: size.width - inset.left - inset.right,
                           height: size.height - inset.top - inset.bottom)
            scrollView.scrollRectToVisible(frame, animated: false)
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            guard let backgroundGradient = layer.sublayers?.first(where: { $0 is CAGradientLayer }) else { return }
            backgroundGradient.frame = bounds
        }

        @objc
        private func didTapButton(_ sender: UIButton) {
            didTap?(sender)
        }

        @objc
        private func didTapContentView(_ sender: UITapGestureRecognizer) {
            guard let view = sender.view else { return }
            didTap?(view)
        }

        /// Removes all child element views and clears all constraints, preparing for fresh layout.
        func prepareForReuse() {
            elements.values.forEach { $0.view.removeFromSuperview() }
            elements.removeAll()

            removeConstraints(constraints)
            contentView.removeConstraints(contentView.constraints)
        }

        /// Activates Auto Layout constraints for all current elements within the content view.
        /// Supports both custom view (fills content view) and stacked element layout.
        func setupConstraints() {
            guard elements.isEmpty == false else { return }

            // Configure accessibility
            configureAccessibility()

            // First, configure the content view constaints The content view must alway be centered to its superview
            var constraints: [NSLayoutConstraint] = [contentView.widthAnchor.constraint(equalTo: widthAnchor)]
            
            let offsetX: CGFloat
            switch alignment {
            case let .center(offset):
                offsetX = offset.x
                constraints.append(contentView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: offset.y))
            case let .top(offset):
                offsetX = offset.x
                constraints.append(contentView.topAnchor.constraint(equalTo: topAnchor, constant: offset.y))
            case let .bottom(offset):
                offsetX = offset.x
                constraints.append(contentView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -offset.y))
            }
            constraints.append(contentView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: offsetX))

            // If applicable, set the custom view's constraints
            if let element = elements[.custom] {
                let view = element.view, layout = element.layout
                constraints += [
                    view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.edgeInsets.left),
                    view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.edgeInsets.right),
                    view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.edgeInsets.top),
                    view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -layout.edgeInsets.bottom)
                ]
                if let height = layout.height {
                    constraints.append(view.heightAnchor.constraint(equalToConstant: height))
                }
            } else {
                var previous: ElementView?
                for key in Element.allCases {
                    guard let element = elements[key] else { continue }

                    let view = element.view, layout = element.layout
                    if let previous { // Previous view
                        constraints.append(view.topAnchor.constraint(equalTo: previous.view.bottomAnchor, constant: layout.edgeInsets.top))
                    } else { // First view
                        constraints.append(view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: layout.edgeInsets.top))
                    }
                    constraints.append(view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: layout.edgeInsets.left))
                    constraints.append(view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -layout.edgeInsets.right))

                    if let height = layout.height {
                        constraints.append(view.heightAnchor.constraint(equalToConstant: height))
                    }
                    previous = element // Save previous view
                }
                if let last = previous { // Last view
                    constraints.append(last.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -last.layout.edgeInsets.bottom))
                }
            }
            NSLayoutConstraint.activate(constraints)
        }

        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            guard let hitView = super.hitTest(point, with: event) else { return nil }
            if hitView is UIControl {
                return hitView // Return any UIControl instance such as buttons, segmented controls, switches, etc.
            }

            if hitView.isEqual(contentView) || hitView.isEqual(elements[.custom]?.view) {
                return hitView // Return either the contentView or customView
            }
            return nil // Touch allowed to pass through
        }

        // MARK: - Accessibility

        /// Configures VoiceOver accessibility by building the `accessibilityElements` array
        /// from visible elements (image, title, detail, button, custom) with appropriate traits.
        private func configureAccessibility() {
            isAccessibilityElement = false
            accessibilityElements = []

            if let imageView = elements[.image]?.view as? UIImageView {
                imageView.isAccessibilityElement = true
                imageView.accessibilityTraits = .image
                // Uses the image's accessibilityIdentifier as the VoiceOver label,
                // allowing data source providers to pass descriptive text via UIImage.
                imageView.accessibilityLabel = imageView.image?.accessibilityIdentifier
                accessibilityElements?.append(imageView)
            }
            if let titleLabel = elements[.title]?.view as? UILabel {
                titleLabel.isAccessibilityElement = true
                titleLabel.accessibilityTraits = .header
                accessibilityElements?.append(titleLabel)
            }
            if let detailLabel = elements[.detail]?.view as? UILabel {
                detailLabel.isAccessibilityElement = true
                detailLabel.accessibilityTraits = .staticText
                accessibilityElements?.append(detailLabel)
            }
            if let button = elements[.button]?.view as? UIButton {
                button.isAccessibilityElement = true
                button.accessibilityTraits = .button
                accessibilityElements?.append(button)
            }
            if let customView = elements[.custom]?.view {
                customView.isAccessibilityElement = false
                accessibilityElements?.append(customView)
            }
        }

        // MARK: - UIGestureRecognizerDelegate
        override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            if let isTouchAllowed, isEqual(gestureRecognizer.view) {
                return isTouchAllowed()
            }
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }

        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                               shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            if gestureRecognizer.isEqual(tapGesture) || otherGestureRecognizer.isEqual(tapGesture) {
                return true
            }
            // defer to blankSlateDelegate's implementation if available
            return shouldRecognizeSimultaneously(otherGestureRecognizer, gestureRecognizer)
        }
    }
}

private struct ElementView {
    let view: UIView
    let layout: BlankSlate.Layout
}

@MainActor
extension Dictionary where Key == BlankSlate.Element, Value == ElementView {
    @discardableResult fileprivate mutating func updateLayout<T: UIView>(
        _ layout: BlankSlate.Layout, maker: (() -> T)? = nil, populator: (T) -> Void, for key: Key
    ) -> T {
        self[key]?.view.removeFromSuperview()
        let view = maker?() ?? T()
        populator(view)
        self[key] = Value(view: view, layout: layout)
        return view
    }
}
