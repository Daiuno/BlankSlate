//
//  WebViewDemo.swift
//  BlankSlate Example
//
//  Demonstrates: bs.setDataSourceAndDelegate(_:) on WKWebView.scrollView,
//  bs.dataLoadStatus (write .failure), bs.dismiss(), blankSlateShouldDisplay (conditional),
//  blankSlateShouldBeInsertedAtBack, layout (height), image
//

import UIKit
import WebKit
import BlankSlate

class WebViewDemo: UIViewController {
    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        webView.navigationDelegate = self
        webView.scrollView.bs.setDataSourceAndDelegate(self)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Success", style: .plain, target: self, action: #selector(loadSuccess)),
            UIBarButtonItem(title: "Error", style: .plain, target: self, action: #selector(loadError)),
        ]
    }

    @objc private func loadSuccess() {
        guard let url = URL(string: "https://www.apple.com") else { return }
        webView.load(URLRequest(url: url))
    }

    @objc private func loadError() {
        guard let url = URL(string: "https://error.invalid/") else { return }
        webView.load(URLRequest(url: url))
    }
}

// MARK: - WKNavigationDelegate

extension WebViewDemo: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        webView.scrollView.bs.dismiss()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.scrollView.bs.dismiss()
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        // Use reload(with:) to both set the status AND trigger blank slate display
        webView.scrollView.bs.reload(with: .failure)
    }
}

// MARK: - BlankSlate

extension WebViewDemo: BlankSlate.DataSource, BlankSlate.Delegate {
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(systemName: "globe.badge.chevron.backward")
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Page Failed to Load", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.label
        ])
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "The server could not be reached.\nTap \"Success\" to load a valid URL.", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func layout(forBlankSlate view: UIView, for element: BlankSlate.Element) -> BlankSlate.Layout {
        .init(edgeInsets: UIEdgeInsets(top: 11, left: 16, bottom: 11, right: 16), height: nil)
    }

    // Only show empty state on failure
    func blankSlateShouldDisplay(_ view: UIView) -> Bool {
        view.bs.dataLoadStatus == .failure
    }

    // Display on top of web content so the error state is clearly visible
    func blankSlateShouldBeInsertedAtBack(_ view: UIView) -> Bool { false }

    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { true }
}
