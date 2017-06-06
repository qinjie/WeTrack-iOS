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

    var resident: Resident?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        address.text = resident?.address
        
        nric.text = resident?.nric
        
        dob.text = resident?.dob

        remark.text = resident?.remark
        
        reported.text = resident?.report
        if (resident?.status == true) {
            lblStatus.text = "Available"
        } else {
            lblStatus.text = "None"
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
    @IBOutlet weak var reported: UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var lblBeaconDetect : UILabel!
    @IBOutlet weak var lblBeaconLocation : UILabel!
    @IBOutlet weak var lblBeaconBelong : UILabel!
    
    
    @IBAction func openMap(_ sender: Any) {
        var testURL = URL(string: "comgooglemaps-x-callback://")
        if UIApplication.shared.canOpenURL(testURL!) {
            let add = (resident?.address.replacingOccurrences(of: " ", with: "+"))! as String
            print("add \(add)")
            var directionsRequest: String = "comgooglemaps://?q=" + add + "&center=" + (resident?.lat)! + "," + (resident?.long)! + "&zoom=15"
            print("\(directionsRequest)")
            var directionsURL = URL(string: directionsRequest)
            UIApplication.shared.openURL(directionsURL!)
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
                    self.resident?.status = true
             
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                
            
                self.switchBtn.isOn = !self.switchBtn.isOn
                self.switchBtn.setOn(self.switchBtn.isOn, animated: true)
                
                self.status.text = "Available"
            
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

}
