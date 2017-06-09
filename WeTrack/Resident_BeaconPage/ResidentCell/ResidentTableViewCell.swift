//
//  ResidentTableViewCell.swift
//  WeTrack
//
//  Created by Anh Tuan on 6/5/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import SDWebImage

class ResidentTableViewCell: UITableViewCell {
    @IBOutlet weak var img : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblLastSeen : UILabel!
    @IBOutlet weak var lblAdress : UILabel!
    @IBOutlet weak var imgStatus : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        img.clipsToBounds = true
        // Configure the view for the selected state
    }
    
    func setData(resident : Resident, type : Int = 0) {
        
        self.lblName.text = resident.name
        if (resident.lastestLocation != nil) {
            self.lblAdress.text = resident.lastestLocation!.address
            self.lblLastSeen.text = "Last seen at " + (resident.lastestLocation!.created_at)
        }
        //let url = Constant.photoURL + (resident?.photo)!
                
        let url = URL(string: Constant.photoURL + (resident.photo))
        self.img.sd_setImage(with: url, placeholderImage: UIImage(named: "default_avatar"))
        if (type == 0){
            self.imgStatus.isHidden = true
        } else {
            self.imgStatus.isHidden = false
        }
        if (resident.status == true) {
            self.imgStatus.image = UIImage(named: "CircleRed")
        } else {
            self.imgStatus.image = UIImage(named: "CircleBlue")
        }
            //print("Urlimage \(url)")
    
    }
    
    func setDate(resident : Resident, warning : Bool = false) {
        self.lblName.text = resident.name
        if (resident.lastestLocation != nil) {
            self.lblAdress.text = resident.lastestLocation!.address
            self.lblLastSeen.text = "Last seen at " + (resident.lastestLocation!.created_at)
        }
        //let url = Constant.photoURL + (resident?.photo)!
        
        let url = URL(string: Constant.photoURL + (resident.photo))
        self.img.sd_setImage(with: url, placeholderImage: UIImage(named: "default_avatar"))
        if (warning == false){
            self.imgStatus.isHidden = true
        } else {
            self.imgStatus.image = UIImage.init(named: "warning")
        }
        
    }
}
