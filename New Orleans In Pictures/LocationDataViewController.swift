//
//  LocationDataViewController.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 08.08.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class LocationDataViewController: UIViewController {

    @IBOutlet weak var locationDataView: ViewForLocationData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clearColor()
        locationDataView.backgroundColor = .clearColor()
        locationDataView.view.backgroundColor = .clearColor()
        
        locationDataView.distanceLabel.text = "dvsvs"
        locationDataView.distanceLabel.backgroundColor = .clearColor()

    }
}
