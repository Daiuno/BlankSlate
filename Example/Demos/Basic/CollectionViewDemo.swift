//
//  CollectionViewDemo.swift
//  BlankSlate Example
//
//  Demonstrates: bs.dataSource, bs.delegate (separate assignment), title, detail, image,
//  blankSlateShouldAllowScroll, blankSlate(_:didTapView:)
//

import UIKit
import BlankSlate

class CollectionViewDemo: UICollectionViewController {
    private var colors: [(String, UIColor)] = []

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        // Demonstrates separate assignment of dataSource and delegate
        collectionView.bs.dataSource = self
        collectionView.bs.delegate = self

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(loadColors)),
            UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearColors)),
        ]
    }

    @objc private func loadColors() {
        colors = [
            ("Coral", .systemRed), ("Ocean", .systemBlue), ("Grass", .systemGreen),
            ("Sun", .systemYellow), ("Grape", .systemPurple), ("Forest", .systemGreen),
            ("Sky", .systemBlue), ("Tangerine", .systemOrange), ("Rose", .systemPink),
            ("Slate", .systemGray), ("Indigo", .systemIndigo), ("Teal", .systemTeal),
        ].shuffled()
        collectionView.reloadData()
    }

    @objc private func clearColors() {
        colors.removeAll()
        collectionView.reloadData()
    }

    // MARK: - UICollectionView

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        colors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = colors[indexPath.item].1
        cell.layer.cornerRadius = 8
        return cell
    }
}

extension CollectionViewDemo: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 4
        let spacing: CGFloat = 4
        let inset: CGFloat = 8
        let available = collectionView.bounds.width - (inset * 2) - (spacing * (columns - 1))
        let side = available / columns
        return CGSize(width: side, height: side)
    }
}

// MARK: - BlankSlate

extension CollectionViewDemo: BlankSlate.DataSource, BlankSlate.Delegate {
    func image(forBlankSlate view: UIView) -> UIImage? {
        UIImage(systemName: "paintpalette")
    }

    func title(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "No Colors Loaded", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: UIColor.secondaryLabel
        ])
    }

    func detail(forBlankSlate view: UIView) -> NSAttributedString? {
        NSAttributedString(string: "Tap the refresh button to load random colors.\nTap here to load instantly.", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.tertiaryLabel
        ])
    }

    func blankSlateShouldAllowScroll(_ scrollView: UIScrollView) -> Bool { true }

    func blankSlate(_ view: UIView, didTapView sender: UIView) {
        loadColors()
    }
}
