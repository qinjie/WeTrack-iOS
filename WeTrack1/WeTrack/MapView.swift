//
//  MapView.swift
//  WeTrack
//
//  Created by xuhelios on 2/1/17.
//  Copyright © 2017 beacon. All rights reserved.
//

import UIKit
import GoogleMaps

class MapView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        GMSServices.provideAPIKey("AIzaSyBImkerv_0RJi8FVD0CtGFhdPWI1zGiBAE")
        
        let camera = GMSCameraPosition.camera(withLatitude:  1.332921, longitude: 103.777574, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        // Do any additional setup after loading the view.
        //let marker = [GMSMarker]()
        
    }

  

  

}
