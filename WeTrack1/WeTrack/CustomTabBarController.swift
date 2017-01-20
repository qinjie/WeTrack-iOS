//
//  CustomTabBarController.swift
//  WeTrack
//
//  Created by xuhelios on 1/19/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let residentList = ResidentList(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: residentList)
        navigationController.title = "Active Resident"
        navigationController.tabBarItem.image = UIImage(named: "resident")
        
        let beaconController = BeaconController(collectionViewLayout: UICollectionViewFlowLayout())
        let secondNavigationController = UINavigationController(rootViewController: beaconController)
        secondNavigationController.title = "Beacon Detecting"
        secondNavigationController.tabBarItem.image = UIImage(named: "geo")
        
//        let messengerVC = UIViewController()
//        let messengerNavigationController = UINavigationController(rootViewController: messengerVC)
//        messengerNavigationController.title = "Messenger"
//        messengerNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
//        
//        let notificationsNavController = UINavigationController(rootViewController: UIViewController())
//        notificationsNavController.title = "Notifications"
//        notificationsNavController.tabBarItem.image = UIImage(named: "globe_icon")
//        
//        let moreNavController = UINavigationController(rootViewController: UIViewController())
//        moreNavController.title = "More"
//        moreNavController.tabBarItem.image = UIImage(named: "more_icon")
//        
//        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavController, moreNavController]
        
       
        viewControllers = [navigationController, secondNavigationController]
        
        tabBar.isTranslucent = false
        
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor(red:0.90, green:0.91, blue:0.92, alpha:1.0).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
        
        let selectedColor   = UIColor(red: 246.0/255.0, green: 155.0/255.0, blue: 13.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 16.0/255.0, green: 224.0/255.0, blue: 223.0/255.0, alpha: 1.0)
        
        tabBar.unselectedItemTintColor = unselectedColor
            
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: unselectedColor], for: .normal)
   
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: selectedColor], for: .selected)
        
        
        
        
    }
    
    fileprivate func createDummyNavControllerWithTitle(_ title: String, imageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }

 
    
    
    // for important Data
    
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
