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
        
        var newViewControllers: [UIViewController] = []
        newViewControllers.append(generateVC(.main, MainViewController(), title: "Меню", image: UIImage(named:"tabIcon_menucard")))
        newViewControllers.append(generateVC(.sales,ActionsViewController(), title: "Акции", image: UIImage(named: "tabIcon_percent")))
        newViewControllers.append(generateVC(.contacts, ContactsViewController(), title: "Контакты", image: UIImage(named: "tabIcon_contaccts")))
        
        if let vacancies = DataStore.shared.generalSettings?.vacancies, (vacancies.first(where: { $0.hasContent } ) != nil) {
            let vacanciesVC = VacanciesViewController()
            vacanciesVC.vacancies = vacancies.filter { $0.hasContent }
            newViewControllers.append(generateVC(.sales, vacanciesVC, title: "Вакансии", image: UIImage(systemName: "square.and.arrow.down.fill")))
        }
        newViewControllers.append(generateVC(.cart, CartViewController(), title: "Корзина", image: UIImage(named: "tabIcon_cart")))
        
        if DataStore.shared.devMode {
            newViewControllers.append(generateVC(.logs, LogsViewController(), title: "Логи", image: UIImage(systemName: "hammer")))
        }
        
        viewControllers = newViewControllers
    }
    
    private func generateVC(_ type: UITabBar.TabItem, _ viewController:UIViewController, title:String, image:UIImage?, changeImageTo:UIImage? = nil) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = changeImageTo
        viewController.tabBarItem.tag = type.rawValue
        
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
