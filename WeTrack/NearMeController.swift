//
//  NearMeController.swift
//  WeTrack
//
//  Created by xuhelios on 1/27/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class NearMeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var residents : [Resident]?
    
    fileprivate let cellId = "cellId"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.residents = GlobalData.nearMe
        self.collectionView!.reloadData()
        
    }

    // send information of 2 classmates you detected to server
    // if it sends successfully, you will take attendance successfully
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupData()
        self.residents = GlobalData.nearMe
        self.collectionView!.reloadData()
        
        
        //for location
        
        // for Collection View
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 90, height: 120)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        navigationItem.title = "Near Residents"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(NearCell.self, forCellWithReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self,selector: #selector(load), name: NSNotification.Name(rawValue: "updateHistory"), object: nil)
//        let mapBtn = UIBarButtonItem(title: "Map", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NearMeController.maps(sender:)))
//        mapBtn.image = UIImage(named: "map")
//        self.navigationItem.rightBarButtonItem = mapBtn
        
    }
//    func maps(sender: UIBarButtonItem) {
//        // Perform your custom actions
//        // ...
//         self.performSegue(withIdentifier: "mapSegue", sender: nil)
//       
//    }
    
    
    func load(){
        self.residents = GlobalData.nearMe
        self.collectionView!.reloadData()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = residents?.count {
            
            return count
            
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NearCell
        if let resident = residents?[indexPath.item] {
            cell.resident = resident
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
     //   self.performSegue(withIdentifier: "detailSegue", sender: nil)
        //    self.performSegue(withIdentifier: "detailSegue", sender: nil)
        //        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let controller = storyboard?.instantiateViewController(withIdentifier: "Detail") as! Detail
        //                   self.navigationController?.pushViewController(controller, animated: true)
        //                } else {
        //                    NSLog("Nil cmnr")
        //                }
        
    }
    
    
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        // retrieve selected cell & fruit
//        
//        if let indexPath = getIndexPathForSelectedCell() {
//            
//            let x = residents?[indexPath.item]
//            
//            let detailViewController = segue.destination as! Detail
//            detailViewController.resident = x!
//        }
//    }
//    
//    func getIndexPathForSelectedCell() -> IndexPath? {
//        
//        var indexPath:IndexPath?
//        
//        if (collectionView?.indexPathsForSelectedItems!.count)! > 0 {
//            indexPath = collectionView?.indexPathsForSelectedItems![0]
//        }
//        return indexPath
//    }
    
    
}
class NearCell: BaseCell {
    
    //    let profileImageView: UIImageView = {
    //        let imageView = UIImageView()
    //        imageView.contentMode = .scaleAspectFill
    //        imageView.layer.cornerRadius = 34
    //        imageView.layer.masksToBounds = true
    //        return imageView
    //    }()
    
    var resident: Resident?{
        didSet {
            
            residentName.text = resident?.name
            
            if (resident?.photo == ""){
                residentPhoto.image = UIImage(named: "default_avatar")
            }else{
                let url = NSURL(string: Constant.photoURL + (resident?.photo)!)
                
                //print("Urlimage \(url)")
                
                let data = NSData(contentsOf: url as! URL)
                if data != nil {
                    residentPhoto.image = UIImage(data:data! as Data)
                }
            }
            
            
        }
    }
    
    let residentPhoto: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "yoo2")
        
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
   
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red:0.00, green:0.36, blue:0.16, alpha:0.5)
        // view.backgroundColor = UIColor(red:0, green:0.92, blue:0.41, alpha:0.5)
        return view
    }()
    
    let residentName: UILabel = {
        let label = UILabel()
        label.text = "Xu Helios"
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let seen: UILabel = {
        let label = UILabel()
        label.text = "Is Nearby"
        label.textColor = UIColor(red:0.10, green:0.31, blue:0.17, alpha:1.0)
        //  label.backgroundColor = UIColor(red:0.51, green:0.83, blue:0.93, alpha:0.5)
        label.textColor = UIColor.darkGray
        label.font = UIFont.italicSystemFont(ofSize: 15)
        return label
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
        
        addConstraintsWithFormat("H:|-100-[v0]|", views: containerView)
        addConstraintsWithFormat("V:[v0(69)]", views: containerView)
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        
        containerView.addSubview(residentName)
        containerView.addSubview(seen)
        
        containerView.addConstraintsWithFormat("V:|[v0(35)][v1(34)]|", views: residentName, seen)
        containerView.addConstraintsWithFormat("H:|[v0]|", views: residentName)
        
        containerView.addConstraintsWithFormat("H:|[v0]|", views: seen)
      }
    
    
}
