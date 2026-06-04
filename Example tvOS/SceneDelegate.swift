//
//  SceneDelegate.swift
//  Example tvOS
//
//  Created by Liam on 2024/2/6.
//  Copyright © 2024 Liam. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: MainMenuViewController())
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}
