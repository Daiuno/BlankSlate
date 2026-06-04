//
//  FullAPIViewModel.swift
//  BlankSlate Example
//
//  MVVM ViewModel for FullAPIDemo. Manages DataLoadStatus and alignment cycling.
//  Demonstrates: DataLoadStatus, Alignment (.center, .top, .bottom), CGPoint.offset(y:x:)
//

import Foundation
import UIKit
import BlankSlate
import Combine

@MainActor
final class FullAPIViewModel: ObservableObject {
    @Published private(set) var dataLoadStatus: BlankSlate.DataLoadStatus = .loading

    private var alignmentIndex = 0
    private let alignments: [BlankSlate.Alignment] = [
        .center(.offset(y: -40)),           // 40pt above center
        .top(.offset(y: 60, x: 0)),         // Near top with 60pt padding
        .bottom(.offset(y: -20)),           // Near bottom with 20pt padding
        .center(),                          // Exact center
    ]

    var currentAlignment: BlankSlate.Alignment {
        alignments[alignmentIndex % alignments.count]
    }

    var titleString: NSAttributedString? {
        switch dataLoadStatus {
        case .loading:
            return NSAttributedString(string: "Loading...", attributes: [
                .font: UIFont.systemFont(ofSize: 20, weight: .medium),
                .foregroundColor: UIColor.secondaryLabel
            ])
        case .success:
            return NSAttributedString(string: "No Data Available", attributes: [
                .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                .foregroundColor: UIColor.label
            ])
        case .failure:
            return NSAttributedString(string: "Failed to Load Data", attributes: [
                .font: UIFont.systemFont(ofSize: 22, weight: .bold),
                .foregroundColor: UIColor.label
            ])
        }
    }

    var detailString: NSAttributedString? {
        switch dataLoadStatus {
        case .loading:
            return nil
        case .success:
            let text = "Alignment: \(alignmentDescription)\nData loaded but list is empty."
            return NSAttributedString(string: text, attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ])
        case .failure:
            let text = "Alignment: \(alignmentDescription)\nTap 'Align' to cycle through .center, .top, .bottom"
            return NSAttributedString(string: text, attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ])
        }
    }

    private var alignmentDescription: String {
        switch currentAlignment {
        case .center(let offset): return ".center(y: \(offset.y))"
        case .top(let offset): return ".top(y: \(offset.y))"
        case .bottom(let offset): return ".bottom(y: \(offset.y))"
        }
    }

    private var loadCount = 0

    func loadData() {
        dataLoadStatus = .loading
        loadCount += 1
        let shouldSucceed = loadCount % 3 == 0  // Every 3rd load succeeds (shows empty state)
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000)
            dataLoadStatus = shouldSucceed ? .success : .failure
        }
    }

    func cycleAlignment() {
        alignmentIndex += 1
        // Re-publish to trigger reload
        let current = dataLoadStatus
        dataLoadStatus = current
    }
}
