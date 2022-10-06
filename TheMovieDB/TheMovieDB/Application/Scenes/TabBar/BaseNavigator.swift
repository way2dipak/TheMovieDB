//
//  BaseNavigator.swift
//  TheMovieDB
//
//  Created by DS on 05/05/21.
//

import Foundation
import UIKit

class BaseNavigator {
    
    private let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
    
    func showTabBarVC() {
        let vc = storyboard.instantiateViewController(withIdentifier: MainContainerVC.identifier) as! MainContainerVC
        AppDelegate.shared.push(to: vc, animated: false)
    }
    
    func showHomeVC() {
        let vc = storyboard.instantiateViewController(withIdentifier: HomeVC.identifier) as! HomeVC
        AppDelegate.shared.push(to: vc, animated: false)
    }
    
}
