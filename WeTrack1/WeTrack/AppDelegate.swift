//
//  AppDelegate.swift
//  WeTrack
//
//  Created by xuhelios on 1/13/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import CoreLocation
import CoreData
import Alamofire

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {
    var window: UIWindow!
    var locationManager: CLLocationManager!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
        UIApplication.shared.cancelAllLocalNotifications()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        UserDefaults.standard.synchronize()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoringDidFailForRegion - error: \(error.localizedDescription)")
        print("monitoringDidFailForRegion - error: \(region?.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("Started monitoring \(region.identifier) region")
        
        //noti(content: "start " + region.identifier)
        
    }
    
    func noti(content : String){
        var notification = UILocalNotification()
        notification.alertBody = content
        notification.soundName = "Default"
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    func locationManager(_ manager: CLLocationManager, didStopMonitoringFor region: CLRegion) {
        print("Stop monitoring \(region.identifier) region")
    }
    
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion){
        
        print("@3: -____- state \(region.identifier)" )
        switch state {
            case .inside:
                print(" -____- Inside \(region.identifier)");
        
                noti(content: "INSIDE  " + region.identifier)
                
                let info = region.identifier.components(separatedBy: "#")
                
//                DispatchQueue.global().async {
//                    self.report(beaconId : info[1], userId : info[2])
//                   
//                }
                
                let today = Date()
                let dateFormatter = DateFormatter()
                
                dateFormatter.dateFormat = "hh:mm:ss"
                let y = dateFormatter.string(from: today)
                
                let x = Beaconx(beaconId: info[1], userId: info[2], d: true, day: y) as Beaconx
                GlobalData.history.insert(x, at: 0)
                
                
                //}
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHistory"), object: nil)
            //report(region: CLRegion)
            case .outside:
                print(" -____- Outside");
            
               // noti(content: "OUTSIDE  " + region.identifier)
            
            case .unknown:
                print(" -____- Unknown");
            default:
                print(" -____-  default");
        }
    }
    
    func report(beaconId : String, userId : String){
        
        let url = Constant.baseURL + "api/web/index.php/v1/location-history/create"
        
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
   
        
        let parameters: [String: Any] = [
            "beacon_id" : beaconId,
            "user_id" : userId,
            "longitude": long,
            "latitude": lat
            ]

        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            let JSONS = response.result.value
            print(" reponse\(JSONS)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        //print("@1: did enter region!!!")
        
        if (region is CLBeaconRegion) {
            
            print("@2: did enter region!!!  \(region.identifier)" )
            
         //   noti(content: "ENTER  " + region.identifier)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        // print("@1: did exit region!!!")
        
        if (region is CLBeaconRegion) {
            print("@2: did exit region!!!   \(region.identifier)")
            let info = region.identifier.components(separatedBy: "#")
            
            let today = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "hh:mm:ss"
            let y = dateFormatter.string(from: today)
            
            let x = Beaconx(beaconId: info[1], userId: info[2], d: false, day: y) as Beaconx
            GlobalData.history.insert(x, at: 0)
            
            noti(content: "EXIT " + region.identifier)
        }
    }
    
    


    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "WeTrack")
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

