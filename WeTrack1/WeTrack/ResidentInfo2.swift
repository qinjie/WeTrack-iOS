//
//  ResidentInfo2.swift
//  WeTrack
//
//  Created by xuhelios on 1/25/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

class BeaconInfo: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    let residentPhoto : UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        imageView.image = UIImage(named: "yoo2")
        
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
        
    }()
    
    
    func setupViews() {
        
        let photoView = UIView()
        let infoView = UIView()
        
        view.addSubview(photoView)
        view.addSubview(infoView)
        view.addConstraintsWithFormat("V:|[v0(50)][v1]|", views: photoView, infoView)
        
        photoView.addSubview(residentPhoto)
        photoView.addConstraintsWithFormat("H:|-30-[v0(50)]-30-|", views: residentPhoto)
        
   
    }
    
    
            fileprivate func setupContainerView() {
        //        let containerView = UIView()
        //        addSubview(containerView)
        //
        //        addConstraintsWithFormat("H:|-90-[v0]|", views: containerView)
        //        addConstraintsWithFormat("V:[v0(50)]", views: containerView)
        //        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        //
        //        containerView.addSubview(nameLabel)
        //        containerView.addSubview(messageLabel)
        //        containerView.addSubview(timeLabel)
        //        containerView.addSubview(hasReadImageView)
        //
        //        containerView.addConstraintsWithFormat("H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
        //
        //        containerView.addConstraintsWithFormat("V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
        //
        //        containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
        //        
        //        containerView.addConstraintsWithFormat("V:|[v0(24)]", views: timeLabel)
        //        
        //        containerView.addConstraintsWithFormat("V:[v0(20)]|", views: hasReadImageView)
            }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
