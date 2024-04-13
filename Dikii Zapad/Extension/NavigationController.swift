//
//  NavigationController.swift
//  Dikii Zapad
//
//  Created by Glushchenko on 13.04.2024.
//

import UIKit

extension UINavigationController {
    override open var shouldAutorotate: Bool {
        get {
            return false
        }
    }

    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            return .portrait
        }
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return .portrait
        }
    }
}
