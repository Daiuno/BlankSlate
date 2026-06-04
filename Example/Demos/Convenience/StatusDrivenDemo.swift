//
//  StatusDrivenDemo.swift
//  BlankSlate Example
//
//  Demonstrates Convenience API:
//    StatusConfiguration, StateContent, StatusDrivenDataSource,
//    onRetry, onRetryAsync, onTapView, transition property
//

import UIKit
import BlankSlate

class StatusDrivenDemo: UITableViewController {
    /// The StatusDrivenDataSource manages everything - zero manual DataSource/Delegate code needed
    private var statusDS: BlankSlate.StatusDrivenDataSource!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Custom configuration for each state
        let config = BlankSlate.StatusConfiguration(
            loading: .init(
                customView: makeLoadingView()
            ),
            empty: .init(
                image: UIImage(systemName: "tray"),
                title: NSAttributedString(string: "Nothing Here", attributes: [
                    .font: UIFont.systemFont(ofSize: 22, weight: .medium),
                    .foregroundColor: UIColor.secondaryLabel
                ]),
                detail: NSAttributedString(string: "Your collection is empty.\nTap to simulate loading.", attributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.tertiaryLabel
                ])
            ),
            failure: .init(
                image: UIImage(systemName: "exclamationmark.icloud"),
                title: NSAttributedString(string: "Connection Error", attributes: [
                    .font: UIFont.systemFont(ofSize: 22, weight: .medium),
                    .foregroundColor: UIColor.label
                ]),
                detail: NSAttributedString(string: "Could not reach the server.", attributes: [
                    .font: UIFont.systemFont(ofSize: 14),
                    .foregroundColor: UIColor.secondaryLabel
                ]),
                buttonTitle: NSAttributedString(string: "Retry", attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                    .foregroundColor: UIColor.systemBlue
                ])
            )
        )

        // Create StatusDrivenDataSource — it auto-registers as bs.dataSource & bs.delegate
        statusDS = BlankSlate.StatusDrivenDataSource(view: tableView, configuration: config)

        // Configure callbacks
        statusDS.onRetry = { [weak self] in
            self?.simulateLoad()
        }
        statusDS.onTapView = { [weak self] in
            self?.simulateLoad()
        }
        statusDS.transition = .slideUp(duration: 0.35)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Load", style: .plain, target: self, action: #selector(startLoad)),
            UIBarButtonItem(title: "Empty", style: .plain, target: self, action: #selector(showEmpty)),
            UIBarButtonItem(title: "Fail", style: .plain, target: self, action: #selector(showFailure)),
        ]

        // Start with empty state
        tableView.bs.reload(with: .success)
    }

    @objc private func startLoad() { simulateLoad() }
    @objc private func showEmpty() { tableView.bs.reload(with: .success) }
    @objc private func showFailure() { tableView.bs.reload(with: .failure) }

    private func simulateLoad() {
        tableView.bs.reload(with: .loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            // Randomly succeed or fail
            let status: BlankSlate.DataLoadStatus = Bool.random() ? .success : .failure
            self?.tableView.bs.reload(with: status)
        }
    }

    private func makeLoadingView() -> UIView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12

        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        stack.addArrangedSubview(spinner)

        let label = UILabel()
        label.text = "Loading..."
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        stack.addArrangedSubview(label)

        return stack
    }

    // MARK: - UITableView (return 0 rows to keep blank slate visible)

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
}
