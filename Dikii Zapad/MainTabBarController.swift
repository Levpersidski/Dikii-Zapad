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
                generateVC(viewController: MainViewController(), title: "Меню", image: UIImage(systemName:"menucard.fill"), changeImageTo: UIImage(systemName:"menucard.fill")),
                generateVC(viewController: ActionsViewController(), title: "Акции", image: UIImage(systemName:"percent"), changeImageTo: UIImage(systemName:"figure.basketball")),
                generateVC(viewController: ContactsViewController(), title: "Контакты", image: UIImage(systemName:"phone.bubble.left"), changeImageTo: UIImage(systemName:"figure.basketball")),
                generateVC(viewController: CartViewController(), title: "Корзина", image: UIImage(systemName:"trash"), changeImageTo: UIImage(systemName:"figure.basketball"))
            ]
        
    }
    
    private func generateVC(viewController:UIViewController, title:String, image:UIImage?, changeImageTo:UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = changeImageTo
        
        return viewController
    }
    private  func setTabBarAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customOrange], for: .normal)
        UITabBarItem.appearance().largeContentSizeImage?.scale
        
        tabBar.selectedItem?.badgeTextAttributes(for: .normal)
        tabBar.backgroundColor = .black
        tabBar.tintColor = .tabBarItemAccent
        tabBar.unselectedItemTintColor = .tabBarItemlight
        tabBar.layer.cornerRadius = 10

    }
}


