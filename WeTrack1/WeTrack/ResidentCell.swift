////
////  ResidentCellCollectionViewCell.swift
////  WeTrack
////
////  Created by xuhelios on 1/18/17.
////  Copyright © 2017 beacon. All rights reserved.
////
//
//import UIKit
//
//class ResidentCell: BaseCell {
//    
//    override var isHighlighted: Bool {
//        didSet {
//            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : UIColor.white
//            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
//            timeLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
//            messageLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
//        }
//    }
//    
////    var message: Message? {
////        didSet {
////            nameLabel.text = message?.friend?.name
////            
////            if let profileImageName = message?.friend?.profileImageName {
////                profileImageView.image = UIImage(named: profileImageName);
////                hasReadImageView.image = UIImage(named: profileImageName);
////            }
////            
////            messageLabel.text = message?.text
////            
////            if let date = message?.date {
////                
////                let dateFormatter = DateFormatter()
////                dateFormatter.dateFormat = "h:mm a"
////                
////                let elapsedTimeInSeconds = Date().timeIntervalSince(date as Date)
////                
////                let secondInDays: TimeInterval = 60 * 60 * 24
////                
////                if elapsedTimeInSeconds > 7 * secondInDays {
////                    dateFormatter.dateFormat = "MM/dd/yy"
////                } else if elapsedTimeInSeconds > secondInDays {
////                    dateFormatter.dateFormat = "EEE"
////                }
////                
////                timeLabel.text = dateFormatter.string(from: date as Date)
////            }
////            
////        }
////    }
//    
//    let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 34
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    
//    let dividerLineView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
//        return view
//    }()
//    
//    let nameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Mark Zuckerberg"
//        label.font = UIFont.systemFont(ofSize: 18)
//        return label
//    }()
//    
//    let messageLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Your friend's message and something else..."
//        label.textColor = UIColor.darkGray
//        label.font = UIFont.systemFont(ofSize: 14)
//        return label
//    }()
//    
//    let timeLabel: UILabel = {
//        let label = UILabel()
//        label.text = "12:05 pm"
//        label.font = UIFont.systemFont(ofSize: 16)
//        label.textAlignment = .right
//        return label
//    }()
//    
//    let hasReadImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.cornerRadius = 10
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    
//    override func setupViews() {
//        
//        addSubview(profileImageView)
//        addSubview(dividerLineView)
//        
//        setupContainerView()
//        
//        profileImageView.image = UIImage(named: "photo")
//        hasReadImageView.image = UIImage(named: "photo")
//        
//        addConstraintsWithFormat("H:|-12-[v0(68)]", views: profileImageView)
//        addConstraintsWithFormat("V:[v0(68)]", views: profileImageView)
//        
//        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
//        
//        addConstraintsWithFormat("H:|-82-[v0]|", views: dividerLineView)
//        addConstraintsWithFormat("V:[v0(1)]|", views: dividerLineView)
//    }
//    
//    fileprivate func setupContainerView() {
////        let containerView = UIView()
////        addSubview(containerView)
////        
////        addConstraintsWithFormat("H:|-90-[v0]|", views: containerView)
////        addConstraintsWithFormat("V:[v0(50)]", views: containerView)
////        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
////        
////        containerView.addSubview(nameLabel)
////        containerView.addSubview(messageLabel)
////        containerView.addSubview(timeLabel)
////        containerView.addSubview(hasReadImageView)
////        
////        containerView.addConstraintsWithFormat("H:|[v0][v1(80)]-12-|", views: nameLabel, timeLabel)
////        
////        containerView.addConstraintsWithFormat("V:|[v0][v1(24)]|", views: nameLabel, messageLabel)
////        
////        containerView.addConstraintsWithFormat("H:|[v0]-8-[v1(20)]-12-|", views: messageLabel, hasReadImageView)
////        
////        containerView.addConstraintsWithFormat("V:|[v0(24)]", views: timeLabel)
////        
////        containerView.addConstraintsWithFormat("V:[v0(20)]|", views: hasReadImageView)
//    }
//    
//}


