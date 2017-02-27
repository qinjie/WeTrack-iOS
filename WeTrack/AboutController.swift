//
//  AboutController.swift
//  WeTrack
//
//  Created by xuhelios on 2/23/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit

class AboutController: UIViewController {
        
    @IBOutlet weak var webView:UIWebView!
    
    override func viewDidLoad() {
        
        let localfilePath = Bundle.main.url(forResource: "about", withExtension: "html");
        let request = NSURLRequest(url: localfilePath!);
//        let url = NSURL(fileURLWithPath: "about.html")
//        let request = NSURLRequest(url: url as URL)
         webView.loadRequest(request as URLRequest)
    }
}


