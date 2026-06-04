//
//  SwiftUIDemo.swift
//  Example tvOS
//
//  Demonstrates: EmptyStateView, StandardEmptyView, .blankSlate() modifier
//
//  Created by Liam on 2024/2/6.
//  Copyright © 2024 Liam. All rights reserved.
//

import SwiftUI
import BlankSlate

@available(tvOS 16.0, *)
struct SwiftUIDemoView: View {
    @State private var items: [String] = []
    @State private var showStandard = true

    var body: some View {
        VStack(spacing: 40) {
            Text("SwiftUI BlankSlate APIs")
                .font(.title)

            // Demo 1: .blankSlate() view modifier
            List(items, id: \.self) { item in
                Text(item)
            }
            .frame(height: 300)
            .blankSlate(isEmpty: items.isEmpty) {
                VStack(spacing: 12) {
                    Image(systemName: "list.bullet")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("Empty List")
                        .font(.headline)
                    Text(".blankSlate() modifier demo")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            // Demo 2: StandardEmptyView
            if showStandard {
                BlankSlate.StandardEmptyView(
                    image: Image(systemName: "tray"),
                    title: "StandardEmptyView",
                    detail: "Pre-built layout with image, title, detail, and button.",
                    buttonTitle: "Add Items",
                    onRetry: { items = ["Alpha", "Beta", "Gamma"] }
                )
                .frame(height: 300)
            }

            // Demo 3: EmptyStateView
            BlankSlate.EmptyStateView(isEmpty: items.isEmpty) {
                Text("Content: \(items.count) items")
                    .font(.title2)
            } empty: {
                Text("EmptyStateView shows this when empty")
                    .foregroundColor(.secondary)
            }

            // Demo 4: .blankSlate() convenience with title/detail
            List(items, id: \.self) { Text($0) }
                .frame(height: 200)
                .blankSlate(
                    isEmpty: items.isEmpty,
                    image: Image(systemName: "star"),
                    title: "Convenience Modifier",
                    detail: "Uses .blankSlate(isEmpty:title:detail:)",
                    buttonTitle: "Load",
                    onRetry: { items = ["One", "Two"] }
                )

            HStack(spacing: 20) {
                Button("Clear") { items = [] }
                Button("Add") { items = ["Item \(items.count + 1)"] + items }
            }
        }
        .padding()
    }
}
