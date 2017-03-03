//
//  Detail.swift
//  WeTrack
//
//  Created by xuhelios on 1/25/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import Alamofire
import UIKit

class DetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let tittles = ["NRIC", "DOB", "Status", "Remark", "Reported at"]
    var info = [String]()
    var res: Resident? {
        didSet {
            
            info = [(res?.nric)!, (res?.dob)!, (res?.status.description)!, (res?.remark)!, (res?.report)! ]
            
        }
    }
    
    fileprivate let headerId = "headerId"
    fileprivate let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        //collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.register(AppInfoCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppInfoCell
        
        cell.tittleView.text = tittles[indexPath.item]
        cell.infoView.text = info[indexPath.item]
        //cell.app = app
        
        return cell
    }
    
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppDetailHeader
        header.resident = res
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    
    func map(){
      
        var testURL = URL(string: "comgooglemaps-x-callback://")
        if UIApplication.shared.canOpenURL(testURL!) {
            let add = (res?.address.replacingOccurrences(of: " ", with: "+"))! as String
            print("add \(add)")
            var directionsRequest: String = "comgooglemaps://?q=" + add + "&center=" + (res?.lat)! + "," + (res?.long)! + "&zoom=15"
            print("\(directionsRequest)")
            var directionsURL = URL(string: directionsRequest)
            UIApplication.shared.openURL(directionsURL!)
        }

 
    }
    
    func changeStt(mySwitch: UISwitch) {
        
        if mySwitch.isOn {
            print("ON")
            res?.status = true
            
            // report missing
            let alert = UIAlertController(title: "Report Missing Relative", message: "Remark", preferredStyle: UIAlertControllerStyle.alert)
            
           
           
            alert.addAction(UIAlertAction(title: "Report", style: UIAlertActionStyle.default, handler: { action in
                 let remark = alert.textFields![0] as UITextField
                
                let parameters: [String: Any] = [
                    "id" : Constant.user_id,
                    "remark" : remark.text
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
                
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { action in
                
                mySwitch.isOn = false
                mySwitch.setOn(false, animated: true)
                self.res?.status = false
                
            }))
            alert.addTextField(configurationHandler: { (textField) -> Void in
                textField.placeholder = "Remark"
                textField.textAlignment = .center
            })
            
            self.present(alert, animated: true, completion: nil)
            
        }
        else {
            print ("OFF")
            res?.status = false
        }
        self.info[2] = (res?.status.description)!
        self.collectionView?.reloadData()
    }
    
}



class AppInfoCell: BaseCell {
    
    let tittleView: UILabel = {
        let label = UILabel()
        label.text = "Xu Helios"
        
        label.font = UIFont.systemFont(ofSize: 15)
        
        return label
    }()
    
    let infoView: UILabel = {
        let label = UILabel()
        label.text = "Xu Helios"
        
        label.font = UIFont.boldSystemFont(ofSize: 17)
        
        return label
    }()
    
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(tittleView)
        addSubview(dividerLineView)
        addSubview(infoView)
        
        addConstraintsWithFormat("H:|-15-[v0]-8-|", views: tittleView)
        addConstraintsWithFormat("H:|-25-[v0]-8-|", views: infoView)
        addConstraintsWithFormat("H:|-14-[v0]|", views: dividerLineView)
        
        addConstraintsWithFormat("V:|-5-[v0]-7-[v1]-7-[v2(1)]|", views: tittleView, infoView, dividerLineView)
    }
    
}

class AppDetailHeader: BaseCell {
    
    var resident: Resident? {
        didSet {
            
            nameLabel.text = resident?.name
            
           // idLabel.text = resident?.id.description
            
            //let url = Constant.photoURL + (resident?.photo)!
            
            if (resident?.photo == ""){
                imageView.image = UIImage(named: "default_avatar")
            }else{
                let url = NSURL(string: Constant.photoURL + (resident?.photo)!)
                
                //print("Urlimage \(url)")
                
                let data = NSData(contentsOf: url as! URL)
                if data != nil {
                    imageView.image = UIImage(data:data! as Data)
                }
            }
            if (resident?.status == true){
                statusLabel.text = "Missing"
                sttButton.isOn = true
            }else{
                sttButton.isOn = false
                statusLabel.text = "Available"
            }
         
            sttButton.isHidden = !(resident?.isRelative)!
            
            locationLabel.text = resident?.address
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.textAlignment = .center
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.font = UIFont(name: "Futura", size: 25)
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Avaitable"
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.font =  UIFont.italicSystemFont(ofSize: 16)
        
        return label
    }()
    

    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.text = "Ngee Ann Poly"
        label.numberOfLines = 2
        label.font = UIFont.italicSystemFont(ofSize: 15)
        return label
    }()
    
    let mapButton: UIButton = {
        let button = UIButton()
        
      //  button.setTitle("BUY", for: UIControlState())

        let image = UIImage(named: "ggmap") as UIImage?
        
        button.setImage(image, for: .normal)
        //button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
      
        button.addTarget(self, action: #selector(DetailController.map), for: .touchUpInside)
        return button
    }()
    
    let sttButton: UISwitch  = {
        let button = UISwitch()
        button.addTarget(self, action: #selector(DetailController.changeStt), for: UIControlEvents.valueChanged)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(imageView)
        addSubview(sttButton)
        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(locationLabel)
        addSubview(mapButton)
        addSubview(dividerLineView)
        
        
        
        addConstraintsWithFormat("H:|-15-[v0(120)]-10-[v1]-10-|", views: imageView, nameLabel)
        
        addConstraintsWithFormat("H:|-15-[v0(120)]-10-[v1]-10-[v2]-10-|", views: imageView, statusLabel, sttButton)
        addConstraintsWithFormat("H:|-15-[v0(120)]-10-[v1]-10-[v2(50)]-10-|", views: imageView, locationLabel, mapButton)
        addConstraintsWithFormat("V:|-15-[v0(120)]", views: imageView)
        
        addConstraintsWithFormat("V:|-15-[v0(30)]-15-[v1(32)]-12-[v2(50)]", views: nameLabel, sttButton, mapButton)
        addConstraintsWithFormat("V:|-15-[v0(30)]-15-[v1(32)]-12-[v2(50)]", views: nameLabel, statusLabel, locationLabel)
        
        addConstraintsWithFormat("H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
    }
    
}




