//
//  RetryDemo.swift
//  BlankSlate Example
//
//  Demonstrates Convenience API:
//    reload(with:retry:) extension method, onRetryAsync
//    Uses StatusDrivenDataSource with async retry closure
//

import UIKit
import BlankSlate

class RetryDemo: UITableViewController {
    private var statusDS: BlankSlate.StatusDrivenDataSource!
    private var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Use default configuration (no customization needed)
        statusDS = BlankSlate.StatusDrivenDataSource(view: tableView)
        statusDS.transition = .bounce(duration: 0.4)

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh, target: self, action: #selector(startLoad)
        )

        startLoad()
    }

    @objc private func startLoad() {
        items.removeAll()
        tableView.reloadData()

        // Demonstrates reload(with:retry:) — the async retry closure
        tableView.bs.reload(with: .loading) { [weak self] in
            // This async closure is stored as onRetryAsync on the StatusDrivenDataSource
            // and is called when the user taps the retry button
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            await MainActor.run {
                self?.fetchData()
            }
        }

        // Simulate initial load
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.fetchData()
        }
    }

    private func fetchData() {
        // 50% chance of failure
        if Bool.random() {
            items = (1...10).map { "Fetched Item \($0)" }
            tableView.bs.reload(with: .success)
            tableView.reloadData()
        } else {
            items.removeAll()
            tableView.bs.reload(with: .failure) { [weak self] in
                // Async retry: called when user taps "Retry" button
                try? await Task.sleep(nanoseconds: 1_500_000_000)
                await MainActor.run {
                    self?.fetchData()
                }
            }
        }
    }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}
