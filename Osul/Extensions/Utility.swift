//
//  Utility.swift
//  ShoppingApp
//
//  Created by Ashraf Essam on 12/9/19.
//  Copyright © 2019 Abdelrahman Saad. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    class func showAlertMessage(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        //We add buttons to the alert controller by creating UIAlertActions:
        let actionOk = UIAlertAction(title: "تم", style: .default, handler: nil)
        //You can use a block here to handle a press on this button
        alertController.addAction(actionOk)
        parentVC.present(alertController, animated: true, completion: nil)
    }
    class func showAlertWithAction(withTitle title: String, message msg: String, delegate del: Any?, parentViewController parentVC: UIViewController, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "لا", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "نعم", style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(true)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        parentVC.present(alert as UIViewController, animated: true, completion: nil)
    }
    class func showActionSheet(withTitle title: String, message msg: String, button: String, delegate del: Any?, parentViewController parentVC: UIViewController, completionHandler: @escaping (Bool) -> Void ) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: button, style: .default, handler: { action in
            switch action.style {
            case .default:
                completionHandler(true)
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }
        }))
        parentVC.present(alert as UIViewController, animated: true, completion: nil)
    }
    
    class func isValidEmail(_ email: String) -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        let isValid: Bool = emailPred.evaluate(with: email)
        return isValid
    }
    
}

