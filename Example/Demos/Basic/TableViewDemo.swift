//
//  TableViewDemo.swift
//  BlankSlate Example
//
//  Demonstrates: bs.setDataSourceAndDelegate(_:), title, detail, image, buttonTitle,
//  blankSlateShouldAllowScroll, blankSlate(_:didTapView:), blankSlate(_:didTapButton:)
//

import UIKit
import BlankSlate

class TableViewDemo: UITableViewController {
    private var items: [String] = []
    private let searchController = UISearchController(searchResultsController: nil)

    private var filteredItems: [String] {
        guard searchController.isActive,
              let text = searchController.searchBar.text, !text.isEmpty else {
            return items
        }
        return items.filter { $0.lowercased().contains(text.lowercased()) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search items..."
        navigationItem.searchController = searchController
        definesPresentationContext = true

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItems)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeAll)),
        ]

        tableView.bs.setDataSourceAndDelegate(self)
    }

    @objc private func addItems() {
        items = (1...20).map { "Item \($0)" }
        tableView.reloadData()
    }

    @objc private func removeAll() {
        items.removeAll()
        tableView.reloadData()
    }

    // MARK: - UITableView DataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredItems[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let item = filteredItems[indexPath.row]
        items.removeAll { $0 == item }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UISearchResultsUpdating

extension TableViewDemo: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}

// MARK: - BlankSlate DataSource & Delegate

extension TableViewDemo: BlankSlate.DataSource, BlankSlate.Delegate {
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(systemName: "tray")
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        let text = searchController.isActive ? "No Results Found" : "No Items Yet"
        return NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        let text = searchController.isActive
            ? "Try a different search term."
            : "Tap the + button to add items,\nor tap here to add sample data."
        return NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.tertiaryLabel
        ])
    }

    func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? {
        guard !searchController.isActive else { return nil }
        let color: UIColor = state == .normal ? .systemBlue : .systemBlue.withAlphaComponent(0.5)
        return NSAttributedString(string: "Add 20 Items", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: color
        ])
    }

    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { true }

    func blankSlate(_ view: UIView, didTapView sender: UIView) {
        addItems()
    }

    func blankSlate(_ view: UIView, didTapButton sender: UIButton) {
        addItems()
    }
}
