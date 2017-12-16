//
//  AppDelegate.swift
//  WeTrack
//
//  Created by xuhelios on 1/13/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import GoogleSignIn


import Firebase

import FirebaseMessaging

@UIApplicationMain


class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate  {
    
    
    var window: UIWindow!
    var locationManager: CLLocationManager!
    private var reachability:Reachability!
    var lh = [LocationHistory]()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.requestLocationService()
        GlobalData.residentStatus.removeAll()
        if (UserDefaults.standard.string(forKey: "email") != nil) {
            Constant.email = UserDefaults.standard.value(forKey: "email") as? String ?? ""
        }
        UIApplication.shared.statusBarStyle = .lightContent
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //        var loginController: LoginController? = (mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginController)
        //         self.window.rootViewController = loginController
        if (UserDefaults.standard.string(forKey: "token") == nil) {
            
            let loginController: LoginController? = (mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginController)
            
            self.window.rootViewController = loginController
        }else{
            
            let mainViewController: CustomTabBarController? = (mainStoryboard.instantiateViewController(withIdentifier: "Home") as? CustomTabBarController)
            
            self.window.rootViewController = mainViewController
            
            Constant.token = UserDefaults.standard.string(forKey: "token")!
        }
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: ReachabilityChangedNotification, object: nil)
        print("Hi guys")
        self.reachability = Reachability.init()
        do {
            try self.reachability.startNotifier()
        } catch {
        }
        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        
        FIRApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        
        NotificationCenter.default.addObserver(self, selector: #selector(tokenRefreshNotification),
                                               name: NSNotification.Name.firInstanceIDTokenRefresh,
                                               object: nil)
        
        return true
    }
    
    
    // NOTE: Need to use this when swizzling is disabled
    public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        FIRInstanceID.instanceID().setAPNSToken(deviceToken as Data, type: FIRInstanceIDAPNSTokenType.sandbox)
        let characterSet = CharacterSet(charactersIn: "<>")
        let deviceTokenString = deviceToken.description.trimmingCharacters(in: characterSet).replacingOccurrences(of: " ", with: "");
        NSLog("deviceToken",deviceTokenString)
        let device_token = UserDefaults.standard.value(forKey: "devicetoken")
        if (device_token == nil) {
            UserDefaults.standard.set(deviceTokenString, forKey: "devicetoken")
        }
        //if (UserDefaults.standard.string(forKey: "devicetoken")!)
    }
    
    func tokenRefreshNotification(notification: NSNotification) {
        // NOTE: It can be nil here
        let refreshedToken = FIRInstanceID.instanceID().token()
        print("InstanceID token: \(refreshedToken)")
        
        UserDefaults.standard.set(refreshedToken, forKey: "devicetoken")
        
        let file = "file.txt" //this is the file. we will write to and read from it
        
//        let text = refreshedToken! //just a text
//        
//        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//            
//            let path = dir.appendingPathComponent(file)
//            
//            //writing
//            do {
//                try text.write(to: path, atomically: false, encoding: String.Encoding.utf8)
//            }
//            catch {/* error handling here */}
//            
//         
//        }
        connectToFcm()
        
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FIRMessaging.messaging().connect { error in
            print("ahihi \(error)")
        }
    }
    
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if (error != nil) {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    
    public func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print(userInfo)
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        return GIDSignIn.sharedInstance().handle(url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
    }
    
    
    func requestLocationService(){
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
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
            
            let info = region.identifier.components(separatedBy: "#")
    
            let today = Date()
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let y = dateFormatter.string(from: today)
            
            if (Constant.noti){
                if let lastTime = GlobalData.residentStatus[info[2]]{
                    let timeInterval = dateFormatter.date(from: y)?.timeIntervalSince(dateFormatter.date(from: lastTime)!)
                    if timeInterval! >= 3600{
                        noti(content: info[0] + " is nearby.")
                    }
                }else{
                    GlobalData.residentStatus[info[2]] = y
                    noti(content: info[0] + " is nearby.")
                }
                
            }
            
           // let x = Beacon()
            
            let z = GlobalData.beaconList.first(where: {$0.id.description == info[1]})
            let t = GlobalData.allResidents.first(where: {$0.id.description == info[2]})
            if (z != nil && t != nil){
              
                    z?.report = y
                    t?.report = y
            
//
//                x.name = (z?.name)!
//                x.major = (z?.major)!
//                x.minor = (z?.minor)!
//                x.photopath = (z?.photopath)!
//                x.resident_id = (z?.resident_id)!
//                x.id = Int(info[1])!
//                x.detect = true
//                x.report = y
                // at here
              //  GlobalData.history.insert(x, at: 0)
            }
            
            if (!GlobalData.nearMe.contains(where: {$0.id.description == info[2]})){
                let k = Resident()
                k.name = info[0]
                k.id = info[2]
                k.status = true
                if t != nil{
                    k.photo = (t?.photo)!
                }
                GlobalData.nearMe.append(k)
            }
            
            //}
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHistory"), object: nil)
            DispatchQueue.global().async {
                self.report(beaconId : info[1], userId : info[2])
                
            }
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
        
        let lat = locationManager.location?.coordinate.latitude
        let long = locationManager.location?.coordinate.longitude
        
        if let user = GlobalData.missingList.filter({$0.id == userId}).first{
            for i in 0...GlobalData.missingList.count-1{
                if GlobalData.missingList[i].id == user.id{
                    var location = [String:Any]()
                    location["longitude"] = long
                    location["latitude"] = lat
                    location["user_id"] = Int(userId)
                    location["beacon_id"] = Int(beaconId)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let today = dateFormatter.string(from: Date())
                    location["created_at"] = today
                    GlobalData.missingList[i].lastestLocation = Location(arr: location)
                    NotificationCenter.default.post(name: Notification.Name(rawValue:"sync"), object: nil)
                }
            }
        }
        
        if (reachability.isReachable){
            
            
            let parameters: [String: Any] = [
                "beacon_id" : beaconId,
                "user_id" : Constant.user_id,
                "longitude": long,
                "latitude": lat
            ]
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Constant.token
                // "Accept": "application/json"
            ]
            
            Alamofire.request(Constant.URLreport , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                
                let JSONS = response.result.value
                print(" reponse\(JSONS)")
            }
            
        }else{
            
            print("Notreachable")
            let x = LocationHistory(bId: beaconId, uId: userId, newlat: (lat?.description)!, newlong: (long?.description)!)
            self.lh.append(x)

            
            let file2 = "data.txt" //this is the file. we will write to and read from it
            
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let filePath = dir.appendingPathComponent(file2)
                
                // write to file
                NSKeyedArchiver.archiveRootObject(lh, toFile: filePath.path)
                
                // read from file
                let dict2 = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as! [LocationHistory]
                
                for y in dict2{
                    print("testlocal \(y.lat)")
                }
                
            }
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
            
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let y = dateFormatter.string(from: today)
            
            // at here
            //let x = Beacon()
            let z = GlobalData.beaconList.first(where: {$0.id.description == info[1]})
            let t = GlobalData.allResidents.first(where: {$0.id.description == info[2]})
            if (z != nil && t != nil){
               
                    z?.report = y
                    t?.report = y
            
//                x.name = (z?.name)!
//                x.major = (z?.major)!
//                x.minor = (z?.minor)!
//                x.photopath = (z?.photopath)!
//                x.resident_id = (z?.resident_id)!
//                x.id = Int(info[1])!
//                
//                x.detect = false
//                x.report = y
//                GlobalData.history.insert(x, at: 0)
            }
            GlobalData.nearMe = GlobalData.nearMe.filter({$0.id.description != info[2]})
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateHistory"), object: nil)
//            if (Constant.noti){
//                noti(content: "Out of " + region.identifier)
//            }
            
        }
    }
    
    
    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //  self.saveContext()
    }
    
    
    
    // MARK: - Core Data stack
    
    //    lazy var persistentContainer: NSPersistentContainer = {
    //        /*
    //         The persistent container for the application. This implementation
    //         creates and returns a container, having loaded the store for the
    //         application to it. This property is optional since there are legitimate
    //         error conditions that could cause the creation of the store to fail.
    //        */
    //        let container = NSPersistentContainer(name: "WeTrack")
    //        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
    //            if let error = error as NSError? {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //
    //                /*
    //                 Typical reasons for an error here include:
    //                 * The parent directory does not exist, cannot be created, or disallows writing.
    //                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
    //                 * The device is out of space.
    //                 * The store could not be migrated to the current model version.
    //                 Check the error message to determine what the actual problem was.
    //                 */
    //                fatalError("Unresolved error \(error), \(error.userInfo)")
    //            }
    //        })
    //        return container
    //    }()
    //
    //    // MARK: - Core Data Saving support
    //
    //    func saveContext () {
    //        let context = persistentContainer.viewContext
    //        if context.hasChanges {
    //            do {
    //                try context.save()
    //            } catch {
    //                // Replace this implementation with code to handle the error appropriately.
    //                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    //                let nserror = error as NSError
    //                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
    //            }
    //        }
    //    }
    
    func reachabilityChanged(notification:Notification) {
        let reachability = notification.object as! Reachability
        if reachability.isReachable {
            if reachability.isReachableViaWiFi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            let file2 = "data.txt" //this is the file. we will write to and read from it
            
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let filePath = dir.appendingPathComponent(file2)
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + Constant.token
                    // "Accept": "application/json"
                ]
                
                // read from file
                if let dict2 = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as? [LocationHistory]{
                    for l in dict2{
                        
                        
                        let parameters: [String: Any] = [
                            "beacon_id" : l.beaconId,
                            "user_id" : Constant.user_id,
                            "longitude": l.long,
                            "latitude": l.lat
                        ]
                        Alamofire.request(Constant.URLreport , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                            let JSONS = response.result.value
                            print(" reponse offline\(JSONS)")
                        }
                        
                    }
                }
                
               
                
            }
            
            
        } else {
            print("Network not reachable")
        }
    }
    func resetAppToFirstController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController: LoginController? = (mainStoryboard.instantiateViewController(withIdentifier: "Login") as? LoginController)
        self.window.rootViewController = loginController
    }
}

