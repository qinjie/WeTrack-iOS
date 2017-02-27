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
import CoreBluetooth

class SettingController: UITableViewController, CBPeripheralManagerDelegate {
    
    
    @IBOutlet weak var usernameLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLb.text = Constant.username.uppercased()

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
    
  
    
    @IBAction func logout(_ sender: Any) {
        
        
    
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableScanning"), object: nil)
            
         
        
     
        
        UserDefaults.standard.removeObject(forKey: "username")
        deleteDeviceTk()
        
        if (Constant.role != 5){
            do {
                GIDSignIn.sharedInstance().signOut()
                               // Set the view to the login screen after signing out
               
            } catch let signOutError as NSError {
                print ("Error signing out: \(signOutError)")
            }
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.resetAppToFirstController()
        

        
        
    }
    
    func deleteDeviceTk(){
        
        let parameters: Parameters = [
            "token": Constant.device_token,
            "user_id": Constant.user_id
        ]
        
        Alamofire.request(Constant.URLdelDeviceTk, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
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
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)
            
        }else{
            
            Constant.isScanning = false
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableScanning"), object: nil)
            
        }
    }
    
    var bluetoothPeripheralManager: CBPeripheralManager?
    
    func turnOnBlt(){
        var bluetoothManager = BluetoothManagerHandler.sharedInstance()
        
        bluetoothManager?.setPower(true)
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
    
}
