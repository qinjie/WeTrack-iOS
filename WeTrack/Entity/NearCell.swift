//
//  NearCell.swift
//  WeTrack
//
//  Created by Anh Tuan on 6/8/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

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
