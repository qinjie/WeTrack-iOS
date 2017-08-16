//
//  ResidentDetailPage.swift
//  WeTrack
//
//  Created by xuhelios on 2/28/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import Alamofire
import UIKit

class ResidentDetailPage: UITableViewController {
    @IBOutlet weak var tbl : UITableView!

    var resident: Resident?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.estimatedRowHeight = 70
        tbl.tableFooterView = UIView.init(frame: CGRect.zero)
        tbl.rowHeight = UITableViewAutomaticDimension
        
        if (resident?.photo == ""){
            photo.image = UIImage(named: "default_avatar")
        }else{
            let url = NSURL(string: Constant.photoURL + (resident?.photo)!)
            
            //print("Urlimage \(url)")
            
            let data = NSData(contentsOf: url as! URL)
            if data != nil {
                photo.image = UIImage(data:data! as Data)
            }
        }
        
        name.text = resident?.name
        
        status.text = resident?.status.description
        
        if (resident?.status == true){
            status.text = "Missing"
            switchBtn.isOn = true
        }else{
            switchBtn.isOn = false
            status.text = "Available"
        }

        
        if (!(resident?.isRelative)!){
            
            switchBtn.isHidden = true
        }
        if (self.resident?.lastestLocation != nil) {
            address.text = resident?.lastestLocation?.address
        }
        //
        
        nric.text = resident?.nric
        
        dob.text = resident?.dob

        remark.text = resident?.remark
        
        if (resident?.status == true) {
            lblStatus.text = "Missing"
            lblStatus.textColor = UIColor.redApp
        } else {
            lblStatus.text = "Available"
            lblStatus.textColor = UIColor.mainApp
        }
        
        var beacon_detect : Beacon?
        if (resident?.lastestLocation != nil) {
            let beacon_id = Int(resident!.lastestLocation!.beacon_id)
            for item in (resident?.beacons)! {
                if (item.id == beacon_id) {
                    beacon_detect = item
                    break
                }
            }
        }
        if (resident?.lastestLocation != nil) {
            lblBeaconLocation.text = resident!.lastestLocation!.address
        } else {
            lblBeaconLocation.text = "Unknown"
        }
        
        if (resident?.beacons?.count == 0) {
            lblBeaconBelong.text = "No beacon"
            lblBeaconBelong.textColor = UIColor.yellowApp
        } else {
            var text = ""
            if ((self.resident?.beacons) != nil){
                for item in (self.resident?.beacons!)! {
                    let str = item.toString()
                    text = text + " - " + str + "\n"
                }
                lblBeaconBelong.text = text
                lblBeaconBelong.textColor = UIColor.black
            }
            
        }
        
        if (beacon_detect != nil ) {
            lblBeaconDetect.text = beacon_detect!.name
            
        } else {
            lblBeaconDetect.text = "Unknown"
        }
    }

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var nric: UILabel!
    @IBOutlet weak var dob: UILabel!
    @IBOutlet weak var remark: UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblBeaconDetect : UILabel!
    @IBOutlet weak var lblBeaconLocation : UILabel!
    @IBOutlet weak var lblBeaconBelong : UILabel!
    
    
    @IBAction func openMap(_ sender: Any) {
        var testURL = URL(string: "comgooglemaps-x-callback://")
        if (UIApplication.shared.canOpenURL(testURL!) && (resident?.lastestLocation != nil)) {
            let add = resident!.lastestLocation!.address
            let lat = resident!.lastestLocation!.latitude
            let lon = resident!.lastestLocation!.longitude
            print("add \(add)")
            
            var directionsRequest: String = "comgooglemaps://?q=\(add)&center=\(lat),\(lon)&zoom=15"
            print("\(directionsRequest)")
            var directionsURL = URL(string: directionsRequest)
            UIApplication.shared.openURL(directionsURL!)
        } else {
            self.displayMyAlertMessage(title: "Warning", mess: "Address is not available")
        }
    }
    
    @IBAction func changeStt(_ sender: Any) {
        
        
            // report missing
        if (self.switchBtn.isOn){
            
        
        
            let alert = UIAlertController(title: "Report Missing Relative", message: "Remark", preferredStyle: UIAlertControllerStyle.alert)
            
            
            
            alert.addAction(UIAlertAction(title: "Report", style: UIAlertActionStyle.default, handler: { action in
                let rm = alert.textFields![0] as UITextField
                
                let parameters: [String: Any] = [
                    "id" : self.resident?.id,
                    "remark" : rm.text
                ]
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + Constant.token
                    // "Accept": "application/json"
                ]
                
                self.resident?.remark = rm.text!
                self.remark.text = rm.text!
                
                DispatchQueue.main.async(execute: {
                    
                    Alamofire.request(Constant.URLstatus , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                        let JSONS = response.result.value
                        print(" reponse\(JSONS)")
                    }
                })

                    self.status.text = "Missing"
                    self.status.textColor = UIColor.redApp
                    self.resident?.status = true
             
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                
            
                self.switchBtn.isOn = !self.switchBtn.isOn
                self.switchBtn.setOn(self.switchBtn.isOn, animated: true)
                
                self.status.text = "Available"
                self.status.textColor = UIColor.mainApp
            
                self.resident?.status = false
                
                
            }))
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Remark"
                textField.textAlignment = .center
            })
            
            self.present(alert, animated: true, completion: nil)
        }else{
            
            self.status.text = "Available"
      
            self.resident?.status = false
            let parameters: [String: Any] = [
                "id" : self.resident?.id,
                "remark" : ""
            ]
            
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Constant.token
                // "Accept": "application/json"
            ]
            
            DispatchQueue.main.async(execute: {
                
                Alamofire.request(Constant.URLstatus , method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
                    let JSONS = response.result.value
                    print(" reponse\(JSONS)")
                }
            })

            
        }
        
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

