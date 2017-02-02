//
//  LoginController.swift
//  WeTrack
//
//  Created by xuhelios on 1/18/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import Alamofire


class LoginController: UIViewController{

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func loginTapped(_ sender: Any) {
        
        //Wating dialog
        
        loadServerList()
 
        //for Location Manager
        DispatchQueue.main.async(execute: {
            
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            
            //                }
        })
        
    }

    
    func loadServerList(){
        var today = Date()
        print("now1 \(today)")
//        let alertController = UIAlertController(title: nil, message: "Please wait...\n\n", preferredStyle: UIAlertControllerStyle.alert)
//        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
//        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
//        spinnerIndicator.color = UIColor.black
//        spinnerIndicator.startAnimating()
//        alertController.view.addSubview(spinnerIndicator)
//        self.present(alertController, animated: false, completion: nil)
        
        UserDefaults.standard.set("xuhelios", forKey: "username")

        

    }
    
    
    
    
    func clearLocal() {
       /* try! realm.write {
            realm.delete(Beacon.self)
            realm.delete(Resident.self)
        }*/
//        let delegate = UIApplication.shared.delegate as? AppDelegate
//        
//        if let context = delegate?.persistentContainer.viewContext {
//            
//            do {
//                
//                let entityNames = ["Beacon"]
//                
//                for entityName in entityNames {
//                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
//                    
//                    let objects = try(context.fetch(fetchRequest)) as? [NSManagedObject]
//                    
//                    for object in objects! {
//                        context.delete(object)
//                    }
//                    
//                }
//                
//                try(context.save())
//                
//            } catch let err {
//                print(err)
//            }
//            
//        }
    }
    
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
