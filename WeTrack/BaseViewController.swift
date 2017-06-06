//
//  BaseViewController.swift
//  WeTrack
//
//  Created by Anh Tuan on 6/5/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import MBProgressHUD


class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.mainApp
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func showLoadingHUD() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.backgroundColor = UIColor.clear
        hud.tintColor = UIColor.clear
        hud.shadowColor = UIColor.clear
        hud.contentColor = UIColor.mainApp
        hud.bezelView.color = UIColor.clear
        hud.bezelView.style = .solidColor
    }
    
    func hideLoadingHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
        //MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
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
