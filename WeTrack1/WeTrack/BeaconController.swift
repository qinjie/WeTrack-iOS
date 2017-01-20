//
//  BeaconController.swift
//  WeTrack
//
//  Created by xuhelios on 1/19/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

class BeaconController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var beacons : [Beaconx]?
    
    fileprivate let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.beacons = GlobalData.history
        self.collectionView!.reloadData()
        
    }

    
    // send information of 2 classmates you detected to server
    // if it sends successfully, you will take attendance successfully
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupData()
        self.beacons = GlobalData.history
       // self.beacons = [Beaconx]()
     //   self.collectionView!.reloadData()
        
        
        //for location
        
        // for Collection View
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        navigationItem.title = "Beacon Detecting"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(BeaconCell.self, forCellWithReuseIdentifier: cellId)

        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = beacons?.count {
            
            return count
            
        }
  
        return 2
    }
    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
////        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BeaconCell
////        if let beacon = beacons?[indexPath.item] {
////            cell.beacon = beacon
////        }
//        let cell = BeaconCell()
//        return cell
//        
//    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BeaconCell
        
        // Configure the cell
        if let beacon = beacons?[indexPath.item] {
            cell.beacon = beacon
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let controller = UIViewController()
        
        navigationController?.pushViewController(controller, animated: true)
        
        //                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ResidentInfo") as! ResidentInfo
        //                self.navigationController?.pushViewController(controller, animated: true)
        //                if self.navigationController != nil {
        //                    self.navigationController?.pushViewController(controller, animated: true)
        //                } else {
        //                    NSLog("Nil cmnr")
        //                }
        
    }
    
    
    
}
class BeaconCell: BaseCell {
    
    //    let profileImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.contentMode = .scaleAspectFill
    //        imageView.layer.cornerRadius = 34
    //        imageView.layer.masksToBounds = true
    //        return imageView
    //    }()
    
    var beacon: Beaconx?{
        didSet {
            
            beaconName.text = beacon?.name
            
            if (beacon?.detect == false){
     
                    statusImage.image = UIImage(named: "exit")
            }else{
                statusImage.image = UIImage(named: "enter2")
            }
            
            //let url = Constant.photoURL + (resident?.photo)!
            
            let url = NSURL(string: Constant.photoURL + (beacon?.photopath)!)
            
            //print("Urlimage \(url)")
            
            let data = NSData(contentsOf: url as! URL)
            if data != nil {
                residentPhoto.image = UIImage(data:data! as Data)
            }
            //residentPhoto.image = UIImage(data: <#T##Data#>)

        }
    }
    
    let residentPhoto : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "yoo2")
        
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    let beaconName : UILabel = {
        let label = UILabel()
        label.text = "Xu Helios"
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let time : UILabel = {
        let label = UILabel()
        label.text = "00 : 00"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    

    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.16, alpha:0.5)
        // view.backgroundColor = UIColor(red:0, green:0.92, blue:0.41, alpha:0.5)
        return view
    }()
    
    let statusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "enter2")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        
        addSubview(residentPhoto)
        addSubview(dividerLineView)
        
        setupContainerView()
        
        //   statusImage.image = UIImage(named: "dol")
        
        addConstraintsWithFormat("H:|-12-[v0(69)]", views: residentPhoto)
        addConstraintsWithFormat("V:[v0(69)]", views: residentPhoto)
        
        addConstraint(NSLayoutConstraint(item: residentPhoto, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        addConstraintsWithFormat("H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
    }
    
    fileprivate func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat("H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat("V:[v0(69)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        containerView.addSubview(time)
        containerView.addSubview(beaconName)
        containerView.addSubview(statusImage)
        
        containerView.addConstraintsWithFormat("H:|[v0]", views: beaconName)
        
        containerView.addConstraintsWithFormat("V:|[v0(35)][v1(34)]|", views: beaconName, time)
        
        containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(25)]-12-|", views: time, statusImage)
        
        containerView.addConstraintsWithFormat("V:[v0(25)]|", views: statusImage)
    }
    
    
}
