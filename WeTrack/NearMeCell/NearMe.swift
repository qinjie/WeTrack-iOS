//
//  NearMe.swift
//  WeTrack
//
//  Created by Anh Tuan on 6/6/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import SDWebImage

class NearMe: UITableViewCell {
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblStatus : UILabel!
    @IBOutlet weak var img : UIImageView!
    var mResident: Resident?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(resident : Resident){
        mResident = resident
        self.img.sd_setImage(with: URL.init(string: resident.photo), placeholderImage: UIImage(named: "default_avatar"))
        
        self.lblName.text = resident.name
        self.lblStatus.text = "Nearby"
    }
    
}
