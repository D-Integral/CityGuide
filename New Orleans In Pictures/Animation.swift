//
//  File.swift
//  New Orleans In Pictures
//
//  Created by Alexander Nuzhniy on 20.07.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

extension GalleryVC {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return fromVC == self && toVC.isKindOfClass(DetailViewController) ? TransitionFromGalleryToDetail() : nil
        
    }
}

