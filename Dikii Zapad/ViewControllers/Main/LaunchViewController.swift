//
//  LaunchViewController.swift
//  Dikii Zapad
//
//  Created by Роман Бакаев on 03.10.2023.
//

import UIKit
import EasyPeasy

final class LaunchViewController: UIViewController {
    private var endedLoadingData = false
    private var endedWelcomeTime = false
    private var hasData = false
    private let dataService = ProductsDataService.shared
    
    private var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: "backgroundImage")
        return view
    }()
    
    private lazy var blackOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()
    
    private lazy var burgerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "burgerImage"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var logoImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logoImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0 // Устанавливаем начальное значение прозрачности в 0
        return imageView
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "ДИКИЙ ЗАПАД"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: "Capture it", size: 50)
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true // Разрешаем уменьшение размера шрифта
        label.minimumScaleFactor = 0.5 // Минимальный размер шрифта (по умолчанию 0.5)
        label.alpha = 0.0
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.tintColor = .white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstrains()
        
        loadDataIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logoImage.fadeIn(1.5)
        logoLabel.fadeIn(1.5)
        blackOverlayView.fadeOut(1)
        startWelcomeTime()
    }
    
    private func startWelcomeTime() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.endedWelcomeTime = true
            self?.tryOpenApp()
        }
    }
    
    private func setupView() {
        view.addSubviews(backgroundImage,
                         logoImage,
                         burgerImage,
                         logoLabel,
                         blackOverlayView,
                         activityIndicator)
    }
    
    private func setupConstrains() {
        logoImage.easy.layout(
            Top(100).to(view.safeAreaLayoutGuide, .top),
            CenterX(),
            Size(60)
        )
        logoLabel.easy.layout(
            Top(30).to(logoImage, .bottom),
            CenterX(),
            Left(30),
            Right(30)
        )
        burgerImage.easy.layout(
            Bottom(-200),
            CenterX(15),
            Size(930)
        )
        backgroundImage.easy.layout(
            Edges()
        )
        blackOverlayView.easy.layout(
            Edges()
        )
        activityIndicator.easy.layout(
            Top(20).to(logoLabel, .bottom),
            CenterX(),
            Size(20)
        )
        
        activityIndicator.transform = CGAffineTransform.init(scaleX: 2, y: 2)
    }
    
    func restartApp() {
        endedWelcomeTime = false
        dataService.products = []
        dataService.categories = []
        startWelcomeTime()
        
        loadDataIfNeeded()
    }
    
    private func loadDataIfNeeded() {
        checkValidVersion { [weak self] result, error  in
            guard let self, error == nil else {
                self?.showAlert("Что то пошло не так",
                                message: "Не удалось загрузить меню",
                                okTitle: "Повторить",
                                present: true)
                return
            }
            
            if result == true {
                self.loadData()
            } else {
                self.showAlert(
                    "Обнови приложение!",
                    message: "Обнови приложение Dikiy Zapad до новой версии. Мы исправили критичные ошибки.\n\nНовая версия доступна в App Store.",
                    okTitle: "Перейти в App Store",
                    present: true,
                    completion: {
                        let url = URL(string: DataStore.shared.generalSettings?.appStoreURL ?? "")!
                        
                        if UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    })
            }
        }
    }
    
    private func tryOpenApp() {
        if !hasData && endedLoadingData {
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            
            showAlert("Что то пошло не так",
                      message: "Не удалось загрузить меню",
                      okTitle: "Повторить",
                      present: true,
                      completion: { [weak self] in self?.loadData() }
            )
            return
        }
        
        guard endedWelcomeTime else {
            return
        }
        guard endedLoadingData else {
            return
        }
        
        guard let vc = navigationController?.viewControllers.last, !(vc is MainTabBarController) else {
            return
        }
        
        let mainViewController = MainTabBarController()
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    private func checkValidVersion(completion: @escaping (Bool?, Error?) -> Void)  {
        dataService.loadGeneralSettings { settings, error in
            guard let settings, error == nil else {
                completion(false, DZError.badData)
                return
            }
            
            let currentVersion = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
            let currentComponents = currentVersion.components(separatedBy: ".")
            let serverComponents = settings.minVersion.components(separatedBy: ".")
            let count = min(currentComponents.count, serverComponents.count)

            for i in 0..<count {
                guard let current = Int(currentComponents[i]) else {
                    continue
                }
                guard let server = Int(serverComponents[i]) else {
                    continue
                }
                
                if current < server {
                    completion(false, nil)
                    return
                } else if current > server {
                    completion(true, nil)
                    return
                }
            }
            
            if currentComponents.count < serverComponents.count {
                completion(false, nil)
                return
            } else {
                completion(true, nil)
                return
            }
        }
    }
    
    private func loadData() {
        endedLoadingData = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        dataService.downloadProduct() { [weak self] hasData in
            guard let self = self else { return }
            self.endedLoadingData = true

            self.hasData = hasData
            self.tryOpenApp()
        }
    }
}

