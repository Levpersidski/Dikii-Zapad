//
//  SceneDelegate.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 24.09.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    private var suspendDate: Date?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let LaunchVC = LaunchViewController()
        let navigationController = UINavigationController(rootViewController: LaunchVC)
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        (UIApplication.shared.delegate as? AppDelegate)?.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        print("=-= sceneWillEnterForeground")
        
        guard let date = suspendDate else {
            return
        }
        
        if Date().timeIntervalSince(date) > DataStore.allowedSecondsInBackground {
            UIApplication.appDelegate.restartApp()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        suspendDate = Date()
    }
}
