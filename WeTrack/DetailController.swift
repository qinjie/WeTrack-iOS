//
//  Detail.swift
//  WeTrack
//
//  Created by xuhelios on 1/25/17.
//  Copyright © 2017 beacon. All rights reserved.
//

//import UIKit
//
//class Detail: UIViewController {
//
//    @IBOutlet weak var residentPhoto: UIImageView!
//    @IBOutlet weak var name: UITextField!
//    
//    @IBOutlet weak var userId: UITextField!
//    @IBOutlet weak var bg: UIImageView!
//    @IBOutlet weak var remark: UITextField!
//    
//    var txt = ""
//    
//    var resident = Resident()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        name.text = resident.name
//        userId.text = resident.id.description
//        remark.text = resident.remark
//        if (resident.photo == ""){
//            residentPhoto.image = UIImage(named: "default_avatar")
//        }else{
//            let url = NSURL(string: Constant.photoURL + (resident.photo))
//            
//            //print("Urlimage \(url)")
//            
//            let data = NSData(contentsOf: url as! URL)
//            if data != nil {
//                residentPhoto.image = UIImage(data:data! as Data)
//            }
//        }
//        self.view.addConstraint(NSLayoutConstraint(item: residentPhoto, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
//        self.view.addConstraint(NSLayoutConstraint(item: name, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
//        self.view.addConstraint(NSLayoutConstraint(item: bg, attribute: .centerY, relatedBy: .equal, toItem: residentPhoto, attribute: .centerY, multiplier: 1.0, constant: 0.0))
//        residentPhoto.layer.cornerRadius = residentPhoto.frame.size.width / 2
//        residentPhoto.clipsToBounds = true
//        residentPhoto.layer.borderWidth = 5.0
//        bg.addSubview(residentPhoto)
//        
//        residentPhoto.layer.borderColor = UIColor.white.cgColor
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}


import UIKit

class DetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let tittles = ["NRIC", "DOB", "Status", "Remark", "Reported at"]
    var info = [String]()
    var res: Resident? {
        didSet {
            
            info = [(res?.nric)!, (res?.dob)!, (res?.status.description)!, (res?.remark)!, (res?.report)!, (res?.seen)! ]
            
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
        return CGSize(width: view.frame.width, height: 200)
    }
    
    func buy(){
        print("Byebyebyebay")
 
    }
    
    func changeStt(mySwitch: UISwitch) {
        if mySwitch.isOn {
            print("ON")
        }
        else {
            print ("OFF")
        }
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
            statusLabel.text = resident?.status.description
            locationLabel.text = resident?.seen
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
        label.font =  UIFont.italicSystemFont(ofSize: 17)
        
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.text = "Ngee Ann Poly"
        label.font = UIFont.italicSystemFont(ofSize: 17)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BUY", for: UIControlState())
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(DetailController.buy), for: .touchUpInside)
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
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        
        
        addConstraintsWithFormat("H:|-15-[v0(150)]-10-[v1]-10-|", views: imageView, nameLabel)
        addConstraintsWithFormat("H:|-15-[v0(150)]-10-[v1]-10-[v2]-10-|", views: imageView, locationLabel, buyButton)
        addConstraintsWithFormat("H:|-15-[v0(150)]-10-[v1]-10-[v2]-10-|", views: imageView, statusLabel, sttButton)
        
        addConstraintsWithFormat("V:|-15-[v0(150)]", views: imageView)
        
        addConstraintsWithFormat("V:|-15-[v0(30)]-20-[v1(32)]-20-[v2(32)]", views: nameLabel, sttButton, buyButton)
        addConstraintsWithFormat("V:|-15-[v0(30)]-20-[v1(32)]-20-[v2]", views: nameLabel, statusLabel, locationLabel)
        
        
        addConstraintsWithFormat("H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
    }
    
}




