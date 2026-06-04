//
//  MainMenuViewController.swift
//  BlankSlate Example
//
//  Created by Liam on 2024/3/11.
//  Copyright © 2024 Liam. All rights reserved.
//

import UIKit
import SwiftUI

// MARK: - Main Menu

class MainMenuViewController: UITableViewController {

    private struct Item {
        let title: String
        let subtitle: String
        let builder: () -> UIViewController
    }

    private struct Section {
        let title: String
        let items: [Item]
    }

    private let sections: [Section] = [
        Section(title: "Basic (View Types)", items: [
            Item(title: "UITableView", subtitle: "bs.setDataSourceAndDelegate, title, detail, image, buttonTitle") {
                TableViewDemo()
            },
            Item(title: "UICollectionView", subtitle: "bs.dataSource, bs.delegate (separate assignment)") {
                CollectionViewDemo()
            },
            Item(title: "UIScrollView", subtitle: "bs.reload(), horizontal paging") {
                ScrollViewDemo()
            },
            Item(title: "UIView", subtitle: "bs.reload(with:), bs.dismiss(), imageAnimation, backgroundGradient") {
                PlainViewDemo()
            },
            Item(title: "WKWebView", subtitle: "bs.dataLoadStatus assignment, shouldDisplay conditional") {
                WebViewDemo()
            },
        ]),
        Section(title: "Full API Demo (MVVM)", items: [
            Item(title: "100% DataSource + Delegate", subtitle: "All DataSource/Delegate methods, DataLoadStatus, Combine") {
                FullAPIDemo()
            },
        ]),
        Section(title: "Transitions", items: [
            Item(title: "Transition Animations", subtitle: ".none, .fadeIn, .slideUp, .slideDown, .scale, .bounce") {
                TransitionDemo()
            },
        ]),
        Section(title: "Convenience API", items: [
            Item(title: "StatusDrivenDataSource", subtitle: "StatusConfiguration, StateContent, zero-code setup") {
                StatusDrivenDemo()
            },
            Item(title: "Retry Extension", subtitle: "reload(with:retry:), onRetryAsync") {
                RetryDemo()
            },
        ]),
        Section(title: "Extension Properties", items: [
            Item(title: "bs.isVisible / bs.view / reloadBlankSlate", subtitle: "Live inspection of extension properties") {
                ExtensionPropertiesDemo()
            },
        ]),
        Section(title: "SwiftUI", items: [
            Item(title: "SwiftUI APIs", subtitle: "EmptyStateView, StandardEmptyView, .blankSlate() modifier") {
                if #available(iOS 16.0, *) {
                    return UIHostingController(rootView: SwiftUIDemosView())
                } else {
                    let label = UILabel()
                    label.text = "Requires iOS 16+"
                    label.textAlignment = .center
                    let vc = UIViewController()
                    vc.view = label
                    return vc
                }
            },
        ]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BlankSlate"
        tableView.register(SubtitleCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    // MARK: - DataSource

    override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { sections[section].title }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].items.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = sections[indexPath.section].items[indexPath.row]
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            content.secondaryText = item.subtitle
            content.secondaryTextProperties.color = .secondaryLabel
            content.secondaryTextProperties.font = .systemFont(ofSize: 12)
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
        }
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sections[indexPath.section].items[indexPath.row]
        let vc = item.builder()
        vc.title = item.title
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Subtitle Cell

private class SubtitleCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) { fatalError() }
}
