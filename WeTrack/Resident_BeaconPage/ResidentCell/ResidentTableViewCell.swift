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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        img.clipsToBounds = true
        // Configure the view for the selected state
    }
    
    func setData(resident : Resident) {
        
        self.lblName.text = resident.name
        
        self.lblAdress.text = resident.address
        //let url = Constant.photoURL + (resident?.photo)!
                
        let url = URL(string: Constant.photoURL + (resident.photo))
        self.img.sd_setImage(with: url, placeholderImage: UIImage(named: "default_avatar"))
            //print("Urlimage \(url)")
    
        self.lblLastSeen.text = resident.report
        if (self.lblLastSeen.text == ""){
            self.lblLastSeen.text = "not report yet"
        }

    }
    
}
