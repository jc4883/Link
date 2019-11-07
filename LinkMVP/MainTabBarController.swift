//
//  ViewController.swift
//  LinkMVP
//
//  Created by Jung Yeon Choi on 7/20/19.
//  Copyright © 2019 Peter Choi. All rights reserved.
//

import UIKit
import Firebase
//UITabBarController is of type UIViewController, which has viewDidLoad() and .view
class MainTabBarController: UITabBarController {
    //why does this subclass have to have its own viewDidLoad?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //check if someone is logged out.
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginController()
                //we now have navigationController for our loginController
                let navigationController = UINavigationController(rootViewController: loginController)
                //you must present the navigation controller!
                self.present(navigationController, animated: true, completion: nil)
            }
            return
        }
        setupViewControllers()
        
    }
    func setupViewControllers() {
        //flowLayout on UICollectionView on navController on tabBarController on view on window
        
        //home map
        let mapController = MapController()
        let mapNavController = UINavigationController(rootViewController: mapController)
        mapNavController.tabBarItem.image = UIImage(named: "home_unselected")
        mapNavController.tabBarItem.selectedImage = UIImage(named: "home_selected")
        
        //friends
        //let searchNavController = setupNavControllers(selectedImage: "search_selected", unselectedImage: "search_unselected")
        let searchControllerLayout = UICollectionViewLayout()
        let searchController = UserSearch(collectionViewLayout: searchControllerLayout)
        let searchNavController = UINavigationController(rootViewController: searchController)
        searchNavController.tabBarItem.image = UIImage(named: "search_unselected")
        searchNavController.tabBarItem.selectedImage = UIImage(named: "search_selected")
        
        
        //notifications
        let notificationsControllerLayout = UICollectionViewFlowLayout()
        let notificationsController = NotificationsController(collectionViewLayout: notificationsControllerLayout)
        let notificationsNavController = UINavigationController(rootViewController: notificationsController)
        notificationsNavController.tabBarItem.image = UIImage(named: "notification_unselected")
        notificationsNavController.tabBarItem.selectedImage = UIImage(named: "notification_selected")
        
        //let notificationsNavController = setupNavControllers(selectedImage: "notification_selected", unselectedImage: "notification_unselected")
        
        //profile
        let userProfileControllerLayout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: userProfileControllerLayout)
        let userProfileNavController = UINavigationController(rootViewController: userProfileController)
        userProfileNavController.tabBarItem.image = UIImage(named: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        tabBar.tintColor = .black
        
        viewControllers = [mapNavController, notificationsNavController, searchNavController, userProfileNavController]
        
        //modify tabBar item insets
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
        }
    }
    
    //helper for setting up default tabs
    fileprivate func setupNavControllers(selectedImage: String, unselectedImage: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = UIImage(named: unselectedImage)
        navController.tabBarItem.selectedImage = UIImage(named: selectedImage)
        return navController
    }
}
