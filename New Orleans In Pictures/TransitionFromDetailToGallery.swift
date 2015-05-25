//
//  TransitionFromDetailToGallery.swift
//  New Orleans In Pictures
//
//  Created by Александр Нужный on 25.05.15.
//  Copyright (c) 2015 D Integralas. All rights reserved.
//

import UIKit

class TransitionFromDetailToGallery: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 1
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! DetailVC
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! GalleryVC
        
        var containerView = transitionContext.containerView()
        var duration = self.transitionDuration(transitionContext)
        
        var imageSnapshot: UIView = fromViewController.imageView.snapshotViewAfterScreenUpdates(false)
        imageSnapshot.frame = containerView.convertRect(fromViewController.imageView.frame, fromView: fromViewController.imageView.superview)
        fromViewController.imageView.hidden = true
        
        
        
        
        
   
    }
}
