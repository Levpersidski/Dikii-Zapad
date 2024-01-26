//
//  UIViewController + Extension.swift
//  Dikii Zapad
//
//  Created by mac on 26.01.2024.
//

import UIKit

extension UIViewController {
    @discardableResult
    func showAlert(_ title: String = "", message: String = "", showCancel: Bool = false, cancelTitle: String = "Отмена", okTitle: String = "OK", present: Bool = true, completion: (() -> ())? = nil) -> UIAlertController {
        //  Don't show the same alert to prevent flashing
        if let presented = self.presentedViewController as? UIAlertController, presented.message == message {
            return presented
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if completion == nil {
            alert.addAction(UIAlertAction(title: okTitle, style: .cancel, handler: nil))
        }
        else {
            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                completion?()
            }))
            if showCancel {
                alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: nil))
            }
        }
        
        if present {
            if presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            } else {
                self.dismiss(animated: false) { () -> Void in
                    self.present(alert, animated: false, completion: nil)
                }
            }
        }
                
        return alert
    }
}
