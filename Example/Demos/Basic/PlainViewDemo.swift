//
//  PlainViewDemo.swift
//  BlankSlate Example
//
//  Demonstrates: bs.setDataSourceAndDelegate(_:) on UIView, bs.reload(with:), bs.dismiss(),
//  bs.dataLoadStatus (read), title, detail, buttonTitle, image, imageAnimation,
//  backgroundGradient, transition, layout (with Element), blankSlateShouldDisplay
//

import UIKit
import BlankSlate

class PlainViewDemo: UIViewController {
    private var counter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.bs.setDataSourceAndDelegate(self)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Dismiss", style: .plain, target: self, action: #selector(dismissBlankSlate)),
            UIBarButtonItem(title: "Toggle", style: .plain, target: self, action: #selector(toggleState)),
        ]
    }

    @objc private func toggleState() {
        counter += 1
        // Alternates between .loading (suppressed by shouldDisplay) and .failure (shown)
        let status: BlankSlate.DataLoadStatus = counter.isMultiple(of: 2) ? .loading : .failure
        view.bs.reload(with: status)
    }

    @objc private func dismissBlankSlate() {
        view.bs.dismiss()
    }
}

// MARK: - BlankSlate

extension PlainViewDemo: BlankSlate.DataSource, BlankSlate.Delegate {
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(systemName: "wifi.slash")
    }

    func imageAnimation(forBlankSlate view: UIView) -> CAAnimation? {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1.0
        animation.toValue = 1.15
        animation.duration = 0.8
        animation.autoreverses = true
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return animation
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Connection Lost", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .bold),
            .foregroundColor: UIColor.label
        ])
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Toggle switches between .loading (hidden) and .failure (shown).\nDismiss removes the blank slate entirely.", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? {
        let color: UIColor = state == .normal ? .systemBlue : .systemBlue.withAlphaComponent(0.4)
        return NSAttributedString(string: "Retry Connection", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: color
        ])
    }

    func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer? {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemBlue.withAlphaComponent(0.05).cgColor,
            UIColor.systemPurple.withAlphaComponent(0.05).cgColor
        ]
        return gradient
    }

    // NOTE: fadeInDuration is deprecated. Use transition(_:) instead.
    func transition(forBlankSlate view: UIView) -> BlankSlate.Transition {
        .fadeIn(duration: 0.35)
    }

    func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout {
        switch element {
        case .image:
            return .init(edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0))
        case .button:
            return .init(edgeInsets: UIEdgeInsets(top: 20, left: 40, bottom: 11, right: 40))
        default:
            return .init()
        }
    }

    // Only display when status != .loading (demonstrates conditional display)
    func blankSlateShouldDisplay(_ view: UIView) -> Bool {
        view.bs.dataLoadStatus != .loading
    }

    func blankSlate(_ view: UIView, didTapButton sender: UIButton) {
        view.bs.dismiss()
    }

    func blankSlate(_ view: UIView, didTapView sender: UIView) {
        print("PlainViewDemo: view tapped")
    }
}
