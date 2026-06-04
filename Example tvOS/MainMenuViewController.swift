//
//  MainMenuViewController.swift
//  Example tvOS
//
//  Created by Liam on 2024/2/6.
//  Copyright © 2024 Liam. All rights reserved.
//

import UIKit
import SwiftUI
import BlankSlate

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
        Section(title: "Basic", items: [
            Item(title: "UITableView", subtitle: "bs.setDataSourceAndDelegate, image, title, detail, buttonTitle") {
                TableViewDemoVC()
            },
            Item(title: "UICollectionView", subtitle: "bs.dataSource, bs.delegate, separate assignment") {
                CollectionViewDemoVC()
            },
            Item(title: "UIView (Plain)", subtitle: "bs.reload(with:), bs.dismiss(), imageAnimation, backgroundGradient") {
                PlainViewDemoVC()
            },
        ]),
        Section(title: "Full API", items: [
            Item(title: "100% DataSource + Delegate", subtitle: "All methods, DataLoadStatus, alignment cycling") {
                FullAPIDemoVC()
            },
        ]),
        Section(title: "Transitions", items: [
            Item(title: "Transition Animations", subtitle: ".fadeIn, .slideUp, .slideDown, .scale, .bounce") {
                TransitionDemoVC()
            },
        ]),
        Section(title: "Convenience", items: [
            Item(title: "StatusDrivenDataSource", subtitle: "StatusConfiguration, StateContent, zero-code setup") {
                StatusDrivenDemoVC()
            },
            Item(title: "Retry Extension", subtitle: "reload(with:retry:), onRetryAsync") {
                RetryDemoVC()
            },
        ]),
        Section(title: "Extensions", items: [
            Item(title: "bs.isVisible / bs.view", subtitle: "Extension properties & reloadBlankSlate") {
                ExtensionDemoVC()
            },
        ]),
        Section(title: "SwiftUI", items: [
            Item(title: "SwiftUI APIs", subtitle: "EmptyStateView, StandardEmptyView, .blankSlate() modifier") {
                if #available(tvOS 16.0, *) {
                    return UIHostingController(rootView: SwiftUIDemoView())
                } else {
                    let vc = UIViewController()
                    vc.view.backgroundColor = .black
                    return vc
                }
            },
        ]),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "BlankSlate tvOS"
    }

    override func numberOfSections(in tableView: UITableView) -> Int { sections.count }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { sections[section].title }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { sections[section].items.count }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let item = sections[indexPath.section].items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle
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
