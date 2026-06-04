//
//  TransitionDemo.swift
//  BlankSlate Example
//
//  Demonstrates: Transition enum (.none, .fadeIn, .slideUp, .slideDown, .scale, .bounce),
//  transition(forBlankSlate:) DataSource method, bs.reloadBlankSlate(with:)
//

import UIKit
import BlankSlate

class TransitionDemo: UITableViewController {
    private var selectedTransition: BlankSlate.Transition = .fadeIn(duration: 0.4)
    private let transitions: [(String, BlankSlate.Transition)] = [
        (".none", .none),
        (".fadeIn(0.4)", .fadeIn(duration: 0.4)),
        (".slideUp(0.4)", .slideUp(duration: 0.4)),
        (".slideDown(0.4)", .slideDown(duration: 0.4)),
        (".scale(0.4)", .scale(duration: 0.4)),
        (".bounce(0.5)", .bounce(duration: 0.5)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.bs.setDataSourceAndDelegate(self)

        let segmented = UISegmentedControl(items: transitions.map { $0.0 })
        segmented.selectedSegmentIndex = 1
        segmented.addTarget(self, action: #selector(transitionChanged(_:)), for: .valueChanged)

        let toolbar = UIToolbar()
        toolbar.items = [UIBarButtonItem(customView: segmented)]
        toolbar.sizeToFit()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Replay", style: .plain, target: self, action: #selector(replay))
        navigationItem.titleView = segmented
    }

    @objc private func transitionChanged(_ sender: UISegmentedControl) {
        selectedTransition = transitions[sender.selectedSegmentIndex].1
        replay()
    }

    @objc private func replay() {
        // Briefly dismiss then re-show to demonstrate the transition animation
        tableView.bs.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.tableView.bs.reloadBlankSlate(with: .failure)
        }
    }

    // Always return 0 rows to force blank slate display
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 0 }
}

// MARK: - BlankSlate

extension TransitionDemo: BlankSlate.DataSource, BlankSlate.Delegate {
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(systemName: "wand.and.stars")
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Transition Demo", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.label
        ])
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Select a transition from the picker above,\nthen tap 'Replay' to see it animate.", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func transition(forBlankSlate view: UIView) -> BlankSlate.Transition {
        selectedTransition
    }

    func backgroundColor(forBlankSlate view: UIView) -> UIColor? {
        .secondarySystemBackground
    }

    func blankSlateShouldBeForcedToDisplay(_ view: UIView) -> Bool { true }
    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { true }
}
