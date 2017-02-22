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

class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate{
    

    @IBOutlet weak var usernameTxt: UITextField!
    
    @IBOutlet weak var passTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  let loginButton = FBSDKLoginButton()
        
       
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
         setupGoogleButtons()
        
        
     //   let ref = FIRDatabase.database().reference(fromURL: "https://wetrack2-79f58.firebaseio.com/")
        
    
        
        // Do any additional setup after loading the view.
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            return
        }
        
        print("Successfully logged into Google", user)
        
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
            print("Successfully logged into Firebase with Google", uid)
            self.loginWithEmail(email: "eceiot.np@gmail.com")
        })
    }
    
    fileprivate func setupGoogleButtons() {
        //add google sign in button
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 50)
       // view.addSubview(googleButton)
    }
    
       /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The button that was clicked.
     */
//    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
//        
//        print("Logout of facebook")
//    }
//    
//    /**
//     Sent to the delegate when the button was used to login.
//     - Parameter loginButton: the sender
//     - Parameter result: The results of the login
//     - Parameter error: The error (if any) from the login
//     */
//    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
//        if error != nil {
//            print(error)
//            return
//        }
//        
//        
//        print("Successfully logged in with facebook...")
//    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginwgg(_ sender: Any) {
        
        
        GIDSignIn.sharedInstance().signIn()
        
        
    }

    @IBAction func loginwfb(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
//        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
//            if err != nil {
//                print("Custom FB Login failed:", err)
//                return
//            }
//            
//            self.showEmailAddress()
//        }
    }
    
//    func showEmailAddress() {
//        
//        let accessToken = FBSDKAccessToken.current()
//        guard let accessTokenString = accessToken?.tokenString else { return }
//        
//        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
//        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
//            if error != nil {
//                print("Something went wrong with our FB user: ", error ?? "")
//                return
//            }
//            
//            print("Successfully logged in with our user: ", user ?? "")
//        })
//        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "email"]).start(completionHandler: {(connection, result, error) in
//            
//            if error != nil {
//                print("Failed to start graph request")
//                return
//            }
//            
//            if let userDict = result as? NSDictionary{
//                
//                let email = userDict["email"] as? String
//                print("user Email \(email)")
//                
//                self.loginWithEmail(email: "eceiot.np@gmail.com")
//            }
//            
//        })
//    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        if ((usernameTxt.text != "") && (passTxt.text != "")) {
            
            loginWithEmail(email: usernameTxt.text!)
        
        }
        else{
    
            //displayMyAlertMessage(mess: "All fields are required")
    
        }

    }

    
    func loginWithEmail(email: String){
        
        //Wating dialog
        let alertController = UIAlertController(title: nil, message: "Please wait...\n\n", preferredStyle: UIAlertControllerStyle.alert)
        let spinnerIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
        spinnerIndicator.color = UIColor.black
        spinnerIndicator.startAnimating()
        alertController.view.addSubview(spinnerIndicator)
        self.present(alertController, animated: false, completion: nil)
        
        let parameters: Parameters = [
            
            "email": email
        ]
        
        Alamofire.request(Constant.URLlogin, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            if let JSON = response.result.value as? [String: Any] {
                print("\(JSON)")
                let result = JSON["result"] as! String
                
                if (result == "correct"){
                    Constant.token = JSON["token"] as! String
                    Constant.id = JSON["user_id"] as! Int
                    Constant.username = JSON["username"] as! String
                    self.loadRelativeList()
                    print("Username \(Constant.username)")
                    print("tokenlogin =  \(Constant.token)")
                    UserDefaults.standard.set(Constant.username, forKey: "username")

                }
                else{
                    alertController.dismiss(animated: true, completion: nil)
                    self.displayMyAlertMessage(mess: "Username or Password is Invalid!")
                }
                
            }
            else{
                //                if (statusCode == 400){
                //                    DispatchQueue.main.async(execute: {
                //                        alertController.dismiss(animated: true, completion: nil)
                //                        //    self.txtErrorMessage.text = "Incorrect data!"
                //                    })
                //                }
                //                else{
                //                    DispatchQueue.main.async(execute: {
                //                        alertController.dismiss(animated: true, completion: nil)
                //                        //  self.txtErrorMessage.text = "Server error!"
                //                    })
                //                }
            }
        }

    }
    
    func loadRelativeList(){
        
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Constant.token
            // "Accept": "application/json"
        ]
        
        Alamofire.request(Constant.URLall, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            
            GlobalData.allResidents = [Resident]()
          
            if let JSON = response.result.value as? [[String: Any]] {
   
                for json in JSON {
                    
                    let newResident = Resident()
                    
                    newResident.status = (json["status"] as? Bool)!
                    
                    newResident.name = (json["fullname"] as? String)!
                    newResident.id = (json["id"] as? Int32)!
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
                            if (x == Constant.id){
                                print("\(json["fullname"])")
                                newResident.isRelative = true
                                break
                            }
                        }
                    }
                
                    GlobalData.allResidents.append(newResident)
                    
                    
                }
            }
            print(" all re1 \(GlobalData.allResidents.count)")
            DispatchQueue.main.async(execute: {
                //alertController.dismiss(animated: true, completion: nil)
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                }
            })
        }

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
    func displayMyAlertMessage(mess : String){
        
        var myAlert = UIAlertController(title: "Alert", message: mess, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK!!", style: UIAlertActionStyle.default, handler: nil)
        
        myAlert.addAction(okAction)
        
        self.present(myAlert, animated: true, completion: nil)
        
    }
}
