//
//  ScrollViewDemo.swift
//  BlankSlate Example
//
//  Demonstrates: bs.setDataSourceAndDelegate(_:) on UIScrollView, bs.reload(),
//  title, detail, image, blankSlateShouldAllowScroll
//

import UIKit
import BlankSlate

class ScrollViewDemo: UIViewController {
    private let scrollView = UIScrollView()
    private var hasContent = true

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        scrollView.bs.setDataSourceAndDelegate(self)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadContent)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearContent)),
        ]

        loadContent()
    }

    @objc private func loadContent() {
        hasContent = true
        scrollView.subviews.forEach { $0.removeFromSuperview() }

        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemOrange, .systemPurple]
        var constraints: [NSLayoutConstraint] = []
        var previous: UIView?

        for (index, color) in colors.enumerated() {
            let page = UILabel()
            page.backgroundColor = color.withAlphaComponent(0.3)
            page.text = "Page \(index + 1)"
            page.textAlignment = .center
            page.font = .systemFont(ofSize: 24, weight: .bold)
            page.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(page)

            constraints += [
                page.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                page.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                page.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            ]
            if let previous {
                constraints.append(page.leadingAnchor.constraint(equalTo: previous.trailingAnchor))
            } else {
                constraints.append(page.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor))
            }
            previous = page
        }
        if let previous {
            constraints.append(previous.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor))
        }
        NSLayoutConstraint.activate(constraints)
        scrollView.bs.reload()
    }

    @objc private func clearContent() {
        hasContent = false
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        scrollView.contentSize = .zero
        scrollView.bs.reload()
    }
}

// MARK: - BlankSlate

extension ScrollViewDemo: BlankSlate.DataSource, BlankSlate.Delegate {
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(systemName: "rectangle.on.rectangle.slash")
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "No Pages", attributes: [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Tap refresh to load horizontal pages.\nThis demonstrates BlankSlate on a plain UIScrollView.", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.tertiaryLabel
        ])
    }

    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { true }

    func blankSlateShouldDisplay(_ view: UIView) -> Bool { !hasContent }

    func blankSlate(_ view: UIView, didTapView sender: UIView) {
        loadContent()
    }
}
