//
//  Impl.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate>
//
//  Created by Liam on 2020/2/6.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

/// Internal UIView extension providing the empty dataset mechanism.
///
/// Uses Objective-C associated objects to store data source, delegate, status, and the blank slate view.
/// Method swizzling injects `reloadBlankSlateIfNeeded()` into `UITableView.reloadData()`,
/// `UITableView.endUpdates()`, and `UICollectionView.reloadData()` so the empty state
/// updates automatically without caller intervention.
extension UIView {
    /// The data source that provides content and configuration for the empty state.
    /// Setting this to non-nil triggers method swizzling for the appropriate scroll view type.
    /// Setting it to nil dismisses any visible empty state.
    weak var blankSlateDataSource: BlankSlate.DataSource? {
        get { (objc_getAssociatedObject(self, &kBlankSlateDataSourceKey) as? WeakObject)?.value as? BlankSlate.DataSource }
        set {
            if newValue == nil || blankSlateDataSource == nil {
                dismissBlankSlateIfNeeded()
            }

            objc_setAssociatedObject(self, &kBlankSlateDataSourceKey, WeakObject(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            // We add method sizzling for injecting `reloadBlankSlateIfNeeded()` implementation to the native `reloadData()` implementation
            // Exclusively for UITableView, we also inject `reloadBlankSlateIfNeeded()` to `endUpdates()`
            switch self {
            case is UITableView:
                swizzleIfNeeded(UITableView.self, #selector(UITableView.reloadData))
                swizzleIfNeeded(UITableView.self, #selector(UITableView.endUpdates))
            case is UICollectionView:
                swizzleIfNeeded(UICollectionView.self, #selector(UICollectionView.reloadData))
            default:
                break
            }
        }
    }

    /// The delegate that receives lifecycle and interaction callbacks.
    /// Setting it to nil dismisses any visible empty state.
    weak var blankSlateDelegate: BlankSlate.Delegate? {
        get { (objc_getAssociatedObject(self, &kBlankSlateDelegateKey) as? WeakObject)?.value as? BlankSlate.Delegate }
        set {
            if newValue == nil {
                dismissBlankSlateIfNeeded()
            }
            objc_setAssociatedObject(self, &kBlankSlateDelegateKey, WeakObject(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    /// The current data load status stored via associated object.
    /// Used by `StatusDrivenDataSource` to determine which state content to display.
    var dataLoadStatus: BlankSlate.DataLoadStatus? {
        get { objc_getAssociatedObject(self, &kBlankSlateStatusKey) as? BlankSlate.DataLoadStatus }
        set { objc_setAssociatedObject(self, &kBlankSlateStatusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Triggers a reload on the underlying view (calls `reloadData()` for table/collection views).
    /// For plain UIViews, directly calls `reloadBlankSlateIfNeeded()`.
    func reloadIfNeeded() {
        switch self {
        case let tableView as UITableView:              tableView.reloadData()
        case let collectionView as UICollectionView:    collectionView.reloadData()
        default:                                        reloadBlankSlateIfNeeded()
        }
    }

    /// The currently displayed `BlankSlate.View` instance, stored as an associated object.
    var blankSlateView: BlankSlate.View? {
        get { objc_getAssociatedObject(self, &kBlankSlateViewKey) as? BlankSlate.View }
        set { objc_setAssociatedObject(self, &kBlankSlateViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Whether the empty state view is currently visible (exists and not hidden).
    var isBlankSlateVisible: Bool {
        guard let blankSlateView else { return false }
        return blankSlateView.isHidden == false
    }

    /// Dismisses the empty state view if currently shown.
    /// Notifies the delegate before and after removal, restores scroll if applicable.
    func dismissBlankSlateIfNeeded() {
        guard let blankSlateView else { return }
        blankSlateDelegate?.blankSlateWillDisappear(self) // Notifies that the empty dataset view will disappear

        blankSlateView.prepareForReuse()
        blankSlateView.removeFromSuperview()
        self.blankSlateView = nil

        if let scrollView = self as? UIScrollView {
            scrollView.isScrollEnabled = blankSlateDelegate?.shouldAllowScrollAfterBlankSlateDisappear(scrollView) ?? true
        }
        blankSlateDelegate?.blankSlateDidDisappear(self) // Notifies that the empty dataset view did disappear
    }

    /// Evaluates whether the empty state should be shown or hidden based on item count,
    /// delegate permissions, and forced display settings. Called automatically after swizzled reloads.
    func reloadBlankSlateIfNeeded() {
        guard let blankSlateDataSource else {
            return dismissBlankSlateIfNeeded()
        }

        if ((blankSlateDelegate?.blankSlateShouldDisplay(self) ?? true) && (itemsCount == 0))
            || (blankSlateDelegate?.blankSlateShouldBeForcedToDisplay(self) ?? false) {
            blankSlateDelegate?.blankSlateWillAppear(self) // Notifies that the empty dataset view will appear

            configureView(blankSlateView ?? makeBlankSlateView(), with: blankSlateDataSource)

            blankSlateDelegate?.blankSlateDidAppear(self) // Notifies that the empty dataset view did appear
        } else if isBlankSlateVisible {
            dismissBlankSlateIfNeeded()
        }
    }

    /// Configures the blank slate view with content from the data source, applies background,
    /// gradient, alignment, user interaction, constraints, and transition animation.
    private func configureView(_ view: BlankSlate.View, with blankSlateDataSource: BlankSlate.DataSource) {
        var transition: BlankSlate.Transition = .none
        if view.superview == nil {
            // Determine transition: prefer new API, fall back to legacy fadeInDuration
            let newTransition = blankSlateDataSource.transition(forBlankSlate: self)
            if case .none = newTransition {
                let legacyDuration = blankSlateDataSource.fadeInDuration(forBlankSlate: self)
                if legacyDuration > 0.0 {
                    transition = .fadeIn(duration: legacyDuration)
                }
            } else {
                transition = newTransition
            }
            view.alpha = 0.0

            if subviews.count > 1 && blankSlateDelegate?.blankSlateShouldBeInsertedAtBack(self) ?? true {
                insertSubview(view, at: 0)
            } else {
                addSubview(view)
            }
        }

        // Removing view resetting the view and its constraints it very important to guarantee a good state
        view.prepareForReuse()

        configureElements(for: view, with: blankSlateDataSource)

        // Configure offset
        view.alignment = blankSlateDataSource.alignment(forBlankSlate: self)

        // Configure the empty dataset view
        let bgColor = blankSlateDataSource.backgroundColor(forBlankSlate: self)
        view.backgroundColor = bgColor ?? .clear
        // Remove any previously added gradient layers before adding new one
        view.layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach { $0.removeFromSuperlayer() }
        if let backgroundGradient = blankSlateDataSource.backgroundGradient(forBlankSlate: self) {
            view.layer.insertSublayer(backgroundGradient, at: 0)
        }
        view.isHidden = false
        view.isUserInteractionEnabled = blankSlateDelegate?.blankSlateShouldAllowTouch(self) ?? true // Configure empty dataset userInteraction permission
        view.setupConstraints()

        UIView.performWithoutAnimation { view.layoutIfNeeded() }

        if let scrollView = self as? UIScrollView {
            scrollView.isScrollEnabled = blankSlateDelegate?.blankSlateShouldAllowScroll(scrollView) ?? false // Configure scroll permission
        }

        applyTransition(transition, to: view)
    }

    /// Applies the specified transition animation to the blank slate view.
    /// Supports fade, slide up/down, scale, and bounce spring animations.
    private func applyTransition(_ transition: BlankSlate.Transition, to view: UIView) {
        switch transition {
        case .none:
            view.alpha = 1.0
        case .fadeIn(let duration):
            UIView.animate(withDuration: duration) { view.alpha = 1.0 }
        case .slideUp(let duration):
            view.transform = CGAffineTransform(translationX: 0, y: 40)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
                view.alpha = 1.0
                view.transform = .identity
            }
        case .slideDown(let duration):
            view.transform = CGAffineTransform(translationX: 0, y: -40)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
                view.alpha = 1.0
                view.transform = .identity
            }
        case .scale(let duration):
            view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
                view.alpha = 1.0
                view.transform = .identity
            }
        case .bounce(let duration):
            view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8) {
                view.alpha = 1.0
                view.transform = .identity
            }
        }
    }

    /// Populates the blank slate view with image, title, detail, button, or custom view
    /// elements by querying the data source for each.
    private func configureElements(for view: BlankSlate.View, with blankSlateDataSource: BlankSlate.DataSource) {
        // If a non-nil custom view is available, let's configure it instead
        if let customView = blankSlateDataSource.customView(forBlankSlate: self) {
            return view.setCustomView(customView, layout: blankSlateDataSource.layout(forBlankSlate: self, for: .custom))
        }

        // Configure Image
        if let image = blankSlateDataSource.image(forBlankSlate: self) {
            let tintColor = blankSlateDataSource.imageTintColor(forBlankSlate: self)
            let imageView = view.makeImageView(with: blankSlateDataSource.layout(forBlankSlate: self, for: .image))
            imageView.image = image.withRenderingMode(tintColor != nil ? .alwaysTemplate : .alwaysOriginal)
            imageView.tintColor = tintColor
            imageView.alpha = blankSlateDataSource.imageAlpha(forBlankSlate: self)

            // Configure image view animation
            if let animation = blankSlateDataSource.imageAnimation(forBlankSlate: self) {
                imageView.layer.add(animation, forKey: kEmptyImageViewAnimationKey)
            }
        }

        // Configure title label
        if let titleString = blankSlateDataSource.title(forBlankSlate: self) {
            view.makeTitleLabel(with: blankSlateDataSource.layout(forBlankSlate: self, for: .title)).attributedText = titleString
        }

        // Configure detail label
        if let detailString = blankSlateDataSource.detail(forBlankSlate: self) {
            view.makeDetailLabel(with: blankSlateDataSource.layout(forBlankSlate: self, for: .detail)).attributedText = detailString
        }

        // Configure button
        if let buttonImage = blankSlateDataSource.buttonImage(forBlankSlate: self, for: .normal) {
            let button = view.makeButton(with: blankSlateDataSource.layout(forBlankSlate: self, for: .button))
            button.setImage(buttonImage, for: .normal)
            button.setImage(blankSlateDataSource.buttonImage(forBlankSlate: self, for: .highlighted), for: .highlighted)
            blankSlateDataSource.blankSlate(self, configure: button)
        } else if let titleString = blankSlateDataSource.buttonTitle(forBlankSlate: self, for: .normal) {
            let button = view.makeButton(with: blankSlateDataSource.layout(forBlankSlate: self, for: .button))
            button.setAttributedTitle(titleString, for: .normal)
            button.setAttributedTitle(blankSlateDataSource.buttonTitle(forBlankSlate: self, for: .highlighted), for: .highlighted)
            button.setBackgroundImage(blankSlateDataSource.buttonBackgroundImage(forBlankSlate: self, for: .normal), for: .normal)
            button.setBackgroundImage(blankSlateDataSource.buttonBackgroundImage(forBlankSlate: self, for: .highlighted), for: .highlighted)
            blankSlateDataSource.blankSlate(self, configure: button)
        }
    }

    /// Counts the total number of items across all sections in the table/collection view.
    /// Returns 0 for plain UIViews (always treated as empty).
    private var itemsCount: Int {
        var items: Int = 0
        switch self {
        case let tableView as UITableView: // UITableView support
            guard let dataSource = tableView.dataSource else { return items }
            let sections = dataSource.numberOfSections?(in: tableView) ?? 1
            (0..<sections).forEach {
                items += dataSource.tableView(tableView, numberOfRowsInSection: $0)
            }
        case let collectionView as UICollectionView: // UICollectionView support
            guard let dataSource = collectionView.dataSource else { return items }
            let sections = dataSource.numberOfSections?(in: collectionView) ?? 1
            (0..<sections).forEach {
                items += dataSource.collectionView(collectionView, numberOfItemsInSection: $0)
            }
        default:
            break
        }
        return items
    }

    /// Creates and configures a new `BlankSlate.View` instance, wiring up touch, gesture,
    /// and tap callbacks to the delegate.
    private func makeBlankSlateView() -> BlankSlate.View {
        let view = BlankSlate.View(frame: .zero)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.isHidden = true
        view.isTouchAllowed = { [weak self] in
            guard let self, let blankSlateDelegate else { return true }
            return blankSlateDelegate.blankSlateShouldAllowTouch(self)
        }
        view.shouldRecognizeSimultaneously = { [weak self](other, of) in
            guard let self, let blankSlateDelegate else { return false }
            if let scrollView = blankSlateDelegate as? UIScrollView, scrollView == self {
                return false
            }
            if let delegate = blankSlateDelegate as? UIGestureRecognizerDelegate,
               let result = delegate.gestureRecognizer?(of, shouldRecognizeSimultaneouslyWith: other) {
                return result
            }
            return false
        }
        view.didTap = { [weak self] in
            guard let self, let blankSlateDelegate else { return }
            if let button = $0 as? UIButton {
                return blankSlateDelegate.blankSlate(self, didTapButton: button)
            }
            blankSlateDelegate.blankSlate(self, didTapView: $0)
        }
        blankSlateView = view
        return view
    }

    /// Performs method swizzling on the given class/selector pair to inject `reloadBlankSlateIfNeeded()`.
    /// Uses a lookup table to ensure each class+selector combination is swizzled only once.
    private func swizzleIfNeeded(_ originalClass: AnyClass, _ originalSelector: Selector) {
        // Check if the target responds to selector
        guard responds(to: originalSelector) else { return assertionFailure() }

        kIMPLookupLock.lock()
        defer { kIMPLookupLock.unlock() }

        // We make sure that setImplementation is called once per class kind, UITableView or UICollectionView.
        let originalStringSelector = NSStringFromSelector(originalSelector)
        for info in kIMPLookupTable.values where (info.selector == originalStringSelector && isKind(of: info.owner)) {
            return
        }

        // If the implementation for this class already exist, skip!!
        let key = "\(NSStringFromClass(originalClass))_\(originalStringSelector)"
        guard kIMPLookupTable[key] == nil else { return }

        // Swizzle by injecting additional implementation
        guard let originalMethod = class_getInstanceMethod(originalClass, originalSelector) else { return assertionFailure() }
        let originalImplementation = method_getImplementation(originalMethod)

        typealias OriginalIMP = @convention(c) (UIScrollView, Selector) -> Void

        let originalClosure = unsafeBitCast(originalImplementation, to: OriginalIMP.self)

        let swizzledBlock: @convention(block) (UIScrollView) -> Void = { owner in
            originalClosure(owner, originalSelector) // Call original implementation

            // We then inject the additional implementation for reloading the empty dataset
            // Doing it after calling the original implementation ensures the data source has updated its item count.
            owner.reloadBlankSlateIfNeeded()
        }

        let swizzledImplementation = imp_implementationWithBlock(unsafeBitCast(swizzledBlock, to: AnyObject.self))
        method_setImplementation(originalMethod, swizzledImplementation)

        kIMPLookupTable[key] = (originalClass, originalStringSelector) // Store the new implementation in the lookup table
    }
}

// MARK: - WeakObject

/// A weak wrapper used for associated objects to avoid retain cycles with data source and delegate.
private class WeakObject {
    private(set) weak var value: AnyObject?

    init?(_ value: AnyObject?) {
        guard let value else { return nil }
        self.value = value
    }

    deinit {
        #if DEBUG
        print("👍🏻👍🏻👍🏻 WeakObject is released.")
        #endif
    }
}

// MARK: - Private keys

#if swift(>=5.10)
nonisolated(unsafe) private var kBlankSlateDataSourceKey: Void?
nonisolated(unsafe) private var kBlankSlateDelegateKey: Void?
nonisolated(unsafe) private var kBlankSlateViewKey: Void?
nonisolated(unsafe) private var kBlankSlateStatusKey: Void?
private let kEmptyImageViewAnimationKey = "com.liam.blankSlate.imageViewAnimation"
private let kIMPLookupLock = NSLock()
nonisolated(unsafe) private var kIMPLookupTable = [String: (owner: AnyClass, selector: String)](minimumCapacity: 3) // 3 represent the supported base classes
#else
private var kBlankSlateDataSourceKey: Void?
private var kBlankSlateDelegateKey: Void?
private var kBlankSlateViewKey: Void?
private var kBlankSlateStatusKey: Void?
private let kEmptyImageViewAnimationKey = "com.liam.blankSlate.imageViewAnimation"
private let kIMPLookupLock = NSLock()
private var kIMPLookupTable = [String: (owner: AnyClass, selector: String)](minimumCapacity: 3) // 3 represent the supported base classes
#endif
