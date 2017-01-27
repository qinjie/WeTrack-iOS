//
//  Detail.swift
//  WeTrack
//
//  Created by xuhelios on 1/25/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

class Detail: UIViewController {

    @IBOutlet weak var residentPhoto: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var bg: UIImageView!
    
    var txt = ""
    
    var resident = Residentx()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = resident.name
        if (resident.photo == ""){
            residentPhoto.image = UIImage(named: "default_avatar")
        }else{
            let url = NSURL(string: Constant.photoURL + (resident.photo))
            
            //print("Urlimage \(url)")
            
            let data = NSData(contentsOf: url as! URL)
            if data != nil {
                residentPhoto.image = UIImage(data:data! as Data)
            }
        }
        self.view.addConstraint(NSLayoutConstraint(item: residentPhoto, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: bg, attribute: .centerY, relatedBy: .equal, toItem: residentPhoto, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        residentPhoto.layer.cornerRadius = residentPhoto.frame.size.width / 2
        residentPhoto.clipsToBounds = true
        residentPhoto.layer.borderWidth = 5.0
        bg.addSubview(residentPhoto)
        residentPhoto.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
