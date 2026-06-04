//
//  ExtensionPropertiesDemo.swift
//  BlankSlate Example
//
//  Demonstrates extension properties and methods:
//    bs.isVisible, bs.view, bs.dataLoadStatus (read/write),
//    bs.reload(), bs.reloadBlankSlate(), bs.reloadBlankSlate(with:), bs.dismiss()
//

import UIKit
import BlankSlate

class ExtensionPropertiesDemo: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .plain)
    private let statusLabel = UILabel()
    private var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.bs.setDataSourceAndDelegate(self)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Inspect", style: .plain, target: self, action: #selector(inspectProperties)),
        ]

        let toolbar = UIStackView()
        toolbar.axis = .horizontal
        toolbar.distribution = .fillEqually
        toolbar.spacing = 4
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        let buttons: [(String, Selector)] = [
            ("reload()", #selector(doReload)),
            ("reloadBS()", #selector(doReloadBlankSlate)),
            ("reloadBS(.fail)", #selector(doReloadBlankSlateWithStatus)),
            ("dismiss()", #selector(doDismiss)),
            ("Add Data", #selector(addData)),
        ]
        for (title, action) in buttons {
            let btn = UIButton(type: .system)
            btn.setTitle(title, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 11)
            btn.titleLabel?.adjustsFontSizeToFitWidth = true
            btn.addTarget(self, action: action, for: .touchUpInside)
            toolbar.addArrangedSubview(btn)
        }

        view.addSubview(toolbar)
        NSLayoutConstraint.activate([
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            toolbar.heightAnchor.constraint(equalToConstant: 36),
        ])

        updateStatusDisplay()
    }

    private func setupUI() {
        statusLabel.numberOfLines = 0
        statusLabel.font = .monospacedSystemFont(ofSize: 12, weight: .regular)
        statusLabel.textColor = .secondaryLabel
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        let statusContainer = UIView()
        statusContainer.backgroundColor = .secondarySystemBackground
        statusContainer.layer.cornerRadius = 8
        statusContainer.translatesAutoresizingMaskIntoConstraints = false
        statusContainer.addSubview(statusLabel)

        view.addSubview(statusContainer)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            statusContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            statusContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            statusContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            statusLabel.topAnchor.constraint(equalTo: statusContainer.topAnchor, constant: 8),
            statusLabel.leadingAnchor.constraint(equalTo: statusContainer.leadingAnchor, constant: 12),
            statusLabel.trailingAnchor.constraint(equalTo: statusContainer.trailingAnchor, constant: -12),
            statusLabel.bottomAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: -8),

            tableView.topAnchor.constraint(equalTo: statusContainer.bottomAnchor, constant: 8),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
        ])
    }

    // MARK: - Actions

    @objc private func doReload() {
        items.removeAll()
        tableView.reloadData()
        tableView.bs.reload()
        updateStatusDisplay()
    }

    @objc private func doReloadBlankSlate() {
        tableView.bs.reloadBlankSlate()
        updateStatusDisplay()
    }

    @objc private func doReloadBlankSlateWithStatus() {
        tableView.bs.reloadBlankSlate(with: .failure)
        updateStatusDisplay()
    }

    @objc private func doDismiss() {
        tableView.bs.dismiss()
        updateStatusDisplay()
    }

    @objc private func addData() {
        items = (1...5).map { "Row \($0)" }
        tableView.reloadData()
        tableView.bs.reload(with: .success)
        updateStatusDisplay()
    }

    @objc private func inspectProperties() {
        updateStatusDisplay()
    }

    private func updateStatusDisplay() {
        let isVisible = tableView.bs.isVisible
        let bsView = tableView.bs.view
        let status = tableView.bs.dataLoadStatus

        statusLabel.text = """
        bs.isVisible:       \(isVisible)
        bs.view:            \(bsView.map { String(describing: type(of: $0)) } ?? "nil")
        bs.dataLoadStatus:  \(status.map { "\($0)" } ?? "nil")
        items.count:        \(items.count)
        """
    }
}

// MARK: - UITableView DataSource

extension ExtensionPropertiesDemo: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

// MARK: - BlankSlate

extension ExtensionPropertiesDemo: BlankSlate.DataSource, BlankSlate.Delegate {
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(systemName: "magnifyingglass")
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Extension Properties Demo", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.label
        ])
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Use the buttons below to test bs.reload(),\nbs.reloadBlankSlate(), bs.dismiss(), etc.\nTap 'Inspect' to refresh the status panel.", attributes: [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func blankSlateDidAppear(_ view: UIView) {
        updateStatusDisplay()
    }

    func blankSlateDidDisappear(_ view: UIView) {
        updateStatusDisplay()
    }
}
