//
//  UIViewController+UIAlert.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import Foundation
import UIKit

extension UIViewController {
    func displayAlert(title: String, message: String) -> Void {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okButton)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func displayAlertWithAction(title: String? = nil, message: String, cancelTitle: String? = nil, successTitle: String? = nil, cancelAction: (() -> Void)?, successAction: (() -> Void)?) -> Void {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if cancelTitle != nil {
                let cancelBtn = UIAlertAction(title: cancelTitle, style: .default) {
                    (handler) in
                    cancelAction?()
                }
                alertVC.addAction(cancelBtn)
            }
            if successTitle != nil {
                let retryButton = UIAlertAction(title: successTitle, style: .default) { (handler) in
                    successAction?()
                }
                alertVC.addAction(retryButton)
            }
            self.present(alertVC, animated: true, completion: nil)
        }
    }

}
