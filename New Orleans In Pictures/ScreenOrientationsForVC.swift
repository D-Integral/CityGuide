//
//  ScreenOrientationsForVC.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 05.08.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//
import UIKit

extension UINavigationController {
    public override func shouldAutorotate() -> Bool {
        return visibleViewController!.shouldAutorotate()
    }
}
