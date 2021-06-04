//
//  BaseNavigator.swift
//  TheMovieDB
//
//  Created by DS on 05/05/21.
//

import Foundation
import UIKit

class BaseNavigator {
    
    private let stroyboard = UIStoryboard(name: "TabBar", bundle: nil)
    
    func showTabBarVC() {
        let vc = stroyboard.instantiateViewController(withIdentifier: MainContainerVC.identifier) as! MainContainerVC
        AppDelegate.shared.push(to: vc, animated: false)
    }
    
}
