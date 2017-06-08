//
//  LoginController.swift
//  WeTrack
//
//  Created by xuhelios on 1/18/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseAuth
import GoogleSignIn
import SwiftyJSON

class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  let loginButton = FBSDKLoginButton()
        
       // Constant.device_token = UserDefaults.standard.string(forKey: "devicetoken")!
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        setupGoogleButtons()
        
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        
        //   let ref = FIRDatabase.database().reference(fromURL: "https://wetrack2-79f58.firebaseio.com/")
        
   
    }


    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
       
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        
        
        if let err = error {
            print("Failed to log into Google: ", err)
                       return
        }
        
        print("Successfully logged into Google", user)
        self.present(alertController, animated: false, completion: nil)
        guard let idToken = user.authentication.idToken else { return }
        guard let accessToken = user.authentication.accessToken else { return }
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error {
                print("Failed to create a Firebase User with Google account: ", err)
                return
            }
            
            guard let uid = user?.uid else { return }
            print("user email login \(user?.email) ")
            
            Constant.userphoto = user?.photoURL


            print("Successfully logged into Firebase with Google", uid)
            self.loginWithEmail(email: (user?.email)!)
        })
    }
    
    @IBOutlet weak var loginAnoBtn: UIButton!
    
    fileprivate func setupGoogleButtons() {
        //add google sign in button
       
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func loginwgg(_ sender: Any) {
        

        Constant.device_token = UserDefaults.standard.string(forKey: "devicetoken")!
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    //Wating dialog
    let alertController = UIAlertController(title: nil, message: "Please wait...\n\n", preferredStyle: UIAlertControllerStyle.alert)
    let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
    
    
   
    
    
    func loginWithEmail(email: String){
        
 
        let parameters: Parameters = [
            
            "email": email
        ]
        
         print("email\(email)")
        
        
        Alamofire.request(Constant.URLlogin, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                print("\(JSON)")
                let result = JSON["result"] as! String
                
                if (result == "correct"){
                    Constant.token = JSON["token"] as! String
                    Constant.user_id = JSON["user_id"] as! Int
                    Constant.username = JSON["username"] as! String
                    Constant.role = JSON["role"] as! Int
                    self.createDeviceTk()
                    UserDefaults.standard.set(Constant.username, forKey: "username")
                    UserDefaults.standard.set(Constant.token, forKey: "token")
                    UserDefaults.standard.set(Constant.user_id, forKey: "userid")
                    UserDefaults.standard.set(Constant.role, forKey: "role")
                }
                else{
                    self.alertController.dismiss(animated: true, completion: nil)
                    self.displayMyAlertMessage(title: "LOGIN FAILED", mess: "This function can only be used by registered user. You can go to nearest police station for registration or use Anonymous login!")
                    do {
                        GIDSignIn.sharedInstance().signOut()
                        // Set the view to the login screen after signing out
                        
                    } catch let signOutError as NSError {
                        print ("Error signing out: \(signOutError)")
                    }

                    do {
                        GIDSignIn.sharedInstance().signOut()
                        // Set the view to the login screen after signing out
                        
                    } catch let signOutError as NSError {
                        print ("Error signing out: \(signOutError)")
                    }

                }
                
            }
            else{
                self.alertController.dismiss(animated: true, completion: nil)
                self.displayMyAlertMessage(title: "LOGIN FAILED", mess: "Please check Internet connection!")
                
            }
        }

    }
    
    
    func loadRelativeList(){
        
        print("constant token \(Constant.token)")
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constant.token
            // "Accept": "application/json"
        ]
        
        Alamofire.request(Constant.URLall, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            GlobalData.allResidents = [Resident]()
            
            if let JSON = response.result.value as? [[String: Any]] {
                
                Constant.isLogin = true
                print("\(JSON)")
                for json in JSON {
                    
                    let newResident = Resident()
                    
                    newResident.status = (json["status"] as? Bool)!
                    
                    newResident.name = (json["fullname"] as? String)!
                    newResident.id = String((json["id"] as? Int)!)
                    newResident.photo = (json["image_path"] as? String)!
                    newResident.remark = (json["remark"] as? String)!
                    newResident.nric = (json["nric"] as? String)!
                    newResident.dob = (json["dob"] as? String)!
                    
                    
                    if let location = json["locations"] as? [[String: Any]]{
                        if (location.count > 0){
                            if let add = location[0]["address"] as? String {
                                newResident.address = add
                            }
                            if let add = location[0]["latitude"] as? String{
                                newResident.lat = add
                            }
                            
                            if let add = location[0]["longitude"] as? String{
                                newResident.long = add
                            }
                            
                            print("add \(newResident.address)")
                        }
                    }
             
                        if let relatives = json["relatives"] as? [[String: Any]]{
                            
                            for relative in relatives{
                                
                                let x = relative["id"] as! Int
                                print("relative id \(x)")
                                if (x == Constant.user_id){
                                 //   print("relative \(json["fullname"])")
                                    newResident.isRelative = true
                                    break
                                }
                            }
                

                    }
                    
                    GlobalData.allResidents.append(newResident)
                    
                    
                }
                DispatchQueue.main.async(execute: {
                    //alertController.dismiss(animated: true, completion: nil)
                    OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "loginSegue", sender: nil)
                    }
                })
            }
            
            print(" all re1 \(GlobalData.allResidents.count)")
            
            GlobalData.relativeList = GlobalData.allResidents.filter({$0.isRelative == true})
            
            var file = "allresident.txt" //this is the file. we will write to and read from it
            
            
            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                var filePath = dir.appendingPathComponent(file)
                
                // write to file
                NSKeyedArchiver.archiveRootObject(GlobalData.allResidents, toFile: filePath.path)
                
                file = "relative.txt"
                
                filePath = dir.appendingPathComponent(file)
                
                NSKeyedArchiver.archiveRootObject(GlobalData.relativeList, toFile: filePath.path)
                
                // read from file
//                let dict2 = NSKeyedUnarchiver.unarchiveObject(withFile: filePath.path) as! [Resident]
//                
//                for y in dict2{
//                    print("testlocal \(y.name)")
//                    print("testlocal \(y.isRelative)")
//                }
                
            }
            
            
        }
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        // Login Anonymously
 
        Constant.user_id = 0
        Constant.device_token = UserDefaults.standard.string(forKey: "devicetoken")!
        UserDefaults.standard.set("Anonymous", forKey: "username")
        UserDefaults.standard.set(Constant.user_id, forKey: "userid")
        Constant.username = "Anonymous"
        //print("device token  \(Constant.device_token)")
        
        createDeviceTk()
        
        
    }
    
    func createDeviceTk(){
        
        let parameters: Parameters = [
            
            "token": Constant.device_token,
            "user_id": Constant.user_id
        ]
        
        Alamofire.request(Constant.URLcreateDeviceTk, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                print("\(JSON)")
                let result = JSON["result"] as! String
                if (result == "correct" && Constant.user_id == 0){
                    Constant.token = JSON["token"] as! String
                    Constant.user_id = JSON["user_id"] as! Int
                    print("newid \(Constant.user_id)")
                    Constant.username = "Anonymous"
                    Constant.role = JSON["role"] as! Int
                    UserDefaults.standard.set(Constant.user_id, forKey: "userid")
                    UserDefaults.standard.set(Constant.role, forKey: "role")
                    UserDefaults.standard.set(Constant.token, forKey: "token")
                }
                self.loadRelativeList()
                
            }
            
            
        }
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
extension UIViewController {
    //    func hideKeyboardWhenTappedAround() {
    //        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    //        view.addGestureRecognizer(tap)
    //    }
    //    
    //    func dismissKeyboard() {
    //        view.endEditing(true)
    //    }
    //    
    func displayMyAlertMessage(title: String, mess : String){
        
        let myAlert = UIAlertController(title: title, message: mess, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK!!", style: UIAlertActionStyle.default, handler: nil)
        
      
       
        myAlert.addAction(okAction)
        
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
}
