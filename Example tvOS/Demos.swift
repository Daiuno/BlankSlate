//
//  Demos.swift
//  Example tvOS
//
//  Comprehensive demos covering 100% of BlankSlate API on tvOS.
//
//  Created by Liam on 2024/2/6.
//  Copyright © 2024 Liam. All rights reserved.
//

import UIKit
import BlankSlate

// MARK: - TableView Demo
// Demonstrates: bs.setDataSourceAndDelegate, image, title, detail, buttonTitle, didTapButton

class TableViewDemoVC: UITableViewController, BlankSlate.DataSource, BlankSlate.Delegate {
    private var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bs.setDataSourceAndDelegate(self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggle))
    }

    @objc private func toggle() {
        items = items.isEmpty ? ["Item 1", "Item 2", "Item 3"] : []
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { items.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }

    // MARK: DataSource
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(named: "icon_wwdc")
    }
    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "No Items", attributes: [
            .font: UIFont.systemFont(ofSize: 38, weight: .medium),
            .foregroundColor: UIColor.label
        ])
    }
    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Press \"Toggle\" to add items.", attributes: [
            .font: UIFont.systemFont(ofSize: 24),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }
    func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? {
        guard state == .normal else { return nil }
        return NSAttributedString(string: "Add Items", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold),
            .foregroundColor: UIColor.systemBlue
        ])
    }
    func blankSlate(_ view: UIView, configure button: UIButton) {
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
    }
    func transition(forBlankSlate view: UIView) -> BlankSlate.Transition {
        .fadeIn(duration: 0.3)
    }

    // MARK: Delegate
    func blankSlate(_ view: UIView, didTapButton sender: UIButton) { toggle() }
    func blankSlate(_ view: UIView, didTapView sender: UIView) { toggle() }
    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { true }
}

// MARK: - CollectionView Demo
// Demonstrates: bs.dataSource, bs.delegate (separate), imageAlpha, imageTintColor

class CollectionViewDemoVC: UICollectionViewController, BlankSlate.DataSource, BlankSlate.Delegate {
    private var items: [String] = []

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 200)
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.bs.dataSource = self
        collectionView.bs.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggle))
    }

    @objc private func toggle() {
        items = items.isEmpty ? ["A", "B"] : []
        collectionView.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { items.count }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .gray
        return cell
    }

    // MARK: DataSource
    func image(forBlankSlate view: UIView) -> UIImage? { UIImage(systemName: "square.grid.2x2") }
    func imageAlpha(forBlankSlate view: UIView) -> CGFloat { 0.6 }
    func imageTintColor(forBlankSlate view: UIView) -> UIColor? { .systemPurple }
    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Empty Collection", attributes: [
            .font: UIFont.systemFont(ofSize: 32, weight: .medium), .foregroundColor: UIColor.label
        ])
    }
    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Demonstrates imageAlpha (0.6) and imageTintColor (.systemPurple)", attributes: [
            .font: UIFont.systemFont(ofSize: 20), .foregroundColor: UIColor.secondaryLabel
        ])
    }

    // MARK: Delegate
    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { false }
}

// MARK: - PlainView Demo
// Demonstrates: UIView bs.reload(), bs.dismiss(), imageAnimation, backgroundGradient, backgroundColor, transition

class PlainViewDemoVC: UIViewController, BlankSlate.DataSource, BlankSlate.Delegate {
    private let contentView = UIView()
    private var showBlankSlate = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        contentView.frame = view.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(contentView)

        contentView.bs.dataSource = self
        contentView.bs.delegate = self
        contentView.bs.reload()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggle))
    }

    @objc private func toggle() {
        showBlankSlate.toggle()
        if showBlankSlate {
            contentView.bs.reload()
        } else {
            contentView.bs.dismiss()
        }
    }

    // MARK: DataSource
    func image(forBlankSlate view: UIView) -> UIImage? { UIImage(systemName: "sparkles") }
    func imageAnimation(forBlankSlate view: UIView) -> CAAnimation? {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 3.0
        rotation.repeatCount = .infinity
        return rotation
    }
    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Plain UIView", attributes: [
            .font: UIFont.systemFont(ofSize: 36, weight: .bold), .foregroundColor: UIColor.white
        ])
    }
    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Demonstrates imageAnimation + backgroundGradient", attributes: [
            .font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.white.withAlphaComponent(0.8)
        ])
    }
    func backgroundColor(forBlankSlate view: UIView) -> UIColor? { .clear }
    func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer? {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.systemPurple.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        return gradient
    }
    func transition(forBlankSlate view: UIView) -> BlankSlate.Transition {
        .fadeIn(duration: 0.5)
    }

    // MARK: Delegate
    func blankSlateShouldDisplay(_ view: UIView) -> Bool { showBlankSlate }
    func blankSlateShouldAllowTouch(_ view: UIView) -> Bool { true }
}

// MARK: - Full API Demo
// Demonstrates: ALL DataSource + Delegate methods, DataLoadStatus, Alignment cycling

class FullAPIDemoVC: UITableViewController, BlankSlate.DataSource, BlankSlate.Delegate {
    private var status: BlankSlate.DataLoadStatus = .loading
    private var alignmentIndex = 0
    private let alignments: [BlankSlate.Alignment] = [
        .center(.offset(y: -40)), .top(.offset(y: 80)), .bottom(.offset(y: -60)), .center()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bs.setDataSourceAndDelegate(self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cycle", style: .plain, target: self, action: #selector(cycleState))
        loadData()
    }

    @objc private func cycleState() {
        alignmentIndex += 1
        tableView.bs.reloadBlankSlate()
    }

    private func loadData() {
        status = .loading
        tableView.bs.reloadBlankSlate()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.status = .failure
            self?.tableView.bs.reloadBlankSlate()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }

    // MARK: DataSource - ALL methods
    func image(forBlankSlate view: UIView) -> UIImage? {
        status == .loading ? nil : UIImage(systemName: "exclamationmark.triangle")
    }
    func imageAlpha(forBlankSlate view: UIView) -> CGFloat { 0.8 }
    func imageTintColor(forBlankSlate view: UIView) -> UIColor? { .systemOrange }
    func imageAnimation(forBlankSlate view: UIView) -> CAAnimation? { nil }
    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        let text = status == .loading ? "Loading..." : "Load Failed"
        return NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 34, weight: .medium), .foregroundColor: UIColor.label
        ])
    }
    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        guard status == .failure else { return nil }
        let desc: String
        switch alignments[alignmentIndex % alignments.count] {
        case .center(let o): desc = ".center(y: \(o.y))"
        case .top(let o): desc = ".top(y: \(o.y))"
        case .bottom(let o): desc = ".bottom(y: \(o.y))"
        }
        return NSAttributedString(string: "Alignment: \(desc)\nPress \"Cycle\" to change", attributes: [
            .font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.secondaryLabel
        ])
    }
    func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? {
        guard self.status == .failure, state == .normal else { return nil }
        return NSAttributedString(string: "Retry", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .semibold), .foregroundColor: UIColor.systemBlue
        ])
    }
    func buttonBackgroundImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage? { nil }
    func buttonImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage? { nil }
    func blankSlate(_ view: UIView, configure button: UIButton) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
    }
    func customView(forBlankSlate view: UIView) -> UIView? {
        guard status == .loading else { return nil }
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        return spinner
    }
    func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout {
        switch element {
        case .image: return .init(edgeInsets: .init(top: 11, left: 16, bottom: 20, right: 16), height: 120)
        default: return .init()
        }
    }
    func alignment(forBlankSlate view: UIView) -> BlankSlate.Alignment {
        alignments[alignmentIndex % alignments.count]
    }
    func backgroundColor(forBlankSlate view: UIView) -> UIColor? { .clear }
    func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer? { nil }
    // Deprecated: kept for API coverage demo. Returns 0.0 (no-op) — use transition() instead.
    func fadeInDuration(forBlankSlate view: UIView) -> TimeInterval { 0.0 }
    func transition(forBlankSlate view: UIView) -> BlankSlate.Transition { .fadeIn(duration: 0.3) }

    // MARK: Delegate - ALL methods
    func blankSlateShouldBeForcedToDisplay(_ view: UIView) -> Bool { true }
    func blankSlateShouldDisplay(_ view: UIView) -> Bool { true }
    func blankSlateShouldBeInsertedAtBack(_ view: UIView) -> Bool { true }
    func blankSlateShouldAllowTouch(_ view: UIView) -> Bool { true }
    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { false }
    func shouldAllowScrollAfterBlankSlateDisappear(_ scrollView: UIScrollView) -> Bool { true }
    func blankSlate(_ view: UIView, didTapView sender: UIView) { loadData() }
    func blankSlate(_ view: UIView, didTapButton sender: UIButton) { loadData() }
    func blankSlateWillAppear(_ view: UIView) { print("tvOS: blankSlateWillAppear") }
    func blankSlateDidAppear(_ view: UIView) { print("tvOS: blankSlateDidAppear") }
    func blankSlateWillDisappear(_ view: UIView) { print("tvOS: blankSlateWillDisappear") }
    func blankSlateDidDisappear(_ view: UIView) { print("tvOS: blankSlateDidDisappear") }
}

// MARK: - Transition Demo
// Demonstrates: All 6 Transition types

class TransitionDemoVC: UITableViewController, BlankSlate.DataSource, BlankSlate.Delegate {
    private let transitions: [(String, BlankSlate.Transition)] = [
        ("None", .none),
        ("Fade In (0.5s)", .fadeIn(duration: 0.5)),
        ("Slide Up (0.4s)", .slideUp(duration: 0.4)),
        ("Slide Down (0.4s)", .slideDown(duration: 0.4)),
        ("Scale (0.5s)", .scale(duration: 0.5)),
        ("Bounce (0.6s)", .bounce(duration: 0.6)),
    ]
    private var currentIndex = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bs.setDataSourceAndDelegate(self)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTransition))
    }

    @objc private func nextTransition() {
        currentIndex = (currentIndex + 1) % transitions.count
        tableView.bs.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.tableView.bs.reloadBlankSlate()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: transitions[currentIndex].0, attributes: [
            .font: UIFont.systemFont(ofSize: 36, weight: .bold), .foregroundColor: UIColor.label
        ])
    }
    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Press \"Next\" to cycle transitions", attributes: [
            .font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.secondaryLabel
        ])
    }
    func transition(forBlankSlate view: UIView) -> BlankSlate.Transition { transitions[currentIndex].1 }
    func blankSlateShouldBeForcedToDisplay(_ view: UIView) -> Bool { true }
    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { false }
}

// MARK: - StatusDriven Demo
// Demonstrates: StatusDrivenDataSource, StatusConfiguration, StateContent

class StatusDrivenDemoVC: UITableViewController {
    private var statusDS: BlankSlate.StatusDrivenDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let config = BlankSlate.StatusConfiguration(
            loading: .init(customView: { let v = UIActivityIndicatorView(style: .large); v.startAnimating(); return v }()),
            empty: .init(
                image: UIImage(systemName: "tray"),
                title: NSAttributedString(string: "Nothing Here", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .medium)]),
                detail: NSAttributedString(string: "Content will appear when available.", attributes: [.font: UIFont.systemFont(ofSize: 20)])
            ),
            failure: .init(
                title: NSAttributedString(string: "Something Went Wrong", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .medium)]),
                buttonTitle: NSAttributedString(string: "Retry", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.systemBlue])
            )
        )
        statusDS = BlankSlate.StatusDrivenDataSource(view: tableView, configuration: config)
        statusDS.onRetry = { [weak self] in self?.simulateLoad() }
        statusDS.onTapView = { print("tvOS: StatusDriven view tapped") }
        simulateLoad()
    }

    private func simulateLoad() {
        tableView.bs.reload(with: .loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.tableView.bs.reload(with: .failure)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
}

// MARK: - Retry Demo
// Demonstrates: reload(with:retry:), onRetryAsync, StatusDrivenDataSource.transition

class RetryDemoVC: UITableViewController {
    private var statusDS: BlankSlate.StatusDrivenDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        let config = BlankSlate.StatusConfiguration(
            failure: .init(
                image: UIImage(systemName: "arrow.clockwise"),
                title: NSAttributedString(string: "Load Failed", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .medium)]),
                buttonTitle: NSAttributedString(string: "Retry (async)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.systemBlue])
            )
        )
        statusDS = BlankSlate.StatusDrivenDataSource(view: tableView, configuration: config)

        // Explicitly set transition property
        statusDS.transition = .scale(duration: 0.4)

        // Explicitly set onRetryAsync
        statusDS.onRetryAsync = { [weak self] in
            await MainActor.run { self?.tableView.bs.reload(with: .loading) }
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            await MainActor.run { self?.tableView.bs.reload(with: .failure) }
        }

        // Also demonstrate reload(with:retry:) convenience
        loadWithRetry()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadTapped))
    }

    @objc private func reloadTapped() { loadWithRetry() }

    private func loadWithRetry() {
        // reload(with:retry:) internally sets onRetryAsync on the StatusDrivenDataSource
        tableView.bs.reload(with: .loading) { [weak self] in
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run { self?.tableView.bs.reload(with: .failure) }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
}

// MARK: - Extension Properties Demo
// Demonstrates: bs.isVisible, bs.view, bs.reload(), bs.reloadBlankSlate(), bs.dismiss()

class ExtensionDemoVC: UITableViewController, BlankSlate.DataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bs.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfo))
    }

    @objc private func showInfo() {
        let isVisible = tableView.bs.isVisible
        let viewDesc = tableView.bs.view != nil ? "exists" : "nil"
        let alert = UIAlertController(
            title: "Extension Properties",
            message: "bs.isVisible: \(isVisible)\nbs.view: \(viewDesc)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss BlankSlate", style: .destructive) { [weak self] _ in
            self?.tableView.bs.dismiss()
        })
        alert.addAction(UIAlertAction(title: "Reload BlankSlate", style: .default) { [weak self] _ in
            self?.tableView.bs.reloadBlankSlate()
        })
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(alert, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Extension Demo", attributes: [
            .font: UIFont.systemFont(ofSize: 34, weight: .medium), .foregroundColor: UIColor.label
        ])
    }
    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Press \"Info\" to inspect bs.isVisible and bs.view", attributes: [
            .font: UIFont.systemFont(ofSize: 22), .foregroundColor: UIColor.secondaryLabel
        ])
    }
}
