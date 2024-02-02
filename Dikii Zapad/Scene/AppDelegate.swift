//
//  AppDelegate.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 24.09.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var shared: AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

extension AppDelegate {
    class var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
}

extension UIApplication {
    class var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    class var tabBar: UITabBarController? {
        guard let rootNavigation = appDelegate.window?.rootViewController as? UINavigationController else {
            return nil
        }
        let tabBar = (rootNavigation.viewControllers.last as? UITabBarController)
        return tabBar
    }
}

extension UITabBar {
    enum TabItem: Int {
        case main = 0
        case sales = 1
        case contacts = 2
        case cart = 3
    }
    
    func setBageValue(_ item: TabItem, value: Int) {
        let indexTab = item.rawValue
        items?[indexTab].badgeValue = value == 0 ? "" : "\(value)"
        
        if value == 0 {
            items?[indexTab].badgeColor = .clear
        } else {
            items?[indexTab].badgeColor = .systemRed
        }
    }
}
