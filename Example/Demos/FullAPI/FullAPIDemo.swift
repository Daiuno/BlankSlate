//
//  FullAPIDemo.swift
//  BlankSlate Example
//
//  Demonstrates 100% of BlankSlate DataSource + Delegate protocol methods.
//  Architecture: MVVM with Combine.
//
//  DataSource APIs demonstrated:
//    image, imageAlpha, imageTintColor, imageAnimation, title, detail,
//    buttonTitle, buttonBackgroundImage, buttonImage, blankSlate(_:configure:),
//    customView, layout (all Element cases), alignment (.center/.top/.bottom + CGPoint.offset),
//    backgroundColor, backgroundGradient, transition
//
//  Delegate APIs demonstrated:
//    blankSlateShouldBeForcedToDisplay, blankSlateShouldDisplay,
//    blankSlateShouldBeInsertedAtBack, blankSlateShouldAllowTouch,
//    blankSlateShouldAllowScroll, shouldAllowScrollAfterBlankSlateDisappear,
//    blankSlate(_:didTapView:), blankSlate(_:didTapButton:),
//    blankSlateWillAppear, blankSlateDidAppear, blankSlateWillDisappear, blankSlateDidDisappear
//
//  Model APIs demonstrated:
//    DataLoadStatus (.loading, .success, .failure), Element, Layout (edgeInsets, height, with),
//    Alignment (.center, .top, .bottom), Transition (.fadeIn), CGPoint.offset(y:x:)
//

import UIKit
import BlankSlate
import Combine

class FullAPIDemo: UITableViewController {
    private let viewModel = FullAPIViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.bs.setDataSourceAndDelegate(self)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(reload)),
            UIBarButtonItem(title: "Align", style: .plain, target: self, action: #selector(cycleAlignment)),
        ]

        bindViewModel()
        viewModel.loadData()
    }

    private func bindViewModel() {
        viewModel.$dataLoadStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] status in
                self?.tableView.bs.reload(with: status)
            }
            .store(in: &cancellables)
    }

    @objc private func reload() { viewModel.loadData() }
    @objc private func cycleAlignment() { viewModel.cycleAlignment() }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.dataLoadStatus == .success ? 5 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "Data Row \(indexPath.row + 1)"
        return cell
    }
}

// MARK: - BlankSlate DataSource (100% coverage)

extension FullAPIDemo: BlankSlate.DataSource {
    func image(forBlankSlate view: UIView) -> UIImage? {
        viewModel.dataLoadStatus == .loading ? nil : UIImage(systemName: "exclamationmark.triangle")
    }

    func imageAlpha(forBlankSlate view: UIView) -> CGFloat { 0.75 }

    func imageTintColor(forBlankSlate view: UIView) -> UIColor? { .systemOrange }

    func imageAnimation(forBlankSlate view: UIView) -> CAAnimation? {
        guard viewModel.dataLoadStatus == .failure else { return nil }
        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = -0.05
        anim.toValue = 0.05
        anim.duration = 0.15
        anim.autoreverses = true
        anim.repeatCount = 3
        return anim
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        viewModel.titleString
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        viewModel.detailString
    }

    func buttonTitle(forBlankSlate view: UIView, for state: UIControl.State) -> NSAttributedString? {
        guard viewModel.dataLoadStatus == .failure else { return nil }
        let color: UIColor = state == .normal ? .white : .white.withAlphaComponent(0.6)
        return NSAttributedString(string: "Retry", attributes: [
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold),
            .foregroundColor: color
        ])
    }

    func buttonBackgroundImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage? {
        guard viewModel.dataLoadStatus == .failure else { return nil }
        // Demonstrates creating a stretchable button background image
        let size = CGSize(width: 28, height: 28)
        let renderer = UIGraphicsImageRenderer(size: size)
        let color: UIColor = state == .highlighted ? .systemBlue.withAlphaComponent(0.8) : .systemBlue
        return renderer.image { ctx in
            color.setFill()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 10).fill()
        }.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    func buttonImage(forBlankSlate view: UIView, for state: UIControl.State) -> UIImage? {
        guard viewModel.dataLoadStatus == .failure else { return nil }
        return UIImage(systemName: "arrow.clockwise")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    }

    func blankSlate(_ view: UIView, configure button: UIButton) {
        // Using buttonBackgroundImage for background, so only set corner radius here
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
            config.imagePadding = 8
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        }
    }

    func customView(forBlankSlate view: UIView) -> UIView? {
        guard viewModel.dataLoadStatus == .loading else { return nil }
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        return spinner
    }

    func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout {
        switch element {
        case .image:
            // Demonstrates Layout.with mutating builder
            var layout = BlankSlate.Layout()
            layout.with { $0.edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0) }
            return layout
        case .title:
            return .init(edgeInsets: UIEdgeInsets(top: 0, left: 20, bottom: 8, right: 20))
        case .detail:
            return .init(edgeInsets: UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30))
        case .button:
            return .init(edgeInsets: UIEdgeInsets(top: 24, left: 40, bottom: 11, right: 40))
        case .custom:
            return .init(edgeInsets: .zero, height: 60)
        }
    }

    func alignment(forBlankSlate view: UIView) -> BlankSlate.Alignment {
        viewModel.currentAlignment
    }

    func backgroundColor(forBlankSlate view: UIView) -> UIColor? {
        UIColor.systemGroupedBackground
    }

    func backgroundGradient(forBlankSlate view: UIView) -> CAGradientLayer? {
        guard viewModel.dataLoadStatus == .failure else { return nil }
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.systemRed.withAlphaComponent(0.03).cgColor,
            UIColor.systemOrange.withAlphaComponent(0.03).cgColor
        ]
        return gradient
    }

    func transition(forBlankSlate view: UIView) -> BlankSlate.Transition {
        .fadeIn(duration: 0.3)
    }
}

// MARK: - BlankSlate Delegate (100% coverage)

extension FullAPIDemo: BlankSlate.Delegate {
    func blankSlateShouldBeForcedToDisplay(_ view: UIView) -> Bool { false }
    func blankSlateShouldDisplay(_ view: UIView) -> Bool { true }
    func blankSlateShouldBeInsertedAtBack(_ view: UIView) -> Bool { true }
    func blankSlateShouldAllowTouch(_ view: UIView) -> Bool { true }
    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { true }
    func shouldAllowScrollAfterBlankSlateDisappear(_ scrollView: UIScrollView) -> Bool { true }

    func blankSlate(_ view: UIView, didTapView sender: UIView) {
        print("[FullAPI] didTapView")
    }

    func blankSlate(_ view: UIView, didTapButton sender: UIButton) {
        viewModel.loadData()
    }

    func blankSlateWillAppear(_ view: UIView) { print("[FullAPI] willAppear") }
    func blankSlateDidAppear(_ view: UIView) { print("[FullAPI] didAppear") }
    func blankSlateWillDisappear(_ view: UIView) { print("[FullAPI] willDisappear") }
    func blankSlateDidDisappear(_ view: UIView) { print("[FullAPI] didDisappear") }
}
