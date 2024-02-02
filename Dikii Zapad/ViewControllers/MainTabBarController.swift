//
//  MainTabBarController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        generatetabBar()
        setTabBarAppearance()
    }
    
   private func generatetabBar() {
            viewControllers = [
                generateVC(MainViewController(), title: "Меню", image: UIImage(named:"tabIcon_menucard")),
                generateVC(ActionsViewController(), title: "Акции", image: UIImage(named: "tabIcon_percent")),
                generateVC(ContactsViewController(), title: "Контакты", image: UIImage(named: "tabIcon_contaccts")),
                generateVC(CartViewController(), title: "Корзина", image: UIImage(named: "tabIcon_cart"))
            ]
    }
    
    private func generateVC(_ viewController:UIViewController, title:String, image:UIImage?, changeImageTo:UIImage? = nil) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = changeImageTo
        
        return viewController
    }
    
    private  func setTabBarAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customOrange], for: .normal)
        
        tabBar.selectedItem?.badgeTextAttributes(for: .normal)
        tabBar.backgroundColor = .black
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemlight
        tabBar.layer.cornerRadius = 10
    }
}
