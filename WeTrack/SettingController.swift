//
//  TableViewController.swift
//  WeTrack
//
//  Created by xuhelios on 2/21/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import Alamofire
import CoreBluetooth

class SettingController: UITableViewController, CBPeripheralDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        deleteDeviceTk()
        
        UserDefaults.standard.removeObject(forKey: "username")
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
            turnOnBlt()
        }else{
            
            Constant.isScanning = false
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "disableScanning"), object: nil)
            
        }
    }
    
    func turnOnBlt(){
        var bluetoothManager = BluetoothManagerHandler.sharedInstance()
        
        bluetoothManager?.enabled()
    }
    // MARK: - Table view data source
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
