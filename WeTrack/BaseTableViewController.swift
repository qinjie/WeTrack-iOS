//
//  BaseTableViewController.swift
//  WeTrack
//
//  Created by Anh Tuan on 6/5/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = UIColor.mainApp
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20)]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
