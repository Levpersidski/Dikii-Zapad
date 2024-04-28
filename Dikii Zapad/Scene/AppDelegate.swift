//
//  AppDelegate.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 24.09.2023.
//

import UIKit
import Kingfisher
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    static var shared: AppDelegate {
        return (UIApplication.shared.delegate as! AppDelegate)
    }
    var orientationLock = UIInterfaceOrientationMask.portrait

    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configureFirebase(for: application)
        let cache = ImageCache.default
        cache.diskStorage.config.expiration = .never
        cache.diskStorage.config.sizeLimit = 1024 * 1024 * 1024 // Например, 1 ГБ
        
        cache.memoryStorage.config.expiration = .seconds(300)
        return true
    }
    
    //  Reports app open from deep link for iOS 10 or later
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return true
    }
    
    

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Отображает пуши в Foreground
        print("willPresent notification")
        completionHandler([.alert, .badge, .sound])
    }


    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
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
        let tabBar = rootNavigation.viewControllers.first(where: {($0 as? UITabBarController) != nil }) as? UITabBarController
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


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG / push notification token: \(fcmToken ?? "nil")")
    }
    
    private func configureFirebase(for application: UIApplication) {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { bool, result in
//            print("DEBUG / push notification bool: \(bool)")
//            print("DEBUG / push notification result: \(String(describing: result))")
        }
        
        application.registerForRemoteNotifications()
    }
}
