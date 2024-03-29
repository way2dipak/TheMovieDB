//
//  AppDelegate.swift
//  TheMovieDB
//
//  Created by DS on 02/05/21.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import SDWebImage
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var myOrientation: UIInterfaceOrientationMask = isIphone ? .portrait : .landscape

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .dark
        }
        initialConfig()
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TheMovieDB")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    private func initialConfig() {
        // config keyboard
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        // debug network requests
        NFX.sharedInstance().start()
        NFX.sharedInstance().setGesture(.shake)
        
        // SDWebImg cache
        SDImageCache.shared.config.maxDiskAge  = 86400  // 1 Day
        SDImageCache.shared.config.shouldCacheImagesInMemory = true
        SDImageCache.shared.deleteOldFiles(completionBlock: nil)
        SDImageCache.shared.calculateSize(completionBlock: nil)
    }
}

extension AppDelegate {
    static var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    var rootViewController: UIViewController? {
        return AppDelegate.shared.window?.rootViewController
    }
    
    var rootNavigationController: UINavigationController? {
        return rootViewController as? UINavigationController
    }
    
    var firstViewController: UIViewController? {
        return rootNavigationController?.viewControllers.first
    }
    
    func push(to vc: UIViewController, animated: Bool = true) {
        var navigationController: UINavigationController?
        
        if let navControllerVC = rootNavigationController {
            navigationController = navControllerVC
        } else {
            navigationController = rootViewController?.navigationController
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.pushViewController(vc, animated: animated)
    }
    
    func present(to vc: UIViewController, animated: Bool = true) {
        var navigationController: UINavigationController?
        
        if let navControllerVC = rootNavigationController {
            navigationController = navControllerVC
        } else {
            navigationController = rootViewController?.navigationController
        }
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return myOrientation
    }
    
}
