//
//  BlankSlate.swift
//  BlankSlate <https://github.com/liam-i/BlankSlate>
//
//  Created by liam on 2024/3/8.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

/// A drop-in UIView extension for showing empty datasets whenever the view has no content to display.
/// - Attention: It will work automatically, by just conforming to `BlankSlate.DataSource`, and returning the data you want to show.
public struct BlankSlate {
    /// Type that acts as a generic extension point for all `BlankSlateExtended` types.
    ///
    /// Use this struct to access BlankSlate functionality through the `bs` namespace on any UIView:
    /// ```swift
    /// tableView.bs.dataSource = self
    /// tableView.bs.delegate = self
    /// tableView.bs.reload()
    /// ```
    public struct Extension<ExtendedViewType> {
        /// Stores the type or meta-type of any extended type.
        private let view: ExtendedViewType
        /// Create an instance from the provided value.
        /// - Parameter view: Instance being extended.
        public init(_ view: ExtendedViewType) {
            self.view = view
        }
    }

    /// Protocol describing the `bs` extension points for BlankSlate extended types.
    ///
    /// Conforming types gain a `bs` property that provides access to BlankSlate functionality.
    /// UIView already conforms to this protocol.
    public protocol Extended: AnyObject {
        /// Type being extended.
        associatedtype ExtendedType
        /// Instance BlankSlate extension point.
        var bs: Extension<ExtendedType> { get set }
    }
}
extension BlankSlate.Extended {
    /// Instance BlankSlate extension point.
    public var bs: BlankSlate.Extension<Self> {
        get { BlankSlate.Extension(self) }
        set {}
    }
}

extension UIView: BlankSlate.Extended {}

@MainActor
extension BlankSlate.Extension where ExtendedViewType: UIView {
    /// The empty datasets data source.
    ///
    /// Set this to an object conforming to ``BlankSlate/DataSource`` to provide content for the empty state.
    /// The data source is held weakly to avoid retain cycles.
    /// ```swift
    /// tableView.bs.dataSource = self
    /// ```
    public weak var dataSource: BlankSlate.DataSource? {
        get { view.blankSlateDataSource }
        set { view.blankSlateDataSource = newValue }
    }

    /// The empty datasets delegate.
    ///
    /// Set this to an object conforming to ``BlankSlate/Delegate`` to receive action callbacks and control behavior.
    /// The delegate is held weakly to avoid retain cycles.
    /// ```swift
    /// tableView.bs.delegate = self
    /// ```
    public weak var delegate: BlankSlate.Delegate? {
        get { view.blankSlateDelegate }
        set { view.blankSlateDelegate = newValue }
    }

    /// Set `BlankSlate.DataSource` & `BlankSlate.Delegate` at the same time.
    ///
    /// A convenience method for when the same object conforms to both protocols.
    /// ```swift
    /// tableView.bs.setDataSourceAndDelegate(self)
    /// ```
    /// - Parameter newValue: The object conforming to both `DataSource` and `Delegate`, or `nil` to clear.
    public func setDataSourceAndDelegate(_ newValue: (BlankSlate.DataSource & BlankSlate.Delegate)?) {
        view.blankSlateDataSource = newValue
        view.blankSlateDelegate = newValue
    }

    /// Data loading status.
    ///
    /// Use this property to track the current state of data loading.
    /// The blank slate can display different content based on this status.
    /// ```swift
    /// tableView.bs.dataLoadStatus = .loading
    /// // ... after loading completes
    /// tableView.bs.dataLoadStatus = .success
    /// ```
    public var dataLoadStatus: BlankSlate.DataLoadStatus? {
        get { view.dataLoadStatus }
        set { view.dataLoadStatus = newValue }
    }

    /// The currently displayed blank slate view, if any.
    ///
    /// Returns the internal `BlankSlate.View` instance that is currently added as a subview,
    /// or `nil` if no empty state is being displayed.
    public var view: UIView? {
        view.blankSlateView
    }

    /// Returns `true` if any empty dataset is currently visible.
    public var isVisible: Bool {
        view.isBlankSlateVisible
    }

    /// Reloads the empty dataset content receiver.
    ///
    /// - For `UITableView` or `UICollectionView`: calls `reloadData()` which triggers the blank slate evaluation automatically.
    /// - For `UIView` or `UIScrollView`: calls `reloadBlankSlateIfNeeded()` directly.
    public func reload() {
        view.reloadIfNeeded()
    }

    /// Set the `dataLoadStatus` property and then reload the empty data set.
    ///
    /// This is a convenience that combines setting the status and triggering a reload in one call.
    /// ```swift
    /// tableView.bs.reload(with: .failure)
    /// ```
    /// - Parameter dataLoadStatus: A new data loading state.
    public func reload(with dataLoadStatus: BlankSlate.DataLoadStatus?) {
        view.dataLoadStatus = dataLoadStatus
        view.reloadIfNeeded()
    }

    /// Reloads only the empty dataset content without triggering a full `reloadData()`.
    ///
    /// Call this method to force the empty dataset to refresh without triggering the table view
    /// or collection view's native `reloadData()`.
    public func reloadBlankSlate() {
        view.reloadBlankSlateIfNeeded()
    }

    /// Set the `dataLoadStatus` property and then reload only the blank slate view.
    ///
    /// Unlike ``reload(with:)``, this does not call `reloadData()` on table/collection views.
    /// - Parameter dataLoadStatus: A new data loading state.
    public func reloadBlankSlate(with dataLoadStatus: BlankSlate.DataLoadStatus?) {
        view.dataLoadStatus = dataLoadStatus
        view.reloadBlankSlateIfNeeded()
    }

    /// Dismisses the BlankSlate View.
    ///
    /// Removes the empty state view from the view hierarchy. If a ``BlankSlate/Delegate`` is set,
    /// scroll behavior is restored based on ``BlankSlate/Delegate/shouldAllowScrollAfterBlankSlateDisappear(_:)``
    /// (defaults to `true`).
    public func dismiss() {
        view.dismissBlankSlateIfNeeded()
    }
}
