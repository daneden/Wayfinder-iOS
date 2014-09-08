//
//  ViewController.swift
//  Wayfinder
//
//  Created by Daniel Eden on 07/09/2014.
//  Copyright (c) 2014 Daniel Eden. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var locationmgr : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationmgr = CLLocationManager()
        locationmgr.requestWhenInUseAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

