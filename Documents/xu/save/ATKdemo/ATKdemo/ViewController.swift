//
//  ViewController.swift
//  ATKdemo
//
//  Created by xuhelios on 11/26/16.
//  Copyright © 2016 xuhelios. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func LoginButtonTapped(_ sender: Any) {
        
        if ((usernameTextField.text == "") || (passTextField.text == "")) {
            displayMyAlertMessage(mess: "All fields are required")
        }
        
        let username = usernameTextField.text
        let password = passTextField.text
        
        NSLog("========START TEST LOGIN =======")
        let parameters: [String: Any] = ["username": username,
                                         "password": password,
                                         "device_hash":"f8:32:e4:5f:77:4fff"
        ]
        
        let urlString = Constants.baseURL + "/atk-ble/api/web/index.php/v1/student/login"
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Parse error")
                return
            }
            
            let json = JSON(responseJSON)
            let name = json["name"].stringValue
            
            if (name == "Bad Request"){
                print("IT HAS ERROR WHEN LOGIN ")
                print(response.result.error)
                self.displayMyAlertMessage(mess: "username or pass or device is invalid")
                
            }else{
                if let data = response.result.value{
                    print("IT HAS DATA WHEN LOGIN ")
                    print(data)
                    // login successfull
                    UserDefaults.standard.set(true, forKey: "isUserLogin")
                    UserDefaults.standard.synchronize()
                    self.dismiss(animated: true, completion: nil)
                }
            }
            NSLog("//======END TEST LOGIN==========//")
        }
    }
    func loadAbc() {
        Alamofire.request("http://api.apixu.com/v1/current.json?key=3bf1a27308204a7a94e90405161911&q=Paris").responseJSON { response in
            
            guard let responseJSON = response.result.value as? [String: AnyObject] else {
                print("Parse error")
                return
            }
            let json = JSON(responseJSON)
            let location = json["location"]
            let name = location["name"].stringValue
            let region = location["region"].stringValue
            NSLog("\(name) +   \(region)"  )
            
        }
    }
    
    func testLogin(){
        NSLog("========START TEST LOGIN =======")
        let parameters: [String: Any] = ["username":"zhangqinjie",
                                         "password":"123456",
                                         // "device_hash":"f8:32:e4:5f:6f:35"
        ]
        
        let urlString = Constants.baseURL + "/atk-ble/api/web/index.php/v1/lecturer/login"
        Alamofire.request(urlString, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse) in
            
            /*   switch(response.result) {
             case .success(_):
             print("IT OK WHEN LOGIN ")
             if let data = response.result.value{
             print("IT HAS DATA WHEN LOGIN ")
             print(data)
             }
             break
             
             case .failure(_):
             print("IT HAS ERROR WHEN LOGIN ")
             print(response.result.error)
             break
             }
             }*/
            
            NSLog("//======END TEST LOGIN==========//")
        }
    }
    func displayMyAlertMessage(mess : String){
        
        var myAlert = UIAlertController(title: "Alert", message: mess, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK!!", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    /*
     let usernameStored = UserDefaults.standard.string(forKey: "username")
     let passwordStored = UserDefaults.standard.string(forKey: "password")
     if ((username == usernameStored) && (password == passwordStored)){
     // login successfull
     
     UserDefaults.standard.set(true, forKey: "isUserLogin")
     UserDefaults.standard.synchronize()
     dismiss(animated: true, completion: nil)
     }*/
}

