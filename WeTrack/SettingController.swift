//
//  TableViewController.swift
//  WeTrack
//
//  Created by xuhelios on 2/21/17.
//  Copyright © 2017 beacon. All rights reserved.
//
import FirebaseAuth
import UIKit
import Alamofire
import GoogleSignIn
import CoreBluetooth
import SwiftyJSON

class SettingController: BaseTableViewController, CBPeripheralManagerDelegate {
    
    
    @IBOutlet weak var userprofile: UIImageView!
    @IBOutlet weak var usernameLb: UILabel!
    
    @IBOutlet weak var lblEmail : UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLb.text = Constant.username
        lblEmail.text = Constant.email
        navigationItem.title = "Setting"
      
        if (Constant.role != 5){
            if (Constant.userphoto != nil){
                let photo = NSData(contentsOf: Constant.userphoto!)
                if (photo != nil){
                    userprofile.image = UIImage(data: photo as! Data)
                }
                
            }
        }else{
            
            userprofile.image = UIImage(named: "default_avatar")
        }
        
        self.tableView.separatorColor = UIColor.seperatorApp
            
    
        
        bluetoothPeripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func deleteData() {
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "userid")
        UserDefaults.standard.removeObject(forKey: "role")
        UserDefaults.standard.removeObject(forKey: "email")
    }
    
    func logOut() {
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableScanning"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "logout"), object: nil)
        
        
        
        
        
        deleteDeviceTk()
        
    }
  
    
    @IBAction func logout(_ sender: Any) {
        self.logOut()
    }
    
    func deleteDeviceTk(){
        self.showLoadingHUD()
        let httpHeader : [String : String] = ["Authorization" : "Bearer " + Constant.token]
        Alamofire.request(Constant.URLLogout, method: .get, parameters: nil, headers: httpHeader).responseJSON { (response) in
            if (response.data != nil) {
                let json = JSON.init(data: response.data!)
                let parameters: Parameters = [
                    "token": Constant.device_token,
                    "user_id": Constant.user_id
                ]
                
                
                Alamofire.request(Constant.URLdelDeviceTk, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                    self.hideLoadingHUD()
                    if (response.data != nil) {
                        self.deleteData()
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.resetAppToFirstController()
                        
                        let json = JSON.init(data: response.data!)
                        if (Constant.role != 5){
                            do {
                                GIDSignIn.sharedInstance().signOut()
                                
                                // Set the view to the login screen after signing out
                                
                            } catch let signOutError as NSError {
                                print ("Error signing out: \(signOutError)")
                            }
                        }
                        
                    } else {
                        self.displayMyAlertMessage(title: "No internet connect", mess: "")
                    }
                    
                }

                
            } else {
                self.displayMyAlertMessage(title: "Warning", mess: "No internet connection")
            }
        }
           }
    
    @IBOutlet weak var switchNotiBtn: UISwitch!
    @IBAction func switchNoti(_ sender: Any) {
        
        if (switchNotiBtn.isOn){
            
            Constant.noti = true
            
        }else{
            
            Constant.noti = false
        }
    }
    
    @IBOutlet weak var switchScanBtn: UISwitch!
    
    @IBAction func switchScan(_ sender: Any) {
        
        if (switchScanBtn.isOn){
            
            Constant.isScanning = true
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "enableScanning"), object: nil)
            let alert = UIAlertController(title: "Bluetooth Turn on Request", message: " WeTrack would like to use your bluetooth!", preferredStyle: UIAlertControllerStyle.alert)
            
            // add the actions (buttons)
            alert.addAction(UIAlertAction(title: "Allow", style: UIAlertActionStyle.default, handler: { action in
                    self.turnOnBlt()
                }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {action in
                self.switchScanBtn.isOn = false
                Constant.isScanning = false
                self.turnOffBlt()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableScanning"), object: nil)
            }))

            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            Constant.isScanning = false
            self.turnOffBlt()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableScanning"), object: nil)
            
        }
    }
    
    var bluetoothPeripheralManager: CBPeripheralManager?
    
    func turnOffBlt() {
//        let bluetoothManager = BluetoothManagerHandler.sharedInstance()
//        bluetoothManager?.disable()
//        bluetoothManager?.setPower(false)
    }
    
    func turnOnBlt(){
//        let bluetoothManager = BluetoothManagerHandler.sharedInstance()
//        bluetoothManager?.enable()
//        bluetoothManager?.setPower(true)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        var statusMessage = ""
        
        switch peripheral.state {
        case .poweredOn:
            statusMessage = "Bluetooth Status: \n Turned On"
            
        case .poweredOff:
            
            print("off blt")
            switchScanBtn.isOn = false
            switchScanBtn.setOn(false, animated: true)
            Constant.isScanning = false
            
        case .resetting:
            statusMessage = "Bluetooth Status: \n Resetting"
            
        case .unauthorized:
            statusMessage = "Bluetooth Status: \n Not Authorized"
            
        case .unsupported:
            statusMessage = "Bluetooth Status: \n Not Supported"
            
        default:
            statusMessage = "Bluetooth Status: \n Unknown"
        }
        
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if ((indexPath.section == 2) && (indexPath.row == 0)) {
            self.logOut()
        }
    }
}
